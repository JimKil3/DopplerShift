/obj/item/augment_module/tool
	name = "tool module"

	/// How much space this tool takes up inside the core implant.
	var/complexity = 1
	/// The item this module gives when activated.
	var/tool_path = null

/obj/item/augment_module/tool/on_install()
	. = ..()
	var/obj/item/organ/cyberimp/core/arm/mounted = frame
	mounted.refresh_modules()
