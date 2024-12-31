#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

int main() {
    char buffer[BUFFER_SIZE];

    int fd = open("example.txt", O_RDONLY | O_NONBLOCK); // Abre o arquivo em modo não-bloqueante
    ssize_t bytes_read = read(fd, buffer, BUFFER_SIZE - 1); // Operação de I/O bloqueante
    printf("%s", buffer);

    close(fd);
    return 0;
}
