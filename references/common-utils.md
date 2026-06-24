# GameMaker Common Utils Toolbox

Use this reference when a project should consume or contribute to
`edcasillas/gamemaker-common-utils`.

## Repository

- GitHub: `https://github.com/edcasillas/gamemaker-common-utils.git`
- Recommended consumer path: `vendor/gamemaker-common-utils`
- Library project container: `gamemaker-common-utils.yyp`
- Module docs: `vendor/gamemaker-common-utils/docs/modules/`

## Core Rule

GameMaker's Import Existing workflow copies resources into the consumer
project. It does not keep a live link to the source repo. For editable shared
code:

1. Keep the consumer `.yyp` resource paths local, such as
   `scripts/gmcu_event_bus/event_bus.yy`.
2. Replace each local resource folder with a symlink to the matching folder in
   `vendor/gamemaker-common-utils`.
3. Let GameMaker edit the local path; the filesystem redirects writes into the
   submodule.

Do not rewrite `.yyp` resource paths to `vendor/...` as the final mechanism.
GameMaker may ignore or revert those edits when it saves from its internal
project state.

## Install Or Update

Install:

```sh
git submodule add https://github.com/edcasillas/gamemaker-common-utils.git vendor/gamemaker-common-utils
git submodule update --init --recursive
```

Update:

```sh
git -C vendor/gamemaker-common-utils pull origin main
git add vendor/gamemaker-common-utils
git commit -m "Update common utils submodule"
```

If GameMaker reports `Could not find a project for the resource file`, ensure
the source repository includes `gamemaker-common-utils.yyp` as an ancestor of
the `.yy` resource.

## Naming Policy

All Common Utils public resources and APIs use `gmcu_` as the first token in
the name. Macros, enums, and constants use `GMCU_`. For objects, put the
prefix before `o`, such as `gmcu_o_input_hub`. Do not add unprefixed aliases.

## Module Documentation Standard

Keep the repository README as a concise module index. Each module entry should
link to its page under `docs/modules/` instead of duplicating complete resource
lists, API details, or consumer instructions.

Write each module page for a human reader who needs to use or contribute to the
module:

1. Start with a brief description.
2. Put practical usage instructions immediately after the description.
3. Describe the purpose of every listed resource, public event, enum, object,
   method, global, and other API surface. Do not publish unexplained name-only
   lists.
4. List direct dependencies with a brief explanation of why the current module
   uses each one.
5. Show dependencies of dependencies as a nested tree. Descriptions are
   optional for these transitive entries.
6. Link every mention of another documented Common Utils module or concept to
   its existing documentation, including mentions outside the dependency
   section.
7. Keep consumer usage separate from contribution and editable-submodule
   instructions.
8. Add concise JSDoc to every new or modified function associated with the
   documented module.
9. When a repository maintains an ordered documentation set, end each document
   with a consistent `Previous | Back | Next` footer. The `Back` link must
   return to the set's main documentation index.

Apply this standard to the module currently being changed. Do not broaden a
focused documentation request into a rewrite of every module unless the user
explicitly asks for that sweep.

## Current Modules

Import or register modules in this dependency order:

1. `Core`
2. `Drawing`
3. `Logging`
4. `Networking`
5. `EventBus`
6. `InGameNotifications`
7. `InputHub`
8. `Localization`
9. `LayeredGUI`
10. `UniversalCursor`
11. `Buttons`
12. `Labels`
13. `TimedActions`
14. `Transitions`
15. `HTML5 Helpers`
16. `Release and Build Info`
17. `Dev Menu`

### Core

Resource folder:

- `scripts/gmcu_core`

Provides `GMCU_OBJECT_NAME`, `GMCU_ROOM_NAME`, `GMCU_DELTA_TIME_SECONDS`, `GMCU_LAYER_DEPTH_MIN`,
`GMCU_LAYER_DEPTH_MAX`, `GMCU_IS_DEV_BUILD`, and
`gmcu_set_notification_handler`.

### Drawing

Resource folder:

- `scripts/gmcu_drawing_parameters`

Provides `new gmcu_DrawingParameters()` and `gmcu_DrawingParameters.apply()`.

### Logging

Resource folders:

- `scripts/gmcu_log_config`
- `scripts/gmcu_log_get_tags`
- `scripts/gmcu_log_debug`
- `scripts/gmcu_log_info`
- `scripts/gmcu_log_warn`
- `scripts/gmcu_log_error`
- `scripts/gmcu_log_exception`

Provides `gmcu_log_debug`, `gmcu_log_info`, `gmcu_log_warn`, `gmcu_log_error`, `gmcu_log_exception`,
`gmcu_log_get_tags`, and `gmcu_log_set_telemetry_handler`. Logging uses
`show_debug_message` and intentionally does not depend on GameAnalytics,
GlobalStats.io, HTML5 Helpers, or project-specific services.

