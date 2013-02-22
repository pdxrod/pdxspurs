class FileNamePair # See clean_up below

  attr_accessor :longname, :shortname

  def initialize(fullpath)
    @longname = fullpath
    @shortname = File.basename(fullpath)
  end

  def ==(fnp)
    fnp.is_a?(FileNamePair) and fnp.longname == @longname
  end

  def eql?(fnp)
    fnp.is_a?(FileNamePair) and fnp.longname == @longname
  end
end

class UploadController < ApplicationController

  before_filter :require_user

  def index
    render :file => UploadHelper::UPLOAD_TEMPLATE
    clean_up
  end

  def uploadfile
    begin
      p = params["p"]
      post = Post.find(p.to_i) 
      if (current_user and (DataFile.save(params["upload"], post)))
        redirect_to(:controller => '/posts', :action => p)
      else
        render :text => "There was a problem<br /><a href='/'>Home</a>"
      end
    rescue ActiveRecord::RecordNotFound
      render :text => "We have an issue<br /><a href='/posts'>Back</a>"
    end
  end

  # Delete all files which are not referred to in a post
  # Delete files until max size of files is not exceeded
  # Nullify image column in posts whose file ain't there
  def clean_up
    finished = false
    while not finished
      files = Array.new
      entries = Dir.new(DIR).entries
      entries.each do |entry|
        path = File.join(DIR, entry)
        if File.file?(path)
          files << FileNamePair.new(path)
        end
      end
      deletable = Array.new
      sz = 0
      files.each do |file|
        posts = Post.find_all_by_image(file.shortname)
        if posts.empty?
          File.delete(file.longname)  # Delete file
          deletable << file         # Remember file to delete it from array - can't
        else                      # do it here because we're in the middle of loop
          sz += File.size(file.longname)
        end
      end
      deletable.each { |file| files.delete(file) } # Remove removed files from array
      if files.size > 0 and sz > MAX_TOTAL
        file = files[files.size - 1]
        File.delete(file.longname)
        files.delete(file)
      else
        finished = true
      end
    end
    posts = Post.find(:all)
    posts.each do |post|
      if (not post.image.nil?) and # Hope FileNamePair's equality operators work
      (not files.include?(FileNamePair.new(
        File.join(DIR, post.image))))
        post.image = post.width = post.height = nil
        post.save!
      end
    end
  end

end

