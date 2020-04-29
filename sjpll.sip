set_global_assignment -entity "sjpll" -library "lib_sjpll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "sjpll" -library "lib_sjpll" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "sjpll" -library "lib_sjpll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sjpll" -name SPD_FILE [file join $::quartus(sip_path) "sjpll.spd"]

set_global_assignment -library "lib_sjpll" -name MISC_FILE [file join $::quartus(sip_path) "sjpll_sim/sjpll.vo"]
