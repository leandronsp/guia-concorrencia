def handle(thread_id)
  puts "Thread #{thread_id} is running..."
  sleep(2) # Simula uma tarefa que leva 2 segundos
  puts "Thread #{thread_id} is finished."
end

threads = []

# Criação das threads
3.times do |i|
  threads << Thread.new(i + 1) do |thread_id|
    handle(thread_id) # Passa o ID da thread como argumento
  end
end

# Aguarda todas as threads finalizarem
threads.each_with_index do |thread, i|
  thread.join
  puts "Thread #{i + 1} has been finished."
end

puts "All threads are finished."
