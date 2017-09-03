# IMBA
NAXX Boss mod + several unique functions for coordination raid, develop tactics and its display in visual form for all raid.

# Original creator
[Cryect](https://wow.curseforge.com/addons/project-2937/)

# Showcase
![](http://imagehost.spark-media.ru/i4/757794F8-242A-1647-E713-E059CF82BA84.png)

# Changelog   		
* Changed names for convenience		
* Changed blank		
* There are 4 variants of maps (each individual map there almost perfectly interchangeable with analogs)			
[Download](https://github.com/0ldi/AddonMaps)			
-minimap_256			
-minimap_128 (lightweight version)			
![](http://imagehost.spark-media.ru/i4/F67A6004-F7FD-F601-99F4-9CEA82CFE8BE.png)			
-air_256 `BY DEFAULT`			
-air_128 (lightweight version)		
![](http://imagehost.spark-media.ru/i4/47EAF6C7-0508-118C-039B-488C0DDEC95A.png)			
* Added AQ40, BWL, MC, ONY, AQ20, ZG, WorldBosses, BGs, Arenas, Capitals	

Based on `IMBA 1.4`

# Instalation
Put `IMBA` folder to `World of Warcraft\Interface\AddOns` 	
For other maps version replace .BLP files from desired folder to 	
`World of Warcraft\Interface\AddOns\IMBA\textures\MapImages` folder

# Detailed description
This is an addon trying to achieve the third generation of information supplied by boss mods. All options can be set via the options window which can be accessed via `/imba`. Windows if hidden will pop up on the start of a boss fight so you can position and close them. 

For the Addons Friendly Neighbor and Tank Finder they have slash commands for targeting a unit in a macro. For Friendly Neighbor its `/targetfn #` where # is the position on the list and the same for Tank Finder except its `/targettf #`. For either of the commands to work the player needs to have the corresponding window open.

Current Addons
-Zul'Gurub
	Hakkar
-Temple of Ahn'Qiraj
	Huhu
	Ouro
	Twin Emperors
	Viscidus
-Naxxramas - Abomination Wing
	Grobbulus
	Gluth
	Thaddius
-Naxxramas - Deathknight Wing
	Razuvious
	Gothik
	Four Horsemen
-Naxxramas - Plague Wing
	Noth the Plaguebringer
	Heigan the Unclean
	Loatheb
-Naxxramas - Spider Wing
	Anub'Rekhan
	Grand Widow Faerlina
	Maexxna
-Naxxramas - Frostwyrm Lair
	Sapphiron
	Kel'Thuzad
	Kel'Thuzad - Interrupt Assister
-Other
	Blackboard
	Friendly Neighbor
	Minimap Marker
	Raid Icon Monitor
	Range Checker
	Tank Finder

Credits
A Function for parsing strings is taken from AIOI
The Templates for enabling & disabling mods is from CTRA (I really liked that setup so figure I would borrow it)
Thanks to MRNaxxramas addon for the basis of the charge detection on Thaddius and the quick confirmation of a few events for a few boss encounters (my own personal old CTRA Boss addons over used events lets say)
Template for the timer bars is based off the template from SWStats
Thanks to Transcriptor for easing my logging of events for AQ40 (I wish I had known of this for Naxx :-p)
