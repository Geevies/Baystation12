/mob/living/silicon/ai/ascent
	can_unwrench = FALSE
	visible_on_law_console = FALSE

/mob/living/silicon/ai/ascent/New(loc, var/datum/ai_laws/L, var/obj/item/device/mmi/B, var/safety = 0)
	..(loc, L, B, safety)
	for(var/datum/language/language in languages)
		remove_language(language.name)
	add_language(LANGUAGE_ADHERENT)
	add_language(LANGUAGE_SKRELLIAN)
	view_core()

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
	var/obj/structure/AIcore/deactivated/ascent/C = new /obj/structure/AIcore/deactivated/ascent(get_turf(src))
	empty_playable_ai_cores += C
	GLOB.global_announcer.autosay("[src] has been moved to intelligence storage.", "Artificial Intelligence Oversight")

	//Handle job slot/tater cleanup.
	clear_client()

/mob/living/silicon/ai/ascent/on_mob_init()
	to_chat(src, "<B>You are playing an Ascent AI. The AI cannot move, but can interact with many objects while viewing them (through cameras).</B>")
	to_chat(src, "<B>To look at other areas, click on yourself to get a camera menu.</B>")
	to_chat(src, "<B>While observing through a camera, you can use most (networked) devices which you can see, such as computers, APCs, intercoms, doors, etc.</B>")
	to_chat(src, "To use something, simply click on it.")
	to_chat(src, "For department channels, use the following say commands:")

	var/radio_text = ""
	for(var/i = 1 to silicon_radio.channels.len)
		var/channel = silicon_radio.channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != silicon_radio.channels.len)
			radio_text += ", "

	to_chat(src, radio_text)

	if (GLOB.malf && !(mind in GLOB.malf.current_antagonists))
		show_laws()
		to_chat(src, "<b>These laws may be changed by other players or by other random events.</b>")

	job = "Ascent AI"
	setup_icon()

/mob/living/silicon/ai/ascent/create_eyeobj(var/newloc)
	if(eyeobj)
		destroy_eyeobj()
	var/visualnet = new /datum/visualnet/ascentnet()
	eyeobj = new /mob/observer/eye/ascent(get_turf(src), visualnet)
	eyeobj.possess(src)
	eyeobj.visualnet.add_source(src)
	for(var/obj/machinery/camera/ascent/C in ascent_camera_network)
		eyeobj.visualnet.add_source(C)