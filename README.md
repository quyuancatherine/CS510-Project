# CS510-Project

All the code changes we made on top of the basic xv6 are described below:

## Part I
### Null Pointer Dereference
* File 'exec.c': change line 44 `sz=0` --> `sz=PGSIZE`
* File syscall.c: line 67, add `i==0` in the if condition
* File vm.c: line 336, change `i=0` to `i=PGSIZE` in the function of `copyuvm()`
* File Makefile: line 150 & line 158, change 0 to 0x1000
* File usertests.c: line 1571, change p from 0 to 4096 in the function of validatetest.

### Shared Memory Page
* File vm.c: line 14-15, add `int sm_counts[NSHAREPAGE]` and `void* sm_addr[NSHAREPAGE]` in the beginning of vm.c to store the shared memory address and shared memory count.
* File proc.h: line 52, add `void* shared_page[NSHAREPAGE]` in the structure of proc.
* File param.h: line 14, add `#Define NSHAREPAGE 4`
* File vm.c: line 415-432, define the function `void shmem_init(void)
* File main.c: line 37, initilize the function `void shmem_init(void)` in main.c
* File vm.c: line 475-483, define a function call `int shmem_count(int page_number)` to count how many pages are using the same shared memory page right now.
* File vm.c: line 433-474, define a function call `void* shmem_access(int page_number)` to get the address of the shared page memory
* File exec.c: line 93-97, initialize the shared page information in the current process
* File vm.c: line 351-364, modify `copyuvm()` to increase the number of shared pages when calling it in the fork function in proc.c
* File vm.c: line 300, modify freeuvm() to only deallocate non-shared memory
* File proc.c: line 295-303, modify wait(), when a process is destroyed, minus shme_count by 1 and clear the shared memory space in the current process.
* add the functions `int shmem_count(int page_number)` and `void* shmem_access(int page_number)` to system calls (sysproc.c, defs.h, usys.S, syscall.c and syscall.h)
* File user.h: line 26-27, add `int shmem_count(int page_number)` and `void* shmem_access(int page_number)`
* File shmem_test.c: line 1-130, write this whole file to test shared memory page feature. 

## Part II
### Priority Based Scheduler
* File proc.c: line 417-429, build a syscall `int setpri(int priority)` to set the priority for each process
* File proc.c: line 430-449, create a syscall `int getpinfo(struct pstat* ps)` to get each process's information
* File proc.c: line 333-415, modify the scheduler function. 
* add system call for `int getpinfo(struct pstat* ps)` and `int setpri(int priority)` in the files defs.h, syscall.c, syscall.h, sysproc.c, usys.S and user.h just like what we do in the previous part of the project.

### File System Checker
* File /linux/fsChecker.c: line 1-556, create this whole file to implement file system checker. 
* File /linux/Makefile: line 1-6: create this whole file to compile and test fsChecker.c

### File System Integrity
* File fs.c: line 373-408, `static uint bmap(struct inode *ip, uint bn)`
* File fs.c: line 447-477,  `void stati(struct inode *ip, struct stat *st)`
* File fs.c: line 482-556, `int readi(struct inode *ip, char *dst, uint off, uint n)`
* File fs.c: line 561-625, `writei(struct inode *ip, char *src, uint off, uint n)`
* File sysfile.c: line 299-309, add the T_Checked judge code in the function call `sys_open(void)`
* File filestat.c: line 1-87, write this whole file to test the file system intergrity of the xv6
