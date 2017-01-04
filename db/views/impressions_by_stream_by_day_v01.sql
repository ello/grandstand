select
  date_trunc('day',created_at) as day
  , stream
  , count(1) as ct
from impressions
group by 1,2
