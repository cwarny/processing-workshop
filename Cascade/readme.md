# Stages of the visualization

### 1. Load data and log it

```
void setup() {
	JSONArray tweetsTree = loadJSONArray("tweets.json");
	println(tweetsTree);
}
```

### 2. Creation of root tweets

```
ArrayList<Tweet> rootTweets = new ArrayList();

void setup() {
	JSONArray tweetsTree = loadJSONArray("tweets.json");
	for (int i=0; i<tweetsTree.size(); i++) {
		rootTweets.add(new Tweet(tweetsTree.getJSONObject(i)));
	}
}

class Tweet {

	int id;
  	String user;
	int followers_count;
	String text;

	Tweet(JSONObject tweet) {
	    id = tweet.getInt("id");
    	text = tweet.getString("text");
	    user = tweet.getJSONObject("user").getString("screen_name");
    	followers_count = tweet.getJSONObject("user").getInt("followers_count");
    }
    
}
```

### 3. Recursive creation of tweets

```
class Tweet {

	ArrayList<Tweet> children = new ArrayList();

	Tweet(JSONObject tweet) {
	    if (tweet.hasKey("children")) {
	    	for (int i=0; i<tweet.getJSONArray("children").size(); i++) {
	    		children.add(new Tweet(tweet.getJSONArray("children").getJSONObject(i)));
	    	}
    	}
	}

}
```

### 4. Introducing time

```
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.Locale;

class Tweet {

	SimpleDateFormat dateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss +0000 yyyy", Locale.ENGLISH);
  	Date created_at;
  
  	Tweet(JSONObject tweet) {
  		// Java forces you to handle exceptions
    	try {
      		created_at = dateFormat.parse(tweet.getString("created_at"));
    	} catch (ParseException pe) {
      		pe.printStackTrace();
    	}
  	}

}
```

### 5. Positioning and chart scales

Being able to position the objects on the screen requires to:

- Define the X and Y axes
- Set a scale for each axis (requires knowing the domain and the range for X and Y)
- Map each object's X and Y values into the scale

```
import java.util.Date;

Date minDate = new Date(2013-1900,7,27,11,39);
Date maxDate = new Date(0,0,1);
int maxDepth = MIN_INT;

class Tweet {

	int storyDepth;
	PVector pos;

	Tweet(JSONObject tweet, int depth) {
		depth++;
		storyDepth = depth;
		
		if (tweet.hasKey("children")) {
			for (int i=0; i<tweet.getJSONArray("children").size(); i++) {
				children.add(new Tweet(tweet.getJSONArray("children").getJSONObject(i), depth));
			}
    	}
    	
    	if (created_at.after(maxDate)) {
      		maxDate = created_at;
    	}
    	if (storyDepth > maxDepth) {
      		maxDepth = storyDepth;
    	}
    	if (followers_count > maxFollowersCount) {
      		maxFollowersCount = followers_count;
    	}
	}
	
	void setPosition() {		
		float posX = map(created_at.getTime(), minDate.getTime(), maxDate.getTime(), 0, width);
		float posY = map(storyDepth, 0, maxDepth, height, 0);
		pos = new PVector(posX,posY);
		
		for (Tweet child : children) {
			child.setPosition();
    	}
  	}

}
```

### 6. Render

```
class Tweet {

	void render() {
		fill(44,127,184);
        ellipse(pos.x,pos.y,3,3);	
        for (Tweet child : children) {
        	stroke(230,230,230,220);
        	strokeWeight(0);
        	line(pos.x,pos.y,child.pos.x,child.pos.y);
      	}
      	
      	for (Tweet child : children) {
      		child.render();
    	}
	}

}
```

### 7. Time-based rendering

Time is a new dimension. Let's set the timing of the object like we set position. The object should only appear on the canvas when it's his time.

```
class Tweet {

	float timing;
	
	void setTiming() {
    	timing = map(created_at.getTime(), minDate.getTime(), maxDate.getTime(), 0, 500);
    
    	for (Tweet child : children) {
      		child.setTiming();
    	}
  	}
  	
  	void render() {
  		if (timing < frameCount) {
			fill(44,127,184);
        	ellipse(pos.x,pos.y,8,8);	
        	for (Tweet child : children) {
        		stroke(230,230,230,220);
        		strokeWeight(0);
        		if (child.timing < frameCount) line(pos.x,pos.y,child.pos.x,child.pos.y);
      		}
      	}
      	
      	for (Tweet child : children) {
      		child.render();
    	}
	}
	
}
```

### 8. Continuous movement

Show new tweets being *ejected* either from the origin (root tweets) or from other tweets (replies or retweets). For that each tweet needs to have a *starting* position and a *target* position.

```
class Tweet {

	PVector pos,tpos;
	
	void setPosition(float parentX) {
		float posX = parentX;
    	float posY = map(storyDepth-1, 0, maxDepth, height, 0);
    	pos = new PVector(posX,posY);
		
		float tposX = map(created_at.getTime(), minDate.getTime(), maxDate.getTime(), 0, width);
		float tposY = map(storyDepth, 0, maxDepth, height, 0);
		tpos = new PVector(tposX,tposY);
		
		for (Tweet child : children) {
			child.setPosition(tposX);
    	}
  	}
  	
  	void update() {
    	if (timing < frameCount) {
      		pos.lerp(tpos,0.1);
      		for (Tweet child : children) {
        		child.update();
      		}
    	}
  	}

}
```

### 9. Symbolize the type of tweet

```
class Tweet {

	int s = 8;

	Tweet(JSONObject tweet, int depth) {
		isReply = !tweet.hasKey("in_reply_to_status_id") || tweet.isNull("in_reply_to_status_id") ? false : true;
    	isRetweet = tweet.hasKey("retweeted_status");
	}
	
	void render() {
    	if (timing < frameCount) {
        	noStroke();
        	rectMode(CENTER);
        	if (isRetweet) {
          		fill(189,0,38);
          		rect(pos.x,pos.y,s,s);
	        } else if (isReply) {
    	      	fill(49,163,84);
        	  	triangle(pos.x-s/2,pos.y+s/(2*sqrt(3)),pos.x,pos.y-s/sqrt(3),pos.x+s/2,pos.y+s/(2*sqrt(3)));
        	} else {
          		fill(44,127,184);
	          	ellipse(pos.x,pos.y,s,s);
    	    }
      
      		for (Tweet child : children) {
      			stroke(230,230,230,220);
	        	strokeWeight(0);
    	    	if (child.timing < frameCount) line(pos.x,pos.y,child.pos.x,child.pos.y);
      		} 
    	}
    	for (Tweet child : children) {
      		child.render();
    	}
  	}

}
```