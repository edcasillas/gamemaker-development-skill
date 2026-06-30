---
name: gamemaker-development
description: "Use when the agent needs to develop GameMaker games or tooling: inspect and edit .yyp projects, reason about GameMaker resources and GML, validate behavior, compile/run/package/publish builds, debug HTML5/runtime issues, automate project maintenance, or share reusable resources. Uses tools such as gm-cli, ResourceTool, GameMaker Manual lookup, and optional gamemaker-common-utils workflows."
---

# GameMaker Development

Use this skill for practical GameMaker game development. It should help an
agent understand project structure, resource ownership, GML code, editor/runtime
constraints, build workflows, and reusable utility patterns.

This skill must remain generic and reusable for any GameMaker project. Do not
encode game-specific rules, project names, characters, rooms, lore, or repo-only
conventions into this skill. If a lesson is useful only for one repository, put
it in that repository's docs or agent guidance instead.

## Core Engineering Principles

Use these as default decision rules unless the user explicitly asks for a
different tradeoff:

- `KISS`: solve the problem with the simplest design that is correct and
  maintainable.
- `DRY` with `Rule of Three`: avoid careless duplication, but do not extract
  unstable abstractions prematurely. Consolidate once repetition is clearly
  real or an existing shared helper already covers it.
- `SRP` and `SoC`: keep each object, script, helper, and document focused on a
  clear responsibility in the correct ownership lane.
- `Fail Fast`: surface broken assumptions, missing registrations, invalid
  wiring, and incomplete migrations immediately instead of relying on quiet
  fallbacks.
- `Composition Over Inheritance`: prefer small composable behaviors, helpers,
  and effects over deep inheritance or hardcoded combination types.
- After making a local DRY cleanup, do a second pass over nearby call sites for
  repeated policy or state-reset steps. Do not stop at extracting one repeated
  line if the subsystem still requires the same semantic preparation in
  multiple places.

When producing durable documentation, keep it complete but concise. Prefer a
short `Quickstart`, dependency/API tables when they improve scanability, and
diagrams wherever they add real explanatory value.
Do not pad module documentation with repeated boilerplate sections when a root
owner document already explains the shared workflow; keep repeated guidance in
the owner doc and leave module pages for module-specific rules.
Document long-lived behavior and ownership, not just the immediate task that
caused the edit. In JSDoc and technical docs, explain what the code actually
does, what state it changes, what events it emits, and what responsibility it
owns. Avoid comments that are only meaningful if the reader already knows the
ticket or implementation plan that introduced the code.
Do not write task-scoped phrasing such as "this refactor", "for this task", or
"this fix" in durable code comments or module documentation unless the text is
explicitly about temporary migration work. Prefer wording that remains correct
after the immediate implementation context has been forgotten.
If a minor gameplay or UI behavior seems to require a large standalone
technical document just to be understandable, treat that as a design smell in
the implementation first. Prefer simplifying the runtime shape and keeping the
explanation inside the existing owner doc when the behavior is small.
Do not use project-specific examples, asset names, or lore in shared-toolbox
documentation or comments when editing reusable modules such as Common Utils.
Keep shared docs consumer-agnostic unless the file explicitly documents a
consumer integration.
Keep TODOs that represent active future work, known limitations, or intended
follow-up. Do not preserve historical comments that only narrate past
structure, previous names, or the fact that a refactor moved code from one
place to another.
When simplifying or deduplicating existing code, preserve useful comments
unless they are wrong or become unnecessary after the change. Do not silently
discard author comments while cleaning up structure.
Prefer local names that describe the concrete thing being counted or placed.
Avoid ambiguous names like `_row_count` when the value actually means tile
count, sprite count, or horizontal repeats.

Use this skill when the task involves building, debugging, refactoring,
documenting, validating, automating, packaging, publishing, or extending a
GameMaker project.

