--[[
--
-- Big Wigs Strategy Module for Instructor Razuvious in Naxxramas.
--
-- Adds timer bars and warning messages for the Understudies
-- Mind Exhaustion debuff, so priests know exactly when they are ready.
--
-- Also adds a timer bar for Taunt.
--
--]]

------------------------------
--      Are you local?      --
------------------------------

local myname = "Razuvious Assistant"
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..myname)
local boss = AceLibrary("Babble-Boss-2.0")("Instructor Razuvious")
local understudy = AceLibrary("Babble-Boss-2.0")("Deathknight Understudy")

local times = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "razassist",

	debuff_cmd = "debuff",
	debuff_name = "Mind Exhaustion Timer",
	debuff_desc = "Show timer bar for the Mind Exhaustion debuff",

	taunt_cmd = "taunt",
	taunt_name = "Taunt",
	taunt_desc = "Show timer bar for Taunt",

	taunt_bar = "Taunt",
	taunt_trigger = "Deathknight Understudy is afflicted by Taunt%.",

	mindexhaustion_bar = "%s - Exhaustion",
	mindexhaustion = "Mind Exhaustion",
	mindexhaustion_gone = "%s is ready for Mind Control!",
	mindexhaustion_5sec = "%s is ready in 5sec!",

	["raidIcon0"] = "Unknown",
	["raidIcon1"] = "Star",
	["raidIcon2"] = "Circle",
	["raidIcon3"] = "Diamond",
	["raidIcon4"] = "Triangle",
	["raidIcon5"] = "Moon",
	["raidIcon6"] = "Square",
	["raidIcon7"] = "Cross",
	["raidIcon8"] = "Skull",

	["raidColor0"] = "Red",
	["raidColor1"] = "Yellow",
	["raidColor2"] = "Orange",
	["raidColor3"] = "Purple",
	["raidColor4"] = "Green",
	["raidColor5"] = "White",
	["raidColor6"] = "Blue",
	["raidColor7"] = "Red",
	["raidColor8"] = "White",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazuviousAssistant = BigWigs:NewModule(myname)
BigWigsRazuviousAssistant.synctoken = myname
BigWigsRazuviousAssistant.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsRazuviousAssistant.enabletrigger = { boss, understudy }
BigWigsRazuviousAssistant.toggleoptions = { "debuff", "taunt" }
BigWigsRazuviousAssistant.revision = tonumber(string.sub("$Revision: 11365 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazuviousAssistant:OnEnable()
	times = {}

	self:RegisterEvent("SpecialEvents_UnitDebuffLost")
	self:RegisterEvent("SpecialEvents_UnitDebuffGained")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

------------------------------
--      Utility             --
------------------------------

function BigWigsRazuviousAssistant:GetRaidIconName(unitid)
	local iconIndex = GetRaidTargetIndex(unitid)
	if not iconIndex or not UnitExists(unitid) then return L["raidIcon0"], 0 end
	return L["raidIcon"..iconIndex], iconIndex
end

function BigWigsRazuviousAssistant:GetRaidIconColor(raidIconIndex)
	return L["raidColor"..raidIconIndex]
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazuviousAssistant:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsRazuviousAssistant:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.db.profile.taunt then return end
	if string.find(msg, L["taunt_trigger"]) then
		self:TriggerEvent("BigWigs_StartBar", self, L["taunt_bar"], 20, "Interface\\Icons\\Spell_Nature_Reincarnation", "Green", "Yellow", "Orange")
	end
end

function BigWigsRazuviousAssistant:SpecialEvents_UnitDebuffLost(unitid, debuffName)
	if self.db.profile.debuff and debuffName == L["mindexhaustion"] and UnitName(unitid) == understudy then
		local iconName, iconIndex = self:GetRaidIconName(unitid)
		-- Throttle by iconIndex, we will get many UnitDebuffLost events.
		if not times[iconIndex] or (times[iconIndex] + 5) <= GetTime() then
			self:TriggerEvent("BigWigs_Message", string.format(L["mindexhaustion_gone"], iconName), "Green")
			times[iconIndex] = GetTime()
		end
	end
end

function BigWigsRazuviousAssistant:SpecialEvents_UnitDebuffGained(unitid, debuffName, applications, debuffType, texture)
	if self.db.profile.debuff and debuffName == L["mindexhaustion"] and UnitName(unitid) == understudy then
		local iconName, iconIndex = self:GetRaidIconName(unitid)

		-- Throttle by iconIndex. We will get many UnitDebuffGained events.
		if not times[iconIndex] or (times[iconIndex] + 5) <= GetTime() then
			local icon = nil
			--if iconIndex > 0 then
			--	icon = UnitPopupButtons["RAID_TARGET_"..iconIndex].icon
			--else
				icon = "Interface\\Icons\\Spell_Shadow_Teleport"
			--end
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mindexhaustion_bar"], iconName), 60, icon, self:GetRaidIconColor(iconIndex))
			--if icon = "Interface\\Icons\\Spell_Shadow_Teleport" then
			--	local candyBar = AceLibrary("CandyBar-2.0")
			--	candyBar.var.handlers["BigWigsBar "..string.format(L["mindexhaustion_bar"], iconName)].frame.icon
			--end
			self:ScheduleEvent("bwrazassmcreadysoon"..iconIndex, "BigWigs_Message", 55, string.format(L["mindexhaustion_5sec"], iconName), "Green")

			times[iconIndex] = GetTime()
		end
	end
end

