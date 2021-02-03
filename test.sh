#!/bin/bash
export RAILS_ENV=test
rails db:drop
rails db:create
rails test --verbose --warnings --backtrace
