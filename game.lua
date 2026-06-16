-- Map generation helpers
solveAttempts = 0
maxSolveAttempts = 50

--
-- 0 = game in progress
-- 1 = game won
-- 2 = fuck you, you lose
winState = 0


function gameInit(x, y, m)
    game_sizex = x
    game_sizey = y
    game_mines = m
    --game_state = "init"
end


function generateMap(startTileCoords)
    -- step 1: generate field
    map = {}
    for x = 1, game_sizex do
        map[x] = {}
        for y = 1, game_sizey do
            --print("Creating new tile at: ", x, ", ", y)
            map[x][y] = Tile()
        end
    end

    -- step 2: fill field with mines
    local attempt = 0
    local i = 0
    --print("max fields: ", game_sizex * game_sizey)
    --print("max attempts: ", game_sizex * game_sizey * 10)
    while i < game_mines do
        if attempt < game_sizex * game_sizey * 10 then
            local rx = love.math.random(1, game_sizex)
            local ry = love.math.random(1, game_sizey)
            local tile = map[rx][ry]
            --print("Generating Mine #", i, ". Attempt #", attempt)
            if tile.hasMine or (rx == startTileCoords[1] and ry == startTileCoords[2]) then
                attempt = attempt + 1
                --print("new attempt")
            else
                tile.hasMine = true
                addMineToNeighbours({rx, ry})
                i = i + 1
            end
        else
            print("I tried so hard and got so far. But in the end I fucked up the minefield generator. ~Freddy")
            i = game_mines
        end
    end
    
    -- step 3: check if map can be solved
    -- Not working yet, implement isMapSolveable to get it working
    if solveAttempts < maxSolveAttempts then
        if not isMapSolveable(startTileCoords) then
            solveAttempts = solveAttempts + 1
            print("Can't solve map. Trying again.")
            generateMap(startTileCoords)
            return
        end
    else
        print("This shit is too hard for me to solve. Maybe choose different generation parameters?")
        return
    end

    -- step 4: reveal first tile
    revealTile(startTileCoords)
    --debugDrawStuff()
end


function addMineToNeighbours(mineCoord)
    local neighbourCoordsArray = getNeighbourCoords(mineCoord)
    for i = 1, #neighbourCoordsArray do
        local neighbourTile = map[neighbourCoordsArray[i][1]][neighbourCoordsArray[i][2]]
        neighbourTile.minedNeighbours = neighbourTile.minedNeighbours + 1
    end
end


function revealTile(coord)
    local tile = map[coord[1]][coord[2]]
    tile.isRevealed = true

    if tile.minedNeighbours == 0 then
        local neighbourCoordsArray = getNeighbourCoords({coord[1], coord[2]})
        for i = 1, #neighbourCoordsArray do
            local neighbourTile = map[neighbourCoordsArray[i][1]][neighbourCoordsArray[i][2]]
            if neighbourTile.hasMine == false then
                if neighbourTile.isRevealed == false then
                    revealTile({neighbourCoordsArray[i][1], neighbourCoordsArray[i][2]})
                end
            end
        end
    end
    isWin()
    canvasDraw()
end


function toggleFlag(coord)
    local tile = map[coord[1]][coord[2]]
    if tile.isRevealed then
        return
    end
    tile.isFlagged = not tile.isFlagged
    canvasDraw()
end


function getNeighbourCoords(coord)
    local neighbours = {}
    for x = -1, 1 do
        for y = -1, 1 do
            if (x ~= 0) or (y ~= 0) then
                local neighbour_x = coord[1] + x
                local neighbour_y = coord[2] + y
                if neighbour_x > 0 and neighbour_x <= #map and neighbour_y > 0 and neighbour_y <= #map[1] then
                    table.insert(neighbours, {neighbour_x, neighbour_y})
                end
            end
        end
    end
    return neighbours
end


-- Unused. Implement this later maybe.
function isMapSolveable(startCoord)
    return true
end


-- Maybe useful for is_map_solveable
function isTileSolveable(tileCoords)
    local neighbours = getNeighbourCoords(tileCoords)
end


-- Returns true if the game has been won (All non-mined tiles revealed)
function isWin()
    for x = 1, #map do
        for y = 1, #map[1] do
            local tile = map[x][y]
            if not tile.isRevealed and not tile.hasMine then
                return false
            end
        end
    end
    print("You win!")
    return true
end


-- Debug Draw


function debugDrawStuff()
    debugDrawMinefield()
    io.write("\n")
    debugDrawNeighbours()
    io.write("\n")
    debugDrawRevealed()
end


function debugDrawMinefield()
    for x = 1, #map do
        for y = 1, #map[1] do
            if map[x][y].hasMine then
                io.write(" X ")
            else
                io.write(" O ")
            end
        end
        io.write("\n")
    end
end


function debugDrawNeighbours()
    for x = 1, #map do
        for y = 1, #map[1] do
            if map[x][y].hasMine then
                io.write(" X ")
            else
                io.write(" ", map[x][y].minedNeighbours , " ")
            end
        end
        io.write("\n")
    end
    
end


function debugDrawRevealed()
    for x = 1, #map do
        for y = 1, #map[1] do
            local neighbours = map[x][y].minedNeighbours
            if map[x][y].isRevealed then
                io.write(" ", neighbours," ")
            else
                io.write(" - ")
            end
        end
        io.write("\n")
    end
end