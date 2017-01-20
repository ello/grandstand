select
  date_trunc('day',created_at) as day
  , stream_id as category
  , count(1) as ct
from impressions
where stream_kind = 'category'
group by 1,2
