-- Trigger: Alleg - Lock 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You give (.*) to Allegaagse.$

-- Script Code:
--print("\nAlleg lock called (" .. matches[2] .. ")")
if matches[2] == "a ruby" then
  AltList.GivenAllegRuby = true
else
  AltList.GivenAllegItem = true
end