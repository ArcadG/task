# frozen_string_literal: true

require_relative 'accessors.rb'
class Test
  extend Accessors
  attr_accessor_with_history :b, :c, :d
end

# def print_history
# puts @history.inspect
# end
test = Test.new
test.d = 2
test.d = 3
test.b = 75
test.c = 766
# test.print_history
puts test.c_history.inspect
