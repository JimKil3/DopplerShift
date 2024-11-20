/obj/item/organ/cyberimp/core
	name = "core augment"
	desc = "you shouldn't be seeing this!"

	icon_state = "heart-c-off"

/obj/item/organ/cyberimp/core/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/augment_module))
		install_module(attacking_item)
		to_chat(user, span_notice("You insert [attacking_item] into [src]."))

/obj/item/organ/cyberimp/core/attack_self(mob/user, modifiers)
	. = ..()
	if(!contents)
		return

	if(length(contents) == 1)
		remove_module(contents[1], user)
		to_chat(user, span_notice("You remove [contents[1]] from [src]."))
		return

	var/choice = tgui_input_list(user, "What module do you want to remove?", "Module Removal", contents)
	remove_module(choice, user)
	to_chat(user, span_notice("You remove [choice] from [src]."))

/obj/item/organ/cyberimp/core/proc/install_module(obj/item/augment_module/new_augment)
	new_augment.forceMove(src)
	new_augment.frame = src

/obj/item/organ/cyberimp/core/proc/remove_module(obj/item/augment_module/removed_augment, mob/living/carbon/remover)
	remover.put_in_hands(removed_augment)
