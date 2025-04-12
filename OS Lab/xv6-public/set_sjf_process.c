#include "types.h"
#include "user.h"

void set_process_sjf(int pid, int burst)
{
    if (pid < 1)
    {
        printf(1, "Invalid pid\n");
        return;
    }
    if (burst < 0)
    {
        printf(1, "Invalid burst time\n");
        return;
    }
    int res = set_sjf_process(pid, burst);
    if (res < 0)
        printf(1, "Error setting SJF params\n");
    else
        printf(1, "SJF params set successfully\n");
}

int main(int argc,char* argv[]){
   if (argc < 3)
        {
            printf(1,"not enough params");
            exit();
        }
    set_process_sjf(atoi(argv[1]), atoi(argv[2]));
    exit();
}