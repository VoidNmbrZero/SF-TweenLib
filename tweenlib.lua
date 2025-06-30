--@name tweenLib
--@author Trench Rat
--@shared


Tween = {} -- screw middleclass
Tween.__index = Tween

local function lerpColor(t, from, to)
    local r = math.lerp(t, from[1], to[1])
    local g = math.lerp(t, from[2], to[2])
    local b = math.lerp(t, from[3], to[3])
    local a = math.lerp(t, from[4], to[4])
    
    return Color(r, g, b, a)
end

function Tween.new(start, target, duration, style, onUpdated, onCompleted)
    local self = setmetatable({}, Tween)
    
    self.duration = math.max(0.001, duration)
    self.start = start
    self.target = target
    self.style = function(t) return math.clamp(style(t), 0, 1) end
    self.value = start
    self.playing = false
    self.id = "tween#"..string.sub(tostring({}), 8)
    self.completed = false
    self.elapsed = 0
    self.onCompleted = onCompleted
    self.onUpdated = onUpdated
    
    return self
end

function Tween:_update(dt)
    if self.completed == true or self.playing == false then return end
    
    self.elapsed = self.elapsed + dt
    
    if self.elapsed >= self.duration then
        self.elapsed = self.duration
        hook.remove("Think", self.id.." updater")
        self.completed = true
        self.playing = false
        
        self.value = self.target
        
        --[[if self.onUpdated then 
            self.onUpdated(self) 
        end]]
        
        if self.onCompleted then 
            self.onCompleted(self) 
        end
    else
        local t = self.style(self.elapsed / self.duration)
        math.clamp(t, 0, 1)
        
        if type(self.target) == "number" then 
            self.value = math.lerp(t, self.start, self.target)
        elseif type(self.target) == "Vector" then 
            self.value = math.lerpVector(t, self.start, self.target)
        elseif type(self.target) == "Angle" then 
            self.value = math.lerpAngle(t, self.start, self.target)
        elseif type(self.target) == "Color" then 
            self.value = lerpColor(t, self.start, self.target) 
        end
        
        if self.onUpdated then 
            self.onUpdated(self) 
        end
    end
end

function Tween:play()
    if self.playing == true then return end
    hook.add("Think", self.id.." updater", function() self:_update(timer.frametime()) end)
    self.completed = false
    self.playing = true
end

function Tween:pause()
    self.playing = false
end

function Tween:restart()
    self.elapsed = 0
    self.value = self.start
    self:play()
end

function Tween:destroy()
    self:pause()
    hook.remove("Think", self.id.." updater")
    self = nil
end

Ease = {
    Linear = function(t) return t end,

    Quad = {
        In = function(t) return t * t end,
        Out = function(t) return t * (2 - t) end,
        InOut = function(t) return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t end
    },

    Cubic = {
        In = function(t) return t * t * t end,
        Out = function(t) return (t - 1)^3 + 1 end,
        InOut = function(t) return t < 0.5 and 4 * t^3 or (t - 1)^3 + 1 end
    },

    Sine = {
        In = function(t) return 1 - math.cos(t * math.pi / 2) end,
        Out = function(t) return math.sin(t * math.pi / 2) end,
        InOut = function(t) return -0.5 * (math.cos(math.pi * t) - 1) end
    },

    Expo = {
        In = function(t) return t == 0 and 0 or 2^(10 * (t - 1)) end,
        Out = function(t) return t == 1 and 1 or 1 - 2^(-10 * t) end,
        InOut = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return t < 0.5 and 2^(20 * t - 10) / 2 or (2 - 2^(-20 * t + 10)) / 2
        end
    },

    Back = {
        In = function(t)
            local overshoot = 1.70158
            return t * t * ((overshoot + 1) * t - overshoot)
        end,
        Out = function(t)
            local overshoot = 1.70158
            t = t - 1
            return t * t * ((overshoot + 1) * t + overshoot) + 1
        end,
        InOut = function(t)
            local overshoot = 1.70158 * 1.525
            t = t * 2
            if t < 1 then return 0.5 * (t * t * ((overshoot + 1) * t - overshoot)) end
            t = t - 2
            return 0.5 * (t * t * ((overshoot + 1) * t + overshoot) + 2)
        end
    },

    Elastic = {
        In = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return -2^(10 * t - 10) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 3)
        end,
        Out = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            return 2^(-10 * t) * math.sin((t * 10 - 0.75) * (2 * math.pi) / 3) + 1
        end,
        InOut = function(t)
            if t == 0 then return 0 end
            if t == 1 then return 1 end
            t = t * 2
            if t < 1 then return -0.5 * 2^(10 * t - 10) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 4.5) end
            return 0.5 * 2^(-10 * (t - 1)) * math.sin((t * 10 - 10.75) * (2 * math.pi) / 4.5) + 1
        end
    },

    Bounce = {
        Out = function(t)
            local bounceConst = 7.5625
            if t < 1 / 2.75 then
                return bounceConst * t * t
            elseif t < 2 / 2.75 then
                t = t - 1.5 / 2.75
                return bounceConst * t * t + 0.75
            elseif t < 2.5 / 2.75 then
                t = t - 2.25 / 2.75
                return bounceConst * t * t + 0.9375
            else
                t = t - 2.625 / 2.75
                return bounceConst * t * t + 0.984375
            end
        end,
        In = function(t) return 1 - Ease.Bounce.Out(1 - t) end,
        InOut = function(t)
            if t < 0.5 then return Ease.Bounce.In(t * 2) * 0.5 end
            return Ease.Bounce.Out(t * 2 - 1) * 0.5 + 0.5
        end
    },

    Circ = {
        In = function(t) return 1 - math.sqrt(1 - t * t) end,
        Out = function(t) return math.sqrt(1 - (t - 1)^2) end,
        InOut = function(t)
            return t < 0.5 
                and (1 - math.sqrt(1 - 4 * t * t)) / 2 
                or (math.sqrt(1 - (2 * t - 2)^2) + 1) / 2
        end
    },

    Quint = {
        In = function(t) return t^5 end,
        Out = function(t) return 1 + (t - 1)^5 end,
        InOut = function(t)
            return t < 0.5 
                and 16 * t^5 
                or 1 + 16 * (t - 1)^5
        end
    }
}

return Tween
