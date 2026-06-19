# Azeroth Angler Records

A pure Lua Turtle/Vanilla WoW addon for running fun fishing contests.

When you loot a known fish, the addon maps that WoW fish to a similar real-world fish, rolls a plausible length and weight, saves the catch, and can announce/sync it with other players running the addon.

Example:

```text
AAR: Ardnaxur caught Raw Sunscale Salmon -> Atlantic salmon 82.4cm / 8.731kg
```

## Compatibility

Designed for Turtle WoW / Vanilla-style clients.

* Client interface: `11200`
* Pure Lua addon
* No DLLs
* No executables
* No external dependencies

## Features

* Detects known fish from loot chat
* Maps WoW fish to real-life analogues
* Rolls length and weight values
* Saves your personal catch history
* Shows personal records
* Shows synced party/raid/guild leaderboard
* Announces catches to party, raid, guild, say, or off
* Syncs catches through addon messages in party/raid/guild
* Includes visible-chat fallback for cases where addon-message sync fails
* Supports contest organizer workflows

## Install

Copy the addon folder to:

```text
World of Warcraft\Interface\AddOns\AzerothAnglerRecords\
```

The `.toc` file must be directly inside that folder:

```text
Interface\AddOns\AzerothAnglerRecords\AzerothAnglerRecords.toc
```

Correct:

```text
Interface\AddOns\AzerothAnglerRecords\AzerothAnglerRecords.toc
Interface\AddOns\AzerothAnglerRecords\AzerothAnglerRecords.lua
Interface\AddOns\AzerothAnglerRecords\AAR_Data.lua
```

Wrong:

```text
Interface\AddOns\AzerothAnglerRecords_v0.1.2\AzerothAnglerRecords\AzerothAnglerRecords.toc
```

After installing, restart the game or reload your UI.

## Quick Start

For a party fishing contest:

```text
/aar clearall
/aar channel party
/aar announce on
/aar sync on
/aar status
```

For a raid fishing contest:

```text
/aar clearall
/aar channel raid
/aar announce on
/aar sync on
/aar status
```

Then fish normally.

To check the leaderboard:

```text
/aar best weight 10
/aar best length 10
```

## Commands

```text
/aar help
```

Shows the command list.

```text
/aar status
```

Shows current addon settings, including announce channel, announce state, sync state, and addon-message support.

```text
/aar best [weight|length] [n]
```

Shows the synced leaderboard.

Examples:

```text
/aar best weight 10
/aar best length 10
```

This includes your catches plus synced catches received from other players.

```text
/aar me [weight|length] [n]
```

Shows only your personal catches.

Examples:

```text
/aar me weight 10
/aar me length 10
```

```text
/aar last
```

Shows your last personal catch.

```text
/aar log [n]
```

Shows your recent personal catches.

Example:

```text
/aar log 20
```

```text
/aar sources [n]
```

Shows recent synced catches and where they came from.

Useful for debugging whether a catch came from addon sync or chat fallback.

```text
/aar channel party|raid|guild|say|off
```

Sets the public announce channel.

Examples:

```text
/aar channel party
/aar channel raid
/aar channel guild
/aar channel say
/aar channel off
```

Important: addon-message sync works only in party, raid, and guild. Say can announce visible catches, but it is not a true addon-sync channel.

```text
/aar announce on|off
```

Turns visible catch announcements on or off.

```text
/aar sync on|off
```

Turns hidden addon-message sync on or off for your own catches.

If you catch a fish and your sync is off, other players may see your chat announcement, but they may not receive the hidden addon sync message.

```text
/aar quiet on|off
```

Controls local addon print noise in your own chat window.

```text
/aar fish <itemid>
```

Shows the database entry for a fish item ID.

Example:

```text
/aar fish 13760
```

```text
/aar test <itemid>
```

Simulates a catch for testing.

In v0.1.2+, this should not save, announce, or sync a real leaderboard catch. It is only for checking database/roll output.

Example:

```text
/aar test 13760
```

```text
/aar reset
```

Clears only your personal catches.

```text
/aar clearall
```

Clears your personal catches and received/synced catches.

Use this before starting a real contest.

## Recommended Contest Setup

Everyone participating should install the same addon version.

Before the contest, each player should run:

```text
/aar clearall
/aar channel raid
/aar announce on
/aar sync on
/aar status
```

For a party contest, use:

```text
/aar channel party
```

The organizer should keep the addon enabled for the whole event and use their synced leaderboard as the official board:

```text
/aar best weight 10
/aar best length 10
/aar sources 10
```

Recommended contest categories:

