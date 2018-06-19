-- UICreator 自动生成
-- 层级调整请改变 View.initialize(self, value1, value2, value3) 的Value3
-- 若是特殊UI，请自行调整

-- ========================== 默认依赖 =======================================
local Class = require("lib.middleclass")
local View = require('core.mvvm.view_base')
-- ==========================================================================
---@class GoldEntranceView : View
local GoldEntranceView = Class('goldEntranceView', View)

local ModuleCache = ModuleCache

local ComponentTypeName = ModuleCache.ComponentTypeName
local GetComponentWithPath = ModuleCache.ComponentManager.GetComponentWithPath
local GetComponent = ModuleCache.ComponentManager.GetComponent
local ComponentUtil = ModuleCache.ComponentUtil
local Manager = require("package.public.module.function_manager")
local PlayerPrefs = UnityEngine.PlayerPrefs
local Color = Color
local Vector3 = Vector3

local initTag = false

function GoldEntranceView:initialize(...)
    -- 初始View 
    View.initialize(self, "public/module/goldentrance/public_windowgoldentrance.prefab", "Public_WindowGoldEntrance", 1)
    self:set_1080p()
    self.TableObjList = {}
    self.RoomTable = {}
    self.wanFaBtnTable = {}
    self.textGoldNum = GetComponentWithPath(self.root, "Top/StatusBar/Gold/TextNum", ComponentTypeName.Text)
    self.textDiamondNum = GetComponentWithPath(self.root, "Top/StatusBar/Diamond/TextNum", ComponentTypeName.Text)
    self.textTiliNum = GetComponentWithPath(self.root, "Top/StatusBar/Tili/TextNum", ComponentTypeName.Text)
    self.textPlayDesc = GetComponentWithPath(self.root, "Center/PlayInfo/PlayText", ComponentTypeName.Text)
    self.textGameName = GetComponentWithPath(self.root, "Top/Text", ComponentTypeName.Text)
    self.objRoom = GetComponentWithPath(self.root, "Center/Room/RoomList/Viewport/RoomListContent/Ex", ComponentTypeName.Transform).gameObject
    self.spriteHolder = ModuleCache.ComponentManager.GetComponent(self.root, "SpriteHolder");
    self.grid = GetComponentWithPath(self.root, "Center/Table/ScrollView/Viewport/Content", ComponentTypeName.GridLayoutGroup);
    self.stageSpriteHolder = ModuleCache.ComponentManager.GetComponentWithPath(self.root, "Center/Room", "SpriteHolder");
    self.scrollTable = GetComponentWithPath(self.root, "Center/Table/ScrollView", ComponentTypeName.ScrollRect)
    self.color = { }
    self.color[1] = Color.New(6 / 255, 73 / 255, 107 / 255, 1)
    self.color[2] = Color.New(134 / 255, 55 / 255, 8 / 255, 1)
    self.color[3] = Color.New(50 / 255, 108 / 255, 6 / 255, 1)
    self.color[4] = Color.New(17 / 255, 90 / 255, 30 / 255, 1)
    self.tagObj = {}
    self.recommodRoom = GetComponentWithPath(self.root, "Center/Room/StartBtn/Text (1)", ComponentTypeName.Text)

    self.wanfalistObj = GetComponentWithPath(self.root, "Center/Room/wanFaList/background/Scroll View/Viewport/Content", ComponentTypeName.Transform).gameObject
    self.wanfaTemplate = GetComponentWithPath(self.wanfalistObj, "ItemTemplate", ComponentTypeName.Transform).gameObject

end

function GoldEntranceView:setRecommondRoom(s)
    self.recommodRoom.text = s
end

function GoldEntranceView:refreshBtnSate()
    self.btnRefresh.enabled = false
    ComponentUtil.SafeSetActive(self.btnRefreshObj.transform.gameObject, true)
    self:subscibe_time_event(1, false, 0):SetIntervalTime(0.01,
            function(t)
                self.btnRefreshObj.fillAmount = t.surplusTime
            end
    )   :OnComplete(function(t)
        ComponentUtil.SafeSetActive(self.btnRefreshObj.transform.gameObject, false)
        self.btnRefresh.enabled = true
    end)

