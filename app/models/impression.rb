class Impression < ApplicationRecord
  include TransactionSkipping

  validates :post_id, :author_id, :created_at, presence: true
end
