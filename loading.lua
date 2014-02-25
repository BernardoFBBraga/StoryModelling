local storyboard = require ( "storyboard" )
local scene = storyboard.newScene()
local data = require("data")

--Create the scene
function scene:createScene( event )
	local widgetGroup = self.view
	local text = display.newText( "Loading.." ,display.screenOriginX + display.actualContentWidth/2 ,display.screenOriginY + display.actualContentHeight/2)
	text:setFillColor(0)
	self.view:insert(text)
	data.request()


end
function scene:enterScene( event )
end
function scene:exitScene( event )
end
--Add the createScene listener
scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "enterScene", scene )

return scene
