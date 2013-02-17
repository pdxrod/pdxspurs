#!/bin/sh
    rake db:migrate RAILS_ENV=test
    rake db:test:prepare
    rake test

