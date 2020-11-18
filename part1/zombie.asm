
_zombie:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	51                   	push   %ecx
    100e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
    1011:	e8 d0 01 00 00       	call   11e6 <fork>
    1016:	85 c0                	test   %eax,%eax
    1018:	7f 05                	jg     101f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
    101a:	e8 cf 01 00 00       	call   11ee <exit>
    sleep(5);  // Let child exit before parent.
    101f:	83 ec 0c             	sub    $0xc,%esp
    1022:	6a 05                	push   $0x5
    1024:	e8 55 02 00 00       	call   127e <sleep>
    1029:	83 c4 10             	add    $0x10,%esp
    102c:	eb ec                	jmp    101a <main+0x1a>

0000102e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    102e:	55                   	push   %ebp
    102f:	89 e5                	mov    %esp,%ebp
    1031:	53                   	push   %ebx
    1032:	8b 45 08             	mov    0x8(%ebp),%eax
    1035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1038:	89 c2                	mov    %eax,%edx
    103a:	83 c1 01             	add    $0x1,%ecx
    103d:	83 c2 01             	add    $0x1,%edx
    1040:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1044:	88 5a ff             	mov    %bl,-0x1(%edx)
    1047:	84 db                	test   %bl,%bl
    1049:	75 ef                	jne    103a <strcpy+0xc>
    ;
  return os;
}
    104b:	5b                   	pop    %ebx
    104c:	5d                   	pop    %ebp
    104d:	c3                   	ret    

0000104e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    104e:	55                   	push   %ebp
    104f:	89 e5                	mov    %esp,%ebp
    1051:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1054:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1057:	0f b6 01             	movzbl (%ecx),%eax
    105a:	84 c0                	test   %al,%al
    105c:	74 15                	je     1073 <strcmp+0x25>
    105e:	3a 02                	cmp    (%edx),%al
    1060:	75 11                	jne    1073 <strcmp+0x25>
    p++, q++;
    1062:	83 c1 01             	add    $0x1,%ecx
    1065:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1068:	0f b6 01             	movzbl (%ecx),%eax
    106b:	84 c0                	test   %al,%al
    106d:	74 04                	je     1073 <strcmp+0x25>
    106f:	3a 02                	cmp    (%edx),%al
    1071:	74 ef                	je     1062 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1073:	0f b6 c0             	movzbl %al,%eax
    1076:	0f b6 12             	movzbl (%edx),%edx
    1079:	29 d0                	sub    %edx,%eax
}
    107b:	5d                   	pop    %ebp
    107c:	c3                   	ret    

0000107d <strlen>:

uint
strlen(const char *s)
{
    107d:	55                   	push   %ebp
    107e:	89 e5                	mov    %esp,%ebp
    1080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1083:	80 39 00             	cmpb   $0x0,(%ecx)
    1086:	74 12                	je     109a <strlen+0x1d>
    1088:	ba 00 00 00 00       	mov    $0x0,%edx
    108d:	83 c2 01             	add    $0x1,%edx
    1090:	89 d0                	mov    %edx,%eax
    1092:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1096:	75 f5                	jne    108d <strlen+0x10>
    ;
  return n;
}
    1098:	5d                   	pop    %ebp
    1099:	c3                   	ret    
  for(n = 0; s[n]; n++)
    109a:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    109f:	eb f7                	jmp    1098 <strlen+0x1b>

000010a1 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10a1:	55                   	push   %ebp
    10a2:	89 e5                	mov    %esp,%ebp
    10a4:	57                   	push   %edi
    10a5:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10a8:	89 d7                	mov    %edx,%edi
    10aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b0:	fc                   	cld    
    10b1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10b3:	89 d0                	mov    %edx,%eax
    10b5:	5f                   	pop    %edi
    10b6:	5d                   	pop    %ebp
    10b7:	c3                   	ret    

000010b8 <strchr>:

