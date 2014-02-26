local gatherer
gatherer.requests = {}


self.coroutine = coroutine.create(
	function ()
		local i = 1
        while true do
			if self.requests[i] == nil then
				--Paralizes
				coroutine.yield()
			end

			if self.requests[i] ~= nil then					
				--do action here
				print("RESUME ", i)
				i = i+1
			end

			if i == self.stopAt then
				--set end conditions when known. Remember to resume the routine after setting it as it may be yielded.
				break;
			end
		end
	end
)

function gatherer:postReady(request)
    self.requests[request.position] = request
	if coroutine.status(self.coroutine) == "suspended" then
		coroutine.resume(self.coroutine)
	end
end

return gatherer
