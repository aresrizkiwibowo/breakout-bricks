Ball = Class{}

-- accelerates each ball over time
BALL_ACCELERATION = 1.02

function Ball:init()
    self.x = spawner.x
    self.y = spawner.y
    self.dx = math.random(-30, 30)
    self.dy = -math.random(50, 100)
end

function Ball:update(dt)
    -- check if ball is colliding with wall
    if self.x - BALL_RADIUS < 0 then -- left wall
        self.x = 0 + BALL_RADIUS
        self.dx = -self.dx
    elseif self.x + BALL_RADIUS > VIRTUAL_WIDTH then -- right wall
        self.x = VIRTUAL_WIDTH - BALL_RADIUS
        self.dx = -self.dx
    elseif self.y - BALL_RADIUS < 0 then -- top wall
        self.y = 0 + BALL_RADIUS
        self.dy = -self.dy
    elseif self.y - BALL_RADIUS > VIRTUAL_HEIGHT then -- remove ball if disappeared to the bottom (no wall)
        self = nil
        return
    end

    self.x = self.x + self.dx * dt * BALL_ACCELERATION
    self.y = self.y + self.dy * dt * BALL_ACCELERATION
end

function Ball:collides(target)
    -- aabb collision
    if (self.x - BALL_RADIUS < target.x + BRICK_WIDTH) and (target.x < self.x + BALL_RADIUS) and
    (self.y - BALL_RADIUS < target.y + BRICK_HEIGHT) and (target.y < self.y + BALL_RADIUS) then
        return true
    else
        return false
    end
end

function Ball:render()
    love.graphics.circle('fill', self.x, self.y, BALL_RADIUS)
end