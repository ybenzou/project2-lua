-- src/railway.lua
local Train = require "src.train"

local Railway = {}
Railway.__index = Railway

function Railway:new(cityStart, cityEnd)
    local self = setmetatable({}, Railway)
    self.cityStart = cityStart
    self.cityEnd = cityEnd
    self.trains = {}

    -- 默认上线一辆火车
    local train = Train:new(cityStart, cityEnd)
    table.insert(self.trains, train)

    return self
end

function Railway:update(dt)
    for _, train in ipairs(self.trains) do
        train:update(dt)
    end
end

function Railway:draw()
    -- 画轨道
    self:drawRail()

    -- 画火车
    for _, train in ipairs(self.trains) do
        train:draw()
    end
end

function Railway:drawRail()
    -- 画漂亮的流光轨道
    local segments = 50
    for i = 0, segments do
        local t = i / segments
        local x = self.cityStart.x + (self.cityEnd.x - self.cityStart.x) * t
        local y = self.cityStart.y + (self.cityEnd.y - self.cityStart.y) * t

        local glow = 0.4 + 0.6 * math.sin(love.timer.getTime() * 5 + t * 10)
        love.graphics.setColor(0.5, 0.8, 1, glow)
        love.graphics.circle("fill", x, y, 2)
    end
end

return Railway
