# GlobalStats.io For GameMaker

Use this reference when installing, maintaining, or debugging a GlobalStats.io
client in a GameMaker project.

## Ownership

Treat GlobalStats.io as consumer-owned integration code. Keep the controller,
HTTP client, credentials, GTD identifiers, event contract, player identity,
persistence, payload schema, and API compatibility policy in the game project.
Do not add a provider-specific facade to Common Utils.

Common Utils Logging and EventBus are optional dependencies. A GlobalStats
client may call `gmcu_log_*` and dispatch asynchronous results through
`gmcu_eventbus_dispatch()` without Common Utils owning the integration.

## Install The Client

Import the complete client snapshot as one unit:

- A persistent controller object.
- Public and internal `gs_*` scripts.
- Request/response data structures.
- Async HTTP and cleanup events.
- Event constants and project configuration.

Register every resource in the consumer `.yyp`, place one controller instance
in the earliest bootstrap room, and make it persistent or enforce singleton
behavior. Compile before adding gameplay calls; partial imports commonly fail
because scripts reference controller fields and other client scripts directly.

Record the source and revision of the imported snapshot. GlobalStats.io API
paths, response formats, and client signatures are compatibility boundaries
that require review during upgrades.

## Configuration

Define consumer-owned macros for the game ID, game secret, and default GTD.
Use explicit GameMaker configurations when development and release use
different GlobalStats applications:

```gml
#macro GLOBALSTATS_GAME_ID "LOCAL_RELEASE_ID"
#macro GLOBALSTATS_GAME_SECRET "LOCAL_RELEASE_SECRET"
#macro DevBuild:GLOBALSTATS_GAME_ID "LOCAL_DEV_ID"
#macro DevBuild:GLOBALSTATS_GAME_SECRET "LOCAL_DEV_SECRET"
#macro GLOBAL_STATS_DEFAULT_GTD_KEY "hscore"
```

Prefer an ignored local configuration file with a versioned placeholder
template. Never place real credentials in Common Utils, skills, documentation,
or new commits. Existing tracked credentials require a separate, deliberate
migration and possible rotation policy.

## Runtime Flow

The controller should:

1. Load persisted player state.
2. Request an access token when none is valid.
3. Dispatch a ready event after authentication.
4. Track every pending HTTP request by request ID.
5. Decode async responses and dispatch typed success or error events.
6. Save changed player state and clean up owned data structures.

Gameplay should wait for the ready event before requesting remote data. A
`false` return can mean that a request could not start, a matching request is
already pending, or authentication must complete first; inspect client logs and
events rather than treating it as a synchronous server failure.

## Statistics And Leaderboards

Define project GTD keys and payload structure in the consumer. For a score
submission:

```gml
var _values = ds_map_create();
ds_map_add(_values, GTD_SCORE, _score);
ds_map_add(_values, GTD_LEVEL, _level);
var _started = gs_share(undefined, _player_name, _values);
ds_map_destroy(_values);
```

Passing no player ID creates an independent statistic and returns a new ID in
the asynchronous response. Passing a known ID updates that player's statistic.
This is game policy and must remain explicit at the call site.

Request leaderboards and rank sections through the imported client API:

```gml
gs_get_gtd_leaderboard(GTD_SCORE, 10);
gs_getRankSection(_player_id, GTD_SCORE);
```

Clamp leaderboard limits to the range supported by the client or service.
Consume results through the client's asynchronous events, not immediate return
values.

## Logging And EventBus

Use Logging for token, request, response, and parse diagnostics. Do not log
credentials or authorization headers. Use EventBus to decouple gameplay from
the controller's Async HTTP event:

- ready;
- leaderboard retrieved;
- share succeeded;
- rank section retrieved;
- error.

Subscribe in Create and unsubscribe in Clean Up. Preserve event payload shapes
when upgrading the client because UI and game flow may depend on them.

## Diagnosis

When requests fail, check:

1. The controller exists and completed Create.
2. The expected GameMaker configuration supplied the intended credentials.
3. An access token exists or a token request is pending.
4. No equivalent request is already pending.
5. The request ID is registered before Async HTTP handling.
6. HTTP status and response JSON match the parser's expectations.
7. The expected success or error event is dispatched.
8. Browser storage behavior is considered on HTML5; probing a missing local
   settings file can produce an expected visible `HEAD` 404.

## Upgrade Checklist

1. Record the old and new client or API revisions.
2. Diff controller fields, `gs_*` signatures, endpoints, headers, payloads,
   response parsing, event names, and event payloads.
3. Preserve GTD keys, player identity policy, and persistence behavior.
4. Compile every supported target and relevant GameMaker configuration.
5. Exercise token acquisition, leaderboard, first share, update share, rank
   section, duplicate pending requests, errors, save, and cleanup.
6. Verify real responses against the GlobalStats.io service before accepting
   the upgrade.

Do not add a generic facade merely to wrap the imported functions in
`try/catch`. A useful abstraction must remove an actual provider dependency or
stabilize a deliberately supported application-level contract.
