int funcId = 0;
void initFuncHash() {
  funcArray = new Functor[10];
  addHashCmd(new DoThing(), "doThing");
  addHashCmd(new Bench(), "bench");
  addHashCmd(new Help(), "help");
  addHashCmd(new Graph1(), "graph1");
  addHashCmd(new Clear(), "clear");
}

class Console {
  boolean opened = false;
  PGraphics pgConsole;
  final int cWidth = 400, cHeight = 250;

  String input = "";
  int backInput = 0;
  int autoSelect = 0;
  ArrayList<String> lastInput = new ArrayList<String>();
  ArrayList<String> output = new ArrayList<String>();
  ArrayList<String> auto = new ArrayList<String>();
  Console() {
    println("test");
    pgConsole = createGraphics(cWidth, cHeight*2, P2D);
    updateDraw();
  }

  void frame() {
    String[] splitStr = split(input, '=');
    String arg1 = splitStr[0].trim();
    if (keyHit == SHIFT) {
    } else if (keyHit == (int)' ') {
      autoSet();
    } else if (keyHit == LEFT) {
      autoSelect = max(0, autoSelect-1);
    } else if (keyHit ==RIGHT) {
      autoSelect = max(0, min(auto.size()-1, autoSelect+1));
    } else if (keyHit == (int)'=') {
      autoSet();
      input = input + "=";
    } else if (keyHit == BACKSPACE) {
      if (input.length() > 0) input =input.substring(0, input.length()-1);
    } else if (keyHit == ENTER) {
      command();
    } else if (keyHit == UP) { 
      getLastInput();
    } else {
      if (input.contains("=") && (hmCmd.containsKey(arg1))) { 
        println("foo");
        autoCompleteVars();
      } else input.contains("=");
      input = input + key;
    }
  }

  void command() {
    String[] splitStr = split(input, '=');
    String arg1 = splitStr[0].trim();
    if ((hmVar.containsKey(arg1)) && (splitStr.length>1)) setVar();
    else if (hmVar.containsKey(input)) returnVar();
    else if (hmCmd.containsKey(splitStr[0])) {
      // String[] splitStr = split(input, ',');
      if (splitStr.length>1) {

        String arg2 = splitStr[1].trim();
        if (hmVar.containsKey( splitStr[1])) {
          output.add("executing " + arg1 + " with args " + arg2);
          funcArray[hmCmd.get(arg1)].execute(arg2);
        }
      } else {
        output.add("executing " + input);
        funcArray[hmCmd.get(input)].execute("");
      }
    } else {
      auto = autoComplete();
      if ((auto.size() > 0) && (!input.trim().equals(auto.get(autoSelect)))) {
        input = auto.get(autoSelect); 
        command();
      } else {
        invalidCmd();
      }
    }
    resetInput();
  }

  void help() {
    output.add("Available vars");
    ArrayList<String> list = new ArrayList<String>();
    list.addAll(hmVar.keySet());
    for (String s : list) {
      output.add("    " + s);
    }
    output.add("Available commands");
    list = new ArrayList<String>();
    list.addAll(hmCmd.keySet());
    for (String s : list) {
      output.add("    " + s);
    }
  }

  void autoSet() {
    auto = autoComplete();
    if (auto.size()>0) input = auto.get(autoSelect);
  }

  void resetInput() {
    backInput = 0;
    if ((lastInput.size() == 0) || (!lastInput.get(lastInput.size()-1).equals(input))) 
      lastInput.add(input);
    input = "";
  }


  ArrayList<String> autoCompleteVars() {
    ArrayList<String> fullList = new ArrayList<String>();
    fullList.addAll(hmVar.keySet());
    ArrayList<String> toRemove =  new ArrayList<String>();
    for (int i = 0; i < fullList.size(); i++) {
      String full = fullList.get(i);
      if (full.length() < input.length()) {
        toRemove.add(full);
      } else {
        String sub = full.substring(0, input.length());
        if (!input.equals(sub)) toRemove.add(full);
      }
    }
    fullList.removeAll(toRemove);
    autoSelect = max(0, min(autoSelect, fullList.size()-1));
    return fullList;
  }

