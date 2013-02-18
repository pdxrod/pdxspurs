FactoryGirl.define do

  sequence :word do 
    "name"+"#{Time.now.to_f.to_s.gsub( '.', 'f' )}".shuffle
  end

  sequence :email_address do
    "me" + "#{Time.now.to_f.to_s.gsub( '.', '1' )}".shuffle + "@pdxspurs.com"
  end

  factory :user do
    email { generate( :email_address ) }
    secret_word User::SECRET
    password User::VALID_PASSWORD
    password_confirmation User::VALID_PASSWORD
  end

end




