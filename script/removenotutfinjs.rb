#!/usr/bin/env ruby

# © is not UTF-8, and messes with your Rails app
# * @copyright Copyright © 2004-2008, Moxiecode Systems AB, All rights reserved.
OKLINE = " * @copyright Copyright (c) 2004-2008, Moxiecode Systems AB, All rights reserved."
REGEX = /Copyright.+Moxiecode.+Systems/i
Dir[File.join('.', "**", "*.js")].each do |path|
  text = File.read path
  text.force_encoding('binary')  
  done = ''
  text.split( "\n" ).each do |line|
    line = OKLINE if line =~ REGEX
    line = line.encode('utf-8', :invalid => :replace, :undef => :replace)
    done += line + "\n"
  end
  file = File.open( path, 'w' )
  file.write done
  file.close
end

