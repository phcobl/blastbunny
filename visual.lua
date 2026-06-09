function visual_init()
    tile_image = love.graphics.newImage("tile.png")
    tile_frames = {}
    tile_frames["normal"] = love.graphics.newQuad(0, 0, 8, 8, tile_image:getWidth(), tile_image:getHeight())
    tile_frames["revealed"] = love.graphics.newQuad(8, 0, 8, 8, tile_image:getWidth(), tile_image:getHeight())

    decal_image = love.graphics.newImage("decal.png")
    decal_frames = {}
    for i=1, 10 do
        decal_frames[i] = love.graphics.newQuad((i-1)*8, 0, 8, 8, decal_image:getWidth(), decal_image:getHeight())
    end
end

function visual_draw()
    for x = 1, #map do
        for y = 1, #map[x] do
            local current_tile = map[x][y]
            if map[x][y].is_revealed then
                love.graphics.draw(tile_image, tile_frames.revealed, x*8, y*8)
                if current_tile.has_mine then
                    love.graphics.draw(decal_image, decal_frames[10], x*8, y*8)
                elseif current_tile.mined_neighbours > 0 then
                    love.graphics.draw(decal_image, decal_frames[current_tile.mined_neighbours], x*8, y*8)
                end
            else
                love.graphics.draw(tile_image, tile_frames.normal, x*8, y*8)
            end
        end
    end
end