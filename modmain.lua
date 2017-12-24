--get info from modinfo
local mode = GetModConfigData("mode")

PrefabFiles = {
	"takumi",
	"takumi_none",
    "yumi",
    "windarrow",
    "fujinlight",   
	"takumi_dirtpile",
	"takumi_track",
	"takumitrap",
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
	Asset("ATLAS", "images/inventoryimages/takumitrap.xml"),
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

--item names
STRINGS.NAMES.YUMI = "Fujin Yumi"
STRINGS.NAMES.TAKUMI_DIRTPILE = "Suspicious Dirt Pile"
STRINGS.NAMES.TAKUMI_TRACK = "Track"
STRINGS.NAMES.TAKUMITRAP = "Takumi's Trap"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.YUMI = "A bow without a bowstring."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TAKUMITRAP = "A sturdy, well-made trap."
--STRINGS.CHARACTERS.TAKUMI.DESCRIBE.YUMI = "The Fujin Yumi. The bow chose me as its wielder."
STRINGS.RECIPE_DESC.TAKUMITRAP = "A sturdier trap made by a hunter." 


-- The character select screen lines
STRINGS.CHARACTER_TITLES.takumi = "The Wildcard"
STRINGS.CHARACTER_NAMES.takumi = "Takumi"
STRINGS.CHARACTER_DESCRIPTIONS.takumi = "*Wielder of the Divine Bow\n*Distrustful"
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



--Tuning
GLOBAL.TUNING.TAKUMI = {}
GLOBAL.TUNING.TAKUMI.KEY = GetModConfigData("takumi_stat_key") or 107 
TUNING.TAKUMI_LEVEL_MAX = 20
TUNING.TAKUMI_EXP_MAX = 100
TUNING.LEVELUP = 1

TUNING.TAKUMI_HEALTH = 100
TUNING.TAKUMI_HUNGER = 100
TUNING.TAKUMI_SANITY = 75

--Info
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
			if  mode  == "fe_on" then
				inst.components.talker:Say("[Current Lvl ".." : "..(inst.Level).." / "..(TUNING.TAKUMI_LEVEL_MAX).." ]\n[ Current EXP".." : "..(inst.Exp).." / "..(TUNING.TAKUMI_EXP_MAX*inst.Level).." ]\n ")
			elseif mode == "fe_off" then
				inst.components.talker:Say("[Current Lvl ".." : "..(inst.Level).." / "..(TUNING.TAKUMI_LEVEL_MAX).." ]\n[ Current EXP".." : "..(inst.Exp).." / "..(TUNING.TAKUMI_EXP_MAX*inst.Level).." ]\n ")
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





