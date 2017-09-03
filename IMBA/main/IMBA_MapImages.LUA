--Needs to be on top of all Map Packs in case IMBA hasn't loaded its default map images yet
if not IMBA_MapImages then
	IMBA_MapImages={}
end

if not IMBA_MapZones then
	IMBA_MapZones={}
end

--Naxx Boss Maps Included With IMBA
--tinsert(IMBA_MapZones,IMBA_LOCATIONS_KAZZAK);
--tinsert(IMBA_MapZones,IMBA_LOCATIONS_AZUREGOS);
--tinsert(IMBA_MapZones,IMBA_LOCATIONS_EMERISS);
--tinsert(IMBA_MapZones,IMBA_LOCATIONS_LETHON);
--tinsert(IMBA_MapZones,IMBA_LOCATIONS_TAERAR);
--tinsert(IMBA_MapZones,IMBA_LOCATIONS_YSONDRE);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_PVP);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_WORLD);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_NAXX);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_AQ40);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_BWL);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_MC);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_ONY);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_AQ20);
tinsert(IMBA_MapZones,IMBA_LOCATIONS_ZG);
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="0_Blank";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB1"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="1_Lord Kazzak_Blasted Lands";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB2"})--Blasted Lands
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="2_Azuregos_Azshara";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB3"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="3_Emeriss_Feralas";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB4"})--Dream Bough
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="4_Lethon_Hinterlands";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB5"})--Seradane
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="5_Taerar_Duskwood";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB6"})--Twilight Grove
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_WORLD;name="6_Ysondre_Ashenvale";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB7"})--Bough Shadow
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="15_Kel'Thuzad";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB8"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="14_Sapphiron";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB9"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="13_Thaddius";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB10"})--
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="12_Gluth";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB12"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="11_Grobbulus";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB11"})--
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="10_Patchwerk";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB13"})--
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="09_Loatheb";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB14"})--
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="08_Heigan the Unclean";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB15"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="07_Noth the Plaguebringer";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB16"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="06_Four Horsemen";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB17"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="05_Gothik the Harvester";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB18"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="04_Instructor Razuvious";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB19"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="03_Maexxna";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB20"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="02_Grand Widow Faerlina";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB21"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_NAXX;name="01_Anub'Rekhan";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB22"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="9_C'thun";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB23"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="8_Ouro";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB24"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="7_Twin Emperors";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB25"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="6_Princess Huhuran";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB26"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="5_Viscidus";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB27"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="4_Fankriss the Unyielding";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB28"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="3_Battleguard Sartura";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB29"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="2_Bug Trio";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB30"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ40;name="1_The Prophet Skeram";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB31"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="8_Nefarian";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB32"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="7_Chromaggus";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB33"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="6_Flamegor";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB34"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="5_Ebonroc";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB35"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="4_Firemaw";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB36"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="3_Broodlord Lashlayer";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB37"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="2_Vaelastrasz the Corrupt";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB38"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_BWL;name="1_Razorgore the Untamed";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB39"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="10_Ragnaros";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB40"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="09_Majordomo Executus";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB41"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="08_Golemagg the Incinerator";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB42"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="07_Sulfuron Harbinger";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB43"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="06_Shazzrah";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB44"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="05_Baron Geddon";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB45"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="04_Garr";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB46"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="03_Gehennas";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB47"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="02_Magmadar";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB48"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_MC;name="01_Lucifron";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB49"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ONY;name="Onyxia";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB50"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ20;name="6_Ossirian the Unscarred";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB51"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ20;name="5_Ayamiss the Hunter";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB52"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ20;name="4_Buru the Gorger";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB53"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ20;name="3_Moam";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB54"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ20;name="2_General Rajaxx";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB55"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_AQ20;name="1_Kurinnaxx";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB56"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="10_Gahz'ranka";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB57"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="09_Hakkar";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB58"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="08_Jin'do the Hexxer";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB59"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="07_High Priestess Arlokk";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB60"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="06_High Priest Thekal";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB61"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="05_Edge of Madness";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB62"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="04_Bloodlord Mandokir";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB63"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="03_High Priestess Mar'li";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB64"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="02_High Priest Venoxis";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB65"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_ZG;name="01_High Priestess Jeklik";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB66"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="01_AV_North";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB67"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="02_AV_Middle";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB68"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="03_AV_South";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB69"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="04_AB";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB70"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="05_WSG";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB71"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="06_Gurubashi_Arena";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB72"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="07_TheMaul_Arena";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB73"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="08_Darnassis";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB74"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="09_Ironforge";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB75"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="10_Stormwind";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB76"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="11_Undercity";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB77"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="12_ThunderBluff";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB78"})
tinsert(IMBA_MapImages,{zone=IMBA_LOCATIONS_PVP;name="13_Orgrimmar";image="Interface\\AddOns\\IMBA\\textures\\MapImages\\ERB79"})


