-- stats.lua
local stats = {}

-- In-memory cache of the latest results
stats.lastRace = {
    totalTime    = 0,
    bestLapTime  = 0,
    lapCount     = 0,
    date         = ""
}

-- The filename for saving high scores
local saveFilename = "highscores.txt"

function stats.saveRace(raceState)
    -- 1. Update in-memory stats
    stats.lastRace.totalTime   = raceState.raceTime or 0
    stats.lastRace.bestLapTime = raceState.bestLapTime or 0
    stats.lastRace.lapCount    = raceState.currentLap or 0
    stats.lastRace.date        = os.date("%Y-%m-%d %H:%M")

    -- 2. Practical Persistence (Save to local app data)
    -- This creates a simple string to save. 
    -- You can expand this to save an array of top 10 times later.
    local data = string.format(
        "TotalTime:%.2f\nBestLap:%.2f\nLaps:%d\nDate:%s",
        stats.lastRace.totalTime,
        stats.lastRace.bestLapTime,
        stats.lastRace.lapCount,
        stats.lastRace.date
    )

    -- love.filesystem writes to the user's "AppData/Roaming/love/" folder on Windows
    local success, message = love.filesystem.write(saveFilename, data)
    if not success then
        print("Could not save stats: " .. tostring(message))
    end
end

function stats.loadLastRace()
    if not love.filesystem.getInfo(saveFilename) then
        return nil
    end

    local contents, size = love.filesystem.read(saveFilename)
    if contents then
        -- Simple parsing logic
        for line in contents:gmatch("[^\r\n]+") do
            local key, val = line:match("([^:]+):(.+)")
            if key == "TotalTime" then stats.lastRace.totalTime = tonumber(val)
            elseif key == "BestLap" then stats.lastRace.bestLapTime = tonumber(val)
            elseif key == "Laps" then stats.lastRace.lapCount = tonumber(val)
            elseif key == "Date" then stats.lastRace.date = val
            end
        end
    end
    return stats.lastRace
end

function stats.getLastRace()
    return stats.lastRace
end

return stats