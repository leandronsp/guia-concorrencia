File.open("queue", File::RDONLY |File::NONBLOCK) do |file|
  loop do
    buffer = file.read(1024)

    if buffer
      puts "Mensagem recebida: #{buffer}"
    else
      puts "Nenhum dado disponível no FIFO agora."
      sleep(1)
    end
  end
end

