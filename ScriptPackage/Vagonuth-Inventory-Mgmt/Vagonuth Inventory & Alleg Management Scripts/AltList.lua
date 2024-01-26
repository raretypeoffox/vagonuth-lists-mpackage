-- Script: AltList
-- Attribute: isActive

-- Script Code:
-- Mudlet LUA script to track alts and their stats
-- Tracks gold, pracs, QP, insigs, and alleg turn ins

-- + Table and Array Functions: deepcopy(), TableSize()

AltList = AltList or {}
AltList.Chars = AltList.Chars or {}

AltList.TimeZone = AltList.TimeZone or 0
AltList.LoginName = AltList.LoginName or nil


-- Function to save AltList.Chars to AltList.lua
function AltList.Save()
  local location = getMudletHomeDir() .. "/AltList.lua"
  AltList.Chars["AltListTimeZone"] = {}
  AltList.Chars["AltListTimeZone"].TimeZone = AltList.TimeZone
  
  table.save(location, AltList.Chars)
  
  AltList.Chars["AltListTimeZone"] = nil
end

-- Function to load AltList.lua into AltList.Chars
function AltList.Load()
  local location = getMudletHomeDir() .. "/AltList.lua"
  if io.exists(location) then
    table.load(location, AltList.Chars)
    if AltList.Chars["AltListTimeZone"] then
      AltList.TimeZone = AltList.Chars["AltListTimeZone"].TimeZone
      AltList.Chars["AltListTimeZone"] = nil
    end
  end
end

-- Check if AltList is empty, if so, attempt to load it
-- This will be run the first time Mudlet/the profile is opened
if TableSize(AltList.Chars) == 0 then AltList.Load() end


function AltList.GetCharName()
  sendGMCP("Char.Group.List")
  
  if AltList.LoginName then
    return AltList.LoginName
  end
  
  local char_name = string.lower(gmcp.Char.Status.character_name):gsub("^%l", string.upper)

  if char_name == "" then error("gmcp.Char.Status.character_name not returning character name"); return nil end
  
  -- Sometimes gmcp.Char.Status bugs out and requires a relog. We can check this against gmcp.Char.Group.List
  for _,Player in ipairs(gmcp.Char.Group.List) do
    if Player.name == char_name then
      return char_name
    end
  end
  
  cecho("<yellow>Vagonuth-Inventory-Mgmt error: <white>could not get character name, gmcp returning <red>" .. char_name .. "\n")
  cecho("If this is different than the name you logged in with, try reconnecting to AVATAR\n")
  cecho("If your char_name is correct, try running the command again\n\n")
  
  error("gmcp.Char.Status is not matching gmcp.Char.Group")
  return nil
end


AltList.GivenAllegRuby = AltList.GivenAllegRuby or false
AltList.GivenAllegItem = AltList.GivenAllegItem or false

function AltList.PlayerExists(char_name)
  if (AltList.Chars[char_name]==nil) then
    AltList.Chars[char_name] = {}
    AltList.Chars[char_name].Worship = ""
    AltList.Chars[char_name].Devoted = ""
    AltList.Chars[char_name].Gold = 0
    AltList.Chars[char_name].Pracs = 0
    AltList.Chars[char_name].QP = 0
    
    AltList.Chars[char_name].Race = ""
    AltList.Chars[char_name].Class = ""
    AltList.Chars[char_name].Level = 0
    AltList.Chars[char_name].SubLevel = 0
    AltList.Chars[char_name].Max_HP = 0
    AltList.Chars[char_name].Max_MP = 0
    AltList.Chars[char_name].HitRoll = 0
    AltList.Chars[char_name].DamRoll= 0
    AltList.Chars[char_name].ArmorClass = 0
    AltList.Chars[char_name].Items = 0
    AltList.Chars[char_name].MaxItems = 0
    AltList.Chars[char_name].Weight = 0
    AltList.Chars[char_name].MaxWeight = 0
    AltList.Chars[char_name].Insigs = {}
    
    AltList.Chars[char_name].Alleg = {}
    AltList.Chars[char_name].Alleg.Insig = ""
    AltList.Chars[char_name].Alleg.Request = ""
    AltList.Chars[char_name].Alleg.Cleared = false
    AltList.Chars[char_name].Alleg.GiveUp = false
    AltList.Chars[char_name].Alleg.LastDate = ""
    
    AltList.Chars[char_name].Spells = {}
    return false
  else
    AltList.UpdateVitals(char_name)
    return true
  end
