**CFX Forum Post**
Link soon

**Features**
* Multiple fishs + chance of bite
* Everything configurable
* Discord Logs
* Add as many fish (or special items) as you want
* Configurable notification

**Requirements**
* ox_inventory
* ox_lib


**Installation:**
**Create Items**<br>
/ox_inventory/data/items.lua
```
['tuna'] = {
  label = 'Tuna',
  weight = 100,
  stack = true,
  close = false,
},
['salmon'] = {
  label = 'Salmon',
  weight = 100,
  stack = true,
  close = false,
},

['trout'] = {
  label = 'Trout',
  weight = 100,
  stack = true,
  close = false,
},

['anchovy'] = {
  label = 'Anchovy',
  weight = 100,
  stack = true,
  close = false,
},

['fishbait'] = {
  label = 'Fishbait',
  weight = 50,
  stack = true,
  close = false,
},
```

**Create Fishing Rod**<br>
/ox_inventory/data/weapons.lua
```
['fishingrod'] = {
  label = 'Fishing Rod',
  durability = 0.01,
  weight = 500,
  stack = true,
  close = true,
},
```

**Add usable item**<br>
/ox_inventory/modules/items/client.lua
```
Item('fishingrod', function(data, slot)
  ox_inventory:useItem(data, function(data)
    if data then
      TriggerEvent('aleks_fishing:startFishing')
    end
  end)
end)```
