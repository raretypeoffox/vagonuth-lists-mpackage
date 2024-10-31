-- Script: Inventory List
-- Attribute: isActive

-- Script Code:
-- Dependencies: 
-- + wait and wait line package installed
-- + Table and Array Functions: deepcopy(), TableSize()

InventoryList = InventoryList or {}
InventoryList.Items = InventoryList.Items or {}
InventoryList.Items._BagNames = InventoryList.Items._BagNames or {}

InventoryList.LoginName = InventoryList.LoginName or nil

OnLocker = OnLocker or {}
OnLocker.isOpen = OnLocker.isOpen or false
OnLocker.len = OnLocker.len or 0
OnLocker.LockerArray = OnLocker.LockerArray or {}


function InventoryList.Save()
  local location = getMudletHomeDir() .. "/InventoryList.lua"
  table.save(location, InventoryList.Items)
end

function InventoryList.Load()
  local location = getMudletHomeDir() .. "/InventoryList.lua"
  if io.exists(location) then
    table.load(location, InventoryList.Items)
  end
end

if TableSize(InventoryList.Items) <= 1 then InventoryList.Load() end
sendGMCP("Char.Group.List")
sendGMCP("Char.Status")
sendGMCP("Char.Vitals")

function InventoryList.GetCharName()
  sendGMCP("Char.Group.List")
  
  if InventoryList.LoginName then
    return InventoryList.LoginName
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

