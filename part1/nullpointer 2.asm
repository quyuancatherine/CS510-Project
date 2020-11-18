
_nullpointer:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"

#define NULL 0
#define stdout 1
int main()
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	51                   	push   %ecx
    100e:	83 ec 0c             	sub    $0xc,%esp
    printf(stdout, "This is a test for NULL pointer dereference \n");
    1011:	68 48 16 00 00       	push   $0x1648
    1016:	6a 01                	push   $0x1
    1018:	e8 14 03 00 00       	call   1331 <printf>
    int *p = NULL;
    printf(1, "*p: %d \n",*p);
    101d:	83 c4 0c             	add    $0xc,%esp
    1020:	ff 35 00 00 00 00    	pushl  0x0
    1026:	68 78 16 00 00       	push   $0x1678
    102b:	6a 01                	push   $0x1
    102d:	e8 ff 02 00 00       	call   1331 <printf>
    exit();
    1032:	e8 c0 01 00 00       	call   11f7 <exit>

00001037 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1037:	55                   	push   %ebp
    1038:	89 e5                	mov    %esp,%ebp
    103a:	53                   	push   %ebx
    103b:	8b 45 08             	mov    0x8(%ebp),%eax
    103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1041:	89 c2                	mov    %eax,%edx
    1043:	83 c1 01             	add    $0x1,%ecx
    1046:	83 c2 01             	add    $0x1,%edx
    1049:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    104d:	88 5a ff             	mov    %bl,-0x1(%edx)
    1050:	84 db                	test   %bl,%bl
    1052:	75 ef                	jne    1043 <strcpy+0xc>
    ;
  return os;
}
    1054:	5b                   	pop    %ebx
    1055:	5d                   	pop    %ebp
    1056:	c3                   	ret    

00001057 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1057:	55                   	push   %ebp
    1058:	89 e5                	mov    %esp,%ebp
    105a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    105d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1060:	0f b6 01             	movzbl (%ecx),%eax
    1063:	84 c0                	test   %al,%al
    1065:	74 15                	je     107c <strcmp+0x25>
    1067:	3a 02                	cmp    (%edx),%al
    1069:	75 11                	jne    107c <strcmp+0x25>
    p++, q++;
    106b:	83 c1 01             	add    $0x1,%ecx
    106e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1071:	0f b6 01             	movzbl (%ecx),%eax
    1074:	84 c0                	test   %al,%al
    1076:	74 04                	je     107c <strcmp+0x25>
    1078:	3a 02                	cmp    (%edx),%al
    107a:	74 ef                	je     106b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    107c:	0f b6 c0             	movzbl %al,%eax
    107f:	0f b6 12             	movzbl (%edx),%edx
    1082:	29 d0                	sub    %edx,%eax
}
    1084:	5d                   	pop    %ebp
    1085:	c3                   	ret    

00001086 <strlen>:

uint
strlen(const char *s)
{
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
    1089:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    108c:	80 39 00             	cmpb   $0x0,(%ecx)
    108f:	74 12                	je     10a3 <strlen+0x1d>
    1091:	ba 00 00 00 00       	mov    $0x0,%edx
    1096:	83 c2 01             	add    $0x1,%edx
    1099:	89 d0                	mov    %edx,%eax
    109b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    109f:	75 f5                	jne    1096 <strlen+0x10>
    ;
  return n;
}
    10a1:	5d                   	pop    %ebp
    10a2:	c3                   	ret    
  for(n = 0; s[n]; n++)
    10a3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    10a8:	eb f7                	jmp    10a1 <strlen+0x1b>

000010aa <memset>:

