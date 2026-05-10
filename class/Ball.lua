Ball = Class{}

-- accelerates each ball over time
BALL_ACCELERATION = 1.002

function Ball:init()
    self.x = spawner.x
    self.y = spawner.y
    self.dx = math.random(-100, 100)
    self.dy = -math.random(50, 100)
end

function Ball:update(dt)
    -- check if ball is colliding with wall
    if self.x - BALL_RADIUS < 0 then -- left wall
        self.dx = -self.dx
    elseif self.x + BALL_RADIUS > VIRTUAL_WIDTH then -- right wall
        self.dx = -self.dx
    elseif self.y + BALL_RADIUS < 0 then -- top wall
        self.dy = -self.dy
    elseif self.y + BALL_RADIUS > VIRTUAL_HEIGHT then -- remove ball if disappeared to the bottom (no wall)
        self = nil
        return
    end

    self.dy = self.dy * BALL_ACCELERATION

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, BALL_RADIUS)
end