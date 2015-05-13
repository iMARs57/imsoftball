class Namecard < ActiveRecord::Base
	validates :name,presence:true
	validates :name,length:{minimum:5}
end
