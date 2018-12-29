
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("ANIM","anim/takumi_classed.zip"),
}
local prefabs = 
{
	
}

-- Custom starting items
local start_inv =
{
	"yumi",
}


local function GetExp(inst)
	if TUNING.LEVELUP == 0 then return end
	
	if inst.Level == 20 and inst:HasTag("classed") then 
		inst.maxlevel = TUNING.TAKUMI_LEVEL_MAX
	elseif inst.Level > 20 then
		inst.maxlevel = TUNING.TAKUMI_LEVEL_MAX
	else
		inst.maxlevel = TUNING.TAKUMI_LEVEL_TWENTY
	end
	
	local MAX_EXP = TUNING.TAKUMI_EXP_MAX*inst.Level
	
	local levelup = false
	
	local currentlvl = inst.Level
	
	--lvl up
	if inst.Level < inst.maxlevel then	
		while inst.Exp >= MAX_EXP do
			inst.Exp = inst.Exp - MAX_EXP
			inst.Level = inst.Level + 1
			levelup = true
			MAX_EXP = TUNING.TAKUMI_EXP_MAX*inst.Level
		end
	elseif inst.Level > inst.maxlevel then
		inst.Level= inst.maxlevel
		
	elseif inst.Level == inst.maxlevel then
		inst.Exp = 0
	end
	
	local lvlup = inst.Level- currentlvl
	if levelup == true and TUNING.STAT_UP_TYPE == "Fixed" then
		
		--add stats for each lvl
		for i = 1, lvlup, 1 do  
			inst.maxhealth = inst.maxhealth +  4
			inst.maxhunger = inst.maxhunger + 4
			inst.maxsanity = inst.maxsanity + 2.5
			inst.currentwalkspeed = inst.currentwalkspeed + 0.1
			inst.currentrunspeed = inst.currentrunspeed + 0.1
			inst.damagemultiplier = inst.damagemultiplier+ 0.01
			inst.damageabsorbtion = inst.damageabsorbtion + 0.005
			
	
		end
		local hunger_percent = inst.components.hunger:GetPercent()
		local health_percent = inst.components.health:GetPercent()
		local sanity_percent = inst.components.sanity:GetPercent()
		inst.components.health.maxhealth = math.ceil (inst.maxhealth)		
		inst.components.hunger.max = math.ceil (inst.maxhunger)			
		inst.components.sanity.max = math.ceil (inst.maxsanity)			
		inst.components.locomotor.walkspeed = math.ceil (inst.currentwalkspeed)	
		inst.components.locomotor.runspeed = math.ceil (inst.currentrunspeed)	
		inst.components.hunger:SetPercent(hunger_percent)
		inst.components.health:SetPercent(health_percent)
		inst.components.sanity:SetPercent(sanity_percent)
		inst.components.combat.damagemultiplier = inst.damagemultiplier
		inst.components.health:SetAbsorptionAmount(inst.damageabsorbtion)
		
		inst.components.talker:Say("[LEVEL UP!]")
		
		
		if inst.Level == 21 then
			inst.components.talker:Say("[CLASS UP!]")
		end		
	elseif levelup == true and TUNING.STAT_UP_TYPE == "Random" then
		local speed = 1/10
		local damagemultiplier = 1/100
		local damageabsorbtion = 1/1000
	
		for i = 1, lvlup, 1 do  
			inst.increasehealth = math.random(0,8)
			inst.increasehunger = math.random(0,8)
			inst.increasesanity = math.random(0,5)
			inst.increasespeed = math.random(0,2)*speed
			inst.increasedamage = math.random(0,2)*damagemultiplier
			inst.increasedamageabsorbtion= math.random(0,10)*damageabsorbtion
			
		
			inst.maxhealth = inst.maxhealth +  inst.increasehealth
			inst.maxhunger = inst.maxhunger + inst.increasehunger
			inst.maxsanity = inst.maxsanity + inst.increasesanity
			inst.currentwalkspeed = inst.currentwalkspeed + inst.increasespeed 
			inst.currentrunspeed = inst.currentrunspeed + inst.increasespeed 
			inst.damagemultiplier = inst.damagemultiplier + inst.increasedamage
			inst.damageabsorbtion = inst.damageabsorbtion + inst.increasedamageabsorbtion
			
	
		end
		local hunger_percent = inst.components.hunger:GetPercent()
		local health_percent = inst.components.health:GetPercent()
		local sanity_percent = inst.components.sanity:GetPercent()
		inst.components.health.maxhealth = math.ceil (inst.maxhealth)		
		inst.components.hunger.max = math.ceil (inst.maxhunger)			
		inst.components.sanity.max = math.ceil (inst.maxsanity)			
		inst.components.locomotor.walkspeed = math.ceil (inst.currentwalkspeed)	
		inst.components.locomotor.runspeed = math.ceil (inst.currentrunspeed)	
		inst.components.hunger:SetPercent(hunger_percent)
		inst.components.health:SetPercent(health_percent)
		inst.components.sanity:SetPercent(sanity_percent)
		inst.components.combat.damagemultiplier = inst.damagemultiplier
		inst.components.health:SetAbsorptionAmount(inst.damageabsorbtion)
		
		
		
		inst.weightedstatchange = inst.increasehealth/4 + inst.increasehunger/4 + inst.increasesanity/2.5 + inst.increasespeed*10+ inst.increasedamage*100+  inst.increasedamageabsorbtion*200
		print(inst.increasehealth/4)
		print(inst.increasehunger/4 )		
		print(inst.increasesanity/2.5)		
		print(inst.increasespeed*10)		
		print(inst.increasedamage*100)
		print(inst.increasedamageabsorbtion*200)
		print(inst.weightedstatchange)
		
		
		if inst.weightedstatchange > 7 then
			inst.components.talker:Say("Phew! Nice growth!")
		elseif inst.weightedstatchange < 5 then
			inst.components.talker:Say("What? It happens!")
		else
			inst.components.talker:Say("All right. Not bad.")
		end
		
		
		if inst.Level == 21 then
			inst.components.talker:Say("[CLASS UP!]")
		end		
		
	end
	
	if inst.Level == 20 then
		inst:AddTag("canclassup")
		print("Can Class Up")
	end

