# frozen_string_literal: true

module Nifty
  module ClassMethods
    def nifty_find(id)
      raise ActiveRecord::UnknownPrimaryKey.new(self.class) if primary_key.nil?

      sql = <<-SQL
        SELECT * FROM #{self.table_name} WHERE #{primary_key} = #{id} LIMIT 1
      SQL

      nifty_result = begin
        # Models can establish a connection with a db server that is not the default db server.
        # Instead of using ActiveRecord::Base.connection_pool, use the connection a model specifies if it has
        # one, to support multiple db.
        self.connection_pool.with_connection do |conn|
          result = conn.execute(sql)
          Nifty::ResultHandler.new(::ActiveRecord::Base.connection_config).handle(result, column_names)
        end
      end
      nifty_result.first
    end
  end
end