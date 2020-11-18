
_testpriority:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }
}

    int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    setpritest();
  11:	e8 ba 00 00 00       	call   d0 <setpritest>
    pinfotest();
  16:	e8 c5 01 00 00       	call   1e0 <pinfotest>
    exit();
  1b:	e8 02 06 00 00       	call   622 <exit>

00000020 <ps>:
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	56                   	push   %esi
  24:	53                   	push   %ebx
    struct pstat* p = (struct pstat*) malloc(sizeof(struct pstat) * NPROC);
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	68 00 04 00 00       	push   $0x400
  2d:	e8 ae 09 00 00       	call   9e0 <malloc>
    if (!getpinfo(p)) {
  32:	89 04 24             	mov    %eax,(%esp)
    struct pstat* p = (struct pstat*) malloc(sizeof(struct pstat) * NPROC);
  35:	89 c3                	mov    %eax,%ebx
    if (!getpinfo(p)) {
  37:	e8 8e 06 00 00       	call   6ca <getpinfo>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	75 69                	jne    ac <ps+0x8c>
        printf(stdout, "forked proc (PID:%d) got proc info:\n", getpid());
  43:	e8 5a 06 00 00       	call   6a2 <getpid>
  48:	83 ec 04             	sub    $0x4,%esp
  4b:	50                   	push   %eax
  4c:	68 d8 0a 00 00       	push   $0xad8
  51:	ff 35 a0 0f 00 00    	pushl  0xfa0
  57:	e8 24 07 00 00       	call   780 <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	8d b3 00 04 00 00    	lea    0x400(%ebx),%esi
  65:	eb 10                	jmp    77 <ps+0x57>
  67:	89 f6                	mov    %esi,%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  70:	83 c3 10             	add    $0x10,%ebx
    for(int i = 0; i < NPROC; i++) {
  73:	39 f3                	cmp    %esi,%ebx
  75:	74 2c                	je     a3 <ps+0x83>
        if (p[i].inuse) 
  77:	8b 03                	mov    (%ebx),%eax
  79:	85 c0                	test   %eax,%eax
  7b:	74 f3                	je     70 <ps+0x50>
            printf(stdout, "\tpid: %d, hticks: %d, lticks: %d\n",
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	ff 73 0c             	pushl  0xc(%ebx)
  83:	ff 73 08             	pushl  0x8(%ebx)
  86:	ff 73 04             	pushl  0x4(%ebx)
  89:	68 00 0b 00 00       	push   $0xb00
  8e:	83 c3 10             	add    $0x10,%ebx
  91:	ff 35 a0 0f 00 00    	pushl  0xfa0
  97:	e8 e4 06 00 00       	call   780 <printf>
  9c:	83 c4 20             	add    $0x20,%esp
    for(int i = 0; i < NPROC; i++) {
  9f:	39 f3                	cmp    %esi,%ebx
  a1:	75 d4                	jne    77 <ps+0x57>
}
  a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  a6:	31 c0                	xor    %eax,%eax
  a8:	5b                   	pop    %ebx
  a9:	5e                   	pop    %esi
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    
        printf(stdout, "FAILED: could not get pinfo\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 f8 0b 00 00       	push   $0xbf8
  b4:	ff 35 a0 0f 00 00    	pushl  0xfa0
  ba:	e8 c1 06 00 00       	call   780 <printf>
  bf:	83 c4 10             	add    $0x10,%esp
  c2:	eb 9b                	jmp    5f <ps+0x3f>
  c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000d0 <setpritest>:
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	83 ec 10             	sub    $0x10,%esp
    printf(stdout, "start setpri test\n");
  d6:	68 15 0c 00 00       	push   $0xc15
  db:	ff 35 a0 0f 00 00    	pushl  0xfa0
  e1:	e8 9a 06 00 00       	call   780 <printf>
    int pid = fork();
  e6:	e8 2f 05 00 00       	call   61a <fork>
    if (pid > 0) {
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	85 c0                	test   %eax,%eax
  f0:	7e 1a                	jle    10c <setpritest+0x3c>
        wait();
  f2:	e8 33 05 00 00       	call   62a <wait>
        printf(stdout, "PASS: forked proc exited normally after elevation\n\n");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 24 0b 00 00       	push   $0xb24
  ff:	ff 35 a0 0f 00 00    	pushl  0xfa0
 105:	e8 76 06 00 00       	call   780 <printf>
}
 10a:	c9                   	leave  
 10b:	c3                   	ret    
        printf(stdout, "forked proc increasing priority to HIGH_PRI\n");
 10c:	50                   	push   %eax
 10d:	50                   	push   %eax
 10e:	68 58 0b 00 00       	push   $0xb58
 113:	ff 35 a0 0f 00 00    	pushl  0xfa0
 119:	e8 62 06 00 00       	call   780 <printf>
        if (setpri(2) >= 0)
 11e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 125:	e8 98 05 00 00       	call   6c2 <setpri>
 12a:	83 c4 10             	add    $0x10,%esp
 12d:	85 c0                	test   %eax,%eax
 12f:	78 2c                	js     15d <setpritest+0x8d>
            printf(stdout, "successfully elevated priority\n");
 131:	51                   	push   %ecx
 132:	51                   	push   %ecx
 133:	68 88 0b 00 00       	push   $0xb88
 138:	ff 35 a0 0f 00 00    	pushl  0xfa0
 13e:	e8 3d 06 00 00       	call   780 <printf>
 143:	83 c4 10             	add    $0x10,%esp
        printf(stdout, "forked proc sleeping to yield processor\n");
 146:	50                   	push   %eax
 147:	50                   	push   %eax
 148:	68 cc 0b 00 00       	push   $0xbcc
 14d:	ff 35 a0 0f 00 00    	pushl  0xfa0
 153:	e8 28 06 00 00       	call   780 <printf>
        exit();
 158:	e8 c5 04 00 00       	call   622 <exit>
            printf(stdout, "FAILED: could not elevate priority\n");
 15d:	52                   	push   %edx
 15e:	52                   	push   %edx
 15f:	68 a8 0b 00 00       	push   $0xba8
 164:	ff 35 a0 0f 00 00    	pushl  0xfa0
 16a:	e8 11 06 00 00       	call   780 <printf>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	eb d2                	jmp    146 <setpritest+0x76>
 174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 17a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000180 <busyloop>:
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 10             	sub    $0x10,%esp
    for (volatile int i = 0; i < spins; i++)
 186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
{
 18d:	8b 55 08             	mov    0x8(%ebp),%edx
    for (volatile int i = 0; i < spins; i++)
 190:	8b 45 f8             	mov    -0x8(%ebp),%eax
 193:	39 c2                	cmp    %eax,%edx
 195:	7e 39                	jle    1d0 <busyloop+0x50>
 197:	89 f6                	mov    %esi,%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for (volatile int j = 0; j < 1; j++)
 1a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1aa:	85 c0                	test   %eax,%eax
 1ac:	7f 12                	jg     1c0 <busyloop+0x40>
 1ae:	66 90                	xchg   %ax,%ax
 1b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1b3:	83 c0 01             	add    $0x1,%eax
 1b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 1b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1bc:	85 c0                	test   %eax,%eax
 1be:	7e f0                	jle    1b0 <busyloop+0x30>
    for (volatile int i = 0; i < spins; i++)
 1c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1c3:	83 c0 01             	add    $0x1,%eax
 1c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
 1c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1cc:	39 d0                	cmp    %edx,%eax
 1ce:	7c d0                	jl     1a0 <busyloop+0x20>
}
 1d0:	c9                   	leave  
 1d1:	c3                   	ret    
 1d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <pinfotest>:
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	56                   	push   %esi
 1e4:	53                   	push   %ebx
    for (int i = 0; i < 5; i++)
 1e5:	31 db                	xor    %ebx,%ebx
{
 1e7:	83 ec 28             	sub    $0x28,%esp
    printf(stdout, "start pinfo test\n");
 1ea:	68 28 0c 00 00       	push   $0xc28
 1ef:	ff 35 a0 0f 00 00    	pushl  0xfa0
 1f5:	e8 86 05 00 00       	call   780 <printf>
    setpri(2);
 1fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 201:	e8 bc 04 00 00       	call   6c2 <setpri>
 206:	83 c4 10             	add    $0x10,%esp
        tpid = fork();
 209:	e8 0c 04 00 00       	call   61a <fork>
        if (!tpid) 
 20e:	85 c0                	test   %eax,%eax
 210:	74 60                	je     272 <pinfotest+0x92>
        else printf(1, "Created working process %d\n", tpid);
 212:	83 ec 04             	sub    $0x4,%esp
    for (int i = 0; i < 5; i++)
 215:	83 c3 01             	add    $0x1,%ebx
        else printf(1, "Created working process %d\n", tpid);
 218:	50                   	push   %eax
 219:	68 3a 0c 00 00       	push   $0xc3a
 21e:	6a 01                	push   $0x1
 220:	e8 5b 05 00 00       	call   780 <printf>
    for (int i = 0; i < 5; i++)
 225:	83 c4 10             	add    $0x10,%esp
 228:	83 fb 05             	cmp    $0x5,%ebx
 22b:	75 dc                	jne    209 <pinfotest+0x29>
    setpri(1);
 22d:	83 ec 0c             	sub    $0xc,%esp
 230:	6a 01                	push   $0x1
 232:	e8 8b 04 00 00       	call   6c2 <setpri>
        ps(); 
 237:	e8 e4 fd ff ff       	call   20 <ps>
        wait();
 23c:	e8 e9 03 00 00       	call   62a <wait>
        ps(); 
 241:	e8 da fd ff ff       	call   20 <ps>
        wait();
 246:	e8 df 03 00 00       	call   62a <wait>
        ps(); 
 24b:	e8 d0 fd ff ff       	call   20 <ps>
        wait();
 250:	e8 d5 03 00 00       	call   62a <wait>
        ps(); 
 255:	e8 c6 fd ff ff       	call   20 <ps>
        wait();
 25a:	e8 cb 03 00 00       	call   62a <wait>
        ps(); 
 25f:	e8 bc fd ff ff       	call   20 <ps>
        wait();
 264:	83 c4 10             	add    $0x10,%esp
}
 267:	8d 65 f8             	lea    -0x8(%ebp),%esp
 26a:	5b                   	pop    %ebx
 26b:	5e                   	pop    %esi
 26c:	5d                   	pop    %ebp
        wait();
 26d:	e9 b8 03 00 00       	jmp    62a <wait>
            else pri = 1;
 272:	31 c0                	xor    %eax,%eax
 274:	83 fb 02             	cmp    $0x2,%ebx
 277:	0f 9f c0             	setg   %al
            setpri(pri); 
 27a:	83 ec 0c             	sub    $0xc,%esp
            else pri = 1;
 27d:	89 c6                	mov    %eax,%esi
 27f:	83 c6 01             	add    $0x1,%esi
            setpri(pri); 
 282:	56                   	push   %esi
 283:	e8 3a 04 00 00       	call   6c2 <setpri>
            busyloop(200000000/pri);
 288:	b8 00 c2 eb 0b       	mov    $0xbebc200,%eax
    for (volatile int i = 0; i < spins; i++)
 28d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            busyloop(200000000/pri);
 294:	83 c4 10             	add    $0x10,%esp
 297:	99                   	cltd   
 298:	f7 fe                	idiv   %esi
 29a:	89 c3                	mov    %eax,%ebx
    for (volatile int i = 0; i < spins; i++)
 29c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 29f:	39 c3                	cmp    %eax,%ebx
 2a1:	7e 35                	jle    2d8 <pinfotest+0xf8>
        for (volatile int j = 0; j < 1; j++)
 2a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 2aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ad:	85 c0                	test   %eax,%eax
 2af:	7f 17                	jg     2c8 <pinfotest+0xe8>
 2b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2bb:	83 c0 01             	add    $0x1,%eax
 2be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 2c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2c4:	85 c0                	test   %eax,%eax
 2c6:	7e f0                	jle    2b8 <pinfotest+0xd8>
    for (volatile int i = 0; i < spins; i++)
 2c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2cb:	83 c0 01             	add    $0x1,%eax
 2ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
 2d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2d4:	39 c3                	cmp    %eax,%ebx
 2d6:	7f cb                	jg     2a3 <pinfotest+0xc3>
 2d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 2df:	8b 45 d8             	mov    -0x28(%ebp),%eax
 2e2:	39 c3                	cmp    %eax,%ebx
 2e4:	7e 32                	jle    318 <pinfotest+0x138>
        for (volatile int j = 0; j < 1; j++)
 2e6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 2ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7f 14                	jg     308 <pinfotest+0x128>
 2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
 2fb:	83 c0 01             	add    $0x1,%eax
 2fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
 301:	8b 45 dc             	mov    -0x24(%ebp),%eax
 304:	85 c0                	test   %eax,%eax
 306:	7e f0                	jle    2f8 <pinfotest+0x118>
    for (volatile int i = 0; i < spins; i++)
 308:	8b 45 d8             	mov    -0x28(%ebp),%eax
 30b:	83 c0 01             	add    $0x1,%eax
 30e:	89 45 d8             	mov    %eax,-0x28(%ebp)
 311:	8b 45 d8             	mov    -0x28(%ebp),%eax
 314:	39 c3                	cmp    %eax,%ebx
 316:	7f ce                	jg     2e6 <pinfotest+0x106>
            if (pri == 2)
 318:	83 fe 02             	cmp    $0x2,%esi
 31b:	74 4e                	je     36b <pinfotest+0x18b>
                setpri(1);
 31d:	83 ec 0c             	sub    $0xc,%esp
 320:	6a 01                	push   $0x1
 322:	e8 9b 03 00 00       	call   6c2 <setpri>
    for (volatile int i = 0; i < spins; i++)
 327:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 32e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 331:	83 c4 10             	add    $0x10,%esp
 334:	39 c3                	cmp    %eax,%ebx
 336:	7e 2e                	jle    366 <pinfotest+0x186>
        for (volatile int j = 0; j < 1; j++)
 338:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 33f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 342:	85 c0                	test   %eax,%eax
 344:	7f 10                	jg     356 <pinfotest+0x176>
 346:	8b 45 f4             	mov    -0xc(%ebp),%eax
 349:	83 c0 01             	add    $0x1,%eax
 34c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 34f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 352:	85 c0                	test   %eax,%eax
 354:	7e f0                	jle    346 <pinfotest+0x166>
    for (volatile int i = 0; i < spins; i++)
 356:	8b 45 f0             	mov    -0x10(%ebp),%eax
 359:	83 c0 01             	add    $0x1,%eax
 35c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 35f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 362:	39 c3                	cmp    %eax,%ebx
 364:	7f d2                	jg     338 <pinfotest+0x158>
            exit();
 366:	e8 b7 02 00 00       	call   622 <exit>
                setpri(1);
 36b:	83 ec 0c             	sub    $0xc,%esp
 36e:	6a 01                	push   $0x1
 370:	e8 4d 03 00 00       	call   6c2 <setpri>
    for (volatile int i = 0; i < spins; i++)
 375:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 37c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 37f:	83 c4 10             	add    $0x10,%esp
 382:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 387:	7f 31                	jg     3ba <pinfotest+0x1da>
        for (volatile int j = 0; j < 1; j++)
 389:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 390:	8b 45 ec             	mov    -0x14(%ebp),%eax
 393:	85 c0                	test   %eax,%eax
 395:	7f 10                	jg     3a7 <pinfotest+0x1c7>
 397:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39a:	83 c0 01             	add    $0x1,%eax
 39d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a3:	85 c0                	test   %eax,%eax
 3a5:	7e f0                	jle    397 <pinfotest+0x1b7>
    for (volatile int i = 0; i < spins; i++)
 3a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3aa:	83 c0 01             	add    $0x1,%eax
 3ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
 3b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3b3:	3d ff e0 f5 05       	cmp    $0x5f5e0ff,%eax
 3b8:	7e cf                	jle    389 <pinfotest+0x1a9>
                ps();
 3ba:	e8 61 fc ff ff       	call   20 <ps>
 3bf:	eb a5                	jmp    366 <pinfotest+0x186>
 3c1:	66 90                	xchg   %ax,%ax
 3c3:	66 90                	xchg   %ax,%ax
 3c5:	66 90                	xchg   %ax,%ax
 3c7:	66 90                	xchg   %ax,%ax
 3c9:	66 90                	xchg   %ax,%ax
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3da:	89 c2                	mov    %eax,%edx
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e0:	83 c1 01             	add    $0x1,%ecx
 3e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3e7:	83 c2 01             	add    $0x1,%edx
 3ea:	84 db                	test   %bl,%bl
 3ec:	88 5a ff             	mov    %bl,-0x1(%edx)
 3ef:	75 ef                	jne    3e0 <strcpy+0x10>
    ;
  return os;
}
 3f1:	5b                   	pop    %ebx
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    
 3f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000400 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 55 08             	mov    0x8(%ebp),%edx
 407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 40a:	0f b6 02             	movzbl (%edx),%eax
 40d:	0f b6 19             	movzbl (%ecx),%ebx
 410:	84 c0                	test   %al,%al
 412:	75 1c                	jne    430 <strcmp+0x30>
 414:	eb 2a                	jmp    440 <strcmp+0x40>
 416:	8d 76 00             	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 420:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 423:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 426:	83 c1 01             	add    $0x1,%ecx
 429:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 42c:	84 c0                	test   %al,%al
 42e:	74 10                	je     440 <strcmp+0x40>
 430:	38 d8                	cmp    %bl,%al
 432:	74 ec                	je     420 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 434:	29 d8                	sub    %ebx,%eax
}
 436:	5b                   	pop    %ebx
 437:	5d                   	pop    %ebp
 438:	c3                   	ret    
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 440:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 442:	29 d8                	sub    %ebx,%eax
}
 444:	5b                   	pop    %ebx
 445:	5d                   	pop    %ebp
 446:	c3                   	ret    
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <strlen>:

uint
strlen(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 456:	80 39 00             	cmpb   $0x0,(%ecx)
 459:	74 15                	je     470 <strlen+0x20>
 45b:	31 d2                	xor    %edx,%edx
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	83 c2 01             	add    $0x1,%edx
 463:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 467:	89 d0                	mov    %edx,%eax
 469:	75 f5                	jne    460 <strlen+0x10>
    ;
  return n;
}
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 470:	31 c0                	xor    %eax,%eax
}
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 47a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000480 <memset>:

void*
memset(void *dst, int c, uint n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 487:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48a:	8b 45 0c             	mov    0xc(%ebp),%eax
 48d:	89 d7                	mov    %edx,%edi
 48f:	fc                   	cld    
 490:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 492:	89 d0                	mov    %edx,%eax
 494:	5f                   	pop    %edi
 495:	5d                   	pop    %ebp
 496:	c3                   	ret    
 497:	89 f6                	mov    %esi,%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <strchr>:

char*
strchr(const char *s, char c)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	53                   	push   %ebx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 4aa:	0f b6 10             	movzbl (%eax),%edx
 4ad:	84 d2                	test   %dl,%dl
 4af:	74 1d                	je     4ce <strchr+0x2e>
    if(*s == c)
 4b1:	38 d3                	cmp    %dl,%bl
 4b3:	89 d9                	mov    %ebx,%ecx
 4b5:	75 0d                	jne    4c4 <strchr+0x24>
 4b7:	eb 17                	jmp    4d0 <strchr+0x30>
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c0:	38 ca                	cmp    %cl,%dl
 4c2:	74 0c                	je     4d0 <strchr+0x30>
  for(; *s; s++)
 4c4:	83 c0 01             	add    $0x1,%eax
 4c7:	0f b6 10             	movzbl (%eax),%edx
 4ca:	84 d2                	test   %dl,%dl
 4cc:	75 f2                	jne    4c0 <strchr+0x20>
      return (char*)s;
  return 0;
 4ce:	31 c0                	xor    %eax,%eax
}
 4d0:	5b                   	pop    %ebx
 4d1:	5d                   	pop    %ebp
 4d2:	c3                   	ret    
 4d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004e0 <gets>:

char*
gets(char *buf, int max)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e6:	31 f6                	xor    %esi,%esi
 4e8:	89 f3                	mov    %esi,%ebx
{
 4ea:	83 ec 1c             	sub    $0x1c,%esp
 4ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4f0:	eb 2f                	jmp    521 <gets+0x41>
 4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4fb:	83 ec 04             	sub    $0x4,%esp
 4fe:	6a 01                	push   $0x1
 500:	50                   	push   %eax
 501:	6a 00                	push   $0x0
 503:	e8 32 01 00 00       	call   63a <read>
    if(cc < 1)
 508:	83 c4 10             	add    $0x10,%esp
 50b:	85 c0                	test   %eax,%eax
 50d:	7e 1c                	jle    52b <gets+0x4b>
      break;
    buf[i++] = c;
 50f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 513:	83 c7 01             	add    $0x1,%edi
 516:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 519:	3c 0a                	cmp    $0xa,%al
 51b:	74 23                	je     540 <gets+0x60>
 51d:	3c 0d                	cmp    $0xd,%al
 51f:	74 1f                	je     540 <gets+0x60>
  for(i=0; i+1 < max; ){
 521:	83 c3 01             	add    $0x1,%ebx
 524:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 527:	89 fe                	mov    %edi,%esi
 529:	7c cd                	jl     4f8 <gets+0x18>
 52b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 530:	c6 03 00             	movb   $0x0,(%ebx)
}
 533:	8d 65 f4             	lea    -0xc(%ebp),%esp
 536:	5b                   	pop    %ebx
 537:	5e                   	pop    %esi
 538:	5f                   	pop    %edi
 539:	5d                   	pop    %ebp
 53a:	c3                   	ret    
 53b:	90                   	nop
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 540:	8b 75 08             	mov    0x8(%ebp),%esi
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	01 de                	add    %ebx,%esi
 548:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 54a:	c6 03 00             	movb   $0x0,(%ebx)
}
 54d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 550:	5b                   	pop    %ebx
 551:	5e                   	pop    %esi
 552:	5f                   	pop    %edi
 553:	5d                   	pop    %ebp
 554:	c3                   	ret    
 555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000560 <stat>:

int
stat(const char *n, struct stat *st)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 565:	83 ec 08             	sub    $0x8,%esp
 568:	6a 00                	push   $0x0
 56a:	ff 75 08             	pushl  0x8(%ebp)
 56d:	e8 f0 00 00 00       	call   662 <open>
  if(fd < 0)
 572:	83 c4 10             	add    $0x10,%esp
 575:	85 c0                	test   %eax,%eax
 577:	78 27                	js     5a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	ff 75 0c             	pushl  0xc(%ebp)
 57f:	89 c3                	mov    %eax,%ebx
 581:	50                   	push   %eax
 582:	e8 f3 00 00 00       	call   67a <fstat>
  close(fd);
 587:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 58a:	89 c6                	mov    %eax,%esi
  close(fd);
 58c:	e8 b9 00 00 00       	call   64a <close>
  return r;
 591:	83 c4 10             	add    $0x10,%esp
}
 594:	8d 65 f8             	lea    -0x8(%ebp),%esp
 597:	89 f0                	mov    %esi,%eax
 599:	5b                   	pop    %ebx
 59a:	5e                   	pop    %esi
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    
 59d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 5a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 5a5:	eb ed                	jmp    594 <stat+0x34>
 5a7:	89 f6                	mov    %esi,%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005b0 <atoi>:

