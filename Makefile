.SUFFIXES:
.SECONDARY:

boxes=$(patsubst designs/%/,%,$(wildcard designs/*/))

all: $(boxes:%=gcode/%-box-design.gcode)
all: $(boxes:%=gcode/%-box-main.gcode)
all: $(boxes:%=gcode/%-lid-design.gcode)
all: $(boxes:%=gcode/%-lid-main.gcode)


all: stl/knob-main.stl stl/knob-design.stl

stl/knob-main.stl: knob.scad designs/knob-pointer.svg
	openscad -o $@ -D "design=false" $<

stl/knob-design.stl: knob.scad designs/knob-pointer.svg
	openscad -o $@ -D "design=true" $<


gcode/%-main.gcode: stl/%-main.stl fxbox-main.ini
	prusa-slicer -g --load fxbox-main.ini -o $@ $<

gcode/%-design.gcode: stl/%-design.stl fxbox-design.ini
	prusa-slicer -g --load fxbox-design.ini -o $@ $<


stl/%-box-design.stl: fxbox.scad designs/%/front.svg designs/%/holes.svg
	openscad -o $@ -D "design_file=\"designs/$*/front.svg\"" -D "holes_file=\"designs/$*/holes.svg\"" -D "design=true" -D "lid=false" $<

stl/%-box-main.stl: fxbox.scad designs/%/front.svg designs/%/holes.svg
	openscad -o $@ -D "design_file=\"designs/$*/front.svg\"" -D "holes_file=\"designs/$*/holes.svg\"" -D "design=false" -D "lid=false" $<

stl/%-lid-design.stl: fxbox.scad designs/%/back.svg
	openscad -o $@ -D "design_file=\"designs/$*/back.svg\"" -D "design=true" -D "lid=true" $<

stl/%-lid-main.stl: fxbox.scad designs/%/back.svg
	openscad -o $@ -D "design_file=\"designs/$*/back.svg\"" -D "design=false" -D "lid=true" $<


.PHONY: clean
clean:
	rm -f gcode/*.gcode stl/*.stl