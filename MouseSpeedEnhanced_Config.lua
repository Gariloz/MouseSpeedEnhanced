MouseSpeedEnhanced = MouseSpeedEnhanced or {}
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

-- Get localization table (will be available after locale file loads)
local function getL()
    return MouseSpeedEnhanced_Locale or {}
end

local options = nil

local function get(info)
    if not MouseSpeedEnhanced.db then
        return nil
    end
    return MouseSpeedEnhanced.db.profile[info[#info]]
end

local function set(info, value)
    if not MouseSpeedEnhanced.db then
        return
    end

    local key = info[#info]

    -- Special handling for unifySettings toggle - handle BEFORE saving to profile
    if key == "unifySettings" then
        -- Handle profile switching for unification
        MouseSpeedEnhanced:HandleUnificationToggle(value)
        MouseSpeedEnhanced:UpdateCurrentValues()
        return -- Exit early to avoid normal processing
    end

    -- Save the value to profile FIRST
    MouseSpeedEnhanced.db.profile[key] = value

    -- Special handling for autoApply toggle
    if key == "autoApply" then
        if value then
            -- Auto-apply enabled: apply current settings
            MouseSpeedEnhanced:ApplySettings()
        end
        -- When auto-apply is disabled, don't change anything - let user apply manually
        MouseSpeedEnhanced:UpdateCurrentValues()
    -- Special handling for enableOnLogin toggle
    elseif key == "enableOnLogin" then
        -- Apply camera settings immediately when toggled
        if value then
            MouseSpeedEnhanced:ApplyCameraSettings()
        end
        MouseSpeedEnhanced:UpdateCurrentValues()
    -- Apply settings immediately if auto-apply is enabled
    elseif MouseSpeedEnhanced.db.profile.autoApply then
        MouseSpeedEnhanced:ApplySettings()
        MouseSpeedEnhanced:UpdateCurrentValues()
    end
end

-- Simple set function for sliders - save and apply, but don't update interface
local function setSlider(info, value)
    if not MouseSpeedEnhanced.db then
        return
    end

    -- Save the value to profile
    MouseSpeedEnhanced.db.profile[info[#info]] = value

    -- Apply settings immediately if auto-apply is enabled
    -- But DON'T update interface to prevent slider jumping
    if MouseSpeedEnhanced.db.profile.autoApply then
        MouseSpeedEnhanced:ApplySettings()
    end
end

local function createOptions()
    if options then
        return options
    end

    local L = getL()

    options = {
        type = "group",
        name = "MouseSpeedEnhanced",
        desc = L["Advanced mouse and camera sensitivity control with configurable settings"] or "Advanced mouse and camera sensitivity control with configurable settings",
        args = {
            header = {
                type = "header",
                name = L["MouseSpeedEnhanced Settings"] or "MouseSpeedEnhanced Settings",
                order = 1,
            },
            -- Main toggles at the top for convenience
            autoApply = {
                type = "toggle",
                name = L["Enable Mouse Settings"] or "Enable Mouse Settings",
                desc = L["Automatically apply mouse and camera settings when you change them"] or "Automatically apply mouse and camera settings when you change them",
                order = 2,
                get = get,
                set = set,
            },
            unifySettings = {
                type = "toggle",
                name = L["Unify Settings Across Characters"] or "Unify Settings Across Characters",
                desc = L["Apply the same mouse and camera settings to ALL characters and accounts. When enabled, all your characters will use identical settings."] or "Apply the same mouse and camera settings to ALL characters and accounts. When enabled, all your characters will use identical settings.",
                order = 3,
                get = get,
                set = set,
            },
            enableOnLogin = {
                type = "toggle",
                name = L["Enable Camera Settings"] or "Enable Camera Settings",
                desc = L["Enable camera speed settings (mouse speed is always active)"] or "Enable camera speed settings (mouse speed is always active)",
                order = 4,
                get = get,
                set = set,
            },
            spacer1 = {
                type = "header",
                name = L["Mouse Settings"] or "Mouse Settings",
                order = 5,
            },
            mouseSpeed = {
                type = "range",
                name = L["Mouse Sensitivity"] or "Mouse Sensitivity",
                desc = function()
                    if MouseSpeedEnhanced.db.profile.unifySettings then
                        return (L["Mouse sensitivity for ALL characters and accounts. Sets mouseSpeed automatically. Works across all your characters!"] or "Mouse sensitivity for ALL characters and accounts. Sets mouseSpeed automatically. Works across all your characters!")
                    else
                        return (L["Mouse sensitivity for this character only. Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."] or "Mouse sensitivity for this character only. Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login.")
                    end
                end,
                min = 0.01,
                max = 10.0,
                step = 0.01,
                bigStep = 0.01,
                order = 6,
                get = get,
                set = setSlider,
            },
            applyMouse = {
                type = "execute",
                name = L["Apply Mouse Settings Now"] or "Apply Mouse Settings Now",
                desc = L["Apply current mouse settings to the game immediately"] or "Apply current mouse settings to the game immediately",
                order = 6.5,
                func = function()
                    MouseSpeedEnhanced:ApplyMouseSettings()
                    MouseSpeedEnhanced:UpdateCurrentValues()
                end,
                hidden = function()
                    -- Show button only when Enable Mouse Settings is disabled
                    if not MouseSpeedEnhanced.db or not MouseSpeedEnhanced.db.profile then
                        return true
                    end
                    return MouseSpeedEnhanced.db.profile.autoApply
                end,
            },
            spacer2 = {
                type = "header",
                name = L["Camera Settings"] or "Camera Settings",
                order = 7,
            },
            cameraYawMoveSpeed = {
                type = "range",
                name = L["Camera Horizontal Speed"] or "Camera Horizontal Speed",
                desc = function()
                    if MouseSpeedEnhanced.db.profile.unifySettings then
                        return (L["Camera horizontal speed for ALL characters and accounts. Sets cameraYawMoveSpeed automatically. Works across all your characters!"] or "Camera horizontal speed for ALL characters and accounts. Sets cameraYawMoveSpeed automatically. Works across all your characters!")
                    else
                        return (L["Camera horizontal speed for this character only. Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."] or "Camera horizontal speed for this character only. Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked.")
                    end
                end,
                min = 1,
                max = 180,
                step = 1,
                bigStep = 1,
                order = 8,
                get = get,
                set = setSlider,
            },
            cameraPitchMoveSpeed = {
                type = "range",
                name = L["Camera Vertical Speed"] or "Camera Vertical Speed",
                desc = function()
                    if MouseSpeedEnhanced.db.profile.unifySettings then
                        return (L["Camera vertical speed for ALL characters and accounts. Sets cameraPitchMoveSpeed automatically. Works across all your characters!"] or "Camera vertical speed for ALL characters and accounts. Sets cameraPitchMoveSpeed automatically. Works across all your characters!")
                    else
                        return (L["Camera vertical speed for this character only. Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."] or "Camera vertical speed for this character only. Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked.")
                    end
                end,
                min = 1,
                max = 180,
                step = 1,
                bigStep = 1,
                order = 9,
                get = get,
                set = setSlider,
            },
            applyCameraSettings = {
                type = "execute",
                name = L["Apply Camera Settings Now"] or "Apply Camera Settings Now",
                desc = L["Apply current camera settings to the game immediately"] or "Apply current camera settings to the game immediately",
                order = 9.5,
                func = function()
                    MouseSpeedEnhanced:ApplyCameraSettings()
                    MouseSpeedEnhanced:UpdateCurrentValues()
                end,
                hidden = function()
                    -- Show button only when Enable Camera Settings is disabled
                    if not MouseSpeedEnhanced.db or not MouseSpeedEnhanced.db.profile then
                        return true
                    end
                    return MouseSpeedEnhanced.db.profile.enableOnLogin
                end,
            },
            spacer3 = {
                type = "header",
                name = L["Actions"] or "Actions",
                order = 10,
            },
            reset = {
                type = "execute",
                name = L["Reset to Defaults"] or "Reset to Defaults",
                desc = L["Reset all settings to default values (mouse: 0.17, camera: 55, unified)"] or "Reset all settings to default values (mouse: 0.17, camera: 55, unified)",
                order = 11,
                func = function()
                    MouseSpeedEnhanced:ResetToDefaults()
                    MouseSpeedEnhanced:UpdateCurrentValues()
                end,
            },

            spacer4 = {
                type = "header",
                name = L["Current Status"] or "Current Status",
                order = 12,
            },
            currentValues = {
                type = "description",
                name = function()
                    if not MouseSpeedEnhanced.db or not MouseSpeedEnhanced.db.profile then
                        return "|cFFFF0000" .. (L["Addon not initialized"] or "Addon not initialized") .. "|r"
                    end

                    local profile = MouseSpeedEnhanced.db.profile

                    -- Get current game values
                    local gameMouseSpeed = GetCVar("mouseSpeed") or (L["Unknown"] or "Unknown")
                    local gameCameraSensitivity = GetCVar("cameraYawMoveSpeed") or (L["Unknown"] or "Unknown")
                    local gameCameraPitch = GetCVar("cameraPitchMoveSpeed") or (L["Unknown"] or "Unknown")

                    local text = "|cFF00FFFF" .. (L["Current Status:"] or "Current Status:") .. "|r\n\n"

                    -- Section 1: Addon Settings Status (shows ACTUAL working state)
                    text = text .. "|cFFFFD700" .. (L["Addon Settings:"] or "Addon Settings:") .. "|r\n"

                    -- Enable Mouse Settings (auto-apply toggle)
                    local mouseColor = profile.autoApply and "|cFF00FF00" or "|cFFFF0000"
                    local mouseStatus = profile.autoApply and " " .. (L["(auto-apply enabled)"] or "(auto-apply enabled)") or " " .. (L["(manual application only)"] or "(manual application only)")
                    text = text .. "• " .. mouseColor .. (L["Enable Mouse Settings"] or "Enable Mouse Settings") .. mouseStatus .. "|r\n"

                    -- Unify Settings Across Characters (works independently)
                    local unifyColor = profile.unifySettings and "|cFF00FF00" or "|cFFFF0000"
                    local unifyStatus = profile.unifySettings and " " .. (L["(unified for all characters)"] or "(unified for all characters)") or " " .. (L["(individual per character)"] or "(individual per character)")
                    text = text .. "• " .. unifyColor .. (L["Unify Settings Across Characters"] or "Unify Settings Across Characters") .. unifyStatus .. "|r\n"

                    -- Enable Camera Settings (always works)
                    local cameraColor = profile.enableOnLogin and "|cFF00FF00" or "|cFFFF0000"
                    text = text .. "• " .. cameraColor .. (L["Enable Camera Settings"] or "Enable Camera Settings") .. "|r\n\n"

                    -- Section 2: Current Values (Game vs Addon)
                    text = text .. "|cFFFFD700" .. (L["Current Values:"] or "Current Values:") .. "|r\n"
                    text = text .. "• " .. (L["Mouse Speed:"] or "Mouse Speed:") .. " |cFF00FF00" .. gameMouseSpeed .. "|r " .. (L["(game)"] or "(game)") .. " / |cFF00FF00" .. profile.mouseSpeed .. "|r " .. (L["(addon)"] or "(addon)") .. "\n"
                    text = text .. "• " .. (L["Camera Horizontal:"] or "Camera Horizontal:") .. " |cFF00FF00" .. gameCameraSensitivity .. "|r " .. (L["(game)"] or "(game)") .. " / |cFF00FF00" .. profile.cameraYawMoveSpeed .. "|r " .. (L["(addon)"] or "(addon)") .. "\n"
                    text = text .. "• " .. (L["Camera Vertical:"] or "Camera Vertical:") .. " |cFF00FF00" .. gameCameraPitch .. "|r " .. (L["(game)"] or "(game)") .. " / |cFF00FF00" .. profile.cameraPitchMoveSpeed .. "|r " .. (L["(addon)"] or "(addon)") .. "\n\n"

                    -- Section 3: Status Summary
                    text = text .. "|cFFFFD700" .. (L["Status Summary:"] or "Status Summary:") .. "|r\n"

                    -- Build status description based on active features
                    local statusParts = {}
                    local descriptionParts = {}

                    -- Mouse speed is ALWAYS applied (like in original script)
                    table.insert(statusParts, (L["Mouse Speed"] or "Mouse Speed"))
                    table.insert(descriptionParts, (L["always applied on login"] or "always applied on login"))

                    -- Add auto-apply status for other settings
                    if profile.autoApply then
                        table.insert(descriptionParts, (L["auto-apply enabled"] or "auto-apply enabled"))
                    end

                    -- Add camera settings if enabled
                    if profile.enableOnLogin then
                        table.insert(statusParts, (L["Camera Settings"] or "Camera Settings"))
                    end

                    -- Add unification if enabled
                    if profile.unifySettings then
                            table.insert(statusParts, (L["Unification"] or "Unification"))
                            table.insert(descriptionParts, (L["unified across all characters"] or "unified across all characters"))
                        end

                    -- Build final status message
                    local statusText = table.concat(statusParts, " + ")
                    text = text .. "|cFF88FF88" .. (L["Active:"] or "Active:") .. " " .. statusText .. "|r\n"

                    -- Add description
                    if #descriptionParts > 0 then
                        local descriptionText = table.concat(descriptionParts, ", ")
                        text = text .. "|cFF888888" .. (L["Features:"] or "Features:") .. " " .. descriptionText .. "|r"
                    end

                    return text
                end,
                order = 13,
            },
        }
    }

    return options
end

-- Configuration initialization function (called after addon load)
function MouseSpeedEnhanced.InitializeConfig()
    if MouseSpeedEnhanced.configInitialized then
        return -- Prevent duplicate registration
    end

    local options = createOptions()
    -- Unregister any existing registration first
    pcall(function() AceConfigDialog:Close("MouseSpeedEnhanced") end)

    AceConfig:RegisterOptionsTable("MouseSpeedEnhanced", options)
    AceConfigDialog:AddToBlizOptions("MouseSpeedEnhanced", "MouseSpeedEnhanced")

    -- Hook interface close to apply settings
    local originalHide = InterfaceOptionsFrame.Hide
    InterfaceOptionsFrame.Hide = function(self)
        -- Apply settings when interface is closed
        if MouseSpeedEnhanced and MouseSpeedEnhanced.ApplySettings then
            MouseSpeedEnhanced:ApplySettings()
        end
        originalHide(self)
    end

    MouseSpeedEnhanced.configInitialized = true
end
