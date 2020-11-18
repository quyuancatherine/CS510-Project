
_testsharemem:     file format elf32-i386


Disassembly of section .text:

00001000 <failure_msg>:
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

void failure_msg(void){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 10             	sub    $0x10,%esp
    printf(1," TEST FAILED\n");
    1006:	68 5c 17 00 00       	push   $0x175c
    100b:	6a 01                	push   $0x1
    100d:	e8 34 04 00 00       	call   1446 <printf>
    exit();
    1012:	e8 f5 02 00 00       	call   130c <exit>

00001017 <main>:
}

int main(){
    1017:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    101b:	83 e4 f0             	and    $0xfffffff0,%esp
    101e:	ff 71 fc             	pushl  -0x4(%ecx)
    1021:	55                   	push   %ebp
    1022:	89 e5                	mov    %esp,%ebp
    1024:	56                   	push   %esi
    1025:	53                   	push   %ebx
    1026:	51                   	push   %ecx
    1027:	83 ec 1c             	sub    $0x1c,%esp
    
    char *test;
    char value = 'a';
    102a:	c6 45 e7 61          	movb   $0x61,-0x19(%ebp)
    char *compare = &value;
    int pid = -1;

    if ((pid = fork()) ==0 ) {
    102e:	e8 d1 02 00 00       	call   1304 <fork>
    1033:	89 c3                	mov    %eax,%ebx
    1035:	85 c0                	test   %eax,%eax
    1037:	0f 85 bd 00 00 00    	jne    10fa <main+0xe3>
        //create first child

        if (fork() ==0 ) {
    103d:	e8 c2 02 00 00       	call   1304 <fork>
    1042:	85 c0                	test   %eax,%eax
    1044:	74 63                	je     10a9 <main+0x92>
            *test = 'b';
            *compare = 'c';
            printf(1,"The grand child address is %x, test value:%c, compare: %x, compare's value: %c\n",test,*test, compare,*compare);
        }

        wait();
    1046:	e8 c9 02 00 00       	call   1314 <wait>
        test = (char*)shmem_access(0);
    104b:	83 ec 0c             	sub    $0xc,%esp
    104e:	6a 00                	push   $0x0
    1050:	e8 57 03 00 00       	call   13ac <shmem_access>
    1055:	89 c6                	mov    %eax,%esi
        int first_child_count = shmem_count(0);
    1057:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    105e:	e8 51 03 00 00       	call   13b4 <shmem_count>
        printf(1,"First child create by using number zero share page and share by %d processes\n", first_child_count);
    1063:	83 c4 0c             	add    $0xc,%esp
    1066:	50                   	push   %eax
    1067:	68 14 18 00 00       	push   $0x1814
    106c:	6a 01                	push   $0x1
    106e:	e8 d3 03 00 00       	call   1446 <printf>
        *test = 'd';
    1073:	c6 06 64             	movb   $0x64,(%esi)
        printf(1,"The first child address is %x, test value:%c, compare: %x, compare's value: %c\n",test,*test, compare,*compare);
    1076:	83 c4 08             	add    $0x8,%esp
    1079:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
    107d:	50                   	push   %eax
    107e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1081:	50                   	push   %eax
    1082:	6a 64                	push   $0x64
    1084:	56                   	push   %esi
    1085:	68 64 18 00 00       	push   $0x1864
    108a:	6a 01                	push   $0x1
    108c:	e8 b5 03 00 00       	call   1446 <printf>
    1091:	83 c4 20             	add    $0x20,%esp
        test = (char*)shmem_access(0);
        int father_count = shmem_count(0);
        printf(1,"Father process create by using number zero share page and share by %d processes\n", father_count);
        printf(1,"The parent process address is %x, test value:%c, compare: %x, compare's value: %c\n",test,*test, compare,*compare);
    }
    printf(1,"pid:%d\n", pid);
    1094:	83 ec 04             	sub    $0x4,%esp
    1097:	53                   	push   %ebx
    1098:	68 6a 17 00 00       	push   $0x176a
    109d:	6a 01                	push   $0x1
    109f:	e8 a2 03 00 00       	call   1446 <printf>
    exit();
    10a4:	e8 63 02 00 00       	call   130c <exit>
            test = (char*)shmem_access(0);
    10a9:	83 ec 0c             	sub    $0xc,%esp
    10ac:	6a 00                	push   $0x0
    10ae:	e8 f9 02 00 00       	call   13ac <shmem_access>
    10b3:	89 c6                	mov    %eax,%esi
            int grand_child_count = shmem_count(0);
    10b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10bc:	e8 f3 02 00 00       	call   13b4 <shmem_count>
            printf(1,"Grand child create by using number zero share page and share by %d processes\n", grand_child_count);
    10c1:	83 c4 0c             	add    $0xc,%esp
    10c4:	50                   	push   %eax
    10c5:	68 74 17 00 00       	push   $0x1774
    10ca:	6a 01                	push   $0x1
    10cc:	e8 75 03 00 00       	call   1446 <printf>
            *test = 'b';
    10d1:	c6 06 62             	movb   $0x62,(%esi)
            *compare = 'c';
    10d4:	c6 45 e7 63          	movb   $0x63,-0x19(%ebp)
            printf(1,"The grand child address is %x, test value:%c, compare: %x, compare's value: %c\n",test,*test, compare,*compare);
    10d8:	83 c4 08             	add    $0x8,%esp
    10db:	6a 63                	push   $0x63
    10dd:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10e0:	50                   	push   %eax
    10e1:	0f be 06             	movsbl (%esi),%eax
    10e4:	50                   	push   %eax
    10e5:	56                   	push   %esi
    10e6:	68 c4 17 00 00       	push   $0x17c4
    10eb:	6a 01                	push   $0x1
    10ed:	e8 54 03 00 00       	call   1446 <printf>
    10f2:	83 c4 20             	add    $0x20,%esp
    10f5:	e9 4c ff ff ff       	jmp    1046 <main+0x2f>
        wait();
    10fa:	e8 15 02 00 00       	call   1314 <wait>
        test = (char*)shmem_access(0);
    10ff:	83 ec 0c             	sub    $0xc,%esp
    1102:	6a 00                	push   $0x0
    1104:	e8 a3 02 00 00       	call   13ac <shmem_access>
    1109:	89 c6                	mov    %eax,%esi
        int father_count = shmem_count(0);
    110b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1112:	e8 9d 02 00 00       	call   13b4 <shmem_count>
        printf(1,"Father process create by using number zero share page and share by %d processes\n", father_count);
    1117:	83 c4 0c             	add    $0xc,%esp
    111a:	50                   	push   %eax
    111b:	68 b4 18 00 00       	push   $0x18b4
    1120:	6a 01                	push   $0x1
    1122:	e8 1f 03 00 00       	call   1446 <printf>
        printf(1,"The parent process address is %x, test value:%c, compare: %x, compare's value: %c\n",test,*test, compare,*compare);
    1127:	83 c4 08             	add    $0x8,%esp
    112a:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
    112e:	50                   	push   %eax
    112f:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1132:	50                   	push   %eax
    1133:	0f be 06             	movsbl (%esi),%eax
    1136:	50                   	push   %eax
    1137:	56                   	push   %esi
    1138:	68 08 19 00 00       	push   $0x1908
    113d:	6a 01                	push   $0x1
    113f:	e8 02 03 00 00       	call   1446 <printf>
    1144:	83 c4 20             	add    $0x20,%esp
    1147:	e9 48 ff ff ff       	jmp    1094 <main+0x7d>

0000114c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    114c:	55                   	push   %ebp
    114d:	89 e5                	mov    %esp,%ebp
    114f:	53                   	push   %ebx
    1150:	8b 45 08             	mov    0x8(%ebp),%eax
    1153:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1156:	89 c2                	mov    %eax,%edx
    1158:	83 c1 01             	add    $0x1,%ecx
    115b:	83 c2 01             	add    $0x1,%edx
    115e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1162:	88 5a ff             	mov    %bl,-0x1(%edx)
    1165:	84 db                	test   %bl,%bl
    1167:	75 ef                	jne    1158 <strcpy+0xc>
    ;
  return os;
}
    1169:	5b                   	pop    %ebx
    116a:	5d                   	pop    %ebp
    116b:	c3                   	ret    

