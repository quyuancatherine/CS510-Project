
_init:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    100f:	83 ec 08             	sub    $0x8,%esp
    1012:	6a 02                	push   $0x2
    1014:	68 f0 16 00 00       	push   $0x16f0
    1019:	e8 c1 02 00 00       	call   12df <open>
    101e:	83 c4 10             	add    $0x10,%esp
    1021:	85 c0                	test   %eax,%eax
    1023:	78 1b                	js     1040 <main+0x40>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
    1025:	83 ec 0c             	sub    $0xc,%esp
    1028:	6a 00                	push   $0x0
    102a:	e8 e8 02 00 00       	call   1317 <dup>
  dup(0);  // stderr
    102f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1036:	e8 dc 02 00 00       	call   1317 <dup>
    103b:	83 c4 10             	add    $0x10,%esp
    103e:	eb 58                	jmp    1098 <main+0x98>
    mknod("console", 1, 1);
    1040:	83 ec 04             	sub    $0x4,%esp
    1043:	6a 01                	push   $0x1
    1045:	6a 01                	push   $0x1
    1047:	68 f0 16 00 00       	push   $0x16f0
    104c:	e8 96 02 00 00       	call   12e7 <mknod>
    open("console", O_RDWR);
    1051:	83 c4 08             	add    $0x8,%esp
    1054:	6a 02                	push   $0x2
    1056:	68 f0 16 00 00       	push   $0x16f0
    105b:	e8 7f 02 00 00       	call   12df <open>
    1060:	83 c4 10             	add    $0x10,%esp
    1063:	eb c0                	jmp    1025 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
    1065:	83 ec 08             	sub    $0x8,%esp
    1068:	68 0b 17 00 00       	push   $0x170b
    106d:	6a 01                	push   $0x1
    106f:	e8 65 03 00 00       	call   13d9 <printf>
      exit();
    1074:	e8 26 02 00 00       	call   129f <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
    1079:	83 ec 08             	sub    $0x8,%esp
    107c:	68 37 17 00 00       	push   $0x1737
    1081:	6a 01                	push   $0x1
    1083:	e8 51 03 00 00       	call   13d9 <printf>
    1088:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
    108b:	e8 17 02 00 00       	call   12a7 <wait>
    1090:	39 c3                	cmp    %eax,%ebx
    1092:	74 04                	je     1098 <main+0x98>
    1094:	85 c0                	test   %eax,%eax
    1096:	79 e1                	jns    1079 <main+0x79>
    printf(1, "init: starting sh\n");
    1098:	83 ec 08             	sub    $0x8,%esp
    109b:	68 f8 16 00 00       	push   $0x16f8
    10a0:	6a 01                	push   $0x1
    10a2:	e8 32 03 00 00       	call   13d9 <printf>
    pid = fork();
    10a7:	e8 eb 01 00 00       	call   1297 <fork>
    10ac:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    10ae:	83 c4 10             	add    $0x10,%esp
    10b1:	85 c0                	test   %eax,%eax
    10b3:	78 b0                	js     1065 <main+0x65>
    if(pid == 0){
    10b5:	85 c0                	test   %eax,%eax
    10b7:	75 d2                	jne    108b <main+0x8b>
      exec("sh", argv);
    10b9:	83 ec 08             	sub    $0x8,%esp
    10bc:	68 b4 19 00 00       	push   $0x19b4
    10c1:	68 1e 17 00 00       	push   $0x171e
    10c6:	e8 0c 02 00 00       	call   12d7 <exec>
      printf(1, "init: exec sh failed\n");
    10cb:	83 c4 08             	add    $0x8,%esp
    10ce:	68 21 17 00 00       	push   $0x1721
    10d3:	6a 01                	push   $0x1
    10d5:	e8 ff 02 00 00       	call   13d9 <printf>
      exit();
    10da:	e8 c0 01 00 00       	call   129f <exit>

000010df <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10df:	55                   	push   %ebp
    10e0:	89 e5                	mov    %esp,%ebp
    10e2:	53                   	push   %ebx
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10e9:	89 c2                	mov    %eax,%edx
    10eb:	83 c1 01             	add    $0x1,%ecx
    10ee:	83 c2 01             	add    $0x1,%edx
    10f1:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    10f5:	88 5a ff             	mov    %bl,-0x1(%edx)
    10f8:	84 db                	test   %bl,%bl
    10fa:	75 ef                	jne    10eb <strcpy+0xc>
    ;
  return os;
}
    10fc:	5b                   	pop    %ebx
    10fd:	5d                   	pop    %ebp
    10fe:	c3                   	ret    

