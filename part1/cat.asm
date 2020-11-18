
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	56                   	push   %esi
    1004:	53                   	push   %ebx
    1005:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1008:	83 ec 04             	sub    $0x4,%esp
    100b:	68 00 02 00 00       	push   $0x200
    1010:	68 20 1a 00 00       	push   $0x1a20
    1015:	56                   	push   %esi
    1016:	e8 b8 02 00 00       	call   12d3 <read>
    101b:	89 c3                	mov    %eax,%ebx
    101d:	83 c4 10             	add    $0x10,%esp
    1020:	85 c0                	test   %eax,%eax
    1022:	7e 2b                	jle    104f <cat+0x4f>
    if (write(1, buf, n) != n) {
    1024:	83 ec 04             	sub    $0x4,%esp
    1027:	53                   	push   %ebx
    1028:	68 20 1a 00 00       	push   $0x1a20
    102d:	6a 01                	push   $0x1
    102f:	e8 a7 02 00 00       	call   12db <write>
    1034:	83 c4 10             	add    $0x10,%esp
    1037:	39 d8                	cmp    %ebx,%eax
    1039:	74 cd                	je     1008 <cat+0x8>
      printf(1, "cat: write error\n");
    103b:	83 ec 08             	sub    $0x8,%esp
    103e:	68 0c 17 00 00       	push   $0x170c
    1043:	6a 01                	push   $0x1
    1045:	e8 ab 03 00 00       	call   13f5 <printf>
      exit();
    104a:	e8 6c 02 00 00       	call   12bb <exit>
    }
  }
  if(n < 0){
    104f:	85 c0                	test   %eax,%eax
    1051:	78 07                	js     105a <cat+0x5a>
    printf(1, "cat: read error\n");
    exit();
  }
}
    1053:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1056:	5b                   	pop    %ebx
    1057:	5e                   	pop    %esi
    1058:	5d                   	pop    %ebp
    1059:	c3                   	ret    
    printf(1, "cat: read error\n");
    105a:	83 ec 08             	sub    $0x8,%esp
    105d:	68 1e 17 00 00       	push   $0x171e
    1062:	6a 01                	push   $0x1
    1064:	e8 8c 03 00 00       	call   13f5 <printf>
    exit();
    1069:	e8 4d 02 00 00       	call   12bb <exit>

0000106e <main>:

