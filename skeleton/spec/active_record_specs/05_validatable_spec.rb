# not yet implemented

# require '05_validatable'
#
# describe 'Validations' do
#   before(:all) do
#     class Cat < SQLObject
#       validate :owner_id, presence: true
#
#       self.finalize!
#     end
#   end
#
#   it "won't let you create an ownerless cat" do
#     puts "validations are #{Cat.validations}"
#     cat = Cat.new(name: "Bob", owner_id: nil)
#
#     cat.save
#   end
#
# end
