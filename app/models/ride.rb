class Ride < ActiveRecord::Base
  default_scope order('date DESC')
  belongs_to :rider, class_name: "User"

  validates :date, presence: true
  validates :distance, presence: true, :numericality => { :greater_than => 0 }
  validates :rider, presence: true

  attr_accessible :date, :description, :distance, :rider_id, :is_round_trip
end
