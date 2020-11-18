
_usertests:     file format elf32-i386


Disassembly of section .text:

00001000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
    1006:	68 78 4c 00 00       	push   $0x4c78
    100b:	ff 35 14 6c 00 00    	pushl  0x6c14
    1011:	e8 b6 38 00 00       	call   48cc <printf>

  if(mkdir("iputdir") < 0){
    1016:	c7 04 24 0b 4c 00 00 	movl   $0x4c0b,(%esp)
    101d:	e8 d8 37 00 00       	call   47fa <mkdir>
    1022:	83 c4 10             	add    $0x10,%esp
    1025:	85 c0                	test   %eax,%eax
    1027:	78 54                	js     107d <iputtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
    1029:	83 ec 0c             	sub    $0xc,%esp
    102c:	68 0b 4c 00 00       	push   $0x4c0b
    1031:	e8 cc 37 00 00       	call   4802 <chdir>
    1036:	83 c4 10             	add    $0x10,%esp
    1039:	85 c0                	test   %eax,%eax
    103b:	78 58                	js     1095 <iputtest+0x95>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
    103d:	83 ec 0c             	sub    $0xc,%esp
    1040:	68 08 4c 00 00       	push   $0x4c08
    1045:	e8 98 37 00 00       	call   47e2 <unlink>
    104a:	83 c4 10             	add    $0x10,%esp
    104d:	85 c0                	test   %eax,%eax
    104f:	78 5c                	js     10ad <iputtest+0xad>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
    1051:	83 ec 0c             	sub    $0xc,%esp
    1054:	68 2d 4c 00 00       	push   $0x4c2d
    1059:	e8 a4 37 00 00       	call   4802 <chdir>
    105e:	83 c4 10             	add    $0x10,%esp
    1061:	85 c0                	test   %eax,%eax
    1063:	78 60                	js     10c5 <iputtest+0xc5>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
    1065:	83 ec 08             	sub    $0x8,%esp
    1068:	68 b0 4c 00 00       	push   $0x4cb0
    106d:	ff 35 14 6c 00 00    	pushl  0x6c14
    1073:	e8 54 38 00 00       	call   48cc <printf>
}
    1078:	83 c4 10             	add    $0x10,%esp
    107b:	c9                   	leave  
    107c:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
    107d:	83 ec 08             	sub    $0x8,%esp
    1080:	68 e4 4b 00 00       	push   $0x4be4
    1085:	ff 35 14 6c 00 00    	pushl  0x6c14
    108b:	e8 3c 38 00 00       	call   48cc <printf>
    exit();
    1090:	e8 fd 36 00 00       	call   4792 <exit>
    printf(stdout, "chdir iputdir failed\n");
    1095:	83 ec 08             	sub    $0x8,%esp
    1098:	68 f2 4b 00 00       	push   $0x4bf2
    109d:	ff 35 14 6c 00 00    	pushl  0x6c14
    10a3:	e8 24 38 00 00       	call   48cc <printf>
    exit();
    10a8:	e8 e5 36 00 00       	call   4792 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
    10ad:	83 ec 08             	sub    $0x8,%esp
    10b0:	68 13 4c 00 00       	push   $0x4c13
    10b5:	ff 35 14 6c 00 00    	pushl  0x6c14
    10bb:	e8 0c 38 00 00       	call   48cc <printf>
    exit();
    10c0:	e8 cd 36 00 00       	call   4792 <exit>
    printf(stdout, "chdir / failed\n");
    10c5:	83 ec 08             	sub    $0x8,%esp
    10c8:	68 2f 4c 00 00       	push   $0x4c2f
    10cd:	ff 35 14 6c 00 00    	pushl  0x6c14
    10d3:	e8 f4 37 00 00       	call   48cc <printf>
    exit();
    10d8:	e8 b5 36 00 00       	call   4792 <exit>

000010dd <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
    10dd:	55                   	push   %ebp
    10de:	89 e5                	mov    %esp,%ebp
    10e0:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
    10e3:	68 3f 4c 00 00       	push   $0x4c3f
    10e8:	ff 35 14 6c 00 00    	pushl  0x6c14
    10ee:	e8 d9 37 00 00       	call   48cc <printf>

  pid = fork();
    10f3:	e8 92 36 00 00       	call   478a <fork>
  if(pid < 0){
    10f8:	83 c4 10             	add    $0x10,%esp
    10fb:	85 c0                	test   %eax,%eax
    10fd:	78 49                	js     1148 <exitiputtest+0x6b>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
    10ff:	85 c0                	test   %eax,%eax
    1101:	0f 85 a1 00 00 00    	jne    11a8 <exitiputtest+0xcb>
    if(mkdir("iputdir") < 0){
    1107:	83 ec 0c             	sub    $0xc,%esp
    110a:	68 0b 4c 00 00       	push   $0x4c0b
    110f:	e8 e6 36 00 00       	call   47fa <mkdir>
    1114:	83 c4 10             	add    $0x10,%esp
    1117:	85 c0                	test   %eax,%eax
    1119:	78 45                	js     1160 <exitiputtest+0x83>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
    111b:	83 ec 0c             	sub    $0xc,%esp
    111e:	68 0b 4c 00 00       	push   $0x4c0b
    1123:	e8 da 36 00 00       	call   4802 <chdir>
    1128:	83 c4 10             	add    $0x10,%esp
    112b:	85 c0                	test   %eax,%eax
    112d:	78 49                	js     1178 <exitiputtest+0x9b>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
    112f:	83 ec 0c             	sub    $0xc,%esp
    1132:	68 08 4c 00 00       	push   $0x4c08
    1137:	e8 a6 36 00 00       	call   47e2 <unlink>
    113c:	83 c4 10             	add    $0x10,%esp
    113f:	85 c0                	test   %eax,%eax
    1141:	78 4d                	js     1190 <exitiputtest+0xb3>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
    1143:	e8 4a 36 00 00       	call   4792 <exit>
    printf(stdout, "fork failed\n");
    1148:	83 ec 08             	sub    $0x8,%esp
    114b:	68 25 5b 00 00       	push   $0x5b25
    1150:	ff 35 14 6c 00 00    	pushl  0x6c14
    1156:	e8 71 37 00 00       	call   48cc <printf>
    exit();
    115b:	e8 32 36 00 00       	call   4792 <exit>
      printf(stdout, "mkdir failed\n");
    1160:	83 ec 08             	sub    $0x8,%esp
    1163:	68 e4 4b 00 00       	push   $0x4be4
    1168:	ff 35 14 6c 00 00    	pushl  0x6c14
    116e:	e8 59 37 00 00       	call   48cc <printf>
      exit();
    1173:	e8 1a 36 00 00       	call   4792 <exit>
      printf(stdout, "child chdir failed\n");
    1178:	83 ec 08             	sub    $0x8,%esp
    117b:	68 4e 4c 00 00       	push   $0x4c4e
    1180:	ff 35 14 6c 00 00    	pushl  0x6c14
    1186:	e8 41 37 00 00       	call   48cc <printf>
      exit();
    118b:	e8 02 36 00 00       	call   4792 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
    1190:	83 ec 08             	sub    $0x8,%esp
    1193:	68 13 4c 00 00       	push   $0x4c13
    1198:	ff 35 14 6c 00 00    	pushl  0x6c14
    119e:	e8 29 37 00 00       	call   48cc <printf>
      exit();
    11a3:	e8 ea 35 00 00       	call   4792 <exit>
  }
  wait();
    11a8:	e8 ed 35 00 00       	call   479a <wait>
  printf(stdout, "exitiput test ok\n");
    11ad:	83 ec 08             	sub    $0x8,%esp
    11b0:	68 62 4c 00 00       	push   $0x4c62
    11b5:	ff 35 14 6c 00 00    	pushl  0x6c14
    11bb:	e8 0c 37 00 00       	call   48cc <printf>
}
    11c0:	83 c4 10             	add    $0x10,%esp
    11c3:	c9                   	leave  
    11c4:	c3                   	ret    

