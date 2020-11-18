
_sh:     file format elf32-i386


Disassembly of section .text:

00001000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	56                   	push   %esi
    1004:	53                   	push   %ebx
    1005:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1008:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
    100b:	83 ec 08             	sub    $0x8,%esp
    100e:	68 e4 1f 00 00       	push   $0x1fe4
    1013:	6a 02                	push   $0x2
    1015:	e8 b2 0c 00 00       	call   1ccc <printf>
  memset(buf, 0, nbuf);
    101a:	83 c4 0c             	add    $0xc,%esp
    101d:	56                   	push   %esi
    101e:	6a 00                	push   $0x0
    1020:	53                   	push   %ebx
    1021:	e8 1f 0a 00 00       	call   1a45 <memset>
  gets(buf, nbuf);
    1026:	83 c4 08             	add    $0x8,%esp
    1029:	56                   	push   %esi
    102a:	53                   	push   %ebx
    102b:	e8 62 0a 00 00       	call   1a92 <gets>
  if(buf[0] == 0) // EOF
    1030:	83 c4 10             	add    $0x10,%esp
    1033:	80 3b 00             	cmpb   $0x0,(%ebx)
    1036:	0f 94 c0             	sete   %al
    1039:	0f b6 c0             	movzbl %al,%eax
    103c:	f7 d8                	neg    %eax
    return -1;
  return 0;
}
    103e:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1041:	5b                   	pop    %ebx
    1042:	5e                   	pop    %esi
    1043:	5d                   	pop    %ebp
    1044:	c3                   	ret    

00001045 <panic>:
  exit();
}

void
panic(char *s)
{
    1045:	55                   	push   %ebp
    1046:	89 e5                	mov    %esp,%ebp
    1048:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
    104b:	ff 75 08             	pushl  0x8(%ebp)
    104e:	68 81 20 00 00       	push   $0x2081
    1053:	6a 02                	push   $0x2
    1055:	e8 72 0c 00 00       	call   1ccc <printf>
  exit();
    105a:	e8 33 0b 00 00       	call   1b92 <exit>

0000105f <fork1>:
}

int
fork1(void)
{
    105f:	55                   	push   %ebp
    1060:	89 e5                	mov    %esp,%ebp
    1062:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
    1065:	e8 20 0b 00 00       	call   1b8a <fork>
  if(pid == -1)
    106a:	83 f8 ff             	cmp    $0xffffffff,%eax
    106d:	74 02                	je     1071 <fork1+0x12>
    panic("fork");
  return pid;
}
    106f:	c9                   	leave  
    1070:	c3                   	ret    
    panic("fork");
    1071:	83 ec 0c             	sub    $0xc,%esp
    1074:	68 e7 1f 00 00       	push   $0x1fe7
    1079:	e8 c7 ff ff ff       	call   1045 <panic>

