-- Mod Author: CrossGamer
-- Mod Name: Scavenger Beacon to Nuke Silo

if UnitDefs and UnitDefs["scavbeacon_t2_scav"] and UnitDefs["armsilo"] then
    local armsilo_wdefs = UnitDefs["armsilo"].weapondefs
    local armsilo_weapons = UnitDefs["armsilo"].weapons

    local scav = UnitDefs["scavbeacon_t2_scav"]
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
