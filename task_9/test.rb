require_relative 'accessors.rb'
class Test
  include Accessors
  a = 3
  s = 7
  a = 5
  a = 292
  puts @history.inspect
end