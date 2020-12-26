holes_file = "designs/vector/holes.svg";
design_file = "designs/vector/front.svg";
design = true;
lid = false;

/*[Hidden]*/
alignment_size = 0.1;

module box()
{	
	difference()
	{
		
		translate([0,0,1.1*25.4])
		scale([1,1,-1])
		import("cad/fxbox-box.stl", convexity=3);

		translate([0,0,-0.1])
		linear_extrude(height = 25, center = false, convexity = 10)
		{
			translate([ -2.35/2.0*25.4, -4.0/2.0*25.4 ])
			import(file = holes_file);
		}
	}
}

module lid()
{	
	translate([0,0,0.15*25.4])
	import("cad/fxbox-lid.stl", convexity=3);
}

module back_graphics()
{
	translate([0,0,-0.1])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -2.35/2.0*25.4, -4.0/2.0*25.4 ])
		import(file = design_file);
	}
}

module front_graphics()
{
	translate([0,0,-0.1])
	color([0.25,0.25,0.25])
	linear_extrude(height = 0.3, center = false, convexity = 25)
	{
		translate([ -2.35/2.0*25.4, -4.0/2.0*25.4 ])
		import(file = design_file);
	}
}

module alignment()
{
	translate([-30,-50])
	cylinder(r=alignment_size,h=0.1,center=true);

	translate([30,-50])
	cylinder(r=alignment_size,h=0.1,center=true);

	translate([-30,50])
	cylinder(r=alignment_size,h=0.1,center=true);

	translate([30,50])
	cylinder(r=alignment_size,h=0.1,center=true);
}

if(lid)
{
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

alignment();