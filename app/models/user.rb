class User < ActiveRecord::Base

  acts_as_authentic do |c|
  end

  ADMIN = "administrator"
  ADMIN_EMAIL = ADMIN + "@pdxspurs.com"
  VALID_PASSWORD = "Mathieu1!"
#  CRYPTED_PASSWORD = "a5298bd02390f6ad9c312141c1fe823d7c1382f878b323e9f45d467ffe1842b887b18ff18e72246628993edc653ab121b7505627c5d758296bd625a0a5eab8b9"
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

  # The capcha word in the image file shown on the signup page to prevent spider spam bot script kiddie trolls 
  attr_accessor :secret_word
  validates_format_of :email, :with => EMAIL_REG, :message => "I don't think that's a valid e-mail address"

end


