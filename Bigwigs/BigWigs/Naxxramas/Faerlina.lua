﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Grand Widow Faerlina")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Faerlina",

	silence_cmd = "silence",
	silence_name = "Silence Alert",
	silence_desc = "Warn for silence",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	starttrigger1 = "Kneel before me, worm!",
	starttrigger2 = "Slay them in the master's name!",
	starttrigger3 = "You cannot hide from me!",
	starttrigger4 = "Run while you still can!",

	silencetrigger = "Grand Widow Faerlina is afflicted by Widow's Embrace.", -- EDITED it affects her too.
	enragetrigger = "Grand Widow Faerlina gains Enrage.",
	enragefade = "Enrage fades from Grand Widow Faerlina.",

	startwarn = "Grand Widow Faerlina engaged, 60 seconds to enrage!",
	enragewarn15sec = "15 seconds until enrage!",
	enragewarn = "Enrage!",
	enrageremovewarn = "Enrage removed! %d seconds until next!", -- added
	silencewarn = "Silence! Delaying Enrage!",
	silencewarnnodelay = "Silence!",
	silencewarn5sec = "Silence ends in 5 sec",

	enragebar = "Enrage",
	silencebar = "Silence",
} end )

L:RegisterTranslations("deDE", function() return {
	silence_name = "Stille",
	silence_desc = "Warnung vor Stille",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Gro\195\159witwe Faerlina w\195\188tend wird.",

	starttrigger1 = "Kniet nieder, Wurm!",
	starttrigger2 = "T\195\182tet sie im Namen des Meisters!",
	starttrigger3 = "Ihr k\195\182nnt euch nicht vor mir verstecken!",
	starttrigger4 = "Flieht, solange ihr noch k\195\182nnt",

	silencetrigger = "Gro\195\159witwe Faerlina ist von Umarmung der Witwe betroffen.", -- EDITED it affects her too.
	enragetrigger = "Gro\195\159witwe Faerlina bekommt 'Wutanfall'.",
	enragefade = "Wutanfall schwindet von Gro\195\159witwe Faerlina",

	startwarn = "Gro\195\159witwe Faerlina angegriffen! Wutanfall in 60 Sekunden!",
	enragewarn15sec = "Wutanfall in 15 Sekunden!",
	enragewarn = "Wutanfall!",
	enrageremovewarn = "Wutanfall vorbei! N\195\164chster in %d Sekunden!",
	silencewarn = "Stille! Wutanfall verz\195\182gert!",
	silencewarnnodelay = "Stille!",
	silencewarn5sec = "Stille endet in 5 Sekunden",

	enragebar = "Wutanfall",
	silencebar = "Stille",
} end )

L:RegisterTranslations("koKR", function() return {

	silence_name = "침묵 경고",
	silence_desc = "침묵에 대한 경고",

	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	starttrigger1 = "내 앞에 무릎을 꿇어라, 벌레들아!",
	starttrigger2 = "주인님의 이름으로 처단하라!",
	starttrigger3 = "나에게서 도망칠 수는 없다!",
	starttrigger4 = "두 발이 성할 때 도망쳐라!",

	silencetrigger = "낙스라마스 숭배자|1이;가; 귀부인의 은총에 걸렸습니다.", -- EDITED it affects her too.
	enragetrigger = "귀부인 팰리나|1이;가; 격노 효과를 얻었습니다.",
	enragefade = "귀부인 펠리나 격노 사라짐",

	startwarn = "귀부인 팰리나 전투 시작! 60초 후 격노!",
	enragewarn15sec = "15초후 격노!",
	enragewarn = "격노!",
	enrageremovewarn = "격노 사라짐! 다음 격노 %d초 후", -- added
	silencewarn = "침묵! 격노 지연!",
	silencewarnnodelay = "침묵!",
	silencewarn5sec = "5초후 침묵 종료!",

	enragebar = "격노",
	silencebar = "침묵",
} end )

L:RegisterTranslations("zhCN", function() return {
	silence_name = "沉默警报",
	silence_desc = "沉默警报",

	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	starttrigger1 = "跪下求饶吧，懦夫！",
	starttrigger2 = "以主人之名，杀了他们！",
	starttrigger3 = "休想从我面前逃掉！",
	starttrigger4 = "逃啊！有本事就逃啊！",

	silencetrigger = "黑女巫法琳娜受到了黑女巫的拥抱效果的影响。", -- EDITED it affects her too.
	enragetrigger = "黑女巫法琳娜获得了激怒的效果。",
	enragefade = "激怒效果从黑女巫法琳娜身上消失。",

	startwarn = "黑女巫法琳娜已激活 - 60秒后激怒！",
	enragewarn15sec = "15秒后激怒！",
	enragewarn = "激怒！",
	enrageremovewarn = "激怒已移除 - %d后再次激怒", -- added
	silencewarn = "沉默！延缓了激怒！",
	silencewarnnodelay = "沉默！",
	silencewarn5sec = "5秒后沉默结束！",

	enragebar = "激怒",
	silencebar = "沉默",
} end )

