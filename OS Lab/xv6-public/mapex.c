#include "types.h"
#include "user.h"
#include "stat.h"


int main(int argc,char* argv[]) { 

    printvir();
    printphy();
    char* a = (char*)(mapex(8192));
    printvir();
    printphy();
    a[0] = 'a';
    printvir();
    printphy();
    a[4096] = 'b';
    printvir();
    printphy();

     
    exit();
}



