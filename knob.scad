design = "designs/knobs/plain/plain-pointer.svg";
base = "cad/knob.stl";
pointer = false;

bed_center = [125, 105];

module knob()
{
	import(base, convexity=3);
}

module pointer()
{
	translate([0,0,0.5*25.4-0.25])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -0.7/2.0*25.4, -0.7/2.0*25.4 ])
		import(file = design);
	}
}

module part()
{
	if(pointer)
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
	if(pointer)
	{
		cylinder(r=0.1,h=0.1);
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
