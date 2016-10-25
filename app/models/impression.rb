class Impression < ApplicationRecord
  validates :post_id, :author_id, :created_at, presence: true
end
