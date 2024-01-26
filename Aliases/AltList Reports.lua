-- Alias: AltList Reports
-- Attribute: isActive

-- Pattern: ^(?i)rep(qp|gold|alleg|vault|thief|insig|inv|locker)$

-- Script Code:
if matches[2] == "qp" then
  AltList.ReportQP()
elseif matches[2] == "gold" then
  AltList.ReportGold()
elseif matches[2] == "alleg" then
  AltList.ReportAlleg()
elseif matches[2] == "vault" then
  InventoryList.VaultHunter()
elseif matches[2] == "thief" then
  InventoryList.ThiefHunter()
elseif matches[2] == "insig" then
  AltList.ReportInsig()
elseif matches[2] == "inv" then
  AltList.ReportInventorySpace()
elseif matches[2] == "locker" then
  InventoryList.ReportLockers()
end