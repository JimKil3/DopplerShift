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
/obj/item/organ/
