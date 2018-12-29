--get info from modinfo
local mode = GetModConfigData("mode")

PrefabFiles = {
	"takumi",
	"takumi_none",
    "yumi",
    "windarrow",
    "fujinlight",   
    "fujinlight2",   
	"takumi_dirtpile",
	"takumi_track",
	"takumitrap",
	"takumi_seal"
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/takumi.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/takumi.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/takumi.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/takumi.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/takumi_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/takumi_silho.xml" ),

    Asset( "IMAGE", "bigportraits/takumi.tex" ),
    Asset( "ATLAS", "bigportraits/takumi.xml" ),
	
	Asset( "IMAGE", "images/map_icons/takumi.tex" ),
	Asset( "ATLAS", "images/map_icons/takumi.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_takumi.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_takumi.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_takumi.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_takumi.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_takumi.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_takumi.xml" ),
	
	Asset( "IMAGE", "images/names_takumi.tex" ),
    Asset( "ATLAS", "images/names_takumi.xml" ),
	
    Asset( "IMAGE", "bigportraits/takumi_none.tex" ),
    Asset( "ATLAS", "bigportraits/takumi_none.xml" ),
	
	Asset( "IMAGE", "images/takumitab.tex" ),
    Asset( "ATLAS", "images/takumitab.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/takumitrap.tex" ),
	Asset( "ATLAS", "images/inventoryimages/takumitrap.xml"),
	
	Asset( "IMAGE", "images/inventoryimages/takumi_seal.tex" ),
	Asset( "ATLAS", "images/inventoryimages/takumi_seal.xml"),
	
	Asset("ATLAS", "images/inventoryimages/yumi.xml"),
    Asset("IMAGE", "images/inventoryimages/yumi.tex"),


}
-- Active key
-- Import the lib use.
modimport("libs/use.lua")

-- Import the mod environment as our environment.
use "libs/mod_env"(env)
-- Imports to keep the keyhandler from working while typing in chat.
use "data/widgets/controls"
use "data/screens/chatinputscreen"
use "data/screens/consolescreen"



local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient
local TUNING = GLOBAL.TUNING

--item names
STRINGS.NAMES.YUMI = "Fujin Yumi"
STRINGS.NAMES.TAKUMI_DIRTPILE = "Suspicious Dirt Pile"
STRINGS.NAMES.TAKUMI_TRACK = "Track"
STRINGS.NAMES.TAKUMITRAP = "Takumi's Trap"
STRINGS.NAMES.TAKUMI_SEAL = "Master Seal"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.YUMI = "A bow without a bowstring."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TAKUMITRAP = "A sturdy, well-made trap."
--STRINGS.CHARACTERS.TAKUMI.DESCRIBE.YUMI = "The Fujin Yumi. The bow chose me as its wielder."
STRINGS.RECIPE_DESC.TAKUMITRAP = "A sturdier trap made by a hunter." 
STRINGS.RECIPE_DESC.TAKUMI_SEAL = "Used to promote at level 20."
STRINGS.RECIPE_DESC.YUMI = "Bow of the wind god."

-- The character select screen lines
STRINGS.CHARACTER_TITLES.takumi = "The Wildcard"
STRINGS.CHARACTER_NAMES.takumi = "Takumi"
STRINGS.CHARACTER_DESCRIPTIONS.takumi = "*Wielder of the Divine Bow\n*Distrustful\n*Skilled at hunting"
STRINGS.CHARACTER_QUOTES.takumi = "\"You can count on me...no matter what some may say.\""

-- Custom speech strings
STRINGS.CHARACTERS.TAKUMI = require "speech_takumi"

-- The character's name as appears in-game 
STRINGS.NAMES.TAKUMI = "Takumi"

