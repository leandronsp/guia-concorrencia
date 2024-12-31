#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

int main() {
    char buffer[BUFFER_SIZE];

    int fd = open("queue", O_RDONLY); // Abre o arquivo em modo somente leitura
    read(fd, buffer, BUFFER_SIZE); // Operação de I/O bloqueante
    printf("Mensagem recebida: %s", buffer);

    close(fd);
    return 0;
}