end

function AltList.UpdateVitals(char_name)
    AltList.Chars[char_name].Race = gmcp.Char.Status.race
    AltList.Chars[char_name].Class = gmcp.Char.Status.class
    AltList.Chars[char_name].Level = tonumber(gmcp.Char.Status.level)
    AltList.Chars[char_name].SubLevel = tonumber(gmcp.Char.Status.sublevel)
    AltList.Chars[char_name].Max_HP = tonumber(gmcp.Char.Vitals.maxhp)
    AltList.Chars[char_name].Max_MP = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 0 or tonumber(gmcp.Char.Vitals.maxmp)
    AltList.Chars[char_name].HitRoll = tonumber(gmcp.Char.Status.hitroll)
    AltList.Chars[char_name].DamRoll = tonumber(gmcp.Char.Status.damroll)
    AltList.Chars[char_name].ArmorClass = tonumber(gmcp.Char.Status.ac) or 0
    AltList.Chars[char_name].Items = tonumber(gmcp.Char.Vitals.items)
    AltList.Chars[char_name].MaxItems = tonumber(string.sub(gmcp.Char.Vitals.string, -3))
    AltList.Chars[char_name].Weight = tonumber(gmcp.Char.Vitals.wgt)
    AltList.Chars[char_name].MaxWeight = tonumber(gmcp.Char.Vitals.maxwgt)
    AltList.Save()
end

function AltList.UpdateGold(gold)
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].Gold = tonumber(gold)
  AltList.Save()
end

function AltList.UpdatePracs(pracs)
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].Pracs = tonumber(pracs)
  AltList.Save()
end

function AltList.UpdateQP(QP)
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].QP = tonumber(QP)
  AltList.Save()
end

function AltList.UpdateInsigs(tbl_Insigs)
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)  
  
  AltList.Chars[char_name].Insigs = deepcopy(tbl_Insigs)

  for _, insig in ipairs(tbl_Insigs) do
    if insig == "Scratcher" or
       insig == "Busybody" or
       insig == "Deed Doer" or
       insig == "Goto Guy/Gal/Person" or
       insig == "Feat Finisher" or
       insig == "Task Master" then
       
       if AltList.Chars[char_name].Alleg.Insig ~= "" and AltList.Chars[char_name].Alleg.Insig ~= insig then
        -- Alleg promotion!
        VictoryBeep()
        printGameMessage("Alleg!", char_name .. " promoted to " .. insig, "purple", "white")
       end
      AltList.Chars[char_name].Alleg.Insig = insig 
    end
  end
  AltList.Save()
end

function AltList.AllegRecordRequest(alleg_request)
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].Alleg.Request = alleg_request
  AltList.Chars[char_name].Alleg.LastDate = getServerTime(AltList.TimeZone)
  AltList.Chars[char_name].Alleg.Cleared = false
  AltList.Chars[char_name].Alleg.GiveUp = false
  AltList.Save()
end

function AltList.AllegRecordCleared(char_name)
  if not char_name then char_name = AltList.GetCharName()
  else char_name = string.lower(char_name):gsub("^%l", string.upper) end
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].Alleg.Cleared = true
  AltList.Chars[char_name].Alleg.GiveUp = false
  AltList.Chars[char_name].Alleg.LastDate = getServerTime(AltList.TimeZone)
  AltList.Chars[char_name].Alleg.Request = ""
  AltList.Save()
end

function AltList.AllegRecordGiveUp()
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].Alleg.Cleared = false
  AltList.Chars[char_name].Alleg.GiveUp = true
  AltList.Chars[char_name].Alleg.LastDate = getServerTime(AltList.TimeZone)
  AltList.Chars[char_name].Alleg.Request = ""
  AltList.Save()
