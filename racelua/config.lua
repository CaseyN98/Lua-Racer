-- config.lua
local config = {}

config.race = { totalLaps = 3, countdown = 3 }

config.cars = {
    { name = "GTI SPEED", maxSpeed = 550, accel = 850, brake = 1000, turn = 3.5, sprite = "assets/car.png" },
    { name = "REV-X", maxSpeed = 480, accel = 1100, brake = 1200, turn = 4.8, sprite = "assets/car1.png" },
    { name = "DRIFT-KING", maxSpeed = 500, accel = 700, brake = 900, turn = 6.0, sprite = "assets/car.png" }
}

config.player = { carIndex = 1, hue = 0.0 }
config.ai = { carIndex = 2, hue = 0.6 }

config.tracks = {
    track1 = {
        name = "City Circuit",
        spritePath = "assets/track1.png",
        maskPath = "assets/track1_mask.png",
        -- Changed start.angle to math.pi to face Left
        start = { x = 1250, y = 1650, angle = math.pi },
        waypoints = { -- Simple counter-clockwise loop
            {x=500, y=1650}, {x=500, y=800}, {x=2400, y=800}, {x=2400, y=1650}
        }
    }
}
config.track = { mapId = "track1" }

return config