
_mkdir:     file format elf32-i386


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
    100d:	57                   	push   %edi
    100e:	56                   	push   %esi
    100f:	53                   	push   %ebx
    1010:	51                   	push   %ecx
    1011:	83 ec 18             	sub    $0x18,%esp
    1014:	8b 39                	mov    (%ecx),%edi
    1016:	8b 59 04             	mov    0x4(%ecx),%ebx
    1019:	83 c3 04             	add    $0x4,%ebx
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    101c:	be 01 00 00 00       	mov    $0x1,%esi
  if(argc < 2){
    1021:	83 ff 01             	cmp    $0x1,%edi
    1024:	7e 20                	jle    1046 <main+0x46>
    if(mkdir(argv[i]) < 0){
    1026:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    1029:	83 ec 0c             	sub    $0xc,%esp
    102c:	ff 33                	pushl  (%ebx)
    102e:	e8 6b 02 00 00       	call   129e <mkdir>
    1033:	83 c4 10             	add    $0x10,%esp
    1036:	85 c0                	test   %eax,%eax
    1038:	78 20                	js     105a <main+0x5a>
  for(i = 1; i < argc; i++){
    103a:	83 c6 01             	add    $0x1,%esi
    103d:	83 c3 04             	add    $0x4,%ebx
    1040:	39 f7                	cmp    %esi,%edi
    1042:	75 e2                	jne    1026 <main+0x26>
    1044:	eb 2b                	jmp    1071 <main+0x71>
    printf(2, "Usage: mkdir files...\n");
    1046:	83 ec 08             	sub    $0x8,%esp
    1049:	68 88 16 00 00       	push   $0x1688
    104e:	6a 02                	push   $0x2
    1050:	e8 1b 03 00 00       	call   1370 <printf>
    exit();
    1055:	e8 dc 01 00 00       	call   1236 <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
    105a:	83 ec 04             	sub    $0x4,%esp
    105d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1060:	ff 30                	pushl  (%eax)
    1062:	68 9f 16 00 00       	push   $0x169f
    1067:	6a 02                	push   $0x2
    1069:	e8 02 03 00 00       	call   1370 <printf>
      break;
    106e:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
    1071:	e8 c0 01 00 00       	call   1236 <exit>

00001076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1076:	55                   	push   %ebp
    1077:	89 e5                	mov    %esp,%ebp
    1079:	53                   	push   %ebx
    107a:	8b 45 08             	mov    0x8(%ebp),%eax
    107d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1080:	89 c2                	mov    %eax,%edx
    1082:	83 c1 01             	add    $0x1,%ecx
    1085:	83 c2 01             	add    $0x1,%edx
    1088:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    108c:	88 5a ff             	mov    %bl,-0x1(%edx)
    108f:	84 db                	test   %bl,%bl
    1091:	75 ef                	jne    1082 <strcpy+0xc>
    ;
  return os;
}
    1093:	5b                   	pop    %ebx
    1094:	5d                   	pop    %ebp
    1095:	c3                   	ret    

00001096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1096:	55                   	push   %ebp
    1097:	89 e5                	mov    %esp,%ebp
    1099:	8b 4d 08             	mov    0x8(%ebp),%ecx
    109c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    109f:	0f b6 01             	movzbl (%ecx),%eax
    10a2:	84 c0                	test   %al,%al
    10a4:	74 15                	je     10bb <strcmp+0x25>
    10a6:	3a 02                	cmp    (%edx),%al
    10a8:	75 11                	jne    10bb <strcmp+0x25>
    p++, q++;
    10aa:	83 c1 01             	add    $0x1,%ecx
    10ad:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10b0:	0f b6 01             	movzbl (%ecx),%eax
    10b3:	84 c0                	test   %al,%al
    10b5:	74 04                	je     10bb <strcmp+0x25>
    10b7:	3a 02                	cmp    (%edx),%al
    10b9:	74 ef                	je     10aa <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    10bb:	0f b6 c0             	movzbl %al,%eax
    10be:	0f b6 12             	movzbl (%edx),%edx
    10c1:	29 d0                	sub    %edx,%eax
}
    10c3:	5d                   	pop    %ebp
    10c4:	c3                   	ret    

000010c5 <strlen>:

uint
strlen(const char *s)
{
    10c5:	55                   	push   %ebp
    10c6:	89 e5                	mov    %esp,%ebp
    10c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10cb:	80 39 00             	cmpb   $0x0,(%ecx)
    10ce:	74 12                	je     10e2 <strlen+0x1d>
    10d0:	ba 00 00 00 00       	mov    $0x0,%edx
    10d5:	83 c2 01             	add    $0x1,%edx
    10d8:	89 d0                	mov    %edx,%eax
    10da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    10de:	75 f5                	jne    10d5 <strlen+0x10>
    ;
  return n;
}
    10e0:	5d                   	pop    %ebp
    10e1:	c3                   	ret    
  for(n = 0; s[n]; n++)
    10e2:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    10e7:	eb f7                	jmp    10e0 <strlen+0x1b>

000010e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10e9:	55                   	push   %ebp
    10ea:	89 e5                	mov    %esp,%ebp
    10ec:	57                   	push   %edi
    10ed:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10f0:	89 d7                	mov    %edx,%edi
    10f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10f5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f8:	fc                   	cld    
    10f9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10fb:	89 d0                	mov    %edx,%eax
    10fd:	5f                   	pop    %edi
    10fe:	5d                   	pop    %ebp
    10ff:	c3                   	ret    

00001100 <strchr>:

char*
strchr(const char *s, char c)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	53                   	push   %ebx
    1104:	8b 45 08             	mov    0x8(%ebp),%eax
    1107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    110a:	0f b6 10             	movzbl (%eax),%edx
    110d:	84 d2                	test   %dl,%dl
    110f:	74 1e                	je     112f <strchr+0x2f>
    1111:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1113:	38 d3                	cmp    %dl,%bl
    1115:	74 15                	je     112c <strchr+0x2c>
  for(; *s; s++)
    1117:	83 c0 01             	add    $0x1,%eax
    111a:	0f b6 10             	movzbl (%eax),%edx
    111d:	84 d2                	test   %dl,%dl
    111f:	74 06                	je     1127 <strchr+0x27>
    if(*s == c)
    1121:	38 ca                	cmp    %cl,%dl
    1123:	75 f2                	jne    1117 <strchr+0x17>
    1125:	eb 05                	jmp    112c <strchr+0x2c>
      return (char*)s;
  return 0;
    1127:	b8 00 00 00 00       	mov    $0x0,%eax
}
    112c:	5b                   	pop    %ebx
    112d:	5d                   	pop    %ebp
    112e:	c3                   	ret    
  return 0;
    112f:	b8 00 00 00 00       	mov    $0x0,%eax
    1134:	eb f6                	jmp    112c <strchr+0x2c>