char*
strchr(const char *s, char c)
{
    10b8:	55                   	push   %ebp
    10b9:	89 e5                	mov    %esp,%ebp
    10bb:	53                   	push   %ebx
    10bc:	8b 45 08             	mov    0x8(%ebp),%eax
    10bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10c2:	0f b6 10             	movzbl (%eax),%edx
    10c5:	84 d2                	test   %dl,%dl
    10c7:	74 1e                	je     10e7 <strchr+0x2f>
    10c9:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    10cb:	38 d3                	cmp    %dl,%bl
    10cd:	74 15                	je     10e4 <strchr+0x2c>
  for(; *s; s++)
    10cf:	83 c0 01             	add    $0x1,%eax
    10d2:	0f b6 10             	movzbl (%eax),%edx
    10d5:	84 d2                	test   %dl,%dl
    10d7:	74 06                	je     10df <strchr+0x27>
    if(*s == c)
    10d9:	38 ca                	cmp    %cl,%dl
    10db:	75 f2                	jne    10cf <strchr+0x17>
    10dd:	eb 05                	jmp    10e4 <strchr+0x2c>
      return (char*)s;
  return 0;
    10df:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10e4:	5b                   	pop    %ebx
    10e5:	5d                   	pop    %ebp
    10e6:	c3                   	ret    
  return 0;
    10e7:	b8 00 00 00 00       	mov    $0x0,%eax
    10ec:	eb f6                	jmp    10e4 <strchr+0x2c>

000010ee <gets>:

char*
gets(char *buf, int max)
{
    10ee:	55                   	push   %ebp
    10ef:	89 e5                	mov    %esp,%ebp
    10f1:	57                   	push   %edi
    10f2:	56                   	push   %esi
    10f3:	53                   	push   %ebx
    10f4:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    10f7:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    10fc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    10ff:	8d 5e 01             	lea    0x1(%esi),%ebx
    1102:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1105:	7d 2b                	jge    1132 <gets+0x44>
    cc = read(0, &c, 1);
    1107:	83 ec 04             	sub    $0x4,%esp
    110a:	6a 01                	push   $0x1
    110c:	57                   	push   %edi
    110d:	6a 00                	push   $0x0
    110f:	e8 f2 00 00 00       	call   1206 <read>
    if(cc < 1)
    1114:	83 c4 10             	add    $0x10,%esp
    1117:	85 c0                	test   %eax,%eax
    1119:	7e 17                	jle    1132 <gets+0x44>
      break;
    buf[i++] = c;
    111b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    111f:	8b 55 08             	mov    0x8(%ebp),%edx
    1122:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1126:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1128:	3c 0a                	cmp    $0xa,%al
    112a:	74 04                	je     1130 <gets+0x42>
    112c:	3c 0d                	cmp    $0xd,%al
    112e:	75 cf                	jne    10ff <gets+0x11>
  for(i=0; i+1 < max; ){
    1130:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1132:	8b 45 08             	mov    0x8(%ebp),%eax
    1135:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1139:	8d 65 f4             	lea    -0xc(%ebp),%esp
    113c:	5b                   	pop    %ebx
    113d:	5e                   	pop    %esi
    113e:	5f                   	pop    %edi
    113f:	5d                   	pop    %ebp
    1140:	c3                   	ret    

00001141 <stat>:

int
stat(const char *n, struct stat *st)
{
    1141:	55                   	push   %ebp
    1142:	89 e5                	mov    %esp,%ebp
    1144:	56                   	push   %esi
    1145:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1146:	83 ec 08             	sub    $0x8,%esp
    1149:	6a 00                	push   $0x0
    114b:	ff 75 08             	pushl  0x8(%ebp)
    114e:	e8 db 00 00 00       	call   122e <open>
  if(fd < 0)
    1153:	83 c4 10             	add    $0x10,%esp
    1156:	85 c0                	test   %eax,%eax
    1158:	78 24                	js     117e <stat+0x3d>
    115a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    115c:	83 ec 08             	sub    $0x8,%esp
    115f:	ff 75 0c             	pushl  0xc(%ebp)
    1162:	50                   	push   %eax
    1163:	e8 de 00 00 00       	call   1246 <fstat>
    1168:	89 c6                	mov    %eax,%esi
  close(fd);
    116a:	89 1c 24             	mov    %ebx,(%esp)
    116d:	e8 a4 00 00 00       	call   1216 <close>
  return r;
    1172:	83 c4 10             	add    $0x10,%esp
}
    1175:	89 f0                	mov    %esi,%eax
    1177:	8d 65 f8             	lea    -0x8(%ebp),%esp
    117a:	5b                   	pop    %ebx
    117b:	5e                   	pop    %esi
    117c:	5d                   	pop    %ebp
    117d:	c3                   	ret    
    return -1;
    117e:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1183:	eb f0                	jmp    1175 <stat+0x34>

00001185 <atoi>:

int
atoi(const char *s)
{
    1185:	55                   	push   %ebp
    1186:	89 e5                	mov    %esp,%ebp
    1188:	53                   	push   %ebx
    1189:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    118c:	0f b6 11             	movzbl (%ecx),%edx
    118f:	8d 42 d0             	lea    -0x30(%edx),%eax
    1192:	3c 09                	cmp    $0x9,%al
    1194:	77 20                	ja     11b6 <atoi+0x31>
  n = 0;
    1196:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    119b:	83 c1 01             	add    $0x1,%ecx
    119e:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11a1:	0f be d2             	movsbl %dl,%edx
    11a4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11a8:	0f b6 11             	movzbl (%ecx),%edx
    11ab:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11ae:	80 fb 09             	cmp    $0x9,%bl
    11b1:	76 e8                	jbe    119b <atoi+0x16>
  return n;
}
    11b3:	5b                   	pop    %ebx
    11b4:	5d                   	pop    %ebp
    11b5:	c3                   	ret    
  n = 0;
    11b6:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11bb:	eb f6                	jmp    11b3 <atoi+0x2e>

000011bd <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11bd:	55                   	push   %ebp
    11be:	89 e5                	mov    %esp,%ebp
    11c0:	56                   	push   %esi
    11c1:	53                   	push   %ebx
    11c2:	8b 45 08             	mov    0x8(%ebp),%eax
    11c5:	8b 75 0c             	mov    0xc(%ebp),%esi
    11c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11cb:	85 db                	test   %ebx,%ebx
    11cd:	7e 13                	jle    11e2 <memmove+0x25>
    11cf:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    11d4:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    11d8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    11db:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    11de:	39 d3                	cmp    %edx,%ebx
    11e0:	75 f2                	jne    11d4 <memmove+0x17>
  return vdst;
}
    11e2:	5b                   	pop    %ebx
    11e3:	5e                   	pop    %esi
    11e4:	5d                   	pop    %ebp
    11e5:	c3                   	ret    

000011e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11e6:	b8 01 00 00 00       	mov    $0x1,%eax
    11eb:	cd 40                	int    $0x40
    11ed:	c3                   	ret    

000011ee <exit>:
SYSCALL(exit)
    11ee:	b8 02 00 00 00       	mov    $0x2,%eax
    11f3:	cd 40                	int    $0x40
    11f5:	c3                   	ret    

000011f6 <wait>:
SYSCALL(wait)
    11f6:	b8 03 00 00 00       	mov    $0x3,%eax
    11fb:	cd 40                	int    $0x40
    11fd:	c3                   	ret    

000011fe <pipe>:
SYSCALL(pipe)
    11fe:	b8 04 00 00 00       	mov    $0x4,%eax
    1203:	cd 40                	int    $0x40
    1205:	c3                   	ret    

00001206 <read>:
SYSCALL(read)
    1206:	b8 05 00 00 00       	mov    $0x5,%eax
    120b:	cd 40                	int    $0x40
    120d:	c3                   	ret    

0000120e <write>:
SYSCALL(write)
    120e:	b8 10 00 00 00       	mov    $0x10,%eax
    1213:	cd 40                	int    $0x40
    1215:	c3                   	ret    

00001216 <close>:
SYSCALL(close)
    1216:	b8 15 00 00 00       	mov    $0x15,%eax
    121b:	cd 40                	int    $0x40
    121d:	c3                   	ret    

0000121e <kill>:
SYSCALL(kill)
    121e:	b8 06 00 00 00       	mov    $0x6,%eax
    1223:	cd 40                	int    $0x40
    1225:	c3                   	ret    

00001226 <exec>:
SYSCALL(exec)
    1226:	b8 07 00 00 00       	mov    $0x7,%eax
    122b:	cd 40                	int    $0x40
    122d:	c3                   	ret    

0000122e <open>:
SYSCALL(open)
    122e:	b8 0f 00 00 00       	mov    $0xf,%eax
    1233:	cd 40                	int    $0x40
    1235:	c3                   	ret    

00001236 <mknod>:
SYSCALL(mknod)
    1236:	b8 11 00 00 00       	mov    $0x11,%eax
    123b:	cd 40                	int    $0x40
    123d:	c3                   	ret    

0000123e <unlink>:
SYSCALL(unlink)
    123e:	b8 12 00 00 00       	mov    $0x12,%eax
    1243:	cd 40                	int    $0x40
    1245:	c3                   	ret    

00001246 <fstat>:
SYSCALL(fstat)
    1246:	b8 08 00 00 00       	mov    $0x8,%eax
    124b:	cd 40                	int    $0x40
    124d:	c3                   	ret    

0000124e <link>:
SYSCALL(link)
    124e:	b8 13 00 00 00       	mov    $0x13,%eax
    1253:	cd 40                	int    $0x40
    1255:	c3                   	ret    

00001256 <mkdir>:
SYSCALL(mkdir)
    1256:	b8 14 00 00 00       	mov    $0x14,%eax
    125b:	cd 40                	int    $0x40
    125d:	c3                   	ret    

0000125e <chdir>:
SYSCALL(chdir)
    125e:	b8 09 00 00 00       	mov    $0x9,%eax
    1263:	cd 40                	int    $0x40
    1265:	c3                   	ret    

00001266 <dup>:
SYSCALL(dup)
    1266:	b8 0a 00 00 00       	mov    $0xa,%eax
    126b:	cd 40                	int    $0x40
    126d:	c3                   	ret    

0000126e <getpid>:
SYSCALL(getpid)
    126e:	b8 0b 00 00 00       	mov    $0xb,%eax
    1273:	cd 40                	int    $0x40
    1275:	c3                   	ret    

00001276 <sbrk>:
SYSCALL(sbrk)
    1276:	b8 0c 00 00 00       	mov    $0xc,%eax
    127b:	cd 40                	int    $0x40
    127d:	c3                   	ret    

0000127e <sleep>:
SYSCALL(sleep)
    127e:	b8 0d 00 00 00       	mov    $0xd,%eax
    1283:	cd 40                	int    $0x40
    1285:	c3                   	ret    

00001286 <uptime>:
SYSCALL(uptime)
    1286:	b8 0e 00 00 00       	mov    $0xe,%eax
    128b:	cd 40                	int    $0x40
    128d:	c3                   	ret    

0000128e <shmem_access>:
SYSCALL(shmem_access)
    128e:	b8 16 00 00 00       	mov    $0x16,%eax
    1293:	cd 40                	int    $0x40
    1295:	c3                   	ret    

00001296 <shmem_count>:
    1296:	b8 17 00 00 00       	mov    $0x17,%eax
    129b:	cd 40                	int    $0x40
    129d:	c3                   	ret    

0000129e <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    129e:	55                   	push   %ebp
    129f:	89 e5                	mov    %esp,%ebp
    12a1:	57                   	push   %edi
    12a2:	56                   	push   %esi
    12a3:	53                   	push   %ebx
    12a4:	83 ec 3c             	sub    $0x3c,%esp
    12a7:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12ad:	74 14                	je     12c3 <printint+0x25>
    12af:	85 d2                	test   %edx,%edx
    12b1:	79 10                	jns    12c3 <printint+0x25>
    neg = 1;
    x = -xx;
    12b3:	f7 da                	neg    %edx
    neg = 1;
    12b5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12bc:	bf 00 00 00 00       	mov    $0x0,%edi
    12c1:	eb 0b                	jmp    12ce <printint+0x30>
  neg = 0;
    12c3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12ca:	eb f0                	jmp    12bc <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    12cc:	89 df                	mov    %ebx,%edi
    12ce:	8d 5f 01             	lea    0x1(%edi),%ebx
    12d1:	89 d0                	mov    %edx,%eax
    12d3:	ba 00 00 00 00       	mov    $0x0,%edx
    12d8:	f7 f1                	div    %ecx
    12da:	0f b6 92 48 16 00 00 	movzbl 0x1648(%edx),%edx
    12e1:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    12e5:	89 c2                	mov    %eax,%edx
    12e7:	85 c0                	test   %eax,%eax
    12e9:	75 e1                	jne    12cc <printint+0x2e>
  if(neg)
    12eb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    12ef:	74 08                	je     12f9 <printint+0x5b>
    buf[i++] = '-';
    12f1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    12f6:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    12f9:	83 eb 01             	sub    $0x1,%ebx
    12fc:	78 22                	js     1320 <printint+0x82>
  write(fd, &c, 1);
    12fe:	8d 7d d7             	lea    -0x29(%ebp),%edi
    1301:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1306:	88 45 d7             	mov    %al,-0x29(%ebp)
    1309:	83 ec 04             	sub    $0x4,%esp
    130c:	6a 01                	push   $0x1
    130e:	57                   	push   %edi
    130f:	56                   	push   %esi
    1310:	e8 f9 fe ff ff       	call   120e <write>
  while(--i >= 0)
    1315:	83 eb 01             	sub    $0x1,%ebx
    1318:	83 c4 10             	add    $0x10,%esp
    131b:	83 fb ff             	cmp    $0xffffffff,%ebx
    131e:	75 e1                	jne    1301 <printint+0x63>
    putc(fd, buf[i]);
}
    1320:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1323:	5b                   	pop    %ebx
    1324:	5e                   	pop    %esi
    1325:	5f                   	pop    %edi
    1326:	5d                   	pop    %ebp
    1327:	c3                   	ret    

00001328 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1328:	55                   	push   %ebp
    1329:	89 e5                	mov    %esp,%ebp
    132b:	57                   	push   %edi
    132c:	56                   	push   %esi
    132d:	53                   	push   %ebx
    132e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1331:	8b 75 0c             	mov    0xc(%ebp),%esi
    1334:	0f b6 1e             	movzbl (%esi),%ebx
    1337:	84 db                	test   %bl,%bl
    1339:	0f 84 b1 01 00 00    	je     14f0 <printf+0x1c8>
    133f:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    1342:	8d 45 10             	lea    0x10(%ebp),%eax
    1345:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1348:	bf 00 00 00 00       	mov    $0x0,%edi
    134d:	eb 2d                	jmp    137c <printf+0x54>
    134f:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1352:	83 ec 04             	sub    $0x4,%esp
    1355:	6a 01                	push   $0x1
    1357:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    135a:	50                   	push   %eax
    135b:	ff 75 08             	pushl  0x8(%ebp)
    135e:	e8 ab fe ff ff       	call   120e <write>
    1363:	83 c4 10             	add    $0x10,%esp
    1366:	eb 05                	jmp    136d <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1368:	83 ff 25             	cmp    $0x25,%edi
    136b:	74 22                	je     138f <printf+0x67>
    136d:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    1370:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1374:	84 db                	test   %bl,%bl
    1376:	0f 84 74 01 00 00    	je     14f0 <printf+0x1c8>
    c = fmt[i] & 0xff;
    137c:	0f be d3             	movsbl %bl,%edx
    137f:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1382:	85 ff                	test   %edi,%edi
    1384:	75 e2                	jne    1368 <printf+0x40>
      if(c == '%'){
    1386:	83 f8 25             	cmp    $0x25,%eax
    1389:	75 c4                	jne    134f <printf+0x27>
        state = '%';
    138b:	89 c7                	mov    %eax,%edi
    138d:	eb de                	jmp    136d <printf+0x45>
      if(c == 'd'){
    138f:	83 f8 64             	cmp    $0x64,%eax
    1392:	74 59                	je     13ed <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1394:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    139a:	83 fa 70             	cmp    $0x70,%edx
    139d:	74 7a                	je     1419 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    139f:	83 f8 73             	cmp    $0x73,%eax
    13a2:	0f 84 9d 00 00 00    	je     1445 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13a8:	83 f8 63             	cmp    $0x63,%eax
    13ab:	0f 84 f2 00 00 00    	je     14a3 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13b1:	83 f8 25             	cmp    $0x25,%eax
    13b4:	0f 84 15 01 00 00    	je     14cf <printf+0x1a7>
    13ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    13be:	83 ec 04             	sub    $0x4,%esp
    13c1:	6a 01                	push   $0x1
    13c3:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13c6:	50                   	push   %eax
    13c7:	ff 75 08             	pushl  0x8(%ebp)
    13ca:	e8 3f fe ff ff       	call   120e <write>
    13cf:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    13d2:	83 c4 0c             	add    $0xc,%esp
    13d5:	6a 01                	push   $0x1
    13d7:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    13da:	50                   	push   %eax
    13db:	ff 75 08             	pushl  0x8(%ebp)
    13de:	e8 2b fe ff ff       	call   120e <write>
    13e3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13e6:	bf 00 00 00 00       	mov    $0x0,%edi
    13eb:	eb 80                	jmp    136d <printf+0x45>
        printint(fd, *ap, 10, 1);
    13ed:	83 ec 0c             	sub    $0xc,%esp
    13f0:	6a 01                	push   $0x1
    13f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
    13f7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    13fa:	8b 17                	mov    (%edi),%edx
    13fc:	8b 45 08             	mov    0x8(%ebp),%eax
    13ff:	e8 9a fe ff ff       	call   129e <printint>
        ap++;
    1404:	89 f8                	mov    %edi,%eax
    1406:	83 c0 04             	add    $0x4,%eax
    1409:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    140c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    140f:	bf 00 00 00 00       	mov    $0x0,%edi
    1414:	e9 54 ff ff ff       	jmp    136d <printf+0x45>
        printint(fd, *ap, 16, 0);
    1419:	83 ec 0c             	sub    $0xc,%esp
    141c:	6a 00                	push   $0x0
    141e:	b9 10 00 00 00       	mov    $0x10,%ecx
    1423:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1426:	8b 17                	mov    (%edi),%edx
    1428:	8b 45 08             	mov    0x8(%ebp),%eax
    142b:	e8 6e fe ff ff       	call   129e <printint>
        ap++;
    1430:	89 f8                	mov    %edi,%eax
    1432:	83 c0 04             	add    $0x4,%eax
    1435:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1438:	83 c4 10             	add    $0x10,%esp
      state = 0;
    143b:	bf 00 00 00 00       	mov    $0x0,%edi
    1440:	e9 28 ff ff ff       	jmp    136d <printf+0x45>
        s = (char*)*ap;
    1445:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1448:	8b 01                	mov    (%ecx),%eax
        ap++;
    144a:	83 c1 04             	add    $0x4,%ecx
    144d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1450:	85 c0                	test   %eax,%eax
    1452:	74 13                	je     1467 <printf+0x13f>
        s = (char*)*ap;
    1454:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1456:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1459:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    145e:	84 c0                	test   %al,%al
    1460:	75 0f                	jne    1471 <printf+0x149>
    1462:	e9 06 ff ff ff       	jmp    136d <printf+0x45>
          s = "(null)";
    1467:	bb 40 16 00 00       	mov    $0x1640,%ebx
        while(*s != 0){
    146c:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    1471:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1474:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1477:	8b 75 08             	mov    0x8(%ebp),%esi
    147a:	88 45 e3             	mov    %al,-0x1d(%ebp)
    147d:	83 ec 04             	sub    $0x4,%esp
    1480:	6a 01                	push   $0x1
    1482:	57                   	push   %edi
    1483:	56                   	push   %esi
    1484:	e8 85 fd ff ff       	call   120e <write>
          s++;
    1489:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    148c:	0f b6 03             	movzbl (%ebx),%eax
    148f:	83 c4 10             	add    $0x10,%esp
    1492:	84 c0                	test   %al,%al
    1494:	75 e4                	jne    147a <printf+0x152>
    1496:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1499:	bf 00 00 00 00       	mov    $0x0,%edi
    149e:	e9 ca fe ff ff       	jmp    136d <printf+0x45>
        putc(fd, *ap);
    14a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14a6:	8b 07                	mov    (%edi),%eax
    14a8:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14ab:	83 ec 04             	sub    $0x4,%esp
    14ae:	6a 01                	push   $0x1
    14b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14b3:	50                   	push   %eax
    14b4:	ff 75 08             	pushl  0x8(%ebp)
    14b7:	e8 52 fd ff ff       	call   120e <write>
        ap++;
    14bc:	83 c7 04             	add    $0x4,%edi
    14bf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14c2:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14c5:	bf 00 00 00 00       	mov    $0x0,%edi
    14ca:	e9 9e fe ff ff       	jmp    136d <printf+0x45>
    14cf:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    14d2:	83 ec 04             	sub    $0x4,%esp
    14d5:	6a 01                	push   $0x1
    14d7:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    14da:	50                   	push   %eax
    14db:	ff 75 08             	pushl  0x8(%ebp)
    14de:	e8 2b fd ff ff       	call   120e <write>
    14e3:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14e6:	bf 00 00 00 00       	mov    $0x0,%edi
    14eb:	e9 7d fe ff ff       	jmp    136d <printf+0x45>
    }
  }
}
    14f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14f3:	5b                   	pop    %ebx
    14f4:	5e                   	pop    %esi
    14f5:	5f                   	pop    %edi
    14f6:	5d                   	pop    %ebp
    14f7:	c3                   	ret    

000014f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    14f8:	55                   	push   %ebp
    14f9:	89 e5                	mov    %esp,%ebp
    14fb:	57                   	push   %edi
    14fc:	56                   	push   %esi
    14fd:	53                   	push   %ebx
    14fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1501:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1504:	a1 b0 18 00 00       	mov    0x18b0,%eax
    1509:	eb 0c                	jmp    1517 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    150b:	8b 10                	mov    (%eax),%edx
    150d:	39 c2                	cmp    %eax,%edx
    150f:	77 04                	ja     1515 <free+0x1d>
    1511:	39 ca                	cmp    %ecx,%edx
    1513:	77 10                	ja     1525 <free+0x2d>
{
    1515:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1517:	39 c8                	cmp    %ecx,%eax
    1519:	73 f0                	jae    150b <free+0x13>
    151b:	8b 10                	mov    (%eax),%edx
    151d:	39 ca                	cmp    %ecx,%edx
    151f:	77 04                	ja     1525 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1521:	39 c2                	cmp    %eax,%edx
    1523:	77 f0                	ja     1515 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1525:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1528:	8b 10                	mov    (%eax),%edx
    152a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    152d:	39 fa                	cmp    %edi,%edx
    152f:	74 19                	je     154a <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1531:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1534:	8b 50 04             	mov    0x4(%eax),%edx
    1537:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    153a:	39 f1                	cmp    %esi,%ecx
    153c:	74 1b                	je     1559 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    153e:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1540:	a3 b0 18 00 00       	mov    %eax,0x18b0
}
    1545:	5b                   	pop    %ebx
    1546:	5e                   	pop    %esi
    1547:	5f                   	pop    %edi
    1548:	5d                   	pop    %ebp
    1549:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    154a:	03 72 04             	add    0x4(%edx),%esi
    154d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1550:	8b 10                	mov    (%eax),%edx
    1552:	8b 12                	mov    (%edx),%edx
    1554:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1557:	eb db                	jmp    1534 <free+0x3c>
    p->s.size += bp->s.size;
    1559:	03 53 fc             	add    -0x4(%ebx),%edx
    155c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    155f:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1562:	89 10                	mov    %edx,(%eax)
    1564:	eb da                	jmp    1540 <free+0x48>

00001566 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1566:	55                   	push   %ebp
    1567:	89 e5                	mov    %esp,%ebp
    1569:	57                   	push   %edi
    156a:	56                   	push   %esi
    156b:	53                   	push   %ebx
    156c:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    156f:	8b 45 08             	mov    0x8(%ebp),%eax
    1572:	8d 58 07             	lea    0x7(%eax),%ebx
    1575:	c1 eb 03             	shr    $0x3,%ebx
    1578:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    157b:	8b 15 b0 18 00 00    	mov    0x18b0,%edx
    1581:	85 d2                	test   %edx,%edx
    1583:	74 20                	je     15a5 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1585:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1587:	8b 48 04             	mov    0x4(%eax),%ecx
    158a:	39 cb                	cmp    %ecx,%ebx
    158c:	76 3c                	jbe    15ca <malloc+0x64>
    158e:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1594:	be 00 10 00 00       	mov    $0x1000,%esi
    1599:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    159c:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15a3:	eb 70                	jmp    1615 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15a5:	c7 05 b0 18 00 00 b4 	movl   $0x18b4,0x18b0
    15ac:	18 00 00 
    15af:	c7 05 b4 18 00 00 b4 	movl   $0x18b4,0x18b4
    15b6:	18 00 00 
    base.s.size = 0;
    15b9:	c7 05 b8 18 00 00 00 	movl   $0x0,0x18b8
    15c0:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    15c3:	ba b4 18 00 00       	mov    $0x18b4,%edx
    15c8:	eb bb                	jmp    1585 <malloc+0x1f>
      if(p->s.size == nunits)
    15ca:	39 cb                	cmp    %ecx,%ebx
    15cc:	74 1c                	je     15ea <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    15ce:	29 d9                	sub    %ebx,%ecx
    15d0:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    15d3:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    15d6:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    15d9:	89 15 b0 18 00 00    	mov    %edx,0x18b0
      return (void*)(p + 1);
    15df:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    15e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15e5:	5b                   	pop    %ebx
    15e6:	5e                   	pop    %esi
    15e7:	5f                   	pop    %edi
    15e8:	5d                   	pop    %ebp
    15e9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    15ea:	8b 08                	mov    (%eax),%ecx
    15ec:	89 0a                	mov    %ecx,(%edx)
    15ee:	eb e9                	jmp    15d9 <malloc+0x73>
  hp->s.size = nu;
    15f0:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    15f3:	83 ec 0c             	sub    $0xc,%esp
    15f6:	83 c0 08             	add    $0x8,%eax
    15f9:	50                   	push   %eax
    15fa:	e8 f9 fe ff ff       	call   14f8 <free>
  return freep;
    15ff:	8b 15 b0 18 00 00    	mov    0x18b0,%edx
      if((p = morecore(nunits)) == 0)
    1605:	83 c4 10             	add    $0x10,%esp
    1608:	85 d2                	test   %edx,%edx
    160a:	74 2b                	je     1637 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    160c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    160e:	8b 48 04             	mov    0x4(%eax),%ecx
    1611:	39 d9                	cmp    %ebx,%ecx
    1613:	73 b5                	jae    15ca <malloc+0x64>
    1615:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1617:	39 05 b0 18 00 00    	cmp    %eax,0x18b0
    161d:	75 ed                	jne    160c <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    161f:	83 ec 0c             	sub    $0xc,%esp
    1622:	57                   	push   %edi
    1623:	e8 4e fc ff ff       	call   1276 <sbrk>
  if(p == (char*)-1)
    1628:	83 c4 10             	add    $0x10,%esp
    162b:	83 f8 ff             	cmp    $0xffffffff,%eax
    162e:	75 c0                	jne    15f0 <malloc+0x8a>
        return 0;
    1630:	b8 00 00 00 00       	mov    $0x0,%eax
    1635:	eb ab                	jmp    15e2 <malloc+0x7c>
    1637:	b8 00 00 00 00       	mov    $0x0,%eax
    163c:	eb a4                	jmp    15e2 <malloc+0x7c>
