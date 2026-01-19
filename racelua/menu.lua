-- menu.lua
local menu = {}
local config = require("config")

local state = "main"
local options = {"START RACE", "CAR SELECT", "QUIT"}
local selected = 1

function menu.load()
    state = "main"
end

function menu.update(dt, input)
    if input.up() then
        selected = selected > 1 and selected - 1 or #options
        love.timer.sleep(0.12)
    elseif input.down() then
        selected = selected < #options and selected + 1 or 1
        love.timer.sleep(0.12)
    end

    if input.confirm() then
        if state == "main" then
            if selected == 1 then return "start"
            elseif selected == 2 then state = "car_select"
            elseif selected == 3 then love.event.quit() end
        elseif state == "car_select" then
            state = "main"
        end
        love.timer.sleep(0.2)
    end

    if state == "car_select" then
        if input.left() then
            config.player.carIndex = math.max(1, config.player.carIndex - 1)
            love.timer.sleep(0.1)
        elseif input.right() then
            config.player.carIndex = math.min(#config.cars, config.player.carIndex + 1)
            love.timer.sleep(0.1)
        end
    end
end

function menu.draw()
    local w, h = love.graphics.getDimensions()
    love.graphics.clear(0.05, 0.05, 0.1)

    if state == "main" then
        love.graphics.setColor(1, 0.8, 0)
        love.graphics.printf("RACELUA", 0, h/4, w, "center")
        for i, opt in ipairs(options) do
            local col = (i == selected) and {1, 1, 1} or {0.5, 0.5, 0.5}
            love.graphics.setColor(col)
            love.graphics.printf((i == selected and "> " or "") .. opt, 0, h/2 + (i*45), w, "center")
        end
    elseif state == "car_select" then
        local car = config.cars[config.player.carIndex]
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("PICK YOUR MACHINE", 0, 100, w, "center")
        love.graphics.printf("<  " .. car.name .. "  >", 0, h/2, w, "center")
        love.graphics.printf("Max Speed: " .. car.maxSpeed .. " | Accel: " .. car.accel, 0, h/2 + 50, w, "center")
    end
end

function menu.keypressed(key) end

return menu