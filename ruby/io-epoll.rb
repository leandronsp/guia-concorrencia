fifo = File.open('queue', File::RDONLY | File::NONBLOCK) 

loop do
  # Usa IO.select para monitorar o descritor de arquivo
  ready = IO.select([fifo], nil, nil, 1) # Timeout de 1 segundo

  if ready.nil?
    puts "Nenhum descritor disponível. Continuando..."
    next
  end

  # Verifica se há dados no FIFO
  ready[0].each do |io|
    data = io.read(1024)
    puts "Mensagem recebida: #{data}"
  end
end