int
atoi(const char *s)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	53                   	push   %ebx
 5b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5b7:	0f be 11             	movsbl (%ecx),%edx
 5ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 5bd:	3c 09                	cmp    $0x9,%al
  n = 0;
 5bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 5c4:	77 1f                	ja     5e5 <atoi+0x35>
 5c6:	8d 76 00             	lea    0x0(%esi),%esi
 5c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 5d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5d3:	83 c1 01             	add    $0x1,%ecx
 5d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 5da:	0f be 11             	movsbl (%ecx),%edx
 5dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5e0:	80 fb 09             	cmp    $0x9,%bl
 5e3:	76 eb                	jbe    5d0 <atoi+0x20>
  return n;
}
 5e5:	5b                   	pop    %ebx
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    
 5e8:	90                   	nop
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	56                   	push   %esi
 5f4:	53                   	push   %ebx
 5f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5fe:	85 db                	test   %ebx,%ebx
 600:	7e 14                	jle    616 <memmove+0x26>
 602:	31 d2                	xor    %edx,%edx
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 608:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 60c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 60f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 612:	39 d3                	cmp    %edx,%ebx
 614:	75 f2                	jne    608 <memmove+0x18>
  return vdst;
}
 616:	5b                   	pop    %ebx
 617:	5e                   	pop    %esi
 618:	5d                   	pop    %ebp
 619:	c3                   	ret    

