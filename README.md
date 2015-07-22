# Welcome to Rails Lite!
This is a functional, lightweight version of Rails. In the root directory, you can create new projects with `ruby new_rails_lite_project.rb` followed by the project name. This will set up a new directory in the `projects` folder with all the files you need to create a functional web application.

# Example project
There's an example project in the `projects` folder that simply stores the names of ninja turtles and their teachers, allowing you to add new turtles.

# Functionality
- SQLite3 database storage
- Object relational mapping
  - Querying through Ruby (e.g. `where`, `includes`)
    - Including lazy evaluation
  - Associations (e.g. `belongs_to`, `has_many_through`)
- Session stored in cookies
  - Including `flash`/`flash.now`
- CSRF protection by default
- Integration with Webrick
