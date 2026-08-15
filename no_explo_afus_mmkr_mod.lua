-- Mod Author: CrossGamer
-- Mod Name: No Explosion AFUS and Converter Mod

local UnitDefs = UnitDefs or {}

local targetUnits = {
    ["armafus"] = true,
    ["corafus"] = true,
    ["legafus"] = true,
    ["armmmkr"] = true,
    ["cormmkr"] = true,
    ["legadveconv"] = true,
}

for unitDefName, unitDef in pairs(UnitDefs) do
    if type(unitDef) == "table" and targetUnits[string.lower(unitDefName)] then
        -- Remove explosion
        unitDef.explodeas = ""
        unitDef.selfdestructas = ""
    end
end
