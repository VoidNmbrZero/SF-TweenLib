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
    
    self.duration = duration
    self.start = start
    self.target = target
    self.style = style
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
        self.value = self.target
        self.completed = true
        self.playing = false
        hook.remove("Think", self.id.." updater")
        if self.onCompleted then self.onCompleted(self) end
    else
        local t = self.style(self.elapsed / self.duration)
        if type(self.target) == "number" then self.value = math.lerp(t, self.start, self.target)
        elseif type(self.target) == "Vector" then self.value = math.lerpVector(t, self.start, self.target)
        elseif type(self.target) == "Angle" then self.value = math.lerpAngle(t, self.start, self.target)
        elseif type(self.target) == "Color" then self.value = lerpColor(t, self.start, self.target) end
    end
    
    if self.onUpdated then self.onUpdated(self) end
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
    self = nil
end

return Tween
