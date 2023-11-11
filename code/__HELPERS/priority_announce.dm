// please don't use these defines outside of this file in order to ensure a unified framework. unless you have a really good reason to make them global, then whatever

// these four are just text spans that furnish the TEXT itself with the appropriate CSS classes
#define MAJOR_ANNOUNCEMENT_TITLE(string) ("<span class='major_announcement_title'>" + string + "</span>")
#define MAJOR_ANNOUNCEMENT_TEXT(string) ("<span class='major_announcement_text'>" + string + "</span>")
#define MINOR_ANNOUNCEMENT_TITLE(string) ("<span class='minor_announcement_title'>" + string + "</span>")
#define MINOR_ANNOUNCEMENT_TEXT(string) ("<span class='minor_announcement_text'>" + string + "</span>")

// these two are the ones that actually give the striped background
#define CHAT_ALERT_DEFAULT_SPAN(string) ("<div class='chat_alert_default'>" + string + "</div>")
#define CHAT_ALERT_COLORED_SPAN(color, string) ("<div class='chat_alert_" + color + "'>" + string + "</div>")

/**
 * Make a big red text announcement to
 *
 * Formatted like:
 *
 * " Message from sender "
 *
 * " Title "
 *
 * " Text "
 *
 * Arguments
 * * text - required, the text to announce
 * * title - optional, the title of the announcement.
 * * sound - optional, the sound played accompanying the announcement
 * * type - optional, the type of the announcement, for some "preset" announcement templates. See __DEFINES/announcements.dm
 * * sender_override - optional, modifies the sender of the announcement
 * * has_important_message - is this message critical to the game (and should not be overridden by station traits), or not
 * * players - a list of all players to send the message to. defaults to all players (not including new players)
 * * encode_title - if TRUE, the title will be HTML encoded
 * * encode_text - if TRUE, the text will be HTML encoded
 */
/proc/priority_announce(text, title = "", sound, type, sender_override, has_important_message = FALSE, list/mob/players, encode_title = TRUE, encode_text = TRUE)
	if(!text)
		return

	if(encode_title && title && length(title) > 0)
		title = html_encode(title)
	if(encode_text)
		text = html_encode(text)
		if(!length(text))
			return

	var/list/announcement_strings = list()

	if(!sound)
		sound = SSstation.announcer.get_rand_alert_sound()
	else if(SSstation.announcer.event_sounds[sound])
		sound = SSstation.announcer.event_sounds[sound]

	var/header
	switch(type)
		if(ANNOUNCEMENT_TYPE_PRIORITY)
			header = MAJOR_ANNOUNCEMENT_TITLE("Priority Announcement")
			if(length(title) > 0)
				header += MINOR_ANNOUNCEMENT_TITLE(title)
		if(ANNOUNCEMENT_TYPE_CAPTAIN)
			header = MAJOR_ANNOUNCEMENT_TITLE("Captain's Announcement")
			GLOB.news_network.submit_article(text, "Captain's Announcement", "Station Announcements", null)
		if(ANNOUNCEMENT_TYPE_SYNDICATE)
			header = MAJOR_ANNOUNCEMENT_TITLE("Syndicate Captain's Announcement")
		else
			header += generate_unique_announcement_header(title, sender_override)

	announcement_strings += header

	///If the announcer overrides alert messages, use that message.
	if(SSstation.announcer.custom_alert_message && !has_important_message)
		announcement_strings += SSstation.announcer.custom_alert_message
	else
		announcement_strings += MAJOR_ANNOUNCEMENT_TEXT(text)

	var/finalized_announcement = CHAT_ALERT_DEFAULT_SPAN(jointext(announcement_strings, "<br>"))

	dispatch_announcement_to_players(finalized_announcement, players, sound)

	if(isnull(sender_override))
		if(length(title) > 0)
			GLOB.news_network.submit_article(title + "<br><br>" + text, "Central Command", "Station Announcements", null)
		else
			GLOB.news_network.submit_article(text, "Central Command Update", "Station Announcements", null)

/**
 * Summon the crew for an emergency meeting
 *
 * Teleports the crew to a specified area, and tells everyone (via an announcement) who called the meeting. Should only be used during april fools!
 * Arguments:
 * * user - Mob who called the meeting
 * * button_zone - Area where the meeting was called and where everyone will get teleported to
 */
/proc/call_emergency_meeting(mob/living/user, area/button_zone)
	var/meeting_sound = sound('sound/misc/emergency_meeting.ogg')
	var/announcement
	announcement += "<h1 class='alert'>Captain Alert</h1>"
	announcement += "<br>[span_alert("[user] has called an Emergency Meeting!")]<br><br>"

	for(var/mob/mob_to_teleport in GLOB.player_list) //gotta make sure the whole crew's here!
		if(isnewplayer(mob_to_teleport) || iscameramob(mob_to_teleport))
			continue
		to_chat(mob_to_teleport, announcement)
		SEND_SOUND(mob_to_teleport, meeting_sound) //no preferences here, you must hear the funny sound
		mob_to_teleport.overlay_fullscreen("emergency_meeting", /atom/movable/screen/fullscreen/emergency_meeting, 1)
		addtimer(CALLBACK(mob_to_teleport, TYPE_PROC_REF(/mob/, clear_fullscreen), "emergency_meeting"), 3 SECONDS)

		if (is_station_level(mob_to_teleport.z)) //teleport the mob to the crew meeting
			var/turf/target
			var/list/turf_list = get_area_turfs(button_zone)
			while (!target && turf_list.len)
				target = pick_n_take(turf_list)
				if (isclosedturf(target))
					target = null
					continue
				mob_to_teleport.forceMove(target)

