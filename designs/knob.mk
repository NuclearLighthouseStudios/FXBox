curr_file := $(word $(words $(MAKEFILE_LIST)), x $(MAKEFILE_LIST))
curr_dir := $(dir $(curr_file))

pointer := $(curr_dir)$(pointer)

stl_dir := $(stl_base_dir)knobs/$(name)
gcode_dir := $(gcode_base_dir)knobs/$(name)

$(stl_dir):
	mkdir -p $@

$(gcode_dir):
	mkdir -p $@

$(stl_dir)/knob-body.stl: knob.scad $(base) $(pointer) | $(stl_dir)
$(stl_dir)/knob-pointer.stl: knob.scad $(base) $(pointer) | $(stl_dir)

knobs: | $(gcode_dir)
knobs: $(gcode_dir)/knob.gcode