# ИНФОРМАЦИЯ:

###### README на другом языке: [`ENG`](https://github.com/VoidNmbrZero/SF-TweenLib/blob/main/README_RU.md)/`RUS`

Простая и понятная библеотека анимирования переменных для [Starfall-Ex](https://github.com/thegrb93/StarfallEx).

# ДОКУМЕНТАЦИЯ:

### ИСПОЛЬЗОВАНИЕ: 

Добавьте это в ваш скрипт:
```lua
--@include https://github.com/VoidNmbrZero/SF-TweenLib/raw/refs/heads/main/tweenlib.lua as TweenLib
local Tween = require("TweenLib")
```

### МЕТОДЫ:

#### tweenLib.new(start, target, duration, style, onUpdated, onCompleted) -> Tween
> Возвращает новый `Tween`

+ start: `number` | `Vector` | `Angle` | `Color`
  + значение с которого `Tween` начинает

+ target: `number` | `Vector` | `Angle` | `Color`
  + значение на котором `Tween` заканчивается

+ duration: `number`
  + время (в секундах) за которое происходит анимирование

+ style: `function`
  + функция плавности из библеотеки math
  + **ЗАМЕТКА**: для линейной плавности ипользуйте функцию возвращающию первый аргумент
  
+ onUpdated: `function(self)?`
  + (необяз.) функция вызываемая при обновлении `Tween`-а
  + получаемые аргументы: `self`
  
+ onCompleted: `function(self?`
  + (необяз.) функция вызываемая при окончании `Tween`-а
  + получаемые аргументы: `self`

#### Tween:play() -> void
> Начинает `Tween`

#### Tween:pause() -> void
> Временно останавливает `Tween`

#### Tween:restart() -> void
> Заново запускает `Tween` по новой

#### Tween:destroy() -> void
> Останавливает и"уничтожает" `Tween`, ставля значение его таблицы на `nil`

### ПРИМЕР:

```lua
--@name tweenLib Example
--@author Trench Rat
--@shared
--@include https://github.com/VoidNmbrZero/SF-TweenLib/raw/refs/heads/main/tweenlib.lua as TweenLib
local Tween = require("TweenLib")

Tween.new(chip():getPos(), chip():getPos+Vector(0, 0, 50), 3, math.easeInOutExpo, function(self) chip():setPos(self.value) end, function(self) self:restart() end):play()
```
Двигает чип на 50 единиц вверх, в течении 3 секунд с экспонентальной плавностью в обе стороны, бесконечно.
