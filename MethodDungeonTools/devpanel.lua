---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Armin.
--- DateTime: 17.06.2018 17:39
---
local AceGUI = LibStub("AceGUI-3.0")
local MethodDungeonTools = MethodDungeonTools
local db
local tonumber,tinsert,slen,pairs,ipairs,tostring,next,type,sformat = tonumber,table.insert,string.len,pairs,ipairs,tostring,next,type,string.format
local UnitName,UnitGUID,UnitCreatureType,UnitHealthMax,UnitLevel = UnitName,UnitGUID,UnitCreatureType,UnitHealthMax,UnitLevel


local function tshow(t, name, indent)
    local cart     -- a container
    local autoref  -- for self references

    --[[ counts the number of elements in a table
    local function tablecount(t)
       local n = 0
       for _, _ in pairs(t) do n = n+1 end
       return n
    end
    ]]
    -- (RiciLake) returns true if the table is empty
    local function isemptytable(t) return next(t) == nil end

    local function basicSerialize (o)
        local so = tostring(o)
        if type(o) == "function" then
            local info = debug.getinfo(o, "S")
            -- info.name is nil because o is not a calling level
            if info.what == "C" then
                return sformat("%q", so .. ", C function")
            else
                -- the information is defined through lines
                return sformat("%q", so .. ", defined in (" ..
                        info.linedefined .. "-" .. info.lastlinedefined ..
                        ")" .. info.source)
            end
        elseif type(o) == "number" or type(o) == "boolean" then
            return so
        else
            return sformat("%q", so)
        end
    end

    local function addtocart (value, name, indent, saved, field)
        indent = indent or ""
        saved = saved or {}
        field = field or name

        cart = cart .. indent .. field

        if type(value) ~= "table" then
            cart = cart .. " = " .. basicSerialize(value) .. ";\n"
        else
            if saved[value] then
                cart = cart .. " = {}; -- " .. saved[value]
                        .. " (self reference)\n"
                autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
            else
                saved[value] = name
                --if tablecount(value) == 0 then
                if isemptytable(value) then
                    cart = cart .. " = {};\n"
                else
                    cart = cart .. " = {\n"
                    for k, v in pairs(value) do
                        k = basicSerialize(k)
                        local fname = sformat("%s[%s]", name, k)
                        field = sformat("[%s]", k)
                        -- three spaces between levels
                        addtocart(v, fname, indent .. "   ", saved, field)
                    end
                    cart = cart .. indent .. "};\n"
                end
            end
        end
    end

    name = name or "__unnamed__"
    if type(t) ~= "table" then
        return name .. " = " .. basicSerialize(t)
    end
    cart, autoref = "", ""
    addtocart(t, name, indent)
    return cart .. autoref
end

