-- main.lua
local menu = require("menu")
local game = require("game")
local input = require("input")

local currentState = "menu"

function love.load()
    love.window.setTitle("RaceLua")
    -- Scaled down window resolution
    love.window.setMode(960, 540)
    love.graphics.setDefaultFilter("nearest", "nearest")
    menu.load()
end

function love.update(dt)
    dt = math.min(dt, 0.07) 
    if currentState == "menu" then
        local action = menu.update(dt, input)
        if action == "start" then
            currentState = "game"
            game.load()
        end
    elseif currentState == "game" then
        local action = game.update(dt, input)
        if action == "menu" then
            currentState = "menu"
            menu.load()
        end
    end
end

function love.draw()
    if currentState == "menu" then
        menu.draw()
    else
        game.draw()
    end
end

function love.keypressed(key)
    if key == "escape" then
        if currentState == "game" then
            currentState = "menu"
            menu.load()
        else
            love.event.quit()
        end
    end
    if currentState == "menu" then menu.keypressed(key) end
end