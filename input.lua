-- Remember last button. If lastButton not -1, ignore new input until last button is released.
lastButton = -1


-- Select tile on button down
function love.mousepressed(x, y, button, istouch)
    if lastButton == -1 then
        lastButton = button
        local x,y = love.mouse.getPosition()
        x = math.floor(x / tileSize / 2) + 1
        y = math.floor(y / tileSize / 2) + 1
        selectTile(x, y)
    end
end


-- Do action for selected tile on button up
function love.mousereleased(x, y, button, istouch)
    if button == lastButton then
        lastButton = -1
        if button == 1 then
            if selectedTile then
                if not selectedTile.isRevealed then
                    revealTile(selectedTileCoords)
                    --print("Revealing: ", selectedTileCoords[1],":" , selectedTileCoords[2])
                else
                    print("Tile ", selectedTileCoords[1],":" , selectedTileCoords[2], " is already revealed.")
                end
            end
        elseif button == 2 then
            -- TODO: figure out how to place flags
            if selectedTile then
                if not selectedTile.isRevealed then
                    toggleFlag(selectedTileCoords)
                    print("Pos ", selectedTileCoords[1],":" , selectedTileCoords[2], " flagged: ", selectedTile.isFlagged)                   
                else
                    print("Can't place a flag on a revaled tile.")
                end
            end
        end
    end
end


function selectTile(x, y)
    if x <= game_sizex and y <= game_sizey then
        if not map_generated then
            generateMap({x,y})
            map_generated = true
        end
        -- TODO: I don't like this being two separate vars :(
        selectedTile = map[x][y]
        selectedTileCoords = {x, y}
    end
end