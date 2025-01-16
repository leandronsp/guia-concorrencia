balance = 0 # Variável compartilhada

def one = 1

mutex = Mutex.new

# Cria 100 threads
threads = 100.times.map do
  Thread.new do
    500_000.times do
      mutex.synchronize do
        balance += one
      end
    end
  end
end

# Espera as 100 threads terminarem de executar
threads.each(&:join)

puts "Balance is: #{balance} (expected: 50000000)"
