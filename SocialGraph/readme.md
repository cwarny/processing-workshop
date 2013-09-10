# How to get the data

* Go to https://developers.facebook.com/tools/explorer

* Sign in your Facebook account (if not already signed in) 

* Generate an access token

* Go on a new web page and enter the following URL:

```
https://graph.facebook.com/me?fields=friends.fields(mutualfriends,name)&access_token=ACCESS_TOKEN
```

# What should be the radius of the ring?

Assuming you want *x* pixels per friend and you have *n* friends: <br/>

Since the circumference of a circle is *2 * PI * r*, then you want *2 * PI * r = n * x* <=> *r = (n * x)/ (2 * PI)*.

# Stages of the visualization

### 1. Load data and log it

```
JSONArray json;

void setup() {
  size(displayWidth, displayHeight);
  json = loadJSONObject("my_facebook_friends.json").getJSONObject("friends").getJSONArray("data");
  println(json.getJSONObject(i).getString("name"));
}
```

### 2. Create Friend objects and populate ArrayList

```
JSONArray json;
ArrayList<Friend> friends = new ArrayList<Friend>();

void setup() {
	json = loadJSONObject("my_facebook_friends.json").getJSONObject("friends").getJSONArray("data");
	for (int i=0; i<json.size(); i++) {
    JSONObject f = json.getJSONObject(i);
    String name = f.getString("name");
    String id = f.getString("id");
    JSONArray jsonArray = f.hasKey("mutualfriends") ? f.getJSONObject("mutualfriends").getJSONArray("data") : new JSONArray();
    friends.add(new Friend(name, id, jsonArray));
}

class Friend {
  
  String name;
  String id;
  JSONArray json;
  ArrayList<Friend> friends = new ArrayList();
  
  Friend(String name, String id, JSONArray json) {
    this.name = name;
    this.id = id;
    this.json = json;
  }

}

```

### 3. Randomly render Friend objects on canvas

```
void setup() {
	for (Friend f: friends) {
  		f.pos = new PVector(random(width),random(height));
  	}
}

void draw() {
	background(0);
	for (Friend f: friends) {
		f.render();
	}
}

class Friend {

	PVector pos = new PVector();
	
	void render() {
		fill(255);
		ellipse(pos.x,pos.y,3,3);
	}

}
```

### 4.  Arrange friends in ring

```
void setup() {
  for (int i=0; i<friends.size(); i++) {
    float theta = map(i, 0, friends.size(), 0, TWO_PI);
    friends.get(i).rot = theta;
    float x = cos(theta) * radius;
    float y = sin(theta) * radius;
    friends.get(i).pos = new PVector(width/2 + x, height/2 + y);
  }
}

void draw() {
	background(0);
	for (Friend f: friends) {
		f.render();
	}
}
```

### 5.  Display name on mouseover

```
class Friend {

void render() {
	fill(255);
	ellipse(pos.x,pos.y,3,3);
	if (isMouseOver()) {
		fill(253, 141, 60);
        text(name,0,0);
	}
}

boolean isMouseOver() {
    boolean mouseOver = (mouseX > pos.x - r && mouseX < pos.x + r && mouseY < pos.y + r && mouseY > pos.y -r) ? true : false;
    return mouseOver;
  }

}
```

### 6. Rotate name

```
class Friend {

  void render() {
	pushMatrix();
	translate(pos.x,pos.y);
	rotate(rot);
	stroke(0);
	fill(255);
	ellipse(0,0,3,3);
	if (isMouseOver()) {
		fill(253, 141, 60);
        text(name,0,0);
	}
	popMatrix();
  }

}
```

### 7.  Connect friends

```
void setup() {
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

class Friend {
	ArrayList<Friend> friends = new ArrayList();
}
```

### 8.  Highlight friendships on mouseover

```
class Friend {

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
```