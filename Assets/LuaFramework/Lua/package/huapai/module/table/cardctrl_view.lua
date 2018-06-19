--
-- Created by IntelliJ IDEA.
-- User: Jufeng01
-- Date: 2016/12/14
-- Time: 12:00
-- To change this template use File | Settings | File Templates.
--

---@class CardCtrlView
local CardCtrlView = {}

local Manager = require("package.public.module.function_manager")
local TableUtilPaoHuZi = require("package.huapai.module.tablebase.table_util")
local ComponentUtil = ModuleCache.ComponentUtil
local ComponentTypeName = ComponentTypeName



local CHI_TYPE = { "左吃", "中吃", "右吃", "小小大", "小大大", "二七十", }

--- 绑定视图
--- @param module TableModule
--- @param view UnityEngine.GameObject
--- @param cloneRoot UnityEngine.GameObject
function CardCtrlView:bind_view(module, view, cloneRoot)
    self.module = module
    self.view = view
    self.ctrl = {}
    self.ctrl.obj = Manager.FindObject(view, "Ctrl" .. AppData.Game_Name)
    self.ctrl.guo = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Guo")
    self.ctrl.guo.onClick:AddListener(function()
        self:on_click_guo()
        self.ctrl.obj.gameObject:SetActive(false)
       -- ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)
    self.ctrl.chi = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Chi")
    self.ctrl.chi.onClick:AddListener(function()
        self:request_chi()
        self.ctrl.obj.gameObject:SetActive(false)
       -- ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)




    self.ctrl.BgButton = Manager.GetButton(view, "Bipai/Bg")
    self.ctrl.BgButton.onClick:AddListener(function()
        self.Bipai:SetActive(false)
        self.BipaiFlagShow = true

      --  ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)

    self.ctrl.peng = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Peng")
    self.ctrl.peng.onClick:AddListener(function()
        self:on_click_peng()
        self.ctrl.obj.gameObject:SetActive(false)
      --  ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)

    self.ctrl.Shao = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Shao")
    self.ctrl.Shao.onClick:AddListener(function()
        self:on_click_peng()
        self.ctrl.obj.gameObject:SetActive(false)
      --  ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)

    self.ctrl.hu = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Hu")
    self.ctrl.hu.onClick:AddListener(function()
        self:on_click_hu()
        self.ctrl.obj.gameObject:SetActive(false)
     --   ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)

    --//动作 1:抵 2:吃 3:碰 4:绍 5:下抓 6:半挎  7:满挎 8:出  9：弃牌 10：胡  11: 开局  12:出张收回
    self.ctrl.Di = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Di")
    self.ctrl.Di.onClick:AddListener(function()
        self.module.model:request_di()
        self.ctrl.obj.gameObject:SetActive(false)
      --  ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)


   


    self.ctrl.Zhua = Manager.GetButton(view, "Ctrl" .. AppData.Game_Name .. "/Zhua")
    self.ctrl.Zhua.onClick:AddListener(function()
        self.module.model:request_zhua()
        self.ctrl.obj.gameObject:SetActive(false)
    --    ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    end)

    self.Bipai = Manager.FindObject(view, "Bipai")
    self.chipai = {}
    self.chipai.obj = Manager.FindObject(view, "Bipai/Chi")
    self.chipai.img = Manager.GetImage(self.chipai.obj, "Image")
    self.chipai.clone = Manager.FindObject(cloneRoot, "Chi")
    self.chipai.light = Manager.FindObject(view, "Bipai/Chi/Highlight")
    self.chipai.layout = Manager.GetComponent(self.chipai.img.gameObject, ComponentTypeName.GridLayoutGroup)

    self.bipai = {}
    for i = 1, 2 do
        local obj = Manager.FindObject(view, "Bipai/Bi" .. i)
        self.bipai[i] = {
            obj = obj,
            scroll = Manager.GetRect(obj, "Scroll View"),
            content = Manager.GetRect(obj, "Scroll View/Viewport/Content"),
            light = Manager.FindObject(obj, "Highlight"),
        }
    end

    self:set_active(false)
end



--- 清除
function CardCtrlView:clear()
    self:set_active(false)
    self.chiShowing = false
    self.chiDataList = nil
    self.ctrl.obj:SetActive(false)
    self:reset_bi_light()
    self.bipai[1].obj:SetActive(false)
    self.bipai[2].obj:SetActive(false)
    self.chipai.obj:SetActive(false)
    self.chipai.light:SetActive(false)
end


--- 过按钮是否在现实
function CardCtrlView:isGuoShow()
    if self.view then
        return self.ctrl.guo.gameObject.activeInHierarchy
    end
end


--- 显示或隐藏
function CardCtrlView:set_active(b)
    if self.view then
        self.view:SetActive(b)
    end
end