end

--更新金币数量
function GoldEntranceView:refresh_gold(data)
    if not data then
        return
    end
    if data.gold then
        self.textGoldNum.text = Util.filterPlayerGoldNum(tonumber(data.gold))
    end
    if data.cards and data.coins then
        self.textTiliNum.text = Util.filterPlayerGoldNum(tonumber(data.cards))
    end
end
--初始化标签
function GoldEntranceView:initTag(tagList, tag)
    --if initTag then
    --    return
    --end
    if self.tagObj and type(self.tagObj) == "table" and #self.tagObj > 0 then
        for _, _obj in ipairs(self.tagObj) do
            Manager.DestroyObject(_obj)
        end
        self.tagObj = {}
    end
    for i, j in pairs(tagList) do
        local target = ComponentUtil.InstantiateLocal(self.objTag, Vector3.zero)
        target.transform:SetParent(self.objTag.transform.parent)
        target.transform.localScale = Vector3.one
        target.transform.localPosition = Vector3.New(target.transform.localPosition.x, target.transform.localPosition.y, 0)
        target.name = tostring(i)
        ComponentUtil.SafeSetActive(target, true)
        local textName1 = GetComponentWithPath(target, "Name", ComponentTypeName.Text)
        local textName2 = GetComponentWithPath(target, "Choose/Name", ComponentTypeName.Text)
        --local objChoose = GetComponentWithPath(target, "Choose", ComponentTypeName.Transform).gameObject
        textName1.text = j.name
        textName2.text = j.name
        --ComponentUtil.SafeSetActive(objChoose,i == tag)
        if AppData.Game_Name == "BULLFIGHT" then
            --拼十特殊处理
            ComponentUtil.SafeSetActive(target, i == tag)
        end
        table.insert(self.tagObj, target)
    end
    self:tagClickDeal(tag)
    initTag = true
end

function GoldEntranceView:tagClickDeal(tag)
    for _, obj in pairs(self.tagObj) do
        local objChoose = GetComponentWithPath(obj, "Choose", ComponentTypeName.Transform).gameObject
        --local btn = GetComponentWithPath(obj,"",ComponentTypeName.Button)
        ComponentUtil.SafeSetActive(objChoose, tonumber(obj.name) == tag)
        --btn.enabled = tonumber(obj.name) ~= tag
    end
    self:refreshPlayDesc(tag)
end

function GoldEntranceView:refreshPlayDesc(tag)
    self.Config = require(string.format("package.public.config.%s.config_%s", AppData.App_Name, AppData.Game_Name))
    self.textPlayDesc.text = ""
    if self.Config.PlayRuleText[tag] then
        self.textPlayDesc.text = self.Config.PlayRuleText[tag]
    else
        self.textPlayDesc.text = self.Config.PlayRuleText[1]
    end
end

