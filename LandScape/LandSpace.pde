Terrain terrain;

void setup(){
  size(600, 600, P3D);
  
  terrain = new Terrain();
  terrain.setScale(15);
  terrain.setTerrainSize(1600, 900, -300, 200);
}

void draw(){
  background(0);
  
  terrain.update();
  terrain.display();
}

void keyPressed(){
  terrain.keyPressed();
}

void keyReleased(){
  terrain.keyReleased();
}
