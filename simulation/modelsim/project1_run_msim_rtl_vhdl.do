transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Users/idn09/Documents/ECE 387/Project 1/project1.vhd}
vcom -2008 -work work {C:/Users/idn09/Documents/ECE 387/Project 1/clockDivider.vhd}
vcom -2008 -work work {C:/Users/idn09/Documents/ECE 387/Project 1/adcReader.vhd}
vcom -2008 -work work {C:/Users/idn09/Documents/ECE 387/Project 1/eepromWrite.vhd}
vcom -2008 -work work {C:/Users/idn09/Documents/ECE 387/Project 1/reg8by64.vhd}

