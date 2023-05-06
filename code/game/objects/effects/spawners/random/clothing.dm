/obj/effect/spawner/random/clothing
	name = "clothing loot spawner"
	desc = "Time to look pretty."
	icon_state = "hat"

/obj/effect/spawner/random/clothing/costume
	name = "random costume spawner"
	icon_state = "costume"
	loot_subtype_path = /obj/effect/spawner/costume
	loot = list()

/obj/effect/spawner/random/clothing/beret_or_rabbitears
	name = "beret or rabbit ears spawner"
	loot = list(
		/obj/item/clothing/head/beret,
		/obj/item/clothing/head/rabbitears,
	)

/obj/effect/spawner/random/clothing/bowler_or_that
	name = "bowler or top hat spawner"
	loot = list(
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/that,
	)

/obj/effect/spawner/random/clothing/kittyears_or_rabbitears
	name = "kitty ears or rabbit ears spawner"
	loot = list(
		/obj/item/clothing/head/kitty,
		/obj/item/clothing/head/rabbitears,
	)

/obj/effect/spawner/random/clothing/pirate_or_bandana
	name = "pirate hat or bandana spawner"
	loot = list(
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/head/bandana,
	)

/obj/effect/spawner/random/clothing/twentyfive_percent_cyborg_mask
	name = "25% cyborg mask spawner"
	spawn_loot_chance = 25
	loot = list(/obj/item/clothing/mask/gas/cyborg)

/obj/effect/spawner/random/clothing/mafia_outfit
	name = "mafia outfit spawner"
	icon_state = "costume"
	loot = list(
		/obj/effect/spawner/costume/mafia = 20,
		/obj/effect/spawner/costume/mafia/white = 5,
		/obj/effect/spawner/costume/mafia/beige = 5,
		/obj/effect/spawner/costume/mafia/checkered = 2,
	)

/obj/effect/spawner/random/clothing/syndie
	name = "syndie outfit spawner"
	icon_state = "syndicate"
	loot = list(
		/obj/item/clothing/under/syndicate,
		/obj/item/clothing/under/syndicate/skirt,
		/obj/item/clothing/under/syndicate/bloodred,
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/clothing/under/syndicate/tacticool/skirt,
		/obj/item/clothing/under/syndicate/sniper,
		/obj/item/clothing/under/syndicate/camo,
		/obj/item/clothing/under/syndicate/soviet,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/clothing/under/syndicate/rus_army,
		/obj/item/clothing/under/syndicate/bloodred/sleepytime,
	)

/obj/effect/spawner/random/clothing/gloves
	name = "random gloves"
	desc = "These gloves are supposed to be a random color..."
	icon_state = "gloves"
	loot = list(
		/obj/item/clothing/gloves/color/orange,
		/obj/item/clothing/gloves/color/red,
		/obj/item/clothing/gloves/color/blue,
		/obj/item/clothing/gloves/color/purple,
		/obj/item/clothing/gloves/color/green,
		/obj/item/clothing/gloves/color/grey,
		/obj/item/clothing/gloves/color/light_brown,
		/obj/item/clothing/gloves/color/brown,
		/obj/item/clothing/gloves/color/white,
		/obj/item/clothing/gloves/color/rainbow,
	)

/obj/effect/spawner/random/clothing/wardrobe_closet
	name = "wardrobe closet spawner"
	icon_state = "locker_clothing"
	loot = list(
		/obj/structure/closet/gmcloset,
		/obj/structure/closet/chefcloset,
		/obj/structure/closet/jcloset,
		/obj/structure/closet/lawcloset,
		/obj/structure/closet/wardrobe/chaplain_black,
		/obj/structure/closet/wardrobe/red,
		/obj/structure/closet/wardrobe/cargotech,
		/obj/structure/closet/wardrobe/atmospherics_yellow,
		/obj/structure/closet/wardrobe/engineering_yellow,
		/obj/structure/closet/wardrobe/white/medical,
		/obj/structure/closet/wardrobe/robotics_black,
		/obj/structure/closet/wardrobe/chemistry_white,
		/obj/structure/closet/wardrobe/genetics_white,
		/obj/structure/closet/wardrobe/virology_white,
		/obj/structure/closet/wardrobe/science_white,
		/obj/structure/closet/wardrobe/botanist,
		/obj/structure/closet/wardrobe/curator,
		/obj/structure/closet/wardrobe/pjs,
	)

/obj/effect/spawner/random/clothing/wardrobe_closet_colored
	name = "colored uniform closet spawner"
	icon_state = "locker_clothing"
	loot = list(
		/obj/structure/closet/wardrobe/mixed,
		/obj/structure/closet/wardrobe,
		/obj/structure/closet/wardrobe/pink,
		/obj/structure/closet/wardrobe/black,
		/obj/structure/closet/wardrobe/green,
		/obj/structure/closet/wardrobe/orange,
		/obj/structure/closet/wardrobe/yellow,
		/obj/structure/closet/wardrobe/white,
		/obj/structure/closet/wardrobe/grey,
	)

