/obj/structure/closet/secure_closet/quartermaster
	name = "\proper quartermaster's locker"
	req_access = list(ACCESS_CARGO_HEAD)
	icon_state = "qm"

/obj/structure/closet/secure_closet/quartermaster/PopulateContents()
	..()
	new /obj/item/clothing/neck/cloak/qm(src)
	new /obj/item/storage/lockbox/medal/cargo(src)
	new /obj/item/clothing/under/rank/cargo/qm(src)
	new /obj/item/clothing/under/rank/cargo/qm/skirt(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/radio/headset/heads/qm(src)
	new /obj/item/clothing/suit/utility/fire/firefighter(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/megaphone/cargo(src)
	new /obj/item/tank/internals/emergency_oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/head/soft(src)
	new /obj/item/export_scanner(src)
	new /obj/item/door_remote/quartermaster(src)
	new /obj/item/circuitboard/machine/techfab/department/cargo(src)
	new /obj/item/storage/photo_album/qm(src)
	new /obj/item/circuitboard/machine/ore_silo(src)
	new /obj/item/clothing/suit/hooded/wintercoat/cargo/qm(src)

/obj/structure/closet/secure_closet/quartermaster/populate_contents_immediate()
	. = ..()

	// Traitor steal objective
	new /obj/item/card/id/departmental_budget/car(src)
