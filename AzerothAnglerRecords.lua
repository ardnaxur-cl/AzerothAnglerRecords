-- Azeroth Angler Records
-- Pure Lua addon for WoW 1.12 / Turtle-style clients.

local AAR = {}
AAR.prefix = "|cff33ff99AAR|r"
AAR.addonPrefix = "AAR1"

local function Print(msg)
  if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(AAR.prefix .. ": " .. tostring(msg)) end
end

local function SafeLower(s)
  if not s then return nil end
  return string.lower(s)
end

local function NormalizePlayerName(name)
  name = tostring(name or "")
  -- Some clients include realm suffixes in addon sender names.
  name = string.gsub(name, "%-.+$", "")
  if name == "" then return nil end
  return name
end

local function Round(n, decimals)
  local p = 10 ^ (decimals or 0)
  return math.floor(n * p + 0.5) / p
end

local function Num(n, decimals)
  if not n then return "?" end
  if decimals == 0 then return tostring(math.floor(n + 0.5)) end
  local fmt = "%0." .. tostring(decimals or 1) .. "f"
  return string.format(fmt, n)
end


local function CanAddonSyncChannel(ch)
  return ch == "PARTY" or ch == "RAID" or ch == "GUILD"
end

local function SplitPipe(s)
  local out = {}
  local start = 1
  while true do
    local p = string.find(s or "", "|", start, true)
    if not p then
      table.insert(out, string.sub(s or "", start))
      break
    end
    table.insert(out, string.sub(s or "", start, p - 1))
    start = p + 1
  end
  return out
end

local function CleanPipe(s)
  s = tostring(s or "")
  s = string.gsub(s, "|", "/")
  s = string.gsub(s, "\n", " ")
  s = string.gsub(s, "\r", " ")
  return s
end

local function InitDB()
  if not AAR_DB then AAR_DB = {} end
  if not AAR_DB.catches then AAR_DB.catches = {} end
  if not AAR_DB.received then AAR_DB.received = {} end
  if not AAR_DB.config then AAR_DB.config = {} end

  if AAR_DB.config.announce == nil then AAR_DB.config.announce = true end
  if not AAR_DB.config.channel then AAR_DB.config.channel = "PARTY" end
  if AAR_DB.config.sync == nil then AAR_DB.config.sync = true end
  if not AAR_DB.config.mode then AAR_DB.config.mode = "weight" end
  if AAR_DB.config.quiet == nil then AAR_DB.config.quiet = false end
end

local function SeedRandom()
  local seed = 0
  if time then seed = seed + time() end
  if GetTime then seed = seed + math.floor(GetTime() * 1000) end
  local n = UnitName and UnitName("player") or "angler"
  local i
  for i = 1, string.len(n) do seed = seed + string.byte(n, i) * i end
  math.randomseed(seed)
  -- stir old Lua RNG a bit
  math.random(); math.random(); math.random()
end

local function RollFishStats(fish)
  -- Trophy catches should be rare. The exponent makes most rolls modest.
  local r = math.random()
  local sizeRoll = r ^ 2.35
  local condition = 0.88 + math.random() * 0.24

  local length = fish.minL + (fish.maxL - fish.minL) * sizeRoll
  local weightRatio = sizeRoll ^ 3
  local weight = fish.minW + (fish.maxW - fish.minW) * weightRatio * condition

  if weight > fish.maxW then weight = fish.maxW end
  if weight < fish.minW then weight = fish.minW end

  return Round(length, 1), Round(weight, 3)
end

local function MakeCatchId(player, itemID)
  local t = GetTime and math.floor(GetTime() * 1000) or math.random(100000, 999999)
  return tostring(player or "?") .. "-" .. tostring(itemID) .. "-" .. tostring(t) .. "-" .. tostring(math.random(1000, 9999))
end

local function GetZone()
  if GetRealZoneText then return GetRealZoneText() or "Unknown" end
  return "Unknown"
end

local function FormatCatch(c)
  return c.player .. " caught " .. c.wow .. " -> " .. c.real .. " (" .. Num(c.lengthCm, 1) .. " cm, " .. Num(c.weightKg, 3) .. " kg)"
end

local function FormatShortCatch(c)
  return "AAR: " .. c.player .. " caught " .. c.wow .. " -> " .. c.real .. " " .. Num(c.lengthCm, 1) .. "cm / " .. Num(c.weightKg, 3) .. "kg"
