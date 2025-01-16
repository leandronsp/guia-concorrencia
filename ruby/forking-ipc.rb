# Cria um pipe com dois descritores (leitura e escrita)
read_fd, write_fd = IO.pipe

pid = fork do
  # Processo filho
  read_fd.close # Fecha a extremidade de leitura no filho
  mensagem = "Message from child!"
  write_fd.puts(mensagem) # Escreve a mensagem no pipe
  write_fd.close # Fecha a extremidade de escrita no filho
end

# Processo pai
write_fd.close # Fecha a extremidade de escrita no pai
mensagem_recebida = read_fd.gets.chomp # Lê a mensagem do pipe
puts "Parent received message: #{mensagem_recebida}"
read_fd.close # Fecha a extremidade de leitura no pai

# Aguarda o processo filho terminar
Process.wait(pid)
