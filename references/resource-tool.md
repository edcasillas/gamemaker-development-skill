# ResourceTool Reference

Captured from `@gm-tools/resource-tool-osx-arm64@latest` on 2026-06-03.

- Captured ResourceTool version: `ResourceTool@2024.14.15`
- Invoked via `gm-cli` 2.1.0 as `gm-cli resourcetool ...`
- Platform package observed on macOS arm64: `@gm-tools/resource-tool-osx-arm64@latest`
- Registry observed in `gm-cli` source: `https://gmpm.gamemaker.io`

Use this as an offline command catalog so an agent can know what ResourceTool can do before installing or downloading it. Still verify with `HELP`, `HELPTABLE`, or command-specific `HELP <COMMAND> <SUBCOMMAND>` when exact syntax matters.

## MCP Mode

Terminology note: ResourceTool "resources" are GameMaker project resources such as sprites, objects, rooms, sounds, and scripts. MCP "resources" are a separate protocol concept returned by `resources/list`. This probe confirmed the ResourceTool command surface, but did not successfully list MCP protocol resources.

ResourceTool exposes:

```text
MCP
  LOGFILE = <Path to LOG file> (Optional)
  TOOLLESS = <Whether we run in tool-less mode> (Optional, default = FALSE)
```

`gm-cli resourcetool mcp` accepts:

```text
[project]      Path to the project .yyp file
--config       GameMaker project config to use (default: Default)
--cache-dir    Cache directory
```

Observed behavior:

- `gm-cli resourcetool mcp` requires a `.yyp` project. Without one, `gm-cli` throws: `You need to specify a .yyp file to use the ResourceTool in MCP mode`.
- A temporary `.yyp` created with `ResourceTool PROJECT CREATE` on macOS arm64 crashed ResourceTool 2024.14.15 on reload with `System.AccessViolationException`, so MCP tool/resource schemas were not successfully listed in this environment.
- Treat the command catalog below as the confirmed ResourceTool operation surface. Treat exact MCP JSON schemas as requiring validation against a real compatible `.yyp` and an MCP client.

## Global Commands

- `CLI`: command-line interface.
- `MCP`: MCP interface.
- `EXIT`: exit CLI or stop processing script.
- `VERSION`: display ResourceTool version.
- `STATUS`: check current project status.
- `SCRIPT PATH=<file>`: process a scripted list of commands.
- `CHECK PROJECTPATH=<path>`: verify a project can load.
- `HELP [COMMAND=<command>]`: display help.
- `HELPTABLE`: display command summary.
- `DEFAULTS GET`: show default argument value.
- `DEFAULTS SET`: set default argument value.

Global arguments available on all commands:

- `PREFABSFOLDER`
- `PROJECTTOOL`
- `PACKAGETOOL`
- `GMPM_DLL`
- `PROJECTPATH`
- `FILEWATCHER` (default `10000` ms)

## Resource Commands

- `RESOURCE LIST [TYPE=<types>]`: list resources, optionally filtering by type.
- `RESOURCE TYPES`: list all resource types.
- `RESOURCE INFO EXPR=<expr> [KEYS] [LIST]`: show resource objects and properties.
- `RESOURCE SET EXPR=<expr> VALUE=<value>`: set a resource property by expression.
- `RESOURCE CREATE TYPE=<type> [NAME=<name>] [PARENT=<name>]`: create and add a resource.
- `RESOURCE DELETE NAME=<name> [TYPE=<type>] [PARENT=<name>] [PARENTTYPE=<type>]`: delete a resource.

Expression examples from help:

- `spr_ufo`
- `spr_ufo.layers`
- `spr_ufo.layers[0]`
- `spr_ufo.bbox_left`
- `obj_ship.visible`
- `inst_1A5B7D9E.scaleX`
- `room_welcome`

## Project Commands

- `PROJECT CREATE NAME=<name> [PATH=<dir>] [SAVE=<true|false>]`: create a new project.
- `PROJECT RENAME NAME=<new-name>`: rename the project.

## Object Event Commands

- `OBJECT EVENT FINDORCREATE NAME=<object> TYPE=<event-type> [SUBTYPE=<subtype>] [COLLISIONOBJECT=<object>]`
- `OBJECT EVENT DELETE NAME=<object> TYPE=<event-type> [SUBTYPE=<subtype>] [COLLISIONOBJECT=<object>]`
- `OBJECT EVENT CHANGE NAME=<object> TYPE=<event-type> [SUBTYPE=<subtype>] [COLLISIONOBJECT=<object>] NEWTYPE=<event-type> [NEWSUBTYPE=<subtype>] [NEWCOLLISIONOBJECT=<object>]`
- `OBJECT EVENT LIST NAME=<object> [TYPE=<event-type>]`
- `OBJECT EVENT TYPES`
- `OBJECT EVENT SETGMLFILE NAME=<object> TYPE=<event-type> [SUBTYPE=<subtype>] [COLLISIONOBJECT=<object>] [PATH=<existing-event-script>]`

## Room Commands

- `ROOM LIST`: list all room names.

Room instances:

- `ROOM INSTANCE CREATE ROOM=<room> OBJECT=<object> [NAME=<instance>] [LAYER=<layer>] [X=<x>] [Y=<y>]`

Room assets:

- `ROOM ASSET CREATE ROOM=<room> [SPRITE=<sprite>] [SEQUENCE=<sequence>] [PARTICLESYSTEM=<particle-system>] [FONT=<font>] [NAME=<asset>] [LAYER=<layer>] [X=<x>] [Y=<y>]`

