module Nifty
  module RelationMethods #:nodoc:
    def nifty
      sql = to_sql
      ::ActiveRecord::Base.connection_pool.with_connection do |conn|
        result = conn.execute(sql)
        handled_result = Nifty::ResultHandler.new(::ActiveRecord::Base.connection_config).handle(result, column_names)
        Nifty::Inspector.new(handled_result)
      end
    end
  end
end