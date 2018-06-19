
local LogConfig = {}

local pacageEnableLogConfig = {
	['biji'] = true,
}

LogConfig.isEnableLog = function(packageName)
	assert(packageName and packageName ~= '', 'packageName should not be nil or empty')
	return pacageEnableLogConfig[packageName] or false
end

return LogConfig