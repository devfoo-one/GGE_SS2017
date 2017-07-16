import queasycam.*;

class FlightCam extends QueasyCam {
  
  public FlightCam(PApplet applet) {
    super(applet);
  }

  public void update(int elapsedTime) {
     camera.position = camera.position.add(PVector.mult(camera.getForward(), float(elapsedTime) * speed));
  
  }

  public void pullUp(int elapsedTime) {
    this.tilt-=0.0001 * elapsedTime;
  }
  
  public void pullDown(int elapsedTime) {
    this.tilt+=0.0001 * elapsedTime;
  }
}