local currentEnemyIdx
local currentCloneGroup
local currentTeeming
local currentPatrol
local currentBossEnemyIdx = 1
---CreateDevPanel
---Creates the dev panel which contains buttons to add npcs, objects to the map
function MethodDungeonTools:CreateDevPanel(frame)
    db = MethodDungeonTools:GetDB()
    frame.devPanel = AceGUI:Create("TabGroup")
    local devPanel = frame.devPanel
    devPanel.frame:SetFrameStrata("HIGH")
    devPanel.frame:SetFrameLevel(50)

    devPanel:SetTabs(
        {
            {text="POI", value="tab1"},
            {text="Enemy", value="tab2"},
            {text="Infested", value="tab3"},
        }
    )
    devPanel:SetWidth(250)
    devPanel:SetPoint("TOPRIGHT",frame.topPanel,"TOPLEFT",0,0)
    devPanel:SetLayout("Flow")
    devPanel.frame:Hide()

    MethodDungeonTools:FixAceGUIShowHide(devPanel)

    -- function that draws the widgets for the first tab
    local function DrawGroup1(container)
        --mapLink Options
        local option1 = AceGUI:Create("EditBox")
        option1:SetLabel("Target Floor")
        option1:SetText(1)
        local option2 = AceGUI:Create("EditBox")
        option2:SetLabel("Direction 1up -1d 2r -2l")
        option2:SetText(1)
        container:AddChild(option1)
        container:AddChild(option2)

        --door options
        local option3 = AceGUI:Create("EditBox")
        option3:SetLabel("Door Name")
        option3:SetText("")
        local option4 = AceGUI:Create("EditBox")
        option4:SetLabel("Door Descripting")
        option4:SetText("")
        local lockedCheckbox = AceGUI:Create("CheckBox")
        lockedCheckbox:SetLabel("Lockpickable")
        container:AddChild(option3)
        container:AddChild(option4)
        container:AddChild(lockedCheckbox)

        --graveyard options
        local option5 = AceGUI:Create("EditBox")
        option5:SetLabel("Graveyard Description")
        option5:SetText("")
        container:AddChild(option5)




        local buttons = {
            [1] = {
                text="MapLink",
                func=function()
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx] then MethodDungeonTools.mapPOIs[db.currentDungeonIdx] = {} end
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] then
                        MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] = {}
                    end
                    local links = MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()]
                    local posx,posy = 300,-200
                    local t = tonumber(option1:GetText())
                    local d = tonumber(option2:GetText())
                    if t and d then
                        tinsert(links,{x=posx,y=posy,target=t,direction=d,template="MapLinkPinTemplate",type="mapLink"})
                        MethodDungeonTools:POI_UpdateAll()
                    end
                end,
            },
            [2] = {
                text="Door",
                func=function()
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx] then MethodDungeonTools.mapPOIs[db.currentDungeonIdx] = {} end
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] then
                        MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] = {}
                    end
                    local links = MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()]
                    local posx,posy = 300,-200
                    local doorNameText = option3:GetText()
                    local doorDescriptionText = option4:GetText()
                    local lockpickableStatus = lockedCheckbox:GetValue() or nil
                    tinsert(links,{x=posx,y=posy,template="MapLinkPinTemplate",type="door",doorName=doorNameText,doorDescription = doorDescriptionText,lockpick=lockpickableStatus})
                    MethodDungeonTools:POI_UpdateAll()
                end,
            },
            [3] = {
                text="Graveyard",
                func=function()
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx] then MethodDungeonTools.mapPOIs[db.currentDungeonIdx] = {} end
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] then
                        MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] = {}
                    end
                    local links = MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()]
                    local posx,posy = 300,-200
                    local graveyardDescriptionText = option5:GetText()
                    tinsert(links,{x=posx,y=posy,template="DeathReleasePinTemplate",type="graveyard",graveyardDescription=graveyardDescriptionText})
                    MethodDungeonTools:POI_UpdateAll()
                end,
            },
            [4] = {
                text="General Note",
                func=function()
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx] then MethodDungeonTools.mapPOIs[db.currentDungeonIdx] = {} end
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] then
                        MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] = {}
                    end
                    local pois = MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()]
                    local posx,posy = 300,-200
                    local noteText = option5:GetText()
                    tinsert(pois,{x=posx,y=posy,template="MapLinkPinTemplate",type="generalNote",text=noteText})
                    MethodDungeonTools:POI_UpdateAll()
                end,
            },
            [5] = {
                text="Heavy Cannon",
                func=function()
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx] then MethodDungeonTools.mapPOIs[db.currentDungeonIdx] = {} end
                    if not MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] then
                        MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()] = {}
                    end
                    local pois = MethodDungeonTools.mapPOIs[db.currentDungeonIdx][MethodDungeonTools:GetCurrentSubLevel()]
                    local posx,posy = 300,-200
                    tinsert(pois,{x=posx,y=posy,template="MapLinkPinTemplate",type="heavyCannon"})
                    MethodDungeonTools:POI_UpdateAll()
                end,
            },
            [6] = {
                text="Export to LUA",
                func=function()
                    local export = tshow(MethodDungeonTools.mapPOIs[db.currentDungeonIdx],"MethodDungeonTools.mapPOIs[dungeonIndex]")
                    MethodDungeonTools.main_frame.ExportFrame:Show()
                    MethodDungeonTools.main_frame.ExportFrame:SetPoint("CENTER",MethodDungeonTools.main_frame,"CENTER",0,50)
                    MethodDungeonTools.main_frame.ExportFrameEditbox:SetText(export)
                    MethodDungeonTools.main_frame.ExportFrameEditbox:HighlightText(0, slen(export))
                    MethodDungeonTools.main_frame.ExportFrameEditbox:SetFocus()
                end,
            },
        }
        for buttonIdx,buttonData in ipairs(buttons) do
            local button = AceGUI:Create("Button")
            button:SetText(buttonData.text)
            button:SetCallback("OnClick",buttonData.func)
            container:AddChild(button)
        end
    end

    -- function that draws the widgets for the second tab
    local function DrawGroup2(container)
        local editBoxes = {}
        local countSlider
        local scaleSlider
        local dropdown

        local function updateFields(health,level,creatureType,id,scale,count,idx)
            if idx then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][idx]
                if not data then return end
                health = data.health
                level = data.level
                creatureType = data.creatureType
                id = data.id
                scale = data.scale
                count = data.count
            end
            editBoxes[1]:SetText(id)
            editBoxes[2]:SetText(health)
            editBoxes[3]:SetText(level)
            editBoxes[4]:SetText(creatureType)
            scaleSlider:SetValue(scale)
            countSlider:SetValue(count)
        end
        local function updateDropdown(npcId,idx)
            if not MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx] then return end
            idx = idx or 1
            local enemies = {}
            for mobIdx,data in ipairs(MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx]) do
                tinsert(enemies,mobIdx,data.name)
                if npcId then
                    if data.id == npcId then idx = mobIdx end
                end
            end
            dropdown:SetList(enemies)
            dropdown:SetValue(idx)
            currentEnemyIdx = idx
            updateFields(nil,nil,nil,nil,nil,nil,idx)
        end

        dropdown = AceGUI:Create("Dropdown")
        dropdown:SetCallback("OnValueChanged", function(widget,callbackName,key)
            currentEnemyIdx = key
            updateFields(nil,nil,nil,nil,nil,nil,key)
            local dungeonEnemyBlips = MethodDungeonTools:GetDungeonEnemyBlips()
            for _,v in ipairs(dungeonEnemyBlips) do
                v.devSelected = nil
            end
            MethodDungeonTools:UpdateMap()
        end)

        container:AddChild(dropdown)

        countSlider = AceGUI:Create("Slider")
        countSlider:SetLabel("Count")
        countSlider:SetSliderValues(0,15,1)
        countSlider:SetValue(4)
        countSlider:SetCallback("OnMouseUp",function(widget,callbackName,value)
            local count = tonumber(value)
            local npcIdx = tonumber(dropdown:GetValue())

            local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][npcIdx]
            data["count"] = value
            MethodDungeonTools:UpdateMap()
        end)
        container:AddChild(countSlider)
        local fields = {
            [1] = "id",
            [2] = "health",
            [3] = "level",
            [4] = "creatureType",
        }
        for idx,name in ipairs(fields) do
            editBoxes[idx] = AceGUI:Create("EditBox")
            editBoxes[idx]:SetLabel(name)
            editBoxes[idx]:SetCallback("OnEnterPressed",function(widget,callbackName,text)
                local value = text
                if name ~= "creatureType" then
                    value = tonumber(text)
                end
                local npcIdx = dropdown:GetValue()
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][npcIdx]
                data[name] = value
                MethodDungeonTools:UpdateMap()
            end)
            container:AddChild(editBoxes[idx])
        end

        scaleSlider = AceGUI:Create("Slider")
        scaleSlider:SetLabel("Scale")
        scaleSlider:SetSliderValues(0,5,0.1)
        scaleSlider:SetValue(1)
        scaleSlider:SetCallback("OnMouseUp",function(widget,callbackName,value)
            local npcIdx = tonumber(dropdown:GetValue())
            local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][npcIdx]
            data["scale"] = value
            MethodDungeonTools:UpdateMap()
        end)
        container:AddChild(scaleSlider)

        local button1 = AceGUI:Create("Button")
        button1:SetText("Create from Target")
        button1:SetCallback("OnClick",function()
            local npcId
            local guid = UnitGUID("target")
            if guid then
                npcId = select(6,strsplit("-", guid))
            end
            if npcId then
                local npcName = UnitName("target")
                local npcHealth = UnitHealthMax("target")
                local npcLevel = UnitLevel("target")
                local npcCreatureType = UnitCreatureType("target")
                local npcScale = 1
                local npcCount = 0
                tinsert(MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx], {
                    name = npcName,
                    health = npcHealth,
                    level = npcLevel,
                    creatureType = npcCreatureType,
                    id = tonumber(npcId),
                    scale = npcScale,
                    count = npcCount,
                    clones = {},
                })
                --updateFields(npcHealth,npcLevel,npcCreatureType,npcId,npcScale,npcCount)

                updateDropdown(tonumber(npcId))
            end

        end)
        container:AddChild(button1)

        --make boss
        local button2 = AceGUI:Create("Button")
        button2:SetText("Make Boss")
        button2:SetCallback("OnClick",function()
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                --encounterID
                local encounterID, encounterName, description, displayInfo, iconImage = EJ_GetCreatureInfo(1)
                if not encounterID then
                    print("MDT: Error - Make sure to open Encounter Journal and navigate to the boss you want to add!")
                    return
                end
                for i=1,10000 do
                    local ixd = EJ_GetCreatureInfo(currentBossEnemyIdx,i)
                    if ixd == encounterID then
                        encounterID = i
                        break
                    end
                end
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.isBoss = true
                local mapID = C_Map.GetBestMapForUnit("player")
                data.instanceID = mapID and EJ_GetInstanceForMap(mapID) or 0
                data.encounterID = encounterID
                --use this data as follows:
                --if (not EncounterJournal) then LoadAddOn('Blizzard_EncounterJournal') end
                --EncounterJournal_OpenJournal(23,data.instanceID,data.encounterID)
                MethodDungeonTools:UpdateMap()
            end
        end)
        container:AddChild(button2)

        --blips movable toggle
        local blipsMovableCheckbox = AceGUI:Create("CheckBox")
        blipsMovableCheckbox:SetLabel("Blips Movable")
        blipsMovableCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
            db.devModeBlipsMovable = value or nil
        end)
        container:AddChild(blipsMovableCheckbox)

        --clone options

        --group
        local cloneGroup = AceGUI:Create("EditBox")
        cloneGroup:SetLabel("Group of clone:")
        cloneGroup:SetCallback("OnEnterPressed",function(widget,callbackName,text)
            local value = tonumber(text)
            if value and value>0 then currentCloneGroup = value else currentCloneGroup = nil end
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].g = currentCloneGroup
                MethodDungeonTools:UpdateMap()
            end
        end)
        container:AddChild(cloneGroup)

        local cloneGroupMaxButton = AceGUI:Create("Button")
        cloneGroupMaxButton:SetText("New Group")
        cloneGroupMaxButton:SetCallback("OnClick",function (widget,callbackName)
            local maxGroup = 0
            for _,data in pairs(MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx]) do
                for _,clone in pairs(data.clones) do
                    maxGroup = (clone.g and (clone.g>maxGroup)) and clone.g or maxGroup
                end
            end
            currentCloneGroup = maxGroup+1
            cloneGroup:SetText(currentCloneGroup)
        end)
        container:AddChild(cloneGroupMaxButton)

        local teemingCheckbox = AceGUI:Create("CheckBox")
        teemingCheckbox:SetLabel("Teeming")
        teemingCheckbox:SetCallback("OnValueChanged",function(widget,callbackName,value)
            currentTeeming = value and true or nil
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].teeming = currentTeeming
                MethodDungeonTools:UpdateMap()
            end
        end)
        teemingCheckbox:SetValue(currentTeeming)
        container:AddChild(teemingCheckbox)


        --patrol
        local patrolCheckbox = AceGUI:Create("CheckBox")
        patrolCheckbox:SetLabel("Patrol")
        patrolCheckbox:SetCallback("OnValueChanged",function(widget,callbackName,value)
            currentPatrol = value or nil
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].patrol = currentPatrol and (data.clones[currentBlip.cloneIdx].patrol or {}) or nil
                if not data.clones[currentBlip.cloneIdx].patrol then
                    currentBlip.patrolActive = false
                end
                MethodDungeonTools:ShowBlipPatrol(currentBlip,false)
                MethodDungeonTools:UpdateMap()
            end
        end)
        container:AddChild(patrolCheckbox)

        --stealthdetect
        local stealthDetectCheckbox = AceGUI:Create("CheckBox")
        stealthDetectCheckbox:SetLabel("Stealth Detect")
        stealthDetectCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
            data.stealthDetect = value or nil
            MethodDungeonTools:UpdateMap()
        end)
        container:AddChild(stealthDetectCheckbox)

        --stealth
        local stealthCheckbox = AceGUI:Create("CheckBox")
        stealthCheckbox:SetLabel("Stealthed")
        stealthCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
            data.stealth = value or nil
            MethodDungeonTools:UpdateMap()
        end)
        container:AddChild(stealthCheckbox)

        --neutral
        local neutralCheckbox = AceGUI:Create("CheckBox")
        neutralCheckbox:SetLabel("Neutral")
        neutralCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
            data.neutral = value or nil
            MethodDungeonTools:UpdateMap()
        end)
        container:AddChild(neutralCheckbox)

        --upstairs
        local upstairsCheckbox = AceGUI:Create("CheckBox")
        upstairsCheckbox:SetLabel("Upstairs")
        upstairsCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].upstairs = value or nil
                MethodDungeonTools:UpdateMap()
            end
        end)
        container:AddChild(upstairsCheckbox)

        --negative teeming
        local negativeteemingCheckbox = AceGUI:Create("CheckBox")
        negativeteemingCheckbox:SetLabel("Negative Teeming")
        negativeteemingCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].negativeTeeming = value or nil
                MethodDungeonTools:UpdateMap()
            end
        end)
        container:AddChild(negativeteemingCheckbox)

        --faction
        local faction = AceGUI:Create("EditBox")
        faction:SetLabel("Faction:")
        faction:SetCallback("OnEnterPressed",function(widget,callbackName,text)
            local value = tonumber(text)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].faction = value
                MethodDungeonTools:UpdateMap()
            end
        end)
        container:AddChild(faction)

        --enter clone options into the GUI (red)
        local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
        if currentBlip then
            cloneGroup:SetText(currentBlip.clone.g)
            currentCloneGroup = currentBlip.clone.g
            teemingCheckbox:SetValue(currentBlip.clone.teeming)
            currentTeeming = currentBlip.clone.teeming
            currentPatrol = currentBlip.patrol and true or nil
            patrolCheckbox:SetValue(currentPatrol and currentBlip.patrolActive)
            stealthDetectCheckbox:SetValue(currentBlip.data.stealthDetect)
            stealthCheckbox:SetValue(currentBlip.data.stealth)
            neutralCheckbox:SetValue(currentBlip.data.neutral)
            upstairsCheckbox:SetValue(currentBlip.clone.upstairs)
            negativeteemingCheckbox:SetValue(currentBlip.clone.negativeTeeming)
            faction:SetText(currentBlip.clone.faction)
        else
            cloneGroup:SetText(currentCloneGroup)
        end
        blipsMovableCheckbox:SetValue(db.devModeBlipsMovable)

        local button3 = AceGUI:Create("Button")
        button3:SetText("Export to LUA")
        button3:SetCallback("OnClick",function()
            local export = tshow(MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx],"MethodDungeonTools.dungeonEnemies[dungeonIndex]")
            MethodDungeonTools.main_frame.ExportFrame:Show()
            MethodDungeonTools.main_frame.ExportFrame:SetPoint("CENTER",MethodDungeonTools.main_frame,"CENTER",0,50)
            MethodDungeonTools.main_frame.ExportFrameEditbox:SetText(export)
            MethodDungeonTools.main_frame.ExportFrameEditbox:HighlightText(0, slen(export))
            MethodDungeonTools.main_frame.ExportFrameEditbox:SetFocus()
        end)
        container:AddChild(button3)





        updateDropdown(nil,currentEnemyIdx)
        end

    local function DrawGroup3(container)
        for i=1,12 do
            local infestedCheckbox = AceGUI:Create("CheckBox")
            infestedCheckbox:SetLabel("Infested Week "..i)
            infestedCheckbox:SetCallback("OnValueChanged",function (widget,callbackName,value)
                local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
                local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
                data.clones[currentBlip.cloneIdx].infested = data.clones[currentBlip.cloneIdx].infested or {}
                data.clones[currentBlip.cloneIdx].infested[i] = value or nil
                MethodDungeonTools:UpdateMap()
            end)
            local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
            if currentBlip then
                infestedCheckbox:SetValue(currentBlip.clone.infested and currentBlip.clone.infested[i])
            end
            container:AddChild(infestedCheckbox)
        end


    end

    -- Callback function for OnGroupSelected
    local function SelectGroup(container, event, group)
        container:ReleaseChildren()
        if group == "tab1" then
            DrawGroup1(container)
        elseif group == "tab2" then
            DrawGroup2(container)
        elseif group == "tab3" then
            DrawGroup3(container)
        end
    end
    devPanel:SetCallback("OnGroupSelected", SelectGroup)
    devPanel:SelectTab("tab2")

    --hook UpdateMap
    local originalFunc = MethodDungeonTools.UpdateMap
    function MethodDungeonTools:UpdateMap(...)
        originalFunc(...)
        local selectedTab
        for k,v in pairs(devPanel.tabs) do
            if v.selected == true then selectedTab = v.value; break end
        end
        --currentEnemyIdx
        local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
        if currentBlip then
            currentEnemyIdx=currentBlip.enemyIdx
        end
        devPanel:SelectTab(selectedTab)
        --show patrol
        local dungeonEnemyBlips = MethodDungeonTools:GetDungeonEnemyBlips()
        for _,v in ipairs(dungeonEnemyBlips) do
            v:DisplayPatrol(v.devSelected)
        end

    end

