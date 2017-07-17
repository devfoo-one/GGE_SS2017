import queasycam.*;

int zFactor = 480;
float zoomFactor = 0.002;
int stepSize = 512;
int RENDERWIDTH;
int RENDERHEIGHT;
int lastMillis;
FlightCam camera;


void setup() {
  //fullScreen(P3D);
  size(1280,800,P3D);
  frameRate(30);
  noiseDetail(5);
  RENDERWIDTH = width * 8;
  RENDERHEIGHT = width * 8;
  camera = new FlightCam(this);
  //right handed coordinate system
  camera.position = new PVector(RENDERWIDTH / 2.0,-100f,RENDERHEIGHT / 2.0);
  camera.tilt = 0.5;
  camera.pan = -0.75;
  camera.speed = 0.8f;
  
}

void draw() {
  
  // Get time since last draw call
  int elapsedTime = millis() - lastMillis;
  lastMillis = millis();
   
  perspective();
  pointLight(255, 255, 255, 0, -2000, 0);
  ambientLight(100,100,100);
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
      int lodLevel = 0;
      
      float ULx = x;
      float ULz = z;
      float ULy = getNoise(ULx, ULz);
      int renderDistance = int(new PVector(ULx, ULy, ULz).sub(camera.position).magSq()); 
      
      
      
      
      
     if (renderDistance < 300000) {
        lodLevel = 6; 
      } else if (renderDistance < 800000) {
        lodLevel = 5; 
      } else if (renderDistance < 1000000) {
        lodLevel = 4;
      } else if (renderDistance < 8000000) {
        lodLevel = 3;
      } else if (renderDistance < 16000000) {
        lodLevel = 2;
      } else if (renderDistance < 32000000) {
        lodLevel = 1;
      }
      
      int lod = int(pow(2,lodLevel));
      int lodStep = stepSize/lod;
      for(int lod_x_i = 0; lod_x_i < lod; lod_x_i++) {
          for(int lod_z_i = 0; lod_z_i < lod; lod_z_i++) {   
            ULx = x + lodStep * lod_x_i;
            ULz = z + lodStep * lod_z_i;
            ULy = getNoise(ULx, ULz);
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
                          
            float darkness = renderDistance / 16000000.f;
                          
            beginShape(QUADS);
            normal(normalUL.x, normalUL.y, normalUL.z);
            fill(lerpColor(getColorForY(UL.y), color(0), darkness));
            vertex(ULx, ULy, ULz);
            normal(normalUR.x, normalUR.y, normalUR.z);
            fill(lerpColor(getColorForY(UR.y), color(0), darkness));
            vertex(URx, URy, URz);
            normal(normalLR.x, normalLR.y, normalLR.z);
            fill(lerpColor(getColorForY(LR.y), color(0), darkness));
            vertex(LRx, LRy, LRz);
            normal(normalLL.x, normalLL.y, normalLL.z);
            fill(lerpColor(getColorForY(LL.y), color(0), darkness));
            vertex(LLx, LLy, LLz);
            endShape(CLOSE);
       
        }
      }      
    }
  }
}

float getNoise(float x, float z) {

  float baseHeight = 2500 - noise(x*0.0001, z * 0.0001) * 5000;
  return clampY(noise(x * zoomFactor,z * zoomFactor) * zFactor - baseHeight);
  
}

color getColorForY(float y) {
  if (y > 299) {
    return color(0,0,255); // water
  } else if (y > 280) {
    return color( 239, 221, 111); // sand
  } else if (y > 120) {
    return color( 22, 102, 35); // grass
  } else if (y > -100) {
    return color( 86, 82, 87); // gravel
  } else {
    return color( 240, 245, 250); // snow
  }
  
  //return color(255,0,0);
  
  
}

float clampY(float y) {
  if (y > 300) {
    return 300;
  }
  return y;
}

void keyPressed() {
 if (key=='n') {this.zoomFactor-=0.0001; print(zoomFactor + "\n");}
 if (key=='m') {this.zoomFactor+=0.0001; print(zoomFactor + "\n");}
   
}
  
    