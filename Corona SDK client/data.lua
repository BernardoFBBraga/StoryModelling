--local burstGatherer = require("burstGatherer")
local data = {}

local json = require("json")

local storyboard = require("storyboard")



local function networkListener( event )
        if ( event.isError ) then
                print( "Network error!")
        elseif ( event.phase == "began" ) then
                if event.bytesEstimated <= 0 then
                     --   print( "Download starting, size unknown" )
                else
                     --   print( "Download starting, estimated size: " .. event.bytesEstimated )
                end
        elseif ( event.phase == "progress" ) then
                if event.bytesEstimated <= 0 then
                      --  print( "Download progress: " .. event.bytesTransferred )
                else
                     --   print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
                end
        elseif ( event.phase == "ended" ) then
               data.currentStory = response
        end
end

local params = {}

-- This tells network.request() that we want the 'began' and 'progress' events...
params.progress = "download"

network.request( "http://localhost:8080/emfrest/app/Database/My1/users/bernardofbbraga/posts/Story/StarWars/elements/Situation/Luke%20dreams/present?depth=2", "GET", networkListener,  params )

print(data.currentStory)
return data