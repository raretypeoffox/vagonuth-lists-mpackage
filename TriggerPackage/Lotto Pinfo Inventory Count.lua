-- Trigger: Lotto Pinfo Inventory Count 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^ ?\b\d{1,2}\b\.? (\*|\+|\-|\$|\@)? ?(?<item>.+?)(?:\s+\(\d+\))?$
-- 1 (regex): ^#\d+ \(x\d+\) (?<item>.*)

-- Script Code:
-- Zaffer's format:
--  1 * a shaleskin arm guard (3) 
-- Hydro's format:
-- 2. a sandblasted emerald

--print(matches[1])

local items_owned = 0
items_owned = InventoryList.ItemsOnHand(matches.item)
--print(matches.item)

if items_owned > 0 then
  deleteLine()
  cecho("<ansi_yellow>" .. matches[1] .. " " .. "<yellow>[Owned: " .. items_owned .. "]\n")
  cecho("\n")
--else
  --cecho("<ansi_yellow>" .. line .. "\n")
--  cecho("<ansi_yellow>" .. line .. " " .. "<yellow>[None]\n")
--  echo("\n")
end