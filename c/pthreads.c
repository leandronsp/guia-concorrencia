#include <stdio.h>
#include <pthread.h>

void* handle() {
	printf("Hello from thread!\n");
	return NULL;
}

int main() {
	pthread_t thread;

	// Cria uma thread
	pthread_create(&thread, NULL, handle, NULL);

	// Aguarda a thread terminar
	pthread_join(thread, NULL);

	printf("Hello from main thread!\n");
	return 0;
}