--fylq|ysghf|sxmj|hnsx|fnbjz|fnsmh|hhmj|hbtdh|hnmj2|hzmj
--阜阳临泉|颍上杠后翻|濉溪麻将|淮南寿县|阜南掰夹子|阜南三门胡|换换麻将|淮北推倒胡|淮南麻将|红中麻将
function GoldEntranceView:initWanFaList(wanfaNames)
    if self.wanFaBtnTable and  #self.wanFaBtnTable > 0 then
        for _, _obj in ipairs(self.wanFaBtnTable) do
            Manager.DestroyObject(_obj.gameObject)
        end
        self.wanFaBtnTable = {}
    end
    if not wanfaNames then
        return
    end
    local key = string.format("%s_lastSelectGoldPlayTypeName",ModuleCache.GameManager.curGameId)
    local lastSelectGoldPlayTypeName = PlayerPrefs.GetString(key,"")
    local lastSelectIndex = PlayerPrefs.GetInt(AppData.get_url_game_name() .. "_wanfaType", 1)
    for i=1,#wanfaNames do
        local wanfaName = wanfaNames[i]
        local target  = ComponentUtil.InstantiateLocal(self.wanfaTemplate, Vector3.zero)
        target.transform:SetParent(self.wanfaTemplate.transform.parent)
        target.transform.localScale = Vector3.one
        target.transform.localPosition = Vector3.New(target.transform.localPosition.x, target.transform.localPosition.y, 0)
        target.name = wanfaName.wanfaType
        ComponentUtil.SafeSetActive(target, true)
        local bgObj =  GetComponentWithPath(target, "Bg", ComponentTypeName.Transform).gameObject
        local selectObj =  GetComponentWithPath(target, "Select", ComponentTypeName.Transform).gameObject
        local bgText =  GetComponentWithPath(bgObj, "TextBg", ComponentTypeName.Text)
        local selectText =  GetComponentWithPath(selectObj, "TextSelect", ComponentTypeName.Text)
        bgText.text = wanfaName.name
        selectText.text = wanfaName.name
        if lastSelectGoldPlayTypeName == wanfaName.wanfaType then
            lastSelectIndex = i
        end
        local btn =
        {
            gameObject = target,
            selectObj = selectObj,
        }
        table.insert(self.wanFaBtnTable,btn)
    end
    local curSelectBtn = self.wanFaBtnTable[lastSelectIndex]
    if not curSelectBtn then
        lastSelectIndex = 1
        curSelectBtn = self.wanFaBtnTable[lastSelectIndex]
    end
    curSelectBtn.gameObject.transform:SetSiblingIndex(0)
    self:refresh_wanfa_btn_state(curSelectBtn.gameObject)
    return lastSelectIndex
end
function GoldEntranceView:refresh_wanfa_btn_state(curSelectObj)
    for i=1,#self.wanFaBtnTable  do
        local btn = self.wanFaBtnTable[i]
        ComponentUtil.SafeSetActive(btn.selectObj, false)
        if btn.gameObject == curSelectObj then
            ComponentUtil.SafeSetActive(btn.selectObj, true)
        end
    end
end
function GoldEntranceView:get_wanfa_index_by_wanfabtn_obj(obj)
    for i=1,#self.wanFaBtnTable  do
        local btn = self.wanFaBtnTable[i]
        if btn.gameObject == obj then
            return i
        end
    end
end

--初始化房间数据
function GoldEntranceView:initRoomViewList(roomData)

    if self.RoomTable and type(self.RoomTable) == "table" and #self.RoomTable > 0 then
        for _, _obj in ipairs(self.RoomTable) do
            Manager.DestroyObject(_obj)
        end
        self.RoomTable = {}
    end
    for _, j in ipairs(roomData) do
        local target = ComponentUtil.InstantiateLocal(self.objRoom, Vector3.zero)
        target.transform:SetParent(self.objRoom.transform.parent)
        target.transform.localScale = Vector3.one
        target.transform.localPosition = Vector3.New(target.transform.localPosition.x, target.transform.localPosition.y, 0)
        target.name = tostring(j.id)
        ComponentUtil.SafeSetActive(target, true)
        local nameImg = GetComponentWithPath(target, "Name", ComponentTypeName.Image)

        local enterText = GetComponentWithPath(target, "Info/Coin", ComponentTypeName.Text)
        local personNum = GetComponentWithPath(target, "Info/PersonNum", ComponentTypeName.Text)
        local tagDesc = GetComponentWithPath(target, "Corner/Text", ComponentTypeName.Text)
        local tagObj = GetComponentWithPath(target, "Corner", ComponentTypeName.Transform).gameObject
        local textUiSwitch = GetComponentWithPath(target, "TextStyle", "UIStateSwitcher")
        local textParent = GetComponentWithPath(target, "TextStyle/" .. j.index, ComponentTypeName.Transform).gameObject
        local nameText = GetComponentWithPath(textParent, "NameText", ComponentTypeName.Text)
        local difenText = GetComponentWithPath(textParent, "DiFenText", ComponentTypeName.Text)
        textUiSwitch:SwitchState(tostring(j.index))
        personNum.text = j.onlinenum
        nameText.text = j.name
        difenText.text = "底分<size=95>" .. j.difen .. "</size>"
        if tonumber(j.maxJoinCoin) >= 99999999 then
            enterText.text = Util.filterPlayerGoldNumWan(tonumber(j.minJoinCoin)) .. "以上"

        else
            enterText.text = Util.filterPlayerGoldNumWan(tonumber(j.minJoinCoin)) .. "-" .. Util.filterPlayerGoldNumWan(tonumber(j.maxJoinCoin))

        end
        if j.desc == "" then
            ComponentUtil.SafeSetActive(tagObj, false)
        else
            ComponentUtil.SafeSetActive(tagObj, true)
            tagDesc.text = j.desc
        end
        nameImg.sprite = self.stageSpriteHolder:FindSpriteByName(j.index .. "");
        table.insert(self.RoomTable, target)
    end
