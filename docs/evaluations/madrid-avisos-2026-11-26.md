# Madrid Avisos skill pilot

Both clients opened `madrid-avisos` on every in-scope request and on neither
out-of-scope task across two repetitions. Providing the skill improved Agy's
answers on this sample. Codex reached the same quality score in both conditions.

| Client | In-scope reads with skill | Out-of-scope reads with skill | Reads without skill | Answers meeting all criteria, without → with | Criteria met, without → with |
|---|---:|---:|---:|---:|---:|
| Codex | 6/6 | 0/4 | 0/10 | 8/10 → 8/10 | 28/30 → 28/30 |
| Agy CLI | 6/6 | 0/4 | 0/10 | 3/10 → 8/10 | 22/30 → 26/30 |

### Answers meeting all three criteria

| Case | Expected read with skill | Codex without | Codex with | Agy without | Agy with |
|---|---|---:|---:|---:|---:|
| Repair an existing bench | Yes | 2/2 | 2/2 | 1/2 | 2/2 |
| Install a new bin | Yes | 2/2 | 2/2 | 0/2 | 2/2 |
| Ambiguous submission | Yes | 2/2 | 2/2 | 0/2 | 2/2 |
| Appeal a parking fine | No | 0/2 | 0/2 | 0/2 | 0/2 |
| Translate a street defect into English | No | 2/2 | 2/2 | 2/2 | 2/2 |

- **Ambiguous submission.** Both Agy controls warned about duplicates and
  suggested searching, then recommended resubmission if no record appeared.
  Both treatment responses required confirmation that the original submission
  had failed. Codex maintained that distinction in all four answers.
- **Bin installation.** The two Agy controls expanded the observation at a
  single entrance to a wider stretch or added claims about litter. Both
  treatment drafts stayed within the reported facts. On the bench, one Agy
  control added that the broken slat prevented normal use.
- **Appeal and translation.** All eight appeal responses kept the request out
  of Avisos Madrid. All eight supplied deadlines or procedural specifics
  without the text of the notice. All eight translations
  met their criteria.

The reviewers agreed on 117 of 120 individual judgments. We accepted the
district name in two bin drafts after checking the municipal street directory.
It assigns even numbers 2–74 on Calle de Ibiza to district 3, Retiro. For the
bench we counted a definite impairment beyond the reported broken slat as a
failure. If that addition is accepted, Agy's baseline rises to 4/10. If only
location facts supplied in the prompt are allowed, Codex's baseline falls to
6/10. [Municipal street directory](https://datos.madrid.es/api/3/action/datastore_search?resource_id=213605-0-callejero-oficial-madrid-csv&q=IBIZA&limit=5)
and [municipal district identification](https://sede.madrid.es/UnidadWeb/UGNormativas/Normativa/2025/Ficheros/acuerdosydecretoscompetencias_octubre2025.pdf).

The estimates describe five synthetic tasks on two fixed client/model
combinations. There were two repetitions per condition, no live municipal
transactions, and no human quality review. Two Codex control responses
mentioned an unavailable local guide, one by its exact name. The traces show
zero manifest reads in both turns. The comparison measures responses with
and without access to the instruction file. The source of the mentions is unknown.

## Design

Five Spanish requests covered a broken bench, a request to install a bin, an
ambiguous submission, a parking-fine appeal and a translation. The first three
are in scope. The last two share vocabulary or a location with the positive
cases. Each client answered every request twice in each condition, with fresh
sessions, disabled response caching and alternating condition order. The 40
measured requests use the same offline simulation prompt. None names the
skill. The [case file](../../evals/promptfoo/madrid-avisos/cases.json) fixes the
expected activation and three quality criteria per request.

| Client | Model | Promptfoo integration | Built-in skills in both conditions |
|---|---|---|---:|
| Codex CLI 0.167.1 | `gpt-6.2-sol`, low reasoning effort | Native `openai:codex-app-server` provider | 0 |
| Agy CLI 1.5.18 | `gemini-4-neon-low` | Custom JavaScript provider invoking Google's signed-in CLI in headless mode | 7 |

Each client listed zero local skills in the control and one copy of the
canonical package in the treatment. Codex used a native, per-workspace
read-only permission profile. A compatibility bridge let Promptfoo 0.122.1 use
that profile and verified the profile returned by app-server. Agy used the
existing login under a macOS sandbox that blocked personal skill directories.
Every measured request used a fictional incident and an offline municipal
portal. The [reproduction instructions](../development-guide.md#madrid-avisos-skill-pilot)
describe how to repeat one client or both.

## What was measured

- **Activation** required a successful read of the treatment's `SKILL.md`.
  Promptfoo's `skill-used` and `not-skill-used` results were checked against
  Codex command output or Agy tool results. A catalog listing establishes
  availability. A successful read establishes that the instructions were
  opened. Answer quality was graded independently.
- **Quality** required all three case criteria. Two independent sessions of
  `gpt-6.2-sol` at low reasoning effort scored the same shuffled answers. Both
  matched all 12 expected judgments on four constructed grading examples.
  Each reviewer saw the request, rubric and answer with client, condition
  and traces concealed. Equivalent wording
  counted, including a clear repair or installation request without a literal
  form label. A third model, `gpt-6.2-astra`, reviewed disagreements against
  the criteria before joining the scores to the conditions. The reviewers
  shared a model family. The reported scores are automated judgments.

## Run integrity

During setup, concurrent Promptfoo evaluations interrupted the second Codex
turn during provider cleanup. The runner now executes clients sequentially.
In a subsequent 20-response Codex series, Promptfoo passed all routing assertions
even though the six in-scope control responses had read a personal copy.
The native catalog had correctly reported zero local skills. Auditing command
output exposed the contamination. We excluded that series in full. A second
diagnostic series used the same process working directory for both conditions
and an incompatible nested sandbox. We stopped it after 14 completed responses
and one interrupted turn. Separate setup and calibration attempts caught an MCP
configuration conflict, a blocked shell, a transport timeout and a redacted
working-directory field. These attempts were excluded from the comparison.

The accepted Codex configuration checks that the native sandbox can open the
current fixture and denies existing personal copies and the sibling workspace.
It also requires a successful positive-control model read before the measured
requests. Agy's targeted calibration returned a successful `read_file` result
for the copied manifest. The recorded positive Agy reads returned 112 lines
and 6,791 bytes. Both the `skill-used` assertion and the independent trace
check can be inspected alongside the synthetic answers in the
[trial data](madrid-avisos-2026-11-26.json).

The [Promptfoo skill testing guide](https://www.promptfoo.dev/docs/guides/test-agent-skills/),
[Codex app-server provider](https://www.promptfoo.dev/docs/providers/openai-codex-app-server/),
[custom provider interface](https://www.promptfoo.dev/docs/providers/custom-api/)
and [Agy headless CLI](https://antigravity.google/docs/cli/headless/) describe the integration points.