end

---AddCloneAtCursorPosition
---Adds a clone at the cursor position to the dungeon enemy table
---bound to hotkey and used to add new npcs to the map
function MethodDungeonTools:AddCloneAtCursorPosition()
    if not MouseIsOver(MethodDungeonToolsScrollFrame) then return end
    if currentEnemyIdx then
        local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentEnemyIdx]
        local cursorx,cursory = MethodDungeonTools:GetCursorPosition()
        tinsert(data.clones,{x=cursorx,y=cursory,sublevel=MethodDungeonTools:GetCurrentSubLevel(),g=currentCloneGroup,teeming=currentTeeming})
        print(string.format("MDT: Created clone %s %d at %d,%d",data.name,#data.clones,cursorx,cursory))
        MethodDungeonTools:UpdateMap()
    end
end

---AddPatrolWaypointAtCursorPosition
---Adds a patrol waypoint to the selected enemy
function MethodDungeonTools:AddPatrolWaypointAtCursorPosition()
    if not MouseIsOver(MethodDungeonToolsScrollFrame) then return end
    local currentBlip = MethodDungeonTools:GetCurrentDevmodeBlip()
    if currentBlip then
        local data = MethodDungeonTools.dungeonEnemies[db.currentDungeonIdx][currentBlip.enemyIdx]
        local cloneData = data.clones[currentBlip.cloneIdx]
        cloneData.patrol = cloneData.patrol or {}
        cloneData.patrol[1] = {x=cloneData.x,y=cloneData.y}
        local cursorx,cursory = MethodDungeonTools:GetCursorPosition()
        --snap onto other waypoints
        local dungeonEnemyBlips = MethodDungeonTools:GetDungeonEnemyBlips()
        for blipIdx,blip in pairs(dungeonEnemyBlips) do
            if blip.patrol then
                for idx,waypoint in pairs(blip.patrol) do
                    if MouseIsOver(waypoint) then
                        cursorx = waypoint.x
                        cursory = waypoint.y
                    end
                end
            end
        end
        tinsert(cloneData.patrol,{x=cursorx,y=cursory})
        print(string.format("MDT: Created Waypoint %d of %s %d at %d,%d",1,data.name,#cloneData.patrol,cursorx,cursory))
        MethodDungeonTools:UpdateMap()
    end
end


---AddBossAtCursorPosition
---Adds a boss at the cursor position to the dungeon boss table
function MethodDungeonTools:AddBossAtCursorPosition()
    local bosses = MethodDungeonTools.dungeonBosses[db.currentDungeonIdx]
    local sublevel = MethodDungeonTools:GetCurrentSubLevel()
    local nid
    local guid = UnitGUID("target")
    if guid then nid = select(6,strsplit("-", guid)) else return end
    if nid then

        local encounterIDx, encounterName, description, displayInfo, iconImage = EJ_GetCreatureInfo(currentBossEnemyIdx)
        if not encounterIDx then return end

        for i=1,10000 do
            local ixd = EJ_GetCreatureInfo(currentBossEnemyIdx,i)
            if ixd == encounterIDx then
                encounterIDx = i
                break
            end
        end

        local encounterHealth = UnitHealthMax("target")
        local encounterLevel = UnitLevel("target")
        local encounterCreatureType = UnitCreatureType("target")
        local cursorx,cursory = MethodDungeonTools:GetCursorPosition()
        bosses[sublevel] = bosses[sublevel] or {}
        tinsert(bosses[sublevel],{
            name = encounterName,
            health = encounterHealth,
            encounterID = encounterIDx,
            level = encounterLevel,
            creatureType = encounterCreatureType,
            id = tonumber(nid),
            x = cursorx,
            y = cursory,
        })
        MethodDungeonTools:UpdateDungeonBossButtons()
    end
end
