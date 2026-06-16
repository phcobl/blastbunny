Tile = Object.extend(Object)


function Tile:new()
    self.hasMine = false
    self.isRevealed = false
    self.isFlagged = false
    self.minedNeighbours = 0
end