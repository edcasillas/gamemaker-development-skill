---
name: gamemaker-development
description: "Use when Codex needs to develop GameMaker games or tooling: inspect and edit .yyp projects, reason about GameMaker resources and GML, validate behavior, compile/run/package/publish builds, debug HTML5/runtime issues, automate project maintenance, or share reusable resources. Uses tools such as gm-cli, ResourceTool, GameMaker Manual lookup, and optional gamemaker-common-utils workflows."
---

# GameMaker Development

Use this skill for practical GameMaker game development. It should help an
agent understand project structure, resource ownership, GML code, editor/runtime
constraints, build workflows, and reusable utility patterns.

This skill is standalone. It can complement migration-specific skills, but it does not require them.

This skill must remain generic and reusable for any GameMaker project. Do not
encode game-specific rules, project names, characters, rooms, lore, or repo-only
conventions into this skill. If a lesson is useful only for one repository, put
it in that repository's docs or agent guidance instead.

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
   - When extracting existing behavior into Common Utils, preserve timing,
     presentation, text, side-effect order, initialization order, and platform
     injection points. Treat any behavior change as a separate request.
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
