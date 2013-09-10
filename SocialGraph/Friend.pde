class Friend {
  
  String name;
  String id;
  JSONArray json;
  ArrayList<Friend> friends = new ArrayList();
  
  PVector pos = new PVector();
  
  float rot = 0;
  
  int r = 3;
  
  Friend(String name, String id, JSONArray json) {
    this.name = name;
    this.id = id;
    this.json = json;
  }
  
  void render() {
    pushMatrix();
      translate(pos.x,pos.y);
      rotate(rot);
      stroke(0);
      fill(255);
      ellipse(0,0,r,r);
      if (isMouseOver()) {
        fill(253, 141, 60);
        text(name,0,0);
      }
      if (isFriendMouseOver()) {
        fill(255,150);
        text(name,0,0);
      }
    popMatrix();
    if (isMouseOver()) {
      for (Friend f: friends) {
        stroke(255, 255, 178);
        line(pos.x,pos.y,f.pos.x,f.pos.y);
      }
    }
  }
  
  boolean isMouseOver() {
    boolean mouseOver = (mouseX > pos.x - r && mouseX < pos.x + r && mouseY < pos.y + r && mouseY > pos.y -r) ? true : false;
    return mouseOver;
  }
  
  boolean isFriendMouseOver() {
    boolean friendMouseOver = false;
    for (Friend f: friends) {
      if (f.isMouseOver()) {
        friendMouseOver = true;
        break;
      }
    }
    return friendMouseOver;
  }
  
}