0000061a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 61a:	b8 01 00 00 00       	mov    $0x1,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <exit>:
SYSCALL(exit)
 622:	b8 02 00 00 00       	mov    $0x2,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <wait>:
SYSCALL(wait)
 62a:	b8 03 00 00 00       	mov    $0x3,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <pipe>:
SYSCALL(pipe)
 632:	b8 04 00 00 00       	mov    $0x4,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <read>:
SYSCALL(read)
 63a:	b8 05 00 00 00       	mov    $0x5,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <write>:
SYSCALL(write)
 642:	b8 10 00 00 00       	mov    $0x10,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <close>:
SYSCALL(close)
 64a:	b8 15 00 00 00       	mov    $0x15,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <kill>:
SYSCALL(kill)
 652:	b8 06 00 00 00       	mov    $0x6,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <exec>:
SYSCALL(exec)
 65a:	b8 07 00 00 00       	mov    $0x7,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <open>:
SYSCALL(open)
 662:	b8 0f 00 00 00       	mov    $0xf,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <mknod>:
SYSCALL(mknod)
 66a:	b8 11 00 00 00       	mov    $0x11,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <unlink>:
SYSCALL(unlink)
 672:	b8 12 00 00 00       	mov    $0x12,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <fstat>:
SYSCALL(fstat)
 67a:	b8 08 00 00 00       	mov    $0x8,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <link>:
SYSCALL(link)
 682:	b8 13 00 00 00       	mov    $0x13,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <mkdir>:
SYSCALL(mkdir)
 68a:	b8 14 00 00 00       	mov    $0x14,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <chdir>:
SYSCALL(chdir)
 692:	b8 09 00 00 00       	mov    $0x9,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <dup>:
SYSCALL(dup)
 69a:	b8 0a 00 00 00       	mov    $0xa,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <getpid>:
SYSCALL(getpid)
 6a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <sbrk>:
SYSCALL(sbrk)
 6aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <sleep>:
SYSCALL(sleep)
 6b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <uptime>:
SYSCALL(uptime)
 6ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <setpri>:
SYSCALL(setpri)
 6c2:	b8 16 00 00 00       	mov    $0x16,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <getpinfo>:
SYSCALL(getpinfo)
 6ca:	b8 17 00 00 00       	mov    $0x17,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    
 6d2:	66 90                	xchg   %ax,%ax
 6d4:	66 90                	xchg   %ax,%ax
 6d6:	66 90                	xchg   %ax,%ax
 6d8:	66 90                	xchg   %ax,%ax
 6da:	66 90                	xchg   %ax,%ax
 6dc:	66 90                	xchg   %ax,%ax
 6de:	66 90                	xchg   %ax,%ax