end

function GoldEntranceView:state_str(num)
    local str
    num = tonumber(num)
    if num <= 20 then
        str = 1
    elseif num <= 100 then
        str = 2
    else
        str = 3
    end
    return str
end



function GoldEntranceView:cloneTable(name, obj, parent)

    local target = ComponentUtil.InstantiateLocal(obj, Vector3.zero)
    if not parent then
        parent = obj.transform.parent
    end
    target.transform:SetParent(parent.transform)
    target.transform.localScale = Vector3.one
    target.transform.localPosition = Vector3.New(target.transform.localPosition.x, target.transform.localPosition.y, 0)
    target.name = tostring(name)
    ComponentUtil.SafeSetActive(target, false)
    return target
end

function GoldEntranceView:click_desc_view(op, obj)
    if op == "close" then
        ComponentUtil.SafeSetActive(self.tableDescObj, false)
    elseif op == "open" then
        if self.timeeventid then
            ModuleCache.SmartTimer.instance:Kill(self.timeeventid)
        end
        ComponentUtil.SafeSetActive(self.tableDescObj, true)
        self.tableDescObj.transform.position = obj.transform.position
        --local rt = GetComponent(self.tableDescObj,ComponentTypeName.RectTransform)
        self.tableDescObj.transform.localPosition = Vector3.New(self.tableDescObj.transform.localPosition.x - 106,
                self.tableDescObj.transform.localPosition.y + 162, self.tableDescObj.transform.localPosition.z)
        local desctext = GetComponentWithPath(obj.transform.parent.gameObject, "Desc/FullDesc", ComponentTypeName.Text)
        self.tableDescText.text = desctext.text
        local preferedH = self.tableDescText.preferredHeight
        print("描述文字高度：", preferedH, self.tableDescDi.rect.height)
        self.tableDescDi.sizeDelta = Vector2(self.tableDescDi.sizeDelta.x, preferedH + 63)

        local timeevent = self:subscibe_time_event(5, false, 0):OnComplete(function(t)
            ComponentUtil.SafeSetActive(self.tableDescObj, false)
        end)
        self.timeeventid = timeevent.id
    end
end

