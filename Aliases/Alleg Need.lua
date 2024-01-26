-- Alias: Alleg Need
-- Attribute: isActive

-- Pattern: ^(?i)alleg(need|clear)\b\s*(.*)$

-- Script Code:
local cmd = string.lower(matches[2])
local args = matches[3]


if cmd == "need" then
  AltList.AllegNeeded((args ~= "" and args or nil))
elseif cmd == "clear" then
  if args ~= "" then
    AltList.AllegRecordCleared(args)
  else
    print("Syntax: allegclear <char name>\tmarks the character as completed their alleg")
  end
else
  error("Error in alleg alias, shouldn't be reached.")
end