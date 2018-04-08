import java.util.*;

Map<String, Float> hmVar = new HashMap<String, Float>();
Map<String, Integer> hmCmd = new HashMap<String, Integer>();
Functor[] funcArray;

final int iWidth = 1280, iHeight = 720;

Game game;
Console console;
BenchTool bench;
GraphLog[] graphs;

float FPSengine = 60, FPSdraw = 144;

boolean gameRunning = false;

void settings() {
  size(iWidth, iHeight, P3D);
}

void setup() {
  game = new Game();
  console = new Console();
  bench = new BenchTool();
  initGraphs();
  frameRate(1000);
  initFuncHash();
  hmVar.put("float1", 50.0);
  hmVar.put("float2", 50.0);
  surface.setLocation(displayWidth/2-width/2, displayHeight/2-height/2);
  gameRunning = true;
  thread("gameThread");
  vSync(1);
}

void vSync(int on) {
  PJOGL pgl = (PJOGL)beginPGL();
  pgl.gl.setSwapInterval(on);
  endPGL();
}

long nextFrameNano = System.nanoTime(), 
  nextDrawFrameNano = System.nanoTime(), measuredGameFPS;
long nanoWaitEngine = (long)((double)(1/FPSengine) * 1000000000.0), 
  nanoWaitDraw = (long)((double)(1/FPSdraw) * 1000000000.0);
long lastMs =  System.nanoTime();

void gameThread() {
  long nextFrameNano = System.nanoTime();
  while (gameRunning) {
    if (System.nanoTime() > nextFrameNano) {
      nextFrameNano += nanoWaitEngine;
      game.gameFrame();
    }
  }
}


void draw() {
 // if (System.nanoTime() > nextDrawFrameNano) {
    nextDrawFrameNano += nanoWaitDraw;
    game.gameDraw();
    utilities();
//  }
}

void utilities() {
  console.update();
  bench.draw();
  if (keyHit('`')) console.triggerKey();
  lastKeys = keys.clone();
  keyHit = (char)0;
}