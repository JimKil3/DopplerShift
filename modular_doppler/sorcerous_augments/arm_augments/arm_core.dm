// A substitute for the garbage that is a million bajillion different 'toolsets.'
// Instead, you construct a dynamic toolset with this mount and by printing each tool you want.

/obj/item/organ/cyberimp/core/arm
	name = "arm endoskeletal mount"
	desc = "A mounting point for various modules which extend from the arms."
	icon_state = "toolkit_generic"

	zone = BODY_ZONE_L_ARM
	slot = ORGAN_SLOT_LEFT_ARM_AUG
	accepted_types = list(/obj/item/augment_module/tool)
	actions_types = list(/datum/action/item_action/organ_action/toggle)

	/// Which arm this module is configured to mount to
	var/current_arm = "left"
	/// All the tools that this augment contains
	var/all_tools = list()
	/// Complexity is how much space a tool takes up in the arm.
	var/max_complexity = 10

/obj/item/organ/cyberimp/core/arm/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/augment_module/tool))
		var/obj/item/augment_module/tool/tool_module = attacking_item
		var/current_complexity = 0
		for(var/obj/item/augment_module/tool/module in contents)
			current_complexity += module.complexity
		if(tool_module.complexity + current_complexity > max_complexity)
			to_chat(user, span_warning("There's not enough space left in [src] to add [tool_module]!"))
			return

	return ..()

/obj/item/organ/cyberimp/core/arm/proc/refresh_modules()
	QDEL_LIST(all_tools)
	for(var/obj/item/augment_module/tool/module in contents)
		all_tools += new module.tool_path(src)