AddMinimapAtlas("images/map_icons/takumi.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("takumi", "MALE")







--Hunter Skill
function WorldPrefabPostInit(inst)
		inst:AddComponent("takumihunter")
end
if GLOBAL.TheNet:GetIsServer() then
	AddPrefabPostInit("world", WorldPrefabPostInit)
end


--Adding reciepe tab and item
RECIPETABS.TAKUMI = {str = "TAKUMI", sort = 19, icon = "takumitab.tex", icon_atlas = "images/takumitab.xml"}
--Recipe("takumitrap", {Ingredient("twigs", 2),Ingredient("cutgrass", 6)}, RECIPETABS.TAKUMI, TECH.NONE)

local takumi_trap = AddRecipe("takumitrap", {Ingredient("twigs", 2),Ingredient("cutgrass", 6)}, RECIPETABS.TAKUMI, TECH.NONE, nil, nil, nil, nil, "takumi" )
takumi_trap.atlas = "images/inventoryimages/takumitrap.xml"

local takumi_seal = AddRecipe("takumi_seal", {Ingredient("goldnugget", 20),Ingredient("gears", 1),Ingredient("redgem", 1)}, RECIPETABS.TAKUMI, TECH.NONE, nil, nil, nil, nil, "takumi" )
takumi_seal.atlas = "images/inventoryimages/takumi_seal.xml"

local yumi = AddRecipe("yumi", {Ingredient("rocks", 10),Ingredient("goldnugget", 10)}, RECIPETABS.TAKUMI, TECH.NONE, nil, nil, nil, nil, "takumi" )
yumi.atlas = "images/inventoryimages/yumi.xml"

--Tuning
TUNING.TAKUMI = {}
TUNING.TAKUMI.KEY = GetModConfigData("takumi_level_key") or 107 
TUNING.TAKUMI.KEY2 = GetModConfigData("takumi_stats_key") or 114 

if  mode == "fe_fixed" then
	
	TUNING.TAKUMI_LEVEL_START = 1
	TUNING.TAKUMI_LEVEL_TWENTY = 20
	TUNING.TAKUMI_LEVEL_MAX = 40
	TUNING.TAKUMI_EXP_MAX = 100
	TUNING.LEVELUP = 1
	TUNING.STAT_UP_TYPE = "Fixed"

	TUNING.TAKUMI_HEALTH = 125
	TUNING.TAKUMI_HUNGER = 100
	TUNING.TAKUMI_SANITY = 75
	TUNING.TAKUMI_WALKSPEED = 4
	TUNING.TAKUMI_RUNSPEED = 6
	TUNING.TAKUMI_DAMAGE_MULTIPLIER = 0.8
	TUNING.TAKUMI_DAMAGE_ABSORBTION = 0

elseif mode == "fe_random" then
	
	TUNING.TAKUMI_LEVEL_START = 1
	TUNING.TAKUMI_LEVEL_TWENTY = 20
	TUNING.TAKUMI_LEVEL_MAX = 40
	TUNING.TAKUMI_EXP_MAX = 100
	TUNING.LEVELUP = 1
	TUNING.STAT_UP_TYPE = "Random"

	TUNING.TAKUMI_HEALTH = 125
	TUNING.TAKUMI_HUNGER = 100
	TUNING.TAKUMI_SANITY = 75
	TUNING.TAKUMI_WALKSPEED = 4
	TUNING.TAKUMI_RUNSPEED = 6
	TUNING.TAKUMI_DAMAGE_MULTIPLIER = 0.8
	TUNING.TAKUMI_DAMAGE_ABSORBTION = 0

elseif mode == "fe_max" then
	TUNING.TAKUMI_LEVEL_START = 40
	TUNING.TAKUMI_LEVEL_TWENTY = 20
	TUNING.TAKUMI_LEVEL_MAX = 40
	TUNING.TAKUMI_EXP_MAX = 100
	TUNING.LEVELUP = 0
	TUNING.STAT_UP_TYPE = "Fixed"
	--master seal gives 15 health, 20 hunger, 25 sanity
	
	TUNING.TAKUMI_HEALTH = 300
	TUNING.TAKUMI_HUNGER = 280
	TUNING.TAKUMI_SANITY = 200
	TUNING.TAKUMI_WALKSPEED = 8
	TUNING.TAKUMI_RUNSPEED = 10
	TUNING.TAKUMI_DAMAGE_MULTIPLIER = 1.2
	TUNING.TAKUMI_DAMAGE_ABSORBTION = 0.2
end


--Exp info keypress
local function INFO(inst)
	inst.writing = false
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z, 1, {"_writeable"})
	for k,v in pairs(ents) do
		inst.writing = true
	end 
	
	if not inst.writing then
		local TheInput = TheInput
		
		inst.keep_check = false			
		if not inst.keep_check then		
			inst.keep_check = true	
			if  mode  == "fe_fixed" or mode == "fe_random" then
				if inst:HasTag("classed") then
					inst.components.talker:Say("[Current Lvl ".." : "..(inst.Level).." / "..(TUNING.TAKUMI_LEVEL_MAX).." ]\n[ Current EXP".." : "..(inst.Exp).." / "..(TUNING.TAKUMI_EXP_MAX*inst.Level).." ]\n ")
				else
					inst.components.talker:Say("[Current Lvl ".." : "..(inst.Level).." / "..(TUNING.TAKUMI_LEVEL_TWENTY).." ]\n[ Current EXP".." : "..(inst.Exp).." / "..(TUNING.TAKUMI_EXP_MAX*inst.Level).." ]\n ")
				end
			elseif mode == "fe_max" then
				inst.components.talker:Say("[Current Lvl ".." : "..(TUNING.TAKUMI_LEVEL_MAX).." / "..(TUNING.TAKUMI_LEVEL_MAX).." ]\n[ Current EXP".." : "..(0).." / "..(TUNING.TAKUMI_EXP_MAX*inst.Level).." ]\n ")
			end
			--inst.sg:AddStateTag("notalking")
		elseif inst.keep_check then		
			inst.keep_check = false	
		end
		inst:DoTaskInTime( 0.5, function()
			if inst.keep_check then
				inst.keep_check = false
			end 
		end)
		----inst.components.talker.colour = Vector3(0.7, 0.85, 1, 1)
	end
	
