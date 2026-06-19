# Azeroth Angler Records

Azeroth Angler Records is a Turtle WoW / Vanilla WoW addon for fun fishing contests.

When you catch a known fish, the addon gives it a real-life fish equivalent and rolls a realistic length and weight. It can save your catches, announce them, and sync contest records with other players using the addon.

Example:

```text
AAR: Razvan caught Raw Sunscale Salmon -> Atlantic salmon 82.4cm / 8.731kg
```

## Features

* Detects fish from loot chat
* Gives each fish a real-life equivalent
* Rolls length and weight
* Saves your personal catches
* Shows personal records
* Shows party/raid/guild contest leaderboards
* Announces catches in chat
* Syncs catches with other players using the addon
* Works as a pure Lua addon, no DLLs or external programs

## Installation

Copy the addon folder to:

```text
World of Warcraft\Interface\AddOns\AzerothAnglerRecords\
```

The addon files should look like this:

```text
Interface\AddOns\AzerothAnglerRecords\AzerothAnglerRecords.toc
Interface\AddOns\AzerothAnglerRecords\AzerothAnglerRecords.lua
Interface\AddOns\AzerothAnglerRecords\AAR_Data.lua
```

Then restart the game or run:

```text
/reload
```

## Quick Start

For a party contest:

```text
/aar clearall
/aar channel party
/aar announce on
/aar sync on
/aar status
```

For a raid contest:

```text
/aar clearall
/aar channel raid
/aar announce on
/aar sync on
/aar status
```

Then fish normally.

To show the leaderboard:

```text
/aar best weight 10
/aar best length 10
```

## Commands

### Help

```text
/aar help
```

Shows the command list.

### Status

```text
/aar status
```

Shows your current addon settings.

### Leaderboard

```text
/aar best weight 10
/aar best length 10
```

Shows the synced leaderboard, including your catches and catches received from other players.

### Personal Records

```text
/aar me weight 10
/aar me length 10
```

Shows only your own catches.

### Last Catch

```text
/aar last
```

Shows your latest saved catch.

### Catch Log

```text
/aar log 10
```

Shows your recent catches.

### Synced Catch Sources

```text
/aar sources 10
```

Shows recently received catches from other players.

Useful for contest organizers to check whether another player's catch synced correctly.

### Set Channel

```text
/aar channel party
/aar channel raid
/aar channel guild
/aar channel say
/aar channel off
```

Sets where catches are announced.

For synced contests, use:

```text
/aar channel party
```

or:

```text
/aar channel raid
```

### Announcements

```text
/aar announce on
/aar announce off
```

Turns visible catch announcements on or off.

### Sync

```text
/aar sync on
/aar sync off
```

Turns catch syncing on or off.

For contests, players should use:

```text
/aar sync on
```

### Quiet Mode

```text
/aar quiet on
/aar quiet off
```

Reduces local addon messages in your chat.

### Fish Lookup

```text
/aar fish <itemid>
```

Shows information about a fish in the addon database.

Example:

```text
/aar fish 13760
```

### Test Roll

```text
/aar test <itemid>
```

Tests what a roll would look like for a fish.

Example:

```text
/aar test 13760
```

Test rolls do not count as real catches.

### Reset Personal Data

```text
/aar reset
```

Clears your own saved catches.

### Clear Everything

```text
/aar clearall
```

Clears your own catches and received synced catches.

Recommended before starting a new contest.

## Recommended Contest Setup

Before starting a contest, all participants should install the same addon version and run:

```text
/aar clearall
/aar channel raid
/aar announce on
/aar sync on
/aar status
```

For party contests, use:

```text
/aar channel party
```

The contest organizer can check standings with:

```text
/aar best weight 10
/aar best length 10
/aar sources 10
```

Suggested contest categories:

```text
Biggest by weight
Longest by length
Smallest catch
Best rare catch
Funniest real-life fish equivalent
```

## Important Notes

This addon is made for fun community events.

It is not cheat-proof. Players can still modify local addon data or use modified addon files.

For best results:

```text
Everyone should use the same addon version
Everyone should clear old data before the contest
Everyone should keep sync enabled
The organizer should use /aar sources if something looks suspicious
```

## Troubleshooting

### I only see my own catches

Make sure everyone has sync enabled:

```text
/aar sync on
```

Also make sure everyone is using party, raid, or guild channel:

```text
/aar channel party
```

or:

```text
/aar channel raid
```

### I see catch announcements, but they do not appear in the leaderboard

In v0.1.3, visible chat announcements are not imported into the leaderboard.

Players need to have the addon installed and sync enabled.

### The leaderboard has old or test entries

Run:

```text
/aar clearall
```

before starting a new contest.

### Sync still does not work

Make sure both players are in the same party or raid and have:

```text
/aar sync on
/aar channel party
```

or:

```text
/aar sync on
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

## Changelog

### v0.1.3

* Fixed party/raid/guild sync issues on Turtle/Vanilla clients.
* Improved compatibility between players using the addon.
* Disabled visible chat fallback for leaderboard imports.
* Leaderboards now rely on addon sync only.
* Removed temporary debug messages from the release version.
* Updated README.

### v0.1.2

* Added visible chat fallback for cases where addon sync was unreliable.
* Added `/aar status`.
* Added `/aar sources`.
* Improved sync troubleshooting.
* Helped identify whether catches were received through sync or chat fallback.

### v0.1.1

* Fixed `/aar test` so test rolls no longer save, announce, or sync as real catches.
* Improved synced catch ownership.
* Added/improved `/aar sources`.
* Improved duplicate handling.
* Recommended `/aar clearall` before real contests.

### v0.1.0

* Initial release.
* Added fish detection from loot chat.
* Added real-life fish equivalents.
* Added length and weight rolls.
* Added personal catch history.
* Added leaderboards.
* Added catch announcements.
* Added initial sync support.
* Added basic slash commands.
