
_echo:     file format elf32-i386


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
    1014:	8b 01                	mov    (%ecx),%eax
    1016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1019:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
    101c:	83 f8 01             	cmp    $0x1,%eax
    101f:	7e 41                	jle    1062 <main+0x62>
    1021:	8d 5f 04             	lea    0x4(%edi),%ebx
    1024:	8d 74 87 fc          	lea    -0x4(%edi,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    1028:	39 f3                	cmp    %esi,%ebx
    102a:	74 1b                	je     1047 <main+0x47>
    102c:	68 78 16 00 00       	push   $0x1678
    1031:	ff 33                	pushl  (%ebx)
    1033:	68 7a 16 00 00       	push   $0x167a
    1038:	6a 01                	push   $0x1
    103a:	e8 22 03 00 00       	call   1361 <printf>
    103f:	83 c3 04             	add    $0x4,%ebx
    1042:	83 c4 10             	add    $0x10,%esp
    1045:	eb e1                	jmp    1028 <main+0x28>
    1047:	68 7f 16 00 00       	push   $0x167f
    104c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    104f:	ff 74 87 fc          	pushl  -0x4(%edi,%eax,4)
    1053:	68 7a 16 00 00       	push   $0x167a
    1058:	6a 01                	push   $0x1
    105a:	e8 02 03 00 00       	call   1361 <printf>
    105f:	83 c4 10             	add    $0x10,%esp
  exit();
    1062:	e8 c0 01 00 00       	call   1227 <exit>

00001067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1067:	55                   	push   %ebp
    1068:	89 e5                	mov    %esp,%ebp
    106a:	53                   	push   %ebx
    106b:	8b 45 08             	mov    0x8(%ebp),%eax
    106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1071:	89 c2                	mov    %eax,%edx
    1073:	83 c1 01             	add    $0x1,%ecx
    1076:	83 c2 01             	add    $0x1,%edx
    1079:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    107d:	88 5a ff             	mov    %bl,-0x1(%edx)
    1080:	84 db                	test   %bl,%bl
    1082:	75 ef                	jne    1073 <strcpy+0xc>
    ;
  return os;
}
    1084:	5b                   	pop    %ebx
    1085:	5d                   	pop    %ebp
    1086:	c3                   	ret    

00001087 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1087:	55                   	push   %ebp
    1088:	89 e5                	mov    %esp,%ebp
    108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    108d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1090:	0f b6 01             	movzbl (%ecx),%eax
    1093:	84 c0                	test   %al,%al
    1095:	74 15                	je     10ac <strcmp+0x25>
    1097:	3a 02                	cmp    (%edx),%al
    1099:	75 11                	jne    10ac <strcmp+0x25>
    p++, q++;
    109b:	83 c1 01             	add    $0x1,%ecx
    109e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10a1:	0f b6 01             	movzbl (%ecx),%eax
    10a4:	84 c0                	test   %al,%al
    10a6:	74 04                	je     10ac <strcmp+0x25>
    10a8:	3a 02                	cmp    (%edx),%al
    10aa:	74 ef                	je     109b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    10ac:	0f b6 c0             	movzbl %al,%eax
    10af:	0f b6 12             	movzbl (%edx),%edx
    10b2:	29 d0                	sub    %edx,%eax
}
    10b4:	5d                   	pop    %ebp
    10b5:	c3                   	ret    

000010b6 <strlen>:

uint
strlen(const char *s)
{
    10b6:	55                   	push   %ebp
    10b7:	89 e5                	mov    %esp,%ebp
    10b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10bc:	80 39 00             	cmpb   $0x0,(%ecx)
    10bf:	74 12                	je     10d3 <strlen+0x1d>
    10c1:	ba 00 00 00 00       	mov    $0x0,%edx
    10c6:	83 c2 01             	add    $0x1,%edx
    10c9:	89 d0                	mov    %edx,%eax
    10cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    10cf:	75 f5                	jne    10c6 <strlen+0x10>
    ;
  return n;
}
    10d1:	5d                   	pop    %ebp
    10d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
    10d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    10d8:	eb f7                	jmp    10d1 <strlen+0x1b>

