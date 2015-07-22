require 'json'
require 'webrick'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookie = find_cookie(req)
  end

  def find_cookie(req)
    req.cookies.each do |cookie|
      return JSON.parse(cookie.value) if cookie.name == '_rails_lite_app'
    end

    {}
  end

  def delete(key)
    @cookie.delete(key)
    @cookie
  end

  def [](key)
    @cookie[key.to_s]
  end

  def []=(key, val)
    @cookie[key.to_s] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    new_cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
    new_cookie.path = "/"
    res.cookies << new_cookie
  end
end