int
main(int argc, char *argv[])
{
    106e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1072:	83 e4 f0             	and    $0xfffffff0,%esp
    1075:	ff 71 fc             	pushl  -0x4(%ecx)
    1078:	55                   	push   %ebp
    1079:	89 e5                	mov    %esp,%ebp
    107b:	57                   	push   %edi
    107c:	56                   	push   %esi
    107d:	53                   	push   %ebx
    107e:	51                   	push   %ecx
    107f:	83 ec 18             	sub    $0x18,%esp
    1082:	8b 01                	mov    (%ecx),%eax
    1084:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1087:	8b 59 04             	mov    0x4(%ecx),%ebx
    108a:	83 c3 04             	add    $0x4,%ebx
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    108d:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
    1092:	83 f8 01             	cmp    $0x1,%eax
    1095:	7e 3c                	jle    10d3 <main+0x65>
    if((fd = open(argv[i], 0)) < 0){
    1097:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    109a:	83 ec 08             	sub    $0x8,%esp
    109d:	6a 00                	push   $0x0
    109f:	ff 33                	pushl  (%ebx)
    10a1:	e8 55 02 00 00       	call   12fb <open>
    10a6:	89 c6                	mov    %eax,%esi
    10a8:	83 c4 10             	add    $0x10,%esp
    10ab:	85 c0                	test   %eax,%eax
    10ad:	78 33                	js     10e2 <main+0x74>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
    10af:	83 ec 0c             	sub    $0xc,%esp
    10b2:	50                   	push   %eax
    10b3:	e8 48 ff ff ff       	call   1000 <cat>
    close(fd);
    10b8:	89 34 24             	mov    %esi,(%esp)
    10bb:	e8 23 02 00 00       	call   12e3 <close>
  for(i = 1; i < argc; i++){
    10c0:	83 c7 01             	add    $0x1,%edi
    10c3:	83 c3 04             	add    $0x4,%ebx
    10c6:	83 c4 10             	add    $0x10,%esp
    10c9:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
    10cc:	75 c9                	jne    1097 <main+0x29>
  }
  exit();
    10ce:	e8 e8 01 00 00       	call   12bb <exit>
    cat(0);
    10d3:	83 ec 0c             	sub    $0xc,%esp
    10d6:	6a 00                	push   $0x0
    10d8:	e8 23 ff ff ff       	call   1000 <cat>
    exit();
    10dd:	e8 d9 01 00 00       	call   12bb <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10e2:	83 ec 04             	sub    $0x4,%esp
    10e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
    10e8:	ff 30                	pushl  (%eax)
    10ea:	68 2f 17 00 00       	push   $0x172f
    10ef:	6a 01                	push   $0x1
    10f1:	e8 ff 02 00 00       	call   13f5 <printf>
      exit();
    10f6:	e8 c0 01 00 00       	call   12bb <exit>

000010fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	53                   	push   %ebx
    10ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1105:	89 c2                	mov    %eax,%edx
    1107:	83 c1 01             	add    $0x1,%ecx
    110a:	83 c2 01             	add    $0x1,%edx
    110d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1111:	88 5a ff             	mov    %bl,-0x1(%edx)
    1114:	84 db                	test   %bl,%bl
    1116:	75 ef                	jne    1107 <strcpy+0xc>
    ;
  return os;
}
    1118:	5b                   	pop    %ebx
    1119:	5d                   	pop    %ebp
    111a:	c3                   	ret    

0000111b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    111b:	55                   	push   %ebp
    111c:	89 e5                	mov    %esp,%ebp
    111e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1121:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1124:	0f b6 01             	movzbl (%ecx),%eax
    1127:	84 c0                	test   %al,%al
    1129:	74 15                	je     1140 <strcmp+0x25>
    112b:	3a 02                	cmp    (%edx),%al
    112d:	75 11                	jne    1140 <strcmp+0x25>
    p++, q++;
    112f:	83 c1 01             	add    $0x1,%ecx
    1132:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1135:	0f b6 01             	movzbl (%ecx),%eax
    1138:	84 c0                	test   %al,%al
    113a:	74 04                	je     1140 <strcmp+0x25>
    113c:	3a 02                	cmp    (%edx),%al
    113e:	74 ef                	je     112f <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1140:	0f b6 c0             	movzbl %al,%eax
    1143:	0f b6 12             	movzbl (%edx),%edx
    1146:	29 d0                	sub    %edx,%eax
}
    1148:	5d                   	pop    %ebp
    1149:	c3                   	ret    

0000114a <strlen>:

uint
strlen(const char *s)
{
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1150:	80 39 00             	cmpb   $0x0,(%ecx)
    1153:	74 12                	je     1167 <strlen+0x1d>
    1155:	ba 00 00 00 00       	mov    $0x0,%edx
    115a:	83 c2 01             	add    $0x1,%edx
    115d:	89 d0                	mov    %edx,%eax
    115f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1163:	75 f5                	jne    115a <strlen+0x10>
    ;
  return n;
}
    1165:	5d                   	pop    %ebp
    1166:	c3                   	ret    
  for(n = 0; s[n]; n++)
    1167:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    116c:	eb f7                	jmp    1165 <strlen+0x1b>

0000116e <memset>:

void*
memset(void *dst, int c, uint n)
{
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	57                   	push   %edi
    1172:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1175:	89 d7                	mov    %edx,%edi
    1177:	8b 4d 10             	mov    0x10(%ebp),%ecx
    117a:	8b 45 0c             	mov    0xc(%ebp),%eax
    117d:	fc                   	cld    
    117e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1180:	89 d0                	mov    %edx,%eax
    1182:	5f                   	pop    %edi
    1183:	5d                   	pop    %ebp
    1184:	c3                   	ret    

00001185 <strchr>:

char*
strchr(const char *s, char c)
{
    1185:	55                   	push   %ebp
    1186:	89 e5                	mov    %esp,%ebp
    1188:	53                   	push   %ebx
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    118f:	0f b6 10             	movzbl (%eax),%edx
    1192:	84 d2                	test   %dl,%dl
    1194:	74 1e                	je     11b4 <strchr+0x2f>
    1196:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1198:	38 d3                	cmp    %dl,%bl
    119a:	74 15                	je     11b1 <strchr+0x2c>
  for(; *s; s++)
    119c:	83 c0 01             	add    $0x1,%eax
    119f:	0f b6 10             	movzbl (%eax),%edx
    11a2:	84 d2                	test   %dl,%dl
    11a4:	74 06                	je     11ac <strchr+0x27>
    if(*s == c)
    11a6:	38 ca                	cmp    %cl,%dl
    11a8:	75 f2                	jne    119c <strchr+0x17>
    11aa:	eb 05                	jmp    11b1 <strchr+0x2c>
      return (char*)s;
  return 0;
    11ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11b1:	5b                   	pop    %ebx
    11b2:	5d                   	pop    %ebp
    11b3:	c3                   	ret    
  return 0;
    11b4:	b8 00 00 00 00       	mov    $0x0,%eax
    11b9:	eb f6                	jmp    11b1 <strchr+0x2c>

000011bb <gets>:

char*
gets(char *buf, int max)
{
    11bb:	55                   	push   %ebp
    11bc:	89 e5                	mov    %esp,%ebp
    11be:	57                   	push   %edi
    11bf:	56                   	push   %esi
    11c0:	53                   	push   %ebx
    11c1:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11c4:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    11c9:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    11cc:	8d 5e 01             	lea    0x1(%esi),%ebx
    11cf:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11d2:	7d 2b                	jge    11ff <gets+0x44>
    cc = read(0, &c, 1);
    11d4:	83 ec 04             	sub    $0x4,%esp
    11d7:	6a 01                	push   $0x1
    11d9:	57                   	push   %edi
    11da:	6a 00                	push   $0x0
    11dc:	e8 f2 00 00 00       	call   12d3 <read>
    if(cc < 1)
    11e1:	83 c4 10             	add    $0x10,%esp
    11e4:	85 c0                	test   %eax,%eax
    11e6:	7e 17                	jle    11ff <gets+0x44>
      break;
    buf[i++] = c;
    11e8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    11ec:	8b 55 08             	mov    0x8(%ebp),%edx
    11ef:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    11f3:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    11f5:	3c 0a                	cmp    $0xa,%al
    11f7:	74 04                	je     11fd <gets+0x42>
    11f9:	3c 0d                	cmp    $0xd,%al
    11fb:	75 cf                	jne    11cc <gets+0x11>
  for(i=0; i+1 < max; ){
    11fd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    11ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1202:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1206:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1209:	5b                   	pop    %ebx
    120a:	5e                   	pop    %esi
    120b:	5f                   	pop    %edi
    120c:	5d                   	pop    %ebp
    120d:	c3                   	ret    

0000120e <stat>:

int
stat(const char *n, struct stat *st)
{
    120e:	55                   	push   %ebp
    120f:	89 e5                	mov    %esp,%ebp
    1211:	56                   	push   %esi
    1212:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1213:	83 ec 08             	sub    $0x8,%esp
    1216:	6a 00                	push   $0x0
    1218:	ff 75 08             	pushl  0x8(%ebp)
    121b:	e8 db 00 00 00       	call   12fb <open>
  if(fd < 0)
    1220:	83 c4 10             	add    $0x10,%esp
    1223:	85 c0                	test   %eax,%eax
    1225:	78 24                	js     124b <stat+0x3d>
    1227:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1229:	83 ec 08             	sub    $0x8,%esp
    122c:	ff 75 0c             	pushl  0xc(%ebp)
    122f:	50                   	push   %eax
    1230:	e8 de 00 00 00       	call   1313 <fstat>
    1235:	89 c6                	mov    %eax,%esi
  close(fd);
    1237:	89 1c 24             	mov    %ebx,(%esp)
    123a:	e8 a4 00 00 00       	call   12e3 <close>
  return r;
    123f:	83 c4 10             	add    $0x10,%esp
}
    1242:	89 f0                	mov    %esi,%eax
    1244:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1247:	5b                   	pop    %ebx
    1248:	5e                   	pop    %esi
    1249:	5d                   	pop    %ebp
    124a:	c3                   	ret    
    return -1;
    124b:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1250:	eb f0                	jmp    1242 <stat+0x34>

00001252 <atoi>:

int
atoi(const char *s)
{
    1252:	55                   	push   %ebp
    1253:	89 e5                	mov    %esp,%ebp
    1255:	53                   	push   %ebx
    1256:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1259:	0f b6 11             	movzbl (%ecx),%edx
    125c:	8d 42 d0             	lea    -0x30(%edx),%eax
    125f:	3c 09                	cmp    $0x9,%al
    1261:	77 20                	ja     1283 <atoi+0x31>
  n = 0;
    1263:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    1268:	83 c1 01             	add    $0x1,%ecx
    126b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    126e:	0f be d2             	movsbl %dl,%edx
    1271:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1275:	0f b6 11             	movzbl (%ecx),%edx
    1278:	8d 5a d0             	lea    -0x30(%edx),%ebx
    127b:	80 fb 09             	cmp    $0x9,%bl
    127e:	76 e8                	jbe    1268 <atoi+0x16>
  return n;
}
    1280:	5b                   	pop    %ebx
    1281:	5d                   	pop    %ebp
    1282:	c3                   	ret    
  n = 0;
    1283:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1288:	eb f6                	jmp    1280 <atoi+0x2e>

0000128a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    128a:	55                   	push   %ebp
    128b:	89 e5                	mov    %esp,%ebp
    128d:	56                   	push   %esi
    128e:	53                   	push   %ebx
    128f:	8b 45 08             	mov    0x8(%ebp),%eax
    1292:	8b 75 0c             	mov    0xc(%ebp),%esi
    1295:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1298:	85 db                	test   %ebx,%ebx
    129a:	7e 13                	jle    12af <memmove+0x25>
    129c:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    12a1:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    12a5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    12a8:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    12ab:	39 d3                	cmp    %edx,%ebx
    12ad:	75 f2                	jne    12a1 <memmove+0x17>
  return vdst;
}
    12af:	5b                   	pop    %ebx
    12b0:	5e                   	pop    %esi
    12b1:	5d                   	pop    %ebp
    12b2:	c3                   	ret    

000012b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12b3:	b8 01 00 00 00       	mov    $0x1,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <exit>:
SYSCALL(exit)
    12bb:	b8 02 00 00 00       	mov    $0x2,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <wait>:
SYSCALL(wait)
    12c3:	b8 03 00 00 00       	mov    $0x3,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <pipe>:
SYSCALL(pipe)
    12cb:	b8 04 00 00 00       	mov    $0x4,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <read>:
SYSCALL(read)
    12d3:	b8 05 00 00 00       	mov    $0x5,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <write>:
SYSCALL(write)
    12db:	b8 10 00 00 00       	mov    $0x10,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <close>:
SYSCALL(close)
    12e3:	b8 15 00 00 00       	mov    $0x15,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <kill>:
SYSCALL(kill)
    12eb:	b8 06 00 00 00       	mov    $0x6,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <exec>:
SYSCALL(exec)
    12f3:	b8 07 00 00 00       	mov    $0x7,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <open>:
SYSCALL(open)
    12fb:	b8 0f 00 00 00       	mov    $0xf,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <mknod>:
SYSCALL(mknod)
    1303:	b8 11 00 00 00       	mov    $0x11,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <unlink>:
SYSCALL(unlink)
    130b:	b8 12 00 00 00       	mov    $0x12,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <fstat>:
SYSCALL(fstat)
    1313:	b8 08 00 00 00       	mov    $0x8,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <link>:
SYSCALL(link)
    131b:	b8 13 00 00 00       	mov    $0x13,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <mkdir>:
SYSCALL(mkdir)
    1323:	b8 14 00 00 00       	mov    $0x14,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <chdir>:
SYSCALL(chdir)
    132b:	b8 09 00 00 00       	mov    $0x9,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <dup>:
SYSCALL(dup)
    1333:	b8 0a 00 00 00       	mov    $0xa,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <getpid>:
SYSCALL(getpid)
    133b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret    

00001343 <sbrk>:
SYSCALL(sbrk)
    1343:	b8 0c 00 00 00       	mov    $0xc,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret    

0000134b <sleep>:
SYSCALL(sleep)
    134b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret    

00001353 <uptime>:
SYSCALL(uptime)
    1353:	b8 0e 00 00 00       	mov    $0xe,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret    

0000135b <shmem_access>:
SYSCALL(shmem_access)
    135b:	b8 16 00 00 00       	mov    $0x16,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret    

00001363 <shmem_count>:
    1363:	b8 17 00 00 00       	mov    $0x17,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret    

0000136b <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    136b:	55                   	push   %ebp
    136c:	89 e5                	mov    %esp,%ebp
    136e:	57                   	push   %edi
    136f:	56                   	push   %esi
    1370:	53                   	push   %ebx
    1371:	83 ec 3c             	sub    $0x3c,%esp
    1374:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    137a:	74 14                	je     1390 <printint+0x25>
    137c:	85 d2                	test   %edx,%edx
    137e:	79 10                	jns    1390 <printint+0x25>
    neg = 1;
    x = -xx;
    1380:	f7 da                	neg    %edx
    neg = 1;
    1382:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1389:	bf 00 00 00 00       	mov    $0x0,%edi
    138e:	eb 0b                	jmp    139b <printint+0x30>
  neg = 0;
    1390:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1397:	eb f0                	jmp    1389 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1399:	89 df                	mov    %ebx,%edi
    139b:	8d 5f 01             	lea    0x1(%edi),%ebx
    139e:	89 d0                	mov    %edx,%eax
    13a0:	ba 00 00 00 00       	mov    $0x0,%edx
    13a5:	f7 f1                	div    %ecx
    13a7:	0f b6 92 4c 17 00 00 	movzbl 0x174c(%edx),%edx
    13ae:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    13b2:	89 c2                	mov    %eax,%edx
    13b4:	85 c0                	test   %eax,%eax
    13b6:	75 e1                	jne    1399 <printint+0x2e>
  if(neg)
    13b8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    13bc:	74 08                	je     13c6 <printint+0x5b>
    buf[i++] = '-';
    13be:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    13c3:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    13c6:	83 eb 01             	sub    $0x1,%ebx
    13c9:	78 22                	js     13ed <printint+0x82>
  write(fd, &c, 1);
    13cb:	8d 7d d7             	lea    -0x29(%ebp),%edi
    13ce:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    13d3:	88 45 d7             	mov    %al,-0x29(%ebp)
    13d6:	83 ec 04             	sub    $0x4,%esp
    13d9:	6a 01                	push   $0x1
    13db:	57                   	push   %edi
    13dc:	56                   	push   %esi
    13dd:	e8 f9 fe ff ff       	call   12db <write>
  while(--i >= 0)
    13e2:	83 eb 01             	sub    $0x1,%ebx
    13e5:	83 c4 10             	add    $0x10,%esp
    13e8:	83 fb ff             	cmp    $0xffffffff,%ebx
    13eb:	75 e1                	jne    13ce <printint+0x63>
    putc(fd, buf[i]);
}
    13ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13f0:	5b                   	pop    %ebx
    13f1:	5e                   	pop    %esi
    13f2:	5f                   	pop    %edi
    13f3:	5d                   	pop    %ebp
    13f4:	c3                   	ret    

000013f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    13f5:	55                   	push   %ebp
    13f6:	89 e5                	mov    %esp,%ebp
    13f8:	57                   	push   %edi
    13f9:	56                   	push   %esi
    13fa:	53                   	push   %ebx
    13fb:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13fe:	8b 75 0c             	mov    0xc(%ebp),%esi
    1401:	0f b6 1e             	movzbl (%esi),%ebx
    1404:	84 db                	test   %bl,%bl
    1406:	0f 84 b1 01 00 00    	je     15bd <printf+0x1c8>
    140c:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    140f:	8d 45 10             	lea    0x10(%ebp),%eax
    1412:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1415:	bf 00 00 00 00       	mov    $0x0,%edi
    141a:	eb 2d                	jmp    1449 <printf+0x54>
    141c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    141f:	83 ec 04             	sub    $0x4,%esp
    1422:	6a 01                	push   $0x1
    1424:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1427:	50                   	push   %eax
    1428:	ff 75 08             	pushl  0x8(%ebp)
    142b:	e8 ab fe ff ff       	call   12db <write>
    1430:	83 c4 10             	add    $0x10,%esp
    1433:	eb 05                	jmp    143a <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1435:	83 ff 25             	cmp    $0x25,%edi
    1438:	74 22                	je     145c <printf+0x67>
    143a:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    143d:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1441:	84 db                	test   %bl,%bl
    1443:	0f 84 74 01 00 00    	je     15bd <printf+0x1c8>
    c = fmt[i] & 0xff;
    1449:	0f be d3             	movsbl %bl,%edx
    144c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    144f:	85 ff                	test   %edi,%edi
    1451:	75 e2                	jne    1435 <printf+0x40>
      if(c == '%'){
    1453:	83 f8 25             	cmp    $0x25,%eax
    1456:	75 c4                	jne    141c <printf+0x27>
        state = '%';
    1458:	89 c7                	mov    %eax,%edi
    145a:	eb de                	jmp    143a <printf+0x45>
      if(c == 'd'){
    145c:	83 f8 64             	cmp    $0x64,%eax
    145f:	74 59                	je     14ba <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1461:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    1467:	83 fa 70             	cmp    $0x70,%edx
    146a:	74 7a                	je     14e6 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    146c:	83 f8 73             	cmp    $0x73,%eax
    146f:	0f 84 9d 00 00 00    	je     1512 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1475:	83 f8 63             	cmp    $0x63,%eax
    1478:	0f 84 f2 00 00 00    	je     1570 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    147e:	83 f8 25             	cmp    $0x25,%eax
    1481:	0f 84 15 01 00 00    	je     159c <printf+0x1a7>
    1487:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    148b:	83 ec 04             	sub    $0x4,%esp
    148e:	6a 01                	push   $0x1
    1490:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1493:	50                   	push   %eax
    1494:	ff 75 08             	pushl  0x8(%ebp)
    1497:	e8 3f fe ff ff       	call   12db <write>
    149c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    149f:	83 c4 0c             	add    $0xc,%esp
    14a2:	6a 01                	push   $0x1
    14a4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    14a7:	50                   	push   %eax
    14a8:	ff 75 08             	pushl  0x8(%ebp)
    14ab:	e8 2b fe ff ff       	call   12db <write>
    14b0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    14b3:	bf 00 00 00 00       	mov    $0x0,%edi
    14b8:	eb 80                	jmp    143a <printf+0x45>
        printint(fd, *ap, 10, 1);
    14ba:	83 ec 0c             	sub    $0xc,%esp
    14bd:	6a 01                	push   $0x1
    14bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
    14c4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14c7:	8b 17                	mov    (%edi),%edx
    14c9:	8b 45 08             	mov    0x8(%ebp),%eax
    14cc:	e8 9a fe ff ff       	call   136b <printint>
        ap++;
    14d1:	89 f8                	mov    %edi,%eax
    14d3:	83 c0 04             	add    $0x4,%eax
    14d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    14d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14dc:	bf 00 00 00 00       	mov    $0x0,%edi
    14e1:	e9 54 ff ff ff       	jmp    143a <printf+0x45>
        printint(fd, *ap, 16, 0);
    14e6:	83 ec 0c             	sub    $0xc,%esp
    14e9:	6a 00                	push   $0x0
    14eb:	b9 10 00 00 00       	mov    $0x10,%ecx
    14f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14f3:	8b 17                	mov    (%edi),%edx
    14f5:	8b 45 08             	mov    0x8(%ebp),%eax
    14f8:	e8 6e fe ff ff       	call   136b <printint>
        ap++;
    14fd:	89 f8                	mov    %edi,%eax
    14ff:	83 c0 04             	add    $0x4,%eax
    1502:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1505:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1508:	bf 00 00 00 00       	mov    $0x0,%edi
    150d:	e9 28 ff ff ff       	jmp    143a <printf+0x45>
        s = (char*)*ap;
    1512:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1515:	8b 01                	mov    (%ecx),%eax
        ap++;
    1517:	83 c1 04             	add    $0x4,%ecx
    151a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    151d:	85 c0                	test   %eax,%eax
    151f:	74 13                	je     1534 <printf+0x13f>
        s = (char*)*ap;
    1521:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1523:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1526:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    152b:	84 c0                	test   %al,%al
    152d:	75 0f                	jne    153e <printf+0x149>
    152f:	e9 06 ff ff ff       	jmp    143a <printf+0x45>
          s = "(null)";
    1534:	bb 44 17 00 00       	mov    $0x1744,%ebx
        while(*s != 0){
    1539:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    153e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1541:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1544:	8b 75 08             	mov    0x8(%ebp),%esi
    1547:	88 45 e3             	mov    %al,-0x1d(%ebp)
    154a:	83 ec 04             	sub    $0x4,%esp
    154d:	6a 01                	push   $0x1
    154f:	57                   	push   %edi
    1550:	56                   	push   %esi
    1551:	e8 85 fd ff ff       	call   12db <write>
          s++;
    1556:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    1559:	0f b6 03             	movzbl (%ebx),%eax
    155c:	83 c4 10             	add    $0x10,%esp
    155f:	84 c0                	test   %al,%al
    1561:	75 e4                	jne    1547 <printf+0x152>
    1563:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1566:	bf 00 00 00 00       	mov    $0x0,%edi
    156b:	e9 ca fe ff ff       	jmp    143a <printf+0x45>
        putc(fd, *ap);
    1570:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1573:	8b 07                	mov    (%edi),%eax
    1575:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1578:	83 ec 04             	sub    $0x4,%esp
    157b:	6a 01                	push   $0x1
    157d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1580:	50                   	push   %eax
    1581:	ff 75 08             	pushl  0x8(%ebp)
    1584:	e8 52 fd ff ff       	call   12db <write>
        ap++;
    1589:	83 c7 04             	add    $0x4,%edi
    158c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    158f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1592:	bf 00 00 00 00       	mov    $0x0,%edi
    1597:	e9 9e fe ff ff       	jmp    143a <printf+0x45>
    159c:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    159f:	83 ec 04             	sub    $0x4,%esp
    15a2:	6a 01                	push   $0x1
    15a4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    15a7:	50                   	push   %eax
    15a8:	ff 75 08             	pushl  0x8(%ebp)
    15ab:	e8 2b fd ff ff       	call   12db <write>
    15b0:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15b3:	bf 00 00 00 00       	mov    $0x0,%edi
    15b8:	e9 7d fe ff ff       	jmp    143a <printf+0x45>
    }
  }
}
    15bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15c0:	5b                   	pop    %ebx
    15c1:	5e                   	pop    %esi
    15c2:	5f                   	pop    %edi
    15c3:	5d                   	pop    %ebp
    15c4:	c3                   	ret    

000015c5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15c5:	55                   	push   %ebp
    15c6:	89 e5                	mov    %esp,%ebp
    15c8:	57                   	push   %edi
    15c9:	56                   	push   %esi
    15ca:	53                   	push   %ebx
    15cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15d1:	a1 00 1a 00 00       	mov    0x1a00,%eax
    15d6:	eb 0c                	jmp    15e4 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15d8:	8b 10                	mov    (%eax),%edx
    15da:	39 c2                	cmp    %eax,%edx
    15dc:	77 04                	ja     15e2 <free+0x1d>
    15de:	39 ca                	cmp    %ecx,%edx
    15e0:	77 10                	ja     15f2 <free+0x2d>
{
    15e2:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15e4:	39 c8                	cmp    %ecx,%eax
    15e6:	73 f0                	jae    15d8 <free+0x13>
    15e8:	8b 10                	mov    (%eax),%edx
    15ea:	39 ca                	cmp    %ecx,%edx
    15ec:	77 04                	ja     15f2 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15ee:	39 c2                	cmp    %eax,%edx
    15f0:	77 f0                	ja     15e2 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    15f2:	8b 73 fc             	mov    -0x4(%ebx),%esi
    15f5:	8b 10                	mov    (%eax),%edx
    15f7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    15fa:	39 fa                	cmp    %edi,%edx
    15fc:	74 19                	je     1617 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    15fe:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1601:	8b 50 04             	mov    0x4(%eax),%edx
    1604:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1607:	39 f1                	cmp    %esi,%ecx
    1609:	74 1b                	je     1626 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    160b:	89 08                	mov    %ecx,(%eax)
  freep = p;
    160d:	a3 00 1a 00 00       	mov    %eax,0x1a00
}
    1612:	5b                   	pop    %ebx
    1613:	5e                   	pop    %esi
    1614:	5f                   	pop    %edi
    1615:	5d                   	pop    %ebp
    1616:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1617:	03 72 04             	add    0x4(%edx),%esi
    161a:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    161d:	8b 10                	mov    (%eax),%edx
    161f:	8b 12                	mov    (%edx),%edx
    1621:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1624:	eb db                	jmp    1601 <free+0x3c>
    p->s.size += bp->s.size;
    1626:	03 53 fc             	add    -0x4(%ebx),%edx
    1629:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    162c:	8b 53 f8             	mov    -0x8(%ebx),%edx
    162f:	89 10                	mov    %edx,(%eax)
    1631:	eb da                	jmp    160d <free+0x48>

00001633 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1633:	55                   	push   %ebp
    1634:	89 e5                	mov    %esp,%ebp
    1636:	57                   	push   %edi
    1637:	56                   	push   %esi
    1638:	53                   	push   %ebx
    1639:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    163c:	8b 45 08             	mov    0x8(%ebp),%eax
    163f:	8d 58 07             	lea    0x7(%eax),%ebx
    1642:	c1 eb 03             	shr    $0x3,%ebx
    1645:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1648:	8b 15 00 1a 00 00    	mov    0x1a00,%edx
    164e:	85 d2                	test   %edx,%edx
    1650:	74 20                	je     1672 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1652:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1654:	8b 48 04             	mov    0x4(%eax),%ecx
    1657:	39 cb                	cmp    %ecx,%ebx
    1659:	76 3c                	jbe    1697 <malloc+0x64>
    165b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1661:	be 00 10 00 00       	mov    $0x1000,%esi
    1666:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    1669:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    1670:	eb 70                	jmp    16e2 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1672:	c7 05 00 1a 00 00 04 	movl   $0x1a04,0x1a00
    1679:	1a 00 00 
    167c:	c7 05 04 1a 00 00 04 	movl   $0x1a04,0x1a04
    1683:	1a 00 00 
    base.s.size = 0;
    1686:	c7 05 08 1a 00 00 00 	movl   $0x0,0x1a08
    168d:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1690:	ba 04 1a 00 00       	mov    $0x1a04,%edx
    1695:	eb bb                	jmp    1652 <malloc+0x1f>
      if(p->s.size == nunits)
    1697:	39 cb                	cmp    %ecx,%ebx
    1699:	74 1c                	je     16b7 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    169b:	29 d9                	sub    %ebx,%ecx
    169d:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    16a0:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    16a3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    16a6:	89 15 00 1a 00 00    	mov    %edx,0x1a00
      return (void*)(p + 1);
    16ac:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    16af:	8d 65 f4             	lea    -0xc(%ebp),%esp
    16b2:	5b                   	pop    %ebx
    16b3:	5e                   	pop    %esi
    16b4:	5f                   	pop    %edi
    16b5:	5d                   	pop    %ebp
    16b6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    16b7:	8b 08                	mov    (%eax),%ecx
    16b9:	89 0a                	mov    %ecx,(%edx)
    16bb:	eb e9                	jmp    16a6 <malloc+0x73>
  hp->s.size = nu;
    16bd:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    16c0:	83 ec 0c             	sub    $0xc,%esp
    16c3:	83 c0 08             	add    $0x8,%eax
    16c6:	50                   	push   %eax
    16c7:	e8 f9 fe ff ff       	call   15c5 <free>
  return freep;
    16cc:	8b 15 00 1a 00 00    	mov    0x1a00,%edx
      if((p = morecore(nunits)) == 0)
    16d2:	83 c4 10             	add    $0x10,%esp
    16d5:	85 d2                	test   %edx,%edx
    16d7:	74 2b                	je     1704 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16d9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16db:	8b 48 04             	mov    0x4(%eax),%ecx
    16de:	39 d9                	cmp    %ebx,%ecx
    16e0:	73 b5                	jae    1697 <malloc+0x64>
    16e2:	89 c2                	mov    %eax,%edx
    if(p == freep)
    16e4:	39 05 00 1a 00 00    	cmp    %eax,0x1a00
    16ea:	75 ed                	jne    16d9 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    16ec:	83 ec 0c             	sub    $0xc,%esp
    16ef:	57                   	push   %edi
    16f0:	e8 4e fc ff ff       	call   1343 <sbrk>
  if(p == (char*)-1)
    16f5:	83 c4 10             	add    $0x10,%esp
    16f8:	83 f8 ff             	cmp    $0xffffffff,%eax
    16fb:	75 c0                	jne    16bd <malloc+0x8a>
        return 0;
    16fd:	b8 00 00 00 00       	mov    $0x0,%eax
    1702:	eb ab                	jmp    16af <malloc+0x7c>
    1704:	b8 00 00 00 00       	mov    $0x0,%eax
    1709:	eb a4                	jmp    16af <malloc+0x7c>