end

function AltList.AllegNeeded(BroadcastType)
  local BroadcastType = BroadcastType or "bud"
  local AllegList = {}
  local AllegCounts = {}
  
  for char_name, _ in pairs(AltList.Chars) do
    local request = AltList.Chars[char_name].Alleg.Request
    if request ~= "" and request ~= "Available" then
      if not AllegList[request] then
        AllegList[request] = 1
      else
        AllegList[request] = AllegList[request] + 1
      end
    end
  end

  if TableSize(AllegList) == 0 then cecho("<red>There's no alleg that you need!\n"); return; end

  local AllegNeededMsg = {}
  local AllegNeededIndex = 1
  AllegNeededMsg[AllegNeededIndex] = "Looking for: |BW|"

  for alleg_item, count in pairs(AllegList) do
    local itemText = alleg_item
    if count > 1 then
      itemText = itemText .. " (x" .. count .. ")"
    end
    if (string.len(AllegNeededMsg[AllegNeededIndex]) + string.len(itemText) + 2) > 400 then
      AllegNeededIndex = AllegNeededIndex + 1
      AllegNeededMsg[AllegNeededIndex] = itemText .. " |BY|||BW| "
    else
      AllegNeededMsg[AllegNeededIndex] = AllegNeededMsg[AllegNeededIndex] .. itemText .. " |BY|||BW| "
    end
  end

  for _, msg in ipairs(AllegNeededMsg) do
    send(BroadcastType .. " " .. msg:sub(1, -12) .. ".")
  end
end

function AltList.AllegUpdate(char_name)

    if AltList.Chars[char_name].Alleg.Request == "Available" then return end
    if AltList.Chars[char_name].Alleg.Request == "" and not AltList.Chars[char_name].Alleg.GiveUp and not AltList.Chars[char_name].Alleg.Cleared then return end
      
    local days_since_LastDate = calculateDaysBetweenTimes(AltList.Chars[char_name].Alleg.LastDate, getServerTime(AltList.TimeZone))
    
    if (days_since_LastDate >= 2 and AltList.Chars[char_name].Alleg.GiveUp)
    or (days_since_LastDate >= 1 and AltList.Chars[char_name].Alleg.Cleared) then
        AltList.Chars[char_name].Alleg.GiveUp = false
        AltList.Chars[char_name].Alleg.Cleared = false
        AltList.Chars[char_name].Alleg.LastDate = ""
        AltList.Chars[char_name].Alleg.Request = "Available"
    end
end

function AltList.AllegUpdateAll()
    for char_name,_ in pairs(AltList.Chars) do
      AltList.AllegUpdate(char_name)
    end
    AltList.Save()
end

function AltList.FormatReportTwoCol(title, tblReport, total)
  if type(title) ~= "string" or type(tblReport) ~= "table" then
    error("showCmdSyntax: Invalid inputs (expected string, table)")
    return false
  end
  
  local formatStr

  if #tblReport == 0 then error("tblReport is empty"); return end

  local line_break = "<white>-----------------------------------------\n"
  cecho("<white>"..title.."\n")
  cecho(line_break)
  cecho(string.format("<white>%-30s%10s\n", tblReport[1][1], tblReport[1][2]))
  table.remove(tblReport,1)
  cecho(line_break)
  for _, v in ipairs(tblReport) do
    if type(v[2]) == "number" then v[2] = format_int(v[2]) end
    if v[1] == AltList.GetCharName() then
        formatStr = string.format("<%s>%-30s%10s\n", "yellow", v[1], v[2])
    else
        formatStr = string.format("<%s>%-30s%10s\n", "white", v[1], v[2])
    end
    cecho(formatStr)
  end
  cecho(line_break)
  if total and total > 0 then
    cecho(string.format("<white>%-30s%10s\n", "Total: ", format_int(total)))
    cecho(line_break)
  end
end

