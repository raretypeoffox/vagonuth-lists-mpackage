-- Alias: AltList Reports
-- Attribute: isActive

-- Pattern: ^(?i)rep(qp|gold|alleg|vault|thief|insig|inv|invr|locker|regen)\b\s*(.*)$

-- Script Code:
local cmd = string.lower(matches[2])
local args = matches[3]

if cmd == "qp" then
  AltList.ReportQP()
elseif cmd == "gold" then
  AltList.ReportGold()
elseif cmd == "alleg" then
  AltList.ReportAlleg()
elseif cmd == "vault" then
  InventoryList.VaultHunter(args)
elseif cmd == "thief" then
  InventoryList.ThiefHunter()
elseif cmd == "insig" then
  AltList.ReportInsig()
elseif cmd == "inv" then
  AltList.ReportInventorySpace()
elseif cmd == "invr" then
  AltList.ReportInventorySpace(-5)
elseif cmd == "locker" then
  InventoryList.ReportLockers()
elseif cmd == "regen" then
  AltList.ReportRegen(125)
end