/obj/effect/spawner/random/clothing/backpack
	name = "backpack spawner"
	icon_state = "backpack"
	loot = list(
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/clown,
		/obj/item/storage/backpack/explorer,
		/obj/item/storage/backpack/mime,
		/obj/item/storage/backpack/medic,
		/obj/item/storage/backpack/security,
		/obj/item/storage/backpack/industrial,
		/obj/item/storage/backpack/botany,
		/obj/item/storage/backpack/chemistry,
		/obj/item/storage/backpack/genetics,
		/obj/item/storage/backpack/science,
		/obj/item/storage/backpack/virology,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/eng,
		/obj/item/storage/backpack/satchel/med,
		/obj/item/storage/backpack/satchel/vir,
		/obj/item/storage/backpack/satchel/chem,
		/obj/item/storage/backpack/satchel/gen,
		/obj/item/storage/backpack/satchel/science,
		/obj/item/storage/backpack/satchel/hyd,
		/obj/item/storage/backpack/satchel/sec,
		/obj/item/storage/backpack/satchel/explorer,
		/obj/item/storage/backpack/duffelbag,
		/obj/item/storage/backpack/duffelbag/med,
		/obj/item/storage/backpack/duffelbag/explorer,
		/obj/item/storage/backpack/duffelbag/hydroponics,
		/obj/item/storage/backpack/duffelbag/chemistry,
		/obj/item/storage/backpack/duffelbag/genetics,
		/obj/item/storage/backpack/duffelbag/science,
		/obj/item/storage/backpack/duffelbag/virology,
		/obj/item/storage/backpack/duffelbag/sec,
		/obj/item/storage/backpack/duffelbag/engineering,
		/obj/item/storage/backpack/duffelbag/clown,
	)

/obj/effect/spawner/random/clothes
	name = "clothes spawner"
	loot = list(
		/obj/item/clothing/under/color/random = 1,
		/obj/item/clothing/under/color/grey = 1,
		/obj/item/clothing/under/misc/overalls = 1,
		/obj/item/clothing/under/misc/assistantformal = 1,
		/obj/item/clothing/under/suit/black = 1,
		/obj/item/clothing/under/suit/black/skirt = 1,
		/obj/item/clothing/under/suit/white = 1,
		/obj/item/clothing/under/suit/white/skirt = 1,
		/obj/item/clothing/under/suit/beige,
		/obj/item/clothing/under/pants/jeans = 1,
		/obj/item/clothing/under/pants/camo = 1,
		/obj/item/clothing/under/rank/civilian/bartender = 1,
		/obj/item/clothing/under/rank/civilian/bartender/skirt = 1
	)

/obj/effect/spawner/random/clothing/headgear
	name = "headgear spawner"
	loot = list(
		/obj/item/clothing/head/welding = 1,
		/obj/item/clothing/head/ushanka = 1,
		/obj/item/clothing/head/soft/grey = 1,
		/obj/item/clothing/head/soft/black = 1,
		/obj/item/clothing/head/chefhat = 1,
		/obj/item/clothing/head/beret = 1,
		/obj/item/clothing/head/beret/black = 1,
		/obj/item/clothing/head/fedora/curator = 1,
		/obj/item/clothing/head/helmet/old = 1,
		/obj/item/clothing/head/bandana = 1
	)

/obj/effect/spawner/random/clothing/shoes
	name = "shoes spawner"
	loot = list(
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/shoes/sneakers/brown = 1,
		/obj/item/clothing/shoes/sneakers/blue = 1,
		/obj/item/clothing/shoes/jackboots = 1
	)

/obj/effect/spawner/random/clothing/suit
	name = "suit spawner"
	loot = list(
		/obj/item/clothing/suit/toggle/labcoat = 1,
		/obj/item/clothing/suit/costume/pirate = 1,
		/obj/item/clothing/suit/costume/poncho = 1,
		/obj/item/clothing/suit/jacket/letterman = 1,
		/obj/item/clothing/suit/toggle/chef = 1,
		/obj/item/clothing/suit/hooded/wintercoat = 1,
		/obj/item/clothing/suit/hooded/wintercoat/custom = 1
	)

/obj/effect/spawner/random/clothing/eyewear
	name = "eyewear spawner"
	loot = list(
		/obj/item/clothing/glasses/meson = 1,
		/obj/item/clothing/glasses/science = 1,
		/obj/item/clothing/glasses/welding = 1,
		/obj/item/clothing/glasses/hud/health = 1,
		/obj/item/clothing/glasses/sunglasses = 1
	)