function AltList.FormatReportThreeCol(title, tblReport, showCmdColour)
  if type(title) ~= "string" or type(tblReport) ~= "table" then
    error("showCmdSyntax: Invalid inputs (expected string, table)")
    return false
  end

  if #tblReport == 0 then error("tblReport is empty"); return end
  
  showCmdColour = showCmdColour or "white" -- https://wiki.mudlet.org/images/c/c3/ShowColors.png
  
  cecho("<"..showCmdColour..">"..title.."\n")
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
  cecho(string.format("<%s>%-30s%-30s%s\n", showCmdColour, tblReport[1][1], tblReport[1][2], tblReport[1][3]))
  table.remove(tblReport,1)
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
  for _, v in ipairs(tblReport) do
    local formatStr
    --if string.sub(v[2],1,1) == "*" then v[2] = "<yellow>" .. v[2] .. "<white>" end
    if v[1] == AltList.GetCharName() then
        formatStr = string.format("<%s>%-30s%-30s%s\n", "yellow", v[1], v[2], v[3])
    else
        formatStr = string.format("<%s>%-30s%-30s%s\n", showCmdColour, v[1], v[2], v[3])
    end
    cecho(formatStr)
  end
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
end

local function AllegTableSort(a, b)
    -- Custom order for sorting
    local order = {"Task Master", "Feat Finisher", "Goto Guy/Gal/Person", "Deed Doer", "Busybody", "Scratcher", ""}

    local aInsignia = AltList.Chars[a].Alleg.Insig
    local bInsignia = AltList.Chars[b].Alleg.Insig

    -- Get the index of the Insignia values in the custom order
    local aIndex = 0
    local bIndex = 0
    for i, value in ipairs(order) do
        if aInsignia == value then
            aIndex = i
        end
        if bInsignia == value then
            bIndex = i
        end
    end

    return aIndex < bIndex
end

function AltList.ReportAlleg()
  AltList.AllegUpdateAll()
  
  local Available = {}
  local Request = {}
  local Tomorrow = {}
  local TwoDays = {}
  
  for char_name,_ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Level == 125 then 
      if AltList.Chars[char_name].Alleg.Request == "Available" then 
        table.insert(Available, char_name)
      elseif AltList.Chars[char_name].Alleg.Cleared then
        table.insert(Tomorrow, char_name)
      elseif AltList.Chars[char_name].Alleg.GiveUp then      
        local days_since_LastDate = calculateDaysBetweenTimes(AltList.Chars[char_name].Alleg.LastDate, getServerTime(AltList.TimeZone))
        if days_since_LastDate == 0 then
          table.insert(TwoDays, char_name)
        else
          table.insert(Tomorrow, char_name)
        end
      elseif AltList.Chars[char_name].Alleg.Request ~= "" then
        --table.insert(Request, {char_name, AltList.Chars[char_name].Alleg.Request})
        table.insert(Request, char_name)      
      end
    end -- end of Level == 125 check
  end
  
  table.sort(Available, AllegTableSort)
  table.sort(Tomorrow, AllegTableSort)
  table.sort(TwoDays, AllegTableSort)
  table.sort(Request, AllegTableSort)
  
  
  if #Request == 0 and #Available == 0 and #Tomorrow == 0 and #TwoDays == 0 then
    print("No Alleg Report available")
    return
  end
  
  local tblAllegReport = {}
  local footnote = false
  
  table.insert(tblAllegReport, {"Character", "Alleg Item/Status", "Insignia"}) 
  
  if #Available > 0 then
    for _,y in pairs(Available) do
      table.insert(tblAllegReport, {y, "Available", AltList.Chars[y].Alleg.Insig})
      --table.sort(tblAllegReport, AllegTableSort)
    end
  end
  
  
  if #Request > 0 then
    for _,y in pairs(Request) do
      local item_name = AltList.Chars[y].Alleg.Request
      if InventoryList.HaveItem(item_name) then
        item_name = "*" .. AltList.Chars[y].Alleg.Request 
        footnote = true
      end
      table.insert(tblAllegReport, {y, string.sub(item_name,1, 25), AltList.Chars[y].Alleg.Insig}) --only use first 25 characters of item name to maintain cols
    end
  end
  

  if #Tomorrow > 0 then
    for _,y in pairs(Tomorrow) do
      table.insert(tblAllegReport, {y, "Tomorrow " .. (AltList.Chars[y].Alleg.Cleared and "(Cleared)" or "(Give Up)"), AltList.Chars[y].Alleg.Insig})
    end
  end
  if #TwoDays > 0 then
    for _,y in pairs(TwoDays) do
      table.insert(tblAllegReport, {y, "Two Days (Give Up)",AltList.Chars[y].Alleg.Insig})
    end
  end
  
  AltList.FormatReportThreeCol("Alleg Report", tblAllegReport)

  if footnote then cecho("<yellow>* <white>item available on character or alt, try isearch <item_name>\n") end
  