000006e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6e9:	85 d2                	test   %edx,%edx
{
 6eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6ee:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6f0:	79 76                	jns    768 <printint+0x88>
 6f2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6f6:	74 70                	je     768 <printint+0x88>
    x = -xx;
 6f8:	f7 d8                	neg    %eax
    neg = 1;
 6fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 701:	31 f6                	xor    %esi,%esi
 703:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 706:	eb 0a                	jmp    712 <printint+0x32>
 708:	90                   	nop
 709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 710:	89 fe                	mov    %edi,%esi
 712:	31 d2                	xor    %edx,%edx
 714:	8d 7e 01             	lea    0x1(%esi),%edi
 717:	f7 f1                	div    %ecx
 719:	0f b6 92 60 0c 00 00 	movzbl 0xc60(%edx),%edx
  }while((x /= base) != 0);
 720:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 722:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 725:	75 e9                	jne    710 <printint+0x30>
  if(neg)
 727:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 72a:	85 c0                	test   %eax,%eax
 72c:	74 08                	je     736 <printint+0x56>
    buf[i++] = '-';
 72e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 733:	8d 7e 02             	lea    0x2(%esi),%edi
 736:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 73a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 73d:	8d 76 00             	lea    0x0(%esi),%esi
 740:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 743:	83 ec 04             	sub    $0x4,%esp
 746:	83 ee 01             	sub    $0x1,%esi
 749:	6a 01                	push   $0x1
 74b:	53                   	push   %ebx
 74c:	57                   	push   %edi
 74d:	88 45 d7             	mov    %al,-0x29(%ebp)
 750:	e8 ed fe ff ff       	call   642 <write>

  while(--i >= 0)
 755:	83 c4 10             	add    $0x10,%esp
 758:	39 de                	cmp    %ebx,%esi
 75a:	75 e4                	jne    740 <printint+0x60>
    putc(fd, buf[i]);
}
 75c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75f:	5b                   	pop    %ebx
 760:	5e                   	pop    %esi
 761:	5f                   	pop    %edi
 762:	5d                   	pop    %ebp
 763:	c3                   	ret    
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 768:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 76f:	eb 90                	jmp    701 <printint+0x21>
 771:	eb 0d                	jmp    780 <printf>
 773:	90                   	nop
 774:	90                   	nop
 775:	90                   	nop
 776:	90                   	nop
 777:	90                   	nop
 778:	90                   	nop
 779:	90                   	nop
 77a:	90                   	nop
 77b:	90                   	nop
 77c:	90                   	nop
 77d:	90                   	nop
 77e:	90                   	nop
 77f:	90                   	nop