  ArrayList<String> autoComplete() {
    ArrayList<String> fullList = new ArrayList<String>();
    fullList.addAll(hmVar.keySet());
    fullList.addAll(hmCmd.keySet());

    ArrayList<String> toRemove =  new ArrayList<String>();
    for (int i = 0; i < fullList.size(); i++) {
      String full = fullList.get(i);
      if (full.length() < input.length()) {
        toRemove.add(full);
      } else {
        String sub = full.substring(0, input.length());
        if (!input.equals(sub)) toRemove.add(full);
      }
    }
    fullList.removeAll(toRemove);
    autoSelect = max(0, min(autoSelect, fullList.size()-1));
    return fullList;
  }

  void setVar() {
    String[] splitStr = split(input, '=');
    String arg1 = splitStr[0].trim();
    if (hmVar.containsKey(arg1)) {
      float f = parseFloat(splitStr[1]);
      if (Float.isNaN(f)) output.add("float is NaN, var not set");
      else {
        hmVar.put(arg1, f);
        Float fr = hmVar.get(arg1);
        fr = f;
        output.add(splitStr[0] + " = " + fr);
      }
    } else {
      output.add(splitStr[0] +" not found");
    }
  }

  void returnVar() {
    output.add(">" + input + "  " + hmVar.get(input));
  }

  void invalidCmd() {
    output.add(input + " / invalid command ");
  }

  void getLastInput() {
    if (lastInput.size()>0) input = lastInput.get(lastInput.size()-1-backInput);
    backInput++;
    backInput = min(backInput, lastInput.size()-1);
  }

  void updateDraw() {
    pgConsole.beginDraw();
    pgConsole.clear();
    color bg = color(48, 87, 48);
    pgConsole.fill(bg);
    pgConsole.rect(0, 0, cWidth-1, cHeight);
    pgConsole.fill(255);
    int y = cHeight-10;
    pgConsole.text(">" +input + "_", 5, y);
    y = 2;
    int linesToDraw = 18;
    int start = max(0, output.size()-linesToDraw);
    int end = min(output.size(), output.size()+linesToDraw);
    for (int i = start; i < end; i++) {
      pgConsole.text(output.get(i), 5, y+=12);
    }

    if (input.length() > 0) {
      auto = autoComplete();
      if (auto.size()>0) {
        pgConsole.fill(bg);
        pgConsole.rect(20, cHeight+10, 100, 14*auto.size());
        pgConsole.fill(255);
        y = 0;
        pgConsole.fill(155, 155, 0);
        pgConsole.rect(20, cHeight+10+12*autoSelect, 100, 14);
        pgConsole.fill(255);
        for (String s : auto) pgConsole.text(s, 24, cHeight+10+(y+=12));
      }
      for (String s : auto) println(s);
    }
    pgConsole.endDraw();
  }

  void update() {

    if (opened) {
      if (keyHit()) {
        frame();
        updateDraw();
      }
      updateDraw();
      for (GraphLog g : graphs) {
        g.draw(pgConsole);  
        g.graph();
      }
      image(pgConsole, 0, 0);
    }
  }

  void triggerKey() {
    opened = !opened;
    input = "";
  }
}


abstract class Functor {
  public abstract void execute(String args);
}

class DoThing extends Functor {
  public void execute(String args) { 
    game.doThing();
  }
}

class Bench extends Functor {
  public void execute(String args) { 
    bench.toggle();
  }
}

class Help extends Functor {
  public void execute(String args) { 
    console.help();
  }
}

class Graph1 extends Functor {
  public void execute(String args) { 
    graphs[0].graphLabel = args;
  }
}
class Graph2 extends Functor {
  public void execute(String args) { 
    graphs[1].graphLabel = args;
  }
}
class Graph3 extends Functor {
  public void execute(String args) { 
    graphs[2].graphLabel = args;
  }
}

class Clear extends Functor {
  public void execute(String args) { 
    console.output = new ArrayList<String>();
  }
}

void addHashCmd(Functor func, String funcName) {
  funcArray[funcId] = func;
  hmCmd.put(funcName, funcId++);
}