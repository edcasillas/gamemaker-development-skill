# gm-cli Reference

This reference summarizes the official YoYoGames `gm-cli` README and live `--help` output captured on 2026-06-03. Verify with `--help` before relying on exact flags because `gm-cli` is actively developed.

Official sources:

- Repository: `https://github.com/YoYoGames/gm-cli`
- Package: `@gamemaker/gm-cli`
- Captured version: `@gamemaker/gm-cli` 2.1.0

## Requirements

`gm-cli` requires Node.js with `npm` and `npx`. Package metadata for 2.1.0 declares Node `>=24`.

Check local versions:

```sh
node --version
npm --version
```

## Invocation

Preferred one-off usage:

```sh
npx @gamemaker/gm-cli@latest --help
```

Global install for repeated use:

```sh
npm install -g @gamemaker/gm-cli@latest
gm-cli --help
```

Get command-specific help:

```sh
npx @gamemaker/gm-cli@latest compile --help
gm-cli resourcetool --help
gm-cli manual --help
gm-cli gxgames --help
gm-cli cache --help
```

Top-level commands in 2.1.0:

- `init`
- `run`
- `compile`
- `package`
- `manual read|open`
- `resourcetool mcp|eval|repl|script`
- `login`
- `gxgames link|upload|meta|publish`
- `cache info|clean`

## New Projects

Create a new project from a blank game or template:

```sh
npx @gamemaker/gm-cli@latest init
```

The official README says `init` can also help set up GitHub automation pipelines and AI-agent integration such as `AGENTS.md`, MCP, and Claude config.

## Compile, Run, Package

Run these from a folder containing a `.yyp` file:

```sh
npx @gamemaker/gm-cli@latest run
npx @gamemaker/gm-cli@latest compile
npx @gamemaker/gm-cli@latest package
```

Use `--help` to choose `target`, `runtime`, and `toolchain` values. Official example:

```sh
npx @gamemaker/gm-cli@latest compile --runtime=vm --target=operagx --toolchain=gms2@2024.14.3.260
```

The README says `gm-cli` can automatically download the runtime and other tools needed to compile and run projects. Treat this as a network/install action.

Observed during a GameMaker 2026 `operagx` VM compile: `--errors-only` can hide the actionable asset compiler failure and show only a final non-zero status. Rerun with `--verbose` when the first output does not identify the failing resource or compiler phase.

Observed with `npx @gamemaker/gm-cli@latest`: a command can still attempt registry/network access even after earlier successful invocations. If the command is required and fails with DNS/registry errors, rerun with approved network access instead of switching to a weaker workflow.

Shared `run`, `compile`, and `package` flags captured in 2.1.0:

- `[project]`: optional path to the project `.yyp`.
- `--target`: platform target such as `windows`, `mac`, `linux`, `operagx`, etc.
- `--toolchain`: toolchain, for example `GMS2`, `GMS2@2024.14.4`, or `GMRT@0.18`.
- `--runtime`: `vm` or `native`; default is `vm`.
- `--verbose` / `--no-verbose`.
- `--errors-only` / `--no-errors-only`.
- `--license`: license `.plist`; can also use env `GAMEMAKER_CLI_LICENSE`.
- `--cache-dir`: cache directory.
- `--config`: project config, default `Default`.
- `--toolchain-options`: JSON string of toolchain-specific options.

`package` also supports `-o` / `--output` for the output file path.

## ResourceTool

ResourceTool edits GameMaker project files without opening the IDE.

In `gm-cli` 2.1.0, ResourceTool is delegated to a platform-specific package from GameMaker's package registry:

```text
@gm-tools/resource-tool-<platform>@latest
```

On macOS arm64, this was observed as:

```text
@gm-tools/resource-tool-osx-arm64@latest
```

Read `resource-tool.md` for the captured ResourceTool 2024.14.15 command catalog.

Read-only list example:

```sh
gm-cli resourcetool eval "resource list"
```

Interactive session:

```sh
gm-cli resourcetool repl
```

AI-agent MCP server:

```sh
gm-cli resourcetool mcp
```

Captured `resourcetool` subcommands and shared flags:

- `mcp [project]`: run as Model Context Protocol server.
- `eval <command> [project]`: evaluate one ResourceTool command.
- `repl [project]`: interactive REPL.
- `script <file> [project]`: run a script file.
- `--config`: GameMaker project config to use, default `Default`.
- `--cache-dir`: cache directory.

