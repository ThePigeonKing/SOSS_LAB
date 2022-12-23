#include "stdio.h"

extern char **environ;
int main(int argc, char const *argv[]) {
    char **env_ptr;
    int amnt = 0;
    printf("Enviromnet variables: \n");
    for (env_ptr = environ; *env_ptr != NULL; env_ptr++) {
        amnt++;
        if (amnt < 10) {
            printf("%s\n", *env_ptr);
        } else {
            return 0;    
        }
    }
    return 0; 
}