000010da <memset>:

void*
memset(void *dst, int c, uint n)
{
    10da:	55                   	push   %ebp
    10db:	89 e5                	mov    %esp,%ebp
    10dd:	57                   	push   %edi
    10de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10e1:	89 d7                	mov    %edx,%edi
    10e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e9:	fc                   	cld    
    10ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10ec:	89 d0                	mov    %edx,%eax
    10ee:	5f                   	pop    %edi
    10ef:	5d                   	pop    %ebp
    10f0:	c3                   	ret    

000010f1 <strchr>:

char*
strchr(const char *s, char c)
{
    10f1:	55                   	push   %ebp
    10f2:	89 e5                	mov    %esp,%ebp
    10f4:	53                   	push   %ebx
    10f5:	8b 45 08             	mov    0x8(%ebp),%eax
    10f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10fb:	0f b6 10             	movzbl (%eax),%edx
    10fe:	84 d2                	test   %dl,%dl
    1100:	74 1e                	je     1120 <strchr+0x2f>
    1102:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1104:	38 d3                	cmp    %dl,%bl
    1106:	74 15                	je     111d <strchr+0x2c>
  for(; *s; s++)
    1108:	83 c0 01             	add    $0x1,%eax
    110b:	0f b6 10             	movzbl (%eax),%edx
    110e:	84 d2                	test   %dl,%dl
    1110:	74 06                	je     1118 <strchr+0x27>
    if(*s == c)
    1112:	38 ca                	cmp    %cl,%dl
    1114:	75 f2                	jne    1108 <strchr+0x17>
    1116:	eb 05                	jmp    111d <strchr+0x2c>
      return (char*)s;
  return 0;
    1118:	b8 00 00 00 00       	mov    $0x0,%eax
}
    111d:	5b                   	pop    %ebx
    111e:	5d                   	pop    %ebp
    111f:	c3                   	ret    
  return 0;
    1120:	b8 00 00 00 00       	mov    $0x0,%eax
    1125:	eb f6                	jmp    111d <strchr+0x2c>

00001127 <gets>:

char*
gets(char *buf, int max)
{
    1127:	55                   	push   %ebp
    1128:	89 e5                	mov    %esp,%ebp
    112a:	57                   	push   %edi
    112b:	56                   	push   %esi
    112c:	53                   	push   %ebx
    112d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1130:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1135:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1138:	8d 5e 01             	lea    0x1(%esi),%ebx
    113b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    113e:	7d 2b                	jge    116b <gets+0x44>
    cc = read(0, &c, 1);
    1140:	83 ec 04             	sub    $0x4,%esp
    1143:	6a 01                	push   $0x1
    1145:	57                   	push   %edi
    1146:	6a 00                	push   $0x0
    1148:	e8 f2 00 00 00       	call   123f <read>
    if(cc < 1)
    114d:	83 c4 10             	add    $0x10,%esp
    1150:	85 c0                	test   %eax,%eax
    1152:	7e 17                	jle    116b <gets+0x44>
      break;
    buf[i++] = c;
    1154:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1158:	8b 55 08             	mov    0x8(%ebp),%edx
    115b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    115f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1161:	3c 0a                	cmp    $0xa,%al
    1163:	74 04                	je     1169 <gets+0x42>
    1165:	3c 0d                	cmp    $0xd,%al
    1167:	75 cf                	jne    1138 <gets+0x11>
  for(i=0; i+1 < max; ){
    1169:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    116b:	8b 45 08             	mov    0x8(%ebp),%eax
    116e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1172:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1175:	5b                   	pop    %ebx
    1176:	5e                   	pop    %esi
    1177:	5f                   	pop    %edi
    1178:	5d                   	pop    %ebp
    1179:	c3                   	ret    

0000117a <stat>:

int
stat(const char *n, struct stat *st)
{
    117a:	55                   	push   %ebp
    117b:	89 e5                	mov    %esp,%ebp
    117d:	56                   	push   %esi
    117e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    117f:	83 ec 08             	sub    $0x8,%esp
    1182:	6a 00                	push   $0x0
    1184:	ff 75 08             	pushl  0x8(%ebp)
    1187:	e8 db 00 00 00       	call   1267 <open>
  if(fd < 0)
    118c:	83 c4 10             	add    $0x10,%esp
    118f:	85 c0                	test   %eax,%eax
    1191:	78 24                	js     11b7 <stat+0x3d>
    1193:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1195:	83 ec 08             	sub    $0x8,%esp
    1198:	ff 75 0c             	pushl  0xc(%ebp)
    119b:	50                   	push   %eax
    119c:	e8 de 00 00 00       	call   127f <fstat>
    11a1:	89 c6                	mov    %eax,%esi
  close(fd);
    11a3:	89 1c 24             	mov    %ebx,(%esp)
    11a6:	e8 a4 00 00 00       	call   124f <close>
  return r;
    11ab:	83 c4 10             	add    $0x10,%esp
}
    11ae:	89 f0                	mov    %esi,%eax
    11b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11b3:	5b                   	pop    %ebx
    11b4:	5e                   	pop    %esi
    11b5:	5d                   	pop    %ebp
    11b6:	c3                   	ret    
    return -1;
    11b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11bc:	eb f0                	jmp    11ae <stat+0x34>

000011be <atoi>:

int
atoi(const char *s)
{
    11be:	55                   	push   %ebp
    11bf:	89 e5                	mov    %esp,%ebp
    11c1:	53                   	push   %ebx
    11c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11c5:	0f b6 11             	movzbl (%ecx),%edx
    11c8:	8d 42 d0             	lea    -0x30(%edx),%eax
    11cb:	3c 09                	cmp    $0x9,%al
    11cd:	77 20                	ja     11ef <atoi+0x31>
  n = 0;
    11cf:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    11d4:	83 c1 01             	add    $0x1,%ecx
    11d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11da:	0f be d2             	movsbl %dl,%edx
    11dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11e1:	0f b6 11             	movzbl (%ecx),%edx
    11e4:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11e7:	80 fb 09             	cmp    $0x9,%bl
    11ea:	76 e8                	jbe    11d4 <atoi+0x16>
  return n;
}
    11ec:	5b                   	pop    %ebx
    11ed:	5d                   	pop    %ebp
    11ee:	c3                   	ret    
  n = 0;
    11ef:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11f4:	eb f6                	jmp    11ec <atoi+0x2e>

000011f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11f6:	55                   	push   %ebp
    11f7:	89 e5                	mov    %esp,%ebp
    11f9:	56                   	push   %esi
    11fa:	53                   	push   %ebx
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	8b 75 0c             	mov    0xc(%ebp),%esi
    1201:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1204:	85 db                	test   %ebx,%ebx
    1206:	7e 13                	jle    121b <memmove+0x25>
    1208:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    120d:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1211:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1214:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1217:	39 d3                	cmp    %edx,%ebx
    1219:	75 f2                	jne    120d <memmove+0x17>
  return vdst;
}
    121b:	5b                   	pop    %ebx
    121c:	5e                   	pop    %esi
    121d:	5d                   	pop    %ebp
    121e:	c3                   	ret    

0000121f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    121f:	b8 01 00 00 00       	mov    $0x1,%eax
    1224:	cd 40                	int    $0x40
    1226:	c3                   	ret    

00001227 <exit>:
SYSCALL(exit)
    1227:	b8 02 00 00 00       	mov    $0x2,%eax
    122c:	cd 40                	int    $0x40
    122e:	c3                   	ret    

0000122f <wait>:
SYSCALL(wait)
    122f:	b8 03 00 00 00       	mov    $0x3,%eax
    1234:	cd 40                	int    $0x40
    1236:	c3                   	ret    

00001237 <pipe>:
SYSCALL(pipe)
    1237:	b8 04 00 00 00       	mov    $0x4,%eax
    123c:	cd 40                	int    $0x40
    123e:	c3                   	ret    

0000123f <read>:
SYSCALL(read)
    123f:	b8 05 00 00 00       	mov    $0x5,%eax
    1244:	cd 40                	int    $0x40
    1246:	c3                   	ret    

00001247 <write>:
SYSCALL(write)
    1247:	b8 10 00 00 00       	mov    $0x10,%eax
    124c:	cd 40                	int    $0x40
    124e:	c3                   	ret    

0000124f <close>:
SYSCALL(close)
    124f:	b8 15 00 00 00       	mov    $0x15,%eax
    1254:	cd 40                	int    $0x40
    1256:	c3                   	ret    

00001257 <kill>:
SYSCALL(kill)
    1257:	b8 06 00 00 00       	mov    $0x6,%eax
    125c:	cd 40                	int    $0x40
    125e:	c3                   	ret    

0000125f <exec>:
SYSCALL(exec)
    125f:	b8 07 00 00 00       	mov    $0x7,%eax
    1264:	cd 40                	int    $0x40
    1266:	c3                   	ret    

00001267 <open>:
SYSCALL(open)
    1267:	b8 0f 00 00 00       	mov    $0xf,%eax
    126c:	cd 40                	int    $0x40
    126e:	c3                   	ret    

0000126f <mknod>:
SYSCALL(mknod)
    126f:	b8 11 00 00 00       	mov    $0x11,%eax
    1274:	cd 40                	int    $0x40
    1276:	c3                   	ret    

00001277 <unlink>:
SYSCALL(unlink)
    1277:	b8 12 00 00 00       	mov    $0x12,%eax
    127c:	cd 40                	int    $0x40
    127e:	c3                   	ret    

0000127f <fstat>:
SYSCALL(fstat)
    127f:	b8 08 00 00 00       	mov    $0x8,%eax
    1284:	cd 40                	int    $0x40
    1286:	c3                   	ret    

00001287 <link>:
SYSCALL(link)
    1287:	b8 13 00 00 00       	mov    $0x13,%eax
    128c:	cd 40                	int    $0x40
    128e:	c3                   	ret    

0000128f <mkdir>:
SYSCALL(mkdir)
    128f:	b8 14 00 00 00       	mov    $0x14,%eax
    1294:	cd 40                	int    $0x40
    1296:	c3                   	ret    

00001297 <chdir>:
SYSCALL(chdir)
    1297:	b8 09 00 00 00       	mov    $0x9,%eax
    129c:	cd 40                	int    $0x40
    129e:	c3                   	ret    

0000129f <dup>:
SYSCALL(dup)
    129f:	b8 0a 00 00 00       	mov    $0xa,%eax
    12a4:	cd 40                	int    $0x40
    12a6:	c3                   	ret    

000012a7 <getpid>:
SYSCALL(getpid)
    12a7:	b8 0b 00 00 00       	mov    $0xb,%eax
    12ac:	cd 40                	int    $0x40
    12ae:	c3                   	ret    

000012af <sbrk>:
SYSCALL(sbrk)
    12af:	b8 0c 00 00 00       	mov    $0xc,%eax
    12b4:	cd 40                	int    $0x40
    12b6:	c3                   	ret    

000012b7 <sleep>:
SYSCALL(sleep)
    12b7:	b8 0d 00 00 00       	mov    $0xd,%eax
    12bc:	cd 40                	int    $0x40
    12be:	c3                   	ret    

000012bf <uptime>:
SYSCALL(uptime)
    12bf:	b8 0e 00 00 00       	mov    $0xe,%eax
    12c4:	cd 40                	int    $0x40
    12c6:	c3                   	ret    

000012c7 <shmem_access>:
SYSCALL(shmem_access)
    12c7:	b8 16 00 00 00       	mov    $0x16,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <shmem_count>:
    12cf:	b8 17 00 00 00       	mov    $0x17,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12d7:	55                   	push   %ebp
    12d8:	89 e5                	mov    %esp,%ebp
    12da:	57                   	push   %edi
    12db:	56                   	push   %esi
    12dc:	53                   	push   %ebx
    12dd:	83 ec 3c             	sub    $0x3c,%esp
    12e0:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12e6:	74 14                	je     12fc <printint+0x25>
    12e8:	85 d2                	test   %edx,%edx
    12ea:	79 10                	jns    12fc <printint+0x25>
    neg = 1;
    x = -xx;
    12ec:	f7 da                	neg    %edx
    neg = 1;
    12ee:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12f5:	bf 00 00 00 00       	mov    $0x0,%edi
    12fa:	eb 0b                	jmp    1307 <printint+0x30>
  neg = 0;
    12fc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1303:	eb f0                	jmp    12f5 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1305:	89 df                	mov    %ebx,%edi
    1307:	8d 5f 01             	lea    0x1(%edi),%ebx
    130a:	89 d0                	mov    %edx,%eax
    130c:	ba 00 00 00 00       	mov    $0x0,%edx
    1311:	f7 f1                	div    %ecx
    1313:	0f b6 92 88 16 00 00 	movzbl 0x1688(%edx),%edx
    131a:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    131e:	89 c2                	mov    %eax,%edx
    1320:	85 c0                	test   %eax,%eax
    1322:	75 e1                	jne    1305 <printint+0x2e>
  if(neg)
    1324:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    1328:	74 08                	je     1332 <printint+0x5b>
    buf[i++] = '-';
    132a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    132f:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1332:	83 eb 01             	sub    $0x1,%ebx
    1335:	78 22                	js     1359 <printint+0x82>
  write(fd, &c, 1);
    1337:	8d 7d d7             	lea    -0x29(%ebp),%edi
    133a:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    133f:	88 45 d7             	mov    %al,-0x29(%ebp)
    1342:	83 ec 04             	sub    $0x4,%esp
    1345:	6a 01                	push   $0x1
    1347:	57                   	push   %edi
    1348:	56                   	push   %esi
    1349:	e8 f9 fe ff ff       	call   1247 <write>
  while(--i >= 0)
    134e:	83 eb 01             	sub    $0x1,%ebx
    1351:	83 c4 10             	add    $0x10,%esp
    1354:	83 fb ff             	cmp    $0xffffffff,%ebx
    1357:	75 e1                	jne    133a <printint+0x63>
    putc(fd, buf[i]);
}
    1359:	8d 65 f4             	lea    -0xc(%ebp),%esp
    135c:	5b                   	pop    %ebx
    135d:	5e                   	pop    %esi
    135e:	5f                   	pop    %edi
    135f:	5d                   	pop    %ebp
    1360:	c3                   	ret    

00001361 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1361:	55                   	push   %ebp
    1362:	89 e5                	mov    %esp,%ebp
    1364:	57                   	push   %edi
    1365:	56                   	push   %esi
    1366:	53                   	push   %ebx
    1367:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    136a:	8b 75 0c             	mov    0xc(%ebp),%esi
    136d:	0f b6 1e             	movzbl (%esi),%ebx
    1370:	84 db                	test   %bl,%bl
    1372:	0f 84 b1 01 00 00    	je     1529 <printf+0x1c8>
    1378:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    137b:	8d 45 10             	lea    0x10(%ebp),%eax
    137e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1381:	bf 00 00 00 00       	mov    $0x0,%edi
    1386:	eb 2d                	jmp    13b5 <printf+0x54>
    1388:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    138b:	83 ec 04             	sub    $0x4,%esp
    138e:	6a 01                	push   $0x1
    1390:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1393:	50                   	push   %eax
    1394:	ff 75 08             	pushl  0x8(%ebp)
    1397:	e8 ab fe ff ff       	call   1247 <write>
    139c:	83 c4 10             	add    $0x10,%esp
    139f:	eb 05                	jmp    13a6 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    13a1:	83 ff 25             	cmp    $0x25,%edi
    13a4:	74 22                	je     13c8 <printf+0x67>
    13a6:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    13a9:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    13ad:	84 db                	test   %bl,%bl
    13af:	0f 84 74 01 00 00    	je     1529 <printf+0x1c8>
    c = fmt[i] & 0xff;
    13b5:	0f be d3             	movsbl %bl,%edx
    13b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    13bb:	85 ff                	test   %edi,%edi
    13bd:	75 e2                	jne    13a1 <printf+0x40>
      if(c == '%'){
    13bf:	83 f8 25             	cmp    $0x25,%eax
    13c2:	75 c4                	jne    1388 <printf+0x27>
        state = '%';
    13c4:	89 c7                	mov    %eax,%edi
    13c6:	eb de                	jmp    13a6 <printf+0x45>
      if(c == 'd'){
    13c8:	83 f8 64             	cmp    $0x64,%eax
    13cb:	74 59                	je     1426 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13cd:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    13d3:	83 fa 70             	cmp    $0x70,%edx
    13d6:	74 7a                	je     1452 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13d8:	83 f8 73             	cmp    $0x73,%eax
    13db:	0f 84 9d 00 00 00    	je     147e <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13e1:	83 f8 63             	cmp    $0x63,%eax
    13e4:	0f 84 f2 00 00 00    	je     14dc <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13ea:	83 f8 25             	cmp    $0x25,%eax
    13ed:	0f 84 15 01 00 00    	je     1508 <printf+0x1a7>
    13f3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    13f7:	83 ec 04             	sub    $0x4,%esp
    13fa:	6a 01                	push   $0x1
    13fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13ff:	50                   	push   %eax
    1400:	ff 75 08             	pushl  0x8(%ebp)
    1403:	e8 3f fe ff ff       	call   1247 <write>
    1408:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    140b:	83 c4 0c             	add    $0xc,%esp
    140e:	6a 01                	push   $0x1
    1410:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1413:	50                   	push   %eax
    1414:	ff 75 08             	pushl  0x8(%ebp)
    1417:	e8 2b fe ff ff       	call   1247 <write>
    141c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    141f:	bf 00 00 00 00       	mov    $0x0,%edi
    1424:	eb 80                	jmp    13a6 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1426:	83 ec 0c             	sub    $0xc,%esp
    1429:	6a 01                	push   $0x1
    142b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1430:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1433:	8b 17                	mov    (%edi),%edx
    1435:	8b 45 08             	mov    0x8(%ebp),%eax
    1438:	e8 9a fe ff ff       	call   12d7 <printint>
        ap++;
    143d:	89 f8                	mov    %edi,%eax
    143f:	83 c0 04             	add    $0x4,%eax
    1442:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1445:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1448:	bf 00 00 00 00       	mov    $0x0,%edi
    144d:	e9 54 ff ff ff       	jmp    13a6 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1452:	83 ec 0c             	sub    $0xc,%esp
    1455:	6a 00                	push   $0x0
    1457:	b9 10 00 00 00       	mov    $0x10,%ecx
    145c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    145f:	8b 17                	mov    (%edi),%edx
    1461:	8b 45 08             	mov    0x8(%ebp),%eax
    1464:	e8 6e fe ff ff       	call   12d7 <printint>
        ap++;
    1469:	89 f8                	mov    %edi,%eax
    146b:	83 c0 04             	add    $0x4,%eax
    146e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1471:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1474:	bf 00 00 00 00       	mov    $0x0,%edi
    1479:	e9 28 ff ff ff       	jmp    13a6 <printf+0x45>
        s = (char*)*ap;
    147e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1481:	8b 01                	mov    (%ecx),%eax
        ap++;
    1483:	83 c1 04             	add    $0x4,%ecx
    1486:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1489:	85 c0                	test   %eax,%eax
    148b:	74 13                	je     14a0 <printf+0x13f>
        s = (char*)*ap;
    148d:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    148f:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1492:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    1497:	84 c0                	test   %al,%al
    1499:	75 0f                	jne    14aa <printf+0x149>
    149b:	e9 06 ff ff ff       	jmp    13a6 <printf+0x45>
          s = "(null)";
    14a0:	bb 81 16 00 00       	mov    $0x1681,%ebx
        while(*s != 0){
    14a5:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    14aa:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    14ad:	89 75 d0             	mov    %esi,-0x30(%ebp)
    14b0:	8b 75 08             	mov    0x8(%ebp),%esi
    14b3:	88 45 e3             	mov    %al,-0x1d(%ebp)
    14b6:	83 ec 04             	sub    $0x4,%esp
    14b9:	6a 01                	push   $0x1
    14bb:	57                   	push   %edi
    14bc:	56                   	push   %esi
    14bd:	e8 85 fd ff ff       	call   1247 <write>
          s++;
    14c2:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    14c5:	0f b6 03             	movzbl (%ebx),%eax
    14c8:	83 c4 10             	add    $0x10,%esp
    14cb:	84 c0                	test   %al,%al
    14cd:	75 e4                	jne    14b3 <printf+0x152>
    14cf:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    14d2:	bf 00 00 00 00       	mov    $0x0,%edi
    14d7:	e9 ca fe ff ff       	jmp    13a6 <printf+0x45>
        putc(fd, *ap);
    14dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14df:	8b 07                	mov    (%edi),%eax
    14e1:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14e4:	83 ec 04             	sub    $0x4,%esp
    14e7:	6a 01                	push   $0x1
    14e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14ec:	50                   	push   %eax
    14ed:	ff 75 08             	pushl  0x8(%ebp)
    14f0:	e8 52 fd ff ff       	call   1247 <write>
        ap++;
    14f5:	83 c7 04             	add    $0x4,%edi
    14f8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14fb:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14fe:	bf 00 00 00 00       	mov    $0x0,%edi
    1503:	e9 9e fe ff ff       	jmp    13a6 <printf+0x45>
    1508:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    150b:	83 ec 04             	sub    $0x4,%esp
    150e:	6a 01                	push   $0x1
    1510:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1513:	50                   	push   %eax
    1514:	ff 75 08             	pushl  0x8(%ebp)
    1517:	e8 2b fd ff ff       	call   1247 <write>
    151c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    151f:	bf 00 00 00 00       	mov    $0x0,%edi
    1524:	e9 7d fe ff ff       	jmp    13a6 <printf+0x45>
    }
  }
}
    1529:	8d 65 f4             	lea    -0xc(%ebp),%esp
    152c:	5b                   	pop    %ebx
    152d:	5e                   	pop    %esi
    152e:	5f                   	pop    %edi
    152f:	5d                   	pop    %ebp
    1530:	c3                   	ret    

00001531 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1531:	55                   	push   %ebp
    1532:	89 e5                	mov    %esp,%ebp
    1534:	57                   	push   %edi
    1535:	56                   	push   %esi
    1536:	53                   	push   %ebx
    1537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    153a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    153d:	a1 fc 18 00 00       	mov    0x18fc,%eax
    1542:	eb 0c                	jmp    1550 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1544:	8b 10                	mov    (%eax),%edx
    1546:	39 c2                	cmp    %eax,%edx
    1548:	77 04                	ja     154e <free+0x1d>
    154a:	39 ca                	cmp    %ecx,%edx
    154c:	77 10                	ja     155e <free+0x2d>
{
    154e:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1550:	39 c8                	cmp    %ecx,%eax
    1552:	73 f0                	jae    1544 <free+0x13>
    1554:	8b 10                	mov    (%eax),%edx
    1556:	39 ca                	cmp    %ecx,%edx
    1558:	77 04                	ja     155e <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    155a:	39 c2                	cmp    %eax,%edx
    155c:	77 f0                	ja     154e <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    155e:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1561:	8b 10                	mov    (%eax),%edx
    1563:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1566:	39 fa                	cmp    %edi,%edx
    1568:	74 19                	je     1583 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    156a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    156d:	8b 50 04             	mov    0x4(%eax),%edx
    1570:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1573:	39 f1                	cmp    %esi,%ecx
    1575:	74 1b                	je     1592 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1577:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1579:	a3 fc 18 00 00       	mov    %eax,0x18fc
}
    157e:	5b                   	pop    %ebx
    157f:	5e                   	pop    %esi
    1580:	5f                   	pop    %edi
    1581:	5d                   	pop    %ebp
    1582:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1583:	03 72 04             	add    0x4(%edx),%esi
    1586:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1589:	8b 10                	mov    (%eax),%edx
    158b:	8b 12                	mov    (%edx),%edx
    158d:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1590:	eb db                	jmp    156d <free+0x3c>
    p->s.size += bp->s.size;
    1592:	03 53 fc             	add    -0x4(%ebx),%edx
    1595:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1598:	8b 53 f8             	mov    -0x8(%ebx),%edx
    159b:	89 10                	mov    %edx,(%eax)
    159d:	eb da                	jmp    1579 <free+0x48>

0000159f <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    159f:	55                   	push   %ebp
    15a0:	89 e5                	mov    %esp,%ebp
    15a2:	57                   	push   %edi
    15a3:	56                   	push   %esi
    15a4:	53                   	push   %ebx
    15a5:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15a8:	8b 45 08             	mov    0x8(%ebp),%eax
    15ab:	8d 58 07             	lea    0x7(%eax),%ebx
    15ae:	c1 eb 03             	shr    $0x3,%ebx
    15b1:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15b4:	8b 15 fc 18 00 00    	mov    0x18fc,%edx
    15ba:	85 d2                	test   %edx,%edx
    15bc:	74 20                	je     15de <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15be:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15c0:	8b 48 04             	mov    0x4(%eax),%ecx
    15c3:	39 cb                	cmp    %ecx,%ebx
    15c5:	76 3c                	jbe    1603 <malloc+0x64>
    15c7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    15cd:	be 00 10 00 00       	mov    $0x1000,%esi
    15d2:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    15d5:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15dc:	eb 70                	jmp    164e <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15de:	c7 05 fc 18 00 00 00 	movl   $0x1900,0x18fc
    15e5:	19 00 00 
    15e8:	c7 05 00 19 00 00 00 	movl   $0x1900,0x1900
    15ef:	19 00 00 
    base.s.size = 0;
    15f2:	c7 05 04 19 00 00 00 	movl   $0x0,0x1904
    15f9:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    15fc:	ba 00 19 00 00       	mov    $0x1900,%edx
    1601:	eb bb                	jmp    15be <malloc+0x1f>
      if(p->s.size == nunits)
    1603:	39 cb                	cmp    %ecx,%ebx
    1605:	74 1c                	je     1623 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1607:	29 d9                	sub    %ebx,%ecx
    1609:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    160c:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    160f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1612:	89 15 fc 18 00 00    	mov    %edx,0x18fc
      return (void*)(p + 1);
    1618:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    161b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    161e:	5b                   	pop    %ebx
    161f:	5e                   	pop    %esi
    1620:	5f                   	pop    %edi
    1621:	5d                   	pop    %ebp
    1622:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1623:	8b 08                	mov    (%eax),%ecx
    1625:	89 0a                	mov    %ecx,(%edx)
    1627:	eb e9                	jmp    1612 <malloc+0x73>
  hp->s.size = nu;
    1629:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    162c:	83 ec 0c             	sub    $0xc,%esp
    162f:	83 c0 08             	add    $0x8,%eax
    1632:	50                   	push   %eax
    1633:	e8 f9 fe ff ff       	call   1531 <free>
  return freep;
    1638:	8b 15 fc 18 00 00    	mov    0x18fc,%edx
      if((p = morecore(nunits)) == 0)
    163e:	83 c4 10             	add    $0x10,%esp
    1641:	85 d2                	test   %edx,%edx
    1643:	74 2b                	je     1670 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1645:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1647:	8b 48 04             	mov    0x4(%eax),%ecx
    164a:	39 d9                	cmp    %ebx,%ecx
    164c:	73 b5                	jae    1603 <malloc+0x64>
    164e:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1650:	39 05 fc 18 00 00    	cmp    %eax,0x18fc
    1656:	75 ed                	jne    1645 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1658:	83 ec 0c             	sub    $0xc,%esp
    165b:	57                   	push   %edi
    165c:	e8 4e fc ff ff       	call   12af <sbrk>
  if(p == (char*)-1)
    1661:	83 c4 10             	add    $0x10,%esp
    1664:	83 f8 ff             	cmp    $0xffffffff,%eax
    1667:	75 c0                	jne    1629 <malloc+0x8a>
        return 0;
    1669:	b8 00 00 00 00       	mov    $0x0,%eax
    166e:	eb ab                	jmp    161b <malloc+0x7c>
    1670:	b8 00 00 00 00       	mov    $0x0,%eax
    1675:	eb a4                	jmp    161b <malloc+0x7c>