00001136 <gets>:

char*
gets(char *buf, int max)
{
    1136:	55                   	push   %ebp
    1137:	89 e5                	mov    %esp,%ebp
    1139:	57                   	push   %edi
    113a:	56                   	push   %esi
    113b:	53                   	push   %ebx
    113c:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113f:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1144:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1147:	8d 5e 01             	lea    0x1(%esi),%ebx
    114a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    114d:	7d 2b                	jge    117a <gets+0x44>
    cc = read(0, &c, 1);
    114f:	83 ec 04             	sub    $0x4,%esp
    1152:	6a 01                	push   $0x1
    1154:	57                   	push   %edi
    1155:	6a 00                	push   $0x0
    1157:	e8 f2 00 00 00       	call   124e <read>
    if(cc < 1)
    115c:	83 c4 10             	add    $0x10,%esp
    115f:	85 c0                	test   %eax,%eax
    1161:	7e 17                	jle    117a <gets+0x44>
      break;
    buf[i++] = c;
    1163:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1167:	8b 55 08             	mov    0x8(%ebp),%edx
    116a:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    116e:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1170:	3c 0a                	cmp    $0xa,%al
    1172:	74 04                	je     1178 <gets+0x42>
    1174:	3c 0d                	cmp    $0xd,%al
    1176:	75 cf                	jne    1147 <gets+0x11>
  for(i=0; i+1 < max; ){
    1178:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1181:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1184:	5b                   	pop    %ebx
    1185:	5e                   	pop    %esi
    1186:	5f                   	pop    %edi
    1187:	5d                   	pop    %ebp
    1188:	c3                   	ret    

00001189 <stat>:

int
stat(const char *n, struct stat *st)
{
    1189:	55                   	push   %ebp
    118a:	89 e5                	mov    %esp,%ebp
    118c:	56                   	push   %esi
    118d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    118e:	83 ec 08             	sub    $0x8,%esp
    1191:	6a 00                	push   $0x0
    1193:	ff 75 08             	pushl  0x8(%ebp)
    1196:	e8 db 00 00 00       	call   1276 <open>
  if(fd < 0)
    119b:	83 c4 10             	add    $0x10,%esp
    119e:	85 c0                	test   %eax,%eax
    11a0:	78 24                	js     11c6 <stat+0x3d>
    11a2:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    11a4:	83 ec 08             	sub    $0x8,%esp
    11a7:	ff 75 0c             	pushl  0xc(%ebp)
    11aa:	50                   	push   %eax
    11ab:	e8 de 00 00 00       	call   128e <fstat>
    11b0:	89 c6                	mov    %eax,%esi
  close(fd);
    11b2:	89 1c 24             	mov    %ebx,(%esp)
    11b5:	e8 a4 00 00 00       	call   125e <close>
  return r;
    11ba:	83 c4 10             	add    $0x10,%esp
}
    11bd:	89 f0                	mov    %esi,%eax
    11bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11c2:	5b                   	pop    %ebx
    11c3:	5e                   	pop    %esi
    11c4:	5d                   	pop    %ebp
    11c5:	c3                   	ret    
    return -1;
    11c6:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11cb:	eb f0                	jmp    11bd <stat+0x34>

000011cd <atoi>:

int
atoi(const char *s)
{
    11cd:	55                   	push   %ebp
    11ce:	89 e5                	mov    %esp,%ebp
    11d0:	53                   	push   %ebx
    11d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11d4:	0f b6 11             	movzbl (%ecx),%edx
    11d7:	8d 42 d0             	lea    -0x30(%edx),%eax
    11da:	3c 09                	cmp    $0x9,%al
    11dc:	77 20                	ja     11fe <atoi+0x31>
  n = 0;
    11de:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    11e3:	83 c1 01             	add    $0x1,%ecx
    11e6:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11e9:	0f be d2             	movsbl %dl,%edx
    11ec:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11f0:	0f b6 11             	movzbl (%ecx),%edx
    11f3:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11f6:	80 fb 09             	cmp    $0x9,%bl
    11f9:	76 e8                	jbe    11e3 <atoi+0x16>
  return n;
}
    11fb:	5b                   	pop    %ebx
    11fc:	5d                   	pop    %ebp
    11fd:	c3                   	ret    
  n = 0;
    11fe:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1203:	eb f6                	jmp    11fb <atoi+0x2e>

00001205 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1205:	55                   	push   %ebp
    1206:	89 e5                	mov    %esp,%ebp
    1208:	56                   	push   %esi
    1209:	53                   	push   %ebx
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1210:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1213:	85 db                	test   %ebx,%ebx
    1215:	7e 13                	jle    122a <memmove+0x25>
    1217:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    121c:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1220:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1223:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1226:	39 d3                	cmp    %edx,%ebx
    1228:	75 f2                	jne    121c <memmove+0x17>
  return vdst;
}
    122a:	5b                   	pop    %ebx
    122b:	5e                   	pop    %esi
    122c:	5d                   	pop    %ebp
    122d:	c3                   	ret    

0000122e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    122e:	b8 01 00 00 00       	mov    $0x1,%eax
    1233:	cd 40                	int    $0x40
    1235:	c3                   	ret    

00001236 <exit>:
SYSCALL(exit)
    1236:	b8 02 00 00 00       	mov    $0x2,%eax
    123b:	cd 40                	int    $0x40
    123d:	c3                   	ret    

0000123e <wait>:
SYSCALL(wait)
    123e:	b8 03 00 00 00       	mov    $0x3,%eax
    1243:	cd 40                	int    $0x40
    1245:	c3                   	ret    

00001246 <pipe>:
SYSCALL(pipe)
    1246:	b8 04 00 00 00       	mov    $0x4,%eax
    124b:	cd 40                	int    $0x40
    124d:	c3                   	ret    

0000124e <read>:
SYSCALL(read)
    124e:	b8 05 00 00 00       	mov    $0x5,%eax
    1253:	cd 40                	int    $0x40
    1255:	c3                   	ret    

00001256 <write>:
SYSCALL(write)
    1256:	b8 10 00 00 00       	mov    $0x10,%eax
    125b:	cd 40                	int    $0x40
    125d:	c3                   	ret    

0000125e <close>:
SYSCALL(close)
    125e:	b8 15 00 00 00       	mov    $0x15,%eax
    1263:	cd 40                	int    $0x40
    1265:	c3                   	ret    

00001266 <kill>:
SYSCALL(kill)
    1266:	b8 06 00 00 00       	mov    $0x6,%eax
    126b:	cd 40                	int    $0x40
    126d:	c3                   	ret    

0000126e <exec>:
SYSCALL(exec)
    126e:	b8 07 00 00 00       	mov    $0x7,%eax
    1273:	cd 40                	int    $0x40
    1275:	c3                   	ret    

00001276 <open>:
SYSCALL(open)
    1276:	b8 0f 00 00 00       	mov    $0xf,%eax
    127b:	cd 40                	int    $0x40
    127d:	c3                   	ret    

0000127e <mknod>:
SYSCALL(mknod)
    127e:	b8 11 00 00 00       	mov    $0x11,%eax
    1283:	cd 40                	int    $0x40
    1285:	c3                   	ret    

00001286 <unlink>:
SYSCALL(unlink)
    1286:	b8 12 00 00 00       	mov    $0x12,%eax
    128b:	cd 40                	int    $0x40
    128d:	c3                   	ret    

0000128e <fstat>:
SYSCALL(fstat)
    128e:	b8 08 00 00 00       	mov    $0x8,%eax
    1293:	cd 40                	int    $0x40
    1295:	c3                   	ret    

00001296 <link>:
SYSCALL(link)
    1296:	b8 13 00 00 00       	mov    $0x13,%eax
    129b:	cd 40                	int    $0x40
    129d:	c3                   	ret    

0000129e <mkdir>:
SYSCALL(mkdir)
    129e:	b8 14 00 00 00       	mov    $0x14,%eax
    12a3:	cd 40                	int    $0x40
    12a5:	c3                   	ret    

000012a6 <chdir>:
SYSCALL(chdir)
    12a6:	b8 09 00 00 00       	mov    $0x9,%eax
    12ab:	cd 40                	int    $0x40
    12ad:	c3                   	ret    

000012ae <dup>:
SYSCALL(dup)
    12ae:	b8 0a 00 00 00       	mov    $0xa,%eax
    12b3:	cd 40                	int    $0x40
    12b5:	c3                   	ret    

000012b6 <getpid>:
SYSCALL(getpid)
    12b6:	b8 0b 00 00 00       	mov    $0xb,%eax
    12bb:	cd 40                	int    $0x40
    12bd:	c3                   	ret    

000012be <sbrk>:
SYSCALL(sbrk)
    12be:	b8 0c 00 00 00       	mov    $0xc,%eax
    12c3:	cd 40                	int    $0x40
    12c5:	c3                   	ret    

000012c6 <sleep>:
SYSCALL(sleep)
    12c6:	b8 0d 00 00 00       	mov    $0xd,%eax
    12cb:	cd 40                	int    $0x40
    12cd:	c3                   	ret    

000012ce <uptime>:
SYSCALL(uptime)
    12ce:	b8 0e 00 00 00       	mov    $0xe,%eax
    12d3:	cd 40                	int    $0x40
    12d5:	c3                   	ret    

000012d6 <shmem_access>:
SYSCALL(shmem_access)
    12d6:	b8 16 00 00 00       	mov    $0x16,%eax
    12db:	cd 40                	int    $0x40
    12dd:	c3                   	ret    

000012de <shmem_count>:
    12de:	b8 17 00 00 00       	mov    $0x17,%eax
    12e3:	cd 40                	int    $0x40
    12e5:	c3                   	ret    

000012e6 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12e6:	55                   	push   %ebp
    12e7:	89 e5                	mov    %esp,%ebp
    12e9:	57                   	push   %edi
    12ea:	56                   	push   %esi
    12eb:	53                   	push   %ebx
    12ec:	83 ec 3c             	sub    $0x3c,%esp
    12ef:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12f5:	74 14                	je     130b <printint+0x25>
    12f7:	85 d2                	test   %edx,%edx
    12f9:	79 10                	jns    130b <printint+0x25>
    neg = 1;
    x = -xx;
    12fb:	f7 da                	neg    %edx
    neg = 1;
    12fd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1304:	bf 00 00 00 00       	mov    $0x0,%edi
    1309:	eb 0b                	jmp    1316 <printint+0x30>
  neg = 0;
    130b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1312:	eb f0                	jmp    1304 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1314:	89 df                	mov    %ebx,%edi
    1316:	8d 5f 01             	lea    0x1(%edi),%ebx
    1319:	89 d0                	mov    %edx,%eax
    131b:	ba 00 00 00 00       	mov    $0x0,%edx
    1320:	f7 f1                	div    %ecx
    1322:	0f b6 92 c4 16 00 00 	movzbl 0x16c4(%edx),%edx
    1329:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    132d:	89 c2                	mov    %eax,%edx
    132f:	85 c0                	test   %eax,%eax
    1331:	75 e1                	jne    1314 <printint+0x2e>
  if(neg)
    1333:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    1337:	74 08                	je     1341 <printint+0x5b>
    buf[i++] = '-';
    1339:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    133e:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1341:	83 eb 01             	sub    $0x1,%ebx
    1344:	78 22                	js     1368 <printint+0x82>
  write(fd, &c, 1);
    1346:	8d 7d d7             	lea    -0x29(%ebp),%edi
    1349:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    134e:	88 45 d7             	mov    %al,-0x29(%ebp)
    1351:	83 ec 04             	sub    $0x4,%esp
    1354:	6a 01                	push   $0x1
    1356:	57                   	push   %edi
    1357:	56                   	push   %esi
    1358:	e8 f9 fe ff ff       	call   1256 <write>
  while(--i >= 0)
    135d:	83 eb 01             	sub    $0x1,%ebx
    1360:	83 c4 10             	add    $0x10,%esp
    1363:	83 fb ff             	cmp    $0xffffffff,%ebx
    1366:	75 e1                	jne    1349 <printint+0x63>
    putc(fd, buf[i]);
}
    1368:	8d 65 f4             	lea    -0xc(%ebp),%esp
    136b:	5b                   	pop    %ebx
    136c:	5e                   	pop    %esi
    136d:	5f                   	pop    %edi
    136e:	5d                   	pop    %ebp
    136f:	c3                   	ret    