Room items:

- `ROOM ITEM LIST [ROOM=<room>] [LAYER=<layer>] [LAYERTYPE=<type>] [ITEM=<item>] [ITEMTYPE=<type>] [ALL]`
- `ROOM ITEM DELETE ROOM=<room> ITEM=<instance-or-asset>`

Room layers:

- `ROOM LAYER CREATE ROOM=<room> NAME=<layer> [TYPE=<layer-type>] [PARENT=<parent-layer>] [DEPTH=<depth>]`
- `ROOM LAYER DELETE ROOM=<room> LAYER=<layer>`
- `ROOM LAYER LIST ROOM=<room> [LAYERTYPE=<type>]`

Layer types:

- `INSTANCE`
- `ASSET`
- `BACKGROUND`
- `PATH`
- `TILE`
- `EFFECTS`

Depth examples:

- `FRONT`
- `BACK`
- `INDEX n`

## Tile Layer Commands

- `ROOM LAYER TILES GET ROOM=<room> [LAYER=<layer>] [LEFT=<x>] [TOP=<y>] [WIDTH=<tiles>] [HEIGHT=<tiles>] [OUTFILE=<csv>]`
- `ROOM LAYER TILES SET ROOM=<room> LAYER=<layer> [LEFT=<x>] [TOP=<y>] [WIDTH=<tiles>] [HEIGHT=<tiles>] [DATA=<csv-values>] [FILE=<csv-file>] [REPEATX=<n>] [REPEATY=<n>] [TRANSPARENT=<tile-index>]`
- `ROOM LAYER TILES LIST [ROOM=<room>]`
- `ROOM LAYER TILES RESIZE ROOM=<room> LAYER=<layer> [WIDTH=<tiles>] [HEIGHT=<tiles>] [PADLEFT=<n>] [TRIMLEFT=<n>] [PADRIGHT=<n>] [TRIMRIGHT=<n>] [PADTOP=<n>] [TRIMTOP=<n>] [PADBOTTOM=<n>] [TRIMBOTTOM=<n>]`
- `ROOM LAYER TILES INFO`: show tile-layer bit field information.

## GML / Script Commands

- `GML SETGMLFILE NAME=<script> PATH=<existing-gml-file>`: set a script file.

## Sprite Commands

- `SPRITE ADDFRAME NAME=<sprite> PATH=<png-frame> [FRAME=<FIRST|LAST|INDEX n>]`
- `SPRITE DELETEFRAME NAME=<sprite> INDEX=<frame-index>`

## Sound Commands

- `SOUND SETFILE NAME=<sound> PATH=<wav-ogg-or-mp3>`

Observed with ResourceTool 2024.14.15 in a modern `.yyp`: `SOUND SETFILE` copies the selected audio file into the target sound resource folder and updates the resource's `soundFile` metadata. It does not necessarily delete the previous linked file from that folder. After relinking, inspect the folder and `git status` before deciding whether stale audio files should be removed.

## Tileset Commands

- `TILESET CREATE [NAME=<tileset>] [PARENT=<parent>] [SPRITE=<sprite>] [TILEWIDTH=<px>] [TILEHEIGHT=<px>] [TILEXOFFSET=<px>] [TILEYOFFSET=<px>] [TILEHSEP=<px>] [TILEVSEP=<px>] [TILEHBORDER=<px>] [TILEVBORDER=<px>]`
- `TILESET DELETE NAME=<tileset>`
- `TILESET RENAME NAME=<tileset> NEWNAME=<new-name>`
- `TILESET SETSPRITE NAME=<tileset> SPRITE=<sprite>`

## Prefab Commands

- `PREFAB LIST [DOWNLOADED] [REFERENCED] [FORCED]`
- `PREFAB INFO COLLECTIONS=<collection-list>`
- `PREFAB ADDREFERENCE COLLECTIONS=<collection-list>`
- `PREFAB REMOVEREFERENCE COLLECTIONS=<collection-list>`
- `PREFAB CUSTOMISE COLLECTION=<collection> PREFAB=<prefab> [NAME=<new-name>]`

Collection lists are comma-separated package IDs with or without version. Latest is used if no version is specified.

## Shader Commands

- `SHADER SETFILEPATH NAME=<shader> PATH=<existing-shader-file> TYPE=<VERTEX|FRAGMENT>`

## Note Commands

- `NOTE SETFILEPATH NAME=<note> PATH=<existing-notes-text-file>`

## Path Commands

- `PATH ADDPOINT NAME=<path> POINTS=<points> [INDEX=<index>]`
- `PATH INFO NAME=<path>`
- `PATH DELETEPOINT NAME=<path> [INDEX=<index>] [COUNT=<n>]`

Point formats:

- `(x,y)`
- `(x,y,speed)`
- comma-separated list of tuples

## Syntax Notes

- Arguments can be supplied in any order.
- Argument names are case-insensitive.
- Quote values that contain spaces.
- Flag arguments are bare words with no value.

Examples:

```text
RESOURCE LIST TYPE=sprites
RESOURCE INFO EXPR=spr_player.layers LIST
OBJECT EVENT LIST NAME=obj_player
ROOM ITEM LIST ROOM=room_welcome ALL
ROOM LAYER TILES GET ROOM=room_welcome LAYER=Tiles OUTFILE=/tmp/tiles.csv
GML SETGMLFILE NAME=sc_player_move PATH=/tmp/sc_player_move.gml
```