`gm-cli`, ResourceTool, GameMaker Manual lookup, and Common Utils are tools this
skill may use. They are not the scope of the skill by themselves.

## Optional Companion Skill

For legacy GM4/GM5/GMS1.4 preservation, migration reasoning, MIDI/audio conversion for web export, imported Drag and Drop cleanup, obsolete function cleanup, resource collision handling, and browser migration validation, use the optional companion skill `gamemaker-migration-assistant`.

Companion repository:

```text
https://github.com/edcasillas/gamemaker-migration-skill
```

Install it as a direct checkout:

```sh
git clone https://github.com/edcasillas/gamemaker-migration-skill.git .agents/skills/gamemaker-migration-assistant
```

Or install it as a Git submodule:

```sh
git submodule add https://github.com/edcasillas/gamemaker-migration-skill.git .agents/skills/gamemaker-migration-assistant
```

The companion skill is optional. If it is not installed, continue using this
skill for current GameMaker project work, including `.yyp` inspection, GML/resource
edits, validation, automation, package, and publish workflows.

## Optional Common Utils Toolbox

For shared reusable GameMaker code, use `edcasillas/gamemaker-common-utils` as an optional toolbox. It is intended for reusable modules such as portable logging, event bus, drawing helpers, in-game notifications, input/UI helpers, timed actions, room transitions, defensive external-service facades, and HTML5 browser helpers.

Toolbox repository:

```text
https://github.com/edcasillas/gamemaker-common-utils.git
```

Recommended consumer path:

```text
vendor/gamemaker-common-utils
```

Read `references/common-utils.md` when the task mentions Common Utils, shared utils, reusable GameMaker scripts, submodule-based utilities, EventBus, portable logging, reusable UI, in-game notifications, or contributing a utility back to the shared toolbox.

This toolbox is optional. Continue using this skill for normal GameMaker
development even when Common Utils is not installed.

## First Steps

1. Identify the active GameMaker project file:
   - Modern GameMaker projects usually use `.yyp`.
   - Legacy GMS1.4 projects usually use `.project.gmx`; `gm-cli` may not apply directly unless the project has been migrated to a supported `.yyp` workflow.
2. Inspect the project shape before changing resources:
   - Read the `.yyp` and relevant resource folders.
   - Prefer existing object, script, room, sprite, option, extension, and datafile patterns.
   - Check whether GameMaker IDE validation is required; command-line checks cannot prove every editor/runtime behavior.
