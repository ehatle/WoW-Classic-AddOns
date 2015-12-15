DEFAULT_CHAT_FRAME:AddMessage("load", 0.95, 0.95, 0.5);
local function log(msg, level)
	if (level ~= nil and level <= Questie.debugLevel) then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

local function debug(msg, category)
	if not (category) then category = true; end
	QuestieDebug[msg] = category;
	--DEFAULT_CHAT_FRAME:AddMessage("Questie has recorded a bugged quest. Please report this to https://github.com/AeroScripts/QuestieDev");
end

Questie = CreateFrame("Frame", "QuestieLua", UIParent, "ActionButtonTemplate")
Questie.TimeSinceLastUpdate = 0
Questie.lastMinimapUpdate = 0
Questie.needsUpdate = false;
Questie.player_x = 0;
Questie.player_y = 0;
Questie.debugLevel = 1;
questsByDistance = {};
QuestieSeenQuests = {};

QuestieNotesDB = {};


QuestieGlobalConfig = { -- TODO SAVEDVARIABLE THIS THING
	['Minimap'] = {
		['Maximum minimap icons'] = 10,
		['Icon scale percentage'] = 100,
		['Enabled'] = true
	},
	['World Map'] = {
		['Maximum world map icons'] = 0,
		['Enabled'] = true
	},
	['Tracker'] = {
		['Maximum tracked quests (NYI)'] = 0,
		['Distance Units'] = "Yds",
		['Enable arrow on click'] = true,
		['Enable Distance display'] = true,
		['Enabled'] = true
	},
	['Misc'] = {
	},
	['Developer'] = {
		['Logging'] = {
			['Verbosity (NYI)'] = 0
		}
	}
};





function Questie:PrintConfigCategory(category, level)
	header = "";
	for q=0,level do -- bad code
		header = header .. "   ";
	end
	for k,v in pairs(category) do
		if type(v) == "table" then
			DEFAULT_CHAT_FRAME:AddMessage(header .. k .. ":");
			local WTF_LUA_WHY_WOULD_YOU_DO_THIS_TO_ME = level + 1;
			Questie:PrintConfigCategory(v, WTF_LUA_WHY_WOULD_YOU_DO_THIS_TO_ME);
		else
			-- because this is for config I didn't want to use the log function

			DEFAULT_CHAT_FRAME:AddMessage(header .. k .. " (Default " .. tostring(v) .. ")");
		end
	end
end

function Questie:PrintSlashHelp()
	Questie:PrintConfigCategory(QuestieGlobalConfig, 0);
end

_GetQuestLogQuestText = GetQuestLogQuestText;

local QUESTIE_MAX_MINIMAP_POINTS = 20;

local minimap_poiframes = {};
local minimap_poiframe_textures = {};
local minimap_poiframe_data = {};

function Questie:ADDON_LOADED()

	if not (QuestieCurrentQuests) then
		QuestieCurrentQuests = {};
	end
	if not (QuestieDebug) then
		QuestieDebug = {};
	end	
	if not (QuestieCurrentNotes) then
		QuestieCurrentNotes = {};
	end
	--Initializes the FramePool;
	Questie:NOTES_LOADED();
	--Added Slashcommand for the Addon
	SlashCmdList["QUESTIE"] = Questie_SlashHandler;
	SLASH_QUESTIE1 = "/questie";
end

--[[
These two functions are DropDown example functions these should be removed!
]]--
function Onclickerino()
	DEFAULT_CHAT_FRAME:AddMessage("CLICKED");
end


function DropDown_OnLoad()
	level = level or 1 --drop down menues can have sub menues. The value of level determines the drop down sub menu tier
	local info = UIDropDownMenu_CreateInfo();
	info.text = "TEST"; --the text of the menu item
	info.value = 1; -- the value of the menu item. This can be a string also.
	info.func = Onclickerino; --sets the function to execute when this item is clicked
	info.owner = this:GetParent(); --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues.
	info.checked = nil; --initially set the menu item to being unchecked with a yellow tick
	info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text
	UIDropDownMenu_AddButton(info, level); --Adds the new button to the drop down menu specified in the UIDropDownMenu_Initialise function. In this case, it's MyDropDownMenu
end

