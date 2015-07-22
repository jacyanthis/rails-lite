require 'uri'

class Params

  def initialize(req, route_params = {})
    @params = {}
    add_route_params(route_params)
    parse_www_encoded_form(req.query_string) if req.query_string
    parse_www_encoded_form(req.body) if req.body
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  # this will be useful if we want to `puts params` in the server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private

  # this should add the params given through the route
  def add_route_params(route_params)
    route_params.each do |key, value|
      @params[key] = value
    end
  end

  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    URI::decode_www_form(www_encoded_form).each do |array|
      keys = parse_key(array[0])
      if keys.length == 1
        @params[array[0]] = array[1]
      else
        current_level = @params
        keys.each_with_index do |key, index|
          if index == 0
            @params[key] ||= {}
            current_level = @params[key]
          elsif index == keys.length - 1
            current_level[key] = array[1]
          else
            current_level[key] = {}
            current_level = current_level[key]
          end
        end
      end
    end
  end

  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
