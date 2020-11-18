
_ln:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
    100f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
    1012:	83 39 03             	cmpl   $0x3,(%ecx)
    1015:	74 14                	je     102b <main+0x2b>
    printf(2, "Usage: ln old new\n");
    1017:	83 ec 08             	sub    $0x8,%esp
    101a:	68 6c 16 00 00       	push   $0x166c
    101f:	6a 02                	push   $0x2
    1021:	e8 30 03 00 00       	call   1356 <printf>
    exit();
    1026:	e8 f1 01 00 00       	call   121c <exit>
  }
  if(link(argv[1], argv[2]) < 0)
    102b:	83 ec 08             	sub    $0x8,%esp
    102e:	ff 73 08             	pushl  0x8(%ebx)
    1031:	ff 73 04             	pushl  0x4(%ebx)
    1034:	e8 43 02 00 00       	call   127c <link>
    1039:	83 c4 10             	add    $0x10,%esp
    103c:	85 c0                	test   %eax,%eax
    103e:	78 05                	js     1045 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
    1040:	e8 d7 01 00 00       	call   121c <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1045:	ff 73 08             	pushl  0x8(%ebx)
    1048:	ff 73 04             	pushl  0x4(%ebx)
    104b:	68 7f 16 00 00       	push   $0x167f
    1050:	6a 02                	push   $0x2
    1052:	e8 ff 02 00 00       	call   1356 <printf>
    1057:	83 c4 10             	add    $0x10,%esp
    105a:	eb e4                	jmp    1040 <main+0x40>

0000105c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    105c:	55                   	push   %ebp
    105d:	89 e5                	mov    %esp,%ebp
    105f:	53                   	push   %ebx
    1060:	8b 45 08             	mov    0x8(%ebp),%eax
    1063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1066:	89 c2                	mov    %eax,%edx
    1068:	83 c1 01             	add    $0x1,%ecx
    106b:	83 c2 01             	add    $0x1,%edx
    106e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1072:	88 5a ff             	mov    %bl,-0x1(%edx)
    1075:	84 db                	test   %bl,%bl
    1077:	75 ef                	jne    1068 <strcpy+0xc>
    ;
  return os;
}
    1079:	5b                   	pop    %ebx
    107a:	5d                   	pop    %ebp
    107b:	c3                   	ret    

0000107c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    107c:	55                   	push   %ebp
    107d:	89 e5                	mov    %esp,%ebp
    107f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1082:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1085:	0f b6 01             	movzbl (%ecx),%eax
    1088:	84 c0                	test   %al,%al
    108a:	74 15                	je     10a1 <strcmp+0x25>
    108c:	3a 02                	cmp    (%edx),%al
    108e:	75 11                	jne    10a1 <strcmp+0x25>
    p++, q++;
    1090:	83 c1 01             	add    $0x1,%ecx
    1093:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1096:	0f b6 01             	movzbl (%ecx),%eax
    1099:	84 c0                	test   %al,%al
    109b:	74 04                	je     10a1 <strcmp+0x25>
    109d:	3a 02                	cmp    (%edx),%al
    109f:	74 ef                	je     1090 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    10a1:	0f b6 c0             	movzbl %al,%eax
    10a4:	0f b6 12             	movzbl (%edx),%edx
    10a7:	29 d0                	sub    %edx,%eax
}
    10a9:	5d                   	pop    %ebp
    10aa:	c3                   	ret    

000010ab <strlen>:

uint
strlen(const char *s)
{
    10ab:	55                   	push   %ebp
    10ac:	89 e5                	mov    %esp,%ebp
    10ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10b1:	80 39 00             	cmpb   $0x0,(%ecx)
    10b4:	74 12                	je     10c8 <strlen+0x1d>
    10b6:	ba 00 00 00 00       	mov    $0x0,%edx
    10bb:	83 c2 01             	add    $0x1,%edx
    10be:	89 d0                	mov    %edx,%eax
    10c0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    10c4:	75 f5                	jne    10bb <strlen+0x10>
    ;
  return n;
}
    10c6:	5d                   	pop    %ebp
    10c7:	c3                   	ret    
  for(n = 0; s[n]; n++)
    10c8:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    10cd:	eb f7                	jmp    10c6 <strlen+0x1b>

