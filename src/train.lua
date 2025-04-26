local Train = {}
Train.__index = Train

function Train:new(cityStart, cityEnd)
    local self = setmetatable({}, Train)
    self.startCity = cityStart
    self.endCity = cityEnd
    self.startX = cityStart.x
    self.startY = cityStart.y
    self.endX = cityEnd.x
    self.endY = cityEnd.y
    self.t = 0
    self.speed = 0.2 + math.random() * 0.2
    self.forward = true

    self.trail = {}
    self.trailMax = 40
    self.trailTimer = 0
    self.trailInterval = 0.02

    -- 新增：货物系统
    self.capacity = math.random(3, 6) -- 火车一趟能运多少货物
    self.load = self.capacity -- 初始满载
    return self
end

function Train:update(dt)
    if self.forward then
        self.t = self.t + self.speed * dt
        if self.t >= 1 then
            self.t = 1
            self:onArrive(self.endCity)
            self.forward = false
        end
    else
        self.t = self.t - self.speed * dt
        if self.t <= 0 then
            self.t = 0
            self:onArrive(self.startCity)
            self.forward = true
        end
    end

    -- 拖尾
    self.trailTimer = self.trailTimer + dt
    if self.trailTimer >= self.trailInterval then
        self.trailTimer = self.trailTimer - self.trailInterval
        table.insert(self.trail, 1, self.t)
        if #self.trail > self.trailMax then
            table.remove(self.trail)
        end
    end
end

function Train:onArrive(city)
    -- 到达城市时检查交付
    if city.order and city.order.target == (self.startCity.name == city.name and self.endCity.name or self.startCity.name) then
        local deliverable = math.min(self.load, city.order.amount - city.order.delivered)
        city.order.delivered = city.order.delivered + deliverable
        self.load = self.load - deliverable
        print("Delivered " .. deliverable .. " units to " .. city.name)

        -- 如果订单完成，可以重新生成订单
        if city.order.delivered >= city.order.amount then
            print("Order at " .. city.name .. " completed!")
            city.order = nil -- 清空旧订单
        end
    end

    -- 到达城市后重新装货
    self.load = self.capacity
end

function Train:draw()
    for i, trailT in ipairs(self.trail) do
        local x = self.startX + (self.endX - self.startX) * trailT
        local y = self.startY + (self.endY - self.startY) * trailT
        local size = 10 - (i - 1) * 0.2
        local alpha = 0.5 - (i - 1) * 0.01
        alpha = math.max(alpha, 0)

        love.graphics.setColor(1, 1, 0.5, alpha)
        love.graphics.circle("fill", x, y, size)
    end

    local x = self.startX + (self.endX - self.startX) * self.t
    local y = self.startY + (self.endY - self.startY) * self.t
    local pulse = 0.8 + 0.2 * math.sin(love.timer.getTime() * 6)
    love.graphics.setColor(1, 1, 0.5, pulse)
    love.graphics.circle("fill", x, y, 12)

    love.graphics.setColor(1, 1, 0.5, 0.3)
    love.graphics.circle("fill", x, y, 20)

    -- 显示火车当前货物量
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.load .. "/" .. self.capacity, x - 10, y - 30)
end

return Train
