function TableSize(t)
  if type(t) ~= "table" then error("TableSize() requires a table as an argument") end
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function deepcopy(o, seen)
  seen = seen or {}
  if not o  then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end

function format_int(number)
  -- Handle non-numeric inputs
  if type(number) ~= "number" then
    return "format_int(): invalid input"
  end

  local str = tostring(number)
  local minus, int, fraction = str:match('([-]?)(%d+)([.]?%d*)') -- first tries to match optional negative sign, then captures whole number, then captures optional decimal

  -- Insert commas for thousands, millions, etc.
  local formatted = ""
  local length = #int
  for i = 1, length do
    formatted = formatted .. int:sub(i, i)
    if (length - i) % 3 == 0 and i ~= length then
      formatted = formatted .. ","
    end
  end

  return minus .. formatted .. fraction
end

function showCmdSyntax(cmd_name, syntax_tbl, showCmdColour)
  if type(cmd_name) ~= "string" or type(syntax_tbl) ~= "table" then
    error("showCmdSyntax: Invalid inputs (expected string, table)")
    return false
  end
  
  showCmdColour = showCmdColour or "white" -- https://wiki.mudlet.org/images/c/c3/ShowColors.png
  
  cecho("<"..showCmdColour..">"..cmd_name.."\n")
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
  for _, v in ipairs(syntax_tbl) do
    local dash = (v[1] and v[2]) and "- " or "  "
    local formatStr = string.format("<%s>%-31s%s\n", showCmdColour, v[1] and " " .. v[1] or "", dash .. (v[2] or ""))
    cecho(formatStr)
  end
  cecho("<"..showCmdColour..">---------------------------------------------------------------------------------------\n")
end

function VictoryBeep()
  playSoundFile({name = getMudletHomeDir() .. "/Vagonuth-Inventory-Mgmt/victorybeep.mp3", volume = 75})
end

function printGameMessage(title, message, colour, colour_message)
  colour = colour or "white"
  colour_message = colour_message or ("ansi_" .. colour)
  
  local formatStr = string.format("<%s>%s<%s>: %s\n", colour, title, colour_message, message)
  if StaticVars and StaticVars.GameMsgsChatOutput then
    cecho(StaticVars.GameMsgsChatOutput, formatStr)
  else
    cecho(formatStr)
  end
end

function printMessage(title, message, colour)
  colour = colour or "white"
  
  local formatStr = string.format("<%s>%s<ansi_%s>: %s\n", colour, title, colour, message)
  cecho(formatStr)
end

function Connected()
  local _, _, ret = getConnectionInfo()
  return ret
end

function splitArgumentIntoTwo(input)
    local arg1, arg2

    -- Check for both "words" enclosed in single quotes
    local match1, match2 = input:match("^'(.-)'%s+'(.-)'$")
    if match1 and match2 then
        arg1 = "'" .. match1 .. "'"
        arg2 = "'" .. match2 .. "'"
    else
        -- Check for the pattern with the first "word" in single quotes
        match1, match2 = input:match("^'(.-)'%s+(%S+)$")
        if match1 and match2 then
            arg1 = "'" .. match1 .. "'"
            arg2 = match2
        else
            -- Check for the pattern with the second "word" in single quotes
            match1, match2 = input:match("^(%S+)%s+'(.-)'$")
            if match1 and match2 then
                arg1 = match1
                arg2 = "'" .. match2 .. "'"
            else
                -- Check for the pattern with exactly two words
                match1, match2 = input:match("^(%S+)%s+(%S+)$")
                if match1 and match2 then
                    arg1 = match1
                    arg2 = match2
                else
                    -- Check for a single word
                    match1 = input:match("^(%S+)$")
                    if match1 then
                        arg1 = match1
                    else
                        -- Return an error if no pattern matches
                        return nil, "Invalid input format. Use one or two words, or enclose multiple words in single quotes."
                    end
                end
            end
        end
    end

    return arg1, arg2
end


