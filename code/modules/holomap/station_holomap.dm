#define HOLOMAP_LOW_LIGHT 1, 2
#define HOLOMAP_HIGH_LIGHT 2, 3
#define HOLOMAP_LIGHT_OFF 0

// Wall mounted holomap of the station
// Credit to polaris for the code which this current map was originally based off of, and credit to VG for making it in the first place.

/obj/machinery/holomap
	name = "\improper station holomap"
	desc = "A virtual map of the surrounding station."
	icon = 'icons/obj/machines/holomap/stationmap.dmi'
	icon_state = "holomap"
	layer = ABOVE_WINDOW_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100
	light_color = HOLOMAP_HOLOFIER

	/// The mob beholding this marvel.
	var/mob/watching_mob
	/// The image that can be seen in-world.
	var/image/small_station_map
	/// The little "map" floor painting.
	var/image/floor_markings

	// zLevel which the map is a map for.
	var/current_z_level
	/// This set to FALSE when the holomap is initialized on a zLevel that has its own icon formatted for use by station holomaps.
	var/bogus = TRUE
	/// The various images and icons for the map are stored in here, as well as the actual big map itself.
	var/datum/station_holomap/holomap_datum

	var/wall_frame_type = /obj/item/wallframe/holomap

/obj/machinery/holomap/open
	panel_open = TRUE

/obj/machinery/holomap/Initialize(mapload)
	. = ..()
	current_z_level = z
	SSholomaps.station_holomaps += src

/obj/machinery/holomap/LateInitialize()
	. = ..()
	setup_holomap()

/obj/machinery/holomap/Destroy()
	SSholomaps.station_holomaps -= src
	close_map()
	QDEL_NULL(holomap_datum)
	. = ..()

/obj/machinery/holomap/proc/setup_holomap()
	holomap_datum = new
	bogus = FALSE
	var/turf/current_turf = get_turf(src)
	if(!("[HOLOMAP_EXTRA_STATIONMAP]_[current_z_level]" in SSholomaps.extra_holomaps))
		bogus = TRUE
		holomap_datum.initialize_holomap_bogus()
		update_icon()
		return

	holomap_datum.initialize_holomap(current_turf.x, current_turf.y, current_z_level, reinit_base_map = TRUE, extra_overlays = handle_overlays())

	floor_markings = image('icons/obj/machines/holomap/stationmap.dmi', "decal_station_map")
	floor_markings.dir = src.dir

	update_icon()

/obj/machinery/holomap/attack_hand(mob/user)
	if(user == watching_mob)
		close_map(user)
		return

	open_map(user)

/// Tries to open the map for the given mob. Returns FALSE if it doesn't meet the criteria, TRUE if the map successfully opened with no runtimes.
/obj/machinery/holomap/proc/open_map(mob/user)
	if((machine_stat & (NOPOWER | BROKEN)) || !user?.client || panel_open || user.hud_used.holomap.used_station_map)
		return FALSE

	if(!holomap_datum)
		// Something is very wrong if we have to un-fuck ourselves here.
		message_admins("\[HOLOMAP] WARNING: Holomap at [x], [y], [z] [ADMIN_FLW(src)] had to set itself up on interact! Something during Initialize went very wrong!")
		setup_holomap()

	holomap_datum.update_map(handle_overlays())

	var/datum/hud/human/user_hud = user.hud_used
	holomap_datum.base_map.loc = user_hud.holomap  // Put the image on the holomap hud
	holomap_datum.base_map.alpha = 0 // Set to transparent so we can fade in

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_position))

	playsound(src, 'sound/machines/holomap/holomap_open.ogg', 125)
	animate(holomap_datum.base_map, alpha = 255, time = 5, easing = LINEAR_EASING)
	icon_state = "station_map_active"
	set_light(HOLOMAP_HIGH_LIGHT)

	user.hud_used.holomap.used_station_map = src
	user.hud_used.holomap.mouse_opacity = MOUSE_OPACITY_ICON
	user.client.screen |= user.hud_used.holomap
	user.client.images |= holomap_datum.base_map

	watching_mob = user
	update_use_power(ACTIVE_POWER_USE)

	if(bogus)
		to_chat(user, span_warning("The holomap failed to initialize. This area of space cannot be mapped."))
	else
		to_chat(user, span_notice("A hologram of the station appears before your eyes."))

	return TRUE

/obj/machinery/holomap/attack_ai(mob/living/silicon/robot/user)
	attack_hand(user)

/obj/machinery/holomap/attack_robot(mob/user)
	attack_hand(user)

/obj/machinery/holomap/process()
	if((machine_stat & (NOPOWER | BROKEN)) || !anchored)
		close_map()

/obj/machinery/holomap/proc/check_position()
	SIGNAL_HANDLER
	if(!watching_mob)
		return

	if(!Adjacent(watching_mob))
		close_map(watching_mob)

/obj/machinery/holomap/proc/close_map()
	if(!watching_mob)
		return

	UnregisterSignal(watching_mob, COMSIG_MOVABLE_MOVED)
	playsound(src, 'sound/machines/holomap/holomap_close.ogg', 125)
	icon_state = initial(icon_state)
	if(watching_mob?.client)
		animate(holomap_datum.base_map, alpha = 0, time = 5, easing = LINEAR_EASING)
		spawn(5) //we give it time to fade out
			watching_mob.client?.screen -= watching_mob.hud_used.holomap
			watching_mob.client?.images -= holomap_datum.base_map
			watching_mob.hud_used.holomap.used_station_map = null
			watching_mob = null
			set_light(HOLOMAP_LOW_LIGHT)

	update_use_power(IDLE_POWER_USE)

