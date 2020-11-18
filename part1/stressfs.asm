
_stressfs:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "fs.h"
#include "fcntl.h"

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
    1011:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
    1017:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
    101e:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
    1025:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
    102b:	68 24 17 00 00       	push   $0x1724
    1030:	6a 01                	push   $0x1
    1032:	e8 d4 03 00 00       	call   140b <printf>
  memset(data, 'a', sizeof(data));
    1037:	83 c4 0c             	add    $0xc,%esp
    103a:	68 00 02 00 00       	push   $0x200
    103f:	6a 61                	push   $0x61
    1041:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
    1047:	50                   	push   %eax
    1048:	e8 37 01 00 00       	call   1184 <memset>
    104d:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
    1050:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(fork() > 0)
    1055:	e8 6f 02 00 00       	call   12c9 <fork>
    105a:	85 c0                	test   %eax,%eax
    105c:	7f 08                	jg     1066 <main+0x66>
  for(i = 0; i < 4; i++)
    105e:	83 c3 01             	add    $0x1,%ebx
    1061:	83 fb 04             	cmp    $0x4,%ebx
    1064:	75 ef                	jne    1055 <main+0x55>
      break;

  printf(1, "write %d\n", i);
    1066:	83 ec 04             	sub    $0x4,%esp
    1069:	53                   	push   %ebx
    106a:	68 37 17 00 00       	push   $0x1737
    106f:	6a 01                	push   $0x1
    1071:	e8 95 03 00 00       	call   140b <printf>

  path[8] += i;
    1076:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
    1079:	83 c4 08             	add    $0x8,%esp
    107c:	68 02 02 00 00       	push   $0x202
    1081:	8d 45 de             	lea    -0x22(%ebp),%eax
    1084:	50                   	push   %eax
    1085:	e8 87 02 00 00       	call   1311 <open>
    108a:	89 c6                	mov    %eax,%esi
    108c:	83 c4 10             	add    $0x10,%esp
    108f:	bb 14 00 00 00       	mov    $0x14,%ebx
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    1094:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
    109a:	83 ec 04             	sub    $0x4,%esp
    109d:	68 00 02 00 00       	push   $0x200
    10a2:	57                   	push   %edi
    10a3:	56                   	push   %esi
    10a4:	e8 48 02 00 00       	call   12f1 <write>
  for(i = 0; i < 20; i++)
    10a9:	83 c4 10             	add    $0x10,%esp
    10ac:	83 eb 01             	sub    $0x1,%ebx
    10af:	75 e9                	jne    109a <main+0x9a>
  close(fd);
    10b1:	83 ec 0c             	sub    $0xc,%esp
    10b4:	56                   	push   %esi
    10b5:	e8 3f 02 00 00       	call   12f9 <close>

  printf(1, "read\n");
    10ba:	83 c4 08             	add    $0x8,%esp
    10bd:	68 41 17 00 00       	push   $0x1741
    10c2:	6a 01                	push   $0x1
    10c4:	e8 42 03 00 00       	call   140b <printf>

  fd = open(path, O_RDONLY);
    10c9:	83 c4 08             	add    $0x8,%esp
    10cc:	6a 00                	push   $0x0
    10ce:	8d 45 de             	lea    -0x22(%ebp),%eax
    10d1:	50                   	push   %eax
    10d2:	e8 3a 02 00 00       	call   1311 <open>
    10d7:	89 c6                	mov    %eax,%esi
    10d9:	83 c4 10             	add    $0x10,%esp
    10dc:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
    10e1:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
    10e7:	83 ec 04             	sub    $0x4,%esp
    10ea:	68 00 02 00 00       	push   $0x200
    10ef:	57                   	push   %edi
    10f0:	56                   	push   %esi
    10f1:	e8 f3 01 00 00       	call   12e9 <read>
  for (i = 0; i < 20; i++)
    10f6:	83 c4 10             	add    $0x10,%esp
    10f9:	83 eb 01             	sub    $0x1,%ebx
    10fc:	75 e9                	jne    10e7 <main+0xe7>
  close(fd);
    10fe:	83 ec 0c             	sub    $0xc,%esp
    1101:	56                   	push   %esi
    1102:	e8 f2 01 00 00       	call   12f9 <close>

  wait();
    1107:	e8 cd 01 00 00       	call   12d9 <wait>

  exit();
    110c:	e8 c0 01 00 00       	call   12d1 <exit>

