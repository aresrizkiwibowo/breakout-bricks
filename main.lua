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
require 'class.Brick'

-- Constants
WINDOW_WIDTH = 960
WINDOW_HEIGHT = 540

VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 180

BALL_RADIUS = 4

BRICK_WIDTH = 20
BRICK_HEIGHT = 10

BRICKS_PADDING_X = 10 -- left and right of each row (not individual brick)
BRICKS_PADDING_Y = 2 -- top and bottom of each row

BRICKS_MAX_ROWS = 5
BRICKS_MAX_COLUMNS = (VIRTUAL_WIDTH - BRICKS_PADDING_X * 2) / BRICK_WIDTH 


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

    balls = {}
    bricks = makeLevel()
end

function love.keypressed(key)
    if key == 'space' then
        table.insert(balls, Ball())
    end
end

function love.update(dt)
    for i, ball in ipairs(balls) do
        ball:update(dt)
    end

    for i, bricks in ipairs(bricks) do
        bricks:update(dt)
    end

    if #bricks == 0 then
        bricks = makeLevel()
    end
end


function love.draw()
    push.start()
    
    for i, ball in ipairs(balls) do
        ball:render()
    end
    
    for i, brick in ipairs(bricks) do
        brick:render()
    end

    push.finish()
end


function makeLevel()
    -- brick row and columns
    local row = math.random(BRICKS_MAX_ROWS)
    local column = math.random(BRICKS_MAX_COLUMNS)

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