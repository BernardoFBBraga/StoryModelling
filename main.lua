-- 
-- Abstract: Tab Bar sample app
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Demonstrates how to create a tab bar that allows the user to navigate between screens,
-- using the Widget & Storyboard libraries.
--
-- Supports Graphics 2.0
------------------------------------------------------------

--[[]
--hack pra pegar o topo certo
local statusBarHeight
if (system.getInfo("androidDisplayDensityName") == "xxhdpi") then
    statusBarHeight = 75 * display.contentScaleY
else
    statusBarHeight = display.topStatusBarContentHeight
end

display.status = display.screenOriginY + statusBarHeight

--]]
display.setStatusBar(display.DarkStatusBar)
local title = require ("title")
local plusButton = require ("plusButton")
local tabbar = require ( "tabbar" )
local storyboard = require ( "storyboard" )
local data = require ("data")


display.setDefault( "background", 1 )
storyboard.gotoScene( "screen1" )


