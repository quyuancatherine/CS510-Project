
_ls:     file format elf32-i386


Disassembly of section .text:

00001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	56                   	push   %esi
    1004:	53                   	push   %ebx
    1005:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1008:	83 ec 0c             	sub    $0xc,%esp
    100b:	53                   	push   %ebx
    100c:	e8 18 03 00 00       	call   1329 <strlen>
    1011:	83 c4 10             	add    $0x10,%esp
    1014:	01 d8                	add    %ebx,%eax
    1016:	72 11                	jb     1029 <fmtname+0x29>
    1018:	80 38 2f             	cmpb   $0x2f,(%eax)
    101b:	74 0c                	je     1029 <fmtname+0x29>
    101d:	83 e8 01             	sub    $0x1,%eax
    1020:	39 c3                	cmp    %eax,%ebx
    1022:	77 05                	ja     1029 <fmtname+0x29>
    1024:	80 38 2f             	cmpb   $0x2f,(%eax)
    1027:	75 f4                	jne    101d <fmtname+0x1d>
    ;
  p++;
    1029:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    102c:	83 ec 0c             	sub    $0xc,%esp
    102f:	53                   	push   %ebx
    1030:	e8 f4 02 00 00       	call   1329 <strlen>
    1035:	83 c4 10             	add    $0x10,%esp
    1038:	83 f8 0d             	cmp    $0xd,%eax
    103b:	76 09                	jbe    1046 <fmtname+0x46>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
    103d:	89 d8                	mov    %ebx,%eax
    103f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1042:	5b                   	pop    %ebx
    1043:	5e                   	pop    %esi
    1044:	5d                   	pop    %ebp
    1045:	c3                   	ret    
  memmove(buf, p, strlen(p));
    1046:	83 ec 0c             	sub    $0xc,%esp
    1049:	53                   	push   %ebx
    104a:	e8 da 02 00 00       	call   1329 <strlen>
    104f:	83 c4 0c             	add    $0xc,%esp
    1052:	50                   	push   %eax
    1053:	53                   	push   %ebx
    1054:	68 0c 1c 00 00       	push   $0x1c0c
    1059:	e8 0b 04 00 00       	call   1469 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    105e:	89 1c 24             	mov    %ebx,(%esp)
    1061:	e8 c3 02 00 00       	call   1329 <strlen>
    1066:	89 c6                	mov    %eax,%esi
    1068:	89 1c 24             	mov    %ebx,(%esp)
    106b:	e8 b9 02 00 00       	call   1329 <strlen>
    1070:	83 c4 0c             	add    $0xc,%esp
    1073:	ba 0e 00 00 00       	mov    $0xe,%edx
    1078:	29 f2                	sub    %esi,%edx
    107a:	52                   	push   %edx
    107b:	6a 20                	push   $0x20
    107d:	05 0c 1c 00 00       	add    $0x1c0c,%eax
    1082:	50                   	push   %eax
    1083:	e8 c5 02 00 00       	call   134d <memset>
  return buf;
    1088:	83 c4 10             	add    $0x10,%esp
    108b:	bb 0c 1c 00 00       	mov    $0x1c0c,%ebx
    1090:	eb ab                	jmp    103d <fmtname+0x3d>

00001092 <ls>:

