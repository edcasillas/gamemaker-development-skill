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
not depend on GameAnalytics, JSUtils, GlobalStats.io, or NoMobileWeb.

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

## Migrating An Existing Resource

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

Future Common Utils candidates include transitions, timed actions, debug/dev
menu helpers, GameAnalytics wrappers, GlobalStats.io wrappers, HTML5
extensions, and optional `.yymps` packaging.
