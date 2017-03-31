class AggregationRecord < ActiveRecord::Base
  establish_connection AGGREGATION_DB
  self.abstract_class = true
end
