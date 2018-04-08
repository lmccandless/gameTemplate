class Game {
  color randColor = 0;
    long lastMsEngine = System.nanoTime(), lastMsDraw = System.nanoTime();
  Game() {
  }

  void gameFrame() {
    hmVar.put("fpsEngine", (float)(int)(float)(1000000000/(System.nanoTime()-lastMsEngine)));
    lastMsEngine = System.nanoTime();
    bench.s("gameFrame");
    bench.f("gameFrame");
  }

  void gameDraw() {
    hmVar.put("fpsDraw", (float)(int)(float)(1000000000/(System.nanoTime()-lastMsDraw)));
    lastMsDraw = System.nanoTime();
    bench.s("gameDraw");
    clear();
    background(100);
    fill(randColor);

    float f1 = hmVar.get("float1");
    text("float1: " + f1, 100, 500);
    rect(400, 400, f1, hmVar.get("float2"));
    bench.f("gameDraw");
  }

  void doThing() {
    randColor = color(random(255), random(255), random(255));
  }
}