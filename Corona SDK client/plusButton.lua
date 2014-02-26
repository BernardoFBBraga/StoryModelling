local LEFT_PADDING = 10
local TOP_PADDING = 10
local topbar = require("title")
local widget = require("widget")
local storyboard = require("storyboard")
--Create the back button

local plusButton

local newInstance = function()
	storyboard.gotoScene(storyboard.gotoScene("newInstance"))
	print("plusButton clicked")
end

plusButton = widget.newButton
{
	width = 56,
	height = 56,
	label = "+", 
	labelYOffset = - 1,
	onRelease = newInstance	
}
plusButton.alpha = 0
plusButton.x = display.screenOriginX + display.actualContentWidth - plusButton.width /2
plusButton.y = topbar.y

plusButton.vanish = function()
	--transition.to( plusButton, { alpha = 0, time = 400, transition = easing.outQuad } )
	plusButton.alpha = 0
end

plusButton.appear = function()
	--transition.to( plusButton, { alpha = 1, time = 400, transition = easing.outQuad } )
	plusButton.alpha = 1
end

--this function sets the back button to do additional actions besides changing scenes. After performing the action once, the button resets to default
plusButton.turnOn = function(f)

	if not(f == nil) then
		--we change the release function to execute the parameter function and the newInstance function
		plusButton._view._onRelease = function()
			--parameter function executed
			f()
			--do default action
			newInstance()
		end
	end
	plusButton.appear()
end

plusButton.turnOff = function()
	plusButton._view._onRelease = newInstance
	plusButton.vanish();
end

return plusButton