function GoldEntranceView:singleTableView(tableObj, tableData)
    local roomIdText = GetComponentWithPath(tableObj, "Enter/RoomNum", ComponentTypeName.Text)
    local ruleText = GetComponentWithPath(tableObj, "Desc", ComponentTypeName.Text)
    local ruleFullText = GetComponentWithPath(tableObj, "Desc/FullDesc", ComponentTypeName.Text)
    local difenText = GetComponentWithPath(tableObj, "DiFenText", ComponentTypeName.Text)
    local enterText = GetComponentWithPath(tableObj, "EnterNum/Text", ComponentTypeName.Text)
    local leaveText = GetComponentWithPath(tableObj, "LeaveNum/Text", ComponentTypeName.Text)
    local cheatObj1 = GetComponentWithPath(tableObj, "Cheat", ComponentTypeName.Transform).gameObject
    local cheatObj2 = GetComponentWithPath(tableObj, "Enter/Cheat", ComponentTypeName.Transform).gameObject
    local descBtn = GetComponentWithPath(tableObj, "DescBtn", ComponentTypeName.Button)
    roomIdText.text = tableData.roomNo
    self.Config = require(string.format("package.public.config.%s.config_%s", AppData.App_Name, AppData.Game_Name))
    --print("玩法规则：",tableData.rule)
    local rule = {}
    if (tableData.rule ~= "......") then
        rule = ModuleCache.GameUtil.json_decode_to_table(tableData.rule)
        local desc = self.Config:PlayRule(rule)
        ruleText.text = desc
        ruleFullText.text = desc
        local subdesc = desc
        local rect = GetComponent(ruleText.transform.gameObject, ComponentTypeName.RectTransform)
        local preferedw = ruleText.preferredWidth
        local transw = rect.rect.width
        local sublen = math.floor(string.len(desc) * (transw / preferedw)) - 3
        print("获取宽度：", preferedw, transw, sublen)
        if preferedw > transw then
            subdesc = string.sub(desc, 1, sublen) .. "..."
        end
        ruleText.text = subdesc
        ComponentUtil.SafeSetActive(descBtn.transform.gameObject, preferedw > transw)
    end

    difenText.text = tostring(tableData.difen)
    enterText.text = "入场:" .. Util.filterPlayerGoldNum(tonumber(tableData.enterGoldNum))
    leaveText.text = "离场:" .. Util.filterPlayerGoldNum(tonumber(tableData.leaveGoldNum))

    local pex = GetComponentWithPath(tableObj, "PersonEx", ComponentTypeName.Transform).gameObject
    local p = GetComponentWithPath(tableObj, "Person", ComponentTypeName.Transform).gameObject
    if p then
        UnityEngine.GameObject.Destroy(p)
    end
    local newp = self:cloneTable("Person", pex)
    ComponentUtil.SafeSetActive(newp, true)
    ComponentUtil.SafeSetActive(cheatObj1, rule.anticheat)
    ComponentUtil.SafeSetActive(cheatObj2, rule.anticheat)

    newp.transform.position = pex.transform.position
    for i = 1, tableData.maxPlayerNum do
        local e = self:cloneTable(tostring(i), self.objPerson, newp)
        ComponentUtil.SafeSetActive(e, true)
        local playerImg = GetComponentWithPath(e, "View", ComponentTypeName.Transform).gameObject
        ComponentUtil.SafeSetActive(playerImg, i <= tonumber(tableData.playerNum))
    end
    --local g = GetComponentWithPath(tableObj, "Person", ComponentTypeName.GridLayoutGroup)-- ModuleCache.ComponentManager.GetComponent(p,  ComponentTypeName.GridLayoutGroup);
    --g.enabled = false
    --g.enabled = true
    --UnityEngine.GameObject.Destroy(p)


    --for (int i = 0; i < p.childCount; i++) {
    --Destroy (transform.GetChild (i).gameObject);
    --}

    --local player_num = tonumber(tableData.playerNum)
    --if player_num > 0 then
    --    for i = 1, player_num do
    --        local playerImg = GetComponentWithPath(tableObj, "Person/" .. i .. "/View", ComponentTypeName.Transform).gameObject
    --        ComponentUtil.SafeSetActive(playerImg, true)
    --    end
    --end
end

function GoldEntranceView:initTableData(tableDataL)
    self.table_data = tableDataL
    self:startViewTable()
end

function GoldEntranceView:startViewTable()

    print("开始显示牌桌数据，", #self.TableObjList, type(self.table_data))
    for i = 1, #self.TableObjList do
        if self.TableObjList[i] then
            ComponentUtil.SafeSetActive(self.TableObjList[i], false)
        else
            ModuleCache.GameSDKInterface:ReportException("goldentranceview.startViewTable", "TableObjList为空,i:" .. i, "")
        end
    end
    if #self.TableObjList == 50 and self.table_data then
        for _, data in ipairs(self.table_data) do
            if data.index <= 50 then
                if self.TableObjList[data.index] then
                    local obj = self.TableObjList[data.index]
                    obj.name = tostring(data.roomNo)
                    self:singleTableView(obj, data)
                    ComponentUtil.SafeSetActive(obj, true)
                end

            end
        end
    end
    self.grid.enabled = false
    self.grid.enabled = true
end

return GoldEntranceView