MCP mode requires a `.yyp` project path. `gm-cli` throws `You need to specify a .yyp file to use the ResourceTool in MCP mode` when no project is found.

Use ResourceTool for structured project inspection and targeted edits. Prefer a read-only command first, then make small edits that can be reviewed in git.

ResourceTool commands may print `Saving...Success` even for read-oriented operations. Check `git status` after each ResourceTool pass before assuming no files changed.

For modern sound relinks:

```sh
npx @gamemaker/gm-cli@latest resourcetool eval "SOUND SETFILE NAME=so_music PATH=/absolute/path/to/so_music.mp3" Project.yyp
```

Observed behavior in ResourceTool 2024.14.15: this copies the audio file into `sounds/<name>/` and changes the sound resource's `soundFile` value to the copied filename. It does not necessarily delete the old linked audio file from the resource folder.

## Sign-In

The official README says `gm-cli` automatically gives a guest license, so sign-in is not required for basic use. If the user wants to use their own access key:

```sh
npx @gamemaker/gm-cli@latest login <access-key>
```

Captured `login` flags:

- `<access-key>`: required access key argument.
- `--print`: print the license to stdout instead of saving to a file.
- `--cache-dir`: cache directory.

Access keys are credentials. Do not ask the user to paste one into chat unless they explicitly choose that path; prefer local secret handling.

## Manual Search

Search/open the GameMaker Manual:

```sh
gm-cli manual open "sprites" --language=es
```

Read a manual article in the terminal:

```sh
gm-cli manual read "data structures"
```

Use `read` when the agent needs terminal-visible evidence. Use `open` for user-facing browser reading.

Captured `manual read` and `manual open` flags:

- `<query>`: required search query.
- `--language`: one of `en`, `ru`, `br`, `it`, `fr`, `pl`, `es`, `ko`, `de`, `ja`, `zh`.

## GX.Games Publishing

Only use these commands when the user explicitly asks to publish or prepare a GX.Games publish flow.

Package as OperaGX zip:

```sh
npx @gamemaker/gm-cli@latest package --target=operagx --output=game.zip
```

Link the project:

```sh
npx @gamemaker/gm-cli@latest gxgames link --studioid=<id> --gameid=<id>
```

Upload:

```sh
npx @gamemaker/gm-cli@latest gxgames upload --file=game.zip --version=1.0.0.0
```

Set metadata:

```sh
npx @gamemaker/gm-cli@latest gxgames meta \
  --title="My Game" \
  --description="A short description" \
  --age-rating=EVERYONE \
  --platforms=DESKTOP,MOBILE \
  --cover=cover_1920x1080.png \
  --graphic=screenshot_1920x1080.png
```

Publish:

```sh
npx @gamemaker/gm-cli@latest gxgames publish
```

The README notes that title, description, age rating, platforms, 16:9 cover, and 16:9 screenshot are required metadata; cover and graphic must be exact 16:9 aspect ratio such as 1920x1080.

Captured GX.Games command details:

- `gxgames link [project] --studioid=<id> --gameid=<id>` links a `.yyp` to a studio/game; flags are optional for interactive selection.
- `gxgames upload [project] --file=<zip> --version=<X.Y.Z.B>` uploads an OperaGX zip; `--file` is required and `--version` is optional.
- `gxgames meta [project]` accepts `--title`, `--age-rating`, `--description`, `--platforms`, `--cover`, and `--graphic`.
- Age rating values: `NOT_SET`, `EVERYONE`, `CHILDREN`, `EARLY_TEENS`, `TEENS`, `ADULTS`, `MATURE`.
- `gxgames publish [project]` requires uploaded bundle plus metadata and opens the published page on success.

## Cache

Captured cache commands:

```sh
gm-cli cache info
gm-cli cache clean
```

Flags:

- `--project`: path to the project `.yyp`.
- `--cache-dir`: cache directory.

Use `cache info` for diagnostics before cleaning. Treat `cache clean` as a destructive local-tooling operation that can force future redownloads.

## Current Limitations / Future Features

The official README lists more targets, a TypeScript library API, and editor integration as planned future features. Treat those as roadmap items, not stable capabilities, until `--help` or current official docs confirm them.
