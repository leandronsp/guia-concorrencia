require 'benchmark'

def io_task
  sleep(0.07)
end

time = Benchmark.measure do
  threads = 50.times.map { Thread.new { io_task }}
  threads.each(&:join)
end

puts "Tempo: #{time.real.round(2)} segundos"
