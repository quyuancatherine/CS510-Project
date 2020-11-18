
_shmem_test:     file format elf32-i386


Disassembly of section .text:

00001000 <init_shmem>:

int *page0, *page1, *page2, *page3;
char* eliteargv[] = {"elite", 0};

// Grab all the shared pages
void init_shmem() {
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 14             	sub    $0x14,%esp
  page0 = (int*)shmem_access(0);
    1006:	6a 00                	push   $0x0
    1008:	e8 c8 05 00 00       	call   15d5 <shmem_access>
    100d:	a3 cc 1e 00 00       	mov    %eax,0x1ecc
  page1 = (int*)shmem_access(1);
    1012:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1019:	e8 b7 05 00 00       	call   15d5 <shmem_access>
    101e:	a3 d8 1e 00 00       	mov    %eax,0x1ed8
  page2 = (int*)shmem_access(2);
    1023:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    102a:	e8 a6 05 00 00       	call   15d5 <shmem_access>
    102f:	a3 d4 1e 00 00       	mov    %eax,0x1ed4
  page3 = (int*)shmem_access(3);
    1034:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
    103b:	e8 95 05 00 00       	call   15d5 <shmem_access>
    1040:	a3 d0 1e 00 00       	mov    %eax,0x1ed0
}
    1045:	83 c4 10             	add    $0x10,%esp
    1048:	c9                   	leave  
    1049:	c3                   	ret    

0000104a <access_pages_test>:

// Can we read/write to shared pages?
void access_pages_test() {
    104a:	55                   	push   %ebp
    104b:	89 e5                	mov    %esp,%ebp
    104d:	83 ec 10             	sub    $0x10,%esp
  printf(1, "START ACCESS TEST\n");
    1050:	68 88 19 00 00       	push   $0x1988
    1055:	6a 01                	push   $0x1
    1057:	e8 13 06 00 00       	call   166f <printf>

  page0[0] = 10;
    105c:	a1 cc 1e 00 00       	mov    0x1ecc,%eax
    1061:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
  page1[0] = 20;
    1067:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
    106c:	c7 00 14 00 00 00    	movl   $0x14,(%eax)
  page2[0] = 30;
    1072:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
    1077:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
  page3[0] = 40;
    107d:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    1082:	c7 00 28 00 00 00    	movl   $0x28,(%eax)

  printf(1, "page0 access: int = %d\n", page0[0]);
    1088:	83 c4 0c             	add    $0xc,%esp
    108b:	a1 cc 1e 00 00       	mov    0x1ecc,%eax
    1090:	ff 30                	pushl  (%eax)
    1092:	68 9b 19 00 00       	push   $0x199b
    1097:	6a 01                	push   $0x1
    1099:	e8 d1 05 00 00       	call   166f <printf>
  printf(1, "page1 access: int = %d\n", page1[0]);
    109e:	83 c4 0c             	add    $0xc,%esp
    10a1:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
    10a6:	ff 30                	pushl  (%eax)
    10a8:	68 b3 19 00 00       	push   $0x19b3
    10ad:	6a 01                	push   $0x1
    10af:	e8 bb 05 00 00       	call   166f <printf>
  printf(1, "page2 access: int = %d\n", page2[0]);
    10b4:	83 c4 0c             	add    $0xc,%esp
    10b7:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
    10bc:	ff 30                	pushl  (%eax)
    10be:	68 cb 19 00 00       	push   $0x19cb
    10c3:	6a 01                	push   $0x1
    10c5:	e8 a5 05 00 00       	call   166f <printf>
  printf(1, "page3 access: int = %d\n", page3[0]);
    10ca:	83 c4 0c             	add    $0xc,%esp
    10cd:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    10d2:	ff 30                	pushl  (%eax)
    10d4:	68 e3 19 00 00       	push   $0x19e3
    10d9:	6a 01                	push   $0x1
    10db:	e8 8f 05 00 00       	call   166f <printf>

  if (   page0[0] == 10
    10e0:	83 c4 10             	add    $0x10,%esp
    10e3:	a1 cc 1e 00 00       	mov    0x1ecc,%eax
    10e8:	83 38 0a             	cmpl   $0xa,(%eax)
    10eb:	75 0a                	jne    10f7 <access_pages_test+0xad>
      && page1[0] == 20
    10ed:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
    10f2:	83 38 14             	cmpl   $0x14,(%eax)
    10f5:	74 14                	je     110b <access_pages_test+0xc1>
      && page2[0] == 30
      && page3[0] == 40) {
    printf(1, "ACCESS TEST PASS\n");
  } else {
    printf(1, "ACCESS TEST FAIL\n");
    10f7:	83 ec 08             	sub    $0x8,%esp
    10fa:	68 0d 1a 00 00       	push   $0x1a0d
    10ff:	6a 01                	push   $0x1
    1101:	e8 69 05 00 00       	call   166f <printf>
    1106:	83 c4 10             	add    $0x10,%esp
  }
}
    1109:	c9                   	leave  
    110a:	c3                   	ret    
      && page2[0] == 30
    110b:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
    1110:	83 38 1e             	cmpl   $0x1e,(%eax)
    1113:	75 e2                	jne    10f7 <access_pages_test+0xad>
      && page3[0] == 40) {
    1115:	a1 d0 1e 00 00       	mov    0x1ed0,%eax
    111a:	83 38 28             	cmpl   $0x28,(%eax)
    111d:	75 d8                	jne    10f7 <access_pages_test+0xad>
    printf(1, "ACCESS TEST PASS\n");
    111f:	83 ec 08             	sub    $0x8,%esp
    1122:	68 fb 19 00 00       	push   $0x19fb
    1127:	6a 01                	push   $0x1
    1129:	e8 41 05 00 00       	call   166f <printf>
    112e:	83 c4 10             	add    $0x10,%esp
    1131:	eb d6                	jmp    1109 <access_pages_test+0xbf>

00001133 <fork_ref_test>:

// Does fork() share pages and keep counts correct?
void fork_ref_test() {
    1133:	55                   	push   %ebp
    1134:	89 e5                	mov    %esp,%ebp
    1136:	53                   	push   %ebx
    1137:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "START FORK COUNT TEST\n");
    113a:	68 1f 1a 00 00       	push   $0x1a1f
    113f:	6a 01                	push   $0x1
    1141:	e8 29 05 00 00       	call   166f <printf>
    1146:	83 c4 10             	add    $0x10,%esp
  int i = 0;
    1149:	bb 00 00 00 00       	mov    $0x0,%ebx
  int pid;

  // make 5 children
  do {
    pid = fork();
    114e:	e8 da 03 00 00       	call   152d <fork>
    i++;
    1153:	83 c3 01             	add    $0x1,%ebx
  } while(pid > 0 && i < 5);
    1156:	85 c0                	test   %eax,%eax
    1158:	7e 05                	jle    115f <fork_ref_test+0x2c>
    115a:	83 fb 04             	cmp    $0x4,%ebx
    115d:	7e ef                	jle    114e <fork_ref_test+0x1b>

  // Just kill the child
  if (pid == 0) {
    115f:	85 c0                	test   %eax,%eax
    1161:	74 7a                	je     11dd <fork_ref_test+0xaa>
    exit();
  } else {
    int count = shmem_count(0);
    1163:	83 ec 0c             	sub    $0xc,%esp
    1166:	6a 00                	push   $0x0
    1168:	e8 70 04 00 00       	call   15dd <shmem_count>
    116d:	89 c3                	mov    %eax,%ebx
    printf(1, "ref count for page0 = %d\n", count);
    116f:	83 c4 0c             	add    $0xc,%esp
    1172:	50                   	push   %eax
    1173:	68 36 1a 00 00       	push   $0x1a36
    1178:	6a 01                	push   $0x1
    117a:	e8 f0 04 00 00       	call   166f <printf>
    if(count == 6) {
    117f:	83 c4 10             	add    $0x10,%esp
    1182:	83 fb 06             	cmp    $0x6,%ebx
    1185:	74 5b                	je     11e2 <fork_ref_test+0xaf>
      printf(1, "COUNT TEST PASSED\n");
    } else {
      printf(1, "COUNT TEST FAILED\n");      
    1187:	83 ec 08             	sub    $0x8,%esp
    118a:	68 63 1a 00 00       	push   $0x1a63
    118f:	6a 01                	push   $0x1
    1191:	e8 d9 04 00 00       	call   166f <printf>
    1196:	83 c4 10             	add    $0x10,%esp
    }
    while(wait() > 0);
    1199:	e8 9f 03 00 00       	call   153d <wait>
    119e:	85 c0                	test   %eax,%eax
    11a0:	7f f7                	jg     1199 <fork_ref_test+0x66>
  }
  int count = shmem_count(0);
    11a2:	83 ec 0c             	sub    $0xc,%esp
    11a5:	6a 00                	push   $0x0
    11a7:	e8 31 04 00 00       	call   15dd <shmem_count>
    11ac:	89 c3                	mov    %eax,%ebx
    printf(1, "ref count for page0 = %d\n", count);
    11ae:	83 c4 0c             	add    $0xc,%esp
    11b1:	50                   	push   %eax
    11b2:	68 36 1a 00 00       	push   $0x1a36
    11b7:	6a 01                	push   $0x1
    11b9:	e8 b1 04 00 00       	call   166f <printf>
    if(count == 1) {
    11be:	83 c4 10             	add    $0x10,%esp
    11c1:	83 fb 01             	cmp    $0x1,%ebx
    11c4:	74 30                	je     11f6 <fork_ref_test+0xc3>
      printf(1, "COUNT TEST PASSED\n");
    } else {
      printf(1, "COUNT TEST FAILED\n");      
    11c6:	83 ec 08             	sub    $0x8,%esp
    11c9:	68 63 1a 00 00       	push   $0x1a63
    11ce:	6a 01                	push   $0x1
    11d0:	e8 9a 04 00 00       	call   166f <printf>
    11d5:	83 c4 10             	add    $0x10,%esp
    }
}
    11d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11db:	c9                   	leave  
    11dc:	c3                   	ret    
    exit();
    11dd:	e8 53 03 00 00       	call   1535 <exit>
      printf(1, "COUNT TEST PASSED\n");
    11e2:	83 ec 08             	sub    $0x8,%esp
    11e5:	68 50 1a 00 00       	push   $0x1a50
    11ea:	6a 01                	push   $0x1
    11ec:	e8 7e 04 00 00       	call   166f <printf>
    11f1:	83 c4 10             	add    $0x10,%esp
    11f4:	eb a3                	jmp    1199 <fork_ref_test+0x66>
      printf(1, "COUNT TEST PASSED\n");
    11f6:	83 ec 08             	sub    $0x8,%esp
    11f9:	68 50 1a 00 00       	push   $0x1a50
    11fe:	6a 01                	push   $0x1
    1200:	e8 6a 04 00 00       	call   166f <printf>
    1205:	83 c4 10             	add    $0x10,%esp
    1208:	eb ce                	jmp    11d8 <fork_ref_test+0xa5>

