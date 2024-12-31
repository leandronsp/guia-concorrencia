#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/select.h>

#define BUFFER_SIZE 1024

int main() {
    char buffer[BUFFER_SIZE];

    // Abre o FIFO em modo não-bloqueante
    int fd = open("queue", O_RDONLY | O_NONBLOCK);
    printf("Monitorando FIFO...\n");

    while (1) {
        fd_set read_fds;
        FD_ZERO(&read_fds);

        // Adiciona o FIFO aos conjuntos de leitura
        FD_SET(fd, &read_fds);

        // Configura timeout opcional (1 segundo)
        struct timeval timeout;
        timeout.tv_sec = 1;
        timeout.tv_usec = 0;

        // Chama select para monitorar os descritores
        int ready = select(fd + 1, &read_fds, NULL, NULL, &timeout);
        if (ready == 0) {
            // Timeout: Nenhuma atividade
            printf("Nenhum descritor disponível. Continuando...\n");
            continue;
        }

        // Verifica se há dados no FIFO
        if (FD_ISSET(fd, &read_fds)) {
            ssize_t bytes_read = read(fd, buffer, BUFFER_SIZE);

            if (bytes_read > 0) {
                printf("Mensagem recebida: %s", buffer);
            } 
        }
    }

    close(fd);
    return 0;
}
