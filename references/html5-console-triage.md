# HTML5 Console Triage

Use this reference when a GameMaker HTML5 run shows Chrome console errors.

## Identify the Served Build

- `http://localhost:<port>/` is usually the GameMaker IDE runner.
- `Builds/html` is an existing exported build and may not match the current IDE
  runner output.
- Confirm the active URL and inspect the served HTML before assuming generated
  build output matches the current run.

## `file_exists()` 404s

On HTML5, GameMaker can implement `file_exists()` as:

1. Check browser-backed storage such as `localStorage`.
2. If no stored value exists, issue a synchronous `HEAD` request for
   `html5game/<filename>`.
3. Return false and let GML fallback code continue when the request returns 404.

This can make expected missing files look like console errors. Before fixing
game logic, identify which GML call requested the file and whether the fallback
path is correct.

Typical examples:

- build-number files generated only during package/deploy flows
- first-run settings files saved later through `ds_map_secure_save`
- optional included files with GML fallback defaults

For build labels, do not assume an IDE HTML5 run means `IS_DEV_BUILD` is true.
`IS_DEV_BUILD` is tied to the selected GameMaker config/macro state. A project
may need a separate local-run signal if it wants three labels such as:

- release candidate: value read from `buildnumber.txt`
- explicit DevBuild config: `GM_version + "-dev"`
- local IDE runner: `GM_version + "-local"`

When documenting or replicating this pattern in another project, make the dev
signal explicit:

```gml
#macro IS_DEV_BUILD false
#macro DevBuild:IS_DEV_BUILD true
```

Then document how to select the `DevBuild` configuration in the IDE before
running, compiling, or packaging. Keep service credentials, god mode, crash
handlers, and build labels behind deliberate config-specific macros rather than
behind the fact that a runner URL is local.

## Recommended Fix Shape

- Prefer bypassing `file_exists()` in known dev-only HTML5 paths when the
  fallback value is already intended.
- Do not add placeholder included files if that risks stale version or settings
  data.
- For settings, validate save/load persistence across browser reloads before
  replacing desktop-safe file logic with HTML5-specific storage logic.
