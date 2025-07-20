-- ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ - ЛЕГКО ИЗМЕНИТЬ
local DEFAULT_MOUSE_SPEED = 0.18          -- Чувствительность мыши по умолчанию
local DEFAULT_CAMERA_YAW = 55             -- Скорость камеры по горизонтали по умолчанию
local DEFAULT_CAMERA_PITCH = 55           -- Скорость камеры по вертикали по умолчанию

-- Значения игры по умолчанию (когда настройки отключены)
local GAME_DEFAULT_MOUSE_SPEED = 1        -- Чувствительность мыши WoW по умолчанию
local GAME_DEFAULT_CAMERA_YAW = 90        -- Скорость камеры WoW по горизонтали по умолчанию
local GAME_DEFAULT_CAMERA_PITCH = 45      -- Скорость камеры WoW по вертикали по умолчанию

-- Простая функция для выполнения с задержкой (аналог C_Timer.After для WoW 3.3.5a)
local function RunAfter(delay, func)
    local f = CreateFrame("Frame")
    local elapsed = 0
    f:SetScript("OnUpdate", function(self, e)
        elapsed = elapsed + e
        if elapsed >= delay then
            self:SetScript("OnUpdate", nil)
            func()
            f = nil
        end
    end)
end

-- Делаем функцию глобальной для использования в других модулях
_G["RunAfter"] = RunAfter

-- Создаём аддон используя AceAddon-3.0
local MouseSpeedEnhanced = LibStub("AceAddon-3.0"):NewAddon("MouseSpeedEnhanced", "AceEvent-3.0", "AceConsole-3.0")

-- Получаем таблицу локализации (будет доступна после загрузки файла локализации)
local function getL()
    return MouseSpeedEnhanced_Locale or {}
end

-- Экспортируем в глобальную область видимости
_G["MouseSpeedEnhanced"] = MouseSpeedEnhanced

-- Настройки по умолчанию (используя константы из выше)
local defaults = {
    profile = {
        mouseSpeed = DEFAULT_MOUSE_SPEED,
        cameraYawMoveSpeed = DEFAULT_CAMERA_YAW,
        cameraPitchMoveSpeed = DEFAULT_CAMERA_PITCH,
        autoApply = true,
        enableOnLogin = false,  -- Камера отключена по умолчанию (как в оригинале)
        unifySettings = true,   -- Унифицировать настройки мыши и камеры для всех персонажей (рекомендуется)
    }
}

function MouseSpeedEnhanced:OnInitialize()
    -- Инициализируем базу данных с поддержкой настроек для каждого персонажа
    self.db = LibStub("AceDB-3.0"):New("MouseSpeedEnhancedDB", defaults, true)

    -- Определяем какой профиль использовать на основе unifySettings
    local characterName = UnitName("player") .. " - " .. GetRealmName()

    -- Сначала устанавливаем профиль конкретного персонажа для проверки текущих настроек
    self.db:SetProfile(characterName)

    -- Если унификация включена в профиле персонажа, переключаемся на унифицированный профиль
    if self.db.profile.unifySettings then
        self.db:SetProfile("Unified")
        -- Убеждаемся что унифицированный профиль также имеет флаг установленным
        self.db.profile.unifySettings = true
        -- Примечание: Унификация будет применена в PLAYER_ENTERING_WORLD
    end

    -- Регистрируем команды чата
    self:RegisterChatCommand("mousespeed", "SlashCmdHandler")
    self:RegisterChatCommand("ms", "SlashCmdHandler")

    local L = getL()
    print("|cFF00FF00MouseSpeedEnhanced v2.0 " .. (L["loaded! Type /ms config for settings."] or "loaded! Type /ms config for settings.") .. "|r")
end

function MouseSpeedEnhanced:OnEnable()
    -- Регистрируем событие входа в мир (как в оригинальном аддоне)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Инициализируем конфигурацию с задержкой (убеждаемся что файл конфигурации загружен)
    RunAfter(0.5, function()
        if MouseSpeedEnhanced.InitializeConfig then
            MouseSpeedEnhanced.InitializeConfig()
        else
            -- Резервный вариант: попробовать позже
            RunAfter(1, function()
                if MouseSpeedEnhanced.InitializeConfig then
                    MouseSpeedEnhanced.InitializeConfig()
                end
            end)
        end
    end)
