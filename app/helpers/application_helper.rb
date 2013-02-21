module ActiveRecord
  class Base
  # Overcomes 'wrong no. of arguments' error in Rails 4 beta
    def Base.find_by( column, value )
      table = name.downcase.pluralize
      cLass = name.constantize
      results = cLass.find_by_sql( "select * from #{table} where #{column} = '#{value}'" )
      return nil if results.size < 1
      raise "#{column} = '#{value}' is not unique in #{table}" if results.size > 1
      results[ 0 ]
    end
  end
end

FLASH_SPAN = '<span style="color: #F94909; font-size: 15px;">'
POSTS_LINK = '<br/>'
ENDOF_SPAN = '</span><br/>'
LONG_WORDS = "Not signed up: Email should look like an email address., Email can't be blank, Email is invalid, " +
             "Password is too short (minimum is 4 characters), Password doesn't match confirmation, Password must " +
             "have an upper and lower case letter and a number, and may have punctuation, Password confirmation " +
             "is too short (minimum is 4 characters), Secret word - '' is not valid - try again"
MULTI_LINE = (LONG_WORDS.size.to_f / 2.8)

ADD_MESSAGE = "Add message to this thread"
COMMENT = "Comment on this message"
NEWS_TITLE = '<b>The latest football news from</b> <a href="http://www.guardian.co.uk/open-platform">the Guardian open platform Ruby API</a>'
LOGIN_BUTTON = " Click to log in "
SAVE_BUTTON = " Save "
CLICK_HERE = " Click here "
SEARCH_BUTTON = " Then click here "
SIGNUP_BUTTON = " Click here "
CREATE_BUTTON = " Create "
CREATE_THREAD = " Create new thread "
MUST_BE_USER = "You must be logged in to access the page you tried to see" 
MUST_BE_ADMIN = "Administrators only" 
SMALL = 50
LARGE = 250
URL_SIZE = 200
TEXT_FIELD_SIZE = 128
NUM_PER_PAGE = (ENV['RAILS_ENV'] == 'production' ? 51 : 7) 
DATE_REG = /\A[A-Z][a-z].+ [0-9]+.+[0-9].\Z/
INT_DATE_MSG = "(yyyy-mm-dd)"
USA_DATE_MSG = "(mm/dd/yyyy)"
PAGE_SIZE = 20
TITLE_LENGTH = 75
TITLE_REG = /[^A-Za-z0-9]/
MSG_WIDTH = 60
MSG_HEIGHT = 30
MSG_MIN = 20
MSG_MED = 40 
MSG_MAX = MSG_MIN * MSG_MED

class Hash

  def revert
    hash_new = Hash.new
    self.each { |key, value|
      if not hash_new.has_key?(key) then
        hash_new[value] = key
      end
    }
    return hash_new
  end

  KEYS = ['-', '=', '~', '_', '+', '#']
  def recurse(pr=false, n=0, key='')
    str = "\n"
    spaces = ' ' * 2 * (1 + n)
    each do |k, v|
      if v.is_a? Hash
        str += v.recurse(pr, n + 1, k)
      else
        s = "#{k}"
        s = ":#{s}" if k.is_a? Symbol
        pointer = KEYS[ n % KEYS.size ]
        first = (key == '' ? '' : "#{key} #{pointer}>")
        str += "#{spaces}#{first} #{s} #{pointer}> #{v}"
      end
    end
    puts str + "\n" if (n == 0) and pr
    str
  end

  def recurse!
    recurse true
  end

  @@hash = { }
  def squish( n = 0 )
    @@hash = { } if n == 0
    each do |k, v|
      if v.is_a? Hash
        v.squish( n + 1 )
      else
        @@hash[ k ] = v
      end
    end
    @@hash 
  end

end

class String

  def short
    num = SMALL / 2
    return self if self.size < num
    self[ 0 .. num-1 ] + '...'
  end

  def shuffle
    m = []
    u = ''

    until u.size == self.size
      n = rand(self.size)
      unless m.include? n
        m << n
        u << self[n]
      end
    end

    u
  end

  def shuffle!
    u = self.shuffle
    u.size.times { |t| self[t..t] = u[t..t] }
  end

# http://stackoverflow.com/questions/862140/hex-to-binary-in-ruby
  def hex_2_bin
    raise "Empty string is not a valid hexadecimal number" if self.size < 1
    hex = self.upcase.split( '' )
    hex.each { |ch| raise "#{self} is not a hexadecimal number" unless "ABCDEF0123456789".include? ch }
    hex = self.upcase
    hex = '0' + hex if((hex.length & 1) != 0)
    hex.scan(/../).map{ |b| b.to_i(16) }.pack('C*')
  end

  def bin_2_hex
    self.unpack('C*').map{ |b| "%02X" % b }.join('')
  end

  def to_b # || ! to_b 
    return nil if self.strip.empty?
    return false if self.downcase.starts_with? 'f'
    return false if self == '0' # the opposite of Ruby
    return true if self.downcase.starts_with? 't'
    return true if self == '1'
    nil
  end

end

class NilClass
  def short
    self
  end

  def to_b
    false
  end
end

def can_change?( model ) # e.g. was this report entered by this user or admin? (otherwise they can't edit or delete it)
  return false unless current_user
  return true if current_user.admin?
  id = (model.class == User ? model.id : model.user_id) # Users don't have user ids, they just have ids, coz they're users
  id == current_user.id
end

def can_delete?( model )
  return false unless current_user
  current_user.admin?
end

def flash_errs( model )
  if model.errors.empty?
    errs = ''
  else
    errs = model.errors.full_messages.join(', ')
  end

  flash[:notice] = errs
  errs
end

def flash_format( notice )
  flash = notice
  if flash.blank?
    flash = POSTS_LINK
  else
    flash = FLASH_SPAN + flash + ENDOF_SPAN
  end
  size = 3 - ((flash.size / MULTI_LINE).to_i + 1)
  size = 1 if size < 1
  flash += "<br/>\n" * (size - 1)
  flash
end

module ApplicationHelper

  def date_string(date_time)
    str = date_time.month.to_s
    str = '0' + str if str.length < 2
    str + '/' + date_time.day.to_s + '/' + date_time.year.to_s
  end

  def guardian_results
    Guardian::results
  end

end

