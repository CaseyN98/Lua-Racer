-- map.lua
local config = require("config")
local map = {}

map.image = nil
map.mask  = nil
map.available = {{id = "track1", name = "City Circuit"}}
map.selected = 1

function map.load(id)
    local trackData = config.tracks[id]
    if not trackData then return end
    map.image = love.graphics.newImage(trackData.spritePath)
    -- Load mask as ImageData to read pixel colors
    map.mask  = love.image.newImageData(trackData.maskPath)
end

function map.getPixel(x, y)
    if not map.mask then return 1, 1, 1, 0 end
    local ix, iy = math.floor(x), math.floor(y)
    if ix < 0 or iy < 0 or ix >= map.mask:getWidth() or iy >= map.mask:getHeight() then
        return 1, 1, 1, 1 -- Outside is White (Wall)
    end
    return map.mask:getPixel(ix, iy)
end

function map.checkType(x, y, type)
    local r, g, b, a = map.getPixel(x, y)
    
    -- dominant color logic
    if type == "road" then
        -- Road is Black/Dark: All colors low
        return r < 0.4 and g < 0.4 and b < 0.4
    elseif type == "checkpoint" then
        -- Mostly Green: Green is significantly higher than Red/Blue
        return g > 0.5 and g > r and g > b
    elseif type == "finish" then
        -- Mostly Red
        return r > 0.5 and r > g and r > b
    elseif type == "boost" then
        -- Mostly Blue
        return b > 0.5 and b > r and b > g
    end
    return false
end

function map.isRoadWorld(x, y)
    local r, g, b, a = map.getPixel(x, y)
    -- COLLISION RULE: 
    -- If the pixel is White (1,1,1), it's a WALL (Grass).
    -- If it's anything else (Black, Red, Green, Blue), it's DRIVABLE.
    local isWhite = (r > 0.8 and g > 0.8 and b > 0.8)
    return not isWhite
end

function map.draw()
    if map.image then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(map.image, 0, 0)
    end
end

return map