void
ls(char *path)
{
    1092:	55                   	push   %ebp
    1093:	89 e5                	mov    %esp,%ebp
    1095:	57                   	push   %edi
    1096:	56                   	push   %esi
    1097:	53                   	push   %ebx
    1098:	81 ec 54 02 00 00    	sub    $0x254,%esp
    109e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    10a1:	6a 00                	push   $0x0
    10a3:	53                   	push   %ebx
    10a4:	e8 31 04 00 00       	call   14da <open>
    10a9:	83 c4 10             	add    $0x10,%esp
    10ac:	85 c0                	test   %eax,%eax
    10ae:	78 7b                	js     112b <ls+0x99>
    10b0:	89 c6                	mov    %eax,%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    10b2:	83 ec 08             	sub    $0x8,%esp
    10b5:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
    10bb:	50                   	push   %eax
    10bc:	56                   	push   %esi
    10bd:	e8 30 04 00 00       	call   14f2 <fstat>
    10c2:	83 c4 10             	add    $0x10,%esp
    10c5:	85 c0                	test   %eax,%eax
    10c7:	78 77                	js     1140 <ls+0xae>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
    10c9:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
    10d0:	66 83 f8 01          	cmp    $0x1,%ax
    10d4:	0f 84 83 00 00 00    	je     115d <ls+0xcb>
    10da:	66 83 f8 02          	cmp    $0x2,%ax
    10de:	75 37                	jne    1117 <ls+0x85>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    10e0:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
    10e6:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
    10ec:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
    10f2:	83 ec 0c             	sub    $0xc,%esp
    10f5:	53                   	push   %ebx
    10f6:	e8 05 ff ff ff       	call   1000 <fmtname>
    10fb:	83 c4 08             	add    $0x8,%esp
    10fe:	57                   	push   %edi
    10ff:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
    1105:	6a 02                	push   $0x2
    1107:	50                   	push   %eax
    1108:	68 14 19 00 00       	push   $0x1914
    110d:	6a 01                	push   $0x1
    110f:	e8 c0 04 00 00       	call   15d4 <printf>
    break;
    1114:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
    1117:	83 ec 0c             	sub    $0xc,%esp
    111a:	56                   	push   %esi
    111b:	e8 a2 03 00 00       	call   14c2 <close>
    1120:	83 c4 10             	add    $0x10,%esp
}
    1123:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1126:	5b                   	pop    %ebx
    1127:	5e                   	pop    %esi
    1128:	5f                   	pop    %edi
    1129:	5d                   	pop    %ebp
    112a:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
    112b:	83 ec 04             	sub    $0x4,%esp
    112e:	53                   	push   %ebx
    112f:	68 ec 18 00 00       	push   $0x18ec
    1134:	6a 02                	push   $0x2
    1136:	e8 99 04 00 00       	call   15d4 <printf>
    return;
    113b:	83 c4 10             	add    $0x10,%esp
    113e:	eb e3                	jmp    1123 <ls+0x91>
    printf(2, "ls: cannot stat %s\n", path);
    1140:	83 ec 04             	sub    $0x4,%esp
    1143:	53                   	push   %ebx
    1144:	68 00 19 00 00       	push   $0x1900
    1149:	6a 02                	push   $0x2
    114b:	e8 84 04 00 00       	call   15d4 <printf>
    close(fd);
    1150:	89 34 24             	mov    %esi,(%esp)
    1153:	e8 6a 03 00 00       	call   14c2 <close>
    return;
    1158:	83 c4 10             	add    $0x10,%esp
    115b:	eb c6                	jmp    1123 <ls+0x91>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    115d:	83 ec 0c             	sub    $0xc,%esp
    1160:	53                   	push   %ebx
    1161:	e8 c3 01 00 00       	call   1329 <strlen>
    1166:	83 c0 10             	add    $0x10,%eax
    1169:	83 c4 10             	add    $0x10,%esp
    116c:	3d 00 02 00 00       	cmp    $0x200,%eax
    1171:	76 14                	jbe    1187 <ls+0xf5>
      printf(1, "ls: path too long\n");
    1173:	83 ec 08             	sub    $0x8,%esp
    1176:	68 21 19 00 00       	push   $0x1921
    117b:	6a 01                	push   $0x1
    117d:	e8 52 04 00 00       	call   15d4 <printf>
      break;
    1182:	83 c4 10             	add    $0x10,%esp
    1185:	eb 90                	jmp    1117 <ls+0x85>
    strcpy(buf, path);
    1187:	83 ec 08             	sub    $0x8,%esp
    118a:	53                   	push   %ebx
    118b:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
    1191:	57                   	push   %edi
    1192:	e8 43 01 00 00       	call   12da <strcpy>
    p = buf+strlen(buf);
    1197:	89 3c 24             	mov    %edi,(%esp)
    119a:	e8 8a 01 00 00       	call   1329 <strlen>
    119f:	01 c7                	add    %eax,%edi
    *p++ = '/';
    11a1:	8d 47 01             	lea    0x1(%edi),%eax
    11a4:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    11aa:	c6 07 2f             	movb   $0x2f,(%edi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    11ad:	83 c4 10             	add    $0x10,%esp
    11b0:	8d 9d d8 fd ff ff    	lea    -0x228(%ebp),%ebx
    11b6:	83 ec 04             	sub    $0x4,%esp
    11b9:	6a 10                	push   $0x10
    11bb:	53                   	push   %ebx
    11bc:	56                   	push   %esi
    11bd:	e8 f0 02 00 00       	call   14b2 <read>
    11c2:	83 c4 10             	add    $0x10,%esp
    11c5:	83 f8 10             	cmp    $0x10,%eax
    11c8:	0f 85 49 ff ff ff    	jne    1117 <ls+0x85>
      if(de.inum == 0)
    11ce:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
    11d5:	00 
    11d6:	74 de                	je     11b6 <ls+0x124>
      memmove(p, de.name, DIRSIZ);
    11d8:	83 ec 04             	sub    $0x4,%esp
    11db:	6a 0e                	push   $0xe
    11dd:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
    11e3:	50                   	push   %eax
    11e4:	ff b5 a8 fd ff ff    	pushl  -0x258(%ebp)
    11ea:	e8 7a 02 00 00       	call   1469 <memmove>
      p[DIRSIZ] = 0;
    11ef:	c6 47 0f 00          	movb   $0x0,0xf(%edi)
      if(stat(buf, &st) < 0){
    11f3:	83 c4 08             	add    $0x8,%esp
    11f6:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
    11fc:	50                   	push   %eax
    11fd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
    1203:	50                   	push   %eax
    1204:	e8 e4 01 00 00       	call   13ed <stat>
    1209:	83 c4 10             	add    $0x10,%esp
    120c:	85 c0                	test   %eax,%eax
    120e:	78 5e                	js     126e <ls+0x1dc>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    1210:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
    1216:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
    121c:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
    1222:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
    1228:	0f bf 8d c4 fd ff ff 	movswl -0x23c(%ebp),%ecx
    122f:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
    1235:	83 ec 0c             	sub    $0xc,%esp
    1238:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
    123e:	50                   	push   %eax
    123f:	e8 bc fd ff ff       	call   1000 <fmtname>
    1244:	83 c4 08             	add    $0x8,%esp
    1247:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
    124d:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
    1253:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
    1259:	50                   	push   %eax
    125a:	68 14 19 00 00       	push   $0x1914
    125f:	6a 01                	push   $0x1
    1261:	e8 6e 03 00 00       	call   15d4 <printf>
    1266:	83 c4 20             	add    $0x20,%esp
    1269:	e9 48 ff ff ff       	jmp    11b6 <ls+0x124>
        printf(1, "ls: cannot stat %s\n", buf);
    126e:	83 ec 04             	sub    $0x4,%esp
    1271:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
    1277:	50                   	push   %eax
    1278:	68 00 19 00 00       	push   $0x1900
    127d:	6a 01                	push   $0x1
    127f:	e8 50 03 00 00       	call   15d4 <printf>
        continue;
    1284:	83 c4 10             	add    $0x10,%esp
    1287:	e9 2a ff ff ff       	jmp    11b6 <ls+0x124>

0000128c <main>:

int
main(int argc, char *argv[])
{
    128c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1290:	83 e4 f0             	and    $0xfffffff0,%esp
    1293:	ff 71 fc             	pushl  -0x4(%ecx)
    1296:	55                   	push   %ebp
    1297:	89 e5                	mov    %esp,%ebp
    1299:	56                   	push   %esi
    129a:	53                   	push   %ebx
    129b:	51                   	push   %ecx
    129c:	83 ec 0c             	sub    $0xc,%esp
    129f:	8b 01                	mov    (%ecx),%eax
    12a1:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
    12a4:	83 f8 01             	cmp    $0x1,%eax
    12a7:	7e 1f                	jle    12c8 <main+0x3c>
    12a9:	8d 5a 04             	lea    0x4(%edx),%ebx
    12ac:	8d 34 82             	lea    (%edx,%eax,4),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
    12af:	83 ec 0c             	sub    $0xc,%esp
    12b2:	ff 33                	pushl  (%ebx)
    12b4:	e8 d9 fd ff ff       	call   1092 <ls>
    12b9:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
    12bc:	83 c4 10             	add    $0x10,%esp
    12bf:	39 f3                	cmp    %esi,%ebx
    12c1:	75 ec                	jne    12af <main+0x23>
  exit();
    12c3:	e8 d2 01 00 00       	call   149a <exit>
    ls(".");
    12c8:	83 ec 0c             	sub    $0xc,%esp
    12cb:	68 34 19 00 00       	push   $0x1934
    12d0:	e8 bd fd ff ff       	call   1092 <ls>
    exit();
    12d5:	e8 c0 01 00 00       	call   149a <exit>

000012da <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    12da:	55                   	push   %ebp
    12db:	89 e5                	mov    %esp,%ebp
    12dd:	53                   	push   %ebx
    12de:	8b 45 08             	mov    0x8(%ebp),%eax
    12e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    12e4:	89 c2                	mov    %eax,%edx
    12e6:	83 c1 01             	add    $0x1,%ecx
    12e9:	83 c2 01             	add    $0x1,%edx
    12ec:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    12f0:	88 5a ff             	mov    %bl,-0x1(%edx)
    12f3:	84 db                	test   %bl,%bl
    12f5:	75 ef                	jne    12e6 <strcpy+0xc>
    ;
  return os;
}
    12f7:	5b                   	pop    %ebx
    12f8:	5d                   	pop    %ebp
    12f9:	c3                   	ret    

000012fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    12fa:	55                   	push   %ebp
    12fb:	89 e5                	mov    %esp,%ebp
    12fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1300:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1303:	0f b6 01             	movzbl (%ecx),%eax
    1306:	84 c0                	test   %al,%al
    1308:	74 15                	je     131f <strcmp+0x25>
    130a:	3a 02                	cmp    (%edx),%al
    130c:	75 11                	jne    131f <strcmp+0x25>
    p++, q++;
    130e:	83 c1 01             	add    $0x1,%ecx
    1311:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1314:	0f b6 01             	movzbl (%ecx),%eax
    1317:	84 c0                	test   %al,%al
    1319:	74 04                	je     131f <strcmp+0x25>
    131b:	3a 02                	cmp    (%edx),%al
    131d:	74 ef                	je     130e <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    131f:	0f b6 c0             	movzbl %al,%eax
    1322:	0f b6 12             	movzbl (%edx),%edx
    1325:	29 d0                	sub    %edx,%eax
}
    1327:	5d                   	pop    %ebp
    1328:	c3                   	ret    

00001329 <strlen>:

uint
strlen(const char *s)
{
    1329:	55                   	push   %ebp
    132a:	89 e5                	mov    %esp,%ebp
    132c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    132f:	80 39 00             	cmpb   $0x0,(%ecx)
    1332:	74 12                	je     1346 <strlen+0x1d>
    1334:	ba 00 00 00 00       	mov    $0x0,%edx
    1339:	83 c2 01             	add    $0x1,%edx
    133c:	89 d0                	mov    %edx,%eax
    133e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1342:	75 f5                	jne    1339 <strlen+0x10>
    ;
  return n;
}
    1344:	5d                   	pop    %ebp
    1345:	c3                   	ret    
  for(n = 0; s[n]; n++)
    1346:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    134b:	eb f7                	jmp    1344 <strlen+0x1b>

0000134d <memset>:

void*
memset(void *dst, int c, uint n)
{
    134d:	55                   	push   %ebp
    134e:	89 e5                	mov    %esp,%ebp
    1350:	57                   	push   %edi
    1351:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1354:	89 d7                	mov    %edx,%edi
    1356:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1359:	8b 45 0c             	mov    0xc(%ebp),%eax
    135c:	fc                   	cld    
    135d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    135f:	89 d0                	mov    %edx,%eax
    1361:	5f                   	pop    %edi
    1362:	5d                   	pop    %ebp
    1363:	c3                   	ret    

00001364 <strchr>:

char*
strchr(const char *s, char c)
{
    1364:	55                   	push   %ebp
    1365:	89 e5                	mov    %esp,%ebp
    1367:	53                   	push   %ebx
    1368:	8b 45 08             	mov    0x8(%ebp),%eax
    136b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    136e:	0f b6 10             	movzbl (%eax),%edx
    1371:	84 d2                	test   %dl,%dl
    1373:	74 1e                	je     1393 <strchr+0x2f>
    1375:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1377:	38 d3                	cmp    %dl,%bl
    1379:	74 15                	je     1390 <strchr+0x2c>
  for(; *s; s++)
    137b:	83 c0 01             	add    $0x1,%eax
    137e:	0f b6 10             	movzbl (%eax),%edx
    1381:	84 d2                	test   %dl,%dl
    1383:	74 06                	je     138b <strchr+0x27>
    if(*s == c)
    1385:	38 ca                	cmp    %cl,%dl
    1387:	75 f2                	jne    137b <strchr+0x17>
    1389:	eb 05                	jmp    1390 <strchr+0x2c>
      return (char*)s;
  return 0;
    138b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1390:	5b                   	pop    %ebx
    1391:	5d                   	pop    %ebp
    1392:	c3                   	ret    
  return 0;
    1393:	b8 00 00 00 00       	mov    $0x0,%eax
    1398:	eb f6                	jmp    1390 <strchr+0x2c>

0000139a <gets>:

char*
gets(char *buf, int max)
{
    139a:	55                   	push   %ebp
    139b:	89 e5                	mov    %esp,%ebp
    139d:	57                   	push   %edi
    139e:	56                   	push   %esi
    139f:	53                   	push   %ebx
    13a0:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13a3:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    13a8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    13ab:	8d 5e 01             	lea    0x1(%esi),%ebx
    13ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    13b1:	7d 2b                	jge    13de <gets+0x44>
    cc = read(0, &c, 1);
    13b3:	83 ec 04             	sub    $0x4,%esp
    13b6:	6a 01                	push   $0x1
    13b8:	57                   	push   %edi
    13b9:	6a 00                	push   $0x0
    13bb:	e8 f2 00 00 00       	call   14b2 <read>
    if(cc < 1)
    13c0:	83 c4 10             	add    $0x10,%esp
    13c3:	85 c0                	test   %eax,%eax
    13c5:	7e 17                	jle    13de <gets+0x44>
      break;
    buf[i++] = c;
    13c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    13cb:	8b 55 08             	mov    0x8(%ebp),%edx
    13ce:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    13d2:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    13d4:	3c 0a                	cmp    $0xa,%al
    13d6:	74 04                	je     13dc <gets+0x42>
    13d8:	3c 0d                	cmp    $0xd,%al
    13da:	75 cf                	jne    13ab <gets+0x11>
  for(i=0; i+1 < max; ){
    13dc:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    13de:	8b 45 08             	mov    0x8(%ebp),%eax
    13e1:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    13e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13e8:	5b                   	pop    %ebx
    13e9:	5e                   	pop    %esi
    13ea:	5f                   	pop    %edi
    13eb:	5d                   	pop    %ebp
    13ec:	c3                   	ret    

000013ed <stat>:

int
stat(const char *n, struct stat *st)
{
    13ed:	55                   	push   %ebp
    13ee:	89 e5                	mov    %esp,%ebp
    13f0:	56                   	push   %esi
    13f1:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13f2:	83 ec 08             	sub    $0x8,%esp
    13f5:	6a 00                	push   $0x0
    13f7:	ff 75 08             	pushl  0x8(%ebp)
    13fa:	e8 db 00 00 00       	call   14da <open>
  if(fd < 0)
    13ff:	83 c4 10             	add    $0x10,%esp
    1402:	85 c0                	test   %eax,%eax
    1404:	78 24                	js     142a <stat+0x3d>
    1406:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1408:	83 ec 08             	sub    $0x8,%esp
    140b:	ff 75 0c             	pushl  0xc(%ebp)
    140e:	50                   	push   %eax
    140f:	e8 de 00 00 00       	call   14f2 <fstat>
    1414:	89 c6                	mov    %eax,%esi
  close(fd);
    1416:	89 1c 24             	mov    %ebx,(%esp)
    1419:	e8 a4 00 00 00       	call   14c2 <close>
  return r;
    141e:	83 c4 10             	add    $0x10,%esp
}
    1421:	89 f0                	mov    %esi,%eax
    1423:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1426:	5b                   	pop    %ebx
    1427:	5e                   	pop    %esi
    1428:	5d                   	pop    %ebp
    1429:	c3                   	ret    
    return -1;
    142a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    142f:	eb f0                	jmp    1421 <stat+0x34>

00001431 <atoi>:

int
atoi(const char *s)
{
    1431:	55                   	push   %ebp
    1432:	89 e5                	mov    %esp,%ebp
    1434:	53                   	push   %ebx
    1435:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1438:	0f b6 11             	movzbl (%ecx),%edx
    143b:	8d 42 d0             	lea    -0x30(%edx),%eax
    143e:	3c 09                	cmp    $0x9,%al
    1440:	77 20                	ja     1462 <atoi+0x31>
  n = 0;
    1442:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    1447:	83 c1 01             	add    $0x1,%ecx
    144a:	8d 04 80             	lea    (%eax,%eax,4),%eax
    144d:	0f be d2             	movsbl %dl,%edx
    1450:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1454:	0f b6 11             	movzbl (%ecx),%edx
    1457:	8d 5a d0             	lea    -0x30(%edx),%ebx
    145a:	80 fb 09             	cmp    $0x9,%bl
    145d:	76 e8                	jbe    1447 <atoi+0x16>
  return n;
}
    145f:	5b                   	pop    %ebx
    1460:	5d                   	pop    %ebp
    1461:	c3                   	ret    
  n = 0;
    1462:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1467:	eb f6                	jmp    145f <atoi+0x2e>

00001469 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1469:	55                   	push   %ebp
    146a:	89 e5                	mov    %esp,%ebp
    146c:	56                   	push   %esi
    146d:	53                   	push   %ebx
    146e:	8b 45 08             	mov    0x8(%ebp),%eax
    1471:	8b 75 0c             	mov    0xc(%ebp),%esi
    1474:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1477:	85 db                	test   %ebx,%ebx
    1479:	7e 13                	jle    148e <memmove+0x25>
    147b:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    1480:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1484:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1487:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    148a:	39 d3                	cmp    %edx,%ebx
    148c:	75 f2                	jne    1480 <memmove+0x17>
  return vdst;
}
    148e:	5b                   	pop    %ebx
    148f:	5e                   	pop    %esi
    1490:	5d                   	pop    %ebp
    1491:	c3                   	ret    

00001492 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1492:	b8 01 00 00 00       	mov    $0x1,%eax
    1497:	cd 40                	int    $0x40
    1499:	c3                   	ret    

0000149a <exit>:
SYSCALL(exit)
    149a:	b8 02 00 00 00       	mov    $0x2,%eax
    149f:	cd 40                	int    $0x40
    14a1:	c3                   	ret    

000014a2 <wait>:
SYSCALL(wait)
    14a2:	b8 03 00 00 00       	mov    $0x3,%eax
    14a7:	cd 40                	int    $0x40
    14a9:	c3                   	ret    

000014aa <pipe>:
SYSCALL(pipe)
    14aa:	b8 04 00 00 00       	mov    $0x4,%eax
    14af:	cd 40                	int    $0x40
    14b1:	c3                   	ret    

000014b2 <read>:
SYSCALL(read)
    14b2:	b8 05 00 00 00       	mov    $0x5,%eax
    14b7:	cd 40                	int    $0x40
    14b9:	c3                   	ret    

000014ba <write>:
SYSCALL(write)
    14ba:	b8 10 00 00 00       	mov    $0x10,%eax
    14bf:	cd 40                	int    $0x40
    14c1:	c3                   	ret    

000014c2 <close>:
SYSCALL(close)
    14c2:	b8 15 00 00 00       	mov    $0x15,%eax
    14c7:	cd 40                	int    $0x40
    14c9:	c3                   	ret    

000014ca <kill>:
SYSCALL(kill)
    14ca:	b8 06 00 00 00       	mov    $0x6,%eax
    14cf:	cd 40                	int    $0x40
    14d1:	c3                   	ret    

000014d2 <exec>:
SYSCALL(exec)
    14d2:	b8 07 00 00 00       	mov    $0x7,%eax
    14d7:	cd 40                	int    $0x40
    14d9:	c3                   	ret    

000014da <open>:
SYSCALL(open)
    14da:	b8 0f 00 00 00       	mov    $0xf,%eax
    14df:	cd 40                	int    $0x40
    14e1:	c3                   	ret    

000014e2 <mknod>:
SYSCALL(mknod)
    14e2:	b8 11 00 00 00       	mov    $0x11,%eax
    14e7:	cd 40                	int    $0x40
    14e9:	c3                   	ret    

000014ea <unlink>:
SYSCALL(unlink)
    14ea:	b8 12 00 00 00       	mov    $0x12,%eax
    14ef:	cd 40                	int    $0x40
    14f1:	c3                   	ret    

000014f2 <fstat>:
SYSCALL(fstat)
    14f2:	b8 08 00 00 00       	mov    $0x8,%eax
    14f7:	cd 40                	int    $0x40
    14f9:	c3                   	ret    

000014fa <link>:
SYSCALL(link)
    14fa:	b8 13 00 00 00       	mov    $0x13,%eax
    14ff:	cd 40                	int    $0x40
    1501:	c3                   	ret    

00001502 <mkdir>:
SYSCALL(mkdir)
    1502:	b8 14 00 00 00       	mov    $0x14,%eax
    1507:	cd 40                	int    $0x40
    1509:	c3                   	ret    

0000150a <chdir>:
SYSCALL(chdir)
    150a:	b8 09 00 00 00       	mov    $0x9,%eax
    150f:	cd 40                	int    $0x40
    1511:	c3                   	ret    

00001512 <dup>:
SYSCALL(dup)
    1512:	b8 0a 00 00 00       	mov    $0xa,%eax
    1517:	cd 40                	int    $0x40
    1519:	c3                   	ret    

0000151a <getpid>:
SYSCALL(getpid)
    151a:	b8 0b 00 00 00       	mov    $0xb,%eax
    151f:	cd 40                	int    $0x40
    1521:	c3                   	ret    

00001522 <sbrk>:
SYSCALL(sbrk)
    1522:	b8 0c 00 00 00       	mov    $0xc,%eax
    1527:	cd 40                	int    $0x40
    1529:	c3                   	ret    

0000152a <sleep>:
SYSCALL(sleep)
    152a:	b8 0d 00 00 00       	mov    $0xd,%eax
    152f:	cd 40                	int    $0x40
    1531:	c3                   	ret    

00001532 <uptime>:
SYSCALL(uptime)
    1532:	b8 0e 00 00 00       	mov    $0xe,%eax
    1537:	cd 40                	int    $0x40
    1539:	c3                   	ret    

0000153a <shmem_access>:
SYSCALL(shmem_access)
    153a:	b8 16 00 00 00       	mov    $0x16,%eax
    153f:	cd 40                	int    $0x40
    1541:	c3                   	ret    

00001542 <shmem_count>:
    1542:	b8 17 00 00 00       	mov    $0x17,%eax
    1547:	cd 40                	int    $0x40
    1549:	c3                   	ret    

0000154a <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    154a:	55                   	push   %ebp
    154b:	89 e5                	mov    %esp,%ebp
    154d:	57                   	push   %edi
    154e:	56                   	push   %esi
    154f:	53                   	push   %ebx
    1550:	83 ec 3c             	sub    $0x3c,%esp
    1553:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1555:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1559:	74 14                	je     156f <printint+0x25>
    155b:	85 d2                	test   %edx,%edx
    155d:	79 10                	jns    156f <printint+0x25>
    neg = 1;
    x = -xx;
    155f:	f7 da                	neg    %edx
    neg = 1;
    1561:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1568:	bf 00 00 00 00       	mov    $0x0,%edi
    156d:	eb 0b                	jmp    157a <printint+0x30>
  neg = 0;
    156f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1576:	eb f0                	jmp    1568 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1578:	89 df                	mov    %ebx,%edi
    157a:	8d 5f 01             	lea    0x1(%edi),%ebx
    157d:	89 d0                	mov    %edx,%eax
    157f:	ba 00 00 00 00       	mov    $0x0,%edx
    1584:	f7 f1                	div    %ecx
    1586:	0f b6 92 40 19 00 00 	movzbl 0x1940(%edx),%edx
    158d:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1591:	89 c2                	mov    %eax,%edx
    1593:	85 c0                	test   %eax,%eax
    1595:	75 e1                	jne    1578 <printint+0x2e>
  if(neg)
    1597:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    159b:	74 08                	je     15a5 <printint+0x5b>
    buf[i++] = '-';
    159d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    15a2:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    15a5:	83 eb 01             	sub    $0x1,%ebx
    15a8:	78 22                	js     15cc <printint+0x82>
  write(fd, &c, 1);
    15aa:	8d 7d d7             	lea    -0x29(%ebp),%edi
    15ad:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    15b2:	88 45 d7             	mov    %al,-0x29(%ebp)
    15b5:	83 ec 04             	sub    $0x4,%esp
    15b8:	6a 01                	push   $0x1
    15ba:	57                   	push   %edi
    15bb:	56                   	push   %esi
    15bc:	e8 f9 fe ff ff       	call   14ba <write>
  while(--i >= 0)
    15c1:	83 eb 01             	sub    $0x1,%ebx
    15c4:	83 c4 10             	add    $0x10,%esp
    15c7:	83 fb ff             	cmp    $0xffffffff,%ebx
    15ca:	75 e1                	jne    15ad <printint+0x63>
    putc(fd, buf[i]);
}
    15cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15cf:	5b                   	pop    %ebx
    15d0:	5e                   	pop    %esi
    15d1:	5f                   	pop    %edi
    15d2:	5d                   	pop    %ebp
    15d3:	c3                   	ret    

000015d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    15d4:	55                   	push   %ebp
    15d5:	89 e5                	mov    %esp,%ebp
    15d7:	57                   	push   %edi
    15d8:	56                   	push   %esi
    15d9:	53                   	push   %ebx
    15da:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15dd:	8b 75 0c             	mov    0xc(%ebp),%esi
    15e0:	0f b6 1e             	movzbl (%esi),%ebx
    15e3:	84 db                	test   %bl,%bl
    15e5:	0f 84 b1 01 00 00    	je     179c <printf+0x1c8>
    15eb:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    15ee:	8d 45 10             	lea    0x10(%ebp),%eax
    15f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    15f4:	bf 00 00 00 00       	mov    $0x0,%edi
    15f9:	eb 2d                	jmp    1628 <printf+0x54>
    15fb:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    15fe:	83 ec 04             	sub    $0x4,%esp
    1601:	6a 01                	push   $0x1
    1603:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1606:	50                   	push   %eax
    1607:	ff 75 08             	pushl  0x8(%ebp)
    160a:	e8 ab fe ff ff       	call   14ba <write>
    160f:	83 c4 10             	add    $0x10,%esp
    1612:	eb 05                	jmp    1619 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1614:	83 ff 25             	cmp    $0x25,%edi
    1617:	74 22                	je     163b <printf+0x67>
    1619:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    161c:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1620:	84 db                	test   %bl,%bl
    1622:	0f 84 74 01 00 00    	je     179c <printf+0x1c8>
    c = fmt[i] & 0xff;
    1628:	0f be d3             	movsbl %bl,%edx
    162b:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    162e:	85 ff                	test   %edi,%edi
    1630:	75 e2                	jne    1614 <printf+0x40>
      if(c == '%'){
    1632:	83 f8 25             	cmp    $0x25,%eax
    1635:	75 c4                	jne    15fb <printf+0x27>
        state = '%';
    1637:	89 c7                	mov    %eax,%edi
    1639:	eb de                	jmp    1619 <printf+0x45>
      if(c == 'd'){
    163b:	83 f8 64             	cmp    $0x64,%eax
    163e:	74 59                	je     1699 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1640:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    1646:	83 fa 70             	cmp    $0x70,%edx
    1649:	74 7a                	je     16c5 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    164b:	83 f8 73             	cmp    $0x73,%eax
    164e:	0f 84 9d 00 00 00    	je     16f1 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1654:	83 f8 63             	cmp    $0x63,%eax
    1657:	0f 84 f2 00 00 00    	je     174f <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    165d:	83 f8 25             	cmp    $0x25,%eax
    1660:	0f 84 15 01 00 00    	je     177b <printf+0x1a7>
    1666:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    166a:	83 ec 04             	sub    $0x4,%esp
    166d:	6a 01                	push   $0x1
    166f:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1672:	50                   	push   %eax
    1673:	ff 75 08             	pushl  0x8(%ebp)
    1676:	e8 3f fe ff ff       	call   14ba <write>
    167b:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    167e:	83 c4 0c             	add    $0xc,%esp
    1681:	6a 01                	push   $0x1
    1683:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1686:	50                   	push   %eax
    1687:	ff 75 08             	pushl  0x8(%ebp)
    168a:	e8 2b fe ff ff       	call   14ba <write>
    168f:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1692:	bf 00 00 00 00       	mov    $0x0,%edi
    1697:	eb 80                	jmp    1619 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1699:	83 ec 0c             	sub    $0xc,%esp
    169c:	6a 01                	push   $0x1
    169e:	b9 0a 00 00 00       	mov    $0xa,%ecx
    16a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    16a6:	8b 17                	mov    (%edi),%edx
    16a8:	8b 45 08             	mov    0x8(%ebp),%eax
    16ab:	e8 9a fe ff ff       	call   154a <printint>
        ap++;
    16b0:	89 f8                	mov    %edi,%eax
    16b2:	83 c0 04             	add    $0x4,%eax
    16b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    16b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
    16bb:	bf 00 00 00 00       	mov    $0x0,%edi
    16c0:	e9 54 ff ff ff       	jmp    1619 <printf+0x45>
        printint(fd, *ap, 16, 0);
    16c5:	83 ec 0c             	sub    $0xc,%esp
    16c8:	6a 00                	push   $0x0
    16ca:	b9 10 00 00 00       	mov    $0x10,%ecx
    16cf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    16d2:	8b 17                	mov    (%edi),%edx
    16d4:	8b 45 08             	mov    0x8(%ebp),%eax
    16d7:	e8 6e fe ff ff       	call   154a <printint>
        ap++;
    16dc:	89 f8                	mov    %edi,%eax
    16de:	83 c0 04             	add    $0x4,%eax
    16e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    16e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
    16e7:	bf 00 00 00 00       	mov    $0x0,%edi
    16ec:	e9 28 ff ff ff       	jmp    1619 <printf+0x45>
        s = (char*)*ap;
    16f1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    16f4:	8b 01                	mov    (%ecx),%eax
        ap++;
    16f6:	83 c1 04             	add    $0x4,%ecx
    16f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    16fc:	85 c0                	test   %eax,%eax
    16fe:	74 13                	je     1713 <printf+0x13f>
        s = (char*)*ap;
    1700:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1702:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1705:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    170a:	84 c0                	test   %al,%al
    170c:	75 0f                	jne    171d <printf+0x149>
    170e:	e9 06 ff ff ff       	jmp    1619 <printf+0x45>
          s = "(null)";
    1713:	bb 36 19 00 00       	mov    $0x1936,%ebx
        while(*s != 0){
    1718:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    171d:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1720:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1723:	8b 75 08             	mov    0x8(%ebp),%esi
    1726:	88 45 e3             	mov    %al,-0x1d(%ebp)
    1729:	83 ec 04             	sub    $0x4,%esp
    172c:	6a 01                	push   $0x1
    172e:	57                   	push   %edi
    172f:	56                   	push   %esi
    1730:	e8 85 fd ff ff       	call   14ba <write>
          s++;
    1735:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    1738:	0f b6 03             	movzbl (%ebx),%eax
    173b:	83 c4 10             	add    $0x10,%esp
    173e:	84 c0                	test   %al,%al
    1740:	75 e4                	jne    1726 <printf+0x152>
    1742:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1745:	bf 00 00 00 00       	mov    $0x0,%edi
    174a:	e9 ca fe ff ff       	jmp    1619 <printf+0x45>
        putc(fd, *ap);
    174f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1752:	8b 07                	mov    (%edi),%eax
    1754:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1757:	83 ec 04             	sub    $0x4,%esp
    175a:	6a 01                	push   $0x1
    175c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    175f:	50                   	push   %eax
    1760:	ff 75 08             	pushl  0x8(%ebp)
    1763:	e8 52 fd ff ff       	call   14ba <write>
        ap++;
    1768:	83 c7 04             	add    $0x4,%edi
    176b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    176e:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1771:	bf 00 00 00 00       	mov    $0x0,%edi
    1776:	e9 9e fe ff ff       	jmp    1619 <printf+0x45>
    177b:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    177e:	83 ec 04             	sub    $0x4,%esp
    1781:	6a 01                	push   $0x1
    1783:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1786:	50                   	push   %eax
    1787:	ff 75 08             	pushl  0x8(%ebp)
    178a:	e8 2b fd ff ff       	call   14ba <write>
    178f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1792:	bf 00 00 00 00       	mov    $0x0,%edi
    1797:	e9 7d fe ff ff       	jmp    1619 <printf+0x45>
    }
  }
}
    179c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    179f:	5b                   	pop    %ebx
    17a0:	5e                   	pop    %esi
    17a1:	5f                   	pop    %edi
    17a2:	5d                   	pop    %ebp
    17a3:	c3                   	ret    

000017a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17a4:	55                   	push   %ebp
    17a5:	89 e5                	mov    %esp,%ebp
    17a7:	57                   	push   %edi
    17a8:	56                   	push   %esi
    17a9:	53                   	push   %ebx
    17aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17ad:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b0:	a1 1c 1c 00 00       	mov    0x1c1c,%eax
    17b5:	eb 0c                	jmp    17c3 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17b7:	8b 10                	mov    (%eax),%edx
    17b9:	39 c2                	cmp    %eax,%edx
    17bb:	77 04                	ja     17c1 <free+0x1d>
    17bd:	39 ca                	cmp    %ecx,%edx
    17bf:	77 10                	ja     17d1 <free+0x2d>
{
    17c1:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17c3:	39 c8                	cmp    %ecx,%eax
    17c5:	73 f0                	jae    17b7 <free+0x13>
    17c7:	8b 10                	mov    (%eax),%edx
    17c9:	39 ca                	cmp    %ecx,%edx
    17cb:	77 04                	ja     17d1 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17cd:	39 c2                	cmp    %eax,%edx
    17cf:	77 f0                	ja     17c1 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    17d1:	8b 73 fc             	mov    -0x4(%ebx),%esi
    17d4:	8b 10                	mov    (%eax),%edx
    17d6:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    17d9:	39 fa                	cmp    %edi,%edx
    17db:	74 19                	je     17f6 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    17dd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    17e0:	8b 50 04             	mov    0x4(%eax),%edx
    17e3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    17e6:	39 f1                	cmp    %esi,%ecx
    17e8:	74 1b                	je     1805 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    17ea:	89 08                	mov    %ecx,(%eax)
  freep = p;
    17ec:	a3 1c 1c 00 00       	mov    %eax,0x1c1c
}
    17f1:	5b                   	pop    %ebx
    17f2:	5e                   	pop    %esi
    17f3:	5f                   	pop    %edi
    17f4:	5d                   	pop    %ebp
    17f5:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    17f6:	03 72 04             	add    0x4(%edx),%esi
    17f9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    17fc:	8b 10                	mov    (%eax),%edx
    17fe:	8b 12                	mov    (%edx),%edx
    1800:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1803:	eb db                	jmp    17e0 <free+0x3c>
    p->s.size += bp->s.size;
    1805:	03 53 fc             	add    -0x4(%ebx),%edx
    1808:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    180b:	8b 53 f8             	mov    -0x8(%ebx),%edx
    180e:	89 10                	mov    %edx,(%eax)
    1810:	eb da                	jmp    17ec <free+0x48>

00001812 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1812:	55                   	push   %ebp
    1813:	89 e5                	mov    %esp,%ebp
    1815:	57                   	push   %edi
    1816:	56                   	push   %esi
    1817:	53                   	push   %ebx
    1818:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    181b:	8b 45 08             	mov    0x8(%ebp),%eax
    181e:	8d 58 07             	lea    0x7(%eax),%ebx
    1821:	c1 eb 03             	shr    $0x3,%ebx
    1824:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1827:	8b 15 1c 1c 00 00    	mov    0x1c1c,%edx
    182d:	85 d2                	test   %edx,%edx
    182f:	74 20                	je     1851 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1831:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1833:	8b 48 04             	mov    0x4(%eax),%ecx
    1836:	39 cb                	cmp    %ecx,%ebx
    1838:	76 3c                	jbe    1876 <malloc+0x64>
    183a:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1840:	be 00 10 00 00       	mov    $0x1000,%esi
    1845:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    1848:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    184f:	eb 70                	jmp    18c1 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1851:	c7 05 1c 1c 00 00 20 	movl   $0x1c20,0x1c1c
    1858:	1c 00 00 
    185b:	c7 05 20 1c 00 00 20 	movl   $0x1c20,0x1c20
    1862:	1c 00 00 
    base.s.size = 0;
    1865:	c7 05 24 1c 00 00 00 	movl   $0x0,0x1c24
    186c:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    186f:	ba 20 1c 00 00       	mov    $0x1c20,%edx
    1874:	eb bb                	jmp    1831 <malloc+0x1f>
      if(p->s.size == nunits)
    1876:	39 cb                	cmp    %ecx,%ebx
    1878:	74 1c                	je     1896 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    187a:	29 d9                	sub    %ebx,%ecx
    187c:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    187f:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1882:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1885:	89 15 1c 1c 00 00    	mov    %edx,0x1c1c
      return (void*)(p + 1);
    188b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    188e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1891:	5b                   	pop    %ebx
    1892:	5e                   	pop    %esi
    1893:	5f                   	pop    %edi
    1894:	5d                   	pop    %ebp
    1895:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1896:	8b 08                	mov    (%eax),%ecx
    1898:	89 0a                	mov    %ecx,(%edx)
    189a:	eb e9                	jmp    1885 <malloc+0x73>
  hp->s.size = nu;
    189c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    189f:	83 ec 0c             	sub    $0xc,%esp
    18a2:	83 c0 08             	add    $0x8,%eax
    18a5:	50                   	push   %eax
    18a6:	e8 f9 fe ff ff       	call   17a4 <free>
  return freep;
    18ab:	8b 15 1c 1c 00 00    	mov    0x1c1c,%edx
      if((p = morecore(nunits)) == 0)
    18b1:	83 c4 10             	add    $0x10,%esp
    18b4:	85 d2                	test   %edx,%edx
    18b6:	74 2b                	je     18e3 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    18ba:	8b 48 04             	mov    0x4(%eax),%ecx
    18bd:	39 d9                	cmp    %ebx,%ecx
    18bf:	73 b5                	jae    1876 <malloc+0x64>
    18c1:	89 c2                	mov    %eax,%edx
    if(p == freep)
    18c3:	39 05 1c 1c 00 00    	cmp    %eax,0x1c1c
    18c9:	75 ed                	jne    18b8 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    18cb:	83 ec 0c             	sub    $0xc,%esp
    18ce:	57                   	push   %edi
    18cf:	e8 4e fc ff ff       	call   1522 <sbrk>
  if(p == (char*)-1)
    18d4:	83 c4 10             	add    $0x10,%esp
    18d7:	83 f8 ff             	cmp    $0xffffffff,%eax
    18da:	75 c0                	jne    189c <malloc+0x8a>
        return 0;
    18dc:	b8 00 00 00 00       	mov    $0x0,%eax
    18e1:	eb ab                	jmp    188e <malloc+0x7c>
    18e3:	b8 00 00 00 00       	mov    $0x0,%eax
    18e8:	eb a4                	jmp    188e <malloc+0x7c>
