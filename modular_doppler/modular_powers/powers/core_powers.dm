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

	cooldown_time = 10 SECONDS

/datum/action/cooldown/prestidigitation/Activate()
	. = ..()

	if(owner.has_status_effect(/datum/status_effect/anchored))
		to_chat(owner, span_warning("Something is preventing you from manipulating Resonance!"))
		return

	var/choices = list(
		"Arcane Fire" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_charge"),
		"Cleansing Wave" = image(icon = 'icons/obj/watercloset.dmi', icon_state = "soap"),
		"Disrupt Lights" = image(icon = 'icons/obj/lighting.dmi', icon_state = "lbulb")
	)
	var/selection = show_radial_menu(owner, owner, choices)
	switch(selection)
		if("Arcane Fire")
			var/obj/item/arcane_fire/fire = new /obj/item/arcane_fire
			if(!owner.put_in_hands(fire, TRUE))
				to_chat(owner, span_warning("You try to call forth arcane fire without somatic components, but fail."))
				return

			owner.visible_message(span_notice("[owner] snaps [owner.p_their()] fingers, arcane fire sparking to life over [owner.p_their()] hand."), span_notice("You snap your fingers and summon arcane fire to your hand."))

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

		if("Disrupt Lights")
			if(!do_after(owner, 4 SECONDS))
				to_chat(owner, span_warning("You lose focus on the disruptive incantation."))
				return

			owner.visible_message(span_warning("[owner] claps their hands together, the noise echoing strangely!"), span_notice("You charge your hands with Resonant energies and clap."))

			for(var/obj/machinery/light/light in view(3, owner))
				light.flicker()


/obj/item/arcane_fire
	name = "Arcane Fire"
	desc = "A tongue of flame fueled by Resonance. It dances harmlessly over your fingers."

	item_flags = DROPDEL | ABSTRACT | NOBLUDGEON

	light_range = 2
	light_power = 1.3
	light_color = LIGHT_COLOR_PURPLE

/obj/item/arcane_fire/dropped(mob/user, silent)
	if(!silent)
		user.visible_message(span_notice("[user]'[user.p_s()] arcane flame gutters out."), span_notice("You cut the flow of Resonance to the flame."))
	return ..()

/obj/item/arcane_fire/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/obj/effect/particle_effect/sparks/spark = new /obj/effect/particle_effect/sparks(user.loc)
	GLOB.move_manager.move_towards(spark, interacting_with, timeout = 5)
	user.visible_message(span_warning("[user] waves [user.p_their()] hand, arcane flame leaping out in a wave of sparks!"))
	qdel(src)
	return ITEM_INTERACT_SUCCESS


/obj/item/arcane_fire/ignition_effect(atom/A, mob/user)
	return span_notice("[user]'[user.p_s()] conjured flame flares up as [user.p_they()] bring[user.p_s()] it close to [A], igniting it.")

// Resonant

/datum/power/meditate
	name = "Meditation"
	desc = "A mental exercise commonly used by Resonant individuals to center themselves and clear both their bodies and minds."
	is_accessible = FALSE
	power_type = TRAIT_PATH_RESONANT

/datum/power/meditate/add(mob/living/carbon/human/target)
	var/datum/action/new_action = new /datum/action/cooldown/meditate(target.mind || target)
	new_action.Grant(target)

/datum/action/cooldown/meditate
	name = "Meditate"
	desc = "Enter a meditative state, clearing your mind and purging any impurities dredged up by your Resonant nature."

	//todo: icon

	cooldown_time = 30 SECONDS

/datum/action/cooldown/meditate/Activate()
	. = ..()

	owner.visible_message(span_notice("[owner] sits down and closes [owner.p_their()] eyes."), span_notice("You sit and turn your attention inwards."))

	while(TRUE)
		var/mob/living/living_owner = owner
		if(!istype(living_owner)) //I don't think this can happen but whatever
			return

		if(owner.has_status_effect(/datum/status_effect/anchored))
			to_chat(owner, span_warning("You cannot meditate under these oppressive conditions!"))
			living_owner.cure_blind(MEDITATION)
			break

		if(!do_after(owner, 6 SECONDS, owner))
			to_chat(owner, span_warning("You lose focus and break out of the meditative state."))
			living_owner.cure_blind(MEDITATION)
			break

		if(!living_owner.is_blind_from(MEDITATION))
			living_owner.become_blind(MEDITATION)

		//esper / cultivator code goes here

		var/negative_event_categories = list()
		for(var/category in living_owner.mob_mood.mood_events)
			var/datum/mood_event/event = living_owner.mob_mood.mood_events[category]
			if(event.mood_change < 0)
				negative_event_categories += category

		if(length(negative_event_categories))
			var/to_remove = pick(negative_event_categories)
			to_chat(owner, span_nicegreen("Your mind feels lighter."))
			living_owner.mob_mood.clear_mood_event(to_remove)

// Mortal

/datum/power/tenacious
	name = "Tenacious"
	desc = "Without the crutch of Resonance, mundane individuals are forced to persevere."
	is_accessible = FALSE
	power_type = TRAIT_PATH_MORTAL
	power_traits = list(TRAIT_POWER_TENACIOUS)

/datum/movespeed_modifier/tenacious_carbon_softcrit
	multiplicative_slowdown = 1.5
	flags = IGNORE_NOSLOW