function Questie_SlashHandler(msg)

	-- HERE DO STRING ARGUMENTS TO SPLINT SPACE INTO ARG1 ARG2 //msg is used meanwhile

	if (msg=="show" or msg=="hide") then msg = ""; end
	if (not msg or msg=="") then
		--Base command
		DEFAULT_CHAT_FRAME:AddMessage("SlashCommand Used - No help implemented yet\n Goto: http://github.com/AeroScripts/QuestieDev/ for help");--Use internal print instead.
	end

	if(msg == "test") then --Tests the questie notes part
		DEFAULT_CHAT_FRAME:AddMessage("Adding icons zones");
		for i = 1, 1 do
			Questie:AddNoteToMap(1, 15, 0.5, 0.5,"complete", tostring(i));
			--Questie:AddNoteToMap(2, 12, 0.8, 0.8,"Loot", "2");
			--Questie:AddNoteToMap(2, 12, 0.9, 0.9,"Object", "3");
			--Questie:AddNoteToMap(2, 12, 0.4, 0.9,"Slay", "4");
		end
		Questie:RedrawNotes();
	end

	if(msg == "getpos") then
		local c,z,x,y = Astrolabe:GetCurrentPlayerPosition();
		if(IsAddOnLoaded("URLCopy"))then
			Questie:debug_Print(URLCopy_Link(x..","..y));
		else
			Questie:debug_Print(x..","..y);
		end
	end

	if(msg == "c") then
		Questie:AddQuestToMap(2743610414);
	end

	if(msg == "u") then
		local t = GetTime();
		for k, v in pairs(Questie:AstroGetAllCurrentQuestHashes()) do
			Questie:debug_Print("Updating", v["hash"])
			Questie:UpdateQuestNotes(v["hash"]);
		end
		Questie:debug_Print("Updated all quests: Time:", GetTime()- t);
		Questie:RedrawNotes();
		--Questie:AddQuestToMap(2743610414);
		--Questie:AddQuestToMap(3270662498);
	end

	if(msg == "q") then
		local t = GetTime();
		for k, v in pairs(Questie:AstroGetAllCurrentQuestHashes()) do
			Questie:AddQuestToMap(v["hash"]);
		end
		Questie:debug_Print("Added quests: Time:", GetTime()- t);
		Questie:RedrawNotes();
		--Questie:AddQuestToMap(2743610414);
		--Questie:AddQuestToMap(3270662498);
	end

	if(msg == "h") then
		testbutton = CreateFrame("Button", "testets", UIParent,"UIPanelButtonTemplate");
		testbutton:SetWidth(80);
		testbutton:SetHeight(50);
		testbutton:SetText("asdf");
		testbutton:SetPoint("CENTER",0,0);
		testbutton:Show();
		DropDownTest = CreateFrame("Frame", "QuestieDropDown", UIParent, "UIDropDownMenuTemplate");
		DropDownTest:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		UIDropDownMenu_SetWidth(130, DropDownTest);
		UIDropDownMenu_Initialize(DropDownTest, DropDown_OnLoad, "MENU");
		DropDownTest:Show();
		testbutton:SetScript("OnClick", function()
			DEFAULT_CHAT_FRAME:AddMessage("Click");
			ToggleDropDownMenu(nil,nil,DropDownTest,"testets",3,-3);	
		end)
	end

	if(msg =="ast") then -- Don't want to remove this... good for reference
		--/script Astrolabe:PlaceIconOnWorldMap(WorldMapFrame,,1,"Ashenvale",100,100);

		local f = CreateFrame("Button",nil,WorldMapFrame)
		f.YoMamma = "Hashisbest";
		f:SetFrameStrata("DIALOG")
		f:SetWidth(16)  -- Set These to whatever height/width is needed 
		f:SetHeight(16) -- for your Texture

		local t = f:CreateTexture(nil,"BACKGROUND")
		t:SetTexture("Interface\\AddOns\\Questie\\Icons\\complete")
		t:SetAllPoints(f)
		f.texture = t
		f:SetScript("OnEnter", function()
				GameTooltip:SetOwner(this, "ANCHOR_CURSOR");
				GameTooltip:AddLine("ICON! "..this.YoMamma);
				GameTooltip:Show();
		end ); --Script Toolip
		f:SetScript("OnLeave", function() if(GameTooltip) then GameTooltip:Hide() end end) --Script Exit Tooltip

		f:SetPoint("TOPLEFT",0,0)
		f:Show()

		local C, Z = GetCurrentMapContinent(), GetCurrentMapZone();
		x, y = Astrolabe:TranslateWorldMapPosition(2,12,0.8, 0.8, 2, 0);
		x, y = Astrolabe:PlaceIconOnWorldMap(WorldMapFrame,f,2,nil,x, y);
		if(x and y) then
			DEFAULT_CHAT_FRAME:AddMessage("Added note to Ashenvale "..x.." : "..y);
		else
			DEFAULT_CHAT_FRAME:AddMessage("Failed");
		end
	end


	if(msg == "glowtest") then
		Questie:debug_Print("GlowTest");
		local w, h = WorldMapFrame:GetWidth(), WorldMapFrame:GetHeight()
		--Setup variables in WorldMapFrame
		--local map_overlay = CreateFrame("Frame","Map_Overlay",UIParent);
		--map_overlay:SetPoint("TOPLEFT",0,0);
		--map_overlay:SetFrameLevel(9);
		--map_overlay:SetWidth(w);
		--map_overlay:SetHeight(h);
		--map_overlay:Show();
		
		--This calulates a good glow size
		x, y =  GetPlayerMapPosition("player");
		c, z = GetCurrentMapContinent(), GetCurrentMapZone();


		local _, x_size, y_size = Astrolabe:ComputeDistance(c, z, 0.25, 0.25, c, z, 0.75, 0.75)
		--f:SetFrameLevel(8);
		x_size = 200 / x_size * w;
		y_size = 200 / y_size * h;

		local c = Icon("abc");
		local d = Icon("cba");
		d:SetPoint("CENTER",16,0);
		d:Show();

		--We Create a new frame and add the glowtexture to it.
		--local glow = CreateFrame("Button",nil,WorldMapFrame);
		--local tex = Questie:CreateGlowTexture(glow);
		--glow:SetFrameLevel(9);
		--glow:SetWidth(x_size);
		--glow:SetHeight(y_size);
		--glow:SetPoint("CENTER",0,0);
		--glow:Show();

		--local g = Questie:CreateGlowFrame()
		--g:SetPoint("CENTER",0,0);
		--g:Show();

		--local ra = Questie:CreateGlowNote("abc");
		--ra:SetPoint("CENTER",0,0)
		--ra:Show()
		--xx, yy = Astrolabe:PlaceIconOnWorldMap(WorldMapFrame,ra,c ,z ,0.5, 0.5);
		--ra = Questie:CreateGlowNote("abc");
		--ra:SetPoint("CENTER",0,0)
		--ra:Show()
		--xx, yy = Astrolabe:PlaceIconOnWorldMap(WorldMapFrame,ra,c ,z ,0.54, 0.5);
		--ra = Questie:CreateGlowNote("abc");
		--ra:SetPoint("CENTER",0,0)
		--ra:Show()
		--xx, yy = Astrolabe:PlaceIconOnWorldMap(WorldMapFrame,ra,c ,z ,0.5, 0.54);
		--Questie:debug_Print(xx,yy);

	end

end

WorldMapFrame.free_icons_frames = {};
WorldMapFrame.free_glow_frames = {};

