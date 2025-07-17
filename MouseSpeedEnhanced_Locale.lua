-- MouseSpeedEnhanced Localization
local L = {}

-- Default English strings
L["MouseSpeedEnhanced"] = "MouseSpeedEnhanced"
L["Advanced mouse and camera sensitivity control with configurable settings"] = "Advanced mouse and camera sensitivity control with configurable settings"
L["MouseSpeedEnhanced Settings"] = "MouseSpeedEnhanced Settings"

-- Main toggles
L["Enable Mouse Settings"] = "Enable Mouse Settings"
L["Automatically apply mouse and camera settings when you change them"] = "Automatically apply mouse and camera settings when you change them"
L["Enable Camera Settings"] = "Enable Camera Settings"
L["Enable camera speed settings (mouse speed is always active)"] = "Enable camera speed settings (mouse speed is always active)"
L["Unify Settings Across Characters"] = "Unify Settings Across Characters"
L["Apply the same mouse and camera settings to ALL characters and accounts. When enabled, all your characters will use identical settings."] = "Apply the same mouse and camera settings to ALL characters and accounts. When enabled, all your characters will use identical settings."

-- Section headers
L["Mouse Settings"] = "Mouse Settings"
L["Camera Settings"] = "Camera Settings"
L["Actions"] = "Actions"
L["Current Status"] = "Current Status"

-- Mouse settings
L["Mouse Sensitivity"] = "Mouse Sensitivity"
L["Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."] = "Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."
L["Mouse sensitivity for ALL characters and accounts. Sets mouseSpeed automatically. Works across all your characters!"] = "Mouse sensitivity for ALL characters and accounts. Sets mouseSpeed automatically. Works across all your characters!"
L["Mouse sensitivity for this character only. Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."] = "Mouse sensitivity for this character only. Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."

-- Camera settings
L["Camera Horizontal Speed"] = "Camera Horizontal Speed"
L["Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."] = "Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."
L["Camera horizontal speed for ALL characters and accounts. Sets cameraYawMoveSpeed automatically. Works across all your characters!"] = "Camera horizontal speed for ALL characters and accounts. Sets cameraYawMoveSpeed automatically. Works across all your characters!"
L["Camera horizontal speed for this character only. Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."] = "Camera horizontal speed for this character only. Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."
L["Camera Vertical Speed"] = "Camera Vertical Speed"
L["Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."] = "Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."
L["Camera vertical speed for ALL characters and accounts. Sets cameraPitchMoveSpeed automatically. Works across all your characters!"] = "Camera vertical speed for ALL characters and accounts. Sets cameraPitchMoveSpeed automatically. Works across all your characters!"
L["Camera vertical speed for this character only. Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."] = "Camera vertical speed for this character only. Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."

-- Action buttons
L["Apply Mouse Settings Now"] = "Apply Mouse Settings Now"
L["Apply current mouse settings to the game immediately"] = "Apply current mouse settings to the game immediately"
L["Apply Camera Settings Now"] = "Apply Camera Settings Now"
L["Apply current camera settings to the game immediately"] = "Apply current camera settings to the game immediately"
L["Reset to Defaults"] = "Reset to Defaults"
L["Reset all settings to default values (mouse: 0.17, camera: 55, unified)"] = "Reset all settings to default values (mouse: 0.17, camera: 55, unified)"
L["(auto-apply enabled)"] = "(auto-apply enabled)"
L["(manual application only)"] = "(manual application only)"
L["Mouse Speed"] = "Mouse Speed"
L["always applied on login"] = "always applied on login"
L["auto-apply enabled"] = "auto-apply enabled"

-- Messages and commands
L["loaded! Type /ms config for settings."] = "loaded! Type /ms config for settings."
L["Commands:"] = "Commands:"
L["Open settings"] = "Open settings"
L["Apply current settings"] = "Apply current settings"
L["Reset to defaults"] = "Reset to defaults"
L["Show this help"] = "Show this help"
L["Unknown command. Type '/ms help' for available commands."] = "Unknown command. Type '/ms help' for available commands."

-- Status interface strings
L["Addon not initialized"] = "Addon not initialized"
L["Current Status:"] = "Current Status:"
L["Addon Settings:"] = "Addon Settings:"
L["Current Values:"] = "Current Values:"
L["Status Summary:"] = "Status Summary:"
L["(game)"] = "(game)"
L["(addon)"] = "(addon)"
L["(unified for all characters)"] = "(unified for all characters)"
L["(individual per character)"] = "(individual per character)"
L["(disabled - settings off)"] = "(disabled - settings off)"
L["(disabled - mouse settings off)"] = "(disabled - mouse settings off)"

-- Status messages
L["All settings active"] = "All settings active"
L["Mouse and camera values are automatically applied"] = "Mouse and camera values are automatically applied"
L["Mouse settings active"] = "Mouse settings active"
L["Mouse values are automatically applied, camera uses defaults"] = "Mouse values are automatically applied, camera uses defaults"
L["Camera settings active"] = "Camera settings active"
L["Camera values are applied, mouse uses defaults"] = "Camera values are applied, mouse uses defaults"
L["Addon disabled"] = "Addon disabled"
L["Use 'Apply Settings Now' buttons to apply manually"] = "Use 'Apply Settings Now' buttons to apply manually"

