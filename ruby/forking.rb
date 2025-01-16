pid = fork

if pid
  puts "In parent, pid is #{Process.pid}. Child is #{pid}"
else
  puts "In child, pid is #{Process.pid}"
end