00001370 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1370:	55                   	push   %ebp
    1371:	89 e5                	mov    %esp,%ebp
    1373:	57                   	push   %edi
    1374:	56                   	push   %esi
    1375:	53                   	push   %ebx
    1376:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1379:	8b 75 0c             	mov    0xc(%ebp),%esi
    137c:	0f b6 1e             	movzbl (%esi),%ebx
    137f:	84 db                	test   %bl,%bl
    1381:	0f 84 b1 01 00 00    	je     1538 <printf+0x1c8>
    1387:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    138a:	8d 45 10             	lea    0x10(%ebp),%eax
    138d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1390:	bf 00 00 00 00       	mov    $0x0,%edi
    1395:	eb 2d                	jmp    13c4 <printf+0x54>
    1397:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    139a:	83 ec 04             	sub    $0x4,%esp
    139d:	6a 01                	push   $0x1
    139f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    13a2:	50                   	push   %eax
    13a3:	ff 75 08             	pushl  0x8(%ebp)
    13a6:	e8 ab fe ff ff       	call   1256 <write>
    13ab:	83 c4 10             	add    $0x10,%esp
    13ae:	eb 05                	jmp    13b5 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    13b0:	83 ff 25             	cmp    $0x25,%edi
    13b3:	74 22                	je     13d7 <printf+0x67>
    13b5:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    13b8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    13bc:	84 db                	test   %bl,%bl
    13be:	0f 84 74 01 00 00    	je     1538 <printf+0x1c8>
    c = fmt[i] & 0xff;
    13c4:	0f be d3             	movsbl %bl,%edx
    13c7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    13ca:	85 ff                	test   %edi,%edi
    13cc:	75 e2                	jne    13b0 <printf+0x40>
      if(c == '%'){
    13ce:	83 f8 25             	cmp    $0x25,%eax
    13d1:	75 c4                	jne    1397 <printf+0x27>
        state = '%';
    13d3:	89 c7                	mov    %eax,%edi
    13d5:	eb de                	jmp    13b5 <printf+0x45>
      if(c == 'd'){
    13d7:	83 f8 64             	cmp    $0x64,%eax
    13da:	74 59                	je     1435 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13dc:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    13e2:	83 fa 70             	cmp    $0x70,%edx
    13e5:	74 7a                	je     1461 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13e7:	83 f8 73             	cmp    $0x73,%eax
    13ea:	0f 84 9d 00 00 00    	je     148d <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13f0:	83 f8 63             	cmp    $0x63,%eax
    13f3:	0f 84 f2 00 00 00    	je     14eb <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13f9:	83 f8 25             	cmp    $0x25,%eax
    13fc:	0f 84 15 01 00 00    	je     1517 <printf+0x1a7>
    1402:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    1406:	83 ec 04             	sub    $0x4,%esp
    1409:	6a 01                	push   $0x1
    140b:	8d 45 e7             	lea    -0x19(%ebp),%eax
    140e:	50                   	push   %eax
    140f:	ff 75 08             	pushl  0x8(%ebp)
    1412:	e8 3f fe ff ff       	call   1256 <write>
    1417:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    141a:	83 c4 0c             	add    $0xc,%esp
    141d:	6a 01                	push   $0x1
    141f:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1422:	50                   	push   %eax
    1423:	ff 75 08             	pushl  0x8(%ebp)
    1426:	e8 2b fe ff ff       	call   1256 <write>
    142b:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    142e:	bf 00 00 00 00       	mov    $0x0,%edi
    1433:	eb 80                	jmp    13b5 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1435:	83 ec 0c             	sub    $0xc,%esp
    1438:	6a 01                	push   $0x1
    143a:	b9 0a 00 00 00       	mov    $0xa,%ecx
    143f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1442:	8b 17                	mov    (%edi),%edx
    1444:	8b 45 08             	mov    0x8(%ebp),%eax
    1447:	e8 9a fe ff ff       	call   12e6 <printint>
        ap++;
    144c:	89 f8                	mov    %edi,%eax
    144e:	83 c0 04             	add    $0x4,%eax
    1451:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1454:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1457:	bf 00 00 00 00       	mov    $0x0,%edi
    145c:	e9 54 ff ff ff       	jmp    13b5 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1461:	83 ec 0c             	sub    $0xc,%esp
    1464:	6a 00                	push   $0x0
    1466:	b9 10 00 00 00       	mov    $0x10,%ecx
    146b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    146e:	8b 17                	mov    (%edi),%edx
    1470:	8b 45 08             	mov    0x8(%ebp),%eax
    1473:	e8 6e fe ff ff       	call   12e6 <printint>
        ap++;
    1478:	89 f8                	mov    %edi,%eax
    147a:	83 c0 04             	add    $0x4,%eax
    147d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1480:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1483:	bf 00 00 00 00       	mov    $0x0,%edi
    1488:	e9 28 ff ff ff       	jmp    13b5 <printf+0x45>
        s = (char*)*ap;
    148d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1490:	8b 01                	mov    (%ecx),%eax
        ap++;
    1492:	83 c1 04             	add    $0x4,%ecx
    1495:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1498:	85 c0                	test   %eax,%eax
    149a:	74 13                	je     14af <printf+0x13f>
        s = (char*)*ap;
    149c:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    149e:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    14a1:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    14a6:	84 c0                	test   %al,%al
    14a8:	75 0f                	jne    14b9 <printf+0x149>
    14aa:	e9 06 ff ff ff       	jmp    13b5 <printf+0x45>
          s = "(null)";
    14af:	bb bb 16 00 00       	mov    $0x16bb,%ebx
        while(*s != 0){
    14b4:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    14b9:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    14bc:	89 75 d0             	mov    %esi,-0x30(%ebp)
    14bf:	8b 75 08             	mov    0x8(%ebp),%esi
    14c2:	88 45 e3             	mov    %al,-0x1d(%ebp)
    14c5:	83 ec 04             	sub    $0x4,%esp
    14c8:	6a 01                	push   $0x1
    14ca:	57                   	push   %edi
    14cb:	56                   	push   %esi
    14cc:	e8 85 fd ff ff       	call   1256 <write>
          s++;
    14d1:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    14d4:	0f b6 03             	movzbl (%ebx),%eax
    14d7:	83 c4 10             	add    $0x10,%esp
    14da:	84 c0                	test   %al,%al
    14dc:	75 e4                	jne    14c2 <printf+0x152>
    14de:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    14e1:	bf 00 00 00 00       	mov    $0x0,%edi
    14e6:	e9 ca fe ff ff       	jmp    13b5 <printf+0x45>
        putc(fd, *ap);
    14eb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14ee:	8b 07                	mov    (%edi),%eax
    14f0:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14f3:	83 ec 04             	sub    $0x4,%esp
    14f6:	6a 01                	push   $0x1
    14f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14fb:	50                   	push   %eax
    14fc:	ff 75 08             	pushl  0x8(%ebp)
    14ff:	e8 52 fd ff ff       	call   1256 <write>
        ap++;
    1504:	83 c7 04             	add    $0x4,%edi
    1507:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    150a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    150d:	bf 00 00 00 00       	mov    $0x0,%edi
    1512:	e9 9e fe ff ff       	jmp    13b5 <printf+0x45>
    1517:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    151a:	83 ec 04             	sub    $0x4,%esp
    151d:	6a 01                	push   $0x1
    151f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1522:	50                   	push   %eax
    1523:	ff 75 08             	pushl  0x8(%ebp)
    1526:	e8 2b fd ff ff       	call   1256 <write>
    152b:	83 c4 10             	add    $0x10,%esp
      state = 0;
    152e:	bf 00 00 00 00       	mov    $0x0,%edi
    1533:	e9 7d fe ff ff       	jmp    13b5 <printf+0x45>
    }
  }
}
    1538:	8d 65 f4             	lea    -0xc(%ebp),%esp
    153b:	5b                   	pop    %ebx
    153c:	5e                   	pop    %esi
    153d:	5f                   	pop    %edi
    153e:	5d                   	pop    %ebp
    153f:	c3                   	ret    

