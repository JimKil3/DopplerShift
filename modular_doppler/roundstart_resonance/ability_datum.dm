/datum/resonant_ability
	var/name = "default ability"
	var/desc = "you shouldn't be seeing this!"

/datum/resonant_ability/proc/grant(mob/living/carbon/human/user)
	return

// Generic abilities which just give the user an action button that does something

/datum/action/resonant
	name = "default generic spell"
	desc = "you shouldn't see this!"

/datum/resonant_ability/generic_spell
	/// Which spell to grant on grant()
	var/datum/action/resonant/spell_to_grant

/datum/resonant_ability/generic_spell/grant(mob/living/carbon/human/user)
	if(!istype(spell_to_grant))
		CRASH("Generic spell datum attempted to grant something other than an action")
	spell_to_grant.New(user)

// Abilities which give an organ to the user
/datum/resonant_ability/organ_granter
	var/organ_to_grant

/datum/resonant_ability/organ_granter/grant(mob/living/carbon/human/user)
	var/obj/item/organ/granted = new(organ_to_grant)
	granted.Insert(user, TRUE, DELETE_IF_REPLACED)

// Abilities which give the user an item
/datum/resonant_ability/item_granter
	var/item_to_grant

/datum/resonant_ability/item_granter/grant(mob/living/carbon/human/user)
	var/obj/item/granted = new(user.loc)
	if(isitem(granted) && istype(user))
		var/obj/item/backpack = user.back
		if(istype(backpack) && backpack?.atom_storage.attempt_insert(granted))
			to_chat(user, span_notice("Your [granted.name] is in [backpack.name], right where it should be."))
			return
		if(user.put_in_hands(granted))
			to_chat(user, span_notice("You're holding your [granted.name]."))
			return
		to_chat(user, span_warning("Your [granted.name] is on the floor! Better pick that up.."))