end

--check if victim is valid
local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("companion") or
				victim:HasTag("birchnutdrake"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

--On kill run
local function OnKill(inst, data)

    local victim = data.victim
    if IsValidVictim(victim) then

		if victim:HasTag("epic") then
			inst.Exp = inst.Exp + 2000
		elseif victim:HasTag("nightmarecreature") or victim:HasTag("character") then
			inst.Exp = inst.Exp + 20
		elseif victim:HasTag("worm") or victim:HasTag("WORM_DANGER") then
			inst.Exp = inst.Exp + 20
		elseif victim:HasTag("shadowchesspiece") or victim:HasTag("tentacle_pillar") then
			inst.Exp = inst.Exp + 30
		elseif victim:HasTag("largecreature") or victim:HasTag("mossling") then
			inst.Exp = inst.Exp + 20
		elseif victim:HasTag("monster") or victim:HasTag("merm") then
			inst.Exp = inst.Exp + 10
		else
			inst.Exp = inst.Exp + 1
		end
		GetExp(inst)
	end
end

local function classup (inst)
	if inst.Level == 20 then
		print("Classup")
		inst:AddTag("classed")
		inst:RemoveTag("canclassup")
		inst:RemoveTag("insomniac")
		inst.components.sanity.night_drain_mult = 1
		inst.components.sanity.neg_aura_mult = 1
		inst.maxhealth = inst.maxhealth + 15
		inst.maxhunger = inst.maxhunger + 20
		inst.maxsanity = inst.maxsanity + 25
		inst.Exp = 2000
		GetExp(inst)
		print("classup")
		
		
		inst.AnimState:SetBuild("takumi_classed")
		--local fx1 = SpawnPrefab("wathgrithr_spirit")
		--fx1.Transform:SetPosition(inst.Transform:GetWorldPosition());fx1.Transform:SetScale(1,1,1)
		SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
	end
end


-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when reviving from ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "takumi_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:SetExternalSpeedMultiplier(inst, "takumi_speed_mod",1)
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)
	
	if inst:HasTag("classed") then 
		inst.AnimState:SetBuild("takumi_classed")
	end

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end



