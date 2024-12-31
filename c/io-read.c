#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

int main() {
    char buffer[BUFFER_SIZE];

    int fd = open("example.txt", O_RDONLY); // Abre o arquivo em modo somente leitura
    ssize_t bytes_read = read(fd, buffer, BUFFER_SIZE - 1); // Operação de I/O bloqueante
    printf("%s", buffer);

    close(fd);
    return 0;
}
