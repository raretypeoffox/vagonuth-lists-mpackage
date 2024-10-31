-- Trigger: Alleg - Gave Up 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Allegaagse says 'Feel free to continue paying me for my time though.'

-- Script Code:
if AltList.GivenAllegRuby then 
  AltList.GivenAllegRuby = false
  AltList.AllegRecordGiveUp()
  print("\n")
  AltList.ReportNextAvailableAlleg()
end