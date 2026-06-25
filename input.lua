-- Remember last button. If lastButton not -1, ignore new input until last button is released.
LastButton = -1


-- Select tile on button down
function love.mousepressed(x, y, button, istouch)
    if LastButton == -1 then
        LastButton = button
        local x,y = love.mouse.getPosition()
        x = math.floor(x / TileSize / 2) + 1
        y = math.floor(y / TileSize / 2) + 1
        SelectTile(x, y)
    end
end


-- Do action for selected tile on button up
function love.mousereleased(x, y, button, istouch)
    if button == LastButton then
        LastButton = -1
        if button == 1 then
            if selectedTile then
                if not selectedTile.isRevealed then
                    RevealTile(selectedTileCoords)
                    --print("Revealing: ", selectedTileCoords[1],":" , selectedTileCoords[2])
                else
                    print("Tile ", selectedTileCoords[1],":" , selectedTileCoords[2], " is already revealed.")
                end
            end
        elseif button == 2 then
            -- TODO: figure out how to place flags
            if selectedTile then
                if not selectedTile.isRevealed then
                    ToggleFlag(selectedTileCoords)
                    print("Pos ", selectedTileCoords[1],":" , selectedTileCoords[2], " flagged: ", selectedTile.isFlagged)                   
                else
                    print("Can't place a flag on a revaled tile.")
                end
            end
        end
    end
end


function SelectTile(x, y)
    if x <= GameSizeX and y <= GameSizeY then
        if not MapGenerated then
            GenerateMap({x,y})
            MapGenerated = true
        end
        -- TODO: I don't like this being two separate vars :(
        selectedTile = Map[x][y]
        selectedTileCoords = {x, y}
    end
end