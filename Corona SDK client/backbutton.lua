local LEFT_PADDING = 10
local TOP_PADDING = 10
local topbar = require("title")
local widget = require("widget")
local storyboard = require("storyboard")
--Create the back button

local backButton

local storyboardBack = function()
	storyboard.gotoScene(storyboard.getPrevious())
	print("backbutton clicked")
end

backButton = widget.newButton
{
	width = 56,
	height = 56,
	label = "Back", 
	labelYOffset = - 1,
	onRelease = storyboardBack	
}
backButton.alpha = 0
backButton.x = display.screenOriginX + backButton.width /2
backButton.y = topbar.y

backButton.vanish = function()
	--transition.to( backButton, { alpha = 0, time = 400, transition = easing.outQuad } )
	backButton.alpha = 0
end

backButton.appear = function()
	--transition.to( backButton, { alpha = 1, time = 400, transition = easing.outQuad } )
	backButton.alpha = 1
end

--this function sets the back button to do additional actions besides changing scenes. After performing the action once, the button resets to default
backButton.turnOn = function(f)

	if not(f == nil) then
		--we change the release function to execute the parameter function and the storyboardBack function
		backButton._view._onRelease = function()
			--parameter function executed
			f()
			--do default action
			storyboardBack()
		end
	end
	backButton.appear()
end

backButton.turnOff = function()
	backButton._view._onRelease = storyboardBack
	backButton.vanish();
end

return backButton