--[[
--
-- BigWigs Strategy Module for Loatheb in Naxxramas.
--
-- Creates a list of the healers and sorts them according
-- to when they should heal.
--
--]]

------------------------------
--      Are you local?      --
------------------------------

local myname = "Healbot Assist"
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..myname)
local boss = AceLibrary("Babble-Boss-2.0")("Loatheb")

local tablet = AceLibrary("Tablet-2.0")
local roster = nil
local healerChannel = nil
local ignoreList = nil

local COLOR_GREEN = "00ff00"
local COLOR_WHITE = "ffffff"
local COLOR_RED = "ff0000"
local COLOR_GREY = "aaaaaa"

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "healbotassist",

	bar_cmd = "bar",
	bar_name = "Corrupted Mind Bar",
	bar_desc = "Show bar for your own Corrupted Mind debuff.",

	healnotify_cmd = "notify",
	healnotify_name = "Notify heals",
	healnotify_desc = "Sends a raid warning about who healed and who is next.",

	notwhisper_cmd = "notwhisper",
	notwhisper_name = "Do NOT whisper healing rotation",
	notwhisper_desc = "Toggles whispering the next one and the one after him to heal and get ready.",

	bar_text = "Corrupted Mind",

	slash_cmd = "/bwhba",
	slash_desc = "Options for Big Wigs Healbot Assist.",

	tabletshow_cmd = "show",
	tabletshow_desc = "Shows the list of healers.",
	tablethide_cmd = "hide",
	tablethide_desc = "Hides the list of healers.",
	setchannel_cmd = "channel",
	setchannel_desc = "Sets the channel to spam healing messages in.",

	["Big Wigs Healbot Assist"] = true,
	["Healer"] = true,
	["Timer"] = true,
	["You have received a healer list for Loatheb from %s, accept this list?"] = true,
	["Yes"] = true,
	["No"] = true,
	["Ready"] = true,
	["Next"] = true,
	["Corrupted Mind"] = true,
	["The leader will automatically whisper the next one in line when to heal."] = true,
	["Get ready!"] = true,
	["Heal now!"] = true,
	["[BWHBA] You are the first healer, heal when ready."] = true,
	["[BWHBA] You are the second healer, heal when you get the message."] = true,
	["%s healed - %s is next!"] = true,
	["<channelname>"] = true,
	["You are NOT in a healer channel. Please set one using /bwhba setchannel <channelname>."] = true,
	["Everyone has debuff!"] = true,
	["Your announce channel is set to %s."] = true,
	["Healing rotation is set to: %s - you will get whispers when to heal."] = true,
	["The channel %s was not found, please set a healer channel with /bwhba setchallen <channelname>."] = true,
	["Offline"] = true,
	["Dead"] = true,
	["Healer list not populated yet, please click here to do so now."] = true,
	["Commands"] = true,
	["Print rotation to raidchat"] = true,
	["Re-scan healers"] = true,
	["Ignore target"] = true,
	["Healer list refreshed."] = true,
	["%s will be blocked from healing rotation."] = true,
	["%s can be in healing rotation."] = true,
	["Healing rotation: %s."] = true,
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHealbotAssist = BigWigs:NewModule(myname, "AceConsole-2.0")
BigWigsHealbotAssist.synctoken = myname
BigWigsHealbotAssist.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsHealbotAssist.enabletrigger = { boss  }
BigWigsHealbotAssist.toggleoptions = { "healnotify", "notwhisper", "bar" }
BigWigsHealbotAssist.revision = tonumber(string.sub("$Revision: 11366 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHealbotAssist:OnInitialize()
	self:RegisterChatCommand({ L["slash_cmd"] }, {
		type = "group",
		args = {
			show = {
				type = "execute", name = L["tabletshow_cmd"],
				desc = L["tabletshow_desc"],
				func = function() self:ShowTablet() end,
			},
			hide = {
				type = "execute", name = L["tablethide_cmd"],
				desc = L["tablethide_desc"],
				func = function() self:HideTablet() end,
			},
			setchannel = {
				type = "text", name = L["setchannel_cmd"],
				desc = L["setchannel_desc"],
				set = function(v) self:SetChannel(v) end,
				get = false,
				usage = L["<channelname>"],
			},
			--[[ignore = {
				type = "text", name = L["ignore_cmd"],
				desc = L["ignore_desc"],
				set = function(v) self:IgnoreCmd(v) end,
				get = function() self:PrintIgnore() end
				usage = 
			}]]
		},
	})
end

function BigWigsHealbotAssist:OnEnable()
	if not roster then roster = AceLibrary("RosterLib-2.0") end
	if not healerChannel then healerChannel = self.db.profile.healerChannel end

	if not healerChannel then
		self:Print(L["You are NOT in a healer channel. Please set one using /bwhba setchannel <channelname>."])
	else
		self:Print(string.format(L["Your announce channel is set to %s."], healerChannel))
	end

	self.playerName = UnitName("player")
	self:RegisterEvent("SEEAEO_UnitDebuffLost")
	self:RegisterEvent("SEEAEO_UnitDebuffGained")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	-- XXX self.healerList
	-- XXX broadcast with
	-- ["Healing rotation is set to: %s - you will get whispers when to heal."]

	self:ShowTablet()
end

function BigWigsHealbotAssist:OnDisable()
	roster = nil

	self:HideTablet()
end

------------------------------
--      Events              --
------------------------------

function BigWigsHealbotAssist:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

------------------------------
--      Tablet              --
------------------------------

function BigWigsHealbotAssist:OnTooltipUpdate()
	if not tablet:IsRegistered("BigWigs_HealbotAssist") then return end

	local cat = tablet:AddCategory(
		"columns", 3,
		"text", "#",
		"text2", L["Healer"],
		"text3", L["Timer"],
		"child_justify1", "LEFT",
		"child_justify2", "LEFT",
		"child_justify3", "RIGHT"
	)
	local counter = 1

	-- Find the first unit.
	-- XXX Use self.healerList
	local unit = nil
	local firstUnit = nil
	for n, u in pairs(roster.roster) do
		if u and u.name and u.class ~= "PET" and u.inHealbotRotation and u.isFirstInRotation then
			firstUnit = u
			break
		end
	end
	unit = firstUnit

	local addMore = true
	while addMore and unit do
		local unitName = unit.name
		local statusLine = nil
		-- This overwrites the rgb values given in addline, and green is not
		-- used by any healer class.
		if unitName == self.playerName then unitName = "|cff"..COLOR_GREEN..unitName.."|r" end
		if UnitIsDeadOrGhost(unit.unitid) then
			statusLine = "|cff"..COLOR_GREY..L["Dead"].."|r"
		elseif not UnitIsConnected(unit.unitid) then
			statusLine = "|cff"..COLOR_GREY..L["Offline"].."|r"
		elseif unit.healbotDebuffTimer then
			statusLine = "|cff"..COLOR_RED..unit.healbotDebuffTimer.."|r"
		else
			statusLine = "|cff"..COLOR_GREEN..L["Ready"].."|r"
		end
		cat:AddLine("text", "|cff"..COLOR_WHITE..tostring(counter).."|r",
					"text2", unitName,
					"text2R", RAID_CLASS_COLORS[unit.class].r,
					"text2G", RAID_CLASS_COLORS[unit.class].g,
					"text2B", RAID_CLASS_COLORS[unit.class].b,
					"text3", statusLine)
		counter = counter + 1
		if firstUnit.name == unit.nextInRotation or counter == 40 then
			addMore = false
			break
		else
			unit = roster:GetUnitObjectFromName(unit.nextInRotation)
		end
	end

	if counter == 1 then
		local cat = tablet:AddCategory("columns", 1)
		cat:AddLine("text", L["Healer list not populated yet, please click here to do so now."],
					"func", function() self:CreateHealerList() end)
	end
	local cat2 = tablet:AddCategory("columns", 1, "text", L["Commands"], "child_justify1", "CENTER")
	if IsRaidOfficer() or IsRaidLeader() then
		cat2:AddLine(
				"text", L["Print rotation to raidchat"],
				"func", function() self:PrintRotation() end)
	end
	cat2:AddLine(
			"text", L["Re-scan healers"],
			"func", function() self:CreateHealerList() end)
	cat2:AddLine(
			"text", L["Ignore target"],
			"func", function() self:IgnoreTarget() end)

	tablet:SetHint(L["The leader will automatically whisper the next one in line when to heal."])
end

function BigWigsHealbotAssist:ShowTablet()
	if not tablet:IsRegistered("BigWigs_HealbotAssist") then
		tablet:Register("BigWigs_HealbotAssist",
			"children",
				function()
					tablet:SetTitle(L["Big Wigs Healbot Assist"])
					self:OnTooltipUpdate()
				end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true
		)
	end

	if not self:IsEventScheduled("bwhbaupdate") then
		self:ScheduleRepeatingEvent("bwhbaupdate", function() tablet:Refresh("BigWigs_HealbotAssist") end, 1)
	end

	if tablet:IsAttached("BigWigs_HealbotAssist") then
		tablet:Detach("BigWigs_HealbotAssist")
	end
end

function BigWigsHealbotAssist:HideTablet()
	if not tablet:IsRegistered("BigWigs_HealbotAssist") then return end

	self:CancelScheduledEvent("bwhbaupdate")

	tablet:Attach("BigWigs_HealbotAssist")
end

------------------------------
--      Roster              --
------------------------------

function BigWigsHealbotAssist:IgnoreTarget()
	if not UnitExists("target") then return end
	local unit = roster:GetUnitObjectFromName(UnitName("target"))
	if not unit then return end
	if unit.bwhbaIgnore then
		unit.bwhbaIgnore = nil
		self:Print(string.format(L["%s can be in healing rotation."], unit.name))
	else
		unit.bwhbaIgnore = true
		self:Print(string.format(L["%s will be blocked from healing rotation."], unit.name))
	end	
end

function BigWigsHealbotAssist:CreateHealerList()
	local firstunit = nil
	local lastunit = nil

	for n, u in pairs(roster.roster) do
		u.healbotDebuffTimer = nil
		u.nextInRotation = nil
	end

	for n, u in pairs(roster.roster) do
		if u and u.name and u.class ~= "PET" then
			if (u.class == "PRIEST" or u.class == "DRUID" or u.class == "SHAMAN" or u.class == "PALADIN") and not u.bwhbaIgnore then
				u.inHealbotRotation = true
				if lastunit then
					u.nextInRotation = lastunit.name
				else
					-- this is the first unit.
					if not self.db.profile.notwhisper then
						self:TriggerEvent("BigWigs_SendTell", u.name, L["[BWHBA] You are the first healer, heal when ready."])
					end
					firstunit = u
					u.isFirstInRotation = true
				end
				lastunit = u
			else
				u.inHealbotRotation = nil
			end
			u.healbotDebuffTimer = nil
		end
	end
	if firstunit and lastunit then
		firstunit.nextInRotation = lastunit.name
		if not self.db.profile.notwhisper then
			self:TriggerEvent("BigWigs_SendTell", lastunit.name, L["[BWHBA] You are the second healer, heal when you get the message."])
		end
	end

	if tablet:IsRegistered("BigWigs_HealbotAssist") then
		tablet:Refresh("BigWigs_HealbotAssist")
	end

	self:Print(L["Healer list refreshed."])
	-- XXX Populate self.healerList
end

------------------------------
--      Messages            --
------------------------------

function BigWigsHealbotAssist:PrintRotation()
	local healers = nil
	local counter = 1
	local unit = nil
	local firstUnit = nil
	for n, u in pairs(roster.roster) do
		if u and u.name and u.class ~= "PET" and u.inHealbotRotation and u.isFirstInRotation then
			firstUnit = u
			break
		end
	end
	unit = firstUnit

	local more = true
	while more and unit do
		if not healers then
			healers = unit.name
		else
			healers = healers..", "..unit.name
		end
		counter = counter + 1
		if firstUnit.name == unit.nextInRotation or counter == 40 then
			more = false
			break
		else
			unit = roster:GetUnitObjectFromName(unit.nextInRotation)
		end
	end

	if not healers then return end
	SendChatMessage(string.format(L["Healing rotation: %s."], healers), "RAID", nil, nil)
end

function BigWigsHealbotAssist:SetChannel(channelName)
	self.db.profile.healerChannel = channelName
	healerChannel = channelName
end

-- Finds the next healer with the least remaining on his debuff
-- in case everyone has debuff.
function BigWigsHealbotAssist:FindLowestDebuffTimer()
	local readySoon = 60
	local unit = nil
	for n, u in pairs(roster.roster) do
		if u.inHealbotRotation then
			if u.healbotDebuffTimer then
				if u.healbotDebuffTimer < readySoon then
					unit = u
					readySoon = u.healbotDebuffTimer
				end
			else
				unit = u
				break
			end
		end
	end
	return unit
end

function BigWigsHealbotAssist:FindNextUnit(aUnit)
	-- Traverse the nextInRotation chain until we find someone that is ready to
	-- heal.
	local unit = aUnit
	while not unit.inHealbotRotation or unit.healbotDebuffTimer or UnitIsDeadOrGhost(unit.unitid) or not UnitIsConnected(unit.unitid)    do
		-- the current unit can not be in rotation for some reason, which is
		-- also true for the first unit object we get in.
		unit = roster:GetUnitObjectFromName(unit.nextInRotation)
		if unit.unitid == aUnit.unitid then break end
	end
	-- If we're back at the original unit we got in, try to find the one with
	-- the lowest debuff.
	if unit.unitid == aUnit.unitid then
		-- Heh, this is the same unit that we got in at first,
		-- apparently there's noone left to heal. Get more healers!
		--self:TriggerEvent("BigWigs_Message", L["Everyone has debuff!"], "Red")
		unit = self:FindLowestDebuffTimer()
	end
	return unit
end

function BigWigsHealbotAssist:Whisper(unit)
	-- unit is the unit that just got the debuff.
	local firstUnitName = unit.name
	local nextUnit = self:FindNextUnit(unit)

	if not self.db.profile.notwhisper then
		local getReadyUnit = roster:GetUnitObjectFromName(nextUnit.nextInRotation)
		if UnitIsDeadOrGhost(getReadyUnit.unitid) or not UnitIsConnected(getReadyUnit.unitid) then
			getReadyUnit = self:FindNextUnit(getReadyUnit)
		end

		-- ZZZ unit here should be someone that can heal.
		-- ZZZ nextHealer is the one scheduled to go next after that one.
		self:TriggerEvent("BigWigs_SendTell", nextUnit.name, L["Heal now!"])
		self:TriggerEvent("BigWigs_SendTell", getReadyUnit.name, L["Get ready!"])
	end

	if self.db.profile.healnotify and healerChannel and (IsRaidOfficer() or IsRaidLeader()) then
		local id, name = GetChannelName(healerChannel)
		if name then
			SendChatMessage(string.format(L["%s healed - %s is next!"], firstUnitName, nextUnit.name), "CHANNEL", nil, id)
		else
			-- yeah this will spam. Good luck without a healer channel.
			self:Print(string.format(L["The channel %s was not found, please set a healer channel with /bwhba setchallen <channelname>."], healerChannel))
		end
	end
end

------------------------------
--      Buff handling       --
------------------------------

function BigWigsHealbotAssist:DecrementCounter(unit)
	unit.healbotDebuffTimer = unit.healbotDebuffTimer - 1
end

function BigWigsHealbotAssist:SEEAEO_UnitDebuffGained(unitid, debuffName, applications, debuffType, texture)
	if debuffName == L["Corrupted Mind"] and texture == "Interface\\Icons\\Spell_Shadow_AuraOfDarkness" then
		local unit = roster:GetUnitObjectFromUnit(unitid)
		if unit and unit.inHealbotRotation and not unit.healbotDebuffTimer then
			if (unitid == "player" or UnitIsUnit("player", unitid)) and self.db.profile.bar then
				self:TriggerEvent("BigWigs_StartBar", self, L["bar_text"], 60, texture, "Red")
			end
			unit.healbotDebuffTimer = 60
			self:ScheduleRepeatingEvent("bwhbaunitdebuff"..unit.name, self.DecrementCounter, 1, self, unit)
			self:Whisper(unit)
		end
	end
end

function BigWigsHealbotAssist:SEEAEO_UnitDebuffLost(unitid, debuffName)
	if debuffName == L["Corrupted Mind"] and string.find(unitid, "raid%d+$") then
		local unit = roster:GetUnitObjectFromUnit(unitid)
		if unit and unit.inHealbotRotation and unit.healbotDebuffTimer then
			unit.healbotDebuffTimer = nil
			self:CancelScheduledEvent("bwhbaunitdebuff"..unit.name)
		end
	end
end

