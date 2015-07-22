require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
        1
    SQL
    .first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |ivar|
      define_method(ivar) do
        attributes[ivar]
      end
      define_method("#{ivar}=") do |content|
        attributes[ivar] = content
      end
    end
  end

  def self.table_name=(table_name)
    instance_variable_set("@table_name", table_name)
  end

  def self.table_name
    if instance_variables.include?(:@table_name)
      @table_name
    else
      self.to_s.tableize
    end
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    pa = parse_all(results)
    pa
  end

  def self.parse_all(results)
    results.map do |result|
      new(result)
    end
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = :id
      LIMIT
        1
    SQL

    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym

      unless self.class.columns.include?(attr_name)
        raise "unknown attribute '#{attr_name}'"
      end

      send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |attr_name|
      send("#{attr_name}")
    end
  end

  def insert
    columns = self.class.columns
    col_names = columns.join(",")
    question_marks = (["?"] * columns.length).join(",")
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns
    set_string = columns.map do |attr_name|
      "#{attr_name} = ?"
    end.join(",")
    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_string}
      WHERE
        id = ?
    SQL
  end

  def save
    # validate_object

    if id.nil?
      insert
    else
      update
    end
  end

  # def validate_object
  #   raise "you can't save that!" unless self.class.validations.all? do |validation|
  #     self.class.send(validation)
  #   end
  # end
end
