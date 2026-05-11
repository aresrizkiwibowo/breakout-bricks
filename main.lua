--[[
    Breakout Brick Test
    main.lua

    Author: Ares Rizki Wibowo

    A Love2D project made to learn brick collision that works in
    Atari's breakout game.

    Controls: Side arrows, space
]]--

Class = require 'lib.class'
push = require 'lib.push'

require 'class.Ball' 
require 'class.BallSpawner' 
require 'class.Brick'

-- Constants
WINDOW_WIDTH = 960
WINDOW_HEIGHT = 540

VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 180

BRICK_WIDTH = 20
BRICK_HEIGHT = 10

BRICKS_PADDING_X = 10 -- left and right of each row (not individual brick)
BRICKS_PADDING_Y = 2 -- top and bottom of each row (individual brick)

-- minimum and maximum rows for the random bricks generator
BRICK_MIN_ROWS = 3
BRICKS_MAX_ROWS = 10
-- same as above, but for columns
BRICK_MIN_COLUMNS = 8
BRICKS_MAX_COLUMNS = (VIRTUAL_WIDTH - BRICKS_PADDING_X * 2) / BRICK_WIDTH 

BALL_RADIUS = 4
BALL_ACCELERATION = 1.02 -- accelerates ball over time

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Breakout Brick Test')

    math.randomseed(os.time())

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = 'normal'})

    spawner = BallSpawner()
    balls = {}
    bricks = makeLevel()
end


function love.update(dt)
    spawner:update(dt)

    -- erase balls when under the screen, erase brick when collided
    -- iterated backwards to avoid skipping when a key is deleted
    for i = #balls, 1, -1 do
        balls[i]:update(dt)
        if balls[i].y - BALL_RADIUS > VIRTUAL_HEIGHT then
            table.remove(balls, i)
            break
        end

        for j = #bricks, 1, -1 do
            if balls[i]:collides(bricks[j]) then
                -- if brick is hit, bounce current ball
                -- calculate offset (center to center distance)
                local ox = balls[i].x - (bricks[j].x + BRICK_WIDTH/2)
                local oy = balls[i].y - (bricks[j].y + BRICK_HEIGHT/2)

                -- calculate penetration depth of ball relative to brick
                local px = BRICK_WIDTH/2 - math.abs(ox)
                local py = BRICK_HEIGHT/2 - math.abs(oy)

                if px < py then
                    -- change to opposite direction
                    balls[i].dx = -balls[i].dx + px * BALL_ACCELERATION * dt
                    -- shift by py to put ball right outside the brick
                    balls[i].x = balls[i].x + (ox < 0 and px or -px)
                else
                    balls[i].dy = -balls[i].dy + py * BALL_ACCELERATION * dt
                    balls[i].y = balls[i].y + (oy < 0 and py or -py)
                end

                -- remove this brick and break the loop to stop looking for another brick
                table.remove(bricks, j)
                break
            end
        end
    end
    
    if #bricks == 0 then
        bricks = makeLevel()
    end
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        table.insert(balls, Ball())
    end
end


function love.draw()
    push.start()

    spawner:render()
    
    for i, ball in ipairs(balls) do
        ball:render()
    end
    
    for i, brick in ipairs(bricks) do
        brick:render()
    end

    if love.keyboard.isDown('v') then
        love.graphics.print('dx: ' .. tostring(spawner.dx), 10, 85/100 * VIRTUAL_HEIGHT)
    end

    push.finish()
end


function makeLevel()
    -- brick row and columns
    local row = math.random(BRICK_MIN_ROWS, BRICKS_MAX_ROWS)
    local column = math.random(BRICK_MIN_COLUMNS ,BRICKS_MAX_COLUMNS)

    -- the length for the brick to start to achieve centered layout
    -- ( half of empty area + padding )
    local leftPadding = (BRICKS_MAX_COLUMNS - column)/2 * BRICK_WIDTH + BRICKS_PADDING_X

    local bricks = {}
    for i = 1, row do
        local brickY = i * (BRICK_HEIGHT + BRICKS_PADDING_Y)
        for j = 1, column do
            local brickX = (j - 1) * BRICK_WIDTH + leftPadding
            table.insert(
                bricks,
                Brick({ -- add new brick
                    x = brickX,
                    y = brickY})
                )
        end
    end

    return bricks
end