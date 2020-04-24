/mob/living/silicon/ai/ascent
	law_override = /datum/ai_laws/ascent
	can_unwrench = FALSE
	visible_on_law_console = FALSE

/mob/living/silicon/ai/ascent/New(loc, var/datum/ai_laws/L, var/obj/item/device/mmi/B, var/safety = 0)
	..()
	for(var/language in languages)
		remove_language(language)
	add_language(LANGUAGE_ADHERENT)
	add_language(LANGUAGE_SKRELLIAN)