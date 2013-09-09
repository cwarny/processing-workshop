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