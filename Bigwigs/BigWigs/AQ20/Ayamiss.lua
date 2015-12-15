﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ayamiss the Hunter")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ayamiss",
	sacrifice_cmd = "sacrifice",
	sacrifice_name = "Sacrifice Alert",
	sacrifice_desc = "Warn for Sacrifice",

	sacrificetrigger = "^([^%s]+) ([^%s]+) afflicted by Paralyze",
	sacrificewarn = " is being Sacrificed!",
	you = "You",
	are = "are",	
} end )

L:RegisterTranslations("frFR", function() return {
	sacrificetrigger = "^([^%s]+) ([^%s]+) les effets de Paralysie%.$",
	sacrificewarn = " est sacrifi� !",
	you = "Vous",
	are = "subissez",
} end )

L:RegisterTranslations("deDE", function() return {
	sacrifice_name = "Opferung",
	sacrifice_desc = "Warnung, wenn ein Spieler geopfert wird.",

	sacrificetrigger = "^([^%s]+) ([^%s]+) von Paralisieren betroffen.",
	sacrificewarn = " wird geopfert!",
	you = "Ihr",
	are = "seid",
} end )

L:RegisterTranslations("zhCN", function() return {
	sacrifice_name = "祭品警报",
	sacrifice_desc = "玩家成为祭品时发出警报",

	sacrificetrigger = "^(.+)受(.+)了麻痹效果的影响。",
	sacrificewarn = "成为祭品了！",
	you = "你",
	are = "到",
} end )

L:RegisterTranslations("koKR", function() return {
	sacrifice_name = "마비 경고",
	sacrifice_desc = "마비에 대한 경고",

	sacrificetrigger = "^([^|;%s]*)(.*)마비에 걸렸습니다%.$",
	sacrificewarn = "님이 마비에 걸렸습니다!",
	you = "",
	are = "",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAyamiss = BigWigs:NewModule(boss)
BigWigsAyamiss.zonename = AceLibrary("Babble-Zone-2.0")("Ruins of Ahn'Qiraj")
BigWigsAyamiss.enabletrigger = boss
BigWigsAyamiss.toggleoptions = {"sacrifice", "bosskill"}
BigWigsAyamiss.revision = tonumber(string.sub("$Revision: 13476 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAyamiss:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath" )
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSacrifice")
end

function BigWigsAyamiss:CheckSacrifice( msg )
	local _, _, player, type = string.find(msg, L["sacrificetrigger"])
	if (player and type) then
		if (player == L["you"] and type == L["are"]) then
			player = UnitName("player")
		end
		if self.db.profile.sacrifice then self:TriggerEvent("BigWigs_Message", player .. L["sacrificewarn"], "Important") end
	end
end

