﻿if GetLocale() ~= "koKR" then return end
local L

---------------
-- Hellfire Assault --
---------------
L= DBM:GetModLocalization(1426)

L:SetTimerLocalization({
	timerSiegeVehicleCD	= "다음 공성 차량: %s"
})

L:SetOptionLocalization({
	timerSiegeVehicleCD =	"다음 공성 차량 바 보기"
})

L:SetMiscLocalization({
	AddsSpawn1		=	"Comin' in hot!",--Blizzard seems to have disabled these (찾지 못함)
	AddsSpawn2		=	"Fire in the hole!",--Blizzard seems to have disabled these (찾지 못함)
	BossLeaving		=	"I'll be back..."--조금만 기다리라고...
})

---------------------------
-- Iron Reaver --
---------------------------
L= DBM:GetModLocalization(1425)

---------------------------
-- Hellfire High Council --
---------------------------
L= DBM:GetModLocalization(1432)

L:SetWarningLocalization({
	reapDelayed =	"악몽의 형상 종료 후 수확"
})

------------------
-- Kormrok --
------------------
L= DBM:GetModLocalization(1392)

L:SetMiscLocalization({
	ExRTNotice		= "ExRT 애드온으로부터 위치 받음 (%s|1이;가; 보냄). 당신의 위치 - 주황색: %s, 녹색: %s, 보라색: %s"
})

--------------
-- Kilrogg Deadeye --
--------------
L= DBM:GetModLocalization(1396)

L:SetMiscLocalization({
	BloodthirstersSoon		=	"와라, 형제들이여! 운명을 손에 넣어라!"
})

--------------------
--Gorefiend --
--------------------
L= DBM:GetModLocalization(1372)

L:SetTimerLocalization({
	SoDDPS2		= "다음 그림자 (%s)",
	SoDTank2	= "다음 그림자 (%s)",
	SoDHealer2	= "다음 그림자 (%s)"
})

L:SetOptionLocalization({
	SoDDPS2		= "다음 $spell:179864 대상 바 보기(공격 전담)",
	SoDTank2	= "다음 $spell:179864 대상 바 보기(방어 전담)",
	SoDHealer2	= "다음 $spell:179864 대상 바 보기(치유 전담)",
	ShowOnlyPlayer	= "$spell:179909 대상일 경우에만 범위정보 표시"
})

--------------------------
-- Shadow-Lord Iskar --
--------------------------
L= DBM:GetModLocalization(1433)

L:SetWarningLocalization({
	specWarnThrowAnzu =	"%s에게 안주의 눈 투척!"
})

L:SetOptionLocalization({
	specWarnThrowAnzu =	"$spell:179202을 던져야 할 경우 특수 경고 보기"
})

--------------------------
-- Fel Lord Zakuun --
--------------------------
L= DBM:GetModLocalization(1391)

L:SetOptionLocalization({
	SeedsBehavior		= "씨앗 위치 알림 방법 설정(공격대장 권한 필요)",
	Iconed				= "별, 동그라미, 다이아, 역삼각형, 달(기둥 위치를 사용할 경우)",--Default
	Numbered			= "1, 2, 3, 4, 5(번호로 지정된 위치를 사용할 경우)",
	DirectionLine		= "왼쪽, 중앙 왼쪽, 중앙, 중앙 오른쪽, 오른쪽.(일직선 진형을 사용할 경우)",
	FreeForAll			= "위지 지정하지 않음. 기본 대화 알림 사용"
})

L:SetMiscLocalization({
	DBMConfigMsg		= "씨앗 위치 알림 방법이 공격대장 설정과 동일하게 하기 위해 %s로 설정되었습니다.",
	BWConfigMsg			= "공격대장이 BigWigs를 사용합니다. BigWigs와 동일한 경고를 하기 위해 번호 알림으로 설정됩니다."
})

--------------------------
-- Xhul'horac --
--------------------------
L= DBM:GetModLocalization(1447)

L:SetOptionLocalization({
	ChainsBehavior		= "지옥의 사슬 대상 경고 방식 설정",
	Cast				= "시전 시작시 바라보는 대상만 알림. 바는 시전 시작에 맞추어 갱신됩니다.",
	Applied				= "시전 완료후 약화 효과 대상 알림. 바는 시전 완료에 맞추어 갱신됩니다.",
	Both				= "시전 시작 및 완료시 모두 알림"
})

--------------------------
-- Socrethar the Eternal --
--------------------------
L= DBM:GetModLocalization(1427)

L:SetOptionLocalization({
	InterruptBehavior	= "지배권 행사 차단 경고 방식 설정(공객대장 권한 필요)",
	Count3Resume		= "3명 차단, 보호막 종료 후 차단 횟수 유지",--Default
	Count3Reset			= "3명 차단, 보호막 종료 후 1번부터 다시 시작",
	Count4Resume		= "4명 차단, 보호막 종료 후 차단 횟수 유지",
	Count4Reset			= "4명 차단, 보호막 종료 후 1번부터 다시 시작"
})

--------------------------
-- Tyrant Velhari --
--------------------------
L= DBM:GetModLocalization(1394)

--------------------------
-- Mannoroth --
--------------------------
L= DBM:GetModLocalization(1395)

L:SetMiscLocalization({
	felSpire		=	"힘을 불어넣기 시작합니다!"
})

--------------------------
-- Archimonde --
--------------------------
L= DBM:GetModLocalization(1438)

L:SetWarningLocalization({
	specWarnBreakShackle	= "구속된 고통: %s로 빠지세요!"
})

L:SetOptionLocalization({
	specWarnBreakShackle	= "$spell:184964 대상이 된 경우 특수 경고 보기(빠지는 순서가 자동으로 할당됩니다.)",
	ExtendWroughtHud2		= "$spell:185014 대상에게 범위정보 연장(선모양이 부정확할 수 있습니다.)",
	AlternateHudLine		= "$spell:185014 대상에게 다른 범위정보 무늬 사용",
	NamesWroughtHud			= "$spell:185014 대상 이름을 포함한 범위정보 보기",
	FilterOtherPhase		= "당신과 다른 위상에 있는 주문 경고 숨기기"
})

L:SetMiscLocalization({
	phase2point5		= "보아라, 불타는 군단의 무한한 힘을. 깨달아라. 저항해도 소용없음을.",--3 seconds faster than CLEU, used as primary, slower CLEU secondary
	First				= "첫번째",
	Second				= "두번째",
	Third				= "세번째",
	Fourth				= "네번째",--Just in case, not sure how many targets in 30 man raid
	Fifth				= "다섯번째"--Just in case, not sure how many targets in 30 man raid
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("HellfireCitadelTrash")

L:SetGeneralLocalization({
	name =	"지옥불 성채: 일반구간"
})
