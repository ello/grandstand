select
  date_trunc('day',created_at) as day
  , stream_id as email
  , count(1) as ct
from impressions
where stream_kind = 'email'
group by 1,2
