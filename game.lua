-- Map generation helpers
Solve_Attempts = 0
Max_Solve_Attempts = 50
Map_Generated = false


-- 0 = game in progress
-- 1 = game won
-- 2 = fuck you, you lose
Win_State = 0


function gameInit(x, y, m)
    Game_Size_X = x
    Game_Size_Y = y
    Game_Mines = m
    --game_state = "init"
end


function generateMap(start_tile_coords)
    -- step 1: generate field
    Map = {}
    for x = 1, Game_Size_X do
        Map[x] = {}
        for y = 1, Game_Size_Y do
            --print("Creating new tile at: ", x, ", ", y)
            Map[x][y] = Tile()
        end
    end

    -- step 2: fill field with mines
    local attempt = 0
    local i = 0
    --print("max fields: ", game_sizex * game_sizey)
    --print("max attempts: ", game_sizex * game_sizey * 10)
    while i < Game_Mines do
        if attempt < Game_Size_X * Game_Size_Y * 10 then
            local rx = love.math.random(1, Game_Size_X)
            local ry = love.math.random(1, Game_Size_Y)
            local tile = Map[rx][ry]
            --print("Generating Mine #", i, ". Attempt #", attempt)
            if tile.has_mine or (rx == start_tile_coords[1] and ry == start_tile_coords[2]) then
                attempt = attempt + 1
                --print("new attempt")
            else
                tile.has_mine = true
                addMineToNeighbours({rx, ry})
                i = i + 1
            end
        else
            print("I tried so hard and got so far. But in the end I fucked up the minefield generator. ~Freddy")
            i = Game_Mines
        end
    end
    
    -- step 3: check if map can be solved
    -- Not working yet, implement isMapSolveable to get it working
    if Solve_Attempts < Max_Solve_Attempts then
        if not isMapSolveable(start_tile_coords) then
            Solve_Attempts = Solve_Attempts + 1
            print("Can't solve map. Trying again.")
            generateMap(start_tile_coords)
            return
        end
    else
        print("This shit is too hard for me to solve. Maybe choose different generation parameters?")
        return
    end
    Solve_Attempts = 0

    -- step 4: reveal first tile
    revealTile(start_tile_coords)
    --debugDrawStuff()
end


function restartGame(size_x, size_y, mine_count)
    Map = {}
    Win_State = 0
    Map_Generated = false

    gameInit(size_x, size_y, mine_count)
    visualInit()
    canvasReset()
end


function addMineToNeighbours(mine_coord)
    local neighbour_coords_array = getNeighbourCoords(mine_coord)
    for i = 1, #neighbour_coords_array do
        local neighbour_tile = Map[neighbour_coords_array[i][1]][neighbour_coords_array[i][2]]
        neighbour_tile.mined_neighbours = neighbour_tile.mined_neighbours + 1
    end
end


function revealTile(coord)
    local tile = Map[coord[1]][coord[2]]
    tile.is_revealed = true

    if tile.mined_neighbours == 0 then
        local neighbour_coords_array = getNeighbourCoords({coord[1], coord[2]})
        for i = 1, #neighbour_coords_array do
            local neighbour_tile = Map[neighbour_coords_array[i][1]][neighbour_coords_array[i][2]]
            if neighbour_tile.has_mine == false then
                if neighbour_tile.is_revealed == false then
                    revealTile({neighbour_coords_array[i][1], neighbour_coords_array[i][2]})
                end
            end
        end
    end
    isWin()
    canvasDraw()
end


function toggleFlag(coord)
    local tile = Map[coord[1]][coord[2]]
    if tile.is_revealed then
        return
    end
    tile.is_flagged = not tile.is_flagged
    canvasDraw()
end


function getNeighbourCoords(coord)
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
function isMapSolveable(start_coord)
    return true
end


-- Maybe useful for is_map_solveable
function IsTileSolveable(tile_coords)
    local neighbours = getNeighbourCoords(tile_coords)
end


-- Returns true if the game has been won (All non-mined tiles revealed)
function isWin()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            local tile = Map[x][y]
            if not tile.is_revealed and not tile.has_mine then
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
    for x = 1, #Map do
        for y = 1, #Map[1] do
            if Map[x][y].has_mine then
                io.write(" X ")
            else
                io.write(" O ")
            end
        end
        io.write("\n")
    end
end


function debugDrawNeighbours()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            if Map[x][y].has_mine then
                io.write(" X ")
            else
                io.write(" ", Map[x][y].mined_neighbours , " ")
            end
        end
        io.write("\n")
    end
    
end


function debugDrawRevealed()
    for x = 1, #Map do
        for y = 1, #Map[1] do
            local neighbours = Map[x][y].mined_neighbours
            if Map[x][y].is_revealed then
                io.write(" ", neighbours," ")
            else
                io.write(" - ")
            end
        end
        io.write("\n")
    end
end