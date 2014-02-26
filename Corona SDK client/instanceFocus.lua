local widget = require ( "widget" )
local storyboard = require ( "storyboard" )
local tabbar = require("tabbar")
local topbar = require("title")
local backButton = require("backbutton")

--Create a storyboard scene for this module
local scene = storyboard.newScene()

--Create the scene
function scene:createScene( event )
	local widgetGroup = self.view

	--topbar.title.text = event.params.inst.label .. "["..event.params.cat.title.."]"
	-- create a constant for the left spacing of the row content
	local LEFT_PADDING = 10
	widgetGroup.y = topbar.y+topbar.height
end

function scene:enterScene( event )
	--special handling for the the back button release event
	local function onBackRelease()

		--transition.to( list, { x = display.screenOriginX  + list.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
		--transition.to( itemSelected, { x = display.actualContentWidth + itemSelected.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
		--topbar.title.text = "Screen2"
	end
	backButton.turnOn(onBackRelease)
end

function scene:exitScene  ( event )
	backButton.turnOff()
end
--Add the createScene listener
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
