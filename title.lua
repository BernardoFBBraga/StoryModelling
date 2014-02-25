
local topbar = display.newGroup( )

local statusBarHeight
if (system.getInfo("androidDisplayDensityName") == "xxhdpi") then
    statusBarHeight = 75 * display.contentScaleY
else
    statusBarHeight = display.topStatusBarContentHeight
end


local titleGradient = {
	type = 'gradient',
	color1 = { 189/255, 203/255, 220/255, 255/255 }, 
	color2 = { 89/255, 116/255, 152/255, 255/255 },
	direction = "down"
}
-- Create toolbar to go at the top of the screen
local titleBar = display.newRect( display.screenOriginX + display.actualContentWidth/2, 0, display.actualContentWidth, 32 )
titleBar:setFillColor( titleGradient )

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( "My List", display.actualContentWidth/2, titleBar.y, native.systemFontBold, 20 )

--[[ create a shadow underneath the titlebar (for a nice touch)
local shadow = display.newImage( "shadow.png" )
shadow.anchorX = 0.0	-- TopLeft anchor points
shadow.anchorY =  0.0
shadow.x, shadow.y = display.screenOriginX,titleBar.y + titleBar.contentHeight * 0.5
shadow.xScale = 320 / shadow.contentWidth
shadow.alpha = 0.45
--]]
topbar:insert( titleBar )
topbar:insert( titleText )
--topbar:insert( shadow )
topbar.title = titleText

topbar.y =  statusBarHeight + display.screenOriginY + titleBar.contentHeight * 0.5
return topbar