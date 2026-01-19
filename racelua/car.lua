-- car.lua
local car = {}
car.__index = car

-- Shader for hue shifting
local hueShader = love.graphics.newShader[[ 
    extern float hue;
    vec3 rgb2hsv(vec3 c) {
        vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y)/(6.0*d + e)), d/(q.x + e), q.x);
    }
    vec3 hsv2rgb(vec3 c) {
        vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz)*6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }
    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 sc) {
        vec4 texcolor = Texel(texture, tc);
        vec3 hsv = rgb2hsv(texcolor.rgb);
        hsv.x = mod(hsv.x + hue, 1.0);
        return vec4(hsv2rgb(hsv), texcolor.a) * color;
    }
]]

function car.new(cfg, isAI)
    local self = setmetatable({}, car)
    self.img = love.graphics.newImage(cfg.sprite)
    self.x, self.y, self.angle = 0, 0, 0
    self.speed = 0
    self.hue = 0
    self.stats = cfg
    self.isAI = isAI
    self.currentWaypoint = 1
    self.lap = 1
    return self
end

function car:update(dt, input, map, waypoints)
    local throttle, steer, brake = 0, 0, 0

    if self.isAI then
        local target = waypoints[self.currentWaypoint]
        local angleToTarget = math.atan2(target.y - self.y, target.x - self.x)
        local diff = (angleToTarget - self.angle + math.pi) % (math.pi*2) - math.pi
        steer = diff > 0.1 and 1 or (diff < -0.1 and -1 or 0)
        throttle = 0.75
        local dx, dy = target.x - self.x, target.y - self.y
        if dx*dx + dy*dy < 4000 then
            self.currentWaypoint = (self.currentWaypoint % #waypoints) + 1
        end
    else
        throttle = input.throttle()
        steer = input.steer()
        brake = input.brake()
    end

    self.speed = self.speed + throttle * self.stats.accel * dt
    self.speed = self.speed - brake * self.stats.brake * dt
    self.speed = self.speed * (1 - dt * 1.5)

    local turnFactor = math.min(math.abs(self.speed), 300) / 300
    self.angle = self.angle + steer * self.stats.turn * turnFactor * dt

    local dx = math.cos(self.angle) * self.speed * dt
    local dy = math.sin(self.angle) * self.speed * dt

    if map.isRoadWorld(self.x + dx, self.y + dy) then
        self.x, self.y = self.x + dx, self.y + dy
    else
        self.speed = self.speed * 0.8
    end
end

function car:draw()
    hueShader:send("hue", self.hue)
    love.graphics.setShader(hueShader)
    -- +math.pi/2 aligns "Up" sprite with "Right" physics (0 rad)
    love.graphics.draw(self.img, self.x, self.y, self.angle + math.pi/2, 1, 1,
        self.img:getWidth()/2, self.img:getHeight()/2)
    love.graphics.setShader()
end

return car