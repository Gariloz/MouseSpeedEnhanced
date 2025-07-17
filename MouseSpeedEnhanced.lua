-- MouseSpeed Enhanced - Advanced mouse and camera sensitivity control using Ace3
-- Version 2.0

-- ============================================================================
-- DEFAULT VALUES - EASY TO MODIFY
-- ============================================================================
local DEFAULT_MOUSE_SPEED = 0.17          -- Default mouse sensitivity
local DEFAULT_CAMERA_YAW = 55             -- Default camera horizontal speed
local DEFAULT_CAMERA_PITCH = 55           -- Default camera vertical speed

-- Game default values (when settings are disabled)
local GAME_DEFAULT_MOUSE_SPEED = 0.17     -- WoW default mouse speed
local GAME_DEFAULT_CAMERA_YAW = 90        -- WoW default camera horizontal speed
local GAME_DEFAULT_CAMERA_PITCH = 45      -- WoW default camera vertical speed
-- ============================================================================

-- Create addon using AceAddon-3.0
local MouseSpeedEnhanced = LibStub("AceAddon-3.0"):NewAddon("MouseSpeedEnhanced", "AceEvent-3.0", "AceConsole-3.0")

-- Get localization table (will be available after locale file loads)
local function getL()
    return MouseSpeedEnhanced_Locale or {}
end

-- Export to global scope
_G["MouseSpeedEnhanced"] = MouseSpeedEnhanced

-- Default settings (using constants from above)
local defaults = {
    profile = {
        mouseSpeed = DEFAULT_MOUSE_SPEED,
        cameraYawMoveSpeed = DEFAULT_CAMERA_YAW,
        cameraPitchMoveSpeed = DEFAULT_CAMERA_PITCH,
        autoApply = true,
        enableOnLogin = false,  -- Camera disabled by default (like in original)
        unifySettings = true,   -- Unify mouse and camera settings across all characters (recommended)
    }
}

function MouseSpeedEnhanced:OnInitialize()
    -- Initialize database with per-character support
    self.db = LibStub("AceDB-3.0"):New("MouseSpeedEnhancedDB", defaults, true)

    -- Determine which profile to use based on unifySettings
    local characterName = UnitName("player") .. " - " .. GetRealmName()

    -- First, set character-specific profile to check current settings
    self.db:SetProfile(characterName)

    -- If unification is enabled in character profile, switch to unified profile
    if self.db.profile.unifySettings then
        self.db:SetProfile("Unified")
        -- Ensure the unified profile also has the flag set
        self.db.profile.unifySettings = true
        -- Note: Unification will be applied in PLAYER_ENTERING_WORLD
    end

    -- Register slash commands
    self:RegisterChatCommand("mousespeed", "SlashCmdHandler")
    self:RegisterChatCommand("ms", "SlashCmdHandler")

    local L = getL()
    print("|cFF00FF00MouseSpeedEnhanced v2.0 " .. (L["loaded! Type /ms config for settings."] or "loaded! Type /ms config for settings.") .. "|r")
end

function MouseSpeedEnhanced:OnEnable()
    -- Register world enter event (like in original addon)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Initialize configuration with small delay
    C_Timer.After(0.1, function()
        if MouseSpeedEnhanced.InitializeConfig then
            MouseSpeedEnhanced.InitializeConfig()
        end
    end)
end

function MouseSpeedEnhanced:OnDisable()
    -- Unregister all events for cleanup
    self:UnregisterAllEvents()

    -- Clean up configuration registration
    self.configInitialized = false
end

-- Event handler - Apply settings on login
function MouseSpeedEnhanced:PLAYER_ENTERING_WORLD()
    -- Apply mouse and camera settings
    if self.db.profile.autoApply then
        self:ApplySettings()
    else
        -- Always apply mouseSpeed (like in original) - regardless of autoApply setting
        SetCVar("mouseSpeed", self.db.profile.mouseSpeed)
    end

    -- Unregister event after first application
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

-- Apply settings to game (simplified like MaxCamEnhanced)
function MouseSpeedEnhanced:ApplySettings()
    -- Always apply mouse speed
    SetCVar("mouseSpeed", self.db.profile.mouseSpeed)

    -- Apply camera settings only if enabled
    if self.db.profile.enableOnLogin then
        SetCVar("cameraYawMoveSpeed", self.db.profile.cameraYawMoveSpeed)
        SetCVar("cameraPitchMoveSpeed", self.db.profile.cameraPitchMoveSpeed)
    end

    -- Force unification across all accounts if enabled
    if self.db.profile.unifySettings then
        self:ForceUnifyAllAccounts()
    end

    -- Settings apply silently
end

-- Apply only mouse settings (for manual application)
function MouseSpeedEnhanced:ApplyMouseSettings()
    SetCVar("mouseSpeed", self.db.profile.mouseSpeed)

    -- Force unification if enabled
    if self.db.profile.unifySettings then
        self:ForceUnifyAllAccounts()
    end
end

-- Apply only camera settings (for manual application)
function MouseSpeedEnhanced:ApplyCameraSettings()
    SetCVar("cameraYawMoveSpeed", self.db.profile.cameraYawMoveSpeed)
    SetCVar("cameraPitchMoveSpeed", self.db.profile.cameraPitchMoveSpeed)

    -- Force unification if enabled
    if self.db.profile.unifySettings then
        self:ForceUnifyAllAccounts()
    end
