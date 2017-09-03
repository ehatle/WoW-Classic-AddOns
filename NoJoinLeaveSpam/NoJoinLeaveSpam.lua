NoJoinLeaveSpam_MutedChannels = {};

SLASH_NOJOINLEAVESPAM1 = "/nojoinleavespam";
SLASH_NOJOINLEAVESPAM2 = "/njls";

function NoJoinLeaveSpam_Message(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00" .. message);
end

function NoJoinLeaveSpam_MuteChannel(channelName)
	NoJoinLeaveSpam_MutedChannels[channelName] = true;
	NoJoinLeaveSpam_Message("Join / leave messages for channel '" .. channelName .. "' will now be hidden");
end

function NoJoinLeaveSpam_UnmuteChannel(channelName)
	NoJoinLeaveSpam_MutedChannels[channelName] = nil;
	NoJoinLeaveSpam_Message("Join / leave messages for channel '" .. channelName .. "' will now be shown");
end

function NoJoinLeaveSpam_ListMutedChannels()
	local mutedChannels = {};
	for k, v in pairs(NoJoinLeaveSpam_MutedChannels) do
		if v then
			table.insert(mutedChannels, k);
		end
	end

	if table.getn(mutedChannels) > 0 then
		local mutedChannelsString = "";
		for i, v in pairs(mutedChannels) do
			if i > 1 then
				mutedChannelsString = mutedChannelsString .. ", ";
			end
			mutedChannelsString = mutedChannelsString .. v;
		end
		NoJoinLeaveSpam_Message("Join / leave messages are currently muted for the following channels: " .. mutedChannelsString);
	else
		NoJoinLeaveSpam_Message("Currently, no channels are muted");
	end
end

function SlashCmdList.NOJOINLEAVESPAM(message)
	local found, _, channelName = string.find(message, "^%s*mute%s+(%w+)%s*$");
	if found then
		channelName = string.lower(channelName);
		NoJoinLeaveSpam_MuteChannel(channelName);
		return;
	end

	local found, _, channelName = string.find(message, "^%s*unmute%s+(%w+)%s*$");
	if found then
		channelName = string.lower(channelName);
		NoJoinLeaveSpam_UnmuteChannel(channelName);
		return;
	end

	local found = string.find(message, "^%s*muted%s*$");
	if found then
		NoJoinLeaveSpam_ListMutedChannels(channelName);
		return;
	end

	-- Otherwise, show instructions
	NoJoinLeaveSpam_Message("Usage: /njls mute <channel name>");
	NoJoinLeaveSpam_Message("Usage: /njls unmute <channel name>");
	NoJoinLeaveSpam_Message("Usage: /njls muted");
end

local ChatFrame_OnEvent_Old;
function NoJoinLeaveSpam_OnEvent()
	if strsub(event, 1, 16) == "VARIABLES_LOADED" then
		if ChatFrame_OnEvent_Old == nil then
			ChatFrame_OnEvent_Old = ChatFrame_OnEvent;
			ChatFrame_OnEvent = ChatFrame_OnEvent_New;
		end
	end
end

function NoJoinLeaveSpam_ShouldMute(channelName)
	return NoJoinLeaveSpam_MutedChannels[channelName];
end

function ChatFrame_OnEvent_New()
	if (event == "CHAT_MSG_CHANNEL_JOIN") or
	   (event == "CHAT_MSG_CHANNEL_LEAVE") or
	   (arg1 == "CHAT_MSG_CHANNEL_NOTICE_USER" and arg1 == "OWNER_CHANGED") then
	    local channelName = string.lower(arg9);
	    local channelNumber = arg8;

	    if NoJoinLeaveSpam_ShouldMute(channelName, channelNumber) then
	    	-- ignore
	    else
	    	-- pass
	    	ChatFrame_OnEvent_Old(event);
	    end
	else
		-- pass
		ChatFrame_OnEvent_Old(event);
	end
end

local f = CreateFrame("frame");
f:RegisterEvent("VARIABLES_LOADED");
f:RegisterEvent("CHAT_MSG_CHANNEL_JOIN");
f:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE");
f:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE_USER");
f:SetScript("OnEvent", NoJoinLeaveSpam_OnEvent)
