Tile = Object.extend(Object)


function Tile:new()
    self.has_mine = false
    self.is_revealed = false
    self.is_flagged = false
    self.mined_neighbours = 0
end