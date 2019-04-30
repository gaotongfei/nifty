# frozen_string_literal: true

require 'nifty/version'
require 'nifty/relation_methods'
require 'nifty/class_methods'
require 'nifty/result_handler'
require 'active_record'

module Nifty
  class Error < StandardError; end
end

ActiveRecord::Relation.send(:include, Nifty::RelationMethods)
