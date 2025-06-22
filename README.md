# TweenLib

###### README in other languages: `ENG`/[`RUS`](https://github.com/VoidNmbrZero/SF-TweenLib/blob/main/README_RU.md)

A simple, easy to understand [Starfall-Ex](https://github.com/thegrb93/StarfallEx) tweening library.

### USAGE: 

Add this to your script:
```lua
--@include https://github.com/VoidNmbrZero/SF-TweenLib/raw/refs/heads/main/tweenlib.lua as TweenLib
local Tween = require("TweenLib")
```

### FUNCTIONS:

#### tweenLib.new(start, target, duration, style, onUpdated, onCompleted) -> Tween
> Returns a brand new `Tween`

+ start: `number` | `Vector` | `Angle` | `Color`
  + value `Tween` begins from

+ target: `number` | `Vector` | `Angle` | `Color`
  + value `Tween` ends at (type must match start)

+ duration: `number`
  + time (in seconds) it will take to reach target

+ style: `function`
  + an ease function from math library
  + **NOTE**: for linear easing you should use a function that returns it's first and the only argument
  
+ onUpdated: `function(self)?`
  + (optional) function called upon `Tween` updating
  + passed arguments: `self`
  
+ onCompleted: `function(self?`
  + (optional) function called upon `Tween` reaching it's target
  + passed arguments: `self`

#### Tween:play() -> void
> Begins the `Tween`

#### Tween:pause() -> void
> Temporialy stops the `Tween`

#### Tween:restart() -> void
> Starts `Tween` from the beginning

#### Tween:destroy() -> void
> Pauses and "destroys" `Tween`, setting it's table to `nil`

### EXAMPLE:

```lua
--@name tweenLib Example
--@author Trench Rat
--@shared
--@include https://github.com/VoidNmbrZero/SF-TweenLib/raw/refs/heads/main/tweenlib.lua as TweenLib
local Tween = require("TweenLib")

Tween.new(chip():getPos(), chip():getPos+Vector(0, 0, 50), 3, math.easeInOutExpo, function(self) chip():setPos(self.value) end, function(self) self:restart() end):play()
```
Moves the chip by 50 units up, under the duration of 3 seconds with exponentional in & out ease, infinetely.
