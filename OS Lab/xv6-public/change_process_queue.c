#include "types.h"
#include "user.h"

void set_queue(int pid,int new_queue) {

    if(pid < 1) {

        printf(1,"invalid pid\n");
        return;
    }

    if(new_queue < 1 || new_queue > 4) {

        printf(1,"invalid queue\n");
        return;
    }

    int res = change_process_queue(pid, new_queue);
    if(res < 0) {
        printf(1,"Eror changing queue\n");
    }
    else {
        printf(1,"process with pid = %d changed queue from %d to %d\n",pid , res , new_queue);
    }

}

int main(int argc,char* argv[]){


    if(argc < 3) {
        printf(1,"not enogh params\n");
        exit();
    }

    set_queue(atoi(argv[1]),atoi(argv[2]));
    exit();

}

