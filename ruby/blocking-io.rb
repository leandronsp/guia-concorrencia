# Abre o arquivo em modo somente leitura
File.open("queue", "r") do |file|
  # Lê o conteúdo do arquivo
  buffer = file.read(1024)

  # Exibe a mensagem recebida
  puts "Mensagem recebida: #{buffer}"
end
