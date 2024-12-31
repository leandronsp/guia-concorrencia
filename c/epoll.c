#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/epoll.h>

#define BUFFER_SIZE 1024
#define MAX_EVENTS 10

int main() {
    char buffer[BUFFER_SIZE];

    // Abre o FIFO em modo não-bloqueante
    int fd = open("queue", O_RDONLY | O_NONBLOCK);

    // Cria o epoll
    int epoll_fd = epoll_create1(0);

    // Configura o descritor no epoll
    struct epoll_event event;
    event.events = EPOLLIN; // Monitorar para leitura
    event.data.fd = fd;

    // Adiciona o descritor ao epoll (similar ao FD_SET)
    epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fd, &event);

    printf("Monitorando FIFO com epoll...\n");

    struct epoll_event events[MAX_EVENTS];

    while (1) {
        int ready = epoll_wait(epoll_fd, events, MAX_EVENTS, 1000); // Timeout de 1 segundo

        if (ready == 0) {
            printf("Nenhum descritor disponível. Continuando...\n");
            continue;
        }

        for (int i = 0; i < ready; i++) {
            if (events[i].events & EPOLLIN) {
                ssize_t bytes_read = read(events[i].data.fd, buffer, BUFFER_SIZE);

                if (bytes_read > 0) {
                    printf("Mensagem recebida: %s\n", buffer);
                }
            }
        }
    }

    close(fd);
    close(epoll_fd);
    return 0;
}