0000116c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    116c:	55                   	push   %ebp
    116d:	89 e5                	mov    %esp,%ebp
    116f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1172:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1175:	0f b6 01             	movzbl (%ecx),%eax
    1178:	84 c0                	test   %al,%al
    117a:	74 15                	je     1191 <strcmp+0x25>
    117c:	3a 02                	cmp    (%edx),%al
    117e:	75 11                	jne    1191 <strcmp+0x25>
    p++, q++;
    1180:	83 c1 01             	add    $0x1,%ecx
    1183:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1186:	0f b6 01             	movzbl (%ecx),%eax
    1189:	84 c0                	test   %al,%al
    118b:	74 04                	je     1191 <strcmp+0x25>
    118d:	3a 02                	cmp    (%edx),%al
    118f:	74 ef                	je     1180 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1191:	0f b6 c0             	movzbl %al,%eax
    1194:	0f b6 12             	movzbl (%edx),%edx
    1197:	29 d0                	sub    %edx,%eax
}
    1199:	5d                   	pop    %ebp
    119a:	c3                   	ret    

0000119b <strlen>:

uint
strlen(const char *s)
{
    119b:	55                   	push   %ebp
    119c:	89 e5                	mov    %esp,%ebp
    119e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    11a1:	80 39 00             	cmpb   $0x0,(%ecx)
    11a4:	74 12                	je     11b8 <strlen+0x1d>
    11a6:	ba 00 00 00 00       	mov    $0x0,%edx
    11ab:	83 c2 01             	add    $0x1,%edx
    11ae:	89 d0                	mov    %edx,%eax
    11b0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    11b4:	75 f5                	jne    11ab <strlen+0x10>
    ;
  return n;
}
    11b6:	5d                   	pop    %ebp
    11b7:	c3                   	ret    
  for(n = 0; s[n]; n++)
    11b8:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11bd:	eb f7                	jmp    11b6 <strlen+0x1b>