3. Choose the right tool for the task:
   - Edit source files directly for narrow GML/docs changes when resource metadata does not need to change.
   - Use ResourceTool for structured `.yyp` and resource edits when it is safer than manual JSON edits.
   - Use `gm-cli` for compile/run/package/manual workflows.
   - Use Common Utils only when the project should consume or contribute reusable shared utilities.
   - For GameMaker script assets, prefer one public function per script and
     group related scripts in the correct folder lane so entry points stay easy
     to find from the Asset Browser and from code search.
   - Before adding a new shared helper or refactoring toward Common Utils, search
     the project for an existing local helper that already solves the problem.
     Prefer migrating that implementation over rewriting it from scratch.
   - Before editing a shared utility resource, confirm the active resource path.
     A project may expose both a vendor checkout and a mirrored or symlinked
     project resource. Do not assume the vendor file you found is the runtime
     file the project actually consumes.
   - When adding a new shared resource from a toolbox such as Common Utils,
     treat it as a 3-part integration:
     1. the real shared resource in the toolbox repo
     2. the local project exposure path that GameMaker resolves, often a
        symlinked folder in `scripts/`, `objects/`, or `extensions/`
     3. the project registration in the consumer `.yyp`
   - Do not treat that integration as complete until all three pieces exist.
     A resource can be perfectly valid on disk and still be invisible to
     GameMaker if the local exposure path or `.yyp` registration is missing.
   - Treat macro/event declaration scripts exactly like any other GameMaker
     resource. A script that only contains `#macro` constants still needs its
     `.gml`, `.yy`, local exposure path, and consumer `.yyp` entry.
   - Distinguish broken shared-resource wiring from stale IDE symbol indexing.
     When you add a new macro/event script, verify the `.gml`, `.yy`, local
     exposure path, and consumer `.yyp` entry. When you change an existing
     shared macro/event script, also verify that GameMaker resolves the new
     symbols after a project refresh; the disk wiring can be correct while the
     IDE still shows stale undefined symbols.
   - When extracting existing behavior into Common Utils, preserve timing,
     presentation, text, side-effect order, initialization order, and platform
     injection points. Treat any behavior change as a separate request.
   - Treat duplicated hosts, fallback paths, and parallel ownership lanes as
     suspicious until verified. If code appears to support two draw hosts, two
     controllers, or two fallback flows, confirm from rooms, entrypoints, and
     active runtime wiring whether both are really used before documenting or
     preserving that complexity.
   - When documenting ownership debt or extraction candidates, distinguish
     confirmed ownership from unresolved candidates. Do not write guesses as if
     they were settled repo rules; mark decisions that still need owner
     confirmation.
   - Do not add wrapper helpers that only forward to another function unless
     they already represent a real policy or reusable ownership boundary. If a
     helper is just `return other_func()` with no actual abstraction value, it
     is usually unjustified indirection.
   - If callers repeatedly need to remember the same setup or teardown step
     before invoking a helper, treat that as an ownership smell. Prefer a
     semantic entry point that owns the repeated policy instead of scattering
     hidden prerequisites across call sites.
   - For transient presentation beats such as labels, notifications, and room
     transition overlays, prefer short-lived instances that exist only while
     the beat is active over permanent manager state that polls every frame.
   - When a presentation system needs multiple combinations of the same visual
     primitives, prefer composable effects such as fade and tremble over
     multiplying object types by combination.
   - When a shared runtime system already knows exactly when a lifecycle moment
     completes, have it dispatch the Event Bus message directly. Avoid
     intermediate callbacks or wrapper events that only forward the same signal
     from one owner to another.
   - Do not replace a simple existing helper with a more configurable shared
     abstraction unless the extra complexity is clearly required.
   - After changing a shared utility feature, verify that every required piece
     of the fix landed together in the active resource path: helper/state,
     runtime behavior, UI/draw/input path, and any mirrored resource copies the
     project still uses. Do not close the task on a half-landed patch.
   - Minimum verification for a newly added shared resource:
     - confirm the local project path with `ls -ld` or `readlink`
     - confirm the resource entry in the consumer `.yyp`
     - confirm consumer code references the exact asset name
     - run `git diff --check`
     - if the change depends on a new asset existing in the editor, require
       IDE confirmation that it appears in the Asset Browser before calling the
       work complete
   - When debugging uncovers a concrete broken shared-resource integration, do
     not stop at explaining the cause. Complete the registration/symlink/asset
     fix in the same pass unless the user explicitly asked for diagnosis only.
4. Check local tool availability before installing:
   - `node --version`
   - `npm --version`
   - `npx @gamemaker/gm-cli@latest --help`
5. Prefer `npx @gamemaker/gm-cli@latest ...` for one-off or exploratory use so the command uses the latest published package without changing global tools.
6. Use a global install only when repeated local use is expected:
   - `npm install -g @gamemaker/gm-cli@latest`
   - `gm-cli --help`
7. If a command would download runtimes/toolchains, install packages, open a browser, sign in, or publish/upload builds, ask for user approval when sandbox or project safety requires it.

If a required local tool is missing, do not silently switch to a weaker workflow. State the missing tool, ask whether it can be installed, and use a manual or limited fallback only if the user declines the install, the install fails, or the tool is unavailable for the current machine.

