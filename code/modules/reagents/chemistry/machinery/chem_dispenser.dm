#define CHEM_DISPENSER_HEATER_COEFFICIENT 1
// Soft drinks dispenser is much better at cooling cause of the specific temperature it wants water and ice at.
#define SOFT_DISPENSER_HEATER_COEFFICIENT 3

/obj/machinery/chem_dispenser
	name = "chem dispenser"
	desc = "Creates and dispenses chemicals."
	density = TRUE
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "dispenser"
	base_icon_state = "dispenser"
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_dispenser
	processing_flags = NONE

	var/obj/item/stock_parts/cell/cell
	var/powerefficiency = 0.1
	var/amount = 30
	var/recharge_amount = 10
	var/recharge_counter = 0
	var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	var/heater_coefficient = CHEM_DISPENSER_HEATER_COEFFICIENT
	///If the UI has the pH meter shown
	var/mutable_appearance/beaker_overlay
	var/working_state = "dispenser_working"
	var/nopower_state = "dispenser_nopower"
	var/ui_title = "Chem Dispenser"
	var/has_panel_overlay = TRUE
	var/obj/item/reagent_containers/beaker = null

	var/list/spawn_cartridges = list(
		CHEM_CARTRIDGE_S(aluminium),
		CHEM_CARTRIDGE_S(bromine),
		CHEM_CARTRIDGE_M(carbon),
		CHEM_CARTRIDGE_M(chlorine),
		CHEM_CARTRIDGE_S(copper),
		CHEM_CARTRIDGE_S(consumable/ethanol),
		CHEM_CARTRIDGE_S(fluorine),
		CHEM_CARTRIDGE_M(hydrogen),
		CHEM_CARTRIDGE_S(iodine),
		CHEM_CARTRIDGE_S(iron),
		CHEM_CARTRIDGE_S(lithium),
		CHEM_CARTRIDGE_S(mercury),
		CHEM_CARTRIDGE_M(nitrogen),
		CHEM_CARTRIDGE_M(oxygen),
		CHEM_CARTRIDGE_S(phosphorus),
		CHEM_CARTRIDGE_S(potassium),
		CHEM_CARTRIDGE_S(uranium/radium),
		CHEM_CARTRIDGE_S(silicon),
		CHEM_CARTRIDGE_S(sodium),
		CHEM_CARTRIDGE_S(stable_plasma),
		CHEM_CARTRIDGE_S(consumable/sugar),
		CHEM_CARTRIDGE_S(sulfur),
		CHEM_CARTRIDGE_S(toxin/acid),
		CHEM_CARTRIDGE_M(water),
		CHEM_CARTRIDGE_M(fuel),
	)

	/// Associative, label -> cartridge
	var/list/cartridges = list()

/obj/machinery/chem_dispenser/Initialize(mapload)
	. = ..()
	if(is_operational)
		begin_processing()
	update_appearance()

	if(spawn_cartridges)
		for(var/type in spawn_cartridges)
			add_cartridge(new type(src))

/obj/machinery/chem_dispenser/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(cell)
	return ..()

/obj/machinery/chem_dispenser/examine(mob/user)
	. = ..()
	if(panel_open)
		. += span_notice("[src]'s maintenance hatch is open!")
	if(in_range(user, src) || isobserver(user))
		. += "It has [length(cartridges)] cartridges installed, and has space for [DISPENSER_MAX_CARTRIDGES - length(cartridges)] more."
	. += span_notice("Use <b>RMB</b> to eject a stored beaker.")

// Tries to keep the chem temperature at the dispense temperature
/obj/machinery/chem_dispenser/process(delta_time)
	..()

/obj/machinery/chem_dispenser/on_set_is_operational(old_value)
	if(old_value) //Turned off
		end_processing()
	else //Turned on
		begin_processing()


/obj/machinery/chem_dispenser/process(delta_time)
	if(machine_stat & NOPOWER)
		return

	if (recharge_counter >= 8)
		var/usedpower = cell.give(recharge_amount)
		if(usedpower)
			use_power(active_power_usage + recharge_amount)
		recharge_counter = 0
	else
		recharge_counter += delta_time

	for(var/obj/item/reagent_containers/chem_disp_cartridge/cartridge as anything in cartridges)
		cartridge = cartridges[cartridge]
		if(cartridge.reagents.total_volume)
			if(cartridge.reagents.is_reacting)//on_reaction_step() handles this
				return
			cartridge.reagents.adjust_thermal_energy((dispensed_temperature - beaker.reagents.chem_temp) * (heater_coefficient * powerefficiency) * delta_time * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume)
			cartridge.reagents.handle_reactions()

			use_power(active_power_usage * delta_time)

