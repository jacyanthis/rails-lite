require 'active_support/inflector'
require_relative 'rails_lite/05_sql_migration.rb'

finished_migrations_array = File.readlines("db/finished_migrations.txt")

finished_migrations = {}

finished_migrations_array.each do |migration_name|
  finished_migrations[migration_name] = true
end

def run_sql(sql_file)
  match_data = /^\S+\/(\w+)$/.match(Dir.pwd)
  db_file = match_data[1] + ".db"
  puts `cat '#{sql_file}' | sqlite3 '#{db_file}'`
  # puts "cat 'turtles.sql' | sqlite3 '#{db_file}'"

end

Dir['db/migrations/*.rb'].each do |migration_name|
  unless finished_migrations["#{migration_name}\n"]
    match_data = /db\/migrations\/(\w+).rb/.match(migration_name)
    file_name_base = match_data[1]
    file_name_base.camelcase.constantize.new(file_name_base).up
    run_sql("db/sql_files/#{file_name_base}.sql")
    open("db/finished_migrations.txt", 'a') { |f|
      f.puts "#{migration_name}"
    }
  end
end