Read `references/gm-cli.md` before running non-trivial `gm-cli` commands or documenting exact syntax.
Read `references/resource-tool.md` before using `gm-cli resourcetool`, ResourceTool scripts, or ResourceTool MCP.
Read `references/html5-console-triage.md` before diagnosing browser console noise from a GameMaker HTML5 runner or exported HTML build.
Read `references/common-utils.md` before installing, linking, migrating, or contributing shared GameMaker resources through `edcasillas/gamemaker-common-utils`.
Read `references/gameanalytics.md` before installing or upgrading the GameAnalytics GameMaker SDK, creating a local defensive facade, configuring credentials, or wiring Common Utils Logging telemetry.
Read `references/globalstats.md` before installing, upgrading, or integrating a GlobalStats.io GameMaker client, including its controller, asynchronous events, GTD schema, credentials, and optional Common Utils Logging/EventBus wiring.
Use the Common Utils release CLI when a consumer should export through
`gm-cli`, serve an HTML export on localhost/LAN, generate a build version, or
publish an explicitly tested artifact through Butler. Keep export and deploy as
separate user actions.
When a project already uses a shared utility family such as Common Utils,
prefer fixing cross-module integration at the shared-owner layer before adding
consumer-side workarounds. Keep that guidance generic and reusable rather than
encoding repository-specific exceptions into the skill.
When a shared utility change appears not to work in runtime, immediately check
whether the edit landed in the active resource path, whether the project keeps
mirrored copies of the same resource, and whether only part of the intended
change was applied.
When documenting an implemented system, record the real runtime hook and host,
not only the helper name. If a draw helper runs from a HUD object, GUI manager,
or object event every frame with an early return, say so explicitly instead of
forcing readers to reverse-engineer the call path from source.
Before creating a new standalone technical document, verify that the subject
really has enough stable complexity and independent ownership to justify it. If
the explanation fits naturally inside an existing owner doc, prefer the owner
doc. Do not leave behind orphaned detail docs that duplicate a shorter
canonical explanation elsewhere.

## Startup Bootstrap Guidance

- Prefer a single startup bootstrap script over multiple competing
  initialization entrypoints unless a concrete requirement demands otherwise.
- When a project uses top-level script statements for bootstrap and also uses
  `gml_pragma("global", ...)`, verify the actual ordering before depending on
  it.
- If the manual confirms a behavior, document it as official.
- If the project relies on behavior you verified experimentally but could not
  confirm in the manual, document it explicitly as empirically verified
  project behavior, not as a guaranteed engine contract.
- When a project has verified that loose top-level bootstrap code runs earlier
  than pragma-global hooks, prefer the loose bootstrap script for the primary
  initialization path because it is simpler and earlier.

## Tool Selection

Use `gm-cli` for:

- Creating new GameMaker projects from a blank project or template.
- Compiling, running, and packaging projects from a folder with a `.yyp`.
- Programmatically editing project resources with `resourcetool`.
- Running ResourceTool as MCP when an AI agent needs structured project editing.
- Searching or reading GameMaker Manual pages from the terminal.
- Packaging and publishing to GX.Games when explicitly requested.

Do not use `gm-cli` as a substitute for legacy-source preservation work. For historical Game Maker artifacts, preserve originals and use the active migrated project unless the user explicitly asks otherwise.

Use direct file edits for:

- Focused GML changes in existing scripts or object events.
- Documentation and project workflow updates.
- Small resource-file corrections where the GameMaker metadata impact is clear.

Use GameMaker IDE validation when:

- Resource tree behavior, object events, room layout, options, extensions, or imported assets may be affected.
- A change depends on how the editor serializes or resolves resources.
- The user reports behavior that only appears inside the IDE or runtime runner.

## Safe Workflow

1. Start with read-only discovery:
   - `npx @gamemaker/gm-cli@latest --help`
   - `npx @gamemaker/gm-cli@latest <command> --help`
   - `gm-cli resourcetool eval "resource list"` when inside a supported project.
