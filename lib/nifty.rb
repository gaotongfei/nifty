require 'nifty/version'
require 'nifty/relation_methods'
require 'nifty/result'
require 'nifty/result_handler'
require 'nifty/inspector'
require 'active_record'

module Nifty
  class Error < StandardError; end
  # Your code goes here...
end

ActiveRecord::Relation.send(:include, Nifty::RelationMethods)
