tileSize = 8

function visualInit()
    tileImage = love.graphics.newImage("tile.png")
    tileImage:setFilter("linear", "nearest")
    tileFrames = {}
    tileFrames["normal"] = love.graphics.newQuad(0, 0, tileSize, tileSize, tileImage:getWidth(), tileImage:getHeight())
    tileFrames["revealed"] = love.graphics.newQuad(tileSize, 0, tileSize, tileSize, tileImage:getWidth(), tileImage:getHeight())

    decalImage = love.graphics.newImage("decal.png")
    decalImage:setFilter("linear", "nearest")
    decalFrames = {}
    for i=1, 10 do
        decalFrames[i] = love.graphics.newQuad((i-1)*tileSize, 0, tileSize, tileSize, decalImage:getWidth(), decalImage:getHeight())
    end

    canvas = love.graphics.newCanvas(game_sizex*tileSize, game_sizey*tileSize)
    canvas:setFilter("linear", "nearest")

    visual_pixelScale = 2
end

function visualDraw()
    love.graphics.draw(canvas, 0, 0, 0, visual_pixelScale, visual_pixelScale)
end

function canvasDraw()
    if not map then
        return
    end
    love.graphics.setCanvas(canvas)
        love.graphics.clear(0, 0, 0)
        for x = 1, game_sizex do
            for y = 1, game_sizey do
                local currentTile = map[x][y]
                if map[x][y].isRevealed then
                    love.graphics.draw(tileImage, tileFrames.revealed, x*tileSize-tileSize, y*tileSize-tileSize)
                    if currentTile.hasMine then
                        love.graphics.draw(decalImage, decalFrames[10], x*tileSize-tileSize, y*tileSize-tileSize)
                    elseif currentTile.minedNeighbours > 0 then
                        love.graphics.draw(decalImage, decalFrames[currentTile.minedNeighbours], x*tileSize-tileSize, y*tileSize-tileSize)
                    end
                else
                    love.graphics.draw(tileImage, tileFrames.normal, x*tileSize-tileSize, y*tileSize-tileSize)
                end
            end
        end
    love.graphics.setCanvas()
end

function canvasReset()
    love.graphics.setCanvas(canvas)
        love.graphics.clear(0, 0, 0)
        for x = 1, game_sizex do
            for y = 1, game_sizey do
                love.graphics.draw(tileImage, tileFrames.normal, x*tileSize-tileSize, y*tileSize-tileSize)
            end
        end
    love.graphics.setCanvas()
end