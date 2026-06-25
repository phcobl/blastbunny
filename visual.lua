TileSize = 8

function VisualInit()
    TileImage = love.graphics.newImage("tile.png")
    TileImage:setFilter("linear", "nearest")
    TileFrames = {}
    TileFrames["normal"] = love.graphics.newQuad(0, 0, TileSize, TileSize, TileImage:getWidth(), TileImage:getHeight())
    TileFrames["revealed"] = love.graphics.newQuad(TileSize, 0, TileSize, TileSize, TileImage:getWidth(), TileImage:getHeight())

    DecalImage = love.graphics.newImage("decal.png")
    DecalImage:setFilter("linear", "nearest")
    DecalFrames = {}
    for i=1, 10 do
        DecalFrames[i] = love.graphics.newQuad((i-1)*TileSize, 0, TileSize, TileSize, DecalImage:getWidth(), DecalImage:getHeight())
    end

    canvas = love.graphics.newCanvas(GameSizeX*TileSize, GameSizeY*TileSize)
    canvas:setFilter("linear", "nearest")

    VisualPixelScale = 2
    --love.window.setMode(400*visual_pixelScale, 240*visual_pixelScale)
end


function VisualDraw()
    love.graphics.draw(canvas, 0, 0, 0, VisualPixelScale, VisualPixelScale)
end


function CanvasDraw()
    if not Map then
        return
    end
    love.graphics.setCanvas(canvas)
        love.graphics.clear(0, 0, 0)
        for x = 1, GameSizeX do
            for y = 1, GameSizeY do
                local currentTile = Map[x][y]
                if Map[x][y].isRevealed then
                    love.graphics.draw(TileImage, TileFrames.revealed, x*TileSize-TileSize, y*TileSize-TileSize)
                    if currentTile.hasMine then
                        love.graphics.draw(DecalImage, DecalFrames[10], x*TileSize-TileSize, y*TileSize-TileSize)
                    elseif currentTile.minedNeighbours > 0 then
                        love.graphics.draw(DecalImage, DecalFrames[currentTile.minedNeighbours], x*TileSize-TileSize, y*TileSize-TileSize)
                    end
                else
                    love.graphics.draw(TileImage, TileFrames.normal, x*TileSize-TileSize, y*TileSize-TileSize)
                    if Map[x][y].isFlagged then
                        love.graphics.draw(DecalImage, DecalFrames[9], x*TileSize-TileSize, y*TileSize-TileSize)
                    end
                end
            end
        end
    love.graphics.setCanvas()
end


function CanvasReset()
    love.graphics.setCanvas(canvas)
        love.graphics.clear(0, 0, 0)
        for x = 1, GameSizeX do
            for y = 1, GameSizeY do
                love.graphics.draw(TileImage, TileFrames.normal, x*TileSize-TileSize, y*TileSize-TileSize)
            end
        end
    love.graphics.setCanvas()
end