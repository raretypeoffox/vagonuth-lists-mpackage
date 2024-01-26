-- Trigger: On Locker 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (regex): ^Your locker contains (\d+) items:

-- Script Code:

if not OnLocker.isOpen then   -- this checks for the first line, and initializes your variables
   OnLocker.len = 1
   OnLocker.isOpen = true
   OnLocker.LockerArray = {}
end

OnLocker.len = OnLocker.len + 1   -- this keeps track of how many lines the trigger is capturing

if line ~= "" then
  local locker_item = string.match(line, "%d+  (.+)")
  if locker_item ~= nil then 
    locker_item = string.gsub(locker_item, '^%s*(.-)%s*$', '%1')
    table.insert(OnLocker.LockerArray,{name = locker_item})
  end
else  
   InventoryList.AddLocker(OnLocker.LockerArray)
   OnLocker.len = 0
   OnLocker.isOpen = false
end

setTriggerStayOpen("On Locker",OnLocker.len)   -- this sets the number of lines for the trigger to capture



