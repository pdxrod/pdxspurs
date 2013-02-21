# Thanks http://snippets.dzone.com/posts/show/805 for size algorithm
# ...except it doesn't work in Ruby 1.9... instead, thanks to
# http://stackoverflow.com/questions/2450906/is-there-a-simple-way-to-get-image-dimensions-in-ruby
# ...see comment by Alan W Smith on 'FastImage'

require 'fastimage' 

NUMBER_OF_THE_BEAST = 0666

class DataFile < ActiveRecord::Base

  def self.create(original, poster)
    path = File.join(ApplicationHelper::POSTERS, original)
    file = File.open(path, File::RDONLY)    
    sz = self.handle(path, file.read)    
    if sz.size > 1
      poster.image = original
      poster.width = sz [0]
      poster.height = sz[1]
      poster.save!
      return true
    else
      return false
    end      
  end

  def self.save(upload, post)
    original = upload['datafile'].original_filename
    path = File.join(ApplicationHelper::DIR, original)
    str = upload['datafile'].read
    flag = 'wb'
    File.open(path, flag) { |f| f.write(str) }
    File.chmod(NUMBER_OF_THE_BEAST, path)
    sz = self.handle(path, str)    
    if sz.size > 1
      post.image = original
      post.width = sz[0]
      post.height = sz[1]
      post.save!
      return true
    else
      return false
    end
  end

  def self.handle(filepath, contents)
    if   contents.size < ApplicationHelper::MAX_FILE_SIZE  \
     and contents.size > ApplicationHelper::MIN_FILE_SIZE  \
     and filepath.downcase =~ /.jpg$|.jpeg$|.bmp$|.png$|.gif$/
      return self.size(filepath, contents) 
    else 
      File.delete(filepath)
      return []
    end
  end
 
# Returns array [width, height] or empty array for invalid file/name
  def self.size(filepath, contents)
    a = FastImage.size( filepath ) 
    a[0] = a[1] = 200 if a.size > 1 and (a[1] < 1 or a[0] < 1)
    self.proportion(a) 
  end

  def self.proportion(a)
    return [] if a.size < 2
    p = 200.0 / a[0].to_f
    b = [ a[0], a[1] ]
    b[0] = 200
    b[1] = b[1].to_f * p
    b[1] = b[1].to_i
    b
  end
 
end


