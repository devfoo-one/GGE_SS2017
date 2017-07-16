import queasycam.*;

int zFactor = 480;
float zoomFactor = 0.004;
int stepSize = 64;
int RENDERWIDTH;
int RENDERHEIGHT;
int lastMillis;
FlightCam camera;


void setup() {
  //fullScreen(P3D,2);
  size(1280,800,P3D);
  frameRate(30);
  RENDERWIDTH = width * 6;
  RENDERHEIGHT = width * 6;
  camera = new FlightCam(this);
  //right handed coordinate system
  camera.position = new PVector(RENDERWIDTH / 2.0,-500f,RENDERHEIGHT / 2.0);
  camera.tilt = 0.5;
  camera.pan = -0.75;
  camera.speed = 0.5f;
}

void draw() {
  
  // Get time since last draw call
  int elapsedTime = millis() - lastMillis;
  lastMillis = millis();
   
  perspective();
  pointLight(255, 255, 255, 0, -2000, 0);
  ambientLight(10, 10, 10);
  background(0,0,255);    
  noStroke();
  camera.update(elapsedTime); 
  
   
  //FLIGHT CONTROLLS
  if (keyPressed == true) {
   
    if (keyCode == UP) {
      camera.pullDown(elapsedTime);
    }
    if (keyCode == DOWN) {
      camera.pullUp(elapsedTime);
      
    }
    if (keyCode == LEFT) {
      camera.pan-=0.05;
    }
    if (keyCode == RIGHT) {
      camera.pan+=0.05;
    }
    
    
    
  }
    
  
  
  int camX = int(camera.position.x);
  int camZ = int(camera.position.z);
    
  for (int x_n = camX/stepSize - (RENDERWIDTH / 2 / stepSize); x_n < camX/stepSize + (RENDERWIDTH / 2 / stepSize); x_n++) {
    for (int z_n = camZ/stepSize - (RENDERHEIGHT / 2 / stepSize); z_n < camZ/stepSize + (RENDERHEIGHT / 2 / stepSize); z_n++) {
      int x = x_n * stepSize;
      int z = z_n * stepSize;
      
      float ULx = x;
      float ULz = z;
      float renderDistance = new PVector(ULx, 0, ULz).sub(camera.position).magSq(); 
           
      //if (renderDistance > 1000000.0) {
      //  break;
      //}
      
      if (renderDistance < 1000000) {
        float lod = norm(renderDistance, 0, 1000000); 
        fill(lerpColor(color(0,255,0), color(255,255,0), lod));
      } else {
        float lod = norm(renderDistance, 1000000, 10000000); 
        fill(lerpColor(color(255,255,0), color(255,0,0), lod));
      }
                 
                 
      float ULy = getNoise(ULx, ULz);
      float URx = x+stepSize;
      float URz = z;
      float URy = getNoise(URx, URz);
      float LLx = x;
      float LLz = z+stepSize;
      float LLy = getNoise(LLx, LLz);
      float LRx = x+stepSize;
      float LRz = z+stepSize;
      float LRy = getNoise(LRx, LRz);
      
      PVector UL = new PVector(ULx, ULy, ULz);
      PVector UR = new PVector(URx, URy, URz);
      PVector LL = new PVector(LLx, LLy, LLz);
      PVector LR = new PVector(LRx, LRy, LRz);
      
      
      beginShape(QUADS);
      PVector edge1 = UL.copy().sub(LL);
      PVector edge2 = LR.copy().sub(LL);
      PVector normal = edge1.cross(edge2).normalize();
      //normal(normal.x, normal.y, normal.z);
      // ONE NORMAL PER VERTEX SHOULD WORK
      vertex(ULx, ULy, ULz);
      vertex(URx, URy, URz);
      vertex(LRx, LRy, LRz);
      vertex(LLx, LLy, LLz);
      endShape(CLOSE);
      
      
            
      
      
    }
  }
}

float getNoise(float x, float z) {
  return noise(x * zoomFactor,z * zoomFactor) * zFactor;
}