import queasycam.*;

int zFactor = 480;
float zoomFactor = 0.004;
int stepSize = 128;
int RENDERWIDTH;
int RENDERHEIGHT;
int lastMillis;
FlightCam camera;


void setup() {
  //fullScreen(P3D);
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
    
  for (int x_i = camX/stepSize - (RENDERWIDTH / 2 / stepSize); x_i < camX/stepSize + (RENDERWIDTH / 2 / stepSize); x_i++) {
    for (int z_i = camZ/stepSize - (RENDERHEIGHT / 2 / stepSize); z_i < camZ/stepSize + (RENDERHEIGHT / 2 / stepSize); z_i++) {
      int x = x_i * stepSize;
      int z = z_i * stepSize;
      
      float ULx = x;
      float ULz = z;
      int renderDistance = int(new PVector(ULx, 0, ULz).sub(camera.position).magSq()); 
      
      int lod = 1;
       
      if (renderDistance < 500000) {
        lod = 4;
        fill(color(0,255,0));
      } else if (renderDistance < 4000000) {
        lod = 3;
        fill(color(255,255,0));
      } else if (renderDistance < 16000000) {
        lod = 2;
        fill(color(255,0,0));
      } else {
        fill(color(0,0,0));
      }
      
      int lodStep = stepSize/lod;
      //print("Drawing stuff... lodStep: " + lodStep + "\n");
      for(int lod_x_i = 0; lod_x_i < lod; lod_x_i++) {
          for(int lod_z_i = 0; lod_z_i < lod; lod_z_i++) {
          ULx = x + lodStep * lod_x_i;
          ULz = z + lodStep * lod_z_i;
          float ULy = getNoise(ULx, ULz);
          float URx = ULx + lodStep;
          float URz = ULz;
          float URy = getNoise(URx, URz);
          float LLx = ULx;
          float LLz = ULz + lodStep;
          float LLy = getNoise(LLx, LLz);
          float LRx = ULx+lodStep;
          float LRz = LLz;
          float LRy = getNoise(LRx, LRz);
          PVector UL = new PVector(ULx, ULy, ULz);
          PVector UR = new PVector(URx, URy, URz);
          PVector LL = new PVector(LLx, LLy, LLz);
          PVector LR = new PVector(LRx, LRy, LRz);
          //print("UL: " + UL + "\n");
          //print("UR: " + UR + "\n");
          //print("LL: " + LL + "\n");
          //print("LR: " + LR + "\n");
          //print("----------\n"); 
          beginShape(QUADS);
          //PVector edge1 = UL.copy().sub(LL);
          //PVector edge2 = LR.copy().sub(LL);
          //PVector normal = edge1.cross(edge2).normalize();
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
  }
}

float getNoise(float x, float z) {
  //zoomFactor = noise(x/100, z/100);  
  return noise(x * zoomFactor,z * zoomFactor) * zFactor;
}