#include "stdio.h"
#include "stdlib.h"

extern char **environ;
int main(int argc, char const *argv[]) {
    char **env_ptr;
    int amnt = 0, limit = 0;
    if (argc <= 1) {
        printf("Not enough parameters!\n");
        return 1;
    } else {
        limit = atoi(argv[1]);
    }
    printf("Environmet variables: \n");
    for (env_ptr = environ; *env_ptr != NULL; env_ptr++) {
        amnt++;
        if (amnt <= limit) {
            printf("%s\n", *env_ptr);
        } else {
            return 0;    
        }
    }
    return 0; 
}
