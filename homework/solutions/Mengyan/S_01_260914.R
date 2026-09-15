#要求一
start_str <- "2026-05-19"
end_str   <- "2026-09-15"
class(start_str) 
class(end_str)

#要求二
start = as.Date("2026-05-19")
end = as.Date("2026-09-15")
class(start)
class(end)
print(start)
print(end)

#要求三
gap = end - start
class(gap)
days = as.numeric(gap)
print(days)

#要求四
print(as.numeric(difftime(end, start, units = "secs")))
print(as.numeric(difftime(end, start, units = "mins")))
print(as.numeric(difftime(end, start, units = "hours")))
print(as.numeric(difftime(end, start, units = "days")))
print(as.numeric(difftime(end, start, units = "weeks")))
