-- Mod Author: CrossGamer
-- Mod Name: Scavenger Beacon to Nuke Silo

local function makeSilo(beaconName, tier)
    if UnitDefs and UnitDefs[beaconName] and UnitDefs["armsilo"] then
        local armsilo_wdefs = UnitDefs["armsilo"].weapondefs
        local armsilo_weapons = UnitDefs["armsilo"].weapons

        local scav = UnitDefs[beaconName]
        scav.weapondefs = {}

        for wname, wdata in pairs(armsilo_wdefs) do
            scav.weapondefs[wname] = {}
            for k, v in pairs(wdata) do
                if type(v) == "table" then
                    scav.weapondefs[wname][k] = {}
                    for k2, v2 in pairs(v) do
                        scav.weapondefs[wname][k][k2] = v2
                    end
                else
                    scav.weapondefs[wname][k] = v
                end
            end

            -- Adjust stockpiletime based on tier
            if scav.weapondefs[wname].stockpiletime then
                if tier == 2 then
                    scav.weapondefs[wname].stockpiletime = math.floor(scav.weapondefs[wname].stockpiletime / 3)
                elseif tier == 3 then
                    scav.weapondefs[wname].stockpiletime = 30
                elseif tier == 4 then
                    scav.weapondefs[wname].stockpiletime = 10
                end
                -- Tier 1 remains unchanged (normal)
            end
        end

        scav.weapons = {}
        for i, wdata in pairs(armsilo_weapons) do
            scav.weapons[i] = {}
            for k, v in pairs(wdata) do
                scav.weapons[i][k] = v
            end
        end

        scav.canattack = true
    end
end

makeSilo("scavbeacon_t1", 1)
makeSilo("scavbeacon_t2", 2)
makeSilo("scavbeacon_t3", 3)
makeSilo("scavbeacon_t4", 4)
makeSilo("scavbeacon_t1_scav", 1)
makeSilo("scavbeacon_t2_scav", 2)
makeSilo("scavbeacon_t3_scav", 3)
makeSilo("scavbeacon_t4_scav", 4)
