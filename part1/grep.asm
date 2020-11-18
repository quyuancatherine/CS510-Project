
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	56                   	push   %esi
    1005:	53                   	push   %ebx
    1006:	83 ec 0c             	sub    $0xc,%esp
    1009:	8b 75 08             	mov    0x8(%ebp),%esi
    100c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    100f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    1012:	83 ec 08             	sub    $0x8,%esp
    1015:	53                   	push   %ebx
    1016:	57                   	push   %edi
    1017:	e8 2c 00 00 00       	call   1048 <matchhere>
    101c:	83 c4 10             	add    $0x10,%esp
    101f:	85 c0                	test   %eax,%eax
    1021:	75 18                	jne    103b <matchstar+0x3b>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
    1023:	0f b6 13             	movzbl (%ebx),%edx
    1026:	84 d2                	test   %dl,%dl
    1028:	74 16                	je     1040 <matchstar+0x40>
    102a:	83 c3 01             	add    $0x1,%ebx
    102d:	83 fe 2e             	cmp    $0x2e,%esi
    1030:	74 e0                	je     1012 <matchstar+0x12>
    1032:	0f be d2             	movsbl %dl,%edx
    1035:	39 f2                	cmp    %esi,%edx
    1037:	74 d9                	je     1012 <matchstar+0x12>
    1039:	eb 05                	jmp    1040 <matchstar+0x40>
      return 1;
    103b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
    1040:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1043:	5b                   	pop    %ebx
    1044:	5e                   	pop    %esi
    1045:	5f                   	pop    %edi
    1046:	5d                   	pop    %ebp
    1047:	c3                   	ret    

00001048 <matchhere>:
{
    1048:	55                   	push   %ebp
    1049:	89 e5                	mov    %esp,%ebp
    104b:	53                   	push   %ebx
    104c:	83 ec 04             	sub    $0x4,%esp
    104f:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
    1052:	0f b6 0a             	movzbl (%edx),%ecx
    return 1;
    1055:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '\0')
    105a:	84 c9                	test   %cl,%cl
    105c:	74 29                	je     1087 <matchhere+0x3f>
  if(re[1] == '*')
    105e:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    1062:	3c 2a                	cmp    $0x2a,%al
    1064:	74 26                	je     108c <matchhere+0x44>
  if(re[0] == '$' && re[1] == '\0')
    1066:	84 c0                	test   %al,%al
    1068:	75 05                	jne    106f <matchhere+0x27>
    106a:	80 f9 24             	cmp    $0x24,%cl
    106d:	74 35                	je     10a4 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    106f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1072:	0f b6 18             	movzbl (%eax),%ebx
  return 0;
    1075:	b8 00 00 00 00       	mov    $0x0,%eax
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    107a:	84 db                	test   %bl,%bl
    107c:	74 09                	je     1087 <matchhere+0x3f>
    107e:	38 d9                	cmp    %bl,%cl
    1080:	74 30                	je     10b2 <matchhere+0x6a>
    1082:	80 f9 2e             	cmp    $0x2e,%cl
    1085:	74 2b                	je     10b2 <matchhere+0x6a>
}
    1087:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    108a:	c9                   	leave  
    108b:	c3                   	ret    
    return matchstar(re[0], re+2, text);
    108c:	83 ec 04             	sub    $0x4,%esp
    108f:	ff 75 0c             	pushl  0xc(%ebp)
    1092:	83 c2 02             	add    $0x2,%edx
    1095:	52                   	push   %edx
    1096:	0f be c9             	movsbl %cl,%ecx
    1099:	51                   	push   %ecx
    109a:	e8 61 ff ff ff       	call   1000 <matchstar>
    109f:	83 c4 10             	add    $0x10,%esp
    10a2:	eb e3                	jmp    1087 <matchhere+0x3f>
    return *text == '\0';
    10a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a7:	80 38 00             	cmpb   $0x0,(%eax)
    10aa:	0f 94 c0             	sete   %al
    10ad:	0f b6 c0             	movzbl %al,%eax
    10b0:	eb d5                	jmp    1087 <matchhere+0x3f>
    return matchhere(re+1, text+1);
    10b2:	83 ec 08             	sub    $0x8,%esp
    10b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b8:	83 c0 01             	add    $0x1,%eax
    10bb:	50                   	push   %eax
    10bc:	83 c2 01             	add    $0x1,%edx
    10bf:	52                   	push   %edx
    10c0:	e8 83 ff ff ff       	call   1048 <matchhere>
    10c5:	83 c4 10             	add    $0x10,%esp
    10c8:	eb bd                	jmp    1087 <matchhere+0x3f>

000010ca <match>:
{
    10ca:	55                   	push   %ebp
    10cb:	89 e5                	mov    %esp,%ebp
    10cd:	56                   	push   %esi
    10ce:	53                   	push   %ebx
    10cf:	8b 75 08             	mov    0x8(%ebp),%esi
    10d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
    10d5:	80 3e 5e             	cmpb   $0x5e,(%esi)
    10d8:	74 1c                	je     10f6 <match+0x2c>
    if(matchhere(re, text))
    10da:	83 ec 08             	sub    $0x8,%esp
    10dd:	53                   	push   %ebx
    10de:	56                   	push   %esi
    10df:	e8 64 ff ff ff       	call   1048 <matchhere>
    10e4:	83 c4 10             	add    $0x10,%esp
    10e7:	85 c0                	test   %eax,%eax
    10e9:	75 1d                	jne    1108 <match+0x3e>
  }while(*text++ != '\0');
    10eb:	83 c3 01             	add    $0x1,%ebx
    10ee:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
    10f2:	75 e6                	jne    10da <match+0x10>
    10f4:	eb 17                	jmp    110d <match+0x43>
    return matchhere(re+1, text);
    10f6:	83 ec 08             	sub    $0x8,%esp
    10f9:	53                   	push   %ebx
    10fa:	83 c6 01             	add    $0x1,%esi
    10fd:	56                   	push   %esi
    10fe:	e8 45 ff ff ff       	call   1048 <matchhere>
    1103:	83 c4 10             	add    $0x10,%esp
    1106:	eb 05                	jmp    110d <match+0x43>
      return 1;
    1108:	b8 01 00 00 00       	mov    $0x1,%eax
}
    110d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1110:	5b                   	pop    %ebx
    1111:	5e                   	pop    %esi
    1112:	5d                   	pop    %ebp
    1113:	c3                   	ret    

