class CreatePostsAndLists < ActiveRecord::Migration  
  
  def self.up  

   create_table "lists", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
   end

   create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.integer  "list_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "width"
    t.integer  "height"
    t.integer  "post_id"
   end

  end  
      
  def self.down  
   drop_table :lists     
   drop_table :posts 
  end  

end  


