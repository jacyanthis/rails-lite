require_relative '03_associatable'

module Associatable
  def has_through(name, through_name, source_name, setting)
    through_options = assoc_options[through_name]

    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.model_class.table_name
      through_self_key = through_options.self_key
      through_other_key = through_options.other_key

      source_table = source_options.model_class.table_name
      source_other_key = source_options.other_key
      source_self_key = source_options.self_key

      through = self.send(through_name)
      if through_options.is_a?(HasManyOptions)
        through_other_values = []

        where_line = through.map do |through_object|
          through_other_values << through_object.send(through_other_key)
          "#{through_table}.#{through_other_key} = ?"
        end.join(" OR ")

        through_other_values
      else
        puts "through is: #{through.inspect}"
        through_other_value = through.send(through_other_key)
        where_line = "#{through_table}.#{through_other_key} = ?"
      end
      
      results_hash_array = DBConnection.execute(<<-SQL, *through_other_value)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table} ON #{through_table}.#{source_self_key} = #{source_table}.#{source_other_key}
        WHERE
          #{where_line}
      SQL

      object_array = results_hash_array.map do |results_hash|
        source_options.model_class.new(results_hash)
      end
      object_array.first if setting == :one
    end
  end

  def has_many_through(name, through_name, source_name)
    has_through(name, through_name, source_name, :many)
  end

  def has_one_through(name, through_name, source_name)
    has_through(name, through_name, source_name, :one)
  end
end
