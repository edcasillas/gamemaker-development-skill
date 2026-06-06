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
   `scripts/event_bus/event_bus.yy`.
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

New shared public resources and APIs use `gmcu_` as the first token in the
name. For objects, put the prefix before `o`, such as `gmcu_o_input_hub`.

## Current Modules

Import or register modules in this dependency order:

1. `Core`
2. `Drawing`
3. `Logging`
4. `EventBus`
5. `InGameNotifications`
6. `InputHub`
7. `Localization`
8. `LayeredGUI`
9. `UniversalCursor`
10. `Buttons`
11. `Labels`
12. `TimedActions`
13. `Transitions`
14. `GameAnalytics`
15. `GlobalStats.io`
16. `HTML5 Helpers`
17. `Release and Build Info`
18. `Dev Menu`

### Core

Resource folder:

- `scripts/common_macros`

Provides `OBJECT_NAME`, `ROOM_NAME`, `DELTA_TIME_SECONDS`, `LAYER_DEPTH_MIN`,
`LAYER_DEPTH_MAX`, `IS_DEV_BUILD`, and
`common_utils_set_notification_handler`.

### Drawing

Resource folder:

- `scripts/DrawingParameters`

Provides `new DrawingParameters()` and `DrawingParameters.apply()`.

### Logging

Resource folders:

- `scripts/log_config`
- `scripts/get_log_tags`
- `scripts/log_debug`
- `scripts/log_info`
- `scripts/log_warn`
- `scripts/log_error`
- `scripts/log_exception`

Provides `log_debug`, `log_info`, `log_warn`, `log_error`, `log_exception`,
and `get_log_tags`. Logging uses `show_debug_message` and intentionally does
not depend on GameAnalytics, GlobalStats.io, HTML5 Helpers, or project-specific
services.

### EventBus

Resource folder:

- `scripts/event_bus`

Provides:

- `eventbus_subscribe(_event_name)`
- `eventbus_unsubscribe(_event_name)`
- `eventbus_dispatch(_event_name, _event_args = undefined)`

Observers define:

```gml
on_event = function(_event_name, _event_args) {
}
```

### InGameNotifications

Resource folders:

- `scripts/InGameNotificationSettings`
- `scripts/show_notification`
- `objects/o_notification_from_top`

Provides `InGameNotificationSettings` and `show_notification`. It registers a
notification handler for Logging so dev-build `log_error` and `log_exception`
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

### GameAnalytics

Resource folder:

- `scripts/gmcu_gameanalytics`

Provides:

- `gmcu_gameanalytics_init(_options)`
- `gmcu_gameanalytics_add_design_event(_event_id, _value)`
- `gmcu_gameanalytics_add_progression_event(...)`
- `gmcu_gameanalytics_add_error_event(_severity, _message)`
- `gmcu_gameanalytics_end_session()`

This module is only a facade. The GameAnalytics extension, its `ga_*` SDK
scripts, credentials, consent policy, build identifiers, and game-specific
event taxonomy remain consumer-owned. Never copy credentials into Common
Utils.

### GlobalStats.io

Resource folder:

- `scripts/gmcu_globalstats`

Provides:

- `gmcu_globalstats_is_available()`
- `gmcu_globalstats_request_leaderboard(_gtd, _num_entries = 10)`
- `gmcu_globalstats_share(_player_id, _player_name, _values)`
- `gmcu_globalstats_request_rank_section(_gtd, _player_id = undefined)`

This module is only a facade. The GlobalStats.io controller, `gs_*` HTTP
client, credentials, GTD identifiers, player identity policy, persistence,
response events, and payload schema remain consumer-owned.

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
tools/link-common-utils-resource.sh scripts/event_bus
```

If the project does not include that helper, use the skill copy:

```sh
.agents/skills/gamemaker-development/scripts/link-common-utils-resource.sh scripts/event_bus
```

5. Verify the link:

```sh
ls -ld scripts/event_bus
sed -n '1,10p' scripts/event_bus/event_bus.gml
```

6. Stage the replacement:

```sh
git add -A scripts/event_bus
git diff --cached --summary
```

Expected output includes `create mode 120000 scripts/event_bus` and deletions
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
