/datum/action/innate/monitor_change
	name = "Screen Change"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/monitor_change/Activate()
	var/mob/living/carbon/human/human = owner
	var/new_ipc_screen = tgui_input_list(usr, "Choose your character's screen:", "Monitor Display", GLOB.synth_screens)

	if(!new_ipc_screen)
		return

	human.dna.features[MUTANT_SYNTH_SCREEN] = new_ipc_screen
	human.update_body()