function Icon(questHash)
	local iconFrame = nil
	if(table.getn(WorldMapFrame.free_icons_frames) == 0) then
		iconFrame = CreateFrame("Button","QuestieNoteFrame",WorldMapFrame)
		local t = iconFrame:CreateTexture(nil,"BACKGROUND")
		t:SetTexture("Interface\\AddOns\\Questie\\Icons\\complete")
		t:SetAllPoints(iconFrame)
		iconFrame.texture = t
	else
		--Use free pool items
	end

	iconFrame:SetParent(WorldMapFrame)--Just a saftey mechanic
	iconFrame:SetFrameLevel(9);
	iconFrame:SetWidth(16)  -- Set These to whatever height/width is needed 
	iconFrame:SetHeight(16) -- for your Texture
	iconFrame:SetScript("OnEnter", Questie_Tooltip_OnEnter); --Script Toolip
	iconFrame:SetScript("OnLeave", function() if(WorldMapTooltip) then WorldMapTooltip:Hide() end if(GameTooltip) then GameTooltip:Hide() end end) --Script Exit Tooltip
	iconFrame.questHash = questHash;

	--Do calculation with questHash objectivelist to see where the icon needs to fall
	--Logic should be, go through all objectives, left to right do (right - left)/2 by both X and Y

	--TempCode
	iconFrame:SetPoint("CENTER",0,0);
	iconFrame:Show();
	--EndTempCode

	function iconFrame:SetTooltip()
		--Do stuff here use f.questHash to get info


		--Just a temporary tooltip
		WorldMapTooltip:SetOwner(this, this); --"ANCHOR_CURSOR"
		WorldMapTooltip:AddLine("ThisIsATestHeader ",1,1,1);
		WorldMapTooltip:AddLine("LowerText");
		if(NOTES_DEBUG) then
			WorldMapTooltip:AddLine("questHash: "..iconFrame.questHash);
		end
		WorldMapTooltip:SetFrameLevel(10);
		WorldMapTooltip:Show();

		Questie:debug_Print("Inside SetTooltip");--Debug remove
	end

	function iconFrame:OnEnter()
		--local list = QuestHelper:GetOverlapObjectives(self.objective) old questhelper code
		--['locations'] = {
	    --  [1] = {30.0, 0.4902, 0.7084, 100.0},
	    --  [2] = {30.0, 0.5847, 0.6143, 2.0}
	    --}
	    this:SetTooltip(list)
	    --self.old_count = #list ???
	    
	    iconFrame.show_glow = true
	    
	    --this:SetGlow(list)
	    
	    --this:SetScript("OnUpdate", self.OnUpdate)
	end

	function iconFrame:OnLeave()
		WorldMapTooltip:Hide();
		this.show_glow = false
		--this.old_count = 0 ???
	end


	iconFrame:SetScript("OnEnter", iconFrame.OnEnter);
	iconFrame:SetScript("OnLeave", iconFrame.OnLeave);

	return iconFrame;
end


function Questie:CreateGlowFrame(questHash)
	local w, h = WorldMapFrame:GetWidth(), WorldMapFrame:GetHeight()
	local c, z = GetCurrentMapContinent(), GetCurrentMapZone()
	local _, x_size, y_size = Astrolabe:ComputeDistance(c, z, 0.25, 0.25, c, z, 0.75, 0.75)
	local f = CreateFrame("Button",nil,WorldMapFrame)
	f:SetFrameLevel(8);
	x_size = 200 / x_size * w;
	y_size = 200 / y_size * h;
	f:SetWidth(x_size)  -- Set These to whatever height/width is needed 
	f:SetHeight(y_size) -- for your Texture

	local t = Questie:CreateGlowTexture(f);

	--t:SetPoint("CENTER", f, "TOPLEFT", 0, 0)
    -- Randomly rotate the texture, so they don't all look the same.
    t:SetVertexColor(1,1,1,0.5)
    t:SetAllPoints(f)
    f.texture = t;

	return f;
end



function Questie:CreateGlowTexture(frame)
	local tex = frame:CreateTexture(nil,"BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\Questie\\Icons\\glow")

	local angle = math.random()*6.28318530717958647692528676655900576839433879875021164
	local x, y = math.cos(angle)*0.707106781186547524400844362104849039284835937688474036588339869,
				 math.sin(angle)*0.707106781186547524400844362104849039284835937688474036588339869

	-- Randomly rotate the texture, so they don't all look the same.
	tex:SetTexCoord(x+0.5, y+0.5, y+0.5, 0.5-x, 0.5-y, x+0.5, 0.5-x, 0.5-y)
	tex:ClearAllPoints()
	tex:SetVertexColor(1,1,1,0)
	tex:SetAllPoints(frame)
  
  return tex
end







function Questie:createMinimapFrames()
	for i=1,QUESTIE_MAX_MINIMAP_POINTS do
		local fram = CreateFrame("Frame", "QUESTIE_MINIPOI" .. i, Minimap);
		local tex = fram:CreateTexture("ARTWORK"); -- not sure why this needs "ARTWORK"
		tex:SetAllPoints();
		tex:SetTexture("Interface\\AddOns\\Questie\\Icons\\object"); --placeholder
		fram:SetWidth(16);
		fram:SetHeight(16);
		fram:EnableMouse(true);
		local pass = i; -- Apparently you cant just pass i 
		fram:SetScript("OnEnter", function()
			--log("onEnter");
			tex.previousAlpha = tex:GetAlpha();
			tex:SetAlpha(1.0);
			GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(minimap_poiframe_data[pass]['progress'], 1, 1, 1);
			GameTooltip:AddLine(minimap_poiframe_data[pass]['name'], 1, 1, 0.1);
			GameTooltip:AddLine(minimap_poiframe_data[pass]['questName'], 0.2, 1, 0.4)
			--GameTooltip:SetPoint(fram:GetPoint());
			GameTooltip:Show();
		end)
		fram:SetScript("OnLeave", function()
			--log("onLeave");
			tex:SetAlpha(tex.previousAlpha);
			GameTooltip:Hide();
		end)
		tex:SetAlpha(0.7);
		minimap_poiframes[i] = fram;
		minimap_poiframe_textures[i] = tex;
	end
end

function Questie:hookTooltip()
	local _GameTooltipOnShow = GameTooltip:GetScript("OnShow") -- APPARENTLY this is always null, and doesnt need to be called for things to function correctly...?
	GameTooltip:SetScript("OnShow", function(self, arg)
		local monster = UnitName("mouseover")
		local objective = GameTooltipTextLeft1:GetText();
		if monster then
			for k,v in pairs(QuestieCurrentQuests) do
				local obj = v['objectives'];
				if not (obj == nil) then --- bad habit I know...
					for l,m in pairs(obj) do
						if m['type'] == "monster" then
							if (monster .. " slain") == m['name'] or monster == m['name'] then
								GameTooltip:AddLine(k, 0.2, 1, 0.3)
								GameTooltip:AddLine("   " .. monster .. ": " .. m['count'], 1, 1, 0.2)
							end
						elseif m['type'] == "item" then
							local monroot = QuestieMonsters[monster];
							if monroot then
								local mondat = monroot['drops'];
								if not (mondat == nil) then
									if mondat[m['name']] then
										GameTooltip:AddLine(k, 0.2, 1, 0.3)
										GameTooltip:AddLine("   " .. m['name'] .. ": " .. m['count'], 1, 1, 0.2)
									end
								end
							end
						end
					end
				end
			end
		elseif objective then
			for k,v in pairs(QuestieCurrentQuests) do
				local obj = v['objectives'];
				if ( obj ) then
					for l,m in pairs(obj) do
						if (m["type"] == "object") then
							local i, j = string.gfind(m["name"], objective);
							if(i and j and QuestieObjects[m["name"]]) then
								GameTooltip:AddLine(k, 0.2, 1, 0.3)
								GameTooltip:AddLine("   " .. m['name'], 1, 1, 0.2)
							end
						elseif (m['type'] == "item" and m['name'] == objective) then
							if(QuestieItems[objective]) then
								GameTooltip:AddLine(k, 0.2, 1, 0.3)
								GameTooltip:AddLine("   " .. m['name'] .. ": " .. m['count'], 1, 1, 0.2)
							end
						end
					end
				end
			end
		end
		GameTooltip:Show() -- recalculates size/position
	end)

