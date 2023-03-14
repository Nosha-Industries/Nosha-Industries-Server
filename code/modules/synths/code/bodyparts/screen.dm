/obj/item/organ/external/screen
	name = "screen"
	preference = "feature_ipc_screen"
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/screen

	zone = BODY_ZONE_HEAD
	slot = MUTANT_SYNTH_SCREEN

	/// The innate action that synths get, if they've got a screen selected on species being set.
	var/datum/action/innate/monitor_change/screen
	/// This is the screen that is given to the user after they get revived. On death, their screen is temporarily set to BSOD before it turns off, hence the need for this var.
	var/saved_screen = "Blank"

/obj/item/organ/external/screen/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()

	if(. && !screen)
		screen = new
		screen.Grant(receiver)

/obj/item/organ/external/screen/Remove(mob/living/carbon/organ_owner, special, moving)
	if(screen)
		screen.Remove(organ_owner)
	. = ..()

/obj/item/organ/external/screen/owner_death()
	. = ..()
	if(!owner)
		return
	var/obj/item/organ/external/screen/screen_organ = owner.getorganslot(MUTANT_SYNTH_SCREEN)
	saved_screen = screen_organ.bodypart_overlay?.sprite_datum?.name || "None"
	switch_to_screen(owner, "BSOD")
	addtimer(CALLBACK(src, PROC_REF(switch_to_screen), owner, "Blank"), 5 SECONDS)

/obj/item/organ/external/screen/owner_revived()
	. = ..()
	if(!owner)
		return
	switch_to_screen(transformer, "Console")
	addtimer(CALLBACK(src, PROC_REF(switch_to_screen), transformer, saved_screen), 5 SECONDS)
	playsound(transformer.loc, 'sound/machines/chime.ogg', 50, TRUE)
	transformer.visible_message(span_notice("[transformer]'s [transformer.getorganslot(MUTANT_SYNTH_SCREEN) ? "monitor lights up" : "eyes flicker to life"]!"), span_notice("All systems nominal. You're back online!"))

/**
 * Simple proc to switch the screen of a monitor-enabled synth, while updating their appearance.
 *
 * Arguments:
 * * transformer - The human that will be affected by the screen change (read: IPC).
 * * screen_name - The name of the screen to switch the ipc_screen mutant bodypart to.
 */
/obj/item/organ/external/screen/proc/switch_to_screen(mob/living/carbon/human/tranformer, screen_name)
	if(!screen)
		return

	var/obj/item/organ/external/screen/screen_organ = tranformer.getorganslot(MUTANT_SYNTH_SCREEN)
	screen_organ?.bodypart_overlay?.set_appearance_from_name(screen_name)

/datum/bodypart_overlay/mutant/screen
	layers = EXTERNAL_FRONT_UNDER_CLOTHES
	feature_key = MUTANT_SYNTH_SCREEN
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/screen/get_global_feature_list()
	return GLOB.synth_screens

/datum/bodypart_overlay/mutant/screen/override_color(obj/item/bodypart/bodypart)
	return sprite_datum.color_src ? bodypart.owner.dna.features["[MUTANT_SYNTH_SCREEN]_color"] : null
