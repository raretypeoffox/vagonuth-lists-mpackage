-- Trigger: Server time 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^The System time \(EST\) is currently:           (?<time>.*)$

-- Script Code:
-- This trigger will calculate the timezone difference between the server and the player whenever the "time" command is used
-- It'll save this difference between different play sessions

-- Function to convert date string to seconds since epoch (Unix timestamp)
local function convertToTimestamp(dateStr)
    -- Define month names and their numeric representations
    local monthNames = {
        Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
        Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12
    }

    -- Extract date components from the string
    local day, monthName, dayOfMonth, time, year = dateStr:match("(%a+) (%a+)  ?(%d+) (%d+:%d+:%d+) (%d+)")

    -- Get the numeric month value
    local month = assert(monthNames[monthName], "Invalid month name")

    -- Extract time components
    local hour, minute, second = time:match("(%d+):(%d+):(%d+)")

    -- Create a date table with the extracted components
    local dateTable = {
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(dayOfMonth),
        hour = tonumber(hour),
        min = tonumber(minute),
        sec = tonumber(second)
    }

    -- Calculate the Unix timestamp (seconds since epoch)
    local timestamp = os.time(dateTable)

    return timestamp
end

-- some timezones are 30 mins off (eg Newfoundland, India)
local function roundToNearestHalf(number)
    local floorValue = math.floor(number)
    local fractionalPart = number - floorValue

    if fractionalPart < 0.25 then
        return floorValue
    elseif fractionalPart < 0.75 then
        return floorValue + 0.5
    else
        return floorValue + 1
    end
end

local timestamp = convertToTimestamp(matches.time) -- parse the server time reported in the command "time"

local timediff = roundToNearestHalf((os.time() - timestamp)/3600) -- take the difference between local time and servertime and calc the hour diff

if timediff > 24 or timediff < -24 then
  error("Trigger: Server time (timezone difference greater than 24 hours)")
  return
end

AltList.TimeZone = timediff

