import queasycam.*;



float xOffset = 0;
float yOffset = 0;
int zFactor = 480;
float zoomFactor = 0.004;
float [][] pointBuffer;
int stepSize = 20;
float roughness = 1.0;
float cameraAngle = 30.0;
int RENDERWIDTH;
int RENDERHEIGHT;
float MINZ;
float MAXZ;
QueasyCam camera;

void setup() {
  //fullScreen(P3D,2);
  size(800,600,P3D);
  frameRate(30);
  RENDERWIDTH = width * 2;
  RENDERHEIGHT = width * 2;
  camera = new QueasyCam(this);
  camera.position = new PVector(0f,-500f,0f);
  camera.tilt = 0.5;
  camera.pan = -0.75;
  
}

void draw() {
  perspective();
  //print(camera.pan + "\n");
  MAXZ = -99999999999.0;
  MINZ = 99999999999.0;
  pointBuffer = new float[RENDERWIDTH / stepSize + 1][RENDERHEIGHT / stepSize + 1];
  for (int x = 0; x < RENDERWIDTH/stepSize + 1; x++) {
    for (int y = 0; y < RENDERHEIGHT/stepSize; y++) {
      float perlinNoise = noise((x*stepSize+xOffset) * zoomFactor,(y*stepSize+yOffset) * zoomFactor);
      float z = pow(perlinNoise, roughness) * zFactor;
      z = z - float(zFactor) / 2.0; // stay centered
      MINZ = min(z, MINZ);
      MAXZ = max(z, MAXZ);
      pointBuffer[x][y] = z;
    }
  }
  
  
  pointLight(255, 255, 255, 0, -800, 0);
          rotateX(-PI/2.0);
  background(0,0,255);    
          
      
  for (int x = 0; x < (RENDERWIDTH/stepSize) - 1; x++) {
    for (int y = 0; y < (RENDERHEIGHT/stepSize) - 1; y++) {
      noStroke();
      float ULx = x*stepSize;
      float ULy = y*stepSize;
      float ULz = pointBuffer[x][y];
      float URx = (x+1)*stepSize;
      float URy = y*stepSize;
      float URz = pointBuffer[x+1][y];
      float LLx = x*stepSize;
      float LLy = (y+1)*stepSize;
      float LLz = pointBuffer[x][y+1];
      float LRx = (x+1)*stepSize;
      float LRy = (y+1)*stepSize;
      float LRz = pointBuffer[x+1][y+1];
      float avgZ = (ULz + URz + LLz + LRz) / 4.0;
      PVector UL = new PVector(ULx, ULy, ULz);
      PVector UR = new PVector(URx, URy, URz);
      PVector LL = new PVector(LLx, LLy, LLz);
      PVector LR = new PVector(LRx, LRy, LRz);
      
 

      beginShape(QUADS);   
      float valueRange = MAXZ - MINZ;
      float value = avgZ - MINZ;
      float ratio = value / valueRange;
      if (ratio < 0.2) {
         fill(255,255,255);
      }
      if (ratio > 0.2 && ratio < 0.4) {
        fill(155,155,155);
      }
      if (ratio > 0.4 && ratio < 0.6) {
        fill(186,232,197);
      }
      
      if (ratio > 0.6) {
        fill(65,140,190);
      }
                
      normal(0,0,1);
      vertex(ULx, ULy, ULz);
      vertex(URx, URy, URz);
      vertex(LRx, LRy, LRz);
      vertex(LLx, LLy, LLz);
      endShape(CLOSE);
            
      if(UL.copy().sub(camera.position).magSq() < 1000000.0) {
        fill(0,255,0);
        
      }
      
    }
  }
}