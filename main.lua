map_generated = false


function love.load()
    Object = require "classic"
    require "game"
    require "tile"
    require "visual"
    require "input"

    local subTitles = {
        "Waffles?",
        "uwu",
        "Boykisser was here",
        "Get mine blasted",
        "Sicko mode",
        "Minesweeper? ~Jack Minecraft",
        "Shovel and Spade! ~John Craft",
        "This will be a super duper minefield!",
        "Where's my puppygirl?",
        "Men? Where are men?",
        "Pipe bomb! So cool! I wonder what happens if I-",
        "Oh no! ...Anyway",
        "You got mines on your field?",
        "Ahe,,,! Mine sweeper,,,",
        "Expies' gonna suffer",
        "Caine! THIS is our adventure?!",
        "I am become mine. Destroyer of fields.",
        "Secret fields? Mine sweeper?",
        "Get that knight grip on your shovel",
        "Sweep sweep sweep sweep~!",
        "I can't talk right now, I'm sweeping mines.",
        "It's literally pseudo-random, you'll figure it out",
        "I'm literally a mine, what's your excuse?",
        "19 DOLLAR MINEFIELD PLOT. Who wants it? I'm giving it away.",
        "You like sweeping mines don't you?",
    }
    local randi = love.math.random(1, #subTitles)
    love.window.setTitle("Blastbunny: " .. subTitles[randi])

    gameInit(10, 10, 10)
    visualInit()
    canvasReset()
end


function love.draw()
    local start = love.timer.getTime()
    visualDraw()
    local result = love.timer.getTime() - start
    love.graphics.print(string.format("%.3f ms", result * 1000), 0, 300)
end