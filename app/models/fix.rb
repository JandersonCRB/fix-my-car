class Fix < ApplicationRecord
  belongs_to :requester, :class_name => 'User'
  belongs_to :mechanical, :class_name => 'User', optional: true
  has_one :review
  # reverse_geocoded_by :latitude, :longitude

  # after_validation :reverse_geocode
end