00001114 <grep>:
{
    1114:	55                   	push   %ebp
    1115:	89 e5                	mov    %esp,%ebp
    1117:	57                   	push   %edi
    1118:	56                   	push   %esi
    1119:	53                   	push   %ebx
    111a:	83 ec 1c             	sub    $0x1c,%esp
  m = 0;
    111d:	bf 00 00 00 00       	mov    $0x0,%edi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1122:	eb 53                	jmp    1177 <grep+0x63>
      p = q+1;
    1124:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
    1127:	83 ec 08             	sub    $0x8,%esp
    112a:	6a 0a                	push   $0xa
    112c:	56                   	push   %esi
    112d:	e8 e6 01 00 00       	call   1318 <strchr>
    1132:	89 c3                	mov    %eax,%ebx
    1134:	83 c4 10             	add    $0x10,%esp
    1137:	85 c0                	test   %eax,%eax
    1139:	74 2d                	je     1168 <grep+0x54>
      *q = 0;
    113b:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
    113e:	83 ec 08             	sub    $0x8,%esp
    1141:	56                   	push   %esi
    1142:	57                   	push   %edi
    1143:	e8 82 ff ff ff       	call   10ca <match>
    1148:	83 c4 10             	add    $0x10,%esp
    114b:	85 c0                	test   %eax,%eax
    114d:	74 d5                	je     1124 <grep+0x10>
        *q = '\n';
    114f:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
    1152:	83 ec 04             	sub    $0x4,%esp
    1155:	8d 43 01             	lea    0x1(%ebx),%eax
    1158:	29 f0                	sub    %esi,%eax
    115a:	50                   	push   %eax
    115b:	56                   	push   %esi
    115c:	6a 01                	push   $0x1
    115e:	e8 0b 03 00 00       	call   146e <write>
    1163:	83 c4 10             	add    $0x10,%esp
    1166:	eb bc                	jmp    1124 <grep+0x10>
    1168:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    if(p == buf)
    116b:	81 fe 20 1c 00 00    	cmp    $0x1c20,%esi
    1171:	74 5b                	je     11ce <grep+0xba>
    if(m > 0){
    1173:	85 ff                	test   %edi,%edi
    1175:	7f 3a                	jg     11b1 <grep+0x9d>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1177:	83 ec 04             	sub    $0x4,%esp
    117a:	b8 ff 03 00 00       	mov    $0x3ff,%eax
    117f:	29 f8                	sub    %edi,%eax
    1181:	50                   	push   %eax
    1182:	8d 87 20 1c 00 00    	lea    0x1c20(%edi),%eax
    1188:	50                   	push   %eax
    1189:	ff 75 0c             	pushl  0xc(%ebp)
    118c:	e8 d5 02 00 00       	call   1466 <read>
    1191:	83 c4 10             	add    $0x10,%esp
    1194:	85 c0                	test   %eax,%eax
    1196:	7e 3d                	jle    11d5 <grep+0xc1>
    m += n;
    1198:	01 c7                	add    %eax,%edi
    buf[m] = '\0';
    119a:	c6 87 20 1c 00 00 00 	movb   $0x0,0x1c20(%edi)
    p = buf;
    11a1:	be 20 1c 00 00       	mov    $0x1c20,%esi
    11a6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    11a9:	8b 7d 08             	mov    0x8(%ebp),%edi
    while((q = strchr(p, '\n')) != 0){
    11ac:	e9 76 ff ff ff       	jmp    1127 <grep+0x13>
      m -= p - buf;
    11b1:	89 f0                	mov    %esi,%eax
    11b3:	2d 20 1c 00 00       	sub    $0x1c20,%eax
    11b8:	29 c7                	sub    %eax,%edi
      memmove(buf, p, m);
    11ba:	83 ec 04             	sub    $0x4,%esp
    11bd:	57                   	push   %edi
    11be:	56                   	push   %esi
    11bf:	68 20 1c 00 00       	push   $0x1c20
    11c4:	e8 54 02 00 00       	call   141d <memmove>
    11c9:	83 c4 10             	add    $0x10,%esp
    11cc:	eb a9                	jmp    1177 <grep+0x63>
      m = 0;
    11ce:	bf 00 00 00 00       	mov    $0x0,%edi
    11d3:	eb a2                	jmp    1177 <grep+0x63>
}
    11d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11d8:	5b                   	pop    %ebx
    11d9:	5e                   	pop    %esi
    11da:	5f                   	pop    %edi
    11db:	5d                   	pop    %ebp
    11dc:	c3                   	ret    

000011dd <main>:
{
    11dd:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    11e1:	83 e4 f0             	and    $0xfffffff0,%esp
    11e4:	ff 71 fc             	pushl  -0x4(%ecx)
    11e7:	55                   	push   %ebp
    11e8:	89 e5                	mov    %esp,%ebp
    11ea:	57                   	push   %edi
    11eb:	56                   	push   %esi
    11ec:	53                   	push   %ebx
    11ed:	51                   	push   %ecx
    11ee:	83 ec 18             	sub    $0x18,%esp
    11f1:	8b 01                	mov    (%ecx),%eax
    11f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    11f6:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc <= 1){
    11f9:	83 f8 01             	cmp    $0x1,%eax
    11fc:	7e 53                	jle    1251 <main+0x74>
  pattern = argv[1];
    11fe:	8b 43 04             	mov    0x4(%ebx),%eax
    1201:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1204:	83 c3 08             	add    $0x8,%ebx
  for(i = 2; i < argc; i++){
    1207:	bf 02 00 00 00       	mov    $0x2,%edi
  if(argc <= 2){
    120c:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
    1210:	7e 53                	jle    1265 <main+0x88>
    if((fd = open(argv[i], 0)) < 0){
    1212:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    1215:	83 ec 08             	sub    $0x8,%esp
    1218:	6a 00                	push   $0x0
    121a:	ff 33                	pushl  (%ebx)
    121c:	e8 6d 02 00 00       	call   148e <open>
    1221:	89 c6                	mov    %eax,%esi
    1223:	83 c4 10             	add    $0x10,%esp
    1226:	85 c0                	test   %eax,%eax
    1228:	78 4b                	js     1275 <main+0x98>
    grep(pattern, fd);
    122a:	83 ec 08             	sub    $0x8,%esp
    122d:	50                   	push   %eax
    122e:	ff 75 e0             	pushl  -0x20(%ebp)
    1231:	e8 de fe ff ff       	call   1114 <grep>
    close(fd);
    1236:	89 34 24             	mov    %esi,(%esp)
    1239:	e8 38 02 00 00       	call   1476 <close>
  for(i = 2; i < argc; i++){
    123e:	83 c7 01             	add    $0x1,%edi
    1241:	83 c3 04             	add    $0x4,%ebx
    1244:	83 c4 10             	add    $0x10,%esp
    1247:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
    124a:	75 c6                	jne    1212 <main+0x35>
  exit();
    124c:	e8 fd 01 00 00       	call   144e <exit>
    printf(2, "usage: grep pattern [file ...]\n");
    1251:	83 ec 08             	sub    $0x8,%esp
    1254:	68 a0 18 00 00       	push   $0x18a0
    1259:	6a 02                	push   $0x2
    125b:	e8 28 03 00 00       	call   1588 <printf>
    exit();
    1260:	e8 e9 01 00 00       	call   144e <exit>
    grep(pattern, 0);
    1265:	83 ec 08             	sub    $0x8,%esp
    1268:	6a 00                	push   $0x0
    126a:	50                   	push   %eax
    126b:	e8 a4 fe ff ff       	call   1114 <grep>
    exit();
    1270:	e8 d9 01 00 00       	call   144e <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1275:	83 ec 04             	sub    $0x4,%esp
    1278:	8b 45 dc             	mov    -0x24(%ebp),%eax
    127b:	ff 30                	pushl  (%eax)
    127d:	68 c0 18 00 00       	push   $0x18c0
    1282:	6a 01                	push   $0x1
    1284:	e8 ff 02 00 00       	call   1588 <printf>
      exit();
    1289:	e8 c0 01 00 00       	call   144e <exit>

0000128e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    128e:	55                   	push   %ebp
    128f:	89 e5                	mov    %esp,%ebp
    1291:	53                   	push   %ebx
    1292:	8b 45 08             	mov    0x8(%ebp),%eax
    1295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1298:	89 c2                	mov    %eax,%edx
    129a:	83 c1 01             	add    $0x1,%ecx
    129d:	83 c2 01             	add    $0x1,%edx
    12a0:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    12a4:	88 5a ff             	mov    %bl,-0x1(%edx)
    12a7:	84 db                	test   %bl,%bl
    12a9:	75 ef                	jne    129a <strcpy+0xc>
    ;
  return os;
}
    12ab:	5b                   	pop    %ebx
    12ac:	5d                   	pop    %ebp
    12ad:	c3                   	ret    

000012ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12ae:	55                   	push   %ebp
    12af:	89 e5                	mov    %esp,%ebp
    12b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
    12b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    12b7:	0f b6 01             	movzbl (%ecx),%eax
    12ba:	84 c0                	test   %al,%al
    12bc:	74 15                	je     12d3 <strcmp+0x25>
    12be:	3a 02                	cmp    (%edx),%al
    12c0:	75 11                	jne    12d3 <strcmp+0x25>
    p++, q++;
    12c2:	83 c1 01             	add    $0x1,%ecx
    12c5:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    12c8:	0f b6 01             	movzbl (%ecx),%eax
    12cb:	84 c0                	test   %al,%al
    12cd:	74 04                	je     12d3 <strcmp+0x25>
    12cf:	3a 02                	cmp    (%edx),%al
    12d1:	74 ef                	je     12c2 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    12d3:	0f b6 c0             	movzbl %al,%eax
    12d6:	0f b6 12             	movzbl (%edx),%edx
    12d9:	29 d0                	sub    %edx,%eax
}
    12db:	5d                   	pop    %ebp
    12dc:	c3                   	ret    

000012dd <strlen>:

uint
strlen(const char *s)
{
    12dd:	55                   	push   %ebp
    12de:	89 e5                	mov    %esp,%ebp
    12e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    12e3:	80 39 00             	cmpb   $0x0,(%ecx)
    12e6:	74 12                	je     12fa <strlen+0x1d>
    12e8:	ba 00 00 00 00       	mov    $0x0,%edx
    12ed:	83 c2 01             	add    $0x1,%edx
    12f0:	89 d0                	mov    %edx,%eax
    12f2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    12f6:	75 f5                	jne    12ed <strlen+0x10>
    ;
  return n;
}
    12f8:	5d                   	pop    %ebp
    12f9:	c3                   	ret    
  for(n = 0; s[n]; n++)
    12fa:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    12ff:	eb f7                	jmp    12f8 <strlen+0x1b>

00001301 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1301:	55                   	push   %ebp
    1302:	89 e5                	mov    %esp,%ebp
    1304:	57                   	push   %edi
    1305:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1308:	89 d7                	mov    %edx,%edi
    130a:	8b 4d 10             	mov    0x10(%ebp),%ecx
    130d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1310:	fc                   	cld    
    1311:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1313:	89 d0                	mov    %edx,%eax
    1315:	5f                   	pop    %edi
    1316:	5d                   	pop    %ebp
    1317:	c3                   	ret    

00001318 <strchr>:

char*
strchr(const char *s, char c)
{
    1318:	55                   	push   %ebp
    1319:	89 e5                	mov    %esp,%ebp
    131b:	53                   	push   %ebx
    131c:	8b 45 08             	mov    0x8(%ebp),%eax
    131f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    1322:	0f b6 10             	movzbl (%eax),%edx
    1325:	84 d2                	test   %dl,%dl
    1327:	74 1e                	je     1347 <strchr+0x2f>
    1329:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    132b:	38 d3                	cmp    %dl,%bl
    132d:	74 15                	je     1344 <strchr+0x2c>
  for(; *s; s++)
    132f:	83 c0 01             	add    $0x1,%eax
    1332:	0f b6 10             	movzbl (%eax),%edx
    1335:	84 d2                	test   %dl,%dl
    1337:	74 06                	je     133f <strchr+0x27>
    if(*s == c)
    1339:	38 ca                	cmp    %cl,%dl
    133b:	75 f2                	jne    132f <strchr+0x17>
    133d:	eb 05                	jmp    1344 <strchr+0x2c>
      return (char*)s;
  return 0;
    133f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1344:	5b                   	pop    %ebx
    1345:	5d                   	pop    %ebp
    1346:	c3                   	ret    
  return 0;
    1347:	b8 00 00 00 00       	mov    $0x0,%eax
    134c:	eb f6                	jmp    1344 <strchr+0x2c>

0000134e <gets>:

char*
gets(char *buf, int max)
{
    134e:	55                   	push   %ebp
    134f:	89 e5                	mov    %esp,%ebp
    1351:	57                   	push   %edi
    1352:	56                   	push   %esi
    1353:	53                   	push   %ebx
    1354:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1357:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    135c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    135f:	8d 5e 01             	lea    0x1(%esi),%ebx
    1362:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1365:	7d 2b                	jge    1392 <gets+0x44>
    cc = read(0, &c, 1);
    1367:	83 ec 04             	sub    $0x4,%esp
    136a:	6a 01                	push   $0x1
    136c:	57                   	push   %edi
    136d:	6a 00                	push   $0x0
    136f:	e8 f2 00 00 00       	call   1466 <read>
    if(cc < 1)
    1374:	83 c4 10             	add    $0x10,%esp
    1377:	85 c0                	test   %eax,%eax
    1379:	7e 17                	jle    1392 <gets+0x44>
      break;
    buf[i++] = c;
    137b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    137f:	8b 55 08             	mov    0x8(%ebp),%edx
    1382:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1386:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1388:	3c 0a                	cmp    $0xa,%al
    138a:	74 04                	je     1390 <gets+0x42>
    138c:	3c 0d                	cmp    $0xd,%al
    138e:	75 cf                	jne    135f <gets+0x11>
  for(i=0; i+1 < max; ){
    1390:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1392:	8b 45 08             	mov    0x8(%ebp),%eax
    1395:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1399:	8d 65 f4             	lea    -0xc(%ebp),%esp
    139c:	5b                   	pop    %ebx
    139d:	5e                   	pop    %esi
    139e:	5f                   	pop    %edi
    139f:	5d                   	pop    %ebp
    13a0:	c3                   	ret    

000013a1 <stat>:

int
stat(const char *n, struct stat *st)
{
    13a1:	55                   	push   %ebp
    13a2:	89 e5                	mov    %esp,%ebp
    13a4:	56                   	push   %esi
    13a5:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13a6:	83 ec 08             	sub    $0x8,%esp
    13a9:	6a 00                	push   $0x0
    13ab:	ff 75 08             	pushl  0x8(%ebp)
    13ae:	e8 db 00 00 00       	call   148e <open>
  if(fd < 0)
    13b3:	83 c4 10             	add    $0x10,%esp
    13b6:	85 c0                	test   %eax,%eax
    13b8:	78 24                	js     13de <stat+0x3d>
    13ba:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    13bc:	83 ec 08             	sub    $0x8,%esp
    13bf:	ff 75 0c             	pushl  0xc(%ebp)
    13c2:	50                   	push   %eax
    13c3:	e8 de 00 00 00       	call   14a6 <fstat>
    13c8:	89 c6                	mov    %eax,%esi
  close(fd);
    13ca:	89 1c 24             	mov    %ebx,(%esp)
    13cd:	e8 a4 00 00 00       	call   1476 <close>
  return r;
    13d2:	83 c4 10             	add    $0x10,%esp
}
    13d5:	89 f0                	mov    %esi,%eax
    13d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
    13da:	5b                   	pop    %ebx
    13db:	5e                   	pop    %esi
    13dc:	5d                   	pop    %ebp
    13dd:	c3                   	ret    
    return -1;
    13de:	be ff ff ff ff       	mov    $0xffffffff,%esi
    13e3:	eb f0                	jmp    13d5 <stat+0x34>

000013e5 <atoi>:

int
atoi(const char *s)
{
    13e5:	55                   	push   %ebp
    13e6:	89 e5                	mov    %esp,%ebp
    13e8:	53                   	push   %ebx
    13e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13ec:	0f b6 11             	movzbl (%ecx),%edx
    13ef:	8d 42 d0             	lea    -0x30(%edx),%eax
    13f2:	3c 09                	cmp    $0x9,%al
    13f4:	77 20                	ja     1416 <atoi+0x31>
  n = 0;
    13f6:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    13fb:	83 c1 01             	add    $0x1,%ecx
    13fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1401:	0f be d2             	movsbl %dl,%edx
    1404:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1408:	0f b6 11             	movzbl (%ecx),%edx
    140b:	8d 5a d0             	lea    -0x30(%edx),%ebx
    140e:	80 fb 09             	cmp    $0x9,%bl
    1411:	76 e8                	jbe    13fb <atoi+0x16>
  return n;
}
    1413:	5b                   	pop    %ebx
    1414:	5d                   	pop    %ebp
    1415:	c3                   	ret    
  n = 0;
    1416:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    141b:	eb f6                	jmp    1413 <atoi+0x2e>

0000141d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    141d:	55                   	push   %ebp
    141e:	89 e5                	mov    %esp,%ebp
    1420:	56                   	push   %esi
    1421:	53                   	push   %ebx
    1422:	8b 45 08             	mov    0x8(%ebp),%eax
    1425:	8b 75 0c             	mov    0xc(%ebp),%esi
    1428:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    142b:	85 db                	test   %ebx,%ebx
    142d:	7e 13                	jle    1442 <memmove+0x25>
    142f:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    1434:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1438:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    143b:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    143e:	39 d3                	cmp    %edx,%ebx
    1440:	75 f2                	jne    1434 <memmove+0x17>
  return vdst;
}
    1442:	5b                   	pop    %ebx
    1443:	5e                   	pop    %esi
    1444:	5d                   	pop    %ebp
    1445:	c3                   	ret    

00001446 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1446:	b8 01 00 00 00       	mov    $0x1,%eax
    144b:	cd 40                	int    $0x40
    144d:	c3                   	ret    

0000144e <exit>:
SYSCALL(exit)
    144e:	b8 02 00 00 00       	mov    $0x2,%eax
    1453:	cd 40                	int    $0x40
    1455:	c3                   	ret    

00001456 <wait>:
SYSCALL(wait)
    1456:	b8 03 00 00 00       	mov    $0x3,%eax
    145b:	cd 40                	int    $0x40
    145d:	c3                   	ret    

0000145e <pipe>:
SYSCALL(pipe)
    145e:	b8 04 00 00 00       	mov    $0x4,%eax
    1463:	cd 40                	int    $0x40
    1465:	c3                   	ret    

00001466 <read>:
SYSCALL(read)
    1466:	b8 05 00 00 00       	mov    $0x5,%eax
    146b:	cd 40                	int    $0x40
    146d:	c3                   	ret    

0000146e <write>:
SYSCALL(write)
    146e:	b8 10 00 00 00       	mov    $0x10,%eax
    1473:	cd 40                	int    $0x40
    1475:	c3                   	ret    

00001476 <close>:
SYSCALL(close)
    1476:	b8 15 00 00 00       	mov    $0x15,%eax
    147b:	cd 40                	int    $0x40
    147d:	c3                   	ret    

0000147e <kill>:
SYSCALL(kill)
    147e:	b8 06 00 00 00       	mov    $0x6,%eax
    1483:	cd 40                	int    $0x40
    1485:	c3                   	ret    

00001486 <exec>:
SYSCALL(exec)
    1486:	b8 07 00 00 00       	mov    $0x7,%eax
    148b:	cd 40                	int    $0x40
    148d:	c3                   	ret    

0000148e <open>:
SYSCALL(open)
    148e:	b8 0f 00 00 00       	mov    $0xf,%eax
    1493:	cd 40                	int    $0x40
    1495:	c3                   	ret    

00001496 <mknod>:
SYSCALL(mknod)
    1496:	b8 11 00 00 00       	mov    $0x11,%eax
    149b:	cd 40                	int    $0x40
    149d:	c3                   	ret    

0000149e <unlink>:
SYSCALL(unlink)
    149e:	b8 12 00 00 00       	mov    $0x12,%eax
    14a3:	cd 40                	int    $0x40
    14a5:	c3                   	ret    

000014a6 <fstat>:
SYSCALL(fstat)
    14a6:	b8 08 00 00 00       	mov    $0x8,%eax
    14ab:	cd 40                	int    $0x40
    14ad:	c3                   	ret    

000014ae <link>:
SYSCALL(link)
    14ae:	b8 13 00 00 00       	mov    $0x13,%eax
    14b3:	cd 40                	int    $0x40
    14b5:	c3                   	ret    

000014b6 <mkdir>:
SYSCALL(mkdir)
    14b6:	b8 14 00 00 00       	mov    $0x14,%eax
    14bb:	cd 40                	int    $0x40
    14bd:	c3                   	ret    

000014be <chdir>:
SYSCALL(chdir)
    14be:	b8 09 00 00 00       	mov    $0x9,%eax
    14c3:	cd 40                	int    $0x40
    14c5:	c3                   	ret    

000014c6 <dup>:
SYSCALL(dup)
    14c6:	b8 0a 00 00 00       	mov    $0xa,%eax
    14cb:	cd 40                	int    $0x40
    14cd:	c3                   	ret    

000014ce <getpid>:
SYSCALL(getpid)
    14ce:	b8 0b 00 00 00       	mov    $0xb,%eax
    14d3:	cd 40                	int    $0x40
    14d5:	c3                   	ret    

000014d6 <sbrk>:
SYSCALL(sbrk)
    14d6:	b8 0c 00 00 00       	mov    $0xc,%eax
    14db:	cd 40                	int    $0x40
    14dd:	c3                   	ret    

000014de <sleep>:
SYSCALL(sleep)
    14de:	b8 0d 00 00 00       	mov    $0xd,%eax
    14e3:	cd 40                	int    $0x40
    14e5:	c3                   	ret    

000014e6 <uptime>:
SYSCALL(uptime)
    14e6:	b8 0e 00 00 00       	mov    $0xe,%eax
    14eb:	cd 40                	int    $0x40
    14ed:	c3                   	ret    

000014ee <shmem_access>:
SYSCALL(shmem_access)
    14ee:	b8 16 00 00 00       	mov    $0x16,%eax
    14f3:	cd 40                	int    $0x40
    14f5:	c3                   	ret    

000014f6 <shmem_count>:
    14f6:	b8 17 00 00 00       	mov    $0x17,%eax
    14fb:	cd 40                	int    $0x40
    14fd:	c3                   	ret    

000014fe <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    14fe:	55                   	push   %ebp
    14ff:	89 e5                	mov    %esp,%ebp
    1501:	57                   	push   %edi
    1502:	56                   	push   %esi
    1503:	53                   	push   %ebx
    1504:	83 ec 3c             	sub    $0x3c,%esp
    1507:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1509:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    150d:	74 14                	je     1523 <printint+0x25>
    150f:	85 d2                	test   %edx,%edx
    1511:	79 10                	jns    1523 <printint+0x25>
    neg = 1;
    x = -xx;
    1513:	f7 da                	neg    %edx
    neg = 1;
    1515:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    151c:	bf 00 00 00 00       	mov    $0x0,%edi
    1521:	eb 0b                	jmp    152e <printint+0x30>
  neg = 0;
    1523:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    152a:	eb f0                	jmp    151c <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    152c:	89 df                	mov    %ebx,%edi
    152e:	8d 5f 01             	lea    0x1(%edi),%ebx
    1531:	89 d0                	mov    %edx,%eax
    1533:	ba 00 00 00 00       	mov    $0x0,%edx
    1538:	f7 f1                	div    %ecx
    153a:	0f b6 92 e0 18 00 00 	movzbl 0x18e0(%edx),%edx
    1541:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1545:	89 c2                	mov    %eax,%edx
    1547:	85 c0                	test   %eax,%eax
    1549:	75 e1                	jne    152c <printint+0x2e>
  if(neg)
    154b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    154f:	74 08                	je     1559 <printint+0x5b>
    buf[i++] = '-';
    1551:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1556:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1559:	83 eb 01             	sub    $0x1,%ebx
    155c:	78 22                	js     1580 <printint+0x82>
  write(fd, &c, 1);
    155e:	8d 7d d7             	lea    -0x29(%ebp),%edi
    1561:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1566:	88 45 d7             	mov    %al,-0x29(%ebp)
    1569:	83 ec 04             	sub    $0x4,%esp
    156c:	6a 01                	push   $0x1
    156e:	57                   	push   %edi
    156f:	56                   	push   %esi
    1570:	e8 f9 fe ff ff       	call   146e <write>
  while(--i >= 0)
    1575:	83 eb 01             	sub    $0x1,%ebx
    1578:	83 c4 10             	add    $0x10,%esp
    157b:	83 fb ff             	cmp    $0xffffffff,%ebx
    157e:	75 e1                	jne    1561 <printint+0x63>
    putc(fd, buf[i]);
}
    1580:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1583:	5b                   	pop    %ebx
    1584:	5e                   	pop    %esi
    1585:	5f                   	pop    %edi
    1586:	5d                   	pop    %ebp
    1587:	c3                   	ret    

00001588 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1588:	55                   	push   %ebp
    1589:	89 e5                	mov    %esp,%ebp
    158b:	57                   	push   %edi
    158c:	56                   	push   %esi
    158d:	53                   	push   %ebx
    158e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1591:	8b 75 0c             	mov    0xc(%ebp),%esi
    1594:	0f b6 1e             	movzbl (%esi),%ebx
    1597:	84 db                	test   %bl,%bl
    1599:	0f 84 b1 01 00 00    	je     1750 <printf+0x1c8>
    159f:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    15a2:	8d 45 10             	lea    0x10(%ebp),%eax
    15a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    15a8:	bf 00 00 00 00       	mov    $0x0,%edi
    15ad:	eb 2d                	jmp    15dc <printf+0x54>
    15af:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    15b2:	83 ec 04             	sub    $0x4,%esp
    15b5:	6a 01                	push   $0x1
    15b7:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    15ba:	50                   	push   %eax
    15bb:	ff 75 08             	pushl  0x8(%ebp)
    15be:	e8 ab fe ff ff       	call   146e <write>
    15c3:	83 c4 10             	add    $0x10,%esp
    15c6:	eb 05                	jmp    15cd <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    15c8:	83 ff 25             	cmp    $0x25,%edi
    15cb:	74 22                	je     15ef <printf+0x67>
    15cd:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    15d0:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    15d4:	84 db                	test   %bl,%bl
    15d6:	0f 84 74 01 00 00    	je     1750 <printf+0x1c8>
    c = fmt[i] & 0xff;
    15dc:	0f be d3             	movsbl %bl,%edx
    15df:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    15e2:	85 ff                	test   %edi,%edi
    15e4:	75 e2                	jne    15c8 <printf+0x40>
      if(c == '%'){
    15e6:	83 f8 25             	cmp    $0x25,%eax
    15e9:	75 c4                	jne    15af <printf+0x27>
        state = '%';
    15eb:	89 c7                	mov    %eax,%edi
    15ed:	eb de                	jmp    15cd <printf+0x45>
      if(c == 'd'){
    15ef:	83 f8 64             	cmp    $0x64,%eax
    15f2:	74 59                	je     164d <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    15f4:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    15fa:	83 fa 70             	cmp    $0x70,%edx
    15fd:	74 7a                	je     1679 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    15ff:	83 f8 73             	cmp    $0x73,%eax
    1602:	0f 84 9d 00 00 00    	je     16a5 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1608:	83 f8 63             	cmp    $0x63,%eax
    160b:	0f 84 f2 00 00 00    	je     1703 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1611:	83 f8 25             	cmp    $0x25,%eax
    1614:	0f 84 15 01 00 00    	je     172f <printf+0x1a7>
    161a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    161e:	83 ec 04             	sub    $0x4,%esp
    1621:	6a 01                	push   $0x1
    1623:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1626:	50                   	push   %eax
    1627:	ff 75 08             	pushl  0x8(%ebp)
    162a:	e8 3f fe ff ff       	call   146e <write>
    162f:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    1632:	83 c4 0c             	add    $0xc,%esp
    1635:	6a 01                	push   $0x1
    1637:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    163a:	50                   	push   %eax
    163b:	ff 75 08             	pushl  0x8(%ebp)
    163e:	e8 2b fe ff ff       	call   146e <write>
    1643:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1646:	bf 00 00 00 00       	mov    $0x0,%edi
    164b:	eb 80                	jmp    15cd <printf+0x45>
        printint(fd, *ap, 10, 1);
    164d:	83 ec 0c             	sub    $0xc,%esp
    1650:	6a 01                	push   $0x1
    1652:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1657:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    165a:	8b 17                	mov    (%edi),%edx
    165c:	8b 45 08             	mov    0x8(%ebp),%eax
    165f:	e8 9a fe ff ff       	call   14fe <printint>
        ap++;
    1664:	89 f8                	mov    %edi,%eax
    1666:	83 c0 04             	add    $0x4,%eax
    1669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    166c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    166f:	bf 00 00 00 00       	mov    $0x0,%edi
    1674:	e9 54 ff ff ff       	jmp    15cd <printf+0x45>
        printint(fd, *ap, 16, 0);
    1679:	83 ec 0c             	sub    $0xc,%esp
    167c:	6a 00                	push   $0x0
    167e:	b9 10 00 00 00       	mov    $0x10,%ecx
    1683:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1686:	8b 17                	mov    (%edi),%edx
    1688:	8b 45 08             	mov    0x8(%ebp),%eax
    168b:	e8 6e fe ff ff       	call   14fe <printint>
        ap++;
    1690:	89 f8                	mov    %edi,%eax
    1692:	83 c0 04             	add    $0x4,%eax
    1695:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1698:	83 c4 10             	add    $0x10,%esp
      state = 0;
    169b:	bf 00 00 00 00       	mov    $0x0,%edi
    16a0:	e9 28 ff ff ff       	jmp    15cd <printf+0x45>
        s = (char*)*ap;
    16a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    16a8:	8b 01                	mov    (%ecx),%eax
        ap++;
    16aa:	83 c1 04             	add    $0x4,%ecx
    16ad:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    16b0:	85 c0                	test   %eax,%eax
    16b2:	74 13                	je     16c7 <printf+0x13f>
        s = (char*)*ap;
    16b4:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    16b6:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    16b9:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    16be:	84 c0                	test   %al,%al
    16c0:	75 0f                	jne    16d1 <printf+0x149>
    16c2:	e9 06 ff ff ff       	jmp    15cd <printf+0x45>
          s = "(null)";
    16c7:	bb d6 18 00 00       	mov    $0x18d6,%ebx
        while(*s != 0){
    16cc:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    16d1:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    16d4:	89 75 d0             	mov    %esi,-0x30(%ebp)
    16d7:	8b 75 08             	mov    0x8(%ebp),%esi
    16da:	88 45 e3             	mov    %al,-0x1d(%ebp)
    16dd:	83 ec 04             	sub    $0x4,%esp
    16e0:	6a 01                	push   $0x1
    16e2:	57                   	push   %edi
    16e3:	56                   	push   %esi
    16e4:	e8 85 fd ff ff       	call   146e <write>
          s++;
    16e9:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    16ec:	0f b6 03             	movzbl (%ebx),%eax
    16ef:	83 c4 10             	add    $0x10,%esp
    16f2:	84 c0                	test   %al,%al
    16f4:	75 e4                	jne    16da <printf+0x152>
    16f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    16f9:	bf 00 00 00 00       	mov    $0x0,%edi
    16fe:	e9 ca fe ff ff       	jmp    15cd <printf+0x45>
        putc(fd, *ap);
    1703:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1706:	8b 07                	mov    (%edi),%eax
    1708:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    170b:	83 ec 04             	sub    $0x4,%esp
    170e:	6a 01                	push   $0x1
    1710:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1713:	50                   	push   %eax
    1714:	ff 75 08             	pushl  0x8(%ebp)
    1717:	e8 52 fd ff ff       	call   146e <write>
        ap++;
    171c:	83 c7 04             	add    $0x4,%edi
    171f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    1722:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1725:	bf 00 00 00 00       	mov    $0x0,%edi
    172a:	e9 9e fe ff ff       	jmp    15cd <printf+0x45>
    172f:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    1732:	83 ec 04             	sub    $0x4,%esp
    1735:	6a 01                	push   $0x1
    1737:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    173a:	50                   	push   %eax
    173b:	ff 75 08             	pushl  0x8(%ebp)
    173e:	e8 2b fd ff ff       	call   146e <write>
    1743:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1746:	bf 00 00 00 00       	mov    $0x0,%edi
    174b:	e9 7d fe ff ff       	jmp    15cd <printf+0x45>
    }
  }
}
    1750:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1753:	5b                   	pop    %ebx
    1754:	5e                   	pop    %esi
    1755:	5f                   	pop    %edi
    1756:	5d                   	pop    %ebp
    1757:	c3                   	ret    

00001758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1758:	55                   	push   %ebp
    1759:	89 e5                	mov    %esp,%ebp
    175b:	57                   	push   %edi
    175c:	56                   	push   %esi
    175d:	53                   	push   %ebx
    175e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1761:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1764:	a1 00 1c 00 00       	mov    0x1c00,%eax
    1769:	eb 0c                	jmp    1777 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    176b:	8b 10                	mov    (%eax),%edx
    176d:	39 c2                	cmp    %eax,%edx
    176f:	77 04                	ja     1775 <free+0x1d>
    1771:	39 ca                	cmp    %ecx,%edx
    1773:	77 10                	ja     1785 <free+0x2d>
{
    1775:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1777:	39 c8                	cmp    %ecx,%eax
    1779:	73 f0                	jae    176b <free+0x13>
    177b:	8b 10                	mov    (%eax),%edx
    177d:	39 ca                	cmp    %ecx,%edx
    177f:	77 04                	ja     1785 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1781:	39 c2                	cmp    %eax,%edx
    1783:	77 f0                	ja     1775 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1785:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1788:	8b 10                	mov    (%eax),%edx
    178a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    178d:	39 fa                	cmp    %edi,%edx
    178f:	74 19                	je     17aa <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1791:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1794:	8b 50 04             	mov    0x4(%eax),%edx
    1797:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    179a:	39 f1                	cmp    %esi,%ecx
    179c:	74 1b                	je     17b9 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    179e:	89 08                	mov    %ecx,(%eax)
  freep = p;
    17a0:	a3 00 1c 00 00       	mov    %eax,0x1c00
}
    17a5:	5b                   	pop    %ebx
    17a6:	5e                   	pop    %esi
    17a7:	5f                   	pop    %edi
    17a8:	5d                   	pop    %ebp
    17a9:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    17aa:	03 72 04             	add    0x4(%edx),%esi
    17ad:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    17b0:	8b 10                	mov    (%eax),%edx
    17b2:	8b 12                	mov    (%edx),%edx
    17b4:	89 53 f8             	mov    %edx,-0x8(%ebx)
    17b7:	eb db                	jmp    1794 <free+0x3c>
    p->s.size += bp->s.size;
    17b9:	03 53 fc             	add    -0x4(%ebx),%edx
    17bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17bf:	8b 53 f8             	mov    -0x8(%ebx),%edx
    17c2:	89 10                	mov    %edx,(%eax)
    17c4:	eb da                	jmp    17a0 <free+0x48>

000017c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17c6:	55                   	push   %ebp
    17c7:	89 e5                	mov    %esp,%ebp
    17c9:	57                   	push   %edi
    17ca:	56                   	push   %esi
    17cb:	53                   	push   %ebx
    17cc:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17cf:	8b 45 08             	mov    0x8(%ebp),%eax
    17d2:	8d 58 07             	lea    0x7(%eax),%ebx
    17d5:	c1 eb 03             	shr    $0x3,%ebx
    17d8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    17db:	8b 15 00 1c 00 00    	mov    0x1c00,%edx
    17e1:	85 d2                	test   %edx,%edx
    17e3:	74 20                	je     1805 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17e5:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    17e7:	8b 48 04             	mov    0x4(%eax),%ecx
    17ea:	39 cb                	cmp    %ecx,%ebx
    17ec:	76 3c                	jbe    182a <malloc+0x64>
    17ee:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    17f4:	be 00 10 00 00       	mov    $0x1000,%esi
    17f9:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    17fc:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    1803:	eb 70                	jmp    1875 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1805:	c7 05 00 1c 00 00 04 	movl   $0x1c04,0x1c00
    180c:	1c 00 00 
    180f:	c7 05 04 1c 00 00 04 	movl   $0x1c04,0x1c04
    1816:	1c 00 00 
    base.s.size = 0;
    1819:	c7 05 08 1c 00 00 00 	movl   $0x0,0x1c08
    1820:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1823:	ba 04 1c 00 00       	mov    $0x1c04,%edx
    1828:	eb bb                	jmp    17e5 <malloc+0x1f>
      if(p->s.size == nunits)
    182a:	39 cb                	cmp    %ecx,%ebx
    182c:	74 1c                	je     184a <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    182e:	29 d9                	sub    %ebx,%ecx
    1830:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1833:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1836:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1839:	89 15 00 1c 00 00    	mov    %edx,0x1c00
      return (void*)(p + 1);
    183f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1842:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1845:	5b                   	pop    %ebx
    1846:	5e                   	pop    %esi
    1847:	5f                   	pop    %edi
    1848:	5d                   	pop    %ebp
    1849:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    184a:	8b 08                	mov    (%eax),%ecx
    184c:	89 0a                	mov    %ecx,(%edx)
    184e:	eb e9                	jmp    1839 <malloc+0x73>
  hp->s.size = nu;
    1850:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1853:	83 ec 0c             	sub    $0xc,%esp
    1856:	83 c0 08             	add    $0x8,%eax
    1859:	50                   	push   %eax
    185a:	e8 f9 fe ff ff       	call   1758 <free>
  return freep;
    185f:	8b 15 00 1c 00 00    	mov    0x1c00,%edx
      if((p = morecore(nunits)) == 0)
    1865:	83 c4 10             	add    $0x10,%esp
    1868:	85 d2                	test   %edx,%edx
    186a:	74 2b                	je     1897 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    186c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    186e:	8b 48 04             	mov    0x4(%eax),%ecx
    1871:	39 d9                	cmp    %ebx,%ecx
    1873:	73 b5                	jae    182a <malloc+0x64>
    1875:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1877:	39 05 00 1c 00 00    	cmp    %eax,0x1c00
    187d:	75 ed                	jne    186c <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    187f:	83 ec 0c             	sub    $0xc,%esp
    1882:	57                   	push   %edi
    1883:	e8 4e fc ff ff       	call   14d6 <sbrk>
  if(p == (char*)-1)
    1888:	83 c4 10             	add    $0x10,%esp
    188b:	83 f8 ff             	cmp    $0xffffffff,%eax
    188e:	75 c0                	jne    1850 <malloc+0x8a>
        return 0;
    1890:	b8 00 00 00 00       	mov    $0x0,%eax
    1895:	eb ab                	jmp    1842 <malloc+0x7c>
    1897:	b8 00 00 00 00       	mov    $0x0,%eax
    189c:	eb a4                	jmp    1842 <malloc+0x7c>
