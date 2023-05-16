/datum/chemical_reaction/acidic_inversifier
	results = list(/datum/reagent/acidic_inversifier = 10)
	required_reagents = list(/datum/reagent/sodium = 2, /datum/reagent/hydrogen = 2, /datum/reagent/consumable/ethanol = 2, /datum/reagent/water = 2)
	mix_message = "The solution froths in the beaker."
	required_temp = 250
	optimal_temp = 500
	overheat_temp = NO_OVERHEAT
	thermic_constant = 0
	rate_up_lim = 20
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// Example competitive reaction (REACTION_COMPETITIVE)  //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/chemical_reaction/prefactor_a
	results = list(/datum/reagent/prefactor_a = 5)
	required_reagents = list(/datum/reagent/phenol = 1, /datum/reagent/consumable/ethanol = 3, /datum/reagent/toxin/plasma = 1)
	mix_message = "The solution's viscosity increases."
	is_cold_recipe = TRUE
	required_temp = 800
	optimal_temp = 300
	overheat_temp = -1 //no overheat
	thermic_constant = -400
	rate_up_lim = 4
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL | REACTION_TAG_COMPETITIVE


/datum/chemical_reaction/prefactor_b
	results = list(/datum/reagent/prefactor_b = 5)
	required_reagents = list(/datum/reagent/prefactor_a = 5)
	mix_message = "The solution's viscosity decreases."
	mix_sound = 'sound/chemistry/bluespace.ogg' //Maybe use this elsewhere instead
	required_temp = 50
	optimal_temp = 500
	overheat_temp = 500
	thermic_constant = -800
	rate_up_lim = 6
	reaction_flags = REACTION_COMPETITIVE //Competes with /datum/chemical_reaction/prefactor_a/competitive
	reaction_tags = REACTION_TAG_MODERATE | REACTION_TAG_DANGEROUS | REACTION_TAG_CHEMICAL | REACTION_TAG_COMPETITIVE

/datum/chemical_reaction/prefactor_b/reaction_step(datum/reagents/holder, datum/equilibrium/reaction, delta_t, step_reaction_vol)
	. = ..()
	if(holder.has_reagent(/datum/reagent/bluespace))
		holder.remove_reagent(/datum/reagent/bluespace, 1)
		reaction.delta_t *= 5

/datum/chemical_reaction/prefactor_b/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	. = ..()
	explode_shockwave(holder, equilibrium)
	var/vol = max(20, holder.total_volume/5) //Not letting you have more than 5
	clear_reagents(holder, vol)//Lest we explode forever

/datum/chemical_reaction/prefactor_b/overly_impure(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	explode_fire(holder, equilibrium)
	var/vol = max(20, holder.total_volume/5) //Not letting you have more than 5
	clear_reagents(holder, vol)

/datum/chemical_reaction/prefactor_a/competitive //So we have a back and forth reaction
	results = list(/datum/reagent/prefactor_a = 5)
	required_reagents = list(/datum/reagent/prefactor_b = 5)
	rate_up_lim = 3
	reaction_flags = REACTION_COMPETITIVE //Competes with /datum/chemical_reaction/prefactor_b
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL | REACTION_TAG_COMPETITIVE

//The actual results
/datum/chemical_reaction/prefactor_a/purity_tester
	results = list(/datum/reagent/reaction_agent/purity_tester = 5)
	required_reagents = list(/datum/reagent/prefactor_a = 5, /datum/reagent/stable_plasma = 5)
	thermic_constant = 0
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL | REACTION_TAG_COMPETITIVE


/datum/chemical_reaction/prefactor_b/speed_agent
	results = list(/datum/reagent/reaction_agent/speed_agent = 5)
	required_reagents = list(/datum/reagent/prefactor_b = 5, /datum/reagent/stable_plasma = 5)
	thermic_constant = 0
	reaction_tags = REACTION_TAG_HARD | REACTION_TAG_DANGEROUS | REACTION_TAG_CHEMICAL | REACTION_TAG_COMPETITIVE

////////////////////////////////End example/////////////////////////////////////////////////////////////////////////////
