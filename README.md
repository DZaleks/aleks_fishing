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
Create Items

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

Create Fishing Rod
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
