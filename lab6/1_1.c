#include "stdio.h"

// CHECK: env | wc -l
// output is 1 less than C script, because in C it adds variable _ = .../1_1.out
extern char **environ;
int main(int argc, char const *argv[]) {
    char **env_ptr;
    int amnt = 0;
    for (env_ptr = environ; *env_ptr != NULL; env_ptr++) {
        // printf("%s\n", *env_ptr);
        amnt++;
    }
    printf("Number of environment variables: %d", amnt-1);
}
