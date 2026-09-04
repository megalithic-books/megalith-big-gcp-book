# Errata

Corrections to the printed text. Nothing is listed here until it has been confirmed against the
current Google Cloud surface — a report is not yet an erratum.

**Reporting.** Open an issue with the **page number** and the **printing** you are reading
(the `book-version` file records which printing this repository matches). A section number helps,
but the page number is what identifies the printing.

## Format

Each entry records where the error is, what the text says, what it should say, and — where it is
not obvious — why. Entries are grouped by the printing that introduced them.

```
### §N.N — <short description>            page NNN, found in 1.0.0, fixed in 1.0.1
**Reads:**   <the printed text>
**Should read:** <the correction>
**Why:** <only when the correction is not self-explanatory>
```

## 1.0.0 — first printing

*No confirmed errata yet.*

## Not errata

Some things that look like errors are deliberate, and are recorded here so the same report is not
filed twice.

- **`roles/owner` and `roles/editor` never appear as identifiers.** The basic roles are written in
  prose as Owner, Editor, Viewer, and Browser throughout. This is a house rule, not an omission:
  the build fails on the literal strings, so that no example can be copied into an estate and grant
  one by accident. §33.4 shows how to *detect* them without writing them.
- **The book prints no CIS control numbers.** No control number could be confirmed against a
  specific benchmark version at the time of writing, so §30.9 describes the benchmark's structure
  instead. A fabricated control number in a compliance mapping is worse than none.
- **No price, quota, or region list is printed as a number** unless it is architecturally
  load-bearing, in which case it carries the date it was observed. Those pages change faster than a
  book can.
- **Organization policy constraints appear with the `constraints/` prefix in prose and bare as a
  `gcloud` positional.** Both forms are correct and Google's own examples use them that way.