00001540 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1540:	55                   	push   %ebp
    1541:	89 e5                	mov    %esp,%ebp
    1543:	57                   	push   %edi
    1544:	56                   	push   %esi
    1545:	53                   	push   %ebx
    1546:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1549:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    154c:	a1 38 19 00 00       	mov    0x1938,%eax
    1551:	eb 0c                	jmp    155f <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1553:	8b 10                	mov    (%eax),%edx
    1555:	39 c2                	cmp    %eax,%edx
    1557:	77 04                	ja     155d <free+0x1d>
    1559:	39 ca                	cmp    %ecx,%edx
    155b:	77 10                	ja     156d <free+0x2d>
{
    155d:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    155f:	39 c8                	cmp    %ecx,%eax
    1561:	73 f0                	jae    1553 <free+0x13>
    1563:	8b 10                	mov    (%eax),%edx
    1565:	39 ca                	cmp    %ecx,%edx
    1567:	77 04                	ja     156d <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1569:	39 c2                	cmp    %eax,%edx
    156b:	77 f0                	ja     155d <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    156d:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1570:	8b 10                	mov    (%eax),%edx
    1572:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1575:	39 fa                	cmp    %edi,%edx
    1577:	74 19                	je     1592 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1579:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    157c:	8b 50 04             	mov    0x4(%eax),%edx
    157f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1582:	39 f1                	cmp    %esi,%ecx
    1584:	74 1b                	je     15a1 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1586:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1588:	a3 38 19 00 00       	mov    %eax,0x1938
}
    158d:	5b                   	pop    %ebx
    158e:	5e                   	pop    %esi
    158f:	5f                   	pop    %edi
    1590:	5d                   	pop    %ebp
    1591:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1592:	03 72 04             	add    0x4(%edx),%esi
    1595:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1598:	8b 10                	mov    (%eax),%edx
    159a:	8b 12                	mov    (%edx),%edx
    159c:	89 53 f8             	mov    %edx,-0x8(%ebx)
    159f:	eb db                	jmp    157c <free+0x3c>
    p->s.size += bp->s.size;
    15a1:	03 53 fc             	add    -0x4(%ebx),%edx
    15a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    15a7:	8b 53 f8             	mov    -0x8(%ebx),%edx
    15aa:	89 10                	mov    %edx,(%eax)
    15ac:	eb da                	jmp    1588 <free+0x48>

