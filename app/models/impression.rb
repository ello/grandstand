class Impression < ApplicationRecord
  include TransactionSkipping

  scope :between, ->(s, f) { where('created_at >= ? AND created_at <= ?', s, f) }
end
