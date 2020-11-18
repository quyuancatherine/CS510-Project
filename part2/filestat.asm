
_filestat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1,"Write Test Passed\n");
    w = close(fd);
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 2c             	sub    $0x2c,%esp
  if(argc != 2){
  13:	83 39 02             	cmpl   $0x2,(%ecx)
{
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 2){
  19:	74 13                	je     2e <main+0x2e>
    printf(1, "Format of Input: filestat pathname\n");
  1b:	50                   	push   %eax
  1c:	50                   	push   %eax
  1d:	68 a0 09 00 00       	push   $0x9a0
  22:	6a 01                	push   $0x1
  24:	e8 d7 05 00 00       	call   600 <printf>
    exit();
  29:	e8 74 04 00 00       	call   4a2 <exit>
  }
  writeFile(argv[1]);
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 67 01 00 00       	call   1a0 <writeFile>
  readFile(argv[1]);
  39:	5e                   	pop    %esi
  3a:	ff 73 04             	pushl  0x4(%ebx)
  3d:	e8 fe 00 00 00       	call   140 <readFile>
  printf(1,"TEST PASSED\n");
  42:	58                   	pop    %eax
  43:	5a                   	pop    %edx
  44:	68 49 0a 00 00       	push   $0xa49
  49:	6a 01                	push   $0x1
  4b:	e8 b0 05 00 00       	call   600 <printf>
  struct stat st;
  struct stat *ptr = &st;
  int fd;

  if((fd = open(argv[1], 0)) < 0) {
  50:	59                   	pop    %ecx
  51:	5e                   	pop    %esi
  52:	6a 00                	push   $0x0
  54:	ff 73 04             	pushl  0x4(%ebx)
  57:	e8 86 04 00 00       	call   4e2 <open>
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	85 c0                	test   %eax,%eax
  61:	89 c6                	mov    %eax,%esi
  63:	78 5b                	js     c0 <main+0xc0>
    printf(2, "filestat: cannot open %s\n", argv[1]);
    exit();
  }
  if(stat(argv[1], ptr) < 0) {
  65:	8d 45 d0             	lea    -0x30(%ebp),%eax
  68:	52                   	push   %edx
  69:	52                   	push   %edx
  6a:	50                   	push   %eax
  6b:	ff 73 04             	pushl  0x4(%ebx)
  6e:	e8 6d 03 00 00       	call   3e0 <stat>
  73:	83 c4 10             	add    $0x10,%esp
  76:	85 c0                	test   %eax,%eax
  78:	78 77                	js     f1 <main+0xf1>
    printf(2, "filestat: cannot stat %s\n", argv[1]);
    close(fd);
    exit();
  }
  switch(st.type) {
  7a:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  7e:	66 83 f8 02          	cmp    $0x2,%ax
  82:	0f 84 9c 00 00 00    	je     124 <main+0x124>
  88:	7e 4b                	jle    d5 <main+0xd5>
  8a:	66 83 f8 03          	cmp    $0x3,%ax
  8e:	74 7e                	je     10e <main+0x10e>
  90:	66 83 f8 04          	cmp    $0x4,%ax
  94:	75 1c                	jne    b2 <main+0xb2>
      break;
    case T_DEV:
      printf(1, "Type: %d\nSize: %d\n", st.type, st.size);
      break;
    case T_CHECKED:
      printf(1, "Type: %d\nSize: %d\nChecksum: %d\n", st.type, st.size, 
  96:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  9a:	83 ec 0c             	sub    $0xc,%esp
  9d:	50                   	push   %eax
  9e:	ff 75 e0             	pushl  -0x20(%ebp)
  a1:	6a 04                	push   $0x4
  a3:	68 c4 09 00 00       	push   $0x9c4
  a8:	6a 01                	push   $0x1
  aa:	e8 51 05 00 00       	call   600 <printf>
          st.checksum);
      break;
  af:	83 c4 20             	add    $0x20,%esp
  }
  close(fd);
  b2:	83 ec 0c             	sub    $0xc,%esp
  b5:	56                   	push   %esi
  b6:	e8 0f 04 00 00       	call   4ca <close>
  exit();
  bb:	e8 e2 03 00 00       	call   4a2 <exit>
    printf(2, "filestat: cannot open %s\n", argv[1]);
  c0:	51                   	push   %ecx
  c1:	ff 73 04             	pushl  0x4(%ebx)
  c4:	68 56 0a 00 00       	push   $0xa56
  c9:	6a 02                	push   $0x2
  cb:	e8 30 05 00 00       	call   600 <printf>
    exit();
  d0:	e8 cd 03 00 00       	call   4a2 <exit>
  switch(st.type) {
  d5:	66 83 e8 01          	sub    $0x1,%ax
  d9:	75 d7                	jne    b2 <main+0xb2>
      printf(1, "Type: %d\nSize: %d\n", st.type, st.size);
  db:	ff 75 e0             	pushl  -0x20(%ebp)
  de:	6a 01                	push   $0x1
  e0:	68 8a 0a 00 00       	push   $0xa8a
  e5:	6a 01                	push   $0x1
  e7:	e8 14 05 00 00       	call   600 <printf>
      break;
  ec:	83 c4 10             	add    $0x10,%esp
  ef:	eb c1                	jmp    b2 <main+0xb2>
    printf(2, "filestat: cannot stat %s\n", argv[1]);
  f1:	50                   	push   %eax
  f2:	ff 73 04             	pushl  0x4(%ebx)
  f5:	68 70 0a 00 00       	push   $0xa70
  fa:	6a 02                	push   $0x2
  fc:	e8 ff 04 00 00       	call   600 <printf>
    close(fd);
 101:	89 34 24             	mov    %esi,(%esp)
 104:	e8 c1 03 00 00       	call   4ca <close>
    exit();
 109:	e8 94 03 00 00       	call   4a2 <exit>
      printf(1, "Type: %d\nSize: %d\n", st.type, st.size);
 10e:	ff 75 e0             	pushl  -0x20(%ebp)
 111:	6a 03                	push   $0x3
 113:	68 8a 0a 00 00       	push   $0xa8a
 118:	6a 01                	push   $0x1
 11a:	e8 e1 04 00 00       	call   600 <printf>
      break;
 11f:	83 c4 10             	add    $0x10,%esp
 122:	eb 8e                	jmp    b2 <main+0xb2>
      printf(1, "Type: %d\nSize: %d\n", st.type, st.size);
 124:	ff 75 e0             	pushl  -0x20(%ebp)
 127:	6a 02                	push   $0x2
 129:	68 8a 0a 00 00       	push   $0xa8a
 12e:	6a 01                	push   $0x1
 130:	e8 cb 04 00 00       	call   600 <printf>
      break;
 135:	83 c4 10             	add    $0x10,%esp
 138:	e9 75 ff ff ff       	jmp    b2 <main+0xb2>
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <readFile>:
void readFile(char* name){
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
    fd = open(name, O_RDONLY);
 14a:	6a 00                	push   $0x0
 14c:	ff 75 08             	pushl  0x8(%ebp)
 14f:	e8 8e 03 00 00       	call   4e2 <open>
 154:	89 c3                	mov    %eax,%ebx
    printf(1,"Successful open the file in read\n");
 156:	58                   	pop    %eax
 157:	5a                   	pop    %edx
 158:	68 58 09 00 00       	push   $0x958
 15d:	6a 01                	push   $0x1
 15f:	e8 9c 04 00 00       	call   600 <printf>
        r = read(fd, buf, SIZE);
 164:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 16a:	83 c4 0c             	add    $0xc,%esp
 16d:	68 00 02 00 00       	push   $0x200
 172:	50                   	push   %eax
 173:	53                   	push   %ebx
 174:	e8 41 03 00 00       	call   4ba <read>
        printf(1,"read: %d\n",r);
 179:	83 c4 0c             	add    $0xc,%esp
 17c:	50                   	push   %eax
 17d:	68 e4 09 00 00       	push   $0x9e4
 182:	6a 01                	push   $0x1
 184:	e8 77 04 00 00       	call   600 <printf>
    printf(1,"Read Test Passed\n");
 189:	59                   	pop    %ecx
 18a:	5b                   	pop    %ebx
 18b:	68 ee 09 00 00       	push   $0x9ee
 190:	6a 01                	push   $0x1
 192:	e8 69 04 00 00       	call   600 <printf>
}
 197:	83 c4 10             	add    $0x10,%esp
 19a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19d:	c9                   	leave  
 19e:	c3                   	ret    
 19f:	90                   	nop

000001a0 <writeFile>:
void writeFile(char* name){
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
    memset(buf, 0, SIZE);
 1a5:	8d b5 f8 fd ff ff    	lea    -0x208(%ebp),%esi
void writeFile(char* name){
 1ab:	81 ec 08 02 00 00    	sub    $0x208,%esp
    fd = open(name,O_CREATE|O_CHECKED|O_RDWR);
 1b1:	68 02 06 00 00       	push   $0x602
 1b6:	ff 75 08             	pushl  0x8(%ebp)
 1b9:	e8 24 03 00 00       	call   4e2 <open>
 1be:	89 c3                	mov    %eax,%ebx
    printf(1,"Successful open the file in write\n");
 1c0:	58                   	pop    %eax
 1c1:	5a                   	pop    %edx
 1c2:	68 7c 09 00 00       	push   $0x97c
 1c7:	6a 01                	push   $0x1
 1c9:	e8 32 04 00 00       	call   600 <printf>
    printf(1,"buffer size: %d\n", SIZE);
 1ce:	83 c4 0c             	add    $0xc,%esp
 1d1:	68 00 02 00 00       	push   $0x200
 1d6:	68 00 0a 00 00       	push   $0xa00
 1db:	6a 01                	push   $0x1
 1dd:	e8 1e 04 00 00       	call   600 <printf>
    memset(buf, 0, SIZE);
 1e2:	83 c4 0c             	add    $0xc,%esp
 1e5:	68 00 02 00 00       	push   $0x200
 1ea:	6a 00                	push   $0x0
 1ec:	56                   	push   %esi
 1ed:	e8 0e 01 00 00       	call   300 <memset>
    printf(1,"Write file Begin.\n");
 1f2:	59                   	pop    %ecx
 1f3:	58                   	pop    %eax
 1f4:	68 11 0a 00 00       	push   $0xa11
 1f9:	6a 01                	push   $0x1
 1fb:	e8 00 04 00 00       	call   600 <printf>
        w = write(fd, buf, SIZE);
 200:	83 c4 0c             	add    $0xc,%esp
        buf[0] = (char)('T');
 203:	c6 85 f8 fd ff ff 54 	movb   $0x54,-0x208(%ebp)
        w = write(fd, buf, SIZE);
 20a:	68 00 02 00 00       	push   $0x200
 20f:	56                   	push   %esi
 210:	53                   	push   %ebx
 211:	e8 ac 02 00 00       	call   4c2 <write>
        printf(1,"%d write %d size\n",w,SIZE);
 216:	68 00 02 00 00       	push   $0x200
 21b:	50                   	push   %eax
 21c:	68 24 0a 00 00       	push   $0xa24
 221:	6a 01                	push   $0x1
 223:	e8 d8 03 00 00       	call   600 <printf>
    printf(1,"Write Test Passed\n");
 228:	83 c4 18             	add    $0x18,%esp
 22b:	68 36 0a 00 00       	push   $0xa36
 230:	6a 01                	push   $0x1
 232:	e8 c9 03 00 00       	call   600 <printf>
    w = close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
 23a:	e8 8b 02 00 00       	call   4ca <close>
}
 23f:	83 c4 10             	add    $0x10,%esp
 242:	8d 65 f8             	lea    -0x8(%ebp),%esp
 245:	5b                   	pop    %ebx
 246:	5e                   	pop    %esi
 247:	5d                   	pop    %ebp
 248:	c3                   	ret    
 249:	66 90                	xchg   %ax,%ax
 24b:	66 90                	xchg   %ax,%ax
 24d:	66 90                	xchg   %ax,%ax
 24f:	90                   	nop

00000250 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 260:	83 c1 01             	add    $0x1,%ecx
 263:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 267:	83 c2 01             	add    $0x1,%edx
 26a:	84 db                	test   %bl,%bl
 26c:	88 5a ff             	mov    %bl,-0x1(%edx)
 26f:	75 ef                	jne    260 <strcpy+0x10>
    ;
  return os;
}
 271:	5b                   	pop    %ebx
 272:	5d                   	pop    %ebp
 273:	c3                   	ret    
 274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 27a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
 287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 28a:	0f b6 02             	movzbl (%edx),%eax
 28d:	0f b6 19             	movzbl (%ecx),%ebx
 290:	84 c0                	test   %al,%al
 292:	75 1c                	jne    2b0 <strcmp+0x30>
 294:	eb 2a                	jmp    2c0 <strcmp+0x40>
 296:	8d 76 00             	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2a0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2a6:	83 c1 01             	add    $0x1,%ecx
 2a9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2ac:	84 c0                	test   %al,%al
 2ae:	74 10                	je     2c0 <strcmp+0x40>
 2b0:	38 d8                	cmp    %bl,%al
 2b2:	74 ec                	je     2a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2b4:	29 d8                	sub    %ebx,%eax
}
 2b6:	5b                   	pop    %ebx
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret    
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2c2:	29 d8                	sub    %ebx,%eax
}
 2c4:	5b                   	pop    %ebx
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <strlen>:

