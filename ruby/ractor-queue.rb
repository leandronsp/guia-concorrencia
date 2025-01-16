queue = Ractor.new do 
  loop do 
    Ractor.yield(Ractor.receive)
  end
end

queue.send(42)
puts queue.take
