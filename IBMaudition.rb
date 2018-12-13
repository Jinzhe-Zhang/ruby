    m=gets
def how_many_kinds(d)
    d=d.to_i
return d>1 ? how_many_kinds(d-1) + how_many_kinds(d-2) :1
end
puts how_many_kinds m
system "pause"