class Icon {
  PImage icon;
  float x, y, th;
  int box_ID, tmp_width, icon_width; 
  float min_x, max_x, min_y, max_y;  
  PImage current; 


  Icon(PImage img, float x_, float y_, float wid_, int box_) {
    //a simple class that defines an Icon object

    icon = img.get(); 
    x = x_;
    y = y_; 
    icon_width = int(wid_); 
    box_ID = box_; 
    current = icon; 

    icon.resize(int(icon_width), 0);
  }


  void display() {
    imageMode(CENTER);
    image(icon, x, y);
  }


  int box() {
    return box_ID;
  }

  float get_x() {
    return x;
  }

  float get_y() {
    return y;
  } 

  void set_width(int new_width) {
    icon.width = new_width;
  }

  void set_height(int new_height) {
    icon.height = new_height;
  }

  int get_width() {
    return int(icon.width);
  }

  int get_height() {
    return int(icon.height);
  }

  PImage get_img() {
    return icon;
  }

  String mouse() {
    //checks location of the mouse 
    min_x = x - get_width()/2;
    max_x = x + get_width()/2;
    min_y = y - get_width()/2;
    max_y = y + get_width()/2;

    if (mouseX > min_x && mouseX < max_x && mouseY > min_y && mouseY < max_y) {
      return "on";
    } 
    else if (mouseX + 10 > min_x && mouseX - 10 < max_x && mouseY + 10 > min_y && mouseY - 10 < max_y) {
      return "near";
    } 
    else {
      return "far";
    }
  }
}

