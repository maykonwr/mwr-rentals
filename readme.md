# Dependencies
- QBCore 
- qb-target https://github.com/qbcore-framework/qb-target
- lj-inventory/qb-inventory
- ox_lib https://github.com/overextended/ox_lib/releases/tag/v2.21.0
------------------------------------------------------------------------------------

# Installation

- Copy the image from the images folder into your inventory images
- Head to your inventory html folder and open the js folder and then open the .js file
- Search for the following:
```lua
} else if (itemData.name == 'stickynote') {
```

above it paste the following:

```lua
    } else if (itemData.name == "rentalpapers") {
        $(".item-info-title").html('<p>' + itemData.label + '</p>')
        $(".item-info-description").html('<p><strong>Name: </strong><span>'+ itemData.info.name +
        '</span></p><p><strong>Vehicle Model: </strong><span>'+ itemData.info.vehicle_model + '</span></p><p><strong>License Plate: </strong><span>'+ itemData.info.vehicle_plate+
        '</span></p><p><strong>Rental Date: </strong><span>'+ itemData.info.rental_date + '</span></p><p><strong>Rented Time: </strong><span>'+ itemData.info.rental_time + '</span></p><p><strong>Rented Until: </strong><span>'+ 
        itemData.info.rental_expiration);
    } else if (itemData.name == "rentalkeys") {
        $(".item-info-title").html("<p>" + itemData.label + "</p>");
        $(".item-info-description").html(
            "<p><strong>Vehicle Model: </b> " + "<a style=\"font-size:bold;color:yellow\">" +
            itemData.info.vehicle_model +"</a>" +
            "</span></p><p><strong>Vehicle Plate: </b> " + "<a style=\"font-size:bold;color:yellow\">" +
            itemData.info.vehicle_plate +"</a>"
        );
```

- Next go to you qb-core folder then open the shared items.lua and add the following:
```lua
	['rentalpapers'] 				 = {['name'] = 'rentalpapers', 			  	  	['label'] = 'Rental Documents', 			['weight'] = 0, 		['type'] = 'item', 		['image'] = 'documents.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
	['rentalkeys'] 				 = {['name'] = 'rentalkeys', 			  	  	['label'] = 'Rental Keys', 			['weight'] = 0, 		['type'] = 'item', 		['image'] = 'rentalkeys.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = ''},
```

# OX INVENTORY HOW TO 

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