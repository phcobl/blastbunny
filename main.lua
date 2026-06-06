function love.load()
    math.randomseed(os.time())
    
    Object = require "classic"
    require "game"
    require "tile"

    generate_map(20, 20, 50, {1,1})
    reveal_tile({1,1})

    temp_rando = {
        "Waffles?",
        "uwu",
        "Boykisser was here",
        "Get mine blasted",
        "Sicko mode",
        "Minesweeper? ~Jack Minecraft",
        "Shovel and Spade! ~John Black",
        "This will be a super duper minefield!",
        "Where's my puppygirl?",
        "Men? Where are men?",
        "Pipe bomb! So cool! I wonder what happens if I-"
    }
    temp_randi = math.random(1, #temp_rando)
end


function love.draw()
    love.graphics.print(temp_rando[temp_randi], 100, 100)
end