end
AddModRPCHandler("takumi", "INFO", INFO)

	
--Stat info
local function STATS(inst)
	inst.writing = false
	local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z, 1, {"_writeable"})
	for k,v in pairs(ents) do
		inst.writing = true
	end 
	
	if not inst.writing then
		local TheInput = TheInput
		
		inst.keep_check = false			
		if not inst.keep_check then		
			inst.keep_check = true	
			if  mode  == "fe_fixed" then
				inst.components.talker:Say("[Gained Hunger".." : "..(inst.maxhunger-TUNING.TAKUMI_HUNGER).."] \n[ Gained Sanity ".." : "..(inst.maxsanity-TUNING.TAKUMI_SANITY).."]\n [Gained Health".." : "..(inst.maxhealth-TUNING.TAKUMI_HEALTH).."] \n[ Current Speed  ".." : "..(inst.currentwalkspeed).."] \n[ Current Damage Multiplier ".." : "..(inst.damagemultiplier).."] \n[ Current Damage Absorbtion  ".." : "..(inst.damageabsorbtion).."]")
			elseif mode == "fe_random" then
				inst.components.talker:Say("[Gained Hunger".." : "..(inst.maxhunger-TUNING.TAKUMI_HUNGER).."] \n[ Gained Sanity ".." : "..(inst.maxsanity-TUNING.TAKUMI_SANITY).."]\n [Gained Health".." : "..(inst.maxhealth-TUNING.TAKUMI_HEALTH).."] \n[ Current Speed  ".." : "..(inst.currentwalkspeed).."] \n[ Current Damage Multiplier ".." : "..(inst.damagemultiplier).."] \n[ Current Damage Absorbtion  ".." : "..(inst.damageabsorbtion).."]")
			elseif mode == "fe_max" then
				inst.components.talker:Say("[Gained Hunger".." : "..(180).."] \n[ Gained Sanity ".." : "..(125).."]\n [Gained Health".." : "..(200).."] \n[ Current Speed  ".." : "..(8).."] \n[ Current Damage Multiplier ".." : "..(1.2).."] \n[ Current Damage Absorbtion  ".." : "..(.2).."]")	
			end
			
			--inst.sg:AddStateTag("notalking")
		elseif inst.keep_check then		
			inst.keep_check = false	
		end
		inst:DoTaskInTime( 0.5, function()
			if inst.keep_check then
				inst.keep_check = false
			end 
		end)
		----inst.components.talker.colour = Vector3(0.7, 0.85, 1, 1)
	end
	
end
AddModRPCHandler("takumi", "STATS", STATS)
