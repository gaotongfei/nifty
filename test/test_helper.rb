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
  def self.setup(db_adapter: 'sqlite3')
    ActiveRecord::Migration.verbose = false
    establish_conn(db_adapter)
    define_schema
  end

  def self.establish_conn(db_adapter)
    case db_adapter
    when 'sqlite3'
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    when 'mysql2'
      ActiveRecord::Base.establish_connection(adapter: 'mysql2', database: 'nifty_test', username: ENV['MYSQL_USERNAME'], password: ENV['MYSQL_PASSWORD'])
    end
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
    extend Nifty::ClassMethods
    self.table_name = 'users'
  end
end

