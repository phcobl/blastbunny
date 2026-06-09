function love.load()
    math.randomseed(os.time())
    
    Object = require "classic"
    require "game"
    require "tile"
    require "visual"

    generate_map(10, 10, 10, {1,1})
    reveal_tile({1,1})

    visual_init()

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
    love.window.setTitle("Blastbunny: " .. temp_rando[temp_randi])
end


function love.draw()
    visual_draw()
end