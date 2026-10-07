# Portal observations and sources

Checked on 2026-10-02. Reinspect live labels and requirements on each use.
This reference documents UI behavior, not an unofficial API contract.

## Live browser observations

A read-only exploration opened the creation form, selected AVISO, resolved the
public example address Plaza de Cibeles, 1, and chose Desperfecto en acera.
No description, attachments, credentials, or report were submitted.

- Cookie banner: **Solo usar cookies necesarias**. A Madrid Móvil promotional
  dialog may then need **CERRAR**.
- **ENTRAR** links to a municipal authentication flow on `servpub.madrid.es`.
  Follow the current portal link rather than hardcoding an authentication URL.
- The new-report icon opens **¿Cómo podemos ayudarte?**, with **AVISO** and
  **PETICIÓN**. The latter requests a new street element.
- **Buscar dirección** has its own search button. After search, the example
  normalized to **Plaza Cibeles, 1** and the remaining fields appeared. Confirm
  the marker as well as the address; location processing is asynchronous.
- Photo area advertised `jpg, png, gif`. The additional-file area advertised
  `pdf, doc, docx, xls, xlsx, ppt, pptx, jpg, bmp, gif, xml, txt`. Follow current
  accepted types and size limits; a size limit was not established in this visit.
- **Categoría** is a grouped list. Verified examples include **Farola sin luz**,
  **Desperfecto en acera**, **Limpieza de calles**, **Vaciado de papelera**, and
  **Vehículo abandonado**. Use live choices, not a fixed full taxonomy.
- **Escribe la descripción** warns that other citizens can see the information.
  The inspected field exposed no maximum length; do not impose an invented
  character limit. Supply a meaningful description even when HTML does not
  mark it required.
- **Reporte público** was initially disabled and unchecked before category
  selection; after selecting Desperfecto en acera it became enabled and checked.
  Verify its final state. Never infer visibility from the initial form.
- **FINALIZAR** became enabled with an empty description in this exploration.
  Treat it as the submission boundary, not as a completeness check.

## Official guidance

- [Avisos sobre la ciudad](https://www.madrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Contacto/Avisos-sobre-la-ciudad/?vgnextchannel=8e464b7e8d740910VgnVCM2000001f4a900aRCRD&vgnextfmt=default)
  describes municipal incidents and requests, possible category-dependent
  contact requirements, and a maximum of **10 reports per person per day**.
- [Official user guide, 27 June 2024](https://www.madrid.es/UnidadWeb/Contenidos/ContactarAvisos/guiaavisosjun24.pdf),
  pp. 20–25: registration is necessary to submit; authentication can discard an
  unfinished form. Location, category, and description are expected; photos and
  supporting files are optional. Some categories request additional data.
  Reports default to public. Pp. 29–32 describe searching by address, report ID,
  description, and filters. Prefer current UI behavior when labels differ.

Authenticated submission, receipts, file upload, CAPTCHA behavior, and every
category-specific branch remain untested. Never test them by filing a fictitious
report in production. Use a real user-authorized report for end-to-end validation.
