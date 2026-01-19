-- camera.lua
local camera = {}

function camera.load(target)
    camera.target = target
    camera.x = target.x
    camera.y = target.y
    -- Zoomed out slightly (0.7) to see more of the environment
    camera.scale = 0.7 
end

function camera.update(dt)
    if not camera.target then return end
    camera.x = camera.x + (camera.target.x - camera.x) * 5 * dt
    camera.y = camera.y + (camera.target.y - camera.y) * 5 * dt
end

function camera.attach()
    local cx = love.graphics.getWidth() / 2
    local cy = love.graphics.getHeight() / 2
    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(camera.scale)
    love.graphics.translate(-math.floor(camera.x), -math.floor(camera.y))
end

function camera.detach()
    love.graphics.pop()
end

return camera