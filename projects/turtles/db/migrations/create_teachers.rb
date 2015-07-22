class CreateTeachers < Migration
  def up
    create_table :teachers do |t|
      t.string :name
    end
  end
end
