--========================================================
-- input.lua
--========================================================
local input = {}

local function getJoystick()
    local sticks = love.joystick.getJoysticks()
    return sticks[1]
end

----------------------------------------------------------
-- GAME CONTROLS (unchanged)
----------------------------------------------------------
function input.steer()
    local j = getJoystick()
    local axis = 0

    if j then
        axis = j:getAxis(1)
        if math.abs(axis) < 0.2 then axis = 0 end
    end

    local left  = love.keyboard.isDown("left")  and -1 or 0
    local right = love.keyboard.isDown("right") and  1 or 0

    return axis ~= 0 and axis or (left + right)
end

function input.throttle()
    local j = getJoystick()

    if love.keyboard.isDown("up") then
        return 1
    end

    if j and j:isGamepadDown("a") then
        return 1
    end

    return 0
end

function input.brake()
    local j = getJoystick()

    -- Keyboard brake
    if love.keyboard.isDown("down") then
        return 1
    end

    -- Gamepad button brake (B / Circle)
    if j and j:isGamepadDown("b") then
        return 1
    end

    -- Gamepad trigger brake (LT / L2)
    if j then
        -- Most controllers use axis 5 or 6 for LT
        local lt = j:getAxis(5) or 0
        if lt > 0.2 then
            return lt  -- analog brake strength
        end
    end

    return 0
end

----------------------------------------------------------
-- MENU CONTROLS (new)
----------------------------------------------------------
function input.up()
    local j = getJoystick()
    return love.keyboard.isDown("up") or love.keyboard.isDown("w")
        or (j and j:isGamepadDown("dpup"))
end

function input.down()
    local j = getJoystick()
    return love.keyboard.isDown("down") or love.keyboard.isDown("s")
        or (j and j:isGamepadDown("dpdown"))
end

function input.confirm()
    local j = getJoystick()
    return love.keyboard.isDown("return") or love.keyboard.isDown("space")
        or (j and (j:isGamepadDown("a") or j:isGamepadDown("start")))
end

function input.back()
    local j = getJoystick()
    return love.keyboard.isDown("escape")
        or (j and j:isGamepadDown("b"))
end
function input.left()
    local j = getJoystick()
    return love.keyboard.isDown("left") or love.keyboard.isDown("a")
        or (j and j:isGamepadDown("dpleft"))
end

function input.right()
    local j = getJoystick()
    return love.keyboard.isDown("right") or love.keyboard.isDown("d")
        or (j and j:isGamepadDown("dpright"))
end



return input