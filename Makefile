.SUFFIXES:
.SECONDARY:

slicer=prusa-slicer

boxes=$(patsubst designs/%/,%,$(wildcard designs/*/))

all: $(boxes:%=gcode/%-box-design.gcode)
all: $(boxes:%=gcode/%-box-main.gcode)
all: $(boxes:%=gcode/%-lid-design.gcode)
all: $(boxes:%=gcode/%-lid-main.gcode)

all: gcode/knob.gcode


stl/knob-main.stl: knob.scad cad/knob.stl designs/knob-pointer.svg
	openscad -o $@ -D "design=false" $<

stl/knob-design.stl: knob.scad cad/knob.stl designs/knob-pointer.svg
	openscad -o $@ -D "design=true" $<


gcode/knob.gcode: gcode/knob-main.gcode gcode/knob-design.gcode
	awk 'f==0{print}; /;KNOB-END/{f=1}' gcode/knob-main.gcode > $@
	awk 'f==1{print}; /;12.6/{f=1}' gcode/knob-design.gcode >> $@

gcode/knob-main.gcode: stl/knob-main.stl knob.ini
	$(slicer) -g --load knob.ini --dont-arrange --split --end-filament-gcode '"M600\n;KNOB-END"' -o $@ $<

gcode/knob-design.gcode: stl/knob-design.stl fxbox-design.ini
	$(slicer) -g --load fxbox-design.ini --dont-arrange -o $@ $<



gcode/%-main.gcode: stl/%-main.stl fxbox-main.ini
	$(slicer) -g --load fxbox-main.ini --dont-arrange -o $@ $<

gcode/%-design.gcode: stl/%-design.stl fxbox-design.ini
	$(slicer) -g --load fxbox-design.ini --dont-arrange -o $@ $<


stl/%-box-design.stl: fxbox.scad cad/fxbox-box.stl designs/%/front.svg designs/%/holes.svg
	openscad -o $@ -D "design_file=\"designs/$*/front.svg\"" -D "holes_file=\"designs/$*/holes.svg\"" -D "design=true" -D "lid=false" $<

stl/%-box-main.stl: fxbox.scad cad/fxbox-box.stl designs/%/front.svg designs/%/holes.svg
	openscad -o $@ -D "design_file=\"designs/$*/front.svg\"" -D "holes_file=\"designs/$*/holes.svg\"" -D "design=false" -D "lid=false" $<

stl/%-lid-design.stl: fxbox.scad cad/fxbox-lid.stl designs/%/back.svg
	openscad -o $@ -D "design_file=\"designs/$*/back.svg\"" -D "design=true" -D "lid=true" $<

stl/%-lid-main.stl: fxbox.scad cad/fxbox-lid.stl designs/%/back.svg
	openscad -o $@ -D "design_file=\"designs/$*/back.svg\"" -D "design=false" -D "lid=true" $<


.PHONY: clean
clean:
	rm -f gcode/*.gcode stl/*.stl