uint
strlen(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2d6:	80 39 00             	cmpb   $0x0,(%ecx)
 2d9:	74 15                	je     2f0 <strlen+0x20>
 2db:	31 d2                	xor    %edx,%edx
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	75 f5                	jne    2e0 <strlen+0x10>
    ;
  return n;
}
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2f0:	31 c0                	xor    %eax,%eax
}
 2f2:	5d                   	pop    %ebp
 2f3:	c3                   	ret    
 2f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000300 <memset>:

void*
memset(void *dst, int c, uint n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 307:	8b 4d 10             	mov    0x10(%ebp),%ecx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 d7                	mov    %edx,%edi
 30f:	fc                   	cld    
 310:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 312:	89 d0                	mov    %edx,%eax
 314:	5f                   	pop    %edi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	89 f6                	mov    %esi,%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <strchr>:

char*
strchr(const char *s, char c)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 32a:	0f b6 10             	movzbl (%eax),%edx
 32d:	84 d2                	test   %dl,%dl
 32f:	74 1d                	je     34e <strchr+0x2e>
    if(*s == c)
 331:	38 d3                	cmp    %dl,%bl
 333:	89 d9                	mov    %ebx,%ecx
 335:	75 0d                	jne    344 <strchr+0x24>
 337:	eb 17                	jmp    350 <strchr+0x30>
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 340:	38 ca                	cmp    %cl,%dl
 342:	74 0c                	je     350 <strchr+0x30>
  for(; *s; s++)
 344:	83 c0 01             	add    $0x1,%eax
 347:	0f b6 10             	movzbl (%eax),%edx
 34a:	84 d2                	test   %dl,%dl
 34c:	75 f2                	jne    340 <strchr+0x20>
      return (char*)s;
  return 0;
 34e:	31 c0                	xor    %eax,%eax
}
 350:	5b                   	pop    %ebx
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	31 f6                	xor    %esi,%esi
 368:	89 f3                	mov    %esi,%ebx
{
 36a:	83 ec 1c             	sub    $0x1c,%esp
 36d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 370:	eb 2f                	jmp    3a1 <gets+0x41>
 372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 378:	8d 45 e7             	lea    -0x19(%ebp),%eax
 37b:	83 ec 04             	sub    $0x4,%esp
 37e:	6a 01                	push   $0x1
 380:	50                   	push   %eax
 381:	6a 00                	push   $0x0
 383:	e8 32 01 00 00       	call   4ba <read>
    if(cc < 1)
 388:	83 c4 10             	add    $0x10,%esp
 38b:	85 c0                	test   %eax,%eax
 38d:	7e 1c                	jle    3ab <gets+0x4b>
      break;
    buf[i++] = c;
 38f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 393:	83 c7 01             	add    $0x1,%edi
 396:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 399:	3c 0a                	cmp    $0xa,%al
 39b:	74 23                	je     3c0 <gets+0x60>
 39d:	3c 0d                	cmp    $0xd,%al
 39f:	74 1f                	je     3c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3a1:	83 c3 01             	add    $0x1,%ebx
 3a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3a7:	89 fe                	mov    %edi,%esi
 3a9:	7c cd                	jl     378 <gets+0x18>
 3ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b6:	5b                   	pop    %ebx
 3b7:	5e                   	pop    %esi
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    
 3bb:	90                   	nop
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3c0:	8b 75 08             	mov    0x8(%ebp),%esi
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	01 de                	add    %ebx,%esi
 3c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 3cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d0:	5b                   	pop    %ebx
 3d1:	5e                   	pop    %esi
 3d2:	5f                   	pop    %edi
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	pushl  0x8(%ebp)
 3ed:	e8 f0 00 00 00       	call   4e2 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	pushl  0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 f3 00 00 00       	call   4fa <fstat>
  close(fd);
 407:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 40a:	89 c6                	mov    %eax,%esi
  close(fd);
 40c:	e8 b9 00 00 00       	call   4ca <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	8d 65 f8             	lea    -0x8(%ebp),%esp
 417:	89 f0                	mov    %esi,%eax
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 420:	be ff ff ff ff       	mov    $0xffffffff,%esi
 425:	eb ed                	jmp    414 <stat+0x34>
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <atoi>:

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 11             	movsbl (%ecx),%edx
 43a:	8d 42 d0             	lea    -0x30(%edx),%eax
 43d:	3c 09                	cmp    $0x9,%al
  n = 0;
 43f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 444:	77 1f                	ja     465 <atoi+0x35>
 446:	8d 76 00             	lea    0x0(%esi),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 450:	8d 04 80             	lea    (%eax,%eax,4),%eax
 453:	83 c1 01             	add    $0x1,%ecx
 456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 45a:	0f be 11             	movsbl (%ecx),%edx
 45d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
  return n;
}
 465:	5b                   	pop    %ebx
 466:	5d                   	pop    %ebp
 467:	c3                   	ret    
 468:	90                   	nop
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	56                   	push   %esi
 474:	53                   	push   %ebx
 475:	8b 5d 10             	mov    0x10(%ebp),%ebx
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 db                	test   %ebx,%ebx
 480:	7e 14                	jle    496 <memmove+0x26>
 482:	31 d2                	xor    %edx,%edx
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 488:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 48c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 48f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 492:	39 d3                	cmp    %edx,%ebx
 494:	75 f2                	jne    488 <memmove+0x18>
  return vdst;
}
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5d                   	pop    %ebp
 499:	c3                   	ret    