/obj/machinery/chem_dispenser/proc/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	b_o.pixel_y = -4
	b_o.pixel_x = -7
	return b_o

/obj/machinery/chem_dispenser/proc/work_animation()
	if(working_state)
		flick(working_state,src)

/obj/machinery/chem_dispenser/update_icon_state()
	icon_state = "[(nopower_state && !powered()) ? nopower_state : base_icon_state]"
	return ..()

/obj/machinery/chem_dispenser/update_overlays()
	. = ..()
	if(has_panel_overlay && panel_open)
		. += mutable_appearance(icon, "[base_icon_state]_panel-o")

	if(beaker)
		beaker_overlay = display_beaker()
		. += beaker_overlay


/obj/machinery/chem_dispenser/emag_act(mob/user)
	to_chat(user, span_warning("[src] has no safeties to emag!"))

/obj/machinery/chem_dispenser/ex_act(severity, target)
	if(severity <= EXPLODE_LIGHT)
		return FALSE
	return ..()

/obj/machinery/chem_dispenser/contents_explosion(severity, target)
	..()
	if(!beaker)
		return

	switch(severity)
		if(EXPLODE_DEVASTATE)
			SSexplosions.high_mov_atom += beaker
		if(EXPLODE_HEAVY)
			SSexplosions.med_mov_atom += beaker
		if(EXPLODE_LIGHT)
			SSexplosions.low_mov_atom += beaker

/obj/machinery/chem_dispenser/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		cut_overlays()

/obj/machinery/chem_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", ui_title)

		var/is_hallucinating = FALSE
		if(isliving(user))
			var/mob/living/living_user = user
			is_hallucinating = !!living_user.has_status_effect(/datum/status_effect/hallucination)

		if(is_hallucinating)
			ui.set_autoupdate(FALSE) //to not ruin the immersion by constantly changing the fake chemicals

		ui.open()

/obj/machinery/chem_dispenser/ui_data(mob/user)
	var/data = list()
	data["amount"] = amount
	data["energy"] = cell.charge ? cell.charge * powerefficiency : "0" //To prevent NaN in the UI.
	data["maxEnergy"] = cell.maxcharge * powerefficiency
	data["isBeakerLoaded"] = beaker ? 1 : 0

	var/beakerContents[0]
	var/beakerCurrentVolume = 0
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = round(R.volume, 0.01)))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = round(beakerCurrentVolume, 0.01)
		data["beakerMaxVolume"] = beaker.volume
		data["beakerTransferAmounts"] = beaker.possible_transfer_amounts
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null
		data["beakerTransferAmounts"] = null

	var/chemicals[0]
	var/is_hallucinating = FALSE
	if(isliving(user))
		var/mob/living/living_user = user
		is_hallucinating = !!living_user.has_status_effect(/datum/status_effect/hallucination)

	for(var/re in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/temp = cartridges[re]
		if(temp)
			var/chemname = temp.label
			if(is_hallucinating && prob(5))
				chemname = "[pick_list_replacements("hallucination.json", "chemicals")]"
			chemicals.Add(list(list("title" = chemname, "id" = temp.label, "amount" = temp.reagents.total_volume, "max" = temp.volume)))
	data["chemicals"] = chemicals

	data["recipeReagents"] = list()
	if(beaker?.reagents.ui_reaction_id)
		var/datum/chemical_reaction/reaction = get_chemical_reaction(beaker.reagents.ui_reaction_id)
		for(var/_reagent in reaction.required_reagents)
			var/datum/reagent/reagent = find_reagent_object_from_type(_reagent)
			data["recipeReagents"] += ckey(reagent.name)
	return data

/obj/machinery/chem_dispenser/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("amount")
			if(!is_operational || QDELETED(beaker))
				return
			var/target = text2num(params["target"])
			if(target in beaker.possible_transfer_amounts)
				amount = target
				work_animation()
				. = TRUE
		if("dispense")
			if(!is_operational || QDELETED(cell))
				return
			var/reagent_name = params["reagent"]
			var/obj/item/reagent_containers/cartridge = cartridges[reagent_name]
			if(beaker && cartridge)
				var/datum/reagents/holder = beaker.reagents
				var/to_dispense = max(0, min(amount, holder.maximum_volume - holder.total_volume))
				if(!cell?.use(to_dispense / powerefficiency))
					say("Not enough energy to complete operation!")
					return
				cartridge.reagents.trans_to(holder, to_dispense)

				work_animation()
			. = TRUE
		if("remove")
			if(!is_operational)
				return
			var/amount = text2num(params["amount"])
			if(beaker && (amount in beaker.possible_transfer_amounts))
				beaker.reagents.remove_all(amount)
				work_animation()
				. = TRUE
		if("eject")
			replace_beaker(usr)
			. = TRUE
		if("reaction_lookup")
			if(beaker)
				beaker.reagents.ui_interact(usr)

/obj/machinery/chem_dispenser/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/machinery/chem_dispenser/attackby(obj/item/I, mob/living/user, params)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_appearance()
		return
	if(default_deconstruction_crowbar(I))
		return
	if(I.tool_behaviour == TOOL_CROWBAR && length(cartridges))
		. = TRUE
		var/label = tgui_input_list(user, "Which cartridge would you like to remove?", "Chemical Dispenser", cartridges)
		if(!label)
			return
		var/obj/item/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, span_notice("You remove \the [C] from \the [src]."))
			C.forceMove(loc)
			return
	if(istype(I, /obj/item/reagent_containers/chem_disp_cartridge))
		add_cartridge(I, user)
	else if(is_reagent_container(I) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		var/obj/item/reagent_containers/B = I
		. = TRUE //no afterattack
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, span_notice("You add [B] to [src]."))
		cartridges = sortTim(cartridges, /proc/cmp_text_asc, TRUE)
	else if(!user.combat_mode && !istype(I, /obj/item/card/emag))
		to_chat(user, span_warning("You can't load [I] into [src]!"))
		return ..()
	else
		return ..()

