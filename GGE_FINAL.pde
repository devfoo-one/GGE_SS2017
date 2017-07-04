import queasycam.*;

int zFactor = 480;
float zoomFactor = 0.004;
int stepSize = 20;
int RENDERWIDTH;
int RENDERHEIGHT;
QueasyCam camera;

void setup() {
  //fullScreen(P3D,2);
  size(800,600,P3D);
  frameRate(30);
  RENDERWIDTH = width * 5;
  RENDERHEIGHT = width * 5;
  camera = new QueasyCam(this);
  camera.position = new PVector(RENDERWIDTH / 2.0,-500f,RENDERHEIGHT / 2.0);
  camera.tilt = 0.5;
  camera.pan = -0.75;
  
}

void draw() {
  perspective();
  pointLight(255, 255, 255, 0, -800, 0);
  background(0,0,255);    
  
    
  for (int x = 0; x < (RENDERWIDTH/stepSize); x++) {
    for (int z = 0; z < (RENDERHEIGHT/stepSize); z++) {
      noStroke();
      
      
      float ULx = x*stepSize;
      float ULz = z*stepSize;
      float renderDistance = new PVector(ULx, 0, ULz).sub(camera.position).magSq(); 
      
      
      //if (renderDistance > 1000000.0) {
      //  break;
      //}
      
      fill(255,0,0);
      
      if(renderDistance < 100000.0) {
        fill(0,255,0);
      } else {
        fill(255,255,0);
      } 
      
      
           
      float ULy = getNoise(ULx, ULz);
      float URx = (x+1)*stepSize;
      float URz = z*stepSize;
      float URy = getNoise(URx, URz);
      float LLx = x*stepSize;
      float LLz = (z+1)*stepSize;
      float LLy = getNoise(LLx, LLz);
      float LRx = (x+1)*stepSize;
      float LRz = (z+1)*stepSize;
      float LRy = getNoise(LRx, LRz);
      float avgY = (ULy + URy + LLy + LRy) / 4.0;
      PVector UL = new PVector(ULx, ULy, ULz);
      PVector UR = new PVector(URx, URy, URz);
      PVector LL = new PVector(LLx, LLy, LLz);
      PVector LR = new PVector(LRx, LRy, LRz);
      
 

         
      
      //float valueRange = MAXZ - MINZ;
      //float value = avgZ - MINZ;
      //float ratio = value / valueRange;
      //if (ratio < 0.2) {
      //   fill(255,255,255);
      //}
      //if (ratio > 0.2 && ratio < 0.4) {
      //  fill(155,155,155);
      //}
      //if (ratio > 0.4 && ratio < 0.6) {
      //  fill(186,232,197);
      //}
      
      //if (ratio > 0.6) {
      //  fill(65,140,190);
      //}
                
      
      
      
      beginShape(QUADS);
      //normal(0,1,0);
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