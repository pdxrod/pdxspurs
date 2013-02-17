FLASH_SPAN = '<span style="color: #F94909; font-size: 15px;">'
FAKES_LINK = '<br/>'
ENDOF_SPAN = '</span><br/>'
LONG_WORDS = "Not signed up: Email should look like an email address., Email can't be blank, Email is invalid, " +
             "Password is too short (minimum is 4 characters), Password doesn't match confirmation, Password must " +
             "have an upper and lower case letter and a number, and may have punctuation, Password confirmation " +
             "is too short (minimum is 4 characters), Secret word - '' is not valid - try again"
MULTI_LINE = (LONG_WORDS.size.to_f / 2.8)

def flash_format( notice )
  flash = notice
  if flash.blank?
    flash = FAKES_LINK
  else
    flash = FLASH_SPAN + flash + ENDOF_SPAN
  end
  size = 3 - ((flash.size / MULTI_LINE).to_i + 1)
  size = 1 if size < 1
  flash += "<br/>\n" * (size - 1)
  flash
end


module ApplicationHelper

end

