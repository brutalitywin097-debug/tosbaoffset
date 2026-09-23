# CS2 Offsets

![build](https://img.shields.io/badge/build-14183-blue)

Auto-dumped Counter-Strike 2 offsets, updated every patch. Powered by
[a2x/cs2-dumper](https://github.com/a2x/cs2-dumper) running against the live
game — not hand-maintained.

**last updated: 2026-09-24 (build 14183)

## Contents

Each module is dumped to every format cs2-dumper supports:

| file | contents |
| --- | --- |
| `offsets.*` | module-relative offsets (`dwEntityList`, `dwLocalPlayerPawn`, `dwViewMatrix`, `dwCSGOInput`, …) |
| `client_dll.*` | client.dll schema classes/fields (`m_iHealth`, `m_iTeamNum`, …) |
| `engine2_dll.*` | engine2.dll schema + `dwBuildNumber`, `dwNetworkGameClient` |
| `interfaces.*` | exposed interface pointers |
| `buttons.*` | input button bitmasks (`in_attack`, `in_jump`, …) |
| `*_dll.*` | per-module schema dumps |
| `info.json` | build number + dump timestamp |

Formats: `json`, `hpp`, `cs`, `rs`, `zig`.

## Usage

Raw JSON, always current:

```
https://raw.githubusercontent.com/NotII/cs2-offsets/main/offsets.json
https://raw.githubusercontent.com/NotII/cs2-offsets/main/client_dll.json
```

Check `info.json` → `build_number` against your game before trusting the values.

## Updating (maintainers)

With cs2 running:

```powershell
.\update.ps1 -Push
```

Re-dumps from the live process, refreshes this README, commits and pushes.
Set `$env:CS2_DUMPER` to your dumper binary if it isn't at the default path.

## Credit

- [a2x/cs2-dumper](https://github.com/a2x/cs2-dumper) — the dumper itself
- maintained by [NotII](https://github.com/NotII) for the gerryhook project
