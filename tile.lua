Tile = Object.extend(Object)


function Tile:new(coords, hasMine)
    self.hasMine = has_mine
    self.isRevealed = false
    self.isFlagged = false
    self.minedNeighbours = 0
    --print("Tile created at: ", self.coords[1], ", ", self.coords[2]) 
end