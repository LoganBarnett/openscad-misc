bodyString = "Shed";
thickness = 2.5;
bodyWidth = 50;
bodySize = [bodyWidth, bodyWidth, thickness ];

module keychainLoop() {
  difference() {
    cylinder(d=10, h = thickness, center=true);
    cylinder(d=5, h = thickness + 0.2, center=true);
  }
}

module bodyText() {
  linear_extrude(thickness / 3.0) {
    text(text=bodyString, halign = "center", valign = "center");
  }
}

module body() {
  difference() {
    cube(bodySize, center=true);
    translate([0, 0, thickness / 3.0 / 2.0 + 0.1]) {
      bodyText();
    }
    translate([0, 0, -(thickness / 2) - 0.1]) {
      rotate([0, 0, 0])
        scale([-1, 1, 1])
        bodyText();
    }
  }
}

body();
translate([27, 27, 0])
color("red")
  keychainLoop();