end

function MouseSpeedEnhanced:OnDisable()
    -- Отменяем регистрацию всех событий для очистки
    self:UnregisterAllEvents()

    -- Очищаем регистрацию конфигурации
    self.configInitialized = false
end

-- Обработчик событий - Применяем настройки при входе
function MouseSpeedEnhanced:PLAYER_ENTERING_WORLD()
    -- Применяем настройки мыши и камеры
    if self.db.profile.autoApply then
        self:ApplySettings()
    else
        -- Всегда применяем mouseSpeed (как в оригинале) - независимо от настройки autoApply
        SetCVar("mouseSpeed", self.db.profile.mouseSpeed)
    end

    -- Отменяем регистрацию события после первого применения
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

-- Применяем настройки к игре (упрощённо как в MaxCamEnhanced)
function MouseSpeedEnhanced:ApplySettings()
    -- Всегда применяем скорость мыши
    SetCVar("mouseSpeed", self.db.profile.mouseSpeed)

    -- Применяем настройки камеры только если включены
    if self.db.profile.enableOnLogin then
        SetCVar("cameraYawMoveSpeed", self.db.profile.cameraYawMoveSpeed)
        SetCVar("cameraPitchMoveSpeed", self.db.profile.cameraPitchMoveSpeed)
    end

    -- Принудительно унифицируем по всем аккаунтам если включено
    if self.db.profile.unifySettings then
        self:ForceUnifyAllAccounts()
    end

    -- Настройки применяются беззвучно
end

-- Применяем только настройки мыши (для ручного применения)
function MouseSpeedEnhanced:ApplyMouseSettings()
    SetCVar("mouseSpeed", self.db.profile.mouseSpeed)

    -- Принудительно унифицируем если включено
    if self.db.profile.unifySettings then
        self:ForceUnifyAllAccounts()
    end
end

-- Применяем только настройки камеры (для ручного применения)
function MouseSpeedEnhanced:ApplyCameraSettings()
    SetCVar("cameraYawMoveSpeed", self.db.profile.cameraYawMoveSpeed)
    SetCVar("cameraPitchMoveSpeed", self.db.profile.cameraPitchMoveSpeed)

    -- Принудительно унифицируем если включено
    if self.db.profile.unifySettings then
        self:ForceUnifyAllAccounts()
    end
end

-- Восстанавливаем значения игры по умолчанию (когда авто-применение отключено)
function MouseSpeedEnhanced:RestoreDefaults()
    -- Восстанавливаем скорость мыши по умолчанию
    SetCVar("mouseSpeed", GAME_DEFAULT_MOUSE_SPEED)

    -- Восстанавливаем значения камеры по умолчанию
    SetCVar("cameraYawMoveSpeed", GAME_DEFAULT_CAMERA_YAW)
    SetCVar("cameraPitchMoveSpeed", GAME_DEFAULT_CAMERA_PITCH)

    -- Настройки применяются беззвучно
end

-- Восстанавливаем только стандартные значения камеры
function MouseSpeedEnhanced:RestoreCameraDefaults()
    -- Восстанавливаем значения камеры по умолчанию
    SetCVar("cameraYawMoveSpeed", GAME_DEFAULT_CAMERA_YAW)
    SetCVar("cameraPitchMoveSpeed", GAME_DEFAULT_CAMERA_PITCH)

    -- Принудительно сохраняем CVars в WTF файлы для сохранения по ВСЕМ аккаунтам
    ConsoleExec("cvar_save")

    -- Настройки применяются беззвучно
end

-- Восстанавливаем только стандартные значения мыши
function MouseSpeedEnhanced:RestoreMouseDefaults()
    -- Восстанавливаем скорость мыши по умолчанию
    SetCVar("mouseSpeed", GAME_DEFAULT_MOUSE_SPEED)

    -- Принудительно сохраняем CVars в WTF файлы для сохранения по ВСЕМ аккаунтам
    ConsoleExec("cvar_save")

    -- Настройки применяются беззвучно
end

