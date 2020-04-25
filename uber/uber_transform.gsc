transform(modelName, range, position, angles) {
    if(!isDefined(range)) {
        range = "150";
    }
    if(!isDefined(position)) {
        position = (0, 0, 0);
    }
    if(!isDefined(angles)) {
        angles = (0, 0, 0);
    }
    self setclientcvar("cg_thirdPerson", "1");
    self setclientcvar("cg_thirdPersonRange", range);
    model = spawn("script_model", (self.origin + position));
    model setmodel(modelName);
    model.angles = (self.angles + angles);
    model linkto(self);
    self hide();
    self setModel("");
    self iprintln("^2Press USE button to unhide yourself");

    while (1) {
        wait(0.05);

        if (self UseButtonPressed()) {
          self setclientcvar("cg_thirdPerson", "0");
          model delete();
          self iprintln("^1Now you're unhidden");
          self show();
          uber\uber::hidden();
          return (0);
        }
        if (self.health <= 0) {
          self setclientcvar("cg_thirdPerson", "0");
          model delete();
          self show();
          uber\uber::hidden();
          return (0);
        }
    }
}