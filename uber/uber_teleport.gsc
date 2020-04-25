teleport() {
    startOrigin = self getEye() + (0, 0, 18);
    forward = anglesToForward(self getplayerangles());
    forward = maps\mp\_utility::vectorScale(forward, 100000);
    endOrigin = startOrigin + forward;

    trace = bulletTrace(startOrigin, endOrigin, false, self);
    angles = vectortoangles(vectornormalize(trace["normal"])) + (90, 0, 0);

    spawneye = spawn("script_model", trace["position"] + (0, 0, 50));
    spawneye.angles = angles;
    self setOrigin(spawneye.origin);
    spawneye delete();
}

savePosition() {
    self.saved_origin = self.origin;
    self.saved_angles = self.angles;
}

loadPosition() {
    if(!isDefined(self.saved_origin)) {
        return;
    } else {
        self setPlayerAngles(self.saved_angles);
        self setOrigin(self.saved_origin);
    }
}