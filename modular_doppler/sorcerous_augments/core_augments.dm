/obj/item/organ/cyberimp/core
	name = "core augment"
	desc = "you shouldn't be seeing this!"

	icon_state = "heart-c-off"

	/// A list of module paths which this core augment accepts.
	var/accepted_types = list()

/obj/item/organ/cyberimp/core/examine(mob/user)
	. = ..()
	. += span_notice("It has " + english_list(contents) + " installed.")

/obj/item/organ/cyberimp/core/attackby(obj/item/attacking_item, mob/user, params)
	if(!istype(attacking_item, /obj/item/augment_module))
		return ..()

	if(!can_install(attacking_item))
		to_chat(user, span_warning("You can't install [attacking_item] into this type of augment!"))
		return

	install_module(attacking_item)
	to_chat(user, span_notice("You insert [attacking_item] into [src]."))

/obj/item/organ/cyberimp/core/attack_self(mob/user, modifiers)
	. = ..()
	if(!contents)
		return

	if(length(contents) == 1)
		to_chat(user, span_notice("You remove [contents[1]] from [src]."))
		remove_module(contents[1], user)
		return

	var/choice = tgui_input_list(user, "What module do you want to remove?", "Module Removal", contents)
	remove_module(choice, user)
	to_chat(user, span_notice("You remove [choice] from [src]."))

/obj/item/organ/cyberimp/core/proc/can_install(obj/item/augment_module/potential_augment)
	return is_type_in_list(potential_augment, accepted_types)

/obj/item/organ/cyberimp/core/proc/install_module(obj/item/augment_module/new_augment)
	new_augment.forceMove(src)
	new_augment.frame = src
	new_augment.on_install()

/obj/item/organ/cyberimp/core/proc/remove_module(obj/item/augment_module/removed_augment, mob/living/carbon/remover)
	removed_augment.on_remove()
	remover.put_in_hands(removed_augment)

/obj/item/organ/cyberimp/core/arm
	name = "arm endoskeletal mount"
	desc = "A mounting point for various modules which extend from or make changes to the arms."
	icon_state = "toolkit_generic"

	zone = BODY_ZONE_L_ARM
	slot = ORGAN_SLOT_LEFT_ARM_AUG
	accepted_types = list(/obj/item/augment_module/tool)

	/// Which arm this module is configured to mount to
	var/current_arm = "left"
	/// All the tool modules that this augment contains
	var/all_tools = list()
