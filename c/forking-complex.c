#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

void perform() {
	printf("Processo filho (PID: %d) executando tarefa...\n", getpid());
	sleep(2); // Simula de uma tarefa que leva 2 segundos
	printf("Processo filho (PID: %d) completou a tarefa!\n", getpid());
}

int main() {
	int num_children = 3;
	pid_t pid;

	for (int i = 0; i < num_children; i++) {
		pid = fork(); // Cria um novo processo

		if (pid == 0) {
			// Processo filho
			perform();
			return 0;
		}
	}

	for (int i = 0; i < num_children; i++) {
		pid_t child_pid = wait(NULL); // Aguarda qualquer filho terminar
		printf("Pai: Processo filho com PID %d terminou.\n", child_pid);
	}

	printf("Pai: Todos os filhos terminaram. Finalizando.\n");
	return 0;
}
