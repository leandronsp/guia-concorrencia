require 'benchmark'

def fib(n) = n < 2 ? n : fib(n - 1) + fib(n - 2)
def cpu_task = fib(30)

time = Benchmark.measure do
  threads = 50.times.map { Thread.new { cpu_task }}
  threads.each(&:join)
end

puts "Tempo: #{time.real.round(2)} segundos"
