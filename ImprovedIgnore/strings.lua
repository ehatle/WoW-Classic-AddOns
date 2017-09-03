--[[
strings.lua

Strings for ImprovedIgnore.  Makes for easy editing and localization.
]]

-- Generic strings
STR_IIGNORE_ALLOW = "allow"
STR_IIGNORE_DENY = "deny"
STR_IIGNORE_REMOVE = "remove"
STR_IIGNORE_LOCALIZATION_WHISPERS = "whispers" -- localized version of "[Player] whispers:"

-- Generic function strings.
STR_IIGNORE_FUNC_LOADED = "ImprovedIgnore %s loaded. Type /ii for help."
STR_IIGNORE_WHISPER_REMOVE = "%s was on your ignore list and has just been removed."
STR_IIGNORE_WHISPER_DENY = "%s is on your ignore list, whisper has been aborted."
STR_IIGNORE_WHISPER_ALLOW = "%s is on your ignore list, you will not see any answers."
STR_IIGNORE_FUNC_COPYFROMLIST = "Added %s from Blizzard ignore list"

-- Help strings.
STR_IIGNORE_HELP_HEADER = "ImprovedIgnore %s."
STR_IIGNORE_HELP_STATUS = "/ii status - Displays the current settings."
STR_IIGNORE_HELP_WHISPER = "/ii whisper <"..STR_IIGNORE_ALLOW.."/"..STR_IIGNORE_DENY.."/"..STR_IIGNORE_REMOVE.."> - What should happen if you whisper to an ignored player?"
STR_IIGNORE_HELP_ADD = "/ii add <name> <reason> - Adds a player to ignore list optionally with a reason"
STR_IIGNORE_HELP_REMOVE = "/ii remove <name> - Removes a player from the ignore list"
STR_IIGNORE_HELP_LIST = "/ii list - Shows a list of all ignored players"
STR_IIGNORE_HELP_ALLOW_CHANNEL = "/ii allow <channel name> - Bypass ignore list on this channel."
STR_IIGNORE_HELP_DENY_CHANNEL = "/ii deny <channel name> - (default) Ignore players on this channel."

-- Status strings.
STR_IIGNORE_STATUS_HEADER = "ImprovedIgnore status:"
STR_IIGNORE_STATUS_CHANNELS = "Channel bypass settings:"
STR_IIGNORE_CHANNEL_SETTING = { [STR_IIGNORE_ALLOW] = STR_IIGNORE_ALLOW, [STR_IIGNORE_DENY] = STR_IIGNORE_DENY }
STR_IIGNORE_STATUS_WHISPER = "Whispers to ignored players:"
STR_IIGNORE_WHISPER_SETTING = { [STR_IIGNORE_ALLOW] = STR_IIGNORE_ALLOW, [STR_IIGNORE_DENY] = STR_IIGNORE_DENY, [STR_IIGNORE_REMOVE] = STR_IIGNORE_REMOVE }
STR_IIGNORE_STATUS_LIST = "The following players are on your ignore list:"
STR_IIGNORE_STATUS_ADDED = "Added %s to ignore list."
STR_IIGNORE_STATUS_REMOVED = "Removed %s from ignore list."
STR_IIGNORE_STATUS_NOT_REMOVED = "%s is not on your ignore list."

-- Channel names
STR_IIGNORE_CHANNEL_PARTY = "Party"
STR_IIGNORE_CHANNEL_RAID = "Raid"
STR_IIGNORE_CHANNEL_RAIDLEAD = "Raid Leader"
STR_IIGNORE_CHANNEL_OFFICER = "Officer"
STR_IIGNORE_CHANNEL_WHISPER = "Whisper"

-- Command-line and setting strings.
STR_IIGNORE_COMMAND_STATUS = "status"
STR_IIGNORE_COMMAND_WHISPER = "whisper"
STR_IIGNORE_COMMAND_ADD = "add"
STR_IIGNORE_COMMAND_REMOVE = "remove"
STR_IIGNORE_COMMAND_LIST = "list"
STR_IIGNORE_COMMAND_ALLOW = "allow"
STR_IIGNORE_COMMAND_DENY = "deny"
