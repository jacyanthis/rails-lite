require 'sqlite3'

ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
puts "root folder is #{ROOT_FOLDER}"
SQL_FILE = Dir['*'].select {|x| x =~ /.*.sql/ }.first
puts "regex is" + /(.*).sql/.match(SQL_FILE)[1]
DB_FILE = Dir['*'].select {|x| x =~ /.*.db/ }.first ||
  /(.*).sql/.match(SQL_FILE)[1] + ".db"

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{DB_FILE}'",
      "cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    # puts args[0]

    instance.execute(*args)
  end

  def self.execute2(*args)
    # puts args[0]

    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def initialize(db_file_name)
  end
end