--- 显示对应按钮
--- @param data GameState
function CardCtrlView:show_btns(data)
    self.module:start_lua_coroutine(function ()

        coroutine.wait(0.3)
        --print('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM')
        --- 可出可不出，只显示过按钮
        if data.ke_chu == 1 then
            TableUtilPaoHuZi.print("只显示过，可出可不出")
            self:show_guo()
            return
        end
        --- 没有任何操作
      
    
        self:clear()
    
        self.paizhi = -1
        --- 找出吃的牌的值
        for i = 1, #data.player do
            if data.player[i].chu_pai == 1 then
                self.paizhi = data.player[i].fan_zhang[#data.player[i].fan_zhang]
            end

            if data.player[i].chu_pai == 2 then
                self.paizhi = data.player[i].qi_zhang[#data.player[i].qi_zhang]
            end
        end
    
        
        self.ctrl.chi.gameObject:SetActive(data.ke_chi)
        self.ctrl.guo.gameObject:SetActive(data.ke_guo)
        self.ctrl.hu.gameObject:SetActive(data.ke_hu)

        if data.ke_peng then
            if self:IsShao() then
                self.ctrl.Shao.gameObject:SetActive(true)
            else
                self.ctrl.peng.gameObject:SetActive(true)
            end
        else
            self.ctrl.peng.gameObject:SetActive(false)
            self.ctrl.Shao.gameObject:SetActive(false)
        end
        self.ctrl.Di.gameObject:SetActive(data.ke_di)

        self.ctrl.Zhua.gameObject:SetActive(data.ke_zhua)


        self:set_active(true)
        self.ctrl.obj:SetActive(true)
    end)
end

--- 只显示过，存在可出牌也可不出牌的情况才使用
function CardCtrlView:show_guo()
    self:clear()
    ComponentUtil.SafeSetActive(self.ctrl.obj, true)
    ComponentUtil.SafeSetActive(self.ctrl.guo.gameObject, true)
    ComponentUtil.SafeSetActive(self.ctrl.peng.gameObject, false)
    ComponentUtil.SafeSetActive(self.ctrl.chi.gameObject, false)
    ComponentUtil.SafeSetActive(self.ctrl.hu.gameObject, false)
    self:set_active(true)
end

function CardCtrlView:on_click_guo()

    self.module.model:request_guo()
    self:set_active(false)
    self.ctrl.obj:SetActive(false)
end

function CardCtrlView:on_click_chi()
    if self.chiShowing then
        return
    end

    self.chiShowing = true
    self.chipai.obj:SetActive(true)
    self:refresh_chi_position()
end

function CardCtrlView:IsShao()
    local data = DataHuaPai.Msg_Table_GameStateNTF
    for i = 1, #data.player do
        local localSeatID = self.module:get_local_seat(i - 1)
        local datas = data.player[i]
        if localSeatID == 1 and datas.chu_pai == 1 then
            return true
        end
    end
    return false
end

function CardCtrlView:on_click_peng()

    self.module.model:request_peng()
    self:set_active(false)
    self.ctrl.obj:SetActive(false)

end

function CardCtrlView:on_click_hu()
    self.module.model:request_hu()
    self:set_active(false)
end





--- 刷新位置
function CardCtrlView:refresh_chi_position()
    local spacing = 30
    local width1 = self.chipai.img.rectTransform.sizeDelta.x
    local width2 = self.bipai[1].scroll.sizeDelta.x
    local width3 = self.bipai[2].scroll.sizeDelta.x

    if self.chipai.obj.activeSelf and self.bipai[1].obj.activeSelf and self.bipai[2].obj.activeSelf then
        local pos = self.bipai[2].obj.transform.position
        pos.x = self.ctrl.guo.transform.position.x
        self.bipai[2].obj.transform.position = pos
        local localPos = self.bipai[2].obj.transform.localPosition
        localPos.x = localPos.x - (width2 + width3) / 2 - spacing
        self.bipai[1].obj.transform.localPosition = localPos
        localPos = self.bipai[1].obj.transform.localPosition
        localPos.x = localPos.x - (width1 + width2) / 2 - spacing
        self.chipai.obj.transform.localPosition = localPos
    elseif self.chipai.obj.activeSelf and self.bipai[1].obj.activeSelf then
        local pos = self.bipai[1].obj.transform.position
        pos.x = self.ctrl.guo.transform.position.x
        self.bipai[1].obj.transform.position = pos
        local localPos = self.bipai[1].obj.transform.localPosition
        localPos.x = localPos.x - (width1 + width2) / 2 - spacing
        self.chipai.obj.transform.localPosition = localPos
    elseif self.chipai.obj.activeSelf then
        local pos = self.chipai.obj.transform.position
        self.chipai.obj.transform.position = Vector3.New(self.ctrl.chi.transform.position.x, pos.y, pos.z)
    end
end

--- 重置比牌高亮物体
function CardCtrlView:reset_bi_light()
    self.bipai[1].light:SetActive(false)
    self.bipai[1].light.transform:SetParent(self.bipai[1].obj.transform)
end

--- 请求吃牌
function CardCtrlView:request_chi()
    self.module.model:request_chi()
end

return CardCtrlView