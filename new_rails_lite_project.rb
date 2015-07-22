require 'fileutils'

# gets project name as first argument on the command line
project_name = ARGV.first
#gets path for project folder
project_path = "projects/#{project_name}"

# raises error if project name is already taken
already_created = File.exists?(project_path)
raise "that rails_lite project already exists!" if already_created

# creates root directory for project
system 'mkdir', '-p', project_path

# creates rails_lite directory in new project
rails_lite_path = project_path + "/rails_lite"
system 'mkdir', '-p', project_path + "/rails_lite"

# copies rails_lite library into project
FileUtils.cp_r 'rails_lite_base/lib/.', rails_lite_path

# creates directories for controllers and models in app directory
system 'mkdir', '-p', project_path + "/app"
system 'mkdir', '-p', project_path + "/app/controllers"
system 'mkdir', '-p', project_path + "/app/models"
system 'mkdir', '-p', project_path + "/app/views"

# creates empty .sql file
sql_file = File.new(project_path + "/" + project_name + ".sql", "w")
sql_file.puts("# please enter sql here to create tables")

# copies server.rb
FileUtils.cp 'rails_lite_base/server.rb', project_path + "/server.rb"

# copies gemfile
FileUtils.cp 'rails_lite_base/Gemfile', project_path + "/Gemfile"

# copies ApplicationController
FileUtils.cp 'rails_lite/application_controller.rb', project_path + "/controllers/application_controller.rb"
