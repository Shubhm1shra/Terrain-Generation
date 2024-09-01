class Terrain{
  private int terrainW = 1600;
  private int terrainH = 900;
  
  private int scale = 10;
  private int rows, cols;
  
  private float[][] terrain;
  private int minTerrainH = -100;
  private int maxTerrainH = 150;
  
  private float camX = 0;
  private float targetCamX = 0;
  private float camZ = 0;
  private float targetCamZ = 0;
  private float movSpeed;
  
  private boolean[] camMovState = {false, false, false, false};
  
  private float cameraAngleXY = PI/3;
  
  private color[] height2color = {color(0, 0, 139), color(196, 164, 132), color(144, 238, 144), color(1, 50, 32)};
  
  Terrain(){
    this.initialize();
  }
  
  private void initialize(){
    this.rows = floor(this.terrainH/this.scale);
    this.cols = floor(this.terrainW/this.scale);
    
    movSpeed = ((float)(this.rows * this.cols) / (14400)) * 0.1;
    
    terrain = new float[rows][cols];
  }
  
  void setScale(int scale){
    this.scale = scale;
    
    this.initialize();
  }
  
  void setTerrainSize(int terrainW, int terrainH, int minTerrainH, int maxTerrainH){
    this.terrainW = terrainW;
    this.terrainH = terrainH;
    
    this.minTerrainH = minTerrainH;
    this.maxTerrainH = maxTerrainH;
    
    this.initialize();
  }
  
  private void loadTerrain(){
    float xOff = this.camX;
    for(int row = 0; row < this.rows; row++){
      float zOff = this.camZ;
      for(int col = 0; col < this.cols; col++){
        this.terrain[row][col] = map(noise(zOff, xOff), 0, 1, this.minTerrainH, this.maxTerrainH);
        zOff += 0.1;
      }
      xOff += 0.1;
    }
  }
  
  void update(){
    if(this.camMovState[0]){this.targetCamX -= this.movSpeed;}
    if(this.camMovState[1]){this.targetCamX += this.movSpeed;}
    if(this.camMovState[2]){this.targetCamZ -= this.movSpeed;}
    if(this.camMovState[3]){this.targetCamZ += this.movSpeed;}
    
    if(keyPressed){
      if(key == 'z'){this.cameraAngleXY -= 0.01;}
      if(key == 'x'){this.cameraAngleXY += 0.01;}
    }
    
    this.camX = lerp(camX, targetCamX, 0.1);
    this.camZ = lerp(camZ, targetCamZ, 0.1);
    
    this.loadTerrain();
  }
  
  void display(){
    background(0);
    
    ambientLight(100, 100, 100);
    //directionalLight(255, 255, 255, -1, -1, -1);
    
    pointLight(255, 200, 150, this.terrainW / 2, this.terrainH / 2, 100);
    
    specular(255);
    shininess(50);
    
    translate(width/2, height/2);
    rotateX(this.cameraAngleXY);
    translate(-this.terrainW/2, -this.terrainH/2);
    
    for(int row = 0; row < this.rows - 1; row++){
      beginShape(TRIANGLE_STRIP);
      for(int col = 0; col < this.cols; col++){
        fill(this.height2color[(int)map(this.terrain[row][col], this.minTerrainH, this.maxTerrainH, 0, this.height2color.length)]);
        vertex(col * this.scale, row * this.scale, terrain[row][col]);
        fill(this.height2color[(int)map(this.terrain[row + 1][col], this.minTerrainH, this.maxTerrainH, 0, this.height2color.length)]);
        vertex(col * this.scale, (row + 1) * this.scale, terrain[row + 1][col]);
      }
      endShape();
    }
  }
  
  void keyPressed(){
    if(key == CODED){
      if(keyCode == UP){this.camMovState[0] = true;}
      else if(keyCode == DOWN){this.camMovState[1] = true;}
      else if(keyCode == LEFT){this.camMovState[2] = true;}
      else if(keyCode == RIGHT){this.camMovState[3] = true;}
    }
  }
  
  void keyReleased(){
    if(key == CODED){
      if(keyCode == UP){this.camMovState[0] = false;}
      else if(keyCode == DOWN){this.camMovState[1] = false;}
      else if(keyCode == LEFT){this.camMovState[2] = false;}
      else if(keyCode == RIGHT){this.camMovState[3] = false;}
    }
  }
}