000011c5 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
    11c5:	55                   	push   %ebp
    11c6:	89 e5                	mov    %esp,%ebp
    11c8:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
    11cb:	68 74 4c 00 00       	push   $0x4c74
    11d0:	ff 35 14 6c 00 00    	pushl  0x6c14
    11d6:	e8 f1 36 00 00       	call   48cc <printf>
  if(mkdir("oidir") < 0){
    11db:	c7 04 24 83 4c 00 00 	movl   $0x4c83,(%esp)
    11e2:	e8 13 36 00 00       	call   47fa <mkdir>
    11e7:	83 c4 10             	add    $0x10,%esp
    11ea:	85 c0                	test   %eax,%eax
    11ec:	78 3b                	js     1229 <openiputtest+0x64>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
    11ee:	e8 97 35 00 00       	call   478a <fork>
  if(pid < 0){
    11f3:	85 c0                	test   %eax,%eax
    11f5:	78 4a                	js     1241 <openiputtest+0x7c>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
    11f7:	85 c0                	test   %eax,%eax
    11f9:	75 63                	jne    125e <openiputtest+0x99>
    int fd = open("oidir", O_RDWR);
    11fb:	83 ec 08             	sub    $0x8,%esp
    11fe:	6a 02                	push   $0x2
    1200:	68 83 4c 00 00       	push   $0x4c83
    1205:	e8 c8 35 00 00       	call   47d2 <open>
    if(fd >= 0){
    120a:	83 c4 10             	add    $0x10,%esp
    120d:	85 c0                	test   %eax,%eax
    120f:	78 48                	js     1259 <openiputtest+0x94>
      printf(stdout, "open directory for write succeeded\n");
    1211:	83 ec 08             	sub    $0x8,%esp
    1214:	68 08 5c 00 00       	push   $0x5c08
    1219:	ff 35 14 6c 00 00    	pushl  0x6c14
    121f:	e8 a8 36 00 00       	call   48cc <printf>
      exit();
    1224:	e8 69 35 00 00       	call   4792 <exit>
    printf(stdout, "mkdir oidir failed\n");
    1229:	83 ec 08             	sub    $0x8,%esp
    122c:	68 89 4c 00 00       	push   $0x4c89
    1231:	ff 35 14 6c 00 00    	pushl  0x6c14
    1237:	e8 90 36 00 00       	call   48cc <printf>
    exit();
    123c:	e8 51 35 00 00       	call   4792 <exit>
    printf(stdout, "fork failed\n");
    1241:	83 ec 08             	sub    $0x8,%esp
    1244:	68 25 5b 00 00       	push   $0x5b25
    1249:	ff 35 14 6c 00 00    	pushl  0x6c14
    124f:	e8 78 36 00 00       	call   48cc <printf>
    exit();
    1254:	e8 39 35 00 00       	call   4792 <exit>
    }
    exit();
    1259:	e8 34 35 00 00       	call   4792 <exit>
  }
  sleep(1);
    125e:	83 ec 0c             	sub    $0xc,%esp
    1261:	6a 01                	push   $0x1
    1263:	e8 ba 35 00 00       	call   4822 <sleep>
  if(unlink("oidir") != 0){
    1268:	c7 04 24 83 4c 00 00 	movl   $0x4c83,(%esp)
    126f:	e8 6e 35 00 00       	call   47e2 <unlink>
    1274:	83 c4 10             	add    $0x10,%esp
    1277:	85 c0                	test   %eax,%eax
    1279:	75 1d                	jne    1298 <openiputtest+0xd3>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
    127b:	e8 1a 35 00 00       	call   479a <wait>
  printf(stdout, "openiput test ok\n");
    1280:	83 ec 08             	sub    $0x8,%esp
    1283:	68 ac 4c 00 00       	push   $0x4cac
    1288:	ff 35 14 6c 00 00    	pushl  0x6c14
    128e:	e8 39 36 00 00       	call   48cc <printf>
}
    1293:	83 c4 10             	add    $0x10,%esp
    1296:	c9                   	leave  
    1297:	c3                   	ret    
    printf(stdout, "unlink failed\n");
    1298:	83 ec 08             	sub    $0x8,%esp
    129b:	68 9d 4c 00 00       	push   $0x4c9d
    12a0:	ff 35 14 6c 00 00    	pushl  0x6c14
    12a6:	e8 21 36 00 00       	call   48cc <printf>
    exit();
    12ab:	e8 e2 34 00 00       	call   4792 <exit>

000012b0 <opentest>:

// simple file system tests

void
opentest(void)
{
    12b0:	55                   	push   %ebp
    12b1:	89 e5                	mov    %esp,%ebp
    12b3:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
    12b6:	68 be 4c 00 00       	push   $0x4cbe
    12bb:	ff 35 14 6c 00 00    	pushl  0x6c14
    12c1:	e8 06 36 00 00       	call   48cc <printf>
  fd = open("echo", 0);
    12c6:	83 c4 08             	add    $0x8,%esp
    12c9:	6a 00                	push   $0x0
    12cb:	68 c9 4c 00 00       	push   $0x4cc9
    12d0:	e8 fd 34 00 00       	call   47d2 <open>
  if(fd < 0){
    12d5:	83 c4 10             	add    $0x10,%esp
    12d8:	85 c0                	test   %eax,%eax
    12da:	78 37                	js     1313 <opentest+0x63>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
    12dc:	83 ec 0c             	sub    $0xc,%esp
    12df:	50                   	push   %eax
    12e0:	e8 d5 34 00 00       	call   47ba <close>
  fd = open("doesnotexist", 0);
    12e5:	83 c4 08             	add    $0x8,%esp
    12e8:	6a 00                	push   $0x0
    12ea:	68 e1 4c 00 00       	push   $0x4ce1
    12ef:	e8 de 34 00 00       	call   47d2 <open>
  if(fd >= 0){
    12f4:	83 c4 10             	add    $0x10,%esp
    12f7:	85 c0                	test   %eax,%eax
    12f9:	79 30                	jns    132b <opentest+0x7b>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
    12fb:	83 ec 08             	sub    $0x8,%esp
    12fe:	68 0c 4d 00 00       	push   $0x4d0c
    1303:	ff 35 14 6c 00 00    	pushl  0x6c14
    1309:	e8 be 35 00 00       	call   48cc <printf>
}
    130e:	83 c4 10             	add    $0x10,%esp
    1311:	c9                   	leave  
    1312:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
    1313:	83 ec 08             	sub    $0x8,%esp
    1316:	68 ce 4c 00 00       	push   $0x4cce
    131b:	ff 35 14 6c 00 00    	pushl  0x6c14
    1321:	e8 a6 35 00 00       	call   48cc <printf>
    exit();
    1326:	e8 67 34 00 00       	call   4792 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
    132b:	83 ec 08             	sub    $0x8,%esp
    132e:	68 ee 4c 00 00       	push   $0x4cee
    1333:	ff 35 14 6c 00 00    	pushl  0x6c14
    1339:	e8 8e 35 00 00       	call   48cc <printf>
    exit();
    133e:	e8 4f 34 00 00       	call   4792 <exit>

00001343 <writetest>:

void
writetest(void)
{
    1343:	55                   	push   %ebp
    1344:	89 e5                	mov    %esp,%ebp
    1346:	56                   	push   %esi
    1347:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
    1348:	83 ec 08             	sub    $0x8,%esp
    134b:	68 1a 4d 00 00       	push   $0x4d1a
    1350:	ff 35 14 6c 00 00    	pushl  0x6c14
    1356:	e8 71 35 00 00       	call   48cc <printf>
  fd = open("small", O_CREATE|O_RDWR);
    135b:	83 c4 08             	add    $0x8,%esp
    135e:	68 02 02 00 00       	push   $0x202
    1363:	68 2b 4d 00 00       	push   $0x4d2b
    1368:	e8 65 34 00 00       	call   47d2 <open>
  if(fd >= 0){
    136d:	83 c4 10             	add    $0x10,%esp
    1370:	85 c0                	test   %eax,%eax
    1372:	0f 88 17 01 00 00    	js     148f <writetest+0x14c>
    1378:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
    137a:	83 ec 08             	sub    $0x8,%esp
    137d:	68 31 4d 00 00       	push   $0x4d31
    1382:	ff 35 14 6c 00 00    	pushl  0x6c14
    1388:	e8 3f 35 00 00       	call   48cc <printf>
    138d:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    1390:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    1395:	83 ec 04             	sub    $0x4,%esp
    1398:	6a 0a                	push   $0xa
    139a:	68 68 4d 00 00       	push   $0x4d68
    139f:	56                   	push   %esi
    13a0:	e8 0d 34 00 00       	call   47b2 <write>
    13a5:	83 c4 10             	add    $0x10,%esp
    13a8:	83 f8 0a             	cmp    $0xa,%eax
    13ab:	0f 85 f6 00 00 00    	jne    14a7 <writetest+0x164>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    13b1:	83 ec 04             	sub    $0x4,%esp
    13b4:	6a 0a                	push   $0xa
    13b6:	68 73 4d 00 00       	push   $0x4d73
    13bb:	56                   	push   %esi
    13bc:	e8 f1 33 00 00       	call   47b2 <write>
    13c1:	83 c4 10             	add    $0x10,%esp
    13c4:	83 f8 0a             	cmp    $0xa,%eax
    13c7:	0f 85 f3 00 00 00    	jne    14c0 <writetest+0x17d>
  for(i = 0; i < 100; i++){
    13cd:	83 c3 01             	add    $0x1,%ebx
    13d0:	83 fb 64             	cmp    $0x64,%ebx
    13d3:	75 c0                	jne    1395 <writetest+0x52>
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
    13d5:	83 ec 08             	sub    $0x8,%esp
    13d8:	68 7e 4d 00 00       	push   $0x4d7e
    13dd:	ff 35 14 6c 00 00    	pushl  0x6c14
    13e3:	e8 e4 34 00 00       	call   48cc <printf>
  close(fd);
    13e8:	89 34 24             	mov    %esi,(%esp)
    13eb:	e8 ca 33 00 00       	call   47ba <close>
  fd = open("small", O_RDONLY);
    13f0:	83 c4 08             	add    $0x8,%esp
    13f3:	6a 00                	push   $0x0
    13f5:	68 2b 4d 00 00       	push   $0x4d2b
    13fa:	e8 d3 33 00 00       	call   47d2 <open>
    13ff:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
    1401:	83 c4 10             	add    $0x10,%esp
    1404:	85 c0                	test   %eax,%eax
    1406:	0f 88 cd 00 00 00    	js     14d9 <writetest+0x196>
    printf(stdout, "open small succeeded ok\n");
    140c:	83 ec 08             	sub    $0x8,%esp
    140f:	68 89 4d 00 00       	push   $0x4d89
    1414:	ff 35 14 6c 00 00    	pushl  0x6c14
    141a:	e8 ad 34 00 00       	call   48cc <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    141f:	83 c4 0c             	add    $0xc,%esp
    1422:	68 d0 07 00 00       	push   $0x7d0
    1427:	68 00 94 00 00       	push   $0x9400
    142c:	53                   	push   %ebx
    142d:	e8 78 33 00 00       	call   47aa <read>
  if(i == 2000){
    1432:	83 c4 10             	add    $0x10,%esp
    1435:	3d d0 07 00 00       	cmp    $0x7d0,%eax
    143a:	0f 85 b1 00 00 00    	jne    14f1 <writetest+0x1ae>
    printf(stdout, "read succeeded ok\n");
    1440:	83 ec 08             	sub    $0x8,%esp
    1443:	68 bd 4d 00 00       	push   $0x4dbd
    1448:	ff 35 14 6c 00 00    	pushl  0x6c14
    144e:	e8 79 34 00 00       	call   48cc <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    1453:	89 1c 24             	mov    %ebx,(%esp)
    1456:	e8 5f 33 00 00       	call   47ba <close>

  if(unlink("small") < 0){
    145b:	c7 04 24 2b 4d 00 00 	movl   $0x4d2b,(%esp)
    1462:	e8 7b 33 00 00       	call   47e2 <unlink>
    1467:	83 c4 10             	add    $0x10,%esp
    146a:	85 c0                	test   %eax,%eax
    146c:	0f 88 97 00 00 00    	js     1509 <writetest+0x1c6>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
    1472:	83 ec 08             	sub    $0x8,%esp
    1475:	68 e5 4d 00 00       	push   $0x4de5
    147a:	ff 35 14 6c 00 00    	pushl  0x6c14
    1480:	e8 47 34 00 00       	call   48cc <printf>
}
    1485:	83 c4 10             	add    $0x10,%esp
    1488:	8d 65 f8             	lea    -0x8(%ebp),%esp
    148b:	5b                   	pop    %ebx
    148c:	5e                   	pop    %esi
    148d:	5d                   	pop    %ebp
    148e:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
    148f:	83 ec 08             	sub    $0x8,%esp
    1492:	68 4c 4d 00 00       	push   $0x4d4c
    1497:	ff 35 14 6c 00 00    	pushl  0x6c14
    149d:	e8 2a 34 00 00       	call   48cc <printf>
    exit();
    14a2:	e8 eb 32 00 00       	call   4792 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
    14a7:	83 ec 04             	sub    $0x4,%esp
    14aa:	53                   	push   %ebx
    14ab:	68 2c 5c 00 00       	push   $0x5c2c
    14b0:	ff 35 14 6c 00 00    	pushl  0x6c14
    14b6:	e8 11 34 00 00       	call   48cc <printf>
      exit();
    14bb:	e8 d2 32 00 00       	call   4792 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
    14c0:	83 ec 04             	sub    $0x4,%esp
    14c3:	53                   	push   %ebx
    14c4:	68 50 5c 00 00       	push   $0x5c50
    14c9:	ff 35 14 6c 00 00    	pushl  0x6c14
    14cf:	e8 f8 33 00 00       	call   48cc <printf>
      exit();
    14d4:	e8 b9 32 00 00       	call   4792 <exit>
    printf(stdout, "error: open small failed!\n");
    14d9:	83 ec 08             	sub    $0x8,%esp
    14dc:	68 a2 4d 00 00       	push   $0x4da2
    14e1:	ff 35 14 6c 00 00    	pushl  0x6c14
    14e7:	e8 e0 33 00 00       	call   48cc <printf>
    exit();
    14ec:	e8 a1 32 00 00       	call   4792 <exit>
    printf(stdout, "read failed\n");
    14f1:	83 ec 08             	sub    $0x8,%esp
    14f4:	68 e9 50 00 00       	push   $0x50e9
    14f9:	ff 35 14 6c 00 00    	pushl  0x6c14
    14ff:	e8 c8 33 00 00       	call   48cc <printf>
    exit();
    1504:	e8 89 32 00 00       	call   4792 <exit>
    printf(stdout, "unlink small failed\n");
    1509:	83 ec 08             	sub    $0x8,%esp
    150c:	68 d0 4d 00 00       	push   $0x4dd0
    1511:	ff 35 14 6c 00 00    	pushl  0x6c14
    1517:	e8 b0 33 00 00       	call   48cc <printf>
    exit();
    151c:	e8 71 32 00 00       	call   4792 <exit>

00001521 <writetest1>:

void
writetest1(void)
{
    1521:	55                   	push   %ebp
    1522:	89 e5                	mov    %esp,%ebp
    1524:	56                   	push   %esi
    1525:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
    1526:	83 ec 08             	sub    $0x8,%esp
    1529:	68 f9 4d 00 00       	push   $0x4df9
    152e:	ff 35 14 6c 00 00    	pushl  0x6c14
    1534:	e8 93 33 00 00       	call   48cc <printf>

  fd = open("big", O_CREATE|O_RDWR);
    1539:	83 c4 08             	add    $0x8,%esp
    153c:	68 02 02 00 00       	push   $0x202
    1541:	68 73 4e 00 00       	push   $0x4e73
    1546:	e8 87 32 00 00       	call   47d2 <open>
  if(fd < 0){
    154b:	83 c4 10             	add    $0x10,%esp
    154e:	85 c0                	test   %eax,%eax
    1550:	0f 88 96 00 00 00    	js     15ec <writetest1+0xcb>
    1556:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
    1558:	bb 00 00 00 00       	mov    $0x0,%ebx
    ((int*)buf)[0] = i;
    155d:	89 1d 00 94 00 00    	mov    %ebx,0x9400
    if(write(fd, buf, 512) != 512){
    1563:	83 ec 04             	sub    $0x4,%esp
    1566:	68 00 02 00 00       	push   $0x200
    156b:	68 00 94 00 00       	push   $0x9400
    1570:	56                   	push   %esi
    1571:	e8 3c 32 00 00       	call   47b2 <write>
    1576:	83 c4 10             	add    $0x10,%esp
    1579:	3d 00 02 00 00       	cmp    $0x200,%eax
    157e:	0f 85 80 00 00 00    	jne    1604 <writetest1+0xe3>
  for(i = 0; i < MAXFILE; i++){
    1584:	83 c3 01             	add    $0x1,%ebx
    1587:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
    158d:	75 ce                	jne    155d <writetest1+0x3c>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    158f:	83 ec 0c             	sub    $0xc,%esp
    1592:	56                   	push   %esi
    1593:	e8 22 32 00 00       	call   47ba <close>

  fd = open("big", O_RDONLY);
    1598:	83 c4 08             	add    $0x8,%esp
    159b:	6a 00                	push   $0x0
    159d:	68 73 4e 00 00       	push   $0x4e73
    15a2:	e8 2b 32 00 00       	call   47d2 <open>
    15a7:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    15a9:	83 c4 10             	add    $0x10,%esp
    15ac:	85 c0                	test   %eax,%eax
    15ae:	78 6d                	js     161d <writetest1+0xfc>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
    15b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
    15b5:	83 ec 04             	sub    $0x4,%esp
    15b8:	68 00 02 00 00       	push   $0x200
    15bd:	68 00 94 00 00       	push   $0x9400
    15c2:	56                   	push   %esi
    15c3:	e8 e2 31 00 00       	call   47aa <read>
    if(i == 0){
    15c8:	83 c4 10             	add    $0x10,%esp
    15cb:	85 c0                	test   %eax,%eax
    15cd:	74 66                	je     1635 <writetest1+0x114>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
    15cf:	3d 00 02 00 00       	cmp    $0x200,%eax
    15d4:	0f 85 b9 00 00 00    	jne    1693 <writetest1+0x172>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
    15da:	a1 00 94 00 00       	mov    0x9400,%eax
    15df:	39 d8                	cmp    %ebx,%eax
    15e1:	0f 85 c5 00 00 00    	jne    16ac <writetest1+0x18b>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
    15e7:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
    15ea:	eb c9                	jmp    15b5 <writetest1+0x94>
    printf(stdout, "error: creat big failed!\n");
    15ec:	83 ec 08             	sub    $0x8,%esp
    15ef:	68 09 4e 00 00       	push   $0x4e09
    15f4:	ff 35 14 6c 00 00    	pushl  0x6c14
    15fa:	e8 cd 32 00 00       	call   48cc <printf>
    exit();
    15ff:	e8 8e 31 00 00       	call   4792 <exit>
      printf(stdout, "error: write big file failed\n", i);
    1604:	83 ec 04             	sub    $0x4,%esp
    1607:	53                   	push   %ebx
    1608:	68 23 4e 00 00       	push   $0x4e23
    160d:	ff 35 14 6c 00 00    	pushl  0x6c14
    1613:	e8 b4 32 00 00       	call   48cc <printf>
      exit();
    1618:	e8 75 31 00 00       	call   4792 <exit>
    printf(stdout, "error: open big failed!\n");
    161d:	83 ec 08             	sub    $0x8,%esp
    1620:	68 41 4e 00 00       	push   $0x4e41
    1625:	ff 35 14 6c 00 00    	pushl  0x6c14
    162b:	e8 9c 32 00 00       	call   48cc <printf>
    exit();
    1630:	e8 5d 31 00 00       	call   4792 <exit>
      if(n == MAXFILE - 1){
    1635:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
    163b:	74 39                	je     1676 <writetest1+0x155>
  }
  close(fd);
    163d:	83 ec 0c             	sub    $0xc,%esp
    1640:	56                   	push   %esi
    1641:	e8 74 31 00 00       	call   47ba <close>
  if(unlink("big") < 0){
    1646:	c7 04 24 73 4e 00 00 	movl   $0x4e73,(%esp)
    164d:	e8 90 31 00 00       	call   47e2 <unlink>
    1652:	83 c4 10             	add    $0x10,%esp
    1655:	85 c0                	test   %eax,%eax
    1657:	78 6a                	js     16c3 <writetest1+0x1a2>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
    1659:	83 ec 08             	sub    $0x8,%esp
    165c:	68 9a 4e 00 00       	push   $0x4e9a
    1661:	ff 35 14 6c 00 00    	pushl  0x6c14
    1667:	e8 60 32 00 00       	call   48cc <printf>
}
    166c:	83 c4 10             	add    $0x10,%esp
    166f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1672:	5b                   	pop    %ebx
    1673:	5e                   	pop    %esi
    1674:	5d                   	pop    %ebp
    1675:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
    1676:	83 ec 04             	sub    $0x4,%esp
    1679:	68 8b 00 00 00       	push   $0x8b
    167e:	68 5a 4e 00 00       	push   $0x4e5a
    1683:	ff 35 14 6c 00 00    	pushl  0x6c14
    1689:	e8 3e 32 00 00       	call   48cc <printf>
        exit();
    168e:	e8 ff 30 00 00       	call   4792 <exit>
      printf(stdout, "read failed %d\n", i);
    1693:	83 ec 04             	sub    $0x4,%esp
    1696:	50                   	push   %eax
    1697:	68 77 4e 00 00       	push   $0x4e77
    169c:	ff 35 14 6c 00 00    	pushl  0x6c14
    16a2:	e8 25 32 00 00       	call   48cc <printf>
      exit();
    16a7:	e8 e6 30 00 00       	call   4792 <exit>
      printf(stdout, "read content of block %d is %d\n",
    16ac:	50                   	push   %eax
    16ad:	53                   	push   %ebx
    16ae:	68 74 5c 00 00       	push   $0x5c74
    16b3:	ff 35 14 6c 00 00    	pushl  0x6c14
    16b9:	e8 0e 32 00 00       	call   48cc <printf>
      exit();
    16be:	e8 cf 30 00 00       	call   4792 <exit>
    printf(stdout, "unlink big failed\n");
    16c3:	83 ec 08             	sub    $0x8,%esp
    16c6:	68 87 4e 00 00       	push   $0x4e87
    16cb:	ff 35 14 6c 00 00    	pushl  0x6c14
    16d1:	e8 f6 31 00 00       	call   48cc <printf>
    exit();
    16d6:	e8 b7 30 00 00       	call   4792 <exit>

000016db <createtest>:

void
createtest(void)
{
    16db:	55                   	push   %ebp
    16dc:	89 e5                	mov    %esp,%ebp
    16de:	53                   	push   %ebx
    16df:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
    16e2:	68 94 5c 00 00       	push   $0x5c94
    16e7:	ff 35 14 6c 00 00    	pushl  0x6c14
    16ed:	e8 da 31 00 00       	call   48cc <printf>

  name[0] = 'a';
    16f2:	c6 05 00 b4 00 00 61 	movb   $0x61,0xb400
  name[2] = '\0';
    16f9:	c6 05 02 b4 00 00 00 	movb   $0x0,0xb402
    1700:	83 c4 10             	add    $0x10,%esp
    1703:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
    1708:	88 1d 01 b4 00 00    	mov    %bl,0xb401
    fd = open(name, O_CREATE|O_RDWR);
    170e:	83 ec 08             	sub    $0x8,%esp
    1711:	68 02 02 00 00       	push   $0x202
    1716:	68 00 b4 00 00       	push   $0xb400
    171b:	e8 b2 30 00 00       	call   47d2 <open>
    close(fd);
    1720:	89 04 24             	mov    %eax,(%esp)
    1723:	e8 92 30 00 00       	call   47ba <close>
    1728:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < 52; i++){
    172b:	83 c4 10             	add    $0x10,%esp
    172e:	80 fb 64             	cmp    $0x64,%bl
    1731:	75 d5                	jne    1708 <createtest+0x2d>
  }
  name[0] = 'a';
    1733:	c6 05 00 b4 00 00 61 	movb   $0x61,0xb400
  name[2] = '\0';
    173a:	c6 05 02 b4 00 00 00 	movb   $0x0,0xb402
    1741:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
    1746:	88 1d 01 b4 00 00    	mov    %bl,0xb401
    unlink(name);
    174c:	83 ec 0c             	sub    $0xc,%esp
    174f:	68 00 b4 00 00       	push   $0xb400
    1754:	e8 89 30 00 00       	call   47e2 <unlink>
    1759:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < 52; i++){
    175c:	83 c4 10             	add    $0x10,%esp
    175f:	80 fb 64             	cmp    $0x64,%bl
    1762:	75 e2                	jne    1746 <createtest+0x6b>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
    1764:	83 ec 08             	sub    $0x8,%esp
    1767:	68 bc 5c 00 00       	push   $0x5cbc
    176c:	ff 35 14 6c 00 00    	pushl  0x6c14
    1772:	e8 55 31 00 00       	call   48cc <printf>
}
    1777:	83 c4 10             	add    $0x10,%esp
    177a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    177d:	c9                   	leave  
    177e:	c3                   	ret    

0000177f <dirtest>:

void dirtest(void)
{
    177f:	55                   	push   %ebp
    1780:	89 e5                	mov    %esp,%ebp
    1782:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
    1785:	68 a8 4e 00 00       	push   $0x4ea8
    178a:	ff 35 14 6c 00 00    	pushl  0x6c14
    1790:	e8 37 31 00 00       	call   48cc <printf>

  if(mkdir("dir0") < 0){
    1795:	c7 04 24 b4 4e 00 00 	movl   $0x4eb4,(%esp)
    179c:	e8 59 30 00 00       	call   47fa <mkdir>
    17a1:	83 c4 10             	add    $0x10,%esp
    17a4:	85 c0                	test   %eax,%eax
    17a6:	78 54                	js     17fc <dirtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
    17a8:	83 ec 0c             	sub    $0xc,%esp
    17ab:	68 b4 4e 00 00       	push   $0x4eb4
    17b0:	e8 4d 30 00 00       	call   4802 <chdir>
    17b5:	83 c4 10             	add    $0x10,%esp
    17b8:	85 c0                	test   %eax,%eax
    17ba:	78 58                	js     1814 <dirtest+0x95>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
    17bc:	83 ec 0c             	sub    $0xc,%esp
    17bf:	68 59 54 00 00       	push   $0x5459
    17c4:	e8 39 30 00 00       	call   4802 <chdir>
    17c9:	83 c4 10             	add    $0x10,%esp
    17cc:	85 c0                	test   %eax,%eax
    17ce:	78 5c                	js     182c <dirtest+0xad>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
    17d0:	83 ec 0c             	sub    $0xc,%esp
    17d3:	68 b4 4e 00 00       	push   $0x4eb4
    17d8:	e8 05 30 00 00       	call   47e2 <unlink>
    17dd:	83 c4 10             	add    $0x10,%esp
    17e0:	85 c0                	test   %eax,%eax
    17e2:	78 60                	js     1844 <dirtest+0xc5>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
    17e4:	83 ec 08             	sub    $0x8,%esp
    17e7:	68 f1 4e 00 00       	push   $0x4ef1
    17ec:	ff 35 14 6c 00 00    	pushl  0x6c14
    17f2:	e8 d5 30 00 00       	call   48cc <printf>
}
    17f7:	83 c4 10             	add    $0x10,%esp
    17fa:	c9                   	leave  
    17fb:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
    17fc:	83 ec 08             	sub    $0x8,%esp
    17ff:	68 e4 4b 00 00       	push   $0x4be4
    1804:	ff 35 14 6c 00 00    	pushl  0x6c14
    180a:	e8 bd 30 00 00       	call   48cc <printf>
    exit();
    180f:	e8 7e 2f 00 00       	call   4792 <exit>
    printf(stdout, "chdir dir0 failed\n");
    1814:	83 ec 08             	sub    $0x8,%esp
    1817:	68 b9 4e 00 00       	push   $0x4eb9
    181c:	ff 35 14 6c 00 00    	pushl  0x6c14
    1822:	e8 a5 30 00 00       	call   48cc <printf>
    exit();
    1827:	e8 66 2f 00 00       	call   4792 <exit>
    printf(stdout, "chdir .. failed\n");
    182c:	83 ec 08             	sub    $0x8,%esp
    182f:	68 cc 4e 00 00       	push   $0x4ecc
    1834:	ff 35 14 6c 00 00    	pushl  0x6c14
    183a:	e8 8d 30 00 00       	call   48cc <printf>
    exit();
    183f:	e8 4e 2f 00 00       	call   4792 <exit>
    printf(stdout, "unlink dir0 failed\n");
    1844:	83 ec 08             	sub    $0x8,%esp
    1847:	68 dd 4e 00 00       	push   $0x4edd
    184c:	ff 35 14 6c 00 00    	pushl  0x6c14
    1852:	e8 75 30 00 00       	call   48cc <printf>
    exit();
    1857:	e8 36 2f 00 00       	call   4792 <exit>

0000185c <exectest>:

void
exectest(void)
{
    185c:	55                   	push   %ebp
    185d:	89 e5                	mov    %esp,%ebp
    185f:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
    1862:	68 00 4f 00 00       	push   $0x4f00
    1867:	ff 35 14 6c 00 00    	pushl  0x6c14
    186d:	e8 5a 30 00 00       	call   48cc <printf>
  if(exec("echo", echoargv) < 0){
    1872:	83 c4 08             	add    $0x8,%esp
    1875:	68 18 6c 00 00       	push   $0x6c18
    187a:	68 c9 4c 00 00       	push   $0x4cc9
    187f:	e8 46 2f 00 00       	call   47ca <exec>
    1884:	83 c4 10             	add    $0x10,%esp
    1887:	85 c0                	test   %eax,%eax
    1889:	78 02                	js     188d <exectest+0x31>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
    188b:	c9                   	leave  
    188c:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
    188d:	83 ec 08             	sub    $0x8,%esp
    1890:	68 0b 4f 00 00       	push   $0x4f0b
    1895:	ff 35 14 6c 00 00    	pushl  0x6c14
    189b:	e8 2c 30 00 00       	call   48cc <printf>
    exit();
    18a0:	e8 ed 2e 00 00       	call   4792 <exit>

000018a5 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    18a5:	55                   	push   %ebp
    18a6:	89 e5                	mov    %esp,%ebp
    18a8:	57                   	push   %edi
    18a9:	56                   	push   %esi
    18aa:	53                   	push   %ebx
    18ab:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    18ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
    18b1:	50                   	push   %eax
    18b2:	e8 eb 2e 00 00       	call   47a2 <pipe>
    18b7:	83 c4 10             	add    $0x10,%esp
    18ba:	85 c0                	test   %eax,%eax
    18bc:	75 75                	jne    1933 <pipe1+0x8e>
    18be:	89 c3                	mov    %eax,%ebx
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
    18c0:	e8 c5 2e 00 00       	call   478a <fork>
  seq = 0;
  if(pid == 0){
    18c5:	85 c0                	test   %eax,%eax
    18c7:	74 7e                	je     1947 <pipe1+0xa2>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    18c9:	85 c0                	test   %eax,%eax
    18cb:	0f 8e 62 01 00 00    	jle    1a33 <pipe1+0x18e>
    close(fds[1]);
    18d1:	83 ec 0c             	sub    $0xc,%esp
    18d4:	ff 75 e4             	pushl  -0x1c(%ebp)
    18d7:	e8 de 2e 00 00       	call   47ba <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    18dc:	83 c4 10             	add    $0x10,%esp
    total = 0;
    18df:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    cc = 1;
    18e2:	be 01 00 00 00       	mov    $0x1,%esi
    while((n = read(fds[0], buf, cc)) > 0){
    18e7:	83 ec 04             	sub    $0x4,%esp
    18ea:	56                   	push   %esi
    18eb:	68 00 94 00 00       	push   $0x9400
    18f0:	ff 75 e0             	pushl  -0x20(%ebp)
    18f3:	e8 b2 2e 00 00       	call   47aa <read>
    18f8:	83 c4 10             	add    $0x10,%esp
    18fb:	85 c0                	test   %eax,%eax
    18fd:	0f 8e ec 00 00 00    	jle    19ef <pipe1+0x14a>
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1903:	8d 53 01             	lea    0x1(%ebx),%edx
    1906:	38 1d 00 94 00 00    	cmp    %bl,0x9400
    190c:	0f 85 a9 00 00 00    	jne    19bb <pipe1+0x116>
    1912:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    1915:	f7 db                	neg    %ebx
      for(i = 0; i < n; i++){
    1917:	39 d7                	cmp    %edx,%edi
    1919:	0f 84 b6 00 00 00    	je     19d5 <pipe1+0x130>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    191f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1922:	38 94 13 00 94 00 00 	cmp    %dl,0x9400(%ebx,%edx,1)
    1929:	0f 85 8c 00 00 00    	jne    19bb <pipe1+0x116>
    192f:	89 ca                	mov    %ecx,%edx
    1931:	eb e4                	jmp    1917 <pipe1+0x72>
    printf(1, "pipe() failed\n");
    1933:	83 ec 08             	sub    $0x8,%esp
    1936:	68 1d 4f 00 00       	push   $0x4f1d
    193b:	6a 01                	push   $0x1
    193d:	e8 8a 2f 00 00       	call   48cc <printf>
    exit();
    1942:	e8 4b 2e 00 00       	call   4792 <exit>
    close(fds[0]);
    1947:	83 ec 0c             	sub    $0xc,%esp
    194a:	ff 75 e0             	pushl  -0x20(%ebp)
    194d:	e8 68 2e 00 00       	call   47ba <close>
    1952:	83 c4 10             	add    $0x10,%esp
    1955:	bb 00 00 00 00       	mov    $0x0,%ebx
    195a:	be 09 04 00 00       	mov    $0x409,%esi
    195f:	89 d8                	mov    %ebx,%eax
    1961:	f7 d8                	neg    %eax
    1963:	89 f2                	mov    %esi,%edx
    1965:	29 da                	sub    %ebx,%edx
        buf[i] = seq++;
    1967:	88 84 03 00 94 00 00 	mov    %al,0x9400(%ebx,%eax,1)
    196e:	83 c0 01             	add    $0x1,%eax
      for(i = 0; i < 1033; i++)
    1971:	39 c2                	cmp    %eax,%edx
    1973:	75 f2                	jne    1967 <pipe1+0xc2>
      if(write(fds[1], buf, 1033) != 1033){
    1975:	83 ec 04             	sub    $0x4,%esp
    1978:	68 09 04 00 00       	push   $0x409
    197d:	68 00 94 00 00       	push   $0x9400
    1982:	ff 75 e4             	pushl  -0x1c(%ebp)
    1985:	e8 28 2e 00 00       	call   47b2 <write>
    198a:	83 c4 10             	add    $0x10,%esp
    198d:	3d 09 04 00 00       	cmp    $0x409,%eax
    1992:	75 13                	jne    19a7 <pipe1+0x102>
    1994:	81 eb 09 04 00 00    	sub    $0x409,%ebx
    for(n = 0; n < 5; n++){
    199a:	81 fb d3 eb ff ff    	cmp    $0xffffebd3,%ebx
    19a0:	75 bd                	jne    195f <pipe1+0xba>
    exit();
    19a2:	e8 eb 2d 00 00       	call   4792 <exit>
        printf(1, "pipe1 oops 1\n");
    19a7:	83 ec 08             	sub    $0x8,%esp
    19aa:	68 2c 4f 00 00       	push   $0x4f2c
    19af:	6a 01                	push   $0x1
    19b1:	e8 16 2f 00 00       	call   48cc <printf>
        exit();
    19b6:	e8 d7 2d 00 00       	call   4792 <exit>
          printf(1, "pipe1 oops 2\n");
    19bb:	83 ec 08             	sub    $0x8,%esp
    19be:	68 3a 4f 00 00       	push   $0x4f3a
    19c3:	6a 01                	push   $0x1
    19c5:	e8 02 2f 00 00       	call   48cc <printf>
          return;
    19ca:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
    19cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19d0:	5b                   	pop    %ebx
    19d1:	5e                   	pop    %esi
    19d2:	5f                   	pop    %edi
    19d3:	5d                   	pop    %ebp
    19d4:	c3                   	ret    
      total += n;
    19d5:	01 45 d4             	add    %eax,-0x2c(%ebp)
      cc = cc * 2;
    19d8:	01 f6                	add    %esi,%esi
        cc = sizeof(buf);
    19da:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
    19e0:	b8 00 20 00 00       	mov    $0x2000,%eax
    19e5:	0f 43 f0             	cmovae %eax,%esi
    19e8:	89 d3                	mov    %edx,%ebx
    19ea:	e9 f8 fe ff ff       	jmp    18e7 <pipe1+0x42>
    if(total != 5 * 1033){
    19ef:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
    19f6:	75 24                	jne    1a1c <pipe1+0x177>
    close(fds[0]);
    19f8:	83 ec 0c             	sub    $0xc,%esp
    19fb:	ff 75 e0             	pushl  -0x20(%ebp)
    19fe:	e8 b7 2d 00 00       	call   47ba <close>
    wait();
    1a03:	e8 92 2d 00 00       	call   479a <wait>
  printf(1, "pipe1 ok\n");
    1a08:	83 c4 08             	add    $0x8,%esp
    1a0b:	68 5f 4f 00 00       	push   $0x4f5f
    1a10:	6a 01                	push   $0x1
    1a12:	e8 b5 2e 00 00       	call   48cc <printf>
    1a17:	83 c4 10             	add    $0x10,%esp
    1a1a:	eb b1                	jmp    19cd <pipe1+0x128>
      printf(1, "pipe1 oops 3 total %d\n", total);
    1a1c:	83 ec 04             	sub    $0x4,%esp
    1a1f:	ff 75 d4             	pushl  -0x2c(%ebp)
    1a22:	68 48 4f 00 00       	push   $0x4f48
    1a27:	6a 01                	push   $0x1
    1a29:	e8 9e 2e 00 00       	call   48cc <printf>
      exit();
    1a2e:	e8 5f 2d 00 00       	call   4792 <exit>
    printf(1, "fork() failed\n");
    1a33:	83 ec 08             	sub    $0x8,%esp
    1a36:	68 69 4f 00 00       	push   $0x4f69
    1a3b:	6a 01                	push   $0x1
    1a3d:	e8 8a 2e 00 00       	call   48cc <printf>
    exit();
    1a42:	e8 4b 2d 00 00       	call   4792 <exit>

00001a47 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    1a47:	55                   	push   %ebp
    1a48:	89 e5                	mov    %esp,%ebp
    1a4a:	57                   	push   %edi
    1a4b:	56                   	push   %esi
    1a4c:	53                   	push   %ebx
    1a4d:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    1a50:	68 78 4f 00 00       	push   $0x4f78
    1a55:	6a 01                	push   $0x1
    1a57:	e8 70 2e 00 00       	call   48cc <printf>
  pid1 = fork();
    1a5c:	e8 29 2d 00 00       	call   478a <fork>
  if(pid1 == 0)
    1a61:	83 c4 10             	add    $0x10,%esp
    1a64:	85 c0                	test   %eax,%eax
    1a66:	75 02                	jne    1a6a <preempt+0x23>
    1a68:	eb fe                	jmp    1a68 <preempt+0x21>
    1a6a:	89 c7                	mov    %eax,%edi
    for(;;)
      ;

  pid2 = fork();
    1a6c:	e8 19 2d 00 00       	call   478a <fork>
    1a71:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
    1a73:	85 c0                	test   %eax,%eax
    1a75:	75 02                	jne    1a79 <preempt+0x32>
    1a77:	eb fe                	jmp    1a77 <preempt+0x30>
    for(;;)
      ;

  pipe(pfds);
    1a79:	83 ec 0c             	sub    $0xc,%esp
    1a7c:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1a7f:	50                   	push   %eax
    1a80:	e8 1d 2d 00 00       	call   47a2 <pipe>
  pid3 = fork();
    1a85:	e8 00 2d 00 00       	call   478a <fork>
    1a8a:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    1a8c:	83 c4 10             	add    $0x10,%esp
    1a8f:	85 c0                	test   %eax,%eax
    1a91:	75 47                	jne    1ada <preempt+0x93>
    close(pfds[0]);
    1a93:	83 ec 0c             	sub    $0xc,%esp
    1a96:	ff 75 e0             	pushl  -0x20(%ebp)
    1a99:	e8 1c 2d 00 00       	call   47ba <close>
    if(write(pfds[1], "x", 1) != 1)
    1a9e:	83 c4 0c             	add    $0xc,%esp
    1aa1:	6a 01                	push   $0x1
    1aa3:	68 3d 55 00 00       	push   $0x553d
    1aa8:	ff 75 e4             	pushl  -0x1c(%ebp)
    1aab:	e8 02 2d 00 00       	call   47b2 <write>
    1ab0:	83 c4 10             	add    $0x10,%esp
    1ab3:	83 f8 01             	cmp    $0x1,%eax
    1ab6:	74 12                	je     1aca <preempt+0x83>
      printf(1, "preempt write error");
    1ab8:	83 ec 08             	sub    $0x8,%esp
    1abb:	68 82 4f 00 00       	push   $0x4f82
    1ac0:	6a 01                	push   $0x1
    1ac2:	e8 05 2e 00 00       	call   48cc <printf>
    1ac7:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
    1aca:	83 ec 0c             	sub    $0xc,%esp
    1acd:	ff 75 e4             	pushl  -0x1c(%ebp)
    1ad0:	e8 e5 2c 00 00       	call   47ba <close>
    1ad5:	83 c4 10             	add    $0x10,%esp
    1ad8:	eb fe                	jmp    1ad8 <preempt+0x91>
    for(;;)
      ;
  }

  close(pfds[1]);
    1ada:	83 ec 0c             	sub    $0xc,%esp
    1add:	ff 75 e4             	pushl  -0x1c(%ebp)
    1ae0:	e8 d5 2c 00 00       	call   47ba <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1ae5:	83 c4 0c             	add    $0xc,%esp
    1ae8:	68 00 20 00 00       	push   $0x2000
    1aed:	68 00 94 00 00       	push   $0x9400
    1af2:	ff 75 e0             	pushl  -0x20(%ebp)
    1af5:	e8 b0 2c 00 00       	call   47aa <read>
    1afa:	83 c4 10             	add    $0x10,%esp
    1afd:	83 f8 01             	cmp    $0x1,%eax
    1b00:	74 1a                	je     1b1c <preempt+0xd5>
    printf(1, "preempt read error");
    1b02:	83 ec 08             	sub    $0x8,%esp
    1b05:	68 96 4f 00 00       	push   $0x4f96
    1b0a:	6a 01                	push   $0x1
    1b0c:	e8 bb 2d 00 00       	call   48cc <printf>
    return;
    1b11:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
    1b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b17:	5b                   	pop    %ebx
    1b18:	5e                   	pop    %esi
    1b19:	5f                   	pop    %edi
    1b1a:	5d                   	pop    %ebp
    1b1b:	c3                   	ret    
  close(pfds[0]);
    1b1c:	83 ec 0c             	sub    $0xc,%esp
    1b1f:	ff 75 e0             	pushl  -0x20(%ebp)
    1b22:	e8 93 2c 00 00       	call   47ba <close>
  printf(1, "kill... ");
    1b27:	83 c4 08             	add    $0x8,%esp
    1b2a:	68 a9 4f 00 00       	push   $0x4fa9
    1b2f:	6a 01                	push   $0x1
    1b31:	e8 96 2d 00 00       	call   48cc <printf>
  kill(pid1);
    1b36:	89 3c 24             	mov    %edi,(%esp)
    1b39:	e8 84 2c 00 00       	call   47c2 <kill>
  kill(pid2);
    1b3e:	89 34 24             	mov    %esi,(%esp)
    1b41:	e8 7c 2c 00 00       	call   47c2 <kill>
  kill(pid3);
    1b46:	89 1c 24             	mov    %ebx,(%esp)
    1b49:	e8 74 2c 00 00       	call   47c2 <kill>
  printf(1, "wait... ");
    1b4e:	83 c4 08             	add    $0x8,%esp
    1b51:	68 b2 4f 00 00       	push   $0x4fb2
    1b56:	6a 01                	push   $0x1
    1b58:	e8 6f 2d 00 00       	call   48cc <printf>
  wait();
    1b5d:	e8 38 2c 00 00       	call   479a <wait>
  wait();
    1b62:	e8 33 2c 00 00       	call   479a <wait>
  wait();
    1b67:	e8 2e 2c 00 00       	call   479a <wait>
  printf(1, "preempt ok\n");
    1b6c:	83 c4 08             	add    $0x8,%esp
    1b6f:	68 bb 4f 00 00       	push   $0x4fbb
    1b74:	6a 01                	push   $0x1
    1b76:	e8 51 2d 00 00       	call   48cc <printf>
    1b7b:	83 c4 10             	add    $0x10,%esp
    1b7e:	eb 94                	jmp    1b14 <preempt+0xcd>

00001b80 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
    1b80:	55                   	push   %ebp
    1b81:	89 e5                	mov    %esp,%ebp
    1b83:	56                   	push   %esi
    1b84:	53                   	push   %ebx
    1b85:	be 64 00 00 00       	mov    $0x64,%esi
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
    1b8a:	e8 fb 2b 00 00       	call   478a <fork>
    1b8f:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    1b91:	85 c0                	test   %eax,%eax
    1b93:	78 26                	js     1bbb <exitwait+0x3b>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
    1b95:	85 c0                	test   %eax,%eax
    1b97:	74 4f                	je     1be8 <exitwait+0x68>
      if(wait() != pid){
    1b99:	e8 fc 2b 00 00       	call   479a <wait>
    1b9e:	39 d8                	cmp    %ebx,%eax
    1ba0:	75 32                	jne    1bd4 <exitwait+0x54>
  for(i = 0; i < 100; i++){
    1ba2:	83 ee 01             	sub    $0x1,%esi
    1ba5:	75 e3                	jne    1b8a <exitwait+0xa>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
    1ba7:	83 ec 08             	sub    $0x8,%esp
    1baa:	68 d7 4f 00 00       	push   $0x4fd7
    1baf:	6a 01                	push   $0x1
    1bb1:	e8 16 2d 00 00       	call   48cc <printf>
    1bb6:	83 c4 10             	add    $0x10,%esp
    1bb9:	eb 12                	jmp    1bcd <exitwait+0x4d>
      printf(1, "fork failed\n");
    1bbb:	83 ec 08             	sub    $0x8,%esp
    1bbe:	68 25 5b 00 00       	push   $0x5b25
    1bc3:	6a 01                	push   $0x1
    1bc5:	e8 02 2d 00 00       	call   48cc <printf>
      return;
    1bca:	83 c4 10             	add    $0x10,%esp
}
    1bcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1bd0:	5b                   	pop    %ebx
    1bd1:	5e                   	pop    %esi
    1bd2:	5d                   	pop    %ebp
    1bd3:	c3                   	ret    
        printf(1, "wait wrong pid\n");
    1bd4:	83 ec 08             	sub    $0x8,%esp
    1bd7:	68 c7 4f 00 00       	push   $0x4fc7
    1bdc:	6a 01                	push   $0x1
    1bde:	e8 e9 2c 00 00       	call   48cc <printf>
        return;
    1be3:	83 c4 10             	add    $0x10,%esp
    1be6:	eb e5                	jmp    1bcd <exitwait+0x4d>
      exit();
    1be8:	e8 a5 2b 00 00       	call   4792 <exit>

00001bed <mem>:

void
mem(void)
{
    1bed:	55                   	push   %ebp
    1bee:	89 e5                	mov    %esp,%ebp
    1bf0:	57                   	push   %edi
    1bf1:	56                   	push   %esi
    1bf2:	53                   	push   %ebx
    1bf3:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    1bf6:	68 e4 4f 00 00       	push   $0x4fe4
    1bfb:	6a 01                	push   $0x1
    1bfd:	e8 ca 2c 00 00       	call   48cc <printf>
  ppid = getpid();
    1c02:	e8 0b 2c 00 00       	call   4812 <getpid>
    1c07:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
    1c09:	e8 7c 2b 00 00       	call   478a <fork>
    1c0e:	83 c4 10             	add    $0x10,%esp
    m1 = 0;
    1c11:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((pid = fork()) == 0){
    1c16:	85 c0                	test   %eax,%eax
    1c18:	74 11                	je     1c2b <mem+0x3e>
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
    1c1a:	e8 7b 2b 00 00       	call   479a <wait>
  }
}
    1c1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1c22:	5b                   	pop    %ebx
    1c23:	5e                   	pop    %esi
    1c24:	5f                   	pop    %edi
    1c25:	5d                   	pop    %ebp
    1c26:	c3                   	ret    
      *(char**)m2 = m1;
    1c27:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
    1c29:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
    1c2b:	83 ec 0c             	sub    $0xc,%esp
    1c2e:	68 11 27 00 00       	push   $0x2711
    1c33:	e8 d2 2e 00 00       	call   4b0a <malloc>
    1c38:	83 c4 10             	add    $0x10,%esp
    1c3b:	85 c0                	test   %eax,%eax
    1c3d:	75 e8                	jne    1c27 <mem+0x3a>
    while(m1){
    1c3f:	85 db                	test   %ebx,%ebx
    1c41:	74 14                	je     1c57 <mem+0x6a>
      m2 = *(char**)m1;
    1c43:	8b 3b                	mov    (%ebx),%edi
      free(m1);
    1c45:	83 ec 0c             	sub    $0xc,%esp
    1c48:	53                   	push   %ebx
    1c49:	e8 4e 2e 00 00       	call   4a9c <free>
      m1 = m2;
    1c4e:	89 fb                	mov    %edi,%ebx
    while(m1){
    1c50:	83 c4 10             	add    $0x10,%esp
    1c53:	85 ff                	test   %edi,%edi
    1c55:	75 ec                	jne    1c43 <mem+0x56>
    m1 = malloc(1024*20);
    1c57:	83 ec 0c             	sub    $0xc,%esp
    1c5a:	68 00 50 00 00       	push   $0x5000
    1c5f:	e8 a6 2e 00 00       	call   4b0a <malloc>
    if(m1 == 0){
    1c64:	83 c4 10             	add    $0x10,%esp
    1c67:	85 c0                	test   %eax,%eax
    1c69:	74 1d                	je     1c88 <mem+0x9b>
    free(m1);
    1c6b:	83 ec 0c             	sub    $0xc,%esp
    1c6e:	50                   	push   %eax
    1c6f:	e8 28 2e 00 00       	call   4a9c <free>
    printf(1, "mem ok\n");
    1c74:	83 c4 08             	add    $0x8,%esp
    1c77:	68 08 50 00 00       	push   $0x5008
    1c7c:	6a 01                	push   $0x1
    1c7e:	e8 49 2c 00 00       	call   48cc <printf>
    exit();
    1c83:	e8 0a 2b 00 00       	call   4792 <exit>
      printf(1, "couldn't allocate mem?!!\n");
    1c88:	83 ec 08             	sub    $0x8,%esp
    1c8b:	68 ee 4f 00 00       	push   $0x4fee
    1c90:	6a 01                	push   $0x1
    1c92:	e8 35 2c 00 00       	call   48cc <printf>
      kill(ppid);
    1c97:	89 34 24             	mov    %esi,(%esp)
    1c9a:	e8 23 2b 00 00       	call   47c2 <kill>
      exit();
    1c9f:	e8 ee 2a 00 00       	call   4792 <exit>

00001ca4 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    1ca4:	55                   	push   %ebp
    1ca5:	89 e5                	mov    %esp,%ebp
    1ca7:	57                   	push   %edi
    1ca8:	56                   	push   %esi
    1ca9:	53                   	push   %ebx
    1caa:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    1cad:	68 10 50 00 00       	push   $0x5010
    1cb2:	6a 01                	push   $0x1
    1cb4:	e8 13 2c 00 00       	call   48cc <printf>

  unlink("sharedfd");
    1cb9:	c7 04 24 1f 50 00 00 	movl   $0x501f,(%esp)
    1cc0:	e8 1d 2b 00 00       	call   47e2 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1cc5:	83 c4 08             	add    $0x8,%esp
    1cc8:	68 02 02 00 00       	push   $0x202
    1ccd:	68 1f 50 00 00       	push   $0x501f
    1cd2:	e8 fb 2a 00 00       	call   47d2 <open>
  if(fd < 0){
    1cd7:	83 c4 10             	add    $0x10,%esp
    1cda:	85 c0                	test   %eax,%eax
    1cdc:	78 4a                	js     1d28 <sharedfd+0x84>
    1cde:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    1ce0:	e8 a5 2a 00 00       	call   478a <fork>
    1ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1ce8:	83 f8 01             	cmp    $0x1,%eax
    1ceb:	19 c0                	sbb    %eax,%eax
    1ced:	83 e0 f3             	and    $0xfffffff3,%eax
    1cf0:	83 c0 70             	add    $0x70,%eax
    1cf3:	83 ec 04             	sub    $0x4,%esp
    1cf6:	6a 0a                	push   $0xa
    1cf8:	50                   	push   %eax
    1cf9:	8d 45 de             	lea    -0x22(%ebp),%eax
    1cfc:	50                   	push   %eax
    1cfd:	e8 43 29 00 00       	call   4645 <memset>
    1d02:	83 c4 10             	add    $0x10,%esp
    1d05:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  for(i = 0; i < 1000; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1d0a:	8d 7d de             	lea    -0x22(%ebp),%edi
    1d0d:	83 ec 04             	sub    $0x4,%esp
    1d10:	6a 0a                	push   $0xa
    1d12:	57                   	push   %edi
    1d13:	56                   	push   %esi
    1d14:	e8 99 2a 00 00       	call   47b2 <write>
    1d19:	83 c4 10             	add    $0x10,%esp
    1d1c:	83 f8 0a             	cmp    $0xa,%eax
    1d1f:	75 1e                	jne    1d3f <sharedfd+0x9b>
  for(i = 0; i < 1000; i++){
    1d21:	83 eb 01             	sub    $0x1,%ebx
    1d24:	75 e7                	jne    1d0d <sharedfd+0x69>
    1d26:	eb 29                	jmp    1d51 <sharedfd+0xad>
    printf(1, "fstests: cannot open sharedfd for writing");
    1d28:	83 ec 08             	sub    $0x8,%esp
    1d2b:	68 e4 5c 00 00       	push   $0x5ce4
    1d30:	6a 01                	push   $0x1
    1d32:	e8 95 2b 00 00       	call   48cc <printf>
    return;
    1d37:	83 c4 10             	add    $0x10,%esp
    1d3a:	e9 dd 00 00 00       	jmp    1e1c <sharedfd+0x178>
      printf(1, "fstests: write sharedfd failed\n");
    1d3f:	83 ec 08             	sub    $0x8,%esp
    1d42:	68 10 5d 00 00       	push   $0x5d10
    1d47:	6a 01                	push   $0x1
    1d49:	e8 7e 2b 00 00       	call   48cc <printf>
      break;
    1d4e:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
    1d51:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    1d55:	74 51                	je     1da8 <sharedfd+0x104>
    exit();
  else
    wait();
    1d57:	e8 3e 2a 00 00       	call   479a <wait>
  close(fd);
    1d5c:	83 ec 0c             	sub    $0xc,%esp
    1d5f:	56                   	push   %esi
    1d60:	e8 55 2a 00 00       	call   47ba <close>
  fd = open("sharedfd", 0);
    1d65:	83 c4 08             	add    $0x8,%esp
    1d68:	6a 00                	push   $0x0
    1d6a:	68 1f 50 00 00       	push   $0x501f
    1d6f:	e8 5e 2a 00 00       	call   47d2 <open>
    1d74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
    1d77:	83 c4 10             	add    $0x10,%esp
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
    1d7a:	bb 00 00 00 00       	mov    $0x0,%ebx
    1d7f:	bf 00 00 00 00       	mov    $0x0,%edi
    1d84:	8d 75 e8             	lea    -0x18(%ebp),%esi
  if(fd < 0){
    1d87:	85 c0                	test   %eax,%eax
    1d89:	78 22                	js     1dad <sharedfd+0x109>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1d8b:	83 ec 04             	sub    $0x4,%esp
    1d8e:	6a 0a                	push   $0xa
    1d90:	8d 45 de             	lea    -0x22(%ebp),%eax
    1d93:	50                   	push   %eax
    1d94:	ff 75 d4             	pushl  -0x2c(%ebp)
    1d97:	e8 0e 2a 00 00       	call   47aa <read>
    1d9c:	83 c4 10             	add    $0x10,%esp
    1d9f:	85 c0                	test   %eax,%eax
    1da1:	7e 3d                	jle    1de0 <sharedfd+0x13c>
    1da3:	8d 45 de             	lea    -0x22(%ebp),%eax
    1da6:	eb 23                	jmp    1dcb <sharedfd+0x127>
    exit();
    1da8:	e8 e5 29 00 00       	call   4792 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1dad:	83 ec 08             	sub    $0x8,%esp
    1db0:	68 30 5d 00 00       	push   $0x5d30
    1db5:	6a 01                	push   $0x1
    1db7:	e8 10 2b 00 00       	call   48cc <printf>
    return;
    1dbc:	83 c4 10             	add    $0x10,%esp
    1dbf:	eb 5b                	jmp    1e1c <sharedfd+0x178>
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
    1dc1:	83 c7 01             	add    $0x1,%edi
    1dc4:	83 c0 01             	add    $0x1,%eax
    for(i = 0; i < sizeof(buf); i++){
    1dc7:	39 f0                	cmp    %esi,%eax
    1dc9:	74 c0                	je     1d8b <sharedfd+0xe7>
      if(buf[i] == 'c')
    1dcb:	0f b6 10             	movzbl (%eax),%edx
    1dce:	80 fa 63             	cmp    $0x63,%dl
    1dd1:	74 ee                	je     1dc1 <sharedfd+0x11d>
      if(buf[i] == 'p')
        np++;
    1dd3:	80 fa 70             	cmp    $0x70,%dl
    1dd6:	0f 94 c2             	sete   %dl
    1dd9:	0f b6 d2             	movzbl %dl,%edx
    1ddc:	01 d3                	add    %edx,%ebx
    1dde:	eb e4                	jmp    1dc4 <sharedfd+0x120>
    }
  }
  close(fd);
    1de0:	83 ec 0c             	sub    $0xc,%esp
    1de3:	ff 75 d4             	pushl  -0x2c(%ebp)
    1de6:	e8 cf 29 00 00       	call   47ba <close>
  unlink("sharedfd");
    1deb:	c7 04 24 1f 50 00 00 	movl   $0x501f,(%esp)
    1df2:	e8 eb 29 00 00       	call   47e2 <unlink>
  if(nc == 10000 && np == 10000){
    1df7:	83 c4 10             	add    $0x10,%esp
    1dfa:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
    1e00:	75 22                	jne    1e24 <sharedfd+0x180>
    1e02:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    1e08:	75 1a                	jne    1e24 <sharedfd+0x180>
    printf(1, "sharedfd ok\n");
    1e0a:	83 ec 08             	sub    $0x8,%esp
    1e0d:	68 28 50 00 00       	push   $0x5028
    1e12:	6a 01                	push   $0x1
    1e14:	e8 b3 2a 00 00       	call   48cc <printf>
    1e19:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    1e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1e1f:	5b                   	pop    %ebx
    1e20:	5e                   	pop    %esi
    1e21:	5f                   	pop    %edi
    1e22:	5d                   	pop    %ebp
    1e23:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1e24:	53                   	push   %ebx
    1e25:	57                   	push   %edi
    1e26:	68 35 50 00 00       	push   $0x5035
    1e2b:	6a 01                	push   $0x1
    1e2d:	e8 9a 2a 00 00       	call   48cc <printf>
    exit();
    1e32:	e8 5b 29 00 00       	call   4792 <exit>

00001e37 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1e37:	55                   	push   %ebp
    1e38:	89 e5                	mov    %esp,%ebp
    1e3a:	57                   	push   %edi
    1e3b:	56                   	push   %esi
    1e3c:	53                   	push   %ebx
    1e3d:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e40:	c7 45 d8 4a 50 00 00 	movl   $0x504a,-0x28(%ebp)
    1e47:	c7 45 dc 93 51 00 00 	movl   $0x5193,-0x24(%ebp)
    1e4e:	c7 45 e0 97 51 00 00 	movl   $0x5197,-0x20(%ebp)
    1e55:	c7 45 e4 4d 50 00 00 	movl   $0x504d,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1e5c:	68 50 50 00 00       	push   $0x5050
    1e61:	6a 01                	push   $0x1
    1e63:	e8 64 2a 00 00       	call   48cc <printf>
    1e68:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1e6b:	bb 00 00 00 00       	mov    $0x0,%ebx
    fname = names[pi];
    1e70:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
    1e74:	83 ec 0c             	sub    $0xc,%esp
    1e77:	56                   	push   %esi
    1e78:	e8 65 29 00 00       	call   47e2 <unlink>

    pid = fork();
    1e7d:	e8 08 29 00 00       	call   478a <fork>
    if(pid < 0){
    1e82:	83 c4 10             	add    $0x10,%esp
    1e85:	85 c0                	test   %eax,%eax
    1e87:	78 2a                	js     1eb3 <fourfiles+0x7c>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    1e89:	85 c0                	test   %eax,%eax
    1e8b:	74 3a                	je     1ec7 <fourfiles+0x90>
  for(pi = 0; pi < 4; pi++){
    1e8d:	83 c3 01             	add    $0x1,%ebx
    1e90:	83 fb 04             	cmp    $0x4,%ebx
    1e93:	75 db                	jne    1e70 <fourfiles+0x39>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    1e95:	e8 00 29 00 00       	call   479a <wait>
    1e9a:	e8 fb 28 00 00       	call   479a <wait>
    1e9f:	e8 f6 28 00 00       	call   479a <wait>
    1ea4:	e8 f1 28 00 00       	call   479a <wait>
    1ea9:	bf 30 00 00 00       	mov    $0x30,%edi
    1eae:	e9 15 01 00 00       	jmp    1fc8 <fourfiles+0x191>
      printf(1, "fork failed\n");
    1eb3:	83 ec 08             	sub    $0x8,%esp
    1eb6:	68 25 5b 00 00       	push   $0x5b25
    1ebb:	6a 01                	push   $0x1
    1ebd:	e8 0a 2a 00 00       	call   48cc <printf>
      exit();
    1ec2:	e8 cb 28 00 00       	call   4792 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1ec7:	83 ec 08             	sub    $0x8,%esp
    1eca:	68 02 02 00 00       	push   $0x202
    1ecf:	56                   	push   %esi
    1ed0:	e8 fd 28 00 00       	call   47d2 <open>
    1ed5:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    1ed7:	83 c4 10             	add    $0x10,%esp
    1eda:	85 c0                	test   %eax,%eax
    1edc:	78 45                	js     1f23 <fourfiles+0xec>
      memset(buf, '0'+pi, 512);
    1ede:	83 ec 04             	sub    $0x4,%esp
    1ee1:	68 00 02 00 00       	push   $0x200
    1ee6:	83 c3 30             	add    $0x30,%ebx
    1ee9:	53                   	push   %ebx
    1eea:	68 00 94 00 00       	push   $0x9400
    1eef:	e8 51 27 00 00       	call   4645 <memset>
    1ef4:	83 c4 10             	add    $0x10,%esp
    1ef7:	bb 0c 00 00 00       	mov    $0xc,%ebx
        if((n = write(fd, buf, 500)) != 500){
    1efc:	83 ec 04             	sub    $0x4,%esp
    1eff:	68 f4 01 00 00       	push   $0x1f4
    1f04:	68 00 94 00 00       	push   $0x9400
    1f09:	56                   	push   %esi
    1f0a:	e8 a3 28 00 00       	call   47b2 <write>
    1f0f:	83 c4 10             	add    $0x10,%esp
    1f12:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1f17:	75 1e                	jne    1f37 <fourfiles+0x100>
      for(i = 0; i < 12; i++){
    1f19:	83 eb 01             	sub    $0x1,%ebx
    1f1c:	75 de                	jne    1efc <fourfiles+0xc5>
      exit();
    1f1e:	e8 6f 28 00 00       	call   4792 <exit>
        printf(1, "create failed\n");
    1f23:	83 ec 08             	sub    $0x8,%esp
    1f26:	68 eb 52 00 00       	push   $0x52eb
    1f2b:	6a 01                	push   $0x1
    1f2d:	e8 9a 29 00 00       	call   48cc <printf>
        exit();
    1f32:	e8 5b 28 00 00       	call   4792 <exit>
          printf(1, "write failed %d\n", n);
    1f37:	83 ec 04             	sub    $0x4,%esp
    1f3a:	50                   	push   %eax
    1f3b:	68 60 50 00 00       	push   $0x5060
    1f40:	6a 01                	push   $0x1
    1f42:	e8 85 29 00 00       	call   48cc <printf>
          exit();
    1f47:	e8 46 28 00 00       	call   4792 <exit>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    1f4c:	01 d3                	add    %edx,%ebx
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f4e:	83 ec 04             	sub    $0x4,%esp
    1f51:	68 00 20 00 00       	push   $0x2000
    1f56:	68 00 94 00 00       	push   $0x9400
    1f5b:	56                   	push   %esi
    1f5c:	e8 49 28 00 00       	call   47aa <read>
    1f61:	83 c4 10             	add    $0x10,%esp
    1f64:	85 c0                	test   %eax,%eax
    1f66:	7e 36                	jle    1f9e <fourfiles+0x167>
        if(buf[j] != '0'+i){
    1f68:	0f b6 0d 00 94 00 00 	movzbl 0x9400,%ecx
    1f6f:	0f be d1             	movsbl %cl,%edx
    1f72:	39 fa                	cmp    %edi,%edx
    1f74:	75 14                	jne    1f8a <fourfiles+0x153>
      for(j = 0; j < n; j++){
    1f76:	ba 00 00 00 00       	mov    $0x0,%edx
    1f7b:	83 c2 01             	add    $0x1,%edx
    1f7e:	39 d0                	cmp    %edx,%eax
    1f80:	74 ca                	je     1f4c <fourfiles+0x115>
        if(buf[j] != '0'+i){
    1f82:	38 8a 00 94 00 00    	cmp    %cl,0x9400(%edx)
    1f88:	74 f1                	je     1f7b <fourfiles+0x144>
          printf(1, "wrong char\n");
    1f8a:	83 ec 08             	sub    $0x8,%esp
    1f8d:	68 71 50 00 00       	push   $0x5071
    1f92:	6a 01                	push   $0x1
    1f94:	e8 33 29 00 00       	call   48cc <printf>
          exit();
    1f99:	e8 f4 27 00 00       	call   4792 <exit>
    }
    close(fd);
    1f9e:	83 ec 0c             	sub    $0xc,%esp
    1fa1:	56                   	push   %esi
    1fa2:	e8 13 28 00 00       	call   47ba <close>
    if(total != 12*500){
    1fa7:	83 c4 10             	add    $0x10,%esp
    1faa:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1fb0:	75 3a                	jne    1fec <fourfiles+0x1b5>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
    1fb2:	83 ec 0c             	sub    $0xc,%esp
    1fb5:	ff 75 d4             	pushl  -0x2c(%ebp)
    1fb8:	e8 25 28 00 00       	call   47e2 <unlink>
    1fbd:	83 c7 01             	add    $0x1,%edi
  for(i = 0; i < 2; i++){
    1fc0:	83 c4 10             	add    $0x10,%esp
    1fc3:	83 ff 32             	cmp    $0x32,%edi
    1fc6:	74 39                	je     2001 <fourfiles+0x1ca>
    fname = names[i];
    1fc8:	8b 84 bd 18 ff ff ff 	mov    -0xe8(%ebp,%edi,4),%eax
    1fcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    fd = open(fname, 0);
    1fd2:	83 ec 08             	sub    $0x8,%esp
    1fd5:	6a 00                	push   $0x0
    1fd7:	50                   	push   %eax
    1fd8:	e8 f5 27 00 00       	call   47d2 <open>
    1fdd:	89 c6                	mov    %eax,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1fdf:	83 c4 10             	add    $0x10,%esp
    total = 0;
    1fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1fe7:	e9 62 ff ff ff       	jmp    1f4e <fourfiles+0x117>
      printf(1, "wrong length %d\n", total);
    1fec:	83 ec 04             	sub    $0x4,%esp
    1fef:	53                   	push   %ebx
    1ff0:	68 7d 50 00 00       	push   $0x507d
    1ff5:	6a 01                	push   $0x1
    1ff7:	e8 d0 28 00 00       	call   48cc <printf>
      exit();
    1ffc:	e8 91 27 00 00       	call   4792 <exit>
  }

  printf(1, "fourfiles ok\n");
    2001:	83 ec 08             	sub    $0x8,%esp
    2004:	68 8e 50 00 00       	push   $0x508e
    2009:	6a 01                	push   $0x1
    200b:	e8 bc 28 00 00       	call   48cc <printf>
}
    2010:	83 c4 10             	add    $0x10,%esp
    2013:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2016:	5b                   	pop    %ebx
    2017:	5e                   	pop    %esi
    2018:	5f                   	pop    %edi
    2019:	5d                   	pop    %ebp
    201a:	c3                   	ret    

0000201b <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    201b:	55                   	push   %ebp
    201c:	89 e5                	mov    %esp,%ebp
    201e:	57                   	push   %edi
    201f:	56                   	push   %esi
    2020:	53                   	push   %ebx
    2021:	83 ec 44             	sub    $0x44,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    2024:	68 9c 50 00 00       	push   $0x509c
    2029:	6a 01                	push   $0x1
    202b:	e8 9c 28 00 00       	call   48cc <printf>
    2030:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    2033:	be 00 00 00 00       	mov    $0x0,%esi
    pid = fork();
    2038:	e8 4d 27 00 00       	call   478a <fork>
    if(pid < 0){
    203d:	85 c0                	test   %eax,%eax
    203f:	78 3c                	js     207d <createdelete+0x62>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    2041:	85 c0                	test   %eax,%eax
    2043:	74 4c                	je     2091 <createdelete+0x76>
  for(pi = 0; pi < 4; pi++){
    2045:	83 c6 01             	add    $0x1,%esi
    2048:	83 fe 04             	cmp    $0x4,%esi
    204b:	75 eb                	jne    2038 <createdelete+0x1d>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    204d:	e8 48 27 00 00       	call   479a <wait>
    2052:	e8 43 27 00 00       	call   479a <wait>
    2057:	e8 3e 27 00 00       	call   479a <wait>
    205c:	e8 39 27 00 00       	call   479a <wait>
  }

  name[0] = name[1] = name[2] = 0;
    2061:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    2065:	c6 45 c7 30          	movb   $0x30,-0x39(%ebp)
    2069:	c7 45 c0 ff ff ff ff 	movl   $0xffffffff,-0x40(%ebp)
  for(i = 0; i < N; i++){
    2070:	be 00 00 00 00       	mov    $0x0,%esi
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
    2075:	8d 7d c8             	lea    -0x38(%ebp),%edi
    2078:	e9 38 01 00 00       	jmp    21b5 <createdelete+0x19a>
      printf(1, "fork failed\n");
    207d:	83 ec 08             	sub    $0x8,%esp
    2080:	68 25 5b 00 00       	push   $0x5b25
    2085:	6a 01                	push   $0x1
    2087:	e8 40 28 00 00       	call   48cc <printf>
      exit();
    208c:	e8 01 27 00 00       	call   4792 <exit>
    2091:	89 c3                	mov    %eax,%ebx
      name[0] = 'p' + pi;
    2093:	8d 46 70             	lea    0x70(%esi),%eax
    2096:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    2099:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    209d:	8d 75 c8             	lea    -0x38(%ebp),%esi
    20a0:	eb 1c                	jmp    20be <createdelete+0xa3>
          printf(1, "create failed\n");
    20a2:	83 ec 08             	sub    $0x8,%esp
    20a5:	68 eb 52 00 00       	push   $0x52eb
    20aa:	6a 01                	push   $0x1
    20ac:	e8 1b 28 00 00       	call   48cc <printf>
          exit();
    20b1:	e8 dc 26 00 00       	call   4792 <exit>
      for(i = 0; i < N; i++){
    20b6:	83 c3 01             	add    $0x1,%ebx
    20b9:	83 fb 14             	cmp    $0x14,%ebx
    20bc:	74 63                	je     2121 <createdelete+0x106>
        name[1] = '0' + i;
    20be:	8d 43 30             	lea    0x30(%ebx),%eax
    20c1:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    20c4:	83 ec 08             	sub    $0x8,%esp
    20c7:	68 02 02 00 00       	push   $0x202
    20cc:	56                   	push   %esi
    20cd:	e8 00 27 00 00       	call   47d2 <open>
        if(fd < 0){
    20d2:	83 c4 10             	add    $0x10,%esp
    20d5:	85 c0                	test   %eax,%eax
    20d7:	78 c9                	js     20a2 <createdelete+0x87>
        close(fd);
    20d9:	83 ec 0c             	sub    $0xc,%esp
    20dc:	50                   	push   %eax
    20dd:	e8 d8 26 00 00       	call   47ba <close>
        if(i > 0 && (i % 2 ) == 0){
    20e2:	83 c4 10             	add    $0x10,%esp
    20e5:	85 db                	test   %ebx,%ebx
    20e7:	7e cd                	jle    20b6 <createdelete+0x9b>
    20e9:	f6 c3 01             	test   $0x1,%bl
    20ec:	75 c8                	jne    20b6 <createdelete+0x9b>
          name[1] = '0' + (i / 2);
    20ee:	89 d8                	mov    %ebx,%eax
    20f0:	c1 e8 1f             	shr    $0x1f,%eax
    20f3:	01 d8                	add    %ebx,%eax
    20f5:	d1 f8                	sar    %eax
    20f7:	83 c0 30             	add    $0x30,%eax
    20fa:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    20fd:	83 ec 0c             	sub    $0xc,%esp
    2100:	56                   	push   %esi
    2101:	e8 dc 26 00 00       	call   47e2 <unlink>
    2106:	83 c4 10             	add    $0x10,%esp
    2109:	85 c0                	test   %eax,%eax
    210b:	79 a9                	jns    20b6 <createdelete+0x9b>
            printf(1, "unlink failed\n");
    210d:	83 ec 08             	sub    $0x8,%esp
    2110:	68 9d 4c 00 00       	push   $0x4c9d
    2115:	6a 01                	push   $0x1
    2117:	e8 b0 27 00 00       	call   48cc <printf>
            exit();
    211c:	e8 71 26 00 00       	call   4792 <exit>
      exit();
    2121:	e8 6c 26 00 00       	call   4792 <exit>
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
    2126:	83 ec 04             	sub    $0x4,%esp
    2129:	8d 45 c8             	lea    -0x38(%ebp),%eax
    212c:	50                   	push   %eax
    212d:	68 5c 5d 00 00       	push   $0x5d5c
    2132:	6a 01                	push   $0x1
    2134:	e8 93 27 00 00       	call   48cc <printf>
        exit();
    2139:	e8 54 26 00 00       	call   4792 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    213e:	85 c0                	test   %eax,%eax
    2140:	79 55                	jns    2197 <createdelete+0x17c>
    2142:	83 c3 01             	add    $0x1,%ebx
    for(pi = 0; pi < 4; pi++){
    2145:	80 fb 74             	cmp    $0x74,%bl
    2148:	74 5b                	je     21a5 <createdelete+0x18a>
      name[0] = 'p' + pi;
    214a:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    214d:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    2151:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    2154:	83 ec 08             	sub    $0x8,%esp
    2157:	6a 00                	push   $0x0
    2159:	57                   	push   %edi
    215a:	e8 73 26 00 00       	call   47d2 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    215f:	83 c4 10             	add    $0x10,%esp
    2162:	85 f6                	test   %esi,%esi
    2164:	0f 94 c1             	sete   %cl
    2167:	83 fe 09             	cmp    $0x9,%esi
    216a:	0f 9f c2             	setg   %dl
    216d:	08 d1                	or     %dl,%cl
    216f:	74 04                	je     2175 <createdelete+0x15a>
    2171:	85 c0                	test   %eax,%eax
    2173:	78 b1                	js     2126 <createdelete+0x10b>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2175:	85 c0                	test   %eax,%eax
    2177:	78 c5                	js     213e <createdelete+0x123>
    2179:	83 7d c0 08          	cmpl   $0x8,-0x40(%ebp)
    217d:	77 bf                	ja     213e <createdelete+0x123>
        printf(1, "oops createdelete %s did exist\n", name);
    217f:	83 ec 04             	sub    $0x4,%esp
    2182:	8d 45 c8             	lea    -0x38(%ebp),%eax
    2185:	50                   	push   %eax
    2186:	68 80 5d 00 00       	push   $0x5d80
    218b:	6a 01                	push   $0x1
    218d:	e8 3a 27 00 00       	call   48cc <printf>
        exit();
    2192:	e8 fb 25 00 00       	call   4792 <exit>
        close(fd);
    2197:	83 ec 0c             	sub    $0xc,%esp
    219a:	50                   	push   %eax
    219b:	e8 1a 26 00 00       	call   47ba <close>
    21a0:	83 c4 10             	add    $0x10,%esp
    21a3:	eb 9d                	jmp    2142 <createdelete+0x127>
  for(i = 0; i < N; i++){
    21a5:	83 c6 01             	add    $0x1,%esi
    21a8:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
    21ac:	80 45 c7 01          	addb   $0x1,-0x39(%ebp)
    21b0:	83 fe 14             	cmp    $0x14,%esi
    21b3:	74 38                	je     21ed <createdelete+0x1d2>
  for(pi = 0; pi < 4; pi++){
    21b5:	bb 70 00 00 00       	mov    $0x70,%ebx
    21ba:	eb 8e                	jmp    214a <createdelete+0x12f>
    21bc:	83 c6 01             	add    $0x1,%esi
    21bf:	80 45 c7 01          	addb   $0x1,-0x39(%ebp)
    }
  }

  for(i = 0; i < N; i++){
    21c3:	89 f0                	mov    %esi,%eax
    21c5:	3c 84                	cmp    $0x84,%al
    21c7:	74 32                	je     21fb <createdelete+0x1e0>
  for(i = 0; i < N; i++){
    21c9:	bb 04 00 00 00       	mov    $0x4,%ebx
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    21ce:	89 f0                	mov    %esi,%eax
    21d0:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    21d3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    21d7:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    21da:	83 ec 0c             	sub    $0xc,%esp
    21dd:	57                   	push   %edi
    21de:	e8 ff 25 00 00       	call   47e2 <unlink>
    for(pi = 0; pi < 4; pi++){
    21e3:	83 c4 10             	add    $0x10,%esp
    21e6:	83 eb 01             	sub    $0x1,%ebx
    21e9:	75 e3                	jne    21ce <createdelete+0x1b3>
    21eb:	eb cf                	jmp    21bc <createdelete+0x1a1>
    21ed:	c6 45 c7 30          	movb   $0x30,-0x39(%ebp)
    21f1:	be 70 00 00 00       	mov    $0x70,%esi
      unlink(name);
    21f6:	8d 7d c8             	lea    -0x38(%ebp),%edi
    21f9:	eb ce                	jmp    21c9 <createdelete+0x1ae>
    }
  }

  printf(1, "createdelete ok\n");
    21fb:	83 ec 08             	sub    $0x8,%esp
    21fe:	68 af 50 00 00       	push   $0x50af
    2203:	6a 01                	push   $0x1
    2205:	e8 c2 26 00 00       	call   48cc <printf>
}
    220a:	83 c4 10             	add    $0x10,%esp
    220d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2210:	5b                   	pop    %ebx
    2211:	5e                   	pop    %esi
    2212:	5f                   	pop    %edi
    2213:	5d                   	pop    %ebp
    2214:	c3                   	ret    

00002215 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    2215:	55                   	push   %ebp
    2216:	89 e5                	mov    %esp,%ebp
    2218:	56                   	push   %esi
    2219:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    221a:	83 ec 08             	sub    $0x8,%esp
    221d:	68 c0 50 00 00       	push   $0x50c0
    2222:	6a 01                	push   $0x1
    2224:	e8 a3 26 00 00       	call   48cc <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    2229:	83 c4 08             	add    $0x8,%esp
    222c:	68 02 02 00 00       	push   $0x202
    2231:	68 d1 50 00 00       	push   $0x50d1
    2236:	e8 97 25 00 00       	call   47d2 <open>
  if(fd < 0){
    223b:	83 c4 10             	add    $0x10,%esp
    223e:	85 c0                	test   %eax,%eax
    2240:	0f 88 f0 00 00 00    	js     2336 <unlinkread+0x121>
    2246:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    2248:	83 ec 04             	sub    $0x4,%esp
    224b:	6a 05                	push   $0x5
    224d:	68 f6 50 00 00       	push   $0x50f6
    2252:	50                   	push   %eax
    2253:	e8 5a 25 00 00       	call   47b2 <write>
  close(fd);
    2258:	89 1c 24             	mov    %ebx,(%esp)
    225b:	e8 5a 25 00 00       	call   47ba <close>

  fd = open("unlinkread", O_RDWR);
    2260:	83 c4 08             	add    $0x8,%esp
    2263:	6a 02                	push   $0x2
    2265:	68 d1 50 00 00       	push   $0x50d1
    226a:	e8 63 25 00 00       	call   47d2 <open>
    226f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2271:	83 c4 10             	add    $0x10,%esp
    2274:	85 c0                	test   %eax,%eax
    2276:	0f 88 ce 00 00 00    	js     234a <unlinkread+0x135>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    227c:	83 ec 0c             	sub    $0xc,%esp
    227f:	68 d1 50 00 00       	push   $0x50d1
    2284:	e8 59 25 00 00       	call   47e2 <unlink>
    2289:	83 c4 10             	add    $0x10,%esp
    228c:	85 c0                	test   %eax,%eax
    228e:	0f 85 ca 00 00 00    	jne    235e <unlinkread+0x149>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    2294:	83 ec 08             	sub    $0x8,%esp
    2297:	68 02 02 00 00       	push   $0x202
    229c:	68 d1 50 00 00       	push   $0x50d1
    22a1:	e8 2c 25 00 00       	call   47d2 <open>
    22a6:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    22a8:	83 c4 0c             	add    $0xc,%esp
    22ab:	6a 03                	push   $0x3
    22ad:	68 2e 51 00 00       	push   $0x512e
    22b2:	50                   	push   %eax
    22b3:	e8 fa 24 00 00       	call   47b2 <write>
  close(fd1);
    22b8:	89 34 24             	mov    %esi,(%esp)
    22bb:	e8 fa 24 00 00       	call   47ba <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    22c0:	83 c4 0c             	add    $0xc,%esp
    22c3:	68 00 20 00 00       	push   $0x2000
    22c8:	68 00 94 00 00       	push   $0x9400
    22cd:	53                   	push   %ebx
    22ce:	e8 d7 24 00 00       	call   47aa <read>
    22d3:	83 c4 10             	add    $0x10,%esp
    22d6:	83 f8 05             	cmp    $0x5,%eax
    22d9:	0f 85 93 00 00 00    	jne    2372 <unlinkread+0x15d>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    22df:	80 3d 00 94 00 00 68 	cmpb   $0x68,0x9400
    22e6:	0f 85 9a 00 00 00    	jne    2386 <unlinkread+0x171>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    22ec:	83 ec 04             	sub    $0x4,%esp
    22ef:	6a 0a                	push   $0xa
    22f1:	68 00 94 00 00       	push   $0x9400
    22f6:	53                   	push   %ebx
    22f7:	e8 b6 24 00 00       	call   47b2 <write>
    22fc:	83 c4 10             	add    $0x10,%esp
    22ff:	83 f8 0a             	cmp    $0xa,%eax
    2302:	0f 85 92 00 00 00    	jne    239a <unlinkread+0x185>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    2308:	83 ec 0c             	sub    $0xc,%esp
    230b:	53                   	push   %ebx
    230c:	e8 a9 24 00 00       	call   47ba <close>
  unlink("unlinkread");
    2311:	c7 04 24 d1 50 00 00 	movl   $0x50d1,(%esp)
    2318:	e8 c5 24 00 00       	call   47e2 <unlink>
  printf(1, "unlinkread ok\n");
    231d:	83 c4 08             	add    $0x8,%esp
    2320:	68 79 51 00 00       	push   $0x5179
    2325:	6a 01                	push   $0x1
    2327:	e8 a0 25 00 00       	call   48cc <printf>
}
    232c:	83 c4 10             	add    $0x10,%esp
    232f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2332:	5b                   	pop    %ebx
    2333:	5e                   	pop    %esi
    2334:	5d                   	pop    %ebp
    2335:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    2336:	83 ec 08             	sub    $0x8,%esp
    2339:	68 dc 50 00 00       	push   $0x50dc
    233e:	6a 01                	push   $0x1
    2340:	e8 87 25 00 00       	call   48cc <printf>
    exit();
    2345:	e8 48 24 00 00       	call   4792 <exit>
    printf(1, "open unlinkread failed\n");
    234a:	83 ec 08             	sub    $0x8,%esp
    234d:	68 fc 50 00 00       	push   $0x50fc
    2352:	6a 01                	push   $0x1
    2354:	e8 73 25 00 00       	call   48cc <printf>
    exit();
    2359:	e8 34 24 00 00       	call   4792 <exit>
    printf(1, "unlink unlinkread failed\n");
    235e:	83 ec 08             	sub    $0x8,%esp
    2361:	68 14 51 00 00       	push   $0x5114
    2366:	6a 01                	push   $0x1
    2368:	e8 5f 25 00 00       	call   48cc <printf>
    exit();
    236d:	e8 20 24 00 00       	call   4792 <exit>
    printf(1, "unlinkread read failed");
    2372:	83 ec 08             	sub    $0x8,%esp
    2375:	68 32 51 00 00       	push   $0x5132
    237a:	6a 01                	push   $0x1
    237c:	e8 4b 25 00 00       	call   48cc <printf>
    exit();
    2381:	e8 0c 24 00 00       	call   4792 <exit>
    printf(1, "unlinkread wrong data\n");
    2386:	83 ec 08             	sub    $0x8,%esp
    2389:	68 49 51 00 00       	push   $0x5149
    238e:	6a 01                	push   $0x1
    2390:	e8 37 25 00 00       	call   48cc <printf>
    exit();
    2395:	e8 f8 23 00 00       	call   4792 <exit>
    printf(1, "unlinkread write failed\n");
    239a:	83 ec 08             	sub    $0x8,%esp
    239d:	68 60 51 00 00       	push   $0x5160
    23a2:	6a 01                	push   $0x1
    23a4:	e8 23 25 00 00       	call   48cc <printf>
    exit();
    23a9:	e8 e4 23 00 00       	call   4792 <exit>

000023ae <linktest>:

void
linktest(void)
{
    23ae:	55                   	push   %ebp
    23af:	89 e5                	mov    %esp,%ebp
    23b1:	53                   	push   %ebx
    23b2:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    23b5:	68 88 51 00 00       	push   $0x5188
    23ba:	6a 01                	push   $0x1
    23bc:	e8 0b 25 00 00       	call   48cc <printf>

  unlink("lf1");
    23c1:	c7 04 24 92 51 00 00 	movl   $0x5192,(%esp)
    23c8:	e8 15 24 00 00       	call   47e2 <unlink>
  unlink("lf2");
    23cd:	c7 04 24 96 51 00 00 	movl   $0x5196,(%esp)
    23d4:	e8 09 24 00 00       	call   47e2 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    23d9:	83 c4 08             	add    $0x8,%esp
    23dc:	68 02 02 00 00       	push   $0x202
    23e1:	68 92 51 00 00       	push   $0x5192
    23e6:	e8 e7 23 00 00       	call   47d2 <open>
  if(fd < 0){
    23eb:	83 c4 10             	add    $0x10,%esp
    23ee:	85 c0                	test   %eax,%eax
    23f0:	0f 88 2a 01 00 00    	js     2520 <linktest+0x172>
    23f6:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    23f8:	83 ec 04             	sub    $0x4,%esp
    23fb:	6a 05                	push   $0x5
    23fd:	68 f6 50 00 00       	push   $0x50f6
    2402:	50                   	push   %eax
    2403:	e8 aa 23 00 00       	call   47b2 <write>
    2408:	83 c4 10             	add    $0x10,%esp
    240b:	83 f8 05             	cmp    $0x5,%eax
    240e:	0f 85 20 01 00 00    	jne    2534 <linktest+0x186>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    2414:	83 ec 0c             	sub    $0xc,%esp
    2417:	53                   	push   %ebx
    2418:	e8 9d 23 00 00       	call   47ba <close>

  if(link("lf1", "lf2") < 0){
    241d:	83 c4 08             	add    $0x8,%esp
    2420:	68 96 51 00 00       	push   $0x5196
    2425:	68 92 51 00 00       	push   $0x5192
    242a:	e8 c3 23 00 00       	call   47f2 <link>
    242f:	83 c4 10             	add    $0x10,%esp
    2432:	85 c0                	test   %eax,%eax
    2434:	0f 88 0e 01 00 00    	js     2548 <linktest+0x19a>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    243a:	83 ec 0c             	sub    $0xc,%esp
    243d:	68 92 51 00 00       	push   $0x5192
    2442:	e8 9b 23 00 00       	call   47e2 <unlink>

  if(open("lf1", 0) >= 0){
    2447:	83 c4 08             	add    $0x8,%esp
    244a:	6a 00                	push   $0x0
    244c:	68 92 51 00 00       	push   $0x5192
    2451:	e8 7c 23 00 00       	call   47d2 <open>
    2456:	83 c4 10             	add    $0x10,%esp
    2459:	85 c0                	test   %eax,%eax
    245b:	0f 89 fb 00 00 00    	jns    255c <linktest+0x1ae>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    2461:	83 ec 08             	sub    $0x8,%esp
    2464:	6a 00                	push   $0x0
    2466:	68 96 51 00 00       	push   $0x5196
    246b:	e8 62 23 00 00       	call   47d2 <open>
    2470:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2472:	83 c4 10             	add    $0x10,%esp
    2475:	85 c0                	test   %eax,%eax
    2477:	0f 88 f3 00 00 00    	js     2570 <linktest+0x1c2>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    247d:	83 ec 04             	sub    $0x4,%esp
    2480:	68 00 20 00 00       	push   $0x2000
    2485:	68 00 94 00 00       	push   $0x9400
    248a:	50                   	push   %eax
    248b:	e8 1a 23 00 00       	call   47aa <read>
    2490:	83 c4 10             	add    $0x10,%esp
    2493:	83 f8 05             	cmp    $0x5,%eax
    2496:	0f 85 e8 00 00 00    	jne    2584 <linktest+0x1d6>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    249c:	83 ec 0c             	sub    $0xc,%esp
    249f:	53                   	push   %ebx
    24a0:	e8 15 23 00 00       	call   47ba <close>

  if(link("lf2", "lf2") >= 0){
    24a5:	83 c4 08             	add    $0x8,%esp
    24a8:	68 96 51 00 00       	push   $0x5196
    24ad:	68 96 51 00 00       	push   $0x5196
    24b2:	e8 3b 23 00 00       	call   47f2 <link>
    24b7:	83 c4 10             	add    $0x10,%esp
    24ba:	85 c0                	test   %eax,%eax
    24bc:	0f 89 d6 00 00 00    	jns    2598 <linktest+0x1ea>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    24c2:	83 ec 0c             	sub    $0xc,%esp
    24c5:	68 96 51 00 00       	push   $0x5196
    24ca:	e8 13 23 00 00       	call   47e2 <unlink>
  if(link("lf2", "lf1") >= 0){
    24cf:	83 c4 08             	add    $0x8,%esp
    24d2:	68 92 51 00 00       	push   $0x5192
    24d7:	68 96 51 00 00       	push   $0x5196
    24dc:	e8 11 23 00 00       	call   47f2 <link>
    24e1:	83 c4 10             	add    $0x10,%esp
    24e4:	85 c0                	test   %eax,%eax
    24e6:	0f 89 c0 00 00 00    	jns    25ac <linktest+0x1fe>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    24ec:	83 ec 08             	sub    $0x8,%esp
    24ef:	68 92 51 00 00       	push   $0x5192
    24f4:	68 5a 54 00 00       	push   $0x545a
    24f9:	e8 f4 22 00 00       	call   47f2 <link>
    24fe:	83 c4 10             	add    $0x10,%esp
    2501:	85 c0                	test   %eax,%eax
    2503:	0f 89 b7 00 00 00    	jns    25c0 <linktest+0x212>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    2509:	83 ec 08             	sub    $0x8,%esp
    250c:	68 30 52 00 00       	push   $0x5230
    2511:	6a 01                	push   $0x1
    2513:	e8 b4 23 00 00       	call   48cc <printf>
}
    2518:	83 c4 10             	add    $0x10,%esp
    251b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    251e:	c9                   	leave  
    251f:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    2520:	83 ec 08             	sub    $0x8,%esp
    2523:	68 9a 51 00 00       	push   $0x519a
    2528:	6a 01                	push   $0x1
    252a:	e8 9d 23 00 00       	call   48cc <printf>
    exit();
    252f:	e8 5e 22 00 00       	call   4792 <exit>
    printf(1, "write lf1 failed\n");
    2534:	83 ec 08             	sub    $0x8,%esp
    2537:	68 ad 51 00 00       	push   $0x51ad
    253c:	6a 01                	push   $0x1
    253e:	e8 89 23 00 00       	call   48cc <printf>
    exit();
    2543:	e8 4a 22 00 00       	call   4792 <exit>
    printf(1, "link lf1 lf2 failed\n");
    2548:	83 ec 08             	sub    $0x8,%esp
    254b:	68 bf 51 00 00       	push   $0x51bf
    2550:	6a 01                	push   $0x1
    2552:	e8 75 23 00 00       	call   48cc <printf>
    exit();
    2557:	e8 36 22 00 00       	call   4792 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    255c:	83 ec 08             	sub    $0x8,%esp
    255f:	68 a0 5d 00 00       	push   $0x5da0
    2564:	6a 01                	push   $0x1
    2566:	e8 61 23 00 00       	call   48cc <printf>
    exit();
    256b:	e8 22 22 00 00       	call   4792 <exit>
    printf(1, "open lf2 failed\n");
    2570:	83 ec 08             	sub    $0x8,%esp
    2573:	68 d4 51 00 00       	push   $0x51d4
    2578:	6a 01                	push   $0x1
    257a:	e8 4d 23 00 00       	call   48cc <printf>
    exit();
    257f:	e8 0e 22 00 00       	call   4792 <exit>
    printf(1, "read lf2 failed\n");
    2584:	83 ec 08             	sub    $0x8,%esp
    2587:	68 e5 51 00 00       	push   $0x51e5
    258c:	6a 01                	push   $0x1
    258e:	e8 39 23 00 00       	call   48cc <printf>
    exit();
    2593:	e8 fa 21 00 00       	call   4792 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    2598:	83 ec 08             	sub    $0x8,%esp
    259b:	68 f6 51 00 00       	push   $0x51f6
    25a0:	6a 01                	push   $0x1
    25a2:	e8 25 23 00 00       	call   48cc <printf>
    exit();
    25a7:	e8 e6 21 00 00       	call   4792 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    25ac:	83 ec 08             	sub    $0x8,%esp
    25af:	68 c8 5d 00 00       	push   $0x5dc8
    25b4:	6a 01                	push   $0x1
    25b6:	e8 11 23 00 00       	call   48cc <printf>
    exit();
    25bb:	e8 d2 21 00 00       	call   4792 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    25c0:	83 ec 08             	sub    $0x8,%esp
    25c3:	68 14 52 00 00       	push   $0x5214
    25c8:	6a 01                	push   $0x1
    25ca:	e8 fd 22 00 00       	call   48cc <printf>
    exit();
    25cf:	e8 be 21 00 00       	call   4792 <exit>

000025d4 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    25d4:	55                   	push   %ebp
    25d5:	89 e5                	mov    %esp,%ebp
    25d7:	57                   	push   %edi
    25d8:	56                   	push   %esi
    25d9:	53                   	push   %ebx
    25da:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    25dd:	68 3d 52 00 00       	push   $0x523d
    25e2:	6a 01                	push   $0x1
    25e4:	e8 e3 22 00 00       	call   48cc <printf>
  file[0] = 'C';
    25e9:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    25ed:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    25f1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    25f4:	bb 00 00 00 00       	mov    $0x0,%ebx
    file[1] = '0' + i;
    unlink(file);
    25f9:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    pid = fork();
    if(pid && (i % 3) == 1){
    25fc:	bf 56 55 55 55       	mov    $0x55555556,%edi
    2601:	e9 75 02 00 00       	jmp    287b <concreate+0x2a7>
      link("C0", file);
    2606:	83 ec 08             	sub    $0x8,%esp
    2609:	56                   	push   %esi
    260a:	68 4d 52 00 00       	push   $0x524d
    260f:	e8 de 21 00 00       	call   47f2 <link>
    2614:	83 c4 10             	add    $0x10,%esp
    2617:	e9 4e 02 00 00       	jmp    286a <concreate+0x296>
    } else if(pid == 0 && (i % 5) == 1){
    261c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    2621:	89 d8                	mov    %ebx,%eax
    2623:	f7 ea                	imul   %edx
    2625:	d1 fa                	sar    %edx
    2627:	89 d8                	mov    %ebx,%eax
    2629:	c1 f8 1f             	sar    $0x1f,%eax
    262c:	29 c2                	sub    %eax,%edx
    262e:	8d 04 92             	lea    (%edx,%edx,4),%eax
    2631:	29 c3                	sub    %eax,%ebx
    2633:	83 fb 01             	cmp    $0x1,%ebx
    2636:	74 34                	je     266c <concreate+0x98>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    2638:	83 ec 08             	sub    $0x8,%esp
    263b:	68 02 02 00 00       	push   $0x202
    2640:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2643:	50                   	push   %eax
    2644:	e8 89 21 00 00       	call   47d2 <open>
      if(fd < 0){
    2649:	83 c4 10             	add    $0x10,%esp
    264c:	85 c0                	test   %eax,%eax
    264e:	0f 89 f9 01 00 00    	jns    284d <concreate+0x279>
        printf(1, "concreate create %s failed\n", file);
    2654:	83 ec 04             	sub    $0x4,%esp
    2657:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    265a:	50                   	push   %eax
    265b:	68 50 52 00 00       	push   $0x5250
    2660:	6a 01                	push   $0x1
    2662:	e8 65 22 00 00       	call   48cc <printf>
        exit();
    2667:	e8 26 21 00 00       	call   4792 <exit>
      link("C0", file);
    266c:	83 ec 08             	sub    $0x8,%esp
    266f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2672:	50                   	push   %eax
    2673:	68 4d 52 00 00       	push   $0x524d
    2678:	e8 75 21 00 00       	call   47f2 <link>
    267d:	83 c4 10             	add    $0x10,%esp
      }
      close(fd);
    }
    if(pid == 0)
      exit();
    2680:	e8 0d 21 00 00       	call   4792 <exit>
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    2685:	83 ec 04             	sub    $0x4,%esp
    2688:	6a 28                	push   $0x28
    268a:	6a 00                	push   $0x0
    268c:	8d 45 bd             	lea    -0x43(%ebp),%eax
    268f:	50                   	push   %eax
    2690:	e8 b0 1f 00 00       	call   4645 <memset>
  fd = open(".", 0);
    2695:	83 c4 08             	add    $0x8,%esp
    2698:	6a 00                	push   $0x0
    269a:	68 5a 54 00 00       	push   $0x545a
    269f:	e8 2e 21 00 00       	call   47d2 <open>
    26a4:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    26a6:	83 c4 10             	add    $0x10,%esp
  n = 0;
    26a9:	bf 00 00 00 00       	mov    $0x0,%edi
  while(read(fd, &de, sizeof(de)) > 0){
    26ae:	8d 75 ac             	lea    -0x54(%ebp),%esi
    26b1:	83 ec 04             	sub    $0x4,%esp
    26b4:	6a 10                	push   $0x10
    26b6:	56                   	push   %esi
    26b7:	53                   	push   %ebx
    26b8:	e8 ed 20 00 00       	call   47aa <read>
    26bd:	83 c4 10             	add    $0x10,%esp
    26c0:	85 c0                	test   %eax,%eax
    26c2:	7e 60                	jle    2724 <concreate+0x150>
    if(de.inum == 0)
    26c4:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    26c9:	74 e6                	je     26b1 <concreate+0xdd>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    26cb:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    26cf:	75 e0                	jne    26b1 <concreate+0xdd>
    26d1:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    26d5:	75 da                	jne    26b1 <concreate+0xdd>
      i = de.name[1] - '0';
    26d7:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    26db:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    26de:	83 f8 27             	cmp    $0x27,%eax
    26e1:	77 11                	ja     26f4 <concreate+0x120>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    26e3:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    26e8:	75 22                	jne    270c <concreate+0x138>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    26ea:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    26ef:	83 c7 01             	add    $0x1,%edi
    26f2:	eb bd                	jmp    26b1 <concreate+0xdd>
        printf(1, "concreate weird file %s\n", de.name);
    26f4:	83 ec 04             	sub    $0x4,%esp
    26f7:	8d 45 ae             	lea    -0x52(%ebp),%eax
    26fa:	50                   	push   %eax
    26fb:	68 6c 52 00 00       	push   $0x526c
    2700:	6a 01                	push   $0x1
    2702:	e8 c5 21 00 00       	call   48cc <printf>
        exit();
    2707:	e8 86 20 00 00       	call   4792 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    270c:	83 ec 04             	sub    $0x4,%esp
    270f:	8d 45 ae             	lea    -0x52(%ebp),%eax
    2712:	50                   	push   %eax
    2713:	68 85 52 00 00       	push   $0x5285
    2718:	6a 01                	push   $0x1
    271a:	e8 ad 21 00 00       	call   48cc <printf>
        exit();
    271f:	e8 6e 20 00 00       	call   4792 <exit>
    }
  }
  close(fd);
    2724:	83 ec 0c             	sub    $0xc,%esp
    2727:	53                   	push   %ebx
    2728:	e8 8d 20 00 00       	call   47ba <close>

  if(n != 40){
    272d:	83 c4 10             	add    $0x10,%esp
    2730:	83 ff 28             	cmp    $0x28,%edi
    2733:	75 0d                	jne    2742 <concreate+0x16e>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    2735:	bb 00 00 00 00       	mov    $0x0,%ebx
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    273a:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    273d:	e9 88 00 00 00       	jmp    27ca <concreate+0x1f6>
    printf(1, "concreate not enough files in directory listing\n");
    2742:	83 ec 08             	sub    $0x8,%esp
    2745:	68 ec 5d 00 00       	push   $0x5dec
    274a:	6a 01                	push   $0x1
    274c:	e8 7b 21 00 00       	call   48cc <printf>
    exit();
    2751:	e8 3c 20 00 00       	call   4792 <exit>
      printf(1, "fork failed\n");
    2756:	83 ec 08             	sub    $0x8,%esp
    2759:	68 25 5b 00 00       	push   $0x5b25
    275e:	6a 01                	push   $0x1
    2760:	e8 67 21 00 00       	call   48cc <printf>
      exit();
    2765:	e8 28 20 00 00       	call   4792 <exit>
      close(open(file, 0));
    276a:	83 ec 08             	sub    $0x8,%esp
    276d:	6a 00                	push   $0x0
    276f:	57                   	push   %edi
    2770:	e8 5d 20 00 00       	call   47d2 <open>
    2775:	89 04 24             	mov    %eax,(%esp)
    2778:	e8 3d 20 00 00       	call   47ba <close>
      close(open(file, 0));
    277d:	83 c4 08             	add    $0x8,%esp
    2780:	6a 00                	push   $0x0
    2782:	57                   	push   %edi
    2783:	e8 4a 20 00 00       	call   47d2 <open>
    2788:	89 04 24             	mov    %eax,(%esp)
    278b:	e8 2a 20 00 00       	call   47ba <close>
      close(open(file, 0));
    2790:	83 c4 08             	add    $0x8,%esp
    2793:	6a 00                	push   $0x0
    2795:	57                   	push   %edi
    2796:	e8 37 20 00 00       	call   47d2 <open>
    279b:	89 04 24             	mov    %eax,(%esp)
    279e:	e8 17 20 00 00       	call   47ba <close>
      close(open(file, 0));
    27a3:	83 c4 08             	add    $0x8,%esp
    27a6:	6a 00                	push   $0x0
    27a8:	57                   	push   %edi
    27a9:	e8 24 20 00 00       	call   47d2 <open>
    27ae:	89 04 24             	mov    %eax,(%esp)
    27b1:	e8 04 20 00 00       	call   47ba <close>
    27b6:	83 c4 10             	add    $0x10,%esp
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    27b9:	85 f6                	test   %esi,%esi
    27bb:	74 74                	je     2831 <concreate+0x25d>
      exit();
    else
      wait();
    27bd:	e8 d8 1f 00 00       	call   479a <wait>
  for(i = 0; i < 40; i++){
    27c2:	83 c3 01             	add    $0x1,%ebx
    27c5:	83 fb 28             	cmp    $0x28,%ebx
    27c8:	74 6c                	je     2836 <concreate+0x262>
    file[1] = '0' + i;
    27ca:	8d 43 30             	lea    0x30(%ebx),%eax
    27cd:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    27d0:	e8 b5 1f 00 00       	call   478a <fork>
    27d5:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    27d7:	85 c0                	test   %eax,%eax
    27d9:	0f 88 77 ff ff ff    	js     2756 <concreate+0x182>
    if(((i % 3) == 0 && pid == 0) ||
    27df:	b8 56 55 55 55       	mov    $0x55555556,%eax
    27e4:	f7 eb                	imul   %ebx
    27e6:	89 d8                	mov    %ebx,%eax
    27e8:	c1 f8 1f             	sar    $0x1f,%eax
    27eb:	29 c2                	sub    %eax,%edx
    27ed:	8d 04 52             	lea    (%edx,%edx,2),%eax
    27f0:	89 da                	mov    %ebx,%edx
    27f2:	29 c2                	sub    %eax,%edx
    27f4:	89 d0                	mov    %edx,%eax
    27f6:	09 f0                	or     %esi,%eax
    27f8:	0f 84 6c ff ff ff    	je     276a <concreate+0x196>
       ((i % 3) == 1 && pid != 0)){
    27fe:	85 f6                	test   %esi,%esi
    2800:	74 09                	je     280b <concreate+0x237>
    2802:	83 fa 01             	cmp    $0x1,%edx
    2805:	0f 84 5f ff ff ff    	je     276a <concreate+0x196>
      unlink(file);
    280b:	83 ec 0c             	sub    $0xc,%esp
    280e:	57                   	push   %edi
    280f:	e8 ce 1f 00 00       	call   47e2 <unlink>
      unlink(file);
    2814:	89 3c 24             	mov    %edi,(%esp)
    2817:	e8 c6 1f 00 00       	call   47e2 <unlink>
      unlink(file);
    281c:	89 3c 24             	mov    %edi,(%esp)
    281f:	e8 be 1f 00 00       	call   47e2 <unlink>
      unlink(file);
    2824:	89 3c 24             	mov    %edi,(%esp)
    2827:	e8 b6 1f 00 00       	call   47e2 <unlink>
    282c:	83 c4 10             	add    $0x10,%esp
    282f:	eb 88                	jmp    27b9 <concreate+0x1e5>
      exit();
    2831:	e8 5c 1f 00 00       	call   4792 <exit>
  }

  printf(1, "concreate ok\n");
    2836:	83 ec 08             	sub    $0x8,%esp
    2839:	68 a2 52 00 00       	push   $0x52a2
    283e:	6a 01                	push   $0x1
    2840:	e8 87 20 00 00       	call   48cc <printf>
}
    2845:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2848:	5b                   	pop    %ebx
    2849:	5e                   	pop    %esi
    284a:	5f                   	pop    %edi
    284b:	5d                   	pop    %ebp
    284c:	c3                   	ret    
      close(fd);
    284d:	83 ec 0c             	sub    $0xc,%esp
    2850:	50                   	push   %eax
    2851:	e8 64 1f 00 00       	call   47ba <close>
    2856:	83 c4 10             	add    $0x10,%esp
    2859:	e9 22 fe ff ff       	jmp    2680 <concreate+0xac>
    285e:	83 ec 0c             	sub    $0xc,%esp
    2861:	50                   	push   %eax
    2862:	e8 53 1f 00 00       	call   47ba <close>
    2867:	83 c4 10             	add    $0x10,%esp
      wait();
    286a:	e8 2b 1f 00 00       	call   479a <wait>
  for(i = 0; i < 40; i++){
    286f:	83 c3 01             	add    $0x1,%ebx
    2872:	83 fb 28             	cmp    $0x28,%ebx
    2875:	0f 84 0a fe ff ff    	je     2685 <concreate+0xb1>
    file[1] = '0' + i;
    287b:	8d 43 30             	lea    0x30(%ebx),%eax
    287e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    2881:	83 ec 0c             	sub    $0xc,%esp
    2884:	56                   	push   %esi
    2885:	e8 58 1f 00 00       	call   47e2 <unlink>
    pid = fork();
    288a:	e8 fb 1e 00 00       	call   478a <fork>
    if(pid && (i % 3) == 1){
    288f:	83 c4 10             	add    $0x10,%esp
    2892:	85 c0                	test   %eax,%eax
    2894:	0f 84 82 fd ff ff    	je     261c <concreate+0x48>
    289a:	89 d8                	mov    %ebx,%eax
    289c:	f7 ef                	imul   %edi
    289e:	89 d8                	mov    %ebx,%eax
    28a0:	c1 f8 1f             	sar    $0x1f,%eax
    28a3:	29 c2                	sub    %eax,%edx
    28a5:	8d 04 52             	lea    (%edx,%edx,2),%eax
    28a8:	89 d9                	mov    %ebx,%ecx
    28aa:	29 c1                	sub    %eax,%ecx
    28ac:	83 f9 01             	cmp    $0x1,%ecx
    28af:	0f 84 51 fd ff ff    	je     2606 <concreate+0x32>
      fd = open(file, O_CREATE | O_RDWR);
    28b5:	83 ec 08             	sub    $0x8,%esp
    28b8:	68 02 02 00 00       	push   $0x202
    28bd:	56                   	push   %esi
    28be:	e8 0f 1f 00 00       	call   47d2 <open>
      if(fd < 0){
    28c3:	83 c4 10             	add    $0x10,%esp
    28c6:	85 c0                	test   %eax,%eax
    28c8:	79 94                	jns    285e <concreate+0x28a>
    28ca:	e9 85 fd ff ff       	jmp    2654 <concreate+0x80>

000028cf <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    28cf:	55                   	push   %ebp
    28d0:	89 e5                	mov    %esp,%ebp
    28d2:	57                   	push   %edi
    28d3:	56                   	push   %esi
    28d4:	53                   	push   %ebx
    28d5:	83 ec 24             	sub    $0x24,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    28d8:	68 b0 52 00 00       	push   $0x52b0
    28dd:	6a 01                	push   $0x1
    28df:	e8 e8 1f 00 00       	call   48cc <printf>

  unlink("x");
    28e4:	c7 04 24 3d 55 00 00 	movl   $0x553d,(%esp)
    28eb:	e8 f2 1e 00 00       	call   47e2 <unlink>
  pid = fork();
    28f0:	e8 95 1e 00 00       	call   478a <fork>
    28f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    28f8:	83 c4 10             	add    $0x10,%esp
    28fb:	85 c0                	test   %eax,%eax
    28fd:	78 18                	js     2917 <linkunlink+0x48>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    28ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    2903:	19 db                	sbb    %ebx,%ebx
    2905:	83 e3 60             	and    $0x60,%ebx
    2908:	83 c3 01             	add    $0x1,%ebx
    290b:	be 64 00 00 00       	mov    $0x64,%esi
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    2910:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
    2915:	eb 36                	jmp    294d <linkunlink+0x7e>
    printf(1, "fork failed\n");
    2917:	83 ec 08             	sub    $0x8,%esp
    291a:	68 25 5b 00 00       	push   $0x5b25
    291f:	6a 01                	push   $0x1
    2921:	e8 a6 1f 00 00       	call   48cc <printf>
    exit();
    2926:	e8 67 1e 00 00       	call   4792 <exit>
      close(open("x", O_RDWR | O_CREATE));
    292b:	83 ec 08             	sub    $0x8,%esp
    292e:	68 02 02 00 00       	push   $0x202
    2933:	68 3d 55 00 00       	push   $0x553d
    2938:	e8 95 1e 00 00       	call   47d2 <open>
    293d:	89 04 24             	mov    %eax,(%esp)
    2940:	e8 75 1e 00 00       	call   47ba <close>
    2945:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    2948:	83 ee 01             	sub    $0x1,%esi
    294b:	74 49                	je     2996 <linkunlink+0xc7>
    x = x * 1103515245 + 12345;
    294d:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    2953:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    2959:	89 d8                	mov    %ebx,%eax
    295b:	f7 e7                	mul    %edi
    295d:	d1 ea                	shr    %edx
    295f:	8d 04 52             	lea    (%edx,%edx,2),%eax
    2962:	89 da                	mov    %ebx,%edx
    2964:	29 c2                	sub    %eax,%edx
    2966:	74 c3                	je     292b <linkunlink+0x5c>
    } else if((x % 3) == 1){
    2968:	83 fa 01             	cmp    $0x1,%edx
    296b:	74 12                	je     297f <linkunlink+0xb0>
      link("cat", "x");
    } else {
      unlink("x");
    296d:	83 ec 0c             	sub    $0xc,%esp
    2970:	68 3d 55 00 00       	push   $0x553d
    2975:	e8 68 1e 00 00       	call   47e2 <unlink>
    297a:	83 c4 10             	add    $0x10,%esp
    297d:	eb c9                	jmp    2948 <linkunlink+0x79>
      link("cat", "x");
    297f:	83 ec 08             	sub    $0x8,%esp
    2982:	68 3d 55 00 00       	push   $0x553d
    2987:	68 c1 52 00 00       	push   $0x52c1
    298c:	e8 61 1e 00 00       	call   47f2 <link>
    2991:	83 c4 10             	add    $0x10,%esp
    2994:	eb b2                	jmp    2948 <linkunlink+0x79>
    }
  }

  if(pid)
    2996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    299a:	74 1c                	je     29b8 <linkunlink+0xe9>
    wait();
    299c:	e8 f9 1d 00 00       	call   479a <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    29a1:	83 ec 08             	sub    $0x8,%esp
    29a4:	68 c5 52 00 00       	push   $0x52c5
    29a9:	6a 01                	push   $0x1
    29ab:	e8 1c 1f 00 00       	call   48cc <printf>
}
    29b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    29b3:	5b                   	pop    %ebx
    29b4:	5e                   	pop    %esi
    29b5:	5f                   	pop    %edi
    29b6:	5d                   	pop    %ebp
    29b7:	c3                   	ret    
    exit();
    29b8:	e8 d5 1d 00 00       	call   4792 <exit>

000029bd <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    29bd:	55                   	push   %ebp
    29be:	89 e5                	mov    %esp,%ebp
    29c0:	57                   	push   %edi
    29c1:	56                   	push   %esi
    29c2:	53                   	push   %ebx
    29c3:	83 ec 24             	sub    $0x24,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    29c6:	68 d4 52 00 00       	push   $0x52d4
    29cb:	6a 01                	push   $0x1
    29cd:	e8 fa 1e 00 00       	call   48cc <printf>
  unlink("bd");
    29d2:	c7 04 24 e1 52 00 00 	movl   $0x52e1,(%esp)
    29d9:	e8 04 1e 00 00       	call   47e2 <unlink>

  fd = open("bd", O_CREATE);
    29de:	83 c4 08             	add    $0x8,%esp
    29e1:	68 00 02 00 00       	push   $0x200
    29e6:	68 e1 52 00 00       	push   $0x52e1
    29eb:	e8 e2 1d 00 00       	call   47d2 <open>
  if(fd < 0){
    29f0:	83 c4 10             	add    $0x10,%esp
    29f3:	85 c0                	test   %eax,%eax
    29f5:	0f 88 e0 00 00 00    	js     2adb <bigdir+0x11e>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    29fb:	83 ec 0c             	sub    $0xc,%esp
    29fe:	50                   	push   %eax
    29ff:	e8 b6 1d 00 00       	call   47ba <close>
    2a04:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    2a07:	be 00 00 00 00       	mov    $0x0,%esi
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    2a0c:	8d 7d de             	lea    -0x22(%ebp),%edi
    name[0] = 'x';
    2a0f:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    2a13:	8d 46 3f             	lea    0x3f(%esi),%eax
    2a16:	85 f6                	test   %esi,%esi
    2a18:	0f 49 c6             	cmovns %esi,%eax
    2a1b:	c1 f8 06             	sar    $0x6,%eax
    2a1e:	83 c0 30             	add    $0x30,%eax
    2a21:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    2a24:	89 f2                	mov    %esi,%edx
    2a26:	c1 fa 1f             	sar    $0x1f,%edx
    2a29:	c1 ea 1a             	shr    $0x1a,%edx
    2a2c:	8d 04 16             	lea    (%esi,%edx,1),%eax
    2a2f:	83 e0 3f             	and    $0x3f,%eax
    2a32:	29 d0                	sub    %edx,%eax
    2a34:	83 c0 30             	add    $0x30,%eax
    2a37:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    2a3a:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(link("bd", name) != 0){
    2a3e:	83 ec 08             	sub    $0x8,%esp
    2a41:	57                   	push   %edi
    2a42:	68 e1 52 00 00       	push   $0x52e1
    2a47:	e8 a6 1d 00 00       	call   47f2 <link>
    2a4c:	89 c3                	mov    %eax,%ebx
    2a4e:	83 c4 10             	add    $0x10,%esp
    2a51:	85 c0                	test   %eax,%eax
    2a53:	0f 85 96 00 00 00    	jne    2aef <bigdir+0x132>
  for(i = 0; i < 500; i++){
    2a59:	83 c6 01             	add    $0x1,%esi
    2a5c:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    2a62:	75 ab                	jne    2a0f <bigdir+0x52>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    2a64:	83 ec 0c             	sub    $0xc,%esp
    2a67:	68 e1 52 00 00       	push   $0x52e1
    2a6c:	e8 71 1d 00 00       	call   47e2 <unlink>
    2a71:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
    2a74:	8d 75 de             	lea    -0x22(%ebp),%esi
    name[0] = 'x';
    2a77:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    2a7b:	8d 43 3f             	lea    0x3f(%ebx),%eax
    2a7e:	85 db                	test   %ebx,%ebx
    2a80:	0f 49 c3             	cmovns %ebx,%eax
    2a83:	c1 f8 06             	sar    $0x6,%eax
    2a86:	83 c0 30             	add    $0x30,%eax
    2a89:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    2a8c:	89 da                	mov    %ebx,%edx
    2a8e:	c1 fa 1f             	sar    $0x1f,%edx
    2a91:	c1 ea 1a             	shr    $0x1a,%edx
    2a94:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    2a97:	83 e0 3f             	and    $0x3f,%eax
    2a9a:	29 d0                	sub    %edx,%eax
    2a9c:	83 c0 30             	add    $0x30,%eax
    2a9f:	88 45 e0             	mov    %al,-0x20(%ebp)
    name[3] = '\0';
    2aa2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    if(unlink(name) != 0){
    2aa6:	83 ec 0c             	sub    $0xc,%esp
    2aa9:	56                   	push   %esi
    2aaa:	e8 33 1d 00 00       	call   47e2 <unlink>
    2aaf:	83 c4 10             	add    $0x10,%esp
    2ab2:	85 c0                	test   %eax,%eax
    2ab4:	75 4d                	jne    2b03 <bigdir+0x146>
  for(i = 0; i < 500; i++){
    2ab6:	83 c3 01             	add    $0x1,%ebx
    2ab9:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    2abf:	75 b6                	jne    2a77 <bigdir+0xba>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    2ac1:	83 ec 08             	sub    $0x8,%esp
    2ac4:	68 23 53 00 00       	push   $0x5323
    2ac9:	6a 01                	push   $0x1
    2acb:	e8 fc 1d 00 00       	call   48cc <printf>
}
    2ad0:	83 c4 10             	add    $0x10,%esp
    2ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2ad6:	5b                   	pop    %ebx
    2ad7:	5e                   	pop    %esi
    2ad8:	5f                   	pop    %edi
    2ad9:	5d                   	pop    %ebp
    2ada:	c3                   	ret    
    printf(1, "bigdir create failed\n");
    2adb:	83 ec 08             	sub    $0x8,%esp
    2ade:	68 e4 52 00 00       	push   $0x52e4
    2ae3:	6a 01                	push   $0x1
    2ae5:	e8 e2 1d 00 00       	call   48cc <printf>
    exit();
    2aea:	e8 a3 1c 00 00       	call   4792 <exit>
      printf(1, "bigdir link failed\n");
    2aef:	83 ec 08             	sub    $0x8,%esp
    2af2:	68 fa 52 00 00       	push   $0x52fa
    2af7:	6a 01                	push   $0x1
    2af9:	e8 ce 1d 00 00       	call   48cc <printf>
      exit();
    2afe:	e8 8f 1c 00 00       	call   4792 <exit>
      printf(1, "bigdir unlink failed");
    2b03:	83 ec 08             	sub    $0x8,%esp
    2b06:	68 0e 53 00 00       	push   $0x530e
    2b0b:	6a 01                	push   $0x1
    2b0d:	e8 ba 1d 00 00       	call   48cc <printf>
      exit();
    2b12:	e8 7b 1c 00 00       	call   4792 <exit>

00002b17 <subdir>:

void
subdir(void)
{
    2b17:	55                   	push   %ebp
    2b18:	89 e5                	mov    %esp,%ebp
    2b1a:	53                   	push   %ebx
    2b1b:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    2b1e:	68 2e 53 00 00       	push   $0x532e
    2b23:	6a 01                	push   $0x1
    2b25:	e8 a2 1d 00 00       	call   48cc <printf>

  unlink("ff");
    2b2a:	c7 04 24 b7 53 00 00 	movl   $0x53b7,(%esp)
    2b31:	e8 ac 1c 00 00       	call   47e2 <unlink>
  if(mkdir("dd") != 0){
    2b36:	c7 04 24 54 54 00 00 	movl   $0x5454,(%esp)
    2b3d:	e8 b8 1c 00 00       	call   47fa <mkdir>
    2b42:	83 c4 10             	add    $0x10,%esp
    2b45:	85 c0                	test   %eax,%eax
    2b47:	0f 85 14 04 00 00    	jne    2f61 <subdir+0x44a>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2b4d:	83 ec 08             	sub    $0x8,%esp
    2b50:	68 02 02 00 00       	push   $0x202
    2b55:	68 8d 53 00 00       	push   $0x538d
    2b5a:	e8 73 1c 00 00       	call   47d2 <open>
    2b5f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2b61:	83 c4 10             	add    $0x10,%esp
    2b64:	85 c0                	test   %eax,%eax
    2b66:	0f 88 09 04 00 00    	js     2f75 <subdir+0x45e>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    2b6c:	83 ec 04             	sub    $0x4,%esp
    2b6f:	6a 02                	push   $0x2
    2b71:	68 b7 53 00 00       	push   $0x53b7
    2b76:	50                   	push   %eax
    2b77:	e8 36 1c 00 00       	call   47b2 <write>
  close(fd);
    2b7c:	89 1c 24             	mov    %ebx,(%esp)
    2b7f:	e8 36 1c 00 00       	call   47ba <close>

  if(unlink("dd") >= 0){
    2b84:	c7 04 24 54 54 00 00 	movl   $0x5454,(%esp)
    2b8b:	e8 52 1c 00 00       	call   47e2 <unlink>
    2b90:	83 c4 10             	add    $0x10,%esp
    2b93:	85 c0                	test   %eax,%eax
    2b95:	0f 89 ee 03 00 00    	jns    2f89 <subdir+0x472>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    2b9b:	83 ec 0c             	sub    $0xc,%esp
    2b9e:	68 68 53 00 00       	push   $0x5368
    2ba3:	e8 52 1c 00 00       	call   47fa <mkdir>
    2ba8:	83 c4 10             	add    $0x10,%esp
    2bab:	85 c0                	test   %eax,%eax
    2bad:	0f 85 ea 03 00 00    	jne    2f9d <subdir+0x486>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bb3:	83 ec 08             	sub    $0x8,%esp
    2bb6:	68 02 02 00 00       	push   $0x202
    2bbb:	68 8a 53 00 00       	push   $0x538a
    2bc0:	e8 0d 1c 00 00       	call   47d2 <open>
    2bc5:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2bc7:	83 c4 10             	add    $0x10,%esp
    2bca:	85 c0                	test   %eax,%eax
    2bcc:	0f 88 df 03 00 00    	js     2fb1 <subdir+0x49a>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    2bd2:	83 ec 04             	sub    $0x4,%esp
    2bd5:	6a 02                	push   $0x2
    2bd7:	68 ab 53 00 00       	push   $0x53ab
    2bdc:	50                   	push   %eax
    2bdd:	e8 d0 1b 00 00       	call   47b2 <write>
  close(fd);
    2be2:	89 1c 24             	mov    %ebx,(%esp)
    2be5:	e8 d0 1b 00 00       	call   47ba <close>

  fd = open("dd/dd/../ff", 0);
    2bea:	83 c4 08             	add    $0x8,%esp
    2bed:	6a 00                	push   $0x0
    2bef:	68 ae 53 00 00       	push   $0x53ae
    2bf4:	e8 d9 1b 00 00       	call   47d2 <open>
    2bf9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2bfb:	83 c4 10             	add    $0x10,%esp
    2bfe:	85 c0                	test   %eax,%eax
    2c00:	0f 88 bf 03 00 00    	js     2fc5 <subdir+0x4ae>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    2c06:	83 ec 04             	sub    $0x4,%esp
    2c09:	68 00 20 00 00       	push   $0x2000
    2c0e:	68 00 94 00 00       	push   $0x9400
    2c13:	50                   	push   %eax
    2c14:	e8 91 1b 00 00       	call   47aa <read>
  if(cc != 2 || buf[0] != 'f'){
    2c19:	83 c4 10             	add    $0x10,%esp
    2c1c:	83 f8 02             	cmp    $0x2,%eax
    2c1f:	0f 85 b4 03 00 00    	jne    2fd9 <subdir+0x4c2>
    2c25:	80 3d 00 94 00 00 66 	cmpb   $0x66,0x9400
    2c2c:	0f 85 a7 03 00 00    	jne    2fd9 <subdir+0x4c2>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    2c32:	83 ec 0c             	sub    $0xc,%esp
    2c35:	53                   	push   %ebx
    2c36:	e8 7f 1b 00 00       	call   47ba <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c3b:	83 c4 08             	add    $0x8,%esp
    2c3e:	68 ee 53 00 00       	push   $0x53ee
    2c43:	68 8a 53 00 00       	push   $0x538a
    2c48:	e8 a5 1b 00 00       	call   47f2 <link>
    2c4d:	83 c4 10             	add    $0x10,%esp
    2c50:	85 c0                	test   %eax,%eax
    2c52:	0f 85 95 03 00 00    	jne    2fed <subdir+0x4d6>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    2c58:	83 ec 0c             	sub    $0xc,%esp
    2c5b:	68 8a 53 00 00       	push   $0x538a
    2c60:	e8 7d 1b 00 00       	call   47e2 <unlink>
    2c65:	83 c4 10             	add    $0x10,%esp
    2c68:	85 c0                	test   %eax,%eax
    2c6a:	0f 85 91 03 00 00    	jne    3001 <subdir+0x4ea>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c70:	83 ec 08             	sub    $0x8,%esp
    2c73:	6a 00                	push   $0x0
    2c75:	68 8a 53 00 00       	push   $0x538a
    2c7a:	e8 53 1b 00 00       	call   47d2 <open>
    2c7f:	83 c4 10             	add    $0x10,%esp
    2c82:	85 c0                	test   %eax,%eax
    2c84:	0f 89 8b 03 00 00    	jns    3015 <subdir+0x4fe>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    2c8a:	83 ec 0c             	sub    $0xc,%esp
    2c8d:	68 54 54 00 00       	push   $0x5454
    2c92:	e8 6b 1b 00 00       	call   4802 <chdir>
    2c97:	83 c4 10             	add    $0x10,%esp
    2c9a:	85 c0                	test   %eax,%eax
    2c9c:	0f 85 87 03 00 00    	jne    3029 <subdir+0x512>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    2ca2:	83 ec 0c             	sub    $0xc,%esp
    2ca5:	68 22 54 00 00       	push   $0x5422
    2caa:	e8 53 1b 00 00       	call   4802 <chdir>
    2caf:	83 c4 10             	add    $0x10,%esp
    2cb2:	85 c0                	test   %eax,%eax
    2cb4:	0f 85 83 03 00 00    	jne    303d <subdir+0x526>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    2cba:	83 ec 0c             	sub    $0xc,%esp
    2cbd:	68 48 54 00 00       	push   $0x5448
    2cc2:	e8 3b 1b 00 00       	call   4802 <chdir>
    2cc7:	83 c4 10             	add    $0x10,%esp
    2cca:	85 c0                	test   %eax,%eax
    2ccc:	0f 85 7f 03 00 00    	jne    3051 <subdir+0x53a>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    2cd2:	83 ec 0c             	sub    $0xc,%esp
    2cd5:	68 57 54 00 00       	push   $0x5457
    2cda:	e8 23 1b 00 00       	call   4802 <chdir>
    2cdf:	83 c4 10             	add    $0x10,%esp
    2ce2:	85 c0                	test   %eax,%eax
    2ce4:	0f 85 7b 03 00 00    	jne    3065 <subdir+0x54e>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    2cea:	83 ec 08             	sub    $0x8,%esp
    2ced:	6a 00                	push   $0x0
    2cef:	68 ee 53 00 00       	push   $0x53ee
    2cf4:	e8 d9 1a 00 00       	call   47d2 <open>
    2cf9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2cfb:	83 c4 10             	add    $0x10,%esp
    2cfe:	85 c0                	test   %eax,%eax
    2d00:	0f 88 73 03 00 00    	js     3079 <subdir+0x562>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2d06:	83 ec 04             	sub    $0x4,%esp
    2d09:	68 00 20 00 00       	push   $0x2000
    2d0e:	68 00 94 00 00       	push   $0x9400
    2d13:	50                   	push   %eax
    2d14:	e8 91 1a 00 00       	call   47aa <read>
    2d19:	83 c4 10             	add    $0x10,%esp
    2d1c:	83 f8 02             	cmp    $0x2,%eax
    2d1f:	0f 85 68 03 00 00    	jne    308d <subdir+0x576>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    2d25:	83 ec 0c             	sub    $0xc,%esp
    2d28:	53                   	push   %ebx
    2d29:	e8 8c 1a 00 00       	call   47ba <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d2e:	83 c4 08             	add    $0x8,%esp
    2d31:	6a 00                	push   $0x0
    2d33:	68 8a 53 00 00       	push   $0x538a
    2d38:	e8 95 1a 00 00       	call   47d2 <open>
    2d3d:	83 c4 10             	add    $0x10,%esp
    2d40:	85 c0                	test   %eax,%eax
    2d42:	0f 89 59 03 00 00    	jns    30a1 <subdir+0x58a>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d48:	83 ec 08             	sub    $0x8,%esp
    2d4b:	68 02 02 00 00       	push   $0x202
    2d50:	68 a2 54 00 00       	push   $0x54a2
    2d55:	e8 78 1a 00 00       	call   47d2 <open>
    2d5a:	83 c4 10             	add    $0x10,%esp
    2d5d:	85 c0                	test   %eax,%eax
    2d5f:	0f 89 50 03 00 00    	jns    30b5 <subdir+0x59e>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d65:	83 ec 08             	sub    $0x8,%esp
    2d68:	68 02 02 00 00       	push   $0x202
    2d6d:	68 c7 54 00 00       	push   $0x54c7
    2d72:	e8 5b 1a 00 00       	call   47d2 <open>
    2d77:	83 c4 10             	add    $0x10,%esp
    2d7a:	85 c0                	test   %eax,%eax
    2d7c:	0f 89 47 03 00 00    	jns    30c9 <subdir+0x5b2>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    2d82:	83 ec 08             	sub    $0x8,%esp
    2d85:	68 00 02 00 00       	push   $0x200
    2d8a:	68 54 54 00 00       	push   $0x5454
    2d8f:	e8 3e 1a 00 00       	call   47d2 <open>
    2d94:	83 c4 10             	add    $0x10,%esp
    2d97:	85 c0                	test   %eax,%eax
    2d99:	0f 89 3e 03 00 00    	jns    30dd <subdir+0x5c6>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    2d9f:	83 ec 08             	sub    $0x8,%esp
    2da2:	6a 02                	push   $0x2
    2da4:	68 54 54 00 00       	push   $0x5454
    2da9:	e8 24 1a 00 00       	call   47d2 <open>
    2dae:	83 c4 10             	add    $0x10,%esp
    2db1:	85 c0                	test   %eax,%eax
    2db3:	0f 89 38 03 00 00    	jns    30f1 <subdir+0x5da>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    2db9:	83 ec 08             	sub    $0x8,%esp
    2dbc:	6a 01                	push   $0x1
    2dbe:	68 54 54 00 00       	push   $0x5454
    2dc3:	e8 0a 1a 00 00       	call   47d2 <open>
    2dc8:	83 c4 10             	add    $0x10,%esp
    2dcb:	85 c0                	test   %eax,%eax
    2dcd:	0f 89 32 03 00 00    	jns    3105 <subdir+0x5ee>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2dd3:	83 ec 08             	sub    $0x8,%esp
    2dd6:	68 36 55 00 00       	push   $0x5536
    2ddb:	68 a2 54 00 00       	push   $0x54a2
    2de0:	e8 0d 1a 00 00       	call   47f2 <link>
    2de5:	83 c4 10             	add    $0x10,%esp
    2de8:	85 c0                	test   %eax,%eax
    2dea:	0f 84 29 03 00 00    	je     3119 <subdir+0x602>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2df0:	83 ec 08             	sub    $0x8,%esp
    2df3:	68 36 55 00 00       	push   $0x5536
    2df8:	68 c7 54 00 00       	push   $0x54c7
    2dfd:	e8 f0 19 00 00       	call   47f2 <link>
    2e02:	83 c4 10             	add    $0x10,%esp
    2e05:	85 c0                	test   %eax,%eax
    2e07:	0f 84 20 03 00 00    	je     312d <subdir+0x616>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2e0d:	83 ec 08             	sub    $0x8,%esp
    2e10:	68 ee 53 00 00       	push   $0x53ee
    2e15:	68 8d 53 00 00       	push   $0x538d
    2e1a:	e8 d3 19 00 00       	call   47f2 <link>
    2e1f:	83 c4 10             	add    $0x10,%esp
    2e22:	85 c0                	test   %eax,%eax
    2e24:	0f 84 17 03 00 00    	je     3141 <subdir+0x62a>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    2e2a:	83 ec 0c             	sub    $0xc,%esp
    2e2d:	68 a2 54 00 00       	push   $0x54a2
    2e32:	e8 c3 19 00 00       	call   47fa <mkdir>
    2e37:	83 c4 10             	add    $0x10,%esp
    2e3a:	85 c0                	test   %eax,%eax
    2e3c:	0f 84 13 03 00 00    	je     3155 <subdir+0x63e>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    2e42:	83 ec 0c             	sub    $0xc,%esp
    2e45:	68 c7 54 00 00       	push   $0x54c7
    2e4a:	e8 ab 19 00 00       	call   47fa <mkdir>
    2e4f:	83 c4 10             	add    $0x10,%esp
    2e52:	85 c0                	test   %eax,%eax
    2e54:	0f 84 0f 03 00 00    	je     3169 <subdir+0x652>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    2e5a:	83 ec 0c             	sub    $0xc,%esp
    2e5d:	68 ee 53 00 00       	push   $0x53ee
    2e62:	e8 93 19 00 00       	call   47fa <mkdir>
    2e67:	83 c4 10             	add    $0x10,%esp
    2e6a:	85 c0                	test   %eax,%eax
    2e6c:	0f 84 0b 03 00 00    	je     317d <subdir+0x666>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    2e72:	83 ec 0c             	sub    $0xc,%esp
    2e75:	68 c7 54 00 00       	push   $0x54c7
    2e7a:	e8 63 19 00 00       	call   47e2 <unlink>
    2e7f:	83 c4 10             	add    $0x10,%esp
    2e82:	85 c0                	test   %eax,%eax
    2e84:	0f 84 07 03 00 00    	je     3191 <subdir+0x67a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    2e8a:	83 ec 0c             	sub    $0xc,%esp
    2e8d:	68 a2 54 00 00       	push   $0x54a2
    2e92:	e8 4b 19 00 00       	call   47e2 <unlink>
    2e97:	83 c4 10             	add    $0x10,%esp
    2e9a:	85 c0                	test   %eax,%eax
    2e9c:	0f 84 03 03 00 00    	je     31a5 <subdir+0x68e>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    2ea2:	83 ec 0c             	sub    $0xc,%esp
    2ea5:	68 8d 53 00 00       	push   $0x538d
    2eaa:	e8 53 19 00 00       	call   4802 <chdir>
    2eaf:	83 c4 10             	add    $0x10,%esp
    2eb2:	85 c0                	test   %eax,%eax
    2eb4:	0f 84 ff 02 00 00    	je     31b9 <subdir+0x6a2>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    2eba:	83 ec 0c             	sub    $0xc,%esp
    2ebd:	68 39 55 00 00       	push   $0x5539
    2ec2:	e8 3b 19 00 00       	call   4802 <chdir>
    2ec7:	83 c4 10             	add    $0x10,%esp
    2eca:	85 c0                	test   %eax,%eax
    2ecc:	0f 84 fb 02 00 00    	je     31cd <subdir+0x6b6>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    2ed2:	83 ec 0c             	sub    $0xc,%esp
    2ed5:	68 ee 53 00 00       	push   $0x53ee
    2eda:	e8 03 19 00 00       	call   47e2 <unlink>
    2edf:	83 c4 10             	add    $0x10,%esp
    2ee2:	85 c0                	test   %eax,%eax
    2ee4:	0f 85 f7 02 00 00    	jne    31e1 <subdir+0x6ca>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    2eea:	83 ec 0c             	sub    $0xc,%esp
    2eed:	68 8d 53 00 00       	push   $0x538d
    2ef2:	e8 eb 18 00 00       	call   47e2 <unlink>
    2ef7:	83 c4 10             	add    $0x10,%esp
    2efa:	85 c0                	test   %eax,%eax
    2efc:	0f 85 f3 02 00 00    	jne    31f5 <subdir+0x6de>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    2f02:	83 ec 0c             	sub    $0xc,%esp
    2f05:	68 54 54 00 00       	push   $0x5454
    2f0a:	e8 d3 18 00 00       	call   47e2 <unlink>
    2f0f:	83 c4 10             	add    $0x10,%esp
    2f12:	85 c0                	test   %eax,%eax
    2f14:	0f 84 ef 02 00 00    	je     3209 <subdir+0x6f2>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    2f1a:	83 ec 0c             	sub    $0xc,%esp
    2f1d:	68 69 53 00 00       	push   $0x5369
    2f22:	e8 bb 18 00 00       	call   47e2 <unlink>
    2f27:	83 c4 10             	add    $0x10,%esp
    2f2a:	85 c0                	test   %eax,%eax
    2f2c:	0f 88 eb 02 00 00    	js     321d <subdir+0x706>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    2f32:	83 ec 0c             	sub    $0xc,%esp
    2f35:	68 54 54 00 00       	push   $0x5454
    2f3a:	e8 a3 18 00 00       	call   47e2 <unlink>
    2f3f:	83 c4 10             	add    $0x10,%esp
    2f42:	85 c0                	test   %eax,%eax
    2f44:	0f 88 e7 02 00 00    	js     3231 <subdir+0x71a>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    2f4a:	83 ec 08             	sub    $0x8,%esp
    2f4d:	68 36 56 00 00       	push   $0x5636
    2f52:	6a 01                	push   $0x1
    2f54:	e8 73 19 00 00       	call   48cc <printf>
}
    2f59:	83 c4 10             	add    $0x10,%esp
    2f5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2f5f:	c9                   	leave  
    2f60:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    2f61:	83 ec 08             	sub    $0x8,%esp
    2f64:	68 3b 53 00 00       	push   $0x533b
    2f69:	6a 01                	push   $0x1
    2f6b:	e8 5c 19 00 00       	call   48cc <printf>
    exit();
    2f70:	e8 1d 18 00 00       	call   4792 <exit>
    printf(1, "create dd/ff failed\n");
    2f75:	83 ec 08             	sub    $0x8,%esp
    2f78:	68 53 53 00 00       	push   $0x5353
    2f7d:	6a 01                	push   $0x1
    2f7f:	e8 48 19 00 00       	call   48cc <printf>
    exit();
    2f84:	e8 09 18 00 00       	call   4792 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2f89:	83 ec 08             	sub    $0x8,%esp
    2f8c:	68 20 5e 00 00       	push   $0x5e20
    2f91:	6a 01                	push   $0x1
    2f93:	e8 34 19 00 00       	call   48cc <printf>
    exit();
    2f98:	e8 f5 17 00 00       	call   4792 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2f9d:	83 ec 08             	sub    $0x8,%esp
    2fa0:	68 6f 53 00 00       	push   $0x536f
    2fa5:	6a 01                	push   $0x1
    2fa7:	e8 20 19 00 00       	call   48cc <printf>
    exit();
    2fac:	e8 e1 17 00 00       	call   4792 <exit>
    printf(1, "create dd/dd/ff failed\n");
    2fb1:	83 ec 08             	sub    $0x8,%esp
    2fb4:	68 93 53 00 00       	push   $0x5393
    2fb9:	6a 01                	push   $0x1
    2fbb:	e8 0c 19 00 00       	call   48cc <printf>
    exit();
    2fc0:	e8 cd 17 00 00       	call   4792 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    2fc5:	83 ec 08             	sub    $0x8,%esp
    2fc8:	68 ba 53 00 00       	push   $0x53ba
    2fcd:	6a 01                	push   $0x1
    2fcf:	e8 f8 18 00 00       	call   48cc <printf>
    exit();
    2fd4:	e8 b9 17 00 00       	call   4792 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    2fd9:	83 ec 08             	sub    $0x8,%esp
    2fdc:	68 d3 53 00 00       	push   $0x53d3
    2fe1:	6a 01                	push   $0x1
    2fe3:	e8 e4 18 00 00       	call   48cc <printf>
    exit();
    2fe8:	e8 a5 17 00 00       	call   4792 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2fed:	83 ec 08             	sub    $0x8,%esp
    2ff0:	68 48 5e 00 00       	push   $0x5e48
    2ff5:	6a 01                	push   $0x1
    2ff7:	e8 d0 18 00 00       	call   48cc <printf>
    exit();
    2ffc:	e8 91 17 00 00       	call   4792 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    3001:	83 ec 08             	sub    $0x8,%esp
    3004:	68 f9 53 00 00       	push   $0x53f9
    3009:	6a 01                	push   $0x1
    300b:	e8 bc 18 00 00       	call   48cc <printf>
    exit();
    3010:	e8 7d 17 00 00       	call   4792 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    3015:	83 ec 08             	sub    $0x8,%esp
    3018:	68 6c 5e 00 00       	push   $0x5e6c
    301d:	6a 01                	push   $0x1
    301f:	e8 a8 18 00 00       	call   48cc <printf>
    exit();
    3024:	e8 69 17 00 00       	call   4792 <exit>
    printf(1, "chdir dd failed\n");
    3029:	83 ec 08             	sub    $0x8,%esp
    302c:	68 11 54 00 00       	push   $0x5411
    3031:	6a 01                	push   $0x1
    3033:	e8 94 18 00 00       	call   48cc <printf>
    exit();
    3038:	e8 55 17 00 00       	call   4792 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    303d:	83 ec 08             	sub    $0x8,%esp
    3040:	68 2e 54 00 00       	push   $0x542e
    3045:	6a 01                	push   $0x1
    3047:	e8 80 18 00 00       	call   48cc <printf>
    exit();
    304c:	e8 41 17 00 00       	call   4792 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    3051:	83 ec 08             	sub    $0x8,%esp
    3054:	68 2e 54 00 00       	push   $0x542e
    3059:	6a 01                	push   $0x1
    305b:	e8 6c 18 00 00       	call   48cc <printf>
    exit();
    3060:	e8 2d 17 00 00       	call   4792 <exit>
    printf(1, "chdir ./.. failed\n");
    3065:	83 ec 08             	sub    $0x8,%esp
    3068:	68 5c 54 00 00       	push   $0x545c
    306d:	6a 01                	push   $0x1
    306f:	e8 58 18 00 00       	call   48cc <printf>
    exit();
    3074:	e8 19 17 00 00       	call   4792 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    3079:	83 ec 08             	sub    $0x8,%esp
    307c:	68 6f 54 00 00       	push   $0x546f
    3081:	6a 01                	push   $0x1
    3083:	e8 44 18 00 00       	call   48cc <printf>
    exit();
    3088:	e8 05 17 00 00       	call   4792 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    308d:	83 ec 08             	sub    $0x8,%esp
    3090:	68 87 54 00 00       	push   $0x5487
    3095:	6a 01                	push   $0x1
    3097:	e8 30 18 00 00       	call   48cc <printf>
    exit();
    309c:	e8 f1 16 00 00       	call   4792 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    30a1:	83 ec 08             	sub    $0x8,%esp
    30a4:	68 90 5e 00 00       	push   $0x5e90
    30a9:	6a 01                	push   $0x1
    30ab:	e8 1c 18 00 00       	call   48cc <printf>
    exit();
    30b0:	e8 dd 16 00 00       	call   4792 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    30b5:	83 ec 08             	sub    $0x8,%esp
    30b8:	68 ab 54 00 00       	push   $0x54ab
    30bd:	6a 01                	push   $0x1
    30bf:	e8 08 18 00 00       	call   48cc <printf>
    exit();
    30c4:	e8 c9 16 00 00       	call   4792 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    30c9:	83 ec 08             	sub    $0x8,%esp
    30cc:	68 d0 54 00 00       	push   $0x54d0
    30d1:	6a 01                	push   $0x1
    30d3:	e8 f4 17 00 00       	call   48cc <printf>
    exit();
    30d8:	e8 b5 16 00 00       	call   4792 <exit>
    printf(1, "create dd succeeded!\n");
    30dd:	83 ec 08             	sub    $0x8,%esp
    30e0:	68 ec 54 00 00       	push   $0x54ec
    30e5:	6a 01                	push   $0x1
    30e7:	e8 e0 17 00 00       	call   48cc <printf>
    exit();
    30ec:	e8 a1 16 00 00       	call   4792 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    30f1:	83 ec 08             	sub    $0x8,%esp
    30f4:	68 02 55 00 00       	push   $0x5502
    30f9:	6a 01                	push   $0x1
    30fb:	e8 cc 17 00 00       	call   48cc <printf>
    exit();
    3100:	e8 8d 16 00 00       	call   4792 <exit>
    printf(1, "open dd wronly succeeded!\n");
    3105:	83 ec 08             	sub    $0x8,%esp
    3108:	68 1b 55 00 00       	push   $0x551b
    310d:	6a 01                	push   $0x1
    310f:	e8 b8 17 00 00       	call   48cc <printf>
    exit();
    3114:	e8 79 16 00 00       	call   4792 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    3119:	83 ec 08             	sub    $0x8,%esp
    311c:	68 b8 5e 00 00       	push   $0x5eb8
    3121:	6a 01                	push   $0x1
    3123:	e8 a4 17 00 00       	call   48cc <printf>
    exit();
    3128:	e8 65 16 00 00       	call   4792 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    312d:	83 ec 08             	sub    $0x8,%esp
    3130:	68 dc 5e 00 00       	push   $0x5edc
    3135:	6a 01                	push   $0x1
    3137:	e8 90 17 00 00       	call   48cc <printf>
    exit();
    313c:	e8 51 16 00 00       	call   4792 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    3141:	83 ec 08             	sub    $0x8,%esp
    3144:	68 00 5f 00 00       	push   $0x5f00
    3149:	6a 01                	push   $0x1
    314b:	e8 7c 17 00 00       	call   48cc <printf>
    exit();
    3150:	e8 3d 16 00 00       	call   4792 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    3155:	83 ec 08             	sub    $0x8,%esp
    3158:	68 3f 55 00 00       	push   $0x553f
    315d:	6a 01                	push   $0x1
    315f:	e8 68 17 00 00       	call   48cc <printf>
    exit();
    3164:	e8 29 16 00 00       	call   4792 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    3169:	83 ec 08             	sub    $0x8,%esp
    316c:	68 5a 55 00 00       	push   $0x555a
    3171:	6a 01                	push   $0x1
    3173:	e8 54 17 00 00       	call   48cc <printf>
    exit();
    3178:	e8 15 16 00 00       	call   4792 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    317d:	83 ec 08             	sub    $0x8,%esp
    3180:	68 75 55 00 00       	push   $0x5575
    3185:	6a 01                	push   $0x1
    3187:	e8 40 17 00 00       	call   48cc <printf>
    exit();
    318c:	e8 01 16 00 00       	call   4792 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    3191:	83 ec 08             	sub    $0x8,%esp
    3194:	68 92 55 00 00       	push   $0x5592
    3199:	6a 01                	push   $0x1
    319b:	e8 2c 17 00 00       	call   48cc <printf>
    exit();
    31a0:	e8 ed 15 00 00       	call   4792 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    31a5:	83 ec 08             	sub    $0x8,%esp
    31a8:	68 ae 55 00 00       	push   $0x55ae
    31ad:	6a 01                	push   $0x1
    31af:	e8 18 17 00 00       	call   48cc <printf>
    exit();
    31b4:	e8 d9 15 00 00       	call   4792 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    31b9:	83 ec 08             	sub    $0x8,%esp
    31bc:	68 ca 55 00 00       	push   $0x55ca
    31c1:	6a 01                	push   $0x1
    31c3:	e8 04 17 00 00       	call   48cc <printf>
    exit();
    31c8:	e8 c5 15 00 00       	call   4792 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    31cd:	83 ec 08             	sub    $0x8,%esp
    31d0:	68 e2 55 00 00       	push   $0x55e2
    31d5:	6a 01                	push   $0x1
    31d7:	e8 f0 16 00 00       	call   48cc <printf>
    exit();
    31dc:	e8 b1 15 00 00       	call   4792 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    31e1:	83 ec 08             	sub    $0x8,%esp
    31e4:	68 f9 53 00 00       	push   $0x53f9
    31e9:	6a 01                	push   $0x1
    31eb:	e8 dc 16 00 00       	call   48cc <printf>
    exit();
    31f0:	e8 9d 15 00 00       	call   4792 <exit>
    printf(1, "unlink dd/ff failed\n");
    31f5:	83 ec 08             	sub    $0x8,%esp
    31f8:	68 fa 55 00 00       	push   $0x55fa
    31fd:	6a 01                	push   $0x1
    31ff:	e8 c8 16 00 00       	call   48cc <printf>
    exit();
    3204:	e8 89 15 00 00       	call   4792 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    3209:	83 ec 08             	sub    $0x8,%esp
    320c:	68 24 5f 00 00       	push   $0x5f24
    3211:	6a 01                	push   $0x1
    3213:	e8 b4 16 00 00       	call   48cc <printf>
    exit();
    3218:	e8 75 15 00 00       	call   4792 <exit>
    printf(1, "unlink dd/dd failed\n");
    321d:	83 ec 08             	sub    $0x8,%esp
    3220:	68 0f 56 00 00       	push   $0x560f
    3225:	6a 01                	push   $0x1
    3227:	e8 a0 16 00 00       	call   48cc <printf>
    exit();
    322c:	e8 61 15 00 00       	call   4792 <exit>
    printf(1, "unlink dd failed\n");
    3231:	83 ec 08             	sub    $0x8,%esp
    3234:	68 24 56 00 00       	push   $0x5624
    3239:	6a 01                	push   $0x1
    323b:	e8 8c 16 00 00       	call   48cc <printf>
    exit();
    3240:	e8 4d 15 00 00       	call   4792 <exit>

00003245 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    3245:	55                   	push   %ebp
    3246:	89 e5                	mov    %esp,%ebp
    3248:	57                   	push   %edi
    3249:	56                   	push   %esi
    324a:	53                   	push   %ebx
    324b:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    324e:	68 41 56 00 00       	push   $0x5641
    3253:	6a 01                	push   $0x1
    3255:	e8 72 16 00 00       	call   48cc <printf>

  unlink("bigwrite");
    325a:	c7 04 24 50 56 00 00 	movl   $0x5650,(%esp)
    3261:	e8 7c 15 00 00       	call   47e2 <unlink>
    3266:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    3269:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    fd = open("bigwrite", O_CREATE | O_RDWR);
    326e:	83 ec 08             	sub    $0x8,%esp
    3271:	68 02 02 00 00       	push   $0x202
    3276:	68 50 56 00 00       	push   $0x5650
    327b:	e8 52 15 00 00       	call   47d2 <open>
    3280:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    3282:	83 c4 10             	add    $0x10,%esp
    3285:	85 c0                	test   %eax,%eax
    3287:	78 6e                	js     32f7 <bigwrite+0xb2>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    3289:	83 ec 04             	sub    $0x4,%esp
    328c:	53                   	push   %ebx
    328d:	68 00 94 00 00       	push   $0x9400
    3292:	50                   	push   %eax
    3293:	e8 1a 15 00 00       	call   47b2 <write>
    3298:	89 c7                	mov    %eax,%edi
      if(cc != sz){
    329a:	83 c4 10             	add    $0x10,%esp
    329d:	39 c3                	cmp    %eax,%ebx
    329f:	75 6a                	jne    330b <bigwrite+0xc6>
      int cc = write(fd, buf, sz);
    32a1:	83 ec 04             	sub    $0x4,%esp
    32a4:	53                   	push   %ebx
    32a5:	68 00 94 00 00       	push   $0x9400
    32aa:	56                   	push   %esi
    32ab:	e8 02 15 00 00       	call   47b2 <write>
      if(cc != sz){
    32b0:	83 c4 10             	add    $0x10,%esp
    32b3:	39 d8                	cmp    %ebx,%eax
    32b5:	75 56                	jne    330d <bigwrite+0xc8>
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    32b7:	83 ec 0c             	sub    $0xc,%esp
    32ba:	56                   	push   %esi
    32bb:	e8 fa 14 00 00       	call   47ba <close>
    unlink("bigwrite");
    32c0:	c7 04 24 50 56 00 00 	movl   $0x5650,(%esp)
    32c7:	e8 16 15 00 00       	call   47e2 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    32cc:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    32d2:	83 c4 10             	add    $0x10,%esp
    32d5:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    32db:	75 91                	jne    326e <bigwrite+0x29>
  }

  printf(1, "bigwrite ok\n");
    32dd:	83 ec 08             	sub    $0x8,%esp
    32e0:	68 83 56 00 00       	push   $0x5683
    32e5:	6a 01                	push   $0x1
    32e7:	e8 e0 15 00 00       	call   48cc <printf>
}
    32ec:	83 c4 10             	add    $0x10,%esp
    32ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
    32f2:	5b                   	pop    %ebx
    32f3:	5e                   	pop    %esi
    32f4:	5f                   	pop    %edi
    32f5:	5d                   	pop    %ebp
    32f6:	c3                   	ret    
      printf(1, "cannot create bigwrite\n");
    32f7:	83 ec 08             	sub    $0x8,%esp
    32fa:	68 59 56 00 00       	push   $0x5659
    32ff:	6a 01                	push   $0x1
    3301:	e8 c6 15 00 00       	call   48cc <printf>
      exit();
    3306:	e8 87 14 00 00       	call   4792 <exit>
      if(cc != sz){
    330b:	89 df                	mov    %ebx,%edi
        printf(1, "write(%d) ret %d\n", sz, cc);
    330d:	50                   	push   %eax
    330e:	57                   	push   %edi
    330f:	68 71 56 00 00       	push   $0x5671
    3314:	6a 01                	push   $0x1
    3316:	e8 b1 15 00 00       	call   48cc <printf>
        exit();
    331b:	e8 72 14 00 00       	call   4792 <exit>

00003320 <bigfile>:

void
bigfile(void)
{
    3320:	55                   	push   %ebp
    3321:	89 e5                	mov    %esp,%ebp
    3323:	57                   	push   %edi
    3324:	56                   	push   %esi
    3325:	53                   	push   %ebx
    3326:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    3329:	68 90 56 00 00       	push   $0x5690
    332e:	6a 01                	push   $0x1
    3330:	e8 97 15 00 00       	call   48cc <printf>

  unlink("bigfile");
    3335:	c7 04 24 ac 56 00 00 	movl   $0x56ac,(%esp)
    333c:	e8 a1 14 00 00       	call   47e2 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    3341:	83 c4 08             	add    $0x8,%esp
    3344:	68 02 02 00 00       	push   $0x202
    3349:	68 ac 56 00 00       	push   $0x56ac
    334e:	e8 7f 14 00 00       	call   47d2 <open>
  if(fd < 0){
    3353:	83 c4 10             	add    $0x10,%esp
    3356:	85 c0                	test   %eax,%eax
    3358:	0f 88 c5 00 00 00    	js     3423 <bigfile+0x103>
    335e:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    3360:	bb 00 00 00 00       	mov    $0x0,%ebx
    memset(buf, i, 600);
    3365:	83 ec 04             	sub    $0x4,%esp
    3368:	68 58 02 00 00       	push   $0x258
    336d:	53                   	push   %ebx
    336e:	68 00 94 00 00       	push   $0x9400
    3373:	e8 cd 12 00 00       	call   4645 <memset>
    if(write(fd, buf, 600) != 600){
    3378:	83 c4 0c             	add    $0xc,%esp
    337b:	68 58 02 00 00       	push   $0x258
    3380:	68 00 94 00 00       	push   $0x9400
    3385:	56                   	push   %esi
    3386:	e8 27 14 00 00       	call   47b2 <write>
    338b:	83 c4 10             	add    $0x10,%esp
    338e:	3d 58 02 00 00       	cmp    $0x258,%eax
    3393:	0f 85 9e 00 00 00    	jne    3437 <bigfile+0x117>
  for(i = 0; i < 20; i++){
    3399:	83 c3 01             	add    $0x1,%ebx
    339c:	83 fb 14             	cmp    $0x14,%ebx
    339f:	75 c4                	jne    3365 <bigfile+0x45>
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    33a1:	83 ec 0c             	sub    $0xc,%esp
    33a4:	56                   	push   %esi
    33a5:	e8 10 14 00 00       	call   47ba <close>

  fd = open("bigfile", 0);
    33aa:	83 c4 08             	add    $0x8,%esp
    33ad:	6a 00                	push   $0x0
    33af:	68 ac 56 00 00       	push   $0x56ac
    33b4:	e8 19 14 00 00       	call   47d2 <open>
    33b9:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    33bb:	83 c4 10             	add    $0x10,%esp
    33be:	85 c0                	test   %eax,%eax
    33c0:	0f 88 85 00 00 00    	js     344b <bigfile+0x12b>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
    33c6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    33cb:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    33d0:	83 ec 04             	sub    $0x4,%esp
    33d3:	68 2c 01 00 00       	push   $0x12c
    33d8:	68 00 94 00 00       	push   $0x9400
    33dd:	57                   	push   %edi
    33de:	e8 c7 13 00 00       	call   47aa <read>
    if(cc < 0){
    33e3:	83 c4 10             	add    $0x10,%esp
    33e6:	85 c0                	test   %eax,%eax
    33e8:	78 75                	js     345f <bigfile+0x13f>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    33ea:	85 c0                	test   %eax,%eax
    33ec:	0f 84 a9 00 00 00    	je     349b <bigfile+0x17b>
      break;
    if(cc != 300){
    33f2:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    33f7:	75 7a                	jne    3473 <bigfile+0x153>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    33f9:	0f be 15 00 94 00 00 	movsbl 0x9400,%edx
    3400:	89 d8                	mov    %ebx,%eax
    3402:	c1 e8 1f             	shr    $0x1f,%eax
    3405:	01 d8                	add    %ebx,%eax
    3407:	d1 f8                	sar    %eax
    3409:	39 c2                	cmp    %eax,%edx
    340b:	75 7a                	jne    3487 <bigfile+0x167>
    340d:	0f be 05 2b 95 00 00 	movsbl 0x952b,%eax
    3414:	39 c2                	cmp    %eax,%edx
    3416:	75 6f                	jne    3487 <bigfile+0x167>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    3418:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  for(i = 0; ; i++){
    341e:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    3421:	eb ad                	jmp    33d0 <bigfile+0xb0>
    printf(1, "cannot create bigfile");
    3423:	83 ec 08             	sub    $0x8,%esp
    3426:	68 9e 56 00 00       	push   $0x569e
    342b:	6a 01                	push   $0x1
    342d:	e8 9a 14 00 00       	call   48cc <printf>
    exit();
    3432:	e8 5b 13 00 00       	call   4792 <exit>
      printf(1, "write bigfile failed\n");
    3437:	83 ec 08             	sub    $0x8,%esp
    343a:	68 b4 56 00 00       	push   $0x56b4
    343f:	6a 01                	push   $0x1
    3441:	e8 86 14 00 00       	call   48cc <printf>
      exit();
    3446:	e8 47 13 00 00       	call   4792 <exit>
    printf(1, "cannot open bigfile\n");
    344b:	83 ec 08             	sub    $0x8,%esp
    344e:	68 ca 56 00 00       	push   $0x56ca
    3453:	6a 01                	push   $0x1
    3455:	e8 72 14 00 00       	call   48cc <printf>
    exit();
    345a:	e8 33 13 00 00       	call   4792 <exit>
      printf(1, "read bigfile failed\n");
    345f:	83 ec 08             	sub    $0x8,%esp
    3462:	68 df 56 00 00       	push   $0x56df
    3467:	6a 01                	push   $0x1
    3469:	e8 5e 14 00 00       	call   48cc <printf>
      exit();
    346e:	e8 1f 13 00 00       	call   4792 <exit>
      printf(1, "short read bigfile\n");
    3473:	83 ec 08             	sub    $0x8,%esp
    3476:	68 f4 56 00 00       	push   $0x56f4
    347b:	6a 01                	push   $0x1
    347d:	e8 4a 14 00 00       	call   48cc <printf>
      exit();
    3482:	e8 0b 13 00 00       	call   4792 <exit>
      printf(1, "read bigfile wrong data\n");
    3487:	83 ec 08             	sub    $0x8,%esp
    348a:	68 08 57 00 00       	push   $0x5708
    348f:	6a 01                	push   $0x1
    3491:	e8 36 14 00 00       	call   48cc <printf>
      exit();
    3496:	e8 f7 12 00 00       	call   4792 <exit>
  }
  close(fd);
    349b:	83 ec 0c             	sub    $0xc,%esp
    349e:	57                   	push   %edi
    349f:	e8 16 13 00 00       	call   47ba <close>
  if(total != 20*600){
    34a4:	83 c4 10             	add    $0x10,%esp
    34a7:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    34ad:	75 27                	jne    34d6 <bigfile+0x1b6>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    34af:	83 ec 0c             	sub    $0xc,%esp
    34b2:	68 ac 56 00 00       	push   $0x56ac
    34b7:	e8 26 13 00 00       	call   47e2 <unlink>

  printf(1, "bigfile test ok\n");
    34bc:	83 c4 08             	add    $0x8,%esp
    34bf:	68 3b 57 00 00       	push   $0x573b
    34c4:	6a 01                	push   $0x1
    34c6:	e8 01 14 00 00       	call   48cc <printf>
}
    34cb:	83 c4 10             	add    $0x10,%esp
    34ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    34d1:	5b                   	pop    %ebx
    34d2:	5e                   	pop    %esi
    34d3:	5f                   	pop    %edi
    34d4:	5d                   	pop    %ebp
    34d5:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    34d6:	83 ec 08             	sub    $0x8,%esp
    34d9:	68 21 57 00 00       	push   $0x5721
    34de:	6a 01                	push   $0x1
    34e0:	e8 e7 13 00 00       	call   48cc <printf>
    exit();
    34e5:	e8 a8 12 00 00       	call   4792 <exit>

000034ea <fourteen>:

void
fourteen(void)
{
    34ea:	55                   	push   %ebp
    34eb:	89 e5                	mov    %esp,%ebp
    34ed:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    34f0:	68 4c 57 00 00       	push   $0x574c
    34f5:	6a 01                	push   $0x1
    34f7:	e8 d0 13 00 00       	call   48cc <printf>

  if(mkdir("12345678901234") != 0){
    34fc:	c7 04 24 87 57 00 00 	movl   $0x5787,(%esp)
    3503:	e8 f2 12 00 00       	call   47fa <mkdir>
    3508:	83 c4 10             	add    $0x10,%esp
    350b:	85 c0                	test   %eax,%eax
    350d:	0f 85 9c 00 00 00    	jne    35af <fourteen+0xc5>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    3513:	83 ec 0c             	sub    $0xc,%esp
    3516:	68 44 5f 00 00       	push   $0x5f44
    351b:	e8 da 12 00 00       	call   47fa <mkdir>
    3520:	83 c4 10             	add    $0x10,%esp
    3523:	85 c0                	test   %eax,%eax
    3525:	0f 85 98 00 00 00    	jne    35c3 <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    352b:	83 ec 08             	sub    $0x8,%esp
    352e:	68 00 02 00 00       	push   $0x200
    3533:	68 94 5f 00 00       	push   $0x5f94
    3538:	e8 95 12 00 00       	call   47d2 <open>
  if(fd < 0){
    353d:	83 c4 10             	add    $0x10,%esp
    3540:	85 c0                	test   %eax,%eax
    3542:	0f 88 8f 00 00 00    	js     35d7 <fourteen+0xed>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    3548:	83 ec 0c             	sub    $0xc,%esp
    354b:	50                   	push   %eax
    354c:	e8 69 12 00 00       	call   47ba <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3551:	83 c4 08             	add    $0x8,%esp
    3554:	6a 00                	push   $0x0
    3556:	68 04 60 00 00       	push   $0x6004
    355b:	e8 72 12 00 00       	call   47d2 <open>
  if(fd < 0){
    3560:	83 c4 10             	add    $0x10,%esp
    3563:	85 c0                	test   %eax,%eax
    3565:	0f 88 80 00 00 00    	js     35eb <fourteen+0x101>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    356b:	83 ec 0c             	sub    $0xc,%esp
    356e:	50                   	push   %eax
    356f:	e8 46 12 00 00       	call   47ba <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    3574:	c7 04 24 78 57 00 00 	movl   $0x5778,(%esp)
    357b:	e8 7a 12 00 00       	call   47fa <mkdir>
    3580:	83 c4 10             	add    $0x10,%esp
    3583:	85 c0                	test   %eax,%eax
    3585:	74 78                	je     35ff <fourteen+0x115>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    3587:	83 ec 0c             	sub    $0xc,%esp
    358a:	68 a0 60 00 00       	push   $0x60a0
    358f:	e8 66 12 00 00       	call   47fa <mkdir>
    3594:	83 c4 10             	add    $0x10,%esp
    3597:	85 c0                	test   %eax,%eax
    3599:	74 78                	je     3613 <fourteen+0x129>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    359b:	83 ec 08             	sub    $0x8,%esp
    359e:	68 96 57 00 00       	push   $0x5796
    35a3:	6a 01                	push   $0x1
    35a5:	e8 22 13 00 00       	call   48cc <printf>
}
    35aa:	83 c4 10             	add    $0x10,%esp
    35ad:	c9                   	leave  
    35ae:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    35af:	83 ec 08             	sub    $0x8,%esp
    35b2:	68 5b 57 00 00       	push   $0x575b
    35b7:	6a 01                	push   $0x1
    35b9:	e8 0e 13 00 00       	call   48cc <printf>
    exit();
    35be:	e8 cf 11 00 00       	call   4792 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    35c3:	83 ec 08             	sub    $0x8,%esp
    35c6:	68 64 5f 00 00       	push   $0x5f64
    35cb:	6a 01                	push   $0x1
    35cd:	e8 fa 12 00 00       	call   48cc <printf>
    exit();
    35d2:	e8 bb 11 00 00       	call   4792 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    35d7:	83 ec 08             	sub    $0x8,%esp
    35da:	68 c4 5f 00 00       	push   $0x5fc4
    35df:	6a 01                	push   $0x1
    35e1:	e8 e6 12 00 00       	call   48cc <printf>
    exit();
    35e6:	e8 a7 11 00 00       	call   4792 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    35eb:	83 ec 08             	sub    $0x8,%esp
    35ee:	68 34 60 00 00       	push   $0x6034
    35f3:	6a 01                	push   $0x1
    35f5:	e8 d2 12 00 00       	call   48cc <printf>
    exit();
    35fa:	e8 93 11 00 00       	call   4792 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    35ff:	83 ec 08             	sub    $0x8,%esp
    3602:	68 70 60 00 00       	push   $0x6070
    3607:	6a 01                	push   $0x1
    3609:	e8 be 12 00 00       	call   48cc <printf>
    exit();
    360e:	e8 7f 11 00 00       	call   4792 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    3613:	83 ec 08             	sub    $0x8,%esp
    3616:	68 c0 60 00 00       	push   $0x60c0
    361b:	6a 01                	push   $0x1
    361d:	e8 aa 12 00 00       	call   48cc <printf>
    exit();
    3622:	e8 6b 11 00 00       	call   4792 <exit>

00003627 <rmdot>:

void
rmdot(void)
{
    3627:	55                   	push   %ebp
    3628:	89 e5                	mov    %esp,%ebp
    362a:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    362d:	68 a3 57 00 00       	push   $0x57a3
    3632:	6a 01                	push   $0x1
    3634:	e8 93 12 00 00       	call   48cc <printf>
  if(mkdir("dots") != 0){
    3639:	c7 04 24 af 57 00 00 	movl   $0x57af,(%esp)
    3640:	e8 b5 11 00 00       	call   47fa <mkdir>
    3645:	83 c4 10             	add    $0x10,%esp
    3648:	85 c0                	test   %eax,%eax
    364a:	0f 85 bc 00 00 00    	jne    370c <rmdot+0xe5>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    3650:	83 ec 0c             	sub    $0xc,%esp
    3653:	68 af 57 00 00       	push   $0x57af
    3658:	e8 a5 11 00 00       	call   4802 <chdir>
    365d:	83 c4 10             	add    $0x10,%esp
    3660:	85 c0                	test   %eax,%eax
    3662:	0f 85 b8 00 00 00    	jne    3720 <rmdot+0xf9>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    3668:	83 ec 0c             	sub    $0xc,%esp
    366b:	68 5a 54 00 00       	push   $0x545a
    3670:	e8 6d 11 00 00       	call   47e2 <unlink>
    3675:	83 c4 10             	add    $0x10,%esp
    3678:	85 c0                	test   %eax,%eax
    367a:	0f 84 b4 00 00 00    	je     3734 <rmdot+0x10d>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    3680:	83 ec 0c             	sub    $0xc,%esp
    3683:	68 59 54 00 00       	push   $0x5459
    3688:	e8 55 11 00 00       	call   47e2 <unlink>
    368d:	83 c4 10             	add    $0x10,%esp
    3690:	85 c0                	test   %eax,%eax
    3692:	0f 84 b0 00 00 00    	je     3748 <rmdot+0x121>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    3698:	83 ec 0c             	sub    $0xc,%esp
    369b:	68 2d 4c 00 00       	push   $0x4c2d
    36a0:	e8 5d 11 00 00       	call   4802 <chdir>
    36a5:	83 c4 10             	add    $0x10,%esp
    36a8:	85 c0                	test   %eax,%eax
    36aa:	0f 85 ac 00 00 00    	jne    375c <rmdot+0x135>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    36b0:	83 ec 0c             	sub    $0xc,%esp
    36b3:	68 f7 57 00 00       	push   $0x57f7
    36b8:	e8 25 11 00 00       	call   47e2 <unlink>
    36bd:	83 c4 10             	add    $0x10,%esp
    36c0:	85 c0                	test   %eax,%eax
    36c2:	0f 84 a8 00 00 00    	je     3770 <rmdot+0x149>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    36c8:	83 ec 0c             	sub    $0xc,%esp
    36cb:	68 15 58 00 00       	push   $0x5815
    36d0:	e8 0d 11 00 00       	call   47e2 <unlink>
    36d5:	83 c4 10             	add    $0x10,%esp
    36d8:	85 c0                	test   %eax,%eax
    36da:	0f 84 a4 00 00 00    	je     3784 <rmdot+0x15d>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    36e0:	83 ec 0c             	sub    $0xc,%esp
    36e3:	68 af 57 00 00       	push   $0x57af
    36e8:	e8 f5 10 00 00       	call   47e2 <unlink>
    36ed:	83 c4 10             	add    $0x10,%esp
    36f0:	85 c0                	test   %eax,%eax
    36f2:	0f 85 a0 00 00 00    	jne    3798 <rmdot+0x171>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    36f8:	83 ec 08             	sub    $0x8,%esp
    36fb:	68 4a 58 00 00       	push   $0x584a
    3700:	6a 01                	push   $0x1
    3702:	e8 c5 11 00 00       	call   48cc <printf>
}
    3707:	83 c4 10             	add    $0x10,%esp
    370a:	c9                   	leave  
    370b:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    370c:	83 ec 08             	sub    $0x8,%esp
    370f:	68 b4 57 00 00       	push   $0x57b4
    3714:	6a 01                	push   $0x1
    3716:	e8 b1 11 00 00       	call   48cc <printf>
    exit();
    371b:	e8 72 10 00 00       	call   4792 <exit>
    printf(1, "chdir dots failed\n");
    3720:	83 ec 08             	sub    $0x8,%esp
    3723:	68 c7 57 00 00       	push   $0x57c7
    3728:	6a 01                	push   $0x1
    372a:	e8 9d 11 00 00       	call   48cc <printf>
    exit();
    372f:	e8 5e 10 00 00       	call   4792 <exit>
    printf(1, "rm . worked!\n");
    3734:	83 ec 08             	sub    $0x8,%esp
    3737:	68 da 57 00 00       	push   $0x57da
    373c:	6a 01                	push   $0x1
    373e:	e8 89 11 00 00       	call   48cc <printf>
    exit();
    3743:	e8 4a 10 00 00       	call   4792 <exit>
    printf(1, "rm .. worked!\n");
    3748:	83 ec 08             	sub    $0x8,%esp
    374b:	68 e8 57 00 00       	push   $0x57e8
    3750:	6a 01                	push   $0x1
    3752:	e8 75 11 00 00       	call   48cc <printf>
    exit();
    3757:	e8 36 10 00 00       	call   4792 <exit>
    printf(1, "chdir / failed\n");
    375c:	83 ec 08             	sub    $0x8,%esp
    375f:	68 2f 4c 00 00       	push   $0x4c2f
    3764:	6a 01                	push   $0x1
    3766:	e8 61 11 00 00       	call   48cc <printf>
    exit();
    376b:	e8 22 10 00 00       	call   4792 <exit>
    printf(1, "unlink dots/. worked!\n");
    3770:	83 ec 08             	sub    $0x8,%esp
    3773:	68 fe 57 00 00       	push   $0x57fe
    3778:	6a 01                	push   $0x1
    377a:	e8 4d 11 00 00       	call   48cc <printf>
    exit();
    377f:	e8 0e 10 00 00       	call   4792 <exit>
    printf(1, "unlink dots/.. worked!\n");
    3784:	83 ec 08             	sub    $0x8,%esp
    3787:	68 1d 58 00 00       	push   $0x581d
    378c:	6a 01                	push   $0x1
    378e:	e8 39 11 00 00       	call   48cc <printf>
    exit();
    3793:	e8 fa 0f 00 00       	call   4792 <exit>
    printf(1, "unlink dots failed!\n");
    3798:	83 ec 08             	sub    $0x8,%esp
    379b:	68 35 58 00 00       	push   $0x5835
    37a0:	6a 01                	push   $0x1
    37a2:	e8 25 11 00 00       	call   48cc <printf>
    exit();
    37a7:	e8 e6 0f 00 00       	call   4792 <exit>

000037ac <dirfile>:

void
dirfile(void)
{
    37ac:	55                   	push   %ebp
    37ad:	89 e5                	mov    %esp,%ebp
    37af:	53                   	push   %ebx
    37b0:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    37b3:	68 54 58 00 00       	push   $0x5854
    37b8:	6a 01                	push   $0x1
    37ba:	e8 0d 11 00 00       	call   48cc <printf>

  fd = open("dirfile", O_CREATE);
    37bf:	83 c4 08             	add    $0x8,%esp
    37c2:	68 00 02 00 00       	push   $0x200
    37c7:	68 61 58 00 00       	push   $0x5861
    37cc:	e8 01 10 00 00       	call   47d2 <open>
  if(fd < 0){
    37d1:	83 c4 10             	add    $0x10,%esp
    37d4:	85 c0                	test   %eax,%eax
    37d6:	0f 88 22 01 00 00    	js     38fe <dirfile+0x152>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    37dc:	83 ec 0c             	sub    $0xc,%esp
    37df:	50                   	push   %eax
    37e0:	e8 d5 0f 00 00       	call   47ba <close>
  if(chdir("dirfile") == 0){
    37e5:	c7 04 24 61 58 00 00 	movl   $0x5861,(%esp)
    37ec:	e8 11 10 00 00       	call   4802 <chdir>
    37f1:	83 c4 10             	add    $0x10,%esp
    37f4:	85 c0                	test   %eax,%eax
    37f6:	0f 84 16 01 00 00    	je     3912 <dirfile+0x166>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    37fc:	83 ec 08             	sub    $0x8,%esp
    37ff:	6a 00                	push   $0x0
    3801:	68 9a 58 00 00       	push   $0x589a
    3806:	e8 c7 0f 00 00       	call   47d2 <open>
  if(fd >= 0){
    380b:	83 c4 10             	add    $0x10,%esp
    380e:	85 c0                	test   %eax,%eax
    3810:	0f 89 10 01 00 00    	jns    3926 <dirfile+0x17a>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    3816:	83 ec 08             	sub    $0x8,%esp
    3819:	68 00 02 00 00       	push   $0x200
    381e:	68 9a 58 00 00       	push   $0x589a
    3823:	e8 aa 0f 00 00       	call   47d2 <open>
  if(fd >= 0){
    3828:	83 c4 10             	add    $0x10,%esp
    382b:	85 c0                	test   %eax,%eax
    382d:	0f 89 07 01 00 00    	jns    393a <dirfile+0x18e>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    3833:	83 ec 0c             	sub    $0xc,%esp
    3836:	68 9a 58 00 00       	push   $0x589a
    383b:	e8 ba 0f 00 00       	call   47fa <mkdir>
    3840:	83 c4 10             	add    $0x10,%esp
    3843:	85 c0                	test   %eax,%eax
    3845:	0f 84 03 01 00 00    	je     394e <dirfile+0x1a2>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    384b:	83 ec 0c             	sub    $0xc,%esp
    384e:	68 9a 58 00 00       	push   $0x589a
    3853:	e8 8a 0f 00 00       	call   47e2 <unlink>
    3858:	83 c4 10             	add    $0x10,%esp
    385b:	85 c0                	test   %eax,%eax
    385d:	0f 84 ff 00 00 00    	je     3962 <dirfile+0x1b6>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    3863:	83 ec 08             	sub    $0x8,%esp
    3866:	68 9a 58 00 00       	push   $0x589a
    386b:	68 fe 58 00 00       	push   $0x58fe
    3870:	e8 7d 0f 00 00       	call   47f2 <link>
    3875:	83 c4 10             	add    $0x10,%esp
    3878:	85 c0                	test   %eax,%eax
    387a:	0f 84 f6 00 00 00    	je     3976 <dirfile+0x1ca>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    3880:	83 ec 0c             	sub    $0xc,%esp
    3883:	68 61 58 00 00       	push   $0x5861
    3888:	e8 55 0f 00 00       	call   47e2 <unlink>
    388d:	83 c4 10             	add    $0x10,%esp
    3890:	85 c0                	test   %eax,%eax
    3892:	0f 85 f2 00 00 00    	jne    398a <dirfile+0x1de>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    3898:	83 ec 08             	sub    $0x8,%esp
    389b:	6a 02                	push   $0x2
    389d:	68 5a 54 00 00       	push   $0x545a
    38a2:	e8 2b 0f 00 00       	call   47d2 <open>
  if(fd >= 0){
    38a7:	83 c4 10             	add    $0x10,%esp
    38aa:	85 c0                	test   %eax,%eax
    38ac:	0f 89 ec 00 00 00    	jns    399e <dirfile+0x1f2>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    38b2:	83 ec 08             	sub    $0x8,%esp
    38b5:	6a 00                	push   $0x0
    38b7:	68 5a 54 00 00       	push   $0x545a
    38bc:	e8 11 0f 00 00       	call   47d2 <open>
    38c1:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    38c3:	83 c4 0c             	add    $0xc,%esp
    38c6:	6a 01                	push   $0x1
    38c8:	68 3d 55 00 00       	push   $0x553d
    38cd:	50                   	push   %eax
    38ce:	e8 df 0e 00 00       	call   47b2 <write>
    38d3:	83 c4 10             	add    $0x10,%esp
    38d6:	85 c0                	test   %eax,%eax
    38d8:	0f 8f d4 00 00 00    	jg     39b2 <dirfile+0x206>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    38de:	83 ec 0c             	sub    $0xc,%esp
    38e1:	53                   	push   %ebx
    38e2:	e8 d3 0e 00 00       	call   47ba <close>

  printf(1, "dir vs file OK\n");
    38e7:	83 c4 08             	add    $0x8,%esp
    38ea:	68 31 59 00 00       	push   $0x5931
    38ef:	6a 01                	push   $0x1
    38f1:	e8 d6 0f 00 00       	call   48cc <printf>
}
    38f6:	83 c4 10             	add    $0x10,%esp
    38f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    38fc:	c9                   	leave  
    38fd:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    38fe:	83 ec 08             	sub    $0x8,%esp
    3901:	68 69 58 00 00       	push   $0x5869
    3906:	6a 01                	push   $0x1
    3908:	e8 bf 0f 00 00       	call   48cc <printf>
    exit();
    390d:	e8 80 0e 00 00       	call   4792 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    3912:	83 ec 08             	sub    $0x8,%esp
    3915:	68 80 58 00 00       	push   $0x5880
    391a:	6a 01                	push   $0x1
    391c:	e8 ab 0f 00 00       	call   48cc <printf>
    exit();
    3921:	e8 6c 0e 00 00       	call   4792 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    3926:	83 ec 08             	sub    $0x8,%esp
    3929:	68 a5 58 00 00       	push   $0x58a5
    392e:	6a 01                	push   $0x1
    3930:	e8 97 0f 00 00       	call   48cc <printf>
    exit();
    3935:	e8 58 0e 00 00       	call   4792 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    393a:	83 ec 08             	sub    $0x8,%esp
    393d:	68 a5 58 00 00       	push   $0x58a5
    3942:	6a 01                	push   $0x1
    3944:	e8 83 0f 00 00       	call   48cc <printf>
    exit();
    3949:	e8 44 0e 00 00       	call   4792 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    394e:	83 ec 08             	sub    $0x8,%esp
    3951:	68 c3 58 00 00       	push   $0x58c3
    3956:	6a 01                	push   $0x1
    3958:	e8 6f 0f 00 00       	call   48cc <printf>
    exit();
    395d:	e8 30 0e 00 00       	call   4792 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    3962:	83 ec 08             	sub    $0x8,%esp
    3965:	68 e0 58 00 00       	push   $0x58e0
    396a:	6a 01                	push   $0x1
    396c:	e8 5b 0f 00 00       	call   48cc <printf>
    exit();
    3971:	e8 1c 0e 00 00       	call   4792 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    3976:	83 ec 08             	sub    $0x8,%esp
    3979:	68 f4 60 00 00       	push   $0x60f4
    397e:	6a 01                	push   $0x1
    3980:	e8 47 0f 00 00       	call   48cc <printf>
    exit();
    3985:	e8 08 0e 00 00       	call   4792 <exit>
    printf(1, "unlink dirfile failed!\n");
    398a:	83 ec 08             	sub    $0x8,%esp
    398d:	68 05 59 00 00       	push   $0x5905
    3992:	6a 01                	push   $0x1
    3994:	e8 33 0f 00 00       	call   48cc <printf>
    exit();
    3999:	e8 f4 0d 00 00       	call   4792 <exit>
    printf(1, "open . for writing succeeded!\n");
    399e:	83 ec 08             	sub    $0x8,%esp
    39a1:	68 14 61 00 00       	push   $0x6114
    39a6:	6a 01                	push   $0x1
    39a8:	e8 1f 0f 00 00       	call   48cc <printf>
    exit();
    39ad:	e8 e0 0d 00 00       	call   4792 <exit>
    printf(1, "write . succeeded!\n");
    39b2:	83 ec 08             	sub    $0x8,%esp
    39b5:	68 1d 59 00 00       	push   $0x591d
    39ba:	6a 01                	push   $0x1
    39bc:	e8 0b 0f 00 00       	call   48cc <printf>
    exit();
    39c1:	e8 cc 0d 00 00       	call   4792 <exit>

000039c6 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    39c6:	55                   	push   %ebp
    39c7:	89 e5                	mov    %esp,%ebp
    39c9:	53                   	push   %ebx
    39ca:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    39cd:	68 41 59 00 00       	push   $0x5941
    39d2:	6a 01                	push   $0x1
    39d4:	e8 f3 0e 00 00       	call   48cc <printf>
    39d9:	83 c4 10             	add    $0x10,%esp
    39dc:	bb 33 00 00 00       	mov    $0x33,%ebx
    39e1:	eb 4f                	jmp    3a32 <iref+0x6c>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    39e3:	83 ec 08             	sub    $0x8,%esp
    39e6:	68 58 59 00 00       	push   $0x5958
    39eb:	6a 01                	push   $0x1
    39ed:	e8 da 0e 00 00       	call   48cc <printf>
      exit();
    39f2:	e8 9b 0d 00 00       	call   4792 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    39f7:	83 ec 08             	sub    $0x8,%esp
    39fa:	68 6c 59 00 00       	push   $0x596c
    39ff:	6a 01                	push   $0x1
    3a01:	e8 c6 0e 00 00       	call   48cc <printf>
      exit();
    3a06:	e8 87 0d 00 00       	call   4792 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    3a0b:	83 ec 0c             	sub    $0xc,%esp
    3a0e:	50                   	push   %eax
    3a0f:	e8 a6 0d 00 00       	call   47ba <close>
    3a14:	83 c4 10             	add    $0x10,%esp
    3a17:	eb 7d                	jmp    3a96 <iref+0xd0>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    3a19:	83 ec 0c             	sub    $0xc,%esp
    3a1c:	68 3c 55 00 00       	push   $0x553c
    3a21:	e8 bc 0d 00 00       	call   47e2 <unlink>
  for(i = 0; i < 50 + 1; i++){
    3a26:	83 c4 10             	add    $0x10,%esp
    3a29:	83 eb 01             	sub    $0x1,%ebx
    3a2c:	0f 84 92 00 00 00    	je     3ac4 <iref+0xfe>
    if(mkdir("irefd") != 0){
    3a32:	83 ec 0c             	sub    $0xc,%esp
    3a35:	68 52 59 00 00       	push   $0x5952
    3a3a:	e8 bb 0d 00 00       	call   47fa <mkdir>
    3a3f:	83 c4 10             	add    $0x10,%esp
    3a42:	85 c0                	test   %eax,%eax
    3a44:	75 9d                	jne    39e3 <iref+0x1d>
    if(chdir("irefd") != 0){
    3a46:	83 ec 0c             	sub    $0xc,%esp
    3a49:	68 52 59 00 00       	push   $0x5952
    3a4e:	e8 af 0d 00 00       	call   4802 <chdir>
    3a53:	83 c4 10             	add    $0x10,%esp
    3a56:	85 c0                	test   %eax,%eax
    3a58:	75 9d                	jne    39f7 <iref+0x31>
    mkdir("");
    3a5a:	83 ec 0c             	sub    $0xc,%esp
    3a5d:	68 07 50 00 00       	push   $0x5007
    3a62:	e8 93 0d 00 00       	call   47fa <mkdir>
    link("README", "");
    3a67:	83 c4 08             	add    $0x8,%esp
    3a6a:	68 07 50 00 00       	push   $0x5007
    3a6f:	68 fe 58 00 00       	push   $0x58fe
    3a74:	e8 79 0d 00 00       	call   47f2 <link>
    fd = open("", O_CREATE);
    3a79:	83 c4 08             	add    $0x8,%esp
    3a7c:	68 00 02 00 00       	push   $0x200
    3a81:	68 07 50 00 00       	push   $0x5007
    3a86:	e8 47 0d 00 00       	call   47d2 <open>
    if(fd >= 0)
    3a8b:	83 c4 10             	add    $0x10,%esp
    3a8e:	85 c0                	test   %eax,%eax
    3a90:	0f 89 75 ff ff ff    	jns    3a0b <iref+0x45>
    fd = open("xx", O_CREATE);
    3a96:	83 ec 08             	sub    $0x8,%esp
    3a99:	68 00 02 00 00       	push   $0x200
    3a9e:	68 3c 55 00 00       	push   $0x553c
    3aa3:	e8 2a 0d 00 00       	call   47d2 <open>
    if(fd >= 0)
    3aa8:	83 c4 10             	add    $0x10,%esp
    3aab:	85 c0                	test   %eax,%eax
    3aad:	0f 88 66 ff ff ff    	js     3a19 <iref+0x53>
      close(fd);
    3ab3:	83 ec 0c             	sub    $0xc,%esp
    3ab6:	50                   	push   %eax
    3ab7:	e8 fe 0c 00 00       	call   47ba <close>
    3abc:	83 c4 10             	add    $0x10,%esp
    3abf:	e9 55 ff ff ff       	jmp    3a19 <iref+0x53>
  }

  chdir("/");
    3ac4:	83 ec 0c             	sub    $0xc,%esp
    3ac7:	68 2d 4c 00 00       	push   $0x4c2d
    3acc:	e8 31 0d 00 00       	call   4802 <chdir>
  printf(1, "empty file name OK\n");
    3ad1:	83 c4 08             	add    $0x8,%esp
    3ad4:	68 80 59 00 00       	push   $0x5980
    3ad9:	6a 01                	push   $0x1
    3adb:	e8 ec 0d 00 00       	call   48cc <printf>
}
    3ae0:	83 c4 10             	add    $0x10,%esp
    3ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3ae6:	c9                   	leave  
    3ae7:	c3                   	ret    

00003ae8 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3ae8:	55                   	push   %ebp
    3ae9:	89 e5                	mov    %esp,%ebp
    3aeb:	53                   	push   %ebx
    3aec:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    3aef:	68 94 59 00 00       	push   $0x5994
    3af4:	6a 01                	push   $0x1
    3af6:	e8 d1 0d 00 00       	call   48cc <printf>
    3afb:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    3afe:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    3b03:	e8 82 0c 00 00       	call   478a <fork>
    if(pid < 0)
    3b08:	85 c0                	test   %eax,%eax
    3b0a:	78 28                	js     3b34 <forktest+0x4c>
      break;
    if(pid == 0)
    3b0c:	85 c0                	test   %eax,%eax
    3b0e:	74 1f                	je     3b2f <forktest+0x47>
  for(n=0; n<1000; n++){
    3b10:	83 c3 01             	add    $0x1,%ebx
    3b13:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    3b19:	75 e8                	jne    3b03 <forktest+0x1b>
      exit();
  }

  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    3b1b:	83 ec 08             	sub    $0x8,%esp
    3b1e:	68 34 61 00 00       	push   $0x6134
    3b23:	6a 01                	push   $0x1
    3b25:	e8 a2 0d 00 00       	call   48cc <printf>
    exit();
    3b2a:	e8 63 0c 00 00       	call   4792 <exit>
      exit();
    3b2f:	e8 5e 0c 00 00       	call   4792 <exit>
  if(n == 1000){
    3b34:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    3b3a:	74 df                	je     3b1b <forktest+0x33>
  }

  for(; n > 0; n--){
    3b3c:	85 db                	test   %ebx,%ebx
    3b3e:	7e 0e                	jle    3b4e <forktest+0x66>
    if(wait() < 0){
    3b40:	e8 55 0c 00 00       	call   479a <wait>
    3b45:	85 c0                	test   %eax,%eax
    3b47:	78 26                	js     3b6f <forktest+0x87>
  for(; n > 0; n--){
    3b49:	83 eb 01             	sub    $0x1,%ebx
    3b4c:	75 f2                	jne    3b40 <forktest+0x58>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    3b4e:	e8 47 0c 00 00       	call   479a <wait>
    3b53:	83 f8 ff             	cmp    $0xffffffff,%eax
    3b56:	75 2b                	jne    3b83 <forktest+0x9b>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    3b58:	83 ec 08             	sub    $0x8,%esp
    3b5b:	68 c6 59 00 00       	push   $0x59c6
    3b60:	6a 01                	push   $0x1
    3b62:	e8 65 0d 00 00       	call   48cc <printf>
}
    3b67:	83 c4 10             	add    $0x10,%esp
    3b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b6d:	c9                   	leave  
    3b6e:	c3                   	ret    
      printf(1, "wait stopped early\n");
    3b6f:	83 ec 08             	sub    $0x8,%esp
    3b72:	68 9f 59 00 00       	push   $0x599f
    3b77:	6a 01                	push   $0x1
    3b79:	e8 4e 0d 00 00       	call   48cc <printf>
      exit();
    3b7e:	e8 0f 0c 00 00       	call   4792 <exit>
    printf(1, "wait got too many\n");
    3b83:	83 ec 08             	sub    $0x8,%esp
    3b86:	68 b3 59 00 00       	push   $0x59b3
    3b8b:	6a 01                	push   $0x1
    3b8d:	e8 3a 0d 00 00       	call   48cc <printf>
    exit();
    3b92:	e8 fb 0b 00 00       	call   4792 <exit>

00003b97 <sbrktest>:

void
sbrktest(void)
{
    3b97:	55                   	push   %ebp
    3b98:	89 e5                	mov    %esp,%ebp
    3b9a:	57                   	push   %edi
    3b9b:	56                   	push   %esi
    3b9c:	53                   	push   %ebx
    3b9d:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3ba0:	68 d4 59 00 00       	push   $0x59d4
    3ba5:	ff 35 14 6c 00 00    	pushl  0x6c14
    3bab:	e8 1c 0d 00 00       	call   48cc <printf>
  oldbrk = sbrk(0);
    3bb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3bb7:	e8 5e 0c 00 00       	call   481a <sbrk>
    3bbc:	89 c3                	mov    %eax,%ebx

  // can one sbrk() less than a page?
  a = sbrk(0);
    3bbe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3bc5:	e8 50 0c 00 00       	call   481a <sbrk>
    3bca:	89 c6                	mov    %eax,%esi
    3bcc:	83 c4 10             	add    $0x10,%esp
  int i;
  for(i = 0; i < 5000; i++){
    3bcf:	bf 00 00 00 00       	mov    $0x0,%edi
    3bd4:	eb 02                	jmp    3bd8 <sbrktest+0x41>
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    a = b + 1;
    3bd6:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    3bd8:	83 ec 0c             	sub    $0xc,%esp
    3bdb:	6a 01                	push   $0x1
    3bdd:	e8 38 0c 00 00       	call   481a <sbrk>
    if(b != a){
    3be2:	83 c4 10             	add    $0x10,%esp
    3be5:	39 f0                	cmp    %esi,%eax
    3be7:	0f 85 8e 01 00 00    	jne    3d7b <sbrktest+0x1e4>
    *b = 1;
    3bed:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    3bf0:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    3bf3:	83 c7 01             	add    $0x1,%edi
    3bf6:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    3bfc:	75 d8                	jne    3bd6 <sbrktest+0x3f>
  }
  pid = fork();
    3bfe:	e8 87 0b 00 00       	call   478a <fork>
    3c03:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    3c05:	85 c0                	test   %eax,%eax
    3c07:	0f 88 8c 01 00 00    	js     3d99 <sbrktest+0x202>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    3c0d:	83 ec 0c             	sub    $0xc,%esp
    3c10:	6a 01                	push   $0x1
    3c12:	e8 03 0c 00 00       	call   481a <sbrk>
  c = sbrk(1);
    3c17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c1e:	e8 f7 0b 00 00       	call   481a <sbrk>
  if(c != a + 1){
    3c23:	83 c6 02             	add    $0x2,%esi
    3c26:	83 c4 10             	add    $0x10,%esp
    3c29:	39 f0                	cmp    %esi,%eax
    3c2b:	0f 85 80 01 00 00    	jne    3db1 <sbrktest+0x21a>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    3c31:	85 ff                	test   %edi,%edi
    3c33:	0f 84 90 01 00 00    	je     3dc9 <sbrktest+0x232>
    exit();
  wait();
    3c39:	e8 5c 0b 00 00       	call   479a <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3c3e:	83 ec 0c             	sub    $0xc,%esp
    3c41:	6a 00                	push   $0x0
    3c43:	e8 d2 0b 00 00       	call   481a <sbrk>
    3c48:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    3c4a:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3c4f:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    3c51:	89 04 24             	mov    %eax,(%esp)
    3c54:	e8 c1 0b 00 00       	call   481a <sbrk>
  if (p != a) {
    3c59:	83 c4 10             	add    $0x10,%esp
    3c5c:	39 c6                	cmp    %eax,%esi
    3c5e:	0f 85 6a 01 00 00    	jne    3dce <sbrktest+0x237>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    3c64:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    3c6b:	83 ec 0c             	sub    $0xc,%esp
    3c6e:	6a 00                	push   $0x0
    3c70:	e8 a5 0b 00 00       	call   481a <sbrk>
    3c75:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    3c77:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3c7e:	e8 97 0b 00 00       	call   481a <sbrk>
  if(c == (char*)0xffffffff){
    3c83:	83 c4 10             	add    $0x10,%esp
    3c86:	83 f8 ff             	cmp    $0xffffffff,%eax
    3c89:	0f 84 57 01 00 00    	je     3de6 <sbrktest+0x24f>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    3c8f:	83 ec 0c             	sub    $0xc,%esp
    3c92:	6a 00                	push   $0x0
    3c94:	e8 81 0b 00 00       	call   481a <sbrk>
  if(c != a - 4096){
    3c99:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    3c9f:	83 c4 10             	add    $0x10,%esp
    3ca2:	39 d0                	cmp    %edx,%eax
    3ca4:	0f 85 54 01 00 00    	jne    3dfe <sbrktest+0x267>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3caa:	83 ec 0c             	sub    $0xc,%esp
    3cad:	6a 00                	push   $0x0
    3caf:	e8 66 0b 00 00       	call   481a <sbrk>
    3cb4:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    3cb6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3cbd:	e8 58 0b 00 00       	call   481a <sbrk>
    3cc2:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    3cc4:	83 c4 10             	add    $0x10,%esp
    3cc7:	39 c6                	cmp    %eax,%esi
    3cc9:	0f 85 46 01 00 00    	jne    3e15 <sbrktest+0x27e>
    3ccf:	83 ec 0c             	sub    $0xc,%esp
    3cd2:	6a 00                	push   $0x0
    3cd4:	e8 41 0b 00 00       	call   481a <sbrk>
    3cd9:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    3cdf:	83 c4 10             	add    $0x10,%esp
    3ce2:	39 d0                	cmp    %edx,%eax
    3ce4:	0f 85 2b 01 00 00    	jne    3e15 <sbrktest+0x27e>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    3cea:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    3cf1:	0f 84 35 01 00 00    	je     3e2c <sbrktest+0x295>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    3cf7:	83 ec 0c             	sub    $0xc,%esp
    3cfa:	6a 00                	push   $0x0
    3cfc:	e8 19 0b 00 00       	call   481a <sbrk>
    3d01:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    3d03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3d0a:	e8 0b 0b 00 00       	call   481a <sbrk>
    3d0f:	89 d9                	mov    %ebx,%ecx
    3d11:	29 c1                	sub    %eax,%ecx
    3d13:	89 0c 24             	mov    %ecx,(%esp)
    3d16:	e8 ff 0a 00 00       	call   481a <sbrk>
  if(c != a){
    3d1b:	83 c4 10             	add    $0x10,%esp
    3d1e:	39 c6                	cmp    %eax,%esi
    3d20:	0f 85 1e 01 00 00    	jne    3e44 <sbrktest+0x2ad>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3d26:	be 00 00 00 80       	mov    $0x80000000,%esi
    ppid = getpid();
    3d2b:	e8 e2 0a 00 00       	call   4812 <getpid>
    3d30:	89 c7                	mov    %eax,%edi
    pid = fork();
    3d32:	e8 53 0a 00 00       	call   478a <fork>
    if(pid < 0){
    3d37:	85 c0                	test   %eax,%eax
    3d39:	0f 88 1c 01 00 00    	js     3e5b <sbrktest+0x2c4>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    3d3f:	85 c0                	test   %eax,%eax
    3d41:	0f 84 2c 01 00 00    	je     3e73 <sbrktest+0x2dc>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    3d47:	e8 4e 0a 00 00       	call   479a <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3d4c:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    3d52:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    3d58:	75 d1                	jne    3d2b <sbrktest+0x194>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3d5a:	83 ec 0c             	sub    $0xc,%esp
    3d5d:	8d 45 e0             	lea    -0x20(%ebp),%eax
    3d60:	50                   	push   %eax
    3d61:	e8 3c 0a 00 00       	call   47a2 <pipe>
    3d66:	83 c4 10             	add    $0x10,%esp
    3d69:	85 c0                	test   %eax,%eax
    3d6b:	0f 85 24 01 00 00    	jne    3e95 <sbrktest+0x2fe>
    3d71:	8d 7d b8             	lea    -0x48(%ebp),%edi
    3d74:	89 fe                	mov    %edi,%esi
    3d76:	e9 78 01 00 00       	jmp    3ef3 <sbrktest+0x35c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3d7b:	83 ec 0c             	sub    $0xc,%esp
    3d7e:	50                   	push   %eax
    3d7f:	56                   	push   %esi
    3d80:	57                   	push   %edi
    3d81:	68 df 59 00 00       	push   $0x59df
    3d86:	ff 35 14 6c 00 00    	pushl  0x6c14
    3d8c:	e8 3b 0b 00 00       	call   48cc <printf>
      exit();
    3d91:	83 c4 20             	add    $0x20,%esp
    3d94:	e8 f9 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk test fork failed\n");
    3d99:	83 ec 08             	sub    $0x8,%esp
    3d9c:	68 fa 59 00 00       	push   $0x59fa
    3da1:	ff 35 14 6c 00 00    	pushl  0x6c14
    3da7:	e8 20 0b 00 00       	call   48cc <printf>
    exit();
    3dac:	e8 e1 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    3db1:	83 ec 08             	sub    $0x8,%esp
    3db4:	68 11 5a 00 00       	push   $0x5a11
    3db9:	ff 35 14 6c 00 00    	pushl  0x6c14
    3dbf:	e8 08 0b 00 00       	call   48cc <printf>
    exit();
    3dc4:	e8 c9 09 00 00       	call   4792 <exit>
    exit();
    3dc9:	e8 c4 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3dce:	83 ec 08             	sub    $0x8,%esp
    3dd1:	68 58 61 00 00       	push   $0x6158
    3dd6:	ff 35 14 6c 00 00    	pushl  0x6c14
    3ddc:	e8 eb 0a 00 00       	call   48cc <printf>
    exit();
    3de1:	e8 ac 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    3de6:	83 ec 08             	sub    $0x8,%esp
    3de9:	68 2d 5a 00 00       	push   $0x5a2d
    3dee:	ff 35 14 6c 00 00    	pushl  0x6c14
    3df4:	e8 d3 0a 00 00       	call   48cc <printf>
    exit();
    3df9:	e8 94 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3dfe:	50                   	push   %eax
    3dff:	56                   	push   %esi
    3e00:	68 98 61 00 00       	push   $0x6198
    3e05:	ff 35 14 6c 00 00    	pushl  0x6c14
    3e0b:	e8 bc 0a 00 00       	call   48cc <printf>
    exit();
    3e10:	e8 7d 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3e15:	57                   	push   %edi
    3e16:	56                   	push   %esi
    3e17:	68 d0 61 00 00       	push   $0x61d0
    3e1c:	ff 35 14 6c 00 00    	pushl  0x6c14
    3e22:	e8 a5 0a 00 00       	call   48cc <printf>
    exit();
    3e27:	e8 66 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3e2c:	83 ec 08             	sub    $0x8,%esp
    3e2f:	68 f8 61 00 00       	push   $0x61f8
    3e34:	ff 35 14 6c 00 00    	pushl  0x6c14
    3e3a:	e8 8d 0a 00 00       	call   48cc <printf>
    exit();
    3e3f:	e8 4e 09 00 00       	call   4792 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3e44:	50                   	push   %eax
    3e45:	56                   	push   %esi
    3e46:	68 28 62 00 00       	push   $0x6228
    3e4b:	ff 35 14 6c 00 00    	pushl  0x6c14
    3e51:	e8 76 0a 00 00       	call   48cc <printf>
    exit();
    3e56:	e8 37 09 00 00       	call   4792 <exit>
      printf(stdout, "fork failed\n");
    3e5b:	83 ec 08             	sub    $0x8,%esp
    3e5e:	68 25 5b 00 00       	push   $0x5b25
    3e63:	ff 35 14 6c 00 00    	pushl  0x6c14
    3e69:	e8 5e 0a 00 00       	call   48cc <printf>
      exit();
    3e6e:	e8 1f 09 00 00       	call   4792 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3e73:	0f be 06             	movsbl (%esi),%eax
    3e76:	50                   	push   %eax
    3e77:	56                   	push   %esi
    3e78:	68 48 5a 00 00       	push   $0x5a48
    3e7d:	ff 35 14 6c 00 00    	pushl  0x6c14
    3e83:	e8 44 0a 00 00       	call   48cc <printf>
      kill(ppid);
    3e88:	89 3c 24             	mov    %edi,(%esp)
    3e8b:	e8 32 09 00 00       	call   47c2 <kill>
      exit();
    3e90:	e8 fd 08 00 00       	call   4792 <exit>
    printf(1, "pipe() failed\n");
    3e95:	83 ec 08             	sub    $0x8,%esp
    3e98:	68 1d 4f 00 00       	push   $0x4f1d
    3e9d:	6a 01                	push   $0x1
    3e9f:	e8 28 0a 00 00       	call   48cc <printf>
    exit();
    3ea4:	e8 e9 08 00 00       	call   4792 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3ea9:	83 ec 0c             	sub    $0xc,%esp
    3eac:	6a 00                	push   $0x0
    3eae:	e8 67 09 00 00       	call   481a <sbrk>
    3eb3:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3eb8:	29 c2                	sub    %eax,%edx
    3eba:	89 14 24             	mov    %edx,(%esp)
    3ebd:	e8 58 09 00 00       	call   481a <sbrk>
      write(fds[1], "x", 1);
    3ec2:	83 c4 0c             	add    $0xc,%esp
    3ec5:	6a 01                	push   $0x1
    3ec7:	68 3d 55 00 00       	push   $0x553d
    3ecc:	ff 75 e4             	pushl  -0x1c(%ebp)
    3ecf:	e8 de 08 00 00       	call   47b2 <write>
    3ed4:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    3ed7:	83 ec 0c             	sub    $0xc,%esp
    3eda:	68 e8 03 00 00       	push   $0x3e8
    3edf:	e8 3e 09 00 00       	call   4822 <sleep>
    3ee4:	83 c4 10             	add    $0x10,%esp
    3ee7:	eb ee                	jmp    3ed7 <sbrktest+0x340>
    3ee9:	83 c6 04             	add    $0x4,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3eec:	8d 45 e0             	lea    -0x20(%ebp),%eax
    3eef:	39 c6                	cmp    %eax,%esi
    3ef1:	74 26                	je     3f19 <sbrktest+0x382>
    if((pids[i] = fork()) == 0){
    3ef3:	e8 92 08 00 00       	call   478a <fork>
    3ef8:	89 06                	mov    %eax,(%esi)
    3efa:	85 c0                	test   %eax,%eax
    3efc:	74 ab                	je     3ea9 <sbrktest+0x312>
    }
    if(pids[i] != -1)
    3efe:	83 f8 ff             	cmp    $0xffffffff,%eax
    3f01:	74 e6                	je     3ee9 <sbrktest+0x352>
      read(fds[0], &scratch, 1);
    3f03:	83 ec 04             	sub    $0x4,%esp
    3f06:	6a 01                	push   $0x1
    3f08:	8d 45 b7             	lea    -0x49(%ebp),%eax
    3f0b:	50                   	push   %eax
    3f0c:	ff 75 e0             	pushl  -0x20(%ebp)
    3f0f:	e8 96 08 00 00       	call   47aa <read>
    3f14:	83 c4 10             	add    $0x10,%esp
    3f17:	eb d0                	jmp    3ee9 <sbrktest+0x352>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3f19:	83 ec 0c             	sub    $0xc,%esp
    3f1c:	68 00 10 00 00       	push   $0x1000
    3f21:	e8 f4 08 00 00       	call   481a <sbrk>
    3f26:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    3f29:	83 c4 10             	add    $0x10,%esp
    3f2c:	eb 07                	jmp    3f35 <sbrktest+0x39e>
    3f2e:	83 c7 04             	add    $0x4,%edi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3f31:	39 fe                	cmp    %edi,%esi
    3f33:	74 1a                	je     3f4f <sbrktest+0x3b8>
    if(pids[i] == -1)
    3f35:	8b 07                	mov    (%edi),%eax
    3f37:	83 f8 ff             	cmp    $0xffffffff,%eax
    3f3a:	74 f2                	je     3f2e <sbrktest+0x397>
      continue;
    kill(pids[i]);
    3f3c:	83 ec 0c             	sub    $0xc,%esp
    3f3f:	50                   	push   %eax
    3f40:	e8 7d 08 00 00       	call   47c2 <kill>
    wait();
    3f45:	e8 50 08 00 00       	call   479a <wait>
    3f4a:	83 c4 10             	add    $0x10,%esp
    3f4d:	eb df                	jmp    3f2e <sbrktest+0x397>
  }
  if(c == (char*)0xffffffff){
    3f4f:	83 7d a4 ff          	cmpl   $0xffffffff,-0x5c(%ebp)
    3f53:	74 2f                	je     3f84 <sbrktest+0x3ed>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    3f55:	83 ec 0c             	sub    $0xc,%esp
    3f58:	6a 00                	push   $0x0
    3f5a:	e8 bb 08 00 00       	call   481a <sbrk>
    3f5f:	83 c4 10             	add    $0x10,%esp
    3f62:	39 d8                	cmp    %ebx,%eax
    3f64:	77 36                	ja     3f9c <sbrktest+0x405>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    3f66:	83 ec 08             	sub    $0x8,%esp
    3f69:	68 7c 5a 00 00       	push   $0x5a7c
    3f6e:	ff 35 14 6c 00 00    	pushl  0x6c14
    3f74:	e8 53 09 00 00       	call   48cc <printf>
}
    3f79:	83 c4 10             	add    $0x10,%esp
    3f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3f7f:	5b                   	pop    %ebx
    3f80:	5e                   	pop    %esi
    3f81:	5f                   	pop    %edi
    3f82:	5d                   	pop    %ebp
    3f83:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    3f84:	83 ec 08             	sub    $0x8,%esp
    3f87:	68 61 5a 00 00       	push   $0x5a61
    3f8c:	ff 35 14 6c 00 00    	pushl  0x6c14
    3f92:	e8 35 09 00 00       	call   48cc <printf>
    exit();
    3f97:	e8 f6 07 00 00       	call   4792 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    3f9c:	83 ec 0c             	sub    $0xc,%esp
    3f9f:	6a 00                	push   $0x0
    3fa1:	e8 74 08 00 00       	call   481a <sbrk>
    3fa6:	29 c3                	sub    %eax,%ebx
    3fa8:	89 1c 24             	mov    %ebx,(%esp)
    3fab:	e8 6a 08 00 00       	call   481a <sbrk>
    3fb0:	83 c4 10             	add    $0x10,%esp
    3fb3:	eb b1                	jmp    3f66 <sbrktest+0x3cf>

00003fb5 <validateint>:

void
validateint(int *p)
{
    3fb5:	55                   	push   %ebp
    3fb6:	89 e5                	mov    %esp,%ebp
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3fb8:	5d                   	pop    %ebp
    3fb9:	c3                   	ret    

00003fba <validatetest>:

void
validatetest(void)
{
    3fba:	55                   	push   %ebp
    3fbb:	89 e5                	mov    %esp,%ebp
    3fbd:	56                   	push   %esi
    3fbe:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3fbf:	83 ec 08             	sub    $0x8,%esp
    3fc2:	68 8a 5a 00 00       	push   $0x5a8a
    3fc7:	ff 35 14 6c 00 00    	pushl  0x6c14
    3fcd:	e8 fa 08 00 00       	call   48cc <printf>
    3fd2:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
  //For Project2 Null Pointer: change p in for loop from 0 to 4096
  for(p = 4096; p <= (uint)hi; p += 4096){
    3fd5:	bb 00 10 00 00       	mov    $0x1000,%ebx
    if((pid = fork()) == 0){
    3fda:	e8 ab 07 00 00       	call   478a <fork>
    3fdf:	89 c6                	mov    %eax,%esi
    3fe1:	85 c0                	test   %eax,%eax
    3fe3:	74 64                	je     4049 <validatetest+0x8f>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
    3fe5:	83 ec 0c             	sub    $0xc,%esp
    3fe8:	6a 00                	push   $0x0
    3fea:	e8 33 08 00 00       	call   4822 <sleep>
    sleep(0);
    3fef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3ff6:	e8 27 08 00 00       	call   4822 <sleep>
    kill(pid);
    3ffb:	89 34 24             	mov    %esi,(%esp)
    3ffe:	e8 bf 07 00 00       	call   47c2 <kill>
    wait();
    4003:	e8 92 07 00 00       	call   479a <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    4008:	83 c4 08             	add    $0x8,%esp
    400b:	53                   	push   %ebx
    400c:	68 99 5a 00 00       	push   $0x5a99
    4011:	e8 dc 07 00 00       	call   47f2 <link>
    4016:	83 c4 10             	add    $0x10,%esp
    4019:	83 f8 ff             	cmp    $0xffffffff,%eax
    401c:	75 30                	jne    404e <validatetest+0x94>
  for(p = 4096; p <= (uint)hi; p += 4096){
    401e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    4024:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    402a:	75 ae                	jne    3fda <validatetest+0x20>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    402c:	83 ec 08             	sub    $0x8,%esp
    402f:	68 bd 5a 00 00       	push   $0x5abd
    4034:	ff 35 14 6c 00 00    	pushl  0x6c14
    403a:	e8 8d 08 00 00       	call   48cc <printf>
}
    403f:	83 c4 10             	add    $0x10,%esp
    4042:	8d 65 f8             	lea    -0x8(%ebp),%esp
    4045:	5b                   	pop    %ebx
    4046:	5e                   	pop    %esi
    4047:	5d                   	pop    %ebp
    4048:	c3                   	ret    
      exit();
    4049:	e8 44 07 00 00       	call   4792 <exit>
      printf(stdout, "link should not succeed\n");
    404e:	83 ec 08             	sub    $0x8,%esp
    4051:	68 a4 5a 00 00       	push   $0x5aa4
    4056:	ff 35 14 6c 00 00    	pushl  0x6c14
    405c:	e8 6b 08 00 00       	call   48cc <printf>
      exit();
    4061:	e8 2c 07 00 00       	call   4792 <exit>

00004066 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    4066:	55                   	push   %ebp
    4067:	89 e5                	mov    %esp,%ebp
    4069:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    406c:	68 ca 5a 00 00       	push   $0x5aca
    4071:	ff 35 14 6c 00 00    	pushl  0x6c14
    4077:	e8 50 08 00 00       	call   48cc <printf>
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
    407c:	83 c4 10             	add    $0x10,%esp
    407f:	80 3d e0 6c 00 00 00 	cmpb   $0x0,0x6ce0
    4086:	75 30                	jne    40b8 <bsstest+0x52>
  for(i = 0; i < sizeof(uninit); i++){
    4088:	b8 01 00 00 00       	mov    $0x1,%eax
    if(uninit[i] != '\0'){
    408d:	80 b8 e0 6c 00 00 00 	cmpb   $0x0,0x6ce0(%eax)
    4094:	75 22                	jne    40b8 <bsstest+0x52>
  for(i = 0; i < sizeof(uninit); i++){
    4096:	83 c0 01             	add    $0x1,%eax
    4099:	3d 10 27 00 00       	cmp    $0x2710,%eax
    409e:	75 ed                	jne    408d <bsstest+0x27>
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    40a0:	83 ec 08             	sub    $0x8,%esp
    40a3:	68 e5 5a 00 00       	push   $0x5ae5
    40a8:	ff 35 14 6c 00 00    	pushl  0x6c14
    40ae:	e8 19 08 00 00       	call   48cc <printf>
}
    40b3:	83 c4 10             	add    $0x10,%esp
    40b6:	c9                   	leave  
    40b7:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    40b8:	83 ec 08             	sub    $0x8,%esp
    40bb:	68 d4 5a 00 00       	push   $0x5ad4
    40c0:	ff 35 14 6c 00 00    	pushl  0x6c14
    40c6:	e8 01 08 00 00       	call   48cc <printf>
      exit();
    40cb:	e8 c2 06 00 00       	call   4792 <exit>

000040d0 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    40d0:	55                   	push   %ebp
    40d1:	89 e5                	mov    %esp,%ebp
    40d3:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    40d6:	68 f2 5a 00 00       	push   $0x5af2
    40db:	e8 02 07 00 00       	call   47e2 <unlink>
  pid = fork();
    40e0:	e8 a5 06 00 00       	call   478a <fork>
  if(pid == 0){
    40e5:	83 c4 10             	add    $0x10,%esp
    40e8:	85 c0                	test   %eax,%eax
    40ea:	74 41                	je     412d <bigargtest+0x5d>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    40ec:	85 c0                	test   %eax,%eax
    40ee:	0f 88 b1 00 00 00    	js     41a5 <bigargtest+0xd5>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    40f4:	e8 a1 06 00 00       	call   479a <wait>
  fd = open("bigarg-ok", 0);
    40f9:	83 ec 08             	sub    $0x8,%esp
    40fc:	6a 00                	push   $0x0
    40fe:	68 f2 5a 00 00       	push   $0x5af2
    4103:	e8 ca 06 00 00       	call   47d2 <open>
  if(fd < 0){
    4108:	83 c4 10             	add    $0x10,%esp
    410b:	85 c0                	test   %eax,%eax
    410d:	0f 88 aa 00 00 00    	js     41bd <bigargtest+0xed>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    4113:	83 ec 0c             	sub    $0xc,%esp
    4116:	50                   	push   %eax
    4117:	e8 9e 06 00 00       	call   47ba <close>
  unlink("bigarg-ok");
    411c:	c7 04 24 f2 5a 00 00 	movl   $0x5af2,(%esp)
    4123:	e8 ba 06 00 00       	call   47e2 <unlink>
}
    4128:	83 c4 10             	add    $0x10,%esp
    412b:	c9                   	leave  
    412c:	c3                   	ret    
    412d:	b8 40 6c 00 00       	mov    $0x6c40,%eax
    4132:	ba bc 6c 00 00       	mov    $0x6cbc,%edx
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    4137:	c7 00 4c 62 00 00    	movl   $0x624c,(%eax)
    413d:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < MAXARG-1; i++)
    4140:	39 d0                	cmp    %edx,%eax
    4142:	75 f3                	jne    4137 <bigargtest+0x67>
    args[MAXARG-1] = 0;
    4144:	c7 05 bc 6c 00 00 00 	movl   $0x0,0x6cbc
    414b:	00 00 00 
    printf(stdout, "bigarg test\n");
    414e:	83 ec 08             	sub    $0x8,%esp
    4151:	68 fc 5a 00 00       	push   $0x5afc
    4156:	ff 35 14 6c 00 00    	pushl  0x6c14
    415c:	e8 6b 07 00 00       	call   48cc <printf>
    exec("echo", args);
    4161:	83 c4 08             	add    $0x8,%esp
    4164:	68 40 6c 00 00       	push   $0x6c40
    4169:	68 c9 4c 00 00       	push   $0x4cc9
    416e:	e8 57 06 00 00       	call   47ca <exec>
    printf(stdout, "bigarg test ok\n");
    4173:	83 c4 08             	add    $0x8,%esp
    4176:	68 09 5b 00 00       	push   $0x5b09
    417b:	ff 35 14 6c 00 00    	pushl  0x6c14
    4181:	e8 46 07 00 00       	call   48cc <printf>
    fd = open("bigarg-ok", O_CREATE);
    4186:	83 c4 08             	add    $0x8,%esp
    4189:	68 00 02 00 00       	push   $0x200
    418e:	68 f2 5a 00 00       	push   $0x5af2
    4193:	e8 3a 06 00 00       	call   47d2 <open>
    close(fd);
    4198:	89 04 24             	mov    %eax,(%esp)
    419b:	e8 1a 06 00 00       	call   47ba <close>
    exit();
    41a0:	e8 ed 05 00 00       	call   4792 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    41a5:	83 ec 08             	sub    $0x8,%esp
    41a8:	68 19 5b 00 00       	push   $0x5b19
    41ad:	ff 35 14 6c 00 00    	pushl  0x6c14
    41b3:	e8 14 07 00 00       	call   48cc <printf>
    exit();
    41b8:	e8 d5 05 00 00       	call   4792 <exit>
    printf(stdout, "bigarg test failed!\n");
    41bd:	83 ec 08             	sub    $0x8,%esp
    41c0:	68 32 5b 00 00       	push   $0x5b32
    41c5:	ff 35 14 6c 00 00    	pushl  0x6c14
    41cb:	e8 fc 06 00 00       	call   48cc <printf>
    exit();
    41d0:	e8 bd 05 00 00       	call   4792 <exit>

000041d5 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    41d5:	55                   	push   %ebp
    41d6:	89 e5                	mov    %esp,%ebp
    41d8:	57                   	push   %edi
    41d9:	56                   	push   %esi
    41da:	53                   	push   %ebx
    41db:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    41de:	68 47 5b 00 00       	push   $0x5b47
    41e3:	6a 01                	push   $0x1
    41e5:	e8 e2 06 00 00       	call   48cc <printf>
    41ea:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    41ed:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    41f2:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    41f6:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    41fb:	f7 eb                	imul   %ebx
    41fd:	c1 fa 06             	sar    $0x6,%edx
    4200:	89 de                	mov    %ebx,%esi
    4202:	c1 fe 1f             	sar    $0x1f,%esi
    4205:	29 f2                	sub    %esi,%edx
    4207:	8d 42 30             	lea    0x30(%edx),%eax
    420a:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    420d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    4213:	89 d9                	mov    %ebx,%ecx
    4215:	29 d1                	sub    %edx,%ecx
    4217:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    421c:	f7 e9                	imul   %ecx
    421e:	c1 fa 05             	sar    $0x5,%edx
    4221:	c1 f9 1f             	sar    $0x1f,%ecx
    4224:	29 ca                	sub    %ecx,%edx
    4226:	83 c2 30             	add    $0x30,%edx
    4229:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    422c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    4231:	f7 eb                	imul   %ebx
    4233:	c1 fa 05             	sar    $0x5,%edx
    4236:	29 f2                	sub    %esi,%edx
    4238:	6b d2 64             	imul   $0x64,%edx,%edx
    423b:	89 df                	mov    %ebx,%edi
    423d:	29 d7                	sub    %edx,%edi
    423f:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    4244:	89 f8                	mov    %edi,%eax
    4246:	f7 e9                	imul   %ecx
    4248:	c1 fa 02             	sar    $0x2,%edx
    424b:	c1 ff 1f             	sar    $0x1f,%edi
    424e:	29 fa                	sub    %edi,%edx
    4250:	83 c2 30             	add    $0x30,%edx
    4253:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    4256:	89 d8                	mov    %ebx,%eax
    4258:	f7 e9                	imul   %ecx
    425a:	c1 fa 02             	sar    $0x2,%edx
    425d:	29 f2                	sub    %esi,%edx
    425f:	8d 04 92             	lea    (%edx,%edx,4),%eax
    4262:	01 c0                	add    %eax,%eax
    4264:	89 df                	mov    %ebx,%edi
    4266:	29 c7                	sub    %eax,%edi
    4268:	89 f8                	mov    %edi,%eax
    426a:	83 c0 30             	add    $0x30,%eax
    426d:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    4270:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    4274:	83 ec 04             	sub    $0x4,%esp
    4277:	8d 75 a8             	lea    -0x58(%ebp),%esi
    427a:	56                   	push   %esi
    427b:	68 54 5b 00 00       	push   $0x5b54
    4280:	6a 01                	push   $0x1
    4282:	e8 45 06 00 00       	call   48cc <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4287:	83 c4 08             	add    $0x8,%esp
    428a:	68 02 02 00 00       	push   $0x202
    428f:	56                   	push   %esi
    4290:	e8 3d 05 00 00       	call   47d2 <open>
    4295:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    4297:	83 c4 10             	add    $0x10,%esp
    429a:	85 c0                	test   %eax,%eax
    429c:	0f 89 d5 00 00 00    	jns    4377 <fsfull+0x1a2>
      printf(1, "open %s failed\n", name);
    42a2:	83 ec 04             	sub    $0x4,%esp
    42a5:	8d 45 a8             	lea    -0x58(%ebp),%eax
    42a8:	50                   	push   %eax
    42a9:	68 60 5b 00 00       	push   $0x5b60
    42ae:	6a 01                	push   $0x1
    42b0:	e8 17 06 00 00       	call   48cc <printf>
      break;
    42b5:	83 c4 10             	add    $0x10,%esp
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    42b8:	85 db                	test   %ebx,%ebx
    42ba:	0f 88 9d 00 00 00    	js     435d <fsfull+0x188>
    char name[64];
    name[0] = 'f';
    42c0:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    42c4:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    42c9:	f7 eb                	imul   %ebx
    42cb:	c1 fa 06             	sar    $0x6,%edx
    42ce:	89 de                	mov    %ebx,%esi
    42d0:	c1 fe 1f             	sar    $0x1f,%esi
    42d3:	29 f2                	sub    %esi,%edx
    42d5:	8d 42 30             	lea    0x30(%edx),%eax
    42d8:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    42db:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    42e1:	89 d9                	mov    %ebx,%ecx
    42e3:	29 d1                	sub    %edx,%ecx
    42e5:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    42ea:	f7 e9                	imul   %ecx
    42ec:	c1 fa 05             	sar    $0x5,%edx
    42ef:	c1 f9 1f             	sar    $0x1f,%ecx
    42f2:	29 ca                	sub    %ecx,%edx
    42f4:	83 c2 30             	add    $0x30,%edx
    42f7:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    42fa:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    42ff:	f7 eb                	imul   %ebx
    4301:	c1 fa 05             	sar    $0x5,%edx
    4304:	29 f2                	sub    %esi,%edx
    4306:	6b d2 64             	imul   $0x64,%edx,%edx
    4309:	89 df                	mov    %ebx,%edi
    430b:	29 d7                	sub    %edx,%edi
    430d:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    4312:	89 f8                	mov    %edi,%eax
    4314:	f7 e9                	imul   %ecx
    4316:	c1 fa 02             	sar    $0x2,%edx
    4319:	c1 ff 1f             	sar    $0x1f,%edi
    431c:	29 fa                	sub    %edi,%edx
    431e:	83 c2 30             	add    $0x30,%edx
    4321:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    4324:	89 d8                	mov    %ebx,%eax
    4326:	f7 e9                	imul   %ecx
    4328:	c1 fa 02             	sar    $0x2,%edx
    432b:	29 f2                	sub    %esi,%edx
    432d:	8d 04 92             	lea    (%edx,%edx,4),%eax
    4330:	01 c0                	add    %eax,%eax
    4332:	89 de                	mov    %ebx,%esi
    4334:	29 c6                	sub    %eax,%esi
    4336:	89 f0                	mov    %esi,%eax
    4338:	83 c0 30             	add    $0x30,%eax
    433b:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    433e:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    4342:	83 ec 0c             	sub    $0xc,%esp
    4345:	8d 45 a8             	lea    -0x58(%ebp),%eax
    4348:	50                   	push   %eax
    4349:	e8 94 04 00 00       	call   47e2 <unlink>
    nfiles--;
    434e:	83 eb 01             	sub    $0x1,%ebx
  while(nfiles >= 0){
    4351:	83 c4 10             	add    $0x10,%esp
    4354:	83 fb ff             	cmp    $0xffffffff,%ebx
    4357:	0f 85 63 ff ff ff    	jne    42c0 <fsfull+0xeb>
  }

  printf(1, "fsfull test finished\n");
    435d:	83 ec 08             	sub    $0x8,%esp
    4360:	68 80 5b 00 00       	push   $0x5b80
    4365:	6a 01                	push   $0x1
    4367:	e8 60 05 00 00       	call   48cc <printf>
}
    436c:	83 c4 10             	add    $0x10,%esp
    436f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    4372:	5b                   	pop    %ebx
    4373:	5e                   	pop    %esi
    4374:	5f                   	pop    %edi
    4375:	5d                   	pop    %ebp
    4376:	c3                   	ret    
    int total = 0;
    4377:	bf 00 00 00 00       	mov    $0x0,%edi
    437c:	eb 02                	jmp    4380 <fsfull+0x1ab>
      total += cc;
    437e:	01 c7                	add    %eax,%edi
      int cc = write(fd, buf, 512);
    4380:	83 ec 04             	sub    $0x4,%esp
    4383:	68 00 02 00 00       	push   $0x200
    4388:	68 00 94 00 00       	push   $0x9400
    438d:	56                   	push   %esi
    438e:	e8 1f 04 00 00       	call   47b2 <write>
      if(cc < 512)
    4393:	83 c4 10             	add    $0x10,%esp
    4396:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    439b:	7f e1                	jg     437e <fsfull+0x1a9>
    printf(1, "wrote %d bytes\n", total);
    439d:	83 ec 04             	sub    $0x4,%esp
    43a0:	57                   	push   %edi
    43a1:	68 70 5b 00 00       	push   $0x5b70
    43a6:	6a 01                	push   $0x1
    43a8:	e8 1f 05 00 00       	call   48cc <printf>
    close(fd);
    43ad:	89 34 24             	mov    %esi,(%esp)
    43b0:	e8 05 04 00 00       	call   47ba <close>
    if(total == 0)
    43b5:	83 c4 10             	add    $0x10,%esp
    43b8:	85 ff                	test   %edi,%edi
    43ba:	0f 84 f8 fe ff ff    	je     42b8 <fsfull+0xe3>
  for(nfiles = 0; ; nfiles++){
    43c0:	83 c3 01             	add    $0x1,%ebx
    43c3:	e9 2a fe ff ff       	jmp    41f2 <fsfull+0x1d>

000043c8 <uio>:

void
uio()
{
    43c8:	55                   	push   %ebp
    43c9:	89 e5                	mov    %esp,%ebp
    43cb:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    43ce:	68 96 5b 00 00       	push   $0x5b96
    43d3:	6a 01                	push   $0x1
    43d5:	e8 f2 04 00 00       	call   48cc <printf>
  pid = fork();
    43da:	e8 ab 03 00 00       	call   478a <fork>
  if(pid == 0){
    43df:	83 c4 10             	add    $0x10,%esp
    43e2:	85 c0                	test   %eax,%eax
    43e4:	74 1d                	je     4403 <uio+0x3b>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    43e6:	85 c0                	test   %eax,%eax
    43e8:	78 3e                	js     4428 <uio+0x60>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    43ea:	e8 ab 03 00 00       	call   479a <wait>
  printf(1, "uio test done\n");
    43ef:	83 ec 08             	sub    $0x8,%esp
    43f2:	68 a0 5b 00 00       	push   $0x5ba0
    43f7:	6a 01                	push   $0x1
    43f9:	e8 ce 04 00 00       	call   48cc <printf>
}
    43fe:	83 c4 10             	add    $0x10,%esp
    4401:	c9                   	leave  
    4402:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    4403:	b8 09 00 00 00       	mov    $0x9,%eax
    4408:	ba 70 00 00 00       	mov    $0x70,%edx
    440d:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    440e:	ba 71 00 00 00       	mov    $0x71,%edx
    4413:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    4414:	83 ec 08             	sub    $0x8,%esp
    4417:	68 2c 63 00 00       	push   $0x632c
    441c:	6a 01                	push   $0x1
    441e:	e8 a9 04 00 00       	call   48cc <printf>
    exit();
    4423:	e8 6a 03 00 00       	call   4792 <exit>
    printf (1, "fork failed\n");
    4428:	83 ec 08             	sub    $0x8,%esp
    442b:	68 25 5b 00 00       	push   $0x5b25
    4430:	6a 01                	push   $0x1
    4432:	e8 95 04 00 00       	call   48cc <printf>
    exit();
    4437:	e8 56 03 00 00       	call   4792 <exit>

0000443c <argptest>:

void argptest()
{
    443c:	55                   	push   %ebp
    443d:	89 e5                	mov    %esp,%ebp
    443f:	53                   	push   %ebx
    4440:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    4443:	6a 00                	push   $0x0
    4445:	68 af 5b 00 00       	push   $0x5baf
    444a:	e8 83 03 00 00       	call   47d2 <open>
  if (fd < 0) {
    444f:	83 c4 10             	add    $0x10,%esp
    4452:	85 c0                	test   %eax,%eax
    4454:	78 3a                	js     4490 <argptest+0x54>
    4456:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    4458:	83 ec 0c             	sub    $0xc,%esp
    445b:	6a 00                	push   $0x0
    445d:	e8 b8 03 00 00       	call   481a <sbrk>
    4462:	83 c4 0c             	add    $0xc,%esp
    4465:	6a ff                	push   $0xffffffff
    4467:	83 e8 01             	sub    $0x1,%eax
    446a:	50                   	push   %eax
    446b:	53                   	push   %ebx
    446c:	e8 39 03 00 00       	call   47aa <read>
  close(fd);
    4471:	89 1c 24             	mov    %ebx,(%esp)
    4474:	e8 41 03 00 00       	call   47ba <close>
  printf(1, "arg test passed\n");
    4479:	83 c4 08             	add    $0x8,%esp
    447c:	68 c1 5b 00 00       	push   $0x5bc1
    4481:	6a 01                	push   $0x1
    4483:	e8 44 04 00 00       	call   48cc <printf>
}
    4488:	83 c4 10             	add    $0x10,%esp
    448b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    448e:	c9                   	leave  
    448f:	c3                   	ret    
    printf(2, "open failed\n");
    4490:	83 ec 08             	sub    $0x8,%esp
    4493:	68 b4 5b 00 00       	push   $0x5bb4
    4498:	6a 02                	push   $0x2
    449a:	e8 2d 04 00 00       	call   48cc <printf>
    exit();
    449f:	e8 ee 02 00 00       	call   4792 <exit>

000044a4 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    44a4:	55                   	push   %ebp
    44a5:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    44a7:	69 05 10 6c 00 00 0d 	imul   $0x19660d,0x6c10,%eax
    44ae:	66 19 00 
    44b1:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    44b6:	a3 10 6c 00 00       	mov    %eax,0x6c10
  return randstate;
}
    44bb:	5d                   	pop    %ebp
    44bc:	c3                   	ret    

000044bd <main>:

int
main(int argc, char *argv[])
{
    44bd:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    44c1:	83 e4 f0             	and    $0xfffffff0,%esp
    44c4:	ff 71 fc             	pushl  -0x4(%ecx)
    44c7:	55                   	push   %ebp
    44c8:	89 e5                	mov    %esp,%ebp
    44ca:	51                   	push   %ecx
    44cb:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    44ce:	68 d2 5b 00 00       	push   $0x5bd2
    44d3:	6a 01                	push   $0x1
    44d5:	e8 f2 03 00 00       	call   48cc <printf>

  if(open("usertests.ran", 0) >= 0){
    44da:	83 c4 08             	add    $0x8,%esp
    44dd:	6a 00                	push   $0x0
    44df:	68 e6 5b 00 00       	push   $0x5be6
    44e4:	e8 e9 02 00 00       	call   47d2 <open>
    44e9:	83 c4 10             	add    $0x10,%esp
    44ec:	85 c0                	test   %eax,%eax
    44ee:	78 14                	js     4504 <main+0x47>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    44f0:	83 ec 08             	sub    $0x8,%esp
    44f3:	68 50 63 00 00       	push   $0x6350
    44f8:	6a 01                	push   $0x1
    44fa:	e8 cd 03 00 00       	call   48cc <printf>
    exit();
    44ff:	e8 8e 02 00 00       	call   4792 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    4504:	83 ec 08             	sub    $0x8,%esp
    4507:	68 00 02 00 00       	push   $0x200
    450c:	68 e6 5b 00 00       	push   $0x5be6
    4511:	e8 bc 02 00 00       	call   47d2 <open>
    4516:	89 04 24             	mov    %eax,(%esp)
    4519:	e8 9c 02 00 00       	call   47ba <close>

  argptest();
    451e:	e8 19 ff ff ff       	call   443c <argptest>
  createdelete();
    4523:	e8 f3 da ff ff       	call   201b <createdelete>
  linkunlink();
    4528:	e8 a2 e3 ff ff       	call   28cf <linkunlink>
  concreate();
    452d:	e8 a2 e0 ff ff       	call   25d4 <concreate>
  fourfiles();
    4532:	e8 00 d9 ff ff       	call   1e37 <fourfiles>
  sharedfd();
    4537:	e8 68 d7 ff ff       	call   1ca4 <sharedfd>

  bigargtest();
    453c:	e8 8f fb ff ff       	call   40d0 <bigargtest>
  bigwrite();
    4541:	e8 ff ec ff ff       	call   3245 <bigwrite>
  bigargtest();
    4546:	e8 85 fb ff ff       	call   40d0 <bigargtest>
  bsstest();
    454b:	e8 16 fb ff ff       	call   4066 <bsstest>
  sbrktest();
    4550:	e8 42 f6 ff ff       	call   3b97 <sbrktest>
  validatetest();
    4555:	e8 60 fa ff ff       	call   3fba <validatetest>

  opentest();
    455a:	e8 51 cd ff ff       	call   12b0 <opentest>
  writetest();
    455f:	e8 df cd ff ff       	call   1343 <writetest>
  writetest1();
    4564:	e8 b8 cf ff ff       	call   1521 <writetest1>
  createtest();
    4569:	e8 6d d1 ff ff       	call   16db <createtest>

  openiputtest();
    456e:	e8 52 cc ff ff       	call   11c5 <openiputtest>
  exitiputtest();
    4573:	e8 65 cb ff ff       	call   10dd <exitiputtest>
  iputtest();
    4578:	e8 83 ca ff ff       	call   1000 <iputtest>

  mem();
    457d:	e8 6b d6 ff ff       	call   1bed <mem>
  pipe1();
    4582:	e8 1e d3 ff ff       	call   18a5 <pipe1>
  preempt();
    4587:	e8 bb d4 ff ff       	call   1a47 <preempt>
  exitwait();
    458c:	e8 ef d5 ff ff       	call   1b80 <exitwait>

  rmdot();
    4591:	e8 91 f0 ff ff       	call   3627 <rmdot>
  fourteen();
    4596:	e8 4f ef ff ff       	call   34ea <fourteen>
  bigfile();
    459b:	e8 80 ed ff ff       	call   3320 <bigfile>
  subdir();
    45a0:	e8 72 e5 ff ff       	call   2b17 <subdir>
  linktest();
    45a5:	e8 04 de ff ff       	call   23ae <linktest>
  unlinkread();
    45aa:	e8 66 dc ff ff       	call   2215 <unlinkread>
  dirfile();
    45af:	e8 f8 f1 ff ff       	call   37ac <dirfile>
  iref();
    45b4:	e8 0d f4 ff ff       	call   39c6 <iref>
  forktest();
    45b9:	e8 2a f5 ff ff       	call   3ae8 <forktest>
  bigdir(); // slow
    45be:	e8 fa e3 ff ff       	call   29bd <bigdir>

  uio();
    45c3:	e8 00 fe ff ff       	call   43c8 <uio>

  exectest();
    45c8:	e8 8f d2 ff ff       	call   185c <exectest>

  exit();
    45cd:	e8 c0 01 00 00       	call   4792 <exit>

000045d2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    45d2:	55                   	push   %ebp
    45d3:	89 e5                	mov    %esp,%ebp
    45d5:	53                   	push   %ebx
    45d6:	8b 45 08             	mov    0x8(%ebp),%eax
    45d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    45dc:	89 c2                	mov    %eax,%edx
    45de:	83 c1 01             	add    $0x1,%ecx
    45e1:	83 c2 01             	add    $0x1,%edx
    45e4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    45e8:	88 5a ff             	mov    %bl,-0x1(%edx)
    45eb:	84 db                	test   %bl,%bl
    45ed:	75 ef                	jne    45de <strcpy+0xc>
    ;
  return os;
}
    45ef:	5b                   	pop    %ebx
    45f0:	5d                   	pop    %ebp
    45f1:	c3                   	ret    

000045f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    45f2:	55                   	push   %ebp
    45f3:	89 e5                	mov    %esp,%ebp
    45f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    45f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    45fb:	0f b6 01             	movzbl (%ecx),%eax
    45fe:	84 c0                	test   %al,%al
    4600:	74 15                	je     4617 <strcmp+0x25>
    4602:	3a 02                	cmp    (%edx),%al
    4604:	75 11                	jne    4617 <strcmp+0x25>
    p++, q++;
    4606:	83 c1 01             	add    $0x1,%ecx
    4609:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    460c:	0f b6 01             	movzbl (%ecx),%eax
    460f:	84 c0                	test   %al,%al
    4611:	74 04                	je     4617 <strcmp+0x25>
    4613:	3a 02                	cmp    (%edx),%al
    4615:	74 ef                	je     4606 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    4617:	0f b6 c0             	movzbl %al,%eax
    461a:	0f b6 12             	movzbl (%edx),%edx
    461d:	29 d0                	sub    %edx,%eax
}
    461f:	5d                   	pop    %ebp
    4620:	c3                   	ret    

00004621 <strlen>:

uint
strlen(const char *s)
{
    4621:	55                   	push   %ebp
    4622:	89 e5                	mov    %esp,%ebp
    4624:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    4627:	80 39 00             	cmpb   $0x0,(%ecx)
    462a:	74 12                	je     463e <strlen+0x1d>
    462c:	ba 00 00 00 00       	mov    $0x0,%edx
    4631:	83 c2 01             	add    $0x1,%edx
    4634:	89 d0                	mov    %edx,%eax
    4636:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    463a:	75 f5                	jne    4631 <strlen+0x10>
    ;
  return n;
}
    463c:	5d                   	pop    %ebp
    463d:	c3                   	ret    
  for(n = 0; s[n]; n++)
    463e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    4643:	eb f7                	jmp    463c <strlen+0x1b>

00004645 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4645:	55                   	push   %ebp
    4646:	89 e5                	mov    %esp,%ebp
    4648:	57                   	push   %edi
    4649:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    464c:	89 d7                	mov    %edx,%edi
    464e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    4651:	8b 45 0c             	mov    0xc(%ebp),%eax
    4654:	fc                   	cld    
    4655:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    4657:	89 d0                	mov    %edx,%eax
    4659:	5f                   	pop    %edi
    465a:	5d                   	pop    %ebp
    465b:	c3                   	ret    

0000465c <strchr>:

char*
strchr(const char *s, char c)
{
    465c:	55                   	push   %ebp
    465d:	89 e5                	mov    %esp,%ebp
    465f:	53                   	push   %ebx
    4660:	8b 45 08             	mov    0x8(%ebp),%eax
    4663:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    4666:	0f b6 10             	movzbl (%eax),%edx
    4669:	84 d2                	test   %dl,%dl
    466b:	74 1e                	je     468b <strchr+0x2f>
    466d:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    466f:	38 d3                	cmp    %dl,%bl
    4671:	74 15                	je     4688 <strchr+0x2c>
  for(; *s; s++)
    4673:	83 c0 01             	add    $0x1,%eax
    4676:	0f b6 10             	movzbl (%eax),%edx
    4679:	84 d2                	test   %dl,%dl
    467b:	74 06                	je     4683 <strchr+0x27>
    if(*s == c)
    467d:	38 ca                	cmp    %cl,%dl
    467f:	75 f2                	jne    4673 <strchr+0x17>
    4681:	eb 05                	jmp    4688 <strchr+0x2c>
      return (char*)s;
  return 0;
    4683:	b8 00 00 00 00       	mov    $0x0,%eax
}
    4688:	5b                   	pop    %ebx
    4689:	5d                   	pop    %ebp
    468a:	c3                   	ret    
  return 0;
    468b:	b8 00 00 00 00       	mov    $0x0,%eax
    4690:	eb f6                	jmp    4688 <strchr+0x2c>

00004692 <gets>:

char*
gets(char *buf, int max)
{
    4692:	55                   	push   %ebp
    4693:	89 e5                	mov    %esp,%ebp
    4695:	57                   	push   %edi
    4696:	56                   	push   %esi
    4697:	53                   	push   %ebx
    4698:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    469b:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    46a0:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    46a3:	8d 5e 01             	lea    0x1(%esi),%ebx
    46a6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    46a9:	7d 2b                	jge    46d6 <gets+0x44>
    cc = read(0, &c, 1);
    46ab:	83 ec 04             	sub    $0x4,%esp
    46ae:	6a 01                	push   $0x1
    46b0:	57                   	push   %edi
    46b1:	6a 00                	push   $0x0
    46b3:	e8 f2 00 00 00       	call   47aa <read>
    if(cc < 1)
    46b8:	83 c4 10             	add    $0x10,%esp
    46bb:	85 c0                	test   %eax,%eax
    46bd:	7e 17                	jle    46d6 <gets+0x44>
      break;
    buf[i++] = c;
    46bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    46c3:	8b 55 08             	mov    0x8(%ebp),%edx
    46c6:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    46ca:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    46cc:	3c 0a                	cmp    $0xa,%al
    46ce:	74 04                	je     46d4 <gets+0x42>
    46d0:	3c 0d                	cmp    $0xd,%al
    46d2:	75 cf                	jne    46a3 <gets+0x11>
  for(i=0; i+1 < max; ){
    46d4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    46d6:	8b 45 08             	mov    0x8(%ebp),%eax
    46d9:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    46dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    46e0:	5b                   	pop    %ebx
    46e1:	5e                   	pop    %esi
    46e2:	5f                   	pop    %edi
    46e3:	5d                   	pop    %ebp
    46e4:	c3                   	ret    

000046e5 <stat>:

int
stat(const char *n, struct stat *st)
{
    46e5:	55                   	push   %ebp
    46e6:	89 e5                	mov    %esp,%ebp
    46e8:	56                   	push   %esi
    46e9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    46ea:	83 ec 08             	sub    $0x8,%esp
    46ed:	6a 00                	push   $0x0
    46ef:	ff 75 08             	pushl  0x8(%ebp)
    46f2:	e8 db 00 00 00       	call   47d2 <open>
  if(fd < 0)
    46f7:	83 c4 10             	add    $0x10,%esp
    46fa:	85 c0                	test   %eax,%eax
    46fc:	78 24                	js     4722 <stat+0x3d>
    46fe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    4700:	83 ec 08             	sub    $0x8,%esp
    4703:	ff 75 0c             	pushl  0xc(%ebp)
    4706:	50                   	push   %eax
    4707:	e8 de 00 00 00       	call   47ea <fstat>
    470c:	89 c6                	mov    %eax,%esi
  close(fd);
    470e:	89 1c 24             	mov    %ebx,(%esp)
    4711:	e8 a4 00 00 00       	call   47ba <close>
  return r;
    4716:	83 c4 10             	add    $0x10,%esp
}
    4719:	89 f0                	mov    %esi,%eax
    471b:	8d 65 f8             	lea    -0x8(%ebp),%esp
    471e:	5b                   	pop    %ebx
    471f:	5e                   	pop    %esi
    4720:	5d                   	pop    %ebp
    4721:	c3                   	ret    
    return -1;
    4722:	be ff ff ff ff       	mov    $0xffffffff,%esi
    4727:	eb f0                	jmp    4719 <stat+0x34>

00004729 <atoi>:

int
atoi(const char *s)
{
    4729:	55                   	push   %ebp
    472a:	89 e5                	mov    %esp,%ebp
    472c:	53                   	push   %ebx
    472d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4730:	0f b6 11             	movzbl (%ecx),%edx
    4733:	8d 42 d0             	lea    -0x30(%edx),%eax
    4736:	3c 09                	cmp    $0x9,%al
    4738:	77 20                	ja     475a <atoi+0x31>
  n = 0;
    473a:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    473f:	83 c1 01             	add    $0x1,%ecx
    4742:	8d 04 80             	lea    (%eax,%eax,4),%eax
    4745:	0f be d2             	movsbl %dl,%edx
    4748:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    474c:	0f b6 11             	movzbl (%ecx),%edx
    474f:	8d 5a d0             	lea    -0x30(%edx),%ebx
    4752:	80 fb 09             	cmp    $0x9,%bl
    4755:	76 e8                	jbe    473f <atoi+0x16>
  return n;
}
    4757:	5b                   	pop    %ebx
    4758:	5d                   	pop    %ebp
    4759:	c3                   	ret    
  n = 0;
    475a:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    475f:	eb f6                	jmp    4757 <atoi+0x2e>

00004761 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4761:	55                   	push   %ebp
    4762:	89 e5                	mov    %esp,%ebp
    4764:	56                   	push   %esi
    4765:	53                   	push   %ebx
    4766:	8b 45 08             	mov    0x8(%ebp),%eax
    4769:	8b 75 0c             	mov    0xc(%ebp),%esi
    476c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    476f:	85 db                	test   %ebx,%ebx
    4771:	7e 13                	jle    4786 <memmove+0x25>
    4773:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    4778:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    477c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    477f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    4782:	39 d3                	cmp    %edx,%ebx
    4784:	75 f2                	jne    4778 <memmove+0x17>
  return vdst;
}
    4786:	5b                   	pop    %ebx
    4787:	5e                   	pop    %esi
    4788:	5d                   	pop    %ebp
    4789:	c3                   	ret    

0000478a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    478a:	b8 01 00 00 00       	mov    $0x1,%eax
    478f:	cd 40                	int    $0x40
    4791:	c3                   	ret    

00004792 <exit>:
SYSCALL(exit)
    4792:	b8 02 00 00 00       	mov    $0x2,%eax
    4797:	cd 40                	int    $0x40
    4799:	c3                   	ret    

0000479a <wait>:
SYSCALL(wait)
    479a:	b8 03 00 00 00       	mov    $0x3,%eax
    479f:	cd 40                	int    $0x40
    47a1:	c3                   	ret    

000047a2 <pipe>:
SYSCALL(pipe)
    47a2:	b8 04 00 00 00       	mov    $0x4,%eax
    47a7:	cd 40                	int    $0x40
    47a9:	c3                   	ret    

000047aa <read>:
SYSCALL(read)
    47aa:	b8 05 00 00 00       	mov    $0x5,%eax
    47af:	cd 40                	int    $0x40
    47b1:	c3                   	ret    

000047b2 <write>:
SYSCALL(write)
    47b2:	b8 10 00 00 00       	mov    $0x10,%eax
    47b7:	cd 40                	int    $0x40
    47b9:	c3                   	ret    

000047ba <close>:
SYSCALL(close)
    47ba:	b8 15 00 00 00       	mov    $0x15,%eax
    47bf:	cd 40                	int    $0x40
    47c1:	c3                   	ret    

000047c2 <kill>:
SYSCALL(kill)
    47c2:	b8 06 00 00 00       	mov    $0x6,%eax
    47c7:	cd 40                	int    $0x40
    47c9:	c3                   	ret    

000047ca <exec>:
SYSCALL(exec)
    47ca:	b8 07 00 00 00       	mov    $0x7,%eax
    47cf:	cd 40                	int    $0x40
    47d1:	c3                   	ret    

000047d2 <open>:
SYSCALL(open)
    47d2:	b8 0f 00 00 00       	mov    $0xf,%eax
    47d7:	cd 40                	int    $0x40
    47d9:	c3                   	ret    

000047da <mknod>:
SYSCALL(mknod)
    47da:	b8 11 00 00 00       	mov    $0x11,%eax
    47df:	cd 40                	int    $0x40
    47e1:	c3                   	ret    

000047e2 <unlink>:
SYSCALL(unlink)
    47e2:	b8 12 00 00 00       	mov    $0x12,%eax
    47e7:	cd 40                	int    $0x40
    47e9:	c3                   	ret    

000047ea <fstat>:
SYSCALL(fstat)
    47ea:	b8 08 00 00 00       	mov    $0x8,%eax
    47ef:	cd 40                	int    $0x40
    47f1:	c3                   	ret    

000047f2 <link>:
SYSCALL(link)
    47f2:	b8 13 00 00 00       	mov    $0x13,%eax
    47f7:	cd 40                	int    $0x40
    47f9:	c3                   	ret    

000047fa <mkdir>:
SYSCALL(mkdir)
    47fa:	b8 14 00 00 00       	mov    $0x14,%eax
    47ff:	cd 40                	int    $0x40
    4801:	c3                   	ret    

00004802 <chdir>:
SYSCALL(chdir)
    4802:	b8 09 00 00 00       	mov    $0x9,%eax
    4807:	cd 40                	int    $0x40
    4809:	c3                   	ret    

0000480a <dup>:
SYSCALL(dup)
    480a:	b8 0a 00 00 00       	mov    $0xa,%eax
    480f:	cd 40                	int    $0x40
    4811:	c3                   	ret    

00004812 <getpid>:
SYSCALL(getpid)
    4812:	b8 0b 00 00 00       	mov    $0xb,%eax
    4817:	cd 40                	int    $0x40
    4819:	c3                   	ret    

0000481a <sbrk>:
SYSCALL(sbrk)
    481a:	b8 0c 00 00 00       	mov    $0xc,%eax
    481f:	cd 40                	int    $0x40
    4821:	c3                   	ret    

00004822 <sleep>:
SYSCALL(sleep)
    4822:	b8 0d 00 00 00       	mov    $0xd,%eax
    4827:	cd 40                	int    $0x40
    4829:	c3                   	ret    

0000482a <uptime>:
SYSCALL(uptime)
    482a:	b8 0e 00 00 00       	mov    $0xe,%eax
    482f:	cd 40                	int    $0x40
    4831:	c3                   	ret    

00004832 <shmem_access>:
SYSCALL(shmem_access)
    4832:	b8 16 00 00 00       	mov    $0x16,%eax
    4837:	cd 40                	int    $0x40
    4839:	c3                   	ret    

0000483a <shmem_count>:
    483a:	b8 17 00 00 00       	mov    $0x17,%eax
    483f:	cd 40                	int    $0x40
    4841:	c3                   	ret    

00004842 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    4842:	55                   	push   %ebp
    4843:	89 e5                	mov    %esp,%ebp
    4845:	57                   	push   %edi
    4846:	56                   	push   %esi
    4847:	53                   	push   %ebx
    4848:	83 ec 3c             	sub    $0x3c,%esp
    484b:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    484d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    4851:	74 14                	je     4867 <printint+0x25>
    4853:	85 d2                	test   %edx,%edx
    4855:	79 10                	jns    4867 <printint+0x25>
    neg = 1;
    x = -xx;
    4857:	f7 da                	neg    %edx
    neg = 1;
    4859:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    4860:	bf 00 00 00 00       	mov    $0x0,%edi
    4865:	eb 0b                	jmp    4872 <printint+0x30>
  neg = 0;
    4867:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    486e:	eb f0                	jmp    4860 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    4870:	89 df                	mov    %ebx,%edi
    4872:	8d 5f 01             	lea    0x1(%edi),%ebx
    4875:	89 d0                	mov    %edx,%eax
    4877:	ba 00 00 00 00       	mov    $0x0,%edx
    487c:	f7 f1                	div    %ecx
    487e:	0f b6 92 84 63 00 00 	movzbl 0x6384(%edx),%edx
    4885:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    4889:	89 c2                	mov    %eax,%edx
    488b:	85 c0                	test   %eax,%eax
    488d:	75 e1                	jne    4870 <printint+0x2e>
  if(neg)
    488f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    4893:	74 08                	je     489d <printint+0x5b>
    buf[i++] = '-';
    4895:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    489a:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    489d:	83 eb 01             	sub    $0x1,%ebx
    48a0:	78 22                	js     48c4 <printint+0x82>
  write(fd, &c, 1);
    48a2:	8d 7d d7             	lea    -0x29(%ebp),%edi
    48a5:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    48aa:	88 45 d7             	mov    %al,-0x29(%ebp)
    48ad:	83 ec 04             	sub    $0x4,%esp
    48b0:	6a 01                	push   $0x1
    48b2:	57                   	push   %edi
    48b3:	56                   	push   %esi
    48b4:	e8 f9 fe ff ff       	call   47b2 <write>
  while(--i >= 0)
    48b9:	83 eb 01             	sub    $0x1,%ebx
    48bc:	83 c4 10             	add    $0x10,%esp
    48bf:	83 fb ff             	cmp    $0xffffffff,%ebx
    48c2:	75 e1                	jne    48a5 <printint+0x63>
    putc(fd, buf[i]);
}
    48c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    48c7:	5b                   	pop    %ebx
    48c8:	5e                   	pop    %esi
    48c9:	5f                   	pop    %edi
    48ca:	5d                   	pop    %ebp
    48cb:	c3                   	ret    

000048cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    48cc:	55                   	push   %ebp
    48cd:	89 e5                	mov    %esp,%ebp
    48cf:	57                   	push   %edi
    48d0:	56                   	push   %esi
    48d1:	53                   	push   %ebx
    48d2:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    48d5:	8b 75 0c             	mov    0xc(%ebp),%esi
    48d8:	0f b6 1e             	movzbl (%esi),%ebx
    48db:	84 db                	test   %bl,%bl
    48dd:	0f 84 b1 01 00 00    	je     4a94 <printf+0x1c8>
    48e3:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    48e6:	8d 45 10             	lea    0x10(%ebp),%eax
    48e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    48ec:	bf 00 00 00 00       	mov    $0x0,%edi
    48f1:	eb 2d                	jmp    4920 <printf+0x54>
    48f3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    48f6:	83 ec 04             	sub    $0x4,%esp
    48f9:	6a 01                	push   $0x1
    48fb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    48fe:	50                   	push   %eax
    48ff:	ff 75 08             	pushl  0x8(%ebp)
    4902:	e8 ab fe ff ff       	call   47b2 <write>
    4907:	83 c4 10             	add    $0x10,%esp
    490a:	eb 05                	jmp    4911 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    490c:	83 ff 25             	cmp    $0x25,%edi
    490f:	74 22                	je     4933 <printf+0x67>
    4911:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    4914:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    4918:	84 db                	test   %bl,%bl
    491a:	0f 84 74 01 00 00    	je     4a94 <printf+0x1c8>
    c = fmt[i] & 0xff;
    4920:	0f be d3             	movsbl %bl,%edx
    4923:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    4926:	85 ff                	test   %edi,%edi
    4928:	75 e2                	jne    490c <printf+0x40>
      if(c == '%'){
    492a:	83 f8 25             	cmp    $0x25,%eax
    492d:	75 c4                	jne    48f3 <printf+0x27>
        state = '%';
    492f:	89 c7                	mov    %eax,%edi
    4931:	eb de                	jmp    4911 <printf+0x45>
      if(c == 'd'){
    4933:	83 f8 64             	cmp    $0x64,%eax
    4936:	74 59                	je     4991 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    4938:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    493e:	83 fa 70             	cmp    $0x70,%edx
    4941:	74 7a                	je     49bd <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    4943:	83 f8 73             	cmp    $0x73,%eax
    4946:	0f 84 9d 00 00 00    	je     49e9 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    494c:	83 f8 63             	cmp    $0x63,%eax
    494f:	0f 84 f2 00 00 00    	je     4a47 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    4955:	83 f8 25             	cmp    $0x25,%eax
    4958:	0f 84 15 01 00 00    	je     4a73 <printf+0x1a7>
    495e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    4962:	83 ec 04             	sub    $0x4,%esp
    4965:	6a 01                	push   $0x1
    4967:	8d 45 e7             	lea    -0x19(%ebp),%eax
    496a:	50                   	push   %eax
    496b:	ff 75 08             	pushl  0x8(%ebp)
    496e:	e8 3f fe ff ff       	call   47b2 <write>
    4973:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    4976:	83 c4 0c             	add    $0xc,%esp
    4979:	6a 01                	push   $0x1
    497b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    497e:	50                   	push   %eax
    497f:	ff 75 08             	pushl  0x8(%ebp)
    4982:	e8 2b fe ff ff       	call   47b2 <write>
    4987:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    498a:	bf 00 00 00 00       	mov    $0x0,%edi
    498f:	eb 80                	jmp    4911 <printf+0x45>
        printint(fd, *ap, 10, 1);
    4991:	83 ec 0c             	sub    $0xc,%esp
    4994:	6a 01                	push   $0x1
    4996:	b9 0a 00 00 00       	mov    $0xa,%ecx
    499b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    499e:	8b 17                	mov    (%edi),%edx
    49a0:	8b 45 08             	mov    0x8(%ebp),%eax
    49a3:	e8 9a fe ff ff       	call   4842 <printint>
        ap++;
    49a8:	89 f8                	mov    %edi,%eax
    49aa:	83 c0 04             	add    $0x4,%eax
    49ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    49b0:	83 c4 10             	add    $0x10,%esp
      state = 0;
    49b3:	bf 00 00 00 00       	mov    $0x0,%edi
    49b8:	e9 54 ff ff ff       	jmp    4911 <printf+0x45>
        printint(fd, *ap, 16, 0);
    49bd:	83 ec 0c             	sub    $0xc,%esp
    49c0:	6a 00                	push   $0x0
    49c2:	b9 10 00 00 00       	mov    $0x10,%ecx
    49c7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    49ca:	8b 17                	mov    (%edi),%edx
    49cc:	8b 45 08             	mov    0x8(%ebp),%eax
    49cf:	e8 6e fe ff ff       	call   4842 <printint>
        ap++;
    49d4:	89 f8                	mov    %edi,%eax
    49d6:	83 c0 04             	add    $0x4,%eax
    49d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    49dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
    49df:	bf 00 00 00 00       	mov    $0x0,%edi
    49e4:	e9 28 ff ff ff       	jmp    4911 <printf+0x45>
        s = (char*)*ap;
    49e9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    49ec:	8b 01                	mov    (%ecx),%eax
        ap++;
    49ee:	83 c1 04             	add    $0x4,%ecx
    49f1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    49f4:	85 c0                	test   %eax,%eax
    49f6:	74 13                	je     4a0b <printf+0x13f>
        s = (char*)*ap;
    49f8:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    49fa:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    49fd:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    4a02:	84 c0                	test   %al,%al
    4a04:	75 0f                	jne    4a15 <printf+0x149>
    4a06:	e9 06 ff ff ff       	jmp    4911 <printf+0x45>
          s = "(null)";
    4a0b:	bb 7c 63 00 00       	mov    $0x637c,%ebx
        while(*s != 0){
    4a10:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    4a15:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    4a18:	89 75 d0             	mov    %esi,-0x30(%ebp)
    4a1b:	8b 75 08             	mov    0x8(%ebp),%esi
    4a1e:	88 45 e3             	mov    %al,-0x1d(%ebp)
    4a21:	83 ec 04             	sub    $0x4,%esp
    4a24:	6a 01                	push   $0x1
    4a26:	57                   	push   %edi
    4a27:	56                   	push   %esi
    4a28:	e8 85 fd ff ff       	call   47b2 <write>
          s++;
    4a2d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    4a30:	0f b6 03             	movzbl (%ebx),%eax
    4a33:	83 c4 10             	add    $0x10,%esp
    4a36:	84 c0                	test   %al,%al
    4a38:	75 e4                	jne    4a1e <printf+0x152>
    4a3a:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    4a3d:	bf 00 00 00 00       	mov    $0x0,%edi
    4a42:	e9 ca fe ff ff       	jmp    4911 <printf+0x45>
        putc(fd, *ap);
    4a47:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    4a4a:	8b 07                	mov    (%edi),%eax
    4a4c:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    4a4f:	83 ec 04             	sub    $0x4,%esp
    4a52:	6a 01                	push   $0x1
    4a54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    4a57:	50                   	push   %eax
    4a58:	ff 75 08             	pushl  0x8(%ebp)
    4a5b:	e8 52 fd ff ff       	call   47b2 <write>
        ap++;
    4a60:	83 c7 04             	add    $0x4,%edi
    4a63:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    4a66:	83 c4 10             	add    $0x10,%esp
      state = 0;
    4a69:	bf 00 00 00 00       	mov    $0x0,%edi
    4a6e:	e9 9e fe ff ff       	jmp    4911 <printf+0x45>
    4a73:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    4a76:	83 ec 04             	sub    $0x4,%esp
    4a79:	6a 01                	push   $0x1
    4a7b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    4a7e:	50                   	push   %eax
    4a7f:	ff 75 08             	pushl  0x8(%ebp)
    4a82:	e8 2b fd ff ff       	call   47b2 <write>
    4a87:	83 c4 10             	add    $0x10,%esp
      state = 0;
    4a8a:	bf 00 00 00 00       	mov    $0x0,%edi
    4a8f:	e9 7d fe ff ff       	jmp    4911 <printf+0x45>
    }
  }
}
    4a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
    4a97:	5b                   	pop    %ebx
    4a98:	5e                   	pop    %esi
    4a99:	5f                   	pop    %edi
    4a9a:	5d                   	pop    %ebp
    4a9b:	c3                   	ret    

00004a9c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4a9c:	55                   	push   %ebp
    4a9d:	89 e5                	mov    %esp,%ebp
    4a9f:	57                   	push   %edi
    4aa0:	56                   	push   %esi
    4aa1:	53                   	push   %ebx
    4aa2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4aa5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4aa8:	a1 c0 6c 00 00       	mov    0x6cc0,%eax
    4aad:	eb 0c                	jmp    4abb <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4aaf:	8b 10                	mov    (%eax),%edx
    4ab1:	39 c2                	cmp    %eax,%edx
    4ab3:	77 04                	ja     4ab9 <free+0x1d>
    4ab5:	39 ca                	cmp    %ecx,%edx
    4ab7:	77 10                	ja     4ac9 <free+0x2d>
{
    4ab9:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4abb:	39 c8                	cmp    %ecx,%eax
    4abd:	73 f0                	jae    4aaf <free+0x13>
    4abf:	8b 10                	mov    (%eax),%edx
    4ac1:	39 ca                	cmp    %ecx,%edx
    4ac3:	77 04                	ja     4ac9 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ac5:	39 c2                	cmp    %eax,%edx
    4ac7:	77 f0                	ja     4ab9 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    4ac9:	8b 73 fc             	mov    -0x4(%ebx),%esi
    4acc:	8b 10                	mov    (%eax),%edx
    4ace:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    4ad1:	39 fa                	cmp    %edi,%edx
    4ad3:	74 19                	je     4aee <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    4ad5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    4ad8:	8b 50 04             	mov    0x4(%eax),%edx
    4adb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    4ade:	39 f1                	cmp    %esi,%ecx
    4ae0:	74 1b                	je     4afd <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    4ae2:	89 08                	mov    %ecx,(%eax)
  freep = p;
    4ae4:	a3 c0 6c 00 00       	mov    %eax,0x6cc0
}
    4ae9:	5b                   	pop    %ebx
    4aea:	5e                   	pop    %esi
    4aeb:	5f                   	pop    %edi
    4aec:	5d                   	pop    %ebp
    4aed:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    4aee:	03 72 04             	add    0x4(%edx),%esi
    4af1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    4af4:	8b 10                	mov    (%eax),%edx
    4af6:	8b 12                	mov    (%edx),%edx
    4af8:	89 53 f8             	mov    %edx,-0x8(%ebx)
    4afb:	eb db                	jmp    4ad8 <free+0x3c>
    p->s.size += bp->s.size;
    4afd:	03 53 fc             	add    -0x4(%ebx),%edx
    4b00:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4b03:	8b 53 f8             	mov    -0x8(%ebx),%edx
    4b06:	89 10                	mov    %edx,(%eax)
    4b08:	eb da                	jmp    4ae4 <free+0x48>

00004b0a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4b0a:	55                   	push   %ebp
    4b0b:	89 e5                	mov    %esp,%ebp
    4b0d:	57                   	push   %edi
    4b0e:	56                   	push   %esi
    4b0f:	53                   	push   %ebx
    4b10:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4b13:	8b 45 08             	mov    0x8(%ebp),%eax
    4b16:	8d 58 07             	lea    0x7(%eax),%ebx
    4b19:	c1 eb 03             	shr    $0x3,%ebx
    4b1c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    4b1f:	8b 15 c0 6c 00 00    	mov    0x6cc0,%edx
    4b25:	85 d2                	test   %edx,%edx
    4b27:	74 20                	je     4b49 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4b29:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    4b2b:	8b 48 04             	mov    0x4(%eax),%ecx
    4b2e:	39 cb                	cmp    %ecx,%ebx
    4b30:	76 3c                	jbe    4b6e <malloc+0x64>
    4b32:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    4b38:	be 00 10 00 00       	mov    $0x1000,%esi
    4b3d:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    4b40:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    4b47:	eb 70                	jmp    4bb9 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    4b49:	c7 05 c0 6c 00 00 c4 	movl   $0x6cc4,0x6cc0
    4b50:	6c 00 00 
    4b53:	c7 05 c4 6c 00 00 c4 	movl   $0x6cc4,0x6cc4
    4b5a:	6c 00 00 
    base.s.size = 0;
    4b5d:	c7 05 c8 6c 00 00 00 	movl   $0x0,0x6cc8
    4b64:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    4b67:	ba c4 6c 00 00       	mov    $0x6cc4,%edx
    4b6c:	eb bb                	jmp    4b29 <malloc+0x1f>
      if(p->s.size == nunits)
    4b6e:	39 cb                	cmp    %ecx,%ebx
    4b70:	74 1c                	je     4b8e <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    4b72:	29 d9                	sub    %ebx,%ecx
    4b74:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    4b77:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    4b7a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    4b7d:	89 15 c0 6c 00 00    	mov    %edx,0x6cc0
      return (void*)(p + 1);
    4b83:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
    4b89:	5b                   	pop    %ebx
    4b8a:	5e                   	pop    %esi
    4b8b:	5f                   	pop    %edi
    4b8c:	5d                   	pop    %ebp
    4b8d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    4b8e:	8b 08                	mov    (%eax),%ecx
    4b90:	89 0a                	mov    %ecx,(%edx)
    4b92:	eb e9                	jmp    4b7d <malloc+0x73>
  hp->s.size = nu;
    4b94:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    4b97:	83 ec 0c             	sub    $0xc,%esp
    4b9a:	83 c0 08             	add    $0x8,%eax
    4b9d:	50                   	push   %eax
    4b9e:	e8 f9 fe ff ff       	call   4a9c <free>
  return freep;
    4ba3:	8b 15 c0 6c 00 00    	mov    0x6cc0,%edx
      if((p = morecore(nunits)) == 0)
    4ba9:	83 c4 10             	add    $0x10,%esp
    4bac:	85 d2                	test   %edx,%edx
    4bae:	74 2b                	je     4bdb <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4bb0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    4bb2:	8b 48 04             	mov    0x4(%eax),%ecx
    4bb5:	39 d9                	cmp    %ebx,%ecx
    4bb7:	73 b5                	jae    4b6e <malloc+0x64>
    4bb9:	89 c2                	mov    %eax,%edx
    if(p == freep)
    4bbb:	39 05 c0 6c 00 00    	cmp    %eax,0x6cc0
    4bc1:	75 ed                	jne    4bb0 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    4bc3:	83 ec 0c             	sub    $0xc,%esp
    4bc6:	57                   	push   %edi
    4bc7:	e8 4e fc ff ff       	call   481a <sbrk>
  if(p == (char*)-1)
    4bcc:	83 c4 10             	add    $0x10,%esp
    4bcf:	83 f8 ff             	cmp    $0xffffffff,%eax
    4bd2:	75 c0                	jne    4b94 <malloc+0x8a>
        return 0;
    4bd4:	b8 00 00 00 00       	mov    $0x0,%eax
    4bd9:	eb ab                	jmp    4b86 <malloc+0x7c>
    4bdb:	b8 00 00 00 00       	mov    $0x0,%eax
    4be0:	eb a4                	jmp    4b86 <malloc+0x7c>
