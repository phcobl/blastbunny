Tile_Size = 8

function visualInit()
    Tile_Image = love.graphics.newImage("tile.png")
    Tile_Image:setFilter("linear", "nearest")
    Tile_Frames = {}
    Tile_Frames["normal"] = love.graphics.newQuad(0, 0, Tile_Size, Tile_Size, Tile_Image:getWidth(), Tile_Image:getHeight())
    Tile_Frames["revealed"] = love.graphics.newQuad(Tile_Size, 0, Tile_Size, Tile_Size, Tile_Image:getWidth(), Tile_Image:getHeight())

    Decal_Image = love.graphics.newImage("decal.png")
    Decal_Image:setFilter("linear", "nearest")
    Decal_Frames = {}
    for i=1, 10 do
        Decal_Frames[i] = love.graphics.newQuad((i-1)*Tile_Size, 0, Tile_Size, Tile_Size, Decal_Image:getWidth(), Decal_Image:getHeight())
    end

    Map_Canvas = love.graphics.newCanvas(Game_Size_X*Tile_Size, Game_Size_Y*Tile_Size)
    Map_Canvas:setFilter("linear", "nearest")

    Visual_Pixel_Scale = 2
    --love.window.setMode(400*visual_pixelScale, 240*visual_pixelScale)
end


function visualDraw()
    love.graphics.draw(Map_Canvas, 0, 0, 0, Visual_Pixel_Scale, Visual_Pixel_Scale)
end


function canvasDraw()
    if not Map then
        return
    end
    love.graphics.setCanvas(Map_Canvas)
        love.graphics.clear(0, 0, 0)
        for x = 1, Game_Size_X do
            for y = 1, Game_Size_Y do
                local current_Tile = Map[x][y]
                if Map[x][y].is_revealed then
                    love.graphics.draw(Tile_Image, Tile_Frames.revealed, x*Tile_Size-Tile_Size, y*Tile_Size-Tile_Size)
                    if current_Tile.has_mine then
                        love.graphics.draw(Decal_Image, Decal_Frames[10], x*Tile_Size-Tile_Size, y*Tile_Size-Tile_Size)
                    elseif current_Tile.mined_neighbours > 0 then
                        love.graphics.draw(Decal_Image, Decal_Frames[current_Tile.mined_neighbours], x*Tile_Size-Tile_Size, y*Tile_Size-Tile_Size)
                    end
                else
                    love.graphics.draw(Tile_Image, Tile_Frames.normal, x*Tile_Size-Tile_Size, y*Tile_Size-Tile_Size)
                    if Map[x][y].is_flagged then
                        love.graphics.draw(Decal_Image, Decal_Frames[9], x*Tile_Size-Tile_Size, y*Tile_Size-Tile_Size)
                    end
                end
            end
        end
    love.graphics.setCanvas()
end


function canvasReset()
    love.graphics.setCanvas(Map_Canvas)
        love.graphics.clear(0, 0, 0)
        for x = 1, Game_Size_X do
            for y = 1, Game_Size_Y do
                love.graphics.draw(Tile_Image, Tile_Frames.normal, x*Tile_Size-Tile_Size, y*Tile_Size-Tile_Size)
            end
        end
    love.graphics.setCanvas()
end