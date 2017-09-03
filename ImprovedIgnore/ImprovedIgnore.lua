--[[
ImprovedIgnore.lua
by Yrys - Hellscream <yrysremove at twparemove dot net>
by Two - Updated to add unlimited ignore functionality

Improved functionality for ignore.  Ignored players show up as red on
who lists, and sending a tell to a player on ignore will optionally either
auto-remove that player from your ignore list, or block the tell.

]]

-- Variables.
IIGNORE_VER = "1.12.1.2"
local SendChatMessage_Orig = nil

local defaultFrame = DEFAULT_CHAT_FRAME
local defaultWrite = DEFAULT_CHAT_FRAME.AddMessage
local log = function(text, r, g, b, group, holdTime)
  defaultWrite(defaultFrame, tostring(text), r, g, b, group, holdTime)
end

local hookChatFrame = function(frame)
  if (not frame) then return end
  
  local original = frame.AddMessage
  if (original) then
    frame.AddMessage = function(t, message, ...)
      local found, _, channel, player = string.find(message, "^%[([^%]]+)%].*|Hplayer:([^|]+)|h")
      if (not found) then
        found, _, player = string.find(message, "|Hplayer:([^|]+)|h.*"..STR_IIGNORE_LOCALIZATION_WHISPERS..":")
        if (found) then 
          channel = STR_IIGNORE_CHANNEL_WHISPER 
        end
      end
      if (found and player and channel) then
        if (ImprovedIgnore_IsPlayerIgnored(player) and not ImprovedIgnore_DoBypassChannel(channel)) then
          return
        end
      end
      original(t, message, unpack (arg))
    end
  else
    log("Tried to hook non-chat frame")
  end
end

local fixPlayerName = function(player)
  local _, _, first, remaining = string.find(player, "^(.)(.+)")
  return string.upper(first or "")..string.lower(remaining or "")
end

local guessChannelName = function(channel)
  for c,s in pairs(ImprovedIgnore_BypassChannel) do
    if (string.lower(c) == string.lower(channel)) then
      return c
    end
  end
  return channel
end

function ImprovedIgnore_IsPlayerIgnored(player)
  if (player and ImprovedIgnore_List[fixPlayerName(player)]) then
    return true
  else 
	  return false
  end
end

function ImprovedIgnore_AddToIgnore(player, reason)
  ImprovedIgnore_List[fixPlayerName(player)] = reason or ""
end

function ImprovedIgnore_RemoveFromIgnore(player)
  ImprovedIgnore_List[fixPlayerName(player)] = nil
end

function ImprovedIgnore_SetBypassChannel(channel, setting)
  if (channel and STR_IIGNORE_CHANNEL_SETTING[setting]) then    
    ImprovedIgnore_BypassChannel[guessChannelName(channel)] = setting
  else
    return nil
  end
end

function ImprovedIgnore_DoBypassChannel(channel)
  return (ImprovedIgnore_BypassChannel[channel] == STR_IIGNORE_ALLOW)
end

function ImprovedIgnore_OnLoad()
  this:RegisterEvent("VARIABLES_LOADED")

	-- Set up slash commands.
	SlashCmdList["IMPROVEDIGNORE"] = ImprovedIgnore_CmdRelay
	SLASH_IMPROVEDIGNORE1 = "/ii"
	SLASH_IMPROVEDIGNORE2 = "/improvedignore"
end

local copyPlayerIgnoreEntries = function()
  local ignoredPlayer
  local numIgnores = GetNumIgnores()
  local toDelete = {}
  if numIgnores then
		for n = 1, numIgnores do
      ignoredPlayer = GetIgnoreName(n)
      if (not ImprovedIgnore_IsPlayerIgnored(ignoredPlayer)) then
        ImprovedIgnore_AddToIgnore(ignoredPlayer)
        log(string.format(STR_IIGNORE_FUNC_COPYFROMLIST, tostring(ignoredPlayer)))
			end
      table.insert(toDelete, ignoredPlayer)
		end
    for n, name in ipairs(toDelete) do
      DelIgnore(name)
    end
	end
end

local hookFunctions = function()
  if SendChatMessage ~= ImprovedIgnore_SendChatMessage then
		SendChatMessage_Orig = SendChatMessage
		SendChatMessage = ImprovedIgnore_SendChatMessage
	end
  
  hookChatFrame(ChatFrame1)
  hookChatFrame(ChatFrame2)
  hookChatFrame(ChatFrame3)
  hookChatFrame(ChatFrame4)
  hookChatFrame(ChatFrame5)
  hookChatFrame(ChatFrame6)
  hookChatFrame(ChatFrame7)
end

local initialize = function()
  ImprovedIgnore_List = ImprovedIgnore_List or {}
  ImprovedIgnore_Settings = ImprovedIgnore_Settings or { 
    whisper = STR_IIGNORE_ALLOW    
  }
  if (not STR_IIGNORE_WHISPER_SETTING[ImprovedIgnore_Settings.whisper]) then
    ImprovedIgnore_Settings.whisper = STR_IIGNORE_ALLOW
  end
  ImprovedIgnore_BypassChannel = ImprovedIgnore_BypassChannel or {
    [STR_IIGNORE_CHANNEL_PARTY] = STR_IIGNORE_ALLOW,
    [STR_IIGNORE_CHANNEL_RAID] = STR_IIGNORE_ALLOW,
    [STR_IIGNORE_CHANNEL_RAIDLEAD] = STR_IIGNORE_ALLOW,
    [STR_IIGNORE_CHANNEL_OFFICER] = STR_IIGNORE_ALLOW,
  } 
  copyPlayerIgnoreEntries()
  hookFunctions()
  
	log(string.format(STR_IIGNORE_FUNC_LOADED, IIGNORE_VER))
