Dir['rails_lite/*.rb'].each {|file| require_relative file }
Dir['app/controllers/*.rb'].each {|file| require_relative file }
Dir['app/models/*.rb'].each {|file| require_relative file }
Dir['app/views/*.rb'].each {|file| require_relative file }

router = Router.new
router.draw do
  # add routes here
  # example:
  #   get Regexp.new("^/cats$"), CatsController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
