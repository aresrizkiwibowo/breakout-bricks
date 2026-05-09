Brick = Class{}


function Brick:init(param)
    self.x = param.x
    self.y = param.y
end

function Brick:update(dt)
    
end

function Brick:render()
    love.graphics.rectangle('line', self.x, self.y, BRICK_WIDTH, BRICK_HEIGHT)
end