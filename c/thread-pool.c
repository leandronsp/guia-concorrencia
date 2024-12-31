#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define NUM_THREADS 4    // Número de threads no pool
#define NUM_TASKS 10     // Número total de tarefas

// Fila de tarefas
typedef struct {
	int task_id;
} Task;

Task queue[NUM_TASKS];
int task_count = 0;
int task_index = 0;

// Variáveis de sincronização
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t condvar = PTHREAD_COND_INITIALIZER;

// Função executada pelas threads do pool
void* handle(void* arg) {
	int thread_id = *((int*)arg);
	free(arg); // Libera a memória alocada para o ID da thread

	while (1) {
		// Bloqueia o mutex para acessar a fila de tarefas
		pthread_mutex_lock(&mutex);

		// Espera até que uma tarefa esteja disponível
		while (task_index >= task_count) {
			pthread_cond_wait(&condvar, &mutex);
		}

		// Retira a próxima tarefa da fila
		Task task = queue[task_index];
		task_index++;

		// Executa a tarefa
		printf("Thread %d processando tarefa %d...\n", thread_id, task.task_id);
		sleep(1); // Simula o processamento da tarefa
		printf("Thread %d completou tarefa %d.\n", thread_id, task.task_id);

		pthread_mutex_unlock(&mutex); // Desbloqueia o mutex
}

	return NULL;
}

// Adiciona uma tarefa à fila
void add_task(int task_id) {
	pthread_mutex_lock(&mutex);

	if (task_count < NUM_TASKS) {
		queue[task_count].task_id = task_id;
		task_count++;
		pthread_cond_signal(&condvar); // Notifica as threads
	} else {
		printf("Fila de tarefas cheia! Não foi possível adicionar tarefa %d.\n", task_id);
	}

	pthread_mutex_unlock(&mutex);
}

int main() {
	pthread_t threads[NUM_THREADS];

	// Cria as threads no pool
	for (int i = 0; i < NUM_THREADS; i++) {
		int* thread_id = malloc(sizeof(int));
		*thread_id = i + 1;
		pthread_create(&threads[i], NULL, handle, thread_id);
	}

	// Adiciona tarefas à fila
	for (int i = 0; i < NUM_TASKS; i++) {
		printf("Adicionando tarefa %d\n", i + 1);
		add_task(i + 1);
		sleep(0.5); // Simula um intervalo entre tarefas
	}

	// Em um sistema real, seria necessário um mecanismo para finalizar as threads.
	// Aqui, como as threads ficam em loop infinito, use Ctrl+C para encerrar.
	for (int i = 0; i < NUM_THREADS; i++) {
		pthread_join(threads[i], NULL);
	}

	return 0;
}
