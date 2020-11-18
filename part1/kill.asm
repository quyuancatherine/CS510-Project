
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	pushl  -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	56                   	push   %esi
    100e:	53                   	push   %ebx
    100f:	51                   	push   %ecx
    1010:	83 ec 0c             	sub    $0xc,%esp
    1013:	8b 01                	mov    (%ecx),%eax
    1015:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
    1018:	83 f8 01             	cmp    $0x1,%eax
    101b:	7e 27                	jle    1044 <main+0x44>
    101d:	8d 5a 04             	lea    0x4(%edx),%ebx
    1020:	8d 34 82             	lea    (%edx,%eax,4),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
    1023:	83 ec 0c             	sub    $0xc,%esp
    1026:	ff 33                	pushl  (%ebx)
    1028:	e8 82 01 00 00       	call   11af <atoi>
    102d:	89 04 24             	mov    %eax,(%esp)
    1030:	e8 13 02 00 00       	call   1248 <kill>
    1035:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
    1038:	83 c4 10             	add    $0x10,%esp
    103b:	39 f3                	cmp    %esi,%ebx
    103d:	75 e4                	jne    1023 <main+0x23>
  exit();
    103f:	e8 d4 01 00 00       	call   1218 <exit>
    printf(2, "usage: kill pid...\n");
    1044:	83 ec 08             	sub    $0x8,%esp
    1047:	68 68 16 00 00       	push   $0x1668
    104c:	6a 02                	push   $0x2
    104e:	e8 ff 02 00 00       	call   1352 <printf>
    exit();
    1053:	e8 c0 01 00 00       	call   1218 <exit>

00001058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1058:	55                   	push   %ebp
    1059:	89 e5                	mov    %esp,%ebp
    105b:	53                   	push   %ebx
    105c:	8b 45 08             	mov    0x8(%ebp),%eax
    105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1062:	89 c2                	mov    %eax,%edx
    1064:	83 c1 01             	add    $0x1,%ecx
    1067:	83 c2 01             	add    $0x1,%edx
    106a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    106e:	88 5a ff             	mov    %bl,-0x1(%edx)
    1071:	84 db                	test   %bl,%bl
    1073:	75 ef                	jne    1064 <strcpy+0xc>
    ;
  return os;
}
    1075:	5b                   	pop    %ebx
    1076:	5d                   	pop    %ebp
    1077:	c3                   	ret    

00001078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1078:	55                   	push   %ebp
    1079:	89 e5                	mov    %esp,%ebp
    107b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    107e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1081:	0f b6 01             	movzbl (%ecx),%eax
    1084:	84 c0                	test   %al,%al
    1086:	74 15                	je     109d <strcmp+0x25>
    1088:	3a 02                	cmp    (%edx),%al
    108a:	75 11                	jne    109d <strcmp+0x25>
    p++, q++;
    108c:	83 c1 01             	add    $0x1,%ecx
    108f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1092:	0f b6 01             	movzbl (%ecx),%eax
    1095:	84 c0                	test   %al,%al
    1097:	74 04                	je     109d <strcmp+0x25>
    1099:	3a 02                	cmp    (%edx),%al
    109b:	74 ef                	je     108c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    109d:	0f b6 c0             	movzbl %al,%eax
    10a0:	0f b6 12             	movzbl (%edx),%edx
    10a3:	29 d0                	sub    %edx,%eax
}
    10a5:	5d                   	pop    %ebp
    10a6:	c3                   	ret    

000010a7 <strlen>:

uint
strlen(const char *s)
{
    10a7:	55                   	push   %ebp
    10a8:	89 e5                	mov    %esp,%ebp
    10aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10ad:	80 39 00             	cmpb   $0x0,(%ecx)
    10b0:	74 12                	je     10c4 <strlen+0x1d>
    10b2:	ba 00 00 00 00       	mov    $0x0,%edx
    10b7:	83 c2 01             	add    $0x1,%edx
    10ba:	89 d0                	mov    %edx,%eax
    10bc:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    10c0:	75 f5                	jne    10b7 <strlen+0x10>
    ;
  return n;
}
    10c2:	5d                   	pop    %ebp
    10c3:	c3                   	ret    
  for(n = 0; s[n]; n++)
    10c4:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    10c9:	eb f7                	jmp    10c2 <strlen+0x1b>

