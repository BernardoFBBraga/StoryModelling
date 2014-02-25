--local burstGatherer = require("burstGatherer")
local data = {}

data.users = {}

local json = require("json")

local storyboard = require("storyboard")
local nReqCall = 0;
local nReqEnd = 0;

function data:requestUserStories(user)
	
end


data.request = function()
	local function requestAndParse(url, parseFunc )
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
		               -- print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
		                storyboard.getScene(storyboard.getCurrentSceneName()):dispatchEvent( event )
		                parseFunc(json.decode(event.response))
		                nReqEnd = nReqEnd+1;
		        end
		end

		local params = {}

		-- This tells network.request() that we want the 'began' and 'progress' events...
		params.progress = "download"

		network.request( url, "GET", networkListener,  params )
	end


	requestAndParse("http://localhost:8080/emfrest/app/Database/My1/users/", 
		function(users) 
			for k,v in pairs(users) do 
				data.users[v.username] = v --{password = v.password} --devo manter tudo ou descartar a chave????
				data.users[v.username].posts = {}
				--print(v.username)
				data.users[v.username].posts.Story = {}
				data.users[v.username].posts.Model = {}
				data.users[v.username].posts.Comment = {}
				requestAndParse("http://localhost:8080/emfrest/app/Database/My1/users/"..v.username.."/posts/", 
					function(posts)
						for k2,v2 in pairs(posts.Model) do 
							data.users[v.username].posts.Model[v2.id] = v2 
							--print("",data.users[v.username].posts.Model[v2.id].id,data.users[v.username].posts.Model[v2.id].creation_time)
							requestAndParse("http://localhost:8080/emfrest/app/Database/My1/users/"..v.username.."/posts/Model/"..data.users[v.username].posts.Model[v2.id].id.."/classes/", 
								function(classes)
									data.users[v.username].posts.Model[v2.id].classes = { Situation_classifier = classes.Situation_classifier, Event_classifier = classes.Event_classifier, Node_classifier = classes.Node_classifier, Link_classifier = classes.Link_classifier}
									--for k3,v3 in pairs(classes.Node_classifier) do print("","",v3.name)end
								end
							)
							nReqCall=nReqCall+1;
						end
						for k2,v2 in pairs(posts.Story) do 
							data.users[v.username].posts.Story[v2.id] = v2
							requestAndParse("http://localhost:8080/emfrest/app/Database/My1/users/"..v.username.."/posts/Story/"..
								data.users[v.username].posts.Story[v2.id].id.."/elements/", 
								function(elements)
									data.users[v.username].posts.Story[v2.id].elements = { Node = elements.Node, Link = elements.Link, Happening = elements.Happening, Action = elements.Action}
									
								end
							)
							nReqCall=nReqCall+1;
						end
					end
				)
				nReqCall=nReqCall+1;
			end
		end
	)
	nReqCall=nReqCall+1;
end

return data