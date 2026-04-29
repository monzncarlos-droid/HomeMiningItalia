// =======================
// PARAMETRI
// =======================
tube_diameter = 152;

// Tolleranze
tolerance = 0.5;          // per infilarsi sul tubo
filter_clearance = 0;   // spazio extra per il filtro - EDIT: TOLTO

// Spessori
wall_thickness = 3;
top_thickness  = 4;
lip_height     = 20;

// Foro centrale
hole_diameter = 142; // <-- MODIFICA QUI (più piccolo del tubo)

// Smusso interno per non tagliare il filtro
chamfer = 1.5;

$fn = 120;

// =======================
// CALCOLI
// =======================
inner_d = tube_diameter + 2*tolerance + filter_clearance;
outer_d = inner_d + 2*wall_thickness;

// =======================
// MODELLO
// =======================
difference() {
    union() {
        // top
        cylinder(d=outer_d, h=top_thickness);

        // parete esterna
        translate([0,0,-lip_height])
            cylinder(d=outer_d, h=lip_height);
    }

    // spazio interno (più largo per il filtro)
    translate([0,0,-lip_height])
        cylinder(d=inner_d, h=lip_height);

    // foro centrale
    translate([0,0,-1])
        cylinder(d=hole_diameter, h=top_thickness + 2);

    // piccolo smusso interno (anti-taglio filtro)
    translate([0,0,top_thickness - chamfer])
        cylinder(d1=hole_diameter, d2=hole_diameter + 3, h=chamfer);
}