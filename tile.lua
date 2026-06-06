Tile = Object.extend(Object)


function Tile:new(coords, has_mine)
    self.has_mine = has_mine
    self.is_revealed = false
    self.is_flagged = false
    self.mined_neighbours = 0
    --print("Tile created at: ", self.coords[1], ", ", self.coords[2]) 
end
