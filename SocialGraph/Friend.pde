class Friend {

  String name;
  String id;
  JSONArray json;
  ArrayList<Friend> myFriends = new ArrayList<Friend>();
  float x;
  float y;
  float theta;
  int d = 5;

  Friend(String myName, String myId, JSONArray myJson) {
    name = myName;
    id = myId;
    json = myJson;
    connectToFriends();
  }

  void render() {
    stroke(0);
    fill(255);
    ellipse(x, y, d, d);
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
    if (mouseX < x + d/2 && mouseX > x - d/2 && mouseY < y + d/2 && mouseY > y - d/2) {
      return true;
    }
    return false;
  }

  void drawName() {
    pushMatrix();
    translate(x, y);
    rotate(theta);
    text(name, 5, 0);
    popMatrix();
  }
}

