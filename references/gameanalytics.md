# GameAnalytics For GameMaker

Use this reference when installing, configuring, upgrading, or debugging the
GameAnalytics GameMaker SDK in a consumer project, especially when Common Utils
Logging must forward telemetry without depending on GameAnalytics.

Official references:

- [GameMaker SDK setup](https://docs.gameanalytics.com/event-tracking-and-integrations/sdks-and-collection-api/game-engine-sdks/gamemaker)
- [GameMaker SDK features, diagnostics, and sessions](https://docs.gameanalytics.com/integrations/sdk/gamemaker/sdk-features/)

## Ownership

GameAnalytics is provider-specific integration code and belongs to the
consumer. Do not add the SDK, credentials, constants, event taxonomy, or a
version-specific facade to `gamemaker-common-utils`.

Common Utils Logging is provider-independent. It exposes:

```gml
gmcu_log_set_telemetry_handler(function(_severity, _message) {
	// Consumer-owned provider call.
});
```

Without a handler, Logging still writes output and fills the Dev Menu buffer.

## Install The SDK

1. Obtain the GameAnalytics SDK for GameMaker Studio 2 from the GameMaker
   Marketplace, as directed by the official GameAnalytics documentation.
2. Import the extension and all SDK resources into the consumer project.
3. Confirm the project contains `GameAnalyticsExt`, the `ga_*` scripts used by
   the integration, and the `GA_*` constants.
4. Record the imported extension version before writing a compatibility
   facade. Do not claim support for newer versions without validation.
5. Compile a minimal target before adding game telemetry.

Fantasma is pinned to extension version `4.0.7`. Its extension metadata also
references Android SDK `6.2.9`; treat those as separate version layers.

## Local Credentials

Keep credentials out of shared repositories, skills, and documentation.
Recommended project layout:

```text
scripts/analytics_config/
├── analytics_config.yy
├── analytics_config.example.gml
└── analytics_config.gml        # ignored by Git
```

Template:

```gml
#macro GAME_ANALYTICS_KEY "YOUR_GAME_KEY"
#macro GAME_ANALYTICS_SECRET "YOUR_SECRET_KEY"
```

Register `analytics_config.yy` in the GameMaker project and ignore only the
real `.gml` file. Each checkout copies the template and supplies its own keys.

## Defensive Local Facade

Create a consumer-owned facade such as `ga_safe_*` and pin it to the installed
SDK version. The facade should:

- Start disabled.
- Validate configuration and credentials.
- Allow intentional disablement.
- Configure build and SDK logs before initialization.
- Wrap every SDK call in `try/catch`.
- Disable itself if initialization fails.
- Return a boolean from every operation.
- Preserve optional argument and overload behavior used by the game.
- Document every wrapped `ga_*` signature with JSDoc.

The facade is defensive against runtime SDK failures. It cannot make a missing
SDK compile: referenced `ga_*` functions and `GA_*` constants must exist.

## Initialize And Wire Logging

Initialize after build information is available:

```gml
ga_safe_init({
	game_key: GAME_ANALYTICS_KEY,
	game_secret: GAME_ANALYTICS_SECRET,
	build: global.build_number,
	info_log: false,
	verbose_log: false
});
```

Then register the consumer-owned severity mapping:

```gml
gmcu_log_set_telemetry_handler(function(_severity, _message) {
	var _ga_severity = GA_ERRORSEVERITY_ERROR;
	switch (_severity) {
		case GMCU_LOG_LEVEL_DEBUG:
			_ga_severity = GA_ERRORSEVERITY_DEBUG;
			break;
		case GMCU_LOG_LEVEL_INFO:
			_ga_severity = GA_ERRORSEVERITY_INFO;
			break;
		case GMCU_LOG_LEVEL_WARN:
			_ga_severity = GA_ERRORSEVERITY_WARNING;
			break;
	}
	ga_safe_add_error_event(_ga_severity, _message);
});
```

Preserve `gmcu_log_debug(_message, true)` as local-only. Logging already skips
the telemetry handler for that call.

## Events And Sessions

Keep event names and progression structure in the consumer. Use the local
facade for design, progression, and error events so SDK failures do not escape
into gameplay.

For release crash handling:

1. Submit the fatal error with `GA_ERRORSEVERITY_CRITICAL`.
2. End the GameAnalytics session to flush the queue.
3. Continue the consumer's crash presentation or shutdown path.

Follow the official session guidance for desktop quit handling and any
platform-specific lifecycle requirements.

## Upgrade Checklist

For every SDK upgrade:

1. Record the old and new extension versions.
2. Diff the imported extension functions, `ga_*` scripts, constants, and
   platform files.
3. Review every facade call for renamed functions, changed argument counts,
   changed overloads, or changed semantics.
4. Update the declared compatible version only after validation.
5. Compile every supported target and both relevant project configurations.
6. Enable SDK info or verbose logs temporarily.
7. Exercise design, progression, error, fatal, and session-end paths.
8. Exercise every Logging severity and verify local-only debug stays local.
9. Confirm events arrive in the GameAnalytics realtime dashboard.
10. Disable verbose diagnostics before release.

Do not treat a successful VM compile as proof that platform SDK binaries,
HTML5 JavaScript, credentials, network submission, or dashboard ingestion work.
