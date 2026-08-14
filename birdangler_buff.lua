-- Mod Author: CrossGamer
-- Mod Name: Bird Angler Buff Mod

-- Note: In tweakdefs, if a unit was added dynamically by another tweakdef,
-- we have to mutate it directly in the global UnitDefs table.
if UnitDefs and UnitDefs['birdangler'] then
    local unit = UnitDefs['birdangler']

    -- Increase costs (metal, energy, buildtime) to compensate for buffs proportionally (approx +40%)
    if unit.metalcost then unit.metalcost = math.floor(unit.metalcost * 1.4) end
    if unit.energycost then unit.energycost = math.floor(unit.energycost * 1.4) end
    if unit.buildtime then unit.buildtime = math.floor(unit.buildtime * 1.4) end

    if unit.weapondefs then
        for wName, wDef in pairs(unit.weapondefs) do
            -- Modify the primary AA weapon
            if wDef.damage and wDef.damage.vtol then
                -- Buff damage >30% (e.g. 35%)
                wDef.damage.vtol = math.floor(wDef.damage.vtol * 1.35)

                -- Reduce reload time by 40% (x 0.6)
                if wDef.reloadtime then
                    wDef.reloadtime = wDef.reloadtime * 0.6
                end

                -- Increase range by 50%
                if wDef.range then
                    wDef.range = math.floor(wDef.range * 1.5)
                end
            end
        end
    end
end
