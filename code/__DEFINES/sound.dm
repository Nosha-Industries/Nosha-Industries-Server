//max channel is 1024. Only go lower from here, because byond tends to pick the first available channel to play sounds on
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023
#define CHANNEL_VOX 1022
#define CHANNEL_JUKEBOX 1021
#define CHANNEL_HEARTBEAT 1020 //sound channel for heartbeats
#define CHANNEL_AMBIENCE 1019
#define CHANNEL_BUZZ 1018
#define CHANNEL_TRAITOR 1017

///Default range of a sound.
#define SOUND_RANGE 17
#define MEDIUM_RANGE_SOUND_EXTRARANGE -5
///default extra range for sounds considered to be quieter
#define SHORT_RANGE_SOUND_EXTRARANGE -9
///The range deducted from sound range for things that are considered silent / sneaky
#define SILENCED_SOUND_EXTRARANGE -11
///Percentage of sound's range where no falloff is applied
#define SOUND_DEFAULT_FALLOFF_DISTANCE 1 //For a normal sound this would be 1 tile of no falloff
///The default exponent of sound falloff
#define SOUND_FALLOFF_EXPONENT 6

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

#define CHANNEL_HIGHEST_AVAILABLE 1015

// TODO: This is currently set to 2 because of legacy audio volumes. Re-balance all audio with a target of NUM_E or 3
/// Logarithmic exponent for volume levels - Good values are 2, NUM_E, 3 and 4, depending on loudness.
#define LOGARITHMIC_AUDIO_VOLUME_EXPONENT 2
// I hate the following but my smooth brain can't come up with a better way to multiply this correctly.
// (x²) * 0.01 would work, but the multiplier is dependent on the exponent.
/// Helper macro for converting linear volume to logarithmic.
#define LOG_AUDIOVOLUME(X) (((X * 0.01) ** LOGARITHMIC_AUDIO_VOLUME_EXPONENT) * 100)

#define MAX_INSTRUMENT_CHANNELS (128 * 6)

#define SOUND_MINIMUM_PRESSURE 10

#define INTERACTION_SOUND_RANGE_MODIFIER -3
#define EQUIP_SOUND_VOLUME 30
#define PICKUP_SOUND_VOLUME 15
#define DROP_SOUND_VOLUME 20
#define YEET_SOUND_VOLUME 90

#define AMBIENCE_GENERIC "generic"
#define AMBIENCE_HOLY "holy"
#define AMBIENCE_DANGER "danger"
#define AMBIENCE_RUINS "ruins"
#define AMBIENCE_ENGI "engi"
#define AMBIENCE_MINING "mining"
#define AMBIENCE_MEDICAL "med"
#define AMBIENCE_VIROLOGY "viro"
#define AMBIENCE_SPOOKY "spooky"
#define AMBIENCE_SPACE "space"
#define AMBIENCE_MAINT "maint"
#define AMBIENCE_AWAY "away"
#define AMBIENCE_REEBE "reebe" //unused
#define AMBIENCE_CREEPY "creepy" //not to be confused with spooky

//default byond sound environments
#define SOUND_ENVIRONMENT_NONE -1
#define SOUND_ENVIRONMENT_GENERIC 0
#define SOUND_ENVIRONMENT_PADDED_CELL 1
#define SOUND_ENVIRONMENT_ROOM 2
#define SOUND_ENVIRONMENT_BATHROOM 3
#define SOUND_ENVIRONMENT_LIVINGROOM 4
#define SOUND_ENVIRONMENT_STONEROOM 5
#define SOUND_ENVIRONMENT_AUDITORIUM 6
#define SOUND_ENVIRONMENT_CONCERT_HALL 7
#define SOUND_ENVIRONMENT_CAVE 8
#define SOUND_ENVIRONMENT_ARENA 9
#define SOUND_ENVIRONMENT_HANGAR 10
#define SOUND_ENVIRONMENT_CARPETED_HALLWAY 11
#define SOUND_ENVIRONMENT_HALLWAY 12
#define SOUND_ENVIRONMENT_STONE_CORRIDOR 13
#define SOUND_ENVIRONMENT_ALLEY 14
#define SOUND_ENVIRONMENT_FOREST 15
#define SOUND_ENVIRONMENT_CITY 16
#define SOUND_ENVIRONMENT_MOUNTAINS 17
#define SOUND_ENVIRONMENT_QUARRY 18
#define SOUND_ENVIRONMENT_PLAIN 19
#define SOUND_ENVIRONMENT_PARKING_LOT 20
#define SOUND_ENVIRONMENT_SEWER_PIPE 21
#define SOUND_ENVIRONMENT_UNDERWATER 22
#define SOUND_ENVIRONMENT_DRUGGED 23
#define SOUND_ENVIRONMENT_DIZZY 24
#define SOUND_ENVIRONMENT_PSYCHOTIC 25
//If we ever make custom ones add them here
#define SOUND_ENVIROMENT_PHASED list(1.8, 0.5, -1000, -4000, 0, 5, 0.1, 1, -15500, 0.007, 2000, 0.05, 0.25, 1, 1.18, 0.348, -5, 2000, 250, 0, 3, 100, 63)

