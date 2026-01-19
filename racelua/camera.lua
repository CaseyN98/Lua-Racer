-- camera.lua
local camera = {}

function camera.load(target)
    camera.target = target
    camera.x = target.x
    camera.y = target.y
    camera.scale = 0.7 -- zoom out slightly
end

function camera.update(dt)
    if not camera.target then return end
    -- Smoothly follow target center
    local tx = camera.target.x
    local ty = camera.target.y
    camera.x = camera.x + (tx - camera.x) * 5 * dt
    camera.y = camera.y + (ty - camera.y) * 5 * dt
end

function camera.attach()
    love.graphics.push()
    -- Scale first
    love.graphics.scale(camera.scale)
    -- Translate so target is centered
    local cx = love.graphics.getWidth() / (2 * camera.scale)
    local cy = love.graphics.getHeight() / (2 * camera.scale)
    love.graphics.translate(cx - camera.x, cy - camera.y)
end

function camera.detach()
    love.graphics.pop()
end

return camera
