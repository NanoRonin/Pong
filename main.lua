function love.load()
    love.window.setTitle("Pong")

    player = {
    }

    bot = {
    }

    ball = {
    }

    player.score = 0
    bot.score = 0
    resetGame()
end

function love.update(dt)
    ball.x = ball.x + ball.vx * dt * ball.speed
    ball.y = ball.y + ball.vy * dt * ball.speed

    if love.keyboard.isDown("w") and player.y > 0 then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown("s") and player.y < love.graphics.getHeight() - player.h then
        player.y = player.y + player.speed * dt
    end

    if bot.y + bot.h/2 > ball.y + ball.r/2 and bot.y > 0 then
        bot.y = bot.y - bot.speed * dt
    elseif bot.y + bot.h/2 < ball.y + ball.r/2 and bot.y < love.graphics.getHeight() - bot.h then
        bot.y = bot.y + bot.speed * dt
    end

    if ball.y < 0 or ball.y > love.graphics.getHeight() - ball.r then
        ball.vy = -1 * ball.vy
        ball.speed = ball.speed + 1
    end

    if checkCollision(player.x, player.y, player.w, player.h, ball.x, ball.y, ball.r, ball.r) then
        ball.vx = -1 * ball.vx
        bot.speed = bot.speed + 1
    elseif checkCollision(bot.x, bot.y, bot.w, bot.h, ball.x, ball.y, ball.r, ball.r) then
        ball.vx = -1 * ball.vx
        ball.speed = ball.speed + 1
    end

    if ball.x < 0 then
        bot.score = bot.score + 1
        resetGame()
    elseif ball.x > love.graphics.getWidth() + ball.r then
        player.score = player.score + 1
        resetGame()
    end
end

function love.draw()
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    love.graphics.rectangle("fill", bot.x, bot.y, bot.w, bot.h)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.r, ball.r)

    love.graphics.print(player.score .. " - " .. bot.score)
end

function resetGame()
    player.h = 150
    player.w = 15
    player.x = 20
    player.y = love.graphics.getHeight()/2 - player.h/2
    player.speed = 150

    bot.h = 150
    bot.w = 15
    bot.x = love.graphics.getWidth() - 20 - bot.w
    bot.y = love.graphics.getHeight()/2 - player.h/2
    bot.speed = 150

    ball.r = 15
    ball.x = love.graphics.getWidth()/2 - ball.r/2
    ball.y = love.graphics.getHeight()/2 - ball.r/2
    ball.vx = love.math.random(0, 1) == 0 and -1 or 1
    ball.vy = love.math.random(0, 1) == 0 and -1 or 1
    ball.speed = 200
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end