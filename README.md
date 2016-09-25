# Grandstand
Service for efficiently counting views

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

The display path keeps track of the views on an individual post using a simple Redis counter. Each time a post is returned in an API response up, a job is enqueued that performs an atomic Redis `INCR` operation on the key for that post. Each time the post count is accessed, we just pull the current values of the relevant counters from Redis with an `MGET` operation.

The analysis path keeps track of the views by sending them through Segment and on into Amazon Redshift, where we can slice and dice them by date, user, and post dimensions.
