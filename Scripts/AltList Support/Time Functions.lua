-- Script: Time Functions
-- Attribute: isActive

-- Script Code:
function getServerTime(TimeZone)
  if not TimeZone then send("time", false); return os.time() end -- if "time" has never been used, will need to run it the first time

  local local_time = os.time()
  local server_time = local_time - (TimeZone * 3600)
  
  return server_time
end

function calculateDaysBetweenTimes(Time1, Time2)
    -- Get the number of seconds in a day
    local secondsInDay = 24 * 60 * 60

    -- Calculate the absolute time difference in seconds
    local timeDifference = math.abs(Time2 - Time1)

    -- Calculate the number of full days between the two timestamps
    local days = math.floor(timeDifference / secondsInDay)

    -- Check if Time1 is ahead of Time2 (past midnight)
    local date1 = os.date("*t", Time1)
    local date2 = os.date("*t", Time2)

    -- Convert both dates to the same day before performing the comparison
    local sameDayTime1 = os.time({year=date2.year, month=date2.month, day=date2.day, hour=date1.hour, min=date1.min, sec=date1.sec})

    if sameDayTime1 > Time2 then
        -- Adjust days count if Time1 is past midnight
        days = days + 1
    end

    return days
end

function IsMDAY()
  assert(AltList.TimeZone)
  return (os.date('%d', getServerTime(AltList.TimeZone)) == "06")
end

