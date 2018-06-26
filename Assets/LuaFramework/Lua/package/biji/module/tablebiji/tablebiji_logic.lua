local ModuleCache = ModuleCache
local gamelogic = require("package.biji.module.tablebiji.gamelogic")

local class = require("lib.middleclass")
local list = require("list")
local arithmetic = require("util.arithmetic")

--- @class TableBiJiLogic
--- @field tableBiJiView TableBiJiView
local TableBiJiLogic = class('TableBiJiLogic')
local TableBiJiHelper = require("package/biji/module/tablebiji/tablebiji_helper")
local combinations = { };
local _paixing = { };

local CSmartTimer = ModuleCache.SmartTimer.instance
local table = table
local tonumber = tonumber
local ipairs = ipairs


function TableBiJiLogic:initialize(module)
    self.tableModule = module;
    self.modelData = module.modelData;
    self.myRoomSeatInfo = self.modelData.roleData.myRoomSeatInfo;
    self.tableBiJiView = self.tableModule.tableBiJiView;
    self.tableBiJiModel = self.tableModule.tableBiJiModel;
    self.modelData.curTableData = { };
    self.modelData.curTableData.roomInfo = { };
    self.sortSequence = true;
    self.tenthPoker = { };
    -- self.inHandPokerList = {};
    self.isComparing = false;
    self.modelData.curTableData.roomInfo.mySeatInfo = { };
    self.modelData.curTableData.roomInfo.seatInfoList = { };
    for i = 1, 5 do
        local seatInfo = { };
        seatInfo.seatIndex = i;
        table.insert(self.modelData.curTableData.roomInfo.seatInfoList, seatInfo);
    end
    -- self.tableBiJiView:SetRoomInfo(self.modelData.curTableData.roomInfo);
    self.pokersInDesc = { };
    self.modelData.FirstMatching = { };
    self.modelData.SecondMatching = { };
    self.modelData.ThirdMatching = { };
    self.modelData.selectList = { };
    self.player = { };
    self.player.XiPai = { }
    self.isPlayingAnimCount = 0;
    self.waitPlayingFinishFunsQueue = list:new()
    self.resultData = { };
    for i = 1, 11 do
        self.player.XiPai[i] = false
        -- 1,三清;2,全黑;3,全红;4,双顺清;5,三顺清;6,双三条;7,全三条;8,四个头(1);9,四个头(2);10,连顺;11,清连顺;12,三顺子
    end

    -- S:黑桃 H:红桃 C:梅花 D
    -- self.pokercolor={"S","S","D","S","C","H","D","H","D"};
    -- self.pokernum={5,11,13,2,4,5,6,2,4};
    self.exchangePoker = { };
    self.isExchangeFinish = true;
    self.btnname = "";
    self.selectindex = 1;
    self.restcount = 0;
    self.tableBiJiHelper = TableBiJiHelper
    self.pokersNum = 9;
    self.tablePlayerNum = 0
    -- 牌局中的人数
end


function TableBiJiLogic:on_press(obj, arg)
    if (obj.transform.parent and obj.transform.parent.parent and obj.transform.parent.parent.gameObject == self.tableBiJiView.goDealWinPokers) then
        self.lastHoverPoker = obj
        self:on_select_poker(obj)
    end
end

function TableBiJiLogic:on_press_up(obj, arg)
    self.lastHoverPoker = nil
end

