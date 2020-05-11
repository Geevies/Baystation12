/datum/visualnet/ascentnet
	valid_source_types = list(/obj/machinery/camera/ascent, /mob/living/silicon/ai/ascent)
	chunk_type = /datum/chunk/ascentnet

/datum/chunk/ascentnet/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		for(var/turf/t in seen_turfs_in_range(source, world.view))
			visible[t] = t