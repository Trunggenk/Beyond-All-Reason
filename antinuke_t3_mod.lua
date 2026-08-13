-- Mod Author: CrossGamer
-- Mod Name: Anti-Nuke T3 Mod

local UnitDefs = UnitDefs or {}

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
    else
        copy = orig
    end
    return copy
end

local function createT3AntiNuke(faction, baseUnit, newUnit)
    if UnitDefs[baseUnit] and not UnitDefs[newUnit] then
        local t2 = UnitDefs[baseUnit]

        -- Deep copy UnitDef fully to prevent reference leaking
        local t3 = deepcopy(t2)

        -- Modifying unit properties
        t3.name = (t3.name or baseUnit) .. " T3"
        t3.health = t2.health * 2.5
        t3.metalcost = t2.metalcost + 200
        -- Revert changes to energycost and buildtime (keep them same as original t2)

        t3.customparams = t3.customparams or {}
        t3.customparams.i18n_en_humanname = "T3 Anti-Nuke"
        t3.customparams.i18n_en_tooltip = "Anti-Nuke (Faster stockpiling)"

        -- Use scavenger variant build pictures
        t3.buildpic = "scavengers/" .. string.upper(baseUnit) .. ".DDS"
        t3.icontype = baseUnit

        -- Apply the scav .s3o object model
        local oldObjectName = string.lower(t3.objectname or "")
        -- Check if it contains "units/" to strip it.
        local baseName = oldObjectName:match("([^/]+)$")
        if baseName then
            t3.objectname = "scavs/" .. baseName
        end

        -- Apply a model scale to distinguish it visually
        if t3.customparams.modelscale then
            t3.customparams.modelscale = tostring(tonumber(t3.customparams.modelscale) * 1.5)
        else
            t3.customparams.modelscale = "1.5"
        end

        -- Modify Weapons
        local wdefName = next(t3.weapondefs)
        if wdefName then
            local wdef = t3.weapondefs[wdefName]
            -- Keep original coverage, cost, velocity, and acceleration
            wdef.stockpiletime = math.floor((wdef.stockpiletime or 90) / 3) -- 1/3 stockpile time
            wdef.customparams = wdef.customparams or {}
            wdef.customparams.stockpilelimit = 30 -- Limit to 30
            wdef.stockpilelimit = 30
        end

        UnitDefs[newUnit] = t3

        -- Add to constructors
        local buildoptions = {
            "armack", "armaca", "armacv", "armhack", "armhaca", "armhacv",
            "corack", "coraca", "coracv", "corhack", "corhaca", "corhacv",
            "legack", "legaca", "legacv", "leghack", "leghaca", "leghacv"
        }

        for _, builder in ipairs(buildoptions) do
            if UnitDefs[builder] and UnitDefs[builder].buildoptions and string.sub(builder, 1, 3) == faction then
                local hasOption = false
                for _, opt in pairs(UnitDefs[builder].buildoptions) do
                    if opt == newUnit then hasOption = true break end
                end
                if not hasOption then
                    -- insert it at the end of the buildoptions map
                    local maxIndex = 0
                    for idx, _ in pairs(UnitDefs[builder].buildoptions) do
                        if type(idx) == "number" and idx > maxIndex then
                            maxIndex = idx
                        end
                    end
                    UnitDefs[builder].buildoptions[maxIndex + 1] = newUnit
                end
            end
        end
    end
end

createT3AntiNuke("arm", "armamd", "armamdt3")
createT3AntiNuke("cor", "corfmd", "corfmdt3")
createT3AntiNuke("leg", "legabm", "legabmt3")

-- Apply the Visual Mod logic from User Input
for n, d in pairs(UnitDefs) do
    if d.weapondefs then
        for _, wDef in pairs(d.weapondefs) do
            if wDef.interceptor == 1 and wDef.weapontype == "StarburstLauncher" then
                wDef.model = "crblmssl.s3o"
                wDef.cegtag = "NUKETRAIL"
                wDef.texture1 = "null"
                wDef.texture2 = "railguntrail"
                wDef.texture3 = "null"
                wDef.smokesize = 35
                wDef.smoketime = 130
                wDef.explosiongenerator = "custom:newnukecor"
                wDef.soundstart = "nukelaunch"
                wDef.soundhit = "nukecor"
                wDef.stockpiletime = 50
                wDef.areaofeffect = 1000
                wDef.impulsefactor = 0
                wDef.impulseboost = 0
                wDef.cratermult = 0

                if type(wDef.damage) == "table" then
                    for k, _ in pairs(wDef.damage) do
                        wDef.damage[k] = 0
                    end
                else
                    wDef.damage = { default = 0 }
                end

            elseif wDef.customparams and (wDef.customparams.nuclear == "1" or wDef.customparams.nuclear == 1) then
                wDef.stockpiletime = 90
            end
        end
    end
end
