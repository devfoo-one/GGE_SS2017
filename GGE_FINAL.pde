import queasycam.*;

int zFactor = 480;
float zoomFactor = 0.004;
int stepSize = 256;
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
  camera.position = new PVector(RENDERWIDTH / 2.0,-100f,RENDERHEIGHT / 2.0);
  camera.tilt = 0.5;
  camera.pan = -0.75;
  camera.speed = 0.05f;
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
      
      int lodLevel = 0;
      
      fill(color(0,255,0));
      
      if (renderDistance < 500000) {
        lodLevel = 4; 
      } else if (renderDistance < 1000000) {
        lodLevel = 3;
      } else if (renderDistance < 8000000) {
        lodLevel = 2;
      } else if (renderDistance < 16000000) {
        lodLevel = 1;
      }
      
      int lod = int(pow(2,lodLevel));
      int lodStep = stepSize/lod;
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
          
          // extreme points for smooth normal calculation
          
          float LULx = ULx - lodStep;
          float LULz = ULz;
          float LULy = getNoise(LULx, LULz);
          PVector LUL = new PVector(LULx, LULy,LULz);
          
          float LLLx = LULx;
          float LLLz = LLz;
          float LLLy = getNoise(LLLx, LLLz);
          PVector LLL = new PVector(LLLx, LLLy,LLLz);
          
          float UULx = ULx;
          float UULz = ULz - lodStep;
          float UULy = getNoise(UULx, UULz);
          PVector UUL = new PVector(UULx, UULy,UULz);
          
          float UURx = URx;
          float UURz = UULz;
          float UURy = getNoise(UURx, UURz);
          PVector UUR = new PVector(UURx, UURy,UURz);
                     
          float RURx = URx + lodStep;
          float RURz = URz;
          float RURy = getNoise(RURx, RURz);
          PVector RUR = new PVector(RURx, RURy,RURz);
                        
          float RLRx = LRx + lodStep;
          float RLRz = LRz;
          float RLRy = getNoise(RLRx, RLRz);
          PVector RLR = new PVector(RLRx, RLRy,RLRz);
                        
          float LLRx = LRx;
          float LLRz = LRz + lodStep;
          float LLRy = getNoise(LLRx, LLRz);
          PVector LLR = new PVector(LLRx, LLRy,LLRz);
                        
          float LLLLx = LLx;
          float LLLLz = LLz + lodStep;
          float LLLLy = getNoise(LLLLx, LLLLz);
          PVector LLLL = new PVector(LLLLx, LLLLy,LLLLz);                       
          
          PVector normalUL = UR.copy().sub(LUL).cross(LL.copy().sub(UUL)).normalize();
          PVector normalUR = LR.copy().sub(UUR).cross(UL.copy().sub(RUR)).normalize();
          PVector normalLL = UL.copy().sub(LLLL).cross(LR.copy().sub(LLL)).normalize();
          PVector normalLR = LL.copy().sub(RLR).cross(UR.copy().sub(LLR)).normalize();
                        
          beginShape(QUADS);
          normal(normalUL.x, normalUL.y, normalUL.z);
          vertex(ULx, ULy, ULz);
          normal(normalUR.x, normalUR.y, normalUR.z);
          vertex(URx, URy, URz);
          normal(normalLR.x, normalLR.y, normalLR.z);
          vertex(LRx, LRy, LRz);
          normal(normalLL.x, normalLL.y, normalLL.z);
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