Consumers that historically forwarded logs to analytics must register a
telemetry handler and preserve severity mapping plus `gmcu_log_debug(..., true)`
local-only behavior. Do not remove observable telemetry merely to keep the
shared module portable.

### Networking

Resource folder:

- `scripts/gmcu_HttpResponseData`

Provides `new gmcu_HttpResponseData(_async_load)`, a reusable wrapper around
GameMaker's Async HTTP callback DS map.

### EventBus

Resource folder:

- `scripts/gmcu_event_bus`

Provides:

- `gmcu_eventbus_subscribe(_event_name)`
- `gmcu_eventbus_unsubscribe(_event_name)`
- `gmcu_eventbus_dispatch(_event_name, _event_args = undefined)`

Observers define:

```gml
on_event = function(_event_name, _event_args) {
}
```

### InGameNotifications

Resource folders:

- `scripts/gmcu_in_game_notification_settings`
- `scripts/gmcu_show_notification`
- `objects/gmcu_o_notification_from_top`

Provides `gmcu_InGameNotificationSettings` and `gmcu_show_notification`. It registers a
notification handler for Logging so dev-build `gmcu_log_error` and `gmcu_log_exception`
calls can show visual notifications.

### InputHub

Resource folders:

- `scripts/gmcu_input_hub_events`
- `scripts/gmcu_gamepad_buttons_mapping`
- `objects/gmcu_o_input_hub`

Provides:

- `GMCU_EVENT_GAMEPAD_BUTTON_PRESSED`
- `GMCU_EVENT_GAMEPAD_BUTTON_RELEASED`
- `GMCU_DIRECTION_ANGLE`
- `gmcu_o_input_hub.gmcu_get_direction()`
- `gmcu_o_input_hub.gmcu_get_four_way_direction()`
- `gmcu_o_input_hub.gmcu_has_connected_gamepad()`
- `gmcu_o_input_hub.gmcu_gamepad_button_pressed(_button)`
- `gmcu_o_input_hub.gmcu_gamepad_button_released(_button)`

Place one `gmcu_o_input_hub` instance in the first room that should initialize
input. The object is persistent and deletes duplicate instances.

### Localization

Resource folders:

- `scripts/gmcu_localization_init`
- `scripts/gmcu_localization_macros`
- `scripts/gmcu_localization_t`

Provides:

- `GMCU_LOCALIZATION_IS_INITIALIZED`
- `gmcu_localization_init(_lang_code = undefined, _csv_file_name = undefined)`
- `gmcu_localization_t(_str)`

Uses `global.gmcu_language` and `global.gmcu_loc_map`. Translation CSV file
names and content stay in the consuming project.

### LayeredGUI

Resource folders:

- `objects/gmcu_o_layered_gui_manager`
- `scripts/gmcu_layered_gui_subscribe`
- `scripts/gmcu_layered_gui_unsubscribe`

Provides:

- `gmcu_o_layered_gui_manager`
- `gmcu_layered_gui_subscribe(_priority)`
- `gmcu_layered_gui_unsubscribe()`

Subscribers define:

```gml
function on_draw_gui() {
}
```

`LayeredGUI` depends on `Core`, `Drawing`, and `Logging`.

### UniversalCursor

Resource folders:

- `objects/gmcu_o_universal_cursor`
- `scripts/gmcu_universal_cursor_show`
- `scripts/gmcu_universal_cursor_hide`
- `scripts/gmcu_universal_cursor_subscribe`
- `scripts/gmcu_universal_cursor_unsubscribe`

Provides:

- `gmcu_o_universal_cursor`
- `gmcu_universal_cursor_show(_sprite_index)`
- `gmcu_universal_cursor_hide(_restore_system_cursor = true)`
- `gmcu_universal_cursor_subscribe()`
- `gmcu_universal_cursor_unsubscribe()`

`UniversalCursor` depends on `Core`, `Drawing`, `Logging`, `LayeredGUI`, and
`InputHub`. Cursor sprites remain consumer-owned.

### Buttons

Resource folders:

- `scripts/gmcu_button_events`
- `objects/gmcu_o_base_button`
- `objects/gmcu_o_base_button_game`
- `objects/gmcu_o_base_button_gui`

Provides:

- `GMCU_EVENT_BUTTON_PRESSED`
- `gmcu_o_base_button`
- `gmcu_o_base_button_game`
- `gmcu_o_base_button_gui`

Buttons depend on `Core`, `Drawing`, `Logging`, `EventBus`, `Localization`,
`LayeredGUI`, and `UniversalCursor`. Sprites, fonts, sounds, and button IDs
remain consumer-owned.

