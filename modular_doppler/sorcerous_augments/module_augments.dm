/obj/item/augment_module
	name = "augment module"
	desc = "you shouldn't be seeing this!"

	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver_map"

	/// The frame this module is in.
	var/obj/item/organ/cyberimp/core/frame
	/// The mob this module is installed in.
	var/mob/living/carbon/human/owner

/obj/item/augment_module/proc/on_install()
	return

/obj/item/augment_module/proc/on_remove()
	return

/obj/item/augment_module/tool
	name = "tool module"
	var/tool_type
