HashMap<String, Friend> allfriends = new HashMap<String, Friend>();
float radius = 250;

void setup() {
  size(840, 600);

  JSONObject json = loadJSONObject("data.json");
  JSONObject friends = json.getJSONObject("friends");
  JSONArray data = friends.getJSONArray("data");

  for (int i=0; i<data.size(); i++) {
    String name = data.getJSONObject(i).getString("name");
    String id = data.getJSONObject(i).getString("id");
    JSONArray mutualfriends = new JSONArray();
    if (data.getJSONObject(i).hasKey("mutualfriends")) {
      mutualfriends = data.getJSONObject(i).getJSONObject("mutualfriends").getJSONArray("data");
    }
    Friend f = new Friend(name, id, mutualfriends);
    allfriends.put(id, f);
  }

  for (Friend f : allfriends.values()) {
    f.connectToFriends();
  }

  int n = 0;
  for (Friend f : allfriends.values()) {
    float theta = map(n, 0, allfriends.size(), 0, TWO_PI);
    float x = cos(theta) * radius;
    float y = sin(theta) * radius;
    f.x = width/2 + x;
    f.y = height/2 + y;
    f.theta = theta;
    n++;
  }
}

void draw() {
  background(0);
  for (Friend f : allfriends.values()) {
    f.render();
  }
}

