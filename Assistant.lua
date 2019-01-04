-- ================== [ Description ] ==================
script_name('ArizonaAssistant')
script_author('Jack Grimes and Lucas Delius')
script_description('GlobalAssistant | Arizona Scottdale')
script_properties("work-in-pause")
-- ===================== [ Libs ] ======================
require "lib.moonloader" 
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'

encoding.default = 'CP1251'
u8 = encoding.UTF8

-- ===================== { Vars } ====================== 

-- ===================== [ Bool's ] ====================== 

local auth_status = false

-- ===================== [ Integer ] ====================== 

local sizeWindowAuthX = 570
local sizeWindowAuthY = 230

-- ===================== [ Imgui bool's ] ====================== 

local starup_window = imgui.ImBool(false)

-- ===================== [ CallBack's ] ====================== 

function sampev.onSendSpawn()
  if auth_status == false then
    sampAddChatMessage('[Информация] {7B68EE}Для авторизации используйте {FF0000}/auth', 0xDAA520)
  end
end

-- ===================== [ Main ] ====================== 

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait (100) end
  sampRegisterChatCommand('auth', cmd_auth)
  -- Загрузка сампа
  while true do
    wait(10)
    if auth_status then
      if isKeyJustPressed(VK_F2) then -- Главное меню
        starup_window.v = not starup_window.v
      end

      if starup_window.v == true then
        imgui.Process = true
      end

      if starup_window == false then
        imgui.Process = false
      end
    end
  end
end

-- ===================== [ Commands ] ====================== 

function cmd_auth()
  if auth_status then
    sampAddChatMessage('[Информация] {7B68EE}Вы уже авторизованы!', 0xDAA520)
  else
    print('Starting load...')
    imgui.SwitchContext()
    imgui.GetIO().Fonts:Clear()
    glyph_ranges_cyrillic = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\arial.ttf', (15*GetNormalTextSize()), nil, glyph_ranges_cyrillic) -- huui
    imgui.RebuildFonts()
    load_startup_images()
    sampAddChatMessage('[Информация] {7B68EE}Скрипт успешно загружен!', 0xDAA520)
    auth_status = true
  end
end

-- ===================== [ Load functions] ====================== 

function load_startup_images()
  arizonaLogo =  imgui.CreateTextureFromFile(getWorkingDirectory() .. '\\ArizonaAssistant\\images\\arizona-logo.png')
end 

-- ===================== [ Other functions ] ====================== 

-- ===================== [ Reder window's ] ====================== 

function imgui.OnDrawFrame()
  if starup_window.v then
    sizeScreenX, sizeScreenY = getScreenResolution()
    sizeWindowX = GetNormalRation(1, sizeWindowAuthX)+30
    sizeWindowY = GetNormalRation(2, sizeWindowAuthY)+30
    tmpPosX = (sizeScreenX/2)-(sizeWindowX/2)
    tmpPosY = (sizeScreenY/2)-(sizeWindowY/2)
    imgui.SetNextWindowPos(imgui.ImVec2(tmpPosX, tmpPosY))
    imgui.SetNextWindowSize(imgui.ImVec2(sizeWindowX, sizeWindowY), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Главное меню', use_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
    imgui.Columns(2, _, false)
    imgui.SetColumnWidth(-1, GetNormalRation(1, 470-15))
    imgui.Image(arizonaLogo, imgui.ImVec2(GetNormalRation(1, 470-15), GetNormalRation(2, 230-15)))
    imgui.NextColumn()
    imgui.SetColumnWidth(-1, GetNormalRation(1, sizeWindowX-465))
    if imgui.Button(u8'Интсрукиця', imgui.ImVec2((sizeWindowX-465)-15, 30)) then
      lua_thread.create(func_winthdraw_from_deposit)
    end
    if imgui.Button(u8'Главные настройки', imgui.ImVec2((sizeWindowX-465)-15, 30)) then
      lua_thread.create(func_winthdraw_from_deposit)
    end
    if imgui.Button(u8'Настройки орг.', imgui.ImVec2((sizeWindowX-465)-15, 30)) then
      lua_thread.create(func_winthdraw_from_deposit)
    end
    if imgui.Button(u8'Биндер', imgui.ImVec2((sizeWindowX-465)-15, 30)) then
      lua_thread.create(func_winthdraw_from_deposit)
    end
    if imgui.Button(u8'Информация', imgui.ImVec2((sizeWindowX-465)-15, 30)) then
      lua_thread.create(func_winthdraw_from_deposit)
    end
    imgui.End()
  end
end


function imgui.CentrText(text)
    local width = imgui.GetWindowWidth()
    local text_width = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
    imgui.Text(text)
end

function GetNormalRation(cordType, sizeElement) -- 1 = X; 2 = Y
  local currentRatio = screenRatio
  local sizeM = 0
  local normalSizeScreenX = 1920
  local normalSizeScreenY = 1080

  if cordType == 1 then
    currentRatio = sizeScreenX / normalSizeScreenX
    sizeM = sizeElement*currentRatio
  end
  if cordType == 2 then
    currentRatio = sizeScreenY / normalSizeScreenY
    sizeM = sizeElement*currentRatio
  end
  return sizeM
end

function GetNormalTextSize()
  sizeScreenX, sizeScreenY = getScreenResolution()
  local currentRatio = screenRatio
  local sizeM = 0
  local normalSizeScreenX = 1920
  local normalSizeScreenY = 1080
    currentRatio = sizeScreenX / normalSizeScreenX
    sizeM = currentRatio
  return sizeM
end

-- ===================== [ Custom style ] ======================
function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2

  style.WindowPadding = ImVec2(15, 15)
  style.WindowRounding = 5.0
  style.FramePadding = ImVec2(5, 5)
  style.FrameRounding = 4.0
  style.ItemSpacing = ImVec2(12, 8)
  style.ItemInnerSpacing = ImVec2(8, 6)
  style.IndentSpacing = 25.0
  style.ScrollbarSize = 15.0
  style.ScrollbarRounding = 9.0
  style.GrabMinSize = 5.0
  style.GrabRounding = 3.0

  colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
  colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
  colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00) 
  colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
  colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
  colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
  colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
  colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()