0000049a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49a:	b8 01 00 00 00       	mov    $0x1,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <exit>:
SYSCALL(exit)
 4a2:	b8 02 00 00 00       	mov    $0x2,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <wait>:
SYSCALL(wait)
 4aa:	b8 03 00 00 00       	mov    $0x3,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <pipe>:
SYSCALL(pipe)
 4b2:	b8 04 00 00 00       	mov    $0x4,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <read>:
SYSCALL(read)
 4ba:	b8 05 00 00 00       	mov    $0x5,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <write>:
SYSCALL(write)
 4c2:	b8 10 00 00 00       	mov    $0x10,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <close>:
SYSCALL(close)
 4ca:	b8 15 00 00 00       	mov    $0x15,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <kill>:
SYSCALL(kill)
 4d2:	b8 06 00 00 00       	mov    $0x6,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <exec>:
SYSCALL(exec)
 4da:	b8 07 00 00 00       	mov    $0x7,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <open>:
SYSCALL(open)
 4e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mknod>:
SYSCALL(mknod)
 4ea:	b8 11 00 00 00       	mov    $0x11,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <unlink>:
SYSCALL(unlink)
 4f2:	b8 12 00 00 00       	mov    $0x12,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <fstat>:
SYSCALL(fstat)
 4fa:	b8 08 00 00 00       	mov    $0x8,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <link>:
SYSCALL(link)
 502:	b8 13 00 00 00       	mov    $0x13,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mkdir>:
SYSCALL(mkdir)
 50a:	b8 14 00 00 00       	mov    $0x14,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <chdir>:
SYSCALL(chdir)
 512:	b8 09 00 00 00       	mov    $0x9,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <dup>:
SYSCALL(dup)
 51a:	b8 0a 00 00 00       	mov    $0xa,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <getpid>:
SYSCALL(getpid)
 522:	b8 0b 00 00 00       	mov    $0xb,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <sbrk>:
SYSCALL(sbrk)
 52a:	b8 0c 00 00 00       	mov    $0xc,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <sleep>:
SYSCALL(sleep)
 532:	b8 0d 00 00 00       	mov    $0xd,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <uptime>:
SYSCALL(uptime)
 53a:	b8 0e 00 00 00       	mov    $0xe,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <setpri>:
SYSCALL(setpri)
 542:	b8 16 00 00 00       	mov    $0x16,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <getpinfo>:
SYSCALL(getpinfo)
 54a:	b8 17 00 00 00       	mov    $0x17,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    
 552:	66 90                	xchg   %ax,%ax
 554:	66 90                	xchg   %ax,%ax
 556:	66 90                	xchg   %ax,%ax
 558:	66 90                	xchg   %ax,%ax
 55a:	66 90                	xchg   %ax,%ax
 55c:	66 90                	xchg   %ax,%ax
 55e:	66 90                	xchg   %ax,%ax

