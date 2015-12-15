------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Gluth")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gluth",

	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for fear",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for frenzy",

	decimate_cmd = "decimate",
	decimate_name = "Decimate Alert",
	decimate_desc = "Warn for Decimate",

	trigger1 = "%s goes into a frenzy!",
	trigger2 = "by Terrifying Roar.",
	starttrigger = "devours all nearby zombies!",

	warn1 = "Frenzy Alert!",
	warn2 = "5 second until AoE Fear!",
	warn3 = "AoE Fear alert - 20 seconds till next!",

	startwarn = "Gluth Engaged! ~105 seconds till Zombies!",
	decimatesoonwarn = "Decimate Soon!",
	decimatewarn = "Decimate!",
	decimatetrigger = "Decimate",

	bar1text = "AoE Fear",
	decimatebartext = "Decimate Zombies",
} end )

L:RegisterTranslations("koKR", function() return {

	fear_name = "공포 경고",
	fear_desc = "공포에 대한 경고",
	
	frenzy_name = "광폭화 경고",
	frenzy_desc = "광폭화에 대한 경고",

	decimate_name = "척살 경보",
	decimate_desc = "척살에 대한 경고",

	trigger1 = "%s|1이;가; 광란의 상태에 빠집니다!", -- CHECK
	trigger2 = "공포의 포효에",
	starttrigger = "devours all nearby zombies!", -- CHECK (not used)

	warn1 = "광폭화 경고!",
	warn2 = "광역 공포 5초 전!",
	warn3 = "광역 공포 경고 - 20초 후",

	startwarn = "글루스 전투 시작! 약 105초 후 좀비!",
	decimatesoonwarn = "곧 척살!",
	decimatewarn = "척살!",
	decimatetrigger = "척살",

	bar1text = "광역 공포",
	decimatebartext = "척살 좀비",
} end )

L:RegisterTranslations("deDE", function() return {
	fear_name = "Furcht",
	fear_desc = "Warnung vor AoE Furcht.",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Gluth in Raserei ger\195\164t",

	decimate_name = "Dezimieren", -- ?
	decimate_desc = "Warnung vor Dezimieren", -- ?

	trigger1 = "%s ger\195\164t in Raserei!",
	trigger2 = "von Erschreckendes Gebr\195\188ll betroffen.",
	starttrigger = "devours all nearby zombies!", -- ?

	warn1 = "Raserei!",
	warn2 = "5 Sekunden bis AoE Furcht!",
	warn3 = "AoE Furcht - N\195\164chste in 20 Sekunden!",

	startwarn = "Gluth angegriffen! ~105 Sekunden bis Zombies!",
	decimatesoonwarn = "Dezimieren kurz bevor",
	decimatewarn = "Dezimieren! - AoE Zombies!",
	decimatetrigger = "Decimate", -- ?

	bar1text = "Furcht",
	decimatebartext = "Dezimieren", -- ?
} end )

L:RegisterTranslations("zhCN", function() return {
	fear_name = "恐惧警报",
	fear_desc = "恐惧警报",

	frenzy_name = "狂暴警报",
	frenzy_desc = "狂暴警报",

	decimate_name = "吞噬警报",
	decimate_desc = "吞噬警报",

	trigger1 = "%s变得狂怒无比！",
	trigger2 = "恐惧怒吼",
	starttrigger = "吞吃了周围所有的僵尸！",

	warn1 = "狂暴警报 - 猎人立刻使用宁神射击！",
	warn2 = "5秒后发动群体恐惧！",
	warn3 = "群体恐惧 - 20秒后再次发动",

	startwarn = "格拉斯已激活 - 105秒后僵尸出现！",
	decimatesoonwarn = "吞噬来临！",
	decimatewarn = "吞噬 - AoE僵尸！",
	decimatetrigger = "吞噬",

	bar1text = "群体恐惧",
	decimatebartext = "吞噬僵尸",
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 = "%s gagne Fr\195\169n\195\169sie.",
	trigger2 = "de Rugissement terrifiant.",
	starttrigger = "d\195\169vore tous les zombies aux alentours !",
	decimatetrigger = "D\195\169cimer",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGluth = BigWigs:NewModule(boss)
BigWigsGluth.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsGluth.enabletrigger = boss
BigWigsGluth.toggleoptions = {"frenzy", "fear", "decimate", "bosskill"}
BigWigsGluth.revision = tonumber(string.sub("$Revision: 13476 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

-- XXX Need to add a timer bar for berserker rage.
-- XXX It happens some time after the 3rd decimate, but it's probably on a
-- XXX fixed timer, so just make it a bar like the Twins@AQ40 enrage timer.

function BigWigsGluth:OnEnable()
	self.prior = nil
	started = nil

	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Frenzy")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Frenzy")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Fear")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Fear")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Decimate")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GluthDecimate", 30)
end

function BigWigsGluth:Frenzy( msg )
	if self.db.profile.frenzy and msg == L["trigger1"] then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Important")
	end
end

function BigWigsGluth:Fear( msg )
	if self.db.profile.fear and not self.prior and string.find(msg, L["trigger2"]) then
		self:TriggerEvent("BigWigs_Message", L["warn3"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 20, "Interface\\Icons\\Spell_Shadow_PsychicScream")
		self:ScheduleEvent("BigWigs_Message", 15, L["warn2"], "Urgent")
		self.prior = true
	end
end

function BigWigsGluth:Decimate( msg )
	if string.find(msg, L["decimatetrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "GluthDecimate")
	end
end

function BigWigsGluth:BigWigs_RecvSync( sync, rest, nick )
	if sync == "GluthDecimate" and self.db.profile.decimate then
		self:TriggerEvent("BigWigs_Message", L["decimatewarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["decimatebartext"], 105, "Interface\\Icons\\INV_Shield_01")
		self:ScheduleEvent("BigWigs_Message", 100, L["decimatesoonwarn"], "Urgent")
	elseif sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self.db.profile.decimate then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["decimatebartext"], 105, "Interface\\Icons\\INV_Shield_01")
			self:ScheduleEvent("BigWigs_Message", 100, L["decimatesoonwarn"], "Urgent")
		end
	end
end

function BigWigsGluth:BigWigs_Message(text)
	if text == L["warn2"] then self.prior = nil end
end

