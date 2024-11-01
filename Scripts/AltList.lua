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
    AltList.Chars[char_name].Current_HP = 0
    AltList.Chars[char_name].Current_MP = 0
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
    -- prevent AltList.UpdateInsigs from overwriting Lord insigs with Legend insigs
    if gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.level and tonumber(gmcp.Char.Status.level) > 125 then
      return
    end
    AltList.Chars[char_name].Race = gmcp.Char.Status.race
    AltList.Chars[char_name].Class = gmcp.Char.Status.class
    AltList.Chars[char_name].Level = tonumber(gmcp.Char.Status.level)
    AltList.Chars[char_name].SubLevel = tonumber(gmcp.Char.Status.sublevel)
    AltList.Chars[char_name].Max_HP = tonumber(gmcp.Char.Vitals.maxhp)
    AltList.Chars[char_name].Max_MP = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 0 or tonumber(gmcp.Char.Vitals.maxmp)
    AltList.Chars[char_name].Current_HP = tonumber(gmcp.Char.Vitals.hp)
    AltList.Chars[char_name].Current_MP = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 0 or tonumber(gmcp.Char.Vitals.mp)
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

function AltList.UpdateQP(QP, char_name)
  local char_name = char_name or AltList.GetCharName()
  AltList.PlayerExists(char_name)
  AltList.Chars[char_name].QP = tonumber(QP)
  AltList.Save()
end

function AltList.UpdateInsigs(tbl_Insigs)
  -- prevent AltList.UpdateInsigs from overwriting Lord insigs with Legend insigs
  if gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.level and tonumber(gmcp.Char.Status.level) > 125 then
    return
  end

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

-- Define a helper function to use the appropriate unpack function based on Lua version
function AltList.SafeUnpack(tbl)
  if table.unpack then
    return table.unpack(tbl) -- Lua 5.2 and later
  else
    return unpack(tbl) -- Lua 5.1 (older versions)
  end
end


