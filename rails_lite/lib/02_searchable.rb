require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    Relation.new(params, self)
  end

  class Relation
    attr_accessor :params, :table_name, :model_class

    def initialize(params, model_class)
      @params = params
      @model_class = model_class
      @table_name = model_class.table_name
    end

    def where(new_params)
      new_params.each do |key, value|
        @params[key] = value
      end
    end

    def method_missing(method_name, *args, &block)
      array = execute_where_query
      array.send(method_name, *args, &block)
    end

    def execute_where_query
      where_line = params.keys.map do |key|
        "#{key} = ?"
      end.join(" AND ")

      results = DBConnection.execute(<<-SQL, *params.values)
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{where_line}
      SQL
      parse_all(results)
    end

    def parse_all(results)
      results.map do |result|
        model_class.new(result)
      end
    end
  end
end

class SQLObject
  extend Searchable
end
