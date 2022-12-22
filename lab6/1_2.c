#include "stdio.h"

extern char **environ;
int main(int argc, char const *argv[]) {
    char **env_ptr;
    int amnt = 0;
    for (env_ptr = environ; *env_ptr != NULL; env_ptr++) {
        // printf("%s\n", *env_ptr);
        amnt++;
    }
    printf("Number of environment variables: %d\n", amnt-1);
    printf("Number of given parameters: %d\n", argc);
}
