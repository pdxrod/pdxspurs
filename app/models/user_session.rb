class UserSession < Authlogic::Session::Base

  attr_accessor :secret_word 

  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  def persisted?
    false
  end

end  


