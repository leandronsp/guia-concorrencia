#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void* handle(void* arg) {
	int thread_id = *((int*)arg); // Recebe o ID da thread
	printf("Thread %d is running...\n", thread_id);
	sleep(2); // Simula uma tarefa que leva 2 segundos
	printf("Thread %d is finished\n", thread_id);
	return NULL;
}

int main() {
	int num_threads = 3;
	pthread_t threads[num_threads];
	int thread_ids[num_threads];

	for (int i = 0; i < num_threads; i++) {
		thread_ids[i] = i + 1; // Identificação das threads
		pthread_create(&threads[i], NULL, handle, &thread_ids[i]);
	}

	for (int i = 0; i < num_threads; i++) {
		pthread_join(threads[i], NULL); // Aguarda cada thread terminar
		printf("Thread %d has been finished.\n", i + 1);
	}

	printf("All threads are finished.\n");
	return 0;
}
