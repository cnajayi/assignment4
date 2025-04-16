local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"

local spriGem = love.graphics.newImage(
    "graphics/sprites/coin_gem_spritesheet.png")
local gridGem = Anim8.newGrid(16,16,spriGem:getWidth(),spriGem:getHeight())

local Gem = Class{}
Gem.SIZE = 16
Gem.SCALE = 2.5
function Gem:init(x,y,type)
    self.x = x
    self.y = y
    self.type = type 
    if self.type == nil then 
        self.type = 4 
    end

    local row = (self.type >= 1 and self.type <= 3) and self.type or 4  --coins are 1-3, else default to gem type 4
    self.animation = Anim8.newAnimation(gridGem('1-4',self.type),0.25)
end

function Gem:setType(type)
    self.type = type
    self.animation = Anim8.newAnimation(gridGem('1-4',self.type),0.25)
end

function Gem:nextType()
    local newtype = self.type+1
    if newtype > 8 then newtype = 4 end
    self:setType(newtype)
end

function Gem:update(dt)
    self.animation:update(dt)
end

function Gem:draw()
    self.animation:draw(spriGem, self.x, self.y, 0, Gem.SCALE, Gem.SCALE)
end

function Gem:getColor()
    --colors for each gem type (4,8)
    local colors = {
        [1] = {1, 0.8, 0},      --gold
        [2] = {0.75, 0.75, 0.75}, --silver
        [3] = {0.8, 0.5, 0.2},  --bronze
        [4] = {1, 1, 0},        --yellow
        [5] = {0, 0, 1},        --blue
        [6] = {0.5, 0.5, 0.5},  --gray
        [7] = {1, 0, 0},        --red
        [8] = {0, 1, 0},        --green
    }
    return colors[self.type] or {1, 1, 1}  --white if type is invalid
end

return Gem
