boolean [] keys = new boolean[256];
boolean [] lastKeys = new boolean[256];

char keyHit = ' ';

boolean keyHit(){
  if (keyHit == 0) return false;
  return true;
}

/*boolean keyHit(char i) {
  int c = (int)i;
  return (keys[c] && !lastKeys[c]);
}*/

boolean keyHit(int c) {
  return (keys[c] && !lastKeys[c]);
}

void setKey(boolean state) {
  
  int rawKey = keyCode;
  //println((int)key);
  if (rawKey < 256) {
    if ((rawKey>64)&&(rawKey<91)) rawKey+=32;
    if ((state) && (!lastKeys[rawKey])) {
      keyHit = (char) (rawKey);
    }
    keys[rawKey] = state;
  }
}

void keyPressed() { 
  //println(keyCode);
  setKey(true);
}

void keyReleased() { 
  setKey(false);
}