end

local function AddCatch(tbl, c)
  if not tbl then return end
  table.insert(tbl, c)
end

local function FindItemInLootMessage(msg)
  local _, _, itemID = string.find(msg or "", "item:(%d+)")
  if itemID then return tonumber(itemID) end

  local _, _, itemName = string.find(msg or "", "%[(.-)%]")
  if itemName then
    return AAR_FISH_NAME_TO_ID[SafeLower(itemName)]
  end

  return nil
end

local function IsOwnLootMessage(msg)
  if not msg then return false end
  -- English Turtle/Vanilla client: "You receive loot: [item]."
  if string.find(msg, "^You receive") then return true end
  if string.find(msg, "^You loot") then return true end
  return false
end

function AAR:CreateCatch(itemID)
  local fish = AAR_FISH[itemID]
  if not fish then return nil end

  local player = UnitName and UnitName("player") or "Player"
  local length, weight = RollFishStats(fish)

  local c = {
    id = MakeCatchId(player, itemID),
    player = player,
    itemID = itemID,
    wow = fish.wow,
    real = fish.real,
    sci = fish.sci,
    habitat = fish.habitat,
    lengthCm = length,
    weightKg = weight,
    zone = GetZone(),
    timestamp = date and date("%Y-%m-%d %H:%M:%S") or tostring(GetTime and GetTime() or 0),
    source = "self",
  }
  return c
end

function AAR:PreviewCatch(itemID)
  InitDB()
  local c = self:CreateCatch(itemID)
  if not c then return end
  Print("test roll only, not saved/synced: " .. FormatCatch(c))
end

function AAR:RecordCatch(itemID, silent)
  InitDB()
  local c = self:CreateCatch(itemID)
  if not c then return end

  AddCatch(AAR_DB.catches, c)

  if not AAR_DB.config.quiet and not silent then
    Print(FormatCatch(c))
  end

  if AAR_DB.config.announce and AAR_DB.config.channel ~= "OFF" and not silent then
    SendChatMessage(FormatShortCatch(c), AAR_DB.config.channel)
  end

  if AAR_DB.config.sync and CanAddonSyncChannel(AAR_DB.config.channel) and not silent and SendAddonMessage then
    local payload = "C|" .. CleanPipe(c.id) .. "|" .. CleanPipe(c.player) .. "|" .. tostring(c.itemID) .. "|" .. tostring(c.lengthCm) .. "|" .. tostring(c.weightKg) .. "|" .. CleanPipe(c.timestamp) .. "|" .. CleanPipe(c.zone)
    SendAddonMessage(self.addonPrefix, payload, AAR_DB.config.channel)
  end
end

function AAR:OnLoot(msg)
  if not IsOwnLootMessage(msg) then return end
  local itemID = FindItemInLootMessage(msg)
  if itemID and AAR_FISH[itemID] then
    self:RecordCatch(itemID, false)
  end
end

local function HasCatch(id)
  local i
  if not id then return true end
  for i = 1, table.getn(AAR_DB.catches or {}) do
    if AAR_DB.catches[i].id == id then return true end
  end
  for i = 1, table.getn(AAR_DB.received or {}) do
    if AAR_DB.received[i].id == id then return true end
  end
  return false
end

local function SameNumber(a, b)
  a = tonumber(a) or 0
  b = tonumber(b) or 0
  return math.abs(a - b) < 0.0005
end

local function HasSimilarCatch(player, itemID, length, weight)
  InitDB()
  player = NormalizePlayerName(player)
  itemID = tonumber(itemID)
  length = tonumber(length) or 0
  weight = tonumber(weight) or 0

  local function scan(tbl)
    local i, c
    for i = 1, table.getn(tbl or {}) do
      c = tbl[i]
      if c and NormalizePlayerName(c.player) == player
        and tonumber(c.itemID) == itemID
        and SameNumber(c.lengthCm, length)
        and SameNumber(c.weightKg, weight) then
        return true
      end
    end
    return false
  end

  return scan(AAR_DB.catches) or scan(AAR_DB.received)
end

local function MakeChatCatchId(player, itemID, length, weight)
  return "chat-" .. tostring(NormalizePlayerName(player) or "?") .. "-" .. tostring(itemID or "?") .. "-" .. tostring(length or "?") .. "-" .. tostring(weight or "?")
