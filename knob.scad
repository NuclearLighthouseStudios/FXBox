design = true;

/*[Hidden]*/
alignment_size = 0.1;

module knob()
{	
	translate([0,0,0.5*25.4])
	scale([1,1,-1])
	import("cad/knob.stl", convexity=3);
}

module pointer()
{
	translate([0,0,-0.1])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -0.7/2.0*25.4, -0.7/2.0*25.4 ])
		import(file = "designs/knob-pointer.svg");
	}
}

module alignment()
{
	translate([-15,-15])
	cylinder(r=alignment_size,h=0.1,center=true);

	translate([15,-15])
	cylinder(r=alignment_size,h=0.1,center=true);

	translate([-15,15])
	cylinder(r=alignment_size,h=0.1,center=true);

	translate([15,15])
	cylinder(r=alignment_size,h=0.1,center=true);
}

if(design)
{
	scale([-1,1,1])
	intersection()
	{
		pointer();
		knob();
	}
}
else
{
	scale([-1,1,1])
	difference()
	{
		knob();
		pointer();
	}
}

alignment();