---
name: deploy-with-vercel
description: >-
  Link this repository to a Vercel project and deploy it using the Vercel MCP
  tools.
disable-model-invocation: true
---
# Deploy with Vercel

Link the current repository to a Vercel project and deploy it, using the Vercel MCP tools.

1. Confirm the Vercel MCP connection first. If the Vercel MCP is not connected or needs authentication, surface the sign-in so the user can authenticate, and continue once connected. If the user signed in but did not grant enough Vercel permissions to see the right team(s) — for example `get_git_deployment_context` or the project-listing tools omit a team you need, or Vercel returns a permissions/forbidden error for that team — and the `cursor-cloud-set-publish-button-visibility` tool is available, call it with `visible: true` and `reconnect: true` so Cursor shows "Reconnect to Vercel" instead of Publish. Clicking that pill starts the same Vercel MCP reauth flow as Publish's MCP auth, so the user can grant the missing team access. Once they have reconnected (or you can see the right team(s)), call the tool again with `visible: true` and omit `reconnect` (or pass `reconnect: false`) to restore the Publish label.
2. Call the Vercel MCP's `get_git_deployment_context` tool (fall back to the project-listing tools if it is unavailable). It reports, per Vercel team: the plan, the projects with their git links, and the Origin namespaces the team is connected to (`originConnections`). If a team already has a project linked to this repository (a `cursor-origin` link matching this repo), skip to deployment on that project.
3. Otherwise create or link the Vercel project for this repository with the Vercel MCP's `create_git_project` tool: set `provider` to `cursor-origin`; default the project name to the repo name. Choose the team deliberately, in this order: (a) use the team named by the user, if any; (b) otherwise prefer a team whose `originConnections` include this repository's Origin namespace — that is where the connection already exists; (c) otherwise prefer the team with the best plan (enterprise over pro over hobby) — hobby teams may not be able to serve this deployment. If no team is connected to the namespace and several are equally plausible, ask the user rather than guessing.
4. Trigger a deployment of the repository's default branch to the linked project. `create_git_project` already does this when it creates the project. Subsequent deploys are triggered by commits to the default branch. Calling the tool again will not trigger a new deploy.
5. Report back the project name and scope, the deployment URL, and its status. If `create_git_project` (or another required Vercel tool) is not available on the connected Vercel MCP, say exactly which capability is missing and stop — never fake a deployment or invent a URL.

Never print tokens or secrets. If there's uncommitted work that would affect the deploy, ask before deploying.

## Handling Vercel tool errors

When a Vercel MCP tool returns an error, relay the actual error message to the user and explain what it means. Never restate an error as a product policy or invent a constraint the tool did not report. For errors not listed here, quote the error and say only what the tool reported.

- `create_git_project` returns a 409 conflict ("Project ... already exists"): the project already exists on that team — this is not a deploy restriction. If that project is already linked to this repository, the link is in place; subsequent deploys are triggered by commits to the default branch, and calling the tool again will not trigger a new deploy. If the name collides with a project not linked to this repository, the tool does not reconnect it — say so and ask the user for a different project name or team.
- `create_git_project` returns a 400 with error code `cursor_origin_error` ("Failed to link ... You do not have access to ... on Origin. (status: 403)"): the Vercel app is not installed on that repository / its Origin namespace. Ask the user to install it (or add this repository to their install) at https://cursor.com/codebase/apps/install?client_id=app_01kyje5yvdedb8z7zkpnq5b49c&source=app-metadata&namespace=<owner>&repository=<repo> — substitute `<owner>` and `<repo>` from the repository named in the error, so the page offers adding exactly that repository — then retry. Do not ask them to reconnect the Vercel MCP — this is not an MCP auth problem.
- A 404 looking up the project right after `create_git_project` succeeded (e.g. `get_project` or `get_git_deployment_context` does not show it): the project and its deployment exist — the current Vercel connection likely cannot see them because the user granted access to specific projects rather than all projects when authenticating the Vercel MCP. Tell the user their project was created, and offer to reconnect (the step 1 `reconnect: true` flow) so they can grant access and see it.
- "Not authorized: Trying to access resource under scope ..." (or any message asking to re-authenticate): the Vercel connection is signed in under a different scope or team than the request targeted. Tell the user which scope the error names and offer to reconnect (the step 1 `reconnect: true` flow) or pick a team the current sign-in can access.
- A create/link/deploy failure that names the Hobby plan or plan limits: Vercel Hobby teams can't be used to publish from a Cursor team — Cursor team users can link Origin repositories only on a plan higher than Hobby. Relay the error, then either use one of the user's higher-plan Vercel teams (from `get_git_deployment_context`), offer to reconnect (the step 1 `reconnect: true` flow) so they can pick a higher-plan team, or offer a plan upgrade via `get_purchase_quote` + `buy_pro` (quote first; requires the user's explicit approval). Do not speculate beyond what the error says.
- No usable team: `create_git_project` requires an explicit team. If `get_git_deployment_context` reports no teams the user can deploy to, say so and ask the user which Vercel team to use.
- A 401/403 when fetching the deployment URL: the deployment is likely protected by Vercel Authentication, not broken. Verify with `get_access_to_vercel_url` or `web_fetch_vercel_url` and tell the user the deployment is protected rather than reporting a failure.
- The Vercel MCP disconnects or asks for authentication mid-flow: return to step 1 and surface the sign-in; do not report this as a failed deployment.

## Presenting the deployment result

After the deployment is triggered, do not stop at "deployment started":

1. As soon as the deployment is triggered, present the kickoff just as clearly and prominently as the final result, using what is known pre-completion: the project name and scope, the deployment URL as a clickable link, and the current status (e.g. queued or building).
2. Deployments take a while to build, so prefer watching asynchronously: launch an async subagent (or an equivalent background task) that polls the deployment's status via the Vercel MCP tools until it reaches a terminal state (ready, failed, or canceled). Continue any remaining work while it runs, and tell the user when the deployment is done.
3. When the deployment finishes, present the result clearly and prominently:
   - The deployment URL as a clickable link.
   - The final status (e.g. ready or failed).
   - Appropriate next steps — e.g. open the URL to see the live site, or for a failed deployment summarize the build error and offer to fix it and redeploy.
4. If the deployment finished successfully (ready) and the `cursor-cloud-set-publish-button-visibility` tool is available, call it with `visible: false` and a reason like "published successfully" so Cursor stops offering the Publish button for this conversation. Never do this for a failed, partial, or skipped deployment. Do not leave `reconnect: true` set after a successful deploy.
5. If you cannot watch the deployment to completion, say so explicitly and give the user the deployment URL and last known status so they can check on it themselves.
