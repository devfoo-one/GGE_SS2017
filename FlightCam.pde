import queasycam.*;

class FlightCam extends QueasyCam {
  
  public FlightCam(PApplet applet) {
    super(applet);
  }

  public void update(int elapsedTime) {
    PVector forward = camera.getForward().add(PVector.mult(camera.getUp(), -0.5)).normalize(); 
    camera.position = camera.position.add(PVector.mult(forward, float(elapsedTime) * speed));
    if (camera.position.y > 200) {
      camera.position.y = 199;    
    }
  }

  public void pullUp(int elapsedTime) {
    this.tilt-=0.0001 * elapsedTime;
  }
  
  public void pullDown(int elapsedTime) {
    this.tilt+=0.0001 * elapsedTime;
  }
}