0000120a <fork_access_test>:

// Can forked procs communicate through shared pages?
void fork_access_test() {
    120a:	55                   	push   %ebp
    120b:	89 e5                	mov    %esp,%ebp
    120d:	83 ec 10             	sub    $0x10,%esp
  printf(1, "START FORK ACCESS TEST\n");
    1210:	68 76 1a 00 00       	push   $0x1a76
    1215:	6a 01                	push   $0x1
    1217:	e8 53 04 00 00       	call   166f <printf>
  int pid = fork();
    121c:	e8 0c 03 00 00       	call   152d <fork>

  if (pid == 0) {
    1221:	83 c4 10             	add    $0x10,%esp
    1224:	85 c0                	test   %eax,%eax
    1226:	74 4e                	je     1276 <fork_access_test+0x6c>
    page1[0] = 5656;
    printf(1, "child setting shared mem to 5656\n");
    exit();
  } else {
    printf(1,"parent waiting for child to touch shared memory\n");
    1228:	83 ec 08             	sub    $0x8,%esp
    122b:	68 34 1b 00 00       	push   $0x1b34
    1230:	6a 01                	push   $0x1
    1232:	e8 38 04 00 00       	call   166f <printf>
    wait();
    1237:	e8 01 03 00 00       	call   153d <wait>
    printf(1, "parent found %d in page1\n", page1[0]);
    123c:	83 c4 0c             	add    $0xc,%esp
    123f:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
    1244:	ff 30                	pushl  (%eax)
    1246:	68 8e 1a 00 00       	push   $0x1a8e
    124b:	6a 01                	push   $0x1
    124d:	e8 1d 04 00 00       	call   166f <printf>
    if (page1[0] == 5656) {
    1252:	83 c4 10             	add    $0x10,%esp
    1255:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
    125a:	81 38 18 16 00 00    	cmpl   $0x1618,(%eax)
    1260:	74 33                	je     1295 <fork_access_test+0x8b>
      printf(1, "FORK ACCESS TEST PASSED\n");
    } else {
      printf(1, "FORK ACCESS TEST FAILED\n");
    1262:	83 ec 08             	sub    $0x8,%esp
    1265:	68 c1 1a 00 00       	push   $0x1ac1
    126a:	6a 01                	push   $0x1
    126c:	e8 fe 03 00 00       	call   166f <printf>
    1271:	83 c4 10             	add    $0x10,%esp
    }
  }
}
    1274:	c9                   	leave  
    1275:	c3                   	ret    
    page1[0] = 5656;
    1276:	a1 d8 1e 00 00       	mov    0x1ed8,%eax
    127b:	c7 00 18 16 00 00    	movl   $0x1618,(%eax)
    printf(1, "child setting shared mem to 5656\n");
    1281:	83 ec 08             	sub    $0x8,%esp
    1284:	68 10 1b 00 00       	push   $0x1b10
    1289:	6a 01                	push   $0x1
    128b:	e8 df 03 00 00       	call   166f <printf>
    exit();
    1290:	e8 a0 02 00 00       	call   1535 <exit>
      printf(1, "FORK ACCESS TEST PASSED\n");
    1295:	83 ec 08             	sub    $0x8,%esp
    1298:	68 a8 1a 00 00       	push   $0x1aa8
    129d:	6a 01                	push   $0x1
    129f:	e8 cb 03 00 00       	call   166f <printf>
    12a4:	83 c4 10             	add    $0x10,%esp
    12a7:	eb cb                	jmp    1274 <fork_access_test+0x6a>

