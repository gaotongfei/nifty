module Nifty
  module RelationMethods #:nodoc:
    def nifty
      sql = to_sql
      ::ActiveRecord::Base.connection_pool.with_connection do |conn|
        result = conn.execute(sql)
        Nifty::ResultHandler.new(::ActiveRecord::Base.connection_config).handle(result, column_names)
      end
    end

    # I basically copied it from ActiveRecord's `find_in_batches` method,
    # it does the same thing as `find_in_batches` does except calling action relation method `nifty`
    # check documentation of ActiveRecord find_in_batches for detail about options
    def nifty_batches(options = {})
      options.assert_valid_keys(:start, :batch_size)

      relation = self
      start = options[:start]
      batch_size = options[:batch_size] || 1000

      unless block_given?
        return to_enum(:find_in_batches, options) do
          total = start ? where(table[primary_key].gteq(start)).nifty.size : size
          (total - 1).div(batch_size) + 1
        end
      end

      if logger && (arel.orders.present? || arel.taken.present?)
        logger.warn("Scoped order and limit are ignored, it's forced to be batch order and batch size")
      end

      relation = relation.reorder(batch_order).limit(batch_size)
      records = start ? relation.where(table[primary_key].gteq(start)).nifty.to_a : relation.nifty.to_a

      while records.any?
        records_size = records.size
        primary_key_offset = records.last.id
        raise "Primary key not included in the custom select clause" unless primary_key_offset

        yield records

        break if records_size < batch_size

        records = relation.where(table[primary_key].gt(primary_key_offset)).nifty.to_a
      end
    end
  end
end