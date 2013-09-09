// For choosing colors: http://colorbrewer2.org

import java.util.Date;

ArrayList<Tweet> rootTweets = new ArrayList();
Date minDate = new Date(2013-1900,7,27,11,39); // See http://stackoverflow.com/questions/9751050/simpledateformat-subclass-adds-1900-to-the-year for an explanation about the Java Date constructor
Date maxDate = new Date(0,0,1);
int maxFollowersCount = MIN_INT;
int maxDepth = MIN_INT;

void setup() {
  size(962,502);
  
  JSONArray tweetsTree = loadJSONArray("tweets.json");
  for (int i=0; i<tweetsTree.size(); i++) {
    rootTweets.add(new Tweet(tweetsTree.getJSONObject(i), 0));
  }
  
  for (Tweet t : rootTweets) {
    t.setPosition(0);
    t.setTiming();
  }
}

void draw() {
  background(0);
  
  for (Tweet t : rootTweets) {
    t.update();
    t.render();
    stroke(230,230,230,100);
    strokeWeight(0);
    if (t.timing < frameCount) line(0,height,t.pos.x,t.pos.y);
  }
  drawTimeAxis();
  drawTimeArrow();
}

void drawTimeAxis() {
  long timeInterval = maxDate.getTime() - minDate.getTime();
  int days = int(timeInterval / 86400000); // There are 86,400,000 milliseconds in a day
  for (int i=1; i<=days; i++) {
    float x = map(i, 0, days, 0, width);
    float y = height - 10;
    stroke(255,200);
    strokeWeight(1);
    line(x, y, x, height);
    fill(237,248,251);
    textAlign(CENTER, BOTTOM);
    text("+" + str(i) + " day(s)", x, y);
  }
}

void drawTimeArrow() {
  float x = map(frameCount, 0, 500, 0, width);
  stroke(255,100);
  strokeWeight(0);
  line(x, 0, x, height);
}
