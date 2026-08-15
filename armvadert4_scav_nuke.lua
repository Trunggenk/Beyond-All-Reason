-- Mod Author: CrossGamer
-- Mod Name: Mobile Nuke Tumbleweed

local function makeMobileNuke(unitName)
    if UnitDefs and UnitDefs[unitName] and UnitDefs["armsilo"] then
        local silo_wdefs = UnitDefs["armsilo"].weapondefs
        local silo_weapons = UnitDefs["armsilo"].weapons

        local targetUnit = UnitDefs[unitName]
        targetUnit.weapondefs = targetUnit.weapondefs or {}

        -- Copy weapondefs from armsilo
        for wname, wdata in pairs(silo_wdefs) do
            targetUnit.weapondefs[wname] = {}
            for k, v in pairs(wdata) do
                if type(v) == "table" then
                    targetUnit.weapondefs[wname][k] = {}
                    for k2, v2 in pairs(v) do
                        targetUnit.weapondefs[wname][k][k2] = v2
                    end
                else
                    targetUnit.weapondefs[wname][k] = v
                end
            end

            if wname == "nuclear_missile" then
                targetUnit.weapondefs[wname].stockpiletime = 1
            end
        end

        -- Overwrite weapons completely so the Nuke takes primary slot
        targetUnit.weapons = {}
        for i, wdata in ipairs(silo_weapons) do
            local newWeapon = {}
            for k, v in pairs(wdata) do
                newWeapon[k] = v
            end
            table.insert(targetUnit.weapons, newWeapon)
        end

        targetUnit.canattack = true
    end
end

local function addMIRV(unitName, weaponName)
    if UnitDefs and UnitDefs[unitName] and UnitDefs[unitName].weapondefs and UnitDefs[unitName].weapondefs[weaponName] then
        local wdefs = UnitDefs[unitName].weapondefs
        local motherNuke = wdefs[weaponName]

        local childNuke = {}
        for k, v in pairs(motherNuke) do
            if type(v) == "table" then
                childNuke[k] = {}
                for k2, v2 in pairs(v) do childNuke[k][k2] = v2 end
            else
                childNuke[k] = v
            end
        end

        local childName = weaponName .. "_mirv_child"
        childNuke.name = (childNuke.name or "Nuke") .. " (MIRV Child)"

        if childNuke.customparams then
            childNuke.customparams.speceffect = nil
            childNuke.customparams.cluster_def = nil
            childNuke.customparams.shield_aoe_penetration = nil
        end

        childNuke.weapontype = "Cannon"
        childNuke.range = 1500

        if childNuke.damage then
            for k, v in pairs(childNuke.damage) do
                childNuke.damage[k] = math.floor(v / 2)
            end
        end

        wdefs[childName] = childNuke

        motherNuke.customparams = motherNuke.customparams or {}
        motherNuke.customparams.speceffect = nil
        motherNuke.customparams.cluster_def = childName
        motherNuke.customparams.cluster_number = "2"
        motherNuke.customparams.shield_aoe_penetration = nil
    end
end

makeMobileNuke("armvadert4_scav")
addMIRV("armvadert4_scav", "nuclear_missile")