/proc/print_command_report(text = "", title = null, announce=TRUE)
	if(!title)
		title = "Classified [command_name()] Update"

	if(announce)
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", SSstation.announcer.get_rand_report_sound(), has_important_message = TRUE)

	var/datum/comm_message/M = new
	M.title = title
	M.content = text

	SScommunications.send_message(M)

/**
 * Sends a minor annoucement to players.
 * Minor announcements are large text, with the title in red and message in white.
 * Only mobs that can hear can see the announcements.
 *
 * message - the message contents of the announcement.
 * title - the title of the announcement, which is often "who sent it".
 * alert - whether this announcement is an alert, or just a notice. Only changes the sound that is played by default.
 * html_encode - if TRUE, we will html encode our title and message before sending it, to prevent player input abuse.
 * players - optional, a list mobs to send the announcement to. If unset, sends to all palyers.
 * sound_override - optional, use the passed sound file instead of the default notice sounds.
 */
/proc/minor_announce(message, title = "Attention:", alert = FALSE, html_encode = TRUE, list/players = null, sound_override = null, should_play_sound = TRUE)
	if(!message)
		return

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	var/list/minor_announcement_strings = list()
	minor_announcement_strings += MINOR_ANNOUNCEMENT_TITLE(title)
	minor_announcement_strings += MINOR_ANNOUNCEMENT_TEXT(message)

	var/finalized_announcement = CHAT_ALERT_DEFAULT_SPAN(jointext(minor_announcement_strings, "<br>"))

	var/custom_sound = sound_override || (alert ? 'sound/misc/notice1.ogg' : 'sound/misc/notice2.ogg')
	dispatch_announcement_to_players(finalized_announcement, players, custom_sound, should_play_sound)

/// Sends an announcement about the level changing to players. Uses the passed in datum and the subsystem's previous security level to generate the message.
/proc/level_announce(datum/security_level/selected_level, previous_level_number)
	var/current_level_number = selected_level.number_level
	var/current_level_name = selected_level.name
	var/current_level_color = selected_level.announcement_color
	var/current_level_sound = selected_level.sound

	var/title
	var/message

	if(current_level_number > previous_level_number)
		title = "Attention! Security level elevated to [current_level_name]:"
		message = selected_level.elevating_to_announcement
	else
		title = "Attention! Security level lowered to [current_level_name]:"
		message = selected_level.lowering_to_announcement

	var/list/level_announcement_strings = list()
	level_announcement_strings += MINOR_ANNOUNCEMENT_TITLE(title)
	level_announcement_strings += MINOR_ANNOUNCEMENT_TEXT(message)

	var/finalized_announcement = CHAT_ALERT_COLORED_SPAN(current_level_color, jointext(level_announcement_strings, "<br>"))

	dispatch_announcement_to_players(finalized_announcement, GLOB.player_list, current_level_sound)

/// Proc that just generates a custom header based on variables fed into `priority_announce()`
/// Will return a string.
/proc/generate_unique_announcement_header(title, sender_override)
	var/list/returnable_strings = list()
	if(isnull(sender_override))
		returnable_strings += MAJOR_ANNOUNCEMENT_TITLE("[command_name()] Update")
	else
		returnable_strings += MAJOR_ANNOUNCEMENT_TITLE(sender_override)

	if(length(title) > 0)
		returnable_strings += MINOR_ANNOUNCEMENT_TITLE(title)

	return jointext(returnable_strings, "<br>")

/// Proc that just dispatches the announcement to our applicable audience. Only the announcement is a mandatory arg.
/proc/dispatch_announcement_to_players(announcement, list/players, sound_override = null, should_play_sound = TRUE)
	if(!players)
		players = GLOB.player_list

	var/sound_to_play = !isnull(sound_override) ? sound_override : 'sound/misc/notice2.ogg'

	for(var/mob/target in players)
		if(isnewplayer(target) || !target.can_hear())
			continue

		to_chat(target, announcement)
		if(!should_play_sound)
			continue

		if(target.client?.prefs.toggles & SOUND_ANNOUNCEMENTS)
			SEND_SOUND(target, sound(sound_to_play))

#undef MAJOR_ANNOUNCEMENT_TITLE
#undef MAJOR_ANNOUNCEMENT_TEXT
#undef MINOR_ANNOUNCEMENT_TITLE
#undef MINOR_ANNOUNCEMENT_TEXT
#undef CHAT_ALERT_DEFAULT_SPAN
#undef CHAT_ALERT_COLORED_SPAN
