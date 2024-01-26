-- Alias: InventoryList Aliases
-- Attribute: isActive

-- Pattern: ^(?i)(isearch|icount|isearchex|icountex|isearchlvl|icountlvl|iupdate|idownload|ihelp)\b\s*(.*)$

-- Script Code:
local cmd = string.lower(matches[2])
local args = matches[3]


if cmd == "iupdate" then
  InventoryList.UpdateItems("inv", true)
  
elseif cmd == "isearch" then
  if args ~= "" then
    InventoryList.SearchReport(args)
  else
    print("Syntax: isearch <item name>\twill search inventory list for item name")
  end
elseif cmd == "isearchex" then
  if args ~= "" then
    char_name, item_name = args:match("^(%S+)%s+(.*)$")
    if not item_name then print("Error: please provide two arguments\nSyntax: isearchex <charname> <item name>\n\twill search inventory list for item name on character level"); return; end
    InventoryList.SearchReport(item_name, char_name)
  else
    print("Syntax: isearchex <charname> <item name>\twill search inventory list (excluding charname) for item name")
  end
elseif cmd == "isearchlvl" then
  if args ~= "" then
    level, item_name = args:match("^(%S+)%s+(.*)$")
    if not item_name then print("Error: please provide two arguments\nSyntax: isearchlvl <level> <item name>\n\twill search inventory list for item name held by character level"); return; end
    InventoryList.SearchReportLevel(item_name, level)
  else
    print("Syntax: isearchlvl <level> <item name>\twill search inventory list for item name held by level")
  end 
elseif cmd == "icount" then
  if args ~= "" then
    InventoryList.CountReport(args)
  else
    print("Syntax: icount <item name>\twill count every item name in inventory list")
  end
elseif cmd == "icountex" then
  if args ~= "" then
    char_name, item_name = args:match("^(%S+)%s+(.*)$")
    if not item_name then print("Error: please provide two arguments\nSyntax: icountex <charname> <item name>\n\tCount every <item> in inventory list (excl. <char>)"); return; end
    InventoryList.CountReport(item_name, char_name)
  else
    print("Syntax: icountex <charname> <item name>\tCount every <item> in inventory list (excl. <char>)")
  end
elseif cmd == "icountlvl" then
  if args ~= "" then
    level, item_name = args:match("^(%S+)%s+(.*)$")
    if not item_name then print("Error: please provide two arguments\nSyntax: icountlvl <level> <item name>\n\tCount every <item> in inventory list with character level)"); return; end
    InventoryList.CountReportLevel(item_name, level)
  else
    print("Syntax: icountlvl <level> <item name>\tCount every <item> in inventory list with character level)")
  end
elseif cmd == "idownload" then
  VagoInv:UpdateVersion()

elseif cmd == "ihelp" then
  local ilist_cmds = {
    {"iupdate", "force inventory list to update manually"},
    {"", "note: iupdate runs every 15 mins in the background"},
    {"isearch <item>", "Searches inventory list for <item>"},
    {"icount <item>", "Count every <item> in inventory list"},
    {"isearchex <char> <item>", "Searches inventory list (excl. <char>) for <item>"},
    {"icountex <char> <item>", "Count every <item> in inventory list (excl. <char>)"},
    {"isearchlvl <level> <item name>", "Will search inventory list for item name held by level"},
    {"icountlvl <level> <item name>", "Count every <item> in inventory list with character level"},
    {"repinv", "Reports your characters with the most inventory space available"},
    {"replockers", "Reports which characters have lockers (to update: look in locker)"},
    --{"idownload", "Downloads the latest version of the package"},
    {"",""},
    {"repgold", "Reports your total gold across all characters"},
    {"repqp", "Reports your total QP across all characters"},
    {"repalleg", "Reports your alleg status across all characters"},
    {"repinsig", "Reports a summary of your alleg insigs"},
    {"repvault", "Reports how many vault treasure hunter items you have"},
    {"repthief", "Reports how many vault thief's bane items you have"},
  }
  showCmdSyntax("Inventory List Management Commands", ilist_cmds)
else
  error("Error in inventorylist alias, shouldn't be reached.")
end