#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#define BUFFER_SIZE 1024

int main() {
    char buffer[BUFFER_SIZE];

    int fd = open("queue", O_RDONLY | O_NONBLOCK); // Abre o arquivo em modo não-bloqueante
						   //
    while (1) { 
	ssize_t bytes_read = read(fd, buffer, BUFFER_SIZE);

	if (bytes_read > 0) {
	    printf("Mensagem recebida: %s", buffer);
	} else if (errno == EAGAIN || errno == EWOULDBLOCK) {
	    printf("Nenhum dado disponível no FIFO agora.\n");
	}

	sleep(1); // Espera 1 segundo
    }

    close(fd);
    return 0;
}
