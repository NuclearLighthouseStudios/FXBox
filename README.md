# FX Box

_A 3d printable enclosure for guitar pedals with a build system!_

This repository contains all the filed needed to generate the STL and gcode files for my guitar pedal enclosures.

## Building

Requirements:
* Prusa-Slicer
* openscad

To generate the STL and gcode files just call `make`. This will take a while.

Currently everything is set up to generate gcode for a prusa i3MK3S.
If you have a different printer you'll need to adjust the .ini files and the `bed_center` setting in the .scad files accordingly.


## Printing

All the enclosure parts get printed in two parts. One for the design and one for the main part.  
Print the design first, with one color of filament, and clean up the priming loop before changing filament and printing the main part of the model on top.

For the knobs just print the `knob.stl` file, it will automatically request a filament change for printing the pointers once all the knobs are printed.


## Assembly

1. Insert the heat-set inserts using a soldering iron set to around 200°C/390°F. Make sure they go in straight.
2. Place the effects PCB into the enclosure and fasten it using the 4 M3 PCB spacers.
3. Mount the foot switch into the enclosure using an appropriate spacer to make sure it lines up right if required.
4. Place the switchboard PCB into the enclosure using 3 spacers on each jack and lining it up with the foot switch.
5. Tighten the nuts on the jacks, make sure everything is seated tightly, and solder in the foot switch.
6. Place the lid onto the enclosure and fasten it in place using the 6 M3x10 bolts

### BOM

This is the additional hardware needed to assemble the enclosure.

| Quantity | Description        |
| -------: | :----------------- |
| 6        | M3 heat-set insert |
| 4        | M3 10mm PCB spacer |
| 6        | M3x10 bolt         |



## Adding a new pedal

Copy one of the existing designs and edit the main svg file to your liking.  
Afterwards save the "Back Graphics", "Front Graphics" and "Front Holes" layers as plain svg files.
Make sure the file only contains filled paths without strokes and no groups.
It's best to ungroup everything and use the "Object to path" and "Stroke to path" commands in inkscape.
Adjust the .mk file in the pedal directory to include the name of your design,
and the correct file names for the front, back and hole SVGs.

Once your design is ready run `make` to generate the STLs and gcode.