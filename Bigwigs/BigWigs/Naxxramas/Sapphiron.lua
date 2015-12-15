------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Sapphiron")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local time
local cachedUnitId
local lastTarget
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sapphiron",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Sapphiron begins to cast Deep Breath.",

	lifedrain_cmd = "lifedrain",
	lifedrain_name = "Life Drain",
	lifedrain_desc = "Warns about the Life Drain curse.",

	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for berserk.",

	berserk_bar = "Berserk",
	berserk_warn_10min = "10min to berserk!",
	berserk_warn_5min = "5min to berserk!",
	berserk_warn_rest = "%s sec to berserk!",

	engage_message = "Sapphiron engaged! Berserk in 15min!",

	lifedrain_message = "Life Drain! Possibly new one ~24sec!",
	lifedrain_warn1 = "Life Drain in 5sec!",
	lifedrain_bar = "Life Drain",

	lifedrain_trigger = "afflicted by Life Drain",
	lifedrain_trigger2 = "Life Drain was resisted by",

	deepbreath_incoming_message = "Ice Bomb casting in ~23sec!",
	deepbreath_incoming_soon_message = "Ice Bomb casting in ~5sec!",
	deepbreath_incoming_bar = "Ice Bomb Cast",
	deepbreath_trigger = "%s takes in a deep breath...",
	deepbreath_warning = "Ice Bomb Incoming!",
	deepbreath_bar = "Ice Bomb Lands!",
} end )

L:RegisterTranslations("koKR", function() return {
	deepbreath_name = "딥브레스 경고",
	deepbreath_desc = "사피론 딥 브레스 시전 시 경고.",

	lifedrain_name = "생명력 흡수",
	lifedrain_desc = "생명력 흡수 저주에 대한 경고.",

	lifedrain_message = "생명력 흡수! 새로운 생명력 흡수 ~24초!",
	lifedrain_warn1 = "5초간 생명력 흡수!",
	lifedrain_bar = "생명력 흡수",

	berserk_name = "광폭화",
	berserk_desc = "광폭화에 대한 경고.",

	berserk_bar = "광폭화",
	berserk_warn_10min = "10분 후 광폭화!",
	berserk_warn_5min = "5분 후 광폭화!",
	berserk_warn_rest = "%s초 후 광폭화!",

	engage_message = "사피론 전투 개시! 광폭화 까지 15분!",

	lifedrain_trigger = "피의 착취에 걸렸습니다.",
	lifedrain_trigger2 = "피의 착취|1으로;로; (.+)|1을;를; 공격했지만 저항했습니다.",

	deepbreath_incoming_message = "얼음 폭탄 시전 - 약 25초 후!",
	deepbreath_incoming_soon_message = "얼음 폭탄 시전 - 약 5초 후!",
	deepbreath_incoming_bar = "얼음 폭탄 시전",
	deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다.",
	deepbreath_warning = "얼음 폭탄 다가옴!",
	deepbreath_bar = "얼음 폭탄 떨어짐!",
} end )

L:RegisterTranslations("deDE", function() return {
	deepbreath_name = "Frostatem Warnung",
	deepbreath_desc = "Warnt, wenn Saphiron Frostatem zaubert.",

	lifedrain_name = "Lebenssauger",
	lifedrain_desc = "Warnt vor dem Lebenssauger Fluch.",

	berserk_name = "Berserker",
	berserk_desc = "Warnt vor Berserker.",

	berserk_bar = "Berserker",
	berserk_warn_10min = "10min bis Berserker!",
	berserk_warn_5min = "5min bis Berserker!",
	berserk_warn_rest = "%s sek bis Berserker!",

	engage_message = "Sapphiron angegriffen! Berserker in 15min!",

	lifedrain_message = "Lebenssauger! N\195\164chster in ~24sek!",
	lifedrain_warn1 = "Lebenssauger in 5sek!",
	lifedrain_bar = "Lebenssauger",

	lifedrain_trigger = "von Lebenssauger betroffen",
	lifedrain_trigger2 = "Lebenssauger wurde von .+ widerstanden",
	
	deepbreath_incoming_message = "Frostatem in ~23sek!",
	deepbreath_incoming_soon_message = "Frostatem in ~5sek!",
	deepbreath_incoming_bar = "Frostatem",
	deepbreath_trigger = "%s atmet tief ein...",
	deepbreath_warning = "Frostatem kommt!",
	deepbreath_bar = "Frostatem!",
} end )

