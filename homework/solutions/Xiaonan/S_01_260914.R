start_str = "2014-04-18"
end_str   = "2026-09-15"
class(start_str)
class(end_str)

start_str = as.Date("2014-04-18")
end_str   = as.Date("2026-09-15")
class(start_str)
class(end_str)
print(start_str)
print(end_str)

a = end_str - start_str
b = difftime(end_str, start_str, units = "weeks")
c = difftime(end_str, start_str, units = "hours")
d = difftime(end_str, start_str, units = "mins")
e = difftime(end_str, start_str, units = "secs")

a1 = as.numeric(a)
b1 = as.numeric(b)
c1 = as.numeric(c)
d1 = as.numeric(d)
e1 = as.numeric(e)

print(a1)
print(b1)
print(c1)
print(d1)
print(e1)

print(a)
print(b)
print(c)
print(d)
print(e)