function RemoveColourCodes(name)
    -- Remove sequences that start with \27 followed by [ and then has one or more digits, a semicolon, again one or more digits and ends with an 'm'
    local stripped = string.gsub(name, "\27%[%d+;%d+m", "")

    -- Remove sequences that start with \27
    stripped = string.gsub(stripped, "\27", "")

    -- Remove squares that have |xX| colour stripAnsiCodes
    stripped = string.gsub(stripped,"|%w+|","")

    return stripped
end

-- request_items should be called externally with InventoryList.UpdateItems("inv", (true|false))
-- will call itself recursively to look in containers
-- optional arg is so that the container's name (rather than id number) is used when saving to the array
InventoryList.UpdateItemsLock = InventoryList.UpdateItemsLock or false
function InventoryList.UpdateItems(loc_type, echo, ...)
  if not Connected() then return end
  if gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.level and tonumber(gmcp.Char.Status.level) > 125 then
    if echo then cecho("<red>Inventory Manager doesn't track legendary items\n") end
    return
  end
  -- Will not allow iupdate to be called twice within 10 seconds
  if loc_type == "inv" then
    if InventoryList.UpdateItemsLock then return end
    InventoryList.UpdateItemsLock = true
    tempTimer(10, function() InventoryList.UpdateItemsLock = false end)
  end
  
  local char_name = InventoryList.GetCharName()
  
  InventoryList.Items[char_name] = InventoryList.Items[char_name] or {}
  
  -- Code that will only be run on the parent level call (and not the recursive calls)
  if loc_type == "inv" then
    -- Delete all the saved inventory since we're updating the list (except for lockers)
    for k, _ in pairs(InventoryList.Items[char_name]) do
      if k ~= "locker" then InventoryList.Items[char_name][k] = {} end
    end
    tempTimer(15, function() InventoryList.Save() end) 
  end
    
  coroutine.wrap(function()
    local timeout = 1
    local request = "Char.Items.Inv"
    local tmparray
    local tmpnamearray = {}
    
    assert(loc_type == "inv" or tonumber(loc_type)~= nil, "InventoryList.UpdateItems(): invalid args, should be inv or container id #")

    if tonumber(loc_type)~= nil then 
      request = "Char.Items.Contents " .. loc_type
    end

    repeat
      sendGMCP(request)
      timeout = timeout + 1
      wait(1)
    until (gmcp.Char.Items.List.location == loc_type or timeout >= 10)
    
    if (timeout >= 10) then
      -- Searching containers within containers (eg jeweled scabbard) causes a timeout, assuming mud doesn't allow it
      -- Can also timeout if too many items are in one container
      print("InventoryList.UpdateItems(): timed out after trying " .. timeout .. " times (once per second)" .. (arg.n == 1 and " " .. arg[1] or ""))
      print("InventoryList.UpdateItems(): can happen if too many items are in one container")
      
      
      return false
    else
      tmparray = deepcopy(gmcp.Char.Items.List.items)
      
      -- Remove colour codes from item names
      for _, y in ipairs(tmparray) do
        y.name = RemoveColourCodes(y.name)
      end
      
      -- Game doesn't seem to respond to a request of looking inside of a container that's already insider another container so we won't even try
      if (loc_type == "inv") then -- we'll only look at containers that are in our inventory and open
        if echo then print("Inventory Update: Looking in your inventory") end
        for _, y in ipairs(tmparray) do
          if y.type == "container" and y.state == "open" then
            if echo then print("Inventory Update: Looking in container " .. y.name) end
            InventoryList.UpdateItems(y.id, echo, y.name)
          end   
        end
      end 
      
      -- If we're looking in a bag, arg[1] will be the bag name. Save it to bag_list
      if arg.n == 1 then
        InventoryList.Items._BagNames[loc_type] = arg[1]
        InventoryList.Items[char_name][loc_type] = deepcopy(tmparray)
      else
        InventoryList.Items[char_name][loc_type] = deepcopy(tmparray)
      end
      if echo then print("Inventory Update: Finished updating items in " .. (loc_type == "inv" and "your inventory" or arg[1])) end
      return true
    end
    
  end)()
end

function InventoryList.Search(tbl, search)
  assert(type(search)=="string")
  search = string.lower(search)
  local locations = {}
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      for _, loc in ipairs(InventoryList.Search(v, search)) do
        table.insert(locations, {k, unpack(loc)})
      end
    elseif k == "name" and type(v) == "string" and string.find(string.lower(v), search, 1, true) then
      table.insert(locations, {v})
    end
  end
  return locations
end

function InventoryList.SearchReport(str, exclude_charname)
  local report = InventoryList.Search(InventoryList.Items, str)

  if #report == 0 then
    cecho("<red>No items by that name found!<reset>\n")
    return false
  end

  local exclude_name = exclude_charname and GMCP_name(exclude_charname) or nil

  for _, v in ipairs(report) do
    if not (exclude_name and v[1] == exclude_name) then
      local location = v[2] == "inv" and "inventory" or (v[2] == "locker" and "<blue>Locker<reset>") or ("bag <purple>" .. (InventoryList.Items._BagNames[v[2]] and InventoryList.Items._BagNames[v[2]] or v[2]) .. "<reset>")
      cecho("<white>" .. v[1] .. "<ansi_white> has <yellow>" .. v[4] .. "<ansi_white> in their " .. location .. "\n")
    end
  end

  return true
end

function InventoryList.SearchReportLevel(str, level)
  level = tonumber(level)
  if level == nil or level < 1 or level > 250 then
    cecho("<red>Please choose a level between 1 and 250\n")
    return
  end

  local report = InventoryList.Search(InventoryList.Items, str)
  
  if #report == 0 then
    cecho("<red>No items by that name found!<reset>\n")
    return false
  end
  
  for _, v in ipairs(report) do
    if not AltList.Chars[v[1]] then
      cecho("<red>Please login in with " .. v[1] .. " and run the \"score\" command\n")
    elseif AltList.Chars[v[1]].Level == level then
      local location = v[2] == "inv" and "inventory" or (v[2] == "locker" and "<blue>Locker<reset>") or ("bag <purple>" .. (InventoryList.Items._BagNames[v[2]] and InventoryList.Items._BagNames[v[2]] or v[2]) .. "<reset>")
      cecho("<white>" .. v[1] .. "<ansi_white> has <yellow>" .. v[4] .. "<ansi_white> in their " .. location .. "\n")
    end
  end

end


function InventoryList.QuickSearch(str)
  local report = InventoryList.Search(InventoryList.Items, str)
  
  if #report == 0 then return "" end

  return report[1][1]
end

function InventoryList.CountReport(str, exclude_charname)
  local report = InventoryList.Search(InventoryList.Items, str)
  if #report == 0 then print("No items by that name found!") ; return false end
  
  local exclude_name = exclude_charname and GMCP_name(exclude_charname) or nil

  local count_report = {}

  for _, v in ipairs(report) do
    if not (exclude_name and v[1] == exclude_name) then
      if count_report[v[4]] == nil then
        count_report[v[4]] = 1
      else
        count_report[v[4]] = count_report[v[4]] + 1
      end
    end
  end
  
  for k, v in pairs(count_report) do
    cecho("<white>" .. v .. "<ansi_white> x\t<yellow>" .. k .. "\n")
   end
end

function InventoryList.CountReportLevel(str, level)
  level = tonumber(level)
  if level == nil or level < 1 or level > 250 then
    cecho("<red>Please choose a level between 1 and 250\n")
    return
  end
  
  local report = InventoryList.Search(InventoryList.Items, str)
  if #report == 0 then print("No items by that name found!") ; return false end
  
  local count_report = {}

  for _, v in ipairs(report) do
    if not AltList.Chars[v[1]] then
      cecho("<red>Please login in with " .. v[1] .. " and run the \"score\" command\n")
    elseif AltList.Chars[v[1]].Level == level then
      if count_report[v[4]] == nil then
        count_report[v[4]] = 1
      else
        count_report[v[4]] = count_report[v[4]] + 1
      end
    end
  end
  
  for k, v in pairs(count_report) do
    cecho("<white>" .. v .. "<ansi_white> x\t<yellow>" .. k .. "\n")
   end
end

function InventoryList.HaveItem(str)
  local report = InventoryList.Search(InventoryList.Items, str)
  if #report == 0 then return false else return true end
end

function InventoryList.AddLocker(tbl)
  assert(type(tbl) == "table")
  local char_name = InventoryList.GetCharName()
  InventoryList.Items[char_name]["locker"] = {}
  InventoryList.Items[char_name]["locker"] = deepcopy(tbl)
  InventoryList.Save()
  return true
end

function InventoryList.ReportLockers()
  cecho("<white>Locker Report\n")
  cecho("<white>-----------------------------------------\n")
  
  local total = 0
  local name_list = {}
  for name, _ in pairs(InventoryList.Items) do
    if InventoryList.Items[name].locker and #InventoryList.Items[name].locker > 0 then
      table.insert(name_list, name)
      total = total + 1
    end
  end
  
  table.sort(name_list)
  
  for _, name in ipairs(name_list) do
    colour = "<white>"
    if name == InventoryList.LoginName then
      colour = "<yellow>"
    end
    cecho(colour .. name .. "\n")
  end
  
  cecho("<white>-----------------------------------------\n")
  cecho("<white>Total: " .. total .. "\n")
  cecho("<white>-----------------------------------------\n")

end

function InventoryList.ItemsOnHand(str)
  local report = InventoryList.Search(InventoryList.Items, str)
  return #report
end

local VaultHunter = {
["Orb Of Bravery"] = 5,
["Astral Powder"] = 5,
["Crown of Crystal"] = 2,
["Treaty Of Purity Of Faith"] = 3,
["Amulet of the Cat's Eye"] = 3,
["Green Silken Sarong"] = 3,
["Jade Bracer"] = 1,
["Rod Of The Wicked Rulers"] = 2,
["Necklace Of Severed Fae Ears"] = 2,
["Silver Iguana"] = 1,
["Floating Circle of Books"] = 2,
["Amulet of Guiding Wind"] = 1,
["Orb Of Gith"] = 3,
["Armband Of The Unseen"] = 1,
["Exaltra's Mirror"] = 1,
["Naeadonna's Choker"] = 1,
["Yorimandil's Blindfold"] = 1,
["Sandblasted Emerald"] = 2,
["Majestre's Crop"] = 1

}

function InventoryList.VaultHunter(char_name)
  local tblReport = {{"Item", "Who has it?", "On Hand (Req'd)"}}
  
  local InventorySearchTable = InventoryList.Items
  if char_name and char_name ~= "" and InventoryList.Items[string.lower(char_name):gsub("^%l", string.upper)] then
    InventorySearchTable = InventoryList.Items[string.lower(char_name):gsub("^%l", string.upper)]
  else
    char_name = nil
  end
    

  for item_name, num_reqd in pairs(VaultHunter) do
    local itemsReport = InventoryList.Search(InventorySearchTable, item_name)
    local x = #itemsReport .. " (" .. num_reqd .. ")"

    -- Determine the color based on the required amount
    if #itemsReport  >= num_reqd then
      x = "    <green>" .. x
    else
      x = "    <yellow>" .. x
    end

    if #itemsReport > 0 then
      table.insert(tblReport, {item_name, (char_name and string.lower(char_name):gsub("^%l", string.upper) or itemsReport[1][1]), x})  -- Report the first character who has the item
    else
      table.insert(tblReport, {item_name, "", x})  -- No character has it
    end
  end

  -- Call FormatReportXCol with appropriate arguments, using nil for color
  AltList.FormatReportXCol(3, {-35, -20, -20}, "Vault Hunter Report", tblReport, nil)
end

function InventoryList.ThiefHunter()
  local ThiefHunter = {
    ["glazed gith hide"] = 1,
    ["soft nubuc hide"] = 1,
    ["embossed hide"] = 1,
    ["whole hide of a merman"] = 1,
    ["hide of an unlucky human"] = 1  
  }
  
  local tblReport = {{"Item", "Who has it?", "On Hand (Req'd)"}}

  for item_name, num_reqd in pairs(ThiefHunter) do
    local itemsReport = InventoryList.Search(InventoryList.Items, item_name)
    local x = #itemsReport .. " (" .. num_reqd .. ")"
    
    -- Determine the color based on the required amount
    if #itemsReport >= num_reqd then
      x = "    <green>" .. x
    else
      x = "    <yellow>" .. x
    end
    
    if itemsReport and #itemsReport > 0 then
      table.insert(tblReport, {item_name, itemsReport[1][1], x})
    else
      table.insert(tblReport, {item_name, "", x})
    end
  end

  -- Call FormatReportXCol with appropriate arguments, using nil for color
  AltList.FormatReportXCol(3, {-30, -20, -20}, "Thief Hunter Report", tblReport)
end


function moveItemsBetweenBags(BagOne, BagTwo)
    local BagOne = BagOne or "2.vault"
    local BagTwo = BagTwo or "vault"

    local function moveItem(item, quantity)
        for i = 1, quantity do
            send("get '" .. item .. "' " .. BagOne)
            send("put '" .. item .. "' " .. BagTwo)
        end
    end

    for item_name, quantity in pairs(VaultHunter) do
        local keyword
        if item_name == "Orb Of Bravery" then
            keyword = "bravery"
        elseif item_name == "Orb Of Gith" then
            keyword = "gith"
        elseif item_name == "Amulet of Guiding Wind" then
            keyword = "guiding"
        elseif item_name == "Amulet of the Cat's Eye" then
            keyword = "cat eye"
        elseif item_name == "Silver Iguana" then
            keyword = "silver iguana"
        else
            keyword = string.lower(item_name:match("^([^%s']+)'?"))
        end

        moveItem(keyword, quantity)
    end
end

function turnInTreasureHunter()
  coroutine.wrap(function()   
    for item_name, quantity in pairs(VaultHunter) do
        local keyword
        if item_name == "Orb Of Bravery" then
            keyword = "bravery"
        elseif item_name == "Orb Of Gith" then
            keyword = "gith"
        elseif item_name == "Amulet of Guiding Wind" then
            keyword = "guiding"
        elseif item_name == "Amulet of the Cat's Eye" then
            keyword = "cat"
        else
            keyword = string.lower(item_name:match("^([^%s']+)'?"))
        end
  
        for i = 1, quantity do
          send("give " .. keyword .. " demon")
          wait(5.5)
        end
    end

  end)()
end

function splitArgumentIntoTwo(input)
    local arg1, arg2

    -- Check for both "words" enclosed in single quotes
    local match1, match2 = input:match("^'(.-)'%s+'(.-)'$")
    if match1 and match2 then
        arg1 = "'" .. match1 .. "'"
        arg2 = "'" .. match2 .. "'"
    else
        -- Check for the pattern with the first "word" in single quotes
        match1, match2 = input:match("^'(.-)'%s+(%S+)$")
        if match1 and match2 then
            arg1 = "'" .. match1 .. "'"
            arg2 = match2
        else
            -- Check for the pattern with the second "word" in single quotes
            match1, match2 = input:match("^(%S+)%s+'(.-)'$")
            if match1 and match2 then
                arg1 = match1
                arg2 = "'" .. match2 .. "'"
            else
                -- Check for the pattern with exactly two words
                match1, match2 = input:match("^(%S+)%s+(%S+)$")
                if match1 and match2 then
                    arg1 = match1
                    arg2 = match2
                else
                    -- Return an error if neither pattern matches
                    return nil, "Invalid input format. Use two words or enclose multiple words in single quotes."
                end
            end
        end
    end

    return arg1, arg2
end
