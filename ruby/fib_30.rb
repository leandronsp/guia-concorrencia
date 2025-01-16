require 'benchmark'

def fib(n) = n < 2 ? n : fib(n - 1) + fib(n - 2)
def cpu_task = fib(30)

time = Benchmark.measure { cpu_task }

puts "Tempo: #{time.real.round(2)} segundos"
