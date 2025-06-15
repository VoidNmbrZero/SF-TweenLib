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
    SINE_IN_OUT = function(t) return -0.5 * (math.cos(math.pi * t) - 1) end,
    EXPO_IN = function(t) return t == 0 and 0 or math.pow(2, 10 * (t - 1)) end,
    EXPO_OUT = function(t) return t == 1 and 1 or 1 - math.pow(2, -10 * t) end,
    EXPO_IN_OUT = function(t)
        if t == 0 then return 0 end
        if t == 1 then return 1 end
        if t < 0.5 then return math.pow(2, 20 * t - 10) / 2 end
        return (2 - math.pow(2, -20 * t + 10)) / 2
    end,
    BACK_IN = function(t)
        local s = 1.70158
        return t * t * ((s + 1) * t - s)
    end,
    BACK_OUT = function(t)
        local s = 1.70158
        t = t - 1
        return t * t * ((s + 1) * t + s) + 1
    end,
    BACK_IN_OUT = function(t)
        local s = 1.70158 * 1.525
        t = t * 2
        if t < 1 then return 0.5 * (t * t * ((s + 1) * t - s)) end
        t = t - 2
        return 0.5 * (t * t * ((s + 1) * t + s) + 2)
    end,
    ELASTIC_IN = function(t)
        if t == 0 then return 0 end
        if t == 1 then return 1 end
        return -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 3)
    end,
    ELASTIC_OUT = function(t)
        if t == 0 then return 0 end
        if t == 1 then return 1 end
        return math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * (2 * math.pi) / 3) + 1
    end,
    ELASTIC_IN_OUT = function(t)
        if t == 0 then return 0 end
        if t == 1 then return 1 end
        t = t * 2
        if t < 1 then return -0.5 * math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 4.5) end
        return math.pow(2, -10 * (t - 1)) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 4.5) * 0.5 + 1
    end,
    BOUNCE_OUT = function(t)
        if t < 1 / 2.75 then
            return 7.5625 * t * t
        elseif t < 2 / 2.75 then
            t = t - 1.5 / 2.75
            return 7.5625 * t * t + 0.75
        elseif t < 2.5 / 2.75 then
            t = t - 2.25 / 2.75
            return 7.5625 * t * t + 0.9375
        else
            t = t - 2.625 / 2.75
            return 7.5625 * t * t + 0.984375
        end
    end,
    BOUNCE_IN = function(t)
        return 1 - EASE.BOUNCE_OUT(1 - t)
    end,
    BOUNCE_IN_OUT= function(t)
        if t < 0.5 then return EASE.BOUNCE_IN(t * 2) * 0.5 end
        return EASE.BOUNCE_OUT(t * 2 - 1) * 0.5 + 0.5
    end,
    CIRC_IN = function(t) return 1 - math.sqrt(1 - t * t) end,
    CIRC_OUT = function(t) local t1 = t - 1 return math.sqrt(1 - t1 * t1) end,
    CIRC_IN_OUT = function(t) return t < 0.5 and (1 - math.sqrt(1 - 4 * t * t)) / 2 or (math.sqrt(1 - (2 * t - 2) * (2 * t - 2)) + 1) / 2 end,
    QUINT_IN = function(t) return t * t * t * t * t end,
    QUINT_OUT = function(t) local t1 = t - 1 return 1 + t1 * t1 * t1 * t1 * t1 end,
    QUINT_IN_OUT = function(t) return t < 0.5 and 16 * t * t * t * t * t or 1 + 16 * (t - 1) * (t - 1) * (t - 1) * (t - 1) * (t - 1) end,
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
        if type(self.target) == "number" then self.value = math.lerp(self.start, self.target, t)
        elseif type(self.target) == "Vector" then self.value = math.lerpVector(t, self.start, self.target)
        elseif type(self.target) == "Angle" then self.value = math.lerpAngle(t, self.start, self.target) end
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
