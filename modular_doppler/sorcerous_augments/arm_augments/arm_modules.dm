/obj/item/augment_module/tool
	name = "tool module"

	/// How much space this tool takes up inside the core implant.
	var/complexity = 1
	/// The item this module gives when activated.
	var/tool_path = null

/obj/item/augment_module/tool/on_install()
	var/obj/item/organ/cyberimp/core/arm/mounted = frame
	mounted.refresh_modules()

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	RegisterSignals(src, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_ATTACK_SELF_SECONDARY), PROC_REF(undeploy))

/obj/item/augment_module/tool/on_remove()
	var/obj/item/organ/cyberimp/core/arm/mounted = frame
	mounted.refresh_modules()

	resistance_flags = null
	REMOVE_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	UnregisterSignal(src, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(src, COMSIG_ITEM_ATTACK_SELF_SECONDARY)

/obj/item/augment_module/tool/proc/deploy()
	var/obj/item/organ/cyberimp/core/arm/mounted = frame
	if(mounted.current_arm == "left")
		owner.put_in_l_hand(src)
	else
		owner.put_in_r_hand(src)

/obj/item/augment_module/tool/proc/undeploy()
	forceMove(frame)

/obj/item/augment_module/tool/screwdriver
	name = "integrated screwdriver"
	desc = "A screwdriver mounted inside the arm."

	tool_behaviour = TOOL_SCREWDRIVER
	toolspeed = 0.8
