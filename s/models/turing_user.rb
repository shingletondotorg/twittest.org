class TuringUser < ActiveRecord::Base
  attr_accessible :name
  has_many :microposts
end

# == Schema Information
#
# Table name: turing_users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