000012a9 <exec_test>:

// Can I exec another proc and communicate with it?
void exec_test() {
    12a9:	55                   	push   %ebp
    12aa:	89 e5                	mov    %esp,%ebp
    12ac:	53                   	push   %ebx
    12ad:	83 ec 04             	sub    $0x4,%esp
  page2[0] = 0;
    12b0:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
    12b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  int pid = fork();
    12bb:	e8 6d 02 00 00       	call   152d <fork>
    12c0:	89 c3                	mov    %eax,%ebx
  printf(1, "pid: %d\n", pid);
    12c2:	83 ec 04             	sub    $0x4,%esp
    12c5:	50                   	push   %eax
    12c6:	68 da 1a 00 00       	push   $0x1ada
    12cb:	6a 01                	push   $0x1
    12cd:	e8 9d 03 00 00       	call   166f <printf>
  if (pid == 0) {
    12d2:	83 c4 10             	add    $0x10,%esp
    12d5:	85 db                	test   %ebx,%ebx
    12d7:	75 52                	jne    132b <exec_test+0x82>
    exec("elite", eliteargv);
    12d9:	83 ec 08             	sub    $0x8,%esp
    12dc:	68 b8 1e 00 00       	push   $0x1eb8
    12e1:	68 e3 1a 00 00       	push   $0x1ae3
    12e6:	e8 82 02 00 00       	call   156d <exec>
    12eb:	83 c4 10             	add    $0x10,%esp
  } else {
    wait();
  }

  // exec proc should set shared int
  printf(1, "found the message %d from exec() proc\n", page2[0]);
    12ee:	83 ec 04             	sub    $0x4,%esp
    12f1:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
    12f6:	ff 30                	pushl  (%eax)
    12f8:	68 68 1b 00 00       	push   $0x1b68
    12fd:	6a 01                	push   $0x1
    12ff:	e8 6b 03 00 00       	call   166f <printf>
  if (1337 == page2[0]) {
    1304:	83 c4 10             	add    $0x10,%esp
    1307:	a1 d4 1e 00 00       	mov    0x1ed4,%eax
    130c:	81 38 39 05 00 00    	cmpl   $0x539,(%eax)
    1312:	74 1e                	je     1332 <exec_test+0x89>
    printf(1, "EXEC TEST PASSED\n");
  } else {
    printf(1, "EXEC TEST FAILED\n");
    1314:	83 ec 08             	sub    $0x8,%esp
    1317:	68 fb 1a 00 00       	push   $0x1afb
    131c:	6a 01                	push   $0x1
    131e:	e8 4c 03 00 00       	call   166f <printf>
    1323:	83 c4 10             	add    $0x10,%esp
  }
}
    1326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1329:	c9                   	leave  
    132a:	c3                   	ret    
    wait();
    132b:	e8 0d 02 00 00       	call   153d <wait>
    1330:	eb bc                	jmp    12ee <exec_test+0x45>
    printf(1, "EXEC TEST PASSED\n");
    1332:	83 ec 08             	sub    $0x8,%esp
    1335:	68 e9 1a 00 00       	push   $0x1ae9
    133a:	6a 01                	push   $0x1
    133c:	e8 2e 03 00 00       	call   166f <printf>
    1341:	83 c4 10             	add    $0x10,%esp
    1344:	eb e0                	jmp    1326 <exec_test+0x7d>

00001346 <main>:

int main(int argc, char const *argv[]) {
    1346:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    134a:	83 e4 f0             	and    $0xfffffff0,%esp
    134d:	ff 71 fc             	pushl  -0x4(%ecx)
    1350:	55                   	push   %ebp
    1351:	89 e5                	mov    %esp,%ebp
    1353:	51                   	push   %ecx
    1354:	83 ec 04             	sub    $0x4,%esp
  init_shmem();
    1357:	e8 a4 fc ff ff       	call   1000 <init_shmem>
  access_pages_test();
    135c:	e8 e9 fc ff ff       	call   104a <access_pages_test>
  fork_ref_test();
    1361:	e8 cd fd ff ff       	call   1133 <fork_ref_test>
  fork_access_test();
    1366:	e8 9f fe ff ff       	call   120a <fork_access_test>
  exec_test();
    136b:	e8 39 ff ff ff       	call   12a9 <exec_test>
  exit();
    1370:	e8 c0 01 00 00       	call   1535 <exit>

00001375 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1375:	55                   	push   %ebp
    1376:	89 e5                	mov    %esp,%ebp
    1378:	53                   	push   %ebx
    1379:	8b 45 08             	mov    0x8(%ebp),%eax
    137c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    137f:	89 c2                	mov    %eax,%edx
    1381:	83 c1 01             	add    $0x1,%ecx
    1384:	83 c2 01             	add    $0x1,%edx
    1387:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    138b:	88 5a ff             	mov    %bl,-0x1(%edx)
    138e:	84 db                	test   %bl,%bl
    1390:	75 ef                	jne    1381 <strcpy+0xc>
    ;
  return os;
}
    1392:	5b                   	pop    %ebx
    1393:	5d                   	pop    %ebp
    1394:	c3                   	ret    