void*
memset(void *dst, int c, uint n)
{
    10aa:	55                   	push   %ebp
    10ab:	89 e5                	mov    %esp,%ebp
    10ad:	57                   	push   %edi
    10ae:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10b1:	89 d7                	mov    %edx,%edi
    10b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10b6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b9:	fc                   	cld    
    10ba:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10bc:	89 d0                	mov    %edx,%eax
    10be:	5f                   	pop    %edi
    10bf:	5d                   	pop    %ebp
    10c0:	c3                   	ret    

000010c1 <strchr>:

char*
strchr(const char *s, char c)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
    10c4:	53                   	push   %ebx
    10c5:	8b 45 08             	mov    0x8(%ebp),%eax
    10c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10cb:	0f b6 10             	movzbl (%eax),%edx
    10ce:	84 d2                	test   %dl,%dl
    10d0:	74 1e                	je     10f0 <strchr+0x2f>
    10d2:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    10d4:	38 d3                	cmp    %dl,%bl
    10d6:	74 15                	je     10ed <strchr+0x2c>
  for(; *s; s++)
    10d8:	83 c0 01             	add    $0x1,%eax
    10db:	0f b6 10             	movzbl (%eax),%edx
    10de:	84 d2                	test   %dl,%dl
    10e0:	74 06                	je     10e8 <strchr+0x27>
    if(*s == c)
    10e2:	38 ca                	cmp    %cl,%dl
    10e4:	75 f2                	jne    10d8 <strchr+0x17>
    10e6:	eb 05                	jmp    10ed <strchr+0x2c>
      return (char*)s;
  return 0;
    10e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10ed:	5b                   	pop    %ebx
    10ee:	5d                   	pop    %ebp
    10ef:	c3                   	ret    
  return 0;
    10f0:	b8 00 00 00 00       	mov    $0x0,%eax
    10f5:	eb f6                	jmp    10ed <strchr+0x2c>

000010f7 <gets>:

char*
gets(char *buf, int max)
{
    10f7:	55                   	push   %ebp
    10f8:	89 e5                	mov    %esp,%ebp
    10fa:	57                   	push   %edi
    10fb:	56                   	push   %esi
    10fc:	53                   	push   %ebx
    10fd:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1100:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1105:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1108:	8d 5e 01             	lea    0x1(%esi),%ebx
    110b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    110e:	7d 2b                	jge    113b <gets+0x44>
    cc = read(0, &c, 1);
    1110:	83 ec 04             	sub    $0x4,%esp
    1113:	6a 01                	push   $0x1
    1115:	57                   	push   %edi
    1116:	6a 00                	push   $0x0
    1118:	e8 f2 00 00 00       	call   120f <read>
    if(cc < 1)
    111d:	83 c4 10             	add    $0x10,%esp
    1120:	85 c0                	test   %eax,%eax
    1122:	7e 17                	jle    113b <gets+0x44>
      break;
    buf[i++] = c;
    1124:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1128:	8b 55 08             	mov    0x8(%ebp),%edx
    112b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    112f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1131:	3c 0a                	cmp    $0xa,%al
    1133:	74 04                	je     1139 <gets+0x42>
    1135:	3c 0d                	cmp    $0xd,%al
    1137:	75 cf                	jne    1108 <gets+0x11>
  for(i=0; i+1 < max; ){
    1139:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1142:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1145:	5b                   	pop    %ebx
    1146:	5e                   	pop    %esi
    1147:	5f                   	pop    %edi
    1148:	5d                   	pop    %ebp
    1149:	c3                   	ret    

0000114a <stat>:

int
stat(const char *n, struct stat *st)
{
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	56                   	push   %esi
    114e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    114f:	83 ec 08             	sub    $0x8,%esp
    1152:	6a 00                	push   $0x0
    1154:	ff 75 08             	pushl  0x8(%ebp)
    1157:	e8 db 00 00 00       	call   1237 <open>
  if(fd < 0)
    115c:	83 c4 10             	add    $0x10,%esp
    115f:	85 c0                	test   %eax,%eax
    1161:	78 24                	js     1187 <stat+0x3d>
    1163:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1165:	83 ec 08             	sub    $0x8,%esp
    1168:	ff 75 0c             	pushl  0xc(%ebp)
    116b:	50                   	push   %eax
    116c:	e8 de 00 00 00       	call   124f <fstat>
    1171:	89 c6                	mov    %eax,%esi
  close(fd);
    1173:	89 1c 24             	mov    %ebx,(%esp)
    1176:	e8 a4 00 00 00       	call   121f <close>
  return r;
    117b:	83 c4 10             	add    $0x10,%esp
}
    117e:	89 f0                	mov    %esi,%eax
    1180:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1183:	5b                   	pop    %ebx
    1184:	5e                   	pop    %esi
    1185:	5d                   	pop    %ebp
    1186:	c3                   	ret    
    return -1;
    1187:	be ff ff ff ff       	mov    $0xffffffff,%esi
    118c:	eb f0                	jmp    117e <stat+0x34>

0000118e <atoi>:

int
atoi(const char *s)
{
    118e:	55                   	push   %ebp
    118f:	89 e5                	mov    %esp,%ebp
    1191:	53                   	push   %ebx
    1192:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1195:	0f b6 11             	movzbl (%ecx),%edx
    1198:	8d 42 d0             	lea    -0x30(%edx),%eax
    119b:	3c 09                	cmp    $0x9,%al
    119d:	77 20                	ja     11bf <atoi+0x31>
  n = 0;
    119f:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    11a4:	83 c1 01             	add    $0x1,%ecx
    11a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11aa:	0f be d2             	movsbl %dl,%edx
    11ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11b1:	0f b6 11             	movzbl (%ecx),%edx
    11b4:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11b7:	80 fb 09             	cmp    $0x9,%bl
    11ba:	76 e8                	jbe    11a4 <atoi+0x16>
  return n;
}
    11bc:	5b                   	pop    %ebx
    11bd:	5d                   	pop    %ebp
    11be:	c3                   	ret    
  n = 0;
    11bf:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11c4:	eb f6                	jmp    11bc <atoi+0x2e>

000011c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11c6:	55                   	push   %ebp
    11c7:	89 e5                	mov    %esp,%ebp
    11c9:	56                   	push   %esi
    11ca:	53                   	push   %ebx
    11cb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ce:	8b 75 0c             	mov    0xc(%ebp),%esi
    11d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11d4:	85 db                	test   %ebx,%ebx
    11d6:	7e 13                	jle    11eb <memmove+0x25>
    11d8:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    11dd:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    11e1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    11e4:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    11e7:	39 d3                	cmp    %edx,%ebx
    11e9:	75 f2                	jne    11dd <memmove+0x17>
  return vdst;
}
    11eb:	5b                   	pop    %ebx
    11ec:	5e                   	pop    %esi
    11ed:	5d                   	pop    %ebp
    11ee:	c3                   	ret    

000011ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11ef:	b8 01 00 00 00       	mov    $0x1,%eax
    11f4:	cd 40                	int    $0x40
    11f6:	c3                   	ret    

000011f7 <exit>:
SYSCALL(exit)
    11f7:	b8 02 00 00 00       	mov    $0x2,%eax
    11fc:	cd 40                	int    $0x40
    11fe:	c3                   	ret    

000011ff <wait>:
SYSCALL(wait)
    11ff:	b8 03 00 00 00       	mov    $0x3,%eax
    1204:	cd 40                	int    $0x40
    1206:	c3                   	ret    

00001207 <pipe>:
SYSCALL(pipe)
    1207:	b8 04 00 00 00       	mov    $0x4,%eax
    120c:	cd 40                	int    $0x40
    120e:	c3                   	ret    

0000120f <read>:
SYSCALL(read)
    120f:	b8 05 00 00 00       	mov    $0x5,%eax
    1214:	cd 40                	int    $0x40
    1216:	c3                   	ret    

00001217 <write>:
SYSCALL(write)
    1217:	b8 10 00 00 00       	mov    $0x10,%eax
    121c:	cd 40                	int    $0x40
    121e:	c3                   	ret    

0000121f <close>:
SYSCALL(close)
    121f:	b8 15 00 00 00       	mov    $0x15,%eax
    1224:	cd 40                	int    $0x40
    1226:	c3                   	ret    

00001227 <kill>:
SYSCALL(kill)
    1227:	b8 06 00 00 00       	mov    $0x6,%eax
    122c:	cd 40                	int    $0x40
    122e:	c3                   	ret    

0000122f <exec>:
SYSCALL(exec)
    122f:	b8 07 00 00 00       	mov    $0x7,%eax
    1234:	cd 40                	int    $0x40
    1236:	c3                   	ret    

00001237 <open>:
SYSCALL(open)
    1237:	b8 0f 00 00 00       	mov    $0xf,%eax
    123c:	cd 40                	int    $0x40
    123e:	c3                   	ret    

0000123f <mknod>:
SYSCALL(mknod)
    123f:	b8 11 00 00 00       	mov    $0x11,%eax
    1244:	cd 40                	int    $0x40
    1246:	c3                   	ret    

00001247 <unlink>:
SYSCALL(unlink)
    1247:	b8 12 00 00 00       	mov    $0x12,%eax
    124c:	cd 40                	int    $0x40
    124e:	c3                   	ret    

0000124f <fstat>:
SYSCALL(fstat)
    124f:	b8 08 00 00 00       	mov    $0x8,%eax
    1254:	cd 40                	int    $0x40
    1256:	c3                   	ret    

00001257 <link>:
SYSCALL(link)
    1257:	b8 13 00 00 00       	mov    $0x13,%eax
    125c:	cd 40                	int    $0x40
    125e:	c3                   	ret    

0000125f <mkdir>:
SYSCALL(mkdir)
    125f:	b8 14 00 00 00       	mov    $0x14,%eax
    1264:	cd 40                	int    $0x40
    1266:	c3                   	ret    

00001267 <chdir>:
SYSCALL(chdir)
    1267:	b8 09 00 00 00       	mov    $0x9,%eax
    126c:	cd 40                	int    $0x40
    126e:	c3                   	ret    

0000126f <dup>:
SYSCALL(dup)
    126f:	b8 0a 00 00 00       	mov    $0xa,%eax
    1274:	cd 40                	int    $0x40
    1276:	c3                   	ret    

00001277 <getpid>:
SYSCALL(getpid)
    1277:	b8 0b 00 00 00       	mov    $0xb,%eax
    127c:	cd 40                	int    $0x40
    127e:	c3                   	ret    

0000127f <sbrk>:
SYSCALL(sbrk)
    127f:	b8 0c 00 00 00       	mov    $0xc,%eax
    1284:	cd 40                	int    $0x40
    1286:	c3                   	ret    

00001287 <sleep>:
SYSCALL(sleep)
    1287:	b8 0d 00 00 00       	mov    $0xd,%eax
    128c:	cd 40                	int    $0x40
    128e:	c3                   	ret    

0000128f <uptime>:
SYSCALL(uptime)
    128f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1294:	cd 40                	int    $0x40
    1296:	c3                   	ret    

00001297 <shmem_access>:
SYSCALL(shmem_access)
    1297:	b8 16 00 00 00       	mov    $0x16,%eax
    129c:	cd 40                	int    $0x40
    129e:	c3                   	ret    

0000129f <shmem_count>:
    129f:	b8 17 00 00 00       	mov    $0x17,%eax
    12a4:	cd 40                	int    $0x40
    12a6:	c3                   	ret    

000012a7 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12a7:	55                   	push   %ebp
    12a8:	89 e5                	mov    %esp,%ebp
    12aa:	57                   	push   %edi
    12ab:	56                   	push   %esi
    12ac:	53                   	push   %ebx
    12ad:	83 ec 3c             	sub    $0x3c,%esp
    12b0:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12b6:	74 14                	je     12cc <printint+0x25>
    12b8:	85 d2                	test   %edx,%edx
    12ba:	79 10                	jns    12cc <printint+0x25>
    neg = 1;
    x = -xx;
    12bc:	f7 da                	neg    %edx
    neg = 1;
    12be:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12c5:	bf 00 00 00 00       	mov    $0x0,%edi
    12ca:	eb 0b                	jmp    12d7 <printint+0x30>
  neg = 0;
    12cc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12d3:	eb f0                	jmp    12c5 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    12d5:	89 df                	mov    %ebx,%edi
    12d7:	8d 5f 01             	lea    0x1(%edi),%ebx
    12da:	89 d0                	mov    %edx,%eax
    12dc:	ba 00 00 00 00       	mov    $0x0,%edx
    12e1:	f7 f1                	div    %ecx
    12e3:	0f b6 92 88 16 00 00 	movzbl 0x1688(%edx),%edx
    12ea:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    12ee:	89 c2                	mov    %eax,%edx
    12f0:	85 c0                	test   %eax,%eax
    12f2:	75 e1                	jne    12d5 <printint+0x2e>
  if(neg)
    12f4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    12f8:	74 08                	je     1302 <printint+0x5b>
    buf[i++] = '-';
    12fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    12ff:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1302:	83 eb 01             	sub    $0x1,%ebx
    1305:	78 22                	js     1329 <printint+0x82>
  write(fd, &c, 1);
    1307:	8d 7d d7             	lea    -0x29(%ebp),%edi
    130a:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    130f:	88 45 d7             	mov    %al,-0x29(%ebp)
    1312:	83 ec 04             	sub    $0x4,%esp
    1315:	6a 01                	push   $0x1
    1317:	57                   	push   %edi
    1318:	56                   	push   %esi
    1319:	e8 f9 fe ff ff       	call   1217 <write>
  while(--i >= 0)
    131e:	83 eb 01             	sub    $0x1,%ebx
    1321:	83 c4 10             	add    $0x10,%esp
    1324:	83 fb ff             	cmp    $0xffffffff,%ebx
    1327:	75 e1                	jne    130a <printint+0x63>
    putc(fd, buf[i]);
}
    1329:	8d 65 f4             	lea    -0xc(%ebp),%esp
    132c:	5b                   	pop    %ebx
    132d:	5e                   	pop    %esi
    132e:	5f                   	pop    %edi
    132f:	5d                   	pop    %ebp
    1330:	c3                   	ret    

00001331 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1331:	55                   	push   %ebp
    1332:	89 e5                	mov    %esp,%ebp
    1334:	57                   	push   %edi
    1335:	56                   	push   %esi
    1336:	53                   	push   %ebx
    1337:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    133a:	8b 75 0c             	mov    0xc(%ebp),%esi
    133d:	0f b6 1e             	movzbl (%esi),%ebx
    1340:	84 db                	test   %bl,%bl
    1342:	0f 84 b1 01 00 00    	je     14f9 <printf+0x1c8>
    1348:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    134b:	8d 45 10             	lea    0x10(%ebp),%eax
    134e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1351:	bf 00 00 00 00       	mov    $0x0,%edi
    1356:	eb 2d                	jmp    1385 <printf+0x54>
    1358:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    135b:	83 ec 04             	sub    $0x4,%esp
    135e:	6a 01                	push   $0x1
    1360:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1363:	50                   	push   %eax
    1364:	ff 75 08             	pushl  0x8(%ebp)
    1367:	e8 ab fe ff ff       	call   1217 <write>
    136c:	83 c4 10             	add    $0x10,%esp
    136f:	eb 05                	jmp    1376 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1371:	83 ff 25             	cmp    $0x25,%edi
    1374:	74 22                	je     1398 <printf+0x67>
    1376:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    1379:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    137d:	84 db                	test   %bl,%bl
    137f:	0f 84 74 01 00 00    	je     14f9 <printf+0x1c8>
    c = fmt[i] & 0xff;
    1385:	0f be d3             	movsbl %bl,%edx
    1388:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    138b:	85 ff                	test   %edi,%edi
    138d:	75 e2                	jne    1371 <printf+0x40>
      if(c == '%'){
    138f:	83 f8 25             	cmp    $0x25,%eax
    1392:	75 c4                	jne    1358 <printf+0x27>
        state = '%';
    1394:	89 c7                	mov    %eax,%edi
    1396:	eb de                	jmp    1376 <printf+0x45>
      if(c == 'd'){
    1398:	83 f8 64             	cmp    $0x64,%eax
    139b:	74 59                	je     13f6 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    139d:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    13a3:	83 fa 70             	cmp    $0x70,%edx
    13a6:	74 7a                	je     1422 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13a8:	83 f8 73             	cmp    $0x73,%eax
    13ab:	0f 84 9d 00 00 00    	je     144e <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13b1:	83 f8 63             	cmp    $0x63,%eax
    13b4:	0f 84 f2 00 00 00    	je     14ac <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13ba:	83 f8 25             	cmp    $0x25,%eax
    13bd:	0f 84 15 01 00 00    	je     14d8 <printf+0x1a7>
    13c3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    13c7:	83 ec 04             	sub    $0x4,%esp
    13ca:	6a 01                	push   $0x1
    13cc:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13cf:	50                   	push   %eax
    13d0:	ff 75 08             	pushl  0x8(%ebp)
    13d3:	e8 3f fe ff ff       	call   1217 <write>
    13d8:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    13db:	83 c4 0c             	add    $0xc,%esp
    13de:	6a 01                	push   $0x1
    13e0:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    13e3:	50                   	push   %eax
    13e4:	ff 75 08             	pushl  0x8(%ebp)
    13e7:	e8 2b fe ff ff       	call   1217 <write>
    13ec:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13ef:	bf 00 00 00 00       	mov    $0x0,%edi
    13f4:	eb 80                	jmp    1376 <printf+0x45>
        printint(fd, *ap, 10, 1);
    13f6:	83 ec 0c             	sub    $0xc,%esp
    13f9:	6a 01                	push   $0x1
    13fb:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1400:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1403:	8b 17                	mov    (%edi),%edx
    1405:	8b 45 08             	mov    0x8(%ebp),%eax
    1408:	e8 9a fe ff ff       	call   12a7 <printint>
        ap++;
    140d:	89 f8                	mov    %edi,%eax
    140f:	83 c0 04             	add    $0x4,%eax
    1412:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1415:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1418:	bf 00 00 00 00       	mov    $0x0,%edi
    141d:	e9 54 ff ff ff       	jmp    1376 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1422:	83 ec 0c             	sub    $0xc,%esp
    1425:	6a 00                	push   $0x0
    1427:	b9 10 00 00 00       	mov    $0x10,%ecx
    142c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    142f:	8b 17                	mov    (%edi),%edx
    1431:	8b 45 08             	mov    0x8(%ebp),%eax
    1434:	e8 6e fe ff ff       	call   12a7 <printint>
        ap++;
    1439:	89 f8                	mov    %edi,%eax
    143b:	83 c0 04             	add    $0x4,%eax
    143e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1441:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1444:	bf 00 00 00 00       	mov    $0x0,%edi
    1449:	e9 28 ff ff ff       	jmp    1376 <printf+0x45>
        s = (char*)*ap;
    144e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1451:	8b 01                	mov    (%ecx),%eax
        ap++;
    1453:	83 c1 04             	add    $0x4,%ecx
    1456:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1459:	85 c0                	test   %eax,%eax
    145b:	74 13                	je     1470 <printf+0x13f>
        s = (char*)*ap;
    145d:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    145f:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1462:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    1467:	84 c0                	test   %al,%al
    1469:	75 0f                	jne    147a <printf+0x149>
    146b:	e9 06 ff ff ff       	jmp    1376 <printf+0x45>
          s = "(null)";
    1470:	bb 81 16 00 00       	mov    $0x1681,%ebx
        while(*s != 0){
    1475:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    147a:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    147d:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1480:	8b 75 08             	mov    0x8(%ebp),%esi
    1483:	88 45 e3             	mov    %al,-0x1d(%ebp)
    1486:	83 ec 04             	sub    $0x4,%esp
    1489:	6a 01                	push   $0x1
    148b:	57                   	push   %edi
    148c:	56                   	push   %esi
    148d:	e8 85 fd ff ff       	call   1217 <write>
          s++;
    1492:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    1495:	0f b6 03             	movzbl (%ebx),%eax
    1498:	83 c4 10             	add    $0x10,%esp
    149b:	84 c0                	test   %al,%al
    149d:	75 e4                	jne    1483 <printf+0x152>
    149f:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    14a2:	bf 00 00 00 00       	mov    $0x0,%edi
    14a7:	e9 ca fe ff ff       	jmp    1376 <printf+0x45>
        putc(fd, *ap);
    14ac:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14af:	8b 07                	mov    (%edi),%eax
    14b1:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14b4:	83 ec 04             	sub    $0x4,%esp
    14b7:	6a 01                	push   $0x1
    14b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14bc:	50                   	push   %eax
    14bd:	ff 75 08             	pushl  0x8(%ebp)
    14c0:	e8 52 fd ff ff       	call   1217 <write>
        ap++;
    14c5:	83 c7 04             	add    $0x4,%edi
    14c8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14cb:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14ce:	bf 00 00 00 00       	mov    $0x0,%edi
    14d3:	e9 9e fe ff ff       	jmp    1376 <printf+0x45>
    14d8:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    14db:	83 ec 04             	sub    $0x4,%esp
    14de:	6a 01                	push   $0x1
    14e0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    14e3:	50                   	push   %eax
    14e4:	ff 75 08             	pushl  0x8(%ebp)
    14e7:	e8 2b fd ff ff       	call   1217 <write>
    14ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14ef:	bf 00 00 00 00       	mov    $0x0,%edi
    14f4:	e9 7d fe ff ff       	jmp    1376 <printf+0x45>
    }
  }
}
    14f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14fc:	5b                   	pop    %ebx
    14fd:	5e                   	pop    %esi
    14fe:	5f                   	pop    %edi
    14ff:	5d                   	pop    %ebp
    1500:	c3                   	ret    

00001501 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1501:	55                   	push   %ebp
    1502:	89 e5                	mov    %esp,%ebp
    1504:	57                   	push   %edi
    1505:	56                   	push   %esi
    1506:	53                   	push   %ebx
    1507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    150a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    150d:	a1 f0 18 00 00       	mov    0x18f0,%eax
    1512:	eb 0c                	jmp    1520 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1514:	8b 10                	mov    (%eax),%edx
    1516:	39 c2                	cmp    %eax,%edx
    1518:	77 04                	ja     151e <free+0x1d>
    151a:	39 ca                	cmp    %ecx,%edx
    151c:	77 10                	ja     152e <free+0x2d>
{
    151e:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1520:	39 c8                	cmp    %ecx,%eax
    1522:	73 f0                	jae    1514 <free+0x13>
    1524:	8b 10                	mov    (%eax),%edx
    1526:	39 ca                	cmp    %ecx,%edx
    1528:	77 04                	ja     152e <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    152a:	39 c2                	cmp    %eax,%edx
    152c:	77 f0                	ja     151e <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    152e:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1531:	8b 10                	mov    (%eax),%edx
    1533:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1536:	39 fa                	cmp    %edi,%edx
    1538:	74 19                	je     1553 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    153a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    153d:	8b 50 04             	mov    0x4(%eax),%edx
    1540:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1543:	39 f1                	cmp    %esi,%ecx
    1545:	74 1b                	je     1562 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1547:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1549:	a3 f0 18 00 00       	mov    %eax,0x18f0
}
    154e:	5b                   	pop    %ebx
    154f:	5e                   	pop    %esi
    1550:	5f                   	pop    %edi
    1551:	5d                   	pop    %ebp
    1552:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1553:	03 72 04             	add    0x4(%edx),%esi
    1556:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1559:	8b 10                	mov    (%eax),%edx
    155b:	8b 12                	mov    (%edx),%edx
    155d:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1560:	eb db                	jmp    153d <free+0x3c>
    p->s.size += bp->s.size;
    1562:	03 53 fc             	add    -0x4(%ebx),%edx
    1565:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1568:	8b 53 f8             	mov    -0x8(%ebx),%edx
    156b:	89 10                	mov    %edx,(%eax)
    156d:	eb da                	jmp    1549 <free+0x48>

0000156f <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    156f:	55                   	push   %ebp
    1570:	89 e5                	mov    %esp,%ebp
    1572:	57                   	push   %edi
    1573:	56                   	push   %esi
    1574:	53                   	push   %ebx
    1575:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1578:	8b 45 08             	mov    0x8(%ebp),%eax
    157b:	8d 58 07             	lea    0x7(%eax),%ebx
    157e:	c1 eb 03             	shr    $0x3,%ebx
    1581:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1584:	8b 15 f0 18 00 00    	mov    0x18f0,%edx
    158a:	85 d2                	test   %edx,%edx
    158c:	74 20                	je     15ae <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    158e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1590:	8b 48 04             	mov    0x4(%eax),%ecx
    1593:	39 cb                	cmp    %ecx,%ebx
    1595:	76 3c                	jbe    15d3 <malloc+0x64>
    1597:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    159d:	be 00 10 00 00       	mov    $0x1000,%esi
    15a2:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    15a5:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15ac:	eb 70                	jmp    161e <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15ae:	c7 05 f0 18 00 00 f4 	movl   $0x18f4,0x18f0
    15b5:	18 00 00 
    15b8:	c7 05 f4 18 00 00 f4 	movl   $0x18f4,0x18f4
    15bf:	18 00 00 
    base.s.size = 0;
    15c2:	c7 05 f8 18 00 00 00 	movl   $0x0,0x18f8
    15c9:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    15cc:	ba f4 18 00 00       	mov    $0x18f4,%edx
    15d1:	eb bb                	jmp    158e <malloc+0x1f>
      if(p->s.size == nunits)
    15d3:	39 cb                	cmp    %ecx,%ebx
    15d5:	74 1c                	je     15f3 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    15d7:	29 d9                	sub    %ebx,%ecx
    15d9:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    15dc:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    15df:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    15e2:	89 15 f0 18 00 00    	mov    %edx,0x18f0
      return (void*)(p + 1);
    15e8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    15eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15ee:	5b                   	pop    %ebx
    15ef:	5e                   	pop    %esi
    15f0:	5f                   	pop    %edi
    15f1:	5d                   	pop    %ebp
    15f2:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    15f3:	8b 08                	mov    (%eax),%ecx
    15f5:	89 0a                	mov    %ecx,(%edx)
    15f7:	eb e9                	jmp    15e2 <malloc+0x73>
  hp->s.size = nu;
    15f9:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    15fc:	83 ec 0c             	sub    $0xc,%esp
    15ff:	83 c0 08             	add    $0x8,%eax
    1602:	50                   	push   %eax
    1603:	e8 f9 fe ff ff       	call   1501 <free>
  return freep;
    1608:	8b 15 f0 18 00 00    	mov    0x18f0,%edx
      if((p = morecore(nunits)) == 0)
    160e:	83 c4 10             	add    $0x10,%esp
    1611:	85 d2                	test   %edx,%edx
    1613:	74 2b                	je     1640 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1615:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1617:	8b 48 04             	mov    0x4(%eax),%ecx
    161a:	39 d9                	cmp    %ebx,%ecx
    161c:	73 b5                	jae    15d3 <malloc+0x64>
    161e:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1620:	39 05 f0 18 00 00    	cmp    %eax,0x18f0
    1626:	75 ed                	jne    1615 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1628:	83 ec 0c             	sub    $0xc,%esp
    162b:	57                   	push   %edi
    162c:	e8 4e fc ff ff       	call   127f <sbrk>
  if(p == (char*)-1)
    1631:	83 c4 10             	add    $0x10,%esp
    1634:	83 f8 ff             	cmp    $0xffffffff,%eax
    1637:	75 c0                	jne    15f9 <malloc+0x8a>
        return 0;
    1639:	b8 00 00 00 00       	mov    $0x0,%eax
    163e:	eb ab                	jmp    15eb <malloc+0x7c>
    1640:	b8 00 00 00 00       	mov    $0x0,%eax
    1645:	eb a4                	jmp    15eb <malloc+0x7c>
