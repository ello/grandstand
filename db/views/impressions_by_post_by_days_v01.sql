select
  date_trunc('day',created_at) as day
  , post_id
  , count(1) as ct
from impressions
group by 1,2
