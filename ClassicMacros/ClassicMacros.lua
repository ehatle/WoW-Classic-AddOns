SLASH_USE1 = "/use"
SLASH_CASTRANDOM1 = "/castrandom"
SLASH_STOPCASTING1 = "/stopcasting"

SLASH_CANCELFORM1 = "/cancelform"
SLASH_CANCELAURA1 = "/cancelaura"

SLASH_STARTATTACK1 = "/startattack"
SLASH_STOPATTACK1 = "/stopattack"

SLASH_PETAGGRESSIVE1 = "/petaggressive"
SLASH_PETPASSIVE1 = "/petpassive"
SLASH_PETDEFENSIVE1 = "/petdefensive"
SLASH_PETATTACK1 = "/petattack"
SLASH_PETFOLLOW1 = "/petfollow"
SLASH_PETSTAY1 = "/petstay"

SLASH_CLEARTARGET1 = "/cleartarget"
SLASH_LASTTARGET1 = "/lasttarget"

SLASH_CLEARFOCUS1 = "/clearfocus"
SLASH_FOCUS1 = "/focus"
SLASH_TARGETFOCUS1 = "/targetfocus"

local focus = ""
local _,playerClass = UnitClass("player")
local isAttacking
local watchframe = CreateFrame("Frame")
local scantip = CreateFrame("GameTooltip", "scantip", nil, "GameTooltipTemplate")
watchframe:RegisterEvent("PLAYER_ENTER_COMBAT")
watchframe:RegisterEvent("PLAYER_LEAVE_COMBAT")
scantip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function onEvent()
	if event == "PLAYER_ENTER_COMBAT" then
		isAttacking = 1
		IsCasting = 0
		startspam = nil
	else
		isAttacking = nil
		stopspam = nil
	end
end

local function strsplit(pString, pPattern)
	local Table = {}
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = strfind(pString, fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		last_end = e+1
		s, e, cap = strfind(pString, fpat, last_end)
	end
	if last_end <= strlen(pString) then
		cap = strsub(pString, last_end)
		table.insert(Table, cap)
	end
	return Table
end

function SlashCmdList.USE(msg, editbox)
	for i=0, 19 do
		scantip:ClearLines()
		scantip:SetInventoryItem("player",i)
		if scantipTextLeft1:GetText() == msg then
			UseInventoryItem(i)
			return
		end
	end
	for i=0, 4 do
		for z=1, GetContainerNumSlots(i) do
			scantip:ClearLines()
			scantip:SetBagItem(i,z)
			local itemName
			itemName = scantipTextLeft1:GetText()
			if itemName == msg then
				UseContainerItem(i, z)
				return
			end
		end
	end
end

function SlashCmdList.CASTRANDOM(msg, editbox)
	if msg == "" then
		return
	end
	local tbl = strsplit(msg, ",")
	local spell = tbl[math.random(1,getn(tbl))]
	while strsub(spell,1,1) == " " do
		spell = strsub(spell,2)
	end
	while strsub(spell,strlen(spell)) == " " do
		spell = strsub(spell, 1, (strlen(spell)-1))
	end
	CastSpellByName(spell)
end

function SlashCmdList.STOPCASTING(msg, editbox)
	SpellStopCasting()
end

function SlashCmdList.CANCELFORM(msg, editbox)
	if not (playerClass == "DRUID" or playerClass == "ROGUE") then
		return
	end
	for i=1, GetNumShapeshiftForms() do
		local icon, name, active = GetShapeshiftFormInfo(i)
		if active then
			CastShapeshiftForm(i)
		end
	end
end

function SlashCmdList.CANCELAURA(msg, editbox)
	local i=1
	while UnitBuff("player",i) do
		scantip:SetUnitBuff("player", i)
		local buffName = scantipTextLeft1:GetText()
		if buffName == msg then
			CancelPlayerBuff(GetPlayerBuff(i-1,"HELPFUL"))
			return
		end
		i = i+1
	end
end

function SlashCmdList.STARTATTACK(msg, editbox)
	if not isAttacking or not UnitExists("target") then
		AttackTarget()
		isAttacking = 1
	else
		local assist = GetCVar("assistAttack")
		SetCVar("assistAttack",1)
		AssistUnit("player")
		SetCVar("assistAttack",assist)
	end
end

function SlashCmdList.STOPATTACK(msg, editbox)
	if isAttacking then
		isAttacking = nil
		AttackTarget()
	end
end

function SlashCmdList.PETAGGRESSIVE(msg, editbox)
	PetAggressiveMode()
end

function SlashCmdList.PETPASSIVE(msg, editbox)
	PetPassiveMode()
end

function SlashCmdList.PETDEFENSIVE(msg, editbox)
	PetDefensiveMode()
end

function SlashCmdList.PETATTACK(msg, editbox)
	PetAttack()
end

function SlashCmdList.PETFOLLOW(msg, editbox)
	PetFollow()
end

function SlashCmdList.PETSTAY(msg, editbox)
	PetWait()
end

function SlashCmdList.CLEARTARGET(msg, editbox)
	ClearTarget()
end

function SlashCmdList.LASTTARGET(msg, editbox)
	TargetLastTarget()
end

function SlashCmdList.CLEARFOCUS(msg, editbox)
	focus = ""
end

function SlashCmdList.FOCUS(msg, editbox)
	focus = UnitName("target")
end

function SlashCmdList.TARGETFOCUS(msg, editbox)
	if focus == "" then
		return
	end
	TargetByName(focus)
end

watchframe:SetScript("OnEvent", onEvent)
