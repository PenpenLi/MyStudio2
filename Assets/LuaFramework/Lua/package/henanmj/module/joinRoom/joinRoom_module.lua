-- ===============================================================================================--
-- data:2016.11.25
-- author:dred
-- desc: 登录模块
-- ===============================================================================================--

-- 初始化
local class = require("lib.middleclass")
local ModuleBase = require("core.mvvm.module_base")
local JoinRoomModule = class("BullFight.JoinRoomModule", ModuleBase)

-- 常用模块引用
local ModuleCache = ModuleCache
local NetClientManager = ModuleCache.net.NetClientManager
local UnityEngine = UnityEngine



function JoinRoomModule:initialize(...)
	-- 开始初始化                view        loginModel           模块数据
	ModuleBase.initialize(self, "joinRoom_view", "joinRoom_model", ...)

	self.strRoomNum = ''
	self.AgentParlorCount = 0
end

-- 模块初始化完成回调，包含了view，Model初始化完成
function JoinRoomModule:on_module_inited()

end


-- 绑定module层的交互事件
function JoinRoomModule:on_module_event_bind()

end


function JoinRoomModule:on_model_event_bind()

end

function JoinRoomModule:on_show(joinData)
	if(not joinData) then
		joinData = { mode = 1 }
	end
	self.joinData = joinData
	self.joinMode = joinData.mode

	self:cleanRoomNumAndRefreshView()
	self.view:refreshPlayMode()
	self:CheckShowTip()
end

function JoinRoomModule:cleanRoomNumAndRefreshView()
	self.strRoomNum = ''
	self.joinRoomView:refreshRoomNumText(self.strRoomNum);
	self.view:refreshGoldNumText(self.strRoomNum)
end

function JoinRoomModule:removeLastNum()
	local len = string.len(self.strRoomNum)
	if(len == 0) then
		self.strRoomNum = ''
	else
		self.strRoomNum = string.sub(self.strRoomNum, 1, len - 1)
	end
end


function JoinRoomModule:on_click(obj, arg)
	ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
	if obj == self.joinRoomView.closeBtn.gameObject then
		ModuleCache.ModuleManager.hide_module("henanmj", "joinroom")
		return
	elseif obj == self.joinRoomView.keyboardMap.buttonDelete.gameObject then
		self:removeLastNum()
		self.joinRoomView:refreshRoomNumText(self.strRoomNum)
		self.view:refreshGoldNumText(self.strRoomNum)

	elseif obj == self.joinRoomView.keyboardMap.buttonClean.gameObject then
		self:cleanRoomNumAndRefreshView();
	elseif(obj.name == "ButtonConfirm") then
		if(self.strRoomNum == "") then
			self.strRoomNum = "0"
		end
		self.view:refreshGoldNumText(self.strRoomNum)
		if(self.joinData.num ~= self.strRoomNum) then
			self:dispatch_module_event("joinroom", "Event_Update_GoldSetNum", {mode = self.joinMode, num = self.strRoomNum})
		end
		ModuleCache.ModuleManager.hide_module("henanmj", "joinroom")
	else
		local len = table.getn(self.joinRoomView.keyboardMap)

		for i=0,len do
			if(obj == self.joinRoomView.keyboardMap[i].gameObject) then
				if(self.joinMode == 1 or self.joinMode == 2) then
					if(string.len(self.strRoomNum) >= 6) then
						return
					end
					self.strRoomNum = self.strRoomNum .. i

					self.joinRoomView:refreshRoomNumText(self.strRoomNum)
					if(string.len(self.strRoomNum) == 6) then
						local roomID = self:getRoomId()

						if roomID <= 99999 then
							if self.joinMode == 2 then

							else
								self:getParlorRules(roomID)
							end

						else
							if self.joinMode == 2 then
								ModuleCache.ModuleManager.show_public_module("textprompt"):show_center_tips("圈号不存在")
							else
								self.modelData.tableCommonData.tableType = 0
								self.modelData.hallData.hideCircle = false
								TableManager:join_room(roomID)
							end
						end
						return
					end
				else
					if(string.len(self.strRoomNum) >= 8) then
						return
					end
					self.strRoomNum = self.strRoomNum .. i
					self.view:refreshGoldNumText(self.strRoomNum)
				end
			end
		end
	end
	self:CheckShowTip()
end

function JoinRoomModule:get_Agent_Parlor_Count()
	local requestData = {
		baseUrl = ModuleCache.GameManager.netAdress.httpCurApiUrl .. "parlor/list/getAgentParlorCount?",
		showModuleNetprompt = true,
		params =
		{
			uid = self.modelData.roleData.userID,
		}
	}
	self:http_get(requestData, function(wwwData)
		local retData = wwwData.www.text
		retData = ModuleCache.Json.decode(retData)
		if (retData.success) then
			self.AgentParlorCount = tonumber( retData.data )
		else

		end
	end , function(wwwErrorData)
		print(wwwErrorData.error)
	end )
end


function JoinRoomModule:getParlorRules(parlorId)
    local requestData = {
        baseUrl = ModuleCache.GameManager.netAdress.httpCurApiUrl .. "parlor/list/getParlorByNum?",
        params = {
            uid = self.modelData.roleData.userID,
			parlorNum = parlorId
        },
    }

	self:http_get(requestData, function(wwwOperation)
        local www = wwwOperation.www;
        local retData = ModuleCache.Json.decode(www.text)
        if(retData.ret and retData.ret == 0) then
			-- local retData = ModuleCache.Json.decode(retData.data)
			local playRule = TableUtil.convert_rule(retData.data.playRule)
			print_table(playRule)
			local createName=""

			if(playRule.gameName) then
				createName = playRule.gameName
			else
				createName = Config.get_create_name_by_wanfatype(playRule.GameType)
			end

			print("---------------playRule.GameType:",playRule.GameType,createName)
			if createName then
				self.modelData.tableCommonData.tableType = 0
				self.modelData.hallData.hideCircle = false
				TableManager:join_room(parlorId, createName)
			end
			end
    end, function(wwwErrorData)
        print(wwwErrorData.error)
		if tostring(wwwErrorData.error):find("500") ~= nil or tostring(wwwErrorData.error):find("error") ~= nil then
			if wwwErrorData.www.text then
				local retData = wwwErrorData.www.text
				retData = ModuleCache.Json.decode(retData)
				if retData.errMsg then
					retData = ModuleCache.Json.decode(retData.errMsg)
					ModuleCache.ModuleManager.show_public_module("textprompt"):show_center_tips(retData.message)
				end
			end
		end
    end)
end

function JoinRoomModule:getRoomId()
	return tonumber(self.strRoomNum)
end

function JoinRoomModule:CheckShowTip()
	local inputLen = string.len(self.strRoomNum or '')
	self.view:SetState_InputRoomIdTipGo(inputLen <= 0)
end


return JoinRoomModule



