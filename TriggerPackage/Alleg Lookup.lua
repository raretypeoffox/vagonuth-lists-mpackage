-- Trigger: Alleg Lookup 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Allegaagse says '(?<clue>.*)'$
-- 1 (regex): ^Allegaagse asks '(?<clue>.*)'$

-- Script Code:
if clue == "What do I need?"
   or clue == "Exactly what I wanted, thank you."
   or clue == "Here is something for your trouble."
   or clue == "Fine, I will find someone else to get that for me." 
   or clue == "Now go away. Maybe I will see if you can be useful some other time."
   or clue == "You have done such a good job that I have raised my estimation of your worth as a searcher."
   or clue == "Hah, \"seen\", get it?'" then return end
   
if AltList.GivenAllegRuby then 
  
  item, item_plane = findItemAndPlane(matches.clue)
  --print("DEBUG: Alleg Lookup (" .. matches.clue .. ")")
  
  if item and item_plane then
    printMessage("\nAlleg's request", item .. " (" .. item_plane .. ")", "yellow", "white")
    
    printGameMessage("Alleg's request", item .. " (" .. AltList.GetCharName() .. ")", "yellow")
    AltList.AllegRecordRequest(item)
    AltList.GivenAllegRuby = false
    
    if not InventoryList.SearchReport(item) then
     --print("Not found, consider giving up?")
    end
    
    AltList.ReportNextAvailableAlleg()
    raiseEvent("AllegRecordRequest")
  end
 end