--load data for exp
local function onpreload(inst, data)
	if data ~= nil then
		if data.Level then
			inst.Level = data.Level
			GetExp(inst)
			
			if data.health and data.health.health then  inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then  inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)
			inst.components.sanity:DoDelta(0)
			
			if inst.Level > 20 then inst:AddTag("classed") end
			if inst.Level == 20 then inst:AddTag("canclassup") end
			
		end
		if data.Exp then
			inst.Exp = data.Exp
			GetExp(inst)
		end
		if data.maxhealth then
			inst.maxhealth = data.maxhealth
		end
		if data.maxhunger then
			inst.maxhunger = data.maxhunger
		end
		if data.maxsanity then  
			inst.maxsanity = data.maxsanity
		end
		if data.currentwalkspeed then
			inst.currentwalkspeed = data.currentwalkspeed
		end
		if data.currentrunspeed then
			inst.currentrunspeed = data.currentrunspeed
		end
		if data.damagemultiplier then
			inst.damagemultiplier = data.damagemultiplier
		end
		if data.damageabsorbtion then
			inst.damageabsorbtion = data.damageabsorbtion
		end
		if TUNING.LEVELUP == 1 then
			inst.components.health.maxhealth = math.ceil (inst.maxhealth)		
			inst.components.hunger.max = math.ceil (inst.maxhunger)			
			inst.components.sanity.max = math.ceil (inst.maxsanity)			
			inst.components.locomotor.walkspeed = math.ceil (inst.currentwalkspeed)	
			inst.components.locomotor.runspeed = math.ceil (inst.currentrunspeed)	
			inst.components.combat.damagemultiplier = inst.damagemultiplier
			inst.components.health:SetAbsorptionAmount(inst.damageabsorbtion)
		end
	
	end
	
end

--save lvl data
local function onsave(inst, data)
	data.Level = inst.Level
	data.Exp = inst.Exp
	data.maxhealth  = inst.maxhealth 
	data.maxhunger =inst.maxhunger 
	data.maxsanity = inst.maxsanity 
	data.currentwalkspeed = inst.currentwalkspeed 
	data.currentrunspeed = inst.currentrunspeed 
	data.damagemultiplier = inst.damagemultiplier
	data.damageabsorbtion = inst.damageabsorbtion
end
-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	
	if TUNING.LEVELUP ~= 0 then
		inst:AddTag("insomniac")
	end
		
	inst:AddTag("takumi")
	 
	inst.MiniMapEntity:SetIcon( "takumi.tex" )
	
	inst.Level = TUNING.TAKUMI_LEVEL_START
	inst.Exp = 0
	inst.maxhealth = TUNING.TAKUMI_HEALTH
	inst.maxhunger = TUNING.TAKUMI_HUNGER
	inst.maxsanity = TUNING.TAKUMI_SANITY
	inst.currentwalkspeed = TUNING.TAKUMI_WALKSPEED
	inst.currentrunspeed  = TUNING.TAKUMI_RUNSPEED
	inst.damagemultiplier = TUNING.TAKUMI_DAMAGE_MULTIPLIER 
	inst.damageabsorbtion = TUNING.TAKUMI_DAMAGE_ABSORBTION
	

	
	--stat info
	inst:AddComponent("keyhandler")
	inst.components.keyhandler:AddActionListener("takumi", TUNING.TAKUMI.KEY, "INFO")
	inst.components.keyhandler:AddActionListener("takumi", TUNING.TAKUMI.KEY2, "STATS")
	
	
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wilson"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
        --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.TAKUMI_HEALTH)
	inst.components.hunger:SetMax(TUNING.TAKUMI_HUNGER)
	inst.components.sanity:SetMax(TUNING.TAKUMI_SANITY)
	inst.components.locomotor.walkspeed = math.ceil (TUNING.TAKUMI_WALKSPEED)	
	inst.components.locomotor.runspeed = math.ceil (TUNING.TAKUMI_RUNSPEED)	
	inst.components.combat.damagemultiplier = inst.damagemultiplier
	inst.components.health:SetAbsorptionAmount(inst.damageabsorbtion)
	
	

	

	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	-- Sanity rate (optional)
	inst.components.sanity.night_drain_mult = 1.5
    inst.components.sanity.neg_aura_mult = 1.75
	
	
	--level up info
	inst.Level = TUNING.TAKUMI_LEVEL_START
	inst.Exp = 0
	inst.maxhealth = TUNING.TAKUMI_HEALTH + 4
	inst.maxhunger = TUNING.TAKUMI_HUNGER + 4
	inst.maxsanity = TUNING.TAKUMI_SANITY + 2.5
	inst.currentwalkspeed = TUNING.TAKUMI_WALKSPEED + 0.1
	inst.currentrunspeed  = TUNING.TAKUMI_RUNSPEED + 0.1
	inst.damagemultiplier = TUNING.TAKUMI_DAMAGE_MULTIPLIER + 0.01
	inst.damageabsorbtion = TUNING.TAKUMI_DAMAGE_ABSORBTION + 0.005
	inst:ListenForEvent("killed", OnKill)
	inst:ListenForEvent("fireemblemclassup", classup)
	
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	
end

return MakePlayerCharacter("takumi", prefabs, assets, common_postinit, master_postinit, start_inv)