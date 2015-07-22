# require_relative '04_associatable2'
# require 'active_support/inflector'
# require 'byebug'
#
# module Validatable
#   def validate(name, options = {})
#     options.each do |key, value|
#       create_validation(name, key, value)
#     end
#   end
#
#   def create_validation(name, key, value)
#     case key
#     when :presence
#       if value == true
#         method_name = "#{name}_presence_#{value}"
#         self.define_method(method_name) do
#           !instance_variable_get("@#{name}").nil?
#         end
#         validations << method_name.to_sym
#         puts "validations are #{validations}"
#         puts "my methods are #{self.methods}"
#       else
#         self.validations << define_method("#{name}_presence_#{value}") do
#           instance_variable_get("@#{name}").nil?
#         end
#         puts "validations are #{validations}"
#       end
#     end
#   end
#
#   def validations
#     @validations ||= []
#   end
# end
#
#
# class SQLObject
#   extend Validatable
# end
