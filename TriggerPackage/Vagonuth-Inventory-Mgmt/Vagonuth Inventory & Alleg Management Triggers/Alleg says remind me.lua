-- Trigger: Alleg says remind me 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Allegaagse says 'If you don't remember the task just say REMIND ME.'

-- Script Code:
if AltList.GivenAllegRuby then
  TryAction("say remind me", 2)
  TryAction("get ruby", 2)
end