### Labels

Resource folders:

- `scripts/gmcu_draw_text_outlined`
- `objects/gmcu_o_base_label`
- `objects/gmcu_o_label_game`
- `objects/gmcu_o_label_gui`

Provides:

- `gmcu_draw_text_outlined(...)`
- `gmcu_o_base_label`
- `gmcu_o_label_game`
- `gmcu_o_label_gui`

Labels depend on `Core`, `Drawing`, `Localization`, and `LayeredGUI`. Localized
labels draw `actual_text`, not the untranslated source key.

### TimedActions

Resource folders:

- `objects/gmcu_o_timed_actions_manager`
- `scripts/gmcu_wait_for_seconds`
- `scripts/gmcu_wait_for_steps`

Provides:

- `gmcu_wait_for_seconds(_seconds, _action)`
- `gmcu_wait_for_steps(_steps, _action)`

The manager is created lazily, persists across rooms, rejects duplicate
instances, and reports callback exceptions through shared Logging.

### Transitions

Resource folders:

- `scripts/gmcu_transition_events`
- `scripts/gmcu_transition_types`
- `scripts/gmcu_transition_to_room`
- `objects/gmcu_o_transition_to_room`
- `objects/gmcu_o_transition_fadeout_to_room`
- `objects/gmcu_o_transition_hcurtain_close_to_room`
- `objects/gmcu_o_transition_hcurtain_open`

Provides:

- `GMCU_TRANSITION_TO_ROOM_TYPE`
- `GMCU_EVENT_TRANSITION_FINISHED`
- `gmcu_transition_to_room(_target_room, _transition_type, _seconds, _options)`

`Transitions` depends on `Core`, `Drawing`, `Logging`, and `EventBus`.
Consumers pass optional `on_progress` and `on_transition_ended` callbacks for
audio fades, stopping music, analytics, or other project-specific side effects.
Do not move those policies into the shared module.

### Provider Telemetry

Common Utils does not own provider SDK integrations such as GameAnalytics.
Logging remains provider-independent and exposes
`gmcu_log_set_telemetry_handler(_handler)` for consumer wiring.

Keep each provider extension, compatibility facade, credentials, consent
policy, build identifiers, severity mapping, sessions, and event taxonomy in
the consuming project. For GameAnalytics installation and wiring, read
`gameanalytics.md`.

### Provider Clients

Common Utils does not own provider clients such as GlobalStats.io. Keep their
controller, HTTP scripts, credentials, identifiers, asynchronous events,
persistence, payload schemas, and compatibility policy in the consumer.

Provider clients may use Common Utils Logging and EventBus as ordinary
dependencies without becoming Common Utils modules. For GlobalStats.io setup
and integration guidance, read `globalstats.md`.

### HTML5 Helpers

Resource folder:

- `extensions/gmcu_html5_helpers`

Provides:

- `gmcu_html5_is_mobile_device()`
- `gmcu_html5_block_canvas(_message)`
- `gmcu_html5_console_error(_message)`

The module includes `datafiles/disable-mobile.js` and injects it through HTML5
`PostBody` to preserve Fantasma's early mobile warning, original text, and
presentation. Consumers that do not want this fixed policy should omit the
included file/module. Guard GML helper calls that may run on native targets
with `os_browser != browser_not_a_browser`. A fresh GameMaker HTML5 export is
required before browser validation; `Builds/html` does not update when GML or
extension source changes.

### Release and Build Info

Tool:

- `tools/release/gmcu_release.py`

GameMaker resource folders:

- `scripts/gmcu_build_info`
- `objects/gmcu_o_build_info_label`

The CLI provides `export`, `serve-html`, `stop-html`, `status`, `version`, and
`deploy`. The normal consumer config contains only itch username/project and an
ordered platform list. Common Utils infers the `.yyp`, conventional
`Builds/<platform>` paths, matching channel names, stable IDs, version-file
locations, state filename, and HTML server defaults. Advanced consumers may
override conventions when necessary.

Export and deployment are separate by design. `export` uses `gm-cli package`
by default and never invokes Butler. gm-cli 2.1.0 does not yet support the
HTML5 target, so consumers may configure an explicit per-platform
`export_command`; otherwise export HTML from GameMaker and run `serve-html`.
HTML exports may pass `--serve` when their configured export command succeeds.
The managed background server prints localhost and LAN URLs. `serve-html` can
start or reuse it without re-exporting, and `stop-html` stops only the process
recorded for that consumer.

`deploy` requires confirmation that the exact export was tested, or
`--yes-tested` for intentional non-interactive use. It reads channel versions
through `butler status`, falls back to the consumer's versioned state, updates
`options.ini` and `buildnumber.txt`, then invokes `butler push`.