00001111 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1111:	55                   	push   %ebp
    1112:	89 e5                	mov    %esp,%ebp
    1114:	53                   	push   %ebx
    1115:	8b 45 08             	mov    0x8(%ebp),%eax
    1118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    111b:	89 c2                	mov    %eax,%edx
    111d:	83 c1 01             	add    $0x1,%ecx
    1120:	83 c2 01             	add    $0x1,%edx
    1123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1127:	88 5a ff             	mov    %bl,-0x1(%edx)
    112a:	84 db                	test   %bl,%bl
    112c:	75 ef                	jne    111d <strcpy+0xc>
    ;
  return os;
}
    112e:	5b                   	pop    %ebx
    112f:	5d                   	pop    %ebp
    1130:	c3                   	ret    

00001131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1131:	55                   	push   %ebp
    1132:	89 e5                	mov    %esp,%ebp
    1134:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1137:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    113a:	0f b6 01             	movzbl (%ecx),%eax
    113d:	84 c0                	test   %al,%al
    113f:	74 15                	je     1156 <strcmp+0x25>
    1141:	3a 02                	cmp    (%edx),%al
    1143:	75 11                	jne    1156 <strcmp+0x25>
    p++, q++;
    1145:	83 c1 01             	add    $0x1,%ecx
    1148:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    114b:	0f b6 01             	movzbl (%ecx),%eax
    114e:	84 c0                	test   %al,%al
    1150:	74 04                	je     1156 <strcmp+0x25>
    1152:	3a 02                	cmp    (%edx),%al
    1154:	74 ef                	je     1145 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1156:	0f b6 c0             	movzbl %al,%eax
    1159:	0f b6 12             	movzbl (%edx),%edx
    115c:	29 d0                	sub    %edx,%eax
}
    115e:	5d                   	pop    %ebp
    115f:	c3                   	ret    

00001160 <strlen>:

uint
strlen(const char *s)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1166:	80 39 00             	cmpb   $0x0,(%ecx)
    1169:	74 12                	je     117d <strlen+0x1d>
    116b:	ba 00 00 00 00       	mov    $0x0,%edx
    1170:	83 c2 01             	add    $0x1,%edx
    1173:	89 d0                	mov    %edx,%eax
    1175:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1179:	75 f5                	jne    1170 <strlen+0x10>
    ;
  return n;
}
    117b:	5d                   	pop    %ebp
    117c:	c3                   	ret    
  for(n = 0; s[n]; n++)
    117d:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1182:	eb f7                	jmp    117b <strlen+0x1b>

00001184 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1184:	55                   	push   %ebp
    1185:	89 e5                	mov    %esp,%ebp
    1187:	57                   	push   %edi
    1188:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    118b:	89 d7                	mov    %edx,%edi
    118d:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1190:	8b 45 0c             	mov    0xc(%ebp),%eax
    1193:	fc                   	cld    
    1194:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1196:	89 d0                	mov    %edx,%eax
    1198:	5f                   	pop    %edi
    1199:	5d                   	pop    %ebp
    119a:	c3                   	ret    

0000119b <strchr>:

char*
strchr(const char *s, char c)
{
    119b:	55                   	push   %ebp
    119c:	89 e5                	mov    %esp,%ebp
    119e:	53                   	push   %ebx
    119f:	8b 45 08             	mov    0x8(%ebp),%eax
    11a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    11a5:	0f b6 10             	movzbl (%eax),%edx
    11a8:	84 d2                	test   %dl,%dl
    11aa:	74 1e                	je     11ca <strchr+0x2f>
    11ac:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    11ae:	38 d3                	cmp    %dl,%bl
    11b0:	74 15                	je     11c7 <strchr+0x2c>
  for(; *s; s++)
    11b2:	83 c0 01             	add    $0x1,%eax
    11b5:	0f b6 10             	movzbl (%eax),%edx
    11b8:	84 d2                	test   %dl,%dl
    11ba:	74 06                	je     11c2 <strchr+0x27>
    if(*s == c)
    11bc:	38 ca                	cmp    %cl,%dl
    11be:	75 f2                	jne    11b2 <strchr+0x17>
    11c0:	eb 05                	jmp    11c7 <strchr+0x2c>
      return (char*)s;
  return 0;
    11c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11c7:	5b                   	pop    %ebx
    11c8:	5d                   	pop    %ebp
    11c9:	c3                   	ret    
  return 0;
    11ca:	b8 00 00 00 00       	mov    $0x0,%eax
    11cf:	eb f6                	jmp    11c7 <strchr+0x2c>

000011d1 <gets>:

char*
gets(char *buf, int max)
{
    11d1:	55                   	push   %ebp
    11d2:	89 e5                	mov    %esp,%ebp
    11d4:	57                   	push   %edi
    11d5:	56                   	push   %esi
    11d6:	53                   	push   %ebx
    11d7:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11da:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    11df:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    11e2:	8d 5e 01             	lea    0x1(%esi),%ebx
    11e5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11e8:	7d 2b                	jge    1215 <gets+0x44>
    cc = read(0, &c, 1);
    11ea:	83 ec 04             	sub    $0x4,%esp
    11ed:	6a 01                	push   $0x1
    11ef:	57                   	push   %edi
    11f0:	6a 00                	push   $0x0
    11f2:	e8 f2 00 00 00       	call   12e9 <read>
    if(cc < 1)
    11f7:	83 c4 10             	add    $0x10,%esp
    11fa:	85 c0                	test   %eax,%eax
    11fc:	7e 17                	jle    1215 <gets+0x44>
      break;
    buf[i++] = c;
    11fe:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1202:	8b 55 08             	mov    0x8(%ebp),%edx
    1205:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1209:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    120b:	3c 0a                	cmp    $0xa,%al
    120d:	74 04                	je     1213 <gets+0x42>
    120f:	3c 0d                	cmp    $0xd,%al
    1211:	75 cf                	jne    11e2 <gets+0x11>
  for(i=0; i+1 < max; ){
    1213:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
    1218:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    121f:	5b                   	pop    %ebx
    1220:	5e                   	pop    %esi
    1221:	5f                   	pop    %edi
    1222:	5d                   	pop    %ebp
    1223:	c3                   	ret    

00001224 <stat>:

int
stat(const char *n, struct stat *st)
{
    1224:	55                   	push   %ebp
    1225:	89 e5                	mov    %esp,%ebp
    1227:	56                   	push   %esi
    1228:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1229:	83 ec 08             	sub    $0x8,%esp
    122c:	6a 00                	push   $0x0
    122e:	ff 75 08             	pushl  0x8(%ebp)
    1231:	e8 db 00 00 00       	call   1311 <open>
  if(fd < 0)
    1236:	83 c4 10             	add    $0x10,%esp
    1239:	85 c0                	test   %eax,%eax
    123b:	78 24                	js     1261 <stat+0x3d>
    123d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    123f:	83 ec 08             	sub    $0x8,%esp
    1242:	ff 75 0c             	pushl  0xc(%ebp)
    1245:	50                   	push   %eax
    1246:	e8 de 00 00 00       	call   1329 <fstat>
    124b:	89 c6                	mov    %eax,%esi
  close(fd);
    124d:	89 1c 24             	mov    %ebx,(%esp)
    1250:	e8 a4 00 00 00       	call   12f9 <close>
  return r;
    1255:	83 c4 10             	add    $0x10,%esp
}
    1258:	89 f0                	mov    %esi,%eax
    125a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    125d:	5b                   	pop    %ebx
    125e:	5e                   	pop    %esi
    125f:	5d                   	pop    %ebp
    1260:	c3                   	ret    
    return -1;
    1261:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1266:	eb f0                	jmp    1258 <stat+0x34>

00001268 <atoi>:

int
atoi(const char *s)
{
    1268:	55                   	push   %ebp
    1269:	89 e5                	mov    %esp,%ebp
    126b:	53                   	push   %ebx
    126c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126f:	0f b6 11             	movzbl (%ecx),%edx
    1272:	8d 42 d0             	lea    -0x30(%edx),%eax
    1275:	3c 09                	cmp    $0x9,%al
    1277:	77 20                	ja     1299 <atoi+0x31>
  n = 0;
    1279:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    127e:	83 c1 01             	add    $0x1,%ecx
    1281:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1284:	0f be d2             	movsbl %dl,%edx
    1287:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    128b:	0f b6 11             	movzbl (%ecx),%edx
    128e:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1291:	80 fb 09             	cmp    $0x9,%bl
    1294:	76 e8                	jbe    127e <atoi+0x16>
  return n;
}
    1296:	5b                   	pop    %ebx
    1297:	5d                   	pop    %ebp
    1298:	c3                   	ret    
  n = 0;
    1299:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    129e:	eb f6                	jmp    1296 <atoi+0x2e>

000012a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12a0:	55                   	push   %ebp
    12a1:	89 e5                	mov    %esp,%ebp
    12a3:	56                   	push   %esi
    12a4:	53                   	push   %ebx
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	8b 75 0c             	mov    0xc(%ebp),%esi
    12ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12ae:	85 db                	test   %ebx,%ebx
    12b0:	7e 13                	jle    12c5 <memmove+0x25>
    12b2:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    12b7:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    12bb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    12be:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    12c1:	39 d3                	cmp    %edx,%ebx
    12c3:	75 f2                	jne    12b7 <memmove+0x17>
  return vdst;
}
    12c5:	5b                   	pop    %ebx
    12c6:	5e                   	pop    %esi
    12c7:	5d                   	pop    %ebp
    12c8:	c3                   	ret    

000012c9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c9:	b8 01 00 00 00       	mov    $0x1,%eax
    12ce:	cd 40                	int    $0x40
    12d0:	c3                   	ret    

000012d1 <exit>:
SYSCALL(exit)
    12d1:	b8 02 00 00 00       	mov    $0x2,%eax
    12d6:	cd 40                	int    $0x40
    12d8:	c3                   	ret    

000012d9 <wait>:
SYSCALL(wait)
    12d9:	b8 03 00 00 00       	mov    $0x3,%eax
    12de:	cd 40                	int    $0x40
    12e0:	c3                   	ret    

000012e1 <pipe>:
SYSCALL(pipe)
    12e1:	b8 04 00 00 00       	mov    $0x4,%eax
    12e6:	cd 40                	int    $0x40
    12e8:	c3                   	ret    

000012e9 <read>:
SYSCALL(read)
    12e9:	b8 05 00 00 00       	mov    $0x5,%eax
    12ee:	cd 40                	int    $0x40
    12f0:	c3                   	ret    

000012f1 <write>:
SYSCALL(write)
    12f1:	b8 10 00 00 00       	mov    $0x10,%eax
    12f6:	cd 40                	int    $0x40
    12f8:	c3                   	ret    

000012f9 <close>:
SYSCALL(close)
    12f9:	b8 15 00 00 00       	mov    $0x15,%eax
    12fe:	cd 40                	int    $0x40
    1300:	c3                   	ret    

00001301 <kill>:
SYSCALL(kill)
    1301:	b8 06 00 00 00       	mov    $0x6,%eax
    1306:	cd 40                	int    $0x40
    1308:	c3                   	ret    

00001309 <exec>:
SYSCALL(exec)
    1309:	b8 07 00 00 00       	mov    $0x7,%eax
    130e:	cd 40                	int    $0x40
    1310:	c3                   	ret    

00001311 <open>:
SYSCALL(open)
    1311:	b8 0f 00 00 00       	mov    $0xf,%eax
    1316:	cd 40                	int    $0x40
    1318:	c3                   	ret    

00001319 <mknod>:
SYSCALL(mknod)
    1319:	b8 11 00 00 00       	mov    $0x11,%eax
    131e:	cd 40                	int    $0x40
    1320:	c3                   	ret    

00001321 <unlink>:
SYSCALL(unlink)
    1321:	b8 12 00 00 00       	mov    $0x12,%eax
    1326:	cd 40                	int    $0x40
    1328:	c3                   	ret    

00001329 <fstat>:
SYSCALL(fstat)
    1329:	b8 08 00 00 00       	mov    $0x8,%eax
    132e:	cd 40                	int    $0x40
    1330:	c3                   	ret    

00001331 <link>:
SYSCALL(link)
    1331:	b8 13 00 00 00       	mov    $0x13,%eax
    1336:	cd 40                	int    $0x40
    1338:	c3                   	ret    

00001339 <mkdir>:
SYSCALL(mkdir)
    1339:	b8 14 00 00 00       	mov    $0x14,%eax
    133e:	cd 40                	int    $0x40
    1340:	c3                   	ret    

00001341 <chdir>:
SYSCALL(chdir)
    1341:	b8 09 00 00 00       	mov    $0x9,%eax
    1346:	cd 40                	int    $0x40
    1348:	c3                   	ret    

00001349 <dup>:
SYSCALL(dup)
    1349:	b8 0a 00 00 00       	mov    $0xa,%eax
    134e:	cd 40                	int    $0x40
    1350:	c3                   	ret    

00001351 <getpid>:
SYSCALL(getpid)
    1351:	b8 0b 00 00 00       	mov    $0xb,%eax
    1356:	cd 40                	int    $0x40
    1358:	c3                   	ret    

00001359 <sbrk>:
SYSCALL(sbrk)
    1359:	b8 0c 00 00 00       	mov    $0xc,%eax
    135e:	cd 40                	int    $0x40
    1360:	c3                   	ret    

00001361 <sleep>:
SYSCALL(sleep)
    1361:	b8 0d 00 00 00       	mov    $0xd,%eax
    1366:	cd 40                	int    $0x40
    1368:	c3                   	ret    

00001369 <uptime>:
SYSCALL(uptime)
    1369:	b8 0e 00 00 00       	mov    $0xe,%eax
    136e:	cd 40                	int    $0x40
    1370:	c3                   	ret    

00001371 <shmem_access>:
SYSCALL(shmem_access)
    1371:	b8 16 00 00 00       	mov    $0x16,%eax
    1376:	cd 40                	int    $0x40
    1378:	c3                   	ret    

00001379 <shmem_count>:
    1379:	b8 17 00 00 00       	mov    $0x17,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1381:	55                   	push   %ebp
    1382:	89 e5                	mov    %esp,%ebp
    1384:	57                   	push   %edi
    1385:	56                   	push   %esi
    1386:	53                   	push   %ebx
    1387:	83 ec 3c             	sub    $0x3c,%esp
    138a:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    138c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1390:	74 14                	je     13a6 <printint+0x25>
    1392:	85 d2                	test   %edx,%edx
    1394:	79 10                	jns    13a6 <printint+0x25>
    neg = 1;
    x = -xx;
    1396:	f7 da                	neg    %edx
    neg = 1;
    1398:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    139f:	bf 00 00 00 00       	mov    $0x0,%edi
    13a4:	eb 0b                	jmp    13b1 <printint+0x30>
  neg = 0;
    13a6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    13ad:	eb f0                	jmp    139f <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    13af:	89 df                	mov    %ebx,%edi
    13b1:	8d 5f 01             	lea    0x1(%edi),%ebx
    13b4:	89 d0                	mov    %edx,%eax
    13b6:	ba 00 00 00 00       	mov    $0x0,%edx
    13bb:	f7 f1                	div    %ecx
    13bd:	0f b6 92 50 17 00 00 	movzbl 0x1750(%edx),%edx
    13c4:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    13c8:	89 c2                	mov    %eax,%edx
    13ca:	85 c0                	test   %eax,%eax
    13cc:	75 e1                	jne    13af <printint+0x2e>
  if(neg)
    13ce:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    13d2:	74 08                	je     13dc <printint+0x5b>
    buf[i++] = '-';
    13d4:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    13d9:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    13dc:	83 eb 01             	sub    $0x1,%ebx
    13df:	78 22                	js     1403 <printint+0x82>
  write(fd, &c, 1);
    13e1:	8d 7d d7             	lea    -0x29(%ebp),%edi
    13e4:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    13e9:	88 45 d7             	mov    %al,-0x29(%ebp)
    13ec:	83 ec 04             	sub    $0x4,%esp
    13ef:	6a 01                	push   $0x1
    13f1:	57                   	push   %edi
    13f2:	56                   	push   %esi
    13f3:	e8 f9 fe ff ff       	call   12f1 <write>
  while(--i >= 0)
    13f8:	83 eb 01             	sub    $0x1,%ebx
    13fb:	83 c4 10             	add    $0x10,%esp
    13fe:	83 fb ff             	cmp    $0xffffffff,%ebx
    1401:	75 e1                	jne    13e4 <printint+0x63>
    putc(fd, buf[i]);
}
    1403:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1406:	5b                   	pop    %ebx
    1407:	5e                   	pop    %esi
    1408:	5f                   	pop    %edi
    1409:	5d                   	pop    %ebp
    140a:	c3                   	ret    

0000140b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    140b:	55                   	push   %ebp
    140c:	89 e5                	mov    %esp,%ebp
    140e:	57                   	push   %edi
    140f:	56                   	push   %esi
    1410:	53                   	push   %ebx
    1411:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1414:	8b 75 0c             	mov    0xc(%ebp),%esi
    1417:	0f b6 1e             	movzbl (%esi),%ebx
    141a:	84 db                	test   %bl,%bl
    141c:	0f 84 b1 01 00 00    	je     15d3 <printf+0x1c8>
    1422:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    1425:	8d 45 10             	lea    0x10(%ebp),%eax
    1428:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    142b:	bf 00 00 00 00       	mov    $0x0,%edi
    1430:	eb 2d                	jmp    145f <printf+0x54>
    1432:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1435:	83 ec 04             	sub    $0x4,%esp
    1438:	6a 01                	push   $0x1
    143a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    143d:	50                   	push   %eax
    143e:	ff 75 08             	pushl  0x8(%ebp)
    1441:	e8 ab fe ff ff       	call   12f1 <write>
    1446:	83 c4 10             	add    $0x10,%esp
    1449:	eb 05                	jmp    1450 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    144b:	83 ff 25             	cmp    $0x25,%edi
    144e:	74 22                	je     1472 <printf+0x67>
    1450:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    1453:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1457:	84 db                	test   %bl,%bl
    1459:	0f 84 74 01 00 00    	je     15d3 <printf+0x1c8>
    c = fmt[i] & 0xff;
    145f:	0f be d3             	movsbl %bl,%edx
    1462:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1465:	85 ff                	test   %edi,%edi
    1467:	75 e2                	jne    144b <printf+0x40>
      if(c == '%'){
    1469:	83 f8 25             	cmp    $0x25,%eax
    146c:	75 c4                	jne    1432 <printf+0x27>
        state = '%';
    146e:	89 c7                	mov    %eax,%edi
    1470:	eb de                	jmp    1450 <printf+0x45>
      if(c == 'd'){
    1472:	83 f8 64             	cmp    $0x64,%eax
    1475:	74 59                	je     14d0 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1477:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    147d:	83 fa 70             	cmp    $0x70,%edx
    1480:	74 7a                	je     14fc <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1482:	83 f8 73             	cmp    $0x73,%eax
    1485:	0f 84 9d 00 00 00    	je     1528 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    148b:	83 f8 63             	cmp    $0x63,%eax
    148e:	0f 84 f2 00 00 00    	je     1586 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1494:	83 f8 25             	cmp    $0x25,%eax
    1497:	0f 84 15 01 00 00    	je     15b2 <printf+0x1a7>
    149d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    14a1:	83 ec 04             	sub    $0x4,%esp
    14a4:	6a 01                	push   $0x1
    14a6:	8d 45 e7             	lea    -0x19(%ebp),%eax
    14a9:	50                   	push   %eax
    14aa:	ff 75 08             	pushl  0x8(%ebp)
    14ad:	e8 3f fe ff ff       	call   12f1 <write>
    14b2:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    14b5:	83 c4 0c             	add    $0xc,%esp
    14b8:	6a 01                	push   $0x1
    14ba:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    14bd:	50                   	push   %eax
    14be:	ff 75 08             	pushl  0x8(%ebp)
    14c1:	e8 2b fe ff ff       	call   12f1 <write>
    14c6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    14c9:	bf 00 00 00 00       	mov    $0x0,%edi
    14ce:	eb 80                	jmp    1450 <printf+0x45>
        printint(fd, *ap, 10, 1);
    14d0:	83 ec 0c             	sub    $0xc,%esp
    14d3:	6a 01                	push   $0x1
    14d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
    14da:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14dd:	8b 17                	mov    (%edi),%edx
    14df:	8b 45 08             	mov    0x8(%ebp),%eax
    14e2:	e8 9a fe ff ff       	call   1381 <printint>
        ap++;
    14e7:	89 f8                	mov    %edi,%eax
    14e9:	83 c0 04             	add    $0x4,%eax
    14ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    14ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14f2:	bf 00 00 00 00       	mov    $0x0,%edi
    14f7:	e9 54 ff ff ff       	jmp    1450 <printf+0x45>
        printint(fd, *ap, 16, 0);
    14fc:	83 ec 0c             	sub    $0xc,%esp
    14ff:	6a 00                	push   $0x0
    1501:	b9 10 00 00 00       	mov    $0x10,%ecx
    1506:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1509:	8b 17                	mov    (%edi),%edx
    150b:	8b 45 08             	mov    0x8(%ebp),%eax
    150e:	e8 6e fe ff ff       	call   1381 <printint>
        ap++;
    1513:	89 f8                	mov    %edi,%eax
    1515:	83 c0 04             	add    $0x4,%eax
    1518:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    151b:	83 c4 10             	add    $0x10,%esp
      state = 0;
    151e:	bf 00 00 00 00       	mov    $0x0,%edi
    1523:	e9 28 ff ff ff       	jmp    1450 <printf+0x45>
        s = (char*)*ap;
    1528:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    152b:	8b 01                	mov    (%ecx),%eax
        ap++;
    152d:	83 c1 04             	add    $0x4,%ecx
    1530:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1533:	85 c0                	test   %eax,%eax
    1535:	74 13                	je     154a <printf+0x13f>
        s = (char*)*ap;
    1537:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1539:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    153c:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    1541:	84 c0                	test   %al,%al
    1543:	75 0f                	jne    1554 <printf+0x149>
    1545:	e9 06 ff ff ff       	jmp    1450 <printf+0x45>
          s = "(null)";
    154a:	bb 47 17 00 00       	mov    $0x1747,%ebx
        while(*s != 0){
    154f:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    1554:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1557:	89 75 d0             	mov    %esi,-0x30(%ebp)
    155a:	8b 75 08             	mov    0x8(%ebp),%esi
    155d:	88 45 e3             	mov    %al,-0x1d(%ebp)
    1560:	83 ec 04             	sub    $0x4,%esp
    1563:	6a 01                	push   $0x1
    1565:	57                   	push   %edi
    1566:	56                   	push   %esi
    1567:	e8 85 fd ff ff       	call   12f1 <write>
          s++;
    156c:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    156f:	0f b6 03             	movzbl (%ebx),%eax
    1572:	83 c4 10             	add    $0x10,%esp
    1575:	84 c0                	test   %al,%al
    1577:	75 e4                	jne    155d <printf+0x152>
    1579:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    157c:	bf 00 00 00 00       	mov    $0x0,%edi
    1581:	e9 ca fe ff ff       	jmp    1450 <printf+0x45>
        putc(fd, *ap);
    1586:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1589:	8b 07                	mov    (%edi),%eax
    158b:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    158e:	83 ec 04             	sub    $0x4,%esp
    1591:	6a 01                	push   $0x1
    1593:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1596:	50                   	push   %eax
    1597:	ff 75 08             	pushl  0x8(%ebp)
    159a:	e8 52 fd ff ff       	call   12f1 <write>
        ap++;
    159f:	83 c7 04             	add    $0x4,%edi
    15a2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    15a5:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15a8:	bf 00 00 00 00       	mov    $0x0,%edi
    15ad:	e9 9e fe ff ff       	jmp    1450 <printf+0x45>
    15b2:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    15b5:	83 ec 04             	sub    $0x4,%esp
    15b8:	6a 01                	push   $0x1
    15ba:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    15bd:	50                   	push   %eax
    15be:	ff 75 08             	pushl  0x8(%ebp)
    15c1:	e8 2b fd ff ff       	call   12f1 <write>
    15c6:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15c9:	bf 00 00 00 00       	mov    $0x0,%edi
    15ce:	e9 7d fe ff ff       	jmp    1450 <printf+0x45>
    }
  }
}
    15d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15d6:	5b                   	pop    %ebx
    15d7:	5e                   	pop    %esi
    15d8:	5f                   	pop    %edi
    15d9:	5d                   	pop    %ebp
    15da:	c3                   	ret    

000015db <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15db:	55                   	push   %ebp
    15dc:	89 e5                	mov    %esp,%ebp
    15de:	57                   	push   %edi
    15df:	56                   	push   %esi
    15e0:	53                   	push   %ebx
    15e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15e4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15e7:	a1 c4 19 00 00       	mov    0x19c4,%eax
    15ec:	eb 0c                	jmp    15fa <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15ee:	8b 10                	mov    (%eax),%edx
    15f0:	39 c2                	cmp    %eax,%edx
    15f2:	77 04                	ja     15f8 <free+0x1d>
    15f4:	39 ca                	cmp    %ecx,%edx
    15f6:	77 10                	ja     1608 <free+0x2d>
{
    15f8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15fa:	39 c8                	cmp    %ecx,%eax
    15fc:	73 f0                	jae    15ee <free+0x13>
    15fe:	8b 10                	mov    (%eax),%edx
    1600:	39 ca                	cmp    %ecx,%edx
    1602:	77 04                	ja     1608 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1604:	39 c2                	cmp    %eax,%edx
    1606:	77 f0                	ja     15f8 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1608:	8b 73 fc             	mov    -0x4(%ebx),%esi
    160b:	8b 10                	mov    (%eax),%edx
    160d:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1610:	39 fa                	cmp    %edi,%edx
    1612:	74 19                	je     162d <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1614:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1617:	8b 50 04             	mov    0x4(%eax),%edx
    161a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    161d:	39 f1                	cmp    %esi,%ecx
    161f:	74 1b                	je     163c <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1621:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1623:	a3 c4 19 00 00       	mov    %eax,0x19c4
}
    1628:	5b                   	pop    %ebx
    1629:	5e                   	pop    %esi
    162a:	5f                   	pop    %edi
    162b:	5d                   	pop    %ebp
    162c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    162d:	03 72 04             	add    0x4(%edx),%esi
    1630:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1633:	8b 10                	mov    (%eax),%edx
    1635:	8b 12                	mov    (%edx),%edx
    1637:	89 53 f8             	mov    %edx,-0x8(%ebx)
    163a:	eb db                	jmp    1617 <free+0x3c>
    p->s.size += bp->s.size;
    163c:	03 53 fc             	add    -0x4(%ebx),%edx
    163f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1642:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1645:	89 10                	mov    %edx,(%eax)
    1647:	eb da                	jmp    1623 <free+0x48>

00001649 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1649:	55                   	push   %ebp
    164a:	89 e5                	mov    %esp,%ebp
    164c:	57                   	push   %edi
    164d:	56                   	push   %esi
    164e:	53                   	push   %ebx
    164f:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1652:	8b 45 08             	mov    0x8(%ebp),%eax
    1655:	8d 58 07             	lea    0x7(%eax),%ebx
    1658:	c1 eb 03             	shr    $0x3,%ebx
    165b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    165e:	8b 15 c4 19 00 00    	mov    0x19c4,%edx
    1664:	85 d2                	test   %edx,%edx
    1666:	74 20                	je     1688 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1668:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    166a:	8b 48 04             	mov    0x4(%eax),%ecx
    166d:	39 cb                	cmp    %ecx,%ebx
    166f:	76 3c                	jbe    16ad <malloc+0x64>
    1671:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1677:	be 00 10 00 00       	mov    $0x1000,%esi
    167c:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    167f:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    1686:	eb 70                	jmp    16f8 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1688:	c7 05 c4 19 00 00 c8 	movl   $0x19c8,0x19c4
    168f:	19 00 00 
    1692:	c7 05 c8 19 00 00 c8 	movl   $0x19c8,0x19c8
    1699:	19 00 00 
    base.s.size = 0;
    169c:	c7 05 cc 19 00 00 00 	movl   $0x0,0x19cc
    16a3:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    16a6:	ba c8 19 00 00       	mov    $0x19c8,%edx
    16ab:	eb bb                	jmp    1668 <malloc+0x1f>
      if(p->s.size == nunits)
    16ad:	39 cb                	cmp    %ecx,%ebx
    16af:	74 1c                	je     16cd <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    16b1:	29 d9                	sub    %ebx,%ecx
    16b3:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    16b6:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    16b9:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    16bc:	89 15 c4 19 00 00    	mov    %edx,0x19c4
      return (void*)(p + 1);
    16c2:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    16c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    16c8:	5b                   	pop    %ebx
    16c9:	5e                   	pop    %esi
    16ca:	5f                   	pop    %edi
    16cb:	5d                   	pop    %ebp
    16cc:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    16cd:	8b 08                	mov    (%eax),%ecx
    16cf:	89 0a                	mov    %ecx,(%edx)
    16d1:	eb e9                	jmp    16bc <malloc+0x73>
  hp->s.size = nu;
    16d3:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    16d6:	83 ec 0c             	sub    $0xc,%esp
    16d9:	83 c0 08             	add    $0x8,%eax
    16dc:	50                   	push   %eax
    16dd:	e8 f9 fe ff ff       	call   15db <free>
  return freep;
    16e2:	8b 15 c4 19 00 00    	mov    0x19c4,%edx
      if((p = morecore(nunits)) == 0)
    16e8:	83 c4 10             	add    $0x10,%esp
    16eb:	85 d2                	test   %edx,%edx
    16ed:	74 2b                	je     171a <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16ef:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16f1:	8b 48 04             	mov    0x4(%eax),%ecx
    16f4:	39 d9                	cmp    %ebx,%ecx
    16f6:	73 b5                	jae    16ad <malloc+0x64>
    16f8:	89 c2                	mov    %eax,%edx
    if(p == freep)
    16fa:	39 05 c4 19 00 00    	cmp    %eax,0x19c4
    1700:	75 ed                	jne    16ef <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1702:	83 ec 0c             	sub    $0xc,%esp
    1705:	57                   	push   %edi
    1706:	e8 4e fc ff ff       	call   1359 <sbrk>
  if(p == (char*)-1)
    170b:	83 c4 10             	add    $0x10,%esp
    170e:	83 f8 ff             	cmp    $0xffffffff,%eax
    1711:	75 c0                	jne    16d3 <malloc+0x8a>
        return 0;
    1713:	b8 00 00 00 00       	mov    $0x0,%eax
    1718:	eb ab                	jmp    16c5 <malloc+0x7c>
    171a:	b8 00 00 00 00       	mov    $0x0,%eax
    171f:	eb a4                	jmp    16c5 <malloc+0x7c>