000010ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ff:	55                   	push   %ebp
    1100:	89 e5                	mov    %esp,%ebp
    1102:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1105:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1108:	0f b6 01             	movzbl (%ecx),%eax
    110b:	84 c0                	test   %al,%al
    110d:	74 15                	je     1124 <strcmp+0x25>
    110f:	3a 02                	cmp    (%edx),%al
    1111:	75 11                	jne    1124 <strcmp+0x25>
    p++, q++;
    1113:	83 c1 01             	add    $0x1,%ecx
    1116:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1119:	0f b6 01             	movzbl (%ecx),%eax
    111c:	84 c0                	test   %al,%al
    111e:	74 04                	je     1124 <strcmp+0x25>
    1120:	3a 02                	cmp    (%edx),%al
    1122:	74 ef                	je     1113 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1124:	0f b6 c0             	movzbl %al,%eax
    1127:	0f b6 12             	movzbl (%edx),%edx
    112a:	29 d0                	sub    %edx,%eax
}
    112c:	5d                   	pop    %ebp
    112d:	c3                   	ret    

0000112e <strlen>:

uint
strlen(const char *s)
{
    112e:	55                   	push   %ebp
    112f:	89 e5                	mov    %esp,%ebp
    1131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1134:	80 39 00             	cmpb   $0x0,(%ecx)
    1137:	74 12                	je     114b <strlen+0x1d>
    1139:	ba 00 00 00 00       	mov    $0x0,%edx
    113e:	83 c2 01             	add    $0x1,%edx
    1141:	89 d0                	mov    %edx,%eax
    1143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1147:	75 f5                	jne    113e <strlen+0x10>
    ;
  return n;
}
    1149:	5d                   	pop    %ebp
    114a:	c3                   	ret    
  for(n = 0; s[n]; n++)
    114b:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1150:	eb f7                	jmp    1149 <strlen+0x1b>

00001152 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1152:	55                   	push   %ebp
    1153:	89 e5                	mov    %esp,%ebp
    1155:	57                   	push   %edi
    1156:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1159:	89 d7                	mov    %edx,%edi
    115b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    115e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1161:	fc                   	cld    
    1162:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1164:	89 d0                	mov    %edx,%eax
    1166:	5f                   	pop    %edi
    1167:	5d                   	pop    %ebp
    1168:	c3                   	ret    

00001169 <strchr>:

