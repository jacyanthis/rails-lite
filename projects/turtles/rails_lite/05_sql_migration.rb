class Migration
  def initialize(file_name_base)
    @file_name_base = file_name_base
  end

  def create_table(table_name, &prc)
    table_definition = TableDefinition.new(table_name, @file_name_base)
    prc.call(table_definition)
    table_definition.finalize
  end
end

class TableDefinition
  def initialize(table_name, file_name_base)
    @sql_file_path = "db/sql_files/#{file_name_base}.sql"
    @sql_file = File.open(@sql_file_path, "w")
    @sql_file.write("CREATE TABLE #{table_name} (\n  id INTEGER PRIMARY KEY")
  end

  def string(name, options = {})
    column(:string, name, options)
  end

  def integer(name, options = {})
    column(:integer, name, options)
  end

  def column(type, name, options = {})
    @sql_file.write(",\n  #{name} #{match_type(type)}")
  end

  def finalize
    @sql_file.write("\n);")
  end

  private

  def match_type(type)
    case type
    when :string
      "VARCHAR(255)"
    when :integer
      "INTEGER"
    end
  end
end