end

function Questie:OnEvent() -- functions created in "object:method"-style have an implicit first parameter of "this", which points to object || in 1.12 parsing arguments as ... doesn't work
	Questie[event](Questie, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) -- route event parameters to Questie:event methods
end
Questie:SetScript("OnEvent", Questie.OnEvent)

local objectives = {};
local throttle = 0;
local throttleOverride = false;

function Questie:modulo(val, by) -- lua5 doesnt support mod math via the % operator :(
	return val - math.floor(val/by)*by
end
function Questie:HashString(text) -- Computes an Adler-32 checksum. (Thanks QuestHelper)
  local a, b = 1, 0
  for i=1,string.len(text) do
    a = Questie:modulo((a+string.byte(text,i)), 65521)
    b = Questie:modulo((b+a), 65521)
  end
  return b*65536+a
end

function Questie:mixString(mix, str)
	return Questie:mixInt(mix, Questie:HashString(str));
end

function Questie:mixInt(hash, addval)
	return bit.lshift(hash, 6) + addval;
end

function Questie:getQuestHash(name, level, objectiveText)

	
	local questLookup = QuestieLevLookup[name];
	if not (questLookup == nil) then -- cant... stop... doingthis....
		--log("QN " .. name .. " is NULL", 1);
		local count = 0;
		local retval = 0;
		local bestDistance = 4294967295; -- some high number (0xFFFFFFFF)
		for k,v in pairs(questLookup) do
			if k == objectiveText then
				return v; -- exact match
			end
			local dist = Questie:levenshtein(objectiveText, k);
			if dist < bestDistance then
				bestDistance = dist;
				retval = v;
			end
			count = count + 1;
		end
		if not (retval == 0) then
			return retval; -- nearest match
		end
	end
	
	-- hash lookup did not contain qust name!! LOG THIS!!!
	local hash = Questie:mixString(0, name);
	hash = Questie:mixInt(hash, level);
	hash = Questie:mixString(hash, objectiveText);
	return hash;
end


-- Returns the Levenshtein distance between the two given strings
-- credit to https://gist.github.com/Badgerati/3261142
function Questie:levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end
        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end
        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (string.byte(str1,i) == string.byte(str2,j)) then
				cost = 0
			else
				cost = 1
			end
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end
        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

function Questie:RegisterCartographerIcons()
	Cartographer_Notes:RegisterIcon("Complete", {
		text = "Complete",
		path = "Interface\\AddOns\\Questie\\Icons\\complete",
	})
	Cartographer_Notes:RegisterIcon("Available", {
		text = "Available",
		path = "Interface\\AddOns\\Questie\\Icons\\available",
	})
	Cartographer_Notes:RegisterIcon("Loot", {
		text = "Loot",
		path = "Interface\\AddOns\\Questie\\Icons\\loot",
	})
	Cartographer_Notes:RegisterIcon("Event", {
		text = "Event",
		path = "Interface\\AddOns\\Questie\\Icons\\event",
	})
	Cartographer_Notes:RegisterIcon("Object", {
		text = "Object",
		path = "Interface\\AddOns\\Questie\\Icons\\object",
	})
	Cartographer_Notes:RegisterIcon("Slay", {
		text = "Slay",
		path = "Interface\\AddOns\\Questie\\Icons\\slay",
	})
end

function GetQuestLogQuestText()
	Questie.needsUpdate = true;
	return _GetQuestLogQuestText(); -- why was this return removed?
end

local needsRegisterHack = true;

function Questie:OnUpdate(elapsed)
	this = Questie
	if Questie.needsUpdate then
		Questie.needsUpdate = false;
		Questie.throttleOverride = true;
		Questie:QUEST_LOG_UPDATE();
	end
	Astrolabe:OnUpdate(nil, elapsed);
	Questie:NOTES_ON_UPDATE(elapsed);
	local now = GetTime()
	local ttl = math.abs((now - Questie.lastMinimapUpdate)*1000); -- convert to miliseconds
	
	if ttl > 250 then -- seems about right
		--Fix not to reset map, Using old sane values when a player has another map open rather than forcing back the map //Logon
		local fx, fy = Questie:getPlayerPos();
		if ( ( ( fx ) and ( fx == 0 ) ) and ( ( fy ) and ( fy == 0 ) ) ) then
			--DEFAULT_CHAT_FRAME:AddMessage("Questie: Cords equal to 0 using old until data is sane ", 0.95, 0.95, 0.5);
			--DEFAULT_CHAT_FRAME:AddMessage(fx.." "..fy, 0.95, 0.95, 0.5);
			--DEFAULT_CHAT_FRAME:AddMessage(Questie.player_x.." "..Questie.player_y, 0.95, 0.95, 0.5);
		else
			Questie.player_x = fx;
			Questie.player_y = fy;
		end
		sort(QuestieCurrentNotes, sortie);
		Questie:updateMinimap();
		this = QuestieTracker;
		QuestieTracker:fillTrackingFrame();
		this = Questie;
		Questie.lastMinimapUpdate = now;
		--log("UMI: " .. Questie.player_x .. ", " .. Questie.player_y);
		--log(now);
	end
	-- Blizzard quest tracker needs to be hidden
	if(EQL3_Player) then EQL3_QuestWatchFrame:Hide(); end
	QuestWatchFrame:Hide()
end

function Questie:PLAYER_LOGIN()
	--log(this:GetName())
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("ZONE_CHANGED"); -- this actually is needed
	this:RegisterEvent("UI_INFO_MESSAGE");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	
	this:RegisterCartographerIcons();
	this:hookTooltip();
	this:createMinimapFrames();
end

function Questie:PLAYER_ENTERING_WORLD()
	this:clearAllNotes();
	this:fillQuestList();
	this:addAvailableQuests();
end

function Questie:createQuestNote(name, progress, questName, x, y, icon, selected)
	--local id, key = MapNotes_CreateQuestNote(name, lin, olin, x, y, icon, selected)
	--DEFAULT_CHAT_FRAME:AddMessage(icon)
	local zone = Cartographer:GetCurrentEnglishZoneName(); -- wrong
	local _, id, key = Cartographer_Notes:SetNote(zone, x, y, icon, "Questie", "info", progress, "info2", questName, "title", name)
	if (questName == "") then 
		questName = progress; 
	end
	
	this:addNoteToCurrentNotes({
		['id'] = id,
		['x'] = x, 
		['y'] = y,
		['icon'] = icon,
		['questName'] = questName,
		['name'] = name,
		['progress'] = progress,
		['distance'] = 1, -- avoid null error
		['zone'] = zone,
		['zoneID'] = getCurrentMapID() -- bad bad bad
	});
	
	this:addNoteToCurrentQuests(questName, id, name, x, y, key, zone, icon);
end

function distance(x, y)
	return math.abs(x-Questie.player_x) + math.abs(y-Questie.player_y);
end

function euclid(x, y)
	local resultX = math.abs(Questie.player_x-x);
	local resultY = math.abs(Questie.player_y-y);
	return math.sqrt(resultX*resultX + resultY*resultY);
end

function sortie(a, b)
	--[[local distA = tonumber(euclid(a['x'], a['y']));
	local distB = tonumber(euclid(b['x'], b['y']));]]
	local distA = Questie:getPlayerDistTo(a['x'], a['y']);
	local distB = Questie:getPlayerDistTo(b['x'], b['y']);
	a['distance'] = distA;
	b['distance'] = distB;
	
	-- while sorted by distance, might as well add formatedDistnace
	local formatDistance, units  = BWP_FormatDist(Questie.player_x, Questie.player_y, a['x'], a['y']);
	a['formatDistance'] = formatDistance;
	a['formatUnits'] = units;
	formatDistance, units  = BWP_FormatDist(Questie.player_x, Questie.player_y, b['x'], b['y']);
	b['formatDistance'] = formatDistance
	b['formatUnits'] = units;
	
	return distA < distB;
end

function Questie:getNearestNotes()
	sort(QuestieCurrentNotes, sortie)
	if ( table.getn(QuestieCurrentNotes) < 1) then
		return;
	end
	return QuestieCurrentNotes[1]['distance'], QuestieCurrentNotes[table.getn(QuestieCurrentNotes)]['distance'];
end

-- for some reason this only shows 3 notes at MAX_NOTES = 5 - 6 at 10 etc
function Questie:updateMinimap()

	-- clean up all frames
	for k,v in pairs(minimap_poiframes) do
		v:Hide();
	end

	local nearest, farthest = Questie:getNearestNotes();
	local index = 1;
	for k,v in pairs(QuestieCurrentNotes) do
		if not (minimap_poiframes[index]) then break; end
		if( v["zone"] == GetRealZoneText() ) then
			local alpha = (1-(v['distance']/(farthest)));
			local offsX, offsY = getMinimapPosFromCoord(v['x'],v['y'],getCurrentMapID());
			minimap_poiframe_textures[index]:SetTexture("Interface\\AddOns\\Questie\\Icons\\" .. string.lower(v['icon']));
			minimap_poiframe_textures[index]:SetAlpha(alpha);
			minimap_poiframe_data[index] = v;
			minimap_poiframes[index]:SetPoint("CENTER", Minimap, "CENTER", offsX, -offsY);
			minimap_poiframes[index]:Show();
			index = index + 1;
		end
	end
end

function Questie:deleteCurrentNotesforQuest(questName)
	
	local antiLeak = GetTime();
	
	local i = 1;
	while i <= table.getn(QuestieCurrentNotes) do
		local v = QuestieCurrentNotes[i];
		if(v["questName"] == questName) then
			table.remove(QuestieCurrentNotes, i);
			this:removeNoteFromCurrentNotes(v);
		else
			i = i + 1;
		end
		if( GetTime() - antiLeak > 0.2 ) then break; end
	end
end

function Questie:addNoteToCurrentNotes(note)
	local isInNotes = false;
	for k,v in pairs(QuestieCurrentNotes) do
		if (note["id"] == v["id"]) then
			isInNotes = true;
		end
	end
	if(isInNotes == false) then
		table.insert(QuestieCurrentNotes, note);
	end
end

-- needs to be called on clearAllNotes, deleteNoteAfterQuestRemoved, etc
function Questie:removeNoteFromCurrentNotes(note)
	for k,v in pairs(QuestieCurrentNotes) do
		if( v["id"] == note["id"] ) then
			table.remove(QuestieCurrentNotes, k);
			break;
		end
	end
	-- find in QuestieCurrentNotes and delete too
end

function Questie:addNoteToCurrentQuests(questName, id, name, x, y, key, zone, icon)
	if(QuestieCurrentQuests[questName] ~= nil) then
		if(type(QuestieCurrentQuests[questName]["notes"]) ~= "table") then
			QuestieCurrentQuests[questName]["notes"] = {}
		end
		--log("adding notes to quest list for quest "..questName)
		--log(name)
		--log(key)
		--log(zone)
		--log(id)
		QuestieCurrentQuests[questName]["notes"][id] = {
			['name'] = name,
			['x'] = x,
			['y'] = y,
			['id'] = id,
			['icon'] = icon,
			['key'] = key,
			['zone'] = zone,
			['icon'] = icon
		};
	end
end

function Questie:addMonsterToMap(monsterName, info, quest, icon, mapid, selected)
	local monsterdata = QuestieMonsters[monsterName];
	if not (monsterdata == nil) then
		local foundNotes = false;
		for b=1,monsterdata['locationCount'] do -- this should be made more efficient (monsterdata[mapid][locations] etc
			local loc = monsterdata['locations'][b];
			if loc[1] == mapid then
				this:createQuestNote(monsterName, info, quest, loc[2], loc[3], icon, selected);
				foundNotes = true;
			end
		end
		if (foundNotes == false) then
			debug("ERROR NO NOTES  " .. quest .. "  monster:  " .. monsterName .."  on map  ".. mapid);
		end
	else
		debug("ERROR UNKNOWN MONSTER " .. quest .. "  monster:" .. monsterName);
	end
end

function Questie:clearAllNotes()
	for k,v in pairs(minimap_poiframes) do
		v:Hide();
	end
	Cartographer_Notes:ClearMap();
end

function Questie:getPlayerPos()

-- thanks to mapnotes for this "bug fix"
	local fx, fy = GetPlayerMapPosition("player");
	local map = getCurrentMapID(); --Added to get the current Map ID to see if a force reset of the map is needed //Logon
	if ( ( ( fx ) and ( fx == 0 ) ) and ( ( fy ) and ( fy == 0 ) ) ) then
		--Force reset the map because MapID == -1 //Logon
		if	(map == -1) then
			SetMapToCurrentZone();
			--DEFAULT_CHAT_FRAME:AddMessage("Questie: Found strange zone MapID: "..map.." reset to currentZone", 0.95, 0.95, 0.5);
		end
	end
	-- thanks mapnotes
	return fx, fy;
end

function getCurrentMapID()

	--Commented this out to prevent stack overflow (because if an endless loop) it's not even used here //Logon
	--local fx, fy = Questie:getPlayerPos(); -- this: does not work here??

	local file = GetMapInfo()
	
	if file == nil then -- thanks optim for finding a null bug here
		return -1
	end
	
	local zid = QuestieZones[file];
	if zid == nil then
		--DEFAULT_CHAT_FRAME:AddMessage("ERROR: We are in unknown zone " .. file, 0.95, 0.2, 0.2);
		return -1
	else
		return zid[1];
	end
end

local QUESTIE_PFACTION_ID = UnitFactionGroup("Player");
if QUESTIE_PFACTION_ID == "Alliance" then
	QUESTIE_PFACTION_ID = 77;
else
	QUESTIE_PFACTION_ID = 178;
end

function Questie:addAvailableQuests()
	local mapid = getCurrentMapID();
	local level = UnitLevel("Player");
	for l=level-6,level do
		if QuestieZoneLevelMap[mapid] then
			local content = QuestieZoneLevelMap[mapid][l];
			if not (content == nil) then
				for k,v in pairs(content) do
					if not QuestieSeenQuests[v] then
						local qdata = QuestieHashMap[v];
						--log(" value [" .. v .. "] !!!= " .. qdata['name'],1);
						if not (qdata == nil) then
							local requires = qdata['rq'];
							if requires == nil or not (QuestieSeenQuests[requires] == nil) then -- ugly logic...
								local stype = qdata['startedType'];
								local sby = qdata['startedBy'];
								local name = qdata['name'];
								local races = qdata['rr'];
								local classes = qdata['rc'];
								local skill = qdata['rs'];
								if races == nil or races == QUESTIE_PFACTION_ID then -- finsih coding races too
									if skill == nil and classes == nil then -- TEMPORARY CODE THIS
										if stype == "monster" then
											local mob = QuestieMonsters[sby];
											if mob == nil then
												debug("ERROR MISSING QUESTGIVER " .. sby .. " quest:" .. name);
											else 
												local loc = mob['locations'][1];
												this:createQuestNote("Pick up: " .. name, sby, name, loc[2], loc[3], "Available", selected);
											end
											--createQuestNote("Pick up: " .. name, sby, stype, loc[2], loc[3], 9, false);
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

objectiveProcessors = {
	['item'] = function(quest, name, amount, selected, mapid)
		--DEFAULT_CHAT_FRAME:AddMessage("derp", 0.95, 0.95, 0.5);
		local itemdata = QuestieItems[name];
		if itemdata == nil then
			debug("ERROR PROCESSING " .. quest .. "  objective:" .. name);
		else
			for k,v in pairs(itemdata) do
				if k == "locationCount" then
					for b=1,itemdata['locationCount'] do
						local loc = itemdata['locations'][b];
						if loc[1] == mapid then
							Questie:createQuestNote(name, quest, "", loc[2], loc[3], "Loot", selected);
						end
					end
				elseif k == "drop" then
					for e,r in pairs(v) do
						--local monsterdata = QuestRoot['QuestHelper_StaticData']['enUS']['objective']['monster'][e];
						--addMonsterToMap(monsterName, info, quest, selected)
						Questie:addMonsterToMap(e, name .. " (" .. amount .. ")", quest, "Loot", mapid, selected);
					end
				else
					debug("ERROR PROCESSING " .. quest .. "  objective:" .. name);
				end
			end
		end
	end,
	['event'] = function(quest, name, amount, selected, mapid)
		local evtdata = QuestieEvents[name]
		if evtdata == nil then
			debug("ERROR UNKNOWN EVENT " .. quest .. "  objective:" .. name);
		else
			--DEFAULT_CHAT_FRAME:AddMessage("VALIDEVT: " .. name, 0.2, 0.95, 0.2);
			for b=1,evtdata['locationCount'] do
				local loc = evtdata['locations'][b];
				if loc[1] == mapid then
					Questie:createQuestNote(name, quest, "", loc[2], loc[3], "Event", selected);
				end
			end
		end
	end,
	['monster'] = function(quest, name, amount, selected, mapid)
		--DEFAULT_CHAT_FRAME:AddMessage("   MONMON: " .. quest .. ", " .. name .. ", " .. amount, 0.95, 0.2, 0.2);
		Questie:addMonsterToMap(name, amount, quest, "Slay", mapid, selected);
	end,
	['object'] = function(quest, name, amount, selected, mapid)
		local objdata = QuestieObjects[name];
		if objdata == nil then
			debug("ERROR UNKNOWN OBJECT " .. quest .. "  objective:" .. name);
		else
			for b=1,objdata['locationCount'] do
				local loc = objdata['locations'][b];
				if loc[1] == mapid then
					Questie:createQuestNote(name, quest, "", loc[2], loc[3], "Object", selected);
				end
			end
		end
	end

}

function Questie:getQuestFinisherByName(name)

end

function findLast(haystack, needle)
    local i=string.gfind(haystack, ".*"..needle.."()")()
    if i==nil then return nil else return i-1 end
end

function Questie:processObjective(quest, desc, typ, selected, mapid, objectiveid)
	--DEFAULT_CHAT_FRAME:AddMessage(desc, 0.95, 0.95, 0.5);
	local ref = objectiveProcessors[typ];
	
	if not (ref == nil) then
		--DEFAULT_CHAT_FRAME:AddMessage("HANDLED TYPE: " .. typ .. " for quest " .. quest, 0.2, 0.95, 0.95);
		if typ == "item" or typ == "monster" then
			local indx = findLast(desc, ":");
			--DEFAULT_CHAT_FRAME:AddMessage(indx, 0.95, 0.95, 0.5);
			local countstr = string.sub(desc, indx+2);
			local namestr = string.sub(desc, 1, indx-1);
			QuestieCurrentQuests[quest]['objectives'][objectiveid] = {
				['name'] = namestr,
				['count'] = countstr,
				['type'] = typ
			};
			ref(quest, namestr, countstr, selected, mapid);
		else
			ref(quest, desc, "", selected, mapid);
			QuestieCurrentQuests[quest]['objectives'][objectiveid] = {
				['name'] = desc,
				['count'] = -1,
				['type'] = typ
			};
		end
	else
		debug("ERROR: UNHANDLED TYPE: " .. typ .. " \"" .. desc .. "\" for quest " .. quest);
	end
end

function getQuestHashByName(name)
	return QuestieHashes[name];
end

function Questie:QUEST_LOG_UPDATE()
	this:deleteNoteAfterQuestRemoved()
		
	local sind = GetQuestLogSelection();
	local mapid = getCurrentMapID();
	if not throttleOverride then
		if throttle == math.floor(GetTime()) then
			return
		else
			throttle = math.floor(GetTime())
		end
	else
		throttleOverride = false;
	end
	--DEFAULT_CHAT_FRAME:AddMessage(throttle, 0.95, 0.95, 0.5);
	--this:clearAllNotes();
	Questie:addAvailableQuests();
	local numEntries, numQuests = GetNumQuestLogEntries()
	--DEFAULT_CHAT_FRAME:AddMessage(numEntries .. " entries containing " .. numQuests .. " quests in your quest log.");
	for v=1,numEntries do
		local q, level, questTag, isHeader, isCollapsed, isComplete = QuestieCompat_GetQuestLogTitle(v);
		if not isHeader then
            SelectQuestLogEntry(v);
            local count =  GetNumQuestLeaderBoards();
            local selected = v == sind;
            local questComplete = true; -- there might be something in the api for this
            local questText, objectiveText = _GetQuestLogQuestText();
            local hash = Questie:getQuestHash(q, level, objectiveText);
			--log("QH:"..q..","..level..","..objectiveText.."="..hash,1);
            local hashData = QuestieHashMap[hash];
                
            if hash and not isHeader then
                local seen = QuestieSeenQuests[hash];
                if QuestieCurrentQuests[q] == nil then
                    QuestieCurrentQuests[q] = {};
                end
                QuestieCurrentQuests[q]['hash'] = hash; -- needs to store the hash (probably not best to set it every time)
                --log("SEEN " .. q .. " as hash " .. hash, 1)
                if seen == nil or not seen then -- not seen would update it if the user had abandoned then re-picked up
                                                -- someone should tell me if LUA is like C where I could do only "if not seen then" here.
                    QuestieSeenQuests[hash] = true; -- true = in the quest log
                end
                
                if not (hashData == nil) then
                    --log(hashData['finishedBy'], 1);
                    if (count == 0) then
                        Questie:addMonsterToMap(hashData['finishedBy'], "Quest Finisher", q, "Complete", mapid, selected);
                        questComplete = false; -- questComplete is used to add the finisher, this avoids adding it twice
                    end
                else
                    local finisher = QuestieFinishers[q];
                
                    if not (finisher == nil) and (count == 0) then
                        Questie:addMonsterToMap(finisher, "Quest Finisher", q, "Complete", mapid, selected);
                        questComplete = false; -- questComplete is used to add the finisher, this avoids adding it twice
                    end
                end
                --DEFAULT_CHAT_FRAME:AddMessage(q);
                
                -- we're re-evaluating objectives now anyway
                QuestieCurrentQuests[q]['objectives'] = {};
                
                --Start changes done by Logon
                --This checks if all the objectives are done.
                AllDone = true;
                for r=1,count do
                    local desc, typ, done = GetQuestLogLeaderBoard(r);
                    if not done then
                    	AllDone = false;
                    end
                end
                --Logon: If not the objectives are done run Questie old code... don't think it even does anything... otherwise update the objective.
                if(AllDone == false) then
	                for r=1, count do
                    	local desc, typ, done = GetQuestLogLeaderBoard(r);
	                    if not done then
	                        questComplete = false;
	                        if selected then
	                            --DEFAULT_CHAT_FRAME:AddMessage("SELECTED " .. q, 0.95, 0.1, 0.95);
	                        else
	                            --DEFAULT_CHAT_FRAME:AddMessage("NOTSELECTEd " .. q .. " " .. in, 0.95, 0.1, 0.95);
	                        end
	                    end
	                    --Logon: This will process on all if not all objectives are acually done
	                    this:processObjective(q, desc, typ, selected, mapid, r)
	                end
	            else
                    --DEFAULT_CHAT_FRAME:AddMessage("Deleting Notes", 0.95, 0.95, 0.5);
                    --Logon: This is just a fucking copy of the deletequestafterremove function but it works in a really strange way... could not figure that shit out ...
	            	local notes = QuestieCurrentQuests[q]["notes"]
					if (notes ~= nil) then
						for k,v in pairs(notes) do
							--log(v["zone"] .. "  " .. v["x"] .. "  " .. v["y"])
							--DEFAULT_CHAT_FRAME:AddMessage(v["progress"]);
							if _CartographerHasNote(v["zone"], v["x"], v["y"]) then
								Cartographer_Notes:DeleteNote(v["zone"], v["x"], v["y"]);
								this:removeNoteFromCurrentNotes(v);
							end
						end
					end
	            end
	            --End Changes done by Logon

                if not (hashData == nil) then
                    --log(hashData['finishedBy'], 1);
                    --Swapped to isComplete 1 as nil = not complete and -1 = failed.
                    if isComplete == 1 then
                    	--DEFAULT_CHAT_FRAME:AddMessage(q.." : 1"..hashData['finishedBy'], 0.95, 0.95, 0.5);
                        Questie:addMonsterToMap(hashData['finishedBy'], "Quest Finisher", q, "Complete", mapid, selected);
                        questComplete = false; -- questComplete is used to add the finisher, this avoids adding it twice
                    end
                else
                    --DEFAULT_CHAT_FRAME:AddMessage("done", 0.95, 0.95, 0.5);
                    local finisher = QuestieFinishers[q];
                
                    --Swapped to isComplete 1 as nil = not complete and -1 = failed.
                    if not (finisher == nil) and isComplete == 1 then
                   		--DEFAULT_CHAT_FRAME:AddMessage(q.." : 2"..finisher, 0.95, 0.95, 0.5);
                        Questie:addMonsterToMap(finisher, "Quest Finisher", q, "Complete", mapid, selected);
                        questComplete = false; -- questComplete is used to add the finisher, this avoids adding it twice
                    end
                end
                --DEFAULT_CHAT_FRAME:AddMessage(hash);
            elseif not hash and not isHeader then
                debug("ERROR: UNKNOWN QUEST: " .. q);
            end
        end
	end
	SelectQuestLogEntry(sind);
end

function Questie:ZONE_CHANGED() -- this is needed
	SetMapToCurrentZone();
	this:QUEST_LOG_UPDATE();
end

function Questie:UI_INFO_MESSAGE(message)
	--log(message, 1)
end

function Questie:removeAvailableMarker(name) -- this needs to be handled differently anyway
	for id, note in pairs(QuestieCurrentNotes) do	
		--log(id, 1)
		if note['icon'] == "Available" then
			--log(, 1)
			if note['questName'] == name then
				this:removeNoteFromCurrentNotes(note);
				Cartographer_Notes:DeleteNote(note["zone"], note["x"], note["y"]);
			end
		end--else log(note['icon'], 1); end
	end
	--removeNoteFromCurrentNotes
end

function Questie:CHAT_MSG_SYSTEM(message)
	--log(message, 1)
	local index = findLast(message, ":");
	if tonumber(index) == 15 then -- quest accepted
		local questName = string.sub(message, index+2);
		--log("Accepted " .. questName, 1)
		Questie:removeAvailableMarker(questName)
	end
end

local math_mod = math.fmod or math.mod

local function _CartographerRound(num, digits) 
    -- banker's rounding
	local mantissa = 10^digits
	local norm = num*mantissa
	norm = norm + 0.5
	local norm_f = math.floor(norm)
	if norm == norm_f and math_mod(norm_f, 2) ~= 0 then
		return (norm_f-1)/mantissa
	end
	return norm_f/mantissa
end

local function _GetCartographerID(x, y)
    return _CartographerRound(x*1000, 0) + _CartographerRound(y*1000, 0)*1001
end

--Remove local to be able to use it everywhere...
function _CartographerHasNote(zone, x, y) -- underscore because its a method for interacting with another mod, why not
	local id = _GetCartographerID(x, y)
	if rawget(Cartographer_Notes.db.account.pois, zone) then
		if rawget(Cartographer_Notes.db.account.pois[zone], id) then
			return true
		end
	end
	return false
end


function Questie:deleteNoteAfterQuestRemoved()
	local finishedQuest = this:getFinishedQuest();
	if (finishedQuest ~= nil) then
		if( QuestieCurrentQuests[finishedQuest]['hash'] ) then
			-- temporarily commented because it causes issues with available quests
			--QuestieSeenQuests[QuestieCurrentQuests[finishedQuest]['hash']] = false; -- no longer in the list
		end
		--log("finished or abandoned quest " .. finishedQuest)
		local notes = QuestieCurrentQuests[finishedQuest]["notes"]
		if (notes ~= nil) then
			for k,v in pairs(notes) do
				--log(v["zone"] .. "  " .. v["x"] .. "  " .. v["y"])
				if _CartographerHasNote(v["zone"], v["x"], v["y"]) then
					Cartographer_Notes:DeleteNote(v["zone"], v["x"], v["y"]);
				end
			end
		end
		--log("Deleting notes for quest:" .. finishedQuest);
		this:deleteCurrentNotesforQuest(finishedQuest);
		QuestieCurrentQuests[finishedQuest] = nil;
	end
end

function Questie:getFinishedQuest()
	this:validateQuestList();
	for k,v in pairs(QuestieCurrentQuests) do
		if (v['status'] == false) then
			return k;
		end
	end
end

function Questie:fillQuestList()
	for i=1, GetNumQuestLogEntries() do
		local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = QuestieCompat_GetQuestLogTitle(i);
		if not (isHeader) then
			if(type(QuestieCurrentQuests[questLogTitleText]) ~= "table") then
				QuestieCurrentQuests[questLogTitleText] = {}
			end
			QuestieCurrentQuests[questLogTitleText]['status'] = true;
			--log("setting " .. QuestieCompat_GetQuestLogTitle(i) .. " true");
		end
	end
end

function Questie:validateQuestList()
	for k,v in pairs(QuestieCurrentQuests) do
		v['status'] = false;
		--log("setting "..k.." to false");
	end
	
	this:fillQuestList();
end

--taken from MetaMapBWP

function BWP_GetDist(x1, y1, x2, y2)
	if(not x1) or (not x2) then return nil 
	else return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
	end
end

--formats to yards or meters or clicks
function BWP_FormatDist(x1, y1, x2, y2)
	local thisDistance = BWP_GetDist(x1, y1, x2, y2)
	thisDistance = Questie:ConvertToYards(x1, y1, x2, y2) / 10;
	if(true) then
		theseUnits = " Yds"
	else
		thisDistance = thisDistance * 0.9144	
		theseUnits = " Mtrs"
	end
	thisDistance = tonumber(string.format("%.0f" , thisDistance)) -- we dont really need decimal places with this small of units
	return thisDistance, theseUnits
end

function Questie:ConvertToYards(x1, y1, x2, y2)
	if(x1 == nil) then
		x1, y1, x2, y2 = 0, 0, 0, 0;
	end
   -- I think the 40482 thing should be taken from some map scale table? Can't find anything I understand though
   local dx = (x1 - x2) * 40482.686754239;
   local dy = (y1 - y2) * (40482.686754239 / 1.5);
   return math.sqrt(dx * dx + dy * dy)
end

function Questie:getPlayerDistTo(x, y)
	return BWP_GetDist(Questie.player_x, Questie.player_y, x, y);
end

function Questie:getPlayerFormatDistTo(x, y)
	local dist, units = BWP_FormatDist(Questie.player_x, Questie.player_y, x, y)
	return dist
end



