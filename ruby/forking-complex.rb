def perform
  pid = Process.pid

  puts "Processo filho (PID: #{pid}) executando tarefa..."
  sleep(2) # Simula uma tarefa que leva 2 segundos
  puts "Processo filho (PID: #{pid}) completou a tarefa!"
end

wait_pids = []

# Criação dos processos filhos
3.times do
  pid = fork do
    perform # Código do processo filho
  end

  wait_pids << pid # Armazena o PID do filho para controle
end

# O processo pai aguarda cada filho terminar
wait_pids.each do |child_pid|
  Process.wait(child_pid)

  puts "Pai: Processo filho com PID #{child_pid} terminou."
end

puts "Pai: Todos os filhos terminaram. Finalizando."
