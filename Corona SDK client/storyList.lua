

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
	local widgetGroup = self.view
	
	scene:addEventListener( "dataReady", function() scene:removeEventListener( "dataReady");storyboard.hideOverlay(); setScrollList() end  )

	storyboard.showOverlay( "loading" )
	local function setScrollList()

		-- create a constant for the left spacing of the row content
		local LEFT_PADDING = 10

		-- Forward reference for our  tableview
		local list
		local rowTitles = {}
		local cat_inst_map = {}
		-- Handle row rendering
		local function onRowRender( event )
			local phase = event.phase
			local row = event.row
			local isCategory = row.isCategory
			
			-- in graphics 2.0, the group contentWidth / contentHeight are initially 0, and expand once elements are inserted into the group.
			-- in order to use contentHeight properly, we cache the variable before inserting objects into the group

			local groupContentHeight = row.contentHeight
			
			local rowTitle = display.newText( row, rowTitles[row.index], 0, 0, native.systemFontBold, 16 )

			-- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
			rowTitle.x = LEFT_PADDING

			-- we also set the anchorX of the text to 0, so the object is x-anchored at the left
			rowTitle.anchorX = 0

			rowTitle.y = groupContentHeight * 0.5
			rowTitle:setFillColor( 0, 0, 0 )
			
			if not isCategory then
				local rowArrow = display.newImage( row, "assets/rowArrow.png", false )
				rowArrow.x = row.contentWidth - LEFT_PADDING

				-- we set the image anchorX to 1, so the object is x-anchored at the right
				rowArrow.anchorX = 1

				-- we set the image anchorX to 1, so the object is x-anchored at the right
				rowArrow.y = groupContentHeight * 0.5
			end
		end

		-- Hande row touch events
		local function onRowTouch( event )
			local phase = event.phase
			local row = event.target
			
			if "press" == phase then
				print( "Pressed row: " .. row.index )

			elseif ("release" == phase) or ( "tap" == phase) then
				storyboard.gotoScene( "instanceFocus", {params = {cat = cat_inst_map[row.index].cat, inst=cat_inst_map[row.index].inst}} )
				print( "Tapped and/or Released row: " .. row.index )
				
			end
			
		end

		-- Create a tableView
		list = widget.newTableView
		{
			top =  topbar.y +topbar.height/2,--display.screenOriginY + topbar.y +topbar.height,
			width = display.actualContentWidth, 
			height = display.actualContentHeight - topbar.height - tabbar.height,
			--maskFile = "mask-320x448.png",
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
		}

		--Insert widgets/images into a group
		widgetGroup:insert( list )


		--Items to show in our list
		local listItems = data.currentStory

		---[[ **Remove This**
		-- insert rows into list (tableView widget)
		local int x = 0
		for i = 1, #listItems do
			--Add the rows category title
			rowTitles[ #rowTitles + 1 ] = listItems[i].title
			
			--Insert the category
			list:insertRow{
				rowHeight = 24,
				rowColor = 
				{ 
					default = { 150/255, 160/255, 180/255, 200/255 },
				},
				isCategory = true,
			}

			--Insert the item
			for j = 1, #listItems[i].items do
				--Add the rows item title
				rowTitles[ #rowTitles + 1 ] = listItems[i].items[j].label
				
				--Insert the item
				list:insertRow{
					rowHeight = 40,
					isCategory = false,
					listener = onRowTouch 
				}
				cat_inst_map[list:getNumRows()] = {cat = listItems[i], inst = listItems[i].items[j]}
				
			end
		end
	end
	
	

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
