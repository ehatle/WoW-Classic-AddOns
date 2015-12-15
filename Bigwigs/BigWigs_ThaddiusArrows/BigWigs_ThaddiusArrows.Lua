--[[
--
-- BigWigs Strategy Module for Thaddius in Naxxramas.
--
-- Adds graphical, textual and sound warnings for what direction
-- you should move in when you get a polarity debuff in phase 2.
--
-- See readme.txt for more info
-- Many thanks to rabbit for all the help.
--
-- TODO
--  - Fix strategy broadcasting across multiple locales.
--
--]]

------------------------------
--      Are you local?      --
------------------------------

local myname = "Thaddius Arrows"
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..myname)
local BZ = AceLibrary("Babble-Zone-2.0")
local boss = AceLibrary("Babble-Boss-2.0")("Thaddius")
local TL = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)
local feugen = AceLibrary("Babble-Boss-2.0")("Feugen")
local stalagg = AceLibrary("Babble-Boss-2.0")("Stalagg")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "ThaddiusArrows",

	graphic_cmd = "garrows",
	graphic_name = "Graphical Arrows",
	graphic_desc = "Display Graphical Arrows",

	text_cmd = "tarrows",
	text_name = "Text Arrows",
	text_desc = "Display Text Arrows",

	sound_cmd = "sarrows",
	sound_name = "Sound Effects",
	sound_desc = "Play Direction Sound Effects",

	strat_cmd = "strat",
	strat_name = "Strategy",
	strat_desc = "Pick the strategy to use for moving",
	strat_validate = { "Circular, L/R", "Circular, R/L", "Run Through" },

	setstrategy_cmd = "bwtabc",
	setstrategy_name = "Broadcast strategy",
	setstrategy_desc = "Broadcasts your current strategy to the raid",

	["Thaddius strategy is set to "] = true,
	["Make sure everyone in the raid has the same strategy set!"] = true,
	["Invalid Thaddius strategy, resetting to default."] = true,
	["You can run the command /bwtabc to broadcast your strategy and force your raid to use it."] = true,
	["You can't broadcast the strategy if you are not the leader or promoted in the raid group."] = true,
	["Broadcasting strategy ..."] = true,
	["Strategy broadcast detected from %s. Strategy set to %s."] = true,
	["Invalid Thaddius strategy received from %s."] = true,

	soundleft = "Interface\\AddOns\\BigWigs_ThaddiusArrows\\sounds\\GoLeftUS.wav",
	soundright = "Interface\\AddOns\\BigWigs_ThaddiusArrows\\sounds\\GoRightUS.wav",
	soundacross = "Interface\\AddOns\\BigWigs_ThaddiusArrows\\sounds\\SwitchSidesUS.wav",

	warnleft = "<----  GO LEFT  <---- GO LEFT <----",
	warnright = "---->  GO RIGHT  ----> GO RIGHT ---->",
	warnacross = "^^^^ SWITCH SIDES ^^^^ SWITCH SIDES ^^^^",
	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsThaddiusArrows = BigWigs:NewModule(myname, "AceConsole-2.0")
