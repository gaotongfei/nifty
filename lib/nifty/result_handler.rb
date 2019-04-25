module Nifty
  class ResultHandler
    # @param :result adapter execution result
    # @param :conn_config [Hash], conn_config is what ActiveRecord::Base.connection_config method returns,
    #   it looks like this {:adapter=>"sqlite3", :database=>":memory:"}
    # @param :column_names [Array]
    def initialize(conn_config)
      @conn_config = conn_config
    end

    def handle(result, column_names)
      klass.handle(result, column_names)
    end

    private

    def klass
      if @conn_config[:adapter] == 'sqlite3'
        SqliteRecordHandler
      elsif @conn_config[:adapter] == 'mysql2'
        MysqlRecordHandler
      else
        raise 'Nifty only support sqlite3 and mysql2 adapters at this moment'
      end
    end
  end


  class SqliteRecordHandler
    # @param :result [Array<SQLite3::ResultSet::HashWithTypesAndFields>]
    # @param :column_names [Array]
    def self.handle(result, column_names)
      aoh = []
      result.each do |r|
        row = {}
        column_names.each do |column_name|
          row[column_name] = r[column_name]
        end
        aoh << Nifty::Result.build(row)
      end
      aoh
    end
  end

  class MysqlRecordHandler
    def self.handle(result, column_names)
      aoh = []
      result.each do |r|
        row = {}
        column_names.each_with_index do |column_name, index|
          row[column_name] = r[index]
        end
        aoh << Nifty::Result.build(row)
      end
      aoh
    end
  end
end

