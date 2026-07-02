-- Remember last button. If lastButton not -1, ignore new input until last button is released.
Last_Button = -1


-- Select tile on button down
function love.mousepressed(x, y, button, is_touch)
    if Last_Button == -1 then
        Last_Button = button
        local x,y = love.mouse.getPosition()
        x = math.floor(x / Tile_Size / 2) + 1
        y = math.floor(y / Tile_Size / 2) + 1
        selectTile(x, y)
    end
end


-- Do action for selected tile on button up
function love.mousereleased(x, y, button, is_touch)
    if button == Last_Button then
        Last_Button = -1
        if button == 1 then
            if Selected_Tile then
                if not Selected_Tile.is_revealed then
                    revealTile(Selected_Tile_Coords)
                    --print("Revealing: ", selectedTileCoords[1],":" , selectedTileCoords[2])
                else
                    --print("Tile ", selectedTileCoords[1],":" , selectedTileCoords[2], " is already revealed.")
                end
            end
        elseif button == 2 then
            -- TODO: figure out how to place flags
            if Selected_Tile then
                if not Selected_Tile.is_revealed then
                    ToggleFlag(Selected_Tile_Coords)
                    --print("Pos ", selectedTileCoords[1],":" , selectedTileCoords[2], " flagged: ", selectedTile.isFlagged)                   
                else
                    --print("Can't place a flag on a revaled tile.")
                end
            end
        end
    end
end


-- Restart game on return key. For debugging
function love.keyreleased(key)
    if key == "backspace" then
        restartGame(12, 12, 12)
    end
end


function selectTile(x, y)
    if x <= Game_Size_X and y <= Game_Size_Y then
        if not Map_Generated then
            generateMap({x,y})
            Map_Generated = true
        end
        -- TODO: I don't like this being two separate vars :(
        Selected_Tile = Map[x][y]
        Selected_Tile_Coords = {x, y}
    end
end