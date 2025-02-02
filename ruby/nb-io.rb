require 'fcntl'

File.open("queue", "r") do |file|
  file.fcntl(Fcntl::O_NONBLOCK) # Configura o arquivo como não bloqueante

  loop do
    begin
      # Tenta ler dados do arquivo
      buffer = file.read_nonblock(1024)
      puts "Mensagem recebida: #{buffer}"
    rescue IO::WaitReadable
      # Nenhum dado disponível no momento, aguarda 1 segundo
      puts "Nenhum dado disponível no FIFO agora."
      sleep(1)
    rescue EOFError
      # Arquivo foi encerrado
      puts "Fim do arquivo alcançado."
      break
    end
  end
end