-- Status messages for interface (unified with MaxCamEnhanced)
L["Active with unification"] = "Active with unification"
L["Settings are automatically applied and unified across all characters"] = "Settings are automatically applied and unified across all characters"
L["Active with mouse settings"] = "Active with mouse settings"
L["Mouse settings are automatically applied, camera uses defaults"] = "Mouse settings are automatically applied, camera uses defaults"
L["Active with camera settings"] = "Active with camera settings"
L["Camera settings are applied, mouse uses defaults"] = "Camera settings are applied, mouse uses defaults"

-- New detailed status messages (unified with MaxCamEnhanced)
L["Mouse Settings"] = "Mouse Settings"
L["Camera Settings"] = "Camera Settings"
L["Unification"] = "Unification"
L["Active:"] = "Active:"
L["Features:"] = "Features:"
L["unified across all characters"] = "unified across all characters"
L["mouse values applied automatically"] = "mouse values applied automatically"
L["camera values applied automatically"] = "camera values applied automatically"

-- Current values
L["Mouse Speed:"] = "Mouse Speed:"
L["Camera Horizontal:"] = "Camera Horiz:"
L["Camera Vertical:"] = "Camera Vert:"
L["Unknown"] = "Unknown"

-- Russian localization
if GetLocale() == "ruRU" then
    L["MouseSpeedEnhanced"] = "MouseSpeedEnhanced"
    L["Advanced mouse and camera sensitivity control with configurable settings"] = "Продвинутое управление чувствительностью мыши и камеры с настраиваемыми параметрами"
    L["MouseSpeedEnhanced Settings"] = "Настройки MouseSpeedEnhanced"

    -- Main toggles
    L["Enable Mouse Settings"] = "Настройки мыши"
    L["Automatically apply mouse and camera settings when you change them"] = "Автоматически применять настройки мыши и камеры при их изменении"
    L["Enable Camera Settings"] = "Настройки камеры"
    L["Enable camera speed settings (mouse speed is always active)"] = "Включить настройки скорости камеры (скорость мыши всегда активна)"
    L["Unify Settings Across Characters"] = "Унифицировать настройки для всех персонажей"
    L["Apply the same mouse and camera settings to ALL characters and accounts. When enabled, all your characters will use identical settings."] = "Применить одинаковые настройки мыши и камеры ко ВСЕМ персонажам и аккаунтам. При включении все ваши персонажи будут использовать идентичные настройки."

    -- Section headers
    L["Mouse Settings"] = "Настройки мыши"
    L["Camera Settings"] = "Настройки камеры"
    L["Actions"] = "Действия"
    L["Current Status"] = "Текущий статус"

    -- Mouse settings
    L["Mouse Sensitivity"] = "Чувствительность мыши"
    L["Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."] = "Управляет чувствительностью мыши (меньше = медленнее, больше = быстрее). Всегда применяется при входе."
    L["Mouse sensitivity for ALL characters and accounts. Sets mouseSpeed automatically. Works across all your characters!"] = "Чувствительность мыши для ВСЕХ персонажей и аккаунтов. Автоматически устанавливает mouseSpeed. Работает для всех ваших персонажей!"
    L["Mouse sensitivity for this character only. Controls mouse sensitivity (lower = slower, higher = faster). Always applied on login."] = "Чувствительность мыши только для этого персонажа. Управляет чувствительностью мыши (меньше = медленнее, больше = быстрее). Всегда применяется при входе."

    -- Camera settings
    L["Camera Horizontal Speed"] = "Скорость камеры по горизонтали"
    L["Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."] = "Управляет скоростью горизонтального движения камеры (влево/вправо). Настройки применяются только когда включены 'Настройки камеры'."
    L["Camera horizontal speed for ALL characters and accounts. Sets cameraYawMoveSpeed automatically. Works across all your characters!"] = "Скорость камеры по горизонтали для ВСЕХ персонажей и аккаунтов. Автоматически устанавливает cameraYawMoveSpeed. Работает для всех ваших персонажей!"
    L["Camera horizontal speed for this character only. Controls horizontal camera movement speed (left/right). Settings apply only when 'Enable Camera Settings' is checked."] = "Скорость камеры по горизонтали только для этого персонажа. Управляет скоростью горизонтального движения камеры (влево/вправо). Настройки применяются только когда включены 'Настройки камеры'."
    L["Camera Vertical Speed"] = "Скорость камеры по вертикали"
    L["Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."] = "Управляет скоростью вертикального движения камеры (вверх/вниз). Настройки применяются только когда включены 'Настройки камеры'."
    L["Camera vertical speed for ALL characters and accounts. Sets cameraPitchMoveSpeed automatically. Works across all your characters!"] = "Скорость камеры по вертикали для ВСЕХ персонажей и аккаунтов. Автоматически устанавливает cameraPitchMoveSpeed. Работает для всех ваших персонажей!"
    L["Camera vertical speed for this character only. Controls vertical camera movement speed (up/down). Settings apply only when 'Enable Camera Settings' is checked."] = "Скорость камеры по вертикали только для этого персонажа. Управляет скоростью вертикального движения камеры (вверх/вниз). Настройки применяются только когда включены 'Настройки камеры'."

    -- Action buttons
    L["Apply Mouse Settings Now"] = "Применить настройки мыши сейчас"
    L["Apply current mouse settings to the game immediately"] = "Применить текущие настройки мыши к игре немедленно"
    L["Apply Camera Settings Now"] = "Применить настройки камеры сейчас"
    L["Apply current camera settings to the game immediately"] = "Применить текущие настройки камеры к игре немедленно"
    L["Reset to Defaults"] = "Сбросить к умолчанию"
    L["Reset all settings to default values (mouse: 0.17, camera: 55, unified)"] = "Сбросить все настройки к умолчанию (мышь: 0.17, камера: 55, унифицировано)"
    L["(auto-apply enabled)"] = "(автоприменение включено)"
    L["(manual application only)"] = "(только ручное применение)"
    L["Mouse Speed"] = "Скорость мыши"
    L["always applied on login"] = "всегда применяется при входе"
    L["auto-apply enabled"] = "автоприменение включено"

    -- Messages and commands
    L["loaded! Type /ms config for settings."] = "загружен! Введите /ms config для настроек."
    L["Commands:"] = "Команды:"
    L["Open settings"] = "Открыть настройки"
    L["Apply current settings"] = "Применить текущие настройки"
    L["Reset to defaults"] = "Сбросить к умолчанию"
    L["Show this help"] = "Показать эту справку"
    L["Unknown command. Type '/ms help' for available commands."] = "Неизвестная команда. Введите '/ms help' для списка доступных команд."

    -- Status interface strings
    L["Addon not initialized"] = "Аддон не инициализирован"
    L["Current Status:"] = "Текущий статус:"
    L["Addon Settings:"] = "Настройки аддона:"
    L["Current Values:"] = "Текущие значения:"
    L["Status Summary:"] = "Сводка статуса:"
    L["(game)"] = "(игра)"
    L["(addon)"] = "(аддон)"
    L["(unified for all characters)"] = "(унифицировано для всех персонажей)"
    L["(individual per character)"] = "(индивидуально для каждого персонажа)"
    L["(disabled - settings off)"] = "(отключено - настройки выключены)"
    L["(disabled - mouse settings off)"] = "(отключено - настройки мыши выключены)"

    -- Status messages
    L["All settings active"] = "Все настройки активны"
    L["Mouse and camera values are automatically applied"] = "Значения мыши и камеры применяются автоматически"
    L["Mouse settings active"] = "Настройки мыши активны"
    L["Mouse values are automatically applied, camera uses defaults"] = "Значения мыши применяются автоматически, камера использует умолчания"
    L["Camera settings active"] = "Настройки камеры активны"
    L["Camera values are applied, mouse uses defaults"] = "Значения камеры применены, мышь использует умолчания"
    L["Addon disabled"] = "Аддон отключен"
    L["Use 'Apply Settings Now' buttons to apply manually"] = "Используйте кнопки 'Применить настройки сейчас' для ручного применения"

    -- Status messages for interface (unified with MaxCamEnhanced)
    L["Active with unification"] = "Активно с унификацией"
    L["Settings are automatically applied and unified across all characters"] = "Настройки автоматически применяются и унифицируются для всех персонажей"
    L["Active with mouse settings"] = "Активно с настройками мыши"
    L["Mouse settings are automatically applied, camera uses defaults"] = "Настройки мыши применяются автоматически, камера использует умолчания"
    L["Active with camera settings"] = "Активно с настройками камеры"
    L["Camera settings are applied, mouse uses defaults"] = "Настройки камеры применены, мышь использует умолчания"

    -- New detailed status messages (unified with MaxCamEnhanced)
    L["Mouse Settings"] = "Настройки мыши"
    L["Camera Settings"] = "Настройки камеры"
    L["Unification"] = "Унификация"
    L["Active:"] = "Активно:"
    L["Features:"] = "Функции:"
    L["unified across all characters"] = "унифицировано для всех персонажей"
    L["mouse values applied automatically"] = "значения мыши применяются автоматически"
    L["camera values applied automatically"] = "значения камеры применяются автоматически"

    -- Current values
    L["Mouse Speed:"] = "Скорость мыши:"
    L["Camera Horizontal:"] = "Камера гориз.:"
    L["Camera Vertical:"] = "Камера верт.:"
    L["Unknown"] = "Неизвестно"
end

-- Export localization table
MouseSpeedEnhanced_Locale = L
