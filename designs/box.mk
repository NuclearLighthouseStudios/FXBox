curr_file := $(word $(words $(MAKEFILE_LIST)), x $(MAKEFILE_LIST))
curr_dir := $(dir $(curr_file))

back := $(curr_dir)$(back)
front := $(curr_dir)$(front)
holes := $(curr_dir)$(holes)

ifeq ($(dsp),true)
	base_box := fxbox-box-dsp.stl
	base_lid := fxbox-lid-dsp.stl
else
	base_box := fxbox-box.stl
	base_lid := fxbox-lid.stl
endif

stl_dir := $(stl_base_dir)$(name)
gcode_dir := $(gcode_base_dir)$(name)

$(stl_dir):
	mkdir -p $@

$(gcode_dir):
	mkdir -p $@

$(stl_dir)/box-design.stl: fxbox.scad cad/$(base_box) $(front) $(holes) | $(stl_dir)
$(stl_dir)/box-main.stl: fxbox.scad cad/$(base_box) $(front) $(holes) | $(stl_dir)
$(stl_dir)/lid-design.stl: fxbox.scad cad/$(base_lid) $(back) | $(stl_dir)
$(stl_dir)/lid-main.stl: fxbox.scad cad/$(base_lid) $(back) | $(stl_dir)

boxes: | $(gcode_dir)
boxes: $(gcode_dir)/box-design.gcode $(gcode_dir)/box-main.gcode
boxes: $(gcode_dir)/lid-design.gcode $(gcode_dir)/lid-main.gcode