end

local function ParseChatAnnouncement(msg)
  local _, _, player, wow, real, length, weight = string.find(msg or "", "^AAR:%s*(.-)%s+caught%s+(.-)%s+%-%>%s+(.-)%s+([%d%.]+)cm%s*/%s*([%d%.]+)kg")
  if not player then return nil end
  local itemID = AAR_FISH_NAME_TO_ID[SafeLower(wow)]
  local fish = itemID and AAR_FISH[itemID]
  if not fish then return nil end
  return {
    id = MakeChatCatchId(player, itemID, length, weight),
    player = NormalizePlayerName(player) or player,
    payloadPlayer = NormalizePlayerName(player),
    sender = NormalizePlayerName(player),
    itemID = itemID,
    wow = fish.wow,
    real = fish.real,
    sci = fish.sci,
    habitat = fish.habitat,
    lengthCm = tonumber(length) or 0,
    weightKg = tonumber(weight) or 0,
    timestamp = date and date("%Y-%m-%d %H:%M:%S") or tostring(GetTime and GetTime() or 0),
    zone = "chat",
    source = "chat",
  }
end

function AAR:OnAddonMessage(prefix, msg, channel, sender)
  if prefix ~= self.addonPrefix then return end
  local senderName = NormalizePlayerName(sender)
  local myName = UnitName and NormalizePlayerName(UnitName("player")) or nil
  if senderName and myName and senderName == myName then return end
  InitDB()

  local parts = SplitPipe(msg or "")
  local typ = parts[1]
  local id = parts[2]
  local player = parts[3]
  local itemID = parts[4]
  local length = parts[5]
  local weight = parts[6]
  local timestamp = parts[7]
  local zone = parts[8]
  if typ ~= "C" then return end
  if HasCatch(id) then return end

  itemID = tonumber(itemID)
  local fish = itemID and AAR_FISH[itemID]
  if not fish then return end

  local c = {
    id = id,
    -- Trust the addon-message sender as the owner when available.
    -- The payload player field is kept for older messages/fallback only.
    player = senderName or NormalizePlayerName(player) or "?",
    payloadPlayer = NormalizePlayerName(player),
    sender = senderName,
    itemID = itemID,
    wow = fish.wow,
    real = fish.real,
    sci = fish.sci,
    habitat = fish.habitat,
    lengthCm = tonumber(length) or 0,
    weightKg = tonumber(weight) or 0,
    timestamp = timestamp or "",
    zone = zone or "",
    source = "sync",
  }

  if HasSimilarCatch(c.player, c.itemID, c.lengthCm, c.weightKg) then return end

  AddCatch(AAR_DB.received, c)

  if not AAR_DB.config.quiet then
    Print("synced: " .. FormatCatch(c))
  end
end

function AAR:OnChatAnnouncement(msg, sender)
  InitDB()
  local c = ParseChatAnnouncement(msg)
  if not c then return end

  local senderName = NormalizePlayerName(sender)
  local myName = UnitName and NormalizePlayerName(UnitName("player")) or nil
  if senderName then
    c.player = senderName
    c.sender = senderName
  end
  if myName and c.player == myName then return end
  if HasCatch(c.id) then return end
  if HasSimilarCatch(c.player, c.itemID, c.lengthCm, c.weightKg) then return end

  AddCatch(AAR_DB.received, c)
  if not AAR_DB.config.quiet then
    Print("chat-synced: " .. FormatCatch(c))
  end
end

local function AllCatches()
  InitDB()
  local all = {}
  local seen = {}
  local i, c
  for i = 1, table.getn(AAR_DB.catches) do
    c = AAR_DB.catches[i]
    if c and c.id and not seen[c.id] then table.insert(all, c); seen[c.id] = true end
  end
  for i = 1, table.getn(AAR_DB.received) do
    c = AAR_DB.received[i]
    if c and c.id and not seen[c.id] then table.insert(all, c); seen[c.id] = true end
  end
  return all
end

local function SortCatches(list, mode)
  table.sort(list, function(a, b)
    if mode == "length" then
      return (a.lengthCm or 0) > (b.lengthCm or 0)
    else
      return (a.weightKg or 0) > (b.weightKg or 0)
    end
  end)
end

