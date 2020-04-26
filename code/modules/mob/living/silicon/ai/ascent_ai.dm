/mob/living/silicon/ai/ascent
	can_unwrench = FALSE
	visible_on_law_console = FALSE

/mob/living/silicon/ai/ascent/New(loc, var/datum/ai_laws/L, var/obj/item/device/mmi/B, var/safety = 0)
	..(loc, L, B, safety)
	for(var/language in languages)
		remove_language(language)
	add_language(LANGUAGE_ADHERENT)
	add_language(LANGUAGE_SKRELLIAN)

/mob/living/silicon/ai/ascent/wipe_core()
	set name = "Wipe Core"
	set category = "OOC"
	set desc = "Wipe your core. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	if(istype(loc, /obj/item))
		to_chat(src, "You cannot wipe your core when you are on a portable storage device.")
		return

	// Guard against misclicks, this isn't the sort of thing we want happening accidentally
	if(alert("WARNING: This will immediately wipe your core and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Core", "No", "No", "Yes") != "Yes")
		return

	if(istype(loc, /obj/item))
		to_chat(src, "You cannot wipe your core when you are on a portable storage device.")
		return

	if(is_special_character(src))
		log_and_message_admins("removed themselves from the round via Wipe Core")

	// We warned you.
	var/obj/structure/AIcore/deactivated/C = new /obj/structure/AIcore/deactivated(get_turf(src))
	C.name = "inactive Ascent AI"
	empty_playable_ai_cores += C
	GLOB.global_announcer.autosay("[src] has been moved to intelligence storage.", "Artificial Intelligence Oversight")

	//Handle job slot/tater cleanup.
	clear_client()