000010cb <memset>:

void*
memset(void *dst, int c, uint n)
{
    10cb:	55                   	push   %ebp
    10cc:	89 e5                	mov    %esp,%ebp
    10ce:	57                   	push   %edi
    10cf:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10d2:	89 d7                	mov    %edx,%edi
    10d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10da:	fc                   	cld    
    10db:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10dd:	89 d0                	mov    %edx,%eax
    10df:	5f                   	pop    %edi
    10e0:	5d                   	pop    %ebp
    10e1:	c3                   	ret    

000010e2 <strchr>:

char*
strchr(const char *s, char c)
{
    10e2:	55                   	push   %ebp
    10e3:	89 e5                	mov    %esp,%ebp
    10e5:	53                   	push   %ebx
    10e6:	8b 45 08             	mov    0x8(%ebp),%eax
    10e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10ec:	0f b6 10             	movzbl (%eax),%edx
    10ef:	84 d2                	test   %dl,%dl
    10f1:	74 1e                	je     1111 <strchr+0x2f>
    10f3:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    10f5:	38 d3                	cmp    %dl,%bl
    10f7:	74 15                	je     110e <strchr+0x2c>
  for(; *s; s++)
    10f9:	83 c0 01             	add    $0x1,%eax
    10fc:	0f b6 10             	movzbl (%eax),%edx
    10ff:	84 d2                	test   %dl,%dl
    1101:	74 06                	je     1109 <strchr+0x27>
    if(*s == c)
    1103:	38 ca                	cmp    %cl,%dl
    1105:	75 f2                	jne    10f9 <strchr+0x17>
    1107:	eb 05                	jmp    110e <strchr+0x2c>
      return (char*)s;
  return 0;
    1109:	b8 00 00 00 00       	mov    $0x0,%eax
}
    110e:	5b                   	pop    %ebx
    110f:	5d                   	pop    %ebp
    1110:	c3                   	ret    
  return 0;
    1111:	b8 00 00 00 00       	mov    $0x0,%eax
    1116:	eb f6                	jmp    110e <strchr+0x2c>

00001118 <gets>:

char*
gets(char *buf, int max)
{
    1118:	55                   	push   %ebp
    1119:	89 e5                	mov    %esp,%ebp
    111b:	57                   	push   %edi
    111c:	56                   	push   %esi
    111d:	53                   	push   %ebx
    111e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1121:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1126:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1129:	8d 5e 01             	lea    0x1(%esi),%ebx
    112c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    112f:	7d 2b                	jge    115c <gets+0x44>
    cc = read(0, &c, 1);
    1131:	83 ec 04             	sub    $0x4,%esp
    1134:	6a 01                	push   $0x1
    1136:	57                   	push   %edi
    1137:	6a 00                	push   $0x0
    1139:	e8 f2 00 00 00       	call   1230 <read>
    if(cc < 1)
    113e:	83 c4 10             	add    $0x10,%esp
    1141:	85 c0                	test   %eax,%eax
    1143:	7e 17                	jle    115c <gets+0x44>
      break;
    buf[i++] = c;
    1145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1149:	8b 55 08             	mov    0x8(%ebp),%edx
    114c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1150:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1152:	3c 0a                	cmp    $0xa,%al
    1154:	74 04                	je     115a <gets+0x42>
    1156:	3c 0d                	cmp    $0xd,%al
    1158:	75 cf                	jne    1129 <gets+0x11>
  for(i=0; i+1 < max; ){
    115a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    115c:	8b 45 08             	mov    0x8(%ebp),%eax
    115f:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1163:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1166:	5b                   	pop    %ebx
    1167:	5e                   	pop    %esi
    1168:	5f                   	pop    %edi
    1169:	5d                   	pop    %ebp
    116a:	c3                   	ret    

0000116b <stat>:

int
stat(const char *n, struct stat *st)
{
    116b:	55                   	push   %ebp
    116c:	89 e5                	mov    %esp,%ebp
    116e:	56                   	push   %esi
    116f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1170:	83 ec 08             	sub    $0x8,%esp
    1173:	6a 00                	push   $0x0
    1175:	ff 75 08             	pushl  0x8(%ebp)
    1178:	e8 db 00 00 00       	call   1258 <open>
  if(fd < 0)
    117d:	83 c4 10             	add    $0x10,%esp
    1180:	85 c0                	test   %eax,%eax
    1182:	78 24                	js     11a8 <stat+0x3d>
    1184:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1186:	83 ec 08             	sub    $0x8,%esp
    1189:	ff 75 0c             	pushl  0xc(%ebp)
    118c:	50                   	push   %eax
    118d:	e8 de 00 00 00       	call   1270 <fstat>
    1192:	89 c6                	mov    %eax,%esi
  close(fd);
    1194:	89 1c 24             	mov    %ebx,(%esp)
    1197:	e8 a4 00 00 00       	call   1240 <close>
  return r;
    119c:	83 c4 10             	add    $0x10,%esp
}
    119f:	89 f0                	mov    %esi,%eax
    11a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11a4:	5b                   	pop    %ebx
    11a5:	5e                   	pop    %esi
    11a6:	5d                   	pop    %ebp
    11a7:	c3                   	ret    
    return -1;
    11a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11ad:	eb f0                	jmp    119f <stat+0x34>

000011af <atoi>:

int
atoi(const char *s)
{
    11af:	55                   	push   %ebp
    11b0:	89 e5                	mov    %esp,%ebp
    11b2:	53                   	push   %ebx
    11b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11b6:	0f b6 11             	movzbl (%ecx),%edx
    11b9:	8d 42 d0             	lea    -0x30(%edx),%eax
    11bc:	3c 09                	cmp    $0x9,%al
    11be:	77 20                	ja     11e0 <atoi+0x31>
  n = 0;
    11c0:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    11c5:	83 c1 01             	add    $0x1,%ecx
    11c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
    11cb:	0f be d2             	movsbl %dl,%edx
    11ce:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    11d2:	0f b6 11             	movzbl (%ecx),%edx
    11d5:	8d 5a d0             	lea    -0x30(%edx),%ebx
    11d8:	80 fb 09             	cmp    $0x9,%bl
    11db:	76 e8                	jbe    11c5 <atoi+0x16>
  return n;
}
    11dd:	5b                   	pop    %ebx
    11de:	5d                   	pop    %ebp
    11df:	c3                   	ret    
  n = 0;
    11e0:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11e5:	eb f6                	jmp    11dd <atoi+0x2e>

000011e7 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11e7:	55                   	push   %ebp
    11e8:	89 e5                	mov    %esp,%ebp
    11ea:	56                   	push   %esi
    11eb:	53                   	push   %ebx
    11ec:	8b 45 08             	mov    0x8(%ebp),%eax
    11ef:	8b 75 0c             	mov    0xc(%ebp),%esi
    11f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11f5:	85 db                	test   %ebx,%ebx
    11f7:	7e 13                	jle    120c <memmove+0x25>
    11f9:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    11fe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1202:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1205:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1208:	39 d3                	cmp    %edx,%ebx
    120a:	75 f2                	jne    11fe <memmove+0x17>
  return vdst;
}
    120c:	5b                   	pop    %ebx
    120d:	5e                   	pop    %esi
    120e:	5d                   	pop    %ebp
    120f:	c3                   	ret    

00001210 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1210:	b8 01 00 00 00       	mov    $0x1,%eax
    1215:	cd 40                	int    $0x40
    1217:	c3                   	ret    

00001218 <exit>:
SYSCALL(exit)
    1218:	b8 02 00 00 00       	mov    $0x2,%eax
    121d:	cd 40                	int    $0x40
    121f:	c3                   	ret    

00001220 <wait>:
SYSCALL(wait)
    1220:	b8 03 00 00 00       	mov    $0x3,%eax
    1225:	cd 40                	int    $0x40
    1227:	c3                   	ret    

00001228 <pipe>:
SYSCALL(pipe)
    1228:	b8 04 00 00 00       	mov    $0x4,%eax
    122d:	cd 40                	int    $0x40
    122f:	c3                   	ret    

00001230 <read>:
SYSCALL(read)
    1230:	b8 05 00 00 00       	mov    $0x5,%eax
    1235:	cd 40                	int    $0x40
    1237:	c3                   	ret    

00001238 <write>:
SYSCALL(write)
    1238:	b8 10 00 00 00       	mov    $0x10,%eax
    123d:	cd 40                	int    $0x40
    123f:	c3                   	ret    

00001240 <close>:
SYSCALL(close)
    1240:	b8 15 00 00 00       	mov    $0x15,%eax
    1245:	cd 40                	int    $0x40
    1247:	c3                   	ret    

00001248 <kill>:
SYSCALL(kill)
    1248:	b8 06 00 00 00       	mov    $0x6,%eax
    124d:	cd 40                	int    $0x40
    124f:	c3                   	ret    

00001250 <exec>:
SYSCALL(exec)
    1250:	b8 07 00 00 00       	mov    $0x7,%eax
    1255:	cd 40                	int    $0x40
    1257:	c3                   	ret    

00001258 <open>:
SYSCALL(open)
    1258:	b8 0f 00 00 00       	mov    $0xf,%eax
    125d:	cd 40                	int    $0x40
    125f:	c3                   	ret    

00001260 <mknod>:
SYSCALL(mknod)
    1260:	b8 11 00 00 00       	mov    $0x11,%eax
    1265:	cd 40                	int    $0x40
    1267:	c3                   	ret    

00001268 <unlink>:
SYSCALL(unlink)
    1268:	b8 12 00 00 00       	mov    $0x12,%eax
    126d:	cd 40                	int    $0x40
    126f:	c3                   	ret    

00001270 <fstat>:
SYSCALL(fstat)
    1270:	b8 08 00 00 00       	mov    $0x8,%eax
    1275:	cd 40                	int    $0x40
    1277:	c3                   	ret    

00001278 <link>:
SYSCALL(link)
    1278:	b8 13 00 00 00       	mov    $0x13,%eax
    127d:	cd 40                	int    $0x40
    127f:	c3                   	ret    

00001280 <mkdir>:
SYSCALL(mkdir)
    1280:	b8 14 00 00 00       	mov    $0x14,%eax
    1285:	cd 40                	int    $0x40
    1287:	c3                   	ret    

00001288 <chdir>:
SYSCALL(chdir)
    1288:	b8 09 00 00 00       	mov    $0x9,%eax
    128d:	cd 40                	int    $0x40
    128f:	c3                   	ret    

00001290 <dup>:
SYSCALL(dup)
    1290:	b8 0a 00 00 00       	mov    $0xa,%eax
    1295:	cd 40                	int    $0x40
    1297:	c3                   	ret    

00001298 <getpid>:
SYSCALL(getpid)
    1298:	b8 0b 00 00 00       	mov    $0xb,%eax
    129d:	cd 40                	int    $0x40
    129f:	c3                   	ret    

000012a0 <sbrk>:
SYSCALL(sbrk)
    12a0:	b8 0c 00 00 00       	mov    $0xc,%eax
    12a5:	cd 40                	int    $0x40
    12a7:	c3                   	ret    

000012a8 <sleep>:
SYSCALL(sleep)
    12a8:	b8 0d 00 00 00       	mov    $0xd,%eax
    12ad:	cd 40                	int    $0x40
    12af:	c3                   	ret    

000012b0 <uptime>:
SYSCALL(uptime)
    12b0:	b8 0e 00 00 00       	mov    $0xe,%eax
    12b5:	cd 40                	int    $0x40
    12b7:	c3                   	ret    

000012b8 <shmem_access>:
SYSCALL(shmem_access)
    12b8:	b8 16 00 00 00       	mov    $0x16,%eax
    12bd:	cd 40                	int    $0x40
    12bf:	c3                   	ret    

000012c0 <shmem_count>:
    12c0:	b8 17 00 00 00       	mov    $0x17,%eax
    12c5:	cd 40                	int    $0x40
    12c7:	c3                   	ret    

000012c8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12c8:	55                   	push   %ebp
    12c9:	89 e5                	mov    %esp,%ebp
    12cb:	57                   	push   %edi
    12cc:	56                   	push   %esi
    12cd:	53                   	push   %ebx
    12ce:	83 ec 3c             	sub    $0x3c,%esp
    12d1:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    12d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12d7:	74 14                	je     12ed <printint+0x25>
    12d9:	85 d2                	test   %edx,%edx
    12db:	79 10                	jns    12ed <printint+0x25>
    neg = 1;
    x = -xx;
    12dd:	f7 da                	neg    %edx
    neg = 1;
    12df:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12e6:	bf 00 00 00 00       	mov    $0x0,%edi
    12eb:	eb 0b                	jmp    12f8 <printint+0x30>
  neg = 0;
    12ed:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12f4:	eb f0                	jmp    12e6 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    12f6:	89 df                	mov    %ebx,%edi
    12f8:	8d 5f 01             	lea    0x1(%edi),%ebx
    12fb:	89 d0                	mov    %edx,%eax
    12fd:	ba 00 00 00 00       	mov    $0x0,%edx
    1302:	f7 f1                	div    %ecx
    1304:	0f b6 92 84 16 00 00 	movzbl 0x1684(%edx),%edx
    130b:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    130f:	89 c2                	mov    %eax,%edx
    1311:	85 c0                	test   %eax,%eax
    1313:	75 e1                	jne    12f6 <printint+0x2e>
  if(neg)
    1315:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    1319:	74 08                	je     1323 <printint+0x5b>
    buf[i++] = '-';
    131b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1320:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1323:	83 eb 01             	sub    $0x1,%ebx
    1326:	78 22                	js     134a <printint+0x82>
  write(fd, &c, 1);
    1328:	8d 7d d7             	lea    -0x29(%ebp),%edi
    132b:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1330:	88 45 d7             	mov    %al,-0x29(%ebp)
    1333:	83 ec 04             	sub    $0x4,%esp
    1336:	6a 01                	push   $0x1
    1338:	57                   	push   %edi
    1339:	56                   	push   %esi
    133a:	e8 f9 fe ff ff       	call   1238 <write>
  while(--i >= 0)
    133f:	83 eb 01             	sub    $0x1,%ebx
    1342:	83 c4 10             	add    $0x10,%esp
    1345:	83 fb ff             	cmp    $0xffffffff,%ebx
    1348:	75 e1                	jne    132b <printint+0x63>
    putc(fd, buf[i]);
}
    134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    134d:	5b                   	pop    %ebx
    134e:	5e                   	pop    %esi
    134f:	5f                   	pop    %edi
    1350:	5d                   	pop    %ebp
    1351:	c3                   	ret    

00001352 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1352:	55                   	push   %ebp
    1353:	89 e5                	mov    %esp,%ebp
    1355:	57                   	push   %edi
    1356:	56                   	push   %esi
    1357:	53                   	push   %ebx
    1358:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    135b:	8b 75 0c             	mov    0xc(%ebp),%esi
    135e:	0f b6 1e             	movzbl (%esi),%ebx
    1361:	84 db                	test   %bl,%bl
    1363:	0f 84 b1 01 00 00    	je     151a <printf+0x1c8>
    1369:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    136c:	8d 45 10             	lea    0x10(%ebp),%eax
    136f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1372:	bf 00 00 00 00       	mov    $0x0,%edi
    1377:	eb 2d                	jmp    13a6 <printf+0x54>
    1379:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    137c:	83 ec 04             	sub    $0x4,%esp
    137f:	6a 01                	push   $0x1
    1381:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1384:	50                   	push   %eax
    1385:	ff 75 08             	pushl  0x8(%ebp)
    1388:	e8 ab fe ff ff       	call   1238 <write>
    138d:	83 c4 10             	add    $0x10,%esp
    1390:	eb 05                	jmp    1397 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1392:	83 ff 25             	cmp    $0x25,%edi
    1395:	74 22                	je     13b9 <printf+0x67>
    1397:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    139a:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    139e:	84 db                	test   %bl,%bl
    13a0:	0f 84 74 01 00 00    	je     151a <printf+0x1c8>
    c = fmt[i] & 0xff;
    13a6:	0f be d3             	movsbl %bl,%edx
    13a9:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    13ac:	85 ff                	test   %edi,%edi
    13ae:	75 e2                	jne    1392 <printf+0x40>
      if(c == '%'){
    13b0:	83 f8 25             	cmp    $0x25,%eax
    13b3:	75 c4                	jne    1379 <printf+0x27>
        state = '%';
    13b5:	89 c7                	mov    %eax,%edi
    13b7:	eb de                	jmp    1397 <printf+0x45>
      if(c == 'd'){
    13b9:	83 f8 64             	cmp    $0x64,%eax
    13bc:	74 59                	je     1417 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13be:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    13c4:	83 fa 70             	cmp    $0x70,%edx
    13c7:	74 7a                	je     1443 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13c9:	83 f8 73             	cmp    $0x73,%eax
    13cc:	0f 84 9d 00 00 00    	je     146f <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13d2:	83 f8 63             	cmp    $0x63,%eax
    13d5:	0f 84 f2 00 00 00    	je     14cd <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13db:	83 f8 25             	cmp    $0x25,%eax
    13de:	0f 84 15 01 00 00    	je     14f9 <printf+0x1a7>
    13e4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    13e8:	83 ec 04             	sub    $0x4,%esp
    13eb:	6a 01                	push   $0x1
    13ed:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13f0:	50                   	push   %eax
    13f1:	ff 75 08             	pushl  0x8(%ebp)
    13f4:	e8 3f fe ff ff       	call   1238 <write>
    13f9:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    13fc:	83 c4 0c             	add    $0xc,%esp
    13ff:	6a 01                	push   $0x1
    1401:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1404:	50                   	push   %eax
    1405:	ff 75 08             	pushl  0x8(%ebp)
    1408:	e8 2b fe ff ff       	call   1238 <write>
    140d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1410:	bf 00 00 00 00       	mov    $0x0,%edi
    1415:	eb 80                	jmp    1397 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1417:	83 ec 0c             	sub    $0xc,%esp
    141a:	6a 01                	push   $0x1
    141c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1421:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1424:	8b 17                	mov    (%edi),%edx
    1426:	8b 45 08             	mov    0x8(%ebp),%eax
    1429:	e8 9a fe ff ff       	call   12c8 <printint>
        ap++;
    142e:	89 f8                	mov    %edi,%eax
    1430:	83 c0 04             	add    $0x4,%eax
    1433:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1436:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1439:	bf 00 00 00 00       	mov    $0x0,%edi
    143e:	e9 54 ff ff ff       	jmp    1397 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1443:	83 ec 0c             	sub    $0xc,%esp
    1446:	6a 00                	push   $0x0
    1448:	b9 10 00 00 00       	mov    $0x10,%ecx
    144d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1450:	8b 17                	mov    (%edi),%edx
    1452:	8b 45 08             	mov    0x8(%ebp),%eax
    1455:	e8 6e fe ff ff       	call   12c8 <printint>
        ap++;
    145a:	89 f8                	mov    %edi,%eax
    145c:	83 c0 04             	add    $0x4,%eax
    145f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1462:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1465:	bf 00 00 00 00       	mov    $0x0,%edi
    146a:	e9 28 ff ff ff       	jmp    1397 <printf+0x45>
        s = (char*)*ap;
    146f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1472:	8b 01                	mov    (%ecx),%eax
        ap++;
    1474:	83 c1 04             	add    $0x4,%ecx
    1477:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    147a:	85 c0                	test   %eax,%eax
    147c:	74 13                	je     1491 <printf+0x13f>
        s = (char*)*ap;
    147e:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1480:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1483:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    1488:	84 c0                	test   %al,%al
    148a:	75 0f                	jne    149b <printf+0x149>
    148c:	e9 06 ff ff ff       	jmp    1397 <printf+0x45>
          s = "(null)";
    1491:	bb 7c 16 00 00       	mov    $0x167c,%ebx
        while(*s != 0){
    1496:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    149b:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    149e:	89 75 d0             	mov    %esi,-0x30(%ebp)
    14a1:	8b 75 08             	mov    0x8(%ebp),%esi
    14a4:	88 45 e3             	mov    %al,-0x1d(%ebp)
    14a7:	83 ec 04             	sub    $0x4,%esp
    14aa:	6a 01                	push   $0x1
    14ac:	57                   	push   %edi
    14ad:	56                   	push   %esi
    14ae:	e8 85 fd ff ff       	call   1238 <write>
          s++;
    14b3:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    14b6:	0f b6 03             	movzbl (%ebx),%eax
    14b9:	83 c4 10             	add    $0x10,%esp
    14bc:	84 c0                	test   %al,%al
    14be:	75 e4                	jne    14a4 <printf+0x152>
    14c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    14c3:	bf 00 00 00 00       	mov    $0x0,%edi
    14c8:	e9 ca fe ff ff       	jmp    1397 <printf+0x45>
        putc(fd, *ap);
    14cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14d0:	8b 07                	mov    (%edi),%eax
    14d2:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14d5:	83 ec 04             	sub    $0x4,%esp
    14d8:	6a 01                	push   $0x1
    14da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14dd:	50                   	push   %eax
    14de:	ff 75 08             	pushl  0x8(%ebp)
    14e1:	e8 52 fd ff ff       	call   1238 <write>
        ap++;
    14e6:	83 c7 04             	add    $0x4,%edi
    14e9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14ef:	bf 00 00 00 00       	mov    $0x0,%edi
    14f4:	e9 9e fe ff ff       	jmp    1397 <printf+0x45>
    14f9:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    14fc:	83 ec 04             	sub    $0x4,%esp
    14ff:	6a 01                	push   $0x1
    1501:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1504:	50                   	push   %eax
    1505:	ff 75 08             	pushl  0x8(%ebp)
    1508:	e8 2b fd ff ff       	call   1238 <write>
    150d:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1510:	bf 00 00 00 00       	mov    $0x0,%edi
    1515:	e9 7d fe ff ff       	jmp    1397 <printf+0x45>
    }
  }
}
    151a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    151d:	5b                   	pop    %ebx
    151e:	5e                   	pop    %esi
    151f:	5f                   	pop    %edi
    1520:	5d                   	pop    %ebp
    1521:	c3                   	ret    

00001522 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1522:	55                   	push   %ebp
    1523:	89 e5                	mov    %esp,%ebp
    1525:	57                   	push   %edi
    1526:	56                   	push   %esi
    1527:	53                   	push   %ebx
    1528:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    152b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    152e:	a1 f4 18 00 00       	mov    0x18f4,%eax
    1533:	eb 0c                	jmp    1541 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1535:	8b 10                	mov    (%eax),%edx
    1537:	39 c2                	cmp    %eax,%edx
    1539:	77 04                	ja     153f <free+0x1d>
    153b:	39 ca                	cmp    %ecx,%edx
    153d:	77 10                	ja     154f <free+0x2d>
{
    153f:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1541:	39 c8                	cmp    %ecx,%eax
    1543:	73 f0                	jae    1535 <free+0x13>
    1545:	8b 10                	mov    (%eax),%edx
    1547:	39 ca                	cmp    %ecx,%edx
    1549:	77 04                	ja     154f <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    154b:	39 c2                	cmp    %eax,%edx
    154d:	77 f0                	ja     153f <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    154f:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1552:	8b 10                	mov    (%eax),%edx
    1554:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1557:	39 fa                	cmp    %edi,%edx
    1559:	74 19                	je     1574 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    155b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    155e:	8b 50 04             	mov    0x4(%eax),%edx
    1561:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1564:	39 f1                	cmp    %esi,%ecx
    1566:	74 1b                	je     1583 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1568:	89 08                	mov    %ecx,(%eax)
  freep = p;
    156a:	a3 f4 18 00 00       	mov    %eax,0x18f4
}
    156f:	5b                   	pop    %ebx
    1570:	5e                   	pop    %esi
    1571:	5f                   	pop    %edi
    1572:	5d                   	pop    %ebp
    1573:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1574:	03 72 04             	add    0x4(%edx),%esi
    1577:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    157a:	8b 10                	mov    (%eax),%edx
    157c:	8b 12                	mov    (%edx),%edx
    157e:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1581:	eb db                	jmp    155e <free+0x3c>
    p->s.size += bp->s.size;
    1583:	03 53 fc             	add    -0x4(%ebx),%edx
    1586:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1589:	8b 53 f8             	mov    -0x8(%ebx),%edx
    158c:	89 10                	mov    %edx,(%eax)
    158e:	eb da                	jmp    156a <free+0x48>

00001590 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1590:	55                   	push   %ebp
    1591:	89 e5                	mov    %esp,%ebp
    1593:	57                   	push   %edi
    1594:	56                   	push   %esi
    1595:	53                   	push   %ebx
    1596:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1599:	8b 45 08             	mov    0x8(%ebp),%eax
    159c:	8d 58 07             	lea    0x7(%eax),%ebx
    159f:	c1 eb 03             	shr    $0x3,%ebx
    15a2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15a5:	8b 15 f4 18 00 00    	mov    0x18f4,%edx
    15ab:	85 d2                	test   %edx,%edx
    15ad:	74 20                	je     15cf <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15af:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15b1:	8b 48 04             	mov    0x4(%eax),%ecx
    15b4:	39 cb                	cmp    %ecx,%ebx
    15b6:	76 3c                	jbe    15f4 <malloc+0x64>
    15b8:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    15be:	be 00 10 00 00       	mov    $0x1000,%esi
    15c3:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    15c6:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    15cd:	eb 70                	jmp    163f <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    15cf:	c7 05 f4 18 00 00 f8 	movl   $0x18f8,0x18f4
    15d6:	18 00 00 
    15d9:	c7 05 f8 18 00 00 f8 	movl   $0x18f8,0x18f8
    15e0:	18 00 00 
    base.s.size = 0;
    15e3:	c7 05 fc 18 00 00 00 	movl   $0x0,0x18fc
    15ea:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    15ed:	ba f8 18 00 00       	mov    $0x18f8,%edx
    15f2:	eb bb                	jmp    15af <malloc+0x1f>
      if(p->s.size == nunits)
    15f4:	39 cb                	cmp    %ecx,%ebx
    15f6:	74 1c                	je     1614 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    15f8:	29 d9                	sub    %ebx,%ecx
    15fa:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    15fd:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1600:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1603:	89 15 f4 18 00 00    	mov    %edx,0x18f4
      return (void*)(p + 1);
    1609:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    160c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    160f:	5b                   	pop    %ebx
    1610:	5e                   	pop    %esi
    1611:	5f                   	pop    %edi
    1612:	5d                   	pop    %ebp
    1613:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1614:	8b 08                	mov    (%eax),%ecx
    1616:	89 0a                	mov    %ecx,(%edx)
    1618:	eb e9                	jmp    1603 <malloc+0x73>
  hp->s.size = nu;
    161a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    161d:	83 ec 0c             	sub    $0xc,%esp
    1620:	83 c0 08             	add    $0x8,%eax
    1623:	50                   	push   %eax
    1624:	e8 f9 fe ff ff       	call   1522 <free>
  return freep;
    1629:	8b 15 f4 18 00 00    	mov    0x18f4,%edx
      if((p = morecore(nunits)) == 0)
    162f:	83 c4 10             	add    $0x10,%esp
    1632:	85 d2                	test   %edx,%edx
    1634:	74 2b                	je     1661 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1636:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1638:	8b 48 04             	mov    0x4(%eax),%ecx
    163b:	39 d9                	cmp    %ebx,%ecx
    163d:	73 b5                	jae    15f4 <malloc+0x64>
    163f:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1641:	39 05 f4 18 00 00    	cmp    %eax,0x18f4
    1647:	75 ed                	jne    1636 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1649:	83 ec 0c             	sub    $0xc,%esp
    164c:	57                   	push   %edi
    164d:	e8 4e fc ff ff       	call   12a0 <sbrk>
  if(p == (char*)-1)
    1652:	83 c4 10             	add    $0x10,%esp
    1655:	83 f8 ff             	cmp    $0xffffffff,%eax
    1658:	75 c0                	jne    161a <malloc+0x8a>
        return 0;
    165a:	b8 00 00 00 00       	mov    $0x0,%eax
    165f:	eb ab                	jmp    160c <malloc+0x7c>
    1661:	b8 00 00 00 00       	mov    $0x0,%eax
    1666:	eb a4                	jmp    160c <malloc+0x7c>
