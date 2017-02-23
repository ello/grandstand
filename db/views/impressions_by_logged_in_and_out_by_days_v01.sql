select
  date_trunc('day',created_at) as day
  , sum(
        case
          when viewer_id is not null
            then 1
          else 0
        end
      ) as logged_in
  , sum(
        case
          when viewer_id is null
            then 1
          else 0
        end
      ) as logged_out
  , count(1) as "Post Views/Day"
from impressions
group by 1
