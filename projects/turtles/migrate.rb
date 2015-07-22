require 'active_support/inflector'
require_relative 'rails_lite/05_sql_migration.rb'

finished_migrations_array = File.readlines("db/finished_migrations.txt")

finished_migrations = {}

finished_migrations_array.each do |migration_name|
  finished_migrations[migration_name] = true
end

Dir['db/migrations/*.rb'].each do |migration_name|
  unless finished_migrations[migration_name]
    load "#{migration_name}"
    match_data = /db\/migrations\/(\w+).rb/.match(migration_name)
    file_name_base = match_data[1]
    file_name_base.camelcase.constantize.new(file_name_base).up
    File.write("db/finished_migrations.txt", "#{migration_name}")
  end
end
