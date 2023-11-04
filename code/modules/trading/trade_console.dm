// This was meant to be simple, dammit.

#define SHUTTLE_BLOCKADE_WARNING "Shuttle movement impossible. See console for details."
#define SHUTTLE_SAFETY_WARNING "For safety and ethical reasons, the automated supply shuttle cannot transport \
		human remains, classified nuclear weaponry, mail, undelivered departmental order crates, enemy bombs, \
		homing beacons, unstable eigenstates, fax machines, or machinery housing any form of artificial intelligence."

/obj/machinery/computer/trade_console
	name = "trade console"
	icon_screen = "supply"
	desc = "Used for communication between the trade networks and for conducting trades."
	circuit = /obj/item/circuitboard/computer/trade_console
	light_color = COLOR_BRIGHT_ORANGE
	var/obj/machinery/trade_pad/linked_pad

	var/last_transmission = ""
	var/denied_hail_transmission

	var/datum/trade_hub/connected_hub
	var/datum/trader/connected_trader

	var/viewed_log = FALSE
	var/makes_log = TRUE
	var/makes_manifests = TRUE

	// Mostly for admins.
	var/list/trade_log

	var/list/manifest_purchased
	var/list/manifest_sold
	var/manifest_loss = 0
	var/manifest_profit = 0
	var/last_user_name = "name"
	var/last_trade_time = ""
	var/manifest_counter = 0

	var/next_bounty_print = 0

	var/obj/item/card/id/inserted_id

	///The name of the shuttle template being used as the cargo shuttle. 'cargo' is default and contains critical code. Don't change this unless you know what you're doing.
	var/cargo_shuttle = "cargo"
	///The docking port called when returning to the station.
	var/docking_home = "cargo_home"
	///The docking port called when leaving the station.
	var/docking_away = "cargo_away"
	///If this console can loan the cargo shuttle. Set to false to disable.
	var/stationcargo = TRUE

	var/list/loaded_coupons = list()

/obj/machinery/computer/trade_console/proc/write_manifest(datum/trader/trader, item_name, amount, price, user_selling, user_name)
	var/trade_string
	last_user_name = user_name
	if(user_selling)
		trade_string = "[amount] of [item_name] for [price] cr."
		write_log("[user_name] sold [trade_string] to [trader.name] (new balance on [inserted_id.registered_account.account_holder]: [inserted_id.registered_account.account_balance] cr.)")
		if(!makes_manifests)
			return
		LAZYINITLIST(manifest_sold)
		manifest_sold += trade_string
		manifest_profit += price
	else
		trade_string = "[amount] of [item_name] for [price] cr."
		write_log("[user_name] bought [trade_string] from [trader.name] (new balance on [inserted_id.registered_account.account_holder]: [inserted_id.registered_account.account_balance] cr.)")
		if(!makes_manifests)
			return
		LAZYINITLIST(manifest_purchased)
		manifest_purchased += trade_string
		manifest_loss += price

/obj/machinery/computer/trade_console/proc/print_manifest()
	if(!makes_manifests)
		QDEL_NULL(manifest_sold)
		QDEL_NULL(manifest_purchased)
		return
	if(!manifest_sold && !manifest_purchased)
		return
	var/turf/my_turf = get_turf(src)
	playsound(my_turf, 'sound/items/poster_being_created.ogg', 20, 1)
	var/obj/item/paper/P = new /obj/item/paper(my_turf)
	manifest_counter++
	P.name = "trade manifest #[manifest_counter]"
	P.add_raw_text("<CENTER><B>TRADE MANIFEST #[manifest_counter] - [last_trade_time]</B></CENTER><BR>Transaction between [last_user_name] and [connected_trader.name] at [connected_trader.origin]")
	if(manifest_purchased)
		P.add_raw_text("<HR><b>BOUGHT ITEMS:</b><BR>")
		for(var/line in manifest_purchased)
			P.add_raw_text("[line]<BR>")
	if(manifest_sold)
		P.add_raw_text("<HR><b>SOLD ITEMS:</b><BR>")
		for(var/line in manifest_sold)
			P.add_raw_text("[line]<BR>")
	P.add_raw_text("<HR>Total gain: [manifest_profit]<BR>Total loss: [manifest_loss]<BR><b>TOTAL PROFIT: [manifest_profit - manifest_loss]</b>")
	P.update_icon()
	manifest_purchased = null
	manifest_sold = null
	manifest_loss = 0
	manifest_profit = 0

