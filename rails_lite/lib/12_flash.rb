require 'json'
require 'webrick'

class Flash
  attr_reader :flash_hash

  def initialize(session)
    @flash_hash = session["flash"] ||= {}
    @now_flash_hash = session["flash_now"] ||= {}
  end

  def [](key)
    @flash_hash[key.to_s] || @now_flash_hash[key.to_s]
  end

  def []=(key, val)
    @flash_hash[key.to_s] = val
  end

  def now
    @now_flash_hash
  end
end
