class Review < ApplicationRecord
  belongs_to :fix

  def owner
  	self.fix.requester
  end
end
