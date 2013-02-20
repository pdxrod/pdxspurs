class List < ActiveRecord::Base

  belongs_to :user
  has_many :posts
  validates_length_of :title, :within => 1..TITLE_LENGTH
  
  def title_display
    msg = title.gsub(/<[^>]*>/, '')
    msg = msg.gsub(/\&.*\;/, '      ')
    msg = msg.gsub(/\n/, ' ')
    return msg if title.size < MSG_MAX / 2 
    msg = msg[0 .. MSG_MAX / 2]
    msg = msg + "..." if title.size > 1 + MSG_MAX / 2
    return msg  
  end
  
end

