import queasycam.*;

class FlightCam extends QueasyCam {
  
  public FlightCam(PApplet applet) {
    super(applet);
  }

  public void update(int elapsedTime) {
    
    this.tilt-=0.1;
    PVector forward = camera.getForward(); 
    camera.position = camera.position.add(PVector.mult(forward, float(elapsedTime) * speed));
    if (camera.position.y > 260) {
      camera.position.y = 259;    
    }
    //this.tilt+=1;
  }

  public void pullUp(int elapsedTime) {
    this.tilt-=0.001 * elapsedTime;
  }
  
  public void pullDown(int elapsedTime) {
    this.tilt+=0.001 * elapsedTime;
  }
}