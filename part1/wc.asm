
_wc:     file format elf32-i386


Disassembly of section .text:

00001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	56                   	push   %esi
    1005:	53                   	push   %ebx
    1006:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
    1009:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
    1010:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    1017:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    101e:	be 00 00 00 00       	mov    $0x0,%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1023:	eb 4d                	jmp    1072 <wc+0x72>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
    1025:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1029:	75 0b                	jne    1036 <wc+0x36>
        w++;
    102b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
    102f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
    1036:	83 c3 01             	add    $0x1,%ebx
    1039:	39 df                	cmp    %ebx,%edi
    103b:	74 32                	je     106f <wc+0x6f>
      if(buf[i] == '\n')
    103d:	0f b6 83 80 1a 00 00 	movzbl 0x1a80(%ebx),%eax
        l++;
    1044:	3c 0a                	cmp    $0xa,%al
    1046:	0f 94 c2             	sete   %dl
    1049:	0f b6 d2             	movzbl %dl,%edx
    104c:	01 d6                	add    %edx,%esi
      if(strchr(" \r\t\n\v", buf[i]))
    104e:	83 ec 08             	sub    $0x8,%esp
    1051:	0f be c0             	movsbl %al,%eax
    1054:	50                   	push   %eax
    1055:	68 78 17 00 00       	push   $0x1778
    105a:	e8 92 01 00 00       	call   11f1 <strchr>
    105f:	83 c4 10             	add    $0x10,%esp
    1062:	85 c0                	test   %eax,%eax
    1064:	74 bf                	je     1025 <wc+0x25>
        inword = 0;
    1066:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    106d:	eb c7                	jmp    1036 <wc+0x36>
    106f:	01 5d dc             	add    %ebx,-0x24(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1072:	83 ec 04             	sub    $0x4,%esp
    1075:	68 00 02 00 00       	push   $0x200
    107a:	68 80 1a 00 00       	push   $0x1a80
    107f:	ff 75 08             	pushl  0x8(%ebp)
    1082:	e8 b8 02 00 00       	call   133f <read>
    1087:	89 c7                	mov    %eax,%edi
    1089:	83 c4 10             	add    $0x10,%esp
    108c:	85 c0                	test   %eax,%eax
    108e:	7e 07                	jle    1097 <wc+0x97>
    for(i=0; i<n; i++){
    1090:	bb 00 00 00 00       	mov    $0x0,%ebx
    1095:	eb a6                	jmp    103d <wc+0x3d>
      }
    }
  }
  if(n < 0){
    1097:	85 c0                	test   %eax,%eax
    1099:	78 24                	js     10bf <wc+0xbf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    109b:	83 ec 08             	sub    $0x8,%esp
    109e:	ff 75 0c             	pushl  0xc(%ebp)
    10a1:	ff 75 dc             	pushl  -0x24(%ebp)
    10a4:	ff 75 e0             	pushl  -0x20(%ebp)
    10a7:	56                   	push   %esi
    10a8:	68 8e 17 00 00       	push   $0x178e
    10ad:	6a 01                	push   $0x1
    10af:	e8 ad 03 00 00       	call   1461 <printf>
}
    10b4:	83 c4 20             	add    $0x20,%esp
    10b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10ba:	5b                   	pop    %ebx
    10bb:	5e                   	pop    %esi
    10bc:	5f                   	pop    %edi
    10bd:	5d                   	pop    %ebp
    10be:	c3                   	ret    
    printf(1, "wc: read error\n");
    10bf:	83 ec 08             	sub    $0x8,%esp
    10c2:	68 7e 17 00 00       	push   $0x177e
    10c7:	6a 01                	push   $0x1
    10c9:	e8 93 03 00 00       	call   1461 <printf>
    exit();
    10ce:	e8 54 02 00 00       	call   1327 <exit>

000010d3 <main>:

int
main(int argc, char *argv[])
{
    10d3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    10d7:	83 e4 f0             	and    $0xfffffff0,%esp
    10da:	ff 71 fc             	pushl  -0x4(%ecx)
    10dd:	55                   	push   %ebp
    10de:	89 e5                	mov    %esp,%ebp
    10e0:	57                   	push   %edi
    10e1:	56                   	push   %esi
    10e2:	53                   	push   %ebx
    10e3:	51                   	push   %ecx
    10e4:	83 ec 18             	sub    $0x18,%esp
    10e7:	8b 01                	mov    (%ecx),%eax
    10e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    10ec:	8b 59 04             	mov    0x4(%ecx),%ebx
    10ef:	83 c3 04             	add    $0x4,%ebx
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    10f2:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
    10f7:	83 f8 01             	cmp    $0x1,%eax
    10fa:	7e 3e                	jle    113a <main+0x67>
    if((fd = open(argv[i], 0)) < 0){
    10fc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    10ff:	83 ec 08             	sub    $0x8,%esp
    1102:	6a 00                	push   $0x0
    1104:	ff 33                	pushl  (%ebx)
    1106:	e8 5c 02 00 00       	call   1367 <open>
    110b:	89 c6                	mov    %eax,%esi
    110d:	83 c4 10             	add    $0x10,%esp
    1110:	85 c0                	test   %eax,%eax
    1112:	78 3a                	js     114e <main+0x7b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
    1114:	83 ec 08             	sub    $0x8,%esp
    1117:	ff 33                	pushl  (%ebx)
    1119:	50                   	push   %eax
    111a:	e8 e1 fe ff ff       	call   1000 <wc>
    close(fd);
    111f:	89 34 24             	mov    %esi,(%esp)
    1122:	e8 28 02 00 00       	call   134f <close>
  for(i = 1; i < argc; i++){
    1127:	83 c7 01             	add    $0x1,%edi
    112a:	83 c3 04             	add    $0x4,%ebx
    112d:	83 c4 10             	add    $0x10,%esp
    1130:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
    1133:	75 c7                	jne    10fc <main+0x29>
  }
  exit();
    1135:	e8 ed 01 00 00       	call   1327 <exit>
    wc(0, "");
    113a:	83 ec 08             	sub    $0x8,%esp
    113d:	68 8d 17 00 00       	push   $0x178d
    1142:	6a 00                	push   $0x0
    1144:	e8 b7 fe ff ff       	call   1000 <wc>
    exit();
    1149:	e8 d9 01 00 00       	call   1327 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
    114e:	83 ec 04             	sub    $0x4,%esp
    1151:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1154:	ff 30                	pushl  (%eax)
    1156:	68 9b 17 00 00       	push   $0x179b
    115b:	6a 01                	push   $0x1
    115d:	e8 ff 02 00 00       	call   1461 <printf>
      exit();
    1162:	e8 c0 01 00 00       	call   1327 <exit>

00001167 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1167:	55                   	push   %ebp
    1168:	89 e5                	mov    %esp,%ebp
    116a:	53                   	push   %ebx
    116b:	8b 45 08             	mov    0x8(%ebp),%eax
    116e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1171:	89 c2                	mov    %eax,%edx
    1173:	83 c1 01             	add    $0x1,%ecx
    1176:	83 c2 01             	add    $0x1,%edx
    1179:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    117d:	88 5a ff             	mov    %bl,-0x1(%edx)
    1180:	84 db                	test   %bl,%bl
    1182:	75 ef                	jne    1173 <strcpy+0xc>
    ;
  return os;
}
    1184:	5b                   	pop    %ebx
    1185:	5d                   	pop    %ebp
    1186:	c3                   	ret    

00001187 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1187:	55                   	push   %ebp
    1188:	89 e5                	mov    %esp,%ebp
    118a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1190:	0f b6 01             	movzbl (%ecx),%eax
    1193:	84 c0                	test   %al,%al
    1195:	74 15                	je     11ac <strcmp+0x25>
    1197:	3a 02                	cmp    (%edx),%al
    1199:	75 11                	jne    11ac <strcmp+0x25>
    p++, q++;
    119b:	83 c1 01             	add    $0x1,%ecx
    119e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    11a1:	0f b6 01             	movzbl (%ecx),%eax
    11a4:	84 c0                	test   %al,%al
    11a6:	74 04                	je     11ac <strcmp+0x25>
    11a8:	3a 02                	cmp    (%edx),%al
    11aa:	74 ef                	je     119b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    11ac:	0f b6 c0             	movzbl %al,%eax
    11af:	0f b6 12             	movzbl (%edx),%edx
    11b2:	29 d0                	sub    %edx,%eax
}
    11b4:	5d                   	pop    %ebp
    11b5:	c3                   	ret    

000011b6 <strlen>:

uint
strlen(const char *s)
{
    11b6:	55                   	push   %ebp
    11b7:	89 e5                	mov    %esp,%ebp
    11b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    11bc:	80 39 00             	cmpb   $0x0,(%ecx)
    11bf:	74 12                	je     11d3 <strlen+0x1d>
    11c1:	ba 00 00 00 00       	mov    $0x0,%edx
    11c6:	83 c2 01             	add    $0x1,%edx
    11c9:	89 d0                	mov    %edx,%eax
    11cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    11cf:	75 f5                	jne    11c6 <strlen+0x10>
    ;
  return n;
}
    11d1:	5d                   	pop    %ebp
    11d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
    11d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    11d8:	eb f7                	jmp    11d1 <strlen+0x1b>

