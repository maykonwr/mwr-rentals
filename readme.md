# Dependencies
- QBCore 
- qb-target https://github.com/qbcore-framework/qb-target
- ox_inventory https://github.com/overextended/ox_inventory
- ox_lib https://github.com/overextended/ox_lib/releases/tag/v3.16.3
- rep-talkNPC https://github.com/BahnMiFPS/rep-talkNPC/releases/tag/v1.0.4
------------------------------------------------------------------------------------

# Installation

* Go to ox_inventory > data > items.lua add the following items 
```lua
		["rentalpapers"] = {
			label = "Rental Documents",
			weight = 0,
			stack = false,
			close = true,
			client = {
				image = "documents.png",
			}
		},
		["rentalkeys"] = {
			label = "Rental Keys",
			weight = 0,
			stack = false,
			close = true,
			client = {
				image = "rentalkeys.png",
				export = 'mwr-rentals.usekeys'
			}
		},
```

* Copy the images within rental images folder and go to ox_inventory > web > images and paste the images