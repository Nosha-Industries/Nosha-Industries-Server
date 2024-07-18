/*
Because mapping is already tedious enough this spawner let you spawn generic
"sets" of objects rather than having to make the same object stack again and
again.
*/

/obj/effect/spawner/structure
	name = "map structure spawner"
	var/list/spawn_list

/obj/effect/spawner/structure/Initialize(mapload)
	. = ..()

	for(var/spawn_type in spawn_list)
		new spawn_type(loc)

	return INITIALIZE_HINT_QDEL


//normal windows

/obj/effect/spawner/structure/window
	icon = 'icons/obj/smooth_structures/window.dmi'
	icon_state = "window-0"
	name = "window spawner"
	spawn_list = list(/obj/structure/low_wall, /obj/structure/window/fulltile)
	dir = SOUTH
	color = "#AFD3E6"

/obj/effect/spawner/structure/window/Initialize(mapload)
	. = ..()

	var/turf/current_turf = loc
	current_turf.rcd_memory = RCD_MEMORY_WINDOWGRILLE

/obj/effect/spawner/structure/window/wood
	name = "window with wooden low wall spawner"
	spawn_list = list(/obj/structure/low_wall/wood, /obj/structure/window/fulltile)


/obj/effect/spawner/structure/window/hollow
	icon = 'icons/obj/structures_spawners.dmi'
	name = "hollow window spawner"
	icon_state = "hwindow_spawner_full"
	spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/north, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)

/obj/effect/spawner/structure/window/hollow/end
	icon_state = "hwindow_spawner_end"

/obj/effect/spawner/structure/window/hollow/end/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/north, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/north, /obj/structure/window/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/north, /obj/structure/window/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/middle
	icon_state = "hwindow_spawner_middle"

/obj/effect/spawner/structure/window/hollow/middle/Initialize(mapload)
	switch(dir)
		if(NORTH,SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/north)
		if(EAST,WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/east, /obj/structure/window/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/directional
	icon_state = "hwindow_spawner_directional"

/obj/effect/spawner/structure/window/hollow/directional/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/north)
		if(NORTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/north, /obj/structure/window/spawner/east)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/east)
		if(SOUTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window)
		if(SOUTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window, /obj/structure/window/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/west)
		if(NORTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/spawner/north, /obj/structure/window/spawner/west)
	. = ..()

//reinforced

/obj/effect/spawner/structure/window/reinforced
	icon = 'icons/obj/smooth_structures/window_reinforced.dmi'
	name = "reinforced window spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/low_wall, /obj/structure/window/reinforced/fulltile)
	color = "#AFD3E6"

/obj/effect/spawner/structure/window/reinforced/no_grille
	spawn_list = list(/obj/structure/low_wall, /obj/structure/window/reinforced/fulltile)

/obj/effect/spawner/structure/window/reinforced/wood
	name = "reinforced window with wooden low wall spawner"
	icon_state = "rwindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/low_wall/wood, /obj/structure/window/reinforced/fulltile)

/obj/effect/spawner/structure/window/hollow/reinforced
	name = "hollow reinforced window spawner"
	icon_state = "hrwindow_spawner_full"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/north, /obj/structure/window/reinforced/spawner/east, /obj/structure/window/reinforced/spawner/west)

/obj/effect/spawner/structure/window/hollow/reinforced/end
	icon_state = "hrwindow_spawner_end"

/obj/effect/spawner/structure/window/hollow/reinforced/end/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/north, /obj/structure/window/reinforced/spawner/east, /obj/structure/window/reinforced/spawner/west)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/north, /obj/structure/window/reinforced/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/east, /obj/structure/window/reinforced/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/north, /obj/structure/window/reinforced/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/reinforced/middle
	icon_state = "hrwindow_spawner_middle"

/obj/effect/spawner/structure/window/hollow/reinforced/middle/Initialize(mapload)
	switch(dir)
		if(NORTH,SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/north)
		if(EAST,WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/east, /obj/structure/window/reinforced/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/reinforced/directional
	icon_state = "hrwindow_spawner_directional"

/obj/effect/spawner/structure/window/hollow/reinforced/directional/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/north)
		if(NORTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/north, /obj/structure/window/reinforced/spawner/east)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/east)
		if(SOUTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced)
		if(SOUTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced, /obj/structure/window/reinforced/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/west)
		if(NORTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/spawner/north, /obj/structure/window/reinforced/spawner/west)
	. = ..()

//tinted

/obj/effect/spawner/structure/window/reinforced/tinted
	name = "tinted reinforced window spawner"
	spawn_list = list(/obj/structure/low_wall, /obj/structure/window/reinforced/tinted/fulltile)
	color = COLOR_ALMOST_BLACK

/obj/effect/spawner/structure/window/reinforced/tinted/grille
	name = "tinted reinforced window with grille spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/low_wall, /obj/structure/window/reinforced/tinted/fulltile)

//bronze

/obj/effect/spawner/structure/window/bronze
	icon = 'icons/obj/structures_spawners.dmi'
	name = "bronze window spawner"
	icon_state = "bronzewindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/bronze/fulltile)


//shuttle window

/obj/effect/spawner/structure/window/reinforced/shuttle
	name = "shuttle window spawner"
	spawn_list = list(/obj/structure/low_wall/titanium, /obj/structure/window/reinforced/shuttle)
	color = "#cbdee9"


//plastitanium window

/obj/effect/spawner/structure/window/reinforced/plasma/plastitanium
	icon = 'icons/obj/structures_spawners.dmi'
	name = "plastitanium window spawner"
	icon_state = "plastitaniumwindow_spawner"
	spawn_list = list(/obj/structure/low_wall/plastitanium, /obj/structure/window/reinforced/plasma/plastitanium)