L:RegisterTranslations("frFR", function() return {
	starttrigger1 = "genoux, vermisseau !",
	starttrigger2 = "Tuez%-les au nom du ma\195\174tre !",
	starttrigger3 = "Vous ne pouvez pas m'\195\169chapper !",
	starttrigger4 = "Fuyez tant que vous le pouvez !",

	silencetrigger = "Grande veuve Faerlina subit les effets de Etreinte de la veuve.", -- EDITED it affects her too.
	enragetrigger = "Grande veuve Faerlina gagne Enrager.",
	enragefade = "Enrager sur Grande veuve Faerlina vient de se dissiper.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFaerlina = BigWigs:NewModule(boss)
BigWigsFaerlina.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsFaerlina.enabletrigger = boss
BigWigsFaerlina.toggleoptions = {"silence", "enrage", "bosskill"}
BigWigsFaerlina.revision = tonumber(string.sub("$Revision: 13478 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFaerlina:OnEnable()
	self.enragetime = 60
	self.enrageTimerStarted = 0
	self.silencetime = 30
	self.enraged = nil

	started = nil

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FaerlinaEnrage", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "FaerlinaSilence", 5)
end

function BigWigsFaerlina:CHAT_MSG_MONSTER_YELL( msg )
	if not started and msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"] then
		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Orange")
		if self.db.profile.enrage then
			self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", self.enragetime - 15, L["enragewarn15sec"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebar"], self.enragetime, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		end
		self.enrageTimerStarted = GetTime()
		started = true
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L["enragetrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FaerlinaEnrage")
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE( msg )
	if msg == L["silencetrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FaerlinaSilence")
	end
end

function BigWigsFaerlina:BigWigs_RecvSync( sync )
	if sync == "FaerlinaEnrage" then
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Urgent")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L["enragebar"])
		self:CancelScheduledEvent("bwfaerlinaenrage15") 
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebar"], self.enragetime, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", self.enragetime - 15, L["enragewarn15sec"], "Important")
		end
		self.enrageTimerStarted = GetTime()
		self.enraged = true
	elseif sync == "FaerlinaSilence" then
		if not self.enraged then -- preemptive, 30s silence
		
			--[[ The enrage timer should only be reset if it's less than 30sec
			to her next enrage, because if you silence her when there's 30+
			sec to the enrage, it won't actually stop her from enraging. ]]

			local currentTime = GetTime()

			if self.db.profile.silence then
				if (self.enrageTimerStarted + 30) < currentTime then
					self:TriggerEvent("BigWigs_Message", L["silencewarnnodelay"], "Urgent")
				else
					self:TriggerEvent("BigWigs_Message", L["silencewarn"], "Urgent")
				end
				self:TriggerEvent("BigWigs_StartBar", self, L["silencebar"], self.silencetime, "Interface\\Icons\\Spell_Holy_Silence")
				self:ScheduleEvent("bwfaerlinasilence5", "BigWigs_Message", self.silencetime -5, L["silencewarn5sec"], "Urgent")
			end
			if (self.enrageTimerStarted + 30) < currentTime then
				if self.db.profile.enrage then
					-- We SHOULD reset the enrage timer, since it's more than 30
					-- sec since enrage started. This is only visuals ofcourse.
					self:TriggerEvent("BigWigs_StopBar", self, L["enragebar"])
					self:CancelScheduledEvent("bwfaerlinaenrage15")
					self:ScheduleEvent( "bwfaerlinaenrage15", "BigWigs_Message", self.silencetime - 15, L["enragewarn15sec"], "Important")
					self:TriggerEvent("BigWigs_StartBar", self, L["enragebar"], self.silencetime, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
				end
				self.enrageTimerStarted = currentTime
			end

		else -- Reactive enrage removed
			if self.db.profile.enrage then
				self:TriggerEvent("BigWigs_Message", string.format(L["enrageremovewarn"], self.enragetime), "Urgent")
			end
			if self.db.profile.silence then
				self:TriggerEvent("BigWigs_StartBar", self, L["silencebar"], self.silencetime, "Interface\\Icons\\Spell_Holy_Silence")
				self:ScheduleEvent("bwfaerlinasilence5", "BigWigs_Message", self.silencetime -5, L["silencewarn5sec"], "Urgent")
 			end
			self.enraged = nil
		end
	end
end

