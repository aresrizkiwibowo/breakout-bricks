BallSpawner = Class{}


function BallSpawner:init()
    self.speed = 100
    self.radius = BALL_RADIUS
    self.x = VIRTUAL_WIDTH/2
    self.y = 9/10 * VIRTUAL_HEIGHT
    self.sharpness = 0
    self.sharpnessIncrement = 0.1
    self.sharpnessMax = 20
end

function BallSpawner:update(dt)
    if love.keyboard.isDown('left') then
        -- spawner movement
        self.dx = -self.speed * dt
        -- ball shooting sharpness
        self.sharpness = self.sharpness - self.sharpnessIncrement
    elseif love.keyboard.isDown('right') then
        self.dx = self.speed * dt
        self.sharpness = self.sharpness + self.sharpnessIncrement
    else
        self.dx = 0
        if self.sharpness < 0 then
            self.sharpness = math.max(-self.sharpnessMax, self.sharpness + 2 * self.sharpnessIncrement * dt)
        else
            self.sharpness = math.min(self.sharpnessMax, self.sharpness - 2 * self.sharpnessIncrement * dt)
        end
    end

    local newX = self.x + self.dx

    if self.dx < 0 then
        self.x = math.max(0 + BALL_RADIUS, newX)
    elseif self.dx > 0 then
        self.x = math.min(VIRTUAL_WIDTH - BALL_RADIUS, newX)
    end
end

function BallSpawner:render()
    love.graphics.circle('line', self.x, self.y, BALL_RADIUS)
end