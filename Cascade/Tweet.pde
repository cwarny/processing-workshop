import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.Locale;

class Tweet {
  
  int storyDepth;
  int id;
  String user;
  int followers_count;
  SimpleDateFormat dateFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss +0000 yyyy", Locale.ENGLISH);
  Date created_at;
  float timing;
  String text;
  boolean isReply, isRetweet;
  ArrayList<Tweet> children = new ArrayList();
  
  PVector pos,tpos;
  int s = 8; // Size of the rendered shape symbolizing the type of tweet
  
  Tweet(JSONObject tweet, int depth) {
    depth++;
    storyDepth = depth;
    id = tweet.getInt("id");
    text = tweet.getString("text");
    user = tweet.getJSONObject("user").getString("screen_name");
    followers_count = tweet.getJSONObject("user").getInt("followers_count");
    
    // Java forces you to handle exceptions
    try {
      created_at = dateFormat.parse(tweet.getString("created_at"));
    } catch (ParseException pe) {
      pe.printStackTrace();
    }
    isReply = !tweet.hasKey("in_reply_to_status_id") || tweet.isNull("in_reply_to_status_id") ? false : true;
    isRetweet = tweet.hasKey("retweeted_status");
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
  
  void setTiming() {
    timing = map(created_at.getTime(), minDate.getTime(), maxDate.getTime(), 0, 500);
    
    for (Tweet child : children) {
      child.setTiming();
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
  
  void render() {
    if (timing < frameCount) {
      pushMatrix();
        translate(pos.x,pos.y);
        noStroke();
        rectMode(CENTER);
        if (isRetweet) {
          fill(189,0,38);
          rect(0,0,s,s);
        } else if (isReply) {
          fill(49,163,84);
          triangle(-s/2,s/(2*sqrt(3)),0,-s/sqrt(3),s/2,s/(2*sqrt(3)));
        } else {
          fill(44,127,184);
          ellipse(0,0,s,s);
        }
        
      popMatrix();
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