000011da <memset>:

void*
memset(void *dst, int c, uint n)
{
    11da:	55                   	push   %ebp
    11db:	89 e5                	mov    %esp,%ebp
    11dd:	57                   	push   %edi
    11de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11e1:	89 d7                	mov    %edx,%edi
    11e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e9:	fc                   	cld    
    11ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11ec:	89 d0                	mov    %edx,%eax
    11ee:	5f                   	pop    %edi
    11ef:	5d                   	pop    %ebp
    11f0:	c3                   	ret    

000011f1 <strchr>:

char*
strchr(const char *s, char c)
{
    11f1:	55                   	push   %ebp
    11f2:	89 e5                	mov    %esp,%ebp
    11f4:	53                   	push   %ebx
    11f5:	8b 45 08             	mov    0x8(%ebp),%eax
    11f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    11fb:	0f b6 10             	movzbl (%eax),%edx
    11fe:	84 d2                	test   %dl,%dl
    1200:	74 1e                	je     1220 <strchr+0x2f>
    1202:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1204:	38 d3                	cmp    %dl,%bl
    1206:	74 15                	je     121d <strchr+0x2c>
  for(; *s; s++)
    1208:	83 c0 01             	add    $0x1,%eax
    120b:	0f b6 10             	movzbl (%eax),%edx
    120e:	84 d2                	test   %dl,%dl
    1210:	74 06                	je     1218 <strchr+0x27>
    if(*s == c)
    1212:	38 ca                	cmp    %cl,%dl
    1214:	75 f2                	jne    1208 <strchr+0x17>
    1216:	eb 05                	jmp    121d <strchr+0x2c>
      return (char*)s;
  return 0;
    1218:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121d:	5b                   	pop    %ebx
    121e:	5d                   	pop    %ebp
    121f:	c3                   	ret    
  return 0;
    1220:	b8 00 00 00 00       	mov    $0x0,%eax
    1225:	eb f6                	jmp    121d <strchr+0x2c>

00001227 <gets>:

char*
gets(char *buf, int max)
{
    1227:	55                   	push   %ebp
    1228:	89 e5                	mov    %esp,%ebp
    122a:	57                   	push   %edi
    122b:	56                   	push   %esi
    122c:	53                   	push   %ebx
    122d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1230:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1235:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1238:	8d 5e 01             	lea    0x1(%esi),%ebx
    123b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    123e:	7d 2b                	jge    126b <gets+0x44>
    cc = read(0, &c, 1);
    1240:	83 ec 04             	sub    $0x4,%esp
    1243:	6a 01                	push   $0x1
    1245:	57                   	push   %edi
    1246:	6a 00                	push   $0x0
    1248:	e8 f2 00 00 00       	call   133f <read>
    if(cc < 1)
    124d:	83 c4 10             	add    $0x10,%esp
    1250:	85 c0                	test   %eax,%eax
    1252:	7e 17                	jle    126b <gets+0x44>
      break;
    buf[i++] = c;
    1254:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1258:	8b 55 08             	mov    0x8(%ebp),%edx
    125b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    125f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1261:	3c 0a                	cmp    $0xa,%al
    1263:	74 04                	je     1269 <gets+0x42>
    1265:	3c 0d                	cmp    $0xd,%al
    1267:	75 cf                	jne    1238 <gets+0x11>
  for(i=0; i+1 < max; ){
    1269:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    126b:	8b 45 08             	mov    0x8(%ebp),%eax
    126e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1272:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1275:	5b                   	pop    %ebx
    1276:	5e                   	pop    %esi
    1277:	5f                   	pop    %edi
    1278:	5d                   	pop    %ebp
    1279:	c3                   	ret    

0000127a <stat>:

int
stat(const char *n, struct stat *st)
{
    127a:	55                   	push   %ebp
    127b:	89 e5                	mov    %esp,%ebp
    127d:	56                   	push   %esi
    127e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    127f:	83 ec 08             	sub    $0x8,%esp
    1282:	6a 00                	push   $0x0
    1284:	ff 75 08             	pushl  0x8(%ebp)
    1287:	e8 db 00 00 00       	call   1367 <open>
  if(fd < 0)
    128c:	83 c4 10             	add    $0x10,%esp
    128f:	85 c0                	test   %eax,%eax
    1291:	78 24                	js     12b7 <stat+0x3d>
    1293:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1295:	83 ec 08             	sub    $0x8,%esp
    1298:	ff 75 0c             	pushl  0xc(%ebp)
    129b:	50                   	push   %eax
    129c:	e8 de 00 00 00       	call   137f <fstat>
    12a1:	89 c6                	mov    %eax,%esi
  close(fd);
    12a3:	89 1c 24             	mov    %ebx,(%esp)
    12a6:	e8 a4 00 00 00       	call   134f <close>
  return r;
    12ab:	83 c4 10             	add    $0x10,%esp
}
    12ae:	89 f0                	mov    %esi,%eax
    12b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12b3:	5b                   	pop    %ebx
    12b4:	5e                   	pop    %esi
    12b5:	5d                   	pop    %ebp
    12b6:	c3                   	ret    
    return -1;
    12b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12bc:	eb f0                	jmp    12ae <stat+0x34>

000012be <atoi>:

int
atoi(const char *s)
{
    12be:	55                   	push   %ebp
    12bf:	89 e5                	mov    %esp,%ebp
    12c1:	53                   	push   %ebx
    12c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12c5:	0f b6 11             	movzbl (%ecx),%edx
    12c8:	8d 42 d0             	lea    -0x30(%edx),%eax
    12cb:	3c 09                	cmp    $0x9,%al
    12cd:	77 20                	ja     12ef <atoi+0x31>
  n = 0;
    12cf:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    12d4:	83 c1 01             	add    $0x1,%ecx
    12d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
    12da:	0f be d2             	movsbl %dl,%edx
    12dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    12e1:	0f b6 11             	movzbl (%ecx),%edx
    12e4:	8d 5a d0             	lea    -0x30(%edx),%ebx
    12e7:	80 fb 09             	cmp    $0x9,%bl
    12ea:	76 e8                	jbe    12d4 <atoi+0x16>
  return n;
}
    12ec:	5b                   	pop    %ebx
    12ed:	5d                   	pop    %ebp
    12ee:	c3                   	ret    
  n = 0;
    12ef:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    12f4:	eb f6                	jmp    12ec <atoi+0x2e>

000012f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12f6:	55                   	push   %ebp
    12f7:	89 e5                	mov    %esp,%ebp
    12f9:	56                   	push   %esi
    12fa:	53                   	push   %ebx
    12fb:	8b 45 08             	mov    0x8(%ebp),%eax
    12fe:	8b 75 0c             	mov    0xc(%ebp),%esi
    1301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1304:	85 db                	test   %ebx,%ebx
    1306:	7e 13                	jle    131b <memmove+0x25>
    1308:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    130d:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1311:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1314:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1317:	39 d3                	cmp    %edx,%ebx
    1319:	75 f2                	jne    130d <memmove+0x17>
  return vdst;
}
    131b:	5b                   	pop    %ebx
    131c:	5e                   	pop    %esi
    131d:	5d                   	pop    %ebp
    131e:	c3                   	ret    

0000131f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    131f:	b8 01 00 00 00       	mov    $0x1,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <exit>:
SYSCALL(exit)
    1327:	b8 02 00 00 00       	mov    $0x2,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <wait>:
SYSCALL(wait)
    132f:	b8 03 00 00 00       	mov    $0x3,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <pipe>:
SYSCALL(pipe)
    1337:	b8 04 00 00 00       	mov    $0x4,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <read>:
SYSCALL(read)
    133f:	b8 05 00 00 00       	mov    $0x5,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <write>:
SYSCALL(write)
    1347:	b8 10 00 00 00       	mov    $0x10,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <close>:
SYSCALL(close)
    134f:	b8 15 00 00 00       	mov    $0x15,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <kill>:
SYSCALL(kill)
    1357:	b8 06 00 00 00       	mov    $0x6,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <exec>:
SYSCALL(exec)
    135f:	b8 07 00 00 00       	mov    $0x7,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <open>:
SYSCALL(open)
    1367:	b8 0f 00 00 00       	mov    $0xf,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <mknod>:
SYSCALL(mknod)
    136f:	b8 11 00 00 00       	mov    $0x11,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <unlink>:
SYSCALL(unlink)
    1377:	b8 12 00 00 00       	mov    $0x12,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <fstat>:
SYSCALL(fstat)
    137f:	b8 08 00 00 00       	mov    $0x8,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <link>:
SYSCALL(link)
    1387:	b8 13 00 00 00       	mov    $0x13,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <mkdir>:
SYSCALL(mkdir)
    138f:	b8 14 00 00 00       	mov    $0x14,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <chdir>:
SYSCALL(chdir)
    1397:	b8 09 00 00 00       	mov    $0x9,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <dup>:
SYSCALL(dup)
    139f:	b8 0a 00 00 00       	mov    $0xa,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <getpid>:
SYSCALL(getpid)
    13a7:	b8 0b 00 00 00       	mov    $0xb,%eax
    13ac:	cd 40                	int    $0x40
    13ae:	c3                   	ret    

000013af <sbrk>:
SYSCALL(sbrk)
    13af:	b8 0c 00 00 00       	mov    $0xc,%eax
    13b4:	cd 40                	int    $0x40
    13b6:	c3                   	ret    

000013b7 <sleep>:
SYSCALL(sleep)
    13b7:	b8 0d 00 00 00       	mov    $0xd,%eax
    13bc:	cd 40                	int    $0x40
    13be:	c3                   	ret    

000013bf <uptime>:
SYSCALL(uptime)
    13bf:	b8 0e 00 00 00       	mov    $0xe,%eax
    13c4:	cd 40                	int    $0x40
    13c6:	c3                   	ret    

000013c7 <shmem_access>:
SYSCALL(shmem_access)
    13c7:	b8 16 00 00 00       	mov    $0x16,%eax
    13cc:	cd 40                	int    $0x40
    13ce:	c3                   	ret    

000013cf <shmem_count>:
    13cf:	b8 17 00 00 00       	mov    $0x17,%eax
    13d4:	cd 40                	int    $0x40
    13d6:	c3                   	ret    

000013d7 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    13d7:	55                   	push   %ebp
    13d8:	89 e5                	mov    %esp,%ebp
    13da:	57                   	push   %edi
    13db:	56                   	push   %esi
    13dc:	53                   	push   %ebx
    13dd:	83 ec 3c             	sub    $0x3c,%esp
    13e0:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    13e6:	74 14                	je     13fc <printint+0x25>
    13e8:	85 d2                	test   %edx,%edx
    13ea:	79 10                	jns    13fc <printint+0x25>
    neg = 1;
    x = -xx;
    13ec:	f7 da                	neg    %edx
    neg = 1;
    13ee:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    13f5:	bf 00 00 00 00       	mov    $0x0,%edi
    13fa:	eb 0b                	jmp    1407 <printint+0x30>
  neg = 0;
    13fc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1403:	eb f0                	jmp    13f5 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1405:	89 df                	mov    %ebx,%edi
    1407:	8d 5f 01             	lea    0x1(%edi),%ebx
    140a:	89 d0                	mov    %edx,%eax
    140c:	ba 00 00 00 00       	mov    $0x0,%edx
    1411:	f7 f1                	div    %ecx
    1413:	0f b6 92 b8 17 00 00 	movzbl 0x17b8(%edx),%edx
    141a:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    141e:	89 c2                	mov    %eax,%edx
    1420:	85 c0                	test   %eax,%eax
    1422:	75 e1                	jne    1405 <printint+0x2e>
  if(neg)
    1424:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    1428:	74 08                	je     1432 <printint+0x5b>
    buf[i++] = '-';
    142a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    142f:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1432:	83 eb 01             	sub    $0x1,%ebx
    1435:	78 22                	js     1459 <printint+0x82>
  write(fd, &c, 1);
    1437:	8d 7d d7             	lea    -0x29(%ebp),%edi
    143a:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    143f:	88 45 d7             	mov    %al,-0x29(%ebp)
    1442:	83 ec 04             	sub    $0x4,%esp
    1445:	6a 01                	push   $0x1
    1447:	57                   	push   %edi
    1448:	56                   	push   %esi
    1449:	e8 f9 fe ff ff       	call   1347 <write>
  while(--i >= 0)
    144e:	83 eb 01             	sub    $0x1,%ebx
    1451:	83 c4 10             	add    $0x10,%esp
    1454:	83 fb ff             	cmp    $0xffffffff,%ebx
    1457:	75 e1                	jne    143a <printint+0x63>
    putc(fd, buf[i]);
}
    1459:	8d 65 f4             	lea    -0xc(%ebp),%esp
    145c:	5b                   	pop    %ebx
    145d:	5e                   	pop    %esi
    145e:	5f                   	pop    %edi
    145f:	5d                   	pop    %ebp
    1460:	c3                   	ret    

00001461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1461:	55                   	push   %ebp
    1462:	89 e5                	mov    %esp,%ebp
    1464:	57                   	push   %edi
    1465:	56                   	push   %esi
    1466:	53                   	push   %ebx
    1467:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    146a:	8b 75 0c             	mov    0xc(%ebp),%esi
    146d:	0f b6 1e             	movzbl (%esi),%ebx
    1470:	84 db                	test   %bl,%bl
    1472:	0f 84 b1 01 00 00    	je     1629 <printf+0x1c8>
    1478:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    147b:	8d 45 10             	lea    0x10(%ebp),%eax
    147e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1481:	bf 00 00 00 00       	mov    $0x0,%edi
    1486:	eb 2d                	jmp    14b5 <printf+0x54>
    1488:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    148b:	83 ec 04             	sub    $0x4,%esp
    148e:	6a 01                	push   $0x1
    1490:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1493:	50                   	push   %eax
    1494:	ff 75 08             	pushl  0x8(%ebp)
    1497:	e8 ab fe ff ff       	call   1347 <write>
    149c:	83 c4 10             	add    $0x10,%esp
    149f:	eb 05                	jmp    14a6 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    14a1:	83 ff 25             	cmp    $0x25,%edi
    14a4:	74 22                	je     14c8 <printf+0x67>
    14a6:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    14a9:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    14ad:	84 db                	test   %bl,%bl
    14af:	0f 84 74 01 00 00    	je     1629 <printf+0x1c8>
    c = fmt[i] & 0xff;
    14b5:	0f be d3             	movsbl %bl,%edx
    14b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    14bb:	85 ff                	test   %edi,%edi
    14bd:	75 e2                	jne    14a1 <printf+0x40>
      if(c == '%'){
    14bf:	83 f8 25             	cmp    $0x25,%eax
    14c2:	75 c4                	jne    1488 <printf+0x27>
        state = '%';
    14c4:	89 c7                	mov    %eax,%edi
    14c6:	eb de                	jmp    14a6 <printf+0x45>
      if(c == 'd'){
    14c8:	83 f8 64             	cmp    $0x64,%eax
    14cb:	74 59                	je     1526 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    14cd:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    14d3:	83 fa 70             	cmp    $0x70,%edx
    14d6:	74 7a                	je     1552 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    14d8:	83 f8 73             	cmp    $0x73,%eax
    14db:	0f 84 9d 00 00 00    	je     157e <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14e1:	83 f8 63             	cmp    $0x63,%eax
    14e4:	0f 84 f2 00 00 00    	je     15dc <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    14ea:	83 f8 25             	cmp    $0x25,%eax
    14ed:	0f 84 15 01 00 00    	je     1608 <printf+0x1a7>
    14f3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    14f7:	83 ec 04             	sub    $0x4,%esp
    14fa:	6a 01                	push   $0x1
    14fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
    14ff:	50                   	push   %eax
    1500:	ff 75 08             	pushl  0x8(%ebp)
    1503:	e8 3f fe ff ff       	call   1347 <write>
    1508:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    150b:	83 c4 0c             	add    $0xc,%esp
    150e:	6a 01                	push   $0x1
    1510:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1513:	50                   	push   %eax
    1514:	ff 75 08             	pushl  0x8(%ebp)
    1517:	e8 2b fe ff ff       	call   1347 <write>
    151c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    151f:	bf 00 00 00 00       	mov    $0x0,%edi
    1524:	eb 80                	jmp    14a6 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1526:	83 ec 0c             	sub    $0xc,%esp
    1529:	6a 01                	push   $0x1
    152b:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1530:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1533:	8b 17                	mov    (%edi),%edx
    1535:	8b 45 08             	mov    0x8(%ebp),%eax
    1538:	e8 9a fe ff ff       	call   13d7 <printint>
        ap++;
    153d:	89 f8                	mov    %edi,%eax
    153f:	83 c0 04             	add    $0x4,%eax
    1542:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1545:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1548:	bf 00 00 00 00       	mov    $0x0,%edi
    154d:	e9 54 ff ff ff       	jmp    14a6 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1552:	83 ec 0c             	sub    $0xc,%esp
    1555:	6a 00                	push   $0x0
    1557:	b9 10 00 00 00       	mov    $0x10,%ecx
    155c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    155f:	8b 17                	mov    (%edi),%edx
    1561:	8b 45 08             	mov    0x8(%ebp),%eax
    1564:	e8 6e fe ff ff       	call   13d7 <printint>
        ap++;
    1569:	89 f8                	mov    %edi,%eax
    156b:	83 c0 04             	add    $0x4,%eax
    156e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1571:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1574:	bf 00 00 00 00       	mov    $0x0,%edi
    1579:	e9 28 ff ff ff       	jmp    14a6 <printf+0x45>
        s = (char*)*ap;
    157e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1581:	8b 01                	mov    (%ecx),%eax
        ap++;
    1583:	83 c1 04             	add    $0x4,%ecx
    1586:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1589:	85 c0                	test   %eax,%eax
    158b:	74 13                	je     15a0 <printf+0x13f>
        s = (char*)*ap;
    158d:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    158f:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1592:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    1597:	84 c0                	test   %al,%al
    1599:	75 0f                	jne    15aa <printf+0x149>
    159b:	e9 06 ff ff ff       	jmp    14a6 <printf+0x45>
          s = "(null)";
    15a0:	bb af 17 00 00       	mov    $0x17af,%ebx
        while(*s != 0){
    15a5:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    15aa:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    15ad:	89 75 d0             	mov    %esi,-0x30(%ebp)
    15b0:	8b 75 08             	mov    0x8(%ebp),%esi
    15b3:	88 45 e3             	mov    %al,-0x1d(%ebp)
    15b6:	83 ec 04             	sub    $0x4,%esp
    15b9:	6a 01                	push   $0x1
    15bb:	57                   	push   %edi
    15bc:	56                   	push   %esi
    15bd:	e8 85 fd ff ff       	call   1347 <write>
          s++;
    15c2:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    15c5:	0f b6 03             	movzbl (%ebx),%eax
    15c8:	83 c4 10             	add    $0x10,%esp
    15cb:	84 c0                	test   %al,%al
    15cd:	75 e4                	jne    15b3 <printf+0x152>
    15cf:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    15d2:	bf 00 00 00 00       	mov    $0x0,%edi
    15d7:	e9 ca fe ff ff       	jmp    14a6 <printf+0x45>
        putc(fd, *ap);
    15dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    15df:	8b 07                	mov    (%edi),%eax
    15e1:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    15e4:	83 ec 04             	sub    $0x4,%esp
    15e7:	6a 01                	push   $0x1
    15e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    15ec:	50                   	push   %eax
    15ed:	ff 75 08             	pushl  0x8(%ebp)
    15f0:	e8 52 fd ff ff       	call   1347 <write>
        ap++;
    15f5:	83 c7 04             	add    $0x4,%edi
    15f8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    15fb:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15fe:	bf 00 00 00 00       	mov    $0x0,%edi
    1603:	e9 9e fe ff ff       	jmp    14a6 <printf+0x45>
    1608:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    160b:	83 ec 04             	sub    $0x4,%esp
    160e:	6a 01                	push   $0x1
    1610:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1613:	50                   	push   %eax
    1614:	ff 75 08             	pushl  0x8(%ebp)
    1617:	e8 2b fd ff ff       	call   1347 <write>
    161c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    161f:	bf 00 00 00 00       	mov    $0x0,%edi
    1624:	e9 7d fe ff ff       	jmp    14a6 <printf+0x45>
    }
  }
}
    1629:	8d 65 f4             	lea    -0xc(%ebp),%esp
    162c:	5b                   	pop    %ebx
    162d:	5e                   	pop    %esi
    162e:	5f                   	pop    %edi
    162f:	5d                   	pop    %ebp
    1630:	c3                   	ret    

00001631 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1631:	55                   	push   %ebp
    1632:	89 e5                	mov    %esp,%ebp
    1634:	57                   	push   %edi
    1635:	56                   	push   %esi
    1636:	53                   	push   %ebx
    1637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    163a:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    163d:	a1 60 1a 00 00       	mov    0x1a60,%eax
    1642:	eb 0c                	jmp    1650 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1644:	8b 10                	mov    (%eax),%edx
    1646:	39 c2                	cmp    %eax,%edx
    1648:	77 04                	ja     164e <free+0x1d>
    164a:	39 ca                	cmp    %ecx,%edx
    164c:	77 10                	ja     165e <free+0x2d>
{
    164e:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1650:	39 c8                	cmp    %ecx,%eax
    1652:	73 f0                	jae    1644 <free+0x13>
    1654:	8b 10                	mov    (%eax),%edx
    1656:	39 ca                	cmp    %ecx,%edx
    1658:	77 04                	ja     165e <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    165a:	39 c2                	cmp    %eax,%edx
    165c:	77 f0                	ja     164e <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    165e:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1661:	8b 10                	mov    (%eax),%edx
    1663:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1666:	39 fa                	cmp    %edi,%edx
    1668:	74 19                	je     1683 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    166a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    166d:	8b 50 04             	mov    0x4(%eax),%edx
    1670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1673:	39 f1                	cmp    %esi,%ecx
    1675:	74 1b                	je     1692 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1677:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1679:	a3 60 1a 00 00       	mov    %eax,0x1a60
}
    167e:	5b                   	pop    %ebx
    167f:	5e                   	pop    %esi
    1680:	5f                   	pop    %edi
    1681:	5d                   	pop    %ebp
    1682:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1683:	03 72 04             	add    0x4(%edx),%esi
    1686:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1689:	8b 10                	mov    (%eax),%edx
    168b:	8b 12                	mov    (%edx),%edx
    168d:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1690:	eb db                	jmp    166d <free+0x3c>
    p->s.size += bp->s.size;
    1692:	03 53 fc             	add    -0x4(%ebx),%edx
    1695:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1698:	8b 53 f8             	mov    -0x8(%ebx),%edx
    169b:	89 10                	mov    %edx,(%eax)
    169d:	eb da                	jmp    1679 <free+0x48>

0000169f <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    169f:	55                   	push   %ebp
    16a0:	89 e5                	mov    %esp,%ebp
    16a2:	57                   	push   %edi
    16a3:	56                   	push   %esi
    16a4:	53                   	push   %ebx
    16a5:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16a8:	8b 45 08             	mov    0x8(%ebp),%eax
    16ab:	8d 58 07             	lea    0x7(%eax),%ebx
    16ae:	c1 eb 03             	shr    $0x3,%ebx
    16b1:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    16b4:	8b 15 60 1a 00 00    	mov    0x1a60,%edx
    16ba:	85 d2                	test   %edx,%edx
    16bc:	74 20                	je     16de <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16be:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16c0:	8b 48 04             	mov    0x4(%eax),%ecx
    16c3:	39 cb                	cmp    %ecx,%ebx
    16c5:	76 3c                	jbe    1703 <malloc+0x64>
    16c7:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    16cd:	be 00 10 00 00       	mov    $0x1000,%esi
    16d2:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    16d5:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    16dc:	eb 70                	jmp    174e <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    16de:	c7 05 60 1a 00 00 64 	movl   $0x1a64,0x1a60
    16e5:	1a 00 00 
    16e8:	c7 05 64 1a 00 00 64 	movl   $0x1a64,0x1a64
    16ef:	1a 00 00 
    base.s.size = 0;
    16f2:	c7 05 68 1a 00 00 00 	movl   $0x0,0x1a68
    16f9:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    16fc:	ba 64 1a 00 00       	mov    $0x1a64,%edx
    1701:	eb bb                	jmp    16be <malloc+0x1f>
      if(p->s.size == nunits)
    1703:	39 cb                	cmp    %ecx,%ebx
    1705:	74 1c                	je     1723 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1707:	29 d9                	sub    %ebx,%ecx
    1709:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    170c:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    170f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1712:	89 15 60 1a 00 00    	mov    %edx,0x1a60
      return (void*)(p + 1);
    1718:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    171b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    171e:	5b                   	pop    %ebx
    171f:	5e                   	pop    %esi
    1720:	5f                   	pop    %edi
    1721:	5d                   	pop    %ebp
    1722:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1723:	8b 08                	mov    (%eax),%ecx
    1725:	89 0a                	mov    %ecx,(%edx)
    1727:	eb e9                	jmp    1712 <malloc+0x73>
  hp->s.size = nu;
    1729:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    172c:	83 ec 0c             	sub    $0xc,%esp
    172f:	83 c0 08             	add    $0x8,%eax
    1732:	50                   	push   %eax
    1733:	e8 f9 fe ff ff       	call   1631 <free>
  return freep;
    1738:	8b 15 60 1a 00 00    	mov    0x1a60,%edx
      if((p = morecore(nunits)) == 0)
    173e:	83 c4 10             	add    $0x10,%esp
    1741:	85 d2                	test   %edx,%edx
    1743:	74 2b                	je     1770 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1745:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1747:	8b 48 04             	mov    0x4(%eax),%ecx
    174a:	39 d9                	cmp    %ebx,%ecx
    174c:	73 b5                	jae    1703 <malloc+0x64>
    174e:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1750:	39 05 60 1a 00 00    	cmp    %eax,0x1a60
    1756:	75 ed                	jne    1745 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1758:	83 ec 0c             	sub    $0xc,%esp
    175b:	57                   	push   %edi
    175c:	e8 4e fc ff ff       	call   13af <sbrk>
  if(p == (char*)-1)
    1761:	83 c4 10             	add    $0x10,%esp
    1764:	83 f8 ff             	cmp    $0xffffffff,%eax
    1767:	75 c0                	jne    1729 <malloc+0x8a>
        return 0;
    1769:	b8 00 00 00 00       	mov    $0x0,%eax
    176e:	eb ab                	jmp    171b <malloc+0x7c>
    1770:	b8 00 00 00 00       	mov    $0x0,%eax
    1775:	eb a4                	jmp    171b <malloc+0x7c>