000015ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    15ae:	55                   	push   %ebp
    15af:	89 e5                	mov    %esp,%ebp
    15b1:	57                   	push   %edi
    15b2:	56                   	push   %esi
    15b3:	53                   	push   %ebx
    15b4:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15b7:	8b 45 08             	mov    0x8(%ebp),%eax
    15ba:	8d 58 07             	lea    0x7(%eax),%ebx
    15bd:	c1 eb 03             	shr    $0x3,%ebx
    15c0:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15c3:	8b 15 38 19 00 00    	mov    0x1938,%edx
    15c9:	85 d2                	test   %edx,%edx
    15cb:	74 20                	je     15ed <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15cd:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15cf:	8b 48 04             	mov    0x4(%eax),%ecx
    15d2:	39 cb                	cmp    %ecx,%ebx
    15d4:	76 3c                	jbe    1612 <malloc+0x64>
    15d6:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    15dc:	be 00 10 00 00       	mov    $0x1000,%esi
    15e1:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    15e4:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15eb:	eb 70                	jmp    165d <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15ed:	c7 05 38 19 00 00 3c 	movl   $0x193c,0x1938
    15f4:	19 00 00 
    15f7:	c7 05 3c 19 00 00 3c 	movl   $0x193c,0x193c
    15fe:	19 00 00 
    base.s.size = 0;
    1601:	c7 05 40 19 00 00 00 	movl   $0x0,0x1940
    1608:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    160b:	ba 3c 19 00 00       	mov    $0x193c,%edx
    1610:	eb bb                	jmp    15cd <malloc+0x1f>
      if(p->s.size == nunits)
    1612:	39 cb                	cmp    %ecx,%ebx
    1614:	74 1c                	je     1632 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1616:	29 d9                	sub    %ebx,%ecx
    1618:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    161b:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    161e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1621:	89 15 38 19 00 00    	mov    %edx,0x1938
      return (void*)(p + 1);
    1627:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    162d:	5b                   	pop    %ebx
    162e:	5e                   	pop    %esi
    162f:	5f                   	pop    %edi
    1630:	5d                   	pop    %ebp
    1631:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1632:	8b 08                	mov    (%eax),%ecx
    1634:	89 0a                	mov    %ecx,(%edx)
    1636:	eb e9                	jmp    1621 <malloc+0x73>
  hp->s.size = nu;
    1638:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    163b:	83 ec 0c             	sub    $0xc,%esp
    163e:	83 c0 08             	add    $0x8,%eax
    1641:	50                   	push   %eax
    1642:	e8 f9 fe ff ff       	call   1540 <free>
  return freep;
    1647:	8b 15 38 19 00 00    	mov    0x1938,%edx
      if((p = morecore(nunits)) == 0)
    164d:	83 c4 10             	add    $0x10,%esp
    1650:	85 d2                	test   %edx,%edx
    1652:	74 2b                	je     167f <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1654:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1656:	8b 48 04             	mov    0x4(%eax),%ecx
    1659:	39 d9                	cmp    %ebx,%ecx
    165b:	73 b5                	jae    1612 <malloc+0x64>
    165d:	89 c2                	mov    %eax,%edx
    if(p == freep)
    165f:	39 05 38 19 00 00    	cmp    %eax,0x1938
    1665:	75 ed                	jne    1654 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1667:	83 ec 0c             	sub    $0xc,%esp
    166a:	57                   	push   %edi
    166b:	e8 4e fc ff ff       	call   12be <sbrk>
  if(p == (char*)-1)
    1670:	83 c4 10             	add    $0x10,%esp
    1673:	83 f8 ff             	cmp    $0xffffffff,%eax
    1676:	75 c0                	jne    1638 <malloc+0x8a>
        return 0;
    1678:	b8 00 00 00 00       	mov    $0x0,%eax
    167d:	eb ab                	jmp    162a <malloc+0x7c>
    167f:	b8 00 00 00 00       	mov    $0x0,%eax
    1684:	eb a4                	jmp    162a <malloc+0x7c>
