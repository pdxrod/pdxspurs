source 'http://rubygems.org'

# https://gist.github.com/2515536
# Slight mistake - don't ./rails/railties/bin/rails new ...

# http://stackoverflow.com/questions/2425676/rvm-1-9-1-nokogiri
# brew install libxml2
# brew link libxml2
# gem install nokogiri -- --with-xml2-include=/usr/local/Cellar/libxml2/2.7.8/include/libxml2
#   --with-xml2-lib=/usr/local/Cellar/libxml2/2.7.8/lib --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.26
if ENV['RAILS_ENV'] == 'production'
  gem 'rails',     path: '../../edge'
  gem 'railties',  path: File.join( '../../edge', 'railties' )
else
  gem 'rails',     path: ENV['RAILS_ROOT']  
  gem 'railties',  path: File.join( ENV['RAILS_ROOT'], 'railties' )
end
gem 'journey',   github: 'rails/journey'
gem 'arel',      github: 'rails/arel'
# gem 'active_record_deprecated_finders', github: 'rails/active_record_deprecated_finders'
# gem 'active_record_deprecated_finders', github: 'markmcspadden/active_record_deprecated_finders'

gem 'will_paginate', '~> 3.0'
gem 'hpricot', '0.8.6'
gem 'libxml-ruby', '2.5.0'

gem 'authlogic', '3.2.0' # path: 'lib/authlogic' 
#                                       gem 'clearance', path: 'lib/clearance' # '1.0.0.rc4' 
gem 'mysql', '2.9.0'                   
gem 'fastimage', '1.2.13'
gem 'logger', '1.2.8'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',   github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'webrat', '0.7.3' 
  gem 'factory_girl_rails', '4.2.1'
  gem 'rspec-rails', '2.12.2'
end

gem 'jquery-rails', '2.2.0'
gem 'therubyracer', '0.11.3'

