#include "types.h"
#include "user.h"
#include "stat.h"

int 
count_num_of_digit_handler(int num){
    
    int prev_ebx;

    asm volatile(
        "movl %%ebx, %0\n\t"
        "movl %1, %%ebx"
        : "=r"(prev_ebx)
        : "r"(num)
    );

    int result = count_num_of_digit();

    asm volatile(
        "movl %0, %%ebx"
        :: "r"(prev_ebx)
    );
    
    return result;
}

int
main(int argc, char* argv[]){
    if (argc < 2) {
        printf(1, "Usage: count_num_of_digit <num>\n");
        exit();
    }
    int input = atoi(argv[1]);
    int result = count_num_of_digit_handler(input);
    /*if (result < 0){
        printf(2, "number should be positive\n");
        exit();
    }*/
    printf(1, "The number of digit %d is %d\n", input, result);
    exit();
}