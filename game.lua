-- Map generation helpers
SolveAttempts = 0
MaxSolveAttempts = 50

--
-- 0 = game in progress
-- 1 = game won
-- 2 = fuck you, you lose
WinState = 0


function GameInit(x, y, m)
    GameSizeX = x
    GameSizeY = y
    GameMines = m
    --game_state = "init"
end


function GenerateMap(startTileCoords)
    -- step 1: generate field
    Map = {}
    for x = 1, GameSizeX do
        Map[x] = {}
        for y = 1, GameSizeY do
            --print("Creating new tile at: ", x, ", ", y)
            Map[x][y] = Tile()
        end
    end

    -- step 2: fill field with mines
    local attempt = 0
    local i = 0
    --print("max fields: ", game_sizex * game_sizey)
    --print("max attempts: ", game_sizex * game_sizey * 10)
    while i < GameMines do
        if attempt < GameSizeX * GameSizeY * 10 then
            local rx = love.math.random(1, GameSizeX)
            local ry = love.math.random(1, GameSizeY)
            local tile = Map[rx][ry]
            --print("Generating Mine #", i, ". Attempt #", attempt)
            if tile.hasMine or (rx == startTileCoords[1] and ry == startTileCoords[2]) then
                attempt = attempt + 1
                --print("new attempt")
            else
                tile.hasMine = true
                AddMineToNeighbours({rx, ry})
                i = i + 1
            end
        else
            print("I tried so hard and got so far. But in the end I fucked up the minefield generator. ~Freddy")
            i = GameMines
        end
    end
    
    -- step 3: check if map can be solved
    -- Not working yet, implement isMapSolveable to get it working
    if SolveAttempts < MaxSolveAttempts then
        if not IsMapSolveable(startTileCoords) then
            SolveAttempts = SolveAttempts + 1
            print("Can't solve map. Trying again.")
            GenerateMap(startTileCoords)
            return
        end
    else
        print("This shit is too hard for me to solve. Maybe choose different generation parameters?")
        return
    end

    -- step 4: reveal first tile
    RevealTile(startTileCoords)
    --debugDrawStuff()
end


function AddMineToNeighbours(mineCoord)
    local neighbourCoordsArray = GetNeighbourCoords(mineCoord)
    for i = 1, #neighbourCoordsArray do
        local neighbourTile = Map[neighbourCoordsArray[i][1]][neighbourCoordsArray[i][2]]
        neighbourTile.minedNeighbours = neighbourTile.minedNeighbours + 1
    end
end


function RevealTile(coord)
    local tile = Map[coord[1]][coord[2]]
    tile.isRevealed = true

    if tile.minedNeighbours == 0 then
        local neighbourCoordsArray = GetNeighbourCoords({coord[1], coord[2]})
        for i = 1, #neighbourCoordsArray do
            local neighbourTile = Map[neighbourCoordsArray[i][1]][neighbourCoordsArray[i][2]]
            if neighbourTile.hasMine == false then
                if neighbourTile.isRevealed == false then
                    RevealTile({neighbourCoordsArray[i][1], neighbourCoordsArray[i][2]})
                end
            end
        end
    end
    IsWin()
    CanvasDraw()
end


function ToggleFlag(coord)
    local tile = Map[coord[1]][coord[2]]
    if tile.isRevealed then
        return
    end
    tile.isFlagged = not tile.isFlagged
    CanvasDraw()
end


function GetNeighbourCoords(coord)
    local neighbours = {}
    for x = -1, 1 do
        for y = -1, 1 do
            if (x ~= 0) or (y ~= 0) then
                local neighbour_x = coord[1] + x
                local neighbour_y = coord[2] + y
                if neighbour_x > 0 and neighbour_x <= #Map and neighbour_y > 0 and neighbour_y <= #Map[1] then
                    table.insert(neighbours, {neighbour_x, neighbour_y})
                end
            end
        end
    end
    return neighbours
end


-- Unused. Implement this later maybe.
function IsMapSolveable(startCoord)
    return true
end


-- Maybe useful for is_map_solveable
function IsTileSolveable(tileCoords)
    local neighbours = GetNeighbourCoords(tileCoords)
end


-- Returns true if the game has been won (All non-mined tiles revealed)
function IsWin()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            local tile = Map[x][y]
            if not tile.isRevealed and not tile.hasMine then
                return false
            end
        end
    end
    print("You win!")
    return true
end


-- Debug Draw


function DebugDrawStuff()
    DebugDrawMinefield()
    io.write("\n")
    DebugDrawNeighbours()
    io.write("\n")
    DebugDrawRevealed()
end


function DebugDrawMinefield()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            if Map[x][y].hasMine then
                io.write(" X ")
            else
                io.write(" O ")
            end
        end
        io.write("\n")
    end
end


function DebugDrawNeighbours()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            if Map[x][y].hasMine then
                io.write(" X ")
            else
                io.write(" ", Map[x][y].minedNeighbours , " ")
            end
        end
        io.write("\n")
    end
    
end


function DebugDrawRevealed()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            local neighbours = Map[x][y].minedNeighbours
            if Map[x][y].isRevealed then
                io.write(" ", neighbours," ")
            else
                io.write(" - ")
            end
        end
        io.write("\n")
    end
end