#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <uv.h>

#define BUFFER_SIZE 1024

// Callback chamado quando a leitura é concluída
void on_data_available(uv_fs_t* req) {
    if (req->result > 0) {
        printf("Conteúdo do arquivo: %s\n", (char*)req->bufs->base);
    } 

    // Libera recursos
    uv_fs_req_cleanup(req);
    free(req->bufs->base);
    free(req);
}

int main() {
    // Inicializa o loop de eventos
    uv_loop_t* loop = uv_default_loop();

    uv_fs_t* open_req = malloc(sizeof(uv_fs_t));
    uv_fs_t* read_req = malloc(sizeof(uv_fs_t));

    // Abre o arquivo de forma assíncrona
    uv_fs_open(loop, open_req, "example.txt", O_RDONLY, 0, NULL);

    if (open_req->result >= 0) {
        char* buffer = malloc(BUFFER_SIZE);
        uv_buf_t iov = uv_buf_init(buffer, BUFFER_SIZE);

        // Lê o arquivo de forma assíncrona
        read_req->bufs = &iov;
        uv_fs_read(loop, read_req, open_req->result, &iov, 1, -1, on_data_available);
    }

    uv_fs_req_cleanup(open_req);
    free(open_req);

    uv_run(loop, UV_RUN_DEFAULT);
    return 0;
}