char*
strchr(const char *s, char c)
{
    1169:	55                   	push   %ebp
    116a:	89 e5                	mov    %esp,%ebp
    116c:	53                   	push   %ebx
    116d:	8b 45 08             	mov    0x8(%ebp),%eax
    1170:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    1173:	0f b6 10             	movzbl (%eax),%edx
    1176:	84 d2                	test   %dl,%dl
    1178:	74 1e                	je     1198 <strchr+0x2f>
    117a:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    117c:	38 d3                	cmp    %dl,%bl
    117e:	74 15                	je     1195 <strchr+0x2c>
  for(; *s; s++)
    1180:	83 c0 01             	add    $0x1,%eax
    1183:	0f b6 10             	movzbl (%eax),%edx
    1186:	84 d2                	test   %dl,%dl
    1188:	74 06                	je     1190 <strchr+0x27>
    if(*s == c)
    118a:	38 ca                	cmp    %cl,%dl
    118c:	75 f2                	jne    1180 <strchr+0x17>
    118e:	eb 05                	jmp    1195 <strchr+0x2c>
      return (char*)s;
  return 0;
    1190:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1195:	5b                   	pop    %ebx
    1196:	5d                   	pop    %ebp
    1197:	c3                   	ret    
  return 0;
    1198:	b8 00 00 00 00       	mov    $0x0,%eax
    119d:	eb f6                	jmp    1195 <strchr+0x2c>

0000119f <gets>:

char*
gets(char *buf, int max)
{
    119f:	55                   	push   %ebp
    11a0:	89 e5                	mov    %esp,%ebp
    11a2:	57                   	push   %edi
    11a3:	56                   	push   %esi
    11a4:	53                   	push   %ebx
    11a5:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a8:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    11ad:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    11b0:	8d 5e 01             	lea    0x1(%esi),%ebx
    11b3:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11b6:	7d 2b                	jge    11e3 <gets+0x44>
    cc = read(0, &c, 1);
    11b8:	83 ec 04             	sub    $0x4,%esp
    11bb:	6a 01                	push   $0x1
    11bd:	57                   	push   %edi
    11be:	6a 00                	push   $0x0
    11c0:	e8 f2 00 00 00       	call   12b7 <read>
    if(cc < 1)
    11c5:	83 c4 10             	add    $0x10,%esp
    11c8:	85 c0                	test   %eax,%eax
    11ca:	7e 17                	jle    11e3 <gets+0x44>
      break;
    buf[i++] = c;
    11cc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    11d0:	8b 55 08             	mov    0x8(%ebp),%edx
    11d3:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    11d7:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    11d9:	3c 0a                	cmp    $0xa,%al
    11db:	74 04                	je     11e1 <gets+0x42>
    11dd:	3c 0d                	cmp    $0xd,%al
    11df:	75 cf                	jne    11b0 <gets+0x11>
  for(i=0; i+1 < max; ){
    11e1:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    11e3:	8b 45 08             	mov    0x8(%ebp),%eax
    11e6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    11ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11ed:	5b                   	pop    %ebx
    11ee:	5e                   	pop    %esi
    11ef:	5f                   	pop    %edi
    11f0:	5d                   	pop    %ebp
    11f1:	c3                   	ret    

000011f2 <stat>:

int
stat(const char *n, struct stat *st)
{
    11f2:	55                   	push   %ebp
    11f3:	89 e5                	mov    %esp,%ebp
    11f5:	56                   	push   %esi
    11f6:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f7:	83 ec 08             	sub    $0x8,%esp
    11fa:	6a 00                	push   $0x0
    11fc:	ff 75 08             	pushl  0x8(%ebp)
    11ff:	e8 db 00 00 00       	call   12df <open>
  if(fd < 0)
    1204:	83 c4 10             	add    $0x10,%esp
    1207:	85 c0                	test   %eax,%eax
    1209:	78 24                	js     122f <stat+0x3d>
    120b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    120d:	83 ec 08             	sub    $0x8,%esp
    1210:	ff 75 0c             	pushl  0xc(%ebp)
    1213:	50                   	push   %eax
    1214:	e8 de 00 00 00       	call   12f7 <fstat>
    1219:	89 c6                	mov    %eax,%esi
  close(fd);
    121b:	89 1c 24             	mov    %ebx,(%esp)
    121e:	e8 a4 00 00 00       	call   12c7 <close>
  return r;
    1223:	83 c4 10             	add    $0x10,%esp
}
    1226:	89 f0                	mov    %esi,%eax
    1228:	8d 65 f8             	lea    -0x8(%ebp),%esp
    122b:	5b                   	pop    %ebx
    122c:	5e                   	pop    %esi
    122d:	5d                   	pop    %ebp
    122e:	c3                   	ret    
    return -1;
    122f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1234:	eb f0                	jmp    1226 <stat+0x34>

00001236 <atoi>:

int
atoi(const char *s)
{
    1236:	55                   	push   %ebp
    1237:	89 e5                	mov    %esp,%ebp
    1239:	53                   	push   %ebx
    123a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    123d:	0f b6 11             	movzbl (%ecx),%edx
    1240:	8d 42 d0             	lea    -0x30(%edx),%eax
    1243:	3c 09                	cmp    $0x9,%al
    1245:	77 20                	ja     1267 <atoi+0x31>
  n = 0;
    1247:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    124c:	83 c1 01             	add    $0x1,%ecx
    124f:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1252:	0f be d2             	movsbl %dl,%edx
    1255:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1259:	0f b6 11             	movzbl (%ecx),%edx
    125c:	8d 5a d0             	lea    -0x30(%edx),%ebx
    125f:	80 fb 09             	cmp    $0x9,%bl
    1262:	76 e8                	jbe    124c <atoi+0x16>
  return n;
}
    1264:	5b                   	pop    %ebx
    1265:	5d                   	pop    %ebp
    1266:	c3                   	ret    
  n = 0;
    1267:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    126c:	eb f6                	jmp    1264 <atoi+0x2e>

0000126e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    126e:	55                   	push   %ebp
    126f:	89 e5                	mov    %esp,%ebp
    1271:	56                   	push   %esi
    1272:	53                   	push   %ebx
    1273:	8b 45 08             	mov    0x8(%ebp),%eax
    1276:	8b 75 0c             	mov    0xc(%ebp),%esi
    1279:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    127c:	85 db                	test   %ebx,%ebx
    127e:	7e 13                	jle    1293 <memmove+0x25>
    1280:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    1285:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1289:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    128c:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    128f:	39 d3                	cmp    %edx,%ebx
    1291:	75 f2                	jne    1285 <memmove+0x17>
  return vdst;
}
    1293:	5b                   	pop    %ebx
    1294:	5e                   	pop    %esi
    1295:	5d                   	pop    %ebp
    1296:	c3                   	ret    

00001297 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1297:	b8 01 00 00 00       	mov    $0x1,%eax
    129c:	cd 40                	int    $0x40
    129e:	c3                   	ret    

0000129f <exit>:
SYSCALL(exit)
    129f:	b8 02 00 00 00       	mov    $0x2,%eax
    12a4:	cd 40                	int    $0x40
    12a6:	c3                   	ret    

000012a7 <wait>:
SYSCALL(wait)
    12a7:	b8 03 00 00 00       	mov    $0x3,%eax
    12ac:	cd 40                	int    $0x40
    12ae:	c3                   	ret    

000012af <pipe>:
SYSCALL(pipe)
    12af:	b8 04 00 00 00       	mov    $0x4,%eax
    12b4:	cd 40                	int    $0x40
    12b6:	c3                   	ret    

000012b7 <read>:
SYSCALL(read)
    12b7:	b8 05 00 00 00       	mov    $0x5,%eax
    12bc:	cd 40                	int    $0x40
    12be:	c3                   	ret    

000012bf <write>:
SYSCALL(write)
    12bf:	b8 10 00 00 00       	mov    $0x10,%eax
    12c4:	cd 40                	int    $0x40
    12c6:	c3                   	ret    

000012c7 <close>:
SYSCALL(close)
    12c7:	b8 15 00 00 00       	mov    $0x15,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <kill>:
SYSCALL(kill)
    12cf:	b8 06 00 00 00       	mov    $0x6,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <exec>:
SYSCALL(exec)
    12d7:	b8 07 00 00 00       	mov    $0x7,%eax
    12dc:	cd 40                	int    $0x40
    12de:	c3                   	ret    

000012df <open>:
SYSCALL(open)
    12df:	b8 0f 00 00 00       	mov    $0xf,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <mknod>:
SYSCALL(mknod)
    12e7:	b8 11 00 00 00       	mov    $0x11,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <unlink>:
SYSCALL(unlink)
    12ef:	b8 12 00 00 00       	mov    $0x12,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <fstat>:
SYSCALL(fstat)
    12f7:	b8 08 00 00 00       	mov    $0x8,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <link>:
SYSCALL(link)
    12ff:	b8 13 00 00 00       	mov    $0x13,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <mkdir>:
SYSCALL(mkdir)
    1307:	b8 14 00 00 00       	mov    $0x14,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <chdir>:
SYSCALL(chdir)
    130f:	b8 09 00 00 00       	mov    $0x9,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <dup>:
SYSCALL(dup)
    1317:	b8 0a 00 00 00       	mov    $0xa,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <getpid>:
SYSCALL(getpid)
    131f:	b8 0b 00 00 00       	mov    $0xb,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <sbrk>:
SYSCALL(sbrk)
    1327:	b8 0c 00 00 00       	mov    $0xc,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <sleep>:
SYSCALL(sleep)
    132f:	b8 0d 00 00 00       	mov    $0xd,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <uptime>:
SYSCALL(uptime)
    1337:	b8 0e 00 00 00       	mov    $0xe,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <shmem_access>:
SYSCALL(shmem_access)
    133f:	b8 16 00 00 00       	mov    $0x16,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <shmem_count>:
    1347:	b8 17 00 00 00       	mov    $0x17,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    134f:	55                   	push   %ebp
    1350:	89 e5                	mov    %esp,%ebp
    1352:	57                   	push   %edi
    1353:	56                   	push   %esi
    1354:	53                   	push   %ebx
    1355:	83 ec 3c             	sub    $0x3c,%esp
    1358:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    135a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    135e:	74 14                	je     1374 <printint+0x25>
    1360:	85 d2                	test   %edx,%edx
    1362:	79 10                	jns    1374 <printint+0x25>
    neg = 1;
    x = -xx;
    1364:	f7 da                	neg    %edx
    neg = 1;
    1366:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    136d:	bf 00 00 00 00       	mov    $0x0,%edi
    1372:	eb 0b                	jmp    137f <printint+0x30>
  neg = 0;
    1374:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    137b:	eb f0                	jmp    136d <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    137d:	89 df                	mov    %ebx,%edi
    137f:	8d 5f 01             	lea    0x1(%edi),%ebx
    1382:	89 d0                	mov    %edx,%eax
    1384:	ba 00 00 00 00       	mov    $0x0,%edx
    1389:	f7 f1                	div    %ecx
    138b:	0f b6 92 48 17 00 00 	movzbl 0x1748(%edx),%edx
    1392:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1396:	89 c2                	mov    %eax,%edx
    1398:	85 c0                	test   %eax,%eax
    139a:	75 e1                	jne    137d <printint+0x2e>
  if(neg)
    139c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    13a0:	74 08                	je     13aa <printint+0x5b>
    buf[i++] = '-';
    13a2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    13a7:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    13aa:	83 eb 01             	sub    $0x1,%ebx
    13ad:	78 22                	js     13d1 <printint+0x82>
  write(fd, &c, 1);
    13af:	8d 7d d7             	lea    -0x29(%ebp),%edi
    13b2:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    13b7:	88 45 d7             	mov    %al,-0x29(%ebp)
    13ba:	83 ec 04             	sub    $0x4,%esp
    13bd:	6a 01                	push   $0x1
    13bf:	57                   	push   %edi
    13c0:	56                   	push   %esi
    13c1:	e8 f9 fe ff ff       	call   12bf <write>
  while(--i >= 0)
    13c6:	83 eb 01             	sub    $0x1,%ebx
    13c9:	83 c4 10             	add    $0x10,%esp
    13cc:	83 fb ff             	cmp    $0xffffffff,%ebx
    13cf:	75 e1                	jne    13b2 <printint+0x63>
    putc(fd, buf[i]);
}
    13d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13d4:	5b                   	pop    %ebx
    13d5:	5e                   	pop    %esi
    13d6:	5f                   	pop    %edi
    13d7:	5d                   	pop    %ebp
    13d8:	c3                   	ret    

000013d9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    13d9:	55                   	push   %ebp
    13da:	89 e5                	mov    %esp,%ebp
    13dc:	57                   	push   %edi
    13dd:	56                   	push   %esi
    13de:	53                   	push   %ebx
    13df:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13e2:	8b 75 0c             	mov    0xc(%ebp),%esi
    13e5:	0f b6 1e             	movzbl (%esi),%ebx
    13e8:	84 db                	test   %bl,%bl
    13ea:	0f 84 b1 01 00 00    	je     15a1 <printf+0x1c8>
    13f0:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    13f3:	8d 45 10             	lea    0x10(%ebp),%eax
    13f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    13f9:	bf 00 00 00 00       	mov    $0x0,%edi
    13fe:	eb 2d                	jmp    142d <printf+0x54>
    1400:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1403:	83 ec 04             	sub    $0x4,%esp
    1406:	6a 01                	push   $0x1
    1408:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    140b:	50                   	push   %eax
    140c:	ff 75 08             	pushl  0x8(%ebp)
    140f:	e8 ab fe ff ff       	call   12bf <write>
    1414:	83 c4 10             	add    $0x10,%esp
    1417:	eb 05                	jmp    141e <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1419:	83 ff 25             	cmp    $0x25,%edi
    141c:	74 22                	je     1440 <printf+0x67>
    141e:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    1421:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1425:	84 db                	test   %bl,%bl
    1427:	0f 84 74 01 00 00    	je     15a1 <printf+0x1c8>
    c = fmt[i] & 0xff;
    142d:	0f be d3             	movsbl %bl,%edx
    1430:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1433:	85 ff                	test   %edi,%edi
    1435:	75 e2                	jne    1419 <printf+0x40>
      if(c == '%'){
    1437:	83 f8 25             	cmp    $0x25,%eax
    143a:	75 c4                	jne    1400 <printf+0x27>
        state = '%';
    143c:	89 c7                	mov    %eax,%edi
    143e:	eb de                	jmp    141e <printf+0x45>
      if(c == 'd'){
    1440:	83 f8 64             	cmp    $0x64,%eax
    1443:	74 59                	je     149e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1445:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    144b:	83 fa 70             	cmp    $0x70,%edx
    144e:	74 7a                	je     14ca <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1450:	83 f8 73             	cmp    $0x73,%eax
    1453:	0f 84 9d 00 00 00    	je     14f6 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1459:	83 f8 63             	cmp    $0x63,%eax
    145c:	0f 84 f2 00 00 00    	je     1554 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1462:	83 f8 25             	cmp    $0x25,%eax
    1465:	0f 84 15 01 00 00    	je     1580 <printf+0x1a7>
    146b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    146f:	83 ec 04             	sub    $0x4,%esp
    1472:	6a 01                	push   $0x1
    1474:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1477:	50                   	push   %eax
    1478:	ff 75 08             	pushl  0x8(%ebp)
    147b:	e8 3f fe ff ff       	call   12bf <write>
    1480:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    1483:	83 c4 0c             	add    $0xc,%esp
    1486:	6a 01                	push   $0x1
    1488:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    148b:	50                   	push   %eax
    148c:	ff 75 08             	pushl  0x8(%ebp)
    148f:	e8 2b fe ff ff       	call   12bf <write>
    1494:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1497:	bf 00 00 00 00       	mov    $0x0,%edi
    149c:	eb 80                	jmp    141e <printf+0x45>
        printint(fd, *ap, 10, 1);
    149e:	83 ec 0c             	sub    $0xc,%esp
    14a1:	6a 01                	push   $0x1
    14a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    14a8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14ab:	8b 17                	mov    (%edi),%edx
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
    14b0:	e8 9a fe ff ff       	call   134f <printint>
        ap++;
    14b5:	89 f8                	mov    %edi,%eax
    14b7:	83 c0 04             	add    $0x4,%eax
    14ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    14bd:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14c0:	bf 00 00 00 00       	mov    $0x0,%edi
    14c5:	e9 54 ff ff ff       	jmp    141e <printf+0x45>
        printint(fd, *ap, 16, 0);
    14ca:	83 ec 0c             	sub    $0xc,%esp
    14cd:	6a 00                	push   $0x0
    14cf:	b9 10 00 00 00       	mov    $0x10,%ecx
    14d4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14d7:	8b 17                	mov    (%edi),%edx
    14d9:	8b 45 08             	mov    0x8(%ebp),%eax
    14dc:	e8 6e fe ff ff       	call   134f <printint>
        ap++;
    14e1:	89 f8                	mov    %edi,%eax
    14e3:	83 c0 04             	add    $0x4,%eax
    14e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    14e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14ec:	bf 00 00 00 00       	mov    $0x0,%edi
    14f1:	e9 28 ff ff ff       	jmp    141e <printf+0x45>
        s = (char*)*ap;
    14f6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    14f9:	8b 01                	mov    (%ecx),%eax
        ap++;
    14fb:	83 c1 04             	add    $0x4,%ecx
    14fe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1501:	85 c0                	test   %eax,%eax
    1503:	74 13                	je     1518 <printf+0x13f>
        s = (char*)*ap;
    1505:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1507:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    150a:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    150f:	84 c0                	test   %al,%al
    1511:	75 0f                	jne    1522 <printf+0x149>
    1513:	e9 06 ff ff ff       	jmp    141e <printf+0x45>
          s = "(null)";
    1518:	bb 40 17 00 00       	mov    $0x1740,%ebx
        while(*s != 0){
    151d:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    1522:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1525:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1528:	8b 75 08             	mov    0x8(%ebp),%esi
    152b:	88 45 e3             	mov    %al,-0x1d(%ebp)
    152e:	83 ec 04             	sub    $0x4,%esp
    1531:	6a 01                	push   $0x1
    1533:	57                   	push   %edi
    1534:	56                   	push   %esi
    1535:	e8 85 fd ff ff       	call   12bf <write>
          s++;
    153a:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    153d:	0f b6 03             	movzbl (%ebx),%eax
    1540:	83 c4 10             	add    $0x10,%esp
    1543:	84 c0                	test   %al,%al
    1545:	75 e4                	jne    152b <printf+0x152>
    1547:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    154a:	bf 00 00 00 00       	mov    $0x0,%edi
    154f:	e9 ca fe ff ff       	jmp    141e <printf+0x45>
        putc(fd, *ap);
    1554:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1557:	8b 07                	mov    (%edi),%eax
    1559:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    155c:	83 ec 04             	sub    $0x4,%esp
    155f:	6a 01                	push   $0x1
    1561:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1564:	50                   	push   %eax
    1565:	ff 75 08             	pushl  0x8(%ebp)
    1568:	e8 52 fd ff ff       	call   12bf <write>
        ap++;
    156d:	83 c7 04             	add    $0x4,%edi
    1570:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    1573:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1576:	bf 00 00 00 00       	mov    $0x0,%edi
    157b:	e9 9e fe ff ff       	jmp    141e <printf+0x45>
    1580:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    1583:	83 ec 04             	sub    $0x4,%esp
    1586:	6a 01                	push   $0x1
    1588:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    158b:	50                   	push   %eax
    158c:	ff 75 08             	pushl  0x8(%ebp)
    158f:	e8 2b fd ff ff       	call   12bf <write>
    1594:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1597:	bf 00 00 00 00       	mov    $0x0,%edi
    159c:	e9 7d fe ff ff       	jmp    141e <printf+0x45>
    }
  }
}
    15a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15a4:	5b                   	pop    %ebx
    15a5:	5e                   	pop    %esi
    15a6:	5f                   	pop    %edi
    15a7:	5d                   	pop    %ebp
    15a8:	c3                   	ret    

000015a9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15a9:	55                   	push   %ebp
    15aa:	89 e5                	mov    %esp,%ebp
    15ac:	57                   	push   %edi
    15ad:	56                   	push   %esi
    15ae:	53                   	push   %ebx
    15af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15b2:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15b5:	a1 bc 19 00 00       	mov    0x19bc,%eax
    15ba:	eb 0c                	jmp    15c8 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15bc:	8b 10                	mov    (%eax),%edx
    15be:	39 c2                	cmp    %eax,%edx
    15c0:	77 04                	ja     15c6 <free+0x1d>
    15c2:	39 ca                	cmp    %ecx,%edx
    15c4:	77 10                	ja     15d6 <free+0x2d>
{
    15c6:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15c8:	39 c8                	cmp    %ecx,%eax
    15ca:	73 f0                	jae    15bc <free+0x13>
    15cc:	8b 10                	mov    (%eax),%edx
    15ce:	39 ca                	cmp    %ecx,%edx
    15d0:	77 04                	ja     15d6 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15d2:	39 c2                	cmp    %eax,%edx
    15d4:	77 f0                	ja     15c6 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    15d6:	8b 73 fc             	mov    -0x4(%ebx),%esi
    15d9:	8b 10                	mov    (%eax),%edx
    15db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    15de:	39 fa                	cmp    %edi,%edx
    15e0:	74 19                	je     15fb <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    15e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    15e5:	8b 50 04             	mov    0x4(%eax),%edx
    15e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    15eb:	39 f1                	cmp    %esi,%ecx
    15ed:	74 1b                	je     160a <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    15ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
    15f1:	a3 bc 19 00 00       	mov    %eax,0x19bc
}
    15f6:	5b                   	pop    %ebx
    15f7:	5e                   	pop    %esi
    15f8:	5f                   	pop    %edi
    15f9:	5d                   	pop    %ebp
    15fa:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    15fb:	03 72 04             	add    0x4(%edx),%esi
    15fe:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1601:	8b 10                	mov    (%eax),%edx
    1603:	8b 12                	mov    (%edx),%edx
    1605:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1608:	eb db                	jmp    15e5 <free+0x3c>
    p->s.size += bp->s.size;
    160a:	03 53 fc             	add    -0x4(%ebx),%edx
    160d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1610:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1613:	89 10                	mov    %edx,(%eax)
    1615:	eb da                	jmp    15f1 <free+0x48>

00001617 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1617:	55                   	push   %ebp
    1618:	89 e5                	mov    %esp,%ebp
    161a:	57                   	push   %edi
    161b:	56                   	push   %esi
    161c:	53                   	push   %ebx
    161d:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1620:	8b 45 08             	mov    0x8(%ebp),%eax
    1623:	8d 58 07             	lea    0x7(%eax),%ebx
    1626:	c1 eb 03             	shr    $0x3,%ebx
    1629:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    162c:	8b 15 bc 19 00 00    	mov    0x19bc,%edx
    1632:	85 d2                	test   %edx,%edx
    1634:	74 20                	je     1656 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1636:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1638:	8b 48 04             	mov    0x4(%eax),%ecx
    163b:	39 cb                	cmp    %ecx,%ebx
    163d:	76 3c                	jbe    167b <malloc+0x64>
    163f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1645:	be 00 10 00 00       	mov    $0x1000,%esi
    164a:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    164d:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    1654:	eb 70                	jmp    16c6 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1656:	c7 05 bc 19 00 00 c0 	movl   $0x19c0,0x19bc
    165d:	19 00 00 
    1660:	c7 05 c0 19 00 00 c0 	movl   $0x19c0,0x19c0
    1667:	19 00 00 
    base.s.size = 0;
    166a:	c7 05 c4 19 00 00 00 	movl   $0x0,0x19c4
    1671:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1674:	ba c0 19 00 00       	mov    $0x19c0,%edx
    1679:	eb bb                	jmp    1636 <malloc+0x1f>
      if(p->s.size == nunits)
    167b:	39 cb                	cmp    %ecx,%ebx
    167d:	74 1c                	je     169b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    167f:	29 d9                	sub    %ebx,%ecx
    1681:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1684:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1687:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    168a:	89 15 bc 19 00 00    	mov    %edx,0x19bc
      return (void*)(p + 1);
    1690:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1693:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1696:	5b                   	pop    %ebx
    1697:	5e                   	pop    %esi
    1698:	5f                   	pop    %edi
    1699:	5d                   	pop    %ebp
    169a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    169b:	8b 08                	mov    (%eax),%ecx
    169d:	89 0a                	mov    %ecx,(%edx)
    169f:	eb e9                	jmp    168a <malloc+0x73>
  hp->s.size = nu;
    16a1:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    16a4:	83 ec 0c             	sub    $0xc,%esp
    16a7:	83 c0 08             	add    $0x8,%eax
    16aa:	50                   	push   %eax
    16ab:	e8 f9 fe ff ff       	call   15a9 <free>
  return freep;
    16b0:	8b 15 bc 19 00 00    	mov    0x19bc,%edx
      if((p = morecore(nunits)) == 0)
    16b6:	83 c4 10             	add    $0x10,%esp
    16b9:	85 d2                	test   %edx,%edx
    16bb:	74 2b                	je     16e8 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16bd:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16bf:	8b 48 04             	mov    0x4(%eax),%ecx
    16c2:	39 d9                	cmp    %ebx,%ecx
    16c4:	73 b5                	jae    167b <malloc+0x64>
    16c6:	89 c2                	mov    %eax,%edx
    if(p == freep)
    16c8:	39 05 bc 19 00 00    	cmp    %eax,0x19bc
    16ce:	75 ed                	jne    16bd <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    16d0:	83 ec 0c             	sub    $0xc,%esp
    16d3:	57                   	push   %edi
    16d4:	e8 4e fc ff ff       	call   1327 <sbrk>
  if(p == (char*)-1)
    16d9:	83 c4 10             	add    $0x10,%esp
    16dc:	83 f8 ff             	cmp    $0xffffffff,%eax
    16df:	75 c0                	jne    16a1 <malloc+0x8a>
        return 0;
    16e1:	b8 00 00 00 00       	mov    $0x0,%eax
    16e6:	eb ab                	jmp    1693 <malloc+0x7c>
    16e8:	b8 00 00 00 00       	mov    $0x0,%eax
    16ed:	eb a4                	jmp    1693 <malloc+0x7c>