000010cf <memset>:

void*
memset(void *dst, int c, uint n)
{
    10cf:	55                   	push   %ebp
    10d0:	89 e5                	mov    %esp,%ebp
    10d2:	57                   	push   %edi
    10d3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10d6:	89 d7                	mov    %edx,%edi
    10d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10db:	8b 45 0c             	mov    0xc(%ebp),%eax
    10de:	fc                   	cld    
    10df:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10e1:	89 d0                	mov    %edx,%eax
    10e3:	5f                   	pop    %edi
    10e4:	5d                   	pop    %ebp
    10e5:	c3                   	ret    

000010e6 <strchr>:

char*
strchr(const char *s, char c)
{
    10e6:	55                   	push   %ebp
    10e7:	89 e5                	mov    %esp,%ebp
    10e9:	53                   	push   %ebx
    10ea:	8b 45 08             	mov    0x8(%ebp),%eax
    10ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10f0:	0f b6 10             	movzbl (%eax),%edx
    10f3:	84 d2                	test   %dl,%dl
    10f5:	74 1e                	je     1115 <strchr+0x2f>
    10f7:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    10f9:	38 d3                	cmp    %dl,%bl
    10fb:	74 15                	je     1112 <strchr+0x2c>
  for(; *s; s++)
    10fd:	83 c0 01             	add    $0x1,%eax
    1100:	0f b6 10             	movzbl (%eax),%edx
    1103:	84 d2                	test   %dl,%dl
    1105:	74 06                	je     110d <strchr+0x27>
    if(*s == c)
    1107:	38 ca                	cmp    %cl,%dl
    1109:	75 f2                	jne    10fd <strchr+0x17>
    110b:	eb 05                	jmp    1112 <strchr+0x2c>
      return (char*)s;
  return 0;
    110d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1112:	5b                   	pop    %ebx
    1113:	5d                   	pop    %ebp
    1114:	c3                   	ret    
  return 0;
    1115:	b8 00 00 00 00       	mov    $0x0,%eax
    111a:	eb f6                	jmp    1112 <strchr+0x2c>

0000111c <gets>:

char*
gets(char *buf, int max)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	57                   	push   %edi
    1120:	56                   	push   %esi
    1121:	53                   	push   %ebx
    1122:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1125:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    112a:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    112d:	8d 5e 01             	lea    0x1(%esi),%ebx
    1130:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1133:	7d 2b                	jge    1160 <gets+0x44>
    cc = read(0, &c, 1);
    1135:	83 ec 04             	sub    $0x4,%esp
    1138:	6a 01                	push   $0x1
    113a:	57                   	push   %edi
    113b:	6a 00                	push   $0x0
    113d:	e8 f2 00 00 00       	call   1234 <read>
    if(cc < 1)
    1142:	83 c4 10             	add    $0x10,%esp
    1145:	85 c0                	test   %eax,%eax
    1147:	7e 17                	jle    1160 <gets+0x44>
      break;
    buf[i++] = c;
    1149:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    114d:	8b 55 08             	mov    0x8(%ebp),%edx
    1150:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1154:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1156:	3c 0a                	cmp    $0xa,%al
    1158:	74 04                	je     115e <gets+0x42>
    115a:	3c 0d                	cmp    $0xd,%al
    115c:	75 cf                	jne    112d <gets+0x11>
  for(i=0; i+1 < max; ){
    115e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1160:	8b 45 08             	mov    0x8(%ebp),%eax
    1163:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1167:	8d 65 f4             	lea    -0xc(%ebp),%esp
    116a:	5b                   	pop    %ebx
    116b:	5e                   	pop    %esi
    116c:	5f                   	pop    %edi
    116d:	5d                   	pop    %ebp
    116e:	c3                   	ret    

0000116f <stat>:

int
stat(const char *n, struct stat *st)
{
    116f:	55                   	push   %ebp
    1170:	89 e5                	mov    %esp,%ebp
    1172:	56                   	push   %esi
    1173:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1174:	83 ec 08             	sub    $0x8,%esp
    1177:	6a 00                	push   $0x0
    1179:	ff 75 08             	pushl  0x8(%ebp)
    117c:	e8 db 00 00 00       	call   125c <open>
  if(fd < 0)
    1181:	83 c4 10             	add    $0x10,%esp
    1184:	85 c0                	test   %eax,%eax
    1186:	78 24                	js     11ac <stat+0x3d>
    1188:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    118a:	83 ec 08             	sub    $0x8,%esp
    118d:	ff 75 0c             	pushl  0xc(%ebp)
    1190:	50                   	push   %eax
    1191:	e8 de 00 00 00       	call   1274 <fstat>
    1196:	89 c6                	mov    %eax,%esi
  close(fd);
    1198:	89 1c 24             	mov    %ebx,(%esp)
    119b:	e8 a4 00 00 00       	call   1244 <close>
  return r;
    11a0:	83 c4 10             	add    $0x10,%esp
}
    11a3:	89 f0                	mov    %esi,%eax
    11a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11a8:	5b                   	pop    %ebx
    11a9:	5e                   	pop    %esi
    11aa:	5d                   	pop    %ebp
    11ab:	c3                   	ret    
    return -1;
    11ac:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11b1:	eb f0                	jmp    11a3 <stat+0x34>

000011b3 <atoi>:

int
atoi(const char *s)
{
    11b3:	55                   	push   %ebp
    11b4:	89 e5                	mov    %esp,%ebp
    11b6:	53                   	push   %ebx
    11b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11ba:	0f b6 11             	movzbl (%ecx),%edx
    11bd:	8d 42 d0             	lea    -0x30(%edx),%eax
    11c0:	3c 09                	cmp    $0x9,%al
    11c2:	77 20                	ja     11e4 <atoi+0x31>
  n = 0;
    11c4:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    11c9:	83 c1 01             	add    $0x1,%ecx
    11cc:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11cf:	0f be d2             	movsbl %dl,%edx
    11d2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11d6:	0f b6 11             	movzbl (%ecx),%edx
    11d9:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11dc:	80 fb 09             	cmp    $0x9,%bl
    11df:	76 e8                	jbe    11c9 <atoi+0x16>
  return n;
}
    11e1:	5b                   	pop    %ebx
    11e2:	5d                   	pop    %ebp
    11e3:	c3                   	ret    
  n = 0;
    11e4:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11e9:	eb f6                	jmp    11e1 <atoi+0x2e>

000011eb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11eb:	55                   	push   %ebp
    11ec:	89 e5                	mov    %esp,%ebp
    11ee:	56                   	push   %esi
    11ef:	53                   	push   %ebx
    11f0:	8b 45 08             	mov    0x8(%ebp),%eax
    11f3:	8b 75 0c             	mov    0xc(%ebp),%esi
    11f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11f9:	85 db                	test   %ebx,%ebx
    11fb:	7e 13                	jle    1210 <memmove+0x25>
    11fd:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    1202:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1206:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1209:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    120c:	39 d3                	cmp    %edx,%ebx
    120e:	75 f2                	jne    1202 <memmove+0x17>
  return vdst;
}
    1210:	5b                   	pop    %ebx
    1211:	5e                   	pop    %esi
    1212:	5d                   	pop    %ebp
    1213:	c3                   	ret    

00001214 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1214:	b8 01 00 00 00       	mov    $0x1,%eax
    1219:	cd 40                	int    $0x40
    121b:	c3                   	ret    

0000121c <exit>:
SYSCALL(exit)
    121c:	b8 02 00 00 00       	mov    $0x2,%eax
    1221:	cd 40                	int    $0x40
    1223:	c3                   	ret    

00001224 <wait>:
SYSCALL(wait)
    1224:	b8 03 00 00 00       	mov    $0x3,%eax
    1229:	cd 40                	int    $0x40
    122b:	c3                   	ret    

0000122c <pipe>:
SYSCALL(pipe)
    122c:	b8 04 00 00 00       	mov    $0x4,%eax
    1231:	cd 40                	int    $0x40
    1233:	c3                   	ret    

00001234 <read>:
SYSCALL(read)
    1234:	b8 05 00 00 00       	mov    $0x5,%eax
    1239:	cd 40                	int    $0x40
    123b:	c3                   	ret    

0000123c <write>:
SYSCALL(write)
    123c:	b8 10 00 00 00       	mov    $0x10,%eax
    1241:	cd 40                	int    $0x40
    1243:	c3                   	ret    

00001244 <close>:
SYSCALL(close)
    1244:	b8 15 00 00 00       	mov    $0x15,%eax
    1249:	cd 40                	int    $0x40
    124b:	c3                   	ret    

0000124c <kill>:
SYSCALL(kill)
    124c:	b8 06 00 00 00       	mov    $0x6,%eax
    1251:	cd 40                	int    $0x40
    1253:	c3                   	ret    

00001254 <exec>:
SYSCALL(exec)
    1254:	b8 07 00 00 00       	mov    $0x7,%eax
    1259:	cd 40                	int    $0x40
    125b:	c3                   	ret    

0000125c <open>:
SYSCALL(open)
    125c:	b8 0f 00 00 00       	mov    $0xf,%eax
    1261:	cd 40                	int    $0x40
    1263:	c3                   	ret    

00001264 <mknod>:
SYSCALL(mknod)
    1264:	b8 11 00 00 00       	mov    $0x11,%eax
    1269:	cd 40                	int    $0x40
    126b:	c3                   	ret    

0000126c <unlink>:
SYSCALL(unlink)
    126c:	b8 12 00 00 00       	mov    $0x12,%eax
    1271:	cd 40                	int    $0x40
    1273:	c3                   	ret    

00001274 <fstat>:
SYSCALL(fstat)
    1274:	b8 08 00 00 00       	mov    $0x8,%eax
    1279:	cd 40                	int    $0x40
    127b:	c3                   	ret    

0000127c <link>:
SYSCALL(link)
    127c:	b8 13 00 00 00       	mov    $0x13,%eax
    1281:	cd 40                	int    $0x40
    1283:	c3                   	ret    

00001284 <mkdir>:
SYSCALL(mkdir)
    1284:	b8 14 00 00 00       	mov    $0x14,%eax
    1289:	cd 40                	int    $0x40
    128b:	c3                   	ret    

0000128c <chdir>:
SYSCALL(chdir)
    128c:	b8 09 00 00 00       	mov    $0x9,%eax
    1291:	cd 40                	int    $0x40
    1293:	c3                   	ret    

00001294 <dup>:
SYSCALL(dup)
    1294:	b8 0a 00 00 00       	mov    $0xa,%eax
    1299:	cd 40                	int    $0x40
    129b:	c3                   	ret    

0000129c <getpid>:
SYSCALL(getpid)
    129c:	b8 0b 00 00 00       	mov    $0xb,%eax
    12a1:	cd 40                	int    $0x40
    12a3:	c3                   	ret    

000012a4 <sbrk>:
SYSCALL(sbrk)
    12a4:	b8 0c 00 00 00       	mov    $0xc,%eax
    12a9:	cd 40                	int    $0x40
    12ab:	c3                   	ret    

000012ac <sleep>:
SYSCALL(sleep)
    12ac:	b8 0d 00 00 00       	mov    $0xd,%eax
    12b1:	cd 40                	int    $0x40
    12b3:	c3                   	ret    

000012b4 <uptime>:
SYSCALL(uptime)
    12b4:	b8 0e 00 00 00       	mov    $0xe,%eax
    12b9:	cd 40                	int    $0x40
    12bb:	c3                   	ret    

000012bc <shmem_access>:
SYSCALL(shmem_access)
    12bc:	b8 16 00 00 00       	mov    $0x16,%eax
    12c1:	cd 40                	int    $0x40
    12c3:	c3                   	ret    

000012c4 <shmem_count>:
    12c4:	b8 17 00 00 00       	mov    $0x17,%eax
    12c9:	cd 40                	int    $0x40
    12cb:	c3                   	ret    

000012cc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12cc:	55                   	push   %ebp
    12cd:	89 e5                	mov    %esp,%ebp
    12cf:	57                   	push   %edi
    12d0:	56                   	push   %esi
    12d1:	53                   	push   %ebx
    12d2:	83 ec 3c             	sub    $0x3c,%esp
    12d5:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12db:	74 14                	je     12f1 <printint+0x25>
    12dd:	85 d2                	test   %edx,%edx
    12df:	79 10                	jns    12f1 <printint+0x25>
    neg = 1;
    x = -xx;
    12e1:	f7 da                	neg    %edx
    neg = 1;
    12e3:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12ea:	bf 00 00 00 00       	mov    $0x0,%edi
    12ef:	eb 0b                	jmp    12fc <printint+0x30>
  neg = 0;
    12f1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12f8:	eb f0                	jmp    12ea <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    12fa:	89 df                	mov    %ebx,%edi
    12fc:	8d 5f 01             	lea    0x1(%edi),%ebx
    12ff:	89 d0                	mov    %edx,%eax
    1301:	ba 00 00 00 00       	mov    $0x0,%edx
    1306:	f7 f1                	div    %ecx
    1308:	0f b6 92 9c 16 00 00 	movzbl 0x169c(%edx),%edx
    130f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1313:	89 c2                	mov    %eax,%edx
    1315:	85 c0                	test   %eax,%eax
    1317:	75 e1                	jne    12fa <printint+0x2e>
  if(neg)
    1319:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    131d:	74 08                	je     1327 <printint+0x5b>
    buf[i++] = '-';
    131f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1324:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1327:	83 eb 01             	sub    $0x1,%ebx
    132a:	78 22                	js     134e <printint+0x82>
  write(fd, &c, 1);
    132c:	8d 7d d7             	lea    -0x29(%ebp),%edi
    132f:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1334:	88 45 d7             	mov    %al,-0x29(%ebp)
    1337:	83 ec 04             	sub    $0x4,%esp
    133a:	6a 01                	push   $0x1
    133c:	57                   	push   %edi
    133d:	56                   	push   %esi
    133e:	e8 f9 fe ff ff       	call   123c <write>
  while(--i >= 0)
    1343:	83 eb 01             	sub    $0x1,%ebx
    1346:	83 c4 10             	add    $0x10,%esp
    1349:	83 fb ff             	cmp    $0xffffffff,%ebx
    134c:	75 e1                	jne    132f <printint+0x63>
    putc(fd, buf[i]);
}
    134e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1351:	5b                   	pop    %ebx
    1352:	5e                   	pop    %esi
    1353:	5f                   	pop    %edi
    1354:	5d                   	pop    %ebp
    1355:	c3                   	ret    

00001356 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1356:	55                   	push   %ebp
    1357:	89 e5                	mov    %esp,%ebp
    1359:	57                   	push   %edi
    135a:	56                   	push   %esi
    135b:	53                   	push   %ebx
    135c:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    135f:	8b 75 0c             	mov    0xc(%ebp),%esi
    1362:	0f b6 1e             	movzbl (%esi),%ebx
    1365:	84 db                	test   %bl,%bl
    1367:	0f 84 b1 01 00 00    	je     151e <printf+0x1c8>
    136d:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    1370:	8d 45 10             	lea    0x10(%ebp),%eax
    1373:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1376:	bf 00 00 00 00       	mov    $0x0,%edi
    137b:	eb 2d                	jmp    13aa <printf+0x54>
    137d:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1380:	83 ec 04             	sub    $0x4,%esp
    1383:	6a 01                	push   $0x1
    1385:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1388:	50                   	push   %eax
    1389:	ff 75 08             	pushl  0x8(%ebp)
    138c:	e8 ab fe ff ff       	call   123c <write>
    1391:	83 c4 10             	add    $0x10,%esp
    1394:	eb 05                	jmp    139b <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1396:	83 ff 25             	cmp    $0x25,%edi
    1399:	74 22                	je     13bd <printf+0x67>
    139b:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    139e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    13a2:	84 db                	test   %bl,%bl
    13a4:	0f 84 74 01 00 00    	je     151e <printf+0x1c8>
    c = fmt[i] & 0xff;
    13aa:	0f be d3             	movsbl %bl,%edx
    13ad:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    13b0:	85 ff                	test   %edi,%edi
    13b2:	75 e2                	jne    1396 <printf+0x40>
      if(c == '%'){
    13b4:	83 f8 25             	cmp    $0x25,%eax
    13b7:	75 c4                	jne    137d <printf+0x27>
        state = '%';
    13b9:	89 c7                	mov    %eax,%edi
    13bb:	eb de                	jmp    139b <printf+0x45>
      if(c == 'd'){
    13bd:	83 f8 64             	cmp    $0x64,%eax
    13c0:	74 59                	je     141b <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13c2:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    13c8:	83 fa 70             	cmp    $0x70,%edx
    13cb:	74 7a                	je     1447 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13cd:	83 f8 73             	cmp    $0x73,%eax
    13d0:	0f 84 9d 00 00 00    	je     1473 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13d6:	83 f8 63             	cmp    $0x63,%eax
    13d9:	0f 84 f2 00 00 00    	je     14d1 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13df:	83 f8 25             	cmp    $0x25,%eax
    13e2:	0f 84 15 01 00 00    	je     14fd <printf+0x1a7>
    13e8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    13ec:	83 ec 04             	sub    $0x4,%esp
    13ef:	6a 01                	push   $0x1
    13f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13f4:	50                   	push   %eax
    13f5:	ff 75 08             	pushl  0x8(%ebp)
    13f8:	e8 3f fe ff ff       	call   123c <write>
    13fd:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    1400:	83 c4 0c             	add    $0xc,%esp
    1403:	6a 01                	push   $0x1
    1405:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1408:	50                   	push   %eax
    1409:	ff 75 08             	pushl  0x8(%ebp)
    140c:	e8 2b fe ff ff       	call   123c <write>
    1411:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1414:	bf 00 00 00 00       	mov    $0x0,%edi
    1419:	eb 80                	jmp    139b <printf+0x45>
        printint(fd, *ap, 10, 1);
    141b:	83 ec 0c             	sub    $0xc,%esp
    141e:	6a 01                	push   $0x1
    1420:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1425:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1428:	8b 17                	mov    (%edi),%edx
    142a:	8b 45 08             	mov    0x8(%ebp),%eax
    142d:	e8 9a fe ff ff       	call   12cc <printint>
        ap++;
    1432:	89 f8                	mov    %edi,%eax
    1434:	83 c0 04             	add    $0x4,%eax
    1437:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    143a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    143d:	bf 00 00 00 00       	mov    $0x0,%edi
    1442:	e9 54 ff ff ff       	jmp    139b <printf+0x45>
        printint(fd, *ap, 16, 0);
    1447:	83 ec 0c             	sub    $0xc,%esp
    144a:	6a 00                	push   $0x0
    144c:	b9 10 00 00 00       	mov    $0x10,%ecx
    1451:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1454:	8b 17                	mov    (%edi),%edx
    1456:	8b 45 08             	mov    0x8(%ebp),%eax
    1459:	e8 6e fe ff ff       	call   12cc <printint>
        ap++;
    145e:	89 f8                	mov    %edi,%eax
    1460:	83 c0 04             	add    $0x4,%eax
    1463:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1466:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1469:	bf 00 00 00 00       	mov    $0x0,%edi
    146e:	e9 28 ff ff ff       	jmp    139b <printf+0x45>
        s = (char*)*ap;
    1473:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1476:	8b 01                	mov    (%ecx),%eax
        ap++;
    1478:	83 c1 04             	add    $0x4,%ecx
    147b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    147e:	85 c0                	test   %eax,%eax
    1480:	74 13                	je     1495 <printf+0x13f>
        s = (char*)*ap;
    1482:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1484:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1487:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    148c:	84 c0                	test   %al,%al
    148e:	75 0f                	jne    149f <printf+0x149>
    1490:	e9 06 ff ff ff       	jmp    139b <printf+0x45>
          s = "(null)";
    1495:	bb 93 16 00 00       	mov    $0x1693,%ebx
        while(*s != 0){
    149a:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    149f:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    14a2:	89 75 d0             	mov    %esi,-0x30(%ebp)
    14a5:	8b 75 08             	mov    0x8(%ebp),%esi
    14a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
    14ab:	83 ec 04             	sub    $0x4,%esp
    14ae:	6a 01                	push   $0x1
    14b0:	57                   	push   %edi
    14b1:	56                   	push   %esi
    14b2:	e8 85 fd ff ff       	call   123c <write>
          s++;
    14b7:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    14ba:	0f b6 03             	movzbl (%ebx),%eax
    14bd:	83 c4 10             	add    $0x10,%esp
    14c0:	84 c0                	test   %al,%al
    14c2:	75 e4                	jne    14a8 <printf+0x152>
    14c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    14c7:	bf 00 00 00 00       	mov    $0x0,%edi
    14cc:	e9 ca fe ff ff       	jmp    139b <printf+0x45>
        putc(fd, *ap);
    14d1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14d4:	8b 07                	mov    (%edi),%eax
    14d6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14d9:	83 ec 04             	sub    $0x4,%esp
    14dc:	6a 01                	push   $0x1
    14de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14e1:	50                   	push   %eax
    14e2:	ff 75 08             	pushl  0x8(%ebp)
    14e5:	e8 52 fd ff ff       	call   123c <write>
        ap++;
    14ea:	83 c7 04             	add    $0x4,%edi
    14ed:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14f3:	bf 00 00 00 00       	mov    $0x0,%edi
    14f8:	e9 9e fe ff ff       	jmp    139b <printf+0x45>
    14fd:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    1500:	83 ec 04             	sub    $0x4,%esp
    1503:	6a 01                	push   $0x1
    1505:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1508:	50                   	push   %eax
    1509:	ff 75 08             	pushl  0x8(%ebp)
    150c:	e8 2b fd ff ff       	call   123c <write>
    1511:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1514:	bf 00 00 00 00       	mov    $0x0,%edi
    1519:	e9 7d fe ff ff       	jmp    139b <printf+0x45>
    }
  }
}
    151e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1521:	5b                   	pop    %ebx
    1522:	5e                   	pop    %esi
    1523:	5f                   	pop    %edi
    1524:	5d                   	pop    %ebp
    1525:	c3                   	ret    

00001526 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1526:	55                   	push   %ebp
    1527:	89 e5                	mov    %esp,%ebp
    1529:	57                   	push   %edi
    152a:	56                   	push   %esi
    152b:	53                   	push   %ebx
    152c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    152f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1532:	a1 08 19 00 00       	mov    0x1908,%eax
    1537:	eb 0c                	jmp    1545 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1539:	8b 10                	mov    (%eax),%edx
    153b:	39 c2                	cmp    %eax,%edx
    153d:	77 04                	ja     1543 <free+0x1d>
    153f:	39 ca                	cmp    %ecx,%edx
    1541:	77 10                	ja     1553 <free+0x2d>
{
    1543:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1545:	39 c8                	cmp    %ecx,%eax
    1547:	73 f0                	jae    1539 <free+0x13>
    1549:	8b 10                	mov    (%eax),%edx
    154b:	39 ca                	cmp    %ecx,%edx
    154d:	77 04                	ja     1553 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    154f:	39 c2                	cmp    %eax,%edx
    1551:	77 f0                	ja     1543 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1553:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1556:	8b 10                	mov    (%eax),%edx
    1558:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    155b:	39 fa                	cmp    %edi,%edx
    155d:	74 19                	je     1578 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    155f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1562:	8b 50 04             	mov    0x4(%eax),%edx
    1565:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1568:	39 f1                	cmp    %esi,%ecx
    156a:	74 1b                	je     1587 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    156c:	89 08                	mov    %ecx,(%eax)
  freep = p;
    156e:	a3 08 19 00 00       	mov    %eax,0x1908
}
    1573:	5b                   	pop    %ebx
    1574:	5e                   	pop    %esi
    1575:	5f                   	pop    %edi
    1576:	5d                   	pop    %ebp
    1577:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1578:	03 72 04             	add    0x4(%edx),%esi
    157b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    157e:	8b 10                	mov    (%eax),%edx
    1580:	8b 12                	mov    (%edx),%edx
    1582:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1585:	eb db                	jmp    1562 <free+0x3c>
    p->s.size += bp->s.size;
    1587:	03 53 fc             	add    -0x4(%ebx),%edx
    158a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    158d:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1590:	89 10                	mov    %edx,(%eax)
    1592:	eb da                	jmp    156e <free+0x48>

00001594 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1594:	55                   	push   %ebp
    1595:	89 e5                	mov    %esp,%ebp
    1597:	57                   	push   %edi
    1598:	56                   	push   %esi
    1599:	53                   	push   %ebx
    159a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    159d:	8b 45 08             	mov    0x8(%ebp),%eax
    15a0:	8d 58 07             	lea    0x7(%eax),%ebx
    15a3:	c1 eb 03             	shr    $0x3,%ebx
    15a6:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15a9:	8b 15 08 19 00 00    	mov    0x1908,%edx
    15af:	85 d2                	test   %edx,%edx
    15b1:	74 20                	je     15d3 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15b3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15b5:	8b 48 04             	mov    0x4(%eax),%ecx
    15b8:	39 cb                	cmp    %ecx,%ebx
    15ba:	76 3c                	jbe    15f8 <malloc+0x64>
    15bc:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    15c2:	be 00 10 00 00       	mov    $0x1000,%esi
    15c7:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    15ca:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15d1:	eb 70                	jmp    1643 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15d3:	c7 05 08 19 00 00 0c 	movl   $0x190c,0x1908
    15da:	19 00 00 
    15dd:	c7 05 0c 19 00 00 0c 	movl   $0x190c,0x190c
    15e4:	19 00 00 
    base.s.size = 0;
    15e7:	c7 05 10 19 00 00 00 	movl   $0x0,0x1910
    15ee:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    15f1:	ba 0c 19 00 00       	mov    $0x190c,%edx
    15f6:	eb bb                	jmp    15b3 <malloc+0x1f>
      if(p->s.size == nunits)
    15f8:	39 cb                	cmp    %ecx,%ebx
    15fa:	74 1c                	je     1618 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    15fc:	29 d9                	sub    %ebx,%ecx
    15fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1601:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1604:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1607:	89 15 08 19 00 00    	mov    %edx,0x1908
      return (void*)(p + 1);
    160d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1610:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1613:	5b                   	pop    %ebx
    1614:	5e                   	pop    %esi
    1615:	5f                   	pop    %edi
    1616:	5d                   	pop    %ebp
    1617:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1618:	8b 08                	mov    (%eax),%ecx
    161a:	89 0a                	mov    %ecx,(%edx)
    161c:	eb e9                	jmp    1607 <malloc+0x73>
  hp->s.size = nu;
    161e:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1621:	83 ec 0c             	sub    $0xc,%esp
    1624:	83 c0 08             	add    $0x8,%eax
    1627:	50                   	push   %eax
    1628:	e8 f9 fe ff ff       	call   1526 <free>
  return freep;
    162d:	8b 15 08 19 00 00    	mov    0x1908,%edx
      if((p = morecore(nunits)) == 0)
    1633:	83 c4 10             	add    $0x10,%esp
    1636:	85 d2                	test   %edx,%edx
    1638:	74 2b                	je     1665 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    163a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    163c:	8b 48 04             	mov    0x4(%eax),%ecx
    163f:	39 d9                	cmp    %ebx,%ecx
    1641:	73 b5                	jae    15f8 <malloc+0x64>
    1643:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1645:	39 05 08 19 00 00    	cmp    %eax,0x1908
    164b:	75 ed                	jne    163a <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    164d:	83 ec 0c             	sub    $0xc,%esp
    1650:	57                   	push   %edi
    1651:	e8 4e fc ff ff       	call   12a4 <sbrk>
  if(p == (char*)-1)
    1656:	83 c4 10             	add    $0x10,%esp
    1659:	83 f8 ff             	cmp    $0xffffffff,%eax
    165c:	75 c0                	jne    161e <malloc+0x8a>
        return 0;
    165e:	b8 00 00 00 00       	mov    $0x0,%eax
    1663:	eb ab                	jmp    1610 <malloc+0x7c>
    1665:	b8 00 00 00 00       	mov    $0x0,%eax
    166a:	eb a4                	jmp    1610 <malloc+0x7c>
