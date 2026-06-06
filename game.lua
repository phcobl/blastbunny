solve_attempts = 0
max_solve_attempts = 50


function generate_map(sizex, sizey, number_of_mines, start_tile_coords)
    -- step 1: generate field
    map = {}
    for x = 1, sizex do
        map [x] = {}
        for y = 1, sizey do
            --print("Creating new tile at: ", x, ", ", y)
            map[x][y] = Tile({x, y}, false)
        end
    end

    -- step 2: fill field with mines
    local attempt = 0
    i = 0
    --print("max fields: ", sizex * sizey)
    --print("max attempts: ", sizex * sizey * 10)
    while i < number_of_mines do
        if attempt < sizex * sizey * 10 then
            rx = math.random(1, sizex)
            ry = math.random(1, sizey)
            tile = map[rx][ry]
            --print("Generating Mine #", i, ". Attempt #", attempt)
            if tile.has_mine or (rx == start_tile_coords[1] and ry == start_tile_coords[2]) then
                attempt = attempt + 1
                --print("new attempt")
            else
                tile.has_mine = true
                add_mine_to_neighbours({rx, ry})
                i = i + 1
            end
        else
            print("I tried so hard and got so far. But in the end I fucked up the minefield generator. ~Freddy")
            i = number_of_mines
        end
    end
    

    if solve_attempts < max_solve_attempts then
        if not is_map_solveable(start_tile_coords) then
            solve_attempts = solve_attempts + 1
            print("Can't solve map. Trying again.")
            generate_map(sizex, sizey, number_of_mines, start_tile_coords)
            return
        end
    else
        print("This shit is too hard for me to solve. Maybe choose different generation parameters?")
        return
    end

    debug_draw_minefield()
    io.write("\n")
    debug_draw_neighbours()
    io.write("\n")
    debug_draw_revealed()
end


function add_mine_to_neighbours(mine_coord)
    local neighbour_coords_array = get_neighbour_coords(mine_coord)
    for i = 1, #neighbour_coords_array do
        local neighbour_tile = map[neighbour_coords_array[i][1]][neighbour_coords_array[i][2]]
        neighbour_tile.mined_neighbours = neighbour_tile.mined_neighbours + 1
    end
end


function reveal_tile(coord)
    local tile = map[coord[1]][coord[2]]
    tile.is_revealed = true

    if tile.mined_neighbours == 0 then
        local neighbour_coords_array = get_neighbour_coords({coord[1], coord[2]})
        for i = 1, #neighbour_coords_array do
            local neighbour_tile = map[neighbour_coords_array[i][1]][neighbour_coords_array[i][2]]
            if neighbour_tile.has_mine == false then
                if neighbour_tile.is_revealed == false then
                    reveal_tile({neighbour_coords_array[i][1], neighbour_coords_array[i][2]})
                end
            end
        end
    end
end


function get_neighbour_coords(coord)
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
function is_map_solveable(start_coord)
    return true
end


-- Maybe useful for is_map_solveable
function is_tile_solveable(tile_coords)
    local neighbours = get_neighbour_coords(tile_coords)
end


-- Debug Draw


function debug_draw_minefield()
    for x = 1, #map do
        for y = 1, #map[1] do
            if map[x][y].has_mine then
                io.write(" X ")
            else
                io.write(" O ")
            end
        end
        io.write("\n")
    end
end


function debug_draw_neighbours()
    for x = 1, #map do
        for y = 1, #map[1] do
            if map[x][y].has_mine then
                io.write(" X ")
            else
                io.write(" ", map[x][y].mined_neighbours , " ")
            end
        end
        io.write("\n")
    end
    
end


function debug_draw_revealed()
    for x = 1, #map do
        for y = 1, #map[1] do
            local neighbours = map[x][y].mined_neighbours
            if map[x][y].is_revealed then
                io.write(" ", neighbours," ")
            else
                io.write(" - ")
            end
        end
        io.write("\n")
    end
end

-- ####################################################################################

function draw_map()
end