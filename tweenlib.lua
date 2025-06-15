--@name tweenLib
--@author Trench Rat
--@shared

twLib = {}
local tweens = {}


EASE = { -- oh zrya ya tuda polez..
    LINEAR = function(t) return t end,
    QUAD_IN = function(t) return t * t end,
    QUAD_OUT = function(t) return t * (2 - t) end,
    QUAD_IN_OUT = function(t) return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t end,
    CUBIC_IN = function(t) return t * t * t end,
    CUBIC_OUT = function(t) return (t - 1) * (t - 1) * (t - 1) + 1 end,
    CUBIC_IN_OUT = function(t) return t < 0.5 and 4 * t * t * t or (t - 1) * (2 * t - 2) * (2 * t - 2) + 1 end,
    SINE_IN = function(t) return 1 - math.cos(t * math.pi / 2) end,
    SINE_OUT = function(t) return math.sin(t * math.pi / 2) end,
    SINE_IN_OUT = function(t) return -0.5 * (math.cos(math.pi * t) - 1) end
}


Tween = {}
Tween.__index = Tween


function updateAll(dt)
    local removing = {}
    
    for id, tween in pairs(tweens) do
        if tween.completed then 
            table.insert(removing, id)
        else
            tween:_update(dt)
        end
    end
    
    for _, id in ipairs(removing) do tweens[id] = nil end
end

function Tween.new(start, target, duration, style, onUpdated, onCompleted)
    local self = setmetatable({}, Tween)
    
    self.duration = duration
    self.start = start
    self.target = target
    self.style = style
    self.value = start
    self.id = "tween@"..string.sub(tostring({}), 8)
    self.completed = false
    self.elapsed = 0
    self.onCompleted = onCompleted
    self.onUpdated = onUpdated
    
    tweens[self.id] = self
    return self
end

function Tween:_update(dt)
    if self.completed == true then return end
    
    self.elapsed = self.elapsed + dt
    
    if self.elapsed >= self.duration then
        self.elapsed = self.duration
        self.value = self.target
        self.completed = true
        if self.onCompleted then self.onCompleted(self) end
    else
        local t = self.style(self.elapsed / self.duration)
        if type(self.target) == "number" then self.value = math.lerp(self.value, self.target, t)
        elseif type(self.target) == "Vector" then self.value = math.lerpVector(t, self.value, self.target)
        elseif type(self.target) == "Angle" then self.value = math.lerpAngle(t, self.value, self.target) end
    end
    
    if self.onUpdated then self.onUpdated(self) end
end

function Tween:cancel()
    self.completed = true  
end

function Tween:reset()
    self.elapsed = 0
    self.value = self.start
    self.completed = false
end
