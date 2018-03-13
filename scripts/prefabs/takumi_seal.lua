local assets =
{ 
    Asset("ANIM", "anim/takumi_seal.zip"),
	Asset( "IMAGE", "images/inventoryimages/takumi_seal.tex" ),
	Asset("ATLAS", "images/inventoryimages/takumi_seal.xml"),
	Asset("ANIM","anim/takumi_classed.zip"),
}

local function OnUseSeal(inst)

	local owner = inst.components.inventoryitem.owner

	
	if owner:HasTag("classed") then  --Takumi has already classed up
		inst.components.useableitem:StopUsingItem()
		inst.components.talker:Say("Nothing happened.")
	elseif owner:HasTag("canclassup") then --Takumi is ready to class up
		owner:PushEvent("fireemblemclassup")
		inst.AnimState:SetBuild("takumi_classed")
		inst.components.useableitem:StopUsingItem()
		if inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
            inst.components.stackable:Get():Remove()
        else
            inst:Remove()
        end
	else
		inst.components.useableitem:StopUsingItem()
		inst.components.talker:Say("I need to get stronger.")
	end
	
	
	
end

local function shine(inst)
    if not inst.AnimState:IsCurrentAnimation("sparkle") then
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:PushAnimation("idle", false)
    end
    inst:DoTaskInTime(4 + math.random() * 5, shine)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    --MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("goldnugget")
    inst.AnimState:SetBuild("takumi_seal")
    inst.AnimState:PlayAnimation("idle")
	

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

--	inst.AddTag("master_seal")
	inst:AddTag("molebait")	

	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/takumi_seal.xml"

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
    inst:AddComponent("stackable")
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 2
	
	
	inst:AddComponent("talker")
	inst:AddComponent("armor")

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	
	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(OnUseSeal)
	--inst.components.useableitem:SetOnStopUseFn(OffUseSeal)
	
	
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	
	
    MakeHauntableLaunch(inst)

    shine(inst)
	

    return inst
end

return Prefab("common/inventory/takumi_seal", fn, assets,prefabs)