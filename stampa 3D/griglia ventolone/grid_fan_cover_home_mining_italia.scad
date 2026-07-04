// =========================================================================
// 200mm Grid Fan Cover for Home Mining Italia Community
//
// Author: Marco Mancino (https://github.com/markoceri)
// =========================================================================

// Structural Parameters
//------------------------------------------
// The grid starts from here
inner_radius = 100;
// Outer edge (frame) thickness
collar_thickness = 4.0;
// This is the height of the grid along the Z-axis
grid_height = 3.0;
// This is the height of the outer edge along the Z-axis
collar_height = 25.0;

// Grid hexagon size. Smaller values ​​create smaller hexagons and a denser grid.
// Larger values ​​create a less dense grid that allows more air to pass through.
grid_exegonal_dimension = 20; 
grid_wall_thickness = 1.6;
//------------------------------------------


// Logo Parameters
//------------------------------------------
// Diameter of the central plate (if set to 0, the grid will not have a logo)
central_plate_diameter = 60;
// This is the size of the logo relative to the central plate
logo_percentual = 50;
// This is the height of the logo along the Z-axis.
// Positive values ​​create a raised logo, while negative values ​​create a recessed logo.
logo_height = -0.3;
//------------------------------------------


// Useful vars
total_diameter = (inner_radius + collar_thickness) * 2;
r_empty = (grid_exegonal_dimension / 2) / cos(30); 
r_full = r_empty + (grid_wall_thickness / (2 * cos(30)));
step_x = r_full * cos(30) * 2;
step_y = r_full * 1.5;

$fn = 120;

module hexagon(r) {
    polygon([for(i=[0:5]) [r * cos(i*60 + 30), r * sin(i*60 + 30)]]);
}

module infinite_hexagonal_pattern() {
    for (x = [-10 : 10]) {
        for (y = [-10 : 10]) {
            offset = (y % 2 == 0) ? 0 : step_x / 2;
            translate([x * step_x + offset, y * step_y]) hexagon(r_empty);
        }
    }
}

module logo_home_mining_italia_2d(percentual, max_diameter) {
    lato = (percentual / 100) * max_diameter;
    w = lato; h = lato * 1.45; th = (lato / 66) * 6.0;
    module merge(p1, p2) { hull() { translate(p1) circle(d=th, $fn=24); translate(p2) circle(d=th, $fn=24); } }
    
    top_l = [-w/2+th/2, h/2-th/2]; bot_l = [-w/2+th/2, -h/2+th/2];
    top_r = [w/2-th/2, h/2-th/2]; bot_r = [w/2-th/2, -h/2+th/2];
    mid_l = [-w/2+th/2, h/4]; mid_r = [w/2-th/2, h/4];
    m_mid = [0, -h/6]; bot_c = [0, -h/2+th/2];

    merge(top_l, bot_l); merge(top_r, bot_r); merge(mid_l, mid_r);
    merge(mid_l, m_mid); merge(mid_r, m_mid); merge(bot_c, [0, h/8]);
}

module base_body() {
    union() {
        // Outer edge (frame)
        difference() {
            cylinder(h=collar_height, r=total_diameter/2);
            translate([0, 0, -1]) 
                cylinder(h=collar_height + 2, r=inner_radius);
        }
        // Grid
        linear_extrude(height=grid_height) {
            difference() {
                circle(r=inner_radius);
                circle(r=central_plate_diameter/2);
                infinite_hexagonal_pattern();
            }
        }
        // Central Plate
        cylinder(h=grid_height, r=central_plate_diameter/2);
    }
}

// Union grid and frame
union() {
    if (logo_height >= 0) {
        union() {
            base_body();
            translate([0, 0, -logo_height]) 
                linear_extrude(height=logo_height) 
                    logo_home_mining_italia_2d(logo_percentual, central_plate_diameter);
        }
    } else {
        difference() {
            base_body();
            linear_extrude(height=abs(logo_height) + 0.01) 
                logo_home_mining_italia_2d(logo_percentual, central_plate_diameter);
        }
    }
}