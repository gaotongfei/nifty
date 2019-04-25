$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'nifty'

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require 'bundler'
require 'bundler/setup'
Bundler.setup(:default, :test)
require 'active_record'

module ActiveRecordTest
  def self.setup
    establish_conn
    define_schema
  end

  def self.establish_conn
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
  end

  def self.define_schema
    ActiveRecord::Schema.define do
      create_table :users do |t|
        t.string :username
        t.string :email
        t.string :introduction
        t.string :password_digest
      end
    end
  end

  class User < ::ActiveRecord::Base
    include Nifty::ScopingMethods
    self.table_name = 'users'
  end
end