end

function AltList.ReportGold()
  local tblCharReport = {}
  local totalGold = 0
  for char_name,_ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Gold > 0 then
      table.insert(tblCharReport, {char_name, AltList.Chars[char_name].Gold})
      totalGold = totalGold + AltList.Chars[char_name].Gold
    end
  end
  
  table.sort(tblCharReport,function(a, b) return a[2] > b[2] end)
  table.insert(tblCharReport, 1, {"Character", "Gold"})
  AltList.FormatReportTwoCol("Gold", tblCharReport, totalGold)
end

function AltList.ReportQP()
  local tblCharReport = {}
  local totalQP = 0
  for char_name,_ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].QP > 0 then
      table.insert(tblCharReport, {char_name, AltList.Chars[char_name].QP})
      totalQP = totalQP + AltList.Chars[char_name].QP
    end
  end
  
  table.sort(tblCharReport,function(a, b) return a[2] > b[2] end)
  table.insert(tblCharReport, 1, {"Character/Token", "QP"})


  local QPtoken_denom = {
    {"QuestPoint Token (1QP)", 1},
    {"QuestPoint Token (2QP)", 2},
    {"QuestPoint Token (3QP)", 3},
    {"QuestPoint Token (4QP)", 4},
    {"QuestPoint Token (5QP)", 5},
    {"QuestPoint Token (10QP)", 10},
    {"QuestPoint Token (20QP)", 20},
    {"QuestPoint Token (30QP)", 30},
    {"Fae Rune For 'Pain'", 5},
    {"Fae Rune For 'Insanity'", 5},
    {"Fae Rune For 'fire'", 5},
    {"Fae Rune For 'Disease'", 5},
    {"Fae Rune For 'Despair'", 10},
    {"Fae Rune For 'Enslavement'", 12},
    {"Fae Rune For 'Destruction'", 12},
    {"orderly dragon scale", 5},
    
  }
  
  for _, token_tbl in pairs(QPtoken_denom) do 
    local QPtoken_name = token_tbl[1]
    local denom = token_tbl[2]
    local QPtoken = InventoryList.ItemsOnHand(QPtoken_name)
    if QPtoken > 0 then
      table.insert(tblCharReport, {QPtoken_name .. " x " .. QPtoken, QPtoken * denom})
      totalQP = totalQP + QPtoken * denom
    end

  end
  
  AltList.FormatReportTwoCol("QuestPoints (QP)", tblCharReport, totalQP)
end

function AltList.ReportInsig()
  local tblCharReport = {}

  local InsigCount = {
    ["Scratcher"] = 0,
    ["Busybody"] = 0,
    ["Deed Doer"] = 0,
    ["Goto Guy/Gal/Person"] = 0,
    ["Feat Finisher"] = 0,
    ["Task Master"] = 0,
  }
  
  local TotalCount = 0

  for char_name, _ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Level == 125 then -- exclude alts that may have remorted
      for _, insig in ipairs(AltList.Chars[char_name].Insigs) do
        if InsigCount[insig] ~= nil then
          InsigCount[insig] = InsigCount[insig] + 1
          TotalCount = TotalCount + 1
        end
      end
    end
  end
  
  if TotalCount == 0 then
    printMessage("Insig Report", "No alts with alleg insigs are tracked. Try logging in with each alt and typing 'insig' once")
    return
  end
  

  -- Iterate over InsigCount using ipairs to maintain the order
  for _, insig in ipairs({"Scratcher", "Busybody", "Deed Doer", "Goto Guy/Gal/Person", "Feat Finisher", "Task Master"}) do
    local count = InsigCount[insig]
    if count > 0 then
      table.insert(tblCharReport, {insig, count})
    end
  end

  table.insert(tblCharReport, 1, {"Alleg Level", "Quantity"})
  AltList.FormatReportTwoCol("Alleg Insig Report", tblCharReport, TotalCount)
