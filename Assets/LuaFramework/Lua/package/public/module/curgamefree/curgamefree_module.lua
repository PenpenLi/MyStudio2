-- 初始化
local class = require("lib.middleclass")
local ModuleBase = require("core.mvvm.module_base")
local CurGameFreeModule = class("curGameFreeModule", ModuleBase)

-- 常用模块引用
local ModuleCache = ModuleCache
local NetClientManager = ModuleCache.net.NetClientManager

function CurGameFreeModule:initialize(...)
    -- 开始初始化                view        loginModel           模块数据
    ModuleBase.initialize(self, "curgamefree_view", nil, ...)
end

-- 模块初始化完成回调，包含了view，Model初始化完成
function CurGameFreeModule:on_module_inited()

end

-- 绑定module层的交互事件
function CurGameFreeModule:on_module_event_bind()

end

-- 绑定loginModel层事件，模块内交互
function CurGameFreeModule:on_model_event_bind()


end

function CurGameFreeModule:on_show(data)
    if data.imgUrl and data.imgUrl ~= "" then
        TableUtil.only_download_head_icon(self.view.bgSprite, data.imgUrl)
    end

end

function CurGameFreeModule:on_click(obj, arg)

    ModuleCache.SoundManager.play_sound("henanmj", "henanmj/sound/button.bytes", "button")
    if obj.name == "ButtonBack" then
        ModuleCache.ModuleManager.hide_module("public", "curgamefree")
        return
    end
end





return CurGameFreeModule