/obj/machinery/chem_dispenser/get_cell()
	return cell

/obj/machinery/chem_dispenser/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/list/datum/reagents/R = list()
	var/total = min(rand(7,15), FLOOR(cell.charge*powerefficiency, 1))
	var/datum/reagents/Q = new(total*10)
	if(beaker?.reagents)
		R += beaker.reagents
	for(var/i in 1 to total)
		var/obj/item/reagent_containers/chem_disp_cartridge = cartridges[pick(cartridges)]
		chem_disp_cartridge.reagents.trans_to(Q, 10)
	R += Q
	chem_splash(get_turf(src), null, 3, R)
	if(beaker?.reagents)
		beaker.reagents.remove_all()
	cell.use(total/powerefficiency)
	cell.emp_act(severity)
	work_animation()
	visible_message(span_danger("[src] malfunctions, spraying chemicals everywhere!"))

/obj/machinery/chem_dispenser/RefreshParts()
	. = ..()
	recharge_amount = initial(recharge_amount)
	var/newpowereff = 0.0666666
	var/parts_rating = 0
	for(var/obj/item/stock_parts/cell/P in component_parts)
		cell = P
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		newpowereff += 0.0166666666*M.rating
		parts_rating += M.rating
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		recharge_amount *= C.rating
		parts_rating += C.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		parts_rating += M.rating
	powerefficiency = round(newpowereff, 0.01)

/obj/machinery/chem_dispenser/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
	update_appearance()
	return TRUE

/obj/machinery/chem_dispenser/on_deconstruction()
	cell = null
	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null
	for(var/cartridge_name in cartridges)
		var/obj/item/cartridge = cartridges[cartridge_name]
		cartridge.forceMove(drop_location())
		cartridges.Remove(cartridge_name)
	return ..()

/obj/machinery/chem_dispenser/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user), FALSE, NO_TK))
		return
	replace_beaker(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/chem_dispenser/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_dispenser/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_dispenser/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/machinery/chem_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, span_warning("\The [C] will not fit in \the [src]!"))
		return

	if(length(cartridges) >= DISPENSER_MAX_CARTRIDGES)
		if(user)
			to_chat(user, span_warning("\The [src] does not have any slots open for \the [C] to fit into!"))
		return

	if(!C.label)
		if(user)
			to_chat(user, span_warning("\The [C] does not have a label!"))
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, span_warning("\The [src] already contains a cartridge with that label!"))
		return

	if(user)
		if(user.temporarilyRemoveItemFromInventory(C))
			to_chat(user, span_notice("You add \the [C] to \the [src]."))
		else
			return

	C.forceMove(src)
	cartridges[C.label] = C
	cartridges = sortTim(cartridges, /proc/cmp_text_asc, TRUE)

/obj/machinery/chem_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
