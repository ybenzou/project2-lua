-- src/city.lua
local City = {}

function City:load()
    self.city1 = { x = 150, y = 300, name = "City A" }
    self.city2 = { x = 650, y = 300, name = "City B" }

    self:generateOrder(self.city1, self.city2)
    self:generateOrder(self.city2, self.city1)
end

function City:generateOrder(cityFrom, cityTo)
    cityFrom.order = {
        target = cityTo.name,
        amount = math.random(3, 8), -- 需要运送的货物数量
        delivered = 0 -- 已经交付的数量
    }
end

function City:draw()
    for _, city in pairs({self.city1, self.city2}) do
        -- 画城市
        for r = 30, 20, -1 do
            local alpha = (30 - r) / 10
            love.graphics.setColor(0.2, 0.6, 1, alpha)
            love.graphics.circle("fill", city.x, city.y, r)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", city.x, city.y, 5)

        love.graphics.setColor(1, 1, 1)
        love.graphics.print(city.name, city.x - 20, city.y + 35)

        -- 画订单
        if city.order then
            love.graphics.setColor(1, 1, 0.6)
            love.graphics.print(
                "To " .. city.order.target .. ": " .. (city.order.amount - city.order.delivered) .. " units",
                city.x - 40, city.y + 55
            )
        end
    end
end

return City