00001395 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1395:	55                   	push   %ebp
    1396:	89 e5                	mov    %esp,%ebp
    1398:	8b 4d 08             	mov    0x8(%ebp),%ecx
    139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    139e:	0f b6 01             	movzbl (%ecx),%eax
    13a1:	84 c0                	test   %al,%al
    13a3:	74 15                	je     13ba <strcmp+0x25>
    13a5:	3a 02                	cmp    (%edx),%al
    13a7:	75 11                	jne    13ba <strcmp+0x25>
    p++, q++;
    13a9:	83 c1 01             	add    $0x1,%ecx
    13ac:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    13af:	0f b6 01             	movzbl (%ecx),%eax
    13b2:	84 c0                	test   %al,%al
    13b4:	74 04                	je     13ba <strcmp+0x25>
    13b6:	3a 02                	cmp    (%edx),%al
    13b8:	74 ef                	je     13a9 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    13ba:	0f b6 c0             	movzbl %al,%eax
    13bd:	0f b6 12             	movzbl (%edx),%edx
    13c0:	29 d0                	sub    %edx,%eax
}
    13c2:	5d                   	pop    %ebp
    13c3:	c3                   	ret    

000013c4 <strlen>:

uint
strlen(const char *s)
{
    13c4:	55                   	push   %ebp
    13c5:	89 e5                	mov    %esp,%ebp
    13c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    13ca:	80 39 00             	cmpb   $0x0,(%ecx)
    13cd:	74 12                	je     13e1 <strlen+0x1d>
    13cf:	ba 00 00 00 00       	mov    $0x0,%edx
    13d4:	83 c2 01             	add    $0x1,%edx
    13d7:	89 d0                	mov    %edx,%eax
    13d9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    13dd:	75 f5                	jne    13d4 <strlen+0x10>
    ;
  return n;
}
    13df:	5d                   	pop    %ebp
    13e0:	c3                   	ret    
  for(n = 0; s[n]; n++)
    13e1:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    13e6:	eb f7                	jmp    13df <strlen+0x1b>

000013e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    13e8:	55                   	push   %ebp
    13e9:	89 e5                	mov    %esp,%ebp
    13eb:	57                   	push   %edi
    13ec:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    13ef:	89 d7                	mov    %edx,%edi
    13f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
    13f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f7:	fc                   	cld    
    13f8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    13fa:	89 d0                	mov    %edx,%eax
    13fc:	5f                   	pop    %edi
    13fd:	5d                   	pop    %ebp
    13fe:	c3                   	ret    

000013ff <strchr>:

char*
strchr(const char *s, char c)
{
    13ff:	55                   	push   %ebp
    1400:	89 e5                	mov    %esp,%ebp
    1402:	53                   	push   %ebx
    1403:	8b 45 08             	mov    0x8(%ebp),%eax
    1406:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    1409:	0f b6 10             	movzbl (%eax),%edx
    140c:	84 d2                	test   %dl,%dl
    140e:	74 1e                	je     142e <strchr+0x2f>
    1410:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1412:	38 d3                	cmp    %dl,%bl
    1414:	74 15                	je     142b <strchr+0x2c>
  for(; *s; s++)
    1416:	83 c0 01             	add    $0x1,%eax
    1419:	0f b6 10             	movzbl (%eax),%edx
    141c:	84 d2                	test   %dl,%dl
    141e:	74 06                	je     1426 <strchr+0x27>
    if(*s == c)
    1420:	38 ca                	cmp    %cl,%dl
    1422:	75 f2                	jne    1416 <strchr+0x17>
    1424:	eb 05                	jmp    142b <strchr+0x2c>
      return (char*)s;
  return 0;
    1426:	b8 00 00 00 00       	mov    $0x0,%eax
}
    142b:	5b                   	pop    %ebx
    142c:	5d                   	pop    %ebp
    142d:	c3                   	ret    
  return 0;
    142e:	b8 00 00 00 00       	mov    $0x0,%eax
    1433:	eb f6                	jmp    142b <strchr+0x2c>

00001435 <gets>:

char*
gets(char *buf, int max)
{
    1435:	55                   	push   %ebp
    1436:	89 e5                	mov    %esp,%ebp
    1438:	57                   	push   %edi
    1439:	56                   	push   %esi
    143a:	53                   	push   %ebx
    143b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    143e:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1443:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1446:	8d 5e 01             	lea    0x1(%esi),%ebx
    1449:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    144c:	7d 2b                	jge    1479 <gets+0x44>
    cc = read(0, &c, 1);
    144e:	83 ec 04             	sub    $0x4,%esp
    1451:	6a 01                	push   $0x1
    1453:	57                   	push   %edi
    1454:	6a 00                	push   $0x0
    1456:	e8 f2 00 00 00       	call   154d <read>
    if(cc < 1)
    145b:	83 c4 10             	add    $0x10,%esp
    145e:	85 c0                	test   %eax,%eax
    1460:	7e 17                	jle    1479 <gets+0x44>
      break;
    buf[i++] = c;
    1462:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1466:	8b 55 08             	mov    0x8(%ebp),%edx
    1469:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    146d:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    146f:	3c 0a                	cmp    $0xa,%al
    1471:	74 04                	je     1477 <gets+0x42>
    1473:	3c 0d                	cmp    $0xd,%al
    1475:	75 cf                	jne    1446 <gets+0x11>
  for(i=0; i+1 < max; ){
    1477:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1479:	8b 45 08             	mov    0x8(%ebp),%eax
    147c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1480:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1483:	5b                   	pop    %ebx
    1484:	5e                   	pop    %esi
    1485:	5f                   	pop    %edi
    1486:	5d                   	pop    %ebp
    1487:	c3                   	ret    

00001488 <stat>:

int
stat(const char *n, struct stat *st)
{
    1488:	55                   	push   %ebp
    1489:	89 e5                	mov    %esp,%ebp
    148b:	56                   	push   %esi
    148c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    148d:	83 ec 08             	sub    $0x8,%esp
    1490:	6a 00                	push   $0x0
    1492:	ff 75 08             	pushl  0x8(%ebp)
    1495:	e8 db 00 00 00       	call   1575 <open>
  if(fd < 0)
    149a:	83 c4 10             	add    $0x10,%esp
    149d:	85 c0                	test   %eax,%eax
    149f:	78 24                	js     14c5 <stat+0x3d>
    14a1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    14a3:	83 ec 08             	sub    $0x8,%esp
    14a6:	ff 75 0c             	pushl  0xc(%ebp)
    14a9:	50                   	push   %eax
    14aa:	e8 de 00 00 00       	call   158d <fstat>
    14af:	89 c6                	mov    %eax,%esi
  close(fd);
    14b1:	89 1c 24             	mov    %ebx,(%esp)
    14b4:	e8 a4 00 00 00       	call   155d <close>
  return r;
    14b9:	83 c4 10             	add    $0x10,%esp
}
    14bc:	89 f0                	mov    %esi,%eax
    14be:	8d 65 f8             	lea    -0x8(%ebp),%esp
    14c1:	5b                   	pop    %ebx
    14c2:	5e                   	pop    %esi
    14c3:	5d                   	pop    %ebp
    14c4:	c3                   	ret    
    return -1;
    14c5:	be ff ff ff ff       	mov    $0xffffffff,%esi
    14ca:	eb f0                	jmp    14bc <stat+0x34>

000014cc <atoi>:

int
atoi(const char *s)
{
    14cc:	55                   	push   %ebp
    14cd:	89 e5                	mov    %esp,%ebp
    14cf:	53                   	push   %ebx
    14d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    14d3:	0f b6 11             	movzbl (%ecx),%edx
    14d6:	8d 42 d0             	lea    -0x30(%edx),%eax
    14d9:	3c 09                	cmp    $0x9,%al
    14db:	77 20                	ja     14fd <atoi+0x31>
  n = 0;
    14dd:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    14e2:	83 c1 01             	add    $0x1,%ecx
    14e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
    14e8:	0f be d2             	movsbl %dl,%edx
    14eb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    14ef:	0f b6 11             	movzbl (%ecx),%edx
    14f2:	8d 5a d0             	lea    -0x30(%edx),%ebx
    14f5:	80 fb 09             	cmp    $0x9,%bl
    14f8:	76 e8                	jbe    14e2 <atoi+0x16>
  return n;
}
    14fa:	5b                   	pop    %ebx
    14fb:	5d                   	pop    %ebp
    14fc:	c3                   	ret    
  n = 0;
    14fd:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1502:	eb f6                	jmp    14fa <atoi+0x2e>

00001504 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1504:	55                   	push   %ebp
    1505:	89 e5                	mov    %esp,%ebp
    1507:	56                   	push   %esi
    1508:	53                   	push   %ebx
    1509:	8b 45 08             	mov    0x8(%ebp),%eax
    150c:	8b 75 0c             	mov    0xc(%ebp),%esi
    150f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1512:	85 db                	test   %ebx,%ebx
    1514:	7e 13                	jle    1529 <memmove+0x25>
    1516:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    151b:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    151f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1522:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1525:	39 d3                	cmp    %edx,%ebx
    1527:	75 f2                	jne    151b <memmove+0x17>
  return vdst;
}
    1529:	5b                   	pop    %ebx
    152a:	5e                   	pop    %esi
    152b:	5d                   	pop    %ebp
    152c:	c3                   	ret    

0000152d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    152d:	b8 01 00 00 00       	mov    $0x1,%eax
    1532:	cd 40                	int    $0x40
    1534:	c3                   	ret    

00001535 <exit>:
SYSCALL(exit)
    1535:	b8 02 00 00 00       	mov    $0x2,%eax
    153a:	cd 40                	int    $0x40
    153c:	c3                   	ret    

0000153d <wait>:
SYSCALL(wait)
    153d:	b8 03 00 00 00       	mov    $0x3,%eax
    1542:	cd 40                	int    $0x40
    1544:	c3                   	ret    

00001545 <pipe>:
SYSCALL(pipe)
    1545:	b8 04 00 00 00       	mov    $0x4,%eax
    154a:	cd 40                	int    $0x40
    154c:	c3                   	ret    

0000154d <read>:
SYSCALL(read)
    154d:	b8 05 00 00 00       	mov    $0x5,%eax
    1552:	cd 40                	int    $0x40
    1554:	c3                   	ret    

00001555 <write>:
SYSCALL(write)
    1555:	b8 10 00 00 00       	mov    $0x10,%eax
    155a:	cd 40                	int    $0x40
    155c:	c3                   	ret    

0000155d <close>:
SYSCALL(close)
    155d:	b8 15 00 00 00       	mov    $0x15,%eax
    1562:	cd 40                	int    $0x40
    1564:	c3                   	ret    

00001565 <kill>:
SYSCALL(kill)
    1565:	b8 06 00 00 00       	mov    $0x6,%eax
    156a:	cd 40                	int    $0x40
    156c:	c3                   	ret    

0000156d <exec>:
SYSCALL(exec)
    156d:	b8 07 00 00 00       	mov    $0x7,%eax
    1572:	cd 40                	int    $0x40
    1574:	c3                   	ret    

00001575 <open>:
SYSCALL(open)
    1575:	b8 0f 00 00 00       	mov    $0xf,%eax
    157a:	cd 40                	int    $0x40
    157c:	c3                   	ret    

0000157d <mknod>:
SYSCALL(mknod)
    157d:	b8 11 00 00 00       	mov    $0x11,%eax
    1582:	cd 40                	int    $0x40
    1584:	c3                   	ret    

00001585 <unlink>:
SYSCALL(unlink)
    1585:	b8 12 00 00 00       	mov    $0x12,%eax
    158a:	cd 40                	int    $0x40
    158c:	c3                   	ret    

0000158d <fstat>:
SYSCALL(fstat)
    158d:	b8 08 00 00 00       	mov    $0x8,%eax
    1592:	cd 40                	int    $0x40
    1594:	c3                   	ret    

00001595 <link>:
SYSCALL(link)
    1595:	b8 13 00 00 00       	mov    $0x13,%eax
    159a:	cd 40                	int    $0x40
    159c:	c3                   	ret    

0000159d <mkdir>:
SYSCALL(mkdir)
    159d:	b8 14 00 00 00       	mov    $0x14,%eax
    15a2:	cd 40                	int    $0x40
    15a4:	c3                   	ret    

000015a5 <chdir>:
SYSCALL(chdir)
    15a5:	b8 09 00 00 00       	mov    $0x9,%eax
    15aa:	cd 40                	int    $0x40
    15ac:	c3                   	ret    

000015ad <dup>:
SYSCALL(dup)
    15ad:	b8 0a 00 00 00       	mov    $0xa,%eax
    15b2:	cd 40                	int    $0x40
    15b4:	c3                   	ret    

000015b5 <getpid>:
SYSCALL(getpid)
    15b5:	b8 0b 00 00 00       	mov    $0xb,%eax
    15ba:	cd 40                	int    $0x40
    15bc:	c3                   	ret    

000015bd <sbrk>:
SYSCALL(sbrk)
    15bd:	b8 0c 00 00 00       	mov    $0xc,%eax
    15c2:	cd 40                	int    $0x40
    15c4:	c3                   	ret    

000015c5 <sleep>:
SYSCALL(sleep)
    15c5:	b8 0d 00 00 00       	mov    $0xd,%eax
    15ca:	cd 40                	int    $0x40
    15cc:	c3                   	ret    

000015cd <uptime>:
SYSCALL(uptime)
    15cd:	b8 0e 00 00 00       	mov    $0xe,%eax
    15d2:	cd 40                	int    $0x40
    15d4:	c3                   	ret    

000015d5 <shmem_access>:
SYSCALL(shmem_access)
    15d5:	b8 16 00 00 00       	mov    $0x16,%eax
    15da:	cd 40                	int    $0x40
    15dc:	c3                   	ret    

000015dd <shmem_count>:
    15dd:	b8 17 00 00 00       	mov    $0x17,%eax
    15e2:	cd 40                	int    $0x40
    15e4:	c3                   	ret    

000015e5 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    15e5:	55                   	push   %ebp
    15e6:	89 e5                	mov    %esp,%ebp
    15e8:	57                   	push   %edi
    15e9:	56                   	push   %esi
    15ea:	53                   	push   %ebx
    15eb:	83 ec 3c             	sub    $0x3c,%esp
    15ee:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    15f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    15f4:	74 14                	je     160a <printint+0x25>
    15f6:	85 d2                	test   %edx,%edx
    15f8:	79 10                	jns    160a <printint+0x25>
    neg = 1;
    x = -xx;
    15fa:	f7 da                	neg    %edx
    neg = 1;
    15fc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1603:	bf 00 00 00 00       	mov    $0x0,%edi
    1608:	eb 0b                	jmp    1615 <printint+0x30>
  neg = 0;
    160a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1611:	eb f0                	jmp    1603 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1613:	89 df                	mov    %ebx,%edi
    1615:	8d 5f 01             	lea    0x1(%edi),%ebx
    1618:	89 d0                	mov    %edx,%eax
    161a:	ba 00 00 00 00       	mov    $0x0,%edx
    161f:	f7 f1                	div    %ecx
    1621:	0f b6 92 98 1b 00 00 	movzbl 0x1b98(%edx),%edx
    1628:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    162c:	89 c2                	mov    %eax,%edx
    162e:	85 c0                	test   %eax,%eax
    1630:	75 e1                	jne    1613 <printint+0x2e>
  if(neg)
    1632:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    1636:	74 08                	je     1640 <printint+0x5b>
    buf[i++] = '-';
    1638:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    163d:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1640:	83 eb 01             	sub    $0x1,%ebx
    1643:	78 22                	js     1667 <printint+0x82>
  write(fd, &c, 1);
    1645:	8d 7d d7             	lea    -0x29(%ebp),%edi
    1648:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    164d:	88 45 d7             	mov    %al,-0x29(%ebp)
    1650:	83 ec 04             	sub    $0x4,%esp
    1653:	6a 01                	push   $0x1
    1655:	57                   	push   %edi
    1656:	56                   	push   %esi
    1657:	e8 f9 fe ff ff       	call   1555 <write>
  while(--i >= 0)
    165c:	83 eb 01             	sub    $0x1,%ebx
    165f:	83 c4 10             	add    $0x10,%esp
    1662:	83 fb ff             	cmp    $0xffffffff,%ebx
    1665:	75 e1                	jne    1648 <printint+0x63>
    putc(fd, buf[i]);
}
    1667:	8d 65 f4             	lea    -0xc(%ebp),%esp
    166a:	5b                   	pop    %ebx
    166b:	5e                   	pop    %esi
    166c:	5f                   	pop    %edi
    166d:	5d                   	pop    %ebp
    166e:	c3                   	ret    

