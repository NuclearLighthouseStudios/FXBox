.SUFFIXES:
.SECONDARY:

slicer = prusa-slicer

stl_base_dir = ./stl/
gcode_base_dir = ./gcode/

all: knobs boxes

.PHONY: knobs
.PHONY: boxes

include $(wildcard designs/*/*.mk)
include $(wildcard designs/knobs/*/*.mk)


$(stl_base_dir)%/box-design.stl:
	openscad -o $@  -D "box_base=\"$(word 2,$^)\"" -D "front_design=\"$(word 3,$^)\"" -D "holes=\"$(word 4,$^)\"" -D "design=true" -D "lid=false" $<

$(stl_base_dir)%/box-main.stl:
	openscad -o $@  -D "box_base=\"$(word 2,$^)\"" -D "front_design=\"$(word 3,$^)\"" -D "holes=\"$(word 4,$^)\"" -D "design=false" -D "lid=false" $<

$(stl_base_dir)%/lid-design.stl:
	openscad -o $@  -D "lid_base=\"$(word 2,$^)\"" -D "back_design=\"$(word 3,$^)\"" -D "design=true" -D "lid=true" $<

$(stl_base_dir)%/lid-main.stl:
	openscad -o $@  -D "lid_base=\"$(word 2,$^)\"" -D "back_design=\"$(word 3,$^)\"" -D "design=false" -D "lid=true" $<


$(gcode_base_dir)%-main.gcode: $(stl_base_dir)%-main.stl configs/fxbox-main.ini
	$(slicer) -g --load configs/fxbox-main.ini --dont-arrange -o $@ $<

$(gcode_base_dir)%-design.gcode: $(stl_base_dir)%-design.stl configs/fxbox-design.ini
	$(slicer) -g --load configs/fxbox-design.ini --dont-arrange -o $@ $<



$(stl_base_dir)%/knob-body.stl:
	openscad -o $@ -D "base=\"$(word 2,$^)\"" -D "design=\"$(word 3,$^)\"" -D "pointer=false" $<

$(stl_base_dir)%/knob-pointer.stl:
	openscad -o $@ -D "base=\"$(word 2,$^)\"" -D "design=\"$(word 3,$^)\"" -D "pointer=true" $<


$(gcode_base_dir)%/knob.gcode: $(gcode_base_dir)%/knob-body.gcode $(gcode_base_dir)%/knob-pointer.gcode
	awk 'f==0{print}; /;KNOB-END/{f=1}' $(word 1,$^) > $@
	awk 'f==1{print}; /;AFTER_LAYER_CHANGE/{f=1}' $(word 2,$^) >> $@

$(gcode_base_dir)%/knob-body.gcode: $(stl_base_dir)%/knob-body.stl configs/knob.ini
	$(slicer) -g --load configs/knob.ini --dont-arrange --split --end-filament-gcode '"M600\n;KNOB-END"' -o $@ $<

$(gcode_base_dir)%/knob-pointer.gcode: $(stl_base_dir)%/knob-pointer.stl configs/fxbox-design.ini
	$(slicer) -g --load configs/fxbox-design.ini --dont-arrange --skirts 0 -o $@ $<


.PHONY: clean
clean:
	-rm -rf $(stl_base_dir) $(gcode_base_dir)
