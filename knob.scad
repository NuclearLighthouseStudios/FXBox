design = true;
bed_center = [125, 105];

module knob()
{
	import("cad/knob.stl", convexity=3);
}

module pointer()
{
	translate([0,0,0.5*25.4-0.25])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -0.7/2.0*25.4, -0.7/2.0*25.4 ])
		import(file = "designs/knob-pointer.svg");
	}
}

module tower()
{
	difference()
	{
		cylinder(r=12,h=0.5*25.4-0.25);
		cylinder(r=11.5,h=0.6*25.4);
	}
}

module part()
{
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
}

translate(bed_center)
{
	if(design)
	{
		tower();
	}

	for ( x=[-1:1])
	{
		for ( y=[-1:1])
		{
			translate([x*75,y*75,0])
			part();
		}
	}
}
