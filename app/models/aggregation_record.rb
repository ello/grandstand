# frozen_string_literal: true

class AggregationRecord < ApplicationRecord
  establish_connection AGGREGATION_DB
  self.abstract_class = true
end
