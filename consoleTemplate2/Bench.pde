
class BenchTool {
  String[] benchLabels = {"gameFrame", "gameDraw"};
  HashMap<String, Integer> hmBench= new HashMap<String, Integer>();
  ArrayList<Float> times = new ArrayList<Float>();
  ArrayList<Long> starts = new ArrayList<Long>();
  boolean enabled = false;
  boolean lastDown = false;
  BenchTool() {
    for (int i = 0; i < benchLabels.length; i++) hmBench.put(benchLabels[i], i);
  }

  void s(String id) {
    s(hmBench.get(id));
  }
  void f(String id) {
    f(hmBench.get(id));
  }

  void s(int id) {
    while (times.size() < id+1) {
      times.add(0.0);
      starts.add(System.nanoTime());
    }
    starts.set(id, System.nanoTime());
  }

  void f(int id) {
    long fer = System.nanoTime()-starts.get(id);
    float avg = times.get(id);
    float newf  = fer/1000.0;
    times.set(id, avg+ (newf-avg)/100);
  }

  void toggle() {
    enabled = !enabled;
  }
  void draw() {
    if (enabled) {
      pushMatrix();
      int x = 10, y= 100;
      fill(255);
      translate(0, 200);
      rect(x, y, 200, times.size()*15 + 15);
      translate(0, 0, 0.1);
      fill(0);
      int i = 0;
      for (Float t : times) {
        text(benchLabels[i] + ": " + int(t), x, y+=15);
        i++;
      }
      popMatrix();
    }
  }
}

void initGraphs() {
  graphs = new GraphLog[3];
  graphs[0] = new GraphLog();
  graphs[1] = new GraphLog();
  graphs[2] = new GraphLog();
  graphs[0].graphLabel = "fpsP3D";
  graphs[1].graphLabel = "fpsEngine";
  graphs[2].graphLabel = "fpsDraw";
  graphs[0].graphCol = color(155, 0, 0);
  graphs[1].graphCol =  color(0, 155, 0);
  graphs[2].graphCol =  color(0, 0, 155);
  graphs[0].offset = 0;
  graphs[1].offset =  1;
  graphs[2].offset = 2;
}

class GraphLog {
  Float[] entries = new Float[400];
  int c = 0;
  int tot = 400;
  String graphLabel = "fpsP3D";
  color graphCol = color(255, 0, 0);
  int offset = 0;
  GraphLog() {
    for (int i = 0; i < tot; i++) {
      entries[i] = null;
    }
  }

  void graph() {
    entries[c] = hmVar.get(graphLabel);
    c++;
    if (c>=tot) c = 0;
  }

  void draw(PGraphics pg) {
    pg.beginDraw();
    //pg.clear();
    int cc = c;
    pg.beginShape();
    pg.noFill();
    pg.stroke(graphCol);
    for (int i = 0; i < tot; i++) {
      if (entries[cc] != null) {
        pg.vertex(400-i*2, entries[cc]);
      }
      cc--;
      if (cc<0) cc = tot-1;
    }
    pg.endShape();
    pg.fill(graphCol);
    Float k = entries[max(0, c-1)];
    if (k !=null) pg.text(graphLabel + " " + k.intValue(), 270, k + offset*12);
    pg.fill(255);
    //  pg.textSize(10);
    pg.textAlign(CENTER, CENTER);
    for (int i = 0; i < 14; i+=2) {
      // pg.line(395, i*10,400,i*10);
      pg.text(i*10, 386, i*10);
    }

    text(10, 150, 150);

    //endShape();
    pg.endDraw();
    pg.stroke(0);
    //  pg.textSize(11);
    pg.textAlign(LEFT, BOTTOM);
    //image(pg, 0, 0);
  }
}