end

-- Event handler.  Checks for non-WhoFrame /whos.
function ImprovedIgnore_OnEvent()
	if (event == "VARIABLES_LOADED") then
    initialize()
	end
end

local printStatusWhispers = function()
  log(STR_IIGNORE_STATUS_WHISPER.." "..STR_IIGNORE_WHISPER_SETTING[ImprovedIgnore_Settings.whisper])
end

local printStatusChannels = function()
  log(STR_IIGNORE_STATUS_CHANNELS)
  for channel, setting in ImprovedIgnore_BypassChannel do
    log(string.format("  %s: %s", tostring(channel), setting))
  end
end

local commands = setmetatable({
  [STR_IIGNORE_COMMAND_STATUS] = function()
    log(STR_IIGNORE_STATUS_HEADER)
    printStatusWhispers()
    printStatusChannels()  
  end,
  
  [STR_IIGNORE_COMMAND_WHISPER] = function(args)
    if (STR_IIGNORE_WHISPER_SETTING[args]) then
      ImprovedIgnore_Settings.whisper = args
      printStatusWhispers()
    else
      log(STR_IIGNORE_HELP_WHISPER)
    end
  end,
  
  [STR_IIGNORE_COMMAND_ADD] = function(args)
    local found, _, name, reason = string.find(args, "^%s*(%S+)%s?(.*)")
    if (found) then
      name = fixPlayerName(name)
      ImprovedIgnore_AddToIgnore(name, reason)
      log(string.format(STR_IIGNORE_STATUS_ADDED, name))
    else
      log(STR_IIGNORE_HELP_ADD)
    end
  end,
  
  [STR_IIGNORE_COMMAND_REMOVE] = function(name)
    if (name and not string.find(name, " ")) then
      name = fixPlayerName(name)
      if (ImprovedIgnore_IsPlayerIgnored(name)) then
        ImprovedIgnore_RemoveFromIgnore(name)
        log(string.format(STR_IIGNORE_STATUS_REMOVED, name))
      else
        log(string.format(STR_IIGNORE_STATUS_NOT_REMOVED, name))
      end
    else
      log(STR_IIGNORE_HELP_REMOVE)
    end
  end,
  
  [STR_IIGNORE_COMMAND_LIST] = function()
    local ignoredWithoutReason = {}
    log(STR_IIGNORE_STATUS_LIST)
    for player, reason in pairs(ImprovedIgnore_List) do
      if (reason and (string.len(reason) > 0)) then
        log(player.." - "..reason)
      else 
        table.insert(ignoredWithoutReason, player)
      end
    end
    log(table.concat(ignoredWithoutReason, ", "))
  end,
  
  [STR_IIGNORE_COMMAND_ALLOW] = function(channel)
    if (channel) then
      channel = guessChannelName(channel)
      ImprovedIgnore_SetBypassChannel(channel, STR_IIGNORE_ALLOW)
      log(channel..": "..STR_IIGNORE_ALLOW)
    else
      log(STR_IIGNORE_HELP_ALLOW_CHANNEL)
    end
  end,
  
  [STR_IIGNORE_COMMAND_DENY] = function(channel)
    if (channel) then
      channel = guessChannelName(channel)
      ImprovedIgnore_SetBypassChannel(channel, STR_IIGNORE_DENY)
      log(channel..": "..STR_IIGNORE_DENY)
    else
      log(STR_IIGNORE_HELP_DENY_CHANNEL)
    end
  end,
  
}, {
  __index = function()
    return function()
      log(string.format(STR_IIGNORE_HELP_HEADER, IIGNORE_VER))
      log(STR_IIGNORE_HELP_STATUS)
      log(STR_IIGNORE_HELP_WHISPER)
      log(STR_IIGNORE_HELP_ADD)
      log(STR_IIGNORE_HELP_REMOVE)
      log(STR_IIGNORE_HELP_LIST)
      log(STR_IIGNORE_HELP_ALLOW_CHANNEL)
      log(STR_IIGNORE_HELP_DENY_CHANNEL)
    end
  end
})

-- Command-line handler.  Passes to other functions.
function ImprovedIgnore_CmdRelay(args)
	if args then
		_, _, cmd, subargs = string.find (args, "^([^ ]-) (.+)$")
		if not cmd then
			cmd = args
		end
    commands[string.lower(cmd)](subargs)
	end
end

-- Check for ignored players on sending a whisper.
function ImprovedIgnore_SendChatMessage (msg, ...)
	local system, language, player = unpack (arg)
  
  if ImprovedIgnore_IsPlayerIgnored(player) then
    if system == "WHISPER" and player then
      if ImprovedIgnore_Settings.whisper == STR_IIGNORE_REMOVE then
        log(string.format (STR_IIGNORE_WHISPER_REMOVE, player), 1.0, 0.2, 0.2)
        ImprovedIgnore_RemoveFromIgnore(player)
      elseif ImprovedIgnore_Settings.whisper == STR_IIGNORE_DENY then
        log(string.format(STR_IIGNORE_WHISPER_DENY, player), 1.0, 0.3, 0.3)
        return
      elseif (ImprovedIgnore_Settings.whisper == STR_IIGNORE_ALLOW) then
        log(string.format(STR_IIGNORE_WHISPER_ALLOW, player), 1.0, 0.3, 0.3)
      end
    end
  end 
  SendChatMessage_Orig (msg, unpack (arg))
end
