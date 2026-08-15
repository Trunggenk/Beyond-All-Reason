-- Mod Author: CrossGamer
-- Mod Name: Boss V4 Nuke MIRV

local function addBossNuke()
    if UnitDefs and UnitDefs["scavengerbossv4"] and UnitDefs["armsilo"] then
        local boss = UnitDefs["scavengerbossv4"]
        local siloWDefs = UnitDefs["armsilo"].weapondefs

        -- Prevent nil lookup if armsilo lacks this weapondef
        if not siloWDefs or not siloWDefs["nuclear_missile"] then return end
        local nukeDef = siloWDefs["nuclear_missile"]

        boss.weapondefs = boss.weapondefs or {}

        -- Deep copy mother nuke
        local motherNuke = {}
        for k, v in pairs(nukeDef) do
            if type(v) == "table" then
                motherNuke[k] = {}
                for k2, v2 in pairs(v) do motherNuke[k][k2] = v2 end
            else
                motherNuke[k] = v
            end
        end

        -- Modify mother nuke to 1s reload.
        -- Keep stockpile = true and commandfire = true so engine treats it as a superweapon.
        motherNuke.name = "Boss MIRV Nuke"
        motherNuke.reloadtime = 1
        motherNuke.stockpile = true
        motherNuke.stockpiletime = 1 -- 1 second to build a nuke
        motherNuke.energypershot = 0 -- prevent stall for 1s reload
        motherNuke.metalpershot = 0
        motherNuke.commandfire = true

        -- Expand stockpile limit just in case
        motherNuke.customparams = motherNuke.customparams or {}
        motherNuke.customparams.stockpilelimit = 100

        -- Define MIRV child
        local childNuke = {}
        for k, v in pairs(motherNuke) do
            if type(v) == "table" then
                childNuke[k] = {}
                for k2, v2 in pairs(v) do childNuke[k][k2] = v2 end
            else
                childNuke[k] = v
            end
        end

        local childName = "boss_mirv_child"
        childNuke.name = "Boss MIRV Nuke (Child)"
        childNuke.weapontype = "Cannon"
        childNuke.range = 1500

        if childNuke.customparams then
            childNuke.customparams.speceffect = nil
            childNuke.customparams.cluster_def = nil
            childNuke.customparams.shield_aoe_penetration = nil
            -- keep nuclear = 1 so the engine still treats explosion as nuke
        end

        if childNuke.damage then
            for k, v in pairs(childNuke.damage) do
                childNuke.damage[k] = math.floor(v / 6)
            end
        end

        -- Link mother to child
        motherNuke.customparams.speceffect = nil
        motherNuke.customparams.cluster_def = childName
        motherNuke.customparams.cluster_number = "6"
        motherNuke.customparams.shield_aoe_penetration = nil
        motherNuke.customparams.nuclear = 1 -- explicitly mark as nuke

        boss.weapondefs["boss_nuke_mirv"] = motherNuke
        boss.weapondefs[childName] = childNuke

        -- Replace weapon #7
        if boss.weapons and boss.weapons[7] then
            boss.weapons[7].def = "boss_nuke_mirv"
        end

        -- Important: enable the boss to actually use commandfire superweapons
        boss.canattack = true
    end
end

addBossNuke()
