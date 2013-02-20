class List < ActiveRecord::Base
  belongs_to :user
  has_many :posts
  validates_length_of :title, :within => 1..TITLE_LENGTH
  
 #  mysql
 #  delimiter //
 #  DROP PROCEDURE IF EXISTS list_title //
 #  CREATE PROCEDURE list_title(IN list_id INT(11), OUT lt VARCHAR(40))
 #  READS SQL DATA
 #  BEGIN
 #    SELECT title into lt FROM lists where id = list_id;   
 #  END
 #  //
 #  DROP FUNCTION IF EXISTS title_of_list //
 #  CREATE FUNCTION title_of_list(list_id INT(11))
 #  RETURNS VARCHAR(40)
 #  BEGIN
 #    DECLARE t VARCHAR(40);
 #    CALL list_title(list_id, t);
 #    RETURN t;
 #  END
 #  //
 #  delimiter ;
  def get_list_title
    p = connection.select_value "select title_of_list("+id.to_s+")"
    p.to_s 
  end    

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

