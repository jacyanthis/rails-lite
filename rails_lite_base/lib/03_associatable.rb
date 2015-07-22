require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
    :other_key,
    :self_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase
    @other_key = @primary_key
    @self_key = @foreign_key
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name.underscore}_id".to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
    @other_key = @foreign_key
    @self_key = @primary_key
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      primary_key = options.send(:primary_key)
      foreign_key = options.send(:foreign_key)
      options.model_class.where({primary_key => self.send(foreign_key)}).first
    end

    assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      primary_key = options.send(:primary_key)
      foreign_key = options.send(:foreign_key)
      options.model_class.where({foreign_key => self.send(primary_key)})
    end

    assoc_options[name] = options
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def includes(assoc_name)
    puts "starting first query..."
    original_objects = self.all
    puts "first query done"

    included_options = assoc_options[assoc_name]
    included_model_class = included_options.model_class
    included_table_name = included_model_class.table_name
    included_other_key = included_options.other_key
    self_key = included_options.self_key

    puts "starting second query..."
    second_query = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{included_table_name}
    SQL

    included_objects = second_query.map do |result|
      included_model_class.new(result)
    end
    puts "second query done"

    original_objects.each do |original|
      original.define_singleton_method(assoc_name) do
        relevant_results = included_objects.select do |included|
          included.send(included_other_key) == original.send(self_key)
        end
      end
    end

  end
end

class SQLObject
  extend Associatable
end