//"sound areas": easy way of keeping different types of areas consistent.
#define SOUND_AREA_STANDARD_STATION SOUND_ENVIRONMENT_PARKING_LOT
#define SOUND_AREA_LARGE_ENCLOSED SOUND_ENVIRONMENT_QUARRY
#define SOUND_AREA_SMALL_ENCLOSED SOUND_ENVIRONMENT_BATHROOM
#define SOUND_AREA_TUNNEL_ENCLOSED SOUND_ENVIRONMENT_STONEROOM
#define SOUND_AREA_LARGE_SOFTFLOOR SOUND_ENVIRONMENT_CARPETED_HALLWAY
#define SOUND_AREA_MEDIUM_SOFTFLOOR SOUND_ENVIRONMENT_LIVINGROOM
#define SOUND_AREA_SMALL_SOFTFLOOR SOUND_ENVIRONMENT_ROOM
#define SOUND_AREA_ASTEROID SOUND_ENVIRONMENT_CAVE
#define SOUND_AREA_SPACE SOUND_ENVIRONMENT_UNDERWATER
#define SOUND_AREA_LAVALAND SOUND_ENVIRONMENT_MOUNTAINS
#define SOUND_AREA_ICEMOON SOUND_ENVIRONMENT_CAVE
#define SOUND_AREA_WOODFLOOR SOUND_ENVIRONMENT_CITY


///Announcer audio keys
#define ANNOUNCER_AIMALF "announcer_aimalf"
#define ANNOUNCER_ALIENS "announcer_aliens"
#define ANNOUNCER_ANIMES "announcer_animes"
#define ANNOUNCER_GRANOMALIES "announcer_granomalies"
#define ANNOUNCER_INTERCEPT "announcer_intercept"
#define ANNOUNCER_IONSTORM "announcer_ionstorm"
#define ANNOUNCER_METEORS "announcer_meteors"
#define ANNOUNCER_OUTBREAK5 "announcer_outbreak5"
#define ANNOUNCER_OUTBREAK7 "announcer_outbreak7"
#define ANNOUNCER_POWEROFF "announcer_poweroff"
#define ANNOUNCER_POWERON "announcer_poweron"
#define ANNOUNCER_RADIATION "announcer_radiation"
#define ANNOUNCER_SHUTTLECALLED "announcer_shuttlecalled"
#define ANNOUNCER_SHUTTLEDOCK "announcer_shuttledock"
#define ANNOUNCER_SHUTTLERECALLED "announcer_shuttlerecalled"
#define ANNOUNCER_SPANOMALIES "announcer_spanomalies"

/// Global list of all of our announcer keys.
GLOBAL_LIST_INIT(announcer_keys, list(
	ANNOUNCER_AIMALF,
	ANNOUNCER_ALIENS,
	ANNOUNCER_ANIMES,
	ANNOUNCER_GRANOMALIES,
	ANNOUNCER_INTERCEPT,
	ANNOUNCER_IONSTORM,
	ANNOUNCER_METEORS,
	ANNOUNCER_OUTBREAK5,
	ANNOUNCER_OUTBREAK7,
	ANNOUNCER_POWEROFF,
	ANNOUNCER_POWERON,
	ANNOUNCER_RADIATION,
	ANNOUNCER_SHUTTLECALLED,
	ANNOUNCER_SHUTTLEDOCK,
	ANNOUNCER_SHUTTLERECALLED,
	ANNOUNCER_SPANOMALIES,
))

/// List of all of our sound keys.
#define SFX_BODYFALL "bodyfall"
#define SFX_BULLET_MISS "bullet_miss"
#define SFX_CAN_OPEN "can_open"
#define SFX_CLOWN_STEP "clown_step"
#define SFX_DESECRATION "desecration"
#define SFX_EXPLOSION "explosion"
#define SFX_EXPLOSION_CREAKING "explosion_creaking"
#define SFX_HISS "hiss"
#define SFX_HONKBOT_E "honkbot_e"
#define SFX_HULL_CREAKING "hull_creaking"
#define SFX_HYPERTORUS_CALM "hypertorus_calm"
#define SFX_HYPERTORUS_MELTING "hypertorus_melting"
#define SFX_IM_HERE "im_here"
#define SFX_LAW "law"
#define SFX_PAGE_TURN "page_turn"
#define SFX_PUNCH "punch"
#define SFX_REVOLVER_SPIN "revolver_spin"
#define SFX_RICOCHET "ricochet"
#define SFX_RUSTLE "rustle"
#define SFX_SHATTER "shatter"
#define SFX_SM_CALM "sm_calm"
#define SFX_SM_DELAM "sm_delam"
#define SFX_SPARKS "sparks"
#define SFX_SUIT_STEP "suit_step"
#define SFX_SWING_HIT "swing_hit"
#define SFX_TERMINAL_TYPE "terminal_type"
#define SFX_WARPSPEED "warpspeed"
#define SFX_CRUNCHY_BUSH_WHACK "crunchy_bush_whack"
#define SFX_TREE_CHOP "tree_chop"
#define SFX_ROCK_TAP "rock_tap"
#define SFX_SWITCH "switch"
#define SFX_KEYBOARD "keyboard"
#define SFX_PDA "pda"

#define EMOTE_VOICE_HUMAN_M "Human Male"
#define EMOTE_VOICE_HUMAN_F "Human Female"
#define EMOTE_VOICE_LIZARD_M "Lizard Male"
#define EMOTE_VOICE_LIZARD_F "Lizard Female"
#define EMOTE_VOICE_MOTH_M "Moth Male"
#define EMOTE_VOICE_MOTH_F "Moth Female"
#define EMOTE_VOICE_ETHEREAL_M "Ethereal Male"
#define EMOTE_VOICE_ETHEREAL_F "Ethereal Female"
