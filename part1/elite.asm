
_elite:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

int main(int argc, char const *argv[]) {
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
  int* page2 = (int*)shmem_access(2);
    100f:	83 ec 0c             	sub    $0xc,%esp
    1012:	6a 02                	push   $0x2
    1014:	e8 92 02 00 00       	call   12ab <shmem_access>
    1019:	89 c3                	mov    %eax,%ebx
  printf(1, "page2 was %d\n", page2[0]);
    101b:	83 c4 0c             	add    $0xc,%esp
    101e:	ff 30                	pushl  (%eax)
    1020:	68 5c 16 00 00       	push   $0x165c
    1025:	6a 01                	push   $0x1
    1027:	e8 19 03 00 00       	call   1345 <printf>
  page2[0] = 1337;
    102c:	c7 03 39 05 00 00    	movl   $0x539,(%ebx)
  printf(1, "elite set page2 to %d\n", page2[0]);
    1032:	83 c4 0c             	add    $0xc,%esp
    1035:	68 39 05 00 00       	push   $0x539
    103a:	68 6a 16 00 00       	push   $0x166a
    103f:	6a 01                	push   $0x1
    1041:	e8 ff 02 00 00       	call   1345 <printf>
  exit();
    1046:	e8 c0 01 00 00       	call   120b <exit>

0000104b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    104b:	55                   	push   %ebp
    104c:	89 e5                	mov    %esp,%ebp
    104e:	53                   	push   %ebx
    104f:	8b 45 08             	mov    0x8(%ebp),%eax
    1052:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1055:	89 c2                	mov    %eax,%edx
    1057:	83 c1 01             	add    $0x1,%ecx
    105a:	83 c2 01             	add    $0x1,%edx
    105d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1061:	88 5a ff             	mov    %bl,-0x1(%edx)
    1064:	84 db                	test   %bl,%bl
    1066:	75 ef                	jne    1057 <strcpy+0xc>
    ;
  return os;
}
    1068:	5b                   	pop    %ebx
    1069:	5d                   	pop    %ebp
    106a:	c3                   	ret    

0000106b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    106b:	55                   	push   %ebp
    106c:	89 e5                	mov    %esp,%ebp
    106e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1071:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1074:	0f b6 01             	movzbl (%ecx),%eax
    1077:	84 c0                	test   %al,%al
    1079:	74 15                	je     1090 <strcmp+0x25>
    107b:	3a 02                	cmp    (%edx),%al
    107d:	75 11                	jne    1090 <strcmp+0x25>
    p++, q++;
    107f:	83 c1 01             	add    $0x1,%ecx
    1082:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1085:	0f b6 01             	movzbl (%ecx),%eax
    1088:	84 c0                	test   %al,%al
    108a:	74 04                	je     1090 <strcmp+0x25>
    108c:	3a 02                	cmp    (%edx),%al
    108e:	74 ef                	je     107f <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1090:	0f b6 c0             	movzbl %al,%eax
    1093:	0f b6 12             	movzbl (%edx),%edx
    1096:	29 d0                	sub    %edx,%eax
}
    1098:	5d                   	pop    %ebp
    1099:	c3                   	ret    

0000109a <strlen>:

uint
strlen(const char *s)
{
    109a:	55                   	push   %ebp
    109b:	89 e5                	mov    %esp,%ebp
    109d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10a0:	80 39 00             	cmpb   $0x0,(%ecx)
    10a3:	74 12                	je     10b7 <strlen+0x1d>
    10a5:	ba 00 00 00 00       	mov    $0x0,%edx
    10aa:	83 c2 01             	add    $0x1,%edx
    10ad:	89 d0                	mov    %edx,%eax
    10af:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    10b3:	75 f5                	jne    10aa <strlen+0x10>
    ;
  return n;
}
    10b5:	5d                   	pop    %ebp
    10b6:	c3                   	ret    
  for(n = 0; s[n]; n++)
    10b7:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    10bc:	eb f7                	jmp    10b5 <strlen+0x1b>

000010be <memset>:

void*
memset(void *dst, int c, uint n)
{
    10be:	55                   	push   %ebp
    10bf:	89 e5                	mov    %esp,%ebp
    10c1:	57                   	push   %edi
    10c2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10c5:	89 d7                	mov    %edx,%edi
    10c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	fc                   	cld    
    10ce:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10d0:	89 d0                	mov    %edx,%eax
    10d2:	5f                   	pop    %edi
    10d3:	5d                   	pop    %ebp
    10d4:	c3                   	ret    

000010d5 <strchr>:

char*
strchr(const char *s, char c)
{
    10d5:	55                   	push   %ebp
    10d6:	89 e5                	mov    %esp,%ebp
    10d8:	53                   	push   %ebx
    10d9:	8b 45 08             	mov    0x8(%ebp),%eax
    10dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10df:	0f b6 10             	movzbl (%eax),%edx
    10e2:	84 d2                	test   %dl,%dl
    10e4:	74 1e                	je     1104 <strchr+0x2f>
    10e6:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    10e8:	38 d3                	cmp    %dl,%bl
    10ea:	74 15                	je     1101 <strchr+0x2c>
  for(; *s; s++)
    10ec:	83 c0 01             	add    $0x1,%eax
    10ef:	0f b6 10             	movzbl (%eax),%edx
    10f2:	84 d2                	test   %dl,%dl
    10f4:	74 06                	je     10fc <strchr+0x27>
    if(*s == c)
    10f6:	38 ca                	cmp    %cl,%dl
    10f8:	75 f2                	jne    10ec <strchr+0x17>
    10fa:	eb 05                	jmp    1101 <strchr+0x2c>
      return (char*)s;
  return 0;
    10fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1101:	5b                   	pop    %ebx
    1102:	5d                   	pop    %ebp
    1103:	c3                   	ret    
  return 0;
    1104:	b8 00 00 00 00       	mov    $0x0,%eax
    1109:	eb f6                	jmp    1101 <strchr+0x2c>

0000110b <gets>:

char*
gets(char *buf, int max)
{
    110b:	55                   	push   %ebp
    110c:	89 e5                	mov    %esp,%ebp
    110e:	57                   	push   %edi
    110f:	56                   	push   %esi
    1110:	53                   	push   %ebx
    1111:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1114:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1119:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    111c:	8d 5e 01             	lea    0x1(%esi),%ebx
    111f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1122:	7d 2b                	jge    114f <gets+0x44>
    cc = read(0, &c, 1);
    1124:	83 ec 04             	sub    $0x4,%esp
    1127:	6a 01                	push   $0x1
    1129:	57                   	push   %edi
    112a:	6a 00                	push   $0x0
    112c:	e8 f2 00 00 00       	call   1223 <read>
    if(cc < 1)
    1131:	83 c4 10             	add    $0x10,%esp
    1134:	85 c0                	test   %eax,%eax
    1136:	7e 17                	jle    114f <gets+0x44>
      break;
    buf[i++] = c;
    1138:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    113c:	8b 55 08             	mov    0x8(%ebp),%edx
    113f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1143:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1145:	3c 0a                	cmp    $0xa,%al
    1147:	74 04                	je     114d <gets+0x42>
    1149:	3c 0d                	cmp    $0xd,%al
    114b:	75 cf                	jne    111c <gets+0x11>
  for(i=0; i+1 < max; ){
    114d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1156:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1159:	5b                   	pop    %ebx
    115a:	5e                   	pop    %esi
    115b:	5f                   	pop    %edi
    115c:	5d                   	pop    %ebp
    115d:	c3                   	ret    

0000115e <stat>:

int
stat(const char *n, struct stat *st)
{
    115e:	55                   	push   %ebp
    115f:	89 e5                	mov    %esp,%ebp
    1161:	56                   	push   %esi
    1162:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1163:	83 ec 08             	sub    $0x8,%esp
    1166:	6a 00                	push   $0x0
    1168:	ff 75 08             	pushl  0x8(%ebp)
    116b:	e8 db 00 00 00       	call   124b <open>
  if(fd < 0)
    1170:	83 c4 10             	add    $0x10,%esp
    1173:	85 c0                	test   %eax,%eax
    1175:	78 24                	js     119b <stat+0x3d>
    1177:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1179:	83 ec 08             	sub    $0x8,%esp
    117c:	ff 75 0c             	pushl  0xc(%ebp)
    117f:	50                   	push   %eax
    1180:	e8 de 00 00 00       	call   1263 <fstat>
    1185:	89 c6                	mov    %eax,%esi
  close(fd);
    1187:	89 1c 24             	mov    %ebx,(%esp)
    118a:	e8 a4 00 00 00       	call   1233 <close>
  return r;
    118f:	83 c4 10             	add    $0x10,%esp
}
    1192:	89 f0                	mov    %esi,%eax
    1194:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1197:	5b                   	pop    %ebx
    1198:	5e                   	pop    %esi
    1199:	5d                   	pop    %ebp
    119a:	c3                   	ret    
    return -1;
    119b:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11a0:	eb f0                	jmp    1192 <stat+0x34>

000011a2 <atoi>:

int
atoi(const char *s)
{
    11a2:	55                   	push   %ebp
    11a3:	89 e5                	mov    %esp,%ebp
    11a5:	53                   	push   %ebx
    11a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11a9:	0f b6 11             	movzbl (%ecx),%edx
    11ac:	8d 42 d0             	lea    -0x30(%edx),%eax
    11af:	3c 09                	cmp    $0x9,%al
    11b1:	77 20                	ja     11d3 <atoi+0x31>
  n = 0;
    11b3:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    11b8:	83 c1 01             	add    $0x1,%ecx
    11bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11be:	0f be d2             	movsbl %dl,%edx
    11c1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11c5:	0f b6 11             	movzbl (%ecx),%edx
    11c8:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11cb:	80 fb 09             	cmp    $0x9,%bl
    11ce:	76 e8                	jbe    11b8 <atoi+0x16>
  return n;
}
    11d0:	5b                   	pop    %ebx
    11d1:	5d                   	pop    %ebp
    11d2:	c3                   	ret    
  n = 0;
    11d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11d8:	eb f6                	jmp    11d0 <atoi+0x2e>

000011da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11da:	55                   	push   %ebp
    11db:	89 e5                	mov    %esp,%ebp
    11dd:	56                   	push   %esi
    11de:	53                   	push   %ebx
    11df:	8b 45 08             	mov    0x8(%ebp),%eax
    11e2:	8b 75 0c             	mov    0xc(%ebp),%esi
    11e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11e8:	85 db                	test   %ebx,%ebx
    11ea:	7e 13                	jle    11ff <memmove+0x25>
    11ec:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    11f1:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    11f5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    11f8:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    11fb:	39 d3                	cmp    %edx,%ebx
    11fd:	75 f2                	jne    11f1 <memmove+0x17>
  return vdst;
}
    11ff:	5b                   	pop    %ebx
    1200:	5e                   	pop    %esi
    1201:	5d                   	pop    %ebp
    1202:	c3                   	ret    

00001203 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1203:	b8 01 00 00 00       	mov    $0x1,%eax
    1208:	cd 40                	int    $0x40
    120a:	c3                   	ret    

0000120b <exit>:
SYSCALL(exit)
    120b:	b8 02 00 00 00       	mov    $0x2,%eax
    1210:	cd 40                	int    $0x40
    1212:	c3                   	ret    

00001213 <wait>:
SYSCALL(wait)
    1213:	b8 03 00 00 00       	mov    $0x3,%eax
    1218:	cd 40                	int    $0x40
    121a:	c3                   	ret    

0000121b <pipe>:
SYSCALL(pipe)
    121b:	b8 04 00 00 00       	mov    $0x4,%eax
    1220:	cd 40                	int    $0x40
    1222:	c3                   	ret    

00001223 <read>:
SYSCALL(read)
    1223:	b8 05 00 00 00       	mov    $0x5,%eax
    1228:	cd 40                	int    $0x40
    122a:	c3                   	ret    

0000122b <write>:
SYSCALL(write)
    122b:	b8 10 00 00 00       	mov    $0x10,%eax
    1230:	cd 40                	int    $0x40
    1232:	c3                   	ret    

00001233 <close>:
SYSCALL(close)
    1233:	b8 15 00 00 00       	mov    $0x15,%eax
    1238:	cd 40                	int    $0x40
    123a:	c3                   	ret    

0000123b <kill>:
SYSCALL(kill)
    123b:	b8 06 00 00 00       	mov    $0x6,%eax
    1240:	cd 40                	int    $0x40
    1242:	c3                   	ret    

00001243 <exec>:
SYSCALL(exec)
    1243:	b8 07 00 00 00       	mov    $0x7,%eax
    1248:	cd 40                	int    $0x40
    124a:	c3                   	ret    

0000124b <open>:
SYSCALL(open)
    124b:	b8 0f 00 00 00       	mov    $0xf,%eax
    1250:	cd 40                	int    $0x40
    1252:	c3                   	ret    

00001253 <mknod>:
SYSCALL(mknod)
    1253:	b8 11 00 00 00       	mov    $0x11,%eax
    1258:	cd 40                	int    $0x40
    125a:	c3                   	ret    

0000125b <unlink>:
SYSCALL(unlink)
    125b:	b8 12 00 00 00       	mov    $0x12,%eax
    1260:	cd 40                	int    $0x40
    1262:	c3                   	ret    

00001263 <fstat>:
SYSCALL(fstat)
    1263:	b8 08 00 00 00       	mov    $0x8,%eax
    1268:	cd 40                	int    $0x40
    126a:	c3                   	ret    

0000126b <link>:
SYSCALL(link)
    126b:	b8 13 00 00 00       	mov    $0x13,%eax
    1270:	cd 40                	int    $0x40
    1272:	c3                   	ret    

00001273 <mkdir>:
SYSCALL(mkdir)
    1273:	b8 14 00 00 00       	mov    $0x14,%eax
    1278:	cd 40                	int    $0x40
    127a:	c3                   	ret    

0000127b <chdir>:
SYSCALL(chdir)
    127b:	b8 09 00 00 00       	mov    $0x9,%eax
    1280:	cd 40                	int    $0x40
    1282:	c3                   	ret    

00001283 <dup>:
SYSCALL(dup)
    1283:	b8 0a 00 00 00       	mov    $0xa,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <getpid>:
SYSCALL(getpid)
    128b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <sbrk>:
SYSCALL(sbrk)
    1293:	b8 0c 00 00 00       	mov    $0xc,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <sleep>:
SYSCALL(sleep)
    129b:	b8 0d 00 00 00       	mov    $0xd,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <uptime>:
SYSCALL(uptime)
    12a3:	b8 0e 00 00 00       	mov    $0xe,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <shmem_access>:
SYSCALL(shmem_access)
    12ab:	b8 16 00 00 00       	mov    $0x16,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <shmem_count>:
    12b3:	b8 17 00 00 00       	mov    $0x17,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12bb:	55                   	push   %ebp
    12bc:	89 e5                	mov    %esp,%ebp
    12be:	57                   	push   %edi
    12bf:	56                   	push   %esi
    12c0:	53                   	push   %ebx
    12c1:	83 ec 3c             	sub    $0x3c,%esp
    12c4:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12ca:	74 14                	je     12e0 <printint+0x25>
    12cc:	85 d2                	test   %edx,%edx
    12ce:	79 10                	jns    12e0 <printint+0x25>
    neg = 1;
    x = -xx;
    12d0:	f7 da                	neg    %edx
    neg = 1;
    12d2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12d9:	bf 00 00 00 00       	mov    $0x0,%edi
    12de:	eb 0b                	jmp    12eb <printint+0x30>
  neg = 0;
    12e0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12e7:	eb f0                	jmp    12d9 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    12e9:	89 df                	mov    %ebx,%edi
    12eb:	8d 5f 01             	lea    0x1(%edi),%ebx
    12ee:	89 d0                	mov    %edx,%eax
    12f0:	ba 00 00 00 00       	mov    $0x0,%edx
    12f5:	f7 f1                	div    %ecx
    12f7:	0f b6 92 88 16 00 00 	movzbl 0x1688(%edx),%edx
    12fe:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1302:	89 c2                	mov    %eax,%edx
    1304:	85 c0                	test   %eax,%eax
    1306:	75 e1                	jne    12e9 <printint+0x2e>
  if(neg)
    1308:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    130c:	74 08                	je     1316 <printint+0x5b>
    buf[i++] = '-';
    130e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1313:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1316:	83 eb 01             	sub    $0x1,%ebx
    1319:	78 22                	js     133d <printint+0x82>
  write(fd, &c, 1);
    131b:	8d 7d d7             	lea    -0x29(%ebp),%edi
    131e:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1323:	88 45 d7             	mov    %al,-0x29(%ebp)
    1326:	83 ec 04             	sub    $0x4,%esp
    1329:	6a 01                	push   $0x1
    132b:	57                   	push   %edi
    132c:	56                   	push   %esi
    132d:	e8 f9 fe ff ff       	call   122b <write>
  while(--i >= 0)
    1332:	83 eb 01             	sub    $0x1,%ebx
    1335:	83 c4 10             	add    $0x10,%esp
    1338:	83 fb ff             	cmp    $0xffffffff,%ebx
    133b:	75 e1                	jne    131e <printint+0x63>
    putc(fd, buf[i]);
}
    133d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1340:	5b                   	pop    %ebx
    1341:	5e                   	pop    %esi
    1342:	5f                   	pop    %edi
    1343:	5d                   	pop    %ebp
    1344:	c3                   	ret    

00001345 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1345:	55                   	push   %ebp
    1346:	89 e5                	mov    %esp,%ebp
    1348:	57                   	push   %edi
    1349:	56                   	push   %esi
    134a:	53                   	push   %ebx
    134b:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    134e:	8b 75 0c             	mov    0xc(%ebp),%esi
    1351:	0f b6 1e             	movzbl (%esi),%ebx
    1354:	84 db                	test   %bl,%bl
    1356:	0f 84 b1 01 00 00    	je     150d <printf+0x1c8>
    135c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    135f:	8d 45 10             	lea    0x10(%ebp),%eax
    1362:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1365:	bf 00 00 00 00       	mov    $0x0,%edi
    136a:	eb 2d                	jmp    1399 <printf+0x54>
    136c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    136f:	83 ec 04             	sub    $0x4,%esp
    1372:	6a 01                	push   $0x1
    1374:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1377:	50                   	push   %eax
    1378:	ff 75 08             	pushl  0x8(%ebp)
    137b:	e8 ab fe ff ff       	call   122b <write>
    1380:	83 c4 10             	add    $0x10,%esp
    1383:	eb 05                	jmp    138a <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1385:	83 ff 25             	cmp    $0x25,%edi
    1388:	74 22                	je     13ac <printf+0x67>
    138a:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    138d:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1391:	84 db                	test   %bl,%bl
    1393:	0f 84 74 01 00 00    	je     150d <printf+0x1c8>
    c = fmt[i] & 0xff;
    1399:	0f be d3             	movsbl %bl,%edx
    139c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    139f:	85 ff                	test   %edi,%edi
    13a1:	75 e2                	jne    1385 <printf+0x40>
      if(c == '%'){
    13a3:	83 f8 25             	cmp    $0x25,%eax
    13a6:	75 c4                	jne    136c <printf+0x27>
        state = '%';
    13a8:	89 c7                	mov    %eax,%edi
    13aa:	eb de                	jmp    138a <printf+0x45>
      if(c == 'd'){
    13ac:	83 f8 64             	cmp    $0x64,%eax
    13af:	74 59                	je     140a <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13b1:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    13b7:	83 fa 70             	cmp    $0x70,%edx
    13ba:	74 7a                	je     1436 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13bc:	83 f8 73             	cmp    $0x73,%eax
    13bf:	0f 84 9d 00 00 00    	je     1462 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13c5:	83 f8 63             	cmp    $0x63,%eax
    13c8:	0f 84 f2 00 00 00    	je     14c0 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13ce:	83 f8 25             	cmp    $0x25,%eax
    13d1:	0f 84 15 01 00 00    	je     14ec <printf+0x1a7>
    13d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    13db:	83 ec 04             	sub    $0x4,%esp
    13de:	6a 01                	push   $0x1
    13e0:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13e3:	50                   	push   %eax
    13e4:	ff 75 08             	pushl  0x8(%ebp)
    13e7:	e8 3f fe ff ff       	call   122b <write>
    13ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    13ef:	83 c4 0c             	add    $0xc,%esp
    13f2:	6a 01                	push   $0x1
    13f4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    13f7:	50                   	push   %eax
    13f8:	ff 75 08             	pushl  0x8(%ebp)
    13fb:	e8 2b fe ff ff       	call   122b <write>
    1400:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1403:	bf 00 00 00 00       	mov    $0x0,%edi
    1408:	eb 80                	jmp    138a <printf+0x45>
        printint(fd, *ap, 10, 1);
    140a:	83 ec 0c             	sub    $0xc,%esp
    140d:	6a 01                	push   $0x1
    140f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1414:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1417:	8b 17                	mov    (%edi),%edx
    1419:	8b 45 08             	mov    0x8(%ebp),%eax
    141c:	e8 9a fe ff ff       	call   12bb <printint>
        ap++;
    1421:	89 f8                	mov    %edi,%eax
    1423:	83 c0 04             	add    $0x4,%eax
    1426:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1429:	83 c4 10             	add    $0x10,%esp
      state = 0;
    142c:	bf 00 00 00 00       	mov    $0x0,%edi
    1431:	e9 54 ff ff ff       	jmp    138a <printf+0x45>
        printint(fd, *ap, 16, 0);
    1436:	83 ec 0c             	sub    $0xc,%esp
    1439:	6a 00                	push   $0x0
    143b:	b9 10 00 00 00       	mov    $0x10,%ecx
    1440:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1443:	8b 17                	mov    (%edi),%edx
    1445:	8b 45 08             	mov    0x8(%ebp),%eax
    1448:	e8 6e fe ff ff       	call   12bb <printint>
        ap++;
    144d:	89 f8                	mov    %edi,%eax
    144f:	83 c0 04             	add    $0x4,%eax
    1452:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1455:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1458:	bf 00 00 00 00       	mov    $0x0,%edi
    145d:	e9 28 ff ff ff       	jmp    138a <printf+0x45>
        s = (char*)*ap;
    1462:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1465:	8b 01                	mov    (%ecx),%eax
        ap++;
    1467:	83 c1 04             	add    $0x4,%ecx
    146a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    146d:	85 c0                	test   %eax,%eax
    146f:	74 13                	je     1484 <printf+0x13f>
        s = (char*)*ap;
    1471:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1473:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1476:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    147b:	84 c0                	test   %al,%al
    147d:	75 0f                	jne    148e <printf+0x149>
    147f:	e9 06 ff ff ff       	jmp    138a <printf+0x45>
          s = "(null)";
    1484:	bb 81 16 00 00       	mov    $0x1681,%ebx
        while(*s != 0){
    1489:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    148e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1491:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1494:	8b 75 08             	mov    0x8(%ebp),%esi
    1497:	88 45 e3             	mov    %al,-0x1d(%ebp)
    149a:	83 ec 04             	sub    $0x4,%esp
    149d:	6a 01                	push   $0x1
    149f:	57                   	push   %edi
    14a0:	56                   	push   %esi
    14a1:	e8 85 fd ff ff       	call   122b <write>
          s++;
    14a6:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    14a9:	0f b6 03             	movzbl (%ebx),%eax
    14ac:	83 c4 10             	add    $0x10,%esp
    14af:	84 c0                	test   %al,%al
    14b1:	75 e4                	jne    1497 <printf+0x152>
    14b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    14b6:	bf 00 00 00 00       	mov    $0x0,%edi
    14bb:	e9 ca fe ff ff       	jmp    138a <printf+0x45>
        putc(fd, *ap);
    14c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14c3:	8b 07                	mov    (%edi),%eax
    14c5:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14c8:	83 ec 04             	sub    $0x4,%esp
    14cb:	6a 01                	push   $0x1
    14cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14d0:	50                   	push   %eax
    14d1:	ff 75 08             	pushl  0x8(%ebp)
    14d4:	e8 52 fd ff ff       	call   122b <write>
        ap++;
    14d9:	83 c7 04             	add    $0x4,%edi
    14dc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14df:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14e2:	bf 00 00 00 00       	mov    $0x0,%edi
    14e7:	e9 9e fe ff ff       	jmp    138a <printf+0x45>
    14ec:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    14ef:	83 ec 04             	sub    $0x4,%esp
    14f2:	6a 01                	push   $0x1
    14f4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    14f7:	50                   	push   %eax
    14f8:	ff 75 08             	pushl  0x8(%ebp)
    14fb:	e8 2b fd ff ff       	call   122b <write>
    1500:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1503:	bf 00 00 00 00       	mov    $0x0,%edi
    1508:	e9 7d fe ff ff       	jmp    138a <printf+0x45>
    }
  }
}
    150d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1510:	5b                   	pop    %ebx
    1511:	5e                   	pop    %esi
    1512:	5f                   	pop    %edi
    1513:	5d                   	pop    %ebp
    1514:	c3                   	ret    

00001515 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1515:	55                   	push   %ebp
    1516:	89 e5                	mov    %esp,%ebp
    1518:	57                   	push   %edi
    1519:	56                   	push   %esi
    151a:	53                   	push   %ebx
    151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    151e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1521:	a1 f4 18 00 00       	mov    0x18f4,%eax
    1526:	eb 0c                	jmp    1534 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1528:	8b 10                	mov    (%eax),%edx
    152a:	39 c2                	cmp    %eax,%edx
    152c:	77 04                	ja     1532 <free+0x1d>
    152e:	39 ca                	cmp    %ecx,%edx
    1530:	77 10                	ja     1542 <free+0x2d>
{
    1532:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1534:	39 c8                	cmp    %ecx,%eax
    1536:	73 f0                	jae    1528 <free+0x13>
    1538:	8b 10                	mov    (%eax),%edx
    153a:	39 ca                	cmp    %ecx,%edx
    153c:	77 04                	ja     1542 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    153e:	39 c2                	cmp    %eax,%edx
    1540:	77 f0                	ja     1532 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1542:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1545:	8b 10                	mov    (%eax),%edx
    1547:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    154a:	39 fa                	cmp    %edi,%edx
    154c:	74 19                	je     1567 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    154e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1551:	8b 50 04             	mov    0x4(%eax),%edx
    1554:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1557:	39 f1                	cmp    %esi,%ecx
    1559:	74 1b                	je     1576 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    155b:	89 08                	mov    %ecx,(%eax)
  freep = p;
    155d:	a3 f4 18 00 00       	mov    %eax,0x18f4
}
    1562:	5b                   	pop    %ebx
    1563:	5e                   	pop    %esi
    1564:	5f                   	pop    %edi
    1565:	5d                   	pop    %ebp
    1566:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1567:	03 72 04             	add    0x4(%edx),%esi
    156a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    156d:	8b 10                	mov    (%eax),%edx
    156f:	8b 12                	mov    (%edx),%edx
    1571:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1574:	eb db                	jmp    1551 <free+0x3c>
    p->s.size += bp->s.size;
    1576:	03 53 fc             	add    -0x4(%ebx),%edx
    1579:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    157c:	8b 53 f8             	mov    -0x8(%ebx),%edx
    157f:	89 10                	mov    %edx,(%eax)
    1581:	eb da                	jmp    155d <free+0x48>

00001583 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1583:	55                   	push   %ebp
    1584:	89 e5                	mov    %esp,%ebp
    1586:	57                   	push   %edi
    1587:	56                   	push   %esi
    1588:	53                   	push   %ebx
    1589:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    158c:	8b 45 08             	mov    0x8(%ebp),%eax
    158f:	8d 58 07             	lea    0x7(%eax),%ebx
    1592:	c1 eb 03             	shr    $0x3,%ebx
    1595:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1598:	8b 15 f4 18 00 00    	mov    0x18f4,%edx
    159e:	85 d2                	test   %edx,%edx
    15a0:	74 20                	je     15c2 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15a2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15a4:	8b 48 04             	mov    0x4(%eax),%ecx
    15a7:	39 cb                	cmp    %ecx,%ebx
    15a9:	76 3c                	jbe    15e7 <malloc+0x64>
    15ab:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    15b1:	be 00 10 00 00       	mov    $0x1000,%esi
    15b6:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    15b9:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15c0:	eb 70                	jmp    1632 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15c2:	c7 05 f4 18 00 00 f8 	movl   $0x18f8,0x18f4
    15c9:	18 00 00 
    15cc:	c7 05 f8 18 00 00 f8 	movl   $0x18f8,0x18f8
    15d3:	18 00 00 
    base.s.size = 0;
    15d6:	c7 05 fc 18 00 00 00 	movl   $0x0,0x18fc
    15dd:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    15e0:	ba f8 18 00 00       	mov    $0x18f8,%edx
    15e5:	eb bb                	jmp    15a2 <malloc+0x1f>
      if(p->s.size == nunits)
    15e7:	39 cb                	cmp    %ecx,%ebx
    15e9:	74 1c                	je     1607 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    15eb:	29 d9                	sub    %ebx,%ecx
    15ed:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    15f0:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    15f3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    15f6:	89 15 f4 18 00 00    	mov    %edx,0x18f4
      return (void*)(p + 1);
    15fc:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    15ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1602:	5b                   	pop    %ebx
    1603:	5e                   	pop    %esi
    1604:	5f                   	pop    %edi
    1605:	5d                   	pop    %ebp
    1606:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1607:	8b 08                	mov    (%eax),%ecx
    1609:	89 0a                	mov    %ecx,(%edx)
    160b:	eb e9                	jmp    15f6 <malloc+0x73>
  hp->s.size = nu;
    160d:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1610:	83 ec 0c             	sub    $0xc,%esp
    1613:	83 c0 08             	add    $0x8,%eax
    1616:	50                   	push   %eax
    1617:	e8 f9 fe ff ff       	call   1515 <free>
  return freep;
    161c:	8b 15 f4 18 00 00    	mov    0x18f4,%edx
      if((p = morecore(nunits)) == 0)
    1622:	83 c4 10             	add    $0x10,%esp
    1625:	85 d2                	test   %edx,%edx
    1627:	74 2b                	je     1654 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1629:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    162b:	8b 48 04             	mov    0x4(%eax),%ecx
    162e:	39 d9                	cmp    %ebx,%ecx
    1630:	73 b5                	jae    15e7 <malloc+0x64>
    1632:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1634:	39 05 f4 18 00 00    	cmp    %eax,0x18f4
    163a:	75 ed                	jne    1629 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    163c:	83 ec 0c             	sub    $0xc,%esp
    163f:	57                   	push   %edi
    1640:	e8 4e fc ff ff       	call   1293 <sbrk>
  if(p == (char*)-1)
    1645:	83 c4 10             	add    $0x10,%esp
    1648:	83 f8 ff             	cmp    $0xffffffff,%eax
    164b:	75 c0                	jne    160d <malloc+0x8a>
        return 0;
    164d:	b8 00 00 00 00       	mov    $0x0,%eax
    1652:	eb ab                	jmp    15ff <malloc+0x7c>
    1654:	b8 00 00 00 00       	mov    $0x0,%eax
    1659:	eb a4                	jmp    15ff <malloc+0x7c>