BigWigsThaddiusArrows.synctoken = myname
BigWigsThaddiusArrows.zonename = BZ"Naxxramas"
BigWigsThaddiusArrows.enabletrigger = { boss, feugen, stalagg }
BigWigsThaddiusArrows.toggleoptions = { "strat", -1, "graphic", "text", "sound" }
BigWigsThaddiusArrows.revision = tonumber(string.sub("$Revision: 11529 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsThaddiusArrows:OnInitialize()
	self.frameArrow = CreateFrame("Frame", nil, UIParent)
	self.texArrow = self.frameArrow:CreateTexture(nil, "BACKGROUND")
	-- Create the frame we will be using for the Arrow
	self.frameArrow:SetFrameStrata("MEDIUM")
	self.frameArrow:SetWidth(200)  -- Set These to whatever height/width is needed 
	self.frameArrow:SetHeight(200) -- for your Texture
	-- Apply Texture
	self.texArrow:SetTexture("Interface\\AddOns\\BigWigs_ThaddiusArrows\\textures\\arrow")	
	self.texArrow:SetAllPoints(self.frameArrow)
	self.frameArrow:SetAlpha(0.6)
	self.frameArrow:Hide()

	self.framestraightArrow = CreateFrame("Frame", nil, UIParent)
	self.texstraightArrow = self.framestraightArrow:CreateTexture(nil, "BACKGROUND")
	-- Create the frame we will be using for the Arrow
	self.framestraightArrow:SetFrameStrata("MEDIUM")
	self.framestraightArrow:SetWidth(200)  -- Set These to whatever height/width is needed 
	self.framestraightArrow:SetHeight(200) -- for your Texture
	-- Apply Texture
	self.texstraightArrow:SetTexture("Interface\\AddOns\\BigWigs_ThaddiusArrows\\textures\\straightArrow")	
	self.texstraightArrow:SetAllPoints(self.framestraightArrow)
	self.framestraightArrow:SetAlpha(0.6)
	self.framestraightArrow:Hide()

	self:RegisterChatCommand({ "/"..L["setstrategy_cmd"] }, {
		type = "execute",
		name = L["setstrategy_name"],
		desc = L["setstrategy_desc"],
		func = function() self:BroadCastStrategy() end,
		}
	)

end

function BigWigsThaddiusArrows:OnEnable()
	self.previousCharge = nil
	if not self.db.profile.strat then self.db.profile.strat = L"strat_validate"[1] end

	self.circularLR = L"strat_validate"[1]
	self.circularRL = L"strat_validate"[2]
	self.through = L"strat_validate"[3]

	if self.db.profile.strat ~= self.circularLR and self.db.profile.strat ~= self.circularRL and self.db.profile.strat ~= self.through then
		self:Print(L["Invalid Thaddius strategy, resetting to default."])
		self.db.profile.strat = L"strat_validate"[1]
	end

	self:Print(L["Thaddius strategy is set to "]..self.db.profile.strat)
	self:Print(L["Make sure everyone in the raid has the same strategy set!"])
	if IsRaidLeader() or IsRaidOfficer() then
		self:Print(L["You can run the command /bwtabc to broadcast your strategy and force your raid to use it."])
	end

	-- Events
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ThaddiusArrowsStrategy", 2)
end

function BigWigsThaddiusArrows:OnDisable()
	if self.frameArrow then self.frameArrow:Hide() end
	if self.framestraightArrow then self.framestraightArrow:Hide() end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsThaddiusArrows:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsThaddiusArrows:BroadCastStrategy()
	if not IsRaidLeader() and not IsRaidOfficer() then
		self:Print(L["You can't broadcast the strategy if you are not the leader or promoted in the raid group."])
		return
	end

	self:Print(L["Broadcasting strategy ..."])
	self:TriggerEvent("BigWigs_SendSync", "ThaddiusArrowsStrategy "..self.db.profile.strat)
end

function BigWigsThaddiusArrows:BigWigs_RecvSync( sync, rest, nick )
	if sync ~= "ThaddiusArrowsStrategy" or not rest or not nick then return end

	if rest ~= self.circularLR and rest ~= self.circularRL and rest ~= self.through then
		self:Print(string.format(L["Invalid Thaddius strategy received from %s."], nick))
		return
	end

	self:Print(string.format(L["Strategy broadcast detected from %s. Strategy set to %s."], nick, rest))

	self.db.profile.strat = rest
end

function BigWigsThaddiusArrows:PLAYER_REGEN_ENABLED()
	local go = BigWigsThaddius:Scan()
	local running = self:IsEventScheduled("ThaddiusArrows_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("ThaddiusArrows_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsThaddiusArrows:Direction( direction )
	if direction == "Left" then -- Left Arrow
		if self.db.profile.graphic then
			self.frameArrow.texture = self.texArrow
			self.texArrow:SetTexCoord(0, 1, 0, 1)
			self.frameArrow:SetPoint("CENTER", -250, 100)
			self.frameArrow:Show()
			self:ScheduleEvent(function() self.frameArrow:Hide() end, 4)
		end
		if self.db.profile.sound then 
			PlaySoundFile(L["soundleft"])
		end
		if self.db.profile.text then
			self:TriggerEvent("BigWigs_Message", L["warnleft"], "Red")
		end
	elseif direction == "Right" then -- Right Arrow
		if self.db.profile.graphic then
			self.frameArrow.texture = self.texArrow
			self.texArrow:SetTexCoord(1, 0, 0, 1)
			self.frameArrow:SetPoint("CENTER", 250, 100)
			self.frameArrow:Show()
			self:ScheduleEvent(function() self.frameArrow:Hide() end, 4)
		end
		if self.db.profile.sound then 
			PlaySoundFile(L["soundright"])
		end
		if self.db.profile.text then
			self:TriggerEvent("BigWigs_Message", L["warnright"], "Red")
		end
	elseif direction == "Across" then -- Switch Sides
		if self.db.profile.graphic then
			self.framestraightArrow.texture = self.texstraightArrow
			self.texstraightArrow:SetTexCoord(0, 1, 0, 1)
			self.framestraightArrow:SetPoint("CENTER", 0, 200)
			self.framestraightArrow:Show()
			self:ScheduleEvent(function() self.framestraightArrow:Hide() end, 4)
		end
		if self.db.profile.sound then 
			PlaySoundFile(L["soundacross"])
		end
		if self.db.profile.text then
			self:TriggerEvent("BigWigs_Message", L["warnacross"], "Red")
		end
	end
end

function BigWigsThaddiusArrows:BigWigs_Message( msg )
	if msg == TL["nochange"] then
		if self.db.profile.strat == self.circularLR then 
			self:Direction("Left")
		elseif self.db.profile.strat == self.circularRL then
			self:Direction("Right")
		end
		self.previousCharge = msg
	elseif msg == TL["poswarn"] or msg == TL["negwarn"] then
		if self.previousCharge then
			if self.db.profile.strat == self.circularLR then
				self:Direction("Right")
			elseif self.db.profile.strat == self.through then
				self:Direction("Across")
			elseif self.db.profile.strat == self.circularRL then
				self:Direction("Left")
			end
		else
			-- First charge
			if msg == TL["poswarn"] then
				if self.db.profile.strat == self.circularLR then
					self:Direction("Left")
				elseif self.db.profile.strat == self.circularRL then
					self:Direction("Right")
				end
			elseif msg == TL["negwarn"] then
				if self.db.profile.strat == self.circularLR then
					self:Direction("Right")
				elseif self.db.profile.strat == self.circularRL then
					self:Direction("Left")
				elseif self.db.profile.strat == self.through then
					self:Direction("Across")
				end
			end
		end
		self.previousCharge = msg
	end
end

