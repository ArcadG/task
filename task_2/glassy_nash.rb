hash = Hash[("a".."z").to_a.zip((1..26).to_a)]
arr =["a", "e", "i", "o", "u", "y"]
print hash.select { |k, v|  arr.include?(k) } 