function AltList.FormatReportXCol(num_of_columns, tblColSizes, title, tblReport, showCmdColour, totalReport)
  if type(title) ~= "string" or type(tblReport) ~= "table" or type(tblColSizes) ~= "table" or type(num_of_columns) ~= "number" then
    error("Invalid inputs (expected string, number, table, table)")
    return false
  end

  if #tblReport == 0 then
    error("tblReport is empty")
    return
  end

  -- Validate that the number of column sizes matches the number of columns
  if #tblColSizes ~= num_of_columns then
    error("The number of column sizes does not match the specified number of columns")
    return false
  end
  
  local totalColSize = 0

  -- Construct the format string dynamically based on the column sizes
  local lineFormat = "<%s>"
  for i = 1, num_of_columns do
    lineFormat = lineFormat .. "%" .. tblColSizes[i] .. "s"
    tblColSizes[i] = math.abs(tblColSizes[i])
    totalColSize = totalColSize + tblColSizes[i]
  end
  lineFormat = lineFormat .. "\n"

  local lineColour = showCmdColour or "white"

  -- Print the title and separator line
  cecho("<" .. lineColour .. ">" .. title .. "\n")
  cecho("<" .. lineColour .. ">" .. string.rep("-", totalColSize) .. "\n")

  -- Print the report's header (assumes first entry is header row)
  local headerRow = tblReport[1]
  local headerArgs = {}
  for i = 1, num_of_columns do
    headerArgs[#headerArgs + 1] = headerRow[i] or ""
  end
  cecho(string.format(lineFormat, lineColour, AltList.SafeUnpack(headerArgs)))
  table.remove(tblReport, 1)
  cecho("<" .. lineColour .. ">" .. string.rep("-", totalColSize) .. "\n")

  -- Print each row in the report
  for _, row in ipairs(tblReport) do
    if row[1] == AltList.GetCharName() then
      lineColour = "yellow"
    else
      lineColour = showCmdColour or "white"
    end

    -- Prepare the values for each row
    local rowArgs = {}
    for i = 1, num_of_columns do
      rowArgs[#rowArgs + 1] = string.sub(row[i] or "", 1, tblColSizes[i] - 1)
    end

    cecho(string.format(lineFormat, lineColour, AltList.SafeUnpack(rowArgs)))
  end
  
  lineColour = showCmdColour or "white"
  
  if totalReport then
    cecho("<" .. lineColour .. ">" .. string.rep("-", totalColSize) .. "\n")
    cecho(string.format("<%s>%-" .. (totalColSize - tblColSizes[#tblColSizes]) .. "s%" .. tblColSizes[#tblColSizes] .. "s\n", lineColour, "Total:", format_int(totalReport)))
  end

  -- Print the final separator line
  cecho("<" .. lineColour .. ">" .. string.rep("-", totalColSize) .. "\n")
end

function AllegTableSort(a, b)
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
  local debug_timer = os.clock()
  AltList.AllegUpdateAll()
  
  local Available = {}
  local Request = {}
  local Tomorrow = {}
  local TwoDays = {}
  
  for char_name,_ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Level >= 125 then 
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
        table.insert(Request, char_name)      
      end
    end
  end
  
  if #Request == 0 and #Available == 0 and #Tomorrow == 0 and #TwoDays == 0 then
    print("No Alleg Report available")
    return
  end
  
  table.sort(Available, AllegTableSort)
  table.sort(Tomorrow, AllegTableSort)
  table.sort(TwoDays, AllegTableSort)
  table.sort(Request, AllegTableSort)
  
  local tblAllegReport = {}
  
  table.insert(tblAllegReport, {"Character", "Alleg Item/Status", "Who has it? (Ttl)", "Insignia"}) 

  if #Request > 0 then
    for _,y in pairs(Request) do
      local item_name = AltList.Chars[y].Alleg.Request
      local item_report = InventoryList.Search(InventoryList.Items, item_name) -- note: adds about 0.25s to processing time when player has 24 items o/s
      if InventoryList.HaveItem(item_name) then
        table.insert(tblAllegReport, {y, item_name, item_report[1][1] .. " (" .. #item_report .. ")" , AltList.Chars[y].Alleg.Insig})
      else
        table.insert(tblAllegReport, {y, item_name, "", AltList.Chars[y].Alleg.Insig})
      end
    end
  end
  if #Available > 0 then
    for _,y in pairs(Available) do
      table.insert(tblAllegReport, {y, "Available", "", AltList.Chars[y].Alleg.Insig})
    end
  end
  if #Tomorrow > 0 then
    for _,y in pairs(Tomorrow) do
      table.insert(tblAllegReport, {y, "Tomorrow " .. (AltList.Chars[y].Alleg.Cleared and "(Cleared)" or "(Give Up)"), "", AltList.Chars[y].Alleg.Insig})
    end
  end
  if #TwoDays > 0 then
    for _,y in pairs(TwoDays) do
      table.insert(tblAllegReport, {y, "Two Days (Give Up)", "", AltList.Chars[y].Alleg.Insig})
    end
  end
  
  AltList.FormatReportXCol(4, {-20, -35, -20, -20}, "Alleg Report", tblAllegReport)
  if #Available > 0 then cecho("<white>" .. #Available .. " alts available to turn in rubies\n") end
    if GlobalVar.Debug then
    printMessage("DEBUG", string.format("AltList.ReportAlleg() ran in %.2f seconds (with %d items)\n", (os.clock() - debug_timer), #Request))
  end
  
end

function AltList.ReportNextAvailableAlleg()
  AltList.AllegUpdateAll()
  
  local Available = {}
  
  for char_name,_ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Level == 125 and AltList.Chars[char_name].Alleg.Request == "Available" and char_name ~= AltList.GetCharName() then 
        table.insert(Available, char_name)
    end
  end
  
  table.sort(Available, AllegTableSort)

  if #Available == 0 then
    printMessage("Alleg", "Completed on all characters", "yellow", "white")
  else
    printMessage("Alleg", "Next available character: " .. Available[1], "yellow", "white")
  end
end

function AltList.ReportGold()
  local tblCharReport = {}
  local totalGold = 0
  
  -- Collect characters with gold and sum up the total
  for char_name, _ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Gold > 0 then
      table.insert(tblCharReport, {char_name, AltList.Chars[char_name].Gold})
      totalGold = totalGold + AltList.Chars[char_name].Gold
    end
  end
  
  -- Sort characters by gold amount in descending order
  table.sort(tblCharReport, function(a, b) return a[2] > b[2] end)
  
  for _,tblChar in pairs(tblCharReport) do
    tblChar[2] = format_int(tblChar[2])
  end
  
  -- Add a header row
  table.insert(tblCharReport, 1, {"Character", "Gold"})
  
  -- Call the formatting function with 2 columns, each of width 20
  AltList.FormatReportXCol(2, {-20, 20}, "Gold Report", tblCharReport, nil, totalGold)
end

function AltList.ReportQP()
  local tblCharReport = {}
  local totalQP = 0

  -- Collect characters with QP and sum up the total
  for char_name, _ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].QP > 0 then
      table.insert(tblCharReport, {char_name, AltList.Chars[char_name].QP})
      totalQP = totalQP + AltList.Chars[char_name].QP
    end
  end

  -- Sort characters by QP in descending order
  table.sort(tblCharReport, function(a, b) return a[2] > b[2] end)
  table.insert(tblCharReport, 1, {"Character/Token", "QP"})

  -- Define the token denominations
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
    {"Fae Rune For 'Fire'", 5},
    {"Fae Rune For 'Disease'", 5},
    {"Fae Rune For 'Despair'", 10},
    {"Fae Rune For 'Enslavement'", 12},
    {"Fae Rune For 'Destruction'", 12},
    {"Orderly Dragon Scale", 5},
  }

  -- Collect token information and add to the report
  for _, token_tbl in pairs(QPtoken_denom) do 
    local QPtoken_name = token_tbl[1]
    local denom = token_tbl[2]
    local QPtoken = InventoryList.ItemsOnHand(QPtoken_name)
    
    if QPtoken > 0 then
      table.insert(tblCharReport, {QPtoken_name .. " x " .. QPtoken, QPtoken * denom})
      totalQP = totalQP + QPtoken * denom
    end
  end

  -- Call the report formatting function with 2 columns and the total QP
  AltList.FormatReportXCol(2, {-30, 10}, "QuestPoints (QP)", tblCharReport, nil, totalQP)
end

function AltList.ReportRegen(level)
  local tblCharReport = {}
  local tempReport = {} -- Temporary table to store character data and missing mana percentage

  assert(level > 0 and (level == 250 or level == 125 or level <= 51))

  for char_name, _ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Level == level then 
      if AltList.Chars[char_name].Current_HP and AltList.Chars[char_name].Current_MP then
        local current_HP = AltList.Chars[char_name].Current_HP
        local max_HP = AltList.Chars[char_name].Max_HP
        local current_MP = AltList.Chars[char_name].Current_MP
        local max_MP = AltList.Chars[char_name].Max_MP

        -- Check if HP or MP is less than 90%
        if (current_HP / max_HP < 0.9 or current_MP / max_MP < 0.9) then
          local hp_report = current_HP .. "/" .. max_HP
          local mp_report = current_MP .. "/" .. max_MP
          local missing_mana_percentage = (max_MP - current_MP) / max_MP
          table.insert(tempReport, {char_name, hp_report, mp_report, missing_mana_percentage})
        end
      end
    end
  end

  -- Sort tempReport in descending order of missing mana percentage
  table.sort(tempReport, function(a, b) return a[4] > b[4] end)

  -- Insert sorted data into tblCharReport
  for _, report in ipairs(tempReport) do
    table.insert(tblCharReport, {report[1], report[2], report[3]})
  end

  -- Add header to the report
  table.insert(tblCharReport, 1, {"Character", "Hit Points", "Mana"})

  -- Call the format function with the new format specifications
  AltList.FormatReportXCol(3, {-20, -20, -20}, "Regen Report (Level: " .. level .. ")", tblCharReport)
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

  -- Count the insignias for characters at level 125
  for char_name, _ in pairs(AltList.Chars) do
    if AltList.Chars[char_name].Level == 125 then
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

  -- Collect insignia counts into the report
  for _, insig in ipairs({"Scratcher", "Busybody", "Deed Doer", "Goto Guy/Gal/Person", "Feat Finisher", "Task Master"}) do
    local count = InsigCount[insig]
    if count > 0 then
      table.insert(tblCharReport, {insig, count})
    end
  end

  -- Add header to the report
  table.insert(tblCharReport, 1, {"Alleg Level", "Quantity"})

  -- Call the format function with the new format specifications
  AltList.FormatReportXCol(2, {-20, 20}, "Alleg Insig Report", tblCharReport, nil, TotalCount)
end

function AltList.ReportInventorySpace(top_x)
  -- inspired by sumnissan's lack of inventory management
  top_x = top_x or 5
  
  -- ensure that top_x is a number
  if type(top_x) ~= "number" then
    error("AltList.ReportInventorySpace(top_x): top_x must be a number")
    return false
  end

  local tblCharReportHero = {} -- for characters Level 51
  local tblCharReportLord = {} -- for characters Level 125

  for char_name, _ in pairs(AltList.Chars) do
    local freeItems = AltList.Chars[char_name].MaxItems - AltList.Chars[char_name].Items
    local freeWeight = AltList.Chars[char_name].MaxWeight - AltList.Chars[char_name].Weight
    local level = AltList.Chars[char_name].Level

    if level == 51 then
      table.insert(tblCharReportHero, {char_name, freeWeight, freeItems})
    elseif level == 125 then
      table.insert(tblCharReportLord, {char_name, freeWeight, freeItems})
    end
  end

  -- Determine if reverse sort is needed
  local ascending = top_x < 0
  top_x = math.abs(top_x)  -- Convert top_x to positive for sorting
  
  -- Sort the tables based on free weight
  if ascending then 
    table.sort(tblCharReportHero, function(a, b) return a[2] < b[2] end)
    table.sort(tblCharReportLord, function(a, b) return a[2] < b[2] end)
  else
    table.sort(tblCharReportHero, function(a, b) return a[2] > b[2] end)
    table.sort(tblCharReportLord, function(a, b) return a[2] > b[2] end)
  end

  
  -- Trim the reports to top_x
  while #tblCharReportHero > top_x + 1 do
    table.remove(tblCharReportHero)
  end

  while #tblCharReportLord > top_x + 1 do
    table.remove(tblCharReportLord)
  end

  -- Add headers
  table.insert(tblCharReportHero, 1, {"Heroes", "Free Weight", "Free Items"})
  table.insert(tblCharReportLord, 1, {"Lords", "Free Weight", "Free Items"})

  if #tblCharReportLord == 1 and #tblCharReportHero == 1 then
    printMessage("Inventory Space Report Error", "You have no lords or heroes on your altlist. Try logging in with your other alts first")
    return
  end
  
  -- Print the inventory space report using the new format
  cecho("\n<white>Inventory Space Report")
  if #tblCharReportLord > 1 then
    AltList.FormatReportXCol(3, {-20, 15, 15}, " ", tblCharReportLord) 
  end
  if #tblCharReportHero > 1 then
    AltList.FormatReportXCol(3, {-20, 15, 15}, " ", tblCharReportHero) 
  end
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