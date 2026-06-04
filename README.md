# GameMaker Development Skill

Codex skill for current GameMaker command-line development with YoYoGames `gm-cli`, including `.yyp` compile/run/package workflows, ResourceTool project editing, GameMaker Manual lookup, GX.Games packaging or publishing workflows, and optional shared-resource workflows through `edcasillas/gamemaker-common-utils`.

This repository is meant to be used as a standalone skill repository and can be included in project repos as a Git submodule.

## What This Skill Covers

- Installing and invoking `@gamemaker/gm-cli`.
- Choosing one-off `npx` use versus global installs.
- Compiling, running, and packaging modern GameMaker `.yyp` projects.
- Using ResourceTool for structured project inspection and targeted edits.
- Running ResourceTool MCP for AI-agent integration.
- Looking up current GameMaker Manual pages from the terminal.
- Packaging and publishing GX.Games builds when explicitly requested.
- Installing, linking, and contributing optional reusable utilities through the `gamemaker-common-utils` submodule workflow.

## Using It

The agent-facing entrypoint is:

```text
SKILL.md
```

That file contains the skill frontmatter and the workflow instructions Codex uses when the skill is triggered.

Bundled supporting material lives in:

- `references/` for captured `gm-cli` and ResourceTool command references.
- `references/common-utils.md` for the optional Common Utils toolbox catalog and submodule/symlink workflow.
- `scripts/link-common-utils-resource.sh` for replacing a local resource folder with a symlink into `vendor/gamemaker-common-utils`.
- `agents/` for UI metadata.

## Optional Common Utils Toolbox

Common Utils is optional. Use it when a GameMaker project should consume or contribute reusable modules such as Core helpers, DrawingParameters, portable Logging, EventBus, or InGameNotifications.

Repository:

```text
https://github.com/edcasillas/gamemaker-common-utils.git
```

Recommended consumer path:

```text
vendor/gamemaker-common-utils
```

The proven editable workflow is submodule plus local resource-folder symlinks. GameMaker keeps local `.yyp` resource paths, while edits made through the IDE land in the submodule. See `references/common-utils.md` before installing, migrating, linking, or adding shared resources.

## Optional Companion Skill

For legacy GM4/GM5/GMS1.4 preservation, migration reasoning, MIDI/audio conversion for web export, imported Drag and Drop cleanup, obsolete function cleanup, resource collision handling, and browser migration validation, use the optional companion skill:

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

Both skills are independent. Install only the one that matches the project work, or install both when a project needs modern GameMaker CLI work and legacy migration guidance.

## Notes For Maintainers

Keep project-specific build discoveries in the target project repo, not here, unless they generalize across GameMaker command-line workflows.

When updating the skill, keep `SKILL.md` concise and move detailed supporting material into `references/` so agents can load it only when needed.
