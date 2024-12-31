#include <stdio.h>
#include <pthread.h>

#define NUM_THREADS 5
#define INCREMENTS 100000

int counter = 0; // Variável compartilhada entre as threads
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; // Mutex para proteger o acesso

void* increment(void* arg) {
	for (int i = 0; i < INCREMENTS; i++) {
		pthread_mutex_lock(&mutex); // Bloqueia o mutex
		counter++; // Incrementa a variável compartilhada
		pthread_mutex_unlock(&mutex); // Desbloqueia o mutex
	}
	return NULL;
}

int main() {
	pthread_t threads[NUM_THREADS];

	// Cria as threads
	for (int i = 0; i < NUM_THREADS; i++) {
		pthread_create(&threads[i], NULL, increment, NULL);
	}

	// Aguarda as threads terminarem
	for (int i = 0; i < NUM_THREADS; i++) {
		pthread_join(threads[i], NULL);
	}

	printf("Valor final do counter compartilhado: %d (esperado: %d)\n", counter, NUM_THREADS * INCREMENTS);
	return 0;
}
