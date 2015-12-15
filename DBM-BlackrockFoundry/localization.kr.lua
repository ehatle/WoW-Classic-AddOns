﻿if GetLocale() ~= "koKR" then return end
local L

---------------
-- Gruul --
---------------
L= DBM:GetModLocalization(1161)

L:SetOptionLocalization({
	MythicSoakBehavior	= "신화 난이도에서 지옥불 가르기 조 알림 방식 선택",
	ThreeGroup			= "3개 파티가 1 중첩씩",
	TwoGroup			= "2개 파티가 2 중첩씩" 
})

---------------------------
-- Oregorger, The Devourer --
---------------------------
L= DBM:GetModLocalization(1202)

L:SetOptionLocalization({
	InterruptBehavior	= "차단 경고 설정",
	Smart				= "우두머리 중첩에 따라 알림",
	Fixed				= "무조건 5/3 중첩에 맞춰서 알림(중첩이 맞지 않더라도)"
})


---------------------------
-- The Blast Furnace --
---------------------------
L= DBM:GetModLocalization(1154)

L:SetWarningLocalization({
	warnRegulators			= "열기 조절 장치 남음: %d",
	warnBlastFrequency		= "폭파 시전 빈도 증가됨: 약 %d초 마다 시전",
	specWarnTwoVolatileFire	= "변덕스러운 불 중복됨!"
})

L:SetOptionLocalization({
	warnRegulators			= "열기 조절 장치 남은숫자 알림 보기",
	warnBlastFrequency		= "$spell:155209 시전 빈도 증가시 알림 보기",
	specWarnTwoVolatileFire	= "$spell:176121 중복시 특수 경고 보기",
	InfoFrame				= "$spell:155192 와 $spell:155196 정보를 정보 창으로 보기",
	VFYellType2				= "변덕스러운 불 대화 알림 방식 선택(신화 난이도)",
	Countdown				= "남은시간 초세기",
	Apply					= "받을때만 알리기"
})

L:SetMiscLocalization({
	heatRegulator		= "열기 조절 장치",
	Regulator			= "조절 장치 %d",
	bombNeeded			= "폭탄 %d개 남음"
})

------------------
-- Hans'gar And Franzok --
------------------
L= DBM:GetModLocalization(1155)

L:SetTimerLocalization({
	timerStamperDodge			= DBM_CORE_AUTO_TIMER_TEXTS.nextcount:format("압축기 회피")
})

L:SetOptionLocalization({
	timerStamperDodge			= "다음 압축기 회피 바 보기"
})

--------------
-- Flamebender Ka'graz --
--------------
L= DBM:GetModLocalization(1123)

--------------------
--Kromog, Legend of the Mountain --
--------------------
L= DBM:GetModLocalization(1162)

L:SetMiscLocalization({
	ExRTNotice		= "ExRT 애드온으로부터 위치 받음 (%s|1이;가; 보냄). 당신의 위치: %s"
})

--------------------------
-- Beastlord Darmac --
--------------------------
L= DBM:GetModLocalization(1122)

--------------------------
-- Operator Thogar --
--------------------------
L= DBM:GetModLocalization(1147)

L:SetWarningLocalization({
	specWarnSplitSoon	= "10초 안에 공격대 상하로 분리하세요!",
	InfoFrameSpeed		= "정보 창에서 언제 다음 기차를 보여줄 것인지 설정",
	Immediately			= "등장할 기차 문이 열릴 때(5초전)",
	Delayed				= "기차가 실제로 등장한 후",
	HudMapUseIcons		= "범위정보에 녹색원 대신 전술 목표 아이콘 사용하기"
})

L:SetOptionLocalization({
	specWarnSplitSoon	= "공격대 분리 10초 전에 특수 경고 보기",
	InfoFrameSpeed		= "다음 열차 정보 창 업데이트 시기 설정",
	Immediately			= "다음 열차 등장 문이 열릴 때(5초 전)",
	Delayed				= "열차가 실제로 등장하기 직전",
	TrainVoiceAnnounce	= "다음 열차 음성 안내 방식 선택(신화 난이도)",
	LanesOnly			= "선로 정보만 안내",
	MovementsOnly		= "이동 방향만 안내(신화 난이도)",
	LanesandMovements	= "선로 정보와 이동 방향 동시 안내(신화 난이도)"
})

L:SetMiscLocalization({
	Train			= "기차",
	lane			= "선로",
	oneTrain		= "무작위 선로 1곳: 열차",
	oneRandom		= "무작위 1곳 등장",
	threeTrains		= "무작위 선로 3곳: 열차",
	threeRandom		= "무작위 3곳 등장",
	helperMessage	= "이 전투는 'Thogar Assist' 애드온 또는 DBM 음성안내로 더 좋은 안내를 받으실 수 있습니다. 해당 애드온들은 Curse에서 다운로드 가능합니다."
})

--------------------------
-- The Iron Maidens --
--------------------------
L= DBM:GetModLocalization(1203)

L:SetWarningLocalization({
	specWarnReturnBase	= "지금 본진으로 복귀!"
})

L:SetOptionLocalization({
	specWarnReturnBase	= "무쌍호에서 안전하게 본진으로 복귀할 수 있을때 특수 경고 보기",
	filterBladeDash3	= "$spell:170395 효과가 있을 경우 $spell:155794 특수 경고를 보이지 않기",
	filterBloodRitual3	= "$spell:170405 효과가 있을 경우 $spell:158078 특수 경고를 보이지 않기"
})

L:SetMiscLocalization({
	shipMessage			= "주 대포를 쏠 준비를 합니다!",
	EarlyBladeDash		= "너무 느려."
})

--------------------------
-- Blackhand --
--------------------------
L= DBM:GetModLocalization(959)

L:SetWarningLocalization({
	specWarnMFDPosition		= "표적 피할 위치: %s",
	specWarnSlagPosition	= "폭탄 피할 위치: %s"
})

L:SetOptionLocalization({
	PositionsAllPhases	= "모든 단계에서 $spell:156096 대화 알림시 위치 정보 표기(기본은 3단계에만 사용합니다. 일반적으로는 불필요합니다.)",
	InfoFrame			= "$spell:155992 와 $spell:156530 정보를 정보 창으로 보기"
})

L:SetMiscLocalization({
	customMFDSay	= "%2$s에게 죽음의 표적! (%1$s)",
	customSlagSay	= "%2$s에게 잿가루 폭탄 부착! (%1$s)"
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("BlackrockFoundryTrash")

L:SetGeneralLocalization({
	name =	"검은바위 용광로: 일반구간"
})
