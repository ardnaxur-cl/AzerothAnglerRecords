Azeroth Angler Records v0.1.2
================================

A pure Lua Turtle/Vanilla WoW addon for running a fun fishing contest.
When you loot a known fish, the addon maps it to a real-world analogue and rolls a plausible length + weight.
It can announce catches and sync them to other people running the addon.

Install
-------
Copy this folder to:

  World of Warcraft\Interface\AddOns\AzerothAnglerRecords\

The .toc must be directly inside that folder:

  Interface\AddOns\AzerothAnglerRecords\AzerothAnglerRecords.toc

Commands
--------
/aar help                         Show commands
/aar best [weight|length] [n]      Synced leaderboard, default top 5
/aar me [weight|length] [n]        Your personal leaderboard
/aar last                         Last personal catch
/aar log [n]                       Recent personal catches
/aar channel party|raid|guild|say|off
/aar announce on|off               Public catch announcement
/aar sync on|off                   Addon-message sync
/aar quiet on|off                  Local print noise
/aar fish <itemid>                 Show database entry
/aar test <itemid>                 Simulate catch for testing
/aar reset                         Clear your personal catches
/aar clearall                      Clear personal and synced catches

Suggested contest setup
-----------------------
Everyone installs the addon.
Party/raid leader says:

  /aar channel raid
  /aar announce on
  /aar sync on

Then winners can be checked with:

  /aar best weight 10
  /aar best length 10

Important fairness warning
--------------------------
This is a local Lua addon. It is good for fun guild events, not serious prize contests.
A player can edit Lua/SavedVariables or fake addon messages.
For better trust, have an organizer present and use the organizer's synced leaderboard as the official log.

Data notes
----------
The database is intentionally gameplay-friendly, not scientific-grade.
It includes common Vanilla/Turtle-style fish, alchemy fish, seasonal fish, rare fish, and bloated fish.
You can extend AAR_Data.lua by adding more item IDs if Turtle/Octo custom fish should be included.

What's changed in v0.1.2
--------------------------
- Adds fallback sync from visible AAR chat announcements.
- If you see their PARTY/RAID/GUILD/SAY announcement, your addon can now add it to the synced leaderboard.
- Keeps real addon-message sync too.
- Adds /aar status for debugging.
- /aar sources now shows whether a catch came from addon sync or chat fallback.
