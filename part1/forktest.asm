
_forktest:     file format elf32-i386


Disassembly of section .text:

00001000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 ec 10             	sub    $0x10,%esp
    1007:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
    100a:	53                   	push   %ebx
    100b:	e8 33 01 00 00       	call   1143 <strlen>
    1010:	83 c4 0c             	add    $0xc,%esp
    1013:	50                   	push   %eax
    1014:	53                   	push   %ebx
    1015:	ff 75 08             	pushl  0x8(%ebp)
    1018:	e8 b7 02 00 00       	call   12d4 <write>
}
    101d:	83 c4 10             	add    $0x10,%esp
    1020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1023:	c9                   	leave  
    1024:	c3                   	ret    

00001025 <forktest>:

void
forktest(void)
{
    1025:	55                   	push   %ebp
    1026:	89 e5                	mov    %esp,%ebp
    1028:	53                   	push   %ebx
    1029:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    102c:	68 64 13 00 00       	push   $0x1364
    1031:	6a 01                	push   $0x1
    1033:	e8 c8 ff ff ff       	call   1000 <printf>
    1038:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
    103b:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    1040:	e8 67 02 00 00       	call   12ac <fork>
    if(pid < 0)
    1045:	85 c0                	test   %eax,%eax
    1047:	78 2d                	js     1076 <forktest+0x51>
      break;
    if(pid == 0)
    1049:	85 c0                	test   %eax,%eax
    104b:	74 24                	je     1071 <forktest+0x4c>
  for(n=0; n<N; n++){
    104d:	83 c3 01             	add    $0x1,%ebx
    1050:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    1056:	75 e8                	jne    1040 <forktest+0x1b>
      exit();
  }

  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    1058:	83 ec 04             	sub    $0x4,%esp
    105b:	68 e8 03 00 00       	push   $0x3e8
    1060:	68 a4 13 00 00       	push   $0x13a4
    1065:	6a 01                	push   $0x1
    1067:	e8 94 ff ff ff       	call   1000 <printf>
    exit();
    106c:	e8 43 02 00 00       	call   12b4 <exit>
      exit();
    1071:	e8 3e 02 00 00       	call   12b4 <exit>
  if(n == N){
    1076:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    107c:	74 da                	je     1058 <forktest+0x33>
  }

  for(; n > 0; n--){
    107e:	85 db                	test   %ebx,%ebx
    1080:	7e 0e                	jle    1090 <forktest+0x6b>
    if(wait() < 0){
    1082:	e8 35 02 00 00       	call   12bc <wait>
    1087:	85 c0                	test   %eax,%eax
    1089:	78 26                	js     10b1 <forktest+0x8c>
  for(; n > 0; n--){
    108b:	83 eb 01             	sub    $0x1,%ebx
    108e:	75 f2                	jne    1082 <forktest+0x5d>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    1090:	e8 27 02 00 00       	call   12bc <wait>
    1095:	83 f8 ff             	cmp    $0xffffffff,%eax
    1098:	75 2b                	jne    10c5 <forktest+0xa0>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    109a:	83 ec 08             	sub    $0x8,%esp
    109d:	68 96 13 00 00       	push   $0x1396
    10a2:	6a 01                	push   $0x1
    10a4:	e8 57 ff ff ff       	call   1000 <printf>
}
    10a9:	83 c4 10             	add    $0x10,%esp
    10ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10af:	c9                   	leave  
    10b0:	c3                   	ret    
      printf(1, "wait stopped early\n");
    10b1:	83 ec 08             	sub    $0x8,%esp
    10b4:	68 6f 13 00 00       	push   $0x136f
    10b9:	6a 01                	push   $0x1
    10bb:	e8 40 ff ff ff       	call   1000 <printf>
      exit();
    10c0:	e8 ef 01 00 00       	call   12b4 <exit>
    printf(1, "wait got too many\n");
    10c5:	83 ec 08             	sub    $0x8,%esp
    10c8:	68 83 13 00 00       	push   $0x1383
    10cd:	6a 01                	push   $0x1
    10cf:	e8 2c ff ff ff       	call   1000 <printf>
    exit();
    10d4:	e8 db 01 00 00       	call   12b4 <exit>

000010d9 <main>:

int
main(void)
{
    10d9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    10dd:	83 e4 f0             	and    $0xfffffff0,%esp
    10e0:	ff 71 fc             	pushl  -0x4(%ecx)
    10e3:	55                   	push   %ebp
    10e4:	89 e5                	mov    %esp,%ebp
    10e6:	51                   	push   %ecx
    10e7:	83 ec 04             	sub    $0x4,%esp
  forktest();
    10ea:	e8 36 ff ff ff       	call   1025 <forktest>
  exit();
    10ef:	e8 c0 01 00 00       	call   12b4 <exit>

000010f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10f4:	55                   	push   %ebp
    10f5:	89 e5                	mov    %esp,%ebp
    10f7:	53                   	push   %ebx
    10f8:	8b 45 08             	mov    0x8(%ebp),%eax
    10fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10fe:	89 c2                	mov    %eax,%edx
    1100:	83 c1 01             	add    $0x1,%ecx
    1103:	83 c2 01             	add    $0x1,%edx
    1106:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    110a:	88 5a ff             	mov    %bl,-0x1(%edx)
    110d:	84 db                	test   %bl,%bl
    110f:	75 ef                	jne    1100 <strcpy+0xc>
    ;
  return os;
}
    1111:	5b                   	pop    %ebx
    1112:	5d                   	pop    %ebp
    1113:	c3                   	ret    

00001114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1114:	55                   	push   %ebp
    1115:	89 e5                	mov    %esp,%ebp
    1117:	8b 4d 08             	mov    0x8(%ebp),%ecx
    111a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    111d:	0f b6 01             	movzbl (%ecx),%eax
    1120:	84 c0                	test   %al,%al
    1122:	74 15                	je     1139 <strcmp+0x25>
    1124:	3a 02                	cmp    (%edx),%al
    1126:	75 11                	jne    1139 <strcmp+0x25>
    p++, q++;
    1128:	83 c1 01             	add    $0x1,%ecx
    112b:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    112e:	0f b6 01             	movzbl (%ecx),%eax
    1131:	84 c0                	test   %al,%al
    1133:	74 04                	je     1139 <strcmp+0x25>
    1135:	3a 02                	cmp    (%edx),%al
    1137:	74 ef                	je     1128 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1139:	0f b6 c0             	movzbl %al,%eax
    113c:	0f b6 12             	movzbl (%edx),%edx
    113f:	29 d0                	sub    %edx,%eax
}
    1141:	5d                   	pop    %ebp
    1142:	c3                   	ret    

00001143 <strlen>:

uint
strlen(const char *s)
{
    1143:	55                   	push   %ebp
    1144:	89 e5                	mov    %esp,%ebp
    1146:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1149:	80 39 00             	cmpb   $0x0,(%ecx)
    114c:	74 12                	je     1160 <strlen+0x1d>
    114e:	ba 00 00 00 00       	mov    $0x0,%edx
    1153:	83 c2 01             	add    $0x1,%edx
    1156:	89 d0                	mov    %edx,%eax
    1158:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    115c:	75 f5                	jne    1153 <strlen+0x10>
    ;
  return n;
}
    115e:	5d                   	pop    %ebp
    115f:	c3                   	ret    
  for(n = 0; s[n]; n++)
    1160:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1165:	eb f7                	jmp    115e <strlen+0x1b>

00001167 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1167:	55                   	push   %ebp
    1168:	89 e5                	mov    %esp,%ebp
    116a:	57                   	push   %edi
    116b:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    116e:	89 d7                	mov    %edx,%edi
    1170:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1173:	8b 45 0c             	mov    0xc(%ebp),%eax
    1176:	fc                   	cld    
    1177:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1179:	89 d0                	mov    %edx,%eax
    117b:	5f                   	pop    %edi
    117c:	5d                   	pop    %ebp
    117d:	c3                   	ret    

0000117e <strchr>:

char*
strchr(const char *s, char c)
{
    117e:	55                   	push   %ebp
    117f:	89 e5                	mov    %esp,%ebp
    1181:	53                   	push   %ebx
    1182:	8b 45 08             	mov    0x8(%ebp),%eax
    1185:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    1188:	0f b6 10             	movzbl (%eax),%edx
    118b:	84 d2                	test   %dl,%dl
    118d:	74 1e                	je     11ad <strchr+0x2f>
    118f:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1191:	38 d3                	cmp    %dl,%bl
    1193:	74 15                	je     11aa <strchr+0x2c>
  for(; *s; s++)
    1195:	83 c0 01             	add    $0x1,%eax
    1198:	0f b6 10             	movzbl (%eax),%edx
    119b:	84 d2                	test   %dl,%dl
    119d:	74 06                	je     11a5 <strchr+0x27>
    if(*s == c)
    119f:	38 ca                	cmp    %cl,%dl
    11a1:	75 f2                	jne    1195 <strchr+0x17>
    11a3:	eb 05                	jmp    11aa <strchr+0x2c>
      return (char*)s;
  return 0;
    11a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11aa:	5b                   	pop    %ebx
    11ab:	5d                   	pop    %ebp
    11ac:	c3                   	ret    
  return 0;
    11ad:	b8 00 00 00 00       	mov    $0x0,%eax
    11b2:	eb f6                	jmp    11aa <strchr+0x2c>

000011b4 <gets>:

char*
gets(char *buf, int max)
{
    11b4:	55                   	push   %ebp
    11b5:	89 e5                	mov    %esp,%ebp
    11b7:	57                   	push   %edi
    11b8:	56                   	push   %esi
    11b9:	53                   	push   %ebx
    11ba:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11bd:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    11c2:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    11c5:	8d 5e 01             	lea    0x1(%esi),%ebx
    11c8:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11cb:	7d 2b                	jge    11f8 <gets+0x44>
    cc = read(0, &c, 1);
    11cd:	83 ec 04             	sub    $0x4,%esp
    11d0:	6a 01                	push   $0x1
    11d2:	57                   	push   %edi
    11d3:	6a 00                	push   $0x0
    11d5:	e8 f2 00 00 00       	call   12cc <read>
    if(cc < 1)
    11da:	83 c4 10             	add    $0x10,%esp
    11dd:	85 c0                	test   %eax,%eax
    11df:	7e 17                	jle    11f8 <gets+0x44>
      break;
    buf[i++] = c;
    11e1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    11e5:	8b 55 08             	mov    0x8(%ebp),%edx
    11e8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    11ec:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    11ee:	3c 0a                	cmp    $0xa,%al
    11f0:	74 04                	je     11f6 <gets+0x42>
    11f2:	3c 0d                	cmp    $0xd,%al
    11f4:	75 cf                	jne    11c5 <gets+0x11>
  for(i=0; i+1 < max; ){
    11f6:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    11f8:	8b 45 08             	mov    0x8(%ebp),%eax
    11fb:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    11ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1202:	5b                   	pop    %ebx
    1203:	5e                   	pop    %esi
    1204:	5f                   	pop    %edi
    1205:	5d                   	pop    %ebp
    1206:	c3                   	ret    

00001207 <stat>:

int
stat(const char *n, struct stat *st)
{
    1207:	55                   	push   %ebp
    1208:	89 e5                	mov    %esp,%ebp
    120a:	56                   	push   %esi
    120b:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    120c:	83 ec 08             	sub    $0x8,%esp
    120f:	6a 00                	push   $0x0
    1211:	ff 75 08             	pushl  0x8(%ebp)
    1214:	e8 db 00 00 00       	call   12f4 <open>
  if(fd < 0)
    1219:	83 c4 10             	add    $0x10,%esp
    121c:	85 c0                	test   %eax,%eax
    121e:	78 24                	js     1244 <stat+0x3d>
    1220:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1222:	83 ec 08             	sub    $0x8,%esp
    1225:	ff 75 0c             	pushl  0xc(%ebp)
    1228:	50                   	push   %eax
    1229:	e8 de 00 00 00       	call   130c <fstat>
    122e:	89 c6                	mov    %eax,%esi
  close(fd);
    1230:	89 1c 24             	mov    %ebx,(%esp)
    1233:	e8 a4 00 00 00       	call   12dc <close>
  return r;
    1238:	83 c4 10             	add    $0x10,%esp
}
    123b:	89 f0                	mov    %esi,%eax
    123d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1240:	5b                   	pop    %ebx
    1241:	5e                   	pop    %esi
    1242:	5d                   	pop    %ebp
    1243:	c3                   	ret    
    return -1;
    1244:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1249:	eb f0                	jmp    123b <stat+0x34>

0000124b <atoi>:

int
atoi(const char *s)
{
    124b:	55                   	push   %ebp
    124c:	89 e5                	mov    %esp,%ebp
    124e:	53                   	push   %ebx
    124f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1252:	0f b6 11             	movzbl (%ecx),%edx
    1255:	8d 42 d0             	lea    -0x30(%edx),%eax
    1258:	3c 09                	cmp    $0x9,%al
    125a:	77 20                	ja     127c <atoi+0x31>
  n = 0;
    125c:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    1261:	83 c1 01             	add    $0x1,%ecx
    1264:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1267:	0f be d2             	movsbl %dl,%edx
    126a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    126e:	0f b6 11             	movzbl (%ecx),%edx
    1271:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1274:	80 fb 09             	cmp    $0x9,%bl
    1277:	76 e8                	jbe    1261 <atoi+0x16>
  return n;
}
    1279:	5b                   	pop    %ebx
    127a:	5d                   	pop    %ebp
    127b:	c3                   	ret    
  n = 0;
    127c:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1281:	eb f6                	jmp    1279 <atoi+0x2e>

00001283 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1283:	55                   	push   %ebp
    1284:	89 e5                	mov    %esp,%ebp
    1286:	56                   	push   %esi
    1287:	53                   	push   %ebx
    1288:	8b 45 08             	mov    0x8(%ebp),%eax
    128b:	8b 75 0c             	mov    0xc(%ebp),%esi
    128e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1291:	85 db                	test   %ebx,%ebx
    1293:	7e 13                	jle    12a8 <memmove+0x25>
    1295:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    129a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    129e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    12a1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    12a4:	39 d3                	cmp    %edx,%ebx
    12a6:	75 f2                	jne    129a <memmove+0x17>
  return vdst;
}
    12a8:	5b                   	pop    %ebx
    12a9:	5e                   	pop    %esi
    12aa:	5d                   	pop    %ebp
    12ab:	c3                   	ret    

000012ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ac:	b8 01 00 00 00       	mov    $0x1,%eax
    12b1:	cd 40                	int    $0x40
    12b3:	c3                   	ret    

000012b4 <exit>:
SYSCALL(exit)
    12b4:	b8 02 00 00 00       	mov    $0x2,%eax
    12b9:	cd 40                	int    $0x40
    12bb:	c3                   	ret    

000012bc <wait>:
SYSCALL(wait)
    12bc:	b8 03 00 00 00       	mov    $0x3,%eax
    12c1:	cd 40                	int    $0x40
    12c3:	c3                   	ret    

000012c4 <pipe>:
SYSCALL(pipe)
    12c4:	b8 04 00 00 00       	mov    $0x4,%eax
    12c9:	cd 40                	int    $0x40
    12cb:	c3                   	ret    

000012cc <read>:
SYSCALL(read)
    12cc:	b8 05 00 00 00       	mov    $0x5,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <write>:
SYSCALL(write)
    12d4:	b8 10 00 00 00       	mov    $0x10,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <close>:
SYSCALL(close)
    12dc:	b8 15 00 00 00       	mov    $0x15,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <kill>:
SYSCALL(kill)
    12e4:	b8 06 00 00 00       	mov    $0x6,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <exec>:
SYSCALL(exec)
    12ec:	b8 07 00 00 00       	mov    $0x7,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <open>:
SYSCALL(open)
    12f4:	b8 0f 00 00 00       	mov    $0xf,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <mknod>:
SYSCALL(mknod)
    12fc:	b8 11 00 00 00       	mov    $0x11,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <unlink>:
SYSCALL(unlink)
    1304:	b8 12 00 00 00       	mov    $0x12,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <fstat>:
SYSCALL(fstat)
    130c:	b8 08 00 00 00       	mov    $0x8,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <link>:
SYSCALL(link)
    1314:	b8 13 00 00 00       	mov    $0x13,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <mkdir>:
SYSCALL(mkdir)
    131c:	b8 14 00 00 00       	mov    $0x14,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <chdir>:
SYSCALL(chdir)
    1324:	b8 09 00 00 00       	mov    $0x9,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <dup>:
SYSCALL(dup)
    132c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <getpid>:
SYSCALL(getpid)
    1334:	b8 0b 00 00 00       	mov    $0xb,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <sbrk>:
SYSCALL(sbrk)
    133c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <sleep>:
SYSCALL(sleep)
    1344:	b8 0d 00 00 00       	mov    $0xd,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <uptime>:
SYSCALL(uptime)
    134c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <shmem_access>:
SYSCALL(shmem_access)
    1354:	b8 16 00 00 00       	mov    $0x16,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <shmem_count>:
    135c:	b8 17 00 00 00       	mov    $0x17,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    
