-- ui.lua
local ui = {}
function ui.load() end

function ui.draw(game)
    local w, h = love.graphics.getDimensions()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 10, h - 70, 180, 50, 4)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("SPEED: " .. math.floor(math.abs(game.player.speed)/10), 25, h - 55)
    love.graphics.printf("TIME: " .. string.format("%.2fs", game.raceTime), 0, 20, w - 20, "right")
    
    if game.countdown > 0 then
        love.graphics.setColor(1, 0.9, 0)
        local txt = math.ceil(game.countdown) > 0 and math.ceil(game.countdown) or "GO!"
        love.graphics.printf(txt, 0, h/2 - 40, w, "center", 0, 2, 2)
    end
end

return ui