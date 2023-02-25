import processing.sound.*;
import java.util.Random;

class Ball {
  int ratecnt;
  float x;
  int r;
  int g;
  int b;
  boolean hit;
  Ball(int ratecnt, float x, int r, int g, int b, boolean hit) {
    this.ratecnt = ratecnt;
    this.x = x;
    this.r = r;
    this.g = g;
    this.b = b;
    this.hit = hit;
  }
  void drawSomething1(int time){
    if(ratecnt == time) {
      //print(x + "\n");
      //print(y + "\n");
      ellipse(r*2, g*2, 20, 20);
    }
    else if (time - ratecnt >= 0){
      if(time - ratecnt <= 5) {
        fill(r, g, b);
        ellipse(r *2, g*2, 20 + (time- ratecnt + 1)*20, 20 + (time- ratecnt + 1)*20);
      }
    }
  }
  
  void drawSomething2(int time) {
    if(Math.abs(time - ratecnt) <=4 && x == pointer) {
      hit = true;
    }
    if(hit == false) {
      int y = (ratecnt - time)*5;
      //print(x + "\n");
      //print(y + "\n");
      fill(r, g, b);
      ellipse(x + 320, 500 - y, 20, 20);
    }
    else if (hit == true){
      if(time - ratecnt <= 5) {
        fill(r, g, b);
        ellipse(x + 320, 500, 20 + (time- ratecnt + 1)*20, 20 + (time- ratecnt + 1)*20);
      }
    }
  }
}

Sound     snd;
SoundFile sfl;
Amplitude amp;




ArrayList<Ball> objects = new ArrayList<Ball>();
String lin;
int ln;
String lines[];

PrintWriter file;
int smplRate = 48000;
int frmRate  = 24;



int pointer = 10000;
float lastanalyze;
int okcount;
int eX = 0;
int judge = 0;
float max = 0;
boolean Inputjudge = false;

void setup(){
  file = createWriter("test.csv");
  size(640, 640);
 colorMode(HSB, 360.0, 100.0, 100.0, 100.0);
 frameRate(frmRate);
}



void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    sfl = new SoundFile(this, selection.getAbsolutePath());
    Inputjudge = true;
    sfl.play();
    amp = new Amplitude(this);
    amp.input(sfl);
    inputcount = 0;
  }
}

int animationcount = -50;
int visualcount = 0;
int count = 0;
int inputcount = 0;
void draw() {
  count++;
  if (judge == 0 && count == 1) {
    println("input key");
    println("1 : file input   2 : visualization  3: rhythm Game");
  }
  
  if(judge == 1 && count == 1) {
    selectInput("Select a file to process:", "fileSelected");
  }
  
  if (judge == 1 && Inputjudge == true) {
    if(sfl.isPlaying()){
      file.print(inputcount);
      file.print(",");
      file.println(amp.analyze());
      if(max < amp.analyze()){
        max = amp.analyze();
      }
      inputcount++;
    } else {
      println(max);
      file.close();
      judge = 0;
      count = 0;
    }
  }
  
  if (judge == 3 && count == 1 || judge == 2 && count == 1) {
    objects = new ArrayList<Ball>();
    ln = 0;
  lines = loadStrings("test.csv");
 for(int i = 0; i < lines.length; i++) {
    lin = lines[i];
    String [] co = split(lin,',');
    if (co.length == 2){
      int time = int(co[0]);
      float analyze = float(co[1]);
      
      if(analyze >= max/2 && okcount > 5 && lastanalyze < analyze){
        if(eX == 0) {
              if (random(-1, 1)<=0){
                eX = -100;
              } else {
                eX = 100;
              }
            } else if(eX == -100){
              if (random(-1, 1)<=0){
                eX = 0;
              } else {
                eX = 100;
              }
            } else if(eX == 100){
              if (random(-1, 1)<=0){
                eX = 0;
              } else {
                eX = -100;
              }
            }
         objects.add(new Ball(time, eX, int(random(256)), int(random(256)), int(random(256)), false));
         okcount = 0;
        } else {
      okcount++;
     }
    lastanalyze = analyze;
    okcount++;
    visualcount =0;
    animationcount = -50;
    }
 }
  }
  
  if(judge == 2 && count > 1) {
    background(0.0, 0.0, 90.0, 100.0);
    noStroke();
    if(visualcount == 0) {
      sfl.play();
    }
    for(int i = 0; i < objects.size(); i++){
      Ball element = objects.get(i);
      //print(count);
      element.drawSomething1(visualcount);
    }
    if(visualcount >= 3 && !sfl.isPlaying()) {
      judge = 0;
      count = 0;
    }
    visualcount++;
  }
  
  if(judge == 3 && count > 1) {
    background(0.0, 0.0, 90.0, 100.0);
    stroke(5);
    strokeWeight(5);
    line(0,500,640,500);
    noStroke();
    if(animationcount == -2) {
      sfl.play();
    }
    for(int i = 0; i < objects.size(); i++){
      Ball element = objects.get(i);
      //print(count);
      element.drawSomething2(animationcount);
    }
    if(animationcount >= 3 && !sfl.isPlaying()) {
      judge = 0;
      count = 0;
    }
    animationcount++;
  }

}


void keyPressed() {
  if(judge == 0) {
    if (key == '1') {
      judge = 1;
      count = 0;
      println("file input");
    } else if (key == '2'){
      judge = 2;
      count = 0;
      println("visualization");
    } else if (key == '3'){
      judge = 3;
      count = 0;
      println("rhythm Game");
    }
  }
  
  
  
  
  
  
  
  if (key == 'j') {
    pointer = -100;
    print(pointer + "\n");
  }
  if (key == 'k') {
    pointer = 0;
    print(pointer + "\n");
  }
  if (key == 'l') {
    pointer = 100;
    print(pointer + "\n");
  }
}

void keyReleased() {
  if (key == 'j') {
    pointer = 10000;
    print(pointer + "\n");
  }
  if (key == 'k') {
    pointer = 10000;
    print(pointer + "\n");
  }
  if (key == 'l') {
    pointer = 10000;
    print(pointer + "\n");
  }
}
