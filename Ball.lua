Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height 
    
    self.dy = 0
    self.dx = 0
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    
--    self.dy = math.random(2) == 1 and -100 or 100
--    self.dx = math.random(-50,50)
end


function Ball:collides(player)
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end
        
    if self.y > player.y + player.height or player.y > self.y + self.height then 
        return false
    end
    
    return true
end
    
        
    
    
    
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt   
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end