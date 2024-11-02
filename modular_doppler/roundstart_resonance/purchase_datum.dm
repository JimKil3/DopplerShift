/datum/resonant_purchase
	var/name = "default purchase"
	var/desc = "you shouldn't see this!"

	/// How many skill points (SP) this ability costs to purchase.
	var/cost
	/// Which category this ability falls under: For example, ROOT_PSYKER, ADVANCED_WARFIGHTER, and BASIC_THAUMATURGE.
	var/category
	/// What ability purchasing this actually grants.
	var/datum/resonant_ability/linked_ability

	/// Which other abilities, if any, the user needs before purchasing the ability.
	var/list/prerequisite_skills = list()

	/// Which abilities, if any, are mutually exclusive with this one: I.E., you cannot have this ability and any of the abilities it is exclusive with.
	var/list/mutually_exclusive_skills = list()

/datum/resonant_purchase/proc/on_purchase(mob/living/carbon/human/user)
	linked_ability.grant(user)
