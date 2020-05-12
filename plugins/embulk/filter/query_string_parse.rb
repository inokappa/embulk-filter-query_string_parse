# require 'pry'
# require 'pry-nav'
require 'uri'

module Embulk
  module Filter

    class QueryStringParseFilterPlugin < FilterPlugin
      Plugin.register_filter('query_string_parse', self)

      def self.transaction(config, in_schema, &control)
        task = {
          'query_string_column_name' => config.param('query_string_column_name', :string, default: "column_name"),
          'expanded_columns' => config.param('expanded_columns', :array, default: [])
        }

        idx = in_schema.size
        task['expanded_columns'].each do |c|
          in_schema = in_schema + [Column.new(idx, c['name'], :string)]
          idx = idx + 1
        end

        yield(task, in_schema)
      end

      def initialize(task, in_schema, out_schema, page_builder)
        super
        @column = task['query_string_column_name']
        @expanded = task['expanded_columns']
      end

      def close
      end

      def add(page)
        page.each do |record|
          begin
            record = hash_record(record)
# binding.pry
            # 対象とするカラムに値が入っていない場合の対処
            if record[@column].nil?
              @page_builder.add(record.values + Array.new(@expanded.length, ''))
              next
            end

            parsed_query = parse_query(record[@column])
            result = {}
            parsed_query.each do |pk, pv|
              @expanded.each do |ec|
                result[pk] = pv if ec['name'] == pk
              end
            end
            result_array = []
            result_array = Array.new(@expanded.length, '') if result.values.empty?
            result_array = result.values unless result.values.empty?
# binding.pry
            @page_builder.add(record.values + result_array)
          rescue
          end
        end
      end

      def finish
        @page_builder.finish
      end

      def hash_record(record)
        Hash[in_schema.names.zip(record)]
      end

      def parse_query(query)
        query_array = URI::decode_www_form(query)
        Hash[query_array]
      end
    end

  end
end
