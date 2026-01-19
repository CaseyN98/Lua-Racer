-- game.lua
local game = {}
local Car = require("car")
local Config = require("config")
local Map = require("map")
local Camera = require("camera")
local UI = require("ui")

function game.load()
    local track = Config.tracks[Config.track.mapId]
    Map.load(Config.track.mapId)

    game.player = Car.new(Config.cars[Config.player.carIndex], false)
    game.player.hue = Config.player.hue
    game.player.x, game.player.y = track.start.x, track.start.y
    game.player.angle = track.start.angle 

    game.ai = Car.new(Config.cars[Config.ai.carIndex], true)
    game.ai.hue = Config.ai.hue
    game.ai.x, game.ai.y = track.start.x + 50, track.start.y + 50
    game.ai.angle = track.start.angle

    game.countdown = Config.race.countdown
    game.raceTime = 0
    Camera.load(game.player)
    UI.load()
end

function game.update(dt, input)
    if game.countdown > 0 then
        game.countdown = game.countdown - dt
        return
    end

    game.raceTime = game.raceTime + dt
    local waypoints = Config.tracks[Config.track.mapId].waypoints

    game.player:update(dt, input, Map, waypoints)
    game.ai:update(dt, nil, Map, waypoints)
    Camera.update(dt)
end

function game.draw()
    Camera.attach()
    Map.draw()
    game.player:draw()
    game.ai:draw()
    Camera.detach()
    UI.draw(game)
end

return game