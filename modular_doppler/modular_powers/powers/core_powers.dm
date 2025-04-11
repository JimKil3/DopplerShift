// Sorcerous

/datum/power/prestidigitation
	name = "Prestidigitation"
	desc = "Various small-scale applications of Resonance with effects common to all Sorcerous paths to power."
	root_power = /datum/power/prestidigitation
	power_type = TRAIT_PATH_SORCEROUS
	is_accessible = FALSE

/datum/power/prestidigitation/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/prestidigitation(target.mind || target)
	new_action.Grant(target)

/datum/action/cooldown/prestidigitation
	name = "Prestidigitation"
	desc = "Apply your knowledge of the esoteric to mundane tasks."

	//todo: icon

	cooldown_time = 5 SECONDS

/datum/action/cooldown/prestidigitation/Activate()
	. = ..()
	var/choices = list(
		"Arcane Fire" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_attack"),
		"Cleansing Wave" = image(icon = 'icons/obj/watercloset.dmi', icon_state = "soap"),
		"Disrupt Light" = image(icon = 'icons/obj/lighting.dmi', icon_state = "lbulb")
	)
	var/selection = show_radial_menu(owner, owner, choices)
	switch(selection)
		if("Arcane Fire")
			var/obj/item/arcane_fire/fire = new /obj/item/arcane_fire
			if(!owner.put_in_hands(fire, TRUE))
				to_chat(owner, span_warning("You try to call forth arcane fire without somatic components, but fail."))
				return

			owner.visible_message(span_notice("[owner]'[owner.p_s()] fingers ignite with arcane fire."))

		if("Cleansing Wave")
			var/obj/item/to_clean = owner.get_active_held_item() || owner.get_inactive_held_item()

			if(!do_after(owner, 4 SECONDS, owner))
				to_chat(owner, span_warning("You lose focus on the cleansing incantation."))
				return

			if(!to_clean)
				owner.wash(CLEAN_WASH)
				owner.visible_message(span_notice("[owner] shimmers, grime vanishing off of them in a wave."), span_notice("You channel the cleansing energy over yourself."))
				return

			to_clean.wash(CLEAN_WASH)
			owner.visible_message(span_notice("Grime flakes off of [to_clean] as [owner] channels cleaning energy through it."), span_notice("You channel cleansing energy into [to_clean]."))

		if("Disrupt Light")
			//placeholder
			var/obj/item/arcane_fire/fire = new /obj/item/arcane_fire
			if(!owner.put_in_hands(fire, TRUE))
				to_chat(owner, span_warning("You try to call forth arcane fire without somatic components, but fail."))
				return

			owner.visible_message(span_notice("[owner]'[owner.p_s()] fingers ignite with arcane fire."))

/obj/item/arcane_fire
	name = "Arcane Fire"
	desc = "A tongue of flame fueled by Resonance. It dances harmlessly over your fingers."

	item_flags = DROPDEL | ABSTRACT | NOBLUDGEON

	light_range = 2
	light_power = 1.3
	light_color = LIGHT_COLOR_PURPLE

/obj/item/arcane_fire/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(interacting_with.loc == user || user.Adjacent(interacting_with))
		return ITEM_INTERACT_SUCCESS
	else
		var/obj/effect/particle_effect/sparks/spark = new /obj/effect/particle_effect/sparks
		GLOB.move_manager.move_towards(spark, interacting_with, timeout = 5)


/obj/item/arcane_fire/ignition_effect(atom/A, mob/user)
	return "[user]'[user.p_s()] conjured flame flares up as [user.p_they()] bring[user.p_s()] it close to [A], igniting it."

// Resonant

/datum/power/meditate
	name = "Meditate"
	desc = "ooughhh im meditating"
	is_accessible = FALSE
	power_type = TRAIT_PATH_SUBTYPE_PSYKER

/datum/power/meditate/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/spell/meditate(target.mind || target)
	new_action.Grant(target)

/datum/action/cooldown/spell/meditate
	name = "Meditate"
	desc = "This state of internal focus allows them to replenish any reserves they have and purge any impurities dredged up by abusing Nature's law."
	button_icon_state = "nose"

	school = SCHOOL_CONJURATION
	cooldown_time = 12 SECONDS
	cooldown_reduction_per_rank = 2.5 SECONDS
	spell_requirements = NONE

	invocation_type = INVOCATION_EMOTE

	invocation = "Someone starts meditating."
	invocation_self_message = "You start meditating"

// Mortal

/datum/power/tenacious
	name = "Tenacious"
	desc = "Try to remember some of the basics of CQC."
	is_accessible = FALSE
	power_traits = list(TRAIT_POWER_TENACIOUS)
