-- Trigger: Alleg Clear 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Allegaagse says 'Exactly what I wanted, thank you.'
-- 1 (start of line): Allegaagse says 'You have done such a good job that I have raised my estimation of your worth as a searcher.'

-- Script Code:
--You give an aurora bow to Allegaagse.                                            [ALLEG - Medium]

--<7738/7738hp 24763/24839ma 12361v 796> 0 lag - - surge off 

--Allegaagse says 'Exactly what I wanted, thank you.'
--Allegaagse says 'Here is something for your trouble.'
--You have received an award of 5 practice points!

if AltList.GivenAllegItem then
  AltList.AllegRecordCleared()
  send("insig", false)
  AltList.GivenAllegItem = false
end

--Allegaagse says 'You have done such a good job that I have raised my estimation of your worth as a searcher.'