/obj/machinery/computer/trade_console/proc/write_log(log_entry)
	LAZYADD(trade_log, log_entry)
	if(!makes_log)
		return
	var/datum/signal/subspace/messaging/trade_msg/message = new(src, list(
		"timestamp" = station_time_timestamp(),
		"message" = log_entry,
	))
	message.send_to_receivers()

/obj/machinery/computer/trade_console/proc/connect_hub(datum/trade_hub/passed_hub)
	if(connected_hub)
		disconnect_hub()
	connected_hub = passed_hub
	connected_hub.connected_consoles += src

/obj/machinery/computer/trade_console/proc/connect_trader(datum/trader/passed_trader, mob/user)
	if(connected_trader)
		disconnect_trader()
	connected_trader = passed_trader
	connected_trader.connected_consoles += src
	last_transmission = passed_trader.get_response("hail", "Welcome to ORIGIN!", user)
	denied_hail_transmission = null

/obj/machinery/computer/trade_console/proc/disconnect_hub()
	if(!connected_hub)
		return
	if(connected_trader)
		disconnect_trader()
	connected_hub.connected_consoles -= src
	connected_hub = null
	denied_hail_transmission = null

/obj/machinery/computer/trade_console/proc/disconnect_trader()
	print_manifest()
	if(!connected_trader)
		return
	connected_trader.connected_consoles -= src
	connected_trader = null

/obj/machinery/computer/trade_console/proc/insert_id(obj/item/card/id/id, mob/user)
	if(!istype(id))
		return
	if(inserted_id)
		if(user)
			balloon_alert(user, "ID already inside!")
		return

	id.forceMove(src)
	inserted_id = id
	playsound(src, 'sound/machines/id_insert.ogg', 50, FALSE)

/obj/machinery/computer/trade_console/proc/remove_id(mob/user)
	if(!inserted_id)
		if(user)
			balloon_alert(user, "no ID!")
		return

	if(user)
		visible_message(span_info("[user] takes [inserted_id] from \the [src]."))
		try_put_in_hand(inserted_id, user)
		inserted_id = null
		playsound(src, 'sound/machines/id_eject.ogg', 50, FALSE)
		return

	inserted_id.forceMove(get_turf(src))
	inserted_id = null
	playsound(src, 'sound/machines/id_eject.ogg', 50, FALSE)

/obj/machinery/computer/trade_console/attackby(obj/item/item, mob/user, params)
	if(isidcard(item))
		insert_id(item)
		return TRUE
	. = ..()

/obj/machinery/computer/trade_console/CtrlClick(mob/user)
	. = ..()
	remove_id(user)
	return TRUE

/obj/machinery/computer/trade_console/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TraderConsole", "Trade Console")
		ui.open()