//ice window

/obj/effect/spawner/structure/window/ice
	icon = 'icons/obj/structures_spawners.dmi'
	name = "ice window spawner"
	icon_state = "icewindow_spawner"
	spawn_list = list(/obj/structure/low_wall, /obj/structure/window/reinforced/fulltile/ice)


//survival pod window

/obj/effect/spawner/structure/window/survival_pod
	icon = 'icons/obj/structures_spawners.dmi'
	name = "pod window spawner"
	icon_state = "podwindow_spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod)

/obj/effect/spawner/structure/window/hollow/survival_pod
	name = "hollow pod window spawner"
	icon_state = "podwindow_spawner_full"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)

/obj/effect/spawner/structure/window/hollow/survival_pod/end
	icon_state = "podwindow_spawner_end"

/obj/effect/spawner/structure/window/hollow/survival_pod/end/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/survival_pod/middle
	icon_state = "podwindow_spawner_middle"

/obj/effect/spawner/structure/window/hollow/survival_pod/middle/Initialize(mapload)
	switch(dir)
		if(NORTH,SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north)
		if(EAST,WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/survival_pod/directional
	icon_state = "podwindow_spawner_directional"

/obj/effect/spawner/structure/window/hollow/survival_pod/directional/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north)
		if(NORTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east)
		if(SOUTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod)
		if(SOUTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
		if(NORTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/north, /obj/structure/window/reinforced/shuttle/survival_pod/spawner/west)
	. = ..()


//plasma windows

/obj/effect/spawner/structure/window/plasma
	icon = 'icons/obj/smooth_structures/window.dmi'
	name = "plasma window spawner"
	spawn_list = list(/obj/structure/low_wall, /obj/structure/window/plasma/fulltile)
	color = "#c162ec"

/obj/effect/spawner/structure/window/hollow/plasma
	name = "hollow plasma window spawner"
	icon_state = "phwindow_spawner_full"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/north, /obj/structure/window/plasma/spawner/east, /obj/structure/window/plasma/spawner/west)

/obj/effect/spawner/structure/window/hollow/plasma/end
	icon_state = "phwindow_spawner_end"

/obj/effect/spawner/structure/window/hollow/plasma/end/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/north, /obj/structure/window/plasma/spawner/east, /obj/structure/window/plasma/spawner/west)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/north, /obj/structure/window/plasma/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/east, /obj/structure/window/plasma/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/north, /obj/structure/window/plasma/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/plasma/middle
	icon_state = "phwindow_spawner_middle"

/obj/effect/spawner/structure/window/hollow/plasma/middle/Initialize(mapload)
	switch(dir)
		if(NORTH,SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/north)
		if(EAST,WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/east, /obj/structure/window/plasma/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/plasma/directional
	icon_state = "phwindow_spawner_directional"

/obj/effect/spawner/structure/window/hollow/plasma/directional/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/north)
		if(NORTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/north, /obj/structure/window/plasma/spawner/east)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/east)
		if(SOUTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma)
		if(SOUTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma, /obj/structure/window/plasma/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/west)
		if(NORTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/plasma/spawner/north, /obj/structure/window/plasma/spawner/west)
	. = ..()

//reinforced plasma

/obj/effect/spawner/structure/window/reinforced/plasma
	icon = 'icons/obj/smooth_structures/window_reinforced.dmi'
	name = "reinforced plasma window spawner"
	spawn_list = list(/obj/structure/grille, /obj/structure/low_wall, /obj/structure/window/reinforced/plasma/fulltile)

/obj/effect/spawner/structure/window/hollow/reinforced/plasma
	name = "hollow reinforced plasma window spawner"
	icon_state = "phrwindow_spawner_full"
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/north, /obj/structure/window/reinforced/plasma/spawner/east, /obj/structure/window/reinforced/plasma/spawner/west)

/obj/effect/spawner/structure/window/hollow/reinforced/plasma/end
	icon_state = "phrwindow_spawner_end"

/obj/effect/spawner/structure/window/hollow/reinforced/plasma/end/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/north, /obj/structure/window/reinforced/plasma/spawner/east, /obj/structure/window/reinforced/plasma/spawner/west)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/north, /obj/structure/window/reinforced/plasma/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/east, /obj/structure/window/reinforced/plasma/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/north, /obj/structure/window/reinforced/plasma/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/reinforced/plasma/middle
	icon_state = "phrwindow_spawner_middle"

/obj/effect/spawner/structure/window/hollow/reinforced/plasma/middle/Initialize(mapload)
	switch(dir)
		if(NORTH,SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/north)
		if(EAST,WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/east, /obj/structure/window/reinforced/plasma/spawner/west)
	. = ..()

/obj/effect/spawner/structure/window/hollow/reinforced/plasma/directional
	icon_state = "phrwindow_spawner_directional"

/obj/effect/spawner/structure/window/hollow/reinforced/plasma/directional/Initialize(mapload)
	switch(dir)
		if(NORTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/north)
		if(NORTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/north, /obj/structure/window/reinforced/plasma/spawner/east)
		if(EAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/east)
		if(SOUTHEAST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/east)
		if(SOUTH)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma)
		if(SOUTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma, /obj/structure/window/reinforced/plasma/spawner/west)
		if(WEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/west)
		if(NORTHWEST)
			spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/plasma/spawner/north, /obj/structure/window/reinforced/plasma/spawner/west)
	. = ..()

/obj/effect/spawner/structure/electrified_grille
	name = "electrified grill spawner"
	icon = 'icons/obj/structures_spawners.dmi'
	icon_state = "electrified_grille"
	spawn_list = list(/obj/structure/grille, /obj/structure/cable)
