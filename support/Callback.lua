local addon = DiminishingReturns
if not addon then return end

for index = 1, GetNumAddOns() do	
	local callback = GetAddOnMetadata(index, 'X-DiminishingReturns-Callback')
	if callback then
		local parent, version = GetAddOnInfo(index), GetAddOnMetadata(index, 'Version')
		local func, msg = loadstring(callback, parent.." X-DiminishingReturns-Callback")
		addon:Debug('X-DiminishingReturns-Callback for', parent, ' : ', callback)
		if func then
			addon:RegisterAddonSupport(parent, function()
				func()
				return 'supported', version
			end)
		else
			geterrorhandler()(msg)
		end
	end
end