```text
Biggest by weight
Longest by length
Best tiny cursed catch
Best freshwater catch
Best saltwater catch
Funniest real-life analogue
```

## Sync Behavior

Azeroth Angler Records has two ways to share catches.

### 1. Addon-message sync

This is the proper sync method.

Works in:

```text
PARTY
RAID
GUILD
```

Does not work in:

```text
SAY
```

The player catching the fish must have:

```text
/aar sync on
```

If you have sync on but the other player has sync off, your catches can sync to them, but their catches will not send hidden addon sync messages to you.

### 2. Visible-chat fallback

If enabled in the installed version, the addon can also parse visible AAR catch announcements from party/raid/guild/say chat and add them to the local leaderboard.

This helps on Turtle/Vanilla clients where `CHAT_MSG_ADDON` or addon-message prefix behavior can be inconsistent.

However, visible-chat fallback is less trustworthy because a player can manually type a fake AAR-looking message.

For casual guild events, this is fine. For serious contests, prefer addon-message sync and an organizer log.

## Testing Sync

To test a real party sync:

1. Both players install the same addon version.
2. Both players join the same party.
3. Both players run:

```text
/aar channel party
/aar announce on
/aar sync on
/aar status
```

4. Player A catches a real fish.
5. Player B checks:

```text
/aar best weight 10
/aar sources 10
```

If Player B saw the party announcement but does not see the catch in `/aar best`, then addon-message sync failed and the visible-chat fallback did not parse the announcement. Check that both players are on the same addon version.

## Defaults

Fresh install defaults:

```text
announce = true
channel = PARTY
sync = true
mode = weight
quiet = false
```

Saved settings are stored in:

```text
WTF\Account\<ACCOUNT>\SavedVariables\AzerothAnglerRecords.lua
```

If a player previously turned sync off, updating the addon will not automatically turn it back on. They should run:

```text
/aar sync on
```

## Important Fairness Warning

This is a local Lua addon for fun events.

It is not cheat-proof.

A player can:

```text
Edit SavedVariables
Modify addon Lua files
Fake visible chat fallback messages
Send fake addon messages
Use test/dev-modified versions
```

For casual guild contests, that is acceptable.

For better trust:

```text
Everyone should use the same addon version
Everyone should clear old data before the event
The organizer should keep the official synced leaderboard
Catches should be announced live
Suspicious entries should be checked with /aar sources
```

Do not use this addon as the only proof for a serious prize contest.

## Data Notes

The fish database is intentionally gameplay-friendly, not scientific-grade.

It includes common Vanilla/Turtle-style fish, alchemy fish, seasonal fish, rare fish, and bloated fish.

Each WoW fish is mapped to a similar real-world fish or creature. The addon then rolls plausible length and weight values using local ranges.

You can extend the database by editing:

```text
AAR_Data.lua
```

Add new Turtle/custom fish by item ID and include:

```text
WoW fish name
Real-world analogue
Scientific name
Habitat
Minimum length
Maximum length
Minimum weight
Maximum weight
```

## Troubleshooting

### I see someone’s catch announcement, but it is not in my leaderboard

The visible chat announcement and hidden addon sync are separate.

Make sure both players run:

```text
/aar channel party
/aar announce on
/aar sync on
/aar status
```

Then check:

```text
/aar sources 10
```

### `/aar best weight 10` only shows my catches

Either you have not received synced catches, or others are not sending them.

The player catching the fish must have sync enabled.

### `/aar best weight 10` shows old/fake/test entries

Clear the data before the real contest:

```text
/aar clearall
```

Also make sure everyone is on v0.1.2 or newer, where `/aar test` should not save/sync real leaderboard entries.

### `RegisterAddonMessagePrefix = false`

That is usually normal on Vanilla/Turtle-style clients.

It means the modern prefix-registration API is not available. The addon can still use old-style addon messages through `SendAddonMessage` and `CHAT_MSG_ADDON`.

### Party sync still does not work

Use v0.1.2 or newer so the visible-chat fallback can help.

Also make sure the channel is not `say` if you want real addon-message sync.

Use:

```text
/aar channel party
```

or:

```text
/aar channel raid
```

## Slash Commands Summary

```text
/aar help
/aar status
/aar best weight 10
/aar best length 10
/aar me weight 10
/aar me length 10
/aar last
/aar log 10
/aar sources 10
/aar channel party
/aar channel raid
/aar channel guild
/aar channel say
/aar channel off
/aar announce on
/aar announce off
/aar sync on
/aar sync off
/aar quiet on
/aar quiet off
/aar fish <itemid>
/aar test <itemid>
/aar reset
/aar clearall
```