000011bf <memset>:

void*
memset(void *dst, int c, uint n)
{
    11bf:	55                   	push   %ebp
    11c0:	89 e5                	mov    %esp,%ebp
    11c2:	57                   	push   %edi
    11c3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11c6:	89 d7                	mov    %edx,%edi
    11c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ce:	fc                   	cld    
    11cf:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11d1:	89 d0                	mov    %edx,%eax
    11d3:	5f                   	pop    %edi
    11d4:	5d                   	pop    %ebp
    11d5:	c3                   	ret    

000011d6 <strchr>:

char*
strchr(const char *s, char c)
{
    11d6:	55                   	push   %ebp
    11d7:	89 e5                	mov    %esp,%ebp
    11d9:	53                   	push   %ebx
    11da:	8b 45 08             	mov    0x8(%ebp),%eax
    11dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    11e0:	0f b6 10             	movzbl (%eax),%edx
    11e3:	84 d2                	test   %dl,%dl
    11e5:	74 1e                	je     1205 <strchr+0x2f>
    11e7:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    11e9:	38 d3                	cmp    %dl,%bl
    11eb:	74 15                	je     1202 <strchr+0x2c>
  for(; *s; s++)
    11ed:	83 c0 01             	add    $0x1,%eax
    11f0:	0f b6 10             	movzbl (%eax),%edx
    11f3:	84 d2                	test   %dl,%dl
    11f5:	74 06                	je     11fd <strchr+0x27>
    if(*s == c)
    11f7:	38 ca                	cmp    %cl,%dl
    11f9:	75 f2                	jne    11ed <strchr+0x17>
    11fb:	eb 05                	jmp    1202 <strchr+0x2c>
      return (char*)s;
  return 0;
    11fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1202:	5b                   	pop    %ebx
    1203:	5d                   	pop    %ebp
    1204:	c3                   	ret    
  return 0;
    1205:	b8 00 00 00 00       	mov    $0x0,%eax
    120a:	eb f6                	jmp    1202 <strchr+0x2c>

0000120c <gets>:

char*
gets(char *buf, int max)
{
    120c:	55                   	push   %ebp
    120d:	89 e5                	mov    %esp,%ebp
    120f:	57                   	push   %edi
    1210:	56                   	push   %esi
    1211:	53                   	push   %ebx
    1212:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1215:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    121a:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    121d:	8d 5e 01             	lea    0x1(%esi),%ebx
    1220:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1223:	7d 2b                	jge    1250 <gets+0x44>
    cc = read(0, &c, 1);
    1225:	83 ec 04             	sub    $0x4,%esp
    1228:	6a 01                	push   $0x1
    122a:	57                   	push   %edi
    122b:	6a 00                	push   $0x0
    122d:	e8 f2 00 00 00       	call   1324 <read>
    if(cc < 1)
    1232:	83 c4 10             	add    $0x10,%esp
    1235:	85 c0                	test   %eax,%eax
    1237:	7e 17                	jle    1250 <gets+0x44>
      break;
    buf[i++] = c;
    1239:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    123d:	8b 55 08             	mov    0x8(%ebp),%edx
    1240:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1244:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1246:	3c 0a                	cmp    $0xa,%al
    1248:	74 04                	je     124e <gets+0x42>
    124a:	3c 0d                	cmp    $0xd,%al
    124c:	75 cf                	jne    121d <gets+0x11>
  for(i=0; i+1 < max; ){
    124e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1250:	8b 45 08             	mov    0x8(%ebp),%eax
    1253:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1257:	8d 65 f4             	lea    -0xc(%ebp),%esp
    125a:	5b                   	pop    %ebx
    125b:	5e                   	pop    %esi
    125c:	5f                   	pop    %edi
    125d:	5d                   	pop    %ebp
    125e:	c3                   	ret    

0000125f <stat>:

int
stat(const char *n, struct stat *st)
{
    125f:	55                   	push   %ebp
    1260:	89 e5                	mov    %esp,%ebp
    1262:	56                   	push   %esi
    1263:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1264:	83 ec 08             	sub    $0x8,%esp
    1267:	6a 00                	push   $0x0
    1269:	ff 75 08             	pushl  0x8(%ebp)
    126c:	e8 db 00 00 00       	call   134c <open>
  if(fd < 0)
    1271:	83 c4 10             	add    $0x10,%esp
    1274:	85 c0                	test   %eax,%eax
    1276:	78 24                	js     129c <stat+0x3d>
    1278:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    127a:	83 ec 08             	sub    $0x8,%esp
    127d:	ff 75 0c             	pushl  0xc(%ebp)
    1280:	50                   	push   %eax
    1281:	e8 de 00 00 00       	call   1364 <fstat>
    1286:	89 c6                	mov    %eax,%esi
  close(fd);
    1288:	89 1c 24             	mov    %ebx,(%esp)
    128b:	e8 a4 00 00 00       	call   1334 <close>
  return r;
    1290:	83 c4 10             	add    $0x10,%esp
}
    1293:	89 f0                	mov    %esi,%eax
    1295:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1298:	5b                   	pop    %ebx
    1299:	5e                   	pop    %esi
    129a:	5d                   	pop    %ebp
    129b:	c3                   	ret    
    return -1;
    129c:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12a1:	eb f0                	jmp    1293 <stat+0x34>

000012a3 <atoi>:

int
atoi(const char *s)
{
    12a3:	55                   	push   %ebp
    12a4:	89 e5                	mov    %esp,%ebp
    12a6:	53                   	push   %ebx
    12a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12aa:	0f b6 11             	movzbl (%ecx),%edx
    12ad:	8d 42 d0             	lea    -0x30(%edx),%eax
    12b0:	3c 09                	cmp    $0x9,%al
    12b2:	77 20                	ja     12d4 <atoi+0x31>
  n = 0;
    12b4:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    12b9:	83 c1 01             	add    $0x1,%ecx
    12bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
    12bf:	0f be d2             	movsbl %dl,%edx
    12c2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    12c6:	0f b6 11             	movzbl (%ecx),%edx
    12c9:	8d 5a d0             	lea    -0x30(%edx),%ebx
    12cc:	80 fb 09             	cmp    $0x9,%bl
    12cf:	76 e8                	jbe    12b9 <atoi+0x16>
  return n;
}
    12d1:	5b                   	pop    %ebx
    12d2:	5d                   	pop    %ebp
    12d3:	c3                   	ret    
  n = 0;
    12d4:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    12d9:	eb f6                	jmp    12d1 <atoi+0x2e>

000012db <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12db:	55                   	push   %ebp
    12dc:	89 e5                	mov    %esp,%ebp
    12de:	56                   	push   %esi
    12df:	53                   	push   %ebx
    12e0:	8b 45 08             	mov    0x8(%ebp),%eax
    12e3:	8b 75 0c             	mov    0xc(%ebp),%esi
    12e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12e9:	85 db                	test   %ebx,%ebx
    12eb:	7e 13                	jle    1300 <memmove+0x25>
    12ed:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    12f2:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    12f6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    12f9:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    12fc:	39 d3                	cmp    %edx,%ebx
    12fe:	75 f2                	jne    12f2 <memmove+0x17>
  return vdst;
}
    1300:	5b                   	pop    %ebx
    1301:	5e                   	pop    %esi
    1302:	5d                   	pop    %ebp
    1303:	c3                   	ret    

00001304 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1304:	b8 01 00 00 00       	mov    $0x1,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <exit>:
SYSCALL(exit)
    130c:	b8 02 00 00 00       	mov    $0x2,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <wait>:
SYSCALL(wait)
    1314:	b8 03 00 00 00       	mov    $0x3,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <pipe>:
SYSCALL(pipe)
    131c:	b8 04 00 00 00       	mov    $0x4,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <read>:
SYSCALL(read)
    1324:	b8 05 00 00 00       	mov    $0x5,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <write>:
SYSCALL(write)
    132c:	b8 10 00 00 00       	mov    $0x10,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <close>:
SYSCALL(close)
    1334:	b8 15 00 00 00       	mov    $0x15,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <kill>:
SYSCALL(kill)
    133c:	b8 06 00 00 00       	mov    $0x6,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <exec>:
SYSCALL(exec)
    1344:	b8 07 00 00 00       	mov    $0x7,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <open>:
SYSCALL(open)
    134c:	b8 0f 00 00 00       	mov    $0xf,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <mknod>:
SYSCALL(mknod)
    1354:	b8 11 00 00 00       	mov    $0x11,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <unlink>:
SYSCALL(unlink)
    135c:	b8 12 00 00 00       	mov    $0x12,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <fstat>:
SYSCALL(fstat)
    1364:	b8 08 00 00 00       	mov    $0x8,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <link>:
SYSCALL(link)
    136c:	b8 13 00 00 00       	mov    $0x13,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <mkdir>:
SYSCALL(mkdir)
    1374:	b8 14 00 00 00       	mov    $0x14,%eax
    1379:	cd 40                	int    $0x40
    137b:	c3                   	ret    

0000137c <chdir>:
SYSCALL(chdir)
    137c:	b8 09 00 00 00       	mov    $0x9,%eax
    1381:	cd 40                	int    $0x40
    1383:	c3                   	ret    

00001384 <dup>:
SYSCALL(dup)
    1384:	b8 0a 00 00 00       	mov    $0xa,%eax
    1389:	cd 40                	int    $0x40
    138b:	c3                   	ret    

0000138c <getpid>:
SYSCALL(getpid)
    138c:	b8 0b 00 00 00       	mov    $0xb,%eax
    1391:	cd 40                	int    $0x40
    1393:	c3                   	ret    

00001394 <sbrk>:
SYSCALL(sbrk)
    1394:	b8 0c 00 00 00       	mov    $0xc,%eax
    1399:	cd 40                	int    $0x40
    139b:	c3                   	ret    

0000139c <sleep>:
SYSCALL(sleep)
    139c:	b8 0d 00 00 00       	mov    $0xd,%eax
    13a1:	cd 40                	int    $0x40
    13a3:	c3                   	ret    

000013a4 <uptime>:
SYSCALL(uptime)
    13a4:	b8 0e 00 00 00       	mov    $0xe,%eax
    13a9:	cd 40                	int    $0x40
    13ab:	c3                   	ret    

000013ac <shmem_access>:
SYSCALL(shmem_access)
    13ac:	b8 16 00 00 00       	mov    $0x16,%eax
    13b1:	cd 40                	int    $0x40
    13b3:	c3                   	ret    

000013b4 <shmem_count>:
    13b4:	b8 17 00 00 00       	mov    $0x17,%eax
    13b9:	cd 40                	int    $0x40
    13bb:	c3                   	ret    

000013bc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    13bc:	55                   	push   %ebp
    13bd:	89 e5                	mov    %esp,%ebp
    13bf:	57                   	push   %edi
    13c0:	56                   	push   %esi
    13c1:	53                   	push   %ebx
    13c2:	83 ec 3c             	sub    $0x3c,%esp
    13c5:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    13cb:	74 14                	je     13e1 <printint+0x25>
    13cd:	85 d2                	test   %edx,%edx
    13cf:	79 10                	jns    13e1 <printint+0x25>
    neg = 1;
    x = -xx;
    13d1:	f7 da                	neg    %edx
    neg = 1;
    13d3:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    13da:	bf 00 00 00 00       	mov    $0x0,%edi
    13df:	eb 0b                	jmp    13ec <printint+0x30>
  neg = 0;
    13e1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    13e8:	eb f0                	jmp    13da <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    13ea:	89 df                	mov    %ebx,%edi
    13ec:	8d 5f 01             	lea    0x1(%edi),%ebx
    13ef:	89 d0                	mov    %edx,%eax
    13f1:	ba 00 00 00 00       	mov    $0x0,%edx
    13f6:	f7 f1                	div    %ecx
    13f8:	0f b6 92 64 19 00 00 	movzbl 0x1964(%edx),%edx
    13ff:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1403:	89 c2                	mov    %eax,%edx
    1405:	85 c0                	test   %eax,%eax
    1407:	75 e1                	jne    13ea <printint+0x2e>
  if(neg)
    1409:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    140d:	74 08                	je     1417 <printint+0x5b>
    buf[i++] = '-';
    140f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1414:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1417:	83 eb 01             	sub    $0x1,%ebx
    141a:	78 22                	js     143e <printint+0x82>
  write(fd, &c, 1);
    141c:	8d 7d d7             	lea    -0x29(%ebp),%edi
    141f:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1424:	88 45 d7             	mov    %al,-0x29(%ebp)
    1427:	83 ec 04             	sub    $0x4,%esp
    142a:	6a 01                	push   $0x1
    142c:	57                   	push   %edi
    142d:	56                   	push   %esi
    142e:	e8 f9 fe ff ff       	call   132c <write>
  while(--i >= 0)
    1433:	83 eb 01             	sub    $0x1,%ebx
    1436:	83 c4 10             	add    $0x10,%esp
    1439:	83 fb ff             	cmp    $0xffffffff,%ebx
    143c:	75 e1                	jne    141f <printint+0x63>
    putc(fd, buf[i]);
}
    143e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1441:	5b                   	pop    %ebx
    1442:	5e                   	pop    %esi
    1443:	5f                   	pop    %edi
    1444:	5d                   	pop    %ebp
    1445:	c3                   	ret    

00001446 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1446:	55                   	push   %ebp
    1447:	89 e5                	mov    %esp,%ebp
    1449:	57                   	push   %edi
    144a:	56                   	push   %esi
    144b:	53                   	push   %ebx
    144c:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    144f:	8b 75 0c             	mov    0xc(%ebp),%esi
    1452:	0f b6 1e             	movzbl (%esi),%ebx
    1455:	84 db                	test   %bl,%bl
    1457:	0f 84 b1 01 00 00    	je     160e <printf+0x1c8>
    145d:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    1460:	8d 45 10             	lea    0x10(%ebp),%eax
    1463:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1466:	bf 00 00 00 00       	mov    $0x0,%edi
    146b:	eb 2d                	jmp    149a <printf+0x54>
    146d:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1470:	83 ec 04             	sub    $0x4,%esp
    1473:	6a 01                	push   $0x1
    1475:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1478:	50                   	push   %eax
    1479:	ff 75 08             	pushl  0x8(%ebp)
    147c:	e8 ab fe ff ff       	call   132c <write>
    1481:	83 c4 10             	add    $0x10,%esp
    1484:	eb 05                	jmp    148b <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1486:	83 ff 25             	cmp    $0x25,%edi
    1489:	74 22                	je     14ad <printf+0x67>
    148b:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    148e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1492:	84 db                	test   %bl,%bl
    1494:	0f 84 74 01 00 00    	je     160e <printf+0x1c8>
    c = fmt[i] & 0xff;
    149a:	0f be d3             	movsbl %bl,%edx
    149d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    14a0:	85 ff                	test   %edi,%edi
    14a2:	75 e2                	jne    1486 <printf+0x40>
      if(c == '%'){
    14a4:	83 f8 25             	cmp    $0x25,%eax
    14a7:	75 c4                	jne    146d <printf+0x27>
        state = '%';
    14a9:	89 c7                	mov    %eax,%edi
    14ab:	eb de                	jmp    148b <printf+0x45>
      if(c == 'd'){
    14ad:	83 f8 64             	cmp    $0x64,%eax
    14b0:	74 59                	je     150b <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    14b2:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    14b8:	83 fa 70             	cmp    $0x70,%edx
    14bb:	74 7a                	je     1537 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    14bd:	83 f8 73             	cmp    $0x73,%eax
    14c0:	0f 84 9d 00 00 00    	je     1563 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14c6:	83 f8 63             	cmp    $0x63,%eax
    14c9:	0f 84 f2 00 00 00    	je     15c1 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    14cf:	83 f8 25             	cmp    $0x25,%eax
    14d2:	0f 84 15 01 00 00    	je     15ed <printf+0x1a7>
    14d8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    14dc:	83 ec 04             	sub    $0x4,%esp
    14df:	6a 01                	push   $0x1
    14e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
    14e4:	50                   	push   %eax
    14e5:	ff 75 08             	pushl  0x8(%ebp)
    14e8:	e8 3f fe ff ff       	call   132c <write>
    14ed:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    14f0:	83 c4 0c             	add    $0xc,%esp
    14f3:	6a 01                	push   $0x1
    14f5:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    14f8:	50                   	push   %eax
    14f9:	ff 75 08             	pushl  0x8(%ebp)
    14fc:	e8 2b fe ff ff       	call   132c <write>
    1501:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1504:	bf 00 00 00 00       	mov    $0x0,%edi
    1509:	eb 80                	jmp    148b <printf+0x45>
        printint(fd, *ap, 10, 1);
    150b:	83 ec 0c             	sub    $0xc,%esp
    150e:	6a 01                	push   $0x1
    1510:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1515:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1518:	8b 17                	mov    (%edi),%edx
    151a:	8b 45 08             	mov    0x8(%ebp),%eax
    151d:	e8 9a fe ff ff       	call   13bc <printint>
        ap++;
    1522:	89 f8                	mov    %edi,%eax
    1524:	83 c0 04             	add    $0x4,%eax
    1527:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    152a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    152d:	bf 00 00 00 00       	mov    $0x0,%edi
    1532:	e9 54 ff ff ff       	jmp    148b <printf+0x45>
        printint(fd, *ap, 16, 0);
    1537:	83 ec 0c             	sub    $0xc,%esp
    153a:	6a 00                	push   $0x0
    153c:	b9 10 00 00 00       	mov    $0x10,%ecx
    1541:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1544:	8b 17                	mov    (%edi),%edx
    1546:	8b 45 08             	mov    0x8(%ebp),%eax
    1549:	e8 6e fe ff ff       	call   13bc <printint>
        ap++;
    154e:	89 f8                	mov    %edi,%eax
    1550:	83 c0 04             	add    $0x4,%eax
    1553:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1556:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1559:	bf 00 00 00 00       	mov    $0x0,%edi
    155e:	e9 28 ff ff ff       	jmp    148b <printf+0x45>
        s = (char*)*ap;
    1563:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1566:	8b 01                	mov    (%ecx),%eax
        ap++;
    1568:	83 c1 04             	add    $0x4,%ecx
    156b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    156e:	85 c0                	test   %eax,%eax
    1570:	74 13                	je     1585 <printf+0x13f>
        s = (char*)*ap;
    1572:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1574:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1577:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    157c:	84 c0                	test   %al,%al
    157e:	75 0f                	jne    158f <printf+0x149>
    1580:	e9 06 ff ff ff       	jmp    148b <printf+0x45>
          s = "(null)";
    1585:	bb 5c 19 00 00       	mov    $0x195c,%ebx
        while(*s != 0){
    158a:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    158f:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1592:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1595:	8b 75 08             	mov    0x8(%ebp),%esi
    1598:	88 45 e3             	mov    %al,-0x1d(%ebp)
    159b:	83 ec 04             	sub    $0x4,%esp
    159e:	6a 01                	push   $0x1
    15a0:	57                   	push   %edi
    15a1:	56                   	push   %esi
    15a2:	e8 85 fd ff ff       	call   132c <write>
          s++;
    15a7:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    15aa:	0f b6 03             	movzbl (%ebx),%eax
    15ad:	83 c4 10             	add    $0x10,%esp
    15b0:	84 c0                	test   %al,%al
    15b2:	75 e4                	jne    1598 <printf+0x152>
    15b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    15b7:	bf 00 00 00 00       	mov    $0x0,%edi
    15bc:	e9 ca fe ff ff       	jmp    148b <printf+0x45>
        putc(fd, *ap);
    15c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    15c4:	8b 07                	mov    (%edi),%eax
    15c6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    15c9:	83 ec 04             	sub    $0x4,%esp
    15cc:	6a 01                	push   $0x1
    15ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    15d1:	50                   	push   %eax
    15d2:	ff 75 08             	pushl  0x8(%ebp)
    15d5:	e8 52 fd ff ff       	call   132c <write>
        ap++;
    15da:	83 c7 04             	add    $0x4,%edi
    15dd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    15e0:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15e3:	bf 00 00 00 00       	mov    $0x0,%edi
    15e8:	e9 9e fe ff ff       	jmp    148b <printf+0x45>
    15ed:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    15f0:	83 ec 04             	sub    $0x4,%esp
    15f3:	6a 01                	push   $0x1
    15f5:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    15f8:	50                   	push   %eax
    15f9:	ff 75 08             	pushl  0x8(%ebp)
    15fc:	e8 2b fd ff ff       	call   132c <write>
    1601:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1604:	bf 00 00 00 00       	mov    $0x0,%edi
    1609:	e9 7d fe ff ff       	jmp    148b <printf+0x45>
    }
  }
}
    160e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1611:	5b                   	pop    %ebx
    1612:	5e                   	pop    %esi
    1613:	5f                   	pop    %edi
    1614:	5d                   	pop    %ebp
    1615:	c3                   	ret    

00001616 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1616:	55                   	push   %ebp
    1617:	89 e5                	mov    %esp,%ebp
    1619:	57                   	push   %edi
    161a:	56                   	push   %esi
    161b:	53                   	push   %ebx
    161c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    161f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1622:	a1 f0 1b 00 00       	mov    0x1bf0,%eax
    1627:	eb 0c                	jmp    1635 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1629:	8b 10                	mov    (%eax),%edx
    162b:	39 c2                	cmp    %eax,%edx
    162d:	77 04                	ja     1633 <free+0x1d>
    162f:	39 ca                	cmp    %ecx,%edx
    1631:	77 10                	ja     1643 <free+0x2d>
{
    1633:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1635:	39 c8                	cmp    %ecx,%eax
    1637:	73 f0                	jae    1629 <free+0x13>
    1639:	8b 10                	mov    (%eax),%edx
    163b:	39 ca                	cmp    %ecx,%edx
    163d:	77 04                	ja     1643 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    163f:	39 c2                	cmp    %eax,%edx
    1641:	77 f0                	ja     1633 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1643:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1646:	8b 10                	mov    (%eax),%edx
    1648:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    164b:	39 fa                	cmp    %edi,%edx
    164d:	74 19                	je     1668 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    164f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1652:	8b 50 04             	mov    0x4(%eax),%edx
    1655:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1658:	39 f1                	cmp    %esi,%ecx
    165a:	74 1b                	je     1677 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    165c:	89 08                	mov    %ecx,(%eax)
  freep = p;
    165e:	a3 f0 1b 00 00       	mov    %eax,0x1bf0
}
    1663:	5b                   	pop    %ebx
    1664:	5e                   	pop    %esi
    1665:	5f                   	pop    %edi
    1666:	5d                   	pop    %ebp
    1667:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1668:	03 72 04             	add    0x4(%edx),%esi
    166b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    166e:	8b 10                	mov    (%eax),%edx
    1670:	8b 12                	mov    (%edx),%edx
    1672:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1675:	eb db                	jmp    1652 <free+0x3c>
    p->s.size += bp->s.size;
    1677:	03 53 fc             	add    -0x4(%ebx),%edx
    167a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    167d:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1680:	89 10                	mov    %edx,(%eax)
    1682:	eb da                	jmp    165e <free+0x48>

00001684 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1684:	55                   	push   %ebp
    1685:	89 e5                	mov    %esp,%ebp
    1687:	57                   	push   %edi
    1688:	56                   	push   %esi
    1689:	53                   	push   %ebx
    168a:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    168d:	8b 45 08             	mov    0x8(%ebp),%eax
    1690:	8d 58 07             	lea    0x7(%eax),%ebx
    1693:	c1 eb 03             	shr    $0x3,%ebx
    1696:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1699:	8b 15 f0 1b 00 00    	mov    0x1bf0,%edx
    169f:	85 d2                	test   %edx,%edx
    16a1:	74 20                	je     16c3 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16a5:	8b 48 04             	mov    0x4(%eax),%ecx
    16a8:	39 cb                	cmp    %ecx,%ebx
    16aa:	76 3c                	jbe    16e8 <malloc+0x64>
    16ac:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    16b2:	be 00 10 00 00       	mov    $0x1000,%esi
    16b7:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    16ba:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    16c1:	eb 70                	jmp    1733 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    16c3:	c7 05 f0 1b 00 00 f4 	movl   $0x1bf4,0x1bf0
    16ca:	1b 00 00 
    16cd:	c7 05 f4 1b 00 00 f4 	movl   $0x1bf4,0x1bf4
    16d4:	1b 00 00 
    base.s.size = 0;
    16d7:	c7 05 f8 1b 00 00 00 	movl   $0x0,0x1bf8
    16de:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    16e1:	ba f4 1b 00 00       	mov    $0x1bf4,%edx
    16e6:	eb bb                	jmp    16a3 <malloc+0x1f>
      if(p->s.size == nunits)
    16e8:	39 cb                	cmp    %ecx,%ebx
    16ea:	74 1c                	je     1708 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    16ec:	29 d9                	sub    %ebx,%ecx
    16ee:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    16f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    16f4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    16f7:	89 15 f0 1b 00 00    	mov    %edx,0x1bf0
      return (void*)(p + 1);
    16fd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1700:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1703:	5b                   	pop    %ebx
    1704:	5e                   	pop    %esi
    1705:	5f                   	pop    %edi
    1706:	5d                   	pop    %ebp
    1707:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1708:	8b 08                	mov    (%eax),%ecx
    170a:	89 0a                	mov    %ecx,(%edx)
    170c:	eb e9                	jmp    16f7 <malloc+0x73>
  hp->s.size = nu;
    170e:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1711:	83 ec 0c             	sub    $0xc,%esp
    1714:	83 c0 08             	add    $0x8,%eax
    1717:	50                   	push   %eax
    1718:	e8 f9 fe ff ff       	call   1616 <free>
  return freep;
    171d:	8b 15 f0 1b 00 00    	mov    0x1bf0,%edx
      if((p = morecore(nunits)) == 0)
    1723:	83 c4 10             	add    $0x10,%esp
    1726:	85 d2                	test   %edx,%edx
    1728:	74 2b                	je     1755 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    172a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    172c:	8b 48 04             	mov    0x4(%eax),%ecx
    172f:	39 d9                	cmp    %ebx,%ecx
    1731:	73 b5                	jae    16e8 <malloc+0x64>
    1733:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1735:	39 05 f0 1b 00 00    	cmp    %eax,0x1bf0
    173b:	75 ed                	jne    172a <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    173d:	83 ec 0c             	sub    $0xc,%esp
    1740:	57                   	push   %edi
    1741:	e8 4e fc ff ff       	call   1394 <sbrk>
  if(p == (char*)-1)
    1746:	83 c4 10             	add    $0x10,%esp
    1749:	83 f8 ff             	cmp    $0xffffffff,%eax
    174c:	75 c0                	jne    170e <malloc+0x8a>
        return 0;
    174e:	b8 00 00 00 00       	mov    $0x0,%eax
    1753:	eb ab                	jmp    1700 <malloc+0x7c>
    1755:	b8 00 00 00 00       	mov    $0x0,%eax
    175a:	eb a4                	jmp    1700 <malloc+0x7c>