Initialize runtime build information before analytics and menu creation:

```gml
gmcu_build_info_init({
    author: "Studio Name",
    copyright_start_year: 2024
});
global.build_number = gmcu_build_info_get_version();
```

The fallback without `buildnumber.txt` is `GM_version + "-dev"`.

### Dev Menu

Resource folders:

- `scripts/gmcu_dev_menu`
- `objects/gmcu_o_dev_menu`

Provides `gmcu_dev_menu_init(_config)`, which creates or reconfigures the
DevBuild-only persistent singleton automatically. Standard adapters provide
room navigation, language selection, and a viewer for the structured Logging
ring buffer. Consumer projects own pause policy, room filtering, labels,
language providers, and optional visual theming.

The default menu is modal: it deactivates other instances while open, keeps
in-game notifications active, and reactivates the game on close. Menu callback
exceptions must be caught and routed through Logging so a debug action cannot
terminate the game.

Standard diagnostic pages should remain optional integrations:

- Resolve optional manager objects by asset name instead of introducing hard
  compile-time dependencies from Dev Menu to every inspected module.
- Capture module state immediately before modal deactivation.
  `instance_exists()` ignores deactivated instances, so a page generated after
  opening the menu can incorrectly report valid subscribers as missing.
- Store copied diagnostic rows in explicit item fields rather than deferred
  closures, and reuse the standard copyable text interaction when practical.
- Include object name and runtime instance id. When several instances share an
  object, let the subscription API accept an optional stable diagnostic label
  such as a button id. GameMaker does not expose the Room Editor instance name
  from a runtime instance id.

For HTML5, avoid deferred anonymous functions that depend on captured local
variables. Store callback arguments and providers explicitly in item/page
structs, and test every dynamic submenu and action in the HTML5 runner. VM
compilation can succeed even when an HTML5 callback becomes `undefined`.

Room navigation remains consumer-aware. If a target room requires a persistent
controller or progression state, the consumer callback must initialize it
before `room_goto`; rooms intended for direct IDE execution should bootstrap
the same dependencies themselves.

## Migrating An Existing Resource

Before editing, define the observable behavior that must remain unchanged.
Extraction is an ownership change, not permission to redesign. Preserve:

- execution and initialization timing
- visual presentation and user-facing text
- side-effect and callback order
- platform injection points and extension behavior
- consumer-owned policy

If portability requires a behavior change, stop and treat it as a separate,
explicitly approved change. Validate the original regression path, not only
that the project compiles.

1. Close GameMaker.
2. Confirm both repos are clean:

```sh
git status --short
git -C vendor/gamemaker-common-utils status --short
```

3. Confirm the resource exists in the submodule.
4. Link the local folder:

```sh
tools/link-common-utils-resource.sh scripts/gmcu_event_bus
```

If the project does not include that helper, use the skill copy:

```sh
.agents/skills/gamemaker-development/scripts/link-common-utils-resource.sh scripts/gmcu_event_bus
```

5. Verify the link:

```sh
ls -ld scripts/gmcu_event_bus
sed -n '1,10p' scripts/gmcu_event_bus/event_bus.gml
```

6. Stage the replacement:

```sh
git add -A scripts/gmcu_event_bus
git diff --cached --summary
```

Expected output includes `create mode 120000 scripts/gmcu_event_bus` and deletions
for the old local files.

7. Open GameMaker and verify the resource opens through the local path.
8. If testing a small IDE edit, confirm it lands in the submodule:

```sh
git -C vendor/gamemaker-common-utils status --short
```

9. Revert test edits unless intentional, then commit the symlink replacement.

## Creating New Shared Resources

1. Create the resource in a scratch GameMaker project or in
   `gamemaker-common-utils.yyp`.
2. Commit the new resource folder in `edcasillas/gamemaker-common-utils`.
3. Update the submodule pointer in the consumer project.
4. Register the resource in the consumer `.yyp` at the local path GameMaker
   expects.
5. Replace that local folder with a symlink to the vendor folder.
6. Validate in GameMaker IDE.

## Validation Commands

```sh
git diff --check
git status --short
git -C vendor/gamemaker-common-utils status --short
find scripts objects -maxdepth 2 -type l -ls
```

Command-line checks do not replace GameMaker IDE validation.

## Roadmap

The Fantasma extraction roadmap is complete through Dev Menu.
Keep credentials, release configuration and state, GTD identifiers,
localization content, mobile-browser policy, consumer messages, generated
builds, and project-specific behavior in the consuming project.
`.yymps` packaging remains deferred because copied imports do not preserve
editable submodule links.
