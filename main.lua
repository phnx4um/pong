
Class = require 'class'
push = require 'push'

require 'Paddle'
require 'Ball'

WINDOWS_WIDTH = 1280
WINDOWS_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243  

paddleSpeed = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Pong')
    
    math.randomseed(os.time())
    
    smallFont = love.graphics.newFont('font.ttf', 8)
    
    scoreFont = love.graphics.newFont('font.ttf', 24)
    
    love.graphics.setFont(smallFont)
    
    push:setupScreen(VIRTUAL_WIDTH,  VIRTUAL_HEIGHT, WINDOWS_WIDTH, WINDOWS_HEIGHT,{
            fullscreen = false,
            resizable = false,
            vsync = true
    })
    
    
    player1Score = 0 
    player2Score = 0
    
    servingPlayer = 1
    
    
--OLD IMPLEMENTATION ******************** 
    
----    players y position
--    player1PositionY = 30 
--    player2PositionY = VIRTUAL_HEIGHT - 30
--    
----    ball position
--    ballX = VIRTUAL_WIDTH/2  - 2
--    ballY = VIRTUAL_HEIGHT/2  - 2
--    
----    balls velocity
--    ballDX = math.random(2) == 1 and 100 or -100 
--    ballDY = math.random(-50, 50)
    
--OLD IMPLEMENTATION ENDS HERE **********
    
    
    
--    oops implementation
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)
    
    ball = Ball(VIRTUAL_WIDTH/2  - 2, VIRTUAL_HEIGHT/2  - 2, 4, 4)
    
    
    gameState = 'start'
    
--    love.window.setMode(WINDOWS_WIDTH, WINDOWS_HEIGHT, {
--            fullscreen = false,
--            resizable = false,
--            vsync = true
--        })
    
end


function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit() 
    
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then 
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
            
--            oops implementation
--            ball:reset()
    
            --OLD IMPLEMENTATION ******************** 
        
--            ballX = VIRTUAL_WIDTH/2  - 2
--            ballY = VIRTUAL_HEIGHT/2  - 2
--        
--            ballDX = math.random(2) == 1 and 100 or -100 
--            ballDY = math.random(-50, 50) 
            
            --OLD IMPLEMENTATION ENDS HERE **********
        elseif gameState == 'done' then
            gameState = 'serve'
            
            ball:reset()
            
            player1Score = 0
            player2Score = 0
            
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end 

-- UPDATE FUNCTION

function love.update(dt)
    
    if gameState == 'serve' then 
        ball.dy = math.random(-50,50)
        if servingPlayer == 1 then
            ball.dx = math.random(140,200)
        else
            ball.dx = - math.random(140,200)
        end
    elseif gameState == 'play' then
        -- hitting the ball behaviour
        if ball:collides(player1) then
            ball.x = player1.x + player1.width
            ball.dx = -ball.dx * 1.05
            
            if ball.dy < 0 then 
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
        end
        
        if ball:collides(player2) then
            ball.x = player2.x - ball.width
            ball.dx = -ball.dx * 1.05
            
            if ball.dy < 0 then 
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
        end     
        
        --handling hitting the boundaries
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
        
        if ball.y >= VIRTUAL_HEIGHT - 4 then 
            ball.y = VIRTUAL_HEIGHT - 4 
            ball.dy = -ball.dy
        end 
        
        --scoring logic
        if ball.x < 0 then 
            servingPlayer = 1
            player2Score = player2Score + 1
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                ball:reset()
                gameState = 'serve'
            end
        end
        
        if ball.x > VIRTUAL_WIDTH then 
            servingPlayer = 2
            player1Score = player1Score + 1
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                ball:reset()
                gameState = 'serve'
            end
        end
        
        ball:update(dt) 
    end
    
    if love.keyboard.isDown( 'w') then 
        player1.dy = -paddleSpeed
    elseif love.keyboard.isDown( 's') then 
        player1.dy = paddleSpeed
    else
        player1.dy = 0
    end

    if love.keyboard.isDown( 'up') then 
        player2.dy = -paddleSpeed
    elseif love.keyboard.isDown('down') then 
        player2.dy = paddleSpeed
    else
        player2.dy = 0
    end
    
    player1:update(dt)
    player2:update(dt)   
        
end 
    


function love.draw()
    push:apply('start')
    
    love.graphics.clear( 40/255, 45/255, 52/255, 1)
    
    
    displayScore()
    
    
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- play the game.. nothing to display
    elseif gameState == 'done' then
        love.graphics.setFont(scoreFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    
    love.graphics.printf(
        'PONG',
        0,
        50,
        VIRTUAL_WIDTH,
        'center'
    )  
----    first paddle 
--    love.graphics.rectangle('fill',
--        10, player1PositionY, 5, 20)   
----    second paddle
--    love.graphics.rectangle('fill',
--        VIRTUAL_WIDTH - 10, player2PositionY, 5, 20)
--    
--    love.graphics.rectangle('fill',
--    ballX, ballY, 4, 4)
    
    
    player1:render()
    player2:render()
    
    ball:render()
    
    displayFPS()
    
    push:apply('end')
end


function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,1,0,1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end


function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end
    
