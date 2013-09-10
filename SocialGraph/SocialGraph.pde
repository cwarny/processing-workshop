JSONArray json;
ArrayList<Friend> friends = new ArrayList<Friend>();
float radius = 250;

void setup() {
  size(displayWidth, displayHeight);
  json = loadJSONObject("my_facebook_friends.json").getJSONObject("friends").getJSONArray("data");
  createFriends(json);
  connectFriends();
  positionFriends();
}

void draw() {
  background(0);
  for (Friend f: friends) {
    f.render();
  }
}

void createFriends(JSONArray json) {
  for (int i=0; i<json.size(); i++) {
    JSONObject f = json.getJSONObject(i);
    String name = f.getString("name");
    String id = f.getString("id");
    JSONArray jsonArray = f.hasKey("mutualfriends") ? f.getJSONObject("mutualfriends").getJSONArray("data") : new JSONArray();
    friends.add(new Friend(name, id, jsonArray));
  }
}

void connectFriends() {
  for (Friend f1: friends) {
    for (int i=0; i<f1.json.size(); i++) {
      for (Friend f2: friends) {
        if (f2.id.equals(f1.json.getJSONObject(i).getString("id"))) {
          f1.friends.add(f2);
        }
      }
    }
  }
}

void positionFriends() {
  for (int i=0; i<friends.size(); i++) {
    float theta = map(i, 0, friends.size(), 0, TWO_PI);
    friends.get(i).rot = theta;
    float x = cos(theta) * radius;
    float y = sin(theta) * radius;
    friends.get(i).pos = new PVector(width/2 + x, height/2 + y);
  }
}