-- Принудительно унифицируем по ВСЕМ аккаунтам записывая в общее расположение WTF
function MouseSpeedEnhanced:ForceUnifyAllAccounts()
    if not self.db.profile.unifySettings then
        return
    end

    -- Получаем текущие настройки
    local mouseSpeed = self.db.profile.mouseSpeed
    local cameraYaw = self.db.profile.cameraYawMoveSpeed
    local cameraPitch = self.db.profile.cameraPitchMoveSpeed
    local autoApply = self.db.profile.autoApply
    local enableOnLogin = self.db.profile.enableOnLogin

    -- Применяем настройки к игровым CVars (работает по всем аккаунтам)
    -- Всегда применяем скорость мыши (как в оригинальном поведении)
    SetCVar("mouseSpeed", mouseSpeed)

    -- Применяем настройки камеры только если включены
    if enableOnLogin then
        SetCVar("cameraYawMoveSpeed", cameraYaw)
        SetCVar("cameraPitchMoveSpeed", cameraPitch)
    end

    -- Принудительно сохраняем CVars в WTF файлы для сохранения по ВСЕМ аккаунтам
    ConsoleExec("cvar_save")

    -- Настройки сохранены через CVars выше
end

-- Обрабатываем переключение унификации - переключаем профили сохраняя текущее состояние UI
function MouseSpeedEnhanced:HandleUnificationToggle(value)
    -- Сохраняем текущее состояние UI перед переключением профилей
    local currentAutoApply = self.db.profile.autoApply
    local currentEnableOnLogin = self.db.profile.enableOnLogin
    local currentMouseSpeed = self.db.profile.mouseSpeed
    local currentCameraYaw = self.db.profile.cameraYawMoveSpeed
    local currentCameraPitch = self.db.profile.cameraPitchMoveSpeed

    if value then
        -- Переключаемся на унифицированный профиль при включении
        self.db:SetProfile("Unified")
        print("MouseSpeedEnhanced: Переключился на унифицированный профиль")
        -- Принудительно унифицируем по всем аккаунтам
        self:ForceUnifyAllAccounts()
    else
        -- Переключаемся на профиль конкретного персонажа при отключении
        local characterName = UnitName("player") .. " - " .. GetRealmName()
        self.db:SetProfile(characterName)
        print("MouseSpeedEnhanced: Переключился на профиль персонажа: " .. characterName)
    end

    -- Восстанавливаем состояние UI в новом профиле чтобы предотвратить нежелательные изменения
    self.db.profile.autoApply = currentAutoApply
    self.db.profile.enableOnLogin = currentEnableOnLogin
    self.db.profile.mouseSpeed = currentMouseSpeed
    self.db.profile.cameraYawMoveSpeed = currentCameraYaw
    self.db.profile.cameraPitchMoveSpeed = currentCameraPitch
    self.db.profile.unifySettings = value

    -- Принудительно сохраняем настройку
    self:SaveSettings()
end

-- Сохраняем текущие настройки в базу данных
function MouseSpeedEnhanced:SaveSettings()
    -- AceDB автоматически сохраняет при изменении данных профиля
    -- Эта функция существует для явных вызовов сохранения если нужно
    if self.db and self.db.profile then
        -- Принудительно записываем в базу данных касаясь профиля
        self.db.profile.lastSaved = time()
    end
end

-- Сброс к значениям по умолчанию
function MouseSpeedEnhanced:ResetToDefaults()
    -- Сбрасываем профиль к значениям по умолчанию
    self.db:ResetProfile()
    -- Применяем настройки по умолчанию
    self:ApplySettings()
    -- Сброс происходит беззвучно
end

-- Обработчик команд чата
function MouseSpeedEnhanced:SlashCmdHandler(input)
    local command = string.lower(input or "")
    local L = getL()

    if command == "config" or command == "settings" or command == "" then
        -- Открываем настройки интерфейса Blizzard для нашего аддона
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

-- Обновляем отображение текущих значений в конфигурации
function MouseSpeedEnhanced:UpdateCurrentValues()
    -- Обновляем интерфейс конфигурации если он открыт
    if LibStub and LibStub("AceConfigRegistry-3.0", true) then
        LibStub("AceConfigRegistry-3.0"):NotifyChange("MouseSpeedEnhanced")
    end
end