/obj/machinery/computer/trade_console/ui_data()
	var/list/trade_hubs = list()
	var/list/traders = list()
	var/list/data = list(
		"connected_hub" = connected_hub ? list(
			"name" = connected_hub.name,
			"id" = connected_hub.id,
			"last_transmission" = last_transmission,
			"traders" = traders,
		) : null,
		"last_transmission" = last_transmission,
		"trade_hubs" = trade_hubs,
		"makes_manifests" = makes_manifests,
		"rank" = istype(inserted_id?.registered_account, /datum/bank_account/department) ? "Department Account" : inserted_id?.registered_account?.account_job?.title,
		"wallet_name" = inserted_id?.registered_account?.account_holder,
		"credits" = inserted_id?.registered_account?.account_balance,
		"shuttle_location" = SSshuttle.supply.getStatusText(),
		"shuttle_away" = SSshuttle.supply.getDockedId() == docking_away,
		"shuttle_docked" = SSshuttle.supply.mode == SHUTTLE_IDLE,
		"shuttle_loanable" = !!SSshuttle.shuttle_loan,
		"shuttle_loan_dispatched" = SSshuttle.shuttle_loan && SSshuttle.shuttle_loan.dispatched,
		"shuttle_blockaded" = !!SSshuttle.trade_blockade.len || !!SSshuttle.supply_blocked,
		"shuttle_eta" = time2text(world.realtime + SSshuttle.supply.timeLeft(), "mm:ss"),
		"grocery_amount" = SStrading.chef_groceries.len,
	)

	var/message = "Remember to stamp and send back the supply manifests."
	if(SStrading.trade_message)
		message = SStrading.trade_message
	if(SSshuttle.supply_blocked)
		message = SHUTTLE_BLOCKADE_WARNING
	data["shuttle_message"] = message
	var/list/cart = list()
	data["cart"] = cart
	for(var/datum/supply_order/order in SStrading.shopping_list)
		cart += list(list(
			"object" = order.pack.name,
			"cost" = order.pack.get_cost(),
			"id" = order.id,
			"orderer" = order.orderer,
			"paid" = !isnull(order.paying_account), //paid by requester
			"dep_order" = !!order.department_destination
		))

	if(connected_hub)
		for(var/datum/trader/trader as anything in connected_hub.traders)
			traders += list(list(
				"name" = trader.name,
				"id" = trader.id,
			))

	if(connected_trader)
		var/list/trades = list()
		var/list/bounties = list()
		var/list/deliveries = list()
		// Index is used cause it requires the least amount of refactoring, and I've refactored enough as it is, dammit.
		var/index = 1
		for(var/sold_good_id as anything in connected_trader.sold_packs)
			var/datum/supply_pack/sold_goods = SStrading.supply_packs[sold_good_id]
			trades += list(list(
				"name" = sold_goods.name,
				"desc" = sold_goods.desc,
				"id" = sold_goods.id,
				"cost" = sold_goods.get_cost(),
				"amount" = sold_goods.stock["[connected_trader.id]"],
			))
			index += 1
		index = 1
		for(var/datum/trader_bounty/bounty as anything in connected_trader.bounties)
			bounties += list(list(
				"name" = bounty.bounty_name,
				"desc" = bounty.bounty_text,
				"index" = index,
				"reward" = bounty.reward_cash,
			))
			index += 1
		index = 1
		for(var/datum/delivery_run/delivery_run as anything in connected_trader.deliveries)
			deliveries += list(list(
				"name" = delivery_run.name,
				"desc" = delivery_run.desc,
				"index" = index,
				"reward" = delivery_run.reward_cash,
			))
			index += 1
		data["connected_trader"] = list(
			"name" = connected_trader.name,
			"id" = connected_trader.id,
			"trades" = trades,
			"bounties" = bounties,
			"deliveries" = deliveries,
		)

	for(var/datum/trade_hub/trade_hub as anything in SStrading.get_available_trade_hubs(get_turf(src)))
		trade_hubs += list(list(
			"name" = trade_hub.name,
			"id" = trade_hub.id,
		))

	. = data

/obj/machinery/computer/trade_console/ui_static_data(mob/user)
	var/list/data = list()
	data["static_galactic_imports"] = list()
	for(var/pack in SStrading.supply_packs)
		var/datum/supply_pack/P = SStrading.supply_packs[pack]
		if(!data["supplies"][P.group])
			data["supplies"][P.group] = list(
				"name" = P.group,
				"packs" = list()
			)
		// I'll eventually make contraband work again.
		if((P.hidden && !(obj_flags & EMAGGED)) || P.contraband || (P.special && !P.special_enabled) || P.drop_pod_only)
			continue
		data["supplies"][P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.get_cost(),
			"id" = pack,
			"desc" = P.desc || P.name, // If there is a description, use it. Otherwise use the pack's name.
			"goody" = P.goody,
			"access" = P.access
		))
	return data

