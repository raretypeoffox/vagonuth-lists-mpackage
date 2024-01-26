-- Trigger: On Insig 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Your insignia:

-- Script Code:

if not OnInsig.isOpen then   -- this checks for the first line, and initializes your variables
   OnInsig.len = 1
   OnInsig.isOpen = true
   if not OnInsig.Lock then OnInsig.InsigArray = {} end
end

OnInsig.len = OnInsig.len + 1   -- this keeps track of how many lines the trigger is capturing

if not OnInsig.IsPrompt(line) then
  OnInsig.ArrayAddLine(line)
else
  OnInsig.ArrayFinish()
  OnInsig.len = 0
  OnInsig.isOpen = false
end

setTriggerStayOpen("On Insig",OnInsig.len)   -- this sets the number of lines for the trigger to capture