2. Confirm the target project, runtime, target platform, and output path before build or package commands.
3. Keep generated output outside source folders unless the project already has a build-output convention.
4. Prefer explicit flags in documented workflows so another agent can reproduce the run.
5. Record meaningful build, packaging, ResourceTool, or publish decisions in the project dev log when they affect the repo workflow.
6. If `--errors-only` hides the actual failure, rerun with `--verbose`. Asset compiler failures can report only a final non-zero exit in errors-only mode while the actionable cause appears earlier in verbose output.
7. Treat `npx @gamemaker/gm-cli@latest` as network-sensitive even when it has worked earlier in the session. If it fails with DNS or registry errors and the command is needed, rerun with approved network access.

## ResourceTool Guidance

Use ResourceTool when the task involves project introspection or structured resource edits without opening the IDE.

Start read-only:

```sh
gm-cli resourcetool eval "resource list"
```

For interactive exploration, use:

```sh
gm-cli resourcetool repl
```

For AI-agent integration, consider:

```sh
gm-cli resourcetool mcp
```

The captured ResourceTool command catalog is in `references/resource-tool.md`. It includes resource, object event, room/layer/tile, script, sprite, sound, tileset, prefab, shader, note, and path operations.

Before mutating resources, inspect the project state, understand the intended resource identity, and keep changes narrow. ResourceTool edits can be powerful; avoid broad automated rewrites unless the user asked for them and the project has been backed up or version-controlled.

ResourceTool may print `Saving...Success` even for read-oriented commands. Always check `git status` after ResourceTool commands and separate semantic changes from no-op autosaves.

For sound relinks in modern `.yyp` projects, use:

```sh
gm-cli resourcetool eval "SOUND SETFILE NAME=so_music PATH=/absolute/path/to/so_music.mp3" Project.yyp
```

Observed ResourceTool behavior: `SOUND SETFILE` copies the selected audio file into the sound resource folder and updates the sound resource's `soundFile` field. It does not necessarily delete the previously linked source file, so inspect the folder afterward before deciding whether any old audio file should be removed.

## Manual Lookup

Use `gm-cli manual` when current GameMaker API behavior or syntax matters.

Examples:

```sh
gm-cli manual read "data structures"
gm-cli manual open "sprites" --language=es
```

Prefer terminal `read` for agent-visible evidence. Use `open` only when the user wants a browser page or an interactive manual page.

## GameMaker Project Hygiene

- Respect existing project conventions for output folders, targets, and runtime versions.
- Add concise JSDoc to every new or modified function. State what it does,
  document relevant parameters, and include its return value when applicable.
- JSDoc should describe stable behavior, outputs, side effects, and ownership.
  Do not make the comment depend on the current task framing when a future
  maintainer really needs to understand the function's concrete runtime effect.
- The same rule applies to inline comments: keep forward-looking TODOs and
  present-tense intent comments; remove backward-looking "this used to be..."
  archaeology unless the historical fact is itself required for correctness.
- Do not commit generated packages or downloaded runtimes unless the repository explicitly tracks them.
- Treat login/access keys and GX.Games publish state as user-controlled credentials and external state.
- When a command fails, capture the exact command, working directory, tool version, and error output before changing project files.
- If a fix depends on current GameMaker behavior, verify with `gm-cli manual` or official docs rather than relying on memory.

## HTML5 Console Triage

- Distinguish IDE runner URLs such as `http://localhost:<port>/` from exported
  build folders such as `Builds/html`; they may not load the same injected
  files.
- For Chrome console 404s from a generated runner file such as `html5game/*.js`,
  check whether GML called `file_exists()` on a missing included file or
  browser-stored save file. On HTML5, that can produce a visible `HEAD` request
  before the normal fallback path runs.
- Preserve release build-number behavior when suppressing dev-runner noise:
  generated release builds may include a build-number file, `GMCU_IS_DEV_BUILD` is an
  explicit config/macro signal, and a GameMaker IDE run is not automatically a
  DevBuild.
