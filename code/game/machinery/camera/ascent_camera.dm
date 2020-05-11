var/global/list/ascent_camera_network = list()

/obj/machinery/camera/ascent
	name = "ascent camera"
	network = list(NETWORK_ASCENT)

/obj/machinery/camera/ascent/Initialize()
	. = ..()
	ascent_camera_network += src
	for(var/mob/living/silicon/ai/ascent/A in ai_list)
		A.eyeobj.visualnet.add_source(src)

/obj/machinery/camera/ascent/Destroy()
	ascent_camera_network -= src
	return ..()