import queasycam.*;

class FlightCam extends QueasyCam {
  
  public FlightCam(PApplet applet) {
    super(applet);
  }

  public void update(int elapsedTime) {
    
    PVector forward = camera.getForward().add(PVector.mult(camera.getUp(), -0.3)).normalize(); 
    camera.position = camera.position.add(PVector.mult(forward, float(elapsedTime) * speed));
    if (camera.position.y > 200) {
      camera.position.y = 199;    
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