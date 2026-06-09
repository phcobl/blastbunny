function love.load()
    Object = require "classic"
    require "game"
    require "tile"
    require "visual"

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
        "Pipe bomb! So cool! I wonder what happens if I-"
    }
    local randi = love.math.random(1, #subTitles)
    love.window.setTitle("Blastbunny: " .. subTitles[randi])


    --generateMap(10, 10, 10, {1,1})
    --revealTile({1,1})

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