00000780 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 789:	8b 75 0c             	mov    0xc(%ebp),%esi
 78c:	0f b6 1e             	movzbl (%esi),%ebx
 78f:	84 db                	test   %bl,%bl
 791:	0f 84 b3 00 00 00    	je     84a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 797:	8d 45 10             	lea    0x10(%ebp),%eax
 79a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 79d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 79f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7a2:	eb 2f                	jmp    7d3 <printf+0x53>
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7a8:	83 f8 25             	cmp    $0x25,%eax
 7ab:	0f 84 a7 00 00 00    	je     858 <printf+0xd8>
  write(fd, &c, 1);
 7b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 7b4:	83 ec 04             	sub    $0x4,%esp
 7b7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 7ba:	6a 01                	push   $0x1
 7bc:	50                   	push   %eax
 7bd:	ff 75 08             	pushl  0x8(%ebp)
 7c0:	e8 7d fe ff ff       	call   642 <write>
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 7cb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7cf:	84 db                	test   %bl,%bl
 7d1:	74 77                	je     84a <printf+0xca>
    if(state == 0){
 7d3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7d5:	0f be cb             	movsbl %bl,%ecx
 7d8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7db:	74 cb                	je     7a8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7dd:	83 ff 25             	cmp    $0x25,%edi
 7e0:	75 e6                	jne    7c8 <printf+0x48>
      if(c == 'd'){
 7e2:	83 f8 64             	cmp    $0x64,%eax
 7e5:	0f 84 05 01 00 00    	je     8f0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7eb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7f1:	83 f9 70             	cmp    $0x70,%ecx
 7f4:	74 72                	je     868 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7f6:	83 f8 73             	cmp    $0x73,%eax
 7f9:	0f 84 99 00 00 00    	je     898 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ff:	83 f8 63             	cmp    $0x63,%eax
 802:	0f 84 08 01 00 00    	je     910 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 808:	83 f8 25             	cmp    $0x25,%eax
 80b:	0f 84 ef 00 00 00    	je     900 <printf+0x180>
  write(fd, &c, 1);
 811:	8d 45 e7             	lea    -0x19(%ebp),%eax
 814:	83 ec 04             	sub    $0x4,%esp
 817:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 81b:	6a 01                	push   $0x1
 81d:	50                   	push   %eax
 81e:	ff 75 08             	pushl  0x8(%ebp)
 821:	e8 1c fe ff ff       	call   642 <write>
 826:	83 c4 0c             	add    $0xc,%esp
 829:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 82c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 82f:	6a 01                	push   $0x1
 831:	50                   	push   %eax
 832:	ff 75 08             	pushl  0x8(%ebp)
 835:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 838:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 83a:	e8 03 fe ff ff       	call   642 <write>
  for(i = 0; fmt[i]; i++){
 83f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 843:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 846:	84 db                	test   %bl,%bl
 848:	75 89                	jne    7d3 <printf+0x53>
    }
  }
}
 84a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 84d:	5b                   	pop    %ebx
 84e:	5e                   	pop    %esi
 84f:	5f                   	pop    %edi
 850:	5d                   	pop    %ebp
 851:	c3                   	ret    
 852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 858:	bf 25 00 00 00       	mov    $0x25,%edi
 85d:	e9 66 ff ff ff       	jmp    7c8 <printf+0x48>
 862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	b9 10 00 00 00       	mov    $0x10,%ecx
 870:	6a 00                	push   $0x0
 872:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	8b 17                	mov    (%edi),%edx
 87a:	e8 61 fe ff ff       	call   6e0 <printint>
        ap++;
 87f:	89 f8                	mov    %edi,%eax
 881:	83 c4 10             	add    $0x10,%esp
      state = 0;
 884:	31 ff                	xor    %edi,%edi
        ap++;
 886:	83 c0 04             	add    $0x4,%eax
 889:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 88c:	e9 37 ff ff ff       	jmp    7c8 <printf+0x48>
 891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 89b:	8b 08                	mov    (%eax),%ecx
        ap++;
 89d:	83 c0 04             	add    $0x4,%eax
 8a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 8a3:	85 c9                	test   %ecx,%ecx
 8a5:	0f 84 8e 00 00 00    	je     939 <printf+0x1b9>
        while(*s != 0){
 8ab:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 8ae:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 8b0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 8b2:	84 c0                	test   %al,%al
 8b4:	0f 84 0e ff ff ff    	je     7c8 <printf+0x48>
 8ba:	89 75 d0             	mov    %esi,-0x30(%ebp)
 8bd:	89 de                	mov    %ebx,%esi
 8bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8c2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 8c5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8c8:	83 ec 04             	sub    $0x4,%esp
          s++;
 8cb:	83 c6 01             	add    $0x1,%esi
 8ce:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8d1:	6a 01                	push   $0x1
 8d3:	57                   	push   %edi
 8d4:	53                   	push   %ebx
 8d5:	e8 68 fd ff ff       	call   642 <write>
        while(*s != 0){
 8da:	0f b6 06             	movzbl (%esi),%eax
 8dd:	83 c4 10             	add    $0x10,%esp
 8e0:	84 c0                	test   %al,%al
 8e2:	75 e4                	jne    8c8 <printf+0x148>
 8e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8e7:	31 ff                	xor    %edi,%edi
 8e9:	e9 da fe ff ff       	jmp    7c8 <printf+0x48>
 8ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8f0:	83 ec 0c             	sub    $0xc,%esp
 8f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8f8:	6a 01                	push   $0x1
 8fa:	e9 73 ff ff ff       	jmp    872 <printf+0xf2>
 8ff:	90                   	nop
  write(fd, &c, 1);
 900:	83 ec 04             	sub    $0x4,%esp
 903:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 906:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 909:	6a 01                	push   $0x1
 90b:	e9 21 ff ff ff       	jmp    831 <printf+0xb1>
        putc(fd, *ap);
 910:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 913:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 916:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 918:	6a 01                	push   $0x1
        ap++;
 91a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 91d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 920:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 923:	50                   	push   %eax
 924:	ff 75 08             	pushl  0x8(%ebp)
 927:	e8 16 fd ff ff       	call   642 <write>
        ap++;
 92c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 92f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 932:	31 ff                	xor    %edi,%edi
 934:	e9 8f fe ff ff       	jmp    7c8 <printf+0x48>
          s = "(null)";
 939:	bb 56 0c 00 00       	mov    $0xc56,%ebx
        while(*s != 0){
 93e:	b8 28 00 00 00       	mov    $0x28,%eax
 943:	e9 72 ff ff ff       	jmp    8ba <printf+0x13a>
 948:	66 90                	xchg   %ax,%ax
 94a:	66 90                	xchg   %ax,%ax
 94c:	66 90                	xchg   %ax,%ax
 94e:	66 90                	xchg   %ax,%ax

00000950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 950:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 951:	a1 a4 0f 00 00       	mov    0xfa4,%eax
{
 956:	89 e5                	mov    %esp,%ebp
 958:	57                   	push   %edi
 959:	56                   	push   %esi
 95a:	53                   	push   %ebx
 95b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 95e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	39 c8                	cmp    %ecx,%eax
 96a:	8b 10                	mov    (%eax),%edx
 96c:	73 32                	jae    9a0 <free+0x50>
 96e:	39 d1                	cmp    %edx,%ecx
 970:	72 04                	jb     976 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	39 d0                	cmp    %edx,%eax
 974:	72 32                	jb     9a8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 976:	8b 73 fc             	mov    -0x4(%ebx),%esi
 979:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 97c:	39 fa                	cmp    %edi,%edx
 97e:	74 30                	je     9b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 980:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 983:	8b 50 04             	mov    0x4(%eax),%edx
 986:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 989:	39 f1                	cmp    %esi,%ecx
 98b:	74 3a                	je     9c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 98d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 98f:	a3 a4 0f 00 00       	mov    %eax,0xfa4
}
 994:	5b                   	pop    %ebx
 995:	5e                   	pop    %esi
 996:	5f                   	pop    %edi
 997:	5d                   	pop    %ebp
 998:	c3                   	ret    
 999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a0:	39 d0                	cmp    %edx,%eax
 9a2:	72 04                	jb     9a8 <free+0x58>
 9a4:	39 d1                	cmp    %edx,%ecx
 9a6:	72 ce                	jb     976 <free+0x26>
{
 9a8:	89 d0                	mov    %edx,%eax
 9aa:	eb bc                	jmp    968 <free+0x18>
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 9b0:	03 72 04             	add    0x4(%edx),%esi
 9b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b6:	8b 10                	mov    (%eax),%edx
 9b8:	8b 12                	mov    (%edx),%edx
 9ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 9bd:	8b 50 04             	mov    0x4(%eax),%edx
 9c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9c3:	39 f1                	cmp    %esi,%ecx
 9c5:	75 c6                	jne    98d <free+0x3d>
    p->s.size += bp->s.size;
 9c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9ca:	a3 a4 0f 00 00       	mov    %eax,0xfa4
    p->s.size += bp->s.size;
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9d5:	89 10                	mov    %edx,(%eax)
}
 9d7:	5b                   	pop    %ebx
 9d8:	5e                   	pop    %esi
 9d9:	5f                   	pop    %edi
 9da:	5d                   	pop    %ebp
 9db:	c3                   	ret    
 9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	57                   	push   %edi
 9e4:	56                   	push   %esi
 9e5:	53                   	push   %ebx
 9e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9ec:	8b 15 a4 0f 00 00    	mov    0xfa4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f2:	8d 78 07             	lea    0x7(%eax),%edi
 9f5:	c1 ef 03             	shr    $0x3,%edi
 9f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9fb:	85 d2                	test   %edx,%edx
 9fd:	0f 84 9d 00 00 00    	je     aa0 <malloc+0xc0>
 a03:	8b 02                	mov    (%edx),%eax
 a05:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a08:	39 cf                	cmp    %ecx,%edi
 a0a:	76 6c                	jbe    a78 <malloc+0x98>
 a0c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 a12:	bb 00 10 00 00       	mov    $0x1000,%ebx
 a17:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 a1a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 a21:	eb 0e                	jmp    a31 <malloc+0x51>
 a23:	90                   	nop
 a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a28:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a2a:	8b 48 04             	mov    0x4(%eax),%ecx
 a2d:	39 f9                	cmp    %edi,%ecx
 a2f:	73 47                	jae    a78 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a31:	39 05 a4 0f 00 00    	cmp    %eax,0xfa4
 a37:	89 c2                	mov    %eax,%edx
 a39:	75 ed                	jne    a28 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a3b:	83 ec 0c             	sub    $0xc,%esp
 a3e:	56                   	push   %esi
 a3f:	e8 66 fc ff ff       	call   6aa <sbrk>
  if(p == (char*)-1)
 a44:	83 c4 10             	add    $0x10,%esp
 a47:	83 f8 ff             	cmp    $0xffffffff,%eax
 a4a:	74 1c                	je     a68 <malloc+0x88>
  hp->s.size = nu;
 a4c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a4f:	83 ec 0c             	sub    $0xc,%esp
 a52:	83 c0 08             	add    $0x8,%eax
 a55:	50                   	push   %eax
 a56:	e8 f5 fe ff ff       	call   950 <free>
  return freep;
 a5b:	8b 15 a4 0f 00 00    	mov    0xfa4,%edx
      if((p = morecore(nunits)) == 0)
 a61:	83 c4 10             	add    $0x10,%esp
 a64:	85 d2                	test   %edx,%edx
 a66:	75 c0                	jne    a28 <malloc+0x48>
        return 0;
  }
}
 a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a6b:	31 c0                	xor    %eax,%eax
}
 a6d:	5b                   	pop    %ebx
 a6e:	5e                   	pop    %esi
 a6f:	5f                   	pop    %edi
 a70:	5d                   	pop    %ebp
 a71:	c3                   	ret    
 a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a78:	39 cf                	cmp    %ecx,%edi
 a7a:	74 54                	je     ad0 <malloc+0xf0>
        p->s.size -= nunits;
 a7c:	29 f9                	sub    %edi,%ecx
 a7e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a81:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a84:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a87:	89 15 a4 0f 00 00    	mov    %edx,0xfa4
}
 a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a90:	83 c0 08             	add    $0x8,%eax
}
 a93:	5b                   	pop    %ebx
 a94:	5e                   	pop    %esi
 a95:	5f                   	pop    %edi
 a96:	5d                   	pop    %ebp
 a97:	c3                   	ret    
 a98:	90                   	nop
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 aa0:	c7 05 a4 0f 00 00 a8 	movl   $0xfa8,0xfa4
 aa7:	0f 00 00 
 aaa:	c7 05 a8 0f 00 00 a8 	movl   $0xfa8,0xfa8
 ab1:	0f 00 00 
    base.s.size = 0;
 ab4:	b8 a8 0f 00 00       	mov    $0xfa8,%eax
 ab9:	c7 05 ac 0f 00 00 00 	movl   $0x0,0xfac
 ac0:	00 00 00 
 ac3:	e9 44 ff ff ff       	jmp    a0c <malloc+0x2c>
 ac8:	90                   	nop
 ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 ad0:	8b 08                	mov    (%eax),%ecx
 ad2:	89 0a                	mov    %ecx,(%edx)
 ad4:	eb b1                	jmp    a87 <malloc+0xa7>
