/datum/surgery/augment_manipulation
	name = "Augment Manipulation"
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_EYES
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/open_augment,
		/datum/surgery_step/manipulate_augment,
		/datum/surgery_step/open_augment/close,
		/datum/surgery_step/close
	)

/datum/surgery_step/open_augment
	name = "prepare augment (screwdriver)"
	implements = list(
		TOOL_SCREWDRIVER = 100,
		TOOL_SCALPEL = 75,
		/obj/item/knife = 50,
		/obj/item/coin = 10
	)
	time = 24
	preop_sound = 'sound/items/tools/screwdriver.ogg'
	success_sound = 'sound/items/tools/screwdriver2.ogg'

/datum/surgery_step/open_augment/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to screw [target]'[target.p_s()] wetware..."),
		span_notice("[user] begins to screw [target]'[target.p_s()] wetware."),
		span_notice("[user] begins to use a screwdriver on [target]."),
	)

/datum/surgery_step/open_augment/close
	name = "seal augment (screwdriver)"

/datum/surgery_step/manipulate_augment
	name = "manipulate augment modules (multitool / augment modules)"
	implements = list(
		TOOL_MULTITOOL = 100,
		/obj/item/augment_module = 100
	)
	repeatable = TRUE
	preop_sound = 'sound/items/tools/screwdriver.ogg'
	success_sound = 'sound/items/tools/crowbar.ogg'
	var/obj/item/organ/cyberimp/core/target_core_augment
	var/target_module
	var/current_type

/datum/surgery/augment_manipulation/can_start(mob/user, mob/living/patient)
	. = ..()
	if(user.zone_selected == BODY_ZONE_PRECISE_EYES)
		user.zone_selected= check_zone(user.zone_selected)
	var/obj/item/bodypart/target_part = patient.get_bodypart(user.zone_selected)
	for(var/obj/item/organ/cyberimp/core/augment in target_part.contents)
		return TRUE
	return FALSE

/datum/surgery_step/manipulate_augment/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)

	if(target_zone == BODY_ZONE_PRECISE_EYES)
		target_zone = check_zone(target_zone)

	var/obj/item/bodypart/target_part = target.get_bodypart(target_zone)
	var/available_modules = list()

	var/core_augments = list()
	for(var/obj/item/organ/cyberimp/core/augment in target_part.contents)
		core_augments += augment

	if(length(core_augments) > 1)
		target_core_augment = tgui_input_list(user, "Which augment are you modifying?", "Augment Selection", core_augments)
	else
		target_core_augment = core_augments[1]

	available_modules = target_core_augment.contents

	if(tool.tool_behaviour == TOOL_MULTITOOL)
		current_type = "removal"
		target_module = tgui_input_list(user, "What module do you want to remove?", "Module Removal", available_modules)
		display_results(
			user,
			target,
			span_notice("You begin to remove [target_module] from [target]'s [target_core_augment]..."),
			span_notice("[user] begins to remove [target_module] from [target]'s [target_core_augment]."),
			span_notice("[user] begins to remove something from [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
		)
		return

	else if(istype(tool, /obj/item/augment_module))
		if(!target_core_augment.can_install(tool))
			to_chat(user, span_warning("You can't mount [tool] to [target_core_augment]!"))
			return SURGERY_STEP_FAIL
		current_type = "addition"
		target_module = tool
		display_results(
			user,
			target,
			span_notice("You begin to connect [target_module] to [target]'s [target_core_augment]..."),
			span_notice("[user] begins to connect [target_module] to [target]'s [target_core_augment]."),
			span_notice("[user] begins to put something in [target]'s [target.parse_zone_with_bodypart(target_zone)]."),
		)
		return

/datum/surgery_step/manipulate_augment/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(current_type == "removal")
		target_core_augment.remove_module(target_module, user)
		display_results(
			user,
			target,
			span_notice("You remove [target_module] from [target]'s [target_core_augment]."),
			span_notice("[user] removes [target_module] from [target]'s [target_core_augment]!"),
			span_notice("[user] removes something from [target]'s [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		return
	else
		target_core_augment.install_module(target_module)
		display_results(
			user,
			target,
			span_notice("You connect [target_module] to [target]'s [target_core_augment]."),
			span_notice("[user] connects [target_module] to [target]'s [target_core_augment]!"),
			span_notice("[user] puts something in [target]'s [target.parse_zone_with_bodypart(target_zone)]!"),
		)
		return
