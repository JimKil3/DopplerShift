// A substitute for the garbage that is a million bajillion different 'toolsets.'
// Instead, you construct a dynamic toolset with this mount and by printing each tool you want.

/obj/item/organ/cyberimp/core/arm
	name = "arm endoskeletal mount"
	desc = "A mounting point for various modules which extend from the arms."
	icon_state = "toolkit_generic"

	zone = BODY_ZONE_L_ARM
	slot = ORGAN_SLOT_LEFT_ARM_AUG
	accepted_types = list(/obj/item/augment_module/tool)
	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)

	/// Which arm this module is configured to mount to
	var/current_arm = "left"
	/// A list of all the modules we have (because contents changes order).
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
	all_tools = list()
	for(var/obj/item/augment_module/tool/module in contents)
		all_tools += module

/obj/item/organ/cyberimp/core/arm/ui_action_click()
	if((organ_flags & ORGAN_FAILING) ||  !length(contents))
		to_chat(owner, span_warning("The implant doesn't respond. It seems to be broken..."))
		return

	if(length(all_tools) == 1)
		var/obj/item/augment_module/tool/active_tool = all_tools[1]
		active_tool.deploy()
