-- Mod Author: CrossGamer
-- Mod Name: Overseer Anti-Nuke Mod

if UnitDefs and UnitDefs['overseer'] then
    local overseer = UnitDefs['overseer']
    if not overseer.buildoptions then
        overseer.buildoptions = {}
    end

    -- Raptor has a native anti-nuke structure: raptor_turret_antinuke_t3_v1
    local hasOption = false
    for _, opt in pairs(overseer.buildoptions) do
        if opt == "raptor_turret_antinuke_t3_v1" then
            hasOption = true
            break
        end
    end

    if not hasOption then
        local maxIndex = 0
        for idx, _ in pairs(overseer.buildoptions) do
            if type(idx) == "number" and idx > maxIndex then
                maxIndex = idx
            end
        end
        overseer.buildoptions[maxIndex + 1] = "raptor_turret_antinuke_t3_v1"
    end
end