function AAR:PrintTop(mode, count, ownOnly)
  InitDB()
  mode = mode or AAR_DB.config.mode or "weight"
  count = tonumber(count) or 5

  local list = ownOnly and AAR_DB.catches or AllCatches()
  SortCatches(list, mode)

  Print("Top " .. tostring(count) .. " by " .. mode .. (ownOnly and " (own only)" or " (synced board)"))
  local i
  for i = 1, math.min(count, table.getn(list)) do
    local c = list[i]
    Print("#" .. i .. " " .. FormatCatch(c) .. " [" .. (c.zone or "?") .. "]")
  end
  if table.getn(list) == 0 then Print("No catches recorded yet.") end
end

function AAR:PrintLast()
  InitDB()
  local n = table.getn(AAR_DB.catches)
  if n == 0 then Print("No personal catches yet.") return end
  Print("Last: " .. FormatCatch(AAR_DB.catches[n]))
end

function AAR:PrintLog(count)
  InitDB()
  count = tonumber(count) or 10
  local n = table.getn(AAR_DB.catches)
  if n == 0 then Print("No personal catches yet.") return end
  local start = n - count + 1
  if start < 1 then start = 1 end
  local i
  for i = start, n do
    Print("#" .. i .. " " .. FormatCatch(AAR_DB.catches[i]))
  end
end

function AAR:PrintSources(count)
  InitDB()
  count = tonumber(count) or 10
  local n = table.getn(AAR_DB.received)
  if n == 0 then Print("No synced catches yet.") return end
  local start = n - count + 1
  if start < 1 then start = 1 end
  local i
  for i = start, n do
    local c = AAR_DB.received[i]
    Print("sync #" .. i .. " source=" .. tostring(c.source or "?") .. " owner=" .. tostring(c.player) .. " sender=" .. tostring(c.sender or "?") .. " payload=" .. tostring(c.payloadPlayer or "?") .. " id=" .. tostring(c.id))
  end
end

function AAR:ShowFish(itemID)
  itemID = tonumber(itemID)
  local fish = itemID and AAR_FISH[itemID]
  if not fish then Print("Unknown fish item id. Example: /aar fish 6291") return end
  Print(fish.wow .. " => " .. fish.real .. " (" .. fish.sci .. "), " .. fish.habitat .. ", " .. Num(fish.minL,1) .. "-" .. Num(fish.maxL,1) .. " cm, " .. Num(fish.minW,3) .. "-" .. Num(fish.maxW,3) .. " kg")
end

function AAR:Status()
  InitDB()
  Print("version = v0.1.2")
  Print("channel = " .. tostring(AAR_DB.config.channel) .. ", announce = " .. tostring(AAR_DB.config.announce) .. ", sync = " .. tostring(AAR_DB.config.sync) .. ", quiet = " .. tostring(AAR_DB.config.quiet))
  Print("SendAddonMessage = " .. tostring(SendAddonMessage ~= nil) .. ", RegisterAddonMessagePrefix = " .. tostring(RegisterAddonMessagePrefix ~= nil))
  Print("personal catches = " .. tostring(table.getn(AAR_DB.catches or {})) .. ", synced/chat catches = " .. tostring(table.getn(AAR_DB.received or {})))
end

function AAR:Help()
  Print("Commands:")
  Print("/aar best [weight|length] [n] - synced leaderboard")
  Print("/aar me [weight|length] [n] - your own leaderboard")
  Print("/aar last - show last catch")
  Print("/aar log [n] - show recent personal catches")
  Print("/aar sources [n] - show recent synced/chat catches with sender info")
  Print("/aar status - show config and sync diagnostics")
  Print("/aar channel party|raid|guild|say|off - announce/sync channel")
  Print("/aar announce on|off - public chat announce")
  Print("/aar sync on|off - addon sync messages")
  Print("/aar quiet on|off - local print noise")
  Print("/aar fish <itemid> - show fish database entry")
  Print("/aar test <itemid> - local test roll, not saved/synced")
  Print("/aar reset - clear your personal catches")
  Print("/aar clearall - clear personal + synced catches")
end

