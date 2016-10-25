<img src="http://d324imu86q1bqn.cloudfront.net/uploads/user/avatar/641/large_Ello.1000x1000.png" width="200px" height="200px" />

# Grandstand
Service for efficiently counting impressions

## Design Goals

One of Ello's key features is the post view counter - the little number next to the eye icon in post tools that gives users an estimate of how many times that post has been served up to a user.

It provides a number of functions within the product itself:

- Giving users positive feedback on the work they post to Ello
- Creating a virtuous cycle of feedback in situations where comments and reposts may be disabled (mitigating the feeling of "posting into the void")
- Providing a sense of progression for users as they continue to engage on Ello and get exposure through more channels (categories, etc.)

From a practical perspective, we make use of a post's view count in a few ways: 

- We display the view count for an individual post in the UI
- We aggregate view counts by date to generate a high-level post impressions metric

### Current State

Our current-generation post view counter makes use of two independent paths for displaying view counts on individual posts and reporting them for analysis.

The display path keeps track of the views on an individual post using a simple Redis counter. Each time a post is returned in an API response up, a job is enqueued that performs an atomic Redis `INCR` operation on the key for that post. Each time the post count is accessed, we just pull the current values of the relevant counters from Redis with an `MGET` operation. The individual `INCR`s are fast, and the number of posts pulled in a single go via `MGET` is typically on the order of 10-25, which is also speedy enough for our request serving use cases.

The analysis path keeps track of the views by sending them through Segment and on into Amazon Redshift, where we can slice and dice them by date, user, and post dimensions. We do this one the server side using Segment's Ruby client library, called via a Sidekiq background job.

#### Limitations

From the display side, since the post-level view counter is a simple scalar value, it cannot be decomposed and analyzed on multiple dimensions (e.g. how many views has a particular user made, how frequently is a post viewed over time, etc.). Due to the nature of Redis's counters, querying counters across multiple posts can be costly, especially when aggregating large numbers of posts (since `MGET` is a [O(N) operation](http://redis.io/commands/mget).

In addition, keeping that many discrete counters in a single Redis instance is starting to become something of a bottleneck for us. While each counter is comparatively small, it exists for every single post/comment, which is a (not huge but not trivial) storage load.

From the analytics side, the primary limitation is cost, as each individual view is billed as a separate event. Given that any request for content will return 10+ posts, these events swamp all others in frequency, by an order of magnitude or more.


### New State

- Stream raw event data for post impressions via Kinesis from the Mothership (our main Rails app)
- Store impressions in a local database

In the future:
- Aggregate counts by dimensions of day, author, user, and post in fast storage
- Potentially checkpoint counts by date/time of last processed event (not sure
  if this is necessary for transition or not)
- Provide an API for the same, including multi-GETing for efficient retrieval:
  - GET /v1/users/:ids  # Aggregate view count across all of individual user's posts. Multi-get for multiple IDs
  - GET /v1/posts/:ids  # View count for an individual post. Multi-get for multiple IDs.

## Quickstart

This is a vanilla Rails 5 (API) application, so getting it started is fairly
standard:

* Install RVM/Rbenv/Ruby 2.3
* Install PostgreSQL (9.4 or newer) if you don't have it already
* Clone this repo
* Run `bundle install` and `bundle exec rake db:setup`
* Fire up the API server with `bundle exec rails server`
* Run the test suite with `bundle exec rake`

##### Deployment, Operations, and Gotchas

The app is pre-packaged for deployment on Heroku, so it should work to fork and
re-push to your own Heroku remote after you create an app. A couple of caveats:

- You'll need to provision a Redis instance as
  [kinesis-stream-reader](https://github.com/ello/kinesis-stream-reader) assumes
  that one will be available to store its local state.
- You'll need an appropriately-sized Postgres DB addon (though a basic one
  should be there for you by default)
- You'll need to specify the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`,
  `AWS_REGION`, and `KINESIS_STREAM_NAME` environment variables

## License
Streams is released under the [MIT License](blob/master/LICENSE.txt)

## Code of Conduct
Ello was created by idealists who believe that the essential nature of all human beings is to be kind, considerate, helpful, intelligent, responsible, and respectful of others. To that end, we will be enforcing [the Ello rules](https://ello.co/wtf/policies/rules/) within all of our open source projects. If you don’t follow the rules, you risk being ignored, banned, or reported for abuse.
