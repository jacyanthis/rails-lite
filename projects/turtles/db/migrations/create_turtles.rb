class CreateTurtles < Migration
  def up
    create_table :turtles do |t|
      t.string :name
      t.string :teacher_name
    end
  end
end