end

function AltList.ReportInventorySpace(top_x)
  -- inspired by sumnissan's lack of inventory management
  top_x = top_x or 5
  
  -- ensure that top_x is a number
  if type(top_x) ~= "number" then
    error("AltList.ReportInventorySpace(top_x): top_x must be a number")
    return false
  end

  local tblCharReportHero = {} --  for characters Level 51
  local tblCharReportLord = {} -- for characters Level 125
  local top_x_hero = 0
  local top_x_lord = 0

  for char_name, _ in pairs(AltList.Chars) do
    local freeItems = AltList.Chars[char_name].MaxItems - AltList.Chars[char_name].Items
    local freeWeight = AltList.Chars[char_name].MaxWeight - AltList.Chars[char_name].Weight
    local level = AltList.Chars[char_name].Level

    if level == 51 then table.insert(tblCharReportHero, {char_name, freeWeight, freeItems}); top_x_hero = top_x_hero + 1
    elseif level == 125 then table.insert(tblCharReportLord, {char_name, freeWeight, freeItems}); top_x_lord = top_x_lord + 1
    end
    
  end

  -- sort tblCharReport based on most free weight least
  table.sort(tblCharReportHero,function(a, b) return a[2] > b[2] end)
  table.sort(tblCharReportLord,function(a, b) return a[2] > b[2] end)


  -- trim tblCharReport to top_x
  if top_x_hero > top_x then
    for i = top_x + 1, #tblCharReportHero do
      tblCharReportHero[i] = nil
    end
  end

  -- trim tbleCharReportLord to top_x
  if top_x_lord > top_x then
    for i = top_x + 1, #tblCharReportLord do
      tblCharReportLord[i] = nil
    end
  end
  
  table.insert(tblCharReportHero, 1, {"Heroes", "Free Weight", "Free Items"})
  table.insert(tblCharReportLord, 1, {"Lords", "Free Weight", "Free Items"})
     
  if #tblCharReportLord == 1 and #tblCharReportHero == 1 then
    printMessage("Inventory Space Report Error", "You have no lords or heroes on your altlist. Try logging in with your other alts first")
    return
  end
  
  cecho("\n<white>Inventory Space Report")
  if #tblCharReportLord > 1 then AltList.FormatReportThreeCol(" ", tblCharReportLord) end
  if #tblCharReportHero > 1 then AltList.FormatReportThreeCol(" ", tblCharReportHero) end
  
end



function AltList.UpdateWorship(worship, devoted)
  local char_name = AltList.GetCharName()
  AltList.PlayerExists(char_name)
  
  AltList.Chars[char_name].Worship = worship
  AltList.Chars[char_name].Devoted = devoted
end

function GetSpellLagMod()
  local char_name = AltList.GetCharName()
  -- If we don't know our worship, just return 1 as the modifier
  if AltList.Chars[char_name] == nil or AltList.Chars[char_name].Worship == nil then send("score",false); return 1 end
  
  if AltList.Chars[char_name].Worship == "Durr" or
     AltList.Chars[char_name].Worship == "Quixoltan" or
     AltList.Chars[char_name].Worship == "Kra" then
      return 1.1
  elseif AltList.Chars[char_name].Worship == "Shizaga" then
    return 0.8
  else  
    return 1
  end
end