/obj/machinery/computer/trade_console/ui_act(action, list/params, datum/tgui/ui)
	..()
	. = TRUE // Just.. always update.
	if(!ui.user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, TRUE))
		return FALSE
	switch(action)
		if("eject_id")
			if(inserted_id)
				remove_id(ui.user)
				return
			var/item = ui.user.get_active_held_item()
			insert_id(isidcard(item) ? item : null, ui.user)
		if("choose_hub")
			var/datum/trade_hub/trade_hub = SStrading.get_trade_hub_by_id(text2num(params["id"]))
			if(trade_hub)
				connect_hub(trade_hub)
				write_log("Connected to hub [trade_hub.name]")
		if("choose_trader")
			var/datum/trader/trader = SStrading.get_trader_by_id(text2num(params["id"]))
			if(trader)
				connect_trader(trader, ui.user)
				write_log("Connected to trader [trader.name]")
		if("buy")
			if(!inserted_id)
				say("No ID detected.")
				return
			if(!inserted_id.registered_account)
				say("No bank account detected.")
				return
			var/pack_id = text2path(params["id"]) || params["id"]
			if(!(pack_id in connected_trader.sold_packs))
				say("Unknown product code.")
				return

			var/datum/supply_pack/goodie = SStrading.supply_packs[pack_id]

			last_transmission = connected_trader.requested_buy(ui.user, src, goodie)
		if("bounty")
			if(!inserted_id)
				say("No ID detected.")
				return
			var/index = text2num(params["index"])
			if(connected_trader.bounties.len < index)
				return
			var/datum/trader_bounty/goodie = connected_trader.bounties[index]
			last_transmission = connected_trader.requested_bounty_claim(ui.user, src, goodie)
		if("delivery")
			var/index = text2num(params["index"])
			if(connected_trader.deliveries.len < index)
				return
			var/datum/delivery_run/goodie = connected_trader.deliveries[index]
			last_transmission = connected_trader.requested_delivery_take(ui.user, src, goodie)
		if("print_manifest")
			print_manifest()
		if("toggle_manifest")
			makes_manifests = !makes_manifests
		if("send_shuttle")
			if(!SSshuttle.supply.canMove())
				say(SHUTTLE_SAFETY_WARNING)
				return
			if(SSshuttle.supply_blocked)
				say(SHUTTLE_BLOCKADE_WARNING)
				return
			if(SSshuttle.supply.getDockedId() == docking_home)
				// SSshuttle.supply.export_categories = EXPORT_CARGO // ARTEA TODO: (maybe) readd emag/contraband-specific exports.
				SSshuttle.moveShuttle(cargo_shuttle, docking_away, TRUE)
				say("The supply shuttle is departing.")
				investigate_log("[key_name(usr)] sent the supply shuttle away.", INVESTIGATE_CARGO)
			else
				investigate_log("[key_name(usr)] called the supply shuttle.", INVESTIGATE_CARGO)
				say("The supply shuttle has been called and will arrive in [SSshuttle.supply.timeLeft(600)] minutes.")
				SSshuttle.moveShuttle(cargo_shuttle, docking_home, TRUE)
			. = TRUE
		if("loan_shuttle")
			if(!SSshuttle.shuttle_loan)
				return
			if(SSshuttle.supply_blocked)
				say(SHUTTLE_BLOCKADE_WARNING)
				return
			else if(SSshuttle.supply.mode != SHUTTLE_IDLE)
				return
			else if(SSshuttle.supply.getDockedId() != docking_away)
				return
			else if(stationcargo != TRUE)
				return
			else
				SSshuttle.shuttle_loan.loan_shuttle()
				say("The supply shuttle has been loaned to CentCom.")
				investigate_log("[key_name(usr)] accepted a shuttle loan event.", INVESTIGATE_CARGO)
				usr.log_message("accepted a shuttle loan event.", LOG_GAME)
				. = TRUE
		if("remove")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SStrading.shopping_list)
				if(SO.id != id)
					continue
				if(SO.department_destination)
					say("Only the department that ordered this item may cancel it.")
					return
				if(SO.applied_coupon)
					say("Coupon refunded.")
					SO.applied_coupon.forceMove(get_turf(src))
				SStrading.shopping_list -= SO
				. = TRUE
				break
		if("clear")
			for(var/datum/supply_order/cancelled_order in SStrading.shopping_list)
				if(cancelled_order.department_destination)
					continue //don't cancel other department's orders
				SStrading.shopping_list -= cancelled_order
			. = TRUE
		if("unload_coupons")
			for(var/obj/coupon in loaded_coupons)
				coupon.forceMove(get_turf(src))
	if(.)
		post_signal(cargo_shuttle)

/obj/machinery/computer/trade_console/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		return

	obj_flags |= EMAGGED
	do_sparks(1, FALSE, src)
	makes_log = FALSE
	update_static_data_for_all_viewers()
	balloon_alert(user, "disabled logging")

/obj/machinery/computer/trade_console/Destroy()
	if(!inserted_id)
		return ..()
	inserted_id.forceMove(get_turf(src))
	inserted_id = null
	return ..()

/obj/machinery/computer/trade_console/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(list("command" = command))
	frequency.post_signal(src, status_signal)

/obj/item/circuitboard/computer/trade_console
	name = "Trade Console (Computer Board)"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/trade_console

#undef SHUTTLE_BLOCKADE_WARNING
