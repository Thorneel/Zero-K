
function widget:GetInfo()
	return {
		name      = "Chili Campaign Message Box",
		desc      = "The message box for displaying in-mission campaign messages",
		author    = "ThornEel",
		date      = "26 June 2020",
		license   = "GNU GPL, v2 or later",
		layer     = 50,
		enabled   = true,
	}
end

local Spring = Spring

-- Only used for campaign missions
if not Spring.GetModOptions().singleplayercampaignbattleid then
	function widget:Initialize()
		Spring.SendCommands("info 0")
	end

	return
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local WINDOW_WIDTH = 600
local DEFAULT_X_POSITION = 400
local DEFAULT_Y_POSITION = 100
local DEFAULT_LINE_NUMBER = 10
local MIN_LINE_NUMBER = 5
local PADDING = 2
local DEFAULT_TEXT_HEIGHT = 18

local messageBoxWindow
local textBoxLinkedList -- newest element first
local oldestTextTimer

local soundFile = "sounds/place_beep.wav"


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function RefreshDisplay(removeLastElement)
  if not messageBoxWindow then
    return
  end

  local textHeightWithPadding = PADDING + (options.text_height.value or DEFAULT_TEXT_HEIGHT)
  local positionY = messageBoxWindow.height
  local previousL
  local l = textBoxLinkedList
  while l do
    local elem = l.value
    local lineCount = #elem.textBox.physicalLines
    
    -- starting with the newest at the bottom of the window, each subsequent textBox is set above the previous one
    positionY = positionY - (lineCount * textHeightWithPadding)
    elem.textBox.y = positionY
    elem.textBox:Invalidate()
    if removeLastElement then
      local nextL = l.next
      if not nextL then
        
        elem.textBox:Dispose()
        if previousL then
          previousL.next = nil
          oldestTextTimer = previousL.value.timer
        else
          oldestTextTimer = nil
        end
        
      end
      previousL = l
      l = nextL
    else
      l = l.next
    end
  end
  
  messageBoxWindow:UpdateLayout()
end


local function AddMessage(message)
  if not messageBoxWindow then
    return
  end
  
  local textHeight = options.text_height.value or DEFAULT_TEXT_HEIGHT
  
  local newTextBox = Chili.TextBox:New{
    parent = messageBoxWindow,
    text = message,
    fontsize = textHeight,
    padding = {0 , 0, 0, 0},
    margin = {0, 0, 0, 0},
    width = '100%',
    height = PADDING + textHeight,
    x = PADDING,
    y = messageBoxWindow.height,
    
    font = {
--      font          = "FreeSansBold.otf",
--      size          = textHeight,
      shadow        = false,
      outline       = true,
--      outlineWidth  = 3,
--      outlineWeight = 3,
      color         = {0.85, 0.85, 0.85, 1},
      outlineColor  = {0, 0, 0, 1},
      autoOutlineColor = true,
    },
  }
  
  local newTextBoxElement = {
    textBox = newTextBox,
    timer = Spring.GetTimer(),
  }
  if not oldestTextTimer then
    oldestTextTimer = newTextBoxElement.timer
  end
  textBoxLinkedList = {next = textBoxLinkedList, value = newTextBoxElement}
  
  RefreshDisplay(false)
  Spring.PlaySoundFile(soundFile, 1, 'ui')
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function InitializeCampaignMessageBox()
	if messageBoxWindow then
		messageBoxWindow:Dispose()
		messageBoxWindow = nil
	end
  
	local defaultWindowHeight = DEFAULT_LINE_NUMBER*(options.text_height.value or DEFAULT_TEXT_HEIGHT)
	local minWindowHeight = MIN_LINE_NUMBER*(options.text_height.value or DEFAULT_TEXT_HEIGHT)
  local yPosition = DEFAULT_Y_POSITION-- math.floor(screenHeight/4)

	--// WINDOW
	messageBoxWindow = Chili.Window:New{
		backgroundColor = {0, 0, 0, 0},
    borderColor = {0, 0, 0, 0},
		color = {0, 0, 0, 0},
		parent = Chili.Screen0,
		name = "Campaign Message Box",
		padding = {0, 0, PADDING, PADDING},
		x = DEFAULT_X_POSITION,
		y = yPosition,
		width = WINDOW_WIDTH,
		minWidth = WINDOW_WIDTH,
    maxWidth = WINDOW_WIDTH,
		height = defaultWindowHeight + PADDING,
		minHeight = minWindowHeight,
		draggable = false,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = true,
		minimizable = false,
	}
  messageBoxWindow.OnResize[#messageBoxWindow.OnResize + 1] = function()
    RefreshDisplay(false)
  end
  
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

options_path = 'Settings/HUD Panels/Campaign Messages'
options_order = {'text_height'}
options = {
	text_height = {
		name = 'Font Size (10-30)',
		type = 'number',
		value = DEFAULT_TEXT_HEIGHT,
		min = 10, max = 30, step = 1,
		OnChange = InitializeCampaignMessageBox,
		advanced = true
	},
	display_time = {
		name = 'Message Display Time (5-30)',
		type = 'number',
		value = 15,
		min = 5, max = 30, step = 5,
		advanced = true
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:Update(_)
  if oldestTextTimer and Spring.DiffTimers(Spring.GetTimer(), oldestTextTimer) > (options.display_time.value or 15) then
    RefreshDisplay(true)
  end
end


function widget:Initialize()
	Chili = WG.Chili

	if (not Chili) then
		widgetHandler:RemoveWidget()
		return
	end
  
	InitializeCampaignMessageBox()
	widgetHandler:RegisterGlobal('DisplayCampaignMessage', AddMessage)
	Spring.SendCommands("info 0")
end