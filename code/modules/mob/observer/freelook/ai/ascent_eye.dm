/mob/observer/eye/ascent
	name = "Ascent AI Eye"
	desc = "An Ascent AI eye."

/mob/observer/eye/ascent/New(var/loc, var/net)
	..()
	visualnet = net

/mob/observer/eye/ascent/Destroy()
	visualnet = null
	return ..()