

local widget = require ( "widget" )
local storyboard = require ( "storyboard" )
local tabbar = require("tabbar")
local topbar = require("title")
local plusButton = require ("plusButton")
--Create a storyboard scene for this module
local scene = storyboard.newScene()
local data = require("data")

--Create the scene
function scene:createScene( event )
	
	local webView = native.newWebView(display.screenOriginX +  display.actualContentWidth/2,display.screenOriginY + display.actualContentHeight/2,display.screenOriginX + display.actualContentWidth, display.screenOriginY + display.contentHeight - topbar.height - tabbar.height)
	webView:request( "http://localhost:8000/home.html" )
	self.view:insert( webView)

end
function scene:enterScene( event )
	topbar.title.text = "Screen1"
	plusButton.turnOn()
end
function scene:exitScene( event )
	plusButton.turnOff()
end
--Add the createScene listener
scene:addEventListener( "createScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "enterScene", scene )

return scene
