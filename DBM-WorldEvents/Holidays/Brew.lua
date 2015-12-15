local mod	= DBM:NewMod("Brew", "DBM-WorldEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 14533 $"):sub(12, -3))
--mod:SetCreatureID(15467)
--mod:SetModelID(15879)
mod:SetReCombatTime(10)
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA"
)

--TODO. Add option to disable volume normalizing.
--TODO, ram racing stuff
--local warnCleave				= mod:NewSpellAnnounce(104903, 2)
--local warnStarfall			= mod:NewSpellAnnounce(26540, 3)

--local specWarnStarfall		= mod:NewSpecialWarningMove(26540)

--local timerCleaveCD			= mod:NewCDTimer(8.5, 104903, nil, nil, nil, 6)
--local timerStarfallCD			= mod:NewCDTimer(15, 26540, nil, nil, nil, 2)

mod:RemoveOption("HealthFrame")
mod:AddBoolOption("NormalizeVolume", true, "misc")

local setActive = false
local function CheckEventActive()
	local _, month, day, year = CalendarGetDate()
	if month == 9 then
		if day >= 20 then
			setActive = true
		end
	elseif month == 10 then
		if day < 7 then
			setActive = true
		end
	end
end
CheckEventActive()

--Volume normalizing or disabling for blizzard stupidly putting the area's music on DIALOG audio channel, making it blaringly loud
local function setDialog(self, set)
	if not self.Options.NormalizeVolume then return end
	if set then
		local musicEnabled = GetCVarBool("Sound_EnableMusic") or true
		local musicVolume = tonumber(GetCVar("Sound_MusicVolume"))
		self.Options.SoundOption = tonumber(GetCVarBool("Sound_DialogVolume")) or 1
		if musicEnabled and musicVolume then--Normalize volume to music volume level
			DBM:Debug("Setting normalized volume to music volume of: "..musicVolume)
			SetCVar("Sound_DialogVolume", musicVolume)
		else--Just mute it
			DBM:Debug("Setting normalized volume to 0")
			SetCVar("Sound_DialogVolume", 0)
		end
	else
		if self.Options.SoundOption then
			DBM:Debug("Restoring Dialog volume to saved value of: "..self.Options.SoundOption)
			SetCVar("Sound_DialogVolume", self.Options.SoundOption)
			self.Options.SoundOption = nil
		end
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	if setActive then
		local set_Z = GetCurrentMapAreaID()
		SetMapToCurrentZone()
		local true_Z = GetCurrentMapAreaID()
		if WorldMapFrame:IsVisible() then
			SetMapByID(set_Z)
		end
		if true_Z == 27 or true_Z == 4 then--Dun Morogh, Durotar
			setDialog(self, true)
		else
			setDialog(self)
		end
	else
		--Even if event isn't active. If a sound option was stored, restore it
		if self.Options.SoundOption then
			setDialog(self)
		end
	end
end
mod.OnInitialize = mod.ZONE_CHANGED_NEW_AREA

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 104903 then
		warnCleave:Show()
		timerCleaveCD:Start()
	elseif spellId == 26540 then
		warnStarfall:Show()
		timerStarfallCD:Start()
	end
end
--]]