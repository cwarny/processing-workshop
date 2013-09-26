class Friend {

  String name;
  String id;
  JSONArray json;
  ArrayList<Friend> myFriends = new ArrayList<Friend>();
  float x;
  float y;
  float theta;
  int r = 5;

  Friend(String myName, String myId, JSONArray myJson) {
    name = myName;
    id = myId;
    json = myJson;
    x = random(width);
    y = random(height);
  }

  void render() {
    stroke(0);
    ellipse(x, y, r, r);
    if (mouseOver()) {
      fill(253, 141, 60);
      drawName();
      stroke(255, 255, 178);
      fill(255, 150);
      for (Friend f : myFriends) {
        line(x, y, f.x, f.y);
        f.drawName();
      }
    }
  }

  void connectToFriends() {
    for (int i=0; i<json.size(); i++) {
      String id = json.getJSONObject(i).getString("id");
      if (allfriends.containsKey(id)) {
        Friend f = allfriends.get(id);
        myFriends.add(f);
      }
    }
  }

  boolean mouseOver() {
    if (mouseX < x + r/2 && mouseX > x - r/2 && mouseY < y + r/2 && mouseY > y - r/2) {
      return true;
    }
    return false;
  }

  void drawName() {
    pushMatrix();
    translate(x, y);
    rotate(theta);
    text(name, 0, 0);
    popMatrix();
  }
}