/obj/machinery/holomap/power_change()
	. = ..()
	update_icon()

	if(machine_stat & NOPOWER)
		set_light(HOLOMAP_LIGHT_OFF)
	else
		set_light(HOLOMAP_LOW_LIGHT)

/obj/machinery/holomap/proc/set_broken()
	machine_stat |= BROKEN
	update_icon()

/obj/machinery/holomap/update_icon()
	. = ..()
	if(!holomap_datum)
		return //Not yet.

	cut_overlays()
	if(machine_stat & BROKEN)
		icon_state = "station_map_broken"
	else if(panel_open)
		icon_state = "station_map_opened"
	else if((machine_stat & NOPOWER))
		icon_state = "station_map_off"
	else
		icon_state = initial(icon_state)

		if(bogus)
			holomap_datum.initialize_holomap_bogus()
		else
			small_station_map = image(SSholomaps.extra_holomaps["[HOLOMAP_EXTRA_STATIONMAPSMALL]_[current_z_level]"], dir = src.dir)
			add_overlay(small_station_map)

	// Put the little "map" overlay down where it looks nice
	if(floor_markings)
		floor_markings.dir = src.dir
		floor_markings.pixel_x = -src.pixel_x
		floor_markings.pixel_y = -src.pixel_y
		add_overlay(floor_markings)

/obj/machinery/holomap/screwdriver_act(mob/living/user, obj/item/tool)
	if(!default_deconstruction_screwdriver(user, "station_map_opened", "station_map_off", tool))
		return FALSE

	close_map()
	update_icon()

	if(!panel_open)
		setup_holomap()

	return TRUE

/obj/machinery/holomap/multitool_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		to_chat(user, span_warning("You need to open the panel to change the [src]'[p_s()] settings!"))
		return FALSE
	if(!SSholomaps.valid_map_indexes.len > 1)
		to_chat(user, span_warning("There are no other maps available for [src]!"))
		return FALSE

	tool.play_tool_sound(user, 50)
	var/current_index = SSholomaps.valid_map_indexes.Find(current_z_level)
	if(current_index >= SSholomaps.valid_map_indexes.len)
		current_z_level = SSholomaps.valid_map_indexes[1]
	else
		current_z_level = SSholomaps.valid_map_indexes[current_index + 1]

	to_chat(user, span_info("You set the [src]'[p_s()] database index to [current_z_level]."))
	return TRUE

/obj/machinery/holomap/crowbar_act(mob/living/user, obj/item/tool)
	. = default_deconstruction_crowbar(tool, custom_deconstruct = TRUE)

	if(!.)
		return

	new wall_frame_type(loc)
	qdel(src)

/obj/machinery/holomap/emp_act(severity)
	if(severity == EMP_LIGHT && !prob(50))
		return

	do_sparks(8, TRUE, src)
	set_broken()

/obj/machinery/holomap/proc/handle_overlays()
	// Each entry in this list contains the text for the legend, and the icon and icon_state use. Null or non-existent icon_state ignore hiding logic.
	// If an entry contains an icon,
	var/list/legend = list() + GLOB.holomap_default_legend

	var/list/z_transitions = SSholomaps.holomap_z_transitions["[current_z_level]"]
	if(length(z_transitions))
		legend += z_transitions

	return legend

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/holomap, 32)

/obj/machinery/holomap/engineering
	name = "\improper engineering holomap"
	icon_state = "station_map_engi"
	wall_frame_type = /obj/item/wallframe/holomap/engineering

/obj/machinery/holomap/engineering/open
	panel_open = TRUE

/obj/machinery/holomap/engineering/attack_hand(mob/user)
	. = ..()

	if(.)
		holomap_datum.update_map(handle_overlays())

/obj/machinery/holomap/engineering/handle_overlays()
	var/list/extra_overlays = ..()
	if(bogus)
		return extra_overlays

	var/list/fire_alarms = list()
	for(var/obj/machinery/firealarm/alarm as anything in GLOB.station_fire_alarms["[current_z_level]"])
		if(alarm?.z == current_z_level && alarm?.my_area?.active_alarms[ALARM_FIRE])
			var/image/alarm_icon = image('icons/obj/machines/holomap/8x8.dmi', "fire_marker")
			alarm_icon.pixel_x = alarm.x + HOLOMAP_CENTER_X - 1
			alarm_icon.pixel_y = alarm.y + HOLOMAP_CENTER_Y
			fire_alarms += alarm_icon

	if(length(fire_alarms))
		extra_overlays["Fire Alarms"] = list("icon" = image('icons/obj/machines/holomap/8x8.dmi', "fire_marker"), "markers" = fire_alarms)

	var/list/air_alarms = list()
	for(var/obj/machinery/airalarm/air_alarm as anything in GLOB.air_alarms)
		if(air_alarm?.z == current_z_level && air_alarm?.my_area?.active_alarms[ALARM_ATMOS])
			var/image/alarm_icon = image('icons/obj/machines/holomap/8x8.dmi', "atmos_marker")
			alarm_icon.pixel_x = air_alarm.x + HOLOMAP_CENTER_X - 1
			alarm_icon.pixel_y = air_alarm.y + HOLOMAP_CENTER_Y
			air_alarms += alarm_icon

	if(length(air_alarms))
		extra_overlays["Air Alarms"] = list("icon" = image('icons/obj/machines/holomap/8x8.dmi', "atmos_marker"), "markers" = air_alarms)

	return extra_overlays

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/holomap/engineering, 32)

#undef HOLOMAP_LOW_LIGHT
#undef HOLOMAP_HIGH_LIGHT
#undef HOLOMAP_LIGHT_OFF