function GetSpellCostModWorship()
  local char_name = AltList.GetCharName()
  -- If we don't know our worship, just return 1 as the modifier
  if AltList.Chars[char_name] == nil or AltList.Chars[char_name].Worship == nil then send("score",false); return 1 end
  
  if AltList.Chars[char_name].Worship == "Bhyss" then return 0.9 end
  
  if AltList.Chars[char_name].Worship == "Gorn" or
     AltList.Chars[char_name].Worship == "Quixoltan" then return 1.05 end
     
  if AltList.Chars[char_name].Worship == "Shizaga" then return 0.95 end
  
  if AltList.Chars[char_name].Worship == "Tor" or
     AltList.Chars[char_name].Worship == "Werredan" then return 1.1 end

  return 1

end

function GetSpellCostModRacial(race, type)
    local racial mod = 1
    race = string.lower(race)
  
    if not (type == "arcane" or type == "divine" or type == "psionic") then
      pdebug("ERROR: GetSpellCostModRacial(type): type must be one of arcane, divine or psionic")
      error("GetSpellCostModRacial(type): type must be one of arcane, divine or psionic")
    end
    
    if (race == string.lower("Centaur")) then
        if type == "arcane" then racialmod = 0.9 end
        if type == "divine" then racialmod = 0.85 end
        if type == "psionic" then racialmod = 0.9 end
    elseif (race == string.lower("Deep Gnome")) then
        if type == "arcane" then racialmod = 0.93 end
        if type == "divine" then racialmod = 0.95 end
        if type == "psionic" then racialmod = 0.95 end
    elseif (race == string.lower("Draconian")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 0.95 end
    elseif (race == string.lower("Drow")) then
        if type == "arcane" then racialmod = 0.88 end
        if type == "divine" then racialmod = 0.9 end
        if type == "psionic" then racialmod = 0.9 end
    elseif (race == string.lower("Duergar")) then
        if type == "arcane" then racialmod = 1.1; print("Please confirm value for Duergar with alias: spellcostcheck") end
        if type == "divine" then racialmod = 0.98; print("Please confirm value for Duergar with alias: spellcostcheck")  end
        if type == "psionic" then racialmod = 1.02; print("Please confirm value for Duergar with alias: spellcostcheck")  end
    elseif (race == string.lower("Dwarf")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 0.95 end
        if type == "psionic" then racialmod = 1.06 end
    elseif (race == string.lower("Elf")) then
        if type == "arcane" then racialmod = 0.88 end
        if type == "divine" then racialmod = 0.9 end
        if type == "psionic" then racialmod = 0.9 end
    elseif (race == string.lower("Ent")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 0.8 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("Firedrake")) then
        if (tonumber(gmcp.Char.Status.level) > 51 or tonumber(gmcp.Char.Status.sublevel) > 250) then racialmod = 0.98 else racialmod = 1 end
    elseif (race == string.lower("Gargoyle")) then
        if type == "arcane" then racialmod = 0.85 end
        if type == "divine" then racialmod = 0.9 end
        if type == "psionic" then racialmod = 0.9 end
    elseif (race == string.lower("Giant")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 1.1 end
        if type == "psionic" then racialmod = 1.1 end
    elseif (race == string.lower("Gnome")) then
        if type == "arcane" then racialmod = 0.93 end
        if type == "divine" then racialmod = 0.95 end
        if type == "psionic" then racialmod = 0.95 end
    elseif (race == string.lower("Goblin")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 1.1 end
        if type == "psionic" then racialmod = 1.1 end
    elseif (race == string.lower("Halfling")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("Half-Elf")) then
        if type == "arcane" then racialmod = 0.94 end
        if type == "divine" then racialmod = 0.95 end
        if type == "psionic" then racialmod = 0.95 end
    elseif (race == string.lower("Half-Orc")) then
        if type == "arcane" then racialmod = 1.05 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1.05 end
    elseif (race == string.lower("Harpy")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1.15 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("Human")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("Imp")) then
        if type == "arcane" then racialmod = 1; print("Please confirm value for Imp with alias: spellcostcheck") end
        if type == "divine" then racialmod = 1; print("Please confirm value for Imp with alias: spellcostcheck") end
        if type == "psionic" then racialmod = 1; print("Please confirm value for Imp with alias: spellcostcheck") end
    elseif (race == string.lower("Kobold")) then
        if type == "arcane" then racialmod = 1.3 end
        if type == "divine" then racialmod = 1.3 end
        if type == "psionic" then racialmod = 1.3 end
    elseif (race == string.lower("Kzinti")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("Lizard Man")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 0.95 end
    elseif (race == string.lower("Ogre")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1.1 end
    elseif (race == string.lower("Orc")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1.1 end
    elseif (race == string.lower("Troglodyte")) then
        if type == "arcane" then racialmod = 1.25 end
        if type == "divine" then racialmod = 1.25 end
        if type == "psionic" then racialmod = 1.225 end
    elseif (race == string.lower("Demonseed")) then
        if type == "arcane" then racialmod = 0.87 end
        if type == "divine" then racialmod = 0.9 end
        if type == "psionic" then racialmod = 0.9 end
    elseif (race == string.lower("Dragon")) then
        if type == "arcane" then racialmod = 0.9 end
        if type == "divine" then racialmod = 0.9 end
        if type == "psionic" then racialmod = 0.85 end
    elseif (race == string.lower("Drider")) then
        if type == "arcane" then racialmod = 0.98 end
        if type == "divine" then racialmod = 0.95 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("Gith")) then
        if type == "arcane" then racialmod = 0.95 end
        if type == "divine" then racialmod = 0.95 end
        if type == "psionic" then racialmod = 0.83 end
    elseif (race == string.lower("Golem")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1.1 end
        if type == "psionic" then racialmod = 1.1 end
    elseif (race == string.lower("Griffon")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 1 end
    elseif (race == string.lower("High Elf")) then
        if type == "arcane" then racialmod = 0.85 end
        if type == "divine" then racialmod = 0.85 end
        if type == "psionic" then racialmod = 0.8 end
    elseif (race == string.lower("Hobgoblin")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 1.1 end
        if type == "psionic" then racialmod = 1.05 end
    elseif (race == string.lower("Ignatur")) then
        if type == "arcane" then racialmod = 0.92 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 0.96 end
    elseif (race == string.lower("Minotaur")) then
        if type == "arcane" then racialmod = 1.25 end
        if type == "divine" then racialmod = 1.15 end
        if type == "psionic" then racialmod = 1.25 end
    elseif (race == string.lower("Miraar")) then
        if type == "arcane" then racialmod = 1 end
        if type == "divine" then racialmod = 1 end
        if type == "psionic" then racialmod = 0.9 end
    elseif (race == string.lower("Sprite")) then
        if type == "arcane" then racialmod = 0.75 end
        if type == "divine" then racialmod = 0.75 end
        if type == "psionic" then racialmod = 0.75 end
    elseif (race == string.lower("Troll")) then
        if type == "arcane" then racialmod = 1.1 end
        if type == "divine" then racialmod = 1.15 end
        if type == "psionic" then racialmod = 1.15 end
    elseif (race == string.lower("Tuataur")) then
        if type == "arcane" then racialmod = 0.9 end
        if type == "divine" then racialmod = 0.9 end
        if type == "psionic" then racialmod = 0.8 end
    else
      error("Unknown race: " .. race)
      return -1     
    end
    
    return racialmod
  
end


function GetSpellCostMod(type)

  local classmod = 1
    
  if (gmcp.Char.Status.class == "Druid") then classmod = 0.85 end
  
  return GetSpellCostModRacial(gmcp.Char.Status.race,type) * GetSpellCostModWorship() * classmod
  
end


function GetSkillLagMod()
  return 1
end

-- AltList.TriggerWorship = AltList.TriggerWorship or nil
--if AltList.TriggerWorship then
--  killTrigger(AltList.TriggerWorship )
--end

--AltList.TriggerWorship = tempRegexTrigger("^You are \d+ years old \(\d+ real life hours?\) and a (?<devoted>devoted worshipper|worshipper) of (?<worship>.*).$", [[AltList.UpdateWorship(matches.worship, (matches.devoted == "devoted worshipper" and true or false))]]) 