-- 选择的牌
function TableBiJiLogic:on_select_poker(obj)
    local count = #self.modelData.selectList;

    -- local seatinfo = self.modelData.curTableData.roomInfo.seatInfoList[1];
    self.selectindex = 1;
    for key, v in ipairs(self.handPokers) do
        if (v.image.gameObject == obj) then
            if v.selected then
                if count > 0 then
                    -- body
                    v.selected = false;
                    for key2, v2 in ipairs(self.modelData.selectList) do
                        if v.image.gameObject == v2.image.gameObject then
                            -- body
                            table.remove(self.modelData.selectList, key2);
                            break;
                        end
                    end
                else
                    return;
                end
                -- body
            else
                if (count < 3) then
                    v.selected = true;
                    table.insert(self.modelData.selectList, v);
                else
                    return;
                end
            end
            if (#self.exchangePoker > 0 and self.exchangePoker[1].indexMatch ~= 5) then

            else
                self.tableBiJiView:refreshCardSelect(v, true);
            end
            break;
        end
    end
end

function TableBiJiLogic:on_drag(obj, arg)
    local count = arg.hovered.Count
    for i = 0, count - 1 do
        local go = arg.hovered[i]
        if (go and go.name == 'poker' and go.transform.parent and go.transform.parent.parent and go.transform.parent.parent.gameObject == self.tableBiJiView.goDealWinPokers) then
            if (go ~= self.lastHoverPoker) then
                self.lastHoverPoker = go
                self:on_select_poker(go)
            end
        end
    end
end


function TableBiJiLogic:LeaveRoom(data)
    local playerID = data.player_id

    self.tablePlayerNum = data.playercnt
    -- 会收到其他玩家的中途进入包，其他玩家在没准备的情况下中途进入也会影响自己的按钮
    local my_seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[self.modelData.roleData.myRoomSeatInfo.SeatID];
    if (my_seatInfo and not my_seatInfo.isReady and self.modelData.curTableData.roomInfo.curRoundNum == 0) then
        self:ResetReadyBtn()
    end

    if (playerID == self.modelData.roleData.userID) then
        return;
    end
    self.tableModule:removeSeatInfoFromChatCurTableData(playerID)
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        if (tonumber(self.modelData.curTableData.roomInfo.seatInfoList[i].playerId) == tonumber(playerID)) then
            -- local seatInfo = {};
            -- seatInfo.seatIndex = self.modelData.curTableData.roomInfo.seatInfoList[i].seatIndex;
            -- self.modelData.curTableData.roomInfo.seatInfoList[i] = seatInfo;
            self.modelData.curTableData.roomInfo.seatInfoList[i].playerId = 0;
        end
        -- self.tableBiJiView:refreshSeat(seatInfo);
    end
    self:RefreshAllSeats();
end

function TableBiJiLogic:RefreshAllSeats()
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        if (seatInfo.playerId == nil) then
            return;
        end
        self.tableBiJiView:refreshSeat(seatInfo);
    end
end

function TableBiJiLogic:InitSeatsInfo(data)
    for i = 1, #data.seatInfo do
        local seatInfo = { };
        seatInfo.seatIndex = data.seatInfo[i].seatNum
        seatInfo.playerId = tostring(data.seatInfo[i].userID)
        if (tonumber(data.seatInfo[i].userID) == tonumber(self.modelData.curTableData.roomInfo.roomHostID)) then
            seatInfo.isCreator = true;
        else
            seatInfo.isCreator = false;
        end
        if (data.seatInfo[i].readyStatus == 1) then
            seatInfo.isReady = true;
        else
            seatInfo.isReady = false;
        end
        seatInfo.isTemporaryLeave = data.seatInfo[i].isTemporaryLeave;
        seatInfo.isOffline = data.seatInfo[i].isOffline;
        seatInfo.gameCount = data.seatInfo[i].gameCount;
        seatInfo.hasConfirmed = data.seatInfo[i].isConfirmed;
        seatInfo.canBeKicked = false;
        if(tonumber(self.modelData.roleData.userID) == tonumber(self.modelData.curTableData.roomInfo.roomHostID)) then
            if(tonumber(seatInfo.playerId) ~= tonumber(self.modelData.curTableData.roomInfo.roomHostID) and seatInfo.gameCount == 0) then
                seatInfo.canBeKicked = true;
            end
        end
        seatInfo.curScore = data.seatInfo[i].curScore;
        -- 玩家房间内积分
        -- seatInfo.winTimes = (seatInfo.isSeated and remoteSeatInfo.winTimes) or 0             --玩家房间内赢得次数
        -- seatInfo.isOffline = (not seatInfo.isSeated) or remoteSeatInfo.isOffline ~= 0      --玩家是否掉线

        -- seatInfo.isDoneComputeNiu = false			            --玩家是否已经完成选牛
        -- seatInfo.isCalculatedResult = false                     --是否已经结算
        seatInfo.roomInfo = data.roomInfo
        seatInfo.localSeatIndex = self.tableBiJiHelper:getLocalIndexFromRemoteSeatIndex(seatInfo.seatIndex, self.modelData.curTableData.roomInfo.mySeatInfo.seatIndex, #self.modelData.curTableData.roomInfo.seatInfoList)
        self.modelData.curTableData.roomInfo.seatInfoList[seatInfo.seatIndex] = seatInfo;
        if (tonumber(data.seatInfo[i].userID) == tonumber(self.modelData.roleData.userID)) then
            self.modelData.curTableData.roomInfo.mySeatInfo = seatInfo;
        end

        self.tableModule:addSeatInfo2ChatCurTableData(seatInfo)
        self:resetSeatHolderArray(#data.seatInfo);
        self.tableBiJiView:refreshSeat(seatInfo);
    end
end

function TableBiJiLogic:RefreshSeatOfflineStatus(playerID, isOffline)
    local seatsInfo = self.modelData.curTableData.roomInfo.seatInfoList;
    for key, v in ipairs(seatsInfo) do
        if (tonumber(v.playerId) == tonumber(playerID)) then
            v.isOffline = isOffline;
            print("------------------",playerID,isOffline)
            if self.modelData.roleData.RoomType == 2  and isOffline  == true and v.gameCount == 0 then -- 快速组局 离线玩家显示踢人按钮
                v.canBeKicked = true
            end
            v.isTemporaryLeave = false;
            self.tableBiJiView:refreshSeat(v);
        end
    end
end

function TableBiJiLogic:RefreshCurScore(data)
    for key, v in ipairs(data.players) do
        self.modelData.curTableData.roomInfo.seatInfoList[v.seatNum].curScore = v.curScore;
        self.tableBiJiView:refreshSeat(self.modelData.curTableData.roomInfo.seatInfoList[v.seatNum]);
    end
end

function TableBiJiLogic:RefreshRoundInfo(curRoundNum)
    self.modelData.curTableData.roomInfo.curRoundNum = curRoundNum;
    self.tableBiJiView:SetRoomInfo(self.modelData.curTableData.roomInfo);
end

function TableBiJiLogic:RefreshTotalRoundInfo(totalRoundNum)
    self.modelData.curTableData.roomInfo.totalRoundCount = totalRoundNum;
    self.tableBiJiView:SetRoomInfo(self.modelData.curTableData.roomInfo);
end

function TableBiJiLogic:onClickKickBtn(index)
    local playerId;
    for key,v in ipairs(self.modelData.curTableData.roomInfo.seatInfoList) do
        if(v.localSeatIndex == tonumber(index)) then
            playerId = v.playerId
        end
    end
    self.tableBiJiModel:request_kick_player(playerId);
end

function TableBiJiLogic:HideKickButton()
    if(tonumber(self.modelData.roleData.userID) ~= self.modelData.curTableData.roomInfo.roomHostID) then
        return;
    end
    local seatsInfo = self.modelData.curTableData.roomInfo.seatInfoList;
    for key, v in ipairs(seatsInfo) do
        if(v.playerId and v.playerId ~= 0) then
            v.canBeKicked = false;
            self.tableBiJiView:refreshSeat(v);
        end
    end
end

function TableBiJiLogic:onClickSurrenderBtn(obj)
    self.tableBiJiModel:request_surrender(self.modelData.roleData.userID);
    self.tableBiJiView:SetDealWindowActive(false);
    -- self.tableBiJiView:SetSurrenderConfirmWindow(false);
    self.tableBiJiView:ShowSelfSurrender()
    self.tableBiJiView:SetSelfImageActive(true);
    self.tableBiJiView:SetClockActive(false);
    -- body
end

-- 配牌
function TableBiJiLogic:onClickPokersOnMatch(obj)
    if (obj.transform.parent.name ~= "pokersOnMatch" and obj.transform.parent.parent.name ~= "pockers") then
        return;
    end
    self.tableBiJiView:SetExchangeHintActive(false);
    local index;

    if (obj.transform.parent.name == "pokersOnMatch") then
        index = tonumber(obj.name) + 1;
    end
    local curMatch = { };
    -- 1代表第一道牌，2代表第二道牌，3代表第三道牌，4代表第10张牌，5代表手牌
    local indexMatch = 0;
    if (obj.transform.parent.parent.gameObject.name == "first") then
        curMatch = self.modelData.FirstMatching;
        indexMatch = 1;
    elseif (obj.transform.parent.parent.gameObject.name == "second") then
        curMatch = self.modelData.SecondMatching;
        indexMatch = 2;
    elseif (obj.transform.parent.parent.gameObject.name == "third") then
        curMatch = self.modelData.ThirdMatching;
        indexMatch = 3;
    end
    if (self.pokersNum == 10 and obj.name == "10") then
        -- 当选中第10张牌时indexMatch为4
        index = 1;
        indexMatch = 4;
        table.insert(curMatch, self.tenthPoker)
    end
    if (obj.transform.parent.parent.gameObject.name == "pockers") then
        -- 当选中手牌时indexMatch为5
        index = tonumber(obj.transform.parent.gameObject.name) + 1;
        indexMatch = 5;
        curMatch = self.handPokers;
        if (#self.modelData.selectList > 1) then
            self.exchangePoker = { };
            return;
        end
    end

    if (#self.exchangePoker == 0) then
        -- 当未选中牌时
        local poker = { };
        if (obj.transform.parent.parent.gameObject.name == "pockers") then
            if (#self.modelData.selectList == 1) then
                poker.index = self:GetSelectedPokerIndex();
                poker.indexMatch = indexMatch;
                poker.number = self.modelData.selectList[1].number;
                poker.colour = self.modelData.selectList[1].colour;
            else
                return;
            end
        else
            if (#self.modelData.selectList > 1) then
                return;
            end
            poker.index = index;
            poker.indexMatch = indexMatch;
            poker.number = curMatch[index].number;
            poker.colour = curMatch[index].colour;
        end
        table.insert(self.exchangePoker, poker);
        self.tableBiJiView:SetExchangePokerColor(indexMatch, index, true);
    elseif (#self.exchangePoker == 1) then
        -- 当选中牌时
        local oldMatch = { };
        local oldIndexMatch = self.exchangePoker[1].indexMatch;
        local oldIndex = self.exchangePoker[1].index;
        if (indexMatch == oldIndexMatch) then
            self.exchangePoker = { };
            self.tableBiJiView:SetExchangePokerColor(oldIndexMatch, oldIndex, false);
            return;
        end
        self.isExchangeFinish = false;
        local poker = { };
        poker.index = index;
        poker.indexMatch = indexMatch;
        poker.number = curMatch[index].number;
        poker.colour = curMatch[index].colour;
        curMatch[index].colour = self.exchangePoker[1].colour;
        curMatch[index].Color = self.exchangePoker[1].colour;
        curMatch[index].number = self.exchangePoker[1].number;
        curMatch[index].Number = self.exchangePoker[1].number;
        -- self.tableBiJiView:setMatchingShow(indexMatch,curMatch,0,false);
        if (indexMatch <= 3) then
            self:sortPoker(curMatch, false);
            self:check_handpokers_in_oringinalPokers(curMatch);
            self.tableBiJiView:setMatchingShow(indexMatch, curMatch, 0, false);
            local res, value = gamelogic.ComputePaixing(curMatch, self.mask)
            self.tableBiJiView:SetPokerTypeHint(indexMatch, res);
        end
        if (self.pokersNum == 10 and indexMatch == 4) then
            self.tableBiJiView:Show10thPokerImage(self.tenthPoker);
        end
        if (indexMatch == 5) then
            self:SetPokersInHand(curMatch, false, self.sortSequence);
        end
        local oldMatch = { };
        local oldIndexMatch = self.exchangePoker[1].indexMatch;
        local oldIndex = self.exchangePoker[1].index;
        if (oldIndexMatch == 1) then
            oldMatch = self.modelData.FirstMatching
        elseif (oldIndexMatch == 2) then
            oldMatch = self.modelData.SecondMatching;
        elseif (oldIndexMatch == 3) then
            oldMatch = self.modelData.ThirdMatching;
        elseif (self.pokersNum == 10 and oldIndexMatch == 4) then
            table.insert(oldMatch, self.tenthPoker)
        elseif (oldIndexMatch == 5) then
            oldMatch = self.handPokers;
        end
        self.tableBiJiView:SetExchangePokerColor(oldIndexMatch, oldIndex, false);
        oldMatch[oldIndex].colour = poker.colour;
        oldMatch[oldIndex].Color = poker.colour;
        oldMatch[oldIndex].number = poker.number;
        oldMatch[oldIndex].Number = poker.number;
        self:sortPoker(oldMatch, false);
        if (oldIndexMatch ~= 5) then
            self.tableBiJiView:setMatchingShow(self.exchangePoker[1].indexMatch, oldMatch, 0, false);
            if (oldIndexMatch <= 3) then
                local res, value = gamelogic.ComputePaixing(oldMatch, self.mask)
                self.tableBiJiView:SetPokerTypeHint(oldIndexMatch, res);
            end
        else
            self:SetPokersInHand(self.handPokers, false, self.sortSequence);
        end
        if (self.pokersNum == 10 and oldIndexMatch == 4) then
            self.tableBiJiView:Show10thPokerImage(self.tenthPoker);
        end

        -- 如果已经放了三道牌上去
        if (#self.modelData.FirstMatching == 3 and #self.modelData.SecondMatching == 3 and #self.modelData.ThirdMatching == 3) then
            self:LocalCheckSequence();
        end
        self.tableBiJiView:ClearSelectedSuggestion();
        self.exchangePoker = { };
    end
end

function TableBiJiLogic:GetSelectedPokerIndex()
    for i = 1, #self.handPokers do
        if (self.handPokers[i].selected) then
            return i;
        end
    end
    return -1;
end

function TableBiJiLogic:onClickSubmitConfirmBtn(obj)
    local pokers = { };
    for key, v in ipairs(self.modelData.FirstMatching) do
        local poker = { };
        poker.Color = v.colour;
        poker.Number = v.number;
        table.insert(pokers, poker);
    end
    for key, v in ipairs(self.modelData.SecondMatching) do
        local poker = { };
        poker.Color = v.colour;
        poker.Number = v.number;
        table.insert(pokers, poker);
    end
    for key, v in ipairs(self.modelData.ThirdMatching) do
        local poker = { };
        poker.Color = v.colour;
        poker.Number = v.number;
        table.insert(pokers, poker);
    end
    if (#self.modelData.FirstMatching ~= 3 or #self.modelData.SecondMatching ~= 3 or #self.modelData.ThirdMatching ~= 3) then
        ModuleCache.ModuleManager.show_public_module("textprompt"):show_center_tips("未完成配牌！")
        return;
    end
    self.tableBiJiModel:request_submit(pokers, self.modelData.roleData.userID);
    -- self.tableBiJiView:SetConfirmWindowActive(false);
    self.tableBiJiView:SetDealWindowActive(false);
    self.tableBiJiView:SetSelfImageActive(true);
    self.tableBiJiView:SetClockActive(false);
    self.tableBiJiView:ShowSelfResultBackTable();
    self:SetMatchingStatus();
    local seatInfoList = self.modelData.curTableData.roomInfo.seatInfoList;
    for key, v in ipairs(seatInfoList) do
        if (not v.hasConfirmed) then
            if (v.playerId ~= 0 and v.playerId ~= nil and v.localSeatIndex ~= 1 and v.localSeatIndex ~= nil and v.gameCount ~= 0) then
                self.tableBiJiView:ShowOthersPokerBack(v.localSeatIndex, false, self.pokersNum)
            end
        end
    end
    if (self.pokersNum == 10) then
        self.tenthPoker = { };
    end
end

function TableBiJiLogic:SetMatchingStatus()
    local seatsInfo = self.modelData.curTableData.roomInfo.seatInfoList;
    for i = 1, #seatsInfo do
        if (seatsInfo[i].localSeatIndex ~= 1 and seatsInfo[i].localSeatIndex ~= nil) then
            self.tableBiJiView:SetMatchingActive(seatsInfo[i].localSeatIndex, true);
        end
    end
end

function TableBiJiLogic:ExitRoom()
    self.tableBiJiModel:request_exit_room(tonumber(self.modelData.roleData.userID));
end

function TableBiJiLogic:resetSeatHolderArray(seatCount)
    local newSeatHolderArray = { }
    local seatHolderArray = self.tableBiJiView.srcSeatHolderArray
    local maxPlayerCount = seatCount
    maxPlayerCount = 6
    if (maxPlayerCount == 3) then
        newSeatHolderArray[1] = seatHolderArray[1]
        newSeatHolderArray[2] = seatHolderArray[3]
        newSeatHolderArray[3] = seatHolderArray[5]
    elseif (maxPlayerCount == 4) then
        newSeatHolderArray[1] = seatHolderArray[1]
        newSeatHolderArray[2] = seatHolderArray[3]
        newSeatHolderArray[3] = seatHolderArray[4]
        newSeatHolderArray[4] = seatHolderArray[5]
    elseif (maxPlayerCount == 5) then
        newSeatHolderArray[1] = seatHolderArray[1]
        newSeatHolderArray[2] = seatHolderArray[3]
        newSeatHolderArray[3] = seatHolderArray[4]
        newSeatHolderArray[4] = seatHolderArray[5]
        newSeatHolderArray[5] = seatHolderArray[6]
    else
        newSeatHolderArray = seatHolderArray
    end

    for i, v in ipairs(seatHolderArray) do
        ModuleCache.ComponentUtil.SafeSetActive(v.seatRoot, false)
    end
    for i, v in ipairs(newSeatHolderArray) do
        ModuleCache.ComponentUtil.SafeSetActive(v.seatRoot, true)
    end
    self.tableBiJiView.seatHolderArray = newSeatHolderArray
end


--- 重置单道牌
--- @param obj table
function TableBiJiLogic:onClickResetBtn(obj)
    if (obj.transform.parent.gameObject.name == "first") then
        for key, v in ipairs(self.modelData.FirstMatching) do
            v.showed = true;
            v.selected = false;
            local poker = { };
            poker.number = v.number;
            poker.Number = v.Number;
            poker.colour = v.colour;
            poker.Color = v.Color;
            poker.showed = v.showed;
            poker.selected = v.selected;
            poker.gameObject = v.gameObject;
            poker.image = v.image;
            table.insert(self.handPokers, poker);
            self.tableBiJiView:refreshCardSelect(v, false);
        end
        self.tableBiJiView:ClearMatchingShow(1);
        self.modelData.FirstMatching = { };
        self.tableBiJiView:SetResetBtnActive(1, false);
        self.tableBiJiView:SetNoPokersImageActive(1, true);
        self.tableBiJiView:ClearPaiXingHint(1);
    end
    if (obj.transform.parent.gameObject.name == "second") then
        for key, v in ipairs(self.modelData.SecondMatching) do
            v.showed = true;
            v.selected = false;
            local poker = { };
            poker.number = v.number;
            poker.Number = v.Number;
            poker.colour = v.colour;
            poker.Color = v.Color;
            poker.showed = v.showed;
            poker.selected = v.selected;
            poker.gameObject = v.gameObject;
            poker.image = v.image;
            table.insert(self.handPokers, poker);
            self.tableBiJiView:refreshCardSelect(v, false);
            -- self.tableBiJiView:setInHandPokerActive(v, true);
        end
        self.tableBiJiView:ClearMatchingShow(2);
        self.modelData.SecondMatching = { };
        self.tableBiJiView:SetResetBtnActive(2, false);
        self.tableBiJiView:SetNoPokersImageActive(2, true);
        self.tableBiJiView:ClearPaiXingHint(2);
    end
    if (obj.transform.parent.gameObject.name == "third") then
        for key, v in ipairs(self.modelData.ThirdMatching) do
            v.showed = true;
            v.selected = false;
            local poker = { };
            poker.number = v.number;
            poker.Number = v.Number;
            poker.colour = v.colour;
            poker.Color = v.Color;
            poker.showed = v.showed;
            poker.selected = v.selected;
            poker.gameObject = v.gameObject;
            poker.image = v.image;
            table.insert(self.handPokers, poker);
            self.tableBiJiView:refreshCardSelect(v, false);
            -- self.tableBiJiView:setInHandPokerActive(v, true);
        end
        self.tableBiJiView:ClearMatchingShow(3);
        self.modelData.ThirdMatching = { };
        self.tableBiJiView:SetResetBtnActive(3, false);
        self.tableBiJiView:SetNoPokersImageActive(3, true);
        self.tableBiJiView:ClearPaiXingHint(3);
    end
    if (self.pokersNum == 10 and self.tenthPoker.number ~= nil) then
        local poker = { };
        poker.number = self.tenthPoker.number;
        poker.Number = self.tenthPoker.Number;
        poker.colour = self.tenthPoker.colour;
        poker.Color = self.tenthPoker.Color;
        poker.showed = self.tenthPoker.showed;
        poker.selected = self.tenthPoker.selected;
        poker.gameObject = self.tenthPoker.gameObject;
        poker.image = self.tenthPoker.image;
        table.insert(self.handPokers, poker);
        self.tableBiJiView:refreshCardSelect(self.tenthPoker, false);
        self.tableBiJiView:Set10thPokersActive(false);
        self.tenthPoker = { };
    end
    local pokersReset = { };
    for key, v in ipairs(self.handPokers) do
        local pokerReset = { };
        pokerReset.Color = v.colour;
        pokerReset.Number = v.number;
        table.insert(pokersReset, pokerReset)
    end
    self:SetPokersInHand(pokersReset, false, self.sortSequence);
    self:SetDealBtnActive();
    self.tableBiJiView:ShowXiPai("");
    self.tableBiJiView:SetResetAllActive(false);
    self:onClickOrderBtn(true);
    self.tableBiJiView:ClearSelectedSuggestion();
    self.tableBiJiView:SetExchangeHintActive(false);
    self.tableBiJiView:SetErrHintActive(false);
    if (#self.exchangePoker > 0) then
        local oldIndexMatch = self.exchangePoker[1].indexMatch;
        local oldIndex = self.exchangePoker[1].index;
        self.tableBiJiView:SetExchangePokerColor(oldIndexMatch, oldIndex, false)
        self.exchangePoker = { };
    end
end

function TableBiJiLogic:onClickResetAllBtnNew(obj)
    self.tableBiJiView:ClearMatchingShow(1);
    self.tableBiJiView:ClearMatchingShow(2);
    self.tableBiJiView:ClearMatchingShow(3);
    self.tableBiJiView:SetResetBtnActive(1, false);
    self.tableBiJiView:SetResetBtnActive(2, false);
    self.tableBiJiView:SetResetBtnActive(3, false);
    self.modelData.FirstMatching = { };
    self.modelData.SecondMatching = { };
    self.modelData.ThirdMatching = { };
    self.modelData.selectList = { }
    self:SetDealBtnActive();
    self.tableBiJiView:ShowXiPai("");
    self.tableBiJiView:SetResetAllActive(false);
    self:onClickOrderBtn(true);
    self.tableBiJiView:ClearSelectedSuggestion();
    self.tableBiJiView:SetExchangeHintActive(false);
    self.tableBiJiView:SetErrHintActive(false);
    if (#self.exchangePoker > 0) then
        local oldIndexMatch = self.exchangePoker[1].indexMatch;
        local oldIndex = self.exchangePoker[1].index;
        self.tableBiJiView:SetExchangePokerColor(oldIndexMatch, oldIndex, false)
        self.exchangePoker = { };
    end
    if (self.pokersNum == 10 and self.tenthPoker.number ~= nil) then
        self.tenthPoker = { };
        self.tableBiJiView:Set10thPokersActive(false);
    end
    self:SetPokersInHand(self.oringinalServerPokers, false, self.sortSequence);
    for i = 1, 3 do
        self.tableBiJiView:ClearPaiXingHint(i);
    end
end


function TableBiJiLogic:RefreshTemporaryLeaveStatus(data)
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        if (tonumber(seatInfo.playerId) == tonumber(data.player_id) and seatInfo.playerId ~= nil) then
            self.modelData.curTableData.roomInfo.seatInfoList[i].isTemporaryLeave = data.is_temporary_leave;
            self.tableBiJiView:refreshSeat(seatInfo);
        end
    end
end

function TableBiJiLogic:SetRoomInfo(data)
    if (not data.err_no or data.err_no == '0') then
        self.roomInfo = {
            roomNum = data.roomInfo.roomNum,
            roomHostID = data.roomInfo.roomHostID,
            curRoundNum = data.roomInfo.curRoundNum,
            totalRoundCount = data.roomInfo.totalRoundNum,
            roomStatus = data.roomInfo.roomStatus,
            roomId = data.roomInfo.roomId
        }
        self.modelData.curTableData.roomInfo.roomNum = self.roomInfo.roomNum;
        self.modelData.curTableData.roomInfo.roomHostID = self.roomInfo.roomHostID;
        self.modelData.curTableData.roomInfo.curRoundNum = self.roomInfo.curRoundNum;
        self.modelData.curTableData.roomInfo.totalRoundCount = self.roomInfo.totalRoundCount;
        self.modelData.curTableData.roomInfo.roomStatus = self.roomInfo.roomStatus;
        self.modelData.curTableData.roomInfo.timeOffset =(data.roomInfo.serverNow or os.time()) - os.time()
        self.roomInfo.rule = self.modelData.roleData.myRoomSeatInfo.Rule
        self.modelData.curTableData.roomInfo.rule = self.roomInfo.rule;
        self.roomInfo.ruleTable = ModuleCache.Json.decode(self.roomInfo.rule);
        self.roomInfo.ruleDesc = self:GetStrRoomRule();
        self.modelData.curTableData.roomInfo.roomId = self.roomInfo.roomId;
        -- self.roomInfo.wanfaName,self.roomInfo.ruleDesc = TableUtil.get_rule_name(self.roomInfo.rule)
        self.pokersNum = self.roomInfo.ruleTable.pokersNum;
        if (self.roomInfo.ruleTable.pokersNum == nil) then
            self.pokersNum = 9;
        end
        self.modelData.curTableData.roomInfo.ruleDesc = self.roomInfo.ruleDesc;
        self.modelData.curTableData.roomInfo.ruleTable = self.roomInfo.ruleTable;
        if (self.roomInfo.curRoundNum == 0) then
            if (self.roomInfo.ruleTable.gameType == 0) then
                self.tableBiJiView:SetGameLogoActive(0, true);
            elseif (self.roomInfo.ruleTable.gameType == 1) then
                self.tableBiJiView:SetGameLogoActive(1, true);
            end
        end
        self:convertMaskCode(self.roomInfo.ruleTable)
        -- self.modelData.curTableData.roomInfo = self.roomInfo;
        -- self.modelData.curTableData.roomInfo.mySeatInfo = {};
        for i = 1, #data.seatInfo do
            if (tonumber(self.modelData.roleData.userID) == tonumber(data.seatInfo[i].userID)) then
                self.modelData.curTableData.roomInfo.mySeatInfo.seatIndex = data.seatInfo[i].seatNum;
            end
        end
        self.tableBiJiView:SetRoomInfo(self.roomInfo);
    end
end

function TableBiJiLogic:GetCurPlayerCount()
    local count = 0;
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        if(self.modelData.curTableData.roomInfo.seatInfoList[i].playerId and self.modelData.curTableData.roomInfo.seatInfoList[i].playerId ~= 0) then
            count = count + 1;
        end
    end
    print("=================",count)
    return count;
end

function TableBiJiLogic:GetStrRoomRule()
    local strRule = "";
    local rule = self.roomInfo.ruleTable;
    strRule = strRule .. rule.roundCount .. "局 ";
    strRule = strRule .. rule.playerCount .. "人 ";
    if (rule.scoreType == 0) then
        strRule = strRule .. "算分(1 2 3 4) "
    elseif (rule.scoreType == 1) then
        strRule = strRule .. "算分(2 4 6 8) "
    end
    if (tonumber(rule.extraScoreTypes) == 16) then
        strRule = strRule .. "喜牌(经典玩法) ";
    elseif (tonumber(rule.extraScoreTypes) == 15) then
        strRule = strRule .. "喜牌(固定加分) ";
    end
    if (tonumber(rule.pokersNum) == 9) then
        strRule = strRule .. "9张配 ";
    elseif (tonumber(rule.pokersNum) == 10) then
        strRule = strRule .. "10张配 ";
    end
    if (rule.hasKing) then
        strRule = strRule .. "带双王 ";
    else
        strRule = strRule .. "不带王 ";
    end
    if (tonumber(rule.payType) == 0) then
        strRule = strRule .. "AA支付 ";
    elseif (tonumber(rule.payType) == 1) then
        strRule = strRule .. "房主支付 ";
    elseif (tonumber(rule.payType) == 2) then
        strRule = strRule .. "大赢家支付 ";
    end
    if (rule.allowHalfEnter) then
        strRule = strRule .. "允许中途加入 ";
    else
        strRule = strRule .. "不允许中途加入 ";
    end
    return strRule;
end

function TableBiJiLogic:GetReadyRsp(data)
    if (data.err_no == "0") then
        self.readyRsp = true;

        self.tableBiJiView:SetReadyCancel(true);
        self:refreshSelfReadyStatus(true);
        -- self.tableBiJiView:SetBtnInviteActive(false);
        self.tableBiJiView:CloseResultTable();
    else
        self.readyRsp = false;
    end
end

function TableBiJiLogic:SetReadyBtnType(data)
    if ((tonumber(data.isJoinAfterStart) == 1) and tonumber(data.roomInfo.roomStatus) == 1) then
        self.tableBiJiView:SetReadyBtn(1);
        self.tableBiJiView:ShowPlayingNotify();
        self.isJoinAfterStart = true;
        return;
    end
    if (data.isJoinAfterStart and tonumber(data.isJoinAfterStart) == 1) then
        self.isJoinAfterStart = true;
    else
        self.isJoinAfterStart = false;
    end
    self.tableBiJiView:ClosePlayingNotify();
    if (self.isJoinAfterStart) then
        if self.modelData.roleData.RoomType ~= 2 then
            -- TODO XLQ:麻将馆随机组局 中途进入的玩家 已经准备后 第一局小结算不再显示准备按钮
            self.tableBiJiView:SetReadyBtn(3);
        end
        self.isJoinAfterStart = false;
        return;
    end

    if (self.modelData.curTableData.roomInfo.curRoundNum == 0) then
        self.tableBiJiView:SetBtnInviteActive(true);
        self:ResetReadyBtn()

        if self.modelData.roleData.RoomType ~= 2 then
            -- 0 非麻将馆房间 1 麻将馆普通开房 2 麻将馆随机组局 3 比赛场房间
            self:onClickReadyBtn(true);
            -- 自动准备    除了随机组局其他都需要自动准备
        end

    else
        local my_seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[self.modelData.roleData.myRoomSeatInfo.SeatID];
--print("------",self.modelData.roleData.RoomType,self.isJoinAfterStart,my_seatInfo.isReady)
        if not my_seatInfo.isReady then
            if self.modelData.roleData.RoomType ~= 2 or not self.isJoinAfterStart then -- 快速组局 中途进入的玩家 在没准备前 都显示离开和邀请按钮 及没倒计时的准备按钮
                self.tableBiJiView:SetBtnInviteActive(false);
                self.tableBiJiView:SetReadyBtn(2);
            end
        end

    end
    if (ModuleCache.GameManager.isEditor and ModuleCache.GameManager.developmentMode) then
        -- self:onClickReadyBtn()
    end
end

function TableBiJiLogic:ResetReadyBtn(data)
    --  print_table(self.modelData,"-----------self.modelData-------ResetReadyBtn--")

    if self.modelData.roleData.RoomType == 2 then
        -- 快速开房
        if (tonumber(self.modelData.curTableData.roomInfo.roomHostID) == tonumber(self.modelData.roleData.userID)) then
            if self.tablePlayerNum > 1 then
                self.tableBiJiView:SetReadyBtn(4);
                -- 显示倒计时准备按钮
            else
                self.tableBiJiView:SetReadyBtn(0);
            end

            local seatsInfo = self.modelData.curTableData.roomInfo.seatInfoList;
            for key, v in ipairs(seatsInfo) do
                if(tonumber(v.playerId) ~= tonumber(self.modelData.curTableData.roomInfo.roomHostID) and v.gameCount == 0) then
                    v.canBeKicked = true;
                    self.tableBiJiView:refreshSeat(v);
                end
            end

        else
            -- 非房主
            if self.tablePlayerNum > 1 then
                self.tableBiJiView:SetReadyBtn(3);
                -- 显示倒计时准备按钮
            else
                self.tableBiJiView:SetReadyBtn(1);
            end

        end
    else
        if (tonumber(self.modelData.curTableData.roomInfo.roomHostID) == tonumber(self.modelData.roleData.userID)) then
            self.tableBiJiView:SetReadyBtn(0);
        else
            -- 非房主
            self.tableBiJiView:SetReadyBtn(1);
            if (data and data.isJoinAfterStart == 1) then
                if (tonumber(data.roomInfo.roomStatus) == 1) then
                    self.tableBiJiView:SetReadyBtn(1);
                else
                    self.tableBiJiView:SetBtnInviteActive(false);
                    self.tableBiJiView:SetReadyBtn(2);
                end
            end
        end
    end

    -- print("----------ResetReadyBtn------------------tablePlayerNum:",self.tablePlayerNum,self.roomInfo.roomHostID,self.modelData.roleData.userID,self.modelData.curTableData.roomInfo.roomHostID)
end

-- 测试所有的牌排列
function TableBiJiLogic:TestAllPokersArrange(handPokers)
    local numData = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local groupData = arithmetic.allCombinationGroup(numData, 3)

    print_table(handPokers)
    for i = 1, #groupData do
        local singleGroupData = groupData[i]
        -- print_table(singleGroupData)
        self.modelData.FirstMatching = { }
        self.modelData.SecondMatching = { }
        self.modelData.ThirdMatching = { }
        for j = 1, 9 do
            if j < 4 then
                table.insert(self.modelData.FirstMatching, handPokers[singleGroupData[j]])
            elseif j > 3 and j < 7 then
                table.insert(self.modelData.SecondMatching, handPokers[singleGroupData[j]])
            else
                table.insert(self.modelData.ThirdMatching, handPokers[singleGroupData[j]])
            end
        end
        self:LocalCheckSequence()
    end

end

--- 本地排序三道牌
function TableBiJiLogic:LocalCheckSequence(onlyCompute)
    local matches = { };
    local pokers = { };
    local mask = { };
    for i = 1, 3 do
        matches[i] = { };
        if (i == 1) then
            for j = 1, 3 do
                local poker = { };
                poker.colour = self.modelData.FirstMatching[j].colour;
                poker.number = self.modelData.FirstMatching[j].number;
                poker.Color = self.modelData.FirstMatching[j].colour;
                poker.Number = self.modelData.FirstMatching[j].number;
                mask[poker.Number * 4 + poker.Color] = true;
                table.insert(matches[i], poker);
            end
            matches[i]["index"] = 1;
        end
        if (i == 2) then
            for j = 1, 3 do
                local poker = { };
                poker.colour = self.modelData.SecondMatching[j].colour;
                poker.number = self.modelData.SecondMatching[j].number;
                poker.Color = self.modelData.SecondMatching[j].colour;
                poker.Number = self.modelData.SecondMatching[j].number;
                mask[poker.Number * 4 + poker.Color] = true;
                table.insert(matches[i], poker);
            end
            matches[i]["index"] = 2;
        end
        if (i == 3) then
            for j = 1, 3 do
                local poker = { };
                poker.colour = self.modelData.ThirdMatching[j].colour;
                poker.number = self.modelData.ThirdMatching[j].number;
                poker.Color = self.modelData.ThirdMatching[j].colour;
                poker.Number = self.modelData.ThirdMatching[j].number;
                mask[poker.Number * 4 + poker.Color] = true;
                table.insert(matches[i], poker);
            end
            matches[i]["index"] = 3;
        end
    end
    gamelogic.SortHBTPai(matches, mask)
    -- print_table(matches)

    local needToChange = false;
    for i = 1, 3 do
        local srcIndex = matches[i]["index"];
        local desIndex = i;
        if (srcIndex ~= desIndex) then
            needToChange = true;
        end
    end
    if (needToChange) then
        -- 自动变牌
        self.tableBiJiView:SetErrHintActive(true);
    end

    for i = 1, 3 do
        for j = 1, 3 do
            table.insert(pokers, matches[i][j])
        end
        self.tableBiJiView:SetPokerTypeHint(i, matches[i].px)
    end

    if ModuleCache.GameManager.isEditor then
        -- local tmpData = {}
        -- table.insert(tmpData, {3,6})
        -- table.insert(tmpData, {4,6})
        -- table.insert(tmpData, {4,14})
        -- table.insert(tmpData, {2,2})
        -- table.insert(tmpData, {2,3})
        -- table.insert(tmpData, {2,10})
        -- table.insert(tmpData, {3,3})
        -- table.insert(tmpData, {3,12})
        -- table.insert(tmpData, {3,13})
        --
        -- for i = 1, #tmpData do
        --    pokers[i].colour = tmpData[i][1]
        --    pokers[i].Color = tmpData[i][1]
        --    pokers[i].number = tmpData[i][2]
        --    pokers[i].Number = tmpData[i][2]
        -- end
    end

    self:CheckedSequence(1, pokers);
    return needToChange;
end

function TableBiJiLogic:SetOthersPokers()
    -- self.isComparing = false;
    local seatInfoList = self.modelData.curTableData.roomInfo.seatInfoList;
    for i = 1, #seatInfoList do
        if (seatInfoList[i].localSeatIndex and seatInfoList[i].localSeatIndex ~= 1 and seatInfoList[i].playerId ~= 0 and seatInfoList[i].playerId ~= nil) then
            self.tableBiJiView:ShowOthersPokerBack(seatInfoList[i].localSeatIndex, true, self.pokersNum);
        end
    end
end

-- 排序
function TableBiJiLogic:CheckedSequence(err_no, pokers)
    self:check_handpokers_in_oringinalPokers(pokers)
    local error = tonumber(err_no);
    local pai = { };
    if (error == 0) then
        -- 与服务器交互后
        table.insert(pai, self.modelData.FirstMatching);
        table.insert(pai, self.modelData.SecondMatching);
        table.insert(pai, self.modelData.ThirdMatching);
        self.player.Poker = self.pokersInDesc;
        self.player.Pai = pai;
        gamelogic.ComputeXiPai(self.player.Pai, self.player.Poker, self.player.XiPai, self.maskXiPai);
        -- strXiPai = self:GetStrXiPai();
        -- self.tableBiJiView:ShowXiPai(strXiPai);
        -- self:ClearXiPai();
        return;
    end

    for i = 1, 3 do
        -- local match = {};
        -- for j = 1,3 do
        -- local poker = {};
        -- poker.colour =pokers[j + (i-1)*3].Color;
        -- poker.number =tonumber(pokers[j + (i-1)*3].Number);
        -- poker.selected = false;
        -- poker.showed = false;
        -- table.insert(match,poker);
        -- end
        if (i == 1) then
            for j = 1, 3 do
                -- local poker = {};
                self.modelData.FirstMatching[j].colour = pokers[j +(i - 1) * 3].colour;
                self.modelData.FirstMatching[j].number = tonumber(pokers[j +(i - 1) * 3].number);
                self.modelData.FirstMatching[j].Color = pokers[j +(i - 1) * 3].colour;
                self.modelData.FirstMatching[j].Number = tonumber(pokers[j +(i - 1) * 3].number);
                self.modelData.FirstMatching[j].selected = false;
                self.modelData.FirstMatching[j].showed = false;
                -- self.modelData.FirstMatching[j].gameObject = self:GetGameObjectInHandFromColorAndNum(self.modelData.FirstMatching[j].colour, self.modelData.FirstMatching[j].number);
            end
        end
        if (i == 2) then
            for j = 1, 3 do
                -- local poker = {};
                self.modelData.SecondMatching[j].colour = pokers[j +(i - 1) * 3].colour;
                self.modelData.SecondMatching[j].number = tonumber(pokers[j +(i - 1) * 3].number);
                self.modelData.SecondMatching[j].Color = pokers[j +(i - 1) * 3].colour;
                self.modelData.SecondMatching[j].Number = tonumber(pokers[j +(i - 1) * 3].number);
                self.modelData.SecondMatching[j].selected = false;
                self.modelData.SecondMatching[j].showed = false;
                -- self.modelData.SecondMatching[j].gameObject = self:GetGameObjectInHandFromColorAndNum(self.modelData.SecondMatching[j].colour, self.modelData.SecondMatching[j].number);
            end
        end
        if (i == 3) then
            for j = 1, 3 do
                -- local poker = {};
                self.modelData.ThirdMatching[j].colour = pokers[j +(i - 1) * 3].colour;
                self.modelData.ThirdMatching[j].number = tonumber(pokers[j +(i - 1) * 3].number);
                self.modelData.ThirdMatching[j].Color = pokers[j +(i - 1) * 3].colour;
                self.modelData.ThirdMatching[j].Number = tonumber(pokers[j +(i - 1) * 3].number);
                self.modelData.ThirdMatching[j].selected = false;
                self.modelData.ThirdMatching[j].showed = false;
                -- self.modelData.ThirdMatching[j].gameObject = self:GetGameObjectInHandFromColorAndNum(self.modelData.ThirdMatching[j].colour, self.modelData.ThirdMatching[j].number);
            end
        end
    end
    table.insert(pai, self.modelData.FirstMatching);
    table.insert(pai, self.modelData.SecondMatching);
    table.insert(pai, self.modelData.ThirdMatching);
    -- log_table(pai)
    -- self:check_handpokers_in_oringinalPokers(self.modelData.FirstMatching)
    -- self:check_handpokers_in_oringinalPokers(self.modelData.SecondMatching)
    -- self:check_handpokers_in_oringinalPokers(self.modelData.ThirdMatching)
    self.tableBiJiView:setMatchingShow(1, self.modelData.FirstMatching, 0, false)
    self.tableBiJiView:setMatchingShow(2, self.modelData.SecondMatching, 0, false)
    self.tableBiJiView:setMatchingShow(3, self.modelData.ThirdMatching, 0, false)
    self.player.Poker = self.pokersInDesc;
    self.player.Pai = pai;
    -- 思源同学说可以删除了
    -- gamelogic.ComputeXiPai(self.player.Pai,self.player.Poker,self.player.XiPai,self.maskXiPai);
    -- strXiPai = self:GetStrXiPai();
    -- self:ClearXiPai();
end


function TableBiJiLogic:ReceiveStartRsp(data)
    if (not data.err_no or data.err_no == '0') then
        self.tableBiJiView:ShowDealTable();
        self.startBtn.transform.parent.gameObject:SetActive(false);
        self.tableBiJiView:SetAllDefaultImageActive(false);
    else
        if (tonumber(self.modelData.curTableData.roomInfo.roomHostID) ~= tonumber(self.modelData.roleData.userID)) then
            return;
        end
        local err_info = data.err_no;
        self.tableBiJiView:ShowNotReadyNotice(err_info);
    end
end

function TableBiJiLogic:ShowSurrenderConfirmWindow()
    self.tableBiJiView:SetSurrenderConfirmWindow(true);
end

function TableBiJiLogic:RefreshReadyStatus(data)
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        if (tonumber(seatInfo.playerId) == tonumber(data.pos_info.player_id)) then
            if (data.pos_info.is_ready == 1) then
                self.modelData.curTableData.roomInfo.seatInfoList[i].isReady = true;
            else
                self.modelData.curTableData.roomInfo.seatInfoList[i].isReady = false;
                if self.modelData.roleData.RoomType == 2 and self.tablePlayerNum > 1 then--快速组局 牌局中人数大于一个人时 三分钟未开始服务器发送取消准备 显示不带倒计时的准备按钮
                    self.tableBiJiView.buttonReady.gameObject:SetActive(true);
                end
                
                
            end
            self.tableBiJiView:refreshSeat(seatInfo);
        end
    end
end

function TableBiJiLogic:GetSeatPositionByID(playerID)
    for key,v in ipairs(self.modelData.curTableData.roomInfo.seatInfoList) do
        if(v.playerId == playerID) then
            local position = self.tableBiJiView:GetSeatPosition(v.localSeatIndex);
            return position;
        end 
    end
end

function TableBiJiLogic:RefreshConfirmStatus(data)
    local onFinishCount = 0
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        if (tonumber(seatInfo.playerId) == tonumber(data.userID)) then
            seatInfo.hasConfirmed = true
            if (seatInfo.localSeatIndex ~= 1) then
                self.tableBiJiView:SetMatchingActive(seatInfo.localSeatIndex, false);
                self.isPlayingAnimCount = self.isPlayingAnimCount + 1;
                local isAllConfirm = self:isAllConfirmed()
                self.tableBiJiView:playConfirmPokerAnimStep1(seatInfo.localSeatIndex, self.pokersNum, function(...)
                    self.tableBiJiView:playComfirmPokerAnimStep2(seatInfo.localSeatIndex, function(...)
                        self.isPlayingAnimCount = self.isPlayingAnimCount - 1;
                        if (self.isPlayingAnimCount == 0) then
                            local func = self.waitPlayingFinishFunsQueue:shift()
                            while func do
                                func()
                                func = self.waitPlayingFinishFunsQueue:shift()
                            end
                        end
                    end , isAllConfirm)
                end , isAllConfirm)
            end
        end
    end
end

function TableBiJiLogic:isAllConfirmed()
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        if (seatInfo.playerId and seatInfo.playerId ~= 0 and seatInfo.gameCount > 0 and not seatInfo.hasConfirmed) then
            return false
        end
    end
    return true
end


function TableBiJiLogic:ClearReadyStatus()
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        if (seatInfo.playerId ~= nil and seatInfo.playerId ~= 0) then

            if self.isJoinAfterStart == false then
                seatInfo.isReady = false;
                -- TODO XLQ ： 快速组局 中途进入的玩家点击准备后，收到第一局小结算时不需要重新准备
            end

            --  print(self.isJoinAfterStart,"-------------------------seatInfo.playerId:",seatInfo.playerId,seatInfo.isReady)
            self.tableBiJiView:refreshSeat(seatInfo);
        end
    end
end

function TableBiJiLogic:onClicCancelSurrenderBtn(obj)
    self.tableBiJiView:SetSurrenderConfirmWindow(false);
end


function TableBiJiLogic:Reconnect(data)
    self.tablePlayerNum = data.playercnt

    if (tonumber(data.reconnectStatus) == 1) then
        -- if(data.roomInfo.roomHostID == tonumber(self.modelData.roleData.userID)) then
        --     self.tableBiJiView:SetReadyBtn(0);
        -- end
        self:ResetReadyBtn(data)
        return;
    elseif (tonumber(data.reconnectStatus) == 2) then
        local reconnect = false
        self.tableModule:subscibe_time_event(2, false, 0):OnComplete(function(t)
            if not reconnect then
                local text = self.modelData.roleData.userID .. "|" .. self.modelData.curTableData.roomInfo.roomNum .. "|" .. self.modelData.curTableData.roomInfo.curRoundNum
                ModuleCache.Log.report_exception("比鸡客户端Reconnect出错",  text, "")
                ModuleCache.GameManager.logout()
            end
        end)
        self:ResetFastMatch();
        -- 服务器的原始数据
        self.oringinalServerPokers = data.pokers
        self:SetPokersInHand(data.pokers, true, true);
        -- self:SetOthersPokers();
        self:RevertTable(data)
        self:ClearMatchingTable();
        self:ClearXiPaiHint();
        -- self:SetDealBtnActive();
        self.tableBiJiView:HideReadyBtn();
        self.tableBiJiView:SetAllDefaultImageActive(false);
        self.tableBiJiView:SetRuleBtnActive(false);
        reconnect = true
    elseif (tonumber(data.reconnectStatus) == 3) then  --已经提交了排序
        self:RevertTable(data);
        self.tableBiJiView:HideReadyBtn();
        self.tableBiJiView:SetAllDefaultImageActive(false);
        self.tableBiJiView:ShowSelfResultBackTable();
        self.tableBiJiView:SetRuleBtnActive(false);
    elseif (tonumber(data.reconnectStatus) == 4) then
        local eventData = { };
        eventData.players = data.players;
        eventData.err_no = data.isJoinAfterStart;
        self.tableBiJiView:HideReadyBtn()
        local onFinishPlayStartCompareAnim = function()
            self.tableBiJiView:ShowResultTable();
            self:DealWithResult(eventData);
        end
        self.tableBiJiView:playStartCompareAnim(onFinishPlayStartCompareAnim)
        self.tableBiJiView:SetAllDefaultImageActive(false);
        self.tableBiJiView:SetRuleBtnActive(false);
    elseif (tonumber(data.reconnectStatus) == 5) then
        -- if(data.roomInfo.roomHostID ~=tonumber(self.modelData.roleData.userID)) then
        --    self.tableBiJiView:HideReadyBtn();
        if (data.roomInfo.curRoundNum ~= 0) then
            self.tableBiJiView:SetAllDefaultImageActive(false);
        end
        self.tableBiJiView:SetRuleBtnActive(false);
        -- end
    end
end

function TableBiJiLogic:OnClickInviteBtn(obj)

end

function TableBiJiLogic:onClickReadyBtn(isAutoReady)
    self.tableBiJiModel:request_ready(1, tonumber(self.modelData.roleData.userID));
    if (not isAutoReady and self.modelData.roleData.RoomType ~= 2) then
        self.tableBiJiView:SetReadyBtn(5)
    end
end

function TableBiJiLogic:refreshSelfReadyStatus(isReady)
    local seatsInfo = self.modelData.curTableData.roomInfo.seatInfoList;
    for i = 1, #seatsInfo do
        if (seatsInfo[i].playerId ~= nil) then
            if (seatsInfo[i].playerId == self.modelData.roleData.userID) then
                seatsInfo[i].isReady = isReady;
                self.tableBiJiView:refreshSeat(seatsInfo[i]);
            end
        end
    end
end

function TableBiJiLogic:SetBtnKickActive(localSeatIndex, isActive)

end

function TableBiJiLogic:onClickCancelBtn(obj)
    self.tableBiJiView:SetReadyCancel(false);
    self.tableBiJiModel:request_ready(0);
end

function TableBiJiLogic:RevertTable(data)
    local seatsInfo = data.seatInfo;
    for i = 1, #seatsInfo do
        local localSeatIndex = self.modelData.curTableData.roomInfo.seatInfoList[seatsInfo[i].seatNum].localSeatIndex;
        if (localSeatIndex ~= 1) then
            self.tableBiJiView:ShowReadyStatus(localSeatIndex, seatsInfo[i].isConfirmed, self.pokersNum);
        end
    end
end


function TableBiJiLogic:GetGameObjectInHandFromColorAndNum(Color, Number)
    for key, v in ipairs(self.handPokers) do
        if (v.colour == Color and v.number == Number) then
            return v.gameObject;
        end
    end
end

function TableBiJiLogic:DelayGettingReady()
    local onFinish = function()

        -- self:onClickReadyBtn()
        -- body
        -- 震动次数太多，先关闭
        -- ModuleCache.GameSDKInterface:ShakePhone(1000)
    end

    if self.tableModule.kickedTimeId then
        CSmartTimer:Kill(self.tableModule.kickedTimeId)
    end
    self.tableBiJiView:DelayToGetReady(onFinish);
end

function TableBiJiLogic:DealWithResult(data)
    local roomData = { };
    roomData.roomInfo = { };
    roomData.roomInfo.roomHostID = self.modelData.curTableData.roomInfo.roomHostID
    roomData.roomInfo.roomStatus = 0;
    self:ClearAllMatchingData()
    if (tonumber(data.err_no) == 0) then
        self.tableBiJiView:ShowResultTable();
    end
    if (tonumber(data.err_no) == 1) then
        self:SetReadyBtnType(roomData);
        self.isJoinAfterStart = true;
    end
    local players = data.players;
    self.resultData = players;
    self.isComparing = true;
    local selfSeatNum;
    local onFinishCount = 0
    local onFinish = function()
        onFinishCount = onFinishCount + 1
        if (onFinishCount ~= #players) then
            return
        end

        self:SetReadyBtnType(roomData);
        self.tableBiJiView:ShowReadyBtn()
        self:RefreshCurScore(data);

        if not self.roomInfo.ruleTable.offlineAutoReady then
            self:DelayGettingReady();
        end
    end
    local isAllSurrender = self:CheckIsAllSurrender(players);
    for key, v in ipairs(players) do
        if (tonumber(v.userID) == tonumber(self.modelData.roleData.userID)) then
            local tmpFunc = function()
                self.tableBiJiView:ShowSelfResult(v, onFinish, isAllSurrender);
                selfSeatNum = v.seatNum;
            end
            if (self.isPlayingAnimCount ~= 0) then
                self.waitPlayingFinishFunsQueue:push(tmpFunc)
            else
                tmpFunc()
            end
        end
    end

    for key, v in ipairs(players) do
        if (tonumber(v.userID) ~= tonumber(self.modelData.roleData.userID)) then
            for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
                if (tonumber(v.userID) == tonumber(self.modelData.curTableData.roomInfo.seatInfoList[i].playerId)) then
                    local tmpFunc = function()
                        self.tableBiJiView:ShowOthersResult(v, self.modelData.curTableData.roomInfo.seatInfoList[i].localSeatIndex, onFinish, isAllSurrender);
                    end
                    if (self.isPlayingAnimCount ~= 0) then
                        self.waitPlayingFinishFunsQueue:push(tmpFunc)
                    else
                        tmpFunc()
                    end
                end
            end
        end
    end

end

function TableBiJiLogic:CheckIsAllSurrender(players)
    local isAllSurrender = true;
    for key, v in ipairs(players) do
        if (not v.isSurrender) then
            isAllSurrender = false;
            return isAllSurrender;
        end
    end
    return isAllSurrender;
end

function TableBiJiLogic:RefreshEnterRoomStatus(data)
    self.tablePlayerNum = data.playercnt
    -- 会收到其他玩家的中途进入包，其他玩家在没准备的情况下中途进入也会影响自己的按钮
    local my_seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[self.modelData.roleData.myRoomSeatInfo.SeatID];
    if self.modelData.roleData.userID == data.seatInfo.userID or(my_seatInfo and not my_seatInfo.isReady and self.modelData.curTableData.roomInfo.curRoundNum == 0) then
        self:ResetReadyBtn()
    end

    print("-------RefreshEnterRoomStatus-----------", self.tablePlayerNum)
    local seatInfo = { };
    seatInfo.seatIndex = data.seatInfo.seatNum;
    seatInfo.playerId = tostring(data.seatInfo.userID)
    seatInfo.gameCount = data.seatInfo.gameCount or 0
    self.tableModule:addSeatInfo2ChatCurTableData(seatInfo)
    if (tonumber(data.seatInfo.userID) == tonumber(self.modelData.curTableData.roomInfo.roomHostID)) then
        seatInfo.isCreator = true;
    else
        seatInfo.isCreator = false;
    end
    if (data.seatInfo.readyStatus == 1) then
        seatInfo.isReady = true;
    else
        seatInfo.isReady = false;
    end
    seatInfo.hasConfirmed = data.isConfirmed;
    seatInfo.isTemporaryLeave = data.isTemporaryLeave;
    seatInfo.canBeKicked = false;
    print("--------------------",tonumber(self.modelData.roleData.userID),self.modelData.curTableData.roomInfo.roomHostID,seatInfo.playerId)
    if(tonumber(self.modelData.roleData.userID) == tonumber(self.modelData.curTableData.roomInfo.roomHostID)) then
        if(tonumber(seatInfo.playerId) ~=tonumber(self.modelData.curTableData.roomInfo.roomHostID)  and seatInfo.gameCount == 0) then
            seatInfo.canBeKicked = true;
        end
    end    
    seatInfo.curScore = data.seatInfo.curScore;
    -- 玩家房间内积分
    -- seatInfo.winTimes = (seatInfo.isSeated and remoteSeatInfo.winTimes) or 0             --玩家房间内赢得次数
    -- seatInfo.isOffline = (not seatInfo.isSeated) or remoteSeatInfo.isOffline ~= 0      --玩家是否掉线

    -- seatInfo.isDoneComputeNiu = false			            --玩家是否已经完成选牛
    -- seatInfo.isCalculatedResult = false                     --是否已经结算
    seatInfo.roomInfo = data.roomInfo;
    seatInfo.localSeatIndex = self.tableBiJiHelper:getLocalIndexFromRemoteSeatIndex(seatInfo.seatIndex, self.modelData.curTableData.roomInfo.mySeatInfo.seatIndex, #self.modelData.curTableData.roomInfo.seatInfoList)
    self.modelData.curTableData.roomInfo.seatInfoList[seatInfo.seatIndex] = seatInfo;
    -- table.insert(self.modelData.curTableData.roomInfo.seatInfoList,seatInfo);
    -- self.modelData.curTableData.roomInfo.seatInfoList = seatsInfo;
    self:resetSeatHolderArray(#self.modelData.curTableData.roomInfo.seatInfoList);
    self.tableBiJiView:refreshSeat(seatInfo);
end

function TableBiJiLogic:onClicPoer(obj)
    local x = 1;
end

--- 点击配牌窗口
--- @param index 配牌选项
--- @param isFastMatching 是否为快速配牌，也就是推荐配牌
function TableBiJiLogic:onClickMatching(index, isFastMatching)
    local fullIndex = 0;
    if (#self.modelData.FirstMatching ~= 0) then
        fullIndex = 1;
    elseif (#self.modelData.SecondMatching ~= 0) then
        fullIndex = 2;
    elseif (#self.modelData.ThirdMatching ~= 0) then
        fullIndex = 3;
    end

    if #self.modelData.selectList ~= 3 then
        -- body
        return;
    end

    if (index == 1) then
        if (#self.modelData.FirstMatching ~= 0) then
            return;
        end
        for key, v in ipairs(self.modelData.selectList) do
            v.showed = false;
            v.selected = false;
            local poker = { };
            poker.number = v.number;
            poker.Number = v.Number;
            poker.colour = v.colour;
            poker.Color = v.Color;
            poker.showed = v.showed;
            poker.selected = v.selected;
            poker.gameObject = v.gameObject;
            poker.image = v.image;
            table.insert(self.modelData.FirstMatching, poker);
            for k, value in ipairs(self.handPokers) do
                if (v.number == value.number and v.colour == value.colour) then
                    table.remove(self.handPokers, k);
                end
            end
            -- self.tableBiJiView:setInHandPokerActive(v, false);
        end
        -- print("++++++++++++++++"..#self.handPokers)
        -- print_table(self.handPokers);
        -- print_table(self.modelData.selectList)
        self:sortPoker(self.modelData.FirstMatching, false);
        self:SetPokersInHand(self.handPokers, false, self.sortSequence);
        if (fullIndex == 0) then
            -- self:check_handpokers_in_oringinalPokers(self.modelData.FirstMatching);
            self.tableBiJiView:setMatchingShow(index, self.modelData.FirstMatching, 0, true);
        else
            -- self:check_handpokers_in_oringinalPokers(self.modelData.FirstMatching);
            self.tableBiJiView:setMatchingShow(index, self.modelData.FirstMatching, 0, false);
        end
        self.modelData.selectList = { };
        self.tableBiJiView:SetResetBtnActive(1, true);
        self.tableBiJiView:SetNoPokersImageActive(1, false);
        self.tableBiJiView:ShowMatchingShow(1);
        local res, value = gamelogic.ComputePaixing(self.modelData.FirstMatching, self.mask)
        self.tableBiJiView:SetPokerTypeHint(1, res);
    elseif (index == 2) then
        -- if not self.modelData.FirstMatching or #self.modelData.FirstMatching ~= 3 then
        -- return;
        -- end
        if (#self.modelData.SecondMatching ~= 0) then
            return;
        end
        for key, v in ipairs(self.modelData.selectList) do
            v.showed = false;
            v.selected = false;
            local poker = { };
            poker.number = v.number;
            poker.Number = v.Number;
            poker.colour = v.colour;
            poker.Color = v.Color;
            poker.showed = v.showed;
            poker.selected = v.selected;
            poker.gameObject = v.gameObject;
            poker.image = v.image;
            table.insert(self.modelData.SecondMatching, poker);
            for k, value in ipairs(self.handPokers) do
                if (v.number == value.number and v.colour == value.colour) then
                    table.remove(self.handPokers, k);
                end
            end
        end

        self:sortPoker(self.modelData.SecondMatching, false);
        self:SetPokersInHand(self.handPokers, false, self.sortSequence);
        if (fullIndex == 0) then
            -- self:check_handpokers_in_oringinalPokers(self.modelData.SecondMatching);
            self.tableBiJiView:setMatchingShow(index, self.modelData.SecondMatching, 0, true);
        else
            -- self:check_handpokers_in_oringinalPokers(self.modelData.SecondMatching);
            self.tableBiJiView:setMatchingShow(index, self.modelData.SecondMatching, 0, false);
        end
        self.modelData.selectList = { };
        self.tableBiJiView:SetResetBtnActive(2, true);
        self.tableBiJiView:SetNoPokersImageActive(2, false);
        self.tableBiJiView:ShowMatchingShow(2);
        local res, value = gamelogic.ComputePaixing(self.modelData.SecondMatching, self.mask)
        self.tableBiJiView:SetPokerTypeHint(2, res);
    elseif (index == 3) then
        if (#self.modelData.ThirdMatching ~= 0) then
            return;
        end
        for key, v in ipairs(self.modelData.selectList) do
            v.showed = false;
            v.selected = false;
            local poker = { };
            poker.number = v.number;
            poker.Number = v.Number;
            poker.colour = v.colour;
            poker.Color = v.Color;
            poker.showed = v.showed;
            poker.selected = v.selected;
            poker.gameObject = v.gameObject;
            poker.image = v.image;
            table.insert(self.modelData.ThirdMatching, poker);
            for k, value in ipairs(self.handPokers) do
                if (v.number == value.number and v.colour == value.colour) then
                    table.remove(self.handPokers, k);
                end
            end
        end
        self:sortPoker(self.modelData.ThirdMatching, false);
        self:SetPokersInHand(self.handPokers, false, self.sortSequence);
        if (fullIndex == 0) then
            -- self:check_handpokers_in_oringinalPokers(self.modelData.ThirdMatching);
            self.tableBiJiView:setMatchingShow(index, self.modelData.ThirdMatching, 0, true);
        else
            -- self:check_handpokers_in_oringinalPokers(self.modelData.ThirdMatching);
            self.tableBiJiView:setMatchingShow(index, self.modelData.ThirdMatching, 0, false);
        end
        self.modelData.selectList = { };
        self.tableBiJiView:SetResetBtnActive(3, true);
        self.tableBiJiView:SetNoPokersImageActive(3, false);
        self.tableBiJiView:ShowMatchingShow(3);
        local res, value = gamelogic.ComputePaixing(self.modelData.ThirdMatching, self.mask)
        self.tableBiJiView:SetPokerTypeHint(3, res);
    end

    -- 不是快速配牌
    if (not isFastMatching and(#self.modelData.FirstMatching + #self.modelData.SecondMatching + #self.modelData.ThirdMatching) == 6 and self.pokersNum == 9) then
        -- 出现大BUG了，因为最后的手牌不是3张了
        if self.handPokers and #self.handPokers ~= 3 then
            if self.modelData.bullfightClient.clientConnected then
                TableManagerPoker:heartbeat_timeout_reconnect_game_server()
                return
            end
        end
        local onFinish = function()
            -- self:LocalCheckSequence();
        end
        if (#self.modelData.FirstMatching == 0) then
            -- self.modelData.FirstMatching = self.handPokers;
            local count = 0;
            for key, v in ipairs(self.handPokers) do
                v.showed = false;
                v.selected = false;
                local poker = { };
                poker.number = v.number;
                poker.Number = v.Number;
                poker.colour = v.colour;
                poker.Color = v.Color;
                poker.showed = v.showed;
                poker.selected = v.selected;
                poker.gameObject = v.gameObject;
                poker.image = v.image;
                table.insert(self.modelData.FirstMatching, poker);
                local _index = tonumber(v.gameObject.name) + 1;
                self.tableBiJiView:PlayAnimHandToMatch(_index, 1, count + 1, onFinish);
                count = count + 1;
                -- self.tableBiJiView:setInHandPokerActive(v, false);
            end
            self:sortPoker(self.modelData.FirstMatching, false);
            -- self:check_handpokers_in_oringinalPokers(self.modelData.FirstMatching);
            self.tableBiJiView:setMatchingShow(1, self.modelData.FirstMatching, 0, false);
            self.tableBiJiView:SetResetBtnActive(1, true);
            self.tableBiJiView:SetNoPokersImageActive(1, false);
            self.tableBiJiView:ShowMatchingShow(1);
            local res, value = gamelogic.ComputePaixing(self.modelData.FirstMatching, self.mask)
            self.tableBiJiView:SetPokerTypeHint(1, res);
        end
        if (#self.modelData.SecondMatching == 0) then
            -- self.modelData.SecondMatching = self.handPokers;
            local count = 0;
            for key, v in ipairs(self.handPokers) do
                v.showed = false;
                v.selected = false;
                local poker = { };
                poker.number = v.number;
                poker.Number = v.Number;
                poker.colour = v.colour;
                poker.Color = v.Color;
                poker.showed = v.showed;
                poker.selected = v.selected;
                poker.gameObject = v.gameObject;
                poker.image = v.image;
                table.insert(self.modelData.SecondMatching, poker);
                local _index = tonumber(v.gameObject.name) + 1;
                self.tableBiJiView:PlayAnimHandToMatch(_index, 2, count + 1, onFinish);
                count = count + 1;
                -- self.tableBiJiView:setInHandPokerActive(v, false);
            end
            self:sortPoker(self.modelData.SecondMatching, false);
            -- self:check_handpokers_in_oringinalPokers(self.modelData.SecondMatching);
            self.tableBiJiView:setMatchingShow(2, self.modelData.SecondMatching, 0, false);
            self.tableBiJiView:SetResetBtnActive(2, true);
            self.tableBiJiView:SetNoPokersImageActive(2, false);
            self.tableBiJiView:ShowMatchingShow(2);
            local res, value = gamelogic.ComputePaixing(self.modelData.SecondMatching, self.mask)
            self.tableBiJiView:SetPokerTypeHint(2, res);
        end
        if (#self.modelData.ThirdMatching == 0) then
            -- self.modelData.ThirdMatching = self.handPokers;
            local count = 0;
            for key, v in ipairs(self.handPokers) do
                v.showed = false;
                v.selected = false;
                local poker = { };
                poker.number = v.number;
                poker.Number = v.Number;
                poker.colour = v.colour;
                poker.Color = v.Color;
                poker.showed = v.showed;
                poker.selected = v.selected;
                poker.gameObject = v.gameObject;
                poker.image = v.image;
                table.insert(self.modelData.ThirdMatching, poker);
                local _index = tonumber(v.gameObject.name) + 1;
                self.tableBiJiView:PlayAnimHandToMatch(_index, 3, count + 1, onFinish);
                count = count + 1;
                -- self.tableBiJiView:setInHandPokerActive(v, false);
            end
            self:sortPoker(self.modelData.ThirdMatching, false);
            -- self:check_handpokers_in_oringinalPokers(self.modelData.ThirdMatching);
            self.tableBiJiView:setMatchingShow(3, self.modelData.ThirdMatching, 0, false);
            self.tableBiJiView:SetResetBtnActive(3, true);
            self.tableBiJiView:SetNoPokersImageActive(3, false);
            self.tableBiJiView:ShowMatchingShow(3);
            local res, value = gamelogic.ComputePaixing(self.modelData.ThirdMatching, self.mask)
            self.tableBiJiView:SetPokerTypeHint(3, res);
        end
        self.handPokers = { };
    end




    if (self.modelData.FirstMatching == nil or self.modelData.SecondMatching == nil or self.modelData.ThirdMatching == nil) then
        return;
    end

    if (#self.modelData.FirstMatching == 3 and #self.modelData.SecondMatching == 3 and #self.modelData.ThirdMatching == 3) then
        local pokers = { };
        for key, v in ipairs(self.modelData.FirstMatching) do
            local poker = { };
            poker.Color = v.colour;
            poker.Number = v.number;
            table.insert(pokers, poker);
        end
        for key, v in ipairs(self.modelData.SecondMatching) do
            local poker = { };
            poker.Color = v.colour;
            poker.Number = v.number;
            table.insert(pokers, poker);
        end
        for key, v in ipairs(self.modelData.ThirdMatching) do
            local poker = { };
            poker.Color = v.colour;
            poker.Number = v.number;
            table.insert(pokers, poker);
        end
        local curMatching;
        for i = 1, 3 do
            if (i == 1) then
                curMatching = self.modelData.FirstMatching
            elseif (i == 2) then
                curMatching = self.modelData.SecondMatching
            elseif (i == 3) then
                curMatching = self.modelData.ThirdMatching
            end
            local res, value = gamelogic.ComputePaixing(curMatching, self.mask)
            self.tableBiJiView:SetPokerTypeHint(i, res);
        end
        local isNeedToChange = self:LocalCheckSequence();
        if (isNeedToChange) then
            self.tableModule:subscibe_time_event(3, false, 0):OnComplete( function(t)
                if (#self.handPokers > 0) then
                    return;
                end
                self.tableBiJiView:SetExchangeHintActive(true);
            end )
        else
            self.tableBiJiView:SetExchangeHintActive(true);
        end;
        -- 0.1s后再显示重制和确定按钮
        self.tableBiJiView:SetResetAllActive(true);
        -- self.tableModule:subscibe_time_event(0.2, false, 0):OnComplete(function(t)
        -- self.tableBiJiView:SetResetAllActive(true);
        -- end)
        if (self.pokersNum == 10) then
            if (#self.handPokers ~= 1) then
                print_table(self.handPokers);
                print("手牌数出错");
                return;
            end
            self.tableBiJiView:Set10thPokersActive(true);
            local poker = { }
            self.handPokers[1].showed = false;
            self.handPokers[1].selected = false;
            local poker = { };
            poker.number = self.handPokers[1].number;
            poker.Number = self.handPokers[1].Number;
            poker.colour = self.handPokers[1].colour;
            poker.Color = self.handPokers[1].Color;
            poker.showed = self.handPokers[1].showed;
            poker.selected = self.handPokers[1].selected;
            poker.gameObject = self.handPokers[1].gameObject;
            poker.image = self.handPokers[1].image;
            self.handPokers = { };
            self.tenthPoker = poker;
            self.tableBiJiView:Show10thPokerImage(self.tenthPoker);
            self:SetPokersInHand(self.handPokers, false);
        end
        -- self.tableBiJiModel:request_complete_match(pokers , self.modelData.roleData.userID);
    end
    self:SetDealBtnActive();
end
-- 大小排序，true为大到小 flagSequence为false时是按大小排序，为true时按照花色排序
function TableBiJiLogic:sortPoker(poker, flag, flagSequence)
    if poker and #poker == 0 then
        return
    end
    self:check_handpokers_in_oringinalPokers(poker);
    -- log_table(poker)
    for i = 1, #poker - 1 do
        local index = i
        for j = i, #poker do
            local num1, num2
            if not flagSequence then
                num1 = poker[j].Number * 4 + poker[j].Color
                num2 = poker[index].Number * 4 + poker[index].Color
            else
                if poker[j].Number == 15 then
                    num1 = poker[j].Number +(poker[j].Color + 4) * 14
                else
                    num1 = poker[j].Number + poker[j].Color * 14
                end
                if poker[index].Number == 15 then
                    num2 = poker[index].Number +(poker[index].Color + 4) * 14
                else
                    num2 = poker[index].Number + poker[index].Color * 14
                end
            end
            if (flag and num1 > num2) or(not flag and num1 < num2) then
                index = j
            end
        end
        local temp = poker[index]
        poker[index] = poker[i]
        poker[i] = temp
    end
    self:check_handpokers_in_oringinalPokers(poker)
end

function TableBiJiLogic:onClickOrderBtn(isSequence)
    self.sortSequence = isSequence;
    self:SetPokersInHand(self.handPokers, false, self.sortSequence);
    self.tableBiJiView:SetOrderSequenceActive(isSequence);
end
-- 点击对子，顺子，同花等按钮
function TableBiJiLogic:onClickDealBtn(btnname)
    local _typepokers = self:setTypePokers(btnname);
    if not _typepokers or #_typepokers ~= 3 then
        return;
    end

    if #self.modelData.selectList <= 3 then
        for key, v in ipairs(self.modelData.selectList) do
            v.selected = false;
            self.tableBiJiView:refreshCardSelect(v, false);
        end
    end
    self.modelData.selectList = { };
    local _pokers = self.handPokers;
    for key, v in ipairs(_typepokers) do
        for _key1, v1 in ipairs(_pokers) do
            if v.number == v1.number and v.colour == v1.colour then
                v1.selected = true;
                table.insert(self.modelData.selectList, v1);
                self.tableBiJiView:refreshCardSelect(v1, true);
                break;
            end
        end
    end

end

function TableBiJiLogic:ResetFastMatch()
    self.fastMatches = nil;
end

function TableBiJiLogic:SetFastMatching()
    for i = 1, 3 do
        if (self.fastMatches[i] ~= nil) then
            local matches = { }
            for j = 1, 3 do
                table.insert(matches, self.fastMatches[i][j].px);
            end
            self.tableBiJiView:SetFastMatchingHint(i, matches)
        end
    end
end

function TableBiJiLogic:onClickSuggestionBtn(index)
    -- self:onClickResetAllBtn();
    self.modelData.FirstMatching = { }
    self.modelData.SecondMatching = { }
    self.modelData.ThirdMatching = { }
    local pokers = self.oringinalPokers;
    -- print_table(self.fastMatches);
    for i = 1, 3 do
        self.modelData.selectList = { }
        for j = 1, 3 do
            local poker = { };
            for key, v in ipairs(pokers) do
                if (self.fastMatches[index][i][j].Color == v.Color and self.fastMatches[index][i][j].Number == v.Number) then
                    poker = v;
                    -- print_table(poker);
                end
            end
            table.insert(self.modelData.selectList, poker);
        end
        self:onClickMatching(i, true);
    end
    self:SetPokersInHand( { }, false);
    self.tableBiJiView:SetSelectedSuggestion(index);
    if (#self.exchangePoker > 0) then
        local oldIndexMatch = self.exchangePoker[1].indexMatch;
        local oldIndex = self.exchangePoker[1].index;
        self.tableBiJiView:SetExchangePokerColor(oldIndexMatch, oldIndex, false)
        self.exchangePoker = { };
    end
end

-- 设置整个牌的界面显示
function TableBiJiLogic:SetDealBtnActive(isFirst)
    local _restpokers = { };
    local pokers = { };
    -- 手上的牌
    for key, v in ipairs(self.handPokers) do
        local poker = { };
        poker.Number = v.number;
        poker.Color = tonumber(v.colour);
        poker.number = v.number;
        poker.colour = tonumber(v.colour);
        table.insert(pokers, poker);
    end
    local _pokers = pokers;
    self:sortPoker(_pokers, false);
    for key, v in ipairs(_pokers) do
        if (not v.showed) then
            table.insert(_restpokers, v);
        end
    end
    if (true) then
        self.restcount = #_restpokers;
        self.btnname = "";
        combinations = { };
        local gpos = { }
        gamelogic.CombinePoker(_restpokers, combinations, gpos);
        _paixing = { };
        for i = 1, 5 do
            _paixing[i] = { }
            -- 1,对子;2,顺子;3,同花;4,同花顺;5,三条
        end
        local gpai = { }
        for i = 1, #combinations do
            local res, value = gamelogic.ComputePaixing(combinations[i], self.mask)
            combinations[i].px = res
            combinations[i].value = value
            gpai[gpos[i]] = i
            if res ~= 1 then
                local temp
                if res == 5 then
                    -- 同花顺也属于同花和顺子
                    for j = 1, 3 do
                        temp = #_paixing[res - j] + 1
                        _paixing[res - j][temp] = combinations[i]
                    end
                else
                    temp = #_paixing[res - 1] + 1
                    _paixing[res - 1][temp] = combinations[i]
                end
            end
        end
        local xipaiscore
        if self.roomInfo.ruleTable.gameType == 0 then
            xipaiscore = { 12, 3, 3, 6, 12, 6, 12, 12, 24, 12, 12, 6 }
            if self.extraScoreTypes == 15 then
                xipaiscore = { 12, 3, 3, 6, 12, 6, 12, 12, 24, 12, 12, 6 }
            elseif self.extraScoreTypes == 16 then
                xipaiscore = { 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 1, 1 }
            end
        else
            xipaiscore = { 0, 0, 0, 0, 0, 0, 0, 12, 24, 0, 0, 0 }
            if self.extraScoreTypes == 15 then
                xipaiscore = { 0, 0, 0, 0, 0, 0, 0, 12, 24, 0, 0, 0 }
            elseif self.extraScoreTypes == 16 then
                xipaiscore = { 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0 }
            end
        end
        if (self.fastMatches == nil and #_pokers == self.pokersNum) then
            self.fastMatches = gamelogic.GenerateHBT(gpai, combinations, _pokers, self.mask, xipaiscore)
        end
        for i = 1, 5 do
            gamelogic.SortPai(_paixing[i], true)
        end

        -- 对子
        if (#_paixing[1] == 0) then
            self.tableBiJiView:SetDealBtnActive(1, false);
        else
            self.tableBiJiView:SetDealBtnActive(1, true);
        end

        -- 顺子
        if (#_paixing[2] == 0) then
            self.tableBiJiView:SetDealBtnActive(2, false);
        else
            self.tableBiJiView:SetDealBtnActive(2, true);
        end
        if (#_paixing[3] == 0) then
            self.tableBiJiView:SetDealBtnActive(3, false);
        else
            self.tableBiJiView:SetDealBtnActive(3, true);
        end
        if (#_paixing[4] == 0) then
            self.tableBiJiView:SetDealBtnActive(4, false);
        else
            self.tableBiJiView:SetDealBtnActive(4, true);
        end
        if (#_paixing[5] == 0) then
            self.tableBiJiView:SetDealBtnActive(5, false);
        else
            self.tableBiJiView:SetDealBtnActive(5, true);
        end
    end
    -- local _typepokers = self:setTypePokers(btnname);
end

function TableBiJiLogic:ClearXiPaiHint()
    self.tableBiJiView:ShowXiPai("");
end

function TableBiJiLogic:ClearMatchingTable()
    self.modelData.FirstMatching = { };
    self.modelData.SecondMatching = { };
    self.modelData.ThirdMatching = { };
    for i = 1, 3 do
        self.tableBiJiView:ClearMatchingShow(i);
        self.tableBiJiView:SetResetBtnActive(i, false);
        self.tableBiJiView:SetNoPokersImageActive(i, true);
        self.tableBiJiView:ClearPaiXingHint(i);
    end
    self.tableBiJiView:ClearFastMatchingHint();
    self.tableBiJiView:ClearSelectedSuggestion();
    self.tableBiJiView:SetGameLogoActive(0, false);
    self.tableBiJiView:SetErrHintActive(false);
    self.tableBiJiView:SetExchangeHintActive(false);
    self.tableBiJiView:Set10thPokersActive(false);
end

function TableBiJiLogic:ShowReadyTable()
    self.tableBiJiView:ShowReadyBtn();
end

function TableBiJiLogic:setTestPokers()
    math.randomseed(os.time())
    local type = math.random(0, 1)
    if (type < 0.5) then
        self:onClickSuggestionBtn(1);
    else
        for i = 1, 2 do
            local randomList = self:getRandomList(9 -(i - 1) * 3);
            for j = 1, 3 do
                local index = randomList[j];
                local pokerGameObject = self.tableBiJiView.inHandPokers[index]["gameobject"].transform:GetChild(0).gameObject
                self:on_select_poker(pokerGameObject);
            end
            self:onClickMatching(i, false);
        end
    end
end

function TableBiJiLogic:getRandomList(length)
    local temp = { };
    local chosen_list = { };
    for i = 1, length do
        table.insert(chosen_list, i)
    end
    for i = 1, length do
        local r = math.random(1, #chosen_list);
        temp[i] = chosen_list[r];
        table.remove(chosen_list, r);
    end
    return temp
end


--- SetPokersInHand
--- @param handPokers
--- @param isFirst true代表新发牌
--- @param isSequence 为false时是按大小排序，为true时按照花色排序
function TableBiJiLogic:SetPokersInHand(handPokers, isFirst, isSequence)
    local firstSetPokersInHand = false
    if (isFirst) then
        self.tableModule:subscibe_time_event(2, false, 0):OnComplete(function(t)
            if not firstSetPokersInHand then
                local text = self.modelData.roleData.userID .. "|" .. self.modelData.curTableData.roomInfo.roomNum .. "|" .. self.modelData.curTableData.roomInfo.curRoundNum
                ModuleCache.Log.report_exception("比鸡客户端SetPokersInHand出错",  text, "")
                ModuleCache.GameManager.logout()
            end
        end)
    end
    self:check_handpokers_in_oringinalPokers(handPokers)
    self.tableBiJiView:SetDealWindowActive(true);
    if (self.modelData ~= nil) then
        -- self.modelData.curTableData = {};
        self.modelData.selectList = { };
    end
    self.handPokers = { };
    if (isFirst) then
        self:ClearAllMatchingData()
        self.oringinalPokers = { };
    end
    for j = 1, #handPokers do
        local poker = { }
        -- local tmp = string.split(remoteSeatInfo.pokers[i], "-")
        poker.colour = handPokers[j].Color;
        poker.number = tonumber(handPokers[j].Number);
        poker.Color = handPokers[j].Color;
        poker.Number = tonumber(handPokers[j].Number);
        poker.selected = false;
        poker.showed = false;
        table.insert(self.handPokers, poker);
        if (isFirst) then
            table.insert(self.oringinalPokers, poker);
        end
    end
    self:sortPoker(self.handPokers, true, isSequence);
    if (isFirst) then
        if ModuleCache.GameManager.isEditor then
            --self:TestAllPokersArrange(self.oringinalPokers)
        end
        self.pokersInDesc = { };
        local duration = 0.25;
        local onFinish = function()
            self:SetDealBtnActive();
            self:SetFastMatching();
            firstSetPokersInHand = true
            -- if (ModuleCache.GameManager.isEditor and ModuleCache.GameManager.developmentMode) then
            -- self:setTestPokers();
            -- local reset = math.random( 0,2 );
            -- if(reset > 1) then
            -- self:onClickResetAllBtnNew();
            -- self:setTestPokers();
            -- end
            -- local time = math.random(0,3)
            -- self.tableModule:subscibe_time_event(time, false, 0):OnComplete(function(t)
            -- self:onClickSubmitConfirmBtn()
            -- end)
            -- end
        end
        self:sortPoker(self.oringinalPokers, true, true);
        for key, v in ipairs(self.oringinalPokers) do
            table.insert(self.pokersInDesc, v);
        end
        self:sortPoker(self.pokersInDesc, false);
        self.mask = gamelogic.PokerToMask(self.pokersInDesc);
        self.tableBiJiView:SetSelfImageActive(false);
        self:check_handpokers_in_oringinalPokers(self.oringinalPokers)
        self.tableBiJiView:refreshPokersInHand(self.oringinalPokers, isFirst, onFinish);

        if not self.roomInfo.ruleTable.offlineAutoReady then
            self.tableBiJiView:SetClockActive(true);
            self.tableBiJiView:StartClockCountdown(60);
        end

        self.tableBiJiView:SetOrderSequenceActive(true);
    else
        self:check_handpokers_in_oringinalPokers(self.handPokers)
        self.tableBiJiView:refreshPokersInHand(self.handPokers, isFirst);
    end
    local _index = 1;
    for key, v in ipairs(self.handPokers) do
        v.gameObject = self.tableBiJiView.inHandPokers[_index]["gameobject"];
        v.image = self.tableBiJiView.inHandPokers[_index]["image"];
        self.tableBiJiView:refreshCardSelect(v);
        _index = _index + 1;
        if (isFirst) then
            self.isJoinAfterStart = false;
        end
    end
    -- self.handPokers = {};
    -- for key, v in ipairs(self.inHandPokerList) do
    -- table.insert(self.handPokers, v);
    -- end

    -- self:check_handpokers_in_oringinalPokers(self.handPokers)
    if (not isFirst) then
        self:SetDealBtnActive();
    end
    -- self.tableBiJiView:refreshSeat(seatList[i]);
end

function TableBiJiLogic:set_oringinalServerPokers(pokers)
    self.oringinalServerPokers = { }
    self.isComparing = false;
    for i = 1, #pokers do
        self.oringinalServerPokers[i] = { }
        self.oringinalServerPokers[i].Color = pokers[i].Color
        self.oringinalServerPokers[i].Number = pokers[i].Number
    end
end

-- 新增牌的检测，因为遇到过有重复拍的问题
function TableBiJiLogic:check_handpokers_in_oringinalPokers(needCheckPokers)
    if not needCheckPokers then
        print("needCheckPokers is nil")
        return
    end

    local inOringinalPokers = true
    -- self.handPokers[10] = {}
    -- needCheckPokers[9].Number = needCheckPokers[1].Number
    -- needCheckPokers[9].Color = needCheckPokers[1].Color
    if #needCheckPokers < 11 then
        -- self.handPokers[1].Number = 12
        -- self.handPokers[1].Color = 1
        local handPokersCount = { }
        local keyTmp = nil
        for i = 1, #needCheckPokers do
            -- 需要过滤重复的牌
            keyTmp = needCheckPokers[i].Number .. "_" .. needCheckPokers[i].Color
            handPokersCount[keyTmp] =(handPokersCount[keyTmp] or 0) + 1
            if handPokersCount[keyTmp] > 1 then
                inOringinalPokers = false
                break
            end

            for j = 1, #self.oringinalServerPokers do
                if needCheckPokers[i].Color == self.oringinalServerPokers[j].Color and needCheckPokers[i].Number == self.oringinalServerPokers[j].Number then
                    inOringinalPokers = true
                    break
                else
                    inOringinalPokers = false
                end
            end
        end
    else
        inOringinalPokers = false
    end


    if #needCheckPokers > 0 and not inOringinalPokers then
        local userID = self.modelData.roleData.userID
        if ModuleCache.GameManager.isEditor then
            ModuleCache.GameSDKInterface:PauseEditorApplication(true)
        else
            ModuleCache.GameManager.logout()
        end
        ModuleCache.Log.report_exception("比鸡牌型数据错误，触发断线重连",  userID .. ": " .. ModuleCache.Log.print_table(needCheckPokers), "")
        if self.oringinalServerPokers then
            log_table(self.oringinalServerPokers)
            log_table(needCheckPokers)
        end
        ---- 故意设置错误代码好上报Bugly
        --local test = kjkd > 0
    end
end

function TableBiJiLogic:onClickStartBtn(obj)
    self.startBtn = obj;
    self.tableBiJiModel:request_start();
    self.tableBiJiView:CloseResultTable();
    -- self.tableBiJiView:ShowDealTable();
    -- obj.transform.parent.gameObject:SetActive(false);
end

-- 根据点击提示按钮设置牌型提示
function TableBiJiLogic:setTypePokers(name)
    local _restpokers = { };
    local _pokers = self.handPokers;
    for key, v in ipairs(_pokers) do
        if (not v.showed) then
            table.insert(_restpokers, v);
        end
    end
    if (self.restcount ~= #_restpokers) then
        self.restcount = #_restpokers;
        self.btnname = "";
        combinations = { };
        local gpos = { }
        gamelogic.CombinePoker(_restpokers, combinations, gpos);
        _paixing = { };
        for i = 1, 5 do
            _paixing[i] = { }
            -- 1,对子;2,顺子;3,同花;4,同花顺;5,三条
        end
        local gpai = { }
        for i = 1, #combinations do
            local res, value = gamelogic.ComputePaixing(combinations[i], self.mask)
            combinations[i].px = res
            combinations[i].value = value
            gpai[gpos[i]] = i
            if res ~= 1 then
                local temp
                if res == 5 then
                    -- 同花顺也属于同花和顺子
                    for j = 1, 3 do
                        temp = #_paixing[res - j] + 1
                        _paixing[res - j][temp] = combinations[i]
                    end
                else
                    temp = #_paixing[res - 1] + 1
                    _paixing[res - 1][temp] = combinations[i]
                end
            end
        end
        for i = 1, 5 do
            gamelogic.SortPai(_paixing[i], true)
        end
    end
    if self.btnname ~= name then
        self.selectindex = 1;
        self.btnname = name;
    else
        self.selectindex = self.selectindex + 1;
    end

    if name == "pair" then
        local _count = #_paixing[1];
        if (_count ~= 0) then
            if self.selectindex > _count then
                self.selectindex = 1;
            end
            return _paixing[1][self.selectindex];
        else
            return nil;
        end
    elseif name == "straight" then
        local _count = #_paixing[2];
        if (_count ~= 0) then
            if self.selectindex > _count then
                self.selectindex = 1;
            end
            return _paixing[2][self.selectindex];

        else
            return nil;
        end
    elseif name == "flush" then
        local _count = #_paixing[3];
        if (_count ~= 0) then
            if self.selectindex > _count then
                self.selectindex = 1;
            end
            return _paixing[3][self.selectindex];

        else
            return nil;
        end
    elseif name == "straightflush" then
        local _count = #_paixing[4];
        if (_count ~= 0) then
            if self.selectindex > _count then
                self.selectindex = 1;
            end
            return _paixing[4][self.selectindex];

        else
            return nil;
        end
    else
        local _count = #_paixing[5];
        if (_count ~= 0) then
            if self.selectindex > _count then
                self.selectindex = 1;
            end
            return _paixing[5][self.selectindex];

        else
            return nil;
        end
    end
end



function TableBiJiLogic:onClickConfirmNotReadyBtn(obj)
    self.tableBiJiView:CloseNotReadyWindow();
end

function TableBiJiLogic:convertMaskCode(ruleTable)
    local mask = ruleTable.extraScoreTypes or 15
    self.extraScoreTypes = ruleTable.extraScoreTypes;
    self.maskXiPai = { }
    for i = 1, 11 do
        self.maskXiPai[i] = false
    end
    if mask % 2 == 1 then
        self.maskXiPai[5] = true
        self.maskXiPai[7] = true
        self.maskXiPai[10] = true
        self.maskXiPai[11] = true
    end
    if (math.floor(mask / 2)) % 2 == 1 then
        self.maskXiPai[1] = true
        self.maskXiPai[8] = true
        self.maskXiPai[9] = true
    end
    if (math.floor(mask / 4)) % 2 == 1 then
        self.maskXiPai[4] = true
        self.maskXiPai[6] = true
    end
    if (math.floor(mask / 8)) % 2 == 1 then
        self.maskXiPai[2] = true
        self.maskXiPai[3] = true
    end
end

function TableBiJiLogic:on_table_start_notify(eventData)
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i];
        seatInfo.hasConfirmed = false
    end
    self:refreshSeatGameCount()
    self:RefreshRoundInfo(self.modelData.curTableData.roomInfo.curRoundNum + 1)
end

function TableBiJiLogic:refreshSeatGameCount()
    for i = 1, #self.modelData.curTableData.roomInfo.seatInfoList do
        local seatInfo = self.modelData.curTableData.roomInfo.seatInfoList[i]
        if (seatInfo.playerId and seatInfo.playerId ~= 0) then
            seatInfo.gameCount =(seatInfo.gameCount or 0) + 1
        end
    end
end

------收到包:客户自定义的信息变化广播


function TableBiJiLogic:ClearAllMatchingData()
    self.modelData.selectList = { };
    self.modelData.FirstMatching = { };
    self.modelData.SecondMatching = { };
    self.modelData.ThirdMatching = { };
    self.handPokers = { };
    self.oringinalPokers = { };
    -- 发给服务器的数据
    self.pokersInDesc = { };
    -- self.inHandPokerList = {};
end

function TableBiJiLogic:on_table_CustomInfoChangeBroadcast(data)
    print("==on_table_CustomInfoChangeBroadcast")
    -- print_table(data.customInfoList)
    if (self.modelData == nil or self.modelData.curTableData == nil
        or self.modelData.curTableData.roomInfo == nil
        or self.modelData.curTableData.roomInfo.seatInfoList == nil) then
        return
    end
    if (data == nil or data.customInfoList == nil or #data.customInfoList <= 0) then
        return
    end
    for i = 1, #data.customInfoList do
        local player_id = data.customInfoList[i].player_id
        local customInfo = data.customInfoList[i].customInfo
        if (customInfo == nil or customInfo == "") then
            print("==customInfo == nil or customInfo ==")
        else
            local seatInfoList = self.modelData.curTableData.roomInfo.seatInfoList
            for m = 1, #seatInfoList do
                local seatInfo = seatInfoList[m]
                if (tostring(seatInfo.playerId) == tostring(player_id) and (customInfo and customInfo ~= '')) then
                    local locTable = ModuleCache.Json.decode(customInfo)
                    -- print("==ip="..locTable.ip.."  address="..locTable.address)
                    -- seatInfo.playerInfo.ip = locTable.ip
                    seatInfo.playerInfo = seatInfo.playerInfo or {}
                    seatInfo.playerInfo.locationData = seatInfo.playerInfo.locationData or { }
                    seatInfo.playerInfo.locationData.address = locTable.address
                    seatInfo.playerInfo.locationData.gpsInfo = locTable.gpsInfo
                end
            end
        end
    end
    self:CheckLocation()
end

------检查位置
function TableBiJiLogic:CheckLocation()
    local seatInfoList = self.modelData.curTableData.roomInfo.seatInfoList
    -- 获取玩家信息列表(比鸡专用)
    local playerInfoList = TableManagerPoker:getPlayerInfoListByBiJi(seatInfoList)
    -- 是否显示定位图标
    TableManagerPoker:isShowLocation(playerInfoList, self.tableBiJiView.buttonLocation)
end

return TableBiJiLogic