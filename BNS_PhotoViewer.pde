//Grace Benz
//BNS_PhotoViewer
//3.10.2013
// Master

int SCREEN_WIDTH= 1024;
int SCREEN_HEIGHT= 768;
int NUM_IMAGES = 9; 

//Center mode 
//int NAV_WIDTH = SCREEN_WIDTH/2;
//int NAV_HEIGHT = SCREEN_HEIGHT/2; 
//int NAV_X = SCREEN_WIDTH/2;
//int NAV_Y = SCREEN_HEIGHT/2; 
//float ICON_WIDTH = SCREEN_WIDTH/6;
//float ICON_HEIGHT = SCREEN_HEIGHT/6;
//String MODE = "Center";
//int MAX_ICON_SIZE = 160;
//int MIN_ICON_SIZE = 120;

//Bar mode 
int NAV_WIDTH = SCREEN_WIDTH;
int NAV_HEIGHT = SCREEN_HEIGHT/7; 
int NAV_X = SCREEN_WIDTH/2;
int NAV_Y = SCREEN_HEIGHT/2; 
float ICON_WIDTH = SCREEN_WIDTH/9;
float ICON_HEIGHT = SCREEN_HEIGHT/9;
String MODE = "Bar"; 
int MAX_ICON_SIZE = 110;
int MIN_ICON_SIZE = 90;


PImage images[]; 
Icon icons[];

boolean are_icons = false; 
boolean mouse_moved = false; 
boolean icon_clicked = false; 

boolean fade_out = false; 
boolean fade_in = false; 
int time_mouse_moved, current_img; 
int fade = 0;
float rect_fade = 0; 
int min_x, max_x, min_y, max_y;


void setup() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT, P3D); 
  smooth();

  images = new PImage[NUM_IMAGES]; //creates array of the images for backgrounds, can change number to accomodate less images
  icons = new Icon[NUM_IMAGES]; //creates array of Icon objects for the icons

  //load full size images
  for (int i = 0; i < NUM_IMAGES; i++) {

    PImage tmp = loadImage("img"+(i+1)+".jpg"); //load image from folder, can easily change pictures in folder

    if (tmp.width/1024 != tmp.height/768) { //if image is not proportional 

      if (tmp.width/tmp.height > 1.33) { 
        tmp.resize(0, 768); //set tmp height to height of window
        tmp = tmp.get(0, 0, width, tmp.height); //crop to correct proportions
      } 
      else {  
        tmp.resize(1024, 0); //set tmp width to width of window     
        tmp = tmp.get(0, 0, tmp.width, height); //crop to correct proportions
      }
    } 
    else { //already proportional
      tmp.resize(1024, 768);
    } 
    images[i] = tmp;
  }

  float icon_x; 
  float icon_y;
  int row = 1; 
  int col = 1; 
  int box = 1; 

  if (MODE == "Center") {

    //initialize icon objects 
    for (int i = 0; i < NUM_IMAGES; i++) {
      icon_x = ICON_WIDTH*col + (NAV_WIDTH - (2*ICON_WIDTH)); //x-cord of center of img
      icon_y = ICON_HEIGHT*row + (NAV_HEIGHT - (2*ICON_HEIGHT)); //y-cord of center of img
      box = (3 * (row-1)) + col; 

      Icon tmp2 = new Icon(images[i], icon_x, icon_y, MIN_ICON_SIZE, box); 

      icons[i] = tmp2; 

      if (col==3) { //end of line
        row ++; //next row
        col = 0;
      } 
      col ++; //next column
    }
  }

  else if (MODE == "Bar") {
    for (int i = 0; i < NUM_IMAGES; i++) {
      icon_x = (col * SCREEN_WIDTH/9) - ICON_WIDTH/2 ; 
      icon_y = NAV_Y; 
      box = i+1; 

      Icon tmp2 = new Icon(images[i], icon_x, icon_y, MIN_ICON_SIZE, box); 

      icons[i] = tmp2;
      col ++; 
    }
  }
  current_img = 0; //set current_img to first image
}

void draw() {
  imageMode(CENTER);

  tint(255, 75); 
  image(images[current_img], SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT); //puts current images as background



  if (are_icons == true) {
    rectMode(CENTER); 

    //mouse inactive for 3 seconds, fade icons out 
    if (float(millis()/1000 - time_mouse_moved/1000) >= 3) {
      fade_out = true; 
      fade_in = false;
    }

    //icons not there, fade icons in
    if (fade < 250 && icon_clicked == false && fade_in == true) {
      fade_in = true; 

      tint (250, fade); 
      noStroke(); 

      rect_fade = mapClamp(fade, 0, 250, 0, 200); 
      fill(10, rect_fade); //fill it, make it transparent
    }

    //mouse inactive for 3 seconds or icon just clicked, fade icons out 
    else if (fade >= 0 && fade_out == true) { 
      tint(250, fade);
      noStroke(); 

      rect_fade = mapClamp(fade, 0, 250, 0, 200); 
      fill(10, rect_fade); //fill it, make it transparent
    }
    else {
      noTint();
      fade_in = false;
      fade_out = false;
    }

    rect(NAV_X, NAV_Y, NAV_WIDTH, NAV_HEIGHT); //transparent rectangle

    //draw icons that grow as mouse approaches 
    for (int i = 0; i < NUM_IMAGES; i++) {
      float aspect = float(images[0].height)/float(images[0].width);
      float mdist = dist(icons[i].get_x(), icons[i].get_y(), mouseX, mouseY);

      float w = mapClamp(mdist, 200, 10, MIN_ICON_SIZE, MAX_ICON_SIZE);
      float h = w * aspect;

      image(images[i], icons[i].get_x(), icons[i].get_y(), w, h);
    }
    if (fade < 250 && fade_in == true) { //fading in
      if (fade == 250) { //icons have faded all the way in 
        fade_in = false;
      }

      fade +=50;
    }

    if (fade >= 0 && fade_out == true) { //fading out
      if (fade == 0) { //icons have faded all the way out 
        are_icons = false;
        fade_out = false;
      }

      mouse_moved = false;
      fade -= 50; 
      noTint();
    }
  }
  icon_clicked = false;
}

float mapClamp(float value, float istart, float istop, float ostart, float ostop) {
  float r = map(value, istart, istop, ostart, ostop);
  if (ostart < ostop) {
    if (r < ostart) return ostart;
    if (r > ostop) return ostop;
  } 
  else {
    if (r > ostart) return ostart;
    if (r < ostop) return ostop;
  }
  return r;
}

void mouseMoved() {
  // if mouse movement interrupts icon while fading out 
  if (fade_out == true) {
    fade_out = false;
  }
  are_icons = true; 
  time_mouse_moved = millis();
  fade_in = true;
}

void mousePressed() {
  for (Icon icon : icons) {

    if (icon.mouse() == "on" && are_icons == true) { 
      current_img = icon.box()-1; 
      fade = 250;
      rect_fade = 200; 

      fade_out = true; 
      mouse_moved = false; //so don't redraw thumbnail interface 
      icon_clicked = true;
    }
  }
}