0000166f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    166f:	55                   	push   %ebp
    1670:	89 e5                	mov    %esp,%ebp
    1672:	57                   	push   %edi
    1673:	56                   	push   %esi
    1674:	53                   	push   %ebx
    1675:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1678:	8b 75 0c             	mov    0xc(%ebp),%esi
    167b:	0f b6 1e             	movzbl (%esi),%ebx
    167e:	84 db                	test   %bl,%bl
    1680:	0f 84 b1 01 00 00    	je     1837 <printf+0x1c8>
    1686:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    1689:	8d 45 10             	lea    0x10(%ebp),%eax
    168c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    168f:	bf 00 00 00 00       	mov    $0x0,%edi
    1694:	eb 2d                	jmp    16c3 <printf+0x54>
    1696:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1699:	83 ec 04             	sub    $0x4,%esp
    169c:	6a 01                	push   $0x1
    169e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    16a1:	50                   	push   %eax
    16a2:	ff 75 08             	pushl  0x8(%ebp)
    16a5:	e8 ab fe ff ff       	call   1555 <write>
    16aa:	83 c4 10             	add    $0x10,%esp
    16ad:	eb 05                	jmp    16b4 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    16af:	83 ff 25             	cmp    $0x25,%edi
    16b2:	74 22                	je     16d6 <printf+0x67>
    16b4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    16b7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    16bb:	84 db                	test   %bl,%bl
    16bd:	0f 84 74 01 00 00    	je     1837 <printf+0x1c8>
    c = fmt[i] & 0xff;
    16c3:	0f be d3             	movsbl %bl,%edx
    16c6:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    16c9:	85 ff                	test   %edi,%edi
    16cb:	75 e2                	jne    16af <printf+0x40>
      if(c == '%'){
    16cd:	83 f8 25             	cmp    $0x25,%eax
    16d0:	75 c4                	jne    1696 <printf+0x27>
        state = '%';
    16d2:	89 c7                	mov    %eax,%edi
    16d4:	eb de                	jmp    16b4 <printf+0x45>
      if(c == 'd'){
    16d6:	83 f8 64             	cmp    $0x64,%eax
    16d9:	74 59                	je     1734 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    16db:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    16e1:	83 fa 70             	cmp    $0x70,%edx
    16e4:	74 7a                	je     1760 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    16e6:	83 f8 73             	cmp    $0x73,%eax
    16e9:	0f 84 9d 00 00 00    	je     178c <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16ef:	83 f8 63             	cmp    $0x63,%eax
    16f2:	0f 84 f2 00 00 00    	je     17ea <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    16f8:	83 f8 25             	cmp    $0x25,%eax
    16fb:	0f 84 15 01 00 00    	je     1816 <printf+0x1a7>
    1701:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    1705:	83 ec 04             	sub    $0x4,%esp
    1708:	6a 01                	push   $0x1
    170a:	8d 45 e7             	lea    -0x19(%ebp),%eax
    170d:	50                   	push   %eax
    170e:	ff 75 08             	pushl  0x8(%ebp)
    1711:	e8 3f fe ff ff       	call   1555 <write>
    1716:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    1719:	83 c4 0c             	add    $0xc,%esp
    171c:	6a 01                	push   $0x1
    171e:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1721:	50                   	push   %eax
    1722:	ff 75 08             	pushl  0x8(%ebp)
    1725:	e8 2b fe ff ff       	call   1555 <write>
    172a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    172d:	bf 00 00 00 00       	mov    $0x0,%edi
    1732:	eb 80                	jmp    16b4 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1734:	83 ec 0c             	sub    $0xc,%esp
    1737:	6a 01                	push   $0x1
    1739:	b9 0a 00 00 00       	mov    $0xa,%ecx
    173e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1741:	8b 17                	mov    (%edi),%edx
    1743:	8b 45 08             	mov    0x8(%ebp),%eax
    1746:	e8 9a fe ff ff       	call   15e5 <printint>
        ap++;
    174b:	89 f8                	mov    %edi,%eax
    174d:	83 c0 04             	add    $0x4,%eax
    1750:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1753:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1756:	bf 00 00 00 00       	mov    $0x0,%edi
    175b:	e9 54 ff ff ff       	jmp    16b4 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1760:	83 ec 0c             	sub    $0xc,%esp
    1763:	6a 00                	push   $0x0
    1765:	b9 10 00 00 00       	mov    $0x10,%ecx
    176a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    176d:	8b 17                	mov    (%edi),%edx
    176f:	8b 45 08             	mov    0x8(%ebp),%eax
    1772:	e8 6e fe ff ff       	call   15e5 <printint>
        ap++;
    1777:	89 f8                	mov    %edi,%eax
    1779:	83 c0 04             	add    $0x4,%eax
    177c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    177f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1782:	bf 00 00 00 00       	mov    $0x0,%edi
    1787:	e9 28 ff ff ff       	jmp    16b4 <printf+0x45>
        s = (char*)*ap;
    178c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    178f:	8b 01                	mov    (%ecx),%eax
        ap++;
    1791:	83 c1 04             	add    $0x4,%ecx
    1794:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1797:	85 c0                	test   %eax,%eax
    1799:	74 13                	je     17ae <printf+0x13f>
        s = (char*)*ap;
    179b:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    179d:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    17a0:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    17a5:	84 c0                	test   %al,%al
    17a7:	75 0f                	jne    17b8 <printf+0x149>
    17a9:	e9 06 ff ff ff       	jmp    16b4 <printf+0x45>
          s = "(null)";
    17ae:	bb 90 1b 00 00       	mov    $0x1b90,%ebx
        while(*s != 0){
    17b3:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    17b8:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    17bb:	89 75 d0             	mov    %esi,-0x30(%ebp)
    17be:	8b 75 08             	mov    0x8(%ebp),%esi
    17c1:	88 45 e3             	mov    %al,-0x1d(%ebp)
    17c4:	83 ec 04             	sub    $0x4,%esp
    17c7:	6a 01                	push   $0x1
    17c9:	57                   	push   %edi
    17ca:	56                   	push   %esi
    17cb:	e8 85 fd ff ff       	call   1555 <write>
          s++;
    17d0:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    17d3:	0f b6 03             	movzbl (%ebx),%eax
    17d6:	83 c4 10             	add    $0x10,%esp
    17d9:	84 c0                	test   %al,%al
    17db:	75 e4                	jne    17c1 <printf+0x152>
    17dd:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    17e0:	bf 00 00 00 00       	mov    $0x0,%edi
    17e5:	e9 ca fe ff ff       	jmp    16b4 <printf+0x45>
        putc(fd, *ap);
    17ea:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    17ed:	8b 07                	mov    (%edi),%eax
    17ef:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    17f2:	83 ec 04             	sub    $0x4,%esp
    17f5:	6a 01                	push   $0x1
    17f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    17fa:	50                   	push   %eax
    17fb:	ff 75 08             	pushl  0x8(%ebp)
    17fe:	e8 52 fd ff ff       	call   1555 <write>
        ap++;
    1803:	83 c7 04             	add    $0x4,%edi
    1806:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    1809:	83 c4 10             	add    $0x10,%esp
      state = 0;
    180c:	bf 00 00 00 00       	mov    $0x0,%edi
    1811:	e9 9e fe ff ff       	jmp    16b4 <printf+0x45>
    1816:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    1819:	83 ec 04             	sub    $0x4,%esp
    181c:	6a 01                	push   $0x1
    181e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1821:	50                   	push   %eax
    1822:	ff 75 08             	pushl  0x8(%ebp)
    1825:	e8 2b fd ff ff       	call   1555 <write>
    182a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    182d:	bf 00 00 00 00       	mov    $0x0,%edi
    1832:	e9 7d fe ff ff       	jmp    16b4 <printf+0x45>
    }
  }
}
    1837:	8d 65 f4             	lea    -0xc(%ebp),%esp
    183a:	5b                   	pop    %ebx
    183b:	5e                   	pop    %esi
    183c:	5f                   	pop    %edi
    183d:	5d                   	pop    %ebp
    183e:	c3                   	ret    