00000560 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 569:	85 d2                	test   %edx,%edx
{
 56b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 56e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 570:	79 76                	jns    5e8 <printint+0x88>
 572:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 576:	74 70                	je     5e8 <printint+0x88>
    x = -xx;
 578:	f7 d8                	neg    %eax
    neg = 1;
 57a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 581:	31 f6                	xor    %esi,%esi
 583:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 586:	eb 0a                	jmp    592 <printint+0x32>
 588:	90                   	nop
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 590:	89 fe                	mov    %edi,%esi
 592:	31 d2                	xor    %edx,%edx
 594:	8d 7e 01             	lea    0x1(%esi),%edi
 597:	f7 f1                	div    %ecx
 599:	0f b6 92 a4 0a 00 00 	movzbl 0xaa4(%edx),%edx
  }while((x /= base) != 0);
 5a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5a5:	75 e9                	jne    590 <printint+0x30>
  if(neg)
 5a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5aa:	85 c0                	test   %eax,%eax
 5ac:	74 08                	je     5b6 <printint+0x56>
    buf[i++] = '-';
 5ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5b3:	8d 7e 02             	lea    0x2(%esi),%edi
 5b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5c3:	83 ec 04             	sub    $0x4,%esp
 5c6:	83 ee 01             	sub    $0x1,%esi
 5c9:	6a 01                	push   $0x1
 5cb:	53                   	push   %ebx
 5cc:	57                   	push   %edi
 5cd:	88 45 d7             	mov    %al,-0x29(%ebp)
 5d0:	e8 ed fe ff ff       	call   4c2 <write>

  while(--i >= 0)
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	39 de                	cmp    %ebx,%esi
 5da:	75 e4                	jne    5c0 <printint+0x60>
    putc(fd, buf[i]);
}
 5dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5df:	5b                   	pop    %ebx
 5e0:	5e                   	pop    %esi
 5e1:	5f                   	pop    %edi
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5ef:	eb 90                	jmp    581 <printint+0x21>
 5f1:	eb 0d                	jmp    600 <printf>
 5f3:	90                   	nop
 5f4:	90                   	nop
 5f5:	90                   	nop
 5f6:	90                   	nop
 5f7:	90                   	nop
 5f8:	90                   	nop
 5f9:	90                   	nop
 5fa:	90                   	nop
 5fb:	90                   	nop
 5fc:	90                   	nop
 5fd:	90                   	nop
 5fe:	90                   	nop
 5ff:	90                   	nop