0000107e <runcmd>:
{
    107e:	55                   	push   %ebp
    107f:	89 e5                	mov    %esp,%ebp
    1081:	53                   	push   %ebx
    1082:	83 ec 14             	sub    $0x14,%esp
    1085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
    1088:	85 db                	test   %ebx,%ebx
    108a:	74 0e                	je     109a <runcmd+0x1c>
  switch(cmd->type){
    108c:	83 3b 05             	cmpl   $0x5,(%ebx)
    108f:	77 0e                	ja     109f <runcmd+0x21>
    1091:	8b 03                	mov    (%ebx),%eax
    1093:	ff 24 85 9c 20 00 00 	jmp    *0x209c(,%eax,4)
    exit();
    109a:	e8 f3 0a 00 00       	call   1b92 <exit>
    panic("runcmd");
    109f:	83 ec 0c             	sub    $0xc,%esp
    10a2:	68 ec 1f 00 00       	push   $0x1fec
    10a7:	e8 99 ff ff ff       	call   1045 <panic>
    if(ecmd->argv[0] == 0)
    10ac:	8b 43 04             	mov    0x4(%ebx),%eax
    10af:	85 c0                	test   %eax,%eax
    10b1:	74 27                	je     10da <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
    10b3:	83 ec 08             	sub    $0x8,%esp
    10b6:	8d 53 04             	lea    0x4(%ebx),%edx
    10b9:	52                   	push   %edx
    10ba:	50                   	push   %eax
    10bb:	e8 0a 0b 00 00       	call   1bca <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    10c0:	83 c4 0c             	add    $0xc,%esp
    10c3:	ff 73 04             	pushl  0x4(%ebx)
    10c6:	68 f3 1f 00 00       	push   $0x1ff3
    10cb:	6a 02                	push   $0x2
    10cd:	e8 fa 0b 00 00       	call   1ccc <printf>
    break;
    10d2:	83 c4 10             	add    $0x10,%esp
    10d5:	e9 3a 01 00 00       	jmp    1214 <runcmd+0x196>
      exit();
    10da:	e8 b3 0a 00 00       	call   1b92 <exit>
    close(rcmd->fd);
    10df:	83 ec 0c             	sub    $0xc,%esp
    10e2:	ff 73 14             	pushl  0x14(%ebx)
    10e5:	e8 d0 0a 00 00       	call   1bba <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    10ea:	83 c4 08             	add    $0x8,%esp
    10ed:	ff 73 10             	pushl  0x10(%ebx)
    10f0:	ff 73 08             	pushl  0x8(%ebx)
    10f3:	e8 da 0a 00 00       	call   1bd2 <open>
    10f8:	83 c4 10             	add    $0x10,%esp
    10fb:	85 c0                	test   %eax,%eax
    10fd:	79 17                	jns    1116 <runcmd+0x98>
      printf(2, "open %s failed\n", rcmd->file);
    10ff:	83 ec 04             	sub    $0x4,%esp
    1102:	ff 73 08             	pushl  0x8(%ebx)
    1105:	68 03 20 00 00       	push   $0x2003
    110a:	6a 02                	push   $0x2
    110c:	e8 bb 0b 00 00       	call   1ccc <printf>
      exit();
    1111:	e8 7c 0a 00 00       	call   1b92 <exit>
    runcmd(rcmd->cmd);
    1116:	83 ec 0c             	sub    $0xc,%esp
    1119:	ff 73 04             	pushl  0x4(%ebx)
    111c:	e8 5d ff ff ff       	call   107e <runcmd>
    if(fork1() == 0)
    1121:	e8 39 ff ff ff       	call   105f <fork1>
    1126:	85 c0                	test   %eax,%eax
    1128:	74 10                	je     113a <runcmd+0xbc>
    wait();
    112a:	e8 6b 0a 00 00       	call   1b9a <wait>
    runcmd(lcmd->right);
    112f:	83 ec 0c             	sub    $0xc,%esp
    1132:	ff 73 08             	pushl  0x8(%ebx)
    1135:	e8 44 ff ff ff       	call   107e <runcmd>
      runcmd(lcmd->left);
    113a:	83 ec 0c             	sub    $0xc,%esp
    113d:	ff 73 04             	pushl  0x4(%ebx)
    1140:	e8 39 ff ff ff       	call   107e <runcmd>
    if(pipe(p) < 0)
    1145:	83 ec 0c             	sub    $0xc,%esp
    1148:	8d 45 f0             	lea    -0x10(%ebp),%eax
    114b:	50                   	push   %eax
    114c:	e8 51 0a 00 00       	call   1ba2 <pipe>
    1151:	83 c4 10             	add    $0x10,%esp
    1154:	85 c0                	test   %eax,%eax
    1156:	78 3a                	js     1192 <runcmd+0x114>
    if(fork1() == 0){
    1158:	e8 02 ff ff ff       	call   105f <fork1>
    115d:	85 c0                	test   %eax,%eax
    115f:	74 3e                	je     119f <runcmd+0x121>
    if(fork1() == 0){
    1161:	e8 f9 fe ff ff       	call   105f <fork1>
    1166:	85 c0                	test   %eax,%eax
    1168:	74 6b                	je     11d5 <runcmd+0x157>
    close(p[0]);
    116a:	83 ec 0c             	sub    $0xc,%esp
    116d:	ff 75 f0             	pushl  -0x10(%ebp)
    1170:	e8 45 0a 00 00       	call   1bba <close>
    close(p[1]);
    1175:	83 c4 04             	add    $0x4,%esp
    1178:	ff 75 f4             	pushl  -0xc(%ebp)
    117b:	e8 3a 0a 00 00       	call   1bba <close>
    wait();
    1180:	e8 15 0a 00 00       	call   1b9a <wait>
    wait();
    1185:	e8 10 0a 00 00       	call   1b9a <wait>
    break;
    118a:	83 c4 10             	add    $0x10,%esp
    118d:	e9 82 00 00 00       	jmp    1214 <runcmd+0x196>
      panic("pipe");
    1192:	83 ec 0c             	sub    $0xc,%esp
    1195:	68 13 20 00 00       	push   $0x2013
    119a:	e8 a6 fe ff ff       	call   1045 <panic>
      close(1);
    119f:	83 ec 0c             	sub    $0xc,%esp
    11a2:	6a 01                	push   $0x1
    11a4:	e8 11 0a 00 00       	call   1bba <close>
      dup(p[1]);
    11a9:	83 c4 04             	add    $0x4,%esp
    11ac:	ff 75 f4             	pushl  -0xc(%ebp)
    11af:	e8 56 0a 00 00       	call   1c0a <dup>
      close(p[0]);
    11b4:	83 c4 04             	add    $0x4,%esp
    11b7:	ff 75 f0             	pushl  -0x10(%ebp)
    11ba:	e8 fb 09 00 00       	call   1bba <close>
      close(p[1]);
    11bf:	83 c4 04             	add    $0x4,%esp
    11c2:	ff 75 f4             	pushl  -0xc(%ebp)
    11c5:	e8 f0 09 00 00       	call   1bba <close>
      runcmd(pcmd->left);
    11ca:	83 c4 04             	add    $0x4,%esp
    11cd:	ff 73 04             	pushl  0x4(%ebx)
    11d0:	e8 a9 fe ff ff       	call   107e <runcmd>
      close(0);
    11d5:	83 ec 0c             	sub    $0xc,%esp
    11d8:	6a 00                	push   $0x0
    11da:	e8 db 09 00 00       	call   1bba <close>
      dup(p[0]);
    11df:	83 c4 04             	add    $0x4,%esp
    11e2:	ff 75 f0             	pushl  -0x10(%ebp)
    11e5:	e8 20 0a 00 00       	call   1c0a <dup>
      close(p[0]);
    11ea:	83 c4 04             	add    $0x4,%esp
    11ed:	ff 75 f0             	pushl  -0x10(%ebp)
    11f0:	e8 c5 09 00 00       	call   1bba <close>
      close(p[1]);
    11f5:	83 c4 04             	add    $0x4,%esp
    11f8:	ff 75 f4             	pushl  -0xc(%ebp)
    11fb:	e8 ba 09 00 00       	call   1bba <close>
      runcmd(pcmd->right);
    1200:	83 c4 04             	add    $0x4,%esp
    1203:	ff 73 08             	pushl  0x8(%ebx)
    1206:	e8 73 fe ff ff       	call   107e <runcmd>
    if(fork1() == 0)
    120b:	e8 4f fe ff ff       	call   105f <fork1>
    1210:	85 c0                	test   %eax,%eax
    1212:	74 05                	je     1219 <runcmd+0x19b>
  exit();
    1214:	e8 79 09 00 00       	call   1b92 <exit>
      runcmd(bcmd->cmd);
    1219:	83 ec 0c             	sub    $0xc,%esp
    121c:	ff 73 04             	pushl  0x4(%ebx)
    121f:	e8 5a fe ff ff       	call   107e <runcmd>

00001224 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    1224:	55                   	push   %ebp
    1225:	89 e5                	mov    %esp,%ebp
    1227:	53                   	push   %ebx
    1228:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    122b:	6a 54                	push   $0x54
    122d:	e8 d8 0c 00 00       	call   1f0a <malloc>
    1232:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    1234:	83 c4 0c             	add    $0xc,%esp
    1237:	6a 54                	push   $0x54
    1239:	6a 00                	push   $0x0
    123b:	50                   	push   %eax
    123c:	e8 04 08 00 00       	call   1a45 <memset>
  cmd->type = EXEC;
    1241:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
    1247:	89 d8                	mov    %ebx,%eax
    1249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    124c:	c9                   	leave  
    124d:	c3                   	ret    

0000124e <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    124e:	55                   	push   %ebp
    124f:	89 e5                	mov    %esp,%ebp
    1251:	53                   	push   %ebx
    1252:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1255:	6a 18                	push   $0x18
    1257:	e8 ae 0c 00 00       	call   1f0a <malloc>
    125c:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    125e:	83 c4 0c             	add    $0xc,%esp
    1261:	6a 18                	push   $0x18
    1263:	6a 00                	push   $0x0
    1265:	50                   	push   %eax
    1266:	e8 da 07 00 00       	call   1a45 <memset>
  cmd->type = REDIR;
    126b:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
    1271:	8b 45 08             	mov    0x8(%ebp),%eax
    1274:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
    1277:	8b 45 0c             	mov    0xc(%ebp),%eax
    127a:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
    127d:	8b 45 10             	mov    0x10(%ebp),%eax
    1280:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
    1283:	8b 45 14             	mov    0x14(%ebp),%eax
    1286:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
    1289:	8b 45 18             	mov    0x18(%ebp),%eax
    128c:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
    128f:	89 d8                	mov    %ebx,%eax
    1291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1294:	c9                   	leave  
    1295:	c3                   	ret    

00001296 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1296:	55                   	push   %ebp
    1297:	89 e5                	mov    %esp,%ebp
    1299:	53                   	push   %ebx
    129a:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    129d:	6a 0c                	push   $0xc
    129f:	e8 66 0c 00 00       	call   1f0a <malloc>
    12a4:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    12a6:	83 c4 0c             	add    $0xc,%esp
    12a9:	6a 0c                	push   $0xc
    12ab:	6a 00                	push   $0x0
    12ad:	50                   	push   %eax
    12ae:	e8 92 07 00 00       	call   1a45 <memset>
  cmd->type = PIPE;
    12b3:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
    12b9:	8b 45 08             	mov    0x8(%ebp),%eax
    12bc:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
    12bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c2:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
    12c5:	89 d8                	mov    %ebx,%eax
    12c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    12ca:	c9                   	leave  
    12cb:	c3                   	ret    

000012cc <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    12cc:	55                   	push   %ebp
    12cd:	89 e5                	mov    %esp,%ebp
    12cf:	53                   	push   %ebx
    12d0:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    12d3:	6a 0c                	push   $0xc
    12d5:	e8 30 0c 00 00       	call   1f0a <malloc>
    12da:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    12dc:	83 c4 0c             	add    $0xc,%esp
    12df:	6a 0c                	push   $0xc
    12e1:	6a 00                	push   $0x0
    12e3:	50                   	push   %eax
    12e4:	e8 5c 07 00 00       	call   1a45 <memset>
  cmd->type = LIST;
    12e9:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
    12ef:	8b 45 08             	mov    0x8(%ebp),%eax
    12f2:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
    12f5:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f8:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
    12fb:	89 d8                	mov    %ebx,%eax
    12fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1300:	c9                   	leave  
    1301:	c3                   	ret    

00001302 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    1302:	55                   	push   %ebp
    1303:	89 e5                	mov    %esp,%ebp
    1305:	53                   	push   %ebx
    1306:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1309:	6a 08                	push   $0x8
    130b:	e8 fa 0b 00 00       	call   1f0a <malloc>
    1310:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
    1312:	83 c4 0c             	add    $0xc,%esp
    1315:	6a 08                	push   $0x8
    1317:	6a 00                	push   $0x0
    1319:	50                   	push   %eax
    131a:	e8 26 07 00 00       	call   1a45 <memset>
  cmd->type = BACK;
    131f:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
    1325:	8b 45 08             	mov    0x8(%ebp),%eax
    1328:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
    132b:	89 d8                	mov    %ebx,%eax
    132d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1330:	c9                   	leave  
    1331:	c3                   	ret    

00001332 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    1332:	55                   	push   %ebp
    1333:	89 e5                	mov    %esp,%ebp
    1335:	57                   	push   %edi
    1336:	56                   	push   %esi
    1337:	53                   	push   %ebx
    1338:	83 ec 0c             	sub    $0xc,%esp
    133b:	8b 75 0c             	mov    0xc(%ebp),%esi
    133e:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
    1341:	8b 45 08             	mov    0x8(%ebp),%eax
    1344:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
    1346:	39 f3                	cmp    %esi,%ebx
    1348:	73 1f                	jae    1369 <gettoken+0x37>
    134a:	83 ec 08             	sub    $0x8,%esp
    134d:	0f be 03             	movsbl (%ebx),%eax
    1350:	50                   	push   %eax
    1351:	68 1c 26 00 00       	push   $0x261c
    1356:	e8 01 07 00 00       	call   1a5c <strchr>
    135b:	83 c4 10             	add    $0x10,%esp
    135e:	85 c0                	test   %eax,%eax
    1360:	74 07                	je     1369 <gettoken+0x37>
    s++;
    1362:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
    1365:	39 de                	cmp    %ebx,%esi
    1367:	75 e1                	jne    134a <gettoken+0x18>
  if(q)
    1369:	85 ff                	test   %edi,%edi
    136b:	74 02                	je     136f <gettoken+0x3d>
    *q = s;
    136d:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
    136f:	0f b6 03             	movzbl (%ebx),%eax
    1372:	0f be f8             	movsbl %al,%edi
  switch(*s){
    1375:	3c 29                	cmp    $0x29,%al
    1377:	0f 8f 99 00 00 00    	jg     1416 <gettoken+0xe4>
    137d:	3c 28                	cmp    $0x28,%al
    137f:	0f 8d a0 00 00 00    	jge    1425 <gettoken+0xf3>
    1385:	84 c0                	test   %al,%al
    1387:	75 3d                	jne    13c6 <gettoken+0x94>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    1389:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    138d:	74 05                	je     1394 <gettoken+0x62>
    *eq = s;
    138f:	8b 45 14             	mov    0x14(%ebp),%eax
    1392:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
    1394:	39 f3                	cmp    %esi,%ebx
    1396:	73 1f                	jae    13b7 <gettoken+0x85>
    1398:	83 ec 08             	sub    $0x8,%esp
    139b:	0f be 03             	movsbl (%ebx),%eax
    139e:	50                   	push   %eax
    139f:	68 1c 26 00 00       	push   $0x261c
    13a4:	e8 b3 06 00 00       	call   1a5c <strchr>
    13a9:	83 c4 10             	add    $0x10,%esp
    13ac:	85 c0                	test   %eax,%eax
    13ae:	74 07                	je     13b7 <gettoken+0x85>
    s++;
    13b0:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
    13b3:	39 de                	cmp    %ebx,%esi
    13b5:	75 e1                	jne    1398 <gettoken+0x66>
  *ps = s;
    13b7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ba:	89 18                	mov    %ebx,(%eax)
  return ret;
}
    13bc:	89 f8                	mov    %edi,%eax
    13be:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13c1:	5b                   	pop    %ebx
    13c2:	5e                   	pop    %esi
    13c3:	5f                   	pop    %edi
    13c4:	5d                   	pop    %ebp
    13c5:	c3                   	ret    
  switch(*s){
    13c6:	3c 26                	cmp    $0x26,%al
    13c8:	74 5b                	je     1425 <gettoken+0xf3>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    13ca:	39 de                	cmp    %ebx,%esi
    13cc:	76 37                	jbe    1405 <gettoken+0xd3>
    13ce:	83 ec 08             	sub    $0x8,%esp
    13d1:	0f be 03             	movsbl (%ebx),%eax
    13d4:	50                   	push   %eax
    13d5:	68 1c 26 00 00       	push   $0x261c
    13da:	e8 7d 06 00 00       	call   1a5c <strchr>
    13df:	83 c4 10             	add    $0x10,%esp
    13e2:	85 c0                	test   %eax,%eax
    13e4:	75 79                	jne    145f <gettoken+0x12d>
    13e6:	83 ec 08             	sub    $0x8,%esp
    13e9:	0f be 03             	movsbl (%ebx),%eax
    13ec:	50                   	push   %eax
    13ed:	68 14 26 00 00       	push   $0x2614
    13f2:	e8 65 06 00 00       	call   1a5c <strchr>
    13f7:	83 c4 10             	add    $0x10,%esp
    13fa:	85 c0                	test   %eax,%eax
    13fc:	75 57                	jne    1455 <gettoken+0x123>
      s++;
    13fe:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    1401:	39 de                	cmp    %ebx,%esi
    1403:	75 c9                	jne    13ce <gettoken+0x9c>
  if(eq)
    1405:	bf 61 00 00 00       	mov    $0x61,%edi
    140a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    140e:	0f 85 7b ff ff ff    	jne    138f <gettoken+0x5d>
    1414:	eb a1                	jmp    13b7 <gettoken+0x85>
  switch(*s){
    1416:	3c 3e                	cmp    $0x3e,%al
    1418:	74 19                	je     1433 <gettoken+0x101>
    141a:	3c 3e                	cmp    $0x3e,%al
    141c:	7f 0f                	jg     142d <gettoken+0xfb>
    141e:	83 e8 3b             	sub    $0x3b,%eax
    1421:	3c 01                	cmp    $0x1,%al
    1423:	77 a5                	ja     13ca <gettoken+0x98>
    s++;
    1425:	83 c3 01             	add    $0x1,%ebx
    break;
    1428:	e9 5c ff ff ff       	jmp    1389 <gettoken+0x57>
  switch(*s){
    142d:	3c 7c                	cmp    $0x7c,%al
    142f:	74 f4                	je     1425 <gettoken+0xf3>
    1431:	eb 97                	jmp    13ca <gettoken+0x98>
    s++;
    1433:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
    1436:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
    143a:	74 0c                	je     1448 <gettoken+0x116>
    s++;
    143c:	89 c3                	mov    %eax,%ebx
  ret = *s;
    143e:	bf 3e 00 00 00       	mov    $0x3e,%edi
    1443:	e9 41 ff ff ff       	jmp    1389 <gettoken+0x57>
      s++;
    1448:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
    144b:	bf 2b 00 00 00       	mov    $0x2b,%edi
    1450:	e9 34 ff ff ff       	jmp    1389 <gettoken+0x57>
    ret = 'a';
    1455:	bf 61 00 00 00       	mov    $0x61,%edi
    145a:	e9 2a ff ff ff       	jmp    1389 <gettoken+0x57>
    145f:	bf 61 00 00 00       	mov    $0x61,%edi
    1464:	e9 20 ff ff ff       	jmp    1389 <gettoken+0x57>

00001469 <peek>:

int
peek(char **ps, char *es, char *toks)
{
    1469:	55                   	push   %ebp
    146a:	89 e5                	mov    %esp,%ebp
    146c:	57                   	push   %edi
    146d:	56                   	push   %esi
    146e:	53                   	push   %ebx
    146f:	83 ec 0c             	sub    $0xc,%esp
    1472:	8b 7d 08             	mov    0x8(%ebp),%edi
    1475:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
    1478:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
    147a:	39 f3                	cmp    %esi,%ebx
    147c:	73 1f                	jae    149d <peek+0x34>
    147e:	83 ec 08             	sub    $0x8,%esp
    1481:	0f be 03             	movsbl (%ebx),%eax
    1484:	50                   	push   %eax
    1485:	68 1c 26 00 00       	push   $0x261c
    148a:	e8 cd 05 00 00       	call   1a5c <strchr>
    148f:	83 c4 10             	add    $0x10,%esp
    1492:	85 c0                	test   %eax,%eax
    1494:	74 07                	je     149d <peek+0x34>
    s++;
    1496:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
    1499:	39 de                	cmp    %ebx,%esi
    149b:	75 e1                	jne    147e <peek+0x15>
  *ps = s;
    149d:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
    149f:	0f b6 13             	movzbl (%ebx),%edx
    14a2:	b8 00 00 00 00       	mov    $0x0,%eax
    14a7:	84 d2                	test   %dl,%dl
    14a9:	75 08                	jne    14b3 <peek+0x4a>
}
    14ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14ae:	5b                   	pop    %ebx
    14af:	5e                   	pop    %esi
    14b0:	5f                   	pop    %edi
    14b1:	5d                   	pop    %ebp
    14b2:	c3                   	ret    
  return *s && strchr(toks, *s);
    14b3:	83 ec 08             	sub    $0x8,%esp
    14b6:	0f be d2             	movsbl %dl,%edx
    14b9:	52                   	push   %edx
    14ba:	ff 75 10             	pushl  0x10(%ebp)
    14bd:	e8 9a 05 00 00       	call   1a5c <strchr>
    14c2:	83 c4 10             	add    $0x10,%esp
    14c5:	85 c0                	test   %eax,%eax
    14c7:	0f 95 c0             	setne  %al
    14ca:	0f b6 c0             	movzbl %al,%eax
    14cd:	eb dc                	jmp    14ab <peek+0x42>

000014cf <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    14cf:	55                   	push   %ebp
    14d0:	89 e5                	mov    %esp,%ebp
    14d2:	57                   	push   %edi
    14d3:	56                   	push   %esi
    14d4:	53                   	push   %ebx
    14d5:	83 ec 1c             	sub    $0x1c,%esp
    14d8:	8b 75 0c             	mov    0xc(%ebp),%esi
    14db:	8b 7d 10             	mov    0x10(%ebp),%edi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    14de:	eb 28                	jmp    1508 <parseredirs+0x39>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    14e0:	83 ec 0c             	sub    $0xc,%esp
    14e3:	68 18 20 00 00       	push   $0x2018
    14e8:	e8 58 fb ff ff       	call   1045 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    14ed:	83 ec 0c             	sub    $0xc,%esp
    14f0:	6a 00                	push   $0x0
    14f2:	6a 00                	push   $0x0
    14f4:	ff 75 e0             	pushl  -0x20(%ebp)
    14f7:	ff 75 e4             	pushl  -0x1c(%ebp)
    14fa:	ff 75 08             	pushl  0x8(%ebp)
    14fd:	e8 4c fd ff ff       	call   124e <redircmd>
    1502:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    1505:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
    1508:	83 ec 04             	sub    $0x4,%esp
    150b:	68 35 20 00 00       	push   $0x2035
    1510:	57                   	push   %edi
    1511:	56                   	push   %esi
    1512:	e8 52 ff ff ff       	call   1469 <peek>
    1517:	83 c4 10             	add    $0x10,%esp
    151a:	85 c0                	test   %eax,%eax
    151c:	74 76                	je     1594 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
    151e:	6a 00                	push   $0x0
    1520:	6a 00                	push   $0x0
    1522:	57                   	push   %edi
    1523:	56                   	push   %esi
    1524:	e8 09 fe ff ff       	call   1332 <gettoken>
    1529:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
    152b:	8d 45 e0             	lea    -0x20(%ebp),%eax
    152e:	50                   	push   %eax
    152f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1532:	50                   	push   %eax
    1533:	57                   	push   %edi
    1534:	56                   	push   %esi
    1535:	e8 f8 fd ff ff       	call   1332 <gettoken>
    153a:	83 c4 20             	add    $0x20,%esp
    153d:	83 f8 61             	cmp    $0x61,%eax
    1540:	75 9e                	jne    14e0 <parseredirs+0x11>
    switch(tok){
    1542:	83 fb 3c             	cmp    $0x3c,%ebx
    1545:	74 a6                	je     14ed <parseredirs+0x1e>
    1547:	83 fb 3e             	cmp    $0x3e,%ebx
    154a:	74 25                	je     1571 <parseredirs+0xa2>
    154c:	83 fb 2b             	cmp    $0x2b,%ebx
    154f:	75 b7                	jne    1508 <parseredirs+0x39>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1551:	83 ec 0c             	sub    $0xc,%esp
    1554:	6a 01                	push   $0x1
    1556:	68 01 02 00 00       	push   $0x201
    155b:	ff 75 e0             	pushl  -0x20(%ebp)
    155e:	ff 75 e4             	pushl  -0x1c(%ebp)
    1561:	ff 75 08             	pushl  0x8(%ebp)
    1564:	e8 e5 fc ff ff       	call   124e <redircmd>
    1569:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    156c:	83 c4 20             	add    $0x20,%esp
    156f:	eb 97                	jmp    1508 <parseredirs+0x39>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1571:	83 ec 0c             	sub    $0xc,%esp
    1574:	6a 01                	push   $0x1
    1576:	68 01 02 00 00       	push   $0x201
    157b:	ff 75 e0             	pushl  -0x20(%ebp)
    157e:	ff 75 e4             	pushl  -0x1c(%ebp)
    1581:	ff 75 08             	pushl  0x8(%ebp)
    1584:	e8 c5 fc ff ff       	call   124e <redircmd>
    1589:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    158c:	83 c4 20             	add    $0x20,%esp
    158f:	e9 74 ff ff ff       	jmp    1508 <parseredirs+0x39>
    }
  }
  return cmd;
}
    1594:	8b 45 08             	mov    0x8(%ebp),%eax
    1597:	8d 65 f4             	lea    -0xc(%ebp),%esp
    159a:	5b                   	pop    %ebx
    159b:	5e                   	pop    %esi
    159c:	5f                   	pop    %edi
    159d:	5d                   	pop    %ebp
    159e:	c3                   	ret    

0000159f <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
    159f:	55                   	push   %ebp
    15a0:	89 e5                	mov    %esp,%ebp
    15a2:	57                   	push   %edi
    15a3:	56                   	push   %esi
    15a4:	53                   	push   %ebx
    15a5:	83 ec 30             	sub    $0x30,%esp
    15a8:	8b 75 08             	mov    0x8(%ebp),%esi
    15ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    15ae:	68 38 20 00 00       	push   $0x2038
    15b3:	57                   	push   %edi
    15b4:	56                   	push   %esi
    15b5:	e8 af fe ff ff       	call   1469 <peek>
    15ba:	83 c4 10             	add    $0x10,%esp
    15bd:	85 c0                	test   %eax,%eax
    15bf:	75 7a                	jne    163b <parseexec+0x9c>
    15c1:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
    15c3:	e8 5c fc ff ff       	call   1224 <execcmd>
    15c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    15cb:	83 ec 04             	sub    $0x4,%esp
    15ce:	57                   	push   %edi
    15cf:	56                   	push   %esi
    15d0:	50                   	push   %eax
    15d1:	e8 f9 fe ff ff       	call   14cf <parseredirs>
    15d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
    15d9:	83 c4 10             	add    $0x10,%esp
    15dc:	83 ec 04             	sub    $0x4,%esp
    15df:	68 4f 20 00 00       	push   $0x204f
    15e4:	57                   	push   %edi
    15e5:	56                   	push   %esi
    15e6:	e8 7e fe ff ff       	call   1469 <peek>
    15eb:	83 c4 10             	add    $0x10,%esp
    15ee:	85 c0                	test   %eax,%eax
    15f0:	75 7e                	jne    1670 <parseexec+0xd1>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    15f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
    15f5:	50                   	push   %eax
    15f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    15f9:	50                   	push   %eax
    15fa:	57                   	push   %edi
    15fb:	56                   	push   %esi
    15fc:	e8 31 fd ff ff       	call   1332 <gettoken>
    1601:	83 c4 10             	add    $0x10,%esp
    1604:	85 c0                	test   %eax,%eax
    1606:	74 68                	je     1670 <parseexec+0xd1>
      break;
    if(tok != 'a')
    1608:	83 f8 61             	cmp    $0x61,%eax
    160b:	75 49                	jne    1656 <parseexec+0xb7>
      panic("syntax");
    cmd->argv[argc] = q;
    160d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1610:	8b 55 d0             	mov    -0x30(%ebp),%edx
    1613:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
    1617:	8b 45 e0             	mov    -0x20(%ebp),%eax
    161a:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
    161e:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
    1621:	83 fb 0a             	cmp    $0xa,%ebx
    1624:	74 3d                	je     1663 <parseexec+0xc4>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
    1626:	83 ec 04             	sub    $0x4,%esp
    1629:	57                   	push   %edi
    162a:	56                   	push   %esi
    162b:	ff 75 d4             	pushl  -0x2c(%ebp)
    162e:	e8 9c fe ff ff       	call   14cf <parseredirs>
    1633:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1636:	83 c4 10             	add    $0x10,%esp
    1639:	eb a1                	jmp    15dc <parseexec+0x3d>
    return parseblock(ps, es);
    163b:	83 ec 08             	sub    $0x8,%esp
    163e:	57                   	push   %edi
    163f:	56                   	push   %esi
    1640:	e8 30 01 00 00       	call   1775 <parseblock>
    1645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1648:	83 c4 10             	add    $0x10,%esp
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
    164b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    164e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1651:	5b                   	pop    %ebx
    1652:	5e                   	pop    %esi
    1653:	5f                   	pop    %edi
    1654:	5d                   	pop    %ebp
    1655:	c3                   	ret    
      panic("syntax");
    1656:	83 ec 0c             	sub    $0xc,%esp
    1659:	68 3a 20 00 00       	push   $0x203a
    165e:	e8 e2 f9 ff ff       	call   1045 <panic>
      panic("too many args");
    1663:	83 ec 0c             	sub    $0xc,%esp
    1666:	68 41 20 00 00       	push   $0x2041
    166b:	e8 d5 f9 ff ff       	call   1045 <panic>
    1670:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1673:	8d 04 98             	lea    (%eax,%ebx,4),%eax
  cmd->argv[argc] = 0;
    1676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
    167d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
    1684:	eb c5                	jmp    164b <parseexec+0xac>

00001686 <parsepipe>:
{
    1686:	55                   	push   %ebp
    1687:	89 e5                	mov    %esp,%ebp
    1689:	57                   	push   %edi
    168a:	56                   	push   %esi
    168b:	53                   	push   %ebx
    168c:	83 ec 14             	sub    $0x14,%esp
    168f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1692:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parseexec(ps, es);
    1695:	56                   	push   %esi
    1696:	53                   	push   %ebx
    1697:	e8 03 ff ff ff       	call   159f <parseexec>
    169c:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
    169e:	83 c4 0c             	add    $0xc,%esp
    16a1:	68 54 20 00 00       	push   $0x2054
    16a6:	56                   	push   %esi
    16a7:	53                   	push   %ebx
    16a8:	e8 bc fd ff ff       	call   1469 <peek>
    16ad:	83 c4 10             	add    $0x10,%esp
    16b0:	85 c0                	test   %eax,%eax
    16b2:	75 0a                	jne    16be <parsepipe+0x38>
}
    16b4:	89 f8                	mov    %edi,%eax
    16b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    16b9:	5b                   	pop    %ebx
    16ba:	5e                   	pop    %esi
    16bb:	5f                   	pop    %edi
    16bc:	5d                   	pop    %ebp
    16bd:	c3                   	ret    
    gettoken(ps, es, 0, 0);
    16be:	6a 00                	push   $0x0
    16c0:	6a 00                	push   $0x0
    16c2:	56                   	push   %esi
    16c3:	53                   	push   %ebx
    16c4:	e8 69 fc ff ff       	call   1332 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    16c9:	83 c4 08             	add    $0x8,%esp
    16cc:	56                   	push   %esi
    16cd:	53                   	push   %ebx
    16ce:	e8 b3 ff ff ff       	call   1686 <parsepipe>
    16d3:	83 c4 08             	add    $0x8,%esp
    16d6:	50                   	push   %eax
    16d7:	57                   	push   %edi
    16d8:	e8 b9 fb ff ff       	call   1296 <pipecmd>
    16dd:	89 c7                	mov    %eax,%edi
    16df:	83 c4 10             	add    $0x10,%esp
  return cmd;
    16e2:	eb d0                	jmp    16b4 <parsepipe+0x2e>

000016e4 <parseline>:
{
    16e4:	55                   	push   %ebp
    16e5:	89 e5                	mov    %esp,%ebp
    16e7:	57                   	push   %edi
    16e8:	56                   	push   %esi
    16e9:	53                   	push   %ebx
    16ea:	83 ec 14             	sub    $0x14,%esp
    16ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parsepipe(ps, es);
    16f3:	56                   	push   %esi
    16f4:	53                   	push   %ebx
    16f5:	e8 8c ff ff ff       	call   1686 <parsepipe>
    16fa:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
    16fc:	83 c4 10             	add    $0x10,%esp
    16ff:	eb 18                	jmp    1719 <parseline+0x35>
    gettoken(ps, es, 0, 0);
    1701:	6a 00                	push   $0x0
    1703:	6a 00                	push   $0x0
    1705:	56                   	push   %esi
    1706:	53                   	push   %ebx
    1707:	e8 26 fc ff ff       	call   1332 <gettoken>
    cmd = backcmd(cmd);
    170c:	89 3c 24             	mov    %edi,(%esp)
    170f:	e8 ee fb ff ff       	call   1302 <backcmd>
    1714:	89 c7                	mov    %eax,%edi
    1716:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
    1719:	83 ec 04             	sub    $0x4,%esp
    171c:	68 56 20 00 00       	push   $0x2056
    1721:	56                   	push   %esi
    1722:	53                   	push   %ebx
    1723:	e8 41 fd ff ff       	call   1469 <peek>
    1728:	83 c4 10             	add    $0x10,%esp
    172b:	85 c0                	test   %eax,%eax
    172d:	75 d2                	jne    1701 <parseline+0x1d>
  if(peek(ps, es, ";")){
    172f:	83 ec 04             	sub    $0x4,%esp
    1732:	68 52 20 00 00       	push   $0x2052
    1737:	56                   	push   %esi
    1738:	53                   	push   %ebx
    1739:	e8 2b fd ff ff       	call   1469 <peek>
    173e:	83 c4 10             	add    $0x10,%esp
    1741:	85 c0                	test   %eax,%eax
    1743:	75 0a                	jne    174f <parseline+0x6b>
}
    1745:	89 f8                	mov    %edi,%eax
    1747:	8d 65 f4             	lea    -0xc(%ebp),%esp
    174a:	5b                   	pop    %ebx
    174b:	5e                   	pop    %esi
    174c:	5f                   	pop    %edi
    174d:	5d                   	pop    %ebp
    174e:	c3                   	ret    
    gettoken(ps, es, 0, 0);
    174f:	6a 00                	push   $0x0
    1751:	6a 00                	push   $0x0
    1753:	56                   	push   %esi
    1754:	53                   	push   %ebx
    1755:	e8 d8 fb ff ff       	call   1332 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    175a:	83 c4 08             	add    $0x8,%esp
    175d:	56                   	push   %esi
    175e:	53                   	push   %ebx
    175f:	e8 80 ff ff ff       	call   16e4 <parseline>
    1764:	83 c4 08             	add    $0x8,%esp
    1767:	50                   	push   %eax
    1768:	57                   	push   %edi
    1769:	e8 5e fb ff ff       	call   12cc <listcmd>
    176e:	89 c7                	mov    %eax,%edi
    1770:	83 c4 10             	add    $0x10,%esp
  return cmd;
    1773:	eb d0                	jmp    1745 <parseline+0x61>

00001775 <parseblock>:
{
    1775:	55                   	push   %ebp
    1776:	89 e5                	mov    %esp,%ebp
    1778:	57                   	push   %edi
    1779:	56                   	push   %esi
    177a:	53                   	push   %ebx
    177b:	83 ec 10             	sub    $0x10,%esp
    177e:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1781:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
    1784:	68 38 20 00 00       	push   $0x2038
    1789:	56                   	push   %esi
    178a:	53                   	push   %ebx
    178b:	e8 d9 fc ff ff       	call   1469 <peek>
    1790:	83 c4 10             	add    $0x10,%esp
    1793:	85 c0                	test   %eax,%eax
    1795:	74 4b                	je     17e2 <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
    1797:	6a 00                	push   $0x0
    1799:	6a 00                	push   $0x0
    179b:	56                   	push   %esi
    179c:	53                   	push   %ebx
    179d:	e8 90 fb ff ff       	call   1332 <gettoken>
  cmd = parseline(ps, es);
    17a2:	83 c4 08             	add    $0x8,%esp
    17a5:	56                   	push   %esi
    17a6:	53                   	push   %ebx
    17a7:	e8 38 ff ff ff       	call   16e4 <parseline>
    17ac:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
    17ae:	83 c4 0c             	add    $0xc,%esp
    17b1:	68 74 20 00 00       	push   $0x2074
    17b6:	56                   	push   %esi
    17b7:	53                   	push   %ebx
    17b8:	e8 ac fc ff ff       	call   1469 <peek>
    17bd:	83 c4 10             	add    $0x10,%esp
    17c0:	85 c0                	test   %eax,%eax
    17c2:	74 2b                	je     17ef <parseblock+0x7a>
  gettoken(ps, es, 0, 0);
    17c4:	6a 00                	push   $0x0
    17c6:	6a 00                	push   $0x0
    17c8:	56                   	push   %esi
    17c9:	53                   	push   %ebx
    17ca:	e8 63 fb ff ff       	call   1332 <gettoken>
  cmd = parseredirs(cmd, ps, es);
    17cf:	83 c4 0c             	add    $0xc,%esp
    17d2:	56                   	push   %esi
    17d3:	53                   	push   %ebx
    17d4:	57                   	push   %edi
    17d5:	e8 f5 fc ff ff       	call   14cf <parseredirs>
}
    17da:	8d 65 f4             	lea    -0xc(%ebp),%esp
    17dd:	5b                   	pop    %ebx
    17de:	5e                   	pop    %esi
    17df:	5f                   	pop    %edi
    17e0:	5d                   	pop    %ebp
    17e1:	c3                   	ret    
    panic("parseblock");
    17e2:	83 ec 0c             	sub    $0xc,%esp
    17e5:	68 58 20 00 00       	push   $0x2058
    17ea:	e8 56 f8 ff ff       	call   1045 <panic>
    panic("syntax - missing )");
    17ef:	83 ec 0c             	sub    $0xc,%esp
    17f2:	68 63 20 00 00       	push   $0x2063
    17f7:	e8 49 f8 ff ff       	call   1045 <panic>

000017fc <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    17fc:	55                   	push   %ebp
    17fd:	89 e5                	mov    %esp,%ebp
    17ff:	53                   	push   %ebx
    1800:	83 ec 04             	sub    $0x4,%esp
    1803:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1806:	85 db                	test   %ebx,%ebx
    1808:	74 3c                	je     1846 <nulterminate+0x4a>
    return 0;

  switch(cmd->type){
    180a:	83 3b 05             	cmpl   $0x5,(%ebx)
    180d:	77 37                	ja     1846 <nulterminate+0x4a>
    180f:	8b 03                	mov    (%ebx),%eax
    1811:	ff 24 85 b4 20 00 00 	jmp    *0x20b4(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1818:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
    181c:	74 28                	je     1846 <nulterminate+0x4a>
    181e:	8d 43 08             	lea    0x8(%ebx),%eax
      *ecmd->eargv[i] = 0;
    1821:	8b 50 24             	mov    0x24(%eax),%edx
    1824:	c6 02 00             	movb   $0x0,(%edx)
    1827:	83 c0 04             	add    $0x4,%eax
    for(i=0; ecmd->argv[i]; i++)
    182a:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
    182e:	75 f1                	jne    1821 <nulterminate+0x25>
    1830:	eb 14                	jmp    1846 <nulterminate+0x4a>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    1832:	83 ec 0c             	sub    $0xc,%esp
    1835:	ff 73 04             	pushl  0x4(%ebx)
    1838:	e8 bf ff ff ff       	call   17fc <nulterminate>
    *rcmd->efile = 0;
    183d:	8b 43 0c             	mov    0xc(%ebx),%eax
    1840:	c6 00 00             	movb   $0x0,(%eax)
    break;
    1843:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
    1846:	89 d8                	mov    %ebx,%eax
    1848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    184b:	c9                   	leave  
    184c:	c3                   	ret    
    nulterminate(pcmd->left);
    184d:	83 ec 0c             	sub    $0xc,%esp
    1850:	ff 73 04             	pushl  0x4(%ebx)
    1853:	e8 a4 ff ff ff       	call   17fc <nulterminate>
    nulterminate(pcmd->right);
    1858:	83 c4 04             	add    $0x4,%esp
    185b:	ff 73 08             	pushl  0x8(%ebx)
    185e:	e8 99 ff ff ff       	call   17fc <nulterminate>
    break;
    1863:	83 c4 10             	add    $0x10,%esp
    1866:	eb de                	jmp    1846 <nulterminate+0x4a>
    nulterminate(lcmd->left);
    1868:	83 ec 0c             	sub    $0xc,%esp
    186b:	ff 73 04             	pushl  0x4(%ebx)
    186e:	e8 89 ff ff ff       	call   17fc <nulterminate>
    nulterminate(lcmd->right);
    1873:	83 c4 04             	add    $0x4,%esp
    1876:	ff 73 08             	pushl  0x8(%ebx)
    1879:	e8 7e ff ff ff       	call   17fc <nulterminate>
    break;
    187e:	83 c4 10             	add    $0x10,%esp
    1881:	eb c3                	jmp    1846 <nulterminate+0x4a>
    nulterminate(bcmd->cmd);
    1883:	83 ec 0c             	sub    $0xc,%esp
    1886:	ff 73 04             	pushl  0x4(%ebx)
    1889:	e8 6e ff ff ff       	call   17fc <nulterminate>
    break;
    188e:	83 c4 10             	add    $0x10,%esp
    1891:	eb b3                	jmp    1846 <nulterminate+0x4a>

00001893 <parsecmd>:
{
    1893:	55                   	push   %ebp
    1894:	89 e5                	mov    %esp,%ebp
    1896:	56                   	push   %esi
    1897:	53                   	push   %ebx
  es = s + strlen(s);
    1898:	8b 5d 08             	mov    0x8(%ebp),%ebx
    189b:	83 ec 0c             	sub    $0xc,%esp
    189e:	53                   	push   %ebx
    189f:	e8 7d 01 00 00       	call   1a21 <strlen>
    18a4:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
    18a6:	83 c4 08             	add    $0x8,%esp
    18a9:	53                   	push   %ebx
    18aa:	8d 45 08             	lea    0x8(%ebp),%eax
    18ad:	50                   	push   %eax
    18ae:	e8 31 fe ff ff       	call   16e4 <parseline>
    18b3:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
    18b5:	83 c4 0c             	add    $0xc,%esp
    18b8:	68 02 20 00 00       	push   $0x2002
    18bd:	53                   	push   %ebx
    18be:	8d 45 08             	lea    0x8(%ebp),%eax
    18c1:	50                   	push   %eax
    18c2:	e8 a2 fb ff ff       	call   1469 <peek>
  if(s != es){
    18c7:	8b 45 08             	mov    0x8(%ebp),%eax
    18ca:	83 c4 10             	add    $0x10,%esp
    18cd:	39 d8                	cmp    %ebx,%eax
    18cf:	75 12                	jne    18e3 <parsecmd+0x50>
  nulterminate(cmd);
    18d1:	83 ec 0c             	sub    $0xc,%esp
    18d4:	56                   	push   %esi
    18d5:	e8 22 ff ff ff       	call   17fc <nulterminate>
}
    18da:	89 f0                	mov    %esi,%eax
    18dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    18df:	5b                   	pop    %ebx
    18e0:	5e                   	pop    %esi
    18e1:	5d                   	pop    %ebp
    18e2:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
    18e3:	83 ec 04             	sub    $0x4,%esp
    18e6:	50                   	push   %eax
    18e7:	68 76 20 00 00       	push   $0x2076
    18ec:	6a 02                	push   $0x2
    18ee:	e8 d9 03 00 00       	call   1ccc <printf>
    panic("syntax");
    18f3:	c7 04 24 3a 20 00 00 	movl   $0x203a,(%esp)
    18fa:	e8 46 f7 ff ff       	call   1045 <panic>

000018ff <main>:
{
    18ff:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1903:	83 e4 f0             	and    $0xfffffff0,%esp
    1906:	ff 71 fc             	pushl  -0x4(%ecx)
    1909:	55                   	push   %ebp
    190a:	89 e5                	mov    %esp,%ebp
    190c:	51                   	push   %ecx
    190d:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
    1910:	83 ec 08             	sub    $0x8,%esp
    1913:	6a 02                	push   $0x2
    1915:	68 85 20 00 00       	push   $0x2085
    191a:	e8 b3 02 00 00       	call   1bd2 <open>
    191f:	83 c4 10             	add    $0x10,%esp
    1922:	85 c0                	test   %eax,%eax
    1924:	78 21                	js     1947 <main+0x48>
    if(fd >= 3){
    1926:	83 f8 02             	cmp    $0x2,%eax
    1929:	7e e5                	jle    1910 <main+0x11>
      close(fd);
    192b:	83 ec 0c             	sub    $0xc,%esp
    192e:	50                   	push   %eax
    192f:	e8 86 02 00 00       	call   1bba <close>
      break;
    1934:	83 c4 10             	add    $0x10,%esp
    1937:	eb 0e                	jmp    1947 <main+0x48>
    if(fork1() == 0)
    1939:	e8 21 f7 ff ff       	call   105f <fork1>
    193e:	85 c0                	test   %eax,%eax
    1940:	74 76                	je     19b8 <main+0xb9>
    wait();
    1942:	e8 53 02 00 00       	call   1b9a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
    1947:	83 ec 08             	sub    $0x8,%esp
    194a:	6a 64                	push   $0x64
    194c:	68 40 26 00 00       	push   $0x2640
    1951:	e8 aa f6 ff ff       	call   1000 <getcmd>
    1956:	83 c4 10             	add    $0x10,%esp
    1959:	85 c0                	test   %eax,%eax
    195b:	78 70                	js     19cd <main+0xce>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    195d:	80 3d 40 26 00 00 63 	cmpb   $0x63,0x2640
    1964:	75 d3                	jne    1939 <main+0x3a>
    1966:	80 3d 41 26 00 00 64 	cmpb   $0x64,0x2641
    196d:	75 ca                	jne    1939 <main+0x3a>
    196f:	80 3d 42 26 00 00 20 	cmpb   $0x20,0x2642
    1976:	75 c1                	jne    1939 <main+0x3a>
      buf[strlen(buf)-1] = 0;  // chop \n
    1978:	83 ec 0c             	sub    $0xc,%esp
    197b:	68 40 26 00 00       	push   $0x2640
    1980:	e8 9c 00 00 00       	call   1a21 <strlen>
    1985:	c6 80 3f 26 00 00 00 	movb   $0x0,0x263f(%eax)
      if(chdir(buf+3) < 0)
    198c:	c7 04 24 43 26 00 00 	movl   $0x2643,(%esp)
    1993:	e8 6a 02 00 00       	call   1c02 <chdir>
    1998:	83 c4 10             	add    $0x10,%esp
    199b:	85 c0                	test   %eax,%eax
    199d:	79 a8                	jns    1947 <main+0x48>
        printf(2, "cannot cd %s\n", buf+3);
    199f:	83 ec 04             	sub    $0x4,%esp
    19a2:	68 43 26 00 00       	push   $0x2643
    19a7:	68 8d 20 00 00       	push   $0x208d
    19ac:	6a 02                	push   $0x2
    19ae:	e8 19 03 00 00       	call   1ccc <printf>
    19b3:	83 c4 10             	add    $0x10,%esp
    19b6:	eb 8f                	jmp    1947 <main+0x48>
      runcmd(parsecmd(buf));
    19b8:	83 ec 0c             	sub    $0xc,%esp
    19bb:	68 40 26 00 00       	push   $0x2640
    19c0:	e8 ce fe ff ff       	call   1893 <parsecmd>
    19c5:	89 04 24             	mov    %eax,(%esp)
    19c8:	e8 b1 f6 ff ff       	call   107e <runcmd>
  exit();
    19cd:	e8 c0 01 00 00       	call   1b92 <exit>

000019d2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    19d2:	55                   	push   %ebp
    19d3:	89 e5                	mov    %esp,%ebp
    19d5:	53                   	push   %ebx
    19d6:	8b 45 08             	mov    0x8(%ebp),%eax
    19d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    19dc:	89 c2                	mov    %eax,%edx
    19de:	83 c1 01             	add    $0x1,%ecx
    19e1:	83 c2 01             	add    $0x1,%edx
    19e4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    19e8:	88 5a ff             	mov    %bl,-0x1(%edx)
    19eb:	84 db                	test   %bl,%bl
    19ed:	75 ef                	jne    19de <strcpy+0xc>
    ;
  return os;
}
    19ef:	5b                   	pop    %ebx
    19f0:	5d                   	pop    %ebp
    19f1:	c3                   	ret    

000019f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    19f2:	55                   	push   %ebp
    19f3:	89 e5                	mov    %esp,%ebp
    19f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    19fb:	0f b6 01             	movzbl (%ecx),%eax
    19fe:	84 c0                	test   %al,%al
    1a00:	74 15                	je     1a17 <strcmp+0x25>
    1a02:	3a 02                	cmp    (%edx),%al
    1a04:	75 11                	jne    1a17 <strcmp+0x25>
    p++, q++;
    1a06:	83 c1 01             	add    $0x1,%ecx
    1a09:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1a0c:	0f b6 01             	movzbl (%ecx),%eax
    1a0f:	84 c0                	test   %al,%al
    1a11:	74 04                	je     1a17 <strcmp+0x25>
    1a13:	3a 02                	cmp    (%edx),%al
    1a15:	74 ef                	je     1a06 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    1a17:	0f b6 c0             	movzbl %al,%eax
    1a1a:	0f b6 12             	movzbl (%edx),%edx
    1a1d:	29 d0                	sub    %edx,%eax
}
    1a1f:	5d                   	pop    %ebp
    1a20:	c3                   	ret    

00001a21 <strlen>:

uint
strlen(const char *s)
{
    1a21:	55                   	push   %ebp
    1a22:	89 e5                	mov    %esp,%ebp
    1a24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1a27:	80 39 00             	cmpb   $0x0,(%ecx)
    1a2a:	74 12                	je     1a3e <strlen+0x1d>
    1a2c:	ba 00 00 00 00       	mov    $0x0,%edx
    1a31:	83 c2 01             	add    $0x1,%edx
    1a34:	89 d0                	mov    %edx,%eax
    1a36:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1a3a:	75 f5                	jne    1a31 <strlen+0x10>
    ;
  return n;
}
    1a3c:	5d                   	pop    %ebp
    1a3d:	c3                   	ret    
  for(n = 0; s[n]; n++)
    1a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1a43:	eb f7                	jmp    1a3c <strlen+0x1b>

00001a45 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1a45:	55                   	push   %ebp
    1a46:	89 e5                	mov    %esp,%ebp
    1a48:	57                   	push   %edi
    1a49:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1a4c:	89 d7                	mov    %edx,%edi
    1a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1a51:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a54:	fc                   	cld    
    1a55:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1a57:	89 d0                	mov    %edx,%eax
    1a59:	5f                   	pop    %edi
    1a5a:	5d                   	pop    %ebp
    1a5b:	c3                   	ret    

00001a5c <strchr>:

char*
strchr(const char *s, char c)
{
    1a5c:	55                   	push   %ebp
    1a5d:	89 e5                	mov    %esp,%ebp
    1a5f:	53                   	push   %ebx
    1a60:	8b 45 08             	mov    0x8(%ebp),%eax
    1a63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    1a66:	0f b6 10             	movzbl (%eax),%edx
    1a69:	84 d2                	test   %dl,%dl
    1a6b:	74 1e                	je     1a8b <strchr+0x2f>
    1a6d:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    1a6f:	38 d3                	cmp    %dl,%bl
    1a71:	74 15                	je     1a88 <strchr+0x2c>
  for(; *s; s++)
    1a73:	83 c0 01             	add    $0x1,%eax
    1a76:	0f b6 10             	movzbl (%eax),%edx
    1a79:	84 d2                	test   %dl,%dl
    1a7b:	74 06                	je     1a83 <strchr+0x27>
    if(*s == c)
    1a7d:	38 ca                	cmp    %cl,%dl
    1a7f:	75 f2                	jne    1a73 <strchr+0x17>
    1a81:	eb 05                	jmp    1a88 <strchr+0x2c>
      return (char*)s;
  return 0;
    1a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1a88:	5b                   	pop    %ebx
    1a89:	5d                   	pop    %ebp
    1a8a:	c3                   	ret    
  return 0;
    1a8b:	b8 00 00 00 00       	mov    $0x0,%eax
    1a90:	eb f6                	jmp    1a88 <strchr+0x2c>

00001a92 <gets>:

char*
gets(char *buf, int max)
{
    1a92:	55                   	push   %ebp
    1a93:	89 e5                	mov    %esp,%ebp
    1a95:	57                   	push   %edi
    1a96:	56                   	push   %esi
    1a97:	53                   	push   %ebx
    1a98:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1a9b:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1aa0:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    1aa3:	8d 5e 01             	lea    0x1(%esi),%ebx
    1aa6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1aa9:	7d 2b                	jge    1ad6 <gets+0x44>
    cc = read(0, &c, 1);
    1aab:	83 ec 04             	sub    $0x4,%esp
    1aae:	6a 01                	push   $0x1
    1ab0:	57                   	push   %edi
    1ab1:	6a 00                	push   $0x0
    1ab3:	e8 f2 00 00 00       	call   1baa <read>
    if(cc < 1)
    1ab8:	83 c4 10             	add    $0x10,%esp
    1abb:	85 c0                	test   %eax,%eax
    1abd:	7e 17                	jle    1ad6 <gets+0x44>
      break;
    buf[i++] = c;
    1abf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1ac3:	8b 55 08             	mov    0x8(%ebp),%edx
    1ac6:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
    1aca:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
    1acc:	3c 0a                	cmp    $0xa,%al
    1ace:	74 04                	je     1ad4 <gets+0x42>
    1ad0:	3c 0d                	cmp    $0xd,%al
    1ad2:	75 cf                	jne    1aa3 <gets+0x11>
  for(i=0; i+1 < max; ){
    1ad4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1ad6:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad9:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1add:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ae0:	5b                   	pop    %ebx
    1ae1:	5e                   	pop    %esi
    1ae2:	5f                   	pop    %edi
    1ae3:	5d                   	pop    %ebp
    1ae4:	c3                   	ret    

00001ae5 <stat>:

int
stat(const char *n, struct stat *st)
{
    1ae5:	55                   	push   %ebp
    1ae6:	89 e5                	mov    %esp,%ebp
    1ae8:	56                   	push   %esi
    1ae9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1aea:	83 ec 08             	sub    $0x8,%esp
    1aed:	6a 00                	push   $0x0
    1aef:	ff 75 08             	pushl  0x8(%ebp)
    1af2:	e8 db 00 00 00       	call   1bd2 <open>
  if(fd < 0)
    1af7:	83 c4 10             	add    $0x10,%esp
    1afa:	85 c0                	test   %eax,%eax
    1afc:	78 24                	js     1b22 <stat+0x3d>
    1afe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1b00:	83 ec 08             	sub    $0x8,%esp
    1b03:	ff 75 0c             	pushl  0xc(%ebp)
    1b06:	50                   	push   %eax
    1b07:	e8 de 00 00 00       	call   1bea <fstat>
    1b0c:	89 c6                	mov    %eax,%esi
  close(fd);
    1b0e:	89 1c 24             	mov    %ebx,(%esp)
    1b11:	e8 a4 00 00 00       	call   1bba <close>
  return r;
    1b16:	83 c4 10             	add    $0x10,%esp
}
    1b19:	89 f0                	mov    %esi,%eax
    1b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1b1e:	5b                   	pop    %ebx
    1b1f:	5e                   	pop    %esi
    1b20:	5d                   	pop    %ebp
    1b21:	c3                   	ret    
    return -1;
    1b22:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1b27:	eb f0                	jmp    1b19 <stat+0x34>

00001b29 <atoi>:

int
atoi(const char *s)
{
    1b29:	55                   	push   %ebp
    1b2a:	89 e5                	mov    %esp,%ebp
    1b2c:	53                   	push   %ebx
    1b2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1b30:	0f b6 11             	movzbl (%ecx),%edx
    1b33:	8d 42 d0             	lea    -0x30(%edx),%eax
    1b36:	3c 09                	cmp    $0x9,%al
    1b38:	77 20                	ja     1b5a <atoi+0x31>
  n = 0;
    1b3a:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    1b3f:	83 c1 01             	add    $0x1,%ecx
    1b42:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1b45:	0f be d2             	movsbl %dl,%edx
    1b48:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1b4c:	0f b6 11             	movzbl (%ecx),%edx
    1b4f:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1b52:	80 fb 09             	cmp    $0x9,%bl
    1b55:	76 e8                	jbe    1b3f <atoi+0x16>
  return n;
}
    1b57:	5b                   	pop    %ebx
    1b58:	5d                   	pop    %ebp
    1b59:	c3                   	ret    
  n = 0;
    1b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
    1b5f:	eb f6                	jmp    1b57 <atoi+0x2e>

00001b61 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1b61:	55                   	push   %ebp
    1b62:	89 e5                	mov    %esp,%ebp
    1b64:	56                   	push   %esi
    1b65:	53                   	push   %ebx
    1b66:	8b 45 08             	mov    0x8(%ebp),%eax
    1b69:	8b 75 0c             	mov    0xc(%ebp),%esi
    1b6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1b6f:	85 db                	test   %ebx,%ebx
    1b71:	7e 13                	jle    1b86 <memmove+0x25>
    1b73:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    1b78:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1b7c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    1b7f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1b82:	39 d3                	cmp    %edx,%ebx
    1b84:	75 f2                	jne    1b78 <memmove+0x17>
  return vdst;
}
    1b86:	5b                   	pop    %ebx
    1b87:	5e                   	pop    %esi
    1b88:	5d                   	pop    %ebp
    1b89:	c3                   	ret    

00001b8a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1b8a:	b8 01 00 00 00       	mov    $0x1,%eax
    1b8f:	cd 40                	int    $0x40
    1b91:	c3                   	ret    

00001b92 <exit>:
SYSCALL(exit)
    1b92:	b8 02 00 00 00       	mov    $0x2,%eax
    1b97:	cd 40                	int    $0x40
    1b99:	c3                   	ret    

00001b9a <wait>:
SYSCALL(wait)
    1b9a:	b8 03 00 00 00       	mov    $0x3,%eax
    1b9f:	cd 40                	int    $0x40
    1ba1:	c3                   	ret    

00001ba2 <pipe>:
SYSCALL(pipe)
    1ba2:	b8 04 00 00 00       	mov    $0x4,%eax
    1ba7:	cd 40                	int    $0x40
    1ba9:	c3                   	ret    

00001baa <read>:
SYSCALL(read)
    1baa:	b8 05 00 00 00       	mov    $0x5,%eax
    1baf:	cd 40                	int    $0x40
    1bb1:	c3                   	ret    

00001bb2 <write>:
SYSCALL(write)
    1bb2:	b8 10 00 00 00       	mov    $0x10,%eax
    1bb7:	cd 40                	int    $0x40
    1bb9:	c3                   	ret    

00001bba <close>:
SYSCALL(close)
    1bba:	b8 15 00 00 00       	mov    $0x15,%eax
    1bbf:	cd 40                	int    $0x40
    1bc1:	c3                   	ret    

00001bc2 <kill>:
SYSCALL(kill)
    1bc2:	b8 06 00 00 00       	mov    $0x6,%eax
    1bc7:	cd 40                	int    $0x40
    1bc9:	c3                   	ret    

00001bca <exec>:
SYSCALL(exec)
    1bca:	b8 07 00 00 00       	mov    $0x7,%eax
    1bcf:	cd 40                	int    $0x40
    1bd1:	c3                   	ret    

00001bd2 <open>:
SYSCALL(open)
    1bd2:	b8 0f 00 00 00       	mov    $0xf,%eax
    1bd7:	cd 40                	int    $0x40
    1bd9:	c3                   	ret    

00001bda <mknod>:
SYSCALL(mknod)
    1bda:	b8 11 00 00 00       	mov    $0x11,%eax
    1bdf:	cd 40                	int    $0x40
    1be1:	c3                   	ret    

00001be2 <unlink>:
SYSCALL(unlink)
    1be2:	b8 12 00 00 00       	mov    $0x12,%eax
    1be7:	cd 40                	int    $0x40
    1be9:	c3                   	ret    

00001bea <fstat>:
SYSCALL(fstat)
    1bea:	b8 08 00 00 00       	mov    $0x8,%eax
    1bef:	cd 40                	int    $0x40
    1bf1:	c3                   	ret    

00001bf2 <link>:
SYSCALL(link)
    1bf2:	b8 13 00 00 00       	mov    $0x13,%eax
    1bf7:	cd 40                	int    $0x40
    1bf9:	c3                   	ret    

00001bfa <mkdir>:
SYSCALL(mkdir)
    1bfa:	b8 14 00 00 00       	mov    $0x14,%eax
    1bff:	cd 40                	int    $0x40
    1c01:	c3                   	ret    

00001c02 <chdir>:
SYSCALL(chdir)
    1c02:	b8 09 00 00 00       	mov    $0x9,%eax
    1c07:	cd 40                	int    $0x40
    1c09:	c3                   	ret    

00001c0a <dup>:
SYSCALL(dup)
    1c0a:	b8 0a 00 00 00       	mov    $0xa,%eax
    1c0f:	cd 40                	int    $0x40
    1c11:	c3                   	ret    

00001c12 <getpid>:
SYSCALL(getpid)
    1c12:	b8 0b 00 00 00       	mov    $0xb,%eax
    1c17:	cd 40                	int    $0x40
    1c19:	c3                   	ret    

00001c1a <sbrk>:
SYSCALL(sbrk)
    1c1a:	b8 0c 00 00 00       	mov    $0xc,%eax
    1c1f:	cd 40                	int    $0x40
    1c21:	c3                   	ret    

00001c22 <sleep>:
SYSCALL(sleep)
    1c22:	b8 0d 00 00 00       	mov    $0xd,%eax
    1c27:	cd 40                	int    $0x40
    1c29:	c3                   	ret    

00001c2a <uptime>:
SYSCALL(uptime)
    1c2a:	b8 0e 00 00 00       	mov    $0xe,%eax
    1c2f:	cd 40                	int    $0x40
    1c31:	c3                   	ret    

00001c32 <shmem_access>:
SYSCALL(shmem_access)
    1c32:	b8 16 00 00 00       	mov    $0x16,%eax
    1c37:	cd 40                	int    $0x40
    1c39:	c3                   	ret    

00001c3a <shmem_count>:
    1c3a:	b8 17 00 00 00       	mov    $0x17,%eax
    1c3f:	cd 40                	int    $0x40
    1c41:	c3                   	ret    

00001c42 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1c42:	55                   	push   %ebp
    1c43:	89 e5                	mov    %esp,%ebp
    1c45:	57                   	push   %edi
    1c46:	56                   	push   %esi
    1c47:	53                   	push   %ebx
    1c48:	83 ec 3c             	sub    $0x3c,%esp
    1c4b:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1c4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1c51:	74 14                	je     1c67 <printint+0x25>
    1c53:	85 d2                	test   %edx,%edx
    1c55:	79 10                	jns    1c67 <printint+0x25>
    neg = 1;
    x = -xx;
    1c57:	f7 da                	neg    %edx
    neg = 1;
    1c59:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1c60:	bf 00 00 00 00       	mov    $0x0,%edi
    1c65:	eb 0b                	jmp    1c72 <printint+0x30>
  neg = 0;
    1c67:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1c6e:	eb f0                	jmp    1c60 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
    1c70:	89 df                	mov    %ebx,%edi
    1c72:	8d 5f 01             	lea    0x1(%edi),%ebx
    1c75:	89 d0                	mov    %edx,%eax
    1c77:	ba 00 00 00 00       	mov    $0x0,%edx
    1c7c:	f7 f1                	div    %ecx
    1c7e:	0f b6 92 d4 20 00 00 	movzbl 0x20d4(%edx),%edx
    1c85:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    1c89:	89 c2                	mov    %eax,%edx
    1c8b:	85 c0                	test   %eax,%eax
    1c8d:	75 e1                	jne    1c70 <printint+0x2e>
  if(neg)
    1c8f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
    1c93:	74 08                	je     1c9d <printint+0x5b>
    buf[i++] = '-';
    1c95:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1c9a:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    1c9d:	83 eb 01             	sub    $0x1,%ebx
    1ca0:	78 22                	js     1cc4 <printint+0x82>
  write(fd, &c, 1);
    1ca2:	8d 7d d7             	lea    -0x29(%ebp),%edi
    1ca5:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
    1caa:	88 45 d7             	mov    %al,-0x29(%ebp)
    1cad:	83 ec 04             	sub    $0x4,%esp
    1cb0:	6a 01                	push   $0x1
    1cb2:	57                   	push   %edi
    1cb3:	56                   	push   %esi
    1cb4:	e8 f9 fe ff ff       	call   1bb2 <write>
  while(--i >= 0)
    1cb9:	83 eb 01             	sub    $0x1,%ebx
    1cbc:	83 c4 10             	add    $0x10,%esp
    1cbf:	83 fb ff             	cmp    $0xffffffff,%ebx
    1cc2:	75 e1                	jne    1ca5 <printint+0x63>
    putc(fd, buf[i]);
}
    1cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1cc7:	5b                   	pop    %ebx
    1cc8:	5e                   	pop    %esi
    1cc9:	5f                   	pop    %edi
    1cca:	5d                   	pop    %ebp
    1ccb:	c3                   	ret    

00001ccc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1ccc:	55                   	push   %ebp
    1ccd:	89 e5                	mov    %esp,%ebp
    1ccf:	57                   	push   %edi
    1cd0:	56                   	push   %esi
    1cd1:	53                   	push   %ebx
    1cd2:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1cd5:	8b 75 0c             	mov    0xc(%ebp),%esi
    1cd8:	0f b6 1e             	movzbl (%esi),%ebx
    1cdb:	84 db                	test   %bl,%bl
    1cdd:	0f 84 b1 01 00 00    	je     1e94 <printf+0x1c8>
    1ce3:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
    1ce6:	8d 45 10             	lea    0x10(%ebp),%eax
    1ce9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
    1cec:	bf 00 00 00 00       	mov    $0x0,%edi
    1cf1:	eb 2d                	jmp    1d20 <printf+0x54>
    1cf3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
    1cf6:	83 ec 04             	sub    $0x4,%esp
    1cf9:	6a 01                	push   $0x1
    1cfb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1cfe:	50                   	push   %eax
    1cff:	ff 75 08             	pushl  0x8(%ebp)
    1d02:	e8 ab fe ff ff       	call   1bb2 <write>
    1d07:	83 c4 10             	add    $0x10,%esp
    1d0a:	eb 05                	jmp    1d11 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1d0c:	83 ff 25             	cmp    $0x25,%edi
    1d0f:	74 22                	je     1d33 <printf+0x67>
    1d11:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    1d14:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1d18:	84 db                	test   %bl,%bl
    1d1a:	0f 84 74 01 00 00    	je     1e94 <printf+0x1c8>
    c = fmt[i] & 0xff;
    1d20:	0f be d3             	movsbl %bl,%edx
    1d23:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1d26:	85 ff                	test   %edi,%edi
    1d28:	75 e2                	jne    1d0c <printf+0x40>
      if(c == '%'){
    1d2a:	83 f8 25             	cmp    $0x25,%eax
    1d2d:	75 c4                	jne    1cf3 <printf+0x27>
        state = '%';
    1d2f:	89 c7                	mov    %eax,%edi
    1d31:	eb de                	jmp    1d11 <printf+0x45>
      if(c == 'd'){
    1d33:	83 f8 64             	cmp    $0x64,%eax
    1d36:	74 59                	je     1d91 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1d38:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    1d3e:	83 fa 70             	cmp    $0x70,%edx
    1d41:	74 7a                	je     1dbd <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1d43:	83 f8 73             	cmp    $0x73,%eax
    1d46:	0f 84 9d 00 00 00    	je     1de9 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1d4c:	83 f8 63             	cmp    $0x63,%eax
    1d4f:	0f 84 f2 00 00 00    	je     1e47 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1d55:	83 f8 25             	cmp    $0x25,%eax
    1d58:	0f 84 15 01 00 00    	je     1e73 <printf+0x1a7>
    1d5e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
    1d62:	83 ec 04             	sub    $0x4,%esp
    1d65:	6a 01                	push   $0x1
    1d67:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1d6a:	50                   	push   %eax
    1d6b:	ff 75 08             	pushl  0x8(%ebp)
    1d6e:	e8 3f fe ff ff       	call   1bb2 <write>
    1d73:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    1d76:	83 c4 0c             	add    $0xc,%esp
    1d79:	6a 01                	push   $0x1
    1d7b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1d7e:	50                   	push   %eax
    1d7f:	ff 75 08             	pushl  0x8(%ebp)
    1d82:	e8 2b fe ff ff       	call   1bb2 <write>
    1d87:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1d8a:	bf 00 00 00 00       	mov    $0x0,%edi
    1d8f:	eb 80                	jmp    1d11 <printf+0x45>
        printint(fd, *ap, 10, 1);
    1d91:	83 ec 0c             	sub    $0xc,%esp
    1d94:	6a 01                	push   $0x1
    1d96:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1d9b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1d9e:	8b 17                	mov    (%edi),%edx
    1da0:	8b 45 08             	mov    0x8(%ebp),%eax
    1da3:	e8 9a fe ff ff       	call   1c42 <printint>
        ap++;
    1da8:	89 f8                	mov    %edi,%eax
    1daa:	83 c0 04             	add    $0x4,%eax
    1dad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1db0:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1db3:	bf 00 00 00 00       	mov    $0x0,%edi
    1db8:	e9 54 ff ff ff       	jmp    1d11 <printf+0x45>
        printint(fd, *ap, 16, 0);
    1dbd:	83 ec 0c             	sub    $0xc,%esp
    1dc0:	6a 00                	push   $0x0
    1dc2:	b9 10 00 00 00       	mov    $0x10,%ecx
    1dc7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1dca:	8b 17                	mov    (%edi),%edx
    1dcc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcf:	e8 6e fe ff ff       	call   1c42 <printint>
        ap++;
    1dd4:	89 f8                	mov    %edi,%eax
    1dd6:	83 c0 04             	add    $0x4,%eax
    1dd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1ddc:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1ddf:	bf 00 00 00 00       	mov    $0x0,%edi
    1de4:	e9 28 ff ff ff       	jmp    1d11 <printf+0x45>
        s = (char*)*ap;
    1de9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    1dec:	8b 01                	mov    (%ecx),%eax
        ap++;
    1dee:	83 c1 04             	add    $0x4,%ecx
    1df1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
    1df4:	85 c0                	test   %eax,%eax
    1df6:	74 13                	je     1e0b <printf+0x13f>
        s = (char*)*ap;
    1df8:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
    1dfa:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
    1dfd:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
    1e02:	84 c0                	test   %al,%al
    1e04:	75 0f                	jne    1e15 <printf+0x149>
    1e06:	e9 06 ff ff ff       	jmp    1d11 <printf+0x45>
          s = "(null)";
    1e0b:	bb cc 20 00 00       	mov    $0x20cc,%ebx
        while(*s != 0){
    1e10:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
    1e15:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1e18:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1e1b:	8b 75 08             	mov    0x8(%ebp),%esi
    1e1e:	88 45 e3             	mov    %al,-0x1d(%ebp)
    1e21:	83 ec 04             	sub    $0x4,%esp
    1e24:	6a 01                	push   $0x1
    1e26:	57                   	push   %edi
    1e27:	56                   	push   %esi
    1e28:	e8 85 fd ff ff       	call   1bb2 <write>
          s++;
    1e2d:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
    1e30:	0f b6 03             	movzbl (%ebx),%eax
    1e33:	83 c4 10             	add    $0x10,%esp
    1e36:	84 c0                	test   %al,%al
    1e38:	75 e4                	jne    1e1e <printf+0x152>
    1e3a:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1e3d:	bf 00 00 00 00       	mov    $0x0,%edi
    1e42:	e9 ca fe ff ff       	jmp    1d11 <printf+0x45>
        putc(fd, *ap);
    1e47:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1e4a:	8b 07                	mov    (%edi),%eax
    1e4c:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1e4f:	83 ec 04             	sub    $0x4,%esp
    1e52:	6a 01                	push   $0x1
    1e54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1e57:	50                   	push   %eax
    1e58:	ff 75 08             	pushl  0x8(%ebp)
    1e5b:	e8 52 fd ff ff       	call   1bb2 <write>
        ap++;
    1e60:	83 c7 04             	add    $0x4,%edi
    1e63:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    1e66:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1e69:	bf 00 00 00 00       	mov    $0x0,%edi
    1e6e:	e9 9e fe ff ff       	jmp    1d11 <printf+0x45>
    1e73:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
    1e76:	83 ec 04             	sub    $0x4,%esp
    1e79:	6a 01                	push   $0x1
    1e7b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1e7e:	50                   	push   %eax
    1e7f:	ff 75 08             	pushl  0x8(%ebp)
    1e82:	e8 2b fd ff ff       	call   1bb2 <write>
    1e87:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1e8a:	bf 00 00 00 00       	mov    $0x0,%edi
    1e8f:	e9 7d fe ff ff       	jmp    1d11 <printf+0x45>
    }
  }
}
    1e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1e97:	5b                   	pop    %ebx
    1e98:	5e                   	pop    %esi
    1e99:	5f                   	pop    %edi
    1e9a:	5d                   	pop    %ebp
    1e9b:	c3                   	ret    

00001e9c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1e9c:	55                   	push   %ebp
    1e9d:	89 e5                	mov    %esp,%ebp
    1e9f:	57                   	push   %edi
    1ea0:	56                   	push   %esi
    1ea1:	53                   	push   %ebx
    1ea2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1ea5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ea8:	a1 a4 26 00 00       	mov    0x26a4,%eax
    1ead:	eb 0c                	jmp    1ebb <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1eaf:	8b 10                	mov    (%eax),%edx
    1eb1:	39 c2                	cmp    %eax,%edx
    1eb3:	77 04                	ja     1eb9 <free+0x1d>
    1eb5:	39 ca                	cmp    %ecx,%edx
    1eb7:	77 10                	ja     1ec9 <free+0x2d>
{
    1eb9:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ebb:	39 c8                	cmp    %ecx,%eax
    1ebd:	73 f0                	jae    1eaf <free+0x13>
    1ebf:	8b 10                	mov    (%eax),%edx
    1ec1:	39 ca                	cmp    %ecx,%edx
    1ec3:	77 04                	ja     1ec9 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1ec5:	39 c2                	cmp    %eax,%edx
    1ec7:	77 f0                	ja     1eb9 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1ec9:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1ecc:	8b 10                	mov    (%eax),%edx
    1ece:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1ed1:	39 fa                	cmp    %edi,%edx
    1ed3:	74 19                	je     1eee <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1ed5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1ed8:	8b 50 04             	mov    0x4(%eax),%edx
    1edb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1ede:	39 f1                	cmp    %esi,%ecx
    1ee0:	74 1b                	je     1efd <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1ee2:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1ee4:	a3 a4 26 00 00       	mov    %eax,0x26a4
}
    1ee9:	5b                   	pop    %ebx
    1eea:	5e                   	pop    %esi
    1eeb:	5f                   	pop    %edi
    1eec:	5d                   	pop    %ebp
    1eed:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    1eee:	03 72 04             	add    0x4(%edx),%esi
    1ef1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1ef4:	8b 10                	mov    (%eax),%edx
    1ef6:	8b 12                	mov    (%edx),%edx
    1ef8:	89 53 f8             	mov    %edx,-0x8(%ebx)
    1efb:	eb db                	jmp    1ed8 <free+0x3c>
    p->s.size += bp->s.size;
    1efd:	03 53 fc             	add    -0x4(%ebx),%edx
    1f00:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1f03:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1f06:	89 10                	mov    %edx,(%eax)
    1f08:	eb da                	jmp    1ee4 <free+0x48>

00001f0a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1f0a:	55                   	push   %ebp
    1f0b:	89 e5                	mov    %esp,%ebp
    1f0d:	57                   	push   %edi
    1f0e:	56                   	push   %esi
    1f0f:	53                   	push   %ebx
    1f10:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1f13:	8b 45 08             	mov    0x8(%ebp),%eax
    1f16:	8d 58 07             	lea    0x7(%eax),%ebx
    1f19:	c1 eb 03             	shr    $0x3,%ebx
    1f1c:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    1f1f:	8b 15 a4 26 00 00    	mov    0x26a4,%edx
    1f25:	85 d2                	test   %edx,%edx
    1f27:	74 20                	je     1f49 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f29:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1f2b:	8b 48 04             	mov    0x4(%eax),%ecx
    1f2e:	39 cb                	cmp    %ecx,%ebx
    1f30:	76 3c                	jbe    1f6e <malloc+0x64>
    1f32:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    1f38:	be 00 10 00 00       	mov    $0x1000,%esi
    1f3d:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
    1f40:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    1f47:	eb 70                	jmp    1fb9 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
    1f49:	c7 05 a4 26 00 00 a8 	movl   $0x26a8,0x26a4
    1f50:	26 00 00 
    1f53:	c7 05 a8 26 00 00 a8 	movl   $0x26a8,0x26a8
    1f5a:	26 00 00 
    base.s.size = 0;
    1f5d:	c7 05 ac 26 00 00 00 	movl   $0x0,0x26ac
    1f64:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1f67:	ba a8 26 00 00       	mov    $0x26a8,%edx
    1f6c:	eb bb                	jmp    1f29 <malloc+0x1f>
      if(p->s.size == nunits)
    1f6e:	39 cb                	cmp    %ecx,%ebx
    1f70:	74 1c                	je     1f8e <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1f72:	29 d9                	sub    %ebx,%ecx
    1f74:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1f77:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1f7a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1f7d:	89 15 a4 26 00 00    	mov    %edx,0x26a4
      return (void*)(p + 1);
    1f83:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1f89:	5b                   	pop    %ebx
    1f8a:	5e                   	pop    %esi
    1f8b:	5f                   	pop    %edi
    1f8c:	5d                   	pop    %ebp
    1f8d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1f8e:	8b 08                	mov    (%eax),%ecx
    1f90:	89 0a                	mov    %ecx,(%edx)
    1f92:	eb e9                	jmp    1f7d <malloc+0x73>
  hp->s.size = nu;
    1f94:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1f97:	83 ec 0c             	sub    $0xc,%esp
    1f9a:	83 c0 08             	add    $0x8,%eax
    1f9d:	50                   	push   %eax
    1f9e:	e8 f9 fe ff ff       	call   1e9c <free>
  return freep;
    1fa3:	8b 15 a4 26 00 00    	mov    0x26a4,%edx
      if((p = morecore(nunits)) == 0)
    1fa9:	83 c4 10             	add    $0x10,%esp
    1fac:	85 d2                	test   %edx,%edx
    1fae:	74 2b                	je     1fdb <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1fb0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1fb2:	8b 48 04             	mov    0x4(%eax),%ecx
    1fb5:	39 d9                	cmp    %ebx,%ecx
    1fb7:	73 b5                	jae    1f6e <malloc+0x64>
    1fb9:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1fbb:	39 05 a4 26 00 00    	cmp    %eax,0x26a4
    1fc1:	75 ed                	jne    1fb0 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1fc3:	83 ec 0c             	sub    $0xc,%esp
    1fc6:	57                   	push   %edi
    1fc7:	e8 4e fc ff ff       	call   1c1a <sbrk>
  if(p == (char*)-1)
    1fcc:	83 c4 10             	add    $0x10,%esp
    1fcf:	83 f8 ff             	cmp    $0xffffffff,%eax
    1fd2:	75 c0                	jne    1f94 <malloc+0x8a>
        return 0;
    1fd4:	b8 00 00 00 00       	mov    $0x0,%eax
    1fd9:	eb ab                	jmp    1f86 <malloc+0x7c>
    1fdb:	b8 00 00 00 00       	mov    $0x0,%eax
    1fe0:	eb a4                	jmp    1f86 <malloc+0x7c>