L:RegisterTranslations("zhCN", function() return {
	deepbreath_name = "深呼吸警报",
	deepbreath_desc = "萨菲隆开始施放深呼吸时发出警报",

	lifedrain_name = "生命吸取警报",
	lifedrain_desc = "生命吸取诅咒时候发出警报",

	berserk_name = "狂暴警报",
	berserk_desc = "狂暴警报",

	berserk_bar = "狂暴",
	berserk_warn_10min = "10分钟后狂暴！",
	berserk_warn_5min = "5分钟后狂暴！",
	berserk_warn_rest = "%s秒后狂暴！",

	engage_message = "萨菲隆激活！15分钟后进入狂暴状态！",

	lifedrain_message = "生命吸取，~24秒后再次施放!",
	lifedrain_warn1 = "5秒后生命吸取！",
	lifedrain_bar = "生命吸取",

	lifedrain_trigger = "受到了生命吸取",  -- need confirm
	lifedrain_trigger2 = "生命吸取被抵抗",  -- need confirm

	deepbreath_incoming_message = "寒冰炸弹~23秒后施放！",
	deepbreath_incoming_soon_message = "寒冰炸弹~5秒后施放！",
	deepbreath_incoming_bar = "寒冰炸弹",
	deepbreath_trigger = "%s深深地吸了一口气……",  -- need confirm
	deepbreath_warning = "寒冰炸弹即将着地！",
	deepbreath_bar = "寒冰炸弹着地！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSapphiron = BigWigs:NewModule(boss)
BigWigsSapphiron.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsSapphiron.enabletrigger = boss
BigWigsSapphiron.toggleoptions = { "berserk", "lifedrain", "deepbreath", "bosskill" }
BigWigsSapphiron.revision = tonumber(string.sub("$Revision: 13640 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSapphiron:OnEnable()
	time = nil
	cachedUnitId = nil
	lastTarget = nil
	started = nil

	if self:IsEventScheduled("bwsapphtargetscanner") then
		self:CancelScheduledEvent("bwsapphtargetscanner")
	end
	if self:IsEventScheduled("bwsapphdelayed") then
		self:CancelScheduledEvent("bwsapphdelayed")
	end

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "LifeDrain")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "LifeDrain")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SapphironLifeDrain", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "SapphironFlight", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSapphiron:BigWigs_RecvSync( sync, rest, nick )
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
		if self:IsEventScheduled("bwsapphtargetscanner") then
			self:CancelScheduledEvent("bwsapphtargetscanner")
		end
		if self:IsEventScheduled("bwsapphdelayed") then
			self:CancelScheduledEvent("bwsapphdelayed")
		end
		if self.db.profile.berserk then
			self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["berserk_bar"], 900, "Interface\\Icons\\INV_Shield_01")
			self:ScheduleEvent("bwsapphberserk1", "BigWigs_Message", 300, L["berserk_warn_10min"], "Attention")
			self:ScheduleEvent("bwsapphberserk2", "BigWigs_Message", 600, L["berserk_warn_5min"], "Attention")
			self:ScheduleEvent("bwsapphberserk3", "BigWigs_Message", 840, string.format(L["berserk_warn_rest"], 60), "Urgent")
			self:ScheduleEvent("bwsapphberserk4", "BigWigs_Message", 870, string.format(L["berserk_warn_rest"], 30), "Important")
			self:ScheduleEvent("bwsapphberserk5", "BigWigs_Message", 890, string.format(L["berserk_warn_rest"], 10), "Important")
			self:ScheduleEvent("bwsapphberserk6", "BigWigs_Message", 895, string.format(L["berserk_warn_rest"], 5), "Important")
		end
		if self.db.profile.deepbreath then
			-- Lets start a repeated event after 5 seconds of combat so that
			-- we're sure that the entire raid is in fact in combat when we
			-- start it.
			self:ScheduleEvent("besapphdelayed", self.StartTargetScanner, 5, self)
		end
	elseif sync == "SapphironLifeDrain" and self.db.profile.lifedrain then
		self:TriggerEvent("BigWigs_Message", L["lifedrain_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["lifedrain_bar"], 24, "Interface\\Icons\\Spell_Shadow_LifeDrain02")
	elseif sync == "SapphironFlight" and self.db.profile.deepbreath then
		if self:IsEventScheduled("bwsapphtargetscanner") then
			self:CancelScheduledEvent("bwsapphtargetscanner")
		end
		if self:IsEventScheduled("bwsapphdelayed") then
			self:CancelScheduledEvent("bwsapphdelayed")
		end
		self:TriggerEvent("BigWigs_Message", L["deepbreath_incoming_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["deepbreath_incoming_bar"], 23, "Interface\\Icons\\Spell_Arcane_PortalIronForge")
		lastTarget = nil
		cachedUnitId = nil
		self:ScheduleEvent("besapphdelayed", self.StartTargetScanner, 50, self)
	end
end

function BigWigsSapphiron:LifeDrain(msg)
	if string.find(msg, L["lifedrain_trigger"]) or string.find(msg, L["lifedrain_trigger2"]) then
		if not time or (time + 2) < GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "SapphironLifeDrain")
			time = GetTime()
		end
	end
end

function BigWigsSapphiron:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["deepbreath_trigger"] then
		if self.db.profile.deepbreath then
			self:TriggerEvent("BigWigs_Message", L["deepbreath_warning"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["deepbreath_bar"], 7, "Interface\\Icons\\Spell_Frost_FrostShock")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L["lifedrain_bar"])
		if self.db.profile.lifedrain then
			self:TriggerEvent("BigWigs_StartBar", self, L["lifedrain_bar"], 14, "Interface\\Icons\\Spell_Shadow_LifeDrain02")
		end
	end
end

------------------------------
--      Target Scanning     --
------------------------------

function BigWigsSapphiron:StartTargetScanner()
	if self:IsEventScheduled("bwsapphtargetscanner") or not started then return end

	-- Start a repeating event that scans the raid for targets every 1 second.
	self:ScheduleRepeatingEvent("bwsapphtargetscanner", self.RepeatedTargetScanner, 1, self)
end

function BigWigsSapphiron:RepeatedTargetScanner()
	if not started then return end
	local found = nil

	-- If we have a cached unit (which we will if we found someone with the boss
	-- as target), then check if he still has the same target
	if cachedUnitId and UnitExists(cachedUnitId) and UnitName(cachedUnitId) == boss then
		found = true
	end

	-- Check the players target
	if not found and UnitExists("target") and UnitName("target") == boss then
		cachedUnitId = "target"
		found = true
	end

	-- Loop the raid roster
	if not found then
		for i = 1, GetNumRaidMembers() do
			local unit = string.format("raid%dtarget", i)
			if UnitExists(unit) and UnitName(unit) == boss then
				cachedUnitId = unit
				found = true
				break
			end
		end
	end

	-- We've checked everything. If nothing was found, just return home.
	-- We basically shouldn't return here, because someone should always have
	-- him targetted.
	if not found then return end

	local inFlight = nil

	-- Alright, we've got a valid unitId with the boss as target, now check if
	-- the boss had a target on the last iteration or not - if he didn't, and
	-- still doesn't, then we fire the "in air" warning.
	if not UnitExists(cachedUnitId.."target") then
		-- Okay, the boss doesn't have a target.
		if not lastTarget then
			-- He didn't have a target last time either
			inFlight = true
		end
		lastTarget = nil
	else
		-- This should always be set before we hit the time when he actually
		-- loses his target, hence we can check |if not lastTarget| above.
		lastTarget = true
	end

	-- He's not flying, so we're just going to continue scanning.
	if not inFlight then return end

	-- He's in flight! (I hope)
	if self:IsEventScheduled("bwsapphtargetscanner") then
		self:CancelScheduledEvent("bwsapphtargetscanner")
	end
	self:TriggerEvent("BigWigs_SendSync", "SapphironFlight")
end

