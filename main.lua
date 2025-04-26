local City = require "src.city"
local Railway = require "src.railway"

local railways = {}

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.15)
    City:load()

    -- 第一条线路
    table.insert(railways, Railway:new(City.city1, City.city2))
end

function love.update(dt)
    for _, railway in ipairs(railways) do
        railway:update(dt)
    end
end

function love.draw()
    City:draw()
    for _, railway in ipairs(railways) do
        railway:draw()
    end
end
