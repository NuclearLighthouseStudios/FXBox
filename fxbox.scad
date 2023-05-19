holes = "designs/holes-2-upper.svg";
front_design = "designs/vector/vector-front.svg";
back_design = "designs/vector/vector-back.svg";
box_base = "cad/fxbox-box.stl";
lid_base = "cad/fxbox-lid.stl";
design = false;
lid = false;

bed_center = [125, 105];
offset = 40;

module box()
{
	difference()
	{
		translate([0,0,1.1*25.4])
		scale([1,1,-1])
		import(box_base, convexity=3);
		
		translate([0,0,-0.1])
		linear_extrude(height = 25, center = false, convexity = 10)
		{
			translate([ -2.35/2.0*25.4, -4.0/2.0*25.4 ])
			import(file = holes);
		}
	}
}

module lid()
{
	translate([0,0,0.15*25.4])
	import(lid_base, convexity=3);
}

module back_graphics()
{
	translate([0,0,-0.1])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -2.35/2.0*25.4, -4.0/2.0*25.4 ])
		import(file = back_design);
	}
}

module front_graphics()
{
	translate([0,0,-0.1])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -2.35/2.0*25.4, -4.0/2.0*25.4 ])
		import(file = front_design);
	}
}


translate(bed_center)
if(lid)
{
	translate([-offset, 0, 0])
	if(design)
	{
		scale([-1,1,1])
		intersection()
		{
			back_graphics();
			lid();
		}
	}
	else
	{
		scale([-1,1,1])
		difference()
		{
			lid();
			back_graphics();
		}
	}
}
else
{
	translate([offset, 0, 0])
	if(design)
	{
		scale([-1,1,1])
		intersection()
		{
			front_graphics();
			box();
		}
	}
	else
	{
		scale([-1,1,1])
		difference()
		{
			box();
			front_graphics();
		}
	}
}
