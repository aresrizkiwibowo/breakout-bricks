Ball = Class{}


function Ball:init()

end

function Ball:update(dt)

end

function Ball:render()
    love.graphics.circle('fill', 0, 0, BALL_RADIUS)
end