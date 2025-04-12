#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"



int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

static int
count_num_of_digit(int n){
  int count = 0;
  
  do {
    n /= 10;
    ++count;
  } while (n != 0);
  return count;

}

int 
sys_count_num_of_digit(void)
{
  return count_num_of_digit(myproc()-> tf -> ebx);
}

int
sys_change_process_queue(void){
    int pid;
    int queue_num;
  if (argint(0, &pid) < 0)
    return -1;
  if (argint(1, &queue_num) < 0)
    return -1;
  return change_process_queue(pid,queue_num);

}

int
sys_set_sjf_process(void)
{
  int pid;
  int burst_time;
  if(argint(0, &pid) < 0 ||
     argint(1, &burst_time) < 0){
     return -1;
  }
  return set_sjf_process(pid, burst_time);
}

int
sys_print_schedule_info(void){
  print_schedule_info();
  return 0;
}

int
sys_printvir(void) {

  printvir();
  return 0;
}

int
sys_printphy(void) {
  
  printphy();
  return 0;
}
    

int
sys_mapex(void)
{
    int size;

    if (argint(0, &size) < 0)
        return 0;

    if (size <= 0 || size % PGSIZE != 0)
        return 0;

    uint s_z = myproc()->sz;

    mapex(size);

   return s_z;
}