end

-- Restore default game values (when auto-apply is disabled)
function MouseSpeedEnhanced:RestoreDefaults()
    -- Restore default mouse speed
    SetCVar("mouseSpeed", GAME_DEFAULT_MOUSE_SPEED)

    -- Restore default camera values
    SetCVar("cameraYawMoveSpeed", GAME_DEFAULT_CAMERA_YAW)
    SetCVar("cameraPitchMoveSpeed", GAME_DEFAULT_CAMERA_PITCH)

    -- Settings apply silently
end

-- Force unification across ALL accounts by writing to shared WTF location
function MouseSpeedEnhanced:ForceUnifyAllAccounts()
    if not self.db.profile.unifySettings then
        return
    end

    -- Get current settings
    local mouseSpeed = self.db.profile.mouseSpeed
    local cameraYaw = self.db.profile.cameraYawMoveSpeed
    local cameraPitch = self.db.profile.cameraPitchMoveSpeed
    local autoApply = self.db.profile.autoApply
    local enableOnLogin = self.db.profile.enableOnLogin

    -- Apply settings to game CVars (works across all accounts)
    -- Always apply mouse speed (like in original behavior)
    SetCVar("mouseSpeed", mouseSpeed)

    -- Apply camera settings only if enabled
    if enableOnLogin then
        SetCVar("cameraYawMoveSpeed", cameraYaw)
        SetCVar("cameraPitchMoveSpeed", cameraPitch)
    end

    -- Force save CVars to WTF files for persistence across ALL accounts
    ConsoleExec("cvar_save")

    -- Settings saved via CVars above
end

-- Handle unification toggle - switch profiles while preserving current UI state
function MouseSpeedEnhanced:HandleUnificationToggle(value)
    -- Save current UI state before switching profiles
    local currentAutoApply = self.db.profile.autoApply
    local currentEnableOnLogin = self.db.profile.enableOnLogin
    local currentMouseSpeed = self.db.profile.mouseSpeed
    local currentCameraYaw = self.db.profile.cameraYawMoveSpeed
    local currentCameraPitch = self.db.profile.cameraPitchMoveSpeed

    if value then
        -- Switch to unified profile when enabling
        self.db:SetProfile("Unified")
        print("MouseSpeedEnhanced: Switched to unified profile")
        -- Force unification across all accounts
        self:ForceUnifyAllAccounts()
    else
        -- Switch to character-specific profile when disabling
        local characterName = UnitName("player") .. " - " .. GetRealmName()
        self.db:SetProfile(characterName)
        print("MouseSpeedEnhanced: Switched to character profile: " .. characterName)
    end

    -- Restore UI state in the new profile to prevent unwanted changes
    self.db.profile.autoApply = currentAutoApply
    self.db.profile.enableOnLogin = currentEnableOnLogin
    self.db.profile.mouseSpeed = currentMouseSpeed
    self.db.profile.cameraYawMoveSpeed = currentCameraYaw
    self.db.profile.cameraPitchMoveSpeed = currentCameraPitch
    self.db.profile.unifySettings = value

    -- Force save the setting
    self:SaveSettings()
end

-- Save current settings to database
function MouseSpeedEnhanced:SaveSettings()
    -- AceDB automatically saves when profile data changes
    -- This function exists for explicit save calls if needed
    if self.db and self.db.profile then
        -- Force a database write by touching the profile
        self.db.profile.lastSaved = time()
    end
end



-- Reset to defaults
function MouseSpeedEnhanced:ResetToDefaults()
    -- Reset profile to defaults
    self.db:ResetProfile()
    -- Apply the default settings
    self:ApplySettings()
    -- Reset happens silently
end

-- Slash command handler
function MouseSpeedEnhanced:SlashCmdHandler(input)
    local command = string.lower(input or "")
    local L = getL()

    if command == "config" or command == "settings" or command == "" then
        -- Open Blizzard interface options to our addon
        InterfaceOptionsFrame_OpenToCategory("MouseSpeedEnhanced")
    elseif command == "apply" then
        self:ApplySettings()
    elseif command == "reset" then
        self:ResetToDefaults()
    elseif command == "help" then
        print("|cFF00FF00MouseSpeedEnhanced " .. (L["Commands:"] or "Commands:") .. "|r")
        print("|cFFFFFF00/ms|r or |cFFFFFF00/mousespeed|r - " .. (L["Open settings"] or "Open settings"))
        print("|cFFFFFF00/ms apply|r - " .. (L["Apply current settings"] or "Apply current settings"))
        print("|cFFFFFF00/ms reset|r - " .. (L["Reset to defaults"] or "Reset to defaults"))
        print("|cFFFFFF00/ms help|r - " .. (L["Show this help"] or "Show this help"))
    else
        print("|cFFFF0000MouseSpeedEnhanced:|r " .. (L["Unknown command. Type '/ms help' for available commands."] or "Unknown command. Type '/ms help' for available commands."))
    end
end

-- Update current values display in config
function MouseSpeedEnhanced:UpdateCurrentValues()
    -- Update configuration interface if it's open
    if LibStub and LibStub("AceConfigRegistry-3.0", true) then
        LibStub("AceConfigRegistry-3.0"):NotifyChange("MouseSpeedEnhanced")
    end
end
