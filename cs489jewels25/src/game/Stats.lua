local Class = require "libs.hump.class"
local Timer = require "libs.hump.timer"
local Tween = require "libs.tween" 
local Sounds = require "src.game.SoundEffects"

local statFont = love.graphics.newFont(26)

local Stats = Class{}
function Stats:init()
    self.y = 10 -- we will need it for tweening later
    self.level = 1 -- current level    
    self.totalScore = 0 -- total score so far
    self.targetScore = 1000
    self.maxSecs = 99 -- max seconds for the level
    self.elapsedSecs = 0 -- elapsed seconds
    self.timeOut = false -- when time is out
    self.tweenLevel = nil -- for later
end

function Stats:draw()
    love.graphics.setColor(1,0,1) -- Magenta
    love.graphics.printf("Level "..tostring(self.level), statFont, gameWidth/2-60,self.y,100,"center")
    love.graphics.printf(string.format("Time %d", self.elapsedSecs).."/"..tostring(self.maxSecs), statFont,10,10,200)
    love.graphics.printf("Score "..tostring(self.totalScore), statFont,gameWidth-210,10,200,"right")
    love.graphics.setColor(1,1,1) -- White
end
    
function Stats:update(dt) -- for now, empty function
    self:keepTime(dt)
    --self:levelUp()
    if self.tweenLevel then
        self.tweenLevel:update(dt)
    end
end

function Stats:addScore(n)
    self.totalScore = self.totalScore + n
    if self.totalScore > self.targetScore then
        self:levelUp()
    end
end

function Stats:keepTime(dt) --new time function
    self.elapsedSecs = self.elapsedSecs + dt
    --self.elapsedSecs = 
    if self.elapsedSecs >= self.maxSecs then
        self.timeOut = true
        self:roundOver()
    end
end

function Stats:levelUp()
    self.level = self.level +1
    self.targetScore = self.targetScore+self.level*1000
    self.elapsedSecs = 0 --reset timer to 0
    --self.elapsedSecs = self.elapsedSecs - 1 --each level up time goes down by 10
     --add tween
    --add tween animation
    self.y = -50 
    self.tweenLevel = Tween.new(1, self, { y = 10 }, 'outBounce')
    
    --add sound effects
    if Sounds["levelUp"]:isPlaying() then
        Sounds["levelUp"]:stop()
    end
    Sounds["levelUp"]:play()  
end

function Stats:roundOver()
    if self.totalScore >= self.targetScore then
        self:levelUp() --go to next level once target score is hit
        self.timeOut = false --time is not over
    else
        self.timeOut = true --time is over

         --added sounds
        if Sounds["timeOut"]:isPlaying() then
            Sounds["timeOut"]:stop()
        end
        Sounds["timeOut"]:play()
    end 
end
    
return Stats
    