0000183f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    183f:	55                   	push   %ebp
    1840:	89 e5                	mov    %esp,%ebp
    1842:	57                   	push   %edi
    1843:	56                   	push   %esi
    1844:	53                   	push   %ebx
    1845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1848:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    184b:	a1 c0 1e 00 00       	mov    0x1ec0,%eax
    1850:	eb 0c                	jmp    185e <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1852:	8b 10                	mov    (%eax),%edx
    1854:	39 c2                	cmp    %eax,%edx
    1856:	77 04                	ja     185c <free+0x1d>
    1858:	39 ca                	cmp    %ecx,%edx
    185a:	77 10                	ja     186c <free+0x2d>
{
    185c:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    185e:	39 c8                	cmp    %ecx,%eax
    1860:	73 f0                	jae    1852 <free+0x13>
    1862:	8b 10                	mov    (%eax),%edx
    1864:	39 ca                	cmp    %ecx,%edx
    1866:	77 04                	ja     186c <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1868:	39 c2                	cmp    %eax,%edx
    186a:	77 f0                	ja     185c <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    186c:	8b 73 fc             	mov    -0x4(%ebx),%esi
    186f:	8b 10                	mov    (%eax),%edx
    1871:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1874:	39 fa                	cmp    %edi,%edx
    1876:	74 19                	je     1891 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1878:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    187b:	8b 50 04             	mov    0x4(%eax),%edx
    187e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1881:	39 f1                	cmp    %esi,%ecx
    1883:	74 1b                	je     18a0 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1885:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1887:	a3 c0 1e 00 00       	mov    %eax,0x1ec0
}
    188c:	5b                   	pop    %ebx
    188d:	5e                   	pop    %esi
    188e:	5f                   	pop    %edi
    188f:	5d                   	pop    %ebp
    1890:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1891:	03 72 04             	add    0x4(%edx),%esi
    1894:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1897:	8b 10                	mov    (%eax),%edx
    1899:	8b 12                	mov    (%edx),%edx
    189b:	89 53 f8             	mov    %edx,-0x8(%ebx)
    189e:	eb db                	jmp    187b <free+0x3c>
    p->s.size += bp->s.size;
    18a0:	03 53 fc             	add    -0x4(%ebx),%edx
    18a3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    18a6:	8b 53 f8             	mov    -0x8(%ebx),%edx
    18a9:	89 10                	mov    %edx,(%eax)
    18ab:	eb da                	jmp    1887 <free+0x48>

