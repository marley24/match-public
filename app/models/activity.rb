class Activity < ApplicationRecord
  belongs_to :user
  scope :user_activities, ->(actual_user) { where(user_id: actual_user) }
  enum activity_type: { Curso: 0, Platica: 1, Post: 2 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, :english, :location, precense: true
end
