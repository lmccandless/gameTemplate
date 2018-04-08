import java.util.*;

Map<String, Float> hmVar = new HashMap<String, Float>();
Map<String, Integer> hmCmd = new HashMap<String, Integer>();
Functor[] funcArray;

final int iWidth = 1280, iHeight = 720;

Game game;
Console console;
BenchTool bench;
GraphLog[] graphs;

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
}

long nextFrameNano = System.nanoTime(), measuredGameFPS;
long nanoWait = (long)((double)(1/60.0) * 1000000000.0);
long lastMs =  System.nanoTime();
void draw() {
  if (System.nanoTime() > nextFrameNano) {
    nextFrameNano += nanoWait;
    game.gameFrame();
    game.gameDraw();
    utilities();
  }
  while (System.nanoTime() < nextFrameNano) {
  }
}

void utilities() {
  console.update();
  bench.draw();
  if (keyHit('`')) console.triggerKey();
  lastKeys = keys.clone();
  keyHit = (char)0;
}