00000600 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 609:	8b 75 0c             	mov    0xc(%ebp),%esi
 60c:	0f b6 1e             	movzbl (%esi),%ebx
 60f:	84 db                	test   %bl,%bl
 611:	0f 84 b3 00 00 00    	je     6ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 617:	8d 45 10             	lea    0x10(%ebp),%eax
 61a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 61d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 61f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 622:	eb 2f                	jmp    653 <printf+0x53>
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 628:	83 f8 25             	cmp    $0x25,%eax
 62b:	0f 84 a7 00 00 00    	je     6d8 <printf+0xd8>
  write(fd, &c, 1);
 631:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 634:	83 ec 04             	sub    $0x4,%esp
 637:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 63a:	6a 01                	push   $0x1
 63c:	50                   	push   %eax
 63d:	ff 75 08             	pushl  0x8(%ebp)
 640:	e8 7d fe ff ff       	call   4c2 <write>
 645:	83 c4 10             	add    $0x10,%esp
 648:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 64b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 64f:	84 db                	test   %bl,%bl
 651:	74 77                	je     6ca <printf+0xca>
    if(state == 0){
 653:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 655:	0f be cb             	movsbl %bl,%ecx
 658:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 65b:	74 cb                	je     628 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65d:	83 ff 25             	cmp    $0x25,%edi
 660:	75 e6                	jne    648 <printf+0x48>
      if(c == 'd'){
 662:	83 f8 64             	cmp    $0x64,%eax
 665:	0f 84 05 01 00 00    	je     770 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 66b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 671:	83 f9 70             	cmp    $0x70,%ecx
 674:	74 72                	je     6e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 676:	83 f8 73             	cmp    $0x73,%eax
 679:	0f 84 99 00 00 00    	je     718 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67f:	83 f8 63             	cmp    $0x63,%eax
 682:	0f 84 08 01 00 00    	je     790 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 688:	83 f8 25             	cmp    $0x25,%eax
 68b:	0f 84 ef 00 00 00    	je     780 <printf+0x180>
  write(fd, &c, 1);
 691:	8d 45 e7             	lea    -0x19(%ebp),%eax
 694:	83 ec 04             	sub    $0x4,%esp
 697:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 69b:	6a 01                	push   $0x1
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 1c fe ff ff       	call   4c2 <write>
 6a6:	83 c4 0c             	add    $0xc,%esp
 6a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6af:	6a 01                	push   $0x1
 6b1:	50                   	push   %eax
 6b2:	ff 75 08             	pushl  0x8(%ebp)
 6b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6ba:	e8 03 fe ff ff       	call   4c2 <write>
  for(i = 0; fmt[i]; i++){
 6bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6c6:	84 db                	test   %bl,%bl
 6c8:	75 89                	jne    653 <printf+0x53>
    }
  }
}
 6ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6cd:	5b                   	pop    %ebx
 6ce:	5e                   	pop    %esi
 6cf:	5f                   	pop    %edi
 6d0:	5d                   	pop    %ebp
 6d1:	c3                   	ret    
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6d8:	bf 25 00 00 00       	mov    $0x25,%edi
 6dd:	e9 66 ff ff ff       	jmp    648 <printf+0x48>
 6e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6e8:	83 ec 0c             	sub    $0xc,%esp
 6eb:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f0:	6a 00                	push   $0x0
 6f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	8b 17                	mov    (%edi),%edx
 6fa:	e8 61 fe ff ff       	call   560 <printint>
        ap++;
 6ff:	89 f8                	mov    %edi,%eax
 701:	83 c4 10             	add    $0x10,%esp
      state = 0;
 704:	31 ff                	xor    %edi,%edi
        ap++;
 706:	83 c0 04             	add    $0x4,%eax
 709:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 70c:	e9 37 ff ff ff       	jmp    648 <printf+0x48>
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 71b:	8b 08                	mov    (%eax),%ecx
        ap++;
 71d:	83 c0 04             	add    $0x4,%eax
 720:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 723:	85 c9                	test   %ecx,%ecx
 725:	0f 84 8e 00 00 00    	je     7b9 <printf+0x1b9>
        while(*s != 0){
 72b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 72e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 730:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 732:	84 c0                	test   %al,%al
 734:	0f 84 0e ff ff ff    	je     648 <printf+0x48>
 73a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 73d:	89 de                	mov    %ebx,%esi
 73f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 742:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 745:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 748:	83 ec 04             	sub    $0x4,%esp
          s++;
 74b:	83 c6 01             	add    $0x1,%esi
 74e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 751:	6a 01                	push   $0x1
 753:	57                   	push   %edi
 754:	53                   	push   %ebx
 755:	e8 68 fd ff ff       	call   4c2 <write>
        while(*s != 0){
 75a:	0f b6 06             	movzbl (%esi),%eax
 75d:	83 c4 10             	add    $0x10,%esp
 760:	84 c0                	test   %al,%al
 762:	75 e4                	jne    748 <printf+0x148>
 764:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 767:	31 ff                	xor    %edi,%edi
 769:	e9 da fe ff ff       	jmp    648 <printf+0x48>
 76e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	b9 0a 00 00 00       	mov    $0xa,%ecx
 778:	6a 01                	push   $0x1
 77a:	e9 73 ff ff ff       	jmp    6f2 <printf+0xf2>
 77f:	90                   	nop
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
 783:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 786:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 789:	6a 01                	push   $0x1
 78b:	e9 21 ff ff ff       	jmp    6b1 <printf+0xb1>
        putc(fd, *ap);
 790:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 793:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 796:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 798:	6a 01                	push   $0x1
        ap++;
 79a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 79d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7a3:	50                   	push   %eax
 7a4:	ff 75 08             	pushl  0x8(%ebp)
 7a7:	e8 16 fd ff ff       	call   4c2 <write>
        ap++;
 7ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7af:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7b2:	31 ff                	xor    %edi,%edi
 7b4:	e9 8f fe ff ff       	jmp    648 <printf+0x48>
          s = "(null)";
 7b9:	bb 9d 0a 00 00       	mov    $0xa9d,%ebx
        while(*s != 0){
 7be:	b8 28 00 00 00       	mov    $0x28,%eax
 7c3:	e9 72 ff ff ff       	jmp    73a <printf+0x13a>
 7c8:	66 90                	xchg   %ax,%ax
 7ca:	66 90                	xchg   %ax,%ax
 7cc:	66 90                	xchg   %ax,%ax
 7ce:	66 90                	xchg   %ax,%ax

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	a1 9c 0d 00 00       	mov    0xd9c,%eax
{
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	57                   	push   %edi
 7d9:	56                   	push   %esi
 7da:	53                   	push   %ebx
 7db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	39 c8                	cmp    %ecx,%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	73 32                	jae    820 <free+0x50>
 7ee:	39 d1                	cmp    %edx,%ecx
 7f0:	72 04                	jb     7f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	39 d0                	cmp    %edx,%eax
 7f4:	72 32                	jb     828 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7fc:	39 fa                	cmp    %edi,%edx
 7fe:	74 30                	je     830 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 800:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 803:	8b 50 04             	mov    0x4(%eax),%edx
 806:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 809:	39 f1                	cmp    %esi,%ecx
 80b:	74 3a                	je     847 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 80d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 80f:	a3 9c 0d 00 00       	mov    %eax,0xd9c
}
 814:	5b                   	pop    %ebx
 815:	5e                   	pop    %esi
 816:	5f                   	pop    %edi
 817:	5d                   	pop    %ebp
 818:	c3                   	ret    
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	39 d0                	cmp    %edx,%eax
 822:	72 04                	jb     828 <free+0x58>
 824:	39 d1                	cmp    %edx,%ecx
 826:	72 ce                	jb     7f6 <free+0x26>
{
 828:	89 d0                	mov    %edx,%eax
 82a:	eb bc                	jmp    7e8 <free+0x18>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 830:	03 72 04             	add    0x4(%edx),%esi
 833:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	8b 10                	mov    (%eax),%edx
 838:	8b 12                	mov    (%edx),%edx
 83a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 83d:	8b 50 04             	mov    0x4(%eax),%edx
 840:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 843:	39 f1                	cmp    %esi,%ecx
 845:	75 c6                	jne    80d <free+0x3d>
    p->s.size += bp->s.size;
 847:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 84a:	a3 9c 0d 00 00       	mov    %eax,0xd9c
    p->s.size += bp->s.size;
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 53 f8             	mov    -0x8(%ebx),%edx
 855:	89 10                	mov    %edx,(%eax)
}
 857:	5b                   	pop    %ebx
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret    
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	56                   	push   %esi
 865:	53                   	push   %ebx
 866:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 869:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 86c:	8b 15 9c 0d 00 00    	mov    0xd9c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	8d 78 07             	lea    0x7(%eax),%edi
 875:	c1 ef 03             	shr    $0x3,%edi
 878:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 87b:	85 d2                	test   %edx,%edx
 87d:	0f 84 9d 00 00 00    	je     920 <malloc+0xc0>
 883:	8b 02                	mov    (%edx),%eax
 885:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 888:	39 cf                	cmp    %ecx,%edi
 88a:	76 6c                	jbe    8f8 <malloc+0x98>
 88c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 892:	bb 00 10 00 00       	mov    $0x1000,%ebx
 897:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 89a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8a1:	eb 0e                	jmp    8b1 <malloc+0x51>
 8a3:	90                   	nop
 8a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8aa:	8b 48 04             	mov    0x4(%eax),%ecx
 8ad:	39 f9                	cmp    %edi,%ecx
 8af:	73 47                	jae    8f8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b1:	39 05 9c 0d 00 00    	cmp    %eax,0xd9c
 8b7:	89 c2                	mov    %eax,%edx
 8b9:	75 ed                	jne    8a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8bb:	83 ec 0c             	sub    $0xc,%esp
 8be:	56                   	push   %esi
 8bf:	e8 66 fc ff ff       	call   52a <sbrk>
  if(p == (char*)-1)
 8c4:	83 c4 10             	add    $0x10,%esp
 8c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ca:	74 1c                	je     8e8 <malloc+0x88>
  hp->s.size = nu;
 8cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8cf:	83 ec 0c             	sub    $0xc,%esp
 8d2:	83 c0 08             	add    $0x8,%eax
 8d5:	50                   	push   %eax
 8d6:	e8 f5 fe ff ff       	call   7d0 <free>
  return freep;
 8db:	8b 15 9c 0d 00 00    	mov    0xd9c,%edx
      if((p = morecore(nunits)) == 0)
 8e1:	83 c4 10             	add    $0x10,%esp
 8e4:	85 d2                	test   %edx,%edx
 8e6:	75 c0                	jne    8a8 <malloc+0x48>
        return 0;
  }
}
 8e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8eb:	31 c0                	xor    %eax,%eax
}
 8ed:	5b                   	pop    %ebx
 8ee:	5e                   	pop    %esi
 8ef:	5f                   	pop    %edi
 8f0:	5d                   	pop    %ebp
 8f1:	c3                   	ret    
 8f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8f8:	39 cf                	cmp    %ecx,%edi
 8fa:	74 54                	je     950 <malloc+0xf0>
        p->s.size -= nunits;
 8fc:	29 f9                	sub    %edi,%ecx
 8fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 901:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 904:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 907:	89 15 9c 0d 00 00    	mov    %edx,0xd9c
}
 90d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 910:	83 c0 08             	add    $0x8,%eax
}
 913:	5b                   	pop    %ebx
 914:	5e                   	pop    %esi
 915:	5f                   	pop    %edi
 916:	5d                   	pop    %ebp
 917:	c3                   	ret    
 918:	90                   	nop
 919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 920:	c7 05 9c 0d 00 00 a0 	movl   $0xda0,0xd9c
 927:	0d 00 00 
 92a:	c7 05 a0 0d 00 00 a0 	movl   $0xda0,0xda0
 931:	0d 00 00 
    base.s.size = 0;
 934:	b8 a0 0d 00 00       	mov    $0xda0,%eax
 939:	c7 05 a4 0d 00 00 00 	movl   $0x0,0xda4
 940:	00 00 00 
 943:	e9 44 ff ff ff       	jmp    88c <malloc+0x2c>
 948:	90                   	nop
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 950:	8b 08                	mov    (%eax),%ecx
 952:	89 0a                	mov    %ecx,(%edx)
 954:	eb b1                	jmp    907 <malloc+0xa7>
