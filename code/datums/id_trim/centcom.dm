/// Trim for basic Centcom cards.
/datum/id_trim/centcom
	access = list(ACCESS_CENTCOM_LOWSEC)
	assignment = JOB_CENTCOM
	department_state = "dept-corporate-gold"
	sechud_icon_state = SECHUD_CENTCOM
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_CENTCOM_BLUE

/// Trim for Centcom VIPs
/datum/id_trim/centcom/vip
	access = list(ACCESS_CENTCOM_LOWSEC)
	assignment = JOB_CENTCOM_VIP
	department_state = "dept-vip-gold"

/// Trim for Centcom Custodians.
/datum/id_trim/centcom/custodian
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC)
	assignment = JOB_CENTCOM_CUSTODIAN
	department_state = "dept-civilian"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_SERVICE_LIME

/// Trim for Centcom Thunderdome Overseers.
/datum/id_trim/centcom/thunderdome_overseer
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_SPECIAL_THUNDERDOME)
	assignment = JOB_CENTCOM_THUNDERDOME_OVERSEER

/// Trim for Centcom Officials.
/datum/id_trim/centcom/official
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_SPECIAL_WEAPONS)
	assignment = JOB_CENTCOM_OFFICIAL

/// Trim for Centcom Interns.
/datum/id_trim/centcom/intern
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_SPECIAL_WEAPONS)
	assignment = "CentCom Intern"
	department_state = "dept-corporate"

/// Trim for Centcom Head Interns. Different assignment, common station access added on.
/datum/id_trim/centcom/intern/head
	assignment = "CentCom Head Intern"

/datum/id_trim/centcom/intern/head/New()
	. = ..()

	access |= SSid_access.get_flag_access_list(ACCESS_FLAG_COMMON)

/// Trim for Bounty Hunters hired by centcom.
/datum/id_trim/centcom/bounty_hunter
	access = list(ACCESS_CENTCOM_LOWSEC)
	assignment = "Bounty Hunter"
	department_state = "dept-corporate"

/// Trim for Centcom Bartenders.
/datum/id_trim/centcom/bartender
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC)
	assignment = JOB_CENTCOM_BARTENDER
	department_state = "dept-corporate"

/// Trim for Centcom Medical Officers.
/datum/id_trim/centcom/medical_officer
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC)
	assignment = JOB_CENTCOM_MEDICAL_DOCTOR
	department_state = "dept-corporate"

/// Trim for Centcom Research Officers.
/datum/id_trim/centcom/research_officer
	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_HIGHSEC)
	assignment = JOB_CENTCOM_RESEARCH_OFFICER
	department_state = "dept-corporate"

/// Trim for Centcom Specops Officers. All Centcom and Station Access.
/datum/id_trim/centcom/specops_officer
	assignment = JOB_CENTCOM_SPECIAL_OFFICER

/datum/id_trim/centcom/specops_officer/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Centcom (Soviet) Admirals. All Centcom and Station Access.
/datum/id_trim/centcom/admiral
	assignment = JOB_CENTCOM_ADMIRAL

/datum/id_trim/centcom/admiral/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Centcom Commanders. All Centcom and Station Access.
/datum/id_trim/centcom/commander
	assignment = JOB_CENTCOM_COMMANDER

/datum/id_trim/centcom/commander/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for Deathsquad officers. All Centcom and Station Access.
/datum/id_trim/centcom/deathsquad
	assignment = JOB_ERT_DEATHSQUAD
	department_state = "dept-deathsquad"
	sechud_icon_state = SECHUD_DEATH_COMMANDO

/datum/id_trim/centcom/deathsquad/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for generic ERT interns. No universal ID card changing access.
/datum/id_trim/centcom/ert
	assignment = "Emergency Response Team Intern"
	department_state = "dept-corporate"

/datum/id_trim/centcom/ert/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)

/// Trim for ERT Commanders. All station and centcom access.
/datum/id_trim/centcom/ert/commander
	assignment = JOB_ERT_COMMANDER
	department_state = "dept-corporate-gold"
	sechud_icon_state = SECHUD_EMERGENCY_RESPONSE_TEAM_COMMANDER

/datum/id_trim/centcom/ert/commander/New()
	. = ..()

	access = SSid_access.get_region_access_list(list(REGION_CENTCOM, REGION_ALL_STATION))

/// Trim for generic ERT seccies. No universal ID card changing access.
/datum/id_trim/centcom/ert/security
	assignment = JOB_ERT_OFFICER
	subdepartment_color = COLOR_SECURITY_RED
	sechud_icon_state = SECHUD_SECURITY_RESPONSE_OFFICER

/datum/id_trim/centcom/ert/security/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)

/// Trim for generic ERT engineers. No universal ID card changing access.
/datum/id_trim/centcom/ert/engineer
	assignment = JOB_ERT_ENGINEER
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_ENGINEERING_RESPONSE_OFFICER

/datum/id_trim/centcom/ert/engineer/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)

/// Trim for generic ERT medics. No universal ID card changing access.
/datum/id_trim/centcom/ert/medical
	assignment = JOB_ERT_MEDICAL_DOCTOR
	subdepartment_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_MEDICAL_RESPONSE_OFFICER

/datum/id_trim/centcom/ert/medical/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)

/// Trim for generic ERT chaplains. No universal ID card changing access.
/datum/id_trim/centcom/ert/chaplain
	assignment = JOB_ERT_CHAPLAIN
	subdepartment_color = "#58C800"
	sechud_icon_state = SECHUD_RELIGIOUS_RESPONSE_OFFICER

/datum/id_trim/centcom/ert/chaplain/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_HIGHSEC, ACCESS_CENTCOM_LOWSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)

/// Trim for generic ERT janitors. No universal ID card changing access.
/datum/id_trim/centcom/ert/janitor
	assignment = JOB_ERT_JANITOR
	subdepartment_color = COLOR_SERVICE_LIME
	sechud_icon_state = SECHUD_JANITORIAL_RESPONSE_OFFICER

/datum/id_trim/centcom/ert/janitor/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)

/// Trim for generic ERT clowns. No universal ID card changing access.
/datum/id_trim/centcom/ert/clown
	assignment = JOB_ERT_CLOWN
	subdepartment_color = COLOR_MAGENTA
	sechud_icon_state = SECHUD_ENTERTAINMENT_RESPONSE_OFFICER

/datum/id_trim/centcom/ert/clown/New()
	. = ..()

	access = list(ACCESS_CENTCOM_LOWSEC, ACCESS_CENTCOM_LOWSEC) | (SSid_access.get_region_access_list(list(REGION_ALL_STATION)) - ACCESS_COMMAND_LOWSEC)
