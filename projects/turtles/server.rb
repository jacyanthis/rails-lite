Dir['rails_lite/*.rb'].each {|file| require_relative file }
Dir['app/controllers/*.rb'].each {|file| require_relative file }
Dir['app/models/*.rb'].each {|file| require_relative file }
Dir['app/views/*.rb'].each {|file| require_relative file }

router = Router.new
router.draw do
  get Regexp.new("^/$"), TurtlesController, :index
  get Regexp.new("^/turtles$"), TurtlesController, :index
  get Regexp.new("^/turtles/new$"), TurtlesController, :new
  post Regexp.new("^/turtles$"), TurtlesController, :create
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