000018ad <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    18ad:	55                   	push   %ebp
    18ae:	89 e5                	mov    %esp,%ebp
    18b0:	57                   	push   %edi
    18b1:	56                   	push   %esi
    18b2:	53                   	push   %ebx
    18b3:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18b6:	8b 45 08             	mov    0x8(%ebp),%eax
    18b9:	8d 58 07             	lea    0x7(%eax),%ebx
    18bc:	c1 eb 03             	shr    $0x3,%ebx
    18bf:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    18c2:	8b 15 c0 1e 00 00    	mov    0x1ec0,%edx
    18c8:	85 d2                	test   %edx,%edx
    18ca:	74 20                	je     18ec <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18cc:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    18ce:	8b 48 04             	mov    0x4(%eax),%ecx
    18d1:	39 cb                	cmp    %ecx,%ebx
    18d3:	76 3c                	jbe    1911 <malloc+0x64>
    18d5:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    18db:	be 00 10 00 00       	mov    $0x1000,%esi
    18e0:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    18e3:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    18ea:	eb 70                	jmp    195c <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    18ec:	c7 05 c0 1e 00 00 c4 	movl   $0x1ec4,0x1ec0
    18f3:	1e 00 00 
    18f6:	c7 05 c4 1e 00 00 c4 	movl   $0x1ec4,0x1ec4
    18fd:	1e 00 00 
    base.s.size = 0;
    1900:	c7 05 c8 1e 00 00 00 	movl   $0x0,0x1ec8
    1907:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    190a:	ba c4 1e 00 00       	mov    $0x1ec4,%edx
    190f:	eb bb                	jmp    18cc <malloc+0x1f>
      if(p->s.size == nunits)
    1911:	39 cb                	cmp    %ecx,%ebx
    1913:	74 1c                	je     1931 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1915:	29 d9                	sub    %ebx,%ecx
    1917:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    191a:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    191d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1920:	89 15 c0 1e 00 00    	mov    %edx,0x1ec0
      return (void*)(p + 1);
    1926:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1929:	8d 65 f4             	lea    -0xc(%ebp),%esp
    192c:	5b                   	pop    %ebx
    192d:	5e                   	pop    %esi
    192e:	5f                   	pop    %edi
    192f:	5d                   	pop    %ebp
    1930:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1931:	8b 08                	mov    (%eax),%ecx
    1933:	89 0a                	mov    %ecx,(%edx)
    1935:	eb e9                	jmp    1920 <malloc+0x73>
  hp->s.size = nu;
    1937:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    193a:	83 ec 0c             	sub    $0xc,%esp
    193d:	83 c0 08             	add    $0x8,%eax
    1940:	50                   	push   %eax
    1941:	e8 f9 fe ff ff       	call   183f <free>
  return freep;
    1946:	8b 15 c0 1e 00 00    	mov    0x1ec0,%edx
      if((p = morecore(nunits)) == 0)
    194c:	83 c4 10             	add    $0x10,%esp
    194f:	85 d2                	test   %edx,%edx
    1951:	74 2b                	je     197e <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1953:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1955:	8b 48 04             	mov    0x4(%eax),%ecx
    1958:	39 d9                	cmp    %ebx,%ecx
    195a:	73 b5                	jae    1911 <malloc+0x64>
    195c:	89 c2                	mov    %eax,%edx
    if(p == freep)
    195e:	39 05 c0 1e 00 00    	cmp    %eax,0x1ec0
    1964:	75 ed                	jne    1953 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1966:	83 ec 0c             	sub    $0xc,%esp
    1969:	57                   	push   %edi
    196a:	e8 4e fc ff ff       	call   15bd <sbrk>
  if(p == (char*)-1)
    196f:	83 c4 10             	add    $0x10,%esp
    1972:	83 f8 ff             	cmp    $0xffffffff,%eax
    1975:	75 c0                	jne    1937 <malloc+0x8a>
        return 0;
    1977:	b8 00 00 00 00       	mov    $0x0,%eax
    197c:	eb ab                	jmp    1929 <malloc+0x7c>
    197e:	b8 00 00 00 00       	mov    $0x0,%eax
    1983:	eb a4                	jmp    1929 <malloc+0x7c>
