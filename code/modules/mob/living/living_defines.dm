/mob/living
	see_invisible = SEE_INVISIBLE_LIVING
	sight = 0
	see_in_dark = 2
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ANTAG_HUD)
	pressure_resistance = 10

	hud_type = /datum/hud/living

	///Badminnery resize
	var/resize = 1
	var/lastattacker = null
	var/lastattackerckey = null

	//Health and life related vars
	/// Maximum health that should be possible.
	var/maxHealth = MAX_LIVING_HEALTH
	/// The mob's current health.
	var/health = MAX_LIVING_HEALTH

	/// The max amount of stamina damage we can have at once (Does NOT effect stamcrit thresholds. See crit_threshold)
	var/max_stamina = 120
	///Stamina damage, or exhaustion. You recover it slowly naturally, and are knocked down if it gets too high. Holodeck and hallucinations deal this.
	var/staminaloss = 0

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	///Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/bruteloss = 0
	///Oxygen depravation damage (no air in lungs)
	var/oxyloss = 0
	///Toxic damage caused by being poisoned or radiated
	var/toxloss = 0
	///Burn damage caused by being way too hot, too cold or burnt.
	var/fireloss = 0
	///Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
	var/cloneloss = 0

	/// when the mob goes from "normal" to crit
	var/crit_threshold = HEALTH_THRESHOLD_CRIT
	///When the mob enters hard critical state and is fully incapacitated.
	var/hardcrit_threshold = HEALTH_THRESHOLD_FULLCRIT

	//Damage dealing vars! These are meaningless outside of specific instances where it's checked and defined.
	/// Lower bound of damage done by unarmed melee attacks. Mob code is a mess, only works where this is checked for.
	var/melee_damage_lower = 0
	/// Upper bound of damage done by unarmed melee attacks. Please ensure you check the xyz_defenses.dm for the mobs in question to see if it uses this or hardcoded values.
	var/melee_damage_upper = 0

	/// Generic bitflags for boolean conditions at the [/mob/living] level. Keep this for inherent traits of living types, instead of runtime-changeable ones.
	var/living_flags = NONE

	/// Flags that determine the potential of a mob to perform certain actions. Do not change this directly.
	var/mobility_flags = MOBILITY_FLAGS_DEFAULT

	var/resting = FALSE

	/// Variable to track the body position of a mob, regardgless of the actual angle of rotation (usually matching it, but not necessarily).
	var/body_position = STANDING_UP
	/// Number of degrees of rotation of a mob. 0 means no rotation, up-side facing NORTH. 90 means up-side rotated to face EAST, and so on.
	VAR_PROTECTED/lying_angle = 0
	/// Value of lying lying_angle before last change. TODO: Remove the need for this.
	var/lying_prev = 0
	///Directly affects how long a mob will hallucinate for
	var/hallucination = 0
	///Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.
	var/last_special = 0
	var/timeofdeath = 0

	///A message sent when the mob dies, with the *deathgasp emote
	var/death_message = ""
	///A sound sent when the mob dies, with the *deathgasp emote
	var/death_sound


	/// Helper vars for quick access to firestacks, these should be updated every time firestacks are adjusted
	var/on_fire = FALSE
	var/fire_stacks = 0

	/**
	  * Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	  *
	  * FALSE is off, [INCORPOREAL_MOVE_BASIC] is normal, [INCORPOREAL_MOVE_SHADOW] is for ninjas
	  * and [INCORPOREAL_MOVE_JAUNT] is blocked by holy water/salt
	  */
	var/incorporeal_move = FALSE

	var/list/quirks = list()
	///a list of surgery datums. generally empty, they're added when the player wants them.
	var/list/surgeries = list()
	///Mob specific surgery speed modifier
	var/mob_surgery_speed_mod = 1

	/// Used by [living/Bump()][/mob/living/proc/Bump] and [living/PushAM()][/mob/living/proc/PushAM] to prevent potential infinite loop.
	var/now_pushing = null

	var/cameraFollow = null

	/// Time of death
	var/tod = null

	/// Sets AI behavior that allows mobs to target and dismember limbs with their basic attack.
	var/limb_destroyer = 0

	var/mob_size = MOB_SIZE_HUMAN
	var/mob_biotypes = MOB_ORGANIC
	///more or less efficiency to metabolize helpful/harmful reagents and regulate body temperature..
	var/metabolism_efficiency = 1
	///does the mob have distinct limbs?(arms,legs, chest,head)
	var/has_limbs = FALSE

	///How many legs does this mob have by default. This shouldn't change at runtime.
	var/default_num_legs = 2
	///How many legs does this mob currently have. Should only be changed through set_num_legs()
	var/num_legs = 2
	///How many usable legs this mob currently has. Should only be changed through set_usable_legs()
	var/usable_legs = 2

	///How many hands does this mob have by default. This shouldn't change at runtime.
	var/default_num_hands = 2
	///How many hands hands does this mob currently have. Should only be changed through set_num_hands()
	var/num_hands = 2
	///How many usable hands does this mob currently have. Should only be changed through set_usable_hands()
	var/usable_hands = 2

	var/list/pipes_shown = list()
	var/last_played_vent = 0
	/// The last direction we moved in a vent. Used to make holding two directions feel nice
	var/last_vent_dir = 0
	/// Cell tracker datum we use to manage the pipes around us, for faster ventcrawling
	/// Should only exist if you're in a pipe
	var/datum/cell_tracker/pipetracker

	var/smoke_delay = 0 ///used to prevent spam with smoke reagent reaction on mob.

	///what icon the mob uses for speechbubbles
	var/bubble_icon = "default"
	///if this exists AND the normal sprite is bigger than 32x32, this is the replacement icon state (because health doll size limitations). the icon will always be screen_gen.dmi
	var/health_doll_icon

	var/last_bumped = 0
	///if a mob's name should be appended with an id when created e.g. Mob (666)
	var/unique_name = FALSE
	///the id a mob gets when it's created
	var/numba = 0

	///these will be yielded from butchering with a probability chance equal to the butcher item's effectiveness
	var/list/butcher_results = null
	///these will always be yielded from butchering
	var/list/guaranteed_butcher_results = null
	///effectiveness prob. is modified negatively by this amount; positive numbers make it more difficult, negative ones make it easier
	var/butcher_difficulty = 0

	///converted to a list of stun absorption sources this mob has when one is added
	var/stun_absorption = null

	///how much blood the mob has
	var/blood_volume = 0

	///0 for no override, sets see_invisible = see_override in silicon & carbon life process via update_sight()
	var/see_override = 0

	///a list of all status effects the mob has
	var/list/status_effects
	var/list/implants = null

	///used for database logging
	var/last_words

	///whether this can be picked up and held.
	var/can_be_held = FALSE
	/// The w_class of the holder when held.
	var/held_w_class = WEIGHT_CLASS_NORMAL
	///if it can be held, can it be equipped to any slots? (think pAI's on head)
	var/worn_slot_flags = NONE

	var/ventcrawl_layer = PIPING_LAYER_DEFAULT
	var/losebreath = 0

	//List of active diseases
	/// list of all diseases in a mob
	var/list/diseases
	var/list/disease_resistances

	///Whether the mob is slowed down when dragging another prone mob
	var/slowed_by_drag = TRUE

	/// List of changes to body temperature, used by desease symtoms like fever
	var/list/body_temp_changes = list()

	//this stuff is here to make it simple for admins to mess with custom held sprites
	///left hand icon for holding mobs
	var/icon/held_lh = 'icons/mob/inhands/pets_held_lh.dmi'
	///right hand icon for holding mobs
	var/icon/held_rh = 'icons/mob/inhands/pets_held_rh.dmi'
	///what it looks like when the mob is held on your head
	var/icon/head_icon = 'icons/mob/clothing/head/pets_held.dmi'
	/// icon_state for holding mobs.
	var/held_state = ""

	///If combat mode is on or not
	var/combat_mode = FALSE

	/// Is this mob allowed to be buckled/unbuckled to/from things?
	var/can_buckle_to = TRUE

	///The y amount a mob's sprite should be offset due to the current position they're in (e.g. lying down moves your sprite down)
	var/body_position_pixel_x_offset = 0
	///The x amount a mob's sprite should be offset due to the current position they're in
	var/body_position_pixel_y_offset = 0

	///what multiplicative slowdown we get from turfs currently.
	var/current_turf_slowdown = 0

	/// Living mob's mood datum
	var/datum/mood/mob_mood

	COOLDOWN_DECLARE(smell_time)
	var/last_smell_intensity = 0

	/// List of weather immunity traits that are then added on Initialize(), see traits.dm.
	var/list/weather_immunities

	// Multiple imaginary friends!
	/// Contains the owner and all imaginary friend mobs if they exist, otherwise null
	var/list/imaginary_group = null
