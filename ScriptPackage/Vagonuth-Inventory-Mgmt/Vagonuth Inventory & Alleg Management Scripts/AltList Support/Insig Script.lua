-- Script: Insig Script
-- Attribute: isActive

-- Script Code:
OnInsig = OnInsig or {}
OnInsig.isOpen = OnInsig.isOpen or false
OnInsig.len = OnInsig.len or 0
OnInsig.InsigArray = OnInsig.InsigArray or {}

OnInsig.Lock = OnInsig.Lock or false

function OnInsig.IsPrompt(line)
    -- for insig, just looking for the empty line should work
    if line == "" then return true else return false end
    -- Note: if you're using a prompt that is not the standard prompt from setup, you'll need to edit this line so that this regex matches your prompt (test at regex101.com)
    --local pattern = "^(.*)<(%d+)/(%d+)hp (%d+)/(%d+)ma (%d+)v (%d+)> (%d+)"
    --print(string.match(line, pattern))
    --return string.match(line, pattern) ~= nil
end

function OnInsig.ArrayAddLine(line)
  if OnInsig.Lock then return end
  line = string.gsub(line, '^%s*(.-)%s*$', '%1') -- remove leading and trailing white space
  table.insert(OnInsig.InsigArray,line)
end

function OnInsig.ArrayFinish()
  if OnInsig.Lock then return end
  
  table.remove(OnInsig.InsigArray,1) -- remove's first line, i.e., Your playerinfo is:
  --table.remove(OnInsig.InsigArray, #OnInsig.InsigArray) -- removes last line (empty line, before the prompt)
  
  OnInsig.Lock = true
  OnInsig.Write()
end


function OnInsig.Write()
  AltList.UpdateInsigs(OnInsig.InsigArray)
  OnInsig.Lock = false
end