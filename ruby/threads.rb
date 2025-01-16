# Função que será executada pela thread
def handle
  puts "Hello from thread!"
end

# Cria uma thread
thread = Thread.new do
  handle
end

puts "Hello from main thread!"

# Aguarda a thread terminar
thread.join