function AAR:Command(msg)
  InitDB()
  msg = msg or ""
  local _, _, cmd, rest = string.find(msg, "^(%S*)%s*(.-)$")
  cmd = SafeLower(cmd or "") or ""
  rest = rest or ""

  if cmd == "" or cmd == "help" then self:Help(); return end

  if cmd == "best" or cmd == "top" then
    local _, _, mode, n = string.find(rest, "^(%S*)%s*(%S*)")
    if mode ~= "length" and mode ~= "weight" then mode = AAR_DB.config.mode end
    self:PrintTop(mode, tonumber(n) or 5, false)
    return
  end

  if cmd == "me" then
    local _, _, mode, n = string.find(rest, "^(%S*)%s*(%S*)")
    if mode ~= "length" and mode ~= "weight" then mode = AAR_DB.config.mode end
    self:PrintTop(mode, tonumber(n) or 5, true)
    return
  end

  if cmd == "last" then self:PrintLast(); return end
  if cmd == "log" then self:PrintLog(tonumber(rest) or 10); return end
  if cmd == "sources" then self:PrintSources(tonumber(rest) or 10); return end
  if cmd == "status" then self:Status(); return end
  if cmd == "fish" then self:ShowFish(rest); return end

  if cmd == "test" then
    local id = tonumber(rest) or 6291
    if not AAR_FISH[id] then Print("Unknown test fish item id.") return end
    self:PreviewCatch(id)
    return
  end

  if cmd == "channel" then
    local ch = string.upper(rest or "")
    if ch == "PARTY" or ch == "RAID" or ch == "GUILD" or ch == "SAY" or ch == "OFF" then
      AAR_DB.config.channel = ch
      Print("channel = " .. ch)
    else
      Print("Use: /aar channel party|raid|guild|say|off")
    end
    return
  end

  if cmd == "announce" then
    if SafeLower(rest) == "on" then AAR_DB.config.announce = true
    elseif SafeLower(rest) == "off" then AAR_DB.config.announce = false
    else Print("announce = " .. tostring(AAR_DB.config.announce)); return end
    Print("announce = " .. tostring(AAR_DB.config.announce))
    return
  end

  if cmd == "sync" then
    if SafeLower(rest) == "on" then AAR_DB.config.sync = true
    elseif SafeLower(rest) == "off" then AAR_DB.config.sync = false
    else Print("sync = " .. tostring(AAR_DB.config.sync)); return end
    Print("sync = " .. tostring(AAR_DB.config.sync))
    return
  end

  if cmd == "quiet" then
    if SafeLower(rest) == "on" then AAR_DB.config.quiet = true
    elseif SafeLower(rest) == "off" then AAR_DB.config.quiet = false
    else Print("quiet = " .. tostring(AAR_DB.config.quiet)); return end
    Print("quiet = " .. tostring(AAR_DB.config.quiet))
    return
  end

  if cmd == "mode" then
    local m = SafeLower(rest)
    if m == "weight" or m == "length" then AAR_DB.config.mode = m; Print("mode = " .. m)
    else Print("Use: /aar mode weight|length") end
    return
  end

  if cmd == "reset" then
    AAR_DB.catches = {}
    Print("personal catches cleared")
    return
  end

  if cmd == "clearall" then
    AAR_DB.catches = {}; AAR_DB.received = {}
    Print("personal + synced catches cleared")
    return
  end

  self:Help()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("CHAT_MSG_LOOT")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:RegisterEvent("CHAT_MSG_PARTY")
frame:RegisterEvent("CHAT_MSG_RAID")
frame:RegisterEvent("CHAT_MSG_GUILD")
frame:RegisterEvent("CHAT_MSG_SAY")

frame:SetScript("OnEvent", function()
  if event == "PLAYER_LOGIN" then
    InitDB()
    SeedRandom()
    if RegisterAddonMessagePrefix then RegisterAddonMessagePrefix(AAR.addonPrefix) end
    Print("loaded v0.1.2. /aar help")
  elseif event == "CHAT_MSG_LOOT" then
    AAR:OnLoot(arg1)
  elseif event == "CHAT_MSG_ADDON" then
    AAR:OnAddonMessage(arg1, arg2, arg3, arg4)
  elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_SAY" then
    AAR:OnChatAnnouncement(arg1, arg2)
  end
end)

SLASH_AZEROTHANGLERRECORDS1 = "/aar"
SLASH_AZEROTHANGLERRECORDS2 = "/angler"
SLASH_AZEROTHANGLERRECORDS3 = "/fishrecord"
SlashCmdList["AZEROTHANGLERRECORDS"] = function(msg) AAR:Command(msg) end
