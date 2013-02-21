require File.dirname( __FILE__ ) + '/../helpers/application_helper'

class User < ActiveRecord::Base

  acts_as_authentic do |c|
  end

  before_destroy { raise "You cannot delete an administrator" if self.admin? }

  ADMIN = "administrator"
  ADMIN_EMAIL = ADMIN + "@pdxspurs.com"
  VALID_PASSWORD = "Mathieu1!"
  SECRET = 'cheese'
  INVALID_EMAIL_PASSWORD_OR_SECRET = 'foo'
  MSG = " must have an upper and lower case letter and a number, and may have punctuation"
  PWD = " is not the same as password confirmation"
  WORDS = [SECRET, 'ssmp7t', 's$mp7t', '77zln', 'au968n9d', 'kel5e3', '478619', 'aak3dk', '8mn4p', 'nwmgw', 'gf34f']
  EMAIL_REG = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i # http://www.regular-expressions.info/email.html
  UPPER = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  LOWER = 'abcdefghijklmnopqrstuvwxyz'
  NUMBERS = '0123456789'
  PUNCTUATION = '!@#$%^&*()_+-=<>.{}[]|'
  VALID_CHARS = UPPER + LOWER + NUMBERS + PUNCTUATION

  has_and_belongs_to_many :roles
  has_many :lists
  has_many :posts

  # The capcha word in the image file shown on the signup page 
  attr_accessor :secret_word
  validates_format_of :email, :with => EMAIL_REG, :message => "I don't think that's a valid e-mail address"
  validate            :secret_word_validation

  def secret_word_validation
    if secret_word.nil? or ( not( WORDS.include?( secret_word.downcase )))
      @errors.add( :secret_word, " - '#{ secret_word }' is not valid - try again" )
      return false
    end
    true
  end

  def name_display
    return '' if self.admin?
    name = email.dup.downcase
    name.gsub!( '@', ' at ' )
    n = name.rindex( '.' )
    name = name[ 0 .. n - 1 ] unless n.nil?
    name	  
  end

  def name
    return '' if self.admin?
    name_display.split( ' ' )[ 0 ]
  end

  def User.find_by_id( *args )
    User.find_by( 'id', *args[ 0 ] )
  end

  def User.find_by_email( *args )
    User.find_by( 'email', *args[ 0 ] )
  end

  def User.find_by_persistence_token( *args )
    User.find_by( 'persistence_token', *args[ 0 ] ) 
  end

  def User.admin!
    User.all.each do |user|
      user.roles.each do |role|
        return user if role.rolename == User::ADMIN 
      end
    end
    nil
  end

  def admin?
    self == User.admin!
  end

  def guest?
    false
  end

end


