arr_f = [1]
num = 1
while  num < 100
  arr_f << num
  num = arr_f[-1] + arr_f[-2]
end
print arr_f
