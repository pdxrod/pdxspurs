module UrlHelper

  def link(msg)
    str = msg.downcase
    return msg unless str.index( OBJECT ).nil?
    str = msg.dup
    pos = 0
    words = msg.split /\s+/
    words.each do |word|        
      if word.downcase.index(HREF) == 0
        pos = pos + word.length
        next
      end      
      unless word.index( /^[0-9]+px/ ).nil?
        pos = pos + word.length
        next
      end
      word.gsub! /<[^>]*>/, '' 
      word.gsub! /^(\s|&nbsp;)+|(\s|&nbsp;)+$/, '' 
      if needs_urling?(word)
        protocol = (word.index( PROTOCOL ).nil?? HTTP : '')
        link = BEGIN_HREF + protocol + word + MIDDLE_HREF + word + END_HREF
        pos = str.index(word, pos)
        str[pos, word.length] = link unless pos.nil?
        pos = pos + link.length unless pos.nil?   
      end  
    end     
    str
  end
  
  DOT = '.'
  SLASH = '/'
  ATSIGN = '@'
  ENDINGS = ['com', 'org', 'info', 'edu', 'uk', 'au', 'tv', 'gov', 'es', 'za',
  'coop', 'mil', 'biz', 'nz', 'us', 'net', 'il', 'it', 'ps', 'pn', 'de', 'fr']
  def needs_urling?(str)
    return false if str.nil?
    return false if str.blank?
    return false if str.index( DOT ).nil?
    return false if str.index( DOT ) == 0
    return false unless str.index( ATSIGN ).nil? 
    return false if str[ -1, 1 ] == DOT
    ENDINGS.each do |ending| 
      ending = DOT + ending
      pos = str.downcase.index( ending ) 
      next if pos.nil?
      len = ending.length
      return true if pos == str.length - len 
      ending = ending + SLASH
      pos = str.downcase.index( ending )
      next if pos.nil?
      return true if pos > 0
    end 
    false
  end

end

