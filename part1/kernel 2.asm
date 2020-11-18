
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c8 2a 10 80       	mov    $0x80102ac8,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 80 68 10 80       	push   $0x80106880
80100040:	68 c0 b5 10 80       	push   $0x8010b5c0
80100045:	e8 08 3c 00 00       	call   80103c52 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100051:	fc 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010005b:	fc 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100061:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
    b->next = bcache.head.next;
80100066:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010006b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010006e:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100075:	83 ec 08             	sub    $0x8,%esp
80100078:	68 87 68 10 80       	push   $0x80106887
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 c2 3a 00 00       	call   80103b48 <initsleeplock>
    bcache.head.next->prev = b;
80100086:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010008b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010008e:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100094:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009a:	83 c4 10             	add    $0x10,%esp
8010009d:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a3:	72 c1                	jb     80100066 <binit+0x32>
  }
}
801000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000a8:	c9                   	leave  
801000a9:	c3                   	ret    

801000aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000aa:	55                   	push   %ebp
801000ab:	89 e5                	mov    %esp,%ebp
801000ad:	57                   	push   %edi
801000ae:	56                   	push   %esi
801000af:	53                   	push   %ebx
801000b0:	83 ec 18             	sub    $0x18,%esp
801000b3:	8b 75 08             	mov    0x8(%ebp),%esi
801000b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000b9:	68 c0 b5 10 80       	push   $0x8010b5c0
801000be:	e8 d7 3c 00 00       	call   80103d9a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000c9:	83 c4 10             	add    $0x10,%esp
801000cc:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000d2:	75 26                	jne    801000fa <bread+0x50>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000d4:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
801000da:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000e0:	75 4e                	jne    80100130 <bread+0x86>
  panic("bget: no buffers");
801000e2:	83 ec 0c             	sub    $0xc,%esp
801000e5:	68 8e 68 10 80       	push   $0x8010688e
801000ea:	e8 55 02 00 00       	call   80100344 <panic>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ef:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	74 da                	je     801000d4 <bread+0x2a>
    if(b->dev == dev && b->blockno == blockno){
801000fa:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fd:	75 f0                	jne    801000ef <bread+0x45>
801000ff:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100102:	75 eb                	jne    801000ef <bread+0x45>
      b->refcnt++;
80100104:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100108:	83 ec 0c             	sub    $0xc,%esp
8010010b:	68 c0 b5 10 80       	push   $0x8010b5c0
80100110:	e8 ec 3c 00 00       	call   80103e01 <release>
      acquiresleep(&b->lock);
80100115:	8d 43 0c             	lea    0xc(%ebx),%eax
80100118:	89 04 24             	mov    %eax,(%esp)
8010011b:	e8 5b 3a 00 00       	call   80103b7b <acquiresleep>
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	eb 44                	jmp    80100169 <bread+0xbf>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100125:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100128:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012e:	74 b2                	je     801000e2 <bread+0x38>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100130:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80100134:	75 ef                	jne    80100125 <bread+0x7b>
80100136:	f6 03 04             	testb  $0x4,(%ebx)
80100139:	75 ea                	jne    80100125 <bread+0x7b>
      b->dev = dev;
8010013b:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010013e:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100147:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	68 c0 b5 10 80       	push   $0x8010b5c0
80100156:	e8 a6 3c 00 00       	call   80103e01 <release>
      acquiresleep(&b->lock);
8010015b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015e:	89 04 24             	mov    %eax,(%esp)
80100161:	e8 15 3a 00 00       	call   80103b7b <acquiresleep>
80100166:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100169:	f6 03 02             	testb  $0x2,(%ebx)
8010016c:	74 0a                	je     80100178 <bread+0xce>
    iderw(b);
  }
  return b;
}
8010016e:	89 d8                	mov    %ebx,%eax
80100170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100173:	5b                   	pop    %ebx
80100174:	5e                   	pop    %esi
80100175:	5f                   	pop    %edi
80100176:	5d                   	pop    %ebp
80100177:	c3                   	ret    
    iderw(b);
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	53                   	push   %ebx
8010017c:	e8 4b 1d 00 00       	call   80101ecc <iderw>
80100181:	83 c4 10             	add    $0x10,%esp
  return b;
80100184:	eb e8                	jmp    8010016e <bread+0xc4>

80100186 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100186:	55                   	push   %ebp
80100187:	89 e5                	mov    %esp,%ebp
80100189:	53                   	push   %ebx
8010018a:	83 ec 10             	sub    $0x10,%esp
8010018d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100190:	8d 43 0c             	lea    0xc(%ebx),%eax
80100193:	50                   	push   %eax
80100194:	e8 6f 3a 00 00       	call   80103c08 <holdingsleep>
80100199:	83 c4 10             	add    $0x10,%esp
8010019c:	85 c0                	test   %eax,%eax
8010019e:	74 14                	je     801001b4 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a3:	83 ec 0c             	sub    $0xc,%esp
801001a6:	53                   	push   %ebx
801001a7:	e8 20 1d 00 00       	call   80101ecc <iderw>
}
801001ac:	83 c4 10             	add    $0x10,%esp
801001af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    
    panic("bwrite");
801001b4:	83 ec 0c             	sub    $0xc,%esp
801001b7:	68 9f 68 10 80       	push   $0x8010689f
801001bc:	e8 83 01 00 00       	call   80100344 <panic>

801001c1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c1:	55                   	push   %ebp
801001c2:	89 e5                	mov    %esp,%ebp
801001c4:	56                   	push   %esi
801001c5:	53                   	push   %ebx
801001c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cc:	83 ec 0c             	sub    $0xc,%esp
801001cf:	56                   	push   %esi
801001d0:	e8 33 3a 00 00       	call   80103c08 <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	74 6b                	je     80100247 <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 e8 39 00 00       	call   80103bcd <releasesleep>

  acquire(&bcache.lock);
801001e5:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801001ec:	e8 a9 3b 00 00       	call   80103d9a <acquire>
  b->refcnt--;
801001f1:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f4:	83 e8 01             	sub    $0x1,%eax
801001f7:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001fa:	83 c4 10             	add    $0x10,%esp
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 2f                	jne    80100230 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100201:	8b 43 54             	mov    0x54(%ebx),%eax
80100204:	8b 53 50             	mov    0x50(%ebx),%edx
80100207:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010020a:	8b 43 50             	mov    0x50(%ebx),%eax
8010020d:	8b 53 54             	mov    0x54(%ebx),%edx
80100210:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100213:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100218:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010021b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100222:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100227:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010022a:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100230:	83 ec 0c             	sub    $0xc,%esp
80100233:	68 c0 b5 10 80       	push   $0x8010b5c0
80100238:	e8 c4 3b 00 00       	call   80103e01 <release>
}
8010023d:	83 c4 10             	add    $0x10,%esp
80100240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100243:	5b                   	pop    %ebx
80100244:	5e                   	pop    %esi
80100245:	5d                   	pop    %ebp
80100246:	c3                   	ret    
    panic("brelse");
80100247:	83 ec 0c             	sub    $0xc,%esp
8010024a:	68 a6 68 10 80       	push   $0x801068a6
8010024f:	e8 f0 00 00 00       	call   80100344 <panic>

80100254 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100254:	55                   	push   %ebp
80100255:	89 e5                	mov    %esp,%ebp
80100257:	57                   	push   %edi
80100258:	56                   	push   %esi
80100259:	53                   	push   %ebx
8010025a:	83 ec 28             	sub    $0x28,%esp
8010025d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100260:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100263:	ff 75 08             	pushl  0x8(%ebp)
80100266:	e8 7a 13 00 00       	call   801015e5 <iunlock>
  target = n;
8010026b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  acquire(&cons.lock);
8010026e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100275:	e8 20 3b 00 00       	call   80103d9a <acquire>
  while(n > 0){
8010027a:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
8010027d:	bb 20 ff 10 80       	mov    $0x8010ff20,%ebx
  while(n > 0){
80100282:	85 f6                	test   %esi,%esi
80100284:	7e 68                	jle    801002ee <consoleread+0x9a>
    while(input.r == input.w){
80100286:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010028c:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100292:	75 2e                	jne    801002c2 <consoleread+0x6e>
      if(myproc()->killed){
80100294:	e8 dd 30 00 00       	call   80103376 <myproc>
80100299:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010029d:	75 71                	jne    80100310 <consoleread+0xbc>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
8010029f:	83 ec 08             	sub    $0x8,%esp
801002a2:	68 20 a5 10 80       	push   $0x8010a520
801002a7:	68 a0 ff 10 80       	push   $0x8010ffa0
801002ac:	e8 70 35 00 00       	call   80103821 <sleep>
    while(input.r == input.w){
801002b1:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801002b7:	83 c4 10             	add    $0x10,%esp
801002ba:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801002c0:	74 d2                	je     80100294 <consoleread+0x40>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002c2:	8d 50 01             	lea    0x1(%eax),%edx
801002c5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
801002cb:	89 c2                	mov    %eax,%edx
801002cd:	83 e2 7f             	and    $0x7f,%edx
801002d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801002d4:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002d7:	83 fa 04             	cmp    $0x4,%edx
801002da:	74 5c                	je     80100338 <consoleread+0xe4>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002dc:	83 c7 01             	add    $0x1,%edi
801002df:	88 4f ff             	mov    %cl,-0x1(%edi)
    --n;
801002e2:	83 ee 01             	sub    $0x1,%esi
    if(c == '\n')
801002e5:	83 fa 0a             	cmp    $0xa,%edx
801002e8:	74 04                	je     801002ee <consoleread+0x9a>
  while(n > 0){
801002ea:	85 f6                	test   %esi,%esi
801002ec:	75 98                	jne    80100286 <consoleread+0x32>
      break;
  }
  release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 a5 10 80       	push   $0x8010a520
801002f6:	e8 06 3b 00 00       	call   80103e01 <release>
  ilock(ip);
801002fb:	83 c4 04             	add    $0x4,%esp
801002fe:	ff 75 08             	pushl  0x8(%ebp)
80100301:	e8 1d 12 00 00       	call   80101523 <ilock>

  return target - n;
80100306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100309:	29 f0                	sub    %esi,%eax
8010030b:	83 c4 10             	add    $0x10,%esp
8010030e:	eb 20                	jmp    80100330 <consoleread+0xdc>
        release(&cons.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 20 a5 10 80       	push   $0x8010a520
80100318:	e8 e4 3a 00 00       	call   80103e01 <release>
        ilock(ip);
8010031d:	83 c4 04             	add    $0x4,%esp
80100320:	ff 75 08             	pushl  0x8(%ebp)
80100323:	e8 fb 11 00 00       	call   80101523 <ilock>
        return -1;
80100328:	83 c4 10             	add    $0x10,%esp
8010032b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100333:	5b                   	pop    %ebx
80100334:	5e                   	pop    %esi
80100335:	5f                   	pop    %edi
80100336:	5d                   	pop    %ebp
80100337:	c3                   	ret    
      if(n < target){
80100338:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010033b:	73 b1                	jae    801002ee <consoleread+0x9a>
        input.r--;
8010033d:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100342:	eb aa                	jmp    801002ee <consoleread+0x9a>

80100344 <panic>:
{
80100344:	55                   	push   %ebp
80100345:	89 e5                	mov    %esp,%ebp
80100347:	56                   	push   %esi
80100348:	53                   	push   %ebx
80100349:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034c:	fa                   	cli    
  cons.locking = 0;
8010034d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100354:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100357:	e8 21 21 00 00       	call   8010247d <lapicid>
8010035c:	83 ec 08             	sub    $0x8,%esp
8010035f:	50                   	push   %eax
80100360:	68 ad 68 10 80       	push   $0x801068ad
80100365:	e8 77 02 00 00       	call   801005e1 <cprintf>
  cprintf(s);
8010036a:	83 c4 04             	add    $0x4,%esp
8010036d:	ff 75 08             	pushl  0x8(%ebp)
80100370:	e8 6c 02 00 00       	call   801005e1 <cprintf>
  cprintf("\n");
80100375:	c7 04 24 57 72 10 80 	movl   $0x80107257,(%esp)
8010037c:	e8 60 02 00 00       	call   801005e1 <cprintf>
  getcallerpcs(&s, pcs);
80100381:	83 c4 08             	add    $0x8,%esp
80100384:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100387:	53                   	push   %ebx
80100388:	8d 45 08             	lea    0x8(%ebp),%eax
8010038b:	50                   	push   %eax
8010038c:	e8 dc 38 00 00       	call   80103c6d <getcallerpcs>
80100391:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100394:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 33                	pushl  (%ebx)
8010039c:	68 c1 68 10 80       	push   $0x801068c1
801003a1:	e8 3b 02 00 00       	call   801005e1 <cprintf>
801003a6:	83 c3 04             	add    $0x4,%ebx
  for(i=0; i<10; i++)
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	39 f3                	cmp    %esi,%ebx
801003ae:	75 e7                	jne    80100397 <panic+0x53>
  panicked = 1; // freeze other CPU
801003b0:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003b7:	00 00 00 
801003ba:	eb fe                	jmp    801003ba <panic+0x76>

801003bc <consputc>:
  if(panicked){
801003bc:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801003c3:	74 03                	je     801003c8 <consputc+0xc>
801003c5:	fa                   	cli    
801003c6:	eb fe                	jmp    801003c6 <consputc+0xa>
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	57                   	push   %edi
801003cc:	56                   	push   %esi
801003cd:	53                   	push   %ebx
801003ce:	83 ec 0c             	sub    $0xc,%esp
801003d1:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003d3:	3d 00 01 00 00       	cmp    $0x100,%eax
801003d8:	74 5f                	je     80100439 <consputc+0x7d>
    uartputc(c);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 7d 4e 00 00       	call   80105260 <uartputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e6:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801003eb:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f0:	89 da                	mov    %ebx,%edx
801003f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003f8:	89 ca                	mov    %ecx,%edx
801003fa:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fb:	0f b6 c0             	movzbl %al,%eax
801003fe:	c1 e0 08             	shl    $0x8,%eax
80100401:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0f 00 00 00       	mov    $0xf,%eax
80100408:	89 da                	mov    %ebx,%edx
8010040a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040b:	89 ca                	mov    %ecx,%edx
8010040d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040e:	0f b6 d8             	movzbl %al,%ebx
80100411:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100413:	83 fe 0a             	cmp    $0xa,%esi
80100416:	74 48                	je     80100460 <consputc+0xa4>
  else if(c == BACKSPACE){
80100418:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041e:	0f 84 93 00 00 00    	je     801004b7 <consputc+0xfb>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100424:	89 f0                	mov    %esi,%eax
80100426:	0f b6 c0             	movzbl %al,%eax
80100429:	80 cc 07             	or     $0x7,%ah
8010042c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100433:	80 
80100434:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100437:	eb 35                	jmp    8010046e <consputc+0xb2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100439:	83 ec 0c             	sub    $0xc,%esp
8010043c:	6a 08                	push   $0x8
8010043e:	e8 1d 4e 00 00       	call   80105260 <uartputc>
80100443:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010044a:	e8 11 4e 00 00       	call   80105260 <uartputc>
8010044f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100456:	e8 05 4e 00 00       	call   80105260 <uartputc>
8010045b:	83 c4 10             	add    $0x10,%esp
8010045e:	eb 86                	jmp    801003e6 <consputc+0x2a>
    pos += 80 - pos%80;
80100460:	b9 50 00 00 00       	mov    $0x50,%ecx
80100465:	89 d8                	mov    %ebx,%eax
80100467:	99                   	cltd   
80100468:	f7 f9                	idiv   %ecx
8010046a:	29 d1                	sub    %edx,%ecx
8010046c:	01 cb                	add    %ecx,%ebx
  if(pos < 0 || pos > 25*80)
8010046e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100474:	77 4a                	ja     801004c0 <consputc+0x104>
  if((pos/80) >= 24){  // Scroll up.
80100476:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010047c:	7f 4f                	jg     801004cd <consputc+0x111>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100483:	b8 0e 00 00 00       	mov    $0xe,%eax
80100488:	89 f2                	mov    %esi,%edx
8010048a:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010048b:	89 d8                	mov    %ebx,%eax
8010048d:	c1 f8 08             	sar    $0x8,%eax
80100490:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100495:	89 ca                	mov    %ecx,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049d:	89 f2                	mov    %esi,%edx
8010049f:	ee                   	out    %al,(%dx)
801004a0:	89 d8                	mov    %ebx,%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a5:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
801004ac:	80 20 07 
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
    if(pos > 0) --pos;
801004b7:	85 db                	test   %ebx,%ebx
801004b9:	7e b3                	jle    8010046e <consputc+0xb2>
801004bb:	83 eb 01             	sub    $0x1,%ebx
801004be:	eb ae                	jmp    8010046e <consputc+0xb2>
    panic("pos under/overflow");
801004c0:	83 ec 0c             	sub    $0xc,%esp
801004c3:	68 c5 68 10 80       	push   $0x801068c5
801004c8:	e8 77 fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004cd:	83 ec 04             	sub    $0x4,%esp
801004d0:	68 60 0e 00 00       	push   $0xe60
801004d5:	68 a0 80 0b 80       	push   $0x800b80a0
801004da:	68 00 80 0b 80       	push   $0x800b8000
801004df:	e8 f9 39 00 00       	call   80103edd <memmove>
    pos -= 80;
801004e4:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004e7:	83 c4 0c             	add    $0xc,%esp
801004ea:	b8 80 07 00 00       	mov    $0x780,%eax
801004ef:	29 d8                	sub    %ebx,%eax
801004f1:	01 c0                	add    %eax,%eax
801004f3:	50                   	push   %eax
801004f4:	6a 00                	push   $0x0
801004f6:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
801004f9:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
801004fe:	50                   	push   %eax
801004ff:	e8 44 39 00 00       	call   80103e48 <memset>
80100504:	83 c4 10             	add    $0x10,%esp
80100507:	e9 72 ff ff ff       	jmp    8010047e <consputc+0xc2>

8010050c <printint>:
{
8010050c:	55                   	push   %ebp
8010050d:	89 e5                	mov    %esp,%ebp
8010050f:	57                   	push   %edi
80100510:	56                   	push   %esi
80100511:	53                   	push   %ebx
80100512:	83 ec 1c             	sub    $0x1c,%esp
80100515:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
80100517:	85 c9                	test   %ecx,%ecx
80100519:	74 04                	je     8010051f <printint+0x13>
8010051b:	85 c0                	test   %eax,%eax
8010051d:	78 0e                	js     8010052d <printint+0x21>
    x = xx;
8010051f:	89 c2                	mov    %eax,%edx
80100521:	bf 00 00 00 00       	mov    $0x0,%edi
  i = 0;
80100526:	b9 00 00 00 00       	mov    $0x0,%ecx
8010052b:	eb 0d                	jmp    8010053a <printint+0x2e>
    x = -xx;
8010052d:	f7 d8                	neg    %eax
8010052f:	89 c2                	mov    %eax,%edx
  if(sign && (sign = xx < 0))
80100531:	bf 01 00 00 00       	mov    $0x1,%edi
    x = -xx;
80100536:	eb ee                	jmp    80100526 <printint+0x1a>
    buf[i++] = digits[x % base];
80100538:	89 d9                	mov    %ebx,%ecx
8010053a:	8d 59 01             	lea    0x1(%ecx),%ebx
8010053d:	89 d0                	mov    %edx,%eax
8010053f:	ba 00 00 00 00       	mov    $0x0,%edx
80100544:	f7 f6                	div    %esi
80100546:	0f b6 92 f0 68 10 80 	movzbl -0x7fef9710(%edx),%edx
8010054d:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100551:	89 c2                	mov    %eax,%edx
80100553:	85 c0                	test   %eax,%eax
80100555:	75 e1                	jne    80100538 <printint+0x2c>
  if(sign)
80100557:	85 ff                	test   %edi,%edi
80100559:	74 08                	je     80100563 <printint+0x57>
    buf[i++] = '-';
8010055b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100560:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	78 12                	js     8010057a <printint+0x6e>
    consputc(buf[i]);
80100568:	0f be 44 2b d8       	movsbl -0x28(%ebx,%ebp,1),%eax
8010056d:	e8 4a fe ff ff       	call   801003bc <consputc>
  while(--i >= 0)
80100572:	83 eb 01             	sub    $0x1,%ebx
80100575:	83 fb ff             	cmp    $0xffffffff,%ebx
80100578:	75 ee                	jne    80100568 <printint+0x5c>
}
8010057a:	83 c4 1c             	add    $0x1c,%esp
8010057d:	5b                   	pop    %ebx
8010057e:	5e                   	pop    %esi
8010057f:	5f                   	pop    %edi
80100580:	5d                   	pop    %ebp
80100581:	c3                   	ret    

80100582 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	57                   	push   %edi
80100586:	56                   	push   %esi
80100587:	53                   	push   %ebx
80100588:	83 ec 18             	sub    $0x18,%esp
8010058b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010058e:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
80100591:	ff 75 08             	pushl  0x8(%ebp)
80100594:	e8 4c 10 00 00       	call   801015e5 <iunlock>
  acquire(&cons.lock);
80100599:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005a0:	e8 f5 37 00 00       	call   80103d9a <acquire>
  for(i = 0; i < n; i++)
801005a5:	83 c4 10             	add    $0x10,%esp
801005a8:	85 ff                	test   %edi,%edi
801005aa:	7e 13                	jle    801005bf <consolewrite+0x3d>
801005ac:	89 f3                	mov    %esi,%ebx
801005ae:	01 fe                	add    %edi,%esi
    consputc(buf[i] & 0xff);
801005b0:	0f b6 03             	movzbl (%ebx),%eax
801005b3:	e8 04 fe ff ff       	call   801003bc <consputc>
801005b8:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < n; i++)
801005bb:	39 f3                	cmp    %esi,%ebx
801005bd:	75 f1                	jne    801005b0 <consolewrite+0x2e>
  release(&cons.lock);
801005bf:	83 ec 0c             	sub    $0xc,%esp
801005c2:	68 20 a5 10 80       	push   $0x8010a520
801005c7:	e8 35 38 00 00       	call   80103e01 <release>
  ilock(ip);
801005cc:	83 c4 04             	add    $0x4,%esp
801005cf:	ff 75 08             	pushl  0x8(%ebp)
801005d2:	e8 4c 0f 00 00       	call   80101523 <ilock>

  return n;
}
801005d7:	89 f8                	mov    %edi,%eax
801005d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005dc:	5b                   	pop    %ebx
801005dd:	5e                   	pop    %esi
801005de:	5f                   	pop    %edi
801005df:	5d                   	pop    %ebp
801005e0:	c3                   	ret    

801005e1 <cprintf>:
{
801005e1:	55                   	push   %ebp
801005e2:	89 e5                	mov    %esp,%ebp
801005e4:	57                   	push   %edi
801005e5:	56                   	push   %esi
801005e6:	53                   	push   %ebx
801005e7:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005ea:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005f2:	85 c0                	test   %eax,%eax
801005f4:	75 2b                	jne    80100621 <cprintf+0x40>
  if (fmt == 0)
801005f6:	8b 7d 08             	mov    0x8(%ebp),%edi
801005f9:	85 ff                	test   %edi,%edi
801005fb:	74 36                	je     80100633 <cprintf+0x52>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005fd:	0f b6 07             	movzbl (%edi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100600:	8d 4d 0c             	lea    0xc(%ebp),%ecx
80100603:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100606:	bb 00 00 00 00       	mov    $0x0,%ebx
8010060b:	85 c0                	test   %eax,%eax
8010060d:	75 41                	jne    80100650 <cprintf+0x6f>
  if(locking)
8010060f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100613:	0f 85 0d 01 00 00    	jne    80100726 <cprintf+0x145>
}
80100619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010061c:	5b                   	pop    %ebx
8010061d:	5e                   	pop    %esi
8010061e:	5f                   	pop    %edi
8010061f:	5d                   	pop    %ebp
80100620:	c3                   	ret    
    acquire(&cons.lock);
80100621:	83 ec 0c             	sub    $0xc,%esp
80100624:	68 20 a5 10 80       	push   $0x8010a520
80100629:	e8 6c 37 00 00       	call   80103d9a <acquire>
8010062e:	83 c4 10             	add    $0x10,%esp
80100631:	eb c3                	jmp    801005f6 <cprintf+0x15>
    panic("null fmt");
80100633:	83 ec 0c             	sub    $0xc,%esp
80100636:	68 df 68 10 80       	push   $0x801068df
8010063b:	e8 04 fd ff ff       	call   80100344 <panic>
      consputc(c);
80100640:	e8 77 fd ff ff       	call   801003bc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100645:	83 c3 01             	add    $0x1,%ebx
80100648:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010064c:	85 c0                	test   %eax,%eax
8010064e:	74 bf                	je     8010060f <cprintf+0x2e>
    if(c != '%'){
80100650:	83 f8 25             	cmp    $0x25,%eax
80100653:	75 eb                	jne    80100640 <cprintf+0x5f>
    c = fmt[++i] & 0xff;
80100655:	83 c3 01             	add    $0x1,%ebx
80100658:	0f b6 34 1f          	movzbl (%edi,%ebx,1),%esi
    if(c == 0)
8010065c:	85 f6                	test   %esi,%esi
8010065e:	74 af                	je     8010060f <cprintf+0x2e>
    switch(c){
80100660:	83 fe 70             	cmp    $0x70,%esi
80100663:	74 4c                	je     801006b1 <cprintf+0xd0>
80100665:	83 fe 70             	cmp    $0x70,%esi
80100668:	7f 2a                	jg     80100694 <cprintf+0xb3>
8010066a:	83 fe 25             	cmp    $0x25,%esi
8010066d:	0f 84 a4 00 00 00    	je     80100717 <cprintf+0x136>
80100673:	83 fe 64             	cmp    $0x64,%esi
80100676:	75 26                	jne    8010069e <cprintf+0xbd>
      printint(*argp++, 10, 1);
80100678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010067b:	8d 70 04             	lea    0x4(%eax),%esi
8010067e:	b9 01 00 00 00       	mov    $0x1,%ecx
80100683:	ba 0a 00 00 00       	mov    $0xa,%edx
80100688:	8b 00                	mov    (%eax),%eax
8010068a:	e8 7d fe ff ff       	call   8010050c <printint>
8010068f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
80100692:	eb b1                	jmp    80100645 <cprintf+0x64>
    switch(c){
80100694:	83 fe 73             	cmp    $0x73,%esi
80100697:	74 37                	je     801006d0 <cprintf+0xef>
80100699:	83 fe 78             	cmp    $0x78,%esi
8010069c:	74 13                	je     801006b1 <cprintf+0xd0>
      consputc('%');
8010069e:	b8 25 00 00 00       	mov    $0x25,%eax
801006a3:	e8 14 fd ff ff       	call   801003bc <consputc>
      consputc(c);
801006a8:	89 f0                	mov    %esi,%eax
801006aa:	e8 0d fd ff ff       	call   801003bc <consputc>
      break;
801006af:	eb 94                	jmp    80100645 <cprintf+0x64>
      printint(*argp++, 16, 0);
801006b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006b4:	8d 70 04             	lea    0x4(%eax),%esi
801006b7:	b9 00 00 00 00       	mov    $0x0,%ecx
801006bc:	ba 10 00 00 00       	mov    $0x10,%edx
801006c1:	8b 00                	mov    (%eax),%eax
801006c3:	e8 44 fe ff ff       	call   8010050c <printint>
801006c8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006cb:	e9 75 ff ff ff       	jmp    80100645 <cprintf+0x64>
      if((s = (char*)*argp++) == 0)
801006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006d3:	8d 50 04             	lea    0x4(%eax),%edx
801006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801006d9:	8b 00                	mov    (%eax),%eax
801006db:	85 c0                	test   %eax,%eax
801006dd:	74 11                	je     801006f0 <cprintf+0x10f>
801006df:	89 c6                	mov    %eax,%esi
      for(; *s; s++)
801006e1:	0f b6 00             	movzbl (%eax),%eax
      if((s = (char*)*argp++) == 0)
801006e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      for(; *s; s++)
801006e7:	84 c0                	test   %al,%al
801006e9:	75 0f                	jne    801006fa <cprintf+0x119>
801006eb:	e9 55 ff ff ff       	jmp    80100645 <cprintf+0x64>
        s = "(null)";
801006f0:	be d8 68 10 80       	mov    $0x801068d8,%esi
      for(; *s; s++)
801006f5:	b8 28 00 00 00       	mov    $0x28,%eax
        consputc(*s);
801006fa:	0f be c0             	movsbl %al,%eax
801006fd:	e8 ba fc ff ff       	call   801003bc <consputc>
      for(; *s; s++)
80100702:	83 c6 01             	add    $0x1,%esi
80100705:	0f b6 06             	movzbl (%esi),%eax
80100708:	84 c0                	test   %al,%al
8010070a:	75 ee                	jne    801006fa <cprintf+0x119>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	e9 2e ff ff ff       	jmp    80100645 <cprintf+0x64>
      consputc('%');
80100717:	b8 25 00 00 00       	mov    $0x25,%eax
8010071c:	e8 9b fc ff ff       	call   801003bc <consputc>
      break;
80100721:	e9 1f ff ff ff       	jmp    80100645 <cprintf+0x64>
    release(&cons.lock);
80100726:	83 ec 0c             	sub    $0xc,%esp
80100729:	68 20 a5 10 80       	push   $0x8010a520
8010072e:	e8 ce 36 00 00       	call   80103e01 <release>
80100733:	83 c4 10             	add    $0x10,%esp
}
80100736:	e9 de fe ff ff       	jmp    80100619 <cprintf+0x38>

8010073b <consoleintr>:
{
8010073b:	55                   	push   %ebp
8010073c:	89 e5                	mov    %esp,%ebp
8010073e:	57                   	push   %edi
8010073f:	56                   	push   %esi
80100740:	53                   	push   %ebx
80100741:	83 ec 28             	sub    $0x28,%esp
80100744:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100747:	68 20 a5 10 80       	push   $0x8010a520
8010074c:	e8 49 36 00 00       	call   80103d9a <acquire>
  while((c = getc()) >= 0){
80100751:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100754:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010075b:	bb 20 ff 10 80       	mov    $0x8010ff20,%ebx
  while((c = getc()) >= 0){
80100760:	e9 c2 00 00 00       	jmp    80100827 <consoleintr+0xec>
    switch(c){
80100765:	83 fe 08             	cmp    $0x8,%esi
80100768:	0f 84 dd 00 00 00    	je     8010084b <consoleintr+0x110>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010076e:	85 f6                	test   %esi,%esi
80100770:	0f 84 b1 00 00 00    	je     80100827 <consoleintr+0xec>
80100776:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010077c:	89 c2                	mov    %eax,%edx
8010077e:	2b 93 80 00 00 00    	sub    0x80(%ebx),%edx
80100784:	83 fa 7f             	cmp    $0x7f,%edx
80100787:	0f 87 9a 00 00 00    	ja     80100827 <consoleintr+0xec>
        c = (c == '\r') ? '\n' : c;
8010078d:	83 fe 0d             	cmp    $0xd,%esi
80100790:	0f 84 fd 00 00 00    	je     80100893 <consoleintr+0x158>
        input.buf[input.e++ % INPUT_BUF] = c;
80100796:	8d 50 01             	lea    0x1(%eax),%edx
80100799:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
8010079f:	83 e0 7f             	and    $0x7f,%eax
801007a2:	89 f1                	mov    %esi,%ecx
801007a4:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
        consputc(c);
801007a7:	89 f0                	mov    %esi,%eax
801007a9:	e8 0e fc ff ff       	call   801003bc <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ae:	83 fe 0a             	cmp    $0xa,%esi
801007b1:	0f 84 f6 00 00 00    	je     801008ad <consoleintr+0x172>
801007b7:	83 fe 04             	cmp    $0x4,%esi
801007ba:	0f 84 ed 00 00 00    	je     801008ad <consoleintr+0x172>
801007c0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801007c6:	83 e8 80             	sub    $0xffffff80,%eax
801007c9:	39 83 88 00 00 00    	cmp    %eax,0x88(%ebx)
801007cf:	75 56                	jne    80100827 <consoleintr+0xec>
801007d1:	e9 d7 00 00 00       	jmp    801008ad <consoleintr+0x172>
      while(input.e != input.w &&
801007d6:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801007dc:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801007e2:	74 43                	je     80100827 <consoleintr+0xec>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007e4:	83 e8 01             	sub    $0x1,%eax
801007e7:	89 c2                	mov    %eax,%edx
801007e9:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007ec:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
801007f0:	74 35                	je     80100827 <consoleintr+0xec>
        input.e--;
801007f2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
801007f8:	b8 00 01 00 00       	mov    $0x100,%eax
801007fd:	e8 ba fb ff ff       	call   801003bc <consputc>
      while(input.e != input.w &&
80100802:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100808:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
8010080e:	74 17                	je     80100827 <consoleintr+0xec>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100810:	83 e8 01             	sub    $0x1,%eax
80100813:	89 c2                	mov    %eax,%edx
80100815:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100818:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
8010081c:	75 d4                	jne    801007f2 <consoleintr+0xb7>
8010081e:	eb 07                	jmp    80100827 <consoleintr+0xec>
      doprocdump = 1;
80100820:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
80100827:	ff d7                	call   *%edi
80100829:	89 c6                	mov    %eax,%esi
8010082b:	85 c0                	test   %eax,%eax
8010082d:	78 3f                	js     8010086e <consoleintr+0x133>
    switch(c){
8010082f:	83 fe 10             	cmp    $0x10,%esi
80100832:	74 ec                	je     80100820 <consoleintr+0xe5>
80100834:	83 fe 10             	cmp    $0x10,%esi
80100837:	0f 8e 28 ff ff ff    	jle    80100765 <consoleintr+0x2a>
8010083d:	83 fe 15             	cmp    $0x15,%esi
80100840:	74 94                	je     801007d6 <consoleintr+0x9b>
80100842:	83 fe 7f             	cmp    $0x7f,%esi
80100845:	0f 85 23 ff ff ff    	jne    8010076e <consoleintr+0x33>
      if(input.e != input.w){
8010084b:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100851:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100857:	74 ce                	je     80100827 <consoleintr+0xec>
        input.e--;
80100859:	83 e8 01             	sub    $0x1,%eax
8010085c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
80100862:	b8 00 01 00 00       	mov    $0x100,%eax
80100867:	e8 50 fb ff ff       	call   801003bc <consputc>
8010086c:	eb b9                	jmp    80100827 <consoleintr+0xec>
  release(&cons.lock);
8010086e:	83 ec 0c             	sub    $0xc,%esp
80100871:	68 20 a5 10 80       	push   $0x8010a520
80100876:	e8 86 35 00 00       	call   80103e01 <release>
  if(doprocdump) {
8010087b:	83 c4 10             	add    $0x10,%esp
8010087e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100882:	75 08                	jne    8010088c <consoleintr+0x151>
}
80100884:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100887:	5b                   	pop    %ebx
80100888:	5e                   	pop    %esi
80100889:	5f                   	pop    %edi
8010088a:	5d                   	pop    %ebp
8010088b:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
8010088c:	e8 e8 31 00 00       	call   80103a79 <procdump>
}
80100891:	eb f1                	jmp    80100884 <consoleintr+0x149>
        input.buf[input.e++ % INPUT_BUF] = c;
80100893:	8d 50 01             	lea    0x1(%eax),%edx
80100896:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
8010089c:	83 e0 7f             	and    $0x7f,%eax
8010089f:	c6 04 03 0a          	movb   $0xa,(%ebx,%eax,1)
        consputc(c);
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	e8 0f fb ff ff       	call   801003bc <consputc>
          input.w = input.e;
801008ad:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801008b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
          wakeup(&input.r);
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 a0 ff 10 80       	push   $0x8010ffa0
801008c1:	e8 09 31 00 00       	call   801039cf <wakeup>
801008c6:	83 c4 10             	add    $0x10,%esp
801008c9:	e9 59 ff ff ff       	jmp    80100827 <consoleintr+0xec>

801008ce <consoleinit>:

void
consoleinit(void)
{
801008ce:	55                   	push   %ebp
801008cf:	89 e5                	mov    %esp,%ebp
801008d1:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008d4:	68 e8 68 10 80       	push   $0x801068e8
801008d9:	68 20 a5 10 80       	push   $0x8010a520
801008de:	e8 6f 33 00 00       	call   80103c52 <initlock>

  devsw[CONSOLE].write = consolewrite;
801008e3:	c7 05 6c 09 11 80 82 	movl   $0x80100582,0x8011096c
801008ea:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008ed:	c7 05 68 09 11 80 54 	movl   $0x80100254,0x80110968
801008f4:	02 10 80 
  cons.locking = 1;
801008f7:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008fe:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100901:	83 c4 08             	add    $0x8,%esp
80100904:	6a 00                	push   $0x0
80100906:	6a 01                	push   $0x1
80100908:	e8 36 17 00 00       	call   80102043 <ioapicenable>
}
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	c9                   	leave  
80100911:	c3                   	ret    

80100912 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100912:	55                   	push   %ebp
80100913:	89 e5                	mov    %esp,%ebp
80100915:	57                   	push   %edi
80100916:	56                   	push   %esi
80100917:	53                   	push   %ebx
80100918:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010091e:	e8 53 2a 00 00       	call   80103376 <myproc>
80100923:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100929:	e8 bc 1e 00 00       	call   801027ea <begin_op>

  if((ip = namei(path)) == 0){
8010092e:	83 ec 0c             	sub    $0xc,%esp
80100931:	ff 75 08             	pushl  0x8(%ebp)
80100934:	e8 87 13 00 00       	call   80101cc0 <namei>
80100939:	83 c4 10             	add    $0x10,%esp
8010093c:	85 c0                	test   %eax,%eax
8010093e:	74 42                	je     80100982 <exec+0x70>
80100940:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100942:	83 ec 0c             	sub    $0xc,%esp
80100945:	50                   	push   %eax
80100946:	e8 d8 0b 00 00       	call   80101523 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010094b:	6a 34                	push   $0x34
8010094d:	6a 00                	push   $0x0
8010094f:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100955:	50                   	push   %eax
80100956:	53                   	push   %ebx
80100957:	e8 5b 0e 00 00       	call   801017b7 <readi>
8010095c:	83 c4 20             	add    $0x20,%esp
8010095f:	83 f8 34             	cmp    $0x34,%eax
80100962:	74 3a                	je     8010099e <exec+0x8c>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100964:	83 ec 0c             	sub    $0xc,%esp
80100967:	53                   	push   %ebx
80100968:	e8 ff 0d 00 00       	call   8010176c <iunlockput>
    end_op();
8010096d:	e8 f3 1e 00 00       	call   80102865 <end_op>
80100972:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010097a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010097d:	5b                   	pop    %ebx
8010097e:	5e                   	pop    %esi
8010097f:	5f                   	pop    %edi
80100980:	5d                   	pop    %ebp
80100981:	c3                   	ret    
    end_op();
80100982:	e8 de 1e 00 00       	call   80102865 <end_op>
    cprintf("exec: fail\n");
80100987:	83 ec 0c             	sub    $0xc,%esp
8010098a:	68 01 69 10 80       	push   $0x80106901
8010098f:	e8 4d fc ff ff       	call   801005e1 <cprintf>
    return -1;
80100994:	83 c4 10             	add    $0x10,%esp
80100997:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010099c:	eb dc                	jmp    8010097a <exec+0x68>
  if(elf.magic != ELF_MAGIC)
8010099e:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801009a5:	45 4c 46 
801009a8:	75 ba                	jne    80100964 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
801009aa:	e8 25 5a 00 00       	call   801063d4 <setupkvm>
801009af:	89 c7                	mov    %eax,%edi
801009b1:	85 c0                	test   %eax,%eax
801009b3:	74 af                	je     80100964 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
801009bb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009c1:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801009c8:	00 
801009c9:	0f 84 bf 00 00 00    	je     80100a8e <exec+0x17c>
  sz = PGSIZE;
801009cf:	c7 85 ec fe ff ff 00 	movl   $0x1000,-0x114(%ebp)
801009d6:	10 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009d9:	be 00 00 00 00       	mov    $0x0,%esi
801009de:	eb 12                	jmp    801009f2 <exec+0xe0>
801009e0:	83 c6 01             	add    $0x1,%esi
801009e3:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801009ea:	39 f0                	cmp    %esi,%eax
801009ec:	0f 8e a6 00 00 00    	jle    80100a98 <exec+0x186>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009f2:	6a 20                	push   $0x20
801009f4:	89 f0                	mov    %esi,%eax
801009f6:	c1 e0 05             	shl    $0x5,%eax
801009f9:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
801009ff:	50                   	push   %eax
80100a00:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a06:	50                   	push   %eax
80100a07:	53                   	push   %ebx
80100a08:	e8 aa 0d 00 00       	call   801017b7 <readi>
80100a0d:	83 c4 10             	add    $0x10,%esp
80100a10:	83 f8 20             	cmp    $0x20,%eax
80100a13:	0f 85 c2 00 00 00    	jne    80100adb <exec+0x1c9>
    if(ph.type != ELF_PROG_LOAD)
80100a19:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a20:	75 be                	jne    801009e0 <exec+0xce>
    if(ph.memsz < ph.filesz)
80100a22:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a28:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a2e:	0f 82 a7 00 00 00    	jb     80100adb <exec+0x1c9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a34:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a3a:	0f 82 9b 00 00 00    	jb     80100adb <exec+0x1c9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a40:	83 ec 04             	sub    $0x4,%esp
80100a43:	50                   	push   %eax
80100a44:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a4a:	57                   	push   %edi
80100a4b:	e8 22 58 00 00       	call   80106272 <allocuvm>
80100a50:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a56:	83 c4 10             	add    $0x10,%esp
80100a59:	85 c0                	test   %eax,%eax
80100a5b:	74 7e                	je     80100adb <exec+0x1c9>
    if(ph.vaddr % PGSIZE != 0)
80100a5d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a68:	75 71                	jne    80100adb <exec+0x1c9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a6a:	83 ec 0c             	sub    $0xc,%esp
80100a6d:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a73:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a79:	53                   	push   %ebx
80100a7a:	50                   	push   %eax
80100a7b:	57                   	push   %edi
80100a7c:	e8 b4 56 00 00       	call   80106135 <loaduvm>
80100a81:	83 c4 20             	add    $0x20,%esp
80100a84:	85 c0                	test   %eax,%eax
80100a86:	0f 89 54 ff ff ff    	jns    801009e0 <exec+0xce>
 bad:
80100a8c:	eb 4d                	jmp    80100adb <exec+0x1c9>
  sz = PGSIZE;
80100a8e:	c7 85 ec fe ff ff 00 	movl   $0x1000,-0x114(%ebp)
80100a95:	10 00 00 
  iunlockput(ip);
80100a98:	83 ec 0c             	sub    $0xc,%esp
80100a9b:	53                   	push   %ebx
80100a9c:	e8 cb 0c 00 00       	call   8010176c <iunlockput>
  end_op();
80100aa1:	e8 bf 1d 00 00       	call   80102865 <end_op>
  sz = PGROUNDUP(sz);
80100aa6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100aac:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ab1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ab6:	89 c2                	mov    %eax,%edx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ab8:	83 c4 0c             	add    $0xc,%esp
80100abb:	8d 80 00 20 00 00    	lea    0x2000(%eax),%eax
80100ac1:	50                   	push   %eax
80100ac2:	52                   	push   %edx
80100ac3:	57                   	push   %edi
80100ac4:	e8 a9 57 00 00       	call   80106272 <allocuvm>
80100ac9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100acf:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100ad2:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	75 1e                	jne    80100af9 <exec+0x1e7>
    freevm(pgdir);
80100adb:	83 ec 0c             	sub    $0xc,%esp
80100ade:	57                   	push   %edi
80100adf:	e8 7d 58 00 00       	call   80106361 <freevm>
  if(ip){
80100ae4:	83 c4 10             	add    $0x10,%esp
80100ae7:	85 db                	test   %ebx,%ebx
80100ae9:	0f 85 75 fe ff ff    	jne    80100964 <exec+0x52>
  return -1;
80100aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100af4:	e9 81 fe ff ff       	jmp    8010097a <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100af9:	83 ec 08             	sub    $0x8,%esp
80100afc:	89 c3                	mov    %eax,%ebx
80100afe:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b04:	50                   	push   %eax
80100b05:	57                   	push   %edi
80100b06:	e8 4e 59 00 00       	call   80106459 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b0e:	8b 00                	mov    (%eax),%eax
80100b10:	83 c4 10             	add    $0x10,%esp
80100b13:	be 00 00 00 00       	mov    $0x0,%esi
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	74 5f                	je     80100b7b <exec+0x269>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b1c:	83 ec 0c             	sub    $0xc,%esp
80100b1f:	50                   	push   %eax
80100b20:	e8 e6 34 00 00       	call   8010400b <strlen>
80100b25:	f7 d0                	not    %eax
80100b27:	01 d8                	add    %ebx,%eax
80100b29:	83 e0 fc             	and    $0xfffffffc,%eax
80100b2c:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b2e:	83 c4 04             	add    $0x4,%esp
80100b31:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b34:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b37:	e8 cf 34 00 00       	call   8010400b <strlen>
80100b3c:	83 c0 01             	add    $0x1,%eax
80100b3f:	50                   	push   %eax
80100b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b43:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b46:	53                   	push   %ebx
80100b47:	57                   	push   %edi
80100b48:	e8 ae 5a 00 00       	call   801065fb <copyout>
80100b4d:	83 c4 20             	add    $0x20,%esp
80100b50:	85 c0                	test   %eax,%eax
80100b52:	0f 88 1f 01 00 00    	js     80100c77 <exec+0x365>
    ustack[3+argc] = sp;
80100b58:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b5f:	83 c6 01             	add    $0x1,%esi
80100b62:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b65:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b68:	85 c0                	test   %eax,%eax
80100b6a:	74 15                	je     80100b81 <exec+0x26f>
    if(argc >= MAXARG)
80100b6c:	83 fe 20             	cmp    $0x20,%esi
80100b6f:	75 ab                	jne    80100b1c <exec+0x20a>
  ip = 0;
80100b71:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b76:	e9 60 ff ff ff       	jmp    80100adb <exec+0x1c9>
  sp = sz;
80100b7b:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
  ustack[3+argc] = 0;
80100b81:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b88:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b8c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b93:	ff ff ff 
  ustack[1] = argc;
80100b96:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b9c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100ba3:	89 da                	mov    %ebx,%edx
80100ba5:	29 c2                	sub    %eax,%edx
80100ba7:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100bad:	83 c0 0c             	add    $0xc,%eax
80100bb0:	89 de                	mov    %ebx,%esi
80100bb2:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bb4:	50                   	push   %eax
80100bb5:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100bbb:	50                   	push   %eax
80100bbc:	56                   	push   %esi
80100bbd:	57                   	push   %edi
80100bbe:	e8 38 5a 00 00       	call   801065fb <copyout>
80100bc3:	83 c4 10             	add    $0x10,%esp
80100bc6:	85 c0                	test   %eax,%eax
80100bc8:	0f 88 b3 00 00 00    	js     80100c81 <exec+0x36f>
    curproc->shared_page[i] = 0;
80100bce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bd4:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
80100bdb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80100be2:	00 00 00 
80100be5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80100bec:	00 00 00 
80100bef:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80100bf6:	00 00 00 
  for(last=s=path; *s; s++)
80100bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80100bfc:	0f b6 10             	movzbl (%eax),%edx
80100bff:	84 d2                	test   %dl,%dl
80100c01:	74 1a                	je     80100c1d <exec+0x30b>
80100c03:	83 c0 01             	add    $0x1,%eax
80100c06:	8b 4d 08             	mov    0x8(%ebp),%ecx
      last = s+1;
80100c09:	80 fa 2f             	cmp    $0x2f,%dl
80100c0c:	0f 44 c8             	cmove  %eax,%ecx
80100c0f:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100c12:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100c16:	84 d2                	test   %dl,%dl
80100c18:	75 ef                	jne    80100c09 <exec+0x2f7>
80100c1a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c1d:	83 ec 04             	sub    $0x4,%esp
80100c20:	6a 10                	push   $0x10
80100c22:	ff 75 08             	pushl  0x8(%ebp)
80100c25:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100c2b:	89 d8                	mov    %ebx,%eax
80100c2d:	83 c0 6c             	add    $0x6c,%eax
80100c30:	50                   	push   %eax
80100c31:	e8 a1 33 00 00       	call   80103fd7 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c36:	89 d8                	mov    %ebx,%eax
80100c38:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100c3b:	89 78 04             	mov    %edi,0x4(%eax)
  curproc->sz = sz;
80100c3e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c44:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100c46:	89 c7                	mov    %eax,%edi
80100c48:	8b 40 18             	mov    0x18(%eax),%eax
80100c4b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c51:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c54:	8b 47 18             	mov    0x18(%edi),%eax
80100c57:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c5a:	89 3c 24             	mov    %edi,(%esp)
80100c5d:	e8 6d 53 00 00       	call   80105fcf <switchuvm>
  freevm(oldpgdir);
80100c62:	89 1c 24             	mov    %ebx,(%esp)
80100c65:	e8 f7 56 00 00       	call   80106361 <freevm>
  return 0;
80100c6a:	83 c4 10             	add    $0x10,%esp
80100c6d:	b8 00 00 00 00       	mov    $0x0,%eax
80100c72:	e9 03 fd ff ff       	jmp    8010097a <exec+0x68>
  ip = 0;
80100c77:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c7c:	e9 5a fe ff ff       	jmp    80100adb <exec+0x1c9>
80100c81:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c86:	e9 50 fe ff ff       	jmp    80100adb <exec+0x1c9>

80100c8b <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c8b:	55                   	push   %ebp
80100c8c:	89 e5                	mov    %esp,%ebp
80100c8e:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c91:	68 0d 69 10 80       	push   $0x8010690d
80100c96:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c9b:	e8 b2 2f 00 00       	call   80103c52 <initlock>
}
80100ca0:	83 c4 10             	add    $0x10,%esp
80100ca3:	c9                   	leave  
80100ca4:	c3                   	ret    

80100ca5 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ca5:	55                   	push   %ebp
80100ca6:	89 e5                	mov    %esp,%ebp
80100ca8:	53                   	push   %ebx
80100ca9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100cac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cb1:	e8 e4 30 00 00       	call   80103d9a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100cb6:	83 c4 10             	add    $0x10,%esp
80100cb9:	83 3d f8 ff 10 80 00 	cmpl   $0x0,0x8010fff8
80100cc0:	74 2d                	je     80100cef <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cc2:	bb 0c 00 11 80       	mov    $0x8011000c,%ebx
    if(f->ref == 0){
80100cc7:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100ccb:	74 27                	je     80100cf4 <filealloc+0x4f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ccd:	83 c3 18             	add    $0x18,%ebx
80100cd0:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100cd6:	72 ef                	jb     80100cc7 <filealloc+0x22>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ce0:	e8 1c 31 00 00       	call   80103e01 <release>
  return 0;
80100ce5:	83 c4 10             	add    $0x10,%esp
80100ce8:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ced:	eb 1c                	jmp    80100d0b <filealloc+0x66>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cef:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
      f->ref = 1;
80100cf4:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d03:	e8 f9 30 00 00       	call   80103e01 <release>
      return f;
80100d08:	83 c4 10             	add    $0x10,%esp
}
80100d0b:	89 d8                	mov    %ebx,%eax
80100d0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d10:	c9                   	leave  
80100d11:	c3                   	ret    

80100d12 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d12:	55                   	push   %ebp
80100d13:	89 e5                	mov    %esp,%ebp
80100d15:	53                   	push   %ebx
80100d16:	83 ec 10             	sub    $0x10,%esp
80100d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d1c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d21:	e8 74 30 00 00       	call   80103d9a <acquire>
  if(f->ref < 1)
80100d26:	8b 43 04             	mov    0x4(%ebx),%eax
80100d29:	83 c4 10             	add    $0x10,%esp
80100d2c:	85 c0                	test   %eax,%eax
80100d2e:	7e 1a                	jle    80100d4a <filedup+0x38>
    panic("filedup");
  f->ref++;
80100d30:	83 c0 01             	add    $0x1,%eax
80100d33:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d36:	83 ec 0c             	sub    $0xc,%esp
80100d39:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d3e:	e8 be 30 00 00       	call   80103e01 <release>
  return f;
}
80100d43:	89 d8                	mov    %ebx,%eax
80100d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
    panic("filedup");
80100d4a:	83 ec 0c             	sub    $0xc,%esp
80100d4d:	68 14 69 10 80       	push   $0x80106914
80100d52:	e8 ed f5 ff ff       	call   80100344 <panic>

80100d57 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d57:	55                   	push   %ebp
80100d58:	89 e5                	mov    %esp,%ebp
80100d5a:	57                   	push   %edi
80100d5b:	56                   	push   %esi
80100d5c:	53                   	push   %ebx
80100d5d:	83 ec 28             	sub    $0x28,%esp
80100d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d63:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d68:	e8 2d 30 00 00       	call   80103d9a <acquire>
  if(f->ref < 1)
80100d6d:	8b 43 04             	mov    0x4(%ebx),%eax
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	85 c0                	test   %eax,%eax
80100d75:	7e 22                	jle    80100d99 <fileclose+0x42>
    panic("fileclose");
  if(--f->ref > 0){
80100d77:	83 e8 01             	sub    $0x1,%eax
80100d7a:	89 43 04             	mov    %eax,0x4(%ebx)
80100d7d:	85 c0                	test   %eax,%eax
80100d7f:	7e 25                	jle    80100da6 <fileclose+0x4f>
    release(&ftable.lock);
80100d81:	83 ec 0c             	sub    $0xc,%esp
80100d84:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d89:	e8 73 30 00 00       	call   80103e01 <release>
80100d8e:	83 c4 10             	add    $0x10,%esp
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d94:	5b                   	pop    %ebx
80100d95:	5e                   	pop    %esi
80100d96:	5f                   	pop    %edi
80100d97:	5d                   	pop    %ebp
80100d98:	c3                   	ret    
    panic("fileclose");
80100d99:	83 ec 0c             	sub    $0xc,%esp
80100d9c:	68 1c 69 10 80       	push   $0x8010691c
80100da1:	e8 9e f5 ff ff       	call   80100344 <panic>
  ff = *f;
80100da6:	8b 33                	mov    (%ebx),%esi
80100da8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100dac:	88 45 e7             	mov    %al,-0x19(%ebp)
80100daf:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100db2:	8b 43 10             	mov    0x10(%ebx),%eax
80100db5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100db8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100dbf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dcd:	e8 2f 30 00 00       	call   80103e01 <release>
  if(ff.type == FD_PIPE)
80100dd2:	83 c4 10             	add    $0x10,%esp
80100dd5:	83 fe 01             	cmp    $0x1,%esi
80100dd8:	74 1f                	je     80100df9 <fileclose+0xa2>
  else if(ff.type == FD_INODE){
80100dda:	83 fe 02             	cmp    $0x2,%esi
80100ddd:	75 b2                	jne    80100d91 <fileclose+0x3a>
    begin_op();
80100ddf:	e8 06 1a 00 00       	call   801027ea <begin_op>
    iput(ff.ip);
80100de4:	83 ec 0c             	sub    $0xc,%esp
80100de7:	ff 75 e0             	pushl  -0x20(%ebp)
80100dea:	e8 3b 08 00 00       	call   8010162a <iput>
    end_op();
80100def:	e8 71 1a 00 00       	call   80102865 <end_op>
80100df4:	83 c4 10             	add    $0x10,%esp
80100df7:	eb 98                	jmp    80100d91 <fileclose+0x3a>
    pipeclose(ff.pipe, ff.writable);
80100df9:	83 ec 08             	sub    $0x8,%esp
80100dfc:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100e00:	50                   	push   %eax
80100e01:	57                   	push   %edi
80100e02:	e8 15 21 00 00       	call   80102f1c <pipeclose>
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	eb 85                	jmp    80100d91 <fileclose+0x3a>

80100e0c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e0c:	55                   	push   %ebp
80100e0d:	89 e5                	mov    %esp,%ebp
80100e0f:	53                   	push   %ebx
80100e10:	83 ec 04             	sub    $0x4,%esp
80100e13:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e16:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e19:	75 31                	jne    80100e4c <filestat+0x40>
    ilock(f->ip);
80100e1b:	83 ec 0c             	sub    $0xc,%esp
80100e1e:	ff 73 10             	pushl  0x10(%ebx)
80100e21:	e8 fd 06 00 00       	call   80101523 <ilock>
    stati(f->ip, st);
80100e26:	83 c4 08             	add    $0x8,%esp
80100e29:	ff 75 0c             	pushl  0xc(%ebp)
80100e2c:	ff 73 10             	pushl  0x10(%ebx)
80100e2f:	e8 58 09 00 00       	call   8010178c <stati>
    iunlock(f->ip);
80100e34:	83 c4 04             	add    $0x4,%esp
80100e37:	ff 73 10             	pushl  0x10(%ebx)
80100e3a:	e8 a6 07 00 00       	call   801015e5 <iunlock>
    return 0;
80100e3f:	83 c4 10             	add    $0x10,%esp
80100e42:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4a:	c9                   	leave  
80100e4b:	c3                   	ret    
  return -1;
80100e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e51:	eb f4                	jmp    80100e47 <filestat+0x3b>

80100e53 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e53:	55                   	push   %ebp
80100e54:	89 e5                	mov    %esp,%ebp
80100e56:	56                   	push   %esi
80100e57:	53                   	push   %ebx
80100e58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e5b:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e5f:	74 70                	je     80100ed1 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e61:	8b 03                	mov    (%ebx),%eax
80100e63:	83 f8 01             	cmp    $0x1,%eax
80100e66:	74 44                	je     80100eac <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e68:	83 f8 02             	cmp    $0x2,%eax
80100e6b:	75 57                	jne    80100ec4 <fileread+0x71>
    ilock(f->ip);
80100e6d:	83 ec 0c             	sub    $0xc,%esp
80100e70:	ff 73 10             	pushl  0x10(%ebx)
80100e73:	e8 ab 06 00 00       	call   80101523 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e78:	ff 75 10             	pushl  0x10(%ebp)
80100e7b:	ff 73 14             	pushl  0x14(%ebx)
80100e7e:	ff 75 0c             	pushl  0xc(%ebp)
80100e81:	ff 73 10             	pushl  0x10(%ebx)
80100e84:	e8 2e 09 00 00       	call   801017b7 <readi>
80100e89:	89 c6                	mov    %eax,%esi
80100e8b:	83 c4 20             	add    $0x20,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 03                	jle    80100e95 <fileread+0x42>
      f->off += r;
80100e92:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e95:	83 ec 0c             	sub    $0xc,%esp
80100e98:	ff 73 10             	pushl  0x10(%ebx)
80100e9b:	e8 45 07 00 00       	call   801015e5 <iunlock>
    return r;
80100ea0:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100ea3:	89 f0                	mov    %esi,%eax
80100ea5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5d                   	pop    %ebp
80100eab:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100eac:	83 ec 04             	sub    $0x4,%esp
80100eaf:	ff 75 10             	pushl  0x10(%ebp)
80100eb2:	ff 75 0c             	pushl  0xc(%ebp)
80100eb5:	ff 73 0c             	pushl  0xc(%ebx)
80100eb8:	e8 e4 21 00 00       	call   801030a1 <piperead>
80100ebd:	89 c6                	mov    %eax,%esi
80100ebf:	83 c4 10             	add    $0x10,%esp
80100ec2:	eb df                	jmp    80100ea3 <fileread+0x50>
  panic("fileread");
80100ec4:	83 ec 0c             	sub    $0xc,%esp
80100ec7:	68 26 69 10 80       	push   $0x80106926
80100ecc:	e8 73 f4 ff ff       	call   80100344 <panic>
    return -1;
80100ed1:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100ed6:	eb cb                	jmp    80100ea3 <fileread+0x50>

80100ed8 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ed8:	55                   	push   %ebp
80100ed9:	89 e5                	mov    %esp,%ebp
80100edb:	57                   	push   %edi
80100edc:	56                   	push   %esi
80100edd:	53                   	push   %ebx
80100ede:	83 ec 1c             	sub    $0x1c,%esp
80100ee1:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ee4:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100ee8:	0f 84 e8 00 00 00    	je     80100fd6 <filewrite+0xfe>
    return -1;
  if(f->type == FD_PIPE)
80100eee:	8b 06                	mov    (%esi),%eax
80100ef0:	83 f8 01             	cmp    $0x1,%eax
80100ef3:	74 1a                	je     80100f0f <filewrite+0x37>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ef5:	83 f8 02             	cmp    $0x2,%eax
80100ef8:	0f 85 cb 00 00 00    	jne    80100fc9 <filewrite+0xf1>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100efe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100f02:	0f 8e 9e 00 00 00    	jle    80100fa6 <filewrite+0xce>
    int i = 0;
80100f08:	bf 00 00 00 00       	mov    $0x0,%edi
80100f0d:	eb 3f                	jmp    80100f4e <filewrite+0x76>
    return pipewrite(f->pipe, addr, n);
80100f0f:	83 ec 04             	sub    $0x4,%esp
80100f12:	ff 75 10             	pushl  0x10(%ebp)
80100f15:	ff 75 0c             	pushl  0xc(%ebp)
80100f18:	ff 76 0c             	pushl  0xc(%esi)
80100f1b:	e8 88 20 00 00       	call   80102fa8 <pipewrite>
80100f20:	89 45 10             	mov    %eax,0x10(%ebp)
80100f23:	83 c4 10             	add    $0x10,%esp
80100f26:	e9 93 00 00 00       	jmp    80100fbe <filewrite+0xe6>

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100f2b:	83 ec 0c             	sub    $0xc,%esp
80100f2e:	ff 76 10             	pushl  0x10(%esi)
80100f31:	e8 af 06 00 00       	call   801015e5 <iunlock>
      end_op();
80100f36:	e8 2a 19 00 00       	call   80102865 <end_op>

      if(r < 0)
80100f3b:	83 c4 10             	add    $0x10,%esp
80100f3e:	85 db                	test   %ebx,%ebx
80100f40:	78 6b                	js     80100fad <filewrite+0xd5>
        break;
      if(r != n1)
80100f42:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100f45:	75 4e                	jne    80100f95 <filewrite+0xbd>
        panic("short filewrite");
      i += r;
80100f47:	01 df                	add    %ebx,%edi
    while(i < n){
80100f49:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100f4c:	7e 54                	jle    80100fa2 <filewrite+0xca>
      int n1 = n - i;
80100f4e:	8b 45 10             	mov    0x10(%ebp),%eax
80100f51:	29 f8                	sub    %edi,%eax
80100f53:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f58:	ba 00 06 00 00       	mov    $0x600,%edx
80100f5d:	0f 4f c2             	cmovg  %edx,%eax
80100f60:	89 c3                	mov    %eax,%ebx
80100f62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      begin_op();
80100f65:	e8 80 18 00 00       	call   801027ea <begin_op>
      ilock(f->ip);
80100f6a:	83 ec 0c             	sub    $0xc,%esp
80100f6d:	ff 76 10             	pushl  0x10(%esi)
80100f70:	e8 ae 05 00 00       	call   80101523 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f75:	53                   	push   %ebx
80100f76:	ff 76 14             	pushl  0x14(%esi)
80100f79:	89 f8                	mov    %edi,%eax
80100f7b:	03 45 0c             	add    0xc(%ebp),%eax
80100f7e:	50                   	push   %eax
80100f7f:	ff 76 10             	pushl  0x10(%esi)
80100f82:	e8 2c 09 00 00       	call   801018b3 <writei>
80100f87:	89 c3                	mov    %eax,%ebx
80100f89:	83 c4 20             	add    $0x20,%esp
80100f8c:	85 c0                	test   %eax,%eax
80100f8e:	7e 9b                	jle    80100f2b <filewrite+0x53>
        f->off += r;
80100f90:	01 46 14             	add    %eax,0x14(%esi)
80100f93:	eb 96                	jmp    80100f2b <filewrite+0x53>
        panic("short filewrite");
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	68 2f 69 10 80       	push   $0x8010692f
80100f9d:	e8 a2 f3 ff ff       	call   80100344 <panic>
80100fa2:	89 f8                	mov    %edi,%eax
80100fa4:	eb 09                	jmp    80100faf <filewrite+0xd7>
    int i = 0;
80100fa6:	b8 00 00 00 00       	mov    $0x0,%eax
80100fab:	eb 02                	jmp    80100faf <filewrite+0xd7>
80100fad:	89 f8                	mov    %edi,%eax
    }
    return i == n ? n : -1;
80100faf:	39 45 10             	cmp    %eax,0x10(%ebp)
80100fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb7:	0f 44 45 10          	cmove  0x10(%ebp),%eax
80100fbb:	89 45 10             	mov    %eax,0x10(%ebp)
  }
  panic("filewrite");
}
80100fbe:	8b 45 10             	mov    0x10(%ebp),%eax
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
  panic("filewrite");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 35 69 10 80       	push   $0x80106935
80100fd1:	e8 6e f3 ff ff       	call   80100344 <panic>
    return -1;
80100fd6:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
80100fdd:	eb df                	jmp    80100fbe <filewrite+0xe6>

80100fdf <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80100fdf:	55                   	push   %ebp
80100fe0:	89 e5                	mov    %esp,%ebp
80100fe2:	57                   	push   %edi
80100fe3:	56                   	push   %esi
80100fe4:	53                   	push   %ebx
80100fe5:	83 ec 2c             	sub    $0x2c,%esp
80100fe8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80100feb:	83 3d c0 09 11 80 00 	cmpl   $0x0,0x801109c0
80100ff2:	0f 84 32 01 00 00    	je     8010112a <balloc+0x14b>
80100ff8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100fff:	e9 8f 00 00 00       	jmp    80101093 <balloc+0xb4>
80101004:	89 c3                	mov    %eax,%ebx
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101006:	09 ca                	or     %ecx,%edx
80101008:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010100b:	88 54 03 5c          	mov    %dl,0x5c(%ebx,%eax,1)
        log_write(bp);
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	53                   	push   %ebx
80101013:	e8 92 19 00 00       	call   801029aa <log_write>
        brelse(bp);
80101018:	89 1c 24             	mov    %ebx,(%esp)
8010101b:	e8 a1 f1 ff ff       	call   801001c1 <brelse>
  bp = bread(dev, bno);
80101020:	83 c4 08             	add    $0x8,%esp
80101023:	ff 75 e4             	pushl  -0x1c(%ebp)
80101026:	ff 75 d4             	pushl  -0x2c(%ebp)
80101029:	e8 7c f0 ff ff       	call   801000aa <bread>
8010102e:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
80101030:	83 c4 0c             	add    $0xc,%esp
80101033:	68 00 02 00 00       	push   $0x200
80101038:	6a 00                	push   $0x0
8010103a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010103d:	50                   	push   %eax
8010103e:	e8 05 2e 00 00       	call   80103e48 <memset>
  log_write(bp);
80101043:	89 34 24             	mov    %esi,(%esp)
80101046:	e8 5f 19 00 00       	call   801029aa <log_write>
  brelse(bp);
8010104b:	89 34 24             	mov    %esi,(%esp)
8010104e:	e8 6e f1 ff ff       	call   801001c1 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
8010105d:	c3                   	ret    
8010105e:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101060:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      m = 1 << (bi % 8);
80101063:	b9 01 00 00 00       	mov    $0x1,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101068:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010106f:	eb 95                	jmp    80101006 <balloc+0x27>
    brelse(bp);
80101071:	83 ec 0c             	sub    $0xc,%esp
80101074:	50                   	push   %eax
80101075:	e8 47 f1 ff ff       	call   801001c1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010107a:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
80101081:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101084:	83 c4 10             	add    $0x10,%esp
80101087:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010108d:	0f 86 97 00 00 00    	jbe    8010112a <balloc+0x14b>
    bp = bread(dev, BBLOCK(b, sb));
80101093:	83 ec 08             	sub    $0x8,%esp
80101096:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101099:	89 fb                	mov    %edi,%ebx
8010109b:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
801010a1:	85 ff                	test   %edi,%edi
801010a3:	0f 49 c7             	cmovns %edi,%eax
801010a6:	c1 f8 0c             	sar    $0xc,%eax
801010a9:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010af:	50                   	push   %eax
801010b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801010b3:	e8 f2 ef ff ff       	call   801000aa <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010b8:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
801010be:	83 c4 10             	add    $0x10,%esp
801010c1:	39 cf                	cmp    %ecx,%edi
801010c3:	73 ac                	jae    80101071 <balloc+0x92>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010c5:	0f b6 50 5c          	movzbl 0x5c(%eax),%edx
801010c9:	f6 c2 01             	test   $0x1,%dl
801010cc:	74 90                	je     8010105e <balloc+0x7f>
801010ce:	29 f9                	sub    %edi,%ecx
801010d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010d3:	be 01 00 00 00       	mov    $0x1,%esi
801010d8:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
801010db:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801010de:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801010e1:	74 8e                	je     80101071 <balloc+0x92>
      m = 1 << (bi % 8);
801010e3:	89 f2                	mov    %esi,%edx
801010e5:	c1 fa 1f             	sar    $0x1f,%edx
801010e8:	c1 ea 1d             	shr    $0x1d,%edx
801010eb:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
801010ee:	83 e1 07             	and    $0x7,%ecx
801010f1:	29 d1                	sub    %edx,%ecx
801010f3:	bf 01 00 00 00       	mov    $0x1,%edi
801010f8:	d3 e7                	shl    %cl,%edi
801010fa:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010fc:	8d 56 07             	lea    0x7(%esi),%edx
801010ff:	85 f6                	test   %esi,%esi
80101101:	0f 49 d6             	cmovns %esi,%edx
80101104:	c1 fa 03             	sar    $0x3,%edx
80101107:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010110a:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
8010110f:	0f b6 fa             	movzbl %dl,%edi
80101112:	85 cf                	test   %ecx,%edi
80101114:	0f 84 ea fe ff ff    	je     80101004 <balloc+0x25>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010111a:	83 c6 01             	add    $0x1,%esi
8010111d:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80101123:	75 b3                	jne    801010d8 <balloc+0xf9>
80101125:	e9 47 ff ff ff       	jmp    80101071 <balloc+0x92>
  panic("balloc: out of blocks");
8010112a:	83 ec 0c             	sub    $0xc,%esp
8010112d:	68 3f 69 10 80       	push   $0x8010693f
80101132:	e8 0d f2 ff ff       	call   80100344 <panic>

80101137 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101137:	55                   	push   %ebp
80101138:	89 e5                	mov    %esp,%ebp
8010113a:	57                   	push   %edi
8010113b:	56                   	push   %esi
8010113c:	53                   	push   %ebx
8010113d:	83 ec 1c             	sub    $0x1c,%esp
80101140:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101142:	83 fa 0b             	cmp    $0xb,%edx
80101145:	77 18                	ja     8010115f <bmap+0x28>
80101147:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
8010114a:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010114d:	85 db                	test   %ebx,%ebx
8010114f:	75 49                	jne    8010119a <bmap+0x63>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101151:	8b 00                	mov    (%eax),%eax
80101153:	e8 87 fe ff ff       	call   80100fdf <balloc>
80101158:	89 c3                	mov    %eax,%ebx
8010115a:	89 47 5c             	mov    %eax,0x5c(%edi)
8010115d:	eb 3b                	jmp    8010119a <bmap+0x63>
    return addr;
  }
  bn -= NDIRECT;
8010115f:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101162:	83 fb 7f             	cmp    $0x7f,%ebx
80101165:	77 68                	ja     801011cf <bmap+0x98>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101167:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010116d:	85 c0                	test   %eax,%eax
8010116f:	74 33                	je     801011a4 <bmap+0x6d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101171:	83 ec 08             	sub    $0x8,%esp
80101174:	50                   	push   %eax
80101175:	ff 36                	pushl  (%esi)
80101177:	e8 2e ef ff ff       	call   801000aa <bread>
8010117c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010117e:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
80101182:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101185:	8b 18                	mov    (%eax),%ebx
80101187:	83 c4 10             	add    $0x10,%esp
8010118a:	85 db                	test   %ebx,%ebx
8010118c:	74 25                	je     801011b3 <bmap+0x7c>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
8010118e:	83 ec 0c             	sub    $0xc,%esp
80101191:	57                   	push   %edi
80101192:	e8 2a f0 ff ff       	call   801001c1 <brelse>
    return addr;
80101197:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
8010119a:	89 d8                	mov    %ebx,%eax
8010119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119f:	5b                   	pop    %ebx
801011a0:	5e                   	pop    %esi
801011a1:	5f                   	pop    %edi
801011a2:	5d                   	pop    %ebp
801011a3:	c3                   	ret    
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011a4:	8b 06                	mov    (%esi),%eax
801011a6:	e8 34 fe ff ff       	call   80100fdf <balloc>
801011ab:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801011b1:	eb be                	jmp    80101171 <bmap+0x3a>
      a[bn] = addr = balloc(ip->dev);
801011b3:	8b 06                	mov    (%esi),%eax
801011b5:	e8 25 fe ff ff       	call   80100fdf <balloc>
801011ba:	89 c3                	mov    %eax,%ebx
801011bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011bf:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	57                   	push   %edi
801011c5:	e8 e0 17 00 00       	call   801029aa <log_write>
801011ca:	83 c4 10             	add    $0x10,%esp
801011cd:	eb bf                	jmp    8010118e <bmap+0x57>
  panic("bmap: out of range");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 55 69 10 80       	push   $0x80106955
801011d7:	e8 68 f1 ff ff       	call   80100344 <panic>

801011dc <iget>:
{
801011dc:	55                   	push   %ebp
801011dd:	89 e5                	mov    %esp,%ebp
801011df:	57                   	push   %edi
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	83 ec 28             	sub    $0x28,%esp
801011e5:	89 c7                	mov    %eax,%edi
801011e7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801011ea:	68 e0 09 11 80       	push   $0x801109e0
801011ef:	e8 a6 2b 00 00       	call   80103d9a <acquire>
801011f4:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011f7:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fc:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
80101201:	eb 1c                	jmp    8010121f <iget+0x43>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101203:	85 c0                	test   %eax,%eax
80101205:	75 0a                	jne    80101211 <iget+0x35>
80101207:	85 f6                	test   %esi,%esi
80101209:	0f 94 c0             	sete   %al
8010120c:	84 c0                	test   %al,%al
8010120e:	0f 45 f3             	cmovne %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101211:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101217:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010121d:	73 2d                	jae    8010124c <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010121f:	8b 43 08             	mov    0x8(%ebx),%eax
80101222:	85 c0                	test   %eax,%eax
80101224:	7e dd                	jle    80101203 <iget+0x27>
80101226:	39 3b                	cmp    %edi,(%ebx)
80101228:	75 e7                	jne    80101211 <iget+0x35>
8010122a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010122d:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101230:	75 df                	jne    80101211 <iget+0x35>
      ip->ref++;
80101232:	83 c0 01             	add    $0x1,%eax
80101235:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101238:	83 ec 0c             	sub    $0xc,%esp
8010123b:	68 e0 09 11 80       	push   $0x801109e0
80101240:	e8 bc 2b 00 00       	call   80103e01 <release>
      return ip;
80101245:	83 c4 10             	add    $0x10,%esp
80101248:	89 de                	mov    %ebx,%esi
8010124a:	eb 2a                	jmp    80101276 <iget+0x9a>
  if(empty == 0)
8010124c:	85 f6                	test   %esi,%esi
8010124e:	74 30                	je     80101280 <iget+0xa4>
  ip->dev = dev;
80101250:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101255:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101258:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010125f:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	68 e0 09 11 80       	push   $0x801109e0
8010126e:	e8 8e 2b 00 00       	call   80103e01 <release>
  return ip;
80101273:	83 c4 10             	add    $0x10,%esp
}
80101276:	89 f0                	mov    %esi,%eax
80101278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127b:	5b                   	pop    %ebx
8010127c:	5e                   	pop    %esi
8010127d:	5f                   	pop    %edi
8010127e:	5d                   	pop    %ebp
8010127f:	c3                   	ret    
    panic("iget: no inodes");
80101280:	83 ec 0c             	sub    $0xc,%esp
80101283:	68 68 69 10 80       	push   $0x80106968
80101288:	e8 b7 f0 ff ff       	call   80100344 <panic>

8010128d <readsb>:
{
8010128d:	55                   	push   %ebp
8010128e:	89 e5                	mov    %esp,%ebp
80101290:	53                   	push   %ebx
80101291:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
80101294:	6a 01                	push   $0x1
80101296:	ff 75 08             	pushl  0x8(%ebp)
80101299:	e8 0c ee ff ff       	call   801000aa <bread>
8010129e:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012a0:	83 c4 0c             	add    $0xc,%esp
801012a3:	6a 1c                	push   $0x1c
801012a5:	8d 40 5c             	lea    0x5c(%eax),%eax
801012a8:	50                   	push   %eax
801012a9:	ff 75 0c             	pushl  0xc(%ebp)
801012ac:	e8 2c 2c 00 00       	call   80103edd <memmove>
  brelse(bp);
801012b1:	89 1c 24             	mov    %ebx,(%esp)
801012b4:	e8 08 ef ff ff       	call   801001c1 <brelse>
}
801012b9:	83 c4 10             	add    $0x10,%esp
801012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012bf:	c9                   	leave  
801012c0:	c3                   	ret    

801012c1 <bfree>:
{
801012c1:	55                   	push   %ebp
801012c2:	89 e5                	mov    %esp,%ebp
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801012ca:	83 ec 08             	sub    $0x8,%esp
801012cd:	68 c0 09 11 80       	push   $0x801109c0
801012d2:	50                   	push   %eax
801012d3:	e8 b5 ff ff ff       	call   8010128d <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801012d8:	83 c4 08             	add    $0x8,%esp
801012db:	89 d8                	mov    %ebx,%eax
801012dd:	c1 e8 0c             	shr    $0xc,%eax
801012e0:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801012e6:	50                   	push   %eax
801012e7:	56                   	push   %esi
801012e8:	e8 bd ed ff ff       	call   801000aa <bread>
801012ed:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012ef:	89 d9                	mov    %ebx,%ecx
801012f1:	83 e1 07             	and    $0x7,%ecx
801012f4:	b8 01 00 00 00       	mov    $0x1,%eax
801012f9:	d3 e0                	shl    %cl,%eax
  bi = b % BPB;
801012fb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if((bp->data[bi/8] & m) == 0)
80101301:	83 c4 10             	add    $0x10,%esp
80101304:	c1 fb 03             	sar    $0x3,%ebx
80101307:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
8010130c:	0f b6 ca             	movzbl %dl,%ecx
8010130f:	85 c1                	test   %eax,%ecx
80101311:	74 23                	je     80101336 <bfree+0x75>
  bp->data[bi/8] &= ~m;
80101313:	f7 d0                	not    %eax
80101315:	21 d0                	and    %edx,%eax
80101317:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010131b:	83 ec 0c             	sub    $0xc,%esp
8010131e:	56                   	push   %esi
8010131f:	e8 86 16 00 00       	call   801029aa <log_write>
  brelse(bp);
80101324:	89 34 24             	mov    %esi,(%esp)
80101327:	e8 95 ee ff ff       	call   801001c1 <brelse>
}
8010132c:	83 c4 10             	add    $0x10,%esp
8010132f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101332:	5b                   	pop    %ebx
80101333:	5e                   	pop    %esi
80101334:	5d                   	pop    %ebp
80101335:	c3                   	ret    
    panic("freeing free block");
80101336:	83 ec 0c             	sub    $0xc,%esp
80101339:	68 78 69 10 80       	push   $0x80106978
8010133e:	e8 01 f0 ff ff       	call   80100344 <panic>

80101343 <iinit>:
{
80101343:	55                   	push   %ebp
80101344:	89 e5                	mov    %esp,%ebp
80101346:	56                   	push   %esi
80101347:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
80101348:	83 ec 08             	sub    $0x8,%esp
8010134b:	68 8b 69 10 80       	push   $0x8010698b
80101350:	68 e0 09 11 80       	push   $0x801109e0
80101355:	e8 f8 28 00 00       	call   80103c52 <initlock>
8010135a:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010135f:	be 40 26 11 80       	mov    $0x80112640,%esi
80101364:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
80101367:	83 ec 08             	sub    $0x8,%esp
8010136a:	68 92 69 10 80       	push   $0x80106992
8010136f:	53                   	push   %ebx
80101370:	e8 d3 27 00 00       	call   80103b48 <initsleeplock>
80101375:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(i = 0; i < NINODE; i++) {
8010137b:	83 c4 10             	add    $0x10,%esp
8010137e:	39 f3                	cmp    %esi,%ebx
80101380:	75 e5                	jne    80101367 <iinit+0x24>
  readsb(dev, &sb);
80101382:	83 ec 08             	sub    $0x8,%esp
80101385:	68 c0 09 11 80       	push   $0x801109c0
8010138a:	ff 75 08             	pushl  0x8(%ebp)
8010138d:	e8 fb fe ff ff       	call   8010128d <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101392:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101398:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010139e:	ff 35 d0 09 11 80    	pushl  0x801109d0
801013a4:	ff 35 cc 09 11 80    	pushl  0x801109cc
801013aa:	ff 35 c8 09 11 80    	pushl  0x801109c8
801013b0:	ff 35 c4 09 11 80    	pushl  0x801109c4
801013b6:	ff 35 c0 09 11 80    	pushl  0x801109c0
801013bc:	68 f8 69 10 80       	push   $0x801069f8
801013c1:	e8 1b f2 ff ff       	call   801005e1 <cprintf>
}
801013c6:	83 c4 30             	add    $0x30,%esp
801013c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013cc:	5b                   	pop    %ebx
801013cd:	5e                   	pop    %esi
801013ce:	5d                   	pop    %ebp
801013cf:	c3                   	ret    

801013d0 <ialloc>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	56                   	push   %esi
801013d5:	53                   	push   %ebx
801013d6:	83 ec 1c             	sub    $0x1c,%esp
801013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801013dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013df:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
801013e6:	76 4d                	jbe    80101435 <ialloc+0x65>
801013e8:	bb 01 00 00 00       	mov    $0x1,%ebx
801013ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
801013f0:	83 ec 08             	sub    $0x8,%esp
801013f3:	89 d8                	mov    %ebx,%eax
801013f5:	c1 e8 03             	shr    $0x3,%eax
801013f8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013fe:	50                   	push   %eax
801013ff:	ff 75 08             	pushl  0x8(%ebp)
80101402:	e8 a3 ec ff ff       	call   801000aa <bread>
80101407:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101409:	89 d8                	mov    %ebx,%eax
8010140b:	83 e0 07             	and    $0x7,%eax
8010140e:	c1 e0 06             	shl    $0x6,%eax
80101411:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101415:	83 c4 10             	add    $0x10,%esp
80101418:	66 83 3f 00          	cmpw   $0x0,(%edi)
8010141c:	74 24                	je     80101442 <ialloc+0x72>
    brelse(bp);
8010141e:	83 ec 0c             	sub    $0xc,%esp
80101421:	56                   	push   %esi
80101422:	e8 9a ed ff ff       	call   801001c1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101427:	83 c3 01             	add    $0x1,%ebx
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101433:	77 b8                	ja     801013ed <ialloc+0x1d>
  panic("ialloc: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 98 69 10 80       	push   $0x80106998
8010143d:	e8 02 ef ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
80101442:	83 ec 04             	sub    $0x4,%esp
80101445:	6a 40                	push   $0x40
80101447:	6a 00                	push   $0x0
80101449:	57                   	push   %edi
8010144a:	e8 f9 29 00 00       	call   80103e48 <memset>
      dip->type = type;
8010144f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80101453:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101456:	89 34 24             	mov    %esi,(%esp)
80101459:	e8 4c 15 00 00       	call   801029aa <log_write>
      brelse(bp);
8010145e:	89 34 24             	mov    %esi,(%esp)
80101461:	e8 5b ed ff ff       	call   801001c1 <brelse>
      return iget(dev, inum);
80101466:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101469:	8b 45 08             	mov    0x8(%ebp),%eax
8010146c:	e8 6b fd ff ff       	call   801011dc <iget>
}
80101471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    

80101479 <iupdate>:
{
80101479:	55                   	push   %ebp
8010147a:	89 e5                	mov    %esp,%ebp
8010147c:	56                   	push   %esi
8010147d:	53                   	push   %ebx
8010147e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101481:	83 ec 08             	sub    $0x8,%esp
80101484:	8b 43 04             	mov    0x4(%ebx),%eax
80101487:	c1 e8 03             	shr    $0x3,%eax
8010148a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101490:	50                   	push   %eax
80101491:	ff 33                	pushl  (%ebx)
80101493:	e8 12 ec ff ff       	call   801000aa <bread>
80101498:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010149a:	8b 43 04             	mov    0x4(%ebx),%eax
8010149d:	83 e0 07             	and    $0x7,%eax
801014a0:	c1 e0 06             	shl    $0x6,%eax
801014a3:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801014a7:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
801014ab:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014ae:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
801014b2:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014b6:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801014ba:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014be:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801014c2:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014c6:	8b 53 58             	mov    0x58(%ebx),%edx
801014c9:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014cc:	83 c4 0c             	add    $0xc,%esp
801014cf:	6a 34                	push   $0x34
801014d1:	83 c3 5c             	add    $0x5c,%ebx
801014d4:	53                   	push   %ebx
801014d5:	83 c0 0c             	add    $0xc,%eax
801014d8:	50                   	push   %eax
801014d9:	e8 ff 29 00 00       	call   80103edd <memmove>
  log_write(bp);
801014de:	89 34 24             	mov    %esi,(%esp)
801014e1:	e8 c4 14 00 00       	call   801029aa <log_write>
  brelse(bp);
801014e6:	89 34 24             	mov    %esi,(%esp)
801014e9:	e8 d3 ec ff ff       	call   801001c1 <brelse>
}
801014ee:	83 c4 10             	add    $0x10,%esp
801014f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014f4:	5b                   	pop    %ebx
801014f5:	5e                   	pop    %esi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    

801014f8 <idup>:
{
801014f8:	55                   	push   %ebp
801014f9:	89 e5                	mov    %esp,%ebp
801014fb:	53                   	push   %ebx
801014fc:	83 ec 10             	sub    $0x10,%esp
801014ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101502:	68 e0 09 11 80       	push   $0x801109e0
80101507:	e8 8e 28 00 00       	call   80103d9a <acquire>
  ip->ref++;
8010150c:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101510:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101517:	e8 e5 28 00 00       	call   80103e01 <release>
}
8010151c:	89 d8                	mov    %ebx,%eax
8010151e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101521:	c9                   	leave  
80101522:	c3                   	ret    

80101523 <ilock>:
{
80101523:	55                   	push   %ebp
80101524:	89 e5                	mov    %esp,%ebp
80101526:	56                   	push   %esi
80101527:	53                   	push   %ebx
80101528:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010152b:	85 db                	test   %ebx,%ebx
8010152d:	74 22                	je     80101551 <ilock+0x2e>
8010152f:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101533:	7e 1c                	jle    80101551 <ilock+0x2e>
  acquiresleep(&ip->lock);
80101535:	83 ec 0c             	sub    $0xc,%esp
80101538:	8d 43 0c             	lea    0xc(%ebx),%eax
8010153b:	50                   	push   %eax
8010153c:	e8 3a 26 00 00       	call   80103b7b <acquiresleep>
  if(ip->valid == 0){
80101541:	83 c4 10             	add    $0x10,%esp
80101544:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101548:	74 14                	je     8010155e <ilock+0x3b>
}
8010154a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154d:	5b                   	pop    %ebx
8010154e:	5e                   	pop    %esi
8010154f:	5d                   	pop    %ebp
80101550:	c3                   	ret    
    panic("ilock");
80101551:	83 ec 0c             	sub    $0xc,%esp
80101554:	68 aa 69 10 80       	push   $0x801069aa
80101559:	e8 e6 ed ff ff       	call   80100344 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010155e:	83 ec 08             	sub    $0x8,%esp
80101561:	8b 43 04             	mov    0x4(%ebx),%eax
80101564:	c1 e8 03             	shr    $0x3,%eax
80101567:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010156d:	50                   	push   %eax
8010156e:	ff 33                	pushl  (%ebx)
80101570:	e8 35 eb ff ff       	call   801000aa <bread>
80101575:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101577:	8b 43 04             	mov    0x4(%ebx),%eax
8010157a:	83 e0 07             	and    $0x7,%eax
8010157d:	c1 e0 06             	shl    $0x6,%eax
80101580:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101584:	0f b7 10             	movzwl (%eax),%edx
80101587:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010158b:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010158f:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101593:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101597:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010159b:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010159f:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015a3:	8b 50 08             	mov    0x8(%eax),%edx
801015a6:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015a9:	83 c4 0c             	add    $0xc,%esp
801015ac:	6a 34                	push   $0x34
801015ae:	83 c0 0c             	add    $0xc,%eax
801015b1:	50                   	push   %eax
801015b2:	8d 43 5c             	lea    0x5c(%ebx),%eax
801015b5:	50                   	push   %eax
801015b6:	e8 22 29 00 00       	call   80103edd <memmove>
    brelse(bp);
801015bb:	89 34 24             	mov    %esi,(%esp)
801015be:	e8 fe eb ff ff       	call   801001c1 <brelse>
    ip->valid = 1;
801015c3:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015ca:	83 c4 10             	add    $0x10,%esp
801015cd:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015d2:	0f 85 72 ff ff ff    	jne    8010154a <ilock+0x27>
      panic("ilock: no type");
801015d8:	83 ec 0c             	sub    $0xc,%esp
801015db:	68 b0 69 10 80       	push   $0x801069b0
801015e0:	e8 5f ed ff ff       	call   80100344 <panic>

801015e5 <iunlock>:
{
801015e5:	55                   	push   %ebp
801015e6:	89 e5                	mov    %esp,%ebp
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015ed:	85 db                	test   %ebx,%ebx
801015ef:	74 2c                	je     8010161d <iunlock+0x38>
801015f1:	8d 73 0c             	lea    0xc(%ebx),%esi
801015f4:	83 ec 0c             	sub    $0xc,%esp
801015f7:	56                   	push   %esi
801015f8:	e8 0b 26 00 00       	call   80103c08 <holdingsleep>
801015fd:	83 c4 10             	add    $0x10,%esp
80101600:	85 c0                	test   %eax,%eax
80101602:	74 19                	je     8010161d <iunlock+0x38>
80101604:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101608:	7e 13                	jle    8010161d <iunlock+0x38>
  releasesleep(&ip->lock);
8010160a:	83 ec 0c             	sub    $0xc,%esp
8010160d:	56                   	push   %esi
8010160e:	e8 ba 25 00 00       	call   80103bcd <releasesleep>
}
80101613:	83 c4 10             	add    $0x10,%esp
80101616:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101619:	5b                   	pop    %ebx
8010161a:	5e                   	pop    %esi
8010161b:	5d                   	pop    %ebp
8010161c:	c3                   	ret    
    panic("iunlock");
8010161d:	83 ec 0c             	sub    $0xc,%esp
80101620:	68 bf 69 10 80       	push   $0x801069bf
80101625:	e8 1a ed ff ff       	call   80100344 <panic>

8010162a <iput>:
{
8010162a:	55                   	push   %ebp
8010162b:	89 e5                	mov    %esp,%ebp
8010162d:	57                   	push   %edi
8010162e:	56                   	push   %esi
8010162f:	53                   	push   %ebx
80101630:	83 ec 28             	sub    $0x28,%esp
80101633:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101636:	8d 73 0c             	lea    0xc(%ebx),%esi
80101639:	56                   	push   %esi
8010163a:	e8 3c 25 00 00       	call   80103b7b <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010163f:	83 c4 10             	add    $0x10,%esp
80101642:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101646:	74 07                	je     8010164f <iput+0x25>
80101648:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010164d:	74 30                	je     8010167f <iput+0x55>
  releasesleep(&ip->lock);
8010164f:	83 ec 0c             	sub    $0xc,%esp
80101652:	56                   	push   %esi
80101653:	e8 75 25 00 00       	call   80103bcd <releasesleep>
  acquire(&icache.lock);
80101658:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010165f:	e8 36 27 00 00       	call   80103d9a <acquire>
  ip->ref--;
80101664:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 8d 27 00 00       	call   80103e01 <release>
}
80101674:	83 c4 10             	add    $0x10,%esp
80101677:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010167a:	5b                   	pop    %ebx
8010167b:	5e                   	pop    %esi
8010167c:	5f                   	pop    %edi
8010167d:	5d                   	pop    %ebp
8010167e:	c3                   	ret    
    acquire(&icache.lock);
8010167f:	83 ec 0c             	sub    $0xc,%esp
80101682:	68 e0 09 11 80       	push   $0x801109e0
80101687:	e8 0e 27 00 00       	call   80103d9a <acquire>
    int r = ip->ref;
8010168c:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
8010168f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101696:	e8 66 27 00 00       	call   80103e01 <release>
    if(r == 1){
8010169b:	83 c4 10             	add    $0x10,%esp
8010169e:	83 ff 01             	cmp    $0x1,%edi
801016a1:	75 ac                	jne    8010164f <iput+0x25>
801016a3:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801016a6:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801016ac:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801016af:	89 c6                	mov    %eax,%esi
801016b1:	eb 07                	jmp    801016ba <iput+0x90>
801016b3:	83 c7 04             	add    $0x4,%edi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801016b6:	39 f7                	cmp    %esi,%edi
801016b8:	74 15                	je     801016cf <iput+0xa5>
    if(ip->addrs[i]){
801016ba:	8b 17                	mov    (%edi),%edx
801016bc:	85 d2                	test   %edx,%edx
801016be:	74 f3                	je     801016b3 <iput+0x89>
      bfree(ip->dev, ip->addrs[i]);
801016c0:	8b 03                	mov    (%ebx),%eax
801016c2:	e8 fa fb ff ff       	call   801012c1 <bfree>
      ip->addrs[i] = 0;
801016c7:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801016cd:	eb e4                	jmp    801016b3 <iput+0x89>
801016cf:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801016d2:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801016d8:	85 c0                	test   %eax,%eax
801016da:	75 2d                	jne    80101709 <iput+0xdf>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801016dc:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801016e3:	83 ec 0c             	sub    $0xc,%esp
801016e6:	53                   	push   %ebx
801016e7:	e8 8d fd ff ff       	call   80101479 <iupdate>
      ip->type = 0;
801016ec:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801016f2:	89 1c 24             	mov    %ebx,(%esp)
801016f5:	e8 7f fd ff ff       	call   80101479 <iupdate>
      ip->valid = 0;
801016fa:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101701:	83 c4 10             	add    $0x10,%esp
80101704:	e9 46 ff ff ff       	jmp    8010164f <iput+0x25>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101709:	83 ec 08             	sub    $0x8,%esp
8010170c:	50                   	push   %eax
8010170d:	ff 33                	pushl  (%ebx)
8010170f:	e8 96 e9 ff ff       	call   801000aa <bread>
80101714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101717:	8d 78 5c             	lea    0x5c(%eax),%edi
8010171a:	05 5c 02 00 00       	add    $0x25c,%eax
8010171f:	83 c4 10             	add    $0x10,%esp
80101722:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101725:	89 c6                	mov    %eax,%esi
80101727:	eb 07                	jmp    80101730 <iput+0x106>
80101729:	83 c7 04             	add    $0x4,%edi
    for(j = 0; j < NINDIRECT; j++){
8010172c:	39 fe                	cmp    %edi,%esi
8010172e:	74 0f                	je     8010173f <iput+0x115>
      if(a[j])
80101730:	8b 17                	mov    (%edi),%edx
80101732:	85 d2                	test   %edx,%edx
80101734:	74 f3                	je     80101729 <iput+0xff>
        bfree(ip->dev, a[j]);
80101736:	8b 03                	mov    (%ebx),%eax
80101738:	e8 84 fb ff ff       	call   801012c1 <bfree>
8010173d:	eb ea                	jmp    80101729 <iput+0xff>
8010173f:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
80101742:	83 ec 0c             	sub    $0xc,%esp
80101745:	ff 75 e4             	pushl  -0x1c(%ebp)
80101748:	e8 74 ea ff ff       	call   801001c1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010174d:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101753:	8b 03                	mov    (%ebx),%eax
80101755:	e8 67 fb ff ff       	call   801012c1 <bfree>
    ip->addrs[NDIRECT] = 0;
8010175a:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101761:	00 00 00 
80101764:	83 c4 10             	add    $0x10,%esp
80101767:	e9 70 ff ff ff       	jmp    801016dc <iput+0xb2>

8010176c <iunlockput>:
{
8010176c:	55                   	push   %ebp
8010176d:	89 e5                	mov    %esp,%ebp
8010176f:	53                   	push   %ebx
80101770:	83 ec 10             	sub    $0x10,%esp
80101773:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101776:	53                   	push   %ebx
80101777:	e8 69 fe ff ff       	call   801015e5 <iunlock>
  iput(ip);
8010177c:	89 1c 24             	mov    %ebx,(%esp)
8010177f:	e8 a6 fe ff ff       	call   8010162a <iput>
}
80101784:	83 c4 10             	add    $0x10,%esp
80101787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010178a:	c9                   	leave  
8010178b:	c3                   	ret    

8010178c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
8010178c:	55                   	push   %ebp
8010178d:	89 e5                	mov    %esp,%ebp
8010178f:	8b 55 08             	mov    0x8(%ebp),%edx
80101792:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101795:	8b 0a                	mov    (%edx),%ecx
80101797:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010179a:	8b 4a 04             	mov    0x4(%edx),%ecx
8010179d:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017a0:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017a4:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017a7:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801017ab:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017af:	8b 52 58             	mov    0x58(%edx),%edx
801017b2:	89 50 10             	mov    %edx,0x10(%eax)
}
801017b5:	5d                   	pop    %ebp
801017b6:	c3                   	ret    

801017b7 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801017b7:	55                   	push   %ebp
801017b8:	89 e5                	mov    %esp,%ebp
801017ba:	57                   	push   %edi
801017bb:	56                   	push   %esi
801017bc:	53                   	push   %ebx
801017bd:	83 ec 1c             	sub    $0x1c,%esp
801017c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801017c3:	8b 45 08             	mov    0x8(%ebp),%eax
801017c6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017cb:	0f 84 9d 00 00 00    	je     8010186e <readi+0xb7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801017d1:	8b 45 08             	mov    0x8(%ebp),%eax
801017d4:	8b 40 58             	mov    0x58(%eax),%eax
801017d7:	39 f8                	cmp    %edi,%eax
801017d9:	0f 82 c6 00 00 00    	jb     801018a5 <readi+0xee>
801017df:	89 fa                	mov    %edi,%edx
801017e1:	03 55 14             	add    0x14(%ebp),%edx
801017e4:	0f 82 c2 00 00 00    	jb     801018ac <readi+0xf5>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801017ea:	89 c1                	mov    %eax,%ecx
801017ec:	29 f9                	sub    %edi,%ecx
801017ee:	39 d0                	cmp    %edx,%eax
801017f0:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
801017f4:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017f7:	85 c9                	test   %ecx,%ecx
801017f9:	74 68                	je     80101863 <readi+0xac>
801017fb:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101800:	89 fa                	mov    %edi,%edx
80101802:	c1 ea 09             	shr    $0x9,%edx
80101805:	8b 45 08             	mov    0x8(%ebp),%eax
80101808:	e8 2a f9 ff ff       	call   80101137 <bmap>
8010180d:	83 ec 08             	sub    $0x8,%esp
80101810:	50                   	push   %eax
80101811:	8b 45 08             	mov    0x8(%ebp),%eax
80101814:	ff 30                	pushl  (%eax)
80101816:	e8 8f e8 ff ff       	call   801000aa <bread>
8010181b:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010181d:	89 f8                	mov    %edi,%eax
8010181f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101824:	bb 00 02 00 00       	mov    $0x200,%ebx
80101829:	29 c3                	sub    %eax,%ebx
8010182b:	8b 55 14             	mov    0x14(%ebp),%edx
8010182e:	29 f2                	sub    %esi,%edx
80101830:	83 c4 0c             	add    $0xc,%esp
80101833:	39 d3                	cmp    %edx,%ebx
80101835:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101838:	53                   	push   %ebx
80101839:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010183c:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101840:	50                   	push   %eax
80101841:	ff 75 0c             	pushl  0xc(%ebp)
80101844:	e8 94 26 00 00       	call   80103edd <memmove>
    brelse(bp);
80101849:	83 c4 04             	add    $0x4,%esp
8010184c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010184f:	e8 6d e9 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101854:	01 de                	add    %ebx,%esi
80101856:	01 df                	add    %ebx,%edi
80101858:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010185b:	83 c4 10             	add    $0x10,%esp
8010185e:	39 75 14             	cmp    %esi,0x14(%ebp)
80101861:	77 9d                	ja     80101800 <readi+0x49>
  }
  return n;
80101863:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101866:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101869:	5b                   	pop    %ebx
8010186a:	5e                   	pop    %esi
8010186b:	5f                   	pop    %edi
8010186c:	5d                   	pop    %ebp
8010186d:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010186e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101872:	66 83 f8 09          	cmp    $0x9,%ax
80101876:	77 1f                	ja     80101897 <readi+0xe0>
80101878:	98                   	cwtl   
80101879:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101880:	85 c0                	test   %eax,%eax
80101882:	74 1a                	je     8010189e <readi+0xe7>
    return devsw[ip->major].read(ip, dst, n);
80101884:	83 ec 04             	sub    $0x4,%esp
80101887:	ff 75 14             	pushl  0x14(%ebp)
8010188a:	ff 75 0c             	pushl  0xc(%ebp)
8010188d:	ff 75 08             	pushl  0x8(%ebp)
80101890:	ff d0                	call   *%eax
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	eb cf                	jmp    80101866 <readi+0xaf>
      return -1;
80101897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010189c:	eb c8                	jmp    80101866 <readi+0xaf>
8010189e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018a3:	eb c1                	jmp    80101866 <readi+0xaf>
    return -1;
801018a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018aa:	eb ba                	jmp    80101866 <readi+0xaf>
801018ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018b1:	eb b3                	jmp    80101866 <readi+0xaf>

801018b3 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801018b3:	55                   	push   %ebp
801018b4:	89 e5                	mov    %esp,%ebp
801018b6:	57                   	push   %edi
801018b7:	56                   	push   %esi
801018b8:	53                   	push   %ebx
801018b9:	83 ec 1c             	sub    $0x1c,%esp
801018bc:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801018bf:	8b 45 08             	mov    0x8(%ebp),%eax
801018c2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018c7:	0f 84 ae 00 00 00    	je     8010197b <writei+0xc8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801018cd:	8b 45 08             	mov    0x8(%ebp),%eax
801018d0:	39 70 58             	cmp    %esi,0x58(%eax)
801018d3:	0f 82 ed 00 00 00    	jb     801019c6 <writei+0x113>
801018d9:	89 f0                	mov    %esi,%eax
801018db:	03 45 14             	add    0x14(%ebp),%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
801018de:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018e3:	0f 87 e4 00 00 00    	ja     801019cd <writei+0x11a>
801018e9:	39 f0                	cmp    %esi,%eax
801018eb:	0f 82 dc 00 00 00    	jb     801019cd <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018f1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018f5:	74 79                	je     80101970 <writei+0xbd>
801018f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018fe:	89 f2                	mov    %esi,%edx
80101900:	c1 ea 09             	shr    $0x9,%edx
80101903:	8b 45 08             	mov    0x8(%ebp),%eax
80101906:	e8 2c f8 ff ff       	call   80101137 <bmap>
8010190b:	83 ec 08             	sub    $0x8,%esp
8010190e:	50                   	push   %eax
8010190f:	8b 45 08             	mov    0x8(%ebp),%eax
80101912:	ff 30                	pushl  (%eax)
80101914:	e8 91 e7 ff ff       	call   801000aa <bread>
80101919:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
8010191b:	89 f0                	mov    %esi,%eax
8010191d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101922:	bb 00 02 00 00       	mov    $0x200,%ebx
80101927:	29 c3                	sub    %eax,%ebx
80101929:	8b 55 14             	mov    0x14(%ebp),%edx
8010192c:	2b 55 e4             	sub    -0x1c(%ebp),%edx
8010192f:	83 c4 0c             	add    $0xc,%esp
80101932:	39 d3                	cmp    %edx,%ebx
80101934:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101937:	53                   	push   %ebx
80101938:	ff 75 0c             	pushl  0xc(%ebp)
8010193b:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
8010193f:	50                   	push   %eax
80101940:	e8 98 25 00 00       	call   80103edd <memmove>
    log_write(bp);
80101945:	89 3c 24             	mov    %edi,(%esp)
80101948:	e8 5d 10 00 00       	call   801029aa <log_write>
    brelse(bp);
8010194d:	89 3c 24             	mov    %edi,(%esp)
80101950:	e8 6c e8 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101955:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101958:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010195b:	01 de                	add    %ebx,%esi
8010195d:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101960:	83 c4 10             	add    $0x10,%esp
80101963:	39 4d 14             	cmp    %ecx,0x14(%ebp)
80101966:	77 96                	ja     801018fe <writei+0x4b>
  }

  if(n > 0 && off > ip->size){
80101968:	8b 45 08             	mov    0x8(%ebp),%eax
8010196b:	39 70 58             	cmp    %esi,0x58(%eax)
8010196e:	72 34                	jb     801019a4 <writei+0xf1>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101970:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101973:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101976:	5b                   	pop    %ebx
80101977:	5e                   	pop    %esi
80101978:	5f                   	pop    %edi
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010197b:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010197f:	66 83 f8 09          	cmp    $0x9,%ax
80101983:	77 33                	ja     801019b8 <writei+0x105>
80101985:	98                   	cwtl   
80101986:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
8010198d:	85 c0                	test   %eax,%eax
8010198f:	74 2e                	je     801019bf <writei+0x10c>
    return devsw[ip->major].write(ip, src, n);
80101991:	83 ec 04             	sub    $0x4,%esp
80101994:	ff 75 14             	pushl  0x14(%ebp)
80101997:	ff 75 0c             	pushl  0xc(%ebp)
8010199a:	ff 75 08             	pushl  0x8(%ebp)
8010199d:	ff d0                	call   *%eax
8010199f:	83 c4 10             	add    $0x10,%esp
801019a2:	eb cf                	jmp    80101973 <writei+0xc0>
    ip->size = off;
801019a4:	8b 45 08             	mov    0x8(%ebp),%eax
801019a7:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801019aa:	83 ec 0c             	sub    $0xc,%esp
801019ad:	50                   	push   %eax
801019ae:	e8 c6 fa ff ff       	call   80101479 <iupdate>
801019b3:	83 c4 10             	add    $0x10,%esp
801019b6:	eb b8                	jmp    80101970 <writei+0xbd>
      return -1;
801019b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019bd:	eb b4                	jmp    80101973 <writei+0xc0>
801019bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019c4:	eb ad                	jmp    80101973 <writei+0xc0>
    return -1;
801019c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019cb:	eb a6                	jmp    80101973 <writei+0xc0>
    return -1;
801019cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019d2:	eb 9f                	jmp    80101973 <writei+0xc0>

801019d4 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801019d4:	55                   	push   %ebp
801019d5:	89 e5                	mov    %esp,%ebp
801019d7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019da:	6a 0e                	push   $0xe
801019dc:	ff 75 0c             	pushl  0xc(%ebp)
801019df:	ff 75 08             	pushl  0x8(%ebp)
801019e2:	e8 55 25 00 00       	call   80103f3c <strncmp>
}
801019e7:	c9                   	leave  
801019e8:	c3                   	ret    

801019e9 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801019e9:	55                   	push   %ebp
801019ea:	89 e5                	mov    %esp,%ebp
801019ec:	57                   	push   %edi
801019ed:	56                   	push   %esi
801019ee:	53                   	push   %ebx
801019ef:	83 ec 1c             	sub    $0x1c,%esp
801019f2:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801019f5:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019fa:	75 15                	jne    80101a11 <dirlookup+0x28>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019fc:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a01:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101a04:	b8 00 00 00 00       	mov    $0x0,%eax
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a09:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
80101a0d:	75 24                	jne    80101a33 <dirlookup+0x4a>
80101a0f:	eb 6e                	jmp    80101a7f <dirlookup+0x96>
    panic("dirlookup not DIR");
80101a11:	83 ec 0c             	sub    $0xc,%esp
80101a14:	68 c7 69 10 80       	push   $0x801069c7
80101a19:	e8 26 e9 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
80101a1e:	83 ec 0c             	sub    $0xc,%esp
80101a21:	68 d9 69 10 80       	push   $0x801069d9
80101a26:	e8 19 e9 ff ff       	call   80100344 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a2b:	83 c3 10             	add    $0x10,%ebx
80101a2e:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a31:	76 47                	jbe    80101a7a <dirlookup+0x91>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a33:	6a 10                	push   $0x10
80101a35:	53                   	push   %ebx
80101a36:	57                   	push   %edi
80101a37:	56                   	push   %esi
80101a38:	e8 7a fd ff ff       	call   801017b7 <readi>
80101a3d:	83 c4 10             	add    $0x10,%esp
80101a40:	83 f8 10             	cmp    $0x10,%eax
80101a43:	75 d9                	jne    80101a1e <dirlookup+0x35>
    if(de.inum == 0)
80101a45:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a4a:	74 df                	je     80101a2b <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
80101a4c:	83 ec 08             	sub    $0x8,%esp
80101a4f:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a52:	50                   	push   %eax
80101a53:	ff 75 0c             	pushl  0xc(%ebp)
80101a56:	e8 79 ff ff ff       	call   801019d4 <namecmp>
80101a5b:	83 c4 10             	add    $0x10,%esp
80101a5e:	85 c0                	test   %eax,%eax
80101a60:	75 c9                	jne    80101a2b <dirlookup+0x42>
      if(poff)
80101a62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a66:	74 05                	je     80101a6d <dirlookup+0x84>
        *poff = off;
80101a68:	8b 45 10             	mov    0x10(%ebp),%eax
80101a6b:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a6d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a71:	8b 06                	mov    (%esi),%eax
80101a73:	e8 64 f7 ff ff       	call   801011dc <iget>
80101a78:	eb 05                	jmp    80101a7f <dirlookup+0x96>
  return 0;
80101a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a82:	5b                   	pop    %ebx
80101a83:	5e                   	pop    %esi
80101a84:	5f                   	pop    %edi
80101a85:	5d                   	pop    %ebp
80101a86:	c3                   	ret    

80101a87 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a87:	55                   	push   %ebp
80101a88:	89 e5                	mov    %esp,%ebp
80101a8a:	57                   	push   %edi
80101a8b:	56                   	push   %esi
80101a8c:	53                   	push   %ebx
80101a8d:	83 ec 1c             	sub    $0x1c,%esp
80101a90:	89 c6                	mov    %eax,%esi
80101a92:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a95:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a98:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a9b:	74 1a                	je     80101ab7 <namex+0x30>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a9d:	e8 d4 18 00 00       	call   80103376 <myproc>
80101aa2:	83 ec 0c             	sub    $0xc,%esp
80101aa5:	ff 70 68             	pushl  0x68(%eax)
80101aa8:	e8 4b fa ff ff       	call   801014f8 <idup>
80101aad:	89 c7                	mov    %eax,%edi
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	e9 d4 00 00 00       	jmp    80101b8b <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
80101ab7:	ba 01 00 00 00       	mov    $0x1,%edx
80101abc:	b8 01 00 00 00       	mov    $0x1,%eax
80101ac1:	e8 16 f7 ff ff       	call   801011dc <iget>
80101ac6:	89 c7                	mov    %eax,%edi
80101ac8:	e9 be 00 00 00       	jmp    80101b8b <namex+0x104>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101acd:	83 ec 0c             	sub    $0xc,%esp
80101ad0:	57                   	push   %edi
80101ad1:	e8 96 fc ff ff       	call   8010176c <iunlockput>
      return 0;
80101ad6:	83 c4 10             	add    $0x10,%esp
80101ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ade:	89 f8                	mov    %edi,%eax
80101ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae3:	5b                   	pop    %ebx
80101ae4:	5e                   	pop    %esi
80101ae5:	5f                   	pop    %edi
80101ae6:	5d                   	pop    %ebp
80101ae7:	c3                   	ret    
      iunlock(ip);
80101ae8:	83 ec 0c             	sub    $0xc,%esp
80101aeb:	57                   	push   %edi
80101aec:	e8 f4 fa ff ff       	call   801015e5 <iunlock>
      return ip;
80101af1:	83 c4 10             	add    $0x10,%esp
80101af4:	eb e8                	jmp    80101ade <namex+0x57>
      iunlockput(ip);
80101af6:	83 ec 0c             	sub    $0xc,%esp
80101af9:	57                   	push   %edi
80101afa:	e8 6d fc ff ff       	call   8010176c <iunlockput>
      return 0;
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	89 f7                	mov    %esi,%edi
80101b04:	eb d8                	jmp    80101ade <namex+0x57>
  while(*path != '/' && *path != 0)
80101b06:	89 f3                	mov    %esi,%ebx
  len = path - s;
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	29 f0                	sub    %esi,%eax
80101b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101b0f:	83 f8 0d             	cmp    $0xd,%eax
80101b12:	0f 8e b4 00 00 00    	jle    80101bcc <namex+0x145>
    memmove(name, s, DIRSIZ);
80101b18:	83 ec 04             	sub    $0x4,%esp
80101b1b:	6a 0e                	push   $0xe
80101b1d:	56                   	push   %esi
80101b1e:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b21:	e8 b7 23 00 00       	call   80103edd <memmove>
80101b26:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101b29:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b2c:	75 08                	jne    80101b36 <namex+0xaf>
    path++;
80101b2e:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101b31:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b34:	74 f8                	je     80101b2e <namex+0xa7>
  while((path = skipelem(path, name)) != 0){
80101b36:	85 db                	test   %ebx,%ebx
80101b38:	0f 84 ad 00 00 00    	je     80101beb <namex+0x164>
    ilock(ip);
80101b3e:	83 ec 0c             	sub    $0xc,%esp
80101b41:	57                   	push   %edi
80101b42:	e8 dc f9 ff ff       	call   80101523 <ilock>
    if(ip->type != T_DIR){
80101b47:	83 c4 10             	add    $0x10,%esp
80101b4a:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101b4f:	0f 85 78 ff ff ff    	jne    80101acd <namex+0x46>
    if(nameiparent && *path == '\0'){
80101b55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101b59:	74 05                	je     80101b60 <namex+0xd9>
80101b5b:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b5e:	74 88                	je     80101ae8 <namex+0x61>
    if((next = dirlookup(ip, name, 0)) == 0){
80101b60:	83 ec 04             	sub    $0x4,%esp
80101b63:	6a 00                	push   $0x0
80101b65:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b68:	57                   	push   %edi
80101b69:	e8 7b fe ff ff       	call   801019e9 <dirlookup>
80101b6e:	89 c6                	mov    %eax,%esi
80101b70:	83 c4 10             	add    $0x10,%esp
80101b73:	85 c0                	test   %eax,%eax
80101b75:	0f 84 7b ff ff ff    	je     80101af6 <namex+0x6f>
    iunlockput(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	57                   	push   %edi
80101b7f:	e8 e8 fb ff ff       	call   8010176c <iunlockput>
    ip = next;
80101b84:	83 c4 10             	add    $0x10,%esp
80101b87:	89 f7                	mov    %esi,%edi
80101b89:	89 de                	mov    %ebx,%esi
  while(*path == '/')
80101b8b:	0f b6 06             	movzbl (%esi),%eax
80101b8e:	3c 2f                	cmp    $0x2f,%al
80101b90:	75 0a                	jne    80101b9c <namex+0x115>
    path++;
80101b92:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
80101b95:	0f b6 06             	movzbl (%esi),%eax
80101b98:	3c 2f                	cmp    $0x2f,%al
80101b9a:	74 f6                	je     80101b92 <namex+0x10b>
  if(*path == 0)
80101b9c:	84 c0                	test   %al,%al
80101b9e:	74 4b                	je     80101beb <namex+0x164>
  while(*path != '/' && *path != 0)
80101ba0:	0f b6 06             	movzbl (%esi),%eax
80101ba3:	3c 2f                	cmp    $0x2f,%al
80101ba5:	0f 84 5b ff ff ff    	je     80101b06 <namex+0x7f>
80101bab:	84 c0                	test   %al,%al
80101bad:	0f 84 53 ff ff ff    	je     80101b06 <namex+0x7f>
80101bb3:	89 f3                	mov    %esi,%ebx
    path++;
80101bb5:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101bb8:	0f b6 03             	movzbl (%ebx),%eax
80101bbb:	3c 2f                	cmp    $0x2f,%al
80101bbd:	0f 84 45 ff ff ff    	je     80101b08 <namex+0x81>
80101bc3:	84 c0                	test   %al,%al
80101bc5:	75 ee                	jne    80101bb5 <namex+0x12e>
80101bc7:	e9 3c ff ff ff       	jmp    80101b08 <namex+0x81>
    memmove(name, s, len);
80101bcc:	83 ec 04             	sub    $0x4,%esp
80101bcf:	ff 75 e0             	pushl  -0x20(%ebp)
80101bd2:	56                   	push   %esi
80101bd3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101bd6:	56                   	push   %esi
80101bd7:	e8 01 23 00 00       	call   80103edd <memmove>
    name[len] = 0;
80101bdc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101bdf:	c6 04 0e 00          	movb   $0x0,(%esi,%ecx,1)
80101be3:	83 c4 10             	add    $0x10,%esp
80101be6:	e9 3e ff ff ff       	jmp    80101b29 <namex+0xa2>
  if(nameiparent){
80101beb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101bef:	0f 84 e9 fe ff ff    	je     80101ade <namex+0x57>
    iput(ip);
80101bf5:	83 ec 0c             	sub    $0xc,%esp
80101bf8:	57                   	push   %edi
80101bf9:	e8 2c fa ff ff       	call   8010162a <iput>
    return 0;
80101bfe:	83 c4 10             	add    $0x10,%esp
80101c01:	bf 00 00 00 00       	mov    $0x0,%edi
80101c06:	e9 d3 fe ff ff       	jmp    80101ade <namex+0x57>

80101c0b <dirlink>:
{
80101c0b:	55                   	push   %ebp
80101c0c:	89 e5                	mov    %esp,%ebp
80101c0e:	57                   	push   %edi
80101c0f:	56                   	push   %esi
80101c10:	53                   	push   %ebx
80101c11:	83 ec 20             	sub    $0x20,%esp
80101c14:	8b 75 08             	mov    0x8(%ebp),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c17:	6a 00                	push   $0x0
80101c19:	ff 75 0c             	pushl  0xc(%ebp)
80101c1c:	56                   	push   %esi
80101c1d:	e8 c7 fd ff ff       	call   801019e9 <dirlookup>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	85 c0                	test   %eax,%eax
80101c27:	75 6a                	jne    80101c93 <dirlink+0x88>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c29:	8b 5e 58             	mov    0x58(%esi),%ebx
80101c2c:	85 db                	test   %ebx,%ebx
80101c2e:	74 29                	je     80101c59 <dirlink+0x4e>
80101c30:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c35:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c38:	6a 10                	push   $0x10
80101c3a:	53                   	push   %ebx
80101c3b:	57                   	push   %edi
80101c3c:	56                   	push   %esi
80101c3d:	e8 75 fb ff ff       	call   801017b7 <readi>
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	83 f8 10             	cmp    $0x10,%eax
80101c48:	75 5c                	jne    80101ca6 <dirlink+0x9b>
    if(de.inum == 0)
80101c4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c4f:	74 08                	je     80101c59 <dirlink+0x4e>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c51:	83 c3 10             	add    $0x10,%ebx
80101c54:	3b 5e 58             	cmp    0x58(%esi),%ebx
80101c57:	72 df                	jb     80101c38 <dirlink+0x2d>
  strncpy(de.name, name, DIRSIZ);
80101c59:	83 ec 04             	sub    $0x4,%esp
80101c5c:	6a 0e                	push   $0xe
80101c5e:	ff 75 0c             	pushl  0xc(%ebp)
80101c61:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c67:	50                   	push   %eax
80101c68:	e8 1b 23 00 00       	call   80103f88 <strncpy>
  de.inum = inum;
80101c6d:	8b 45 10             	mov    0x10(%ebp),%eax
80101c70:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c74:	6a 10                	push   $0x10
80101c76:	53                   	push   %ebx
80101c77:	57                   	push   %edi
80101c78:	56                   	push   %esi
80101c79:	e8 35 fc ff ff       	call   801018b3 <writei>
80101c7e:	83 c4 20             	add    $0x20,%esp
80101c81:	83 f8 10             	cmp    $0x10,%eax
80101c84:	75 2d                	jne    80101cb3 <dirlink+0xa8>
  return 0;
80101c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8e:	5b                   	pop    %ebx
80101c8f:	5e                   	pop    %esi
80101c90:	5f                   	pop    %edi
80101c91:	5d                   	pop    %ebp
80101c92:	c3                   	ret    
    iput(ip);
80101c93:	83 ec 0c             	sub    $0xc,%esp
80101c96:	50                   	push   %eax
80101c97:	e8 8e f9 ff ff       	call   8010162a <iput>
    return -1;
80101c9c:	83 c4 10             	add    $0x10,%esp
80101c9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ca4:	eb e5                	jmp    80101c8b <dirlink+0x80>
      panic("dirlink read");
80101ca6:	83 ec 0c             	sub    $0xc,%esp
80101ca9:	68 e8 69 10 80       	push   $0x801069e8
80101cae:	e8 91 e6 ff ff       	call   80100344 <panic>
    panic("dirlink");
80101cb3:	83 ec 0c             	sub    $0xc,%esp
80101cb6:	68 e6 6f 10 80       	push   $0x80106fe6
80101cbb:	e8 84 e6 ff ff       	call   80100344 <panic>

80101cc0 <namei>:

struct inode*
namei(char *path)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101cc6:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101cc9:	ba 00 00 00 00       	mov    $0x0,%edx
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	e8 b1 fd ff ff       	call   80101a87 <namex>
}
80101cd6:	c9                   	leave  
80101cd7:	c3                   	ret    

80101cd8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101cd8:	55                   	push   %ebp
80101cd9:	89 e5                	mov    %esp,%ebp
80101cdb:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ce1:	ba 01 00 00 00       	mov    $0x1,%edx
80101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce9:	e8 99 fd ff ff       	call   80101a87 <namex>
}
80101cee:	c9                   	leave  
80101cef:	c3                   	ret    

80101cf0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
  if(b == 0)
80101cf5:	85 c0                	test   %eax,%eax
80101cf7:	0f 84 84 00 00 00    	je     80101d81 <idestart+0x91>
80101cfd:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cff:	8b 58 08             	mov    0x8(%eax),%ebx
80101d02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101d08:	0f 87 80 00 00 00    	ja     80101d8e <idestart+0x9e>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d13:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d14:	83 e0 c0             	and    $0xffffffc0,%eax
80101d17:	3c 40                	cmp    $0x40,%al
80101d19:	75 f8                	jne    80101d13 <idestart+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d1b:	b8 00 00 00 00       	mov    $0x0,%eax
80101d20:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d25:	ee                   	out    %al,(%dx)
80101d26:	b8 01 00 00 00       	mov    $0x1,%eax
80101d2b:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d30:	ee                   	out    %al,(%dx)
80101d31:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d36:	89 d8                	mov    %ebx,%eax
80101d38:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d39:	89 d8                	mov    %ebx,%eax
80101d3b:	c1 f8 08             	sar    $0x8,%eax
80101d3e:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d43:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d44:	89 d8                	mov    %ebx,%eax
80101d46:	c1 f8 10             	sar    $0x10,%eax
80101d49:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d4e:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d4f:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d53:	c1 e0 04             	shl    $0x4,%eax
80101d56:	83 e0 10             	and    $0x10,%eax
80101d59:	83 c8 e0             	or     $0xffffffe0,%eax
80101d5c:	c1 fb 18             	sar    $0x18,%ebx
80101d5f:	83 e3 0f             	and    $0xf,%ebx
80101d62:	09 d8                	or     %ebx,%eax
80101d64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d69:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d6a:	f6 06 04             	testb  $0x4,(%esi)
80101d6d:	75 2c                	jne    80101d9b <idestart+0xab>
80101d6f:	b8 20 00 00 00       	mov    $0x20,%eax
80101d74:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d79:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d7d:	5b                   	pop    %ebx
80101d7e:	5e                   	pop    %esi
80101d7f:	5d                   	pop    %ebp
80101d80:	c3                   	ret    
    panic("idestart");
80101d81:	83 ec 0c             	sub    $0xc,%esp
80101d84:	68 4b 6a 10 80       	push   $0x80106a4b
80101d89:	e8 b6 e5 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	68 54 6a 10 80       	push   $0x80106a54
80101d96:	e8 a9 e5 ff ff       	call   80100344 <panic>
80101d9b:	b8 30 00 00 00       	mov    $0x30,%eax
80101da0:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101da5:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101da6:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101da9:	b9 80 00 00 00       	mov    $0x80,%ecx
80101dae:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101db3:	fc                   	cld    
80101db4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101db6:	eb c2                	jmp    80101d7a <idestart+0x8a>

80101db8 <ideinit>:
{
80101db8:	55                   	push   %ebp
80101db9:	89 e5                	mov    %esp,%ebp
80101dbb:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101dbe:	68 66 6a 10 80       	push   $0x80106a66
80101dc3:	68 80 a5 10 80       	push   $0x8010a580
80101dc8:	e8 85 1e 00 00       	call   80103c52 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101dcd:	83 c4 08             	add    $0x8,%esp
80101dd0:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101dd5:	83 e8 01             	sub    $0x1,%eax
80101dd8:	50                   	push   %eax
80101dd9:	6a 0e                	push   $0xe
80101ddb:	e8 63 02 00 00       	call   80102043 <ioapicenable>
80101de0:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101de3:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101de8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101de9:	83 e0 c0             	and    $0xffffffc0,%eax
80101dec:	3c 40                	cmp    $0x40,%al
80101dee:	75 f8                	jne    80101de8 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101df0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101df5:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101dfa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dfb:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e00:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e01:	84 c0                	test   %al,%al
80101e03:	75 11                	jne    80101e16 <ideinit+0x5e>
80101e05:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101e0a:	ec                   	in     (%dx),%al
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 07                	jne    80101e16 <ideinit+0x5e>
  for(i=0; i<1000; i++){
80101e0f:	83 e9 01             	sub    $0x1,%ecx
80101e12:	75 f6                	jne    80101e0a <ideinit+0x52>
80101e14:	eb 0a                	jmp    80101e20 <ideinit+0x68>
      havedisk1 = 1;
80101e16:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101e1d:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e20:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101e25:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e2a:	ee                   	out    %al,(%dx)
}
80101e2b:	c9                   	leave  
80101e2c:	c3                   	ret    

80101e2d <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e2d:	55                   	push   %ebp
80101e2e:	89 e5                	mov    %esp,%ebp
80101e30:	57                   	push   %edi
80101e31:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e32:	83 ec 0c             	sub    $0xc,%esp
80101e35:	68 80 a5 10 80       	push   $0x8010a580
80101e3a:	e8 5b 1f 00 00       	call   80103d9a <acquire>

  if((b = idequeue) == 0){
80101e3f:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e45:	83 c4 10             	add    $0x10,%esp
80101e48:	85 db                	test   %ebx,%ebx
80101e4a:	74 48                	je     80101e94 <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e4c:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4f:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e54:	f6 03 04             	testb  $0x4,(%ebx)
80101e57:	74 4d                	je     80101ea6 <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101e59:	8b 03                	mov    (%ebx),%eax
80101e5b:	83 e0 fb             	and    $0xfffffffb,%eax
80101e5e:	83 c8 02             	or     $0x2,%eax
80101e61:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e63:	83 ec 0c             	sub    $0xc,%esp
80101e66:	53                   	push   %ebx
80101e67:	e8 63 1b 00 00       	call   801039cf <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e6c:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101e71:	83 c4 10             	add    $0x10,%esp
80101e74:	85 c0                	test   %eax,%eax
80101e76:	74 05                	je     80101e7d <ideintr+0x50>
    idestart(idequeue);
80101e78:	e8 73 fe ff ff       	call   80101cf0 <idestart>

  release(&idelock);
80101e7d:	83 ec 0c             	sub    $0xc,%esp
80101e80:	68 80 a5 10 80       	push   $0x8010a580
80101e85:	e8 77 1f 00 00       	call   80103e01 <release>
80101e8a:	83 c4 10             	add    $0x10,%esp
}
80101e8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e90:	5b                   	pop    %ebx
80101e91:	5f                   	pop    %edi
80101e92:	5d                   	pop    %ebp
80101e93:	c3                   	ret    
    release(&idelock);
80101e94:	83 ec 0c             	sub    $0xc,%esp
80101e97:	68 80 a5 10 80       	push   $0x8010a580
80101e9c:	e8 60 1f 00 00       	call   80103e01 <release>
    return;
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	eb e7                	jmp    80101e8d <ideintr+0x60>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ea6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101eab:	ec                   	in     (%dx),%al
80101eac:	89 c1                	mov    %eax,%ecx
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101eae:	83 e0 c0             	and    $0xffffffc0,%eax
80101eb1:	3c 40                	cmp    $0x40,%al
80101eb3:	75 f6                	jne    80101eab <ideintr+0x7e>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101eb5:	f6 c1 21             	test   $0x21,%cl
80101eb8:	75 9f                	jne    80101e59 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101eba:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101ebd:	b9 80 00 00 00       	mov    $0x80,%ecx
80101ec2:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ec7:	fc                   	cld    
80101ec8:	f3 6d                	rep insl (%dx),%es:(%edi)
80101eca:	eb 8d                	jmp    80101e59 <ideintr+0x2c>

80101ecc <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101ecc:	55                   	push   %ebp
80101ecd:	89 e5                	mov    %esp,%ebp
80101ecf:	53                   	push   %ebx
80101ed0:	83 ec 10             	sub    $0x10,%esp
80101ed3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101ed6:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ed9:	50                   	push   %eax
80101eda:	e8 29 1d 00 00       	call   80103c08 <holdingsleep>
80101edf:	83 c4 10             	add    $0x10,%esp
80101ee2:	85 c0                	test   %eax,%eax
80101ee4:	74 41                	je     80101f27 <iderw+0x5b>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ee6:	8b 03                	mov    (%ebx),%eax
80101ee8:	83 e0 06             	and    $0x6,%eax
80101eeb:	83 f8 02             	cmp    $0x2,%eax
80101eee:	74 44                	je     80101f34 <iderw+0x68>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101ef0:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101ef4:	74 09                	je     80101eff <iderw+0x33>
80101ef6:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101efd:	74 42                	je     80101f41 <iderw+0x75>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101eff:	83 ec 0c             	sub    $0xc,%esp
80101f02:	68 80 a5 10 80       	push   $0x8010a580
80101f07:	e8 8e 1e 00 00       	call   80103d9a <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f0c:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f13:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80101f19:	83 c4 10             	add    $0x10,%esp
80101f1c:	85 d2                	test   %edx,%edx
80101f1e:	75 30                	jne    80101f50 <iderw+0x84>
80101f20:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101f25:	eb 33                	jmp    80101f5a <iderw+0x8e>
    panic("iderw: buf not locked");
80101f27:	83 ec 0c             	sub    $0xc,%esp
80101f2a:	68 6a 6a 10 80       	push   $0x80106a6a
80101f2f:	e8 10 e4 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	68 80 6a 10 80       	push   $0x80106a80
80101f3c:	e8 03 e4 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101f41:	83 ec 0c             	sub    $0xc,%esp
80101f44:	68 95 6a 10 80       	push   $0x80106a95
80101f49:	e8 f6 e3 ff ff       	call   80100344 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f4e:	89 c2                	mov    %eax,%edx
80101f50:	8b 42 58             	mov    0x58(%edx),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	75 f7                	jne    80101f4e <iderw+0x82>
80101f57:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101f5a:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f5c:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101f62:	74 3a                	je     80101f9e <iderw+0xd2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f64:	8b 03                	mov    (%ebx),%eax
80101f66:	83 e0 06             	and    $0x6,%eax
80101f69:	83 f8 02             	cmp    $0x2,%eax
80101f6c:	74 1b                	je     80101f89 <iderw+0xbd>
    sleep(b, &idelock);
80101f6e:	83 ec 08             	sub    $0x8,%esp
80101f71:	68 80 a5 10 80       	push   $0x8010a580
80101f76:	53                   	push   %ebx
80101f77:	e8 a5 18 00 00       	call   80103821 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f7c:	8b 03                	mov    (%ebx),%eax
80101f7e:	83 e0 06             	and    $0x6,%eax
80101f81:	83 c4 10             	add    $0x10,%esp
80101f84:	83 f8 02             	cmp    $0x2,%eax
80101f87:	75 e5                	jne    80101f6e <iderw+0xa2>
  }


  release(&idelock);
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	68 80 a5 10 80       	push   $0x8010a580
80101f91:	e8 6b 1e 00 00       	call   80103e01 <release>
}
80101f96:	83 c4 10             	add    $0x10,%esp
80101f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f9c:	c9                   	leave  
80101f9d:	c3                   	ret    
    idestart(b);
80101f9e:	89 d8                	mov    %ebx,%eax
80101fa0:	e8 4b fd ff ff       	call   80101cf0 <idestart>
80101fa5:	eb bd                	jmp    80101f64 <iderw+0x98>

80101fa7 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101fa7:	55                   	push   %ebp
80101fa8:	89 e5                	mov    %esp,%ebp
80101faa:	56                   	push   %esi
80101fab:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fac:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101fb3:	00 c0 fe 
  ioapic->reg = reg;
80101fb6:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101fbd:	00 00 00 
  return ioapic->data;
80101fc0:	a1 34 26 11 80       	mov    0x80112634,%eax
80101fc5:	8b 58 10             	mov    0x10(%eax),%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101fc8:	c1 eb 10             	shr    $0x10,%ebx
80101fcb:	0f b6 db             	movzbl %bl,%ebx
  ioapic->reg = reg;
80101fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80101fd4:	a1 34 26 11 80       	mov    0x80112634,%eax
80101fd9:	8b 40 10             	mov    0x10(%eax),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80101fdc:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  id = ioapicread(REG_ID) >> 24;
80101fe3:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fe6:	39 c2                	cmp    %eax,%edx
80101fe8:	75 47                	jne    80102031 <ioapicinit+0x8a>
{
80101fea:	ba 10 00 00 00       	mov    $0x10,%edx
80101fef:	b8 00 00 00 00       	mov    $0x0,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101ff4:	8d 48 20             	lea    0x20(%eax),%ecx
80101ff7:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
80101ffd:	8b 35 34 26 11 80    	mov    0x80112634,%esi
80102003:	89 16                	mov    %edx,(%esi)
  ioapic->data = data;
80102005:	8b 35 34 26 11 80    	mov    0x80112634,%esi
8010200b:	89 4e 10             	mov    %ecx,0x10(%esi)
8010200e:	8d 4a 01             	lea    0x1(%edx),%ecx
  ioapic->reg = reg;
80102011:	89 0e                	mov    %ecx,(%esi)
  ioapic->data = data;
80102013:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102019:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102020:	83 c0 01             	add    $0x1,%eax
80102023:	83 c2 02             	add    $0x2,%edx
80102026:	39 c3                	cmp    %eax,%ebx
80102028:	7d ca                	jge    80101ff4 <ioapicinit+0x4d>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010202a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010202d:	5b                   	pop    %ebx
8010202e:	5e                   	pop    %esi
8010202f:	5d                   	pop    %ebp
80102030:	c3                   	ret    
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102031:	83 ec 0c             	sub    $0xc,%esp
80102034:	68 b4 6a 10 80       	push   $0x80106ab4
80102039:	e8 a3 e5 ff ff       	call   801005e1 <cprintf>
8010203e:	83 c4 10             	add    $0x10,%esp
80102041:	eb a7                	jmp    80101fea <ioapicinit+0x43>

80102043 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102043:	55                   	push   %ebp
80102044:	89 e5                	mov    %esp,%ebp
80102046:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102049:	8d 50 20             	lea    0x20(%eax),%edx
8010204c:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102050:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102056:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102058:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010205e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102061:	8b 55 0c             	mov    0xc(%ebp),%edx
80102064:	c1 e2 18             	shl    $0x18,%edx
80102067:	83 c0 01             	add    $0x1,%eax
  ioapic->reg = reg;
8010206a:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010206c:	a1 34 26 11 80       	mov    0x80112634,%eax
80102071:	89 50 10             	mov    %edx,0x10(%eax)
}
80102074:	5d                   	pop    %ebp
80102075:	c3                   	ret    

80102076 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102076:	55                   	push   %ebp
80102077:	89 e5                	mov    %esp,%ebp
80102079:	53                   	push   %ebx
8010207a:	83 ec 04             	sub    $0x4,%esp
8010207d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102080:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102086:	75 4c                	jne    801020d4 <kfree+0x5e>
80102088:	81 fb c8 58 11 80    	cmp    $0x801158c8,%ebx
8010208e:	72 44                	jb     801020d4 <kfree+0x5e>
80102090:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102096:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
8010209b:	77 37                	ja     801020d4 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010209d:	83 ec 04             	sub    $0x4,%esp
801020a0:	68 00 10 00 00       	push   $0x1000
801020a5:	6a 01                	push   $0x1
801020a7:	53                   	push   %ebx
801020a8:	e8 9b 1d 00 00       	call   80103e48 <memset>

  if(kmem.use_lock)
801020ad:	83 c4 10             	add    $0x10,%esp
801020b0:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
801020b7:	75 28                	jne    801020e1 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801020b9:	a1 78 26 11 80       	mov    0x80112678,%eax
801020be:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801020c0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801020c6:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
801020cd:	75 24                	jne    801020f3 <kfree+0x7d>
    release(&kmem.lock);
}
801020cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020d2:	c9                   	leave  
801020d3:	c3                   	ret    
    panic("kfree");
801020d4:	83 ec 0c             	sub    $0xc,%esp
801020d7:	68 e6 6a 10 80       	push   $0x80106ae6
801020dc:	e8 63 e2 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
801020e1:	83 ec 0c             	sub    $0xc,%esp
801020e4:	68 40 26 11 80       	push   $0x80112640
801020e9:	e8 ac 1c 00 00       	call   80103d9a <acquire>
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	eb c6                	jmp    801020b9 <kfree+0x43>
    release(&kmem.lock);
801020f3:	83 ec 0c             	sub    $0xc,%esp
801020f6:	68 40 26 11 80       	push   $0x80112640
801020fb:	e8 01 1d 00 00       	call   80103e01 <release>
80102100:	83 c4 10             	add    $0x10,%esp
}
80102103:	eb ca                	jmp    801020cf <kfree+0x59>

80102105 <freerange>:
{
80102105:	55                   	push   %ebp
80102106:	89 e5                	mov    %esp,%ebp
80102108:	56                   	push   %esi
80102109:	53                   	push   %ebx
8010210a:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010210d:	8b 45 08             	mov    0x8(%ebp),%eax
80102110:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102116:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010211c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102122:	39 de                	cmp    %ebx,%esi
80102124:	72 1c                	jb     80102142 <freerange+0x3d>
    kfree(p);
80102126:	83 ec 0c             	sub    $0xc,%esp
80102129:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010212f:	50                   	push   %eax
80102130:	e8 41 ff ff ff       	call   80102076 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102135:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	39 f3                	cmp    %esi,%ebx
80102140:	76 e4                	jbe    80102126 <freerange+0x21>
}
80102142:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102145:	5b                   	pop    %ebx
80102146:	5e                   	pop    %esi
80102147:	5d                   	pop    %ebp
80102148:	c3                   	ret    

80102149 <kinit1>:
{
80102149:	55                   	push   %ebp
8010214a:	89 e5                	mov    %esp,%ebp
8010214c:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010214f:	68 ec 6a 10 80       	push   $0x80106aec
80102154:	68 40 26 11 80       	push   $0x80112640
80102159:	e8 f4 1a 00 00       	call   80103c52 <initlock>
  kmem.use_lock = 0;
8010215e:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102165:	00 00 00 
  freerange(vstart, vend);
80102168:	83 c4 08             	add    $0x8,%esp
8010216b:	ff 75 0c             	pushl  0xc(%ebp)
8010216e:	ff 75 08             	pushl  0x8(%ebp)
80102171:	e8 8f ff ff ff       	call   80102105 <freerange>
}
80102176:	83 c4 10             	add    $0x10,%esp
80102179:	c9                   	leave  
8010217a:	c3                   	ret    

8010217b <kinit2>:
{
8010217b:	55                   	push   %ebp
8010217c:	89 e5                	mov    %esp,%ebp
8010217e:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102181:	ff 75 0c             	pushl  0xc(%ebp)
80102184:	ff 75 08             	pushl  0x8(%ebp)
80102187:	e8 79 ff ff ff       	call   80102105 <freerange>
  kmem.use_lock = 1;
8010218c:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102193:	00 00 00 
}
80102196:	83 c4 10             	add    $0x10,%esp
80102199:	c9                   	leave  
8010219a:	c3                   	ret    

8010219b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010219b:	55                   	push   %ebp
8010219c:	89 e5                	mov    %esp,%ebp
8010219e:	53                   	push   %ebx
8010219f:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801021a2:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
801021a9:	75 21                	jne    801021cc <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801021ab:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801021b1:	85 db                	test   %ebx,%ebx
801021b3:	74 10                	je     801021c5 <kalloc+0x2a>
    kmem.freelist = r->next;
801021b5:	8b 03                	mov    (%ebx),%eax
801021b7:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
801021bc:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
801021c3:	75 23                	jne    801021e8 <kalloc+0x4d>
    release(&kmem.lock);
  return (char*)r;
}
801021c5:	89 d8                	mov    %ebx,%eax
801021c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021ca:	c9                   	leave  
801021cb:	c3                   	ret    
    acquire(&kmem.lock);
801021cc:	83 ec 0c             	sub    $0xc,%esp
801021cf:	68 40 26 11 80       	push   $0x80112640
801021d4:	e8 c1 1b 00 00       	call   80103d9a <acquire>
  r = kmem.freelist;
801021d9:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801021df:	83 c4 10             	add    $0x10,%esp
801021e2:	85 db                	test   %ebx,%ebx
801021e4:	75 cf                	jne    801021b5 <kalloc+0x1a>
801021e6:	eb d4                	jmp    801021bc <kalloc+0x21>
    release(&kmem.lock);
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	68 40 26 11 80       	push   $0x80112640
801021f0:	e8 0c 1c 00 00       	call   80103e01 <release>
801021f5:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021f8:	eb cb                	jmp    801021c5 <kalloc+0x2a>

801021fa <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba 64 00 00 00       	mov    $0x64,%edx
801021ff:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102200:	a8 01                	test   $0x1,%al
80102202:	0f 84 bb 00 00 00    	je     801022c3 <kbdgetc+0xc9>
80102208:	ba 60 00 00 00       	mov    $0x60,%edx
8010220d:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010220e:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102211:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102217:	74 5b                	je     80102274 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102219:	84 c0                	test   %al,%al
8010221b:	78 64                	js     80102281 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010221d:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102223:	f6 c1 40             	test   $0x40,%cl
80102226:	74 0f                	je     80102237 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102228:	83 c8 80             	or     $0xffffff80,%eax
8010222b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
8010222e:	83 e1 bf             	and    $0xffffffbf,%ecx
80102231:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
80102237:	0f b6 8a 20 6c 10 80 	movzbl -0x7fef93e0(%edx),%ecx
8010223e:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
80102244:	0f b6 82 20 6b 10 80 	movzbl -0x7fef94e0(%edx),%eax
8010224b:	31 c1                	xor    %eax,%ecx
8010224d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102253:	89 c8                	mov    %ecx,%eax
80102255:	83 e0 03             	and    $0x3,%eax
80102258:	8b 04 85 00 6b 10 80 	mov    -0x7fef9500(,%eax,4),%eax
8010225f:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102263:	f6 c1 08             	test   $0x8,%cl
80102266:	74 61                	je     801022c9 <kbdgetc+0xcf>
    if('a' <= c && c <= 'z')
80102268:	8d 50 9f             	lea    -0x61(%eax),%edx
8010226b:	83 fa 19             	cmp    $0x19,%edx
8010226e:	77 46                	ja     801022b6 <kbdgetc+0xbc>
      c += 'A' - 'a';
80102270:	83 e8 20             	sub    $0x20,%eax
80102273:	c3                   	ret    
    shift |= E0ESC;
80102274:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010227b:	b8 00 00 00 00       	mov    $0x0,%eax
80102280:	c3                   	ret    
{
80102281:	55                   	push   %ebp
80102282:	89 e5                	mov    %esp,%ebp
80102284:	53                   	push   %ebx
    data = (shift & E0ESC ? data : data & 0x7F);
80102285:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010228b:	89 cb                	mov    %ecx,%ebx
8010228d:	83 e3 40             	and    $0x40,%ebx
80102290:	83 e0 7f             	and    $0x7f,%eax
80102293:	85 db                	test   %ebx,%ebx
80102295:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102298:	0f b6 82 20 6c 10 80 	movzbl -0x7fef93e0(%edx),%eax
8010229f:	83 c8 40             	or     $0x40,%eax
801022a2:	0f b6 c0             	movzbl %al,%eax
801022a5:	f7 d0                	not    %eax
801022a7:	21 c8                	and    %ecx,%eax
801022a9:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801022ae:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801022b3:	5b                   	pop    %ebx
801022b4:	5d                   	pop    %ebp
801022b5:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
801022b6:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801022b9:	8d 50 20             	lea    0x20(%eax),%edx
801022bc:	83 f9 1a             	cmp    $0x1a,%ecx
801022bf:	0f 42 c2             	cmovb  %edx,%eax
  return c;
801022c2:	c3                   	ret    
    return -1;
801022c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c8:	c3                   	ret    
}
801022c9:	f3 c3                	repz ret 

801022cb <kbdintr>:

void
kbdintr(void)
{
801022cb:	55                   	push   %ebp
801022cc:	89 e5                	mov    %esp,%ebp
801022ce:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801022d1:	68 fa 21 10 80       	push   $0x801021fa
801022d6:	e8 60 e4 ff ff       	call   8010073b <consoleintr>
}
801022db:	83 c4 10             	add    $0x10,%esp
801022de:	c9                   	leave  
801022df:	c3                   	ret    

801022e0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801022e3:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
801022e9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022ec:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022ee:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801022f3:	8b 40 20             	mov    0x20(%eax),%eax
}
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    

801022f8 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
801022f8:	55                   	push   %ebp
801022f9:	89 e5                	mov    %esp,%ebp
801022fb:	56                   	push   %esi
801022fc:	53                   	push   %ebx
801022fd:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ff:	be 70 00 00 00       	mov    $0x70,%esi
80102304:	b8 00 00 00 00       	mov    $0x0,%eax
80102309:	89 f2                	mov    %esi,%edx
8010230b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010230c:	b9 71 00 00 00       	mov    $0x71,%ecx
80102311:	89 ca                	mov    %ecx,%edx
80102313:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102314:	0f b6 c0             	movzbl %al,%eax
80102317:	89 03                	mov    %eax,(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102319:	b8 02 00 00 00       	mov    $0x2,%eax
8010231e:	89 f2                	mov    %esi,%edx
80102320:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102321:	89 ca                	mov    %ecx,%edx
80102323:	ec                   	in     (%dx),%al
80102324:	0f b6 c0             	movzbl %al,%eax
80102327:	89 43 04             	mov    %eax,0x4(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	b8 04 00 00 00       	mov    $0x4,%eax
8010232f:	89 f2                	mov    %esi,%edx
80102331:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102332:	89 ca                	mov    %ecx,%edx
80102334:	ec                   	in     (%dx),%al
80102335:	0f b6 c0             	movzbl %al,%eax
80102338:	89 43 08             	mov    %eax,0x8(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010233b:	b8 07 00 00 00       	mov    $0x7,%eax
80102340:	89 f2                	mov    %esi,%edx
80102342:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102343:	89 ca                	mov    %ecx,%edx
80102345:	ec                   	in     (%dx),%al
80102346:	0f b6 c0             	movzbl %al,%eax
80102349:	89 43 0c             	mov    %eax,0xc(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010234c:	b8 08 00 00 00       	mov    $0x8,%eax
80102351:	89 f2                	mov    %esi,%edx
80102353:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102354:	89 ca                	mov    %ecx,%edx
80102356:	ec                   	in     (%dx),%al
80102357:	0f b6 c0             	movzbl %al,%eax
8010235a:	89 43 10             	mov    %eax,0x10(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010235d:	b8 09 00 00 00       	mov    $0x9,%eax
80102362:	89 f2                	mov    %esi,%edx
80102364:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102365:	89 ca                	mov    %ecx,%edx
80102367:	ec                   	in     (%dx),%al
80102368:	0f b6 c0             	movzbl %al,%eax
8010236b:	89 43 14             	mov    %eax,0x14(%ebx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
8010236e:	5b                   	pop    %ebx
8010236f:	5e                   	pop    %esi
80102370:	5d                   	pop    %ebp
80102371:	c3                   	ret    

80102372 <lapicinit>:
  if(!lapic)
80102372:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
80102379:	0f 84 fc 00 00 00    	je     8010247b <lapicinit+0x109>
{
8010237f:	55                   	push   %ebp
80102380:	89 e5                	mov    %esp,%ebp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102382:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102387:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010238c:	e8 4f ff ff ff       	call   801022e0 <lapicw>
  lapicw(TDCR, X1);
80102391:	ba 0b 00 00 00       	mov    $0xb,%edx
80102396:	b8 f8 00 00 00       	mov    $0xf8,%eax
8010239b:	e8 40 ff ff ff       	call   801022e0 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801023a0:	ba 20 00 02 00       	mov    $0x20020,%edx
801023a5:	b8 c8 00 00 00       	mov    $0xc8,%eax
801023aa:	e8 31 ff ff ff       	call   801022e0 <lapicw>
  lapicw(TICR, 10000000);
801023af:	ba 80 96 98 00       	mov    $0x989680,%edx
801023b4:	b8 e0 00 00 00       	mov    $0xe0,%eax
801023b9:	e8 22 ff ff ff       	call   801022e0 <lapicw>
  lapicw(LINT0, MASKED);
801023be:	ba 00 00 01 00       	mov    $0x10000,%edx
801023c3:	b8 d4 00 00 00       	mov    $0xd4,%eax
801023c8:	e8 13 ff ff ff       	call   801022e0 <lapicw>
  lapicw(LINT1, MASKED);
801023cd:	ba 00 00 01 00       	mov    $0x10000,%edx
801023d2:	b8 d8 00 00 00       	mov    $0xd8,%eax
801023d7:	e8 04 ff ff ff       	call   801022e0 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023dc:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023e1:	8b 40 30             	mov    0x30(%eax),%eax
801023e4:	c1 e8 10             	shr    $0x10,%eax
801023e7:	3c 03                	cmp    $0x3,%al
801023e9:	77 7c                	ja     80102467 <lapicinit+0xf5>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023eb:	ba 33 00 00 00       	mov    $0x33,%edx
801023f0:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023f5:	e8 e6 fe ff ff       	call   801022e0 <lapicw>
  lapicw(ESR, 0);
801023fa:	ba 00 00 00 00       	mov    $0x0,%edx
801023ff:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102404:	e8 d7 fe ff ff       	call   801022e0 <lapicw>
  lapicw(ESR, 0);
80102409:	ba 00 00 00 00       	mov    $0x0,%edx
8010240e:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102413:	e8 c8 fe ff ff       	call   801022e0 <lapicw>
  lapicw(EOI, 0);
80102418:	ba 00 00 00 00       	mov    $0x0,%edx
8010241d:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102422:	e8 b9 fe ff ff       	call   801022e0 <lapicw>
  lapicw(ICRHI, 0);
80102427:	ba 00 00 00 00       	mov    $0x0,%edx
8010242c:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102431:	e8 aa fe ff ff       	call   801022e0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102436:	ba 00 85 08 00       	mov    $0x88500,%edx
8010243b:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102440:	e8 9b fe ff ff       	call   801022e0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102445:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
8010244b:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
80102451:	f6 c4 10             	test   $0x10,%ah
80102454:	75 f5                	jne    8010244b <lapicinit+0xd9>
  lapicw(TPR, 0);
80102456:	ba 00 00 00 00       	mov    $0x0,%edx
8010245b:	b8 20 00 00 00       	mov    $0x20,%eax
80102460:	e8 7b fe ff ff       	call   801022e0 <lapicw>
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102467:	ba 00 00 01 00       	mov    $0x10000,%edx
8010246c:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102471:	e8 6a fe ff ff       	call   801022e0 <lapicw>
80102476:	e9 70 ff ff ff       	jmp    801023eb <lapicinit+0x79>
8010247b:	f3 c3                	repz ret 

8010247d <lapicid>:
{
8010247d:	55                   	push   %ebp
8010247e:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102480:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
    return 0;
80102486:	b8 00 00 00 00       	mov    $0x0,%eax
  if (!lapic)
8010248b:	85 d2                	test   %edx,%edx
8010248d:	74 06                	je     80102495 <lapicid+0x18>
  return lapic[ID] >> 24;
8010248f:	8b 42 20             	mov    0x20(%edx),%eax
80102492:	c1 e8 18             	shr    $0x18,%eax
}
80102495:	5d                   	pop    %ebp
80102496:	c3                   	ret    

80102497 <lapiceoi>:
  if(lapic)
80102497:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
8010249e:	74 14                	je     801024b4 <lapiceoi+0x1d>
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
    lapicw(EOI, 0);
801024a3:	ba 00 00 00 00       	mov    $0x0,%edx
801024a8:	b8 2c 00 00 00       	mov    $0x2c,%eax
801024ad:	e8 2e fe ff ff       	call   801022e0 <lapicw>
}
801024b2:	5d                   	pop    %ebp
801024b3:	c3                   	ret    
801024b4:	f3 c3                	repz ret 

801024b6 <microdelay>:
{
801024b6:	55                   	push   %ebp
801024b7:	89 e5                	mov    %esp,%ebp
}
801024b9:	5d                   	pop    %ebp
801024ba:	c3                   	ret    

801024bb <lapicstartap>:
{
801024bb:	55                   	push   %ebp
801024bc:	89 e5                	mov    %esp,%ebp
801024be:	56                   	push   %esi
801024bf:	53                   	push   %ebx
801024c0:	8b 75 08             	mov    0x8(%ebp),%esi
801024c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024c6:	b8 0f 00 00 00       	mov    $0xf,%eax
801024cb:	ba 70 00 00 00       	mov    $0x70,%edx
801024d0:	ee                   	out    %al,(%dx)
801024d1:	b8 0a 00 00 00       	mov    $0xa,%eax
801024d6:	ba 71 00 00 00       	mov    $0x71,%edx
801024db:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801024dc:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024e3:	00 00 
  wrv[1] = addr >> 4;
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	c1 e8 04             	shr    $0x4,%eax
801024ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801024f0:	c1 e6 18             	shl    $0x18,%esi
801024f3:	89 f2                	mov    %esi,%edx
801024f5:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024fa:	e8 e1 fd ff ff       	call   801022e0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024ff:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102504:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102509:	e8 d2 fd ff ff       	call   801022e0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010250e:	ba 00 85 00 00       	mov    $0x8500,%edx
80102513:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102518:	e8 c3 fd ff ff       	call   801022e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010251d:	c1 eb 0c             	shr    $0xc,%ebx
80102520:	80 cf 06             	or     $0x6,%bh
    lapicw(ICRHI, apicid<<24);
80102523:	89 f2                	mov    %esi,%edx
80102525:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010252a:	e8 b1 fd ff ff       	call   801022e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010252f:	89 da                	mov    %ebx,%edx
80102531:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102536:	e8 a5 fd ff ff       	call   801022e0 <lapicw>
    lapicw(ICRHI, apicid<<24);
8010253b:	89 f2                	mov    %esi,%edx
8010253d:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102542:	e8 99 fd ff ff       	call   801022e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102547:	89 da                	mov    %ebx,%edx
80102549:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010254e:	e8 8d fd ff ff       	call   801022e0 <lapicw>
}
80102553:	5b                   	pop    %ebx
80102554:	5e                   	pop    %esi
80102555:	5d                   	pop    %ebp
80102556:	c3                   	ret    

80102557 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102557:	55                   	push   %ebp
80102558:	89 e5                	mov    %esp,%ebp
8010255a:	57                   	push   %edi
8010255b:	56                   	push   %esi
8010255c:	53                   	push   %ebx
8010255d:	83 ec 4c             	sub    $0x4c,%esp
80102560:	8b 7d 08             	mov    0x8(%ebp),%edi
80102563:	b8 0b 00 00 00       	mov    $0xb,%eax
80102568:	ba 70 00 00 00       	mov    $0x70,%edx
8010256d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010256e:	ba 71 00 00 00       	mov    $0x71,%edx
80102573:	ec                   	in     (%dx),%al
80102574:	83 e0 04             	and    $0x4,%eax
80102577:	88 45 b7             	mov    %al,-0x49(%ebp)

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010257a:	8d 75 d0             	lea    -0x30(%ebp),%esi
8010257d:	89 f0                	mov    %esi,%eax
8010257f:	e8 74 fd ff ff       	call   801022f8 <fill_rtcdate>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102584:	ba 70 00 00 00       	mov    $0x70,%edx
80102589:	b8 0a 00 00 00       	mov    $0xa,%eax
8010258e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010258f:	ba 71 00 00 00       	mov    $0x71,%edx
80102594:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102595:	84 c0                	test   %al,%al
80102597:	78 e4                	js     8010257d <cmostime+0x26>
        continue;
    fill_rtcdate(&t2);
80102599:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010259c:	89 d8                	mov    %ebx,%eax
8010259e:	e8 55 fd ff ff       	call   801022f8 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801025a3:	83 ec 04             	sub    $0x4,%esp
801025a6:	6a 18                	push   $0x18
801025a8:	53                   	push   %ebx
801025a9:	56                   	push   %esi
801025aa:	e8 dd 18 00 00       	call   80103e8c <memcmp>
801025af:	83 c4 10             	add    $0x10,%esp
801025b2:	85 c0                	test   %eax,%eax
801025b4:	75 c7                	jne    8010257d <cmostime+0x26>
      break;
  }

  // convert
  if(bcd) {
801025b6:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801025ba:	75 78                	jne    80102634 <cmostime+0xdd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801025bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025bf:	89 c2                	mov    %eax,%edx
801025c1:	c1 ea 04             	shr    $0x4,%edx
801025c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c7:	83 e0 0f             	and    $0xf,%eax
801025ca:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
801025d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025d3:	89 c2                	mov    %eax,%edx
801025d5:	c1 ea 04             	shr    $0x4,%edx
801025d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025db:	83 e0 0f             	and    $0xf,%eax
801025de:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025e7:	89 c2                	mov    %eax,%edx
801025e9:	c1 ea 04             	shr    $0x4,%edx
801025ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ef:	83 e0 0f             	and    $0xf,%eax
801025f2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025fb:	89 c2                	mov    %eax,%edx
801025fd:	c1 ea 04             	shr    $0x4,%edx
80102600:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102603:	83 e0 0f             	and    $0xf,%eax
80102606:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102609:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
8010260c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010260f:	89 c2                	mov    %eax,%edx
80102611:	c1 ea 04             	shr    $0x4,%edx
80102614:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102617:	83 e0 0f             	and    $0xf,%eax
8010261a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010261d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
80102620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102623:	89 c2                	mov    %eax,%edx
80102625:	c1 ea 04             	shr    $0x4,%edx
80102628:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010262b:	83 e0 0f             	and    $0xf,%eax
8010262e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102634:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102637:	89 07                	mov    %eax,(%edi)
80102639:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010263c:	89 47 04             	mov    %eax,0x4(%edi)
8010263f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102642:	89 47 08             	mov    %eax,0x8(%edi)
80102645:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102648:	89 47 0c             	mov    %eax,0xc(%edi)
8010264b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010264e:	89 47 10             	mov    %eax,0x10(%edi)
80102651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102654:	89 47 14             	mov    %eax,0x14(%edi)
  r->year += 2000;
80102657:	81 47 14 d0 07 00 00 	addl   $0x7d0,0x14(%edi)
}
8010265e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5f                   	pop    %edi
80102664:	5d                   	pop    %ebp
80102665:	c3                   	ret    

80102666 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102666:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010266d:	0f 8e 84 00 00 00    	jle    801026f7 <install_trans+0x91>
{
80102673:	55                   	push   %ebp
80102674:	89 e5                	mov    %esp,%ebp
80102676:	57                   	push   %edi
80102677:	56                   	push   %esi
80102678:	53                   	push   %ebx
80102679:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010267c:	bb 00 00 00 00       	mov    $0x0,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102681:	be 80 26 11 80       	mov    $0x80112680,%esi
80102686:	83 ec 08             	sub    $0x8,%esp
80102689:	89 d8                	mov    %ebx,%eax
8010268b:	03 46 34             	add    0x34(%esi),%eax
8010268e:	83 c0 01             	add    $0x1,%eax
80102691:	50                   	push   %eax
80102692:	ff 76 44             	pushl  0x44(%esi)
80102695:	e8 10 da ff ff       	call   801000aa <bread>
8010269a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010269d:	83 c4 08             	add    $0x8,%esp
801026a0:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801026a7:	ff 76 44             	pushl  0x44(%esi)
801026aa:	e8 fb d9 ff ff       	call   801000aa <bread>
801026af:	89 c7                	mov    %eax,%edi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801026b1:	83 c4 0c             	add    $0xc,%esp
801026b4:	68 00 02 00 00       	push   $0x200
801026b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801026bc:	83 c0 5c             	add    $0x5c,%eax
801026bf:	50                   	push   %eax
801026c0:	8d 47 5c             	lea    0x5c(%edi),%eax
801026c3:	50                   	push   %eax
801026c4:	e8 14 18 00 00       	call   80103edd <memmove>
    bwrite(dbuf);  // write dst to disk
801026c9:	89 3c 24             	mov    %edi,(%esp)
801026cc:	e8 b5 da ff ff       	call   80100186 <bwrite>
    brelse(lbuf);
801026d1:	83 c4 04             	add    $0x4,%esp
801026d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801026d7:	e8 e5 da ff ff       	call   801001c1 <brelse>
    brelse(dbuf);
801026dc:	89 3c 24             	mov    %edi,(%esp)
801026df:	e8 dd da ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026e4:	83 c3 01             	add    $0x1,%ebx
801026e7:	83 c4 10             	add    $0x10,%esp
801026ea:	39 5e 48             	cmp    %ebx,0x48(%esi)
801026ed:	7f 97                	jg     80102686 <install_trans+0x20>
  }
}
801026ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026f2:	5b                   	pop    %ebx
801026f3:	5e                   	pop    %esi
801026f4:	5f                   	pop    %edi
801026f5:	5d                   	pop    %ebp
801026f6:	c3                   	ret    
801026f7:	f3 c3                	repz ret 

801026f9 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026f9:	55                   	push   %ebp
801026fa:	89 e5                	mov    %esp,%ebp
801026fc:	53                   	push   %ebx
801026fd:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102700:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102706:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010270c:	e8 99 d9 ff ff       	call   801000aa <bread>
80102711:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102713:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102719:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010271c:	83 c4 10             	add    $0x10,%esp
8010271f:	85 c9                	test   %ecx,%ecx
80102721:	7e 19                	jle    8010273c <write_head+0x43>
80102723:	c1 e1 02             	shl    $0x2,%ecx
80102726:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
8010272b:	8b 90 cc 26 11 80    	mov    -0x7feed934(%eax),%edx
80102731:	89 54 03 60          	mov    %edx,0x60(%ebx,%eax,1)
80102735:	83 c0 04             	add    $0x4,%eax
  for (i = 0; i < log.lh.n; i++) {
80102738:	39 c8                	cmp    %ecx,%eax
8010273a:	75 ef                	jne    8010272b <write_head+0x32>
  }
  bwrite(buf);
8010273c:	83 ec 0c             	sub    $0xc,%esp
8010273f:	53                   	push   %ebx
80102740:	e8 41 da ff ff       	call   80100186 <bwrite>
  brelse(buf);
80102745:	89 1c 24             	mov    %ebx,(%esp)
80102748:	e8 74 da ff ff       	call   801001c1 <brelse>
}
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102753:	c9                   	leave  
80102754:	c3                   	ret    

80102755 <initlog>:
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
80102758:	53                   	push   %ebx
80102759:	83 ec 2c             	sub    $0x2c,%esp
8010275c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010275f:	68 20 6d 10 80       	push   $0x80106d20
80102764:	68 80 26 11 80       	push   $0x80112680
80102769:	e8 e4 14 00 00       	call   80103c52 <initlock>
  readsb(dev, &sb);
8010276e:	83 c4 08             	add    $0x8,%esp
80102771:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102774:	50                   	push   %eax
80102775:	53                   	push   %ebx
80102776:	e8 12 eb ff ff       	call   8010128d <readsb>
  log.start = sb.logstart;
8010277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010277e:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102783:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102786:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.dev = dev;
8010278c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102792:	83 c4 08             	add    $0x8,%esp
80102795:	50                   	push   %eax
80102796:	53                   	push   %ebx
80102797:	e8 0e d9 ff ff       	call   801000aa <bread>
  log.lh.n = lh->n;
8010279c:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010279f:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801027a5:	83 c4 10             	add    $0x10,%esp
801027a8:	85 db                	test   %ebx,%ebx
801027aa:	7e 19                	jle    801027c5 <initlog+0x70>
801027ac:	c1 e3 02             	shl    $0x2,%ebx
801027af:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
801027b4:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801027b8:	89 8a cc 26 11 80    	mov    %ecx,-0x7feed934(%edx)
801027be:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
801027c1:	39 d3                	cmp    %edx,%ebx
801027c3:	75 ef                	jne    801027b4 <initlog+0x5f>
  brelse(buf);
801027c5:	83 ec 0c             	sub    $0xc,%esp
801027c8:	50                   	push   %eax
801027c9:	e8 f3 d9 ff ff       	call   801001c1 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801027ce:	e8 93 fe ff ff       	call   80102666 <install_trans>
  log.lh.n = 0;
801027d3:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801027da:	00 00 00 
  write_head(); // clear the log
801027dd:	e8 17 ff ff ff       	call   801026f9 <write_head>
}
801027e2:	83 c4 10             	add    $0x10,%esp
801027e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e8:	c9                   	leave  
801027e9:	c3                   	ret    

801027ea <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801027ea:	55                   	push   %ebp
801027eb:	89 e5                	mov    %esp,%ebp
801027ed:	53                   	push   %ebx
801027ee:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801027f1:	68 80 26 11 80       	push   $0x80112680
801027f6:	e8 9f 15 00 00       	call   80103d9a <acquire>
801027fb:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801027fe:	bb 80 26 11 80       	mov    $0x80112680,%ebx
80102803:	eb 15                	jmp    8010281a <begin_op+0x30>
      sleep(&log, &log.lock);
80102805:	83 ec 08             	sub    $0x8,%esp
80102808:	68 80 26 11 80       	push   $0x80112680
8010280d:	68 80 26 11 80       	push   $0x80112680
80102812:	e8 0a 10 00 00       	call   80103821 <sleep>
80102817:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010281a:	83 7b 40 00          	cmpl   $0x0,0x40(%ebx)
8010281e:	75 e5                	jne    80102805 <begin_op+0x1b>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102820:	8b 43 3c             	mov    0x3c(%ebx),%eax
80102823:	83 c0 01             	add    $0x1,%eax
80102826:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102829:	8b 53 48             	mov    0x48(%ebx),%edx
8010282c:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010282f:	83 fa 1e             	cmp    $0x1e,%edx
80102832:	7e 17                	jle    8010284b <begin_op+0x61>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80102834:	83 ec 08             	sub    $0x8,%esp
80102837:	68 80 26 11 80       	push   $0x80112680
8010283c:	68 80 26 11 80       	push   $0x80112680
80102841:	e8 db 0f 00 00       	call   80103821 <sleep>
80102846:	83 c4 10             	add    $0x10,%esp
80102849:	eb cf                	jmp    8010281a <begin_op+0x30>
    } else {
      log.outstanding += 1;
8010284b:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102850:	83 ec 0c             	sub    $0xc,%esp
80102853:	68 80 26 11 80       	push   $0x80112680
80102858:	e8 a4 15 00 00       	call   80103e01 <release>
      break;
    }
  }
}
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102863:	c9                   	leave  
80102864:	c3                   	ret    

80102865 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102865:	55                   	push   %ebp
80102866:	89 e5                	mov    %esp,%ebp
80102868:	57                   	push   %edi
80102869:	56                   	push   %esi
8010286a:	53                   	push   %ebx
8010286b:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010286e:	68 80 26 11 80       	push   $0x80112680
80102873:	e8 22 15 00 00       	call   80103d9a <acquire>
  log.outstanding -= 1;
80102878:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010287d:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102880:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102886:	83 c4 10             	add    $0x10,%esp
80102889:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102890:	0f 85 e9 00 00 00    	jne    8010297f <end_op+0x11a>
    panic("log.committing");
  if(log.outstanding == 0){
80102896:	85 db                	test   %ebx,%ebx
80102898:	0f 85 ee 00 00 00    	jne    8010298c <end_op+0x127>
    do_commit = 1;
    log.committing = 1;
8010289e:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
801028a5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801028a8:	83 ec 0c             	sub    $0xc,%esp
801028ab:	68 80 26 11 80       	push   $0x80112680
801028b0:	e8 4c 15 00 00       	call   80103e01 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801028b5:	83 c4 10             	add    $0x10,%esp
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801028b8:	be 80 26 11 80       	mov    $0x80112680,%esi
  if (log.lh.n > 0) {
801028bd:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
801028c4:	7e 7f                	jle    80102945 <end_op+0xe0>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801028c6:	83 ec 08             	sub    $0x8,%esp
801028c9:	89 d8                	mov    %ebx,%eax
801028cb:	03 46 34             	add    0x34(%esi),%eax
801028ce:	83 c0 01             	add    $0x1,%eax
801028d1:	50                   	push   %eax
801028d2:	ff 76 44             	pushl  0x44(%esi)
801028d5:	e8 d0 d7 ff ff       	call   801000aa <bread>
801028da:	89 c7                	mov    %eax,%edi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801028dc:	83 c4 08             	add    $0x8,%esp
801028df:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801028e6:	ff 76 44             	pushl  0x44(%esi)
801028e9:	e8 bc d7 ff ff       	call   801000aa <bread>
    memmove(to->data, from->data, BSIZE);
801028ee:	83 c4 0c             	add    $0xc,%esp
801028f1:	68 00 02 00 00       	push   $0x200
801028f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801028f9:	83 c0 5c             	add    $0x5c,%eax
801028fc:	50                   	push   %eax
801028fd:	8d 47 5c             	lea    0x5c(%edi),%eax
80102900:	50                   	push   %eax
80102901:	e8 d7 15 00 00       	call   80103edd <memmove>
    bwrite(to);  // write the log
80102906:	89 3c 24             	mov    %edi,(%esp)
80102909:	e8 78 d8 ff ff       	call   80100186 <bwrite>
    brelse(from);
8010290e:	83 c4 04             	add    $0x4,%esp
80102911:	ff 75 e4             	pushl  -0x1c(%ebp)
80102914:	e8 a8 d8 ff ff       	call   801001c1 <brelse>
    brelse(to);
80102919:	89 3c 24             	mov    %edi,(%esp)
8010291c:	e8 a0 d8 ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102921:	83 c3 01             	add    $0x1,%ebx
80102924:	83 c4 10             	add    $0x10,%esp
80102927:	3b 5e 48             	cmp    0x48(%esi),%ebx
8010292a:	7c 9a                	jl     801028c6 <end_op+0x61>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010292c:	e8 c8 fd ff ff       	call   801026f9 <write_head>
    install_trans(); // Now install writes to home locations
80102931:	e8 30 fd ff ff       	call   80102666 <install_trans>
    log.lh.n = 0;
80102936:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010293d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102940:	e8 b4 fd ff ff       	call   801026f9 <write_head>
    acquire(&log.lock);
80102945:	83 ec 0c             	sub    $0xc,%esp
80102948:	68 80 26 11 80       	push   $0x80112680
8010294d:	e8 48 14 00 00       	call   80103d9a <acquire>
    log.committing = 0;
80102952:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102959:	00 00 00 
    wakeup(&log);
8010295c:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102963:	e8 67 10 00 00       	call   801039cf <wakeup>
    release(&log.lock);
80102968:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010296f:	e8 8d 14 00 00       	call   80103e01 <release>
80102974:	83 c4 10             	add    $0x10,%esp
}
80102977:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010297a:	5b                   	pop    %ebx
8010297b:	5e                   	pop    %esi
8010297c:	5f                   	pop    %edi
8010297d:	5d                   	pop    %ebp
8010297e:	c3                   	ret    
    panic("log.committing");
8010297f:	83 ec 0c             	sub    $0xc,%esp
80102982:	68 24 6d 10 80       	push   $0x80106d24
80102987:	e8 b8 d9 ff ff       	call   80100344 <panic>
    wakeup(&log);
8010298c:	83 ec 0c             	sub    $0xc,%esp
8010298f:	68 80 26 11 80       	push   $0x80112680
80102994:	e8 36 10 00 00       	call   801039cf <wakeup>
  release(&log.lock);
80102999:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801029a0:	e8 5c 14 00 00       	call   80103e01 <release>
801029a5:	83 c4 10             	add    $0x10,%esp
801029a8:	eb cd                	jmp    80102977 <end_op+0x112>

801029aa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801029aa:	55                   	push   %ebp
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	53                   	push   %ebx
801029ae:	83 ec 04             	sub    $0x4,%esp
801029b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801029b4:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801029ba:	83 fa 1d             	cmp    $0x1d,%edx
801029bd:	7f 6b                	jg     80102a2a <log_write+0x80>
801029bf:	a1 b8 26 11 80       	mov    0x801126b8,%eax
801029c4:	83 e8 01             	sub    $0x1,%eax
801029c7:	39 c2                	cmp    %eax,%edx
801029c9:	7d 5f                	jge    80102a2a <log_write+0x80>
    panic("too big a transaction");
  if (log.outstanding < 1)
801029cb:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
801029d2:	7e 63                	jle    80102a37 <log_write+0x8d>
    panic("log_write outside of trans");

  acquire(&log.lock);
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 80 26 11 80       	push   $0x80112680
801029dc:	e8 b9 13 00 00       	call   80103d9a <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029e1:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801029e7:	83 c4 10             	add    $0x10,%esp
801029ea:	85 d2                	test   %edx,%edx
801029ec:	7e 56                	jle    80102a44 <log_write+0x9a>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029f1:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
801029f7:	74 5b                	je     80102a54 <log_write+0xaa>
  for (i = 0; i < log.lh.n; i++) {
801029f9:	b8 00 00 00 00       	mov    $0x0,%eax
801029fe:	83 c0 01             	add    $0x1,%eax
80102a01:	39 d0                	cmp    %edx,%eax
80102a03:	74 56                	je     80102a5b <log_write+0xb1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a05:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102a0c:	75 f0                	jne    801029fe <log_write+0x54>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a0e:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a15:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	68 80 26 11 80       	push   $0x80112680
80102a20:	e8 dc 13 00 00       	call   80103e01 <release>
}
80102a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a28:	c9                   	leave  
80102a29:	c3                   	ret    
    panic("too big a transaction");
80102a2a:	83 ec 0c             	sub    $0xc,%esp
80102a2d:	68 33 6d 10 80       	push   $0x80106d33
80102a32:	e8 0d d9 ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
80102a37:	83 ec 0c             	sub    $0xc,%esp
80102a3a:	68 49 6d 10 80       	push   $0x80106d49
80102a3f:	e8 00 d9 ff ff       	call   80100344 <panic>
  log.lh.block[i] = b->blockno;
80102a44:	8b 43 08             	mov    0x8(%ebx),%eax
80102a47:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102a4c:	85 d2                	test   %edx,%edx
80102a4e:	75 c5                	jne    80102a15 <log_write+0x6b>
  for (i = 0; i < log.lh.n; i++) {
80102a50:	89 d0                	mov    %edx,%eax
80102a52:	eb 11                	jmp    80102a65 <log_write+0xbb>
80102a54:	b8 00 00 00 00       	mov    $0x0,%eax
80102a59:	eb b3                	jmp    80102a0e <log_write+0x64>
  log.lh.block[i] = b->blockno;
80102a5b:	8b 53 08             	mov    0x8(%ebx),%edx
80102a5e:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
    log.lh.n++;
80102a65:	83 c0 01             	add    $0x1,%eax
80102a68:	a3 c8 26 11 80       	mov    %eax,0x801126c8
80102a6d:	eb a6                	jmp    80102a15 <log_write+0x6b>

80102a6f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102a6f:	55                   	push   %ebp
80102a70:	89 e5                	mov    %esp,%ebp
80102a72:	53                   	push   %ebx
80102a73:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a76:	e8 e0 08 00 00       	call   8010335b <cpuid>
80102a7b:	89 c3                	mov    %eax,%ebx
80102a7d:	e8 d9 08 00 00       	call   8010335b <cpuid>
80102a82:	83 ec 04             	sub    $0x4,%esp
80102a85:	53                   	push   %ebx
80102a86:	50                   	push   %eax
80102a87:	68 64 6d 10 80       	push   $0x80106d64
80102a8c:	e8 50 db ff ff       	call   801005e1 <cprintf>
  idtinit();       // load idt register
80102a91:	e8 64 25 00 00       	call   80104ffa <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a96:	e8 49 08 00 00       	call   801032e4 <mycpu>
80102a9b:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a9d:	b8 01 00 00 00       	mov    $0x1,%eax
80102aa2:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102aa9:	e8 46 0b 00 00       	call   801035f4 <scheduler>

80102aae <mpenter>:
{
80102aae:	55                   	push   %ebp
80102aaf:	89 e5                	mov    %esp,%ebp
80102ab1:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ab4:	e8 04 35 00 00       	call   80105fbd <switchkvm>
  seginit();
80102ab9:	e8 97 33 00 00       	call   80105e55 <seginit>
  lapicinit();
80102abe:	e8 af f8 ff ff       	call   80102372 <lapicinit>
  mpmain();
80102ac3:	e8 a7 ff ff ff       	call   80102a6f <mpmain>

80102ac8 <main>:
{
80102ac8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102acc:	83 e4 f0             	and    $0xfffffff0,%esp
80102acf:	ff 71 fc             	pushl  -0x4(%ecx)
80102ad2:	55                   	push   %ebp
80102ad3:	89 e5                	mov    %esp,%ebp
80102ad5:	53                   	push   %ebx
80102ad6:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ad7:	83 ec 08             	sub    $0x8,%esp
80102ada:	68 00 00 40 80       	push   $0x80400000
80102adf:	68 c8 58 11 80       	push   $0x801158c8
80102ae4:	e8 60 f6 ff ff       	call   80102149 <kinit1>
  kvmalloc();      // kernel page table
80102ae9:	e8 54 39 00 00       	call   80106442 <kvmalloc>
  mpinit();        // detect other processors
80102aee:	e8 55 01 00 00       	call   80102c48 <mpinit>
  lapicinit();     // interrupt controller
80102af3:	e8 7a f8 ff ff       	call   80102372 <lapicinit>
  seginit();       // segment descriptors
80102af8:	e8 58 33 00 00       	call   80105e55 <seginit>
  picinit();       // disable pic
80102afd:	e8 06 03 00 00       	call   80102e08 <picinit>
  ioapicinit();    // another interrupt controller
80102b02:	e8 a0 f4 ff ff       	call   80101fa7 <ioapicinit>
  consoleinit();   // console hardware
80102b07:	e8 c2 dd ff ff       	call   801008ce <consoleinit>
  uartinit();      // serial port
80102b0c:	e8 a9 27 00 00       	call   801052ba <uartinit>
  pinit();         // process table
80102b11:	e8 b4 07 00 00       	call   801032ca <pinit>
  tvinit();        // trap vectors
80102b16:	e8 54 24 00 00       	call   80104f6f <tvinit>
  binit();         // buffer cache
80102b1b:	e8 14 d5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102b20:	e8 66 e1 ff ff       	call   80100c8b <fileinit>
  ideinit();       // disk 
80102b25:	e8 8e f2 ff ff       	call   80101db8 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102b2a:	83 c4 0c             	add    $0xc,%esp
80102b2d:	68 8a 00 00 00       	push   $0x8a
80102b32:	68 8c a4 10 80       	push   $0x8010a48c
80102b37:	68 00 70 00 80       	push   $0x80007000
80102b3c:	e8 9c 13 00 00       	call   80103edd <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102b41:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102b48:	00 00 00 
80102b4b:	05 80 27 11 80       	add    $0x80112780,%eax
80102b50:	83 c4 10             	add    $0x10,%esp
80102b53:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102b58:	76 6c                	jbe    80102bc6 <main+0xfe>
80102b5a:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102b5f:	eb 19                	jmp    80102b7a <main+0xb2>
80102b61:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b67:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102b6e:	00 00 00 
80102b71:	05 80 27 11 80       	add    $0x80112780,%eax
80102b76:	39 c3                	cmp    %eax,%ebx
80102b78:	73 4c                	jae    80102bc6 <main+0xfe>
    if(c == mycpu())  // We've started already.
80102b7a:	e8 65 07 00 00       	call   801032e4 <mycpu>
80102b7f:	39 d8                	cmp    %ebx,%eax
80102b81:	74 de                	je     80102b61 <main+0x99>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102b83:	e8 13 f6 ff ff       	call   8010219b <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102b88:	05 00 10 00 00       	add    $0x1000,%eax
80102b8d:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102b92:	c7 05 f8 6f 00 80 ae 	movl   $0x80102aae,0x80006ff8
80102b99:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102b9c:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ba3:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102ba6:	83 ec 08             	sub    $0x8,%esp
80102ba9:	68 00 70 00 00       	push   $0x7000
80102bae:	0f b6 03             	movzbl (%ebx),%eax
80102bb1:	50                   	push   %eax
80102bb2:	e8 04 f9 ff ff       	call   801024bb <lapicstartap>
80102bb7:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102bba:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	74 f6                	je     80102bba <main+0xf2>
80102bc4:	eb 9b                	jmp    80102b61 <main+0x99>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102bc6:	83 ec 08             	sub    $0x8,%esp
80102bc9:	68 00 00 00 8e       	push   $0x8e000000
80102bce:	68 00 00 40 80       	push   $0x80400000
80102bd3:	e8 a3 f5 ff ff       	call   8010217b <kinit2>
  userinit();      // first user process
80102bd8:	e8 bd 07 00 00       	call   8010339a <userinit>
  shmem_init();    // initial share page memory
80102bdd:	e8 94 3a 00 00       	call   80106676 <shmem_init>
  mpmain();        // finish this processor's setup
80102be2:	e8 88 fe ff ff       	call   80102a6f <mpmain>

80102be7 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102be7:	55                   	push   %ebp
80102be8:	89 e5                	mov    %esp,%ebp
80102bea:	57                   	push   %edi
80102beb:	56                   	push   %esi
80102bec:	53                   	push   %ebx
80102bed:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bf0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  e = addr+len;
80102bf6:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bf9:	39 f3                	cmp    %esi,%ebx
80102bfb:	72 12                	jb     80102c0f <mpsearch1+0x28>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102bfd:	bb 00 00 00 00       	mov    $0x0,%ebx
80102c02:	eb 3a                	jmp    80102c3e <mpsearch1+0x57>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c04:	84 c0                	test   %al,%al
80102c06:	74 36                	je     80102c3e <mpsearch1+0x57>
  for(p = addr; p < e; p += sizeof(struct mp))
80102c08:	83 c3 10             	add    $0x10,%ebx
80102c0b:	39 de                	cmp    %ebx,%esi
80102c0d:	76 2a                	jbe    80102c39 <mpsearch1+0x52>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c0f:	83 ec 04             	sub    $0x4,%esp
80102c12:	6a 04                	push   $0x4
80102c14:	68 78 6d 10 80       	push   $0x80106d78
80102c19:	53                   	push   %ebx
80102c1a:	e8 6d 12 00 00       	call   80103e8c <memcmp>
80102c1f:	83 c4 10             	add    $0x10,%esp
80102c22:	85 c0                	test   %eax,%eax
80102c24:	75 e2                	jne    80102c08 <mpsearch1+0x21>
80102c26:	89 d9                	mov    %ebx,%ecx
80102c28:	8d 7b 10             	lea    0x10(%ebx),%edi
    sum += addr[i];
80102c2b:	0f b6 11             	movzbl (%ecx),%edx
80102c2e:	01 d0                	add    %edx,%eax
80102c30:	83 c1 01             	add    $0x1,%ecx
  for(i=0; i<len; i++)
80102c33:	39 f9                	cmp    %edi,%ecx
80102c35:	75 f4                	jne    80102c2b <mpsearch1+0x44>
80102c37:	eb cb                	jmp    80102c04 <mpsearch1+0x1d>
  return 0;
80102c39:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c3e:	89 d8                	mov    %ebx,%eax
80102c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c43:	5b                   	pop    %ebx
80102c44:	5e                   	pop    %esi
80102c45:	5f                   	pop    %edi
80102c46:	5d                   	pop    %ebp
80102c47:	c3                   	ret    

80102c48 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c48:	55                   	push   %ebp
80102c49:	89 e5                	mov    %esp,%ebp
80102c4b:	57                   	push   %edi
80102c4c:	56                   	push   %esi
80102c4d:	53                   	push   %ebx
80102c4e:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c51:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c58:	c1 e0 08             	shl    $0x8,%eax
80102c5b:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c62:	09 d0                	or     %edx,%eax
80102c64:	c1 e0 04             	shl    $0x4,%eax
80102c67:	85 c0                	test   %eax,%eax
80102c69:	0f 84 b0 00 00 00    	je     80102d1f <mpinit+0xd7>
    if((mp = mpsearch1(p, 1024)))
80102c6f:	ba 00 04 00 00       	mov    $0x400,%edx
80102c74:	e8 6e ff ff ff       	call   80102be7 <mpsearch1>
80102c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c7c:	85 c0                	test   %eax,%eax
80102c7e:	0f 84 cb 00 00 00    	je     80102d4f <mpinit+0x107>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102c87:	8b 58 04             	mov    0x4(%eax),%ebx
80102c8a:	85 db                	test   %ebx,%ebx
80102c8c:	0f 84 d7 00 00 00    	je     80102d69 <mpinit+0x121>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c92:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c98:	83 ec 04             	sub    $0x4,%esp
80102c9b:	6a 04                	push   $0x4
80102c9d:	68 7d 6d 10 80       	push   $0x80106d7d
80102ca2:	56                   	push   %esi
80102ca3:	e8 e4 11 00 00       	call   80103e8c <memcmp>
80102ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102cab:	83 c4 10             	add    $0x10,%esp
80102cae:	85 c0                	test   %eax,%eax
80102cb0:	0f 85 b3 00 00 00    	jne    80102d69 <mpinit+0x121>
  if(conf->version != 1 && conf->version != 4)
80102cb6:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102cbd:	3c 01                	cmp    $0x1,%al
80102cbf:	74 08                	je     80102cc9 <mpinit+0x81>
80102cc1:	3c 04                	cmp    $0x4,%al
80102cc3:	0f 85 a0 00 00 00    	jne    80102d69 <mpinit+0x121>
  if(sum((uchar*)conf, conf->length) != 0)
80102cc9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80102cd0:	66 85 d2             	test   %dx,%dx
80102cd3:	74 1f                	je     80102cf4 <mpinit+0xac>
80102cd5:	89 f0                	mov    %esi,%eax
80102cd7:	0f b7 d2             	movzwl %dx,%edx
80102cda:	8d bc 13 00 00 00 80 	lea    -0x80000000(%ebx,%edx,1),%edi
  sum = 0;
80102ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    sum += addr[i];
80102ce4:	0f b6 08             	movzbl (%eax),%ecx
80102ce7:	01 ca                	add    %ecx,%edx
80102ce9:	83 c0 01             	add    $0x1,%eax
  for(i=0; i<len; i++)
80102cec:	39 c7                	cmp    %eax,%edi
80102cee:	75 f4                	jne    80102ce4 <mpinit+0x9c>
  if(sum((uchar*)conf, conf->length) != 0)
80102cf0:	84 d2                	test   %dl,%dl
80102cf2:	75 75                	jne    80102d69 <mpinit+0x121>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102cf4:	85 f6                	test   %esi,%esi
80102cf6:	74 71                	je     80102d69 <mpinit+0x121>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102cf8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102cfe:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d03:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102d09:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102d10:	01 d6                	add    %edx,%esi
  ismp = 1;
80102d12:	b9 01 00 00 00       	mov    $0x1,%ecx
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80102d17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d1a:	e9 88 00 00 00       	jmp    80102da7 <mpinit+0x15f>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102d1f:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102d26:	c1 e0 08             	shl    $0x8,%eax
80102d29:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102d30:	09 d0                	or     %edx,%eax
80102d32:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102d35:	2d 00 04 00 00       	sub    $0x400,%eax
80102d3a:	ba 00 04 00 00       	mov    $0x400,%edx
80102d3f:	e8 a3 fe ff ff       	call   80102be7 <mpsearch1>
80102d44:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d47:	85 c0                	test   %eax,%eax
80102d49:	0f 85 35 ff ff ff    	jne    80102c84 <mpinit+0x3c>
  return mpsearch1(0xF0000, 0x10000);
80102d4f:	ba 00 00 01 00       	mov    $0x10000,%edx
80102d54:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102d59:	e8 89 fe ff ff       	call   80102be7 <mpsearch1>
80102d5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102d61:	85 c0                	test   %eax,%eax
80102d63:	0f 85 1b ff ff ff    	jne    80102c84 <mpinit+0x3c>
    panic("Expect to run on an SMP");
80102d69:	83 ec 0c             	sub    $0xc,%esp
80102d6c:	68 82 6d 10 80       	push   $0x80106d82
80102d71:	e8 ce d5 ff ff       	call   80100344 <panic>
      ismp = 0;
80102d76:	89 f9                	mov    %edi,%ecx
80102d78:	eb 34                	jmp    80102dae <mpinit+0x166>
      if(ncpu < NCPU) {
80102d7a:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102d80:	83 fa 07             	cmp    $0x7,%edx
80102d83:	7f 1f                	jg     80102da4 <mpinit+0x15c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d85:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102d88:	69 da b0 00 00 00    	imul   $0xb0,%edx,%ebx
80102d8e:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d92:	88 93 80 27 11 80    	mov    %dl,-0x7feed880(%ebx)
        ncpu++;
80102d98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102d9b:	83 c2 01             	add    $0x1,%edx
80102d9e:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
80102da4:	83 c0 14             	add    $0x14,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102da7:	39 f0                	cmp    %esi,%eax
80102da9:	73 26                	jae    80102dd1 <mpinit+0x189>
    switch(*p){
80102dab:	0f b6 10             	movzbl (%eax),%edx
80102dae:	80 fa 04             	cmp    $0x4,%dl
80102db1:	77 c3                	ja     80102d76 <mpinit+0x12e>
80102db3:	0f b6 d2             	movzbl %dl,%edx
80102db6:	ff 24 95 bc 6d 10 80 	jmp    *-0x7fef9244(,%edx,4)
      ioapicid = ioapic->apicno;
80102dbd:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102dc1:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
80102dc7:	83 c0 08             	add    $0x8,%eax
      continue;
80102dca:	eb db                	jmp    80102da7 <mpinit+0x15f>
      p += 8;
80102dcc:	83 c0 08             	add    $0x8,%eax
      continue;
80102dcf:	eb d6                	jmp    80102da7 <mpinit+0x15f>
      break;
    }
  }
  if(!ismp)
80102dd1:	85 c9                	test   %ecx,%ecx
80102dd3:	74 26                	je     80102dfb <mpinit+0x1b3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102dd8:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102ddc:	74 15                	je     80102df3 <mpinit+0x1ab>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dde:	b8 70 00 00 00       	mov    $0x70,%eax
80102de3:	ba 22 00 00 00       	mov    $0x22,%edx
80102de8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de9:	ba 23 00 00 00       	mov    $0x23,%edx
80102dee:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102def:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df2:	ee                   	out    %al,(%dx)
  }
}
80102df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df6:	5b                   	pop    %ebx
80102df7:	5e                   	pop    %esi
80102df8:	5f                   	pop    %edi
80102df9:	5d                   	pop    %ebp
80102dfa:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102dfb:	83 ec 0c             	sub    $0xc,%esp
80102dfe:	68 9c 6d 10 80       	push   $0x80106d9c
80102e03:	e8 3c d5 ff ff       	call   80100344 <panic>

80102e08 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102e08:	55                   	push   %ebp
80102e09:	89 e5                	mov    %esp,%ebp
80102e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e10:	ba 21 00 00 00       	mov    $0x21,%edx
80102e15:	ee                   	out    %al,(%dx)
80102e16:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e1b:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e1c:	5d                   	pop    %ebp
80102e1d:	c3                   	ret    

80102e1e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e1e:	55                   	push   %ebp
80102e1f:	89 e5                	mov    %esp,%ebp
80102e21:	57                   	push   %edi
80102e22:	56                   	push   %esi
80102e23:	53                   	push   %ebx
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e2d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e33:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e39:	e8 67 de ff ff       	call   80100ca5 <filealloc>
80102e3e:	89 03                	mov    %eax,(%ebx)
80102e40:	85 c0                	test   %eax,%eax
80102e42:	0f 84 a9 00 00 00    	je     80102ef1 <pipealloc+0xd3>
80102e48:	e8 58 de ff ff       	call   80100ca5 <filealloc>
80102e4d:	89 06                	mov    %eax,(%esi)
80102e4f:	85 c0                	test   %eax,%eax
80102e51:	0f 84 88 00 00 00    	je     80102edf <pipealloc+0xc1>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e57:	e8 3f f3 ff ff       	call   8010219b <kalloc>
80102e5c:	89 c7                	mov    %eax,%edi
80102e5e:	85 c0                	test   %eax,%eax
80102e60:	75 0b                	jne    80102e6d <pipealloc+0x4f>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e62:	8b 03                	mov    (%ebx),%eax
80102e64:	85 c0                	test   %eax,%eax
80102e66:	75 7d                	jne    80102ee5 <pipealloc+0xc7>
80102e68:	e9 84 00 00 00       	jmp    80102ef1 <pipealloc+0xd3>
  p->readopen = 1;
80102e6d:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e74:	00 00 00 
  p->writeopen = 1;
80102e77:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e7e:	00 00 00 
  p->nwrite = 0;
80102e81:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e88:	00 00 00 
  p->nread = 0;
80102e8b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e92:	00 00 00 
  initlock(&p->lock, "pipe");
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	68 d0 6d 10 80       	push   $0x80106dd0
80102e9d:	50                   	push   %eax
80102e9e:	e8 af 0d 00 00       	call   80103c52 <initlock>
  (*f0)->type = FD_PIPE;
80102ea3:	8b 03                	mov    (%ebx),%eax
80102ea5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102eab:	8b 03                	mov    (%ebx),%eax
80102ead:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102eb1:	8b 03                	mov    (%ebx),%eax
80102eb3:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102eb7:	8b 03                	mov    (%ebx),%eax
80102eb9:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ebc:	8b 06                	mov    (%esi),%eax
80102ebe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102ec4:	8b 06                	mov    (%esi),%eax
80102ec6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102eca:	8b 06                	mov    (%esi),%eax
80102ecc:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102ed0:	8b 06                	mov    (%esi),%eax
80102ed2:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102ed5:	83 c4 10             	add    $0x10,%esp
80102ed8:	b8 00 00 00 00       	mov    $0x0,%eax
80102edd:	eb 2e                	jmp    80102f0d <pipealloc+0xef>
  if(*f0)
80102edf:	8b 03                	mov    (%ebx),%eax
80102ee1:	85 c0                	test   %eax,%eax
80102ee3:	74 30                	je     80102f15 <pipealloc+0xf7>
    fileclose(*f0);
80102ee5:	83 ec 0c             	sub    $0xc,%esp
80102ee8:	50                   	push   %eax
80102ee9:	e8 69 de ff ff       	call   80100d57 <fileclose>
80102eee:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102ef1:	8b 16                	mov    (%esi),%edx
    fileclose(*f1);
  return -1;
80102ef3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(*f1)
80102ef8:	85 d2                	test   %edx,%edx
80102efa:	74 11                	je     80102f0d <pipealloc+0xef>
    fileclose(*f1);
80102efc:	83 ec 0c             	sub    $0xc,%esp
80102eff:	52                   	push   %edx
80102f00:	e8 52 de ff ff       	call   80100d57 <fileclose>
80102f05:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f10:	5b                   	pop    %ebx
80102f11:	5e                   	pop    %esi
80102f12:	5f                   	pop    %edi
80102f13:	5d                   	pop    %ebp
80102f14:	c3                   	ret    
  return -1;
80102f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f1a:	eb f1                	jmp    80102f0d <pipealloc+0xef>

80102f1c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f1c:	55                   	push   %ebp
80102f1d:	89 e5                	mov    %esp,%ebp
80102f1f:	53                   	push   %ebx
80102f20:	83 ec 10             	sub    $0x10,%esp
80102f23:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102f26:	53                   	push   %ebx
80102f27:	e8 6e 0e 00 00       	call   80103d9a <acquire>
  if(writable){
80102f2c:	83 c4 10             	add    $0x10,%esp
80102f2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102f33:	74 3f                	je     80102f74 <pipeclose+0x58>
    p->writeopen = 0;
80102f35:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f3c:	00 00 00 
    wakeup(&p->nread);
80102f3f:	83 ec 0c             	sub    $0xc,%esp
80102f42:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f48:	50                   	push   %eax
80102f49:	e8 81 0a 00 00       	call   801039cf <wakeup>
80102f4e:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f51:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f58:	75 09                	jne    80102f63 <pipeclose+0x47>
80102f5a:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f61:	74 2f                	je     80102f92 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f63:	83 ec 0c             	sub    $0xc,%esp
80102f66:	53                   	push   %ebx
80102f67:	e8 95 0e 00 00       	call   80103e01 <release>
80102f6c:	83 c4 10             	add    $0x10,%esp
}
80102f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f72:	c9                   	leave  
80102f73:	c3                   	ret    
    p->readopen = 0;
80102f74:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f7b:	00 00 00 
    wakeup(&p->nwrite);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f87:	50                   	push   %eax
80102f88:	e8 42 0a 00 00       	call   801039cf <wakeup>
80102f8d:	83 c4 10             	add    $0x10,%esp
80102f90:	eb bf                	jmp    80102f51 <pipeclose+0x35>
    release(&p->lock);
80102f92:	83 ec 0c             	sub    $0xc,%esp
80102f95:	53                   	push   %ebx
80102f96:	e8 66 0e 00 00       	call   80103e01 <release>
    kfree((char*)p);
80102f9b:	89 1c 24             	mov    %ebx,(%esp)
80102f9e:	e8 d3 f0 ff ff       	call   80102076 <kfree>
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	eb c7                	jmp    80102f6f <pipeclose+0x53>

80102fa8 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102fa8:	55                   	push   %ebp
80102fa9:	89 e5                	mov    %esp,%ebp
80102fab:	57                   	push   %edi
80102fac:	56                   	push   %esi
80102fad:	53                   	push   %ebx
80102fae:	83 ec 28             	sub    $0x28,%esp
80102fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fb4:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80102fb7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102fba:	53                   	push   %ebx
80102fbb:	e8 da 0d 00 00       	call   80103d9a <acquire>
  for(i = 0; i < n; i++){
80102fc0:	83 c4 10             	add    $0x10,%esp
80102fc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102fc7:	0f 8e b5 00 00 00    	jle    80103082 <pipewrite+0xda>
80102fcd:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102fd0:	03 75 10             	add    0x10(%ebp),%esi
80102fd3:	89 75 dc             	mov    %esi,-0x24(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102fd6:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fdc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fe2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fe8:	05 00 02 00 00       	add    $0x200,%eax
80102fed:	39 c2                	cmp    %eax,%edx
80102fef:	75 69                	jne    8010305a <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80102ff1:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ff8:	74 47                	je     80103041 <pipewrite+0x99>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102ffa:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
      if(p->readopen == 0 || myproc()->killed){
80103000:	e8 71 03 00 00       	call   80103376 <myproc>
80103005:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80103009:	75 36                	jne    80103041 <pipewrite+0x99>
      wakeup(&p->nread);
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	57                   	push   %edi
8010300f:	e8 bb 09 00 00       	call   801039cf <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103014:	83 c4 08             	add    $0x8,%esp
80103017:	ff 75 e4             	pushl  -0x1c(%ebp)
8010301a:	56                   	push   %esi
8010301b:	e8 01 08 00 00       	call   80103821 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103020:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103026:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010302c:	05 00 02 00 00       	add    $0x200,%eax
80103031:	83 c4 10             	add    $0x10,%esp
80103034:	39 c2                	cmp    %eax,%edx
80103036:	75 22                	jne    8010305a <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80103038:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
8010303f:	75 bf                	jne    80103000 <pipewrite+0x58>
        release(&p->lock);
80103041:	83 ec 0c             	sub    $0xc,%esp
80103044:	53                   	push   %ebx
80103045:	e8 b7 0d 00 00       	call   80103e01 <release>
        return -1;
8010304a:	83 c4 10             	add    $0x10,%esp
8010304d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103052:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103055:	5b                   	pop    %ebx
80103056:	5e                   	pop    %esi
80103057:	5f                   	pop    %edi
80103058:	5d                   	pop    %ebp
80103059:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010305a:	8d 42 01             	lea    0x1(%edx),%eax
8010305d:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103063:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103066:	0f b6 01             	movzbl (%ecx),%eax
80103069:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010306f:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
80103073:	83 c1 01             	add    $0x1,%ecx
80103076:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(i = 0; i < n; i++){
80103079:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
8010307c:	0f 85 5a ff ff ff    	jne    80102fdc <pipewrite+0x34>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103082:	83 ec 0c             	sub    $0xc,%esp
80103085:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010308b:	50                   	push   %eax
8010308c:	e8 3e 09 00 00       	call   801039cf <wakeup>
  release(&p->lock);
80103091:	89 1c 24             	mov    %ebx,(%esp)
80103094:	e8 68 0d 00 00       	call   80103e01 <release>
  return n;
80103099:	83 c4 10             	add    $0x10,%esp
8010309c:	8b 45 10             	mov    0x10(%ebp),%eax
8010309f:	eb b1                	jmp    80103052 <pipewrite+0xaa>

801030a1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801030a1:	55                   	push   %ebp
801030a2:	89 e5                	mov    %esp,%ebp
801030a4:	57                   	push   %edi
801030a5:	56                   	push   %esi
801030a6:	53                   	push   %ebx
801030a7:	83 ec 18             	sub    $0x18,%esp
801030aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801030ad:	53                   	push   %ebx
801030ae:	e8 e7 0c 00 00       	call   80103d9a <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030b3:	83 c4 10             	add    $0x10,%esp
801030b6:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030bc:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030c2:	75 7c                	jne    80103140 <piperead+0x9f>
801030c4:	89 de                	mov    %ebx,%esi
801030c6:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
801030cd:	74 35                	je     80103104 <piperead+0x63>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030cf:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    if(myproc()->killed){
801030d5:	e8 9c 02 00 00       	call   80103376 <myproc>
801030da:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801030de:	75 4d                	jne    8010312d <piperead+0x8c>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030e0:	83 ec 08             	sub    $0x8,%esp
801030e3:	56                   	push   %esi
801030e4:	57                   	push   %edi
801030e5:	e8 37 07 00 00       	call   80103821 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030ea:	83 c4 10             	add    $0x10,%esp
801030ed:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030f3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030f9:	75 45                	jne    80103140 <piperead+0x9f>
801030fb:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80103102:	75 d1                	jne    801030d5 <piperead+0x34>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103104:	be 00 00 00 00       	mov    $0x0,%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103109:	83 ec 0c             	sub    $0xc,%esp
8010310c:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103112:	50                   	push   %eax
80103113:	e8 b7 08 00 00       	call   801039cf <wakeup>
  release(&p->lock);
80103118:	89 1c 24             	mov    %ebx,(%esp)
8010311b:	e8 e1 0c 00 00       	call   80103e01 <release>
  return i;
80103120:	83 c4 10             	add    $0x10,%esp
}
80103123:	89 f0                	mov    %esi,%eax
80103125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103128:	5b                   	pop    %ebx
80103129:	5e                   	pop    %esi
8010312a:	5f                   	pop    %edi
8010312b:	5d                   	pop    %ebp
8010312c:	c3                   	ret    
      release(&p->lock);
8010312d:	83 ec 0c             	sub    $0xc,%esp
80103130:	53                   	push   %ebx
80103131:	e8 cb 0c 00 00       	call   80103e01 <release>
      return -1;
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010313e:	eb e3                	jmp    80103123 <piperead+0x82>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103140:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103144:	7e 3c                	jle    80103182 <piperead+0xe1>
    if(p->nread == p->nwrite)
80103146:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010314c:	be 00 00 00 00       	mov    $0x0,%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103151:	8d 50 01             	lea    0x1(%eax),%edx
80103154:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
8010315a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010315f:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103164:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103167:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010316a:	83 c6 01             	add    $0x1,%esi
8010316d:	39 75 10             	cmp    %esi,0x10(%ebp)
80103170:	74 97                	je     80103109 <piperead+0x68>
    if(p->nread == p->nwrite)
80103172:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103178:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010317e:	75 d1                	jne    80103151 <piperead+0xb0>
80103180:	eb 87                	jmp    80103109 <piperead+0x68>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103182:	be 00 00 00 00       	mov    $0x0,%esi
80103187:	eb 80                	jmp    80103109 <piperead+0x68>

80103189 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103189:	55                   	push   %ebp
8010318a:	89 e5                	mov    %esp,%ebp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010318c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103191:	eb 0e                	jmp    801031a1 <wakeup1+0x18>
80103193:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103199:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
8010319f:	73 14                	jae    801031b5 <wakeup1+0x2c>
    if(p->state == SLEEPING && p->chan == chan)
801031a1:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801031a5:	75 ec                	jne    80103193 <wakeup1+0xa>
801031a7:	39 42 20             	cmp    %eax,0x20(%edx)
801031aa:	75 e7                	jne    80103193 <wakeup1+0xa>
      p->state = RUNNABLE;
801031ac:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
801031b3:	eb de                	jmp    80103193 <wakeup1+0xa>
}
801031b5:	5d                   	pop    %ebp
801031b6:	c3                   	ret    

801031b7 <allocproc>:
{
801031b7:	55                   	push   %ebp
801031b8:	89 e5                	mov    %esp,%ebp
801031ba:	53                   	push   %ebx
801031bb:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801031be:	68 20 2d 11 80       	push   $0x80112d20
801031c3:	e8 d2 0b 00 00       	call   80103d9a <acquire>
    if(p->state == UNUSED)
801031c8:	83 c4 10             	add    $0x10,%esp
801031cb:	83 3d 60 2d 11 80 00 	cmpl   $0x0,0x80112d60
801031d2:	74 30                	je     80103204 <allocproc+0x4d>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031d4:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
    if(p->state == UNUSED)
801031d9:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801031dd:	74 2a                	je     80103209 <allocproc+0x52>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031df:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801031e5:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801031eb:	72 ec                	jb     801031d9 <allocproc+0x22>
  release(&ptable.lock);
801031ed:	83 ec 0c             	sub    $0xc,%esp
801031f0:	68 20 2d 11 80       	push   $0x80112d20
801031f5:	e8 07 0c 00 00       	call   80103e01 <release>
  return 0;
801031fa:	83 c4 10             	add    $0x10,%esp
801031fd:	bb 00 00 00 00       	mov    $0x0,%ebx
80103202:	eb 6e                	jmp    80103272 <allocproc+0xbb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103204:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  p->state = EMBRYO;
80103209:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103210:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103215:	8d 50 01             	lea    0x1(%eax),%edx
80103218:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010321e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103221:	83 ec 0c             	sub    $0xc,%esp
80103224:	68 20 2d 11 80       	push   $0x80112d20
80103229:	e8 d3 0b 00 00       	call   80103e01 <release>
  if((p->kstack = kalloc()) == 0){
8010322e:	e8 68 ef ff ff       	call   8010219b <kalloc>
80103233:	89 43 08             	mov    %eax,0x8(%ebx)
80103236:	83 c4 10             	add    $0x10,%esp
80103239:	85 c0                	test   %eax,%eax
8010323b:	74 3c                	je     80103279 <allocproc+0xc2>
  sp -= sizeof *p->tf;
8010323d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103243:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103246:	c7 80 b0 0f 00 00 64 	movl   $0x80104f64,0xfb0(%eax)
8010324d:	4f 10 80 
  sp -= sizeof *p->context;
80103250:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103255:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103258:	83 ec 04             	sub    $0x4,%esp
8010325b:	6a 14                	push   $0x14
8010325d:	6a 00                	push   $0x0
8010325f:	50                   	push   %eax
80103260:	e8 e3 0b 00 00       	call   80103e48 <memset>
  p->context->eip = (uint)forkret;
80103265:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103268:	c7 40 10 87 32 10 80 	movl   $0x80103287,0x10(%eax)
  return p;
8010326f:	83 c4 10             	add    $0x10,%esp
}
80103272:	89 d8                	mov    %ebx,%eax
80103274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103277:	c9                   	leave  
80103278:	c3                   	ret    
    p->state = UNUSED;
80103279:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103280:	bb 00 00 00 00       	mov    $0x0,%ebx
80103285:	eb eb                	jmp    80103272 <allocproc+0xbb>

80103287 <forkret>:
{
80103287:	55                   	push   %ebp
80103288:	89 e5                	mov    %esp,%ebp
8010328a:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
8010328d:	68 20 2d 11 80       	push   $0x80112d20
80103292:	e8 6a 0b 00 00       	call   80103e01 <release>
  if (first) {
80103297:	83 c4 10             	add    $0x10,%esp
8010329a:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
801032a1:	75 02                	jne    801032a5 <forkret+0x1e>
}
801032a3:	c9                   	leave  
801032a4:	c3                   	ret    
    first = 0;
801032a5:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801032ac:	00 00 00 
    iinit(ROOTDEV);
801032af:	83 ec 0c             	sub    $0xc,%esp
801032b2:	6a 01                	push   $0x1
801032b4:	e8 8a e0 ff ff       	call   80101343 <iinit>
    initlog(ROOTDEV);
801032b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801032c0:	e8 90 f4 ff ff       	call   80102755 <initlog>
801032c5:	83 c4 10             	add    $0x10,%esp
}
801032c8:	eb d9                	jmp    801032a3 <forkret+0x1c>

801032ca <pinit>:
{
801032ca:	55                   	push   %ebp
801032cb:	89 e5                	mov    %esp,%ebp
801032cd:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801032d0:	68 d5 6d 10 80       	push   $0x80106dd5
801032d5:	68 20 2d 11 80       	push   $0x80112d20
801032da:	e8 73 09 00 00       	call   80103c52 <initlock>
}
801032df:	83 c4 10             	add    $0x10,%esp
801032e2:	c9                   	leave  
801032e3:	c3                   	ret    

801032e4 <mycpu>:
{
801032e4:	55                   	push   %ebp
801032e5:	89 e5                	mov    %esp,%ebp
801032e7:	56                   	push   %esi
801032e8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032e9:	9c                   	pushf  
801032ea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801032eb:	f6 c4 02             	test   $0x2,%ah
801032ee:	75 4a                	jne    8010333a <mycpu+0x56>
  apicid = lapicid();
801032f0:	e8 88 f1 ff ff       	call   8010247d <lapicid>
  for (i = 0; i < ncpu; ++i) {
801032f5:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801032fb:	85 f6                	test   %esi,%esi
801032fd:	7e 4f                	jle    8010334e <mycpu+0x6a>
    if (cpus[i].apicid == apicid)
801032ff:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103306:	39 d0                	cmp    %edx,%eax
80103308:	74 3d                	je     80103347 <mycpu+0x63>
8010330a:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010330f:	ba 00 00 00 00       	mov    $0x0,%edx
80103314:	83 c2 01             	add    $0x1,%edx
80103317:	39 f2                	cmp    %esi,%edx
80103319:	74 33                	je     8010334e <mycpu+0x6a>
    if (cpus[i].apicid == apicid)
8010331b:	0f b6 19             	movzbl (%ecx),%ebx
8010331e:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103324:	39 c3                	cmp    %eax,%ebx
80103326:	75 ec                	jne    80103314 <mycpu+0x30>
      return &cpus[i];
80103328:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010332e:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103333:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103336:	5b                   	pop    %ebx
80103337:	5e                   	pop    %esi
80103338:	5d                   	pop    %ebp
80103339:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
8010333a:	83 ec 0c             	sub    $0xc,%esp
8010333d:	68 b8 6e 10 80       	push   $0x80106eb8
80103342:	e8 fd cf ff ff       	call   80100344 <panic>
  for (i = 0; i < ncpu; ++i) {
80103347:	ba 00 00 00 00       	mov    $0x0,%edx
8010334c:	eb da                	jmp    80103328 <mycpu+0x44>
  panic("unknown apicid\n");
8010334e:	83 ec 0c             	sub    $0xc,%esp
80103351:	68 dc 6d 10 80       	push   $0x80106ddc
80103356:	e8 e9 cf ff ff       	call   80100344 <panic>

8010335b <cpuid>:
cpuid() {
8010335b:	55                   	push   %ebp
8010335c:	89 e5                	mov    %esp,%ebp
8010335e:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103361:	e8 7e ff ff ff       	call   801032e4 <mycpu>
80103366:	2d 80 27 11 80       	sub    $0x80112780,%eax
8010336b:	c1 f8 04             	sar    $0x4,%eax
8010336e:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103374:	c9                   	leave  
80103375:	c3                   	ret    

80103376 <myproc>:
myproc(void) {
80103376:	55                   	push   %ebp
80103377:	89 e5                	mov    %esp,%ebp
80103379:	53                   	push   %ebx
8010337a:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010337d:	e8 47 09 00 00       	call   80103cc9 <pushcli>
  c = mycpu();
80103382:	e8 5d ff ff ff       	call   801032e4 <mycpu>
  p = c->proc;
80103387:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010338d:	e8 74 09 00 00       	call   80103d06 <popcli>
}
80103392:	89 d8                	mov    %ebx,%eax
80103394:	83 c4 04             	add    $0x4,%esp
80103397:	5b                   	pop    %ebx
80103398:	5d                   	pop    %ebp
80103399:	c3                   	ret    

8010339a <userinit>:
{
8010339a:	55                   	push   %ebp
8010339b:	89 e5                	mov    %esp,%ebp
8010339d:	53                   	push   %ebx
8010339e:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801033a1:	e8 11 fe ff ff       	call   801031b7 <allocproc>
801033a6:	89 c3                	mov    %eax,%ebx
  initproc = p;
801033a8:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801033ad:	e8 22 30 00 00       	call   801063d4 <setupkvm>
801033b2:	89 43 04             	mov    %eax,0x4(%ebx)
801033b5:	85 c0                	test   %eax,%eax
801033b7:	0f 84 b7 00 00 00    	je     80103474 <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801033bd:	83 ec 04             	sub    $0x4,%esp
801033c0:	68 2c 00 00 00       	push   $0x2c
801033c5:	68 60 a4 10 80       	push   $0x8010a460
801033ca:	50                   	push   %eax
801033cb:	e8 fd 2c 00 00       	call   801060cd <inituvm>
  p->sz = PGSIZE;
801033d0:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801033d6:	83 c4 0c             	add    $0xc,%esp
801033d9:	6a 4c                	push   $0x4c
801033db:	6a 00                	push   $0x0
801033dd:	ff 73 18             	pushl  0x18(%ebx)
801033e0:	e8 63 0a 00 00       	call   80103e48 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033e5:	8b 43 18             	mov    0x18(%ebx),%eax
801033e8:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033ee:	8b 43 18             	mov    0x18(%ebx),%eax
801033f1:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033f7:	8b 43 18             	mov    0x18(%ebx),%eax
801033fa:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033fe:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103402:	8b 43 18             	mov    0x18(%ebx),%eax
80103405:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103409:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010340d:	8b 43 18             	mov    0x18(%ebx),%eax
80103410:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103417:	8b 43 18             	mov    0x18(%ebx),%eax
8010341a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103421:	8b 43 18             	mov    0x18(%ebx),%eax
80103424:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010342b:	83 c4 0c             	add    $0xc,%esp
8010342e:	6a 10                	push   $0x10
80103430:	68 05 6e 10 80       	push   $0x80106e05
80103435:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103438:	50                   	push   %eax
80103439:	e8 99 0b 00 00       	call   80103fd7 <safestrcpy>
  p->cwd = namei("/");
8010343e:	c7 04 24 0e 6e 10 80 	movl   $0x80106e0e,(%esp)
80103445:	e8 76 e8 ff ff       	call   80101cc0 <namei>
8010344a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010344d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103454:	e8 41 09 00 00       	call   80103d9a <acquire>
  p->state = RUNNABLE;
80103459:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103460:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103467:	e8 95 09 00 00       	call   80103e01 <release>
}
8010346c:	83 c4 10             	add    $0x10,%esp
8010346f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103472:	c9                   	leave  
80103473:	c3                   	ret    
    panic("userinit: out of memory?");
80103474:	83 ec 0c             	sub    $0xc,%esp
80103477:	68 ec 6d 10 80       	push   $0x80106dec
8010347c:	e8 c3 ce ff ff       	call   80100344 <panic>

80103481 <growproc>:
{
80103481:	55                   	push   %ebp
80103482:	89 e5                	mov    %esp,%ebp
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103489:	e8 e8 fe ff ff       	call   80103376 <myproc>
8010348e:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103490:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103492:	85 f6                	test   %esi,%esi
80103494:	7f 21                	jg     801034b7 <growproc+0x36>
  } else if(n < 0){
80103496:	85 f6                	test   %esi,%esi
80103498:	79 33                	jns    801034cd <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010349a:	83 ec 04             	sub    $0x4,%esp
8010349d:	01 c6                	add    %eax,%esi
8010349f:	56                   	push   %esi
801034a0:	50                   	push   %eax
801034a1:	ff 73 04             	pushl  0x4(%ebx)
801034a4:	e8 3a 2d 00 00       	call   801061e3 <deallocuvm>
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	85 c0                	test   %eax,%eax
801034ae:	75 1d                	jne    801034cd <growproc+0x4c>
      return -1;
801034b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034b5:	eb 29                	jmp    801034e0 <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034b7:	83 ec 04             	sub    $0x4,%esp
801034ba:	01 c6                	add    %eax,%esi
801034bc:	56                   	push   %esi
801034bd:	50                   	push   %eax
801034be:	ff 73 04             	pushl  0x4(%ebx)
801034c1:	e8 ac 2d 00 00       	call   80106272 <allocuvm>
801034c6:	83 c4 10             	add    $0x10,%esp
801034c9:	85 c0                	test   %eax,%eax
801034cb:	74 1a                	je     801034e7 <growproc+0x66>
  curproc->sz = sz;
801034cd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801034cf:	83 ec 0c             	sub    $0xc,%esp
801034d2:	53                   	push   %ebx
801034d3:	e8 f7 2a 00 00       	call   80105fcf <switchuvm>
  return 0;
801034d8:	83 c4 10             	add    $0x10,%esp
801034db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801034e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034e3:	5b                   	pop    %ebx
801034e4:	5e                   	pop    %esi
801034e5:	5d                   	pop    %ebp
801034e6:	c3                   	ret    
      return -1;
801034e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034ec:	eb f2                	jmp    801034e0 <growproc+0x5f>

801034ee <fork>:
{
801034ee:	55                   	push   %ebp
801034ef:	89 e5                	mov    %esp,%ebp
801034f1:	57                   	push   %edi
801034f2:	56                   	push   %esi
801034f3:	53                   	push   %ebx
801034f4:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801034f7:	e8 7a fe ff ff       	call   80103376 <myproc>
801034fc:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801034fe:	e8 b4 fc ff ff       	call   801031b7 <allocproc>
80103503:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103506:	89 c7                	mov    %eax,%edi
80103508:	85 c0                	test   %eax,%eax
8010350a:	0f 84 dd 00 00 00    	je     801035ed <fork+0xff>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, np, curproc)) == 0){
80103510:	53                   	push   %ebx
80103511:	50                   	push   %eax
80103512:	ff 33                	pushl  (%ebx)
80103514:	ff 73 04             	pushl  0x4(%ebx)
80103517:	e8 69 2f 00 00       	call   80106485 <copyuvm>
8010351c:	89 47 04             	mov    %eax,0x4(%edi)
8010351f:	83 c4 10             	add    $0x10,%esp
80103522:	85 c0                	test   %eax,%eax
80103524:	74 2a                	je     80103550 <fork+0x62>
  np->sz = curproc->sz;
80103526:	8b 03                	mov    (%ebx),%eax
80103528:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010352b:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010352d:	89 c8                	mov    %ecx,%eax
8010352f:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103532:	8b 73 18             	mov    0x18(%ebx),%esi
80103535:	8b 79 18             	mov    0x18(%ecx),%edi
80103538:	b9 13 00 00 00       	mov    $0x13,%ecx
8010353d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
8010353f:	8b 40 18             	mov    0x18(%eax),%eax
80103542:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103549:	be 00 00 00 00       	mov    $0x0,%esi
8010354e:	eb 2e                	jmp    8010357e <fork+0x90>
    kfree(np->kstack);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103556:	ff 77 08             	pushl  0x8(%edi)
80103559:	e8 18 eb ff ff       	call   80102076 <kfree>
    np->kstack = 0;
8010355e:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103565:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
8010356c:	83 c4 10             	add    $0x10,%esp
8010356f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103574:	eb 6d                	jmp    801035e3 <fork+0xf5>
  for(i = 0; i < NOFILE; i++)
80103576:	83 c6 01             	add    $0x1,%esi
80103579:	83 fe 10             	cmp    $0x10,%esi
8010357c:	74 1d                	je     8010359b <fork+0xad>
    if(curproc->ofile[i])
8010357e:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103582:	85 c0                	test   %eax,%eax
80103584:	74 f0                	je     80103576 <fork+0x88>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	50                   	push   %eax
8010358a:	e8 83 d7 ff ff       	call   80100d12 <filedup>
8010358f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103592:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103596:	83 c4 10             	add    $0x10,%esp
80103599:	eb db                	jmp    80103576 <fork+0x88>
  np->cwd = idup(curproc->cwd);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	ff 73 68             	pushl  0x68(%ebx)
801035a1:	e8 52 df ff ff       	call   801014f8 <idup>
801035a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801035a9:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801035ac:	83 c4 0c             	add    $0xc,%esp
801035af:	6a 10                	push   $0x10
801035b1:	83 c3 6c             	add    $0x6c,%ebx
801035b4:	53                   	push   %ebx
801035b5:	8d 47 6c             	lea    0x6c(%edi),%eax
801035b8:	50                   	push   %eax
801035b9:	e8 19 0a 00 00       	call   80103fd7 <safestrcpy>
  pid = np->pid;
801035be:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801035c1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035c8:	e8 cd 07 00 00       	call   80103d9a <acquire>
  np->state = RUNNABLE;
801035cd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801035d4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035db:	e8 21 08 00 00       	call   80103e01 <release>
  return pid;
801035e0:	83 c4 10             	add    $0x10,%esp
}
801035e3:	89 d8                	mov    %ebx,%eax
801035e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e8:	5b                   	pop    %ebx
801035e9:	5e                   	pop    %esi
801035ea:	5f                   	pop    %edi
801035eb:	5d                   	pop    %ebp
801035ec:	c3                   	ret    
    return -1;
801035ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801035f2:	eb ef                	jmp    801035e3 <fork+0xf5>

801035f4 <scheduler>:
{
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	57                   	push   %edi
801035f8:	56                   	push   %esi
801035f9:	53                   	push   %ebx
801035fa:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801035fd:	e8 e2 fc ff ff       	call   801032e4 <mycpu>
80103602:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103604:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010360b:	00 00 00 
      swtch(&(c->scheduler), p->context);
8010360e:	8d 78 04             	lea    0x4(%eax),%edi
80103611:	eb 5a                	jmp    8010366d <scheduler+0x79>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103613:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103619:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010361f:	73 3c                	jae    8010365d <scheduler+0x69>
      if(p->state != RUNNABLE)
80103621:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103625:	75 ec                	jne    80103613 <scheduler+0x1f>
      c->proc = p;
80103627:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010362d:	83 ec 0c             	sub    $0xc,%esp
80103630:	53                   	push   %ebx
80103631:	e8 99 29 00 00       	call   80105fcf <switchuvm>
      p->state = RUNNING;
80103636:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010363d:	83 c4 08             	add    $0x8,%esp
80103640:	ff 73 1c             	pushl  0x1c(%ebx)
80103643:	57                   	push   %edi
80103644:	e8 e4 09 00 00       	call   8010402d <swtch>
      switchkvm();
80103649:	e8 6f 29 00 00       	call   80105fbd <switchkvm>
      c->proc = 0;
8010364e:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103655:	00 00 00 
80103658:	83 c4 10             	add    $0x10,%esp
8010365b:	eb b6                	jmp    80103613 <scheduler+0x1f>
    release(&ptable.lock);
8010365d:	83 ec 0c             	sub    $0xc,%esp
80103660:	68 20 2d 11 80       	push   $0x80112d20
80103665:	e8 97 07 00 00       	call   80103e01 <release>
    sti();
8010366a:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
8010366d:	fb                   	sti    
    acquire(&ptable.lock);
8010366e:	83 ec 0c             	sub    $0xc,%esp
80103671:	68 20 2d 11 80       	push   $0x80112d20
80103676:	e8 1f 07 00 00       	call   80103d9a <acquire>
8010367b:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010367e:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103683:	eb 9c                	jmp    80103621 <scheduler+0x2d>

80103685 <sched>:
{
80103685:	55                   	push   %ebp
80103686:	89 e5                	mov    %esp,%ebp
80103688:	56                   	push   %esi
80103689:	53                   	push   %ebx
  struct proc *p = myproc();
8010368a:	e8 e7 fc ff ff       	call   80103376 <myproc>
8010368f:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103691:	83 ec 0c             	sub    $0xc,%esp
80103694:	68 20 2d 11 80       	push   $0x80112d20
80103699:	e8 c8 06 00 00       	call   80103d66 <holding>
8010369e:	83 c4 10             	add    $0x10,%esp
801036a1:	85 c0                	test   %eax,%eax
801036a3:	74 4f                	je     801036f4 <sched+0x6f>
  if(mycpu()->ncli != 1)
801036a5:	e8 3a fc ff ff       	call   801032e4 <mycpu>
801036aa:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801036b1:	75 4e                	jne    80103701 <sched+0x7c>
  if(p->state == RUNNING)
801036b3:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801036b7:	74 55                	je     8010370e <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036b9:	9c                   	pushf  
801036ba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036bb:	f6 c4 02             	test   $0x2,%ah
801036be:	75 5b                	jne    8010371b <sched+0x96>
  intena = mycpu()->intena;
801036c0:	e8 1f fc ff ff       	call   801032e4 <mycpu>
801036c5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801036cb:	e8 14 fc ff ff       	call   801032e4 <mycpu>
801036d0:	83 ec 08             	sub    $0x8,%esp
801036d3:	ff 70 04             	pushl  0x4(%eax)
801036d6:	83 c3 1c             	add    $0x1c,%ebx
801036d9:	53                   	push   %ebx
801036da:	e8 4e 09 00 00       	call   8010402d <swtch>
  mycpu()->intena = intena;
801036df:	e8 00 fc ff ff       	call   801032e4 <mycpu>
801036e4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f0:	5b                   	pop    %ebx
801036f1:	5e                   	pop    %esi
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
    panic("sched ptable.lock");
801036f4:	83 ec 0c             	sub    $0xc,%esp
801036f7:	68 10 6e 10 80       	push   $0x80106e10
801036fc:	e8 43 cc ff ff       	call   80100344 <panic>
    panic("sched locks");
80103701:	83 ec 0c             	sub    $0xc,%esp
80103704:	68 22 6e 10 80       	push   $0x80106e22
80103709:	e8 36 cc ff ff       	call   80100344 <panic>
    panic("sched running");
8010370e:	83 ec 0c             	sub    $0xc,%esp
80103711:	68 2e 6e 10 80       	push   $0x80106e2e
80103716:	e8 29 cc ff ff       	call   80100344 <panic>
    panic("sched interruptible");
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	68 3c 6e 10 80       	push   $0x80106e3c
80103723:	e8 1c cc ff ff       	call   80100344 <panic>

80103728 <exit>:
{
80103728:	55                   	push   %ebp
80103729:	89 e5                	mov    %esp,%ebp
8010372b:	57                   	push   %edi
8010372c:	56                   	push   %esi
8010372d:	53                   	push   %ebx
8010372e:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103731:	e8 40 fc ff ff       	call   80103376 <myproc>
80103736:	89 c6                	mov    %eax,%esi
80103738:	8d 58 28             	lea    0x28(%eax),%ebx
8010373b:	8d 78 68             	lea    0x68(%eax),%edi
  if(curproc == initproc)
8010373e:	39 05 b8 a5 10 80    	cmp    %eax,0x8010a5b8
80103744:	75 14                	jne    8010375a <exit+0x32>
    panic("init exiting");
80103746:	83 ec 0c             	sub    $0xc,%esp
80103749:	68 50 6e 10 80       	push   $0x80106e50
8010374e:	e8 f1 cb ff ff       	call   80100344 <panic>
80103753:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103756:	39 df                	cmp    %ebx,%edi
80103758:	74 1a                	je     80103774 <exit+0x4c>
    if(curproc->ofile[fd]){
8010375a:	8b 03                	mov    (%ebx),%eax
8010375c:	85 c0                	test   %eax,%eax
8010375e:	74 f3                	je     80103753 <exit+0x2b>
      fileclose(curproc->ofile[fd]);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	50                   	push   %eax
80103764:	e8 ee d5 ff ff       	call   80100d57 <fileclose>
      curproc->ofile[fd] = 0;
80103769:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010376f:	83 c4 10             	add    $0x10,%esp
80103772:	eb df                	jmp    80103753 <exit+0x2b>
  begin_op();
80103774:	e8 71 f0 ff ff       	call   801027ea <begin_op>
  iput(curproc->cwd);
80103779:	83 ec 0c             	sub    $0xc,%esp
8010377c:	ff 76 68             	pushl  0x68(%esi)
8010377f:	e8 a6 de ff ff       	call   8010162a <iput>
  end_op();
80103784:	e8 dc f0 ff ff       	call   80102865 <end_op>
  curproc->cwd = 0;
80103789:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103790:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103797:	e8 fe 05 00 00       	call   80103d9a <acquire>
  wakeup1(curproc->parent);
8010379c:	8b 46 14             	mov    0x14(%esi),%eax
8010379f:	e8 e5 f9 ff ff       	call   80103189 <wakeup1>
801037a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037a7:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801037ac:	eb 0e                	jmp    801037bc <exit+0x94>
801037ae:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801037b4:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801037ba:	73 1a                	jae    801037d6 <exit+0xae>
    if(p->parent == curproc){
801037bc:	39 73 14             	cmp    %esi,0x14(%ebx)
801037bf:	75 ed                	jne    801037ae <exit+0x86>
      p->parent = initproc;
801037c1:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801037c6:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801037c9:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037cd:	75 df                	jne    801037ae <exit+0x86>
        wakeup1(initproc);
801037cf:	e8 b5 f9 ff ff       	call   80103189 <wakeup1>
801037d4:	eb d8                	jmp    801037ae <exit+0x86>
  curproc->state = ZOMBIE;
801037d6:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037dd:	e8 a3 fe ff ff       	call   80103685 <sched>
  panic("zombie exit");
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	68 5d 6e 10 80       	push   $0x80106e5d
801037ea:	e8 55 cb ff ff       	call   80100344 <panic>

801037ef <yield>:
{
801037ef:	55                   	push   %ebp
801037f0:	89 e5                	mov    %esp,%ebp
801037f2:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037f5:	68 20 2d 11 80       	push   $0x80112d20
801037fa:	e8 9b 05 00 00       	call   80103d9a <acquire>
  myproc()->state = RUNNABLE;
801037ff:	e8 72 fb ff ff       	call   80103376 <myproc>
80103804:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010380b:	e8 75 fe ff ff       	call   80103685 <sched>
  release(&ptable.lock);
80103810:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103817:	e8 e5 05 00 00       	call   80103e01 <release>
}
8010381c:	83 c4 10             	add    $0x10,%esp
8010381f:	c9                   	leave  
80103820:	c3                   	ret    

80103821 <sleep>:
{
80103821:	55                   	push   %ebp
80103822:	89 e5                	mov    %esp,%ebp
80103824:	57                   	push   %edi
80103825:	56                   	push   %esi
80103826:	53                   	push   %ebx
80103827:	83 ec 0c             	sub    $0xc,%esp
8010382a:	8b 7d 08             	mov    0x8(%ebp),%edi
8010382d:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103830:	e8 41 fb ff ff       	call   80103376 <myproc>
  if(p == 0)
80103835:	85 c0                	test   %eax,%eax
80103837:	74 58                	je     80103891 <sleep+0x70>
80103839:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
8010383b:	85 f6                	test   %esi,%esi
8010383d:	74 5f                	je     8010389e <sleep+0x7d>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010383f:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103845:	74 64                	je     801038ab <sleep+0x8a>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103847:	83 ec 0c             	sub    $0xc,%esp
8010384a:	68 20 2d 11 80       	push   $0x80112d20
8010384f:	e8 46 05 00 00       	call   80103d9a <acquire>
    release(lk);
80103854:	89 34 24             	mov    %esi,(%esp)
80103857:	e8 a5 05 00 00       	call   80103e01 <release>
  p->chan = chan;
8010385c:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010385f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103866:	e8 1a fe ff ff       	call   80103685 <sched>
  p->chan = 0;
8010386b:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103872:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103879:	e8 83 05 00 00       	call   80103e01 <release>
    acquire(lk);
8010387e:	89 34 24             	mov    %esi,(%esp)
80103881:	e8 14 05 00 00       	call   80103d9a <acquire>
80103886:	83 c4 10             	add    $0x10,%esp
}
80103889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010388c:	5b                   	pop    %ebx
8010388d:	5e                   	pop    %esi
8010388e:	5f                   	pop    %edi
8010388f:	5d                   	pop    %ebp
80103890:	c3                   	ret    
    panic("sleep");
80103891:	83 ec 0c             	sub    $0xc,%esp
80103894:	68 69 6e 10 80       	push   $0x80106e69
80103899:	e8 a6 ca ff ff       	call   80100344 <panic>
    panic("sleep without lk");
8010389e:	83 ec 0c             	sub    $0xc,%esp
801038a1:	68 6f 6e 10 80       	push   $0x80106e6f
801038a6:	e8 99 ca ff ff       	call   80100344 <panic>
  p->chan = chan;
801038ab:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
801038ae:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801038b5:	e8 cb fd ff ff       	call   80103685 <sched>
  p->chan = 0;
801038ba:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
801038c1:	eb c6                	jmp    80103889 <sleep+0x68>

801038c3 <wait>:
{
801038c3:	55                   	push   %ebp
801038c4:	89 e5                	mov    %esp,%ebp
801038c6:	57                   	push   %edi
801038c7:	56                   	push   %esi
801038c8:	53                   	push   %ebx
801038c9:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801038cc:	e8 a5 fa ff ff       	call   80103376 <myproc>
801038d1:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801038d3:	83 ec 0c             	sub    $0xc,%esp
801038d6:	68 20 2d 11 80       	push   $0x80112d20
801038db:	e8 ba 04 00 00       	call   80103d9a <acquire>
801038e0:	83 c4 10             	add    $0x10,%esp
      havekids = 1;
801038e3:	bf 01 00 00 00       	mov    $0x1,%edi
    havekids = 0;
801038e8:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038ed:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801038f2:	e9 8e 00 00 00       	jmp    80103985 <wait+0xc2>
801038f7:	b8 00 00 00 00       	mov    $0x0,%eax
801038fc:	eb 08                	jmp    80103906 <wait+0x43>
801038fe:	83 c0 04             	add    $0x4,%eax
        for(i = 0; i < NSHAREPAGE; i++)
80103901:	83 f8 10             	cmp    $0x10,%eax
80103904:	74 18                	je     8010391e <wait+0x5b>
          if (p->shared_page[i])
80103906:	83 7c 03 7c 00       	cmpl   $0x0,0x7c(%ebx,%eax,1)
8010390b:	74 f1                	je     801038fe <wait+0x3b>
            p->shared_page[i] = 0;
8010390d:	c7 44 03 7c 00 00 00 	movl   $0x0,0x7c(%ebx,%eax,1)
80103914:	00 
            sm_counts[i]--;
80103915:	83 a8 b4 58 11 80 01 	subl   $0x1,-0x7feea74c(%eax)
8010391c:	eb e0                	jmp    801038fe <wait+0x3b>
        pid = p->pid;
8010391e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103921:	83 ec 0c             	sub    $0xc,%esp
80103924:	ff 73 08             	pushl  0x8(%ebx)
80103927:	e8 4a e7 ff ff       	call   80102076 <kfree>
        p->kstack = 0;
8010392c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103933:	83 c4 04             	add    $0x4,%esp
80103936:	ff 73 04             	pushl  0x4(%ebx)
80103939:	e8 23 2a 00 00       	call   80106361 <freevm>
        p->pid = 0;
8010393e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103945:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010394c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103950:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103957:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010395e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103965:	e8 97 04 00 00       	call   80103e01 <release>
        return pid;
8010396a:	83 c4 10             	add    $0x10,%esp
}
8010396d:	89 f0                	mov    %esi,%eax
8010396f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103972:	5b                   	pop    %ebx
80103973:	5e                   	pop    %esi
80103974:	5f                   	pop    %edi
80103975:	5d                   	pop    %ebp
80103976:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103977:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010397d:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103983:	73 13                	jae    80103998 <wait+0xd5>
      if(p->parent != curproc)
80103985:	39 73 14             	cmp    %esi,0x14(%ebx)
80103988:	75 ed                	jne    80103977 <wait+0xb4>
      if(p->state == ZOMBIE){
8010398a:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010398e:	0f 84 63 ff ff ff    	je     801038f7 <wait+0x34>
      havekids = 1;
80103994:	89 f8                	mov    %edi,%eax
80103996:	eb df                	jmp    80103977 <wait+0xb4>
    if(!havekids || curproc->killed){
80103998:	85 c0                	test   %eax,%eax
8010399a:	74 06                	je     801039a2 <wait+0xdf>
8010399c:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801039a0:	74 17                	je     801039b9 <wait+0xf6>
      release(&ptable.lock);
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	68 20 2d 11 80       	push   $0x80112d20
801039aa:	e8 52 04 00 00       	call   80103e01 <release>
      return -1;
801039af:	83 c4 10             	add    $0x10,%esp
801039b2:	be ff ff ff ff       	mov    $0xffffffff,%esi
801039b7:	eb b4                	jmp    8010396d <wait+0xaa>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801039b9:	83 ec 08             	sub    $0x8,%esp
801039bc:	68 20 2d 11 80       	push   $0x80112d20
801039c1:	56                   	push   %esi
801039c2:	e8 5a fe ff ff       	call   80103821 <sleep>
    havekids = 0;
801039c7:	83 c4 10             	add    $0x10,%esp
801039ca:	e9 19 ff ff ff       	jmp    801038e8 <wait+0x25>

801039cf <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801039cf:	55                   	push   %ebp
801039d0:	89 e5                	mov    %esp,%ebp
801039d2:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801039d5:	68 20 2d 11 80       	push   $0x80112d20
801039da:	e8 bb 03 00 00       	call   80103d9a <acquire>
  wakeup1(chan);
801039df:	8b 45 08             	mov    0x8(%ebp),%eax
801039e2:	e8 a2 f7 ff ff       	call   80103189 <wakeup1>
  release(&ptable.lock);
801039e7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039ee:	e8 0e 04 00 00       	call   80103e01 <release>
}
801039f3:	83 c4 10             	add    $0x10,%esp
801039f6:	c9                   	leave  
801039f7:	c3                   	ret    

801039f8 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039f8:	55                   	push   %ebp
801039f9:	89 e5                	mov    %esp,%ebp
801039fb:	53                   	push   %ebx
801039fc:	83 ec 10             	sub    $0x10,%esp
801039ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103a02:	68 20 2d 11 80       	push   $0x80112d20
80103a07:	e8 8e 03 00 00       	call   80103d9a <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80103a0c:	83 c4 10             	add    $0x10,%esp
80103a0f:	3b 1d 64 2d 11 80    	cmp    0x80112d64,%ebx
80103a15:	74 2d                	je     80103a44 <kill+0x4c>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a17:	b8 e0 2d 11 80       	mov    $0x80112de0,%eax
    if(p->pid == pid){
80103a1c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103a1f:	74 28                	je     80103a49 <kill+0x51>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a21:	05 8c 00 00 00       	add    $0x8c,%eax
80103a26:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103a2b:	72 ef                	jb     80103a1c <kill+0x24>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103a2d:	83 ec 0c             	sub    $0xc,%esp
80103a30:	68 20 2d 11 80       	push   $0x80112d20
80103a35:	e8 c7 03 00 00       	call   80103e01 <release>
  return -1;
80103a3a:	83 c4 10             	add    $0x10,%esp
80103a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a42:	eb 27                	jmp    80103a6b <kill+0x73>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a44:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
      p->killed = 1;
80103a49:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103a50:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a54:	74 1a                	je     80103a70 <kill+0x78>
      release(&ptable.lock);
80103a56:	83 ec 0c             	sub    $0xc,%esp
80103a59:	68 20 2d 11 80       	push   $0x80112d20
80103a5e:	e8 9e 03 00 00       	call   80103e01 <release>
      return 0;
80103a63:	83 c4 10             	add    $0x10,%esp
80103a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a6e:	c9                   	leave  
80103a6f:	c3                   	ret    
        p->state = RUNNABLE;
80103a70:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a77:	eb dd                	jmp    80103a56 <kill+0x5e>

80103a79 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a79:	55                   	push   %ebp
80103a7a:	89 e5                	mov    %esp,%ebp
80103a7c:	57                   	push   %edi
80103a7d:	56                   	push   %esi
80103a7e:	53                   	push   %ebx
80103a7f:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a82:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103a87:	8d 7d e8             	lea    -0x18(%ebp),%edi
80103a8a:	eb 39                	jmp    80103ac5 <procdump+0x4c>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103a8c:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a8f:	52                   	push   %edx
80103a90:	50                   	push   %eax
80103a91:	ff 73 10             	pushl  0x10(%ebx)
80103a94:	68 84 6e 10 80       	push   $0x80106e84
80103a99:	e8 43 cb ff ff       	call   801005e1 <cprintf>
    if(p->state == SLEEPING){
80103a9e:	83 c4 10             	add    $0x10,%esp
80103aa1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103aa5:	74 42                	je     80103ae9 <procdump+0x70>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103aa7:	83 ec 0c             	sub    $0xc,%esp
80103aaa:	68 57 72 10 80       	push   $0x80107257
80103aaf:	e8 2d cb ff ff       	call   801005e1 <cprintf>
80103ab4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab7:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103abd:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103ac3:	73 7b                	jae    80103b40 <procdump+0xc7>
    if(p->state == UNUSED)
80103ac5:	8b 53 0c             	mov    0xc(%ebx),%edx
80103ac8:	85 d2                	test   %edx,%edx
80103aca:	74 eb                	je     80103ab7 <procdump+0x3e>
      state = "???";
80103acc:	b8 80 6e 10 80       	mov    $0x80106e80,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ad1:	83 fa 05             	cmp    $0x5,%edx
80103ad4:	77 b6                	ja     80103a8c <procdump+0x13>
80103ad6:	8b 04 95 e0 6e 10 80 	mov    -0x7fef9120(,%edx,4),%eax
80103add:	85 c0                	test   %eax,%eax
      state = "???";
80103adf:	ba 80 6e 10 80       	mov    $0x80106e80,%edx
80103ae4:	0f 44 c2             	cmove  %edx,%eax
80103ae7:	eb a3                	jmp    80103a8c <procdump+0x13>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103ae9:	83 ec 08             	sub    $0x8,%esp
80103aec:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103aef:	50                   	push   %eax
80103af0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103af3:	8b 40 0c             	mov    0xc(%eax),%eax
80103af6:	83 c0 08             	add    $0x8,%eax
80103af9:	50                   	push   %eax
80103afa:	e8 6e 01 00 00       	call   80103c6d <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103aff:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103b02:	83 c4 10             	add    $0x10,%esp
80103b05:	85 c0                	test   %eax,%eax
80103b07:	74 9e                	je     80103aa7 <procdump+0x2e>
        cprintf(" %p", pc[i]);
80103b09:	83 ec 08             	sub    $0x8,%esp
80103b0c:	50                   	push   %eax
80103b0d:	68 c1 68 10 80       	push   $0x801068c1
80103b12:	e8 ca ca ff ff       	call   801005e1 <cprintf>
80103b17:	8d 75 c4             	lea    -0x3c(%ebp),%esi
80103b1a:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80103b1d:	8b 06                	mov    (%esi),%eax
80103b1f:	85 c0                	test   %eax,%eax
80103b21:	74 84                	je     80103aa7 <procdump+0x2e>
        cprintf(" %p", pc[i]);
80103b23:	83 ec 08             	sub    $0x8,%esp
80103b26:	50                   	push   %eax
80103b27:	68 c1 68 10 80       	push   $0x801068c1
80103b2c:	e8 b0 ca ff ff       	call   801005e1 <cprintf>
80103b31:	83 c6 04             	add    $0x4,%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103b34:	83 c4 10             	add    $0x10,%esp
80103b37:	39 f7                	cmp    %esi,%edi
80103b39:	75 e2                	jne    80103b1d <procdump+0xa4>
80103b3b:	e9 67 ff ff ff       	jmp    80103aa7 <procdump+0x2e>
  }
}
80103b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b43:	5b                   	pop    %ebx
80103b44:	5e                   	pop    %esi
80103b45:	5f                   	pop    %edi
80103b46:	5d                   	pop    %ebp
80103b47:	c3                   	ret    

80103b48 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b48:	55                   	push   %ebp
80103b49:	89 e5                	mov    %esp,%ebp
80103b4b:	53                   	push   %ebx
80103b4c:	83 ec 0c             	sub    $0xc,%esp
80103b4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b52:	68 f8 6e 10 80       	push   $0x80106ef8
80103b57:	8d 43 04             	lea    0x4(%ebx),%eax
80103b5a:	50                   	push   %eax
80103b5b:	e8 f2 00 00 00       	call   80103c52 <initlock>
  lk->name = name;
80103b60:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b63:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103b66:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b6c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103b73:	83 c4 10             	add    $0x10,%esp
80103b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b79:	c9                   	leave  
80103b7a:	c3                   	ret    

80103b7b <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b7b:	55                   	push   %ebp
80103b7c:	89 e5                	mov    %esp,%ebp
80103b7e:	56                   	push   %esi
80103b7f:	53                   	push   %ebx
80103b80:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b83:	8d 73 04             	lea    0x4(%ebx),%esi
80103b86:	83 ec 0c             	sub    $0xc,%esp
80103b89:	56                   	push   %esi
80103b8a:	e8 0b 02 00 00       	call   80103d9a <acquire>
  while (lk->locked) {
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b95:	74 12                	je     80103ba9 <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103b97:	83 ec 08             	sub    $0x8,%esp
80103b9a:	56                   	push   %esi
80103b9b:	53                   	push   %ebx
80103b9c:	e8 80 fc ff ff       	call   80103821 <sleep>
  while (lk->locked) {
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ba7:	75 ee                	jne    80103b97 <acquiresleep+0x1c>
  }
  lk->locked = 1;
80103ba9:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103baf:	e8 c2 f7 ff ff       	call   80103376 <myproc>
80103bb4:	8b 40 10             	mov    0x10(%eax),%eax
80103bb7:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103bba:	83 ec 0c             	sub    $0xc,%esp
80103bbd:	56                   	push   %esi
80103bbe:	e8 3e 02 00 00       	call   80103e01 <release>
}
80103bc3:	83 c4 10             	add    $0x10,%esp
80103bc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bc9:	5b                   	pop    %ebx
80103bca:	5e                   	pop    %esi
80103bcb:	5d                   	pop    %ebp
80103bcc:	c3                   	ret    

80103bcd <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103bcd:	55                   	push   %ebp
80103bce:	89 e5                	mov    %esp,%ebp
80103bd0:	56                   	push   %esi
80103bd1:	53                   	push   %ebx
80103bd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103bd5:	8d 73 04             	lea    0x4(%ebx),%esi
80103bd8:	83 ec 0c             	sub    $0xc,%esp
80103bdb:	56                   	push   %esi
80103bdc:	e8 b9 01 00 00       	call   80103d9a <acquire>
  lk->locked = 0;
80103be1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103be7:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103bee:	89 1c 24             	mov    %ebx,(%esp)
80103bf1:	e8 d9 fd ff ff       	call   801039cf <wakeup>
  release(&lk->lk);
80103bf6:	89 34 24             	mov    %esi,(%esp)
80103bf9:	e8 03 02 00 00       	call   80103e01 <release>
}
80103bfe:	83 c4 10             	add    $0x10,%esp
80103c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c04:	5b                   	pop    %ebx
80103c05:	5e                   	pop    %esi
80103c06:	5d                   	pop    %ebp
80103c07:	c3                   	ret    

80103c08 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103c08:	55                   	push   %ebp
80103c09:	89 e5                	mov    %esp,%ebp
80103c0b:	57                   	push   %edi
80103c0c:	56                   	push   %esi
80103c0d:	53                   	push   %ebx
80103c0e:	83 ec 18             	sub    $0x18,%esp
80103c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103c14:	8d 73 04             	lea    0x4(%ebx),%esi
80103c17:	56                   	push   %esi
80103c18:	e8 7d 01 00 00       	call   80103d9a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103c1d:	83 c4 10             	add    $0x10,%esp
80103c20:	bf 00 00 00 00       	mov    $0x0,%edi
80103c25:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c28:	75 13                	jne    80103c3d <holdingsleep+0x35>
  release(&lk->lk);
80103c2a:	83 ec 0c             	sub    $0xc,%esp
80103c2d:	56                   	push   %esi
80103c2e:	e8 ce 01 00 00       	call   80103e01 <release>
  return r;
}
80103c33:	89 f8                	mov    %edi,%eax
80103c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c38:	5b                   	pop    %ebx
80103c39:	5e                   	pop    %esi
80103c3a:	5f                   	pop    %edi
80103c3b:	5d                   	pop    %ebp
80103c3c:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103c3d:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103c40:	e8 31 f7 ff ff       	call   80103376 <myproc>
80103c45:	39 58 10             	cmp    %ebx,0x10(%eax)
80103c48:	0f 94 c0             	sete   %al
80103c4b:	0f b6 c0             	movzbl %al,%eax
80103c4e:	89 c7                	mov    %eax,%edi
80103c50:	eb d8                	jmp    80103c2a <holdingsleep+0x22>

80103c52 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c52:	55                   	push   %ebp
80103c53:	89 e5                	mov    %esp,%ebp
80103c55:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c5b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c6b:	5d                   	pop    %ebp
80103c6c:	c3                   	ret    

80103c6d <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c6d:	55                   	push   %ebp
80103c6e:	89 e5                	mov    %esp,%ebp
80103c70:	53                   	push   %ebx
80103c71:	8b 45 08             	mov    0x8(%ebp),%eax
80103c74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c77:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80103c7d:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103c83:	77 2d                	ja     80103cb2 <getcallerpcs+0x45>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c85:	8b 50 fc             	mov    -0x4(%eax),%edx
80103c88:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c8a:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103c8d:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c92:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103c98:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c9e:	77 17                	ja     80103cb7 <getcallerpcs+0x4a>
    pcs[i] = ebp[1];     // saved %eip
80103ca0:	8b 5a 04             	mov    0x4(%edx),%ebx
80103ca3:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103ca6:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103ca8:	83 c0 01             	add    $0x1,%eax
80103cab:	83 f8 0a             	cmp    $0xa,%eax
80103cae:	75 e2                	jne    80103c92 <getcallerpcs+0x25>
80103cb0:	eb 14                	jmp    80103cc6 <getcallerpcs+0x59>
80103cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103cb7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103cbe:	83 c0 01             	add    $0x1,%eax
80103cc1:	83 f8 09             	cmp    $0x9,%eax
80103cc4:	7e f1                	jle    80103cb7 <getcallerpcs+0x4a>
}
80103cc6:	5b                   	pop    %ebx
80103cc7:	5d                   	pop    %ebp
80103cc8:	c3                   	ret    

80103cc9 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103cc9:	55                   	push   %ebp
80103cca:	89 e5                	mov    %esp,%ebp
80103ccc:	53                   	push   %ebx
80103ccd:	83 ec 04             	sub    $0x4,%esp
80103cd0:	9c                   	pushf  
80103cd1:	5b                   	pop    %ebx
  asm volatile("cli");
80103cd2:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103cd3:	e8 0c f6 ff ff       	call   801032e4 <mycpu>
80103cd8:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cdf:	74 12                	je     80103cf3 <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103ce1:	e8 fe f5 ff ff       	call   801032e4 <mycpu>
80103ce6:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103ced:	83 c4 04             	add    $0x4,%esp
80103cf0:	5b                   	pop    %ebx
80103cf1:	5d                   	pop    %ebp
80103cf2:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103cf3:	e8 ec f5 ff ff       	call   801032e4 <mycpu>
80103cf8:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103cfe:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103d04:	eb db                	jmp    80103ce1 <pushcli+0x18>

80103d06 <popcli>:

void
popcli(void)
{
80103d06:	55                   	push   %ebp
80103d07:	89 e5                	mov    %esp,%ebp
80103d09:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d0c:	9c                   	pushf  
80103d0d:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d0e:	f6 c4 02             	test   $0x2,%ah
80103d11:	75 28                	jne    80103d3b <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103d13:	e8 cc f5 ff ff       	call   801032e4 <mycpu>
80103d18:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103d1e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103d21:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103d27:	85 d2                	test   %edx,%edx
80103d29:	78 1d                	js     80103d48 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d2b:	e8 b4 f5 ff ff       	call   801032e4 <mycpu>
80103d30:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103d37:	74 1c                	je     80103d55 <popcli+0x4f>
    sti();
}
80103d39:	c9                   	leave  
80103d3a:	c3                   	ret    
    panic("popcli - interruptible");
80103d3b:	83 ec 0c             	sub    $0xc,%esp
80103d3e:	68 03 6f 10 80       	push   $0x80106f03
80103d43:	e8 fc c5 ff ff       	call   80100344 <panic>
    panic("popcli");
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	68 1a 6f 10 80       	push   $0x80106f1a
80103d50:	e8 ef c5 ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d55:	e8 8a f5 ff ff       	call   801032e4 <mycpu>
80103d5a:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d61:	74 d6                	je     80103d39 <popcli+0x33>
  asm volatile("sti");
80103d63:	fb                   	sti    
}
80103d64:	eb d3                	jmp    80103d39 <popcli+0x33>

80103d66 <holding>:
{
80103d66:	55                   	push   %ebp
80103d67:	89 e5                	mov    %esp,%ebp
80103d69:	56                   	push   %esi
80103d6a:	53                   	push   %ebx
80103d6b:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d6e:	e8 56 ff ff ff       	call   80103cc9 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d73:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d78:	83 3e 00             	cmpl   $0x0,(%esi)
80103d7b:	75 0b                	jne    80103d88 <holding+0x22>
  popcli();
80103d7d:	e8 84 ff ff ff       	call   80103d06 <popcli>
}
80103d82:	89 d8                	mov    %ebx,%eax
80103d84:	5b                   	pop    %ebx
80103d85:	5e                   	pop    %esi
80103d86:	5d                   	pop    %ebp
80103d87:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103d88:	8b 5e 08             	mov    0x8(%esi),%ebx
80103d8b:	e8 54 f5 ff ff       	call   801032e4 <mycpu>
80103d90:	39 c3                	cmp    %eax,%ebx
80103d92:	0f 94 c3             	sete   %bl
80103d95:	0f b6 db             	movzbl %bl,%ebx
80103d98:	eb e3                	jmp    80103d7d <holding+0x17>

80103d9a <acquire>:
{
80103d9a:	55                   	push   %ebp
80103d9b:	89 e5                	mov    %esp,%ebp
80103d9d:	53                   	push   %ebx
80103d9e:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103da1:	e8 23 ff ff ff       	call   80103cc9 <pushcli>
  if(holding(lk))
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	ff 75 08             	pushl  0x8(%ebp)
80103dac:	e8 b5 ff ff ff       	call   80103d66 <holding>
80103db1:	83 c4 10             	add    $0x10,%esp
80103db4:	85 c0                	test   %eax,%eax
80103db6:	75 3c                	jne    80103df4 <acquire+0x5a>
  asm volatile("lock; xchgl %0, %1" :
80103db8:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103dbd:	8b 55 08             	mov    0x8(%ebp),%edx
80103dc0:	89 c8                	mov    %ecx,%eax
80103dc2:	f0 87 02             	lock xchg %eax,(%edx)
80103dc5:	85 c0                	test   %eax,%eax
80103dc7:	75 f4                	jne    80103dbd <acquire+0x23>
  __sync_synchronize();
80103dc9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dd1:	e8 0e f5 ff ff       	call   801032e4 <mycpu>
80103dd6:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103dd9:	83 ec 08             	sub    $0x8,%esp
80103ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddf:	83 c0 0c             	add    $0xc,%eax
80103de2:	50                   	push   %eax
80103de3:	8d 45 08             	lea    0x8(%ebp),%eax
80103de6:	50                   	push   %eax
80103de7:	e8 81 fe ff ff       	call   80103c6d <getcallerpcs>
}
80103dec:	83 c4 10             	add    $0x10,%esp
80103def:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df2:	c9                   	leave  
80103df3:	c3                   	ret    
    panic("acquire");
80103df4:	83 ec 0c             	sub    $0xc,%esp
80103df7:	68 21 6f 10 80       	push   $0x80106f21
80103dfc:	e8 43 c5 ff ff       	call   80100344 <panic>

80103e01 <release>:
{
80103e01:	55                   	push   %ebp
80103e02:	89 e5                	mov    %esp,%ebp
80103e04:	53                   	push   %ebx
80103e05:	83 ec 10             	sub    $0x10,%esp
80103e08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103e0b:	53                   	push   %ebx
80103e0c:	e8 55 ff ff ff       	call   80103d66 <holding>
80103e11:	83 c4 10             	add    $0x10,%esp
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 23                	je     80103e3b <release+0x3a>
  lk->pcs[0] = 0;
80103e18:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103e1f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103e26:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103e2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103e31:	e8 d0 fe ff ff       	call   80103d06 <popcli>
}
80103e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e39:	c9                   	leave  
80103e3a:	c3                   	ret    
    panic("release");
80103e3b:	83 ec 0c             	sub    $0xc,%esp
80103e3e:	68 29 6f 10 80       	push   $0x80106f29
80103e43:	e8 fc c4 ff ff       	call   80100344 <panic>

80103e48 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103e48:	55                   	push   %ebp
80103e49:	89 e5                	mov    %esp,%ebp
80103e4b:	57                   	push   %edi
80103e4c:	53                   	push   %ebx
80103e4d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103e53:	f6 c2 03             	test   $0x3,%dl
80103e56:	75 05                	jne    80103e5d <memset+0x15>
80103e58:	f6 c1 03             	test   $0x3,%cl
80103e5b:	74 0e                	je     80103e6b <memset+0x23>
  asm volatile("cld; rep stosb" :
80103e5d:	89 d7                	mov    %edx,%edi
80103e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e62:	fc                   	cld    
80103e63:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80103e65:	89 d0                	mov    %edx,%eax
80103e67:	5b                   	pop    %ebx
80103e68:	5f                   	pop    %edi
80103e69:	5d                   	pop    %ebp
80103e6a:	c3                   	ret    
    c &= 0xFF;
80103e6b:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103e6f:	c1 e9 02             	shr    $0x2,%ecx
80103e72:	89 f8                	mov    %edi,%eax
80103e74:	c1 e0 18             	shl    $0x18,%eax
80103e77:	89 fb                	mov    %edi,%ebx
80103e79:	c1 e3 10             	shl    $0x10,%ebx
80103e7c:	09 d8                	or     %ebx,%eax
80103e7e:	09 f8                	or     %edi,%eax
80103e80:	c1 e7 08             	shl    $0x8,%edi
80103e83:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103e85:	89 d7                	mov    %edx,%edi
80103e87:	fc                   	cld    
80103e88:	f3 ab                	rep stos %eax,%es:(%edi)
80103e8a:	eb d9                	jmp    80103e65 <memset+0x1d>

80103e8c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103e8c:	55                   	push   %ebp
80103e8d:	89 e5                	mov    %esp,%ebp
80103e8f:	57                   	push   %edi
80103e90:	56                   	push   %esi
80103e91:	53                   	push   %ebx
80103e92:	8b 75 08             	mov    0x8(%ebp),%esi
80103e95:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103e9b:	85 db                	test   %ebx,%ebx
80103e9d:	74 37                	je     80103ed6 <memcmp+0x4a>
    if(*s1 != *s2)
80103e9f:	0f b6 16             	movzbl (%esi),%edx
80103ea2:	0f b6 0f             	movzbl (%edi),%ecx
80103ea5:	38 ca                	cmp    %cl,%dl
80103ea7:	75 19                	jne    80103ec2 <memcmp+0x36>
80103ea9:	b8 01 00 00 00       	mov    $0x1,%eax
  while(n-- > 0){
80103eae:	39 d8                	cmp    %ebx,%eax
80103eb0:	74 1d                	je     80103ecf <memcmp+0x43>
    if(*s1 != *s2)
80103eb2:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80103eb6:	83 c0 01             	add    $0x1,%eax
80103eb9:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80103ebe:	38 ca                	cmp    %cl,%dl
80103ec0:	74 ec                	je     80103eae <memcmp+0x22>
      return *s1 - *s2;
80103ec2:	0f b6 c2             	movzbl %dl,%eax
80103ec5:	0f b6 c9             	movzbl %cl,%ecx
80103ec8:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80103eca:	5b                   	pop    %ebx
80103ecb:	5e                   	pop    %esi
80103ecc:	5f                   	pop    %edi
80103ecd:	5d                   	pop    %ebp
80103ece:	c3                   	ret    
  return 0;
80103ecf:	b8 00 00 00 00       	mov    $0x0,%eax
80103ed4:	eb f4                	jmp    80103eca <memcmp+0x3e>
80103ed6:	b8 00 00 00 00       	mov    $0x0,%eax
80103edb:	eb ed                	jmp    80103eca <memcmp+0x3e>

80103edd <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103edd:	55                   	push   %ebp
80103ede:	89 e5                	mov    %esp,%ebp
80103ee0:	56                   	push   %esi
80103ee1:	53                   	push   %ebx
80103ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103ee8:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103eeb:	39 c3                	cmp    %eax,%ebx
80103eed:	72 1b                	jb     80103f0a <memmove+0x2d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80103eef:	ba 00 00 00 00       	mov    $0x0,%edx
80103ef4:	85 f6                	test   %esi,%esi
80103ef6:	74 0e                	je     80103f06 <memmove+0x29>
      *d++ = *s++;
80103ef8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80103efc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80103eff:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80103f02:	39 d6                	cmp    %edx,%esi
80103f04:	75 f2                	jne    80103ef8 <memmove+0x1b>

  return dst;
}
80103f06:	5b                   	pop    %ebx
80103f07:	5e                   	pop    %esi
80103f08:	5d                   	pop    %ebp
80103f09:	c3                   	ret    
  if(s < d && s + n > d){
80103f0a:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80103f0d:	39 d0                	cmp    %edx,%eax
80103f0f:	73 de                	jae    80103eef <memmove+0x12>
    while(n-- > 0)
80103f11:	8d 56 ff             	lea    -0x1(%esi),%edx
80103f14:	85 f6                	test   %esi,%esi
80103f16:	74 ee                	je     80103f06 <memmove+0x29>
      *--d = *--s;
80103f18:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80103f1c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80103f1f:	83 ea 01             	sub    $0x1,%edx
80103f22:	83 fa ff             	cmp    $0xffffffff,%edx
80103f25:	75 f1                	jne    80103f18 <memmove+0x3b>
80103f27:	eb dd                	jmp    80103f06 <memmove+0x29>

80103f29 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103f29:	55                   	push   %ebp
80103f2a:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80103f2c:	ff 75 10             	pushl  0x10(%ebp)
80103f2f:	ff 75 0c             	pushl  0xc(%ebp)
80103f32:	ff 75 08             	pushl  0x8(%ebp)
80103f35:	e8 a3 ff ff ff       	call   80103edd <memmove>
}
80103f3a:	c9                   	leave  
80103f3b:	c3                   	ret    

80103f3c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103f3c:	55                   	push   %ebp
80103f3d:	89 e5                	mov    %esp,%ebp
80103f3f:	53                   	push   %ebx
80103f40:	8b 45 08             	mov    0x8(%ebp),%eax
80103f43:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80103f49:	85 db                	test   %ebx,%ebx
80103f4b:	74 2d                	je     80103f7a <strncmp+0x3e>
80103f4d:	0f b6 08             	movzbl (%eax),%ecx
80103f50:	84 c9                	test   %cl,%cl
80103f52:	74 1b                	je     80103f6f <strncmp+0x33>
80103f54:	3a 0a                	cmp    (%edx),%cl
80103f56:	75 17                	jne    80103f6f <strncmp+0x33>
80103f58:	01 c3                	add    %eax,%ebx
    n--, p++, q++;
80103f5a:	83 c0 01             	add    $0x1,%eax
80103f5d:	83 c2 01             	add    $0x1,%edx
  while(n > 0 && *p && *p == *q)
80103f60:	39 d8                	cmp    %ebx,%eax
80103f62:	74 1d                	je     80103f81 <strncmp+0x45>
80103f64:	0f b6 08             	movzbl (%eax),%ecx
80103f67:	84 c9                	test   %cl,%cl
80103f69:	74 04                	je     80103f6f <strncmp+0x33>
80103f6b:	3a 0a                	cmp    (%edx),%cl
80103f6d:	74 eb                	je     80103f5a <strncmp+0x1e>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80103f6f:	0f b6 00             	movzbl (%eax),%eax
80103f72:	0f b6 12             	movzbl (%edx),%edx
80103f75:	29 d0                	sub    %edx,%eax
}
80103f77:	5b                   	pop    %ebx
80103f78:	5d                   	pop    %ebp
80103f79:	c3                   	ret    
    return 0;
80103f7a:	b8 00 00 00 00       	mov    $0x0,%eax
80103f7f:	eb f6                	jmp    80103f77 <strncmp+0x3b>
80103f81:	b8 00 00 00 00       	mov    $0x0,%eax
80103f86:	eb ef                	jmp    80103f77 <strncmp+0x3b>

80103f88 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103f88:	55                   	push   %ebp
80103f89:	89 e5                	mov    %esp,%ebp
80103f8b:	57                   	push   %edi
80103f8c:	56                   	push   %esi
80103f8d:	53                   	push   %ebx
80103f8e:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f94:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103f97:	89 f9                	mov    %edi,%ecx
80103f99:	eb 02                	jmp    80103f9d <strncpy+0x15>
80103f9b:	89 f2                	mov    %esi,%edx
80103f9d:	8d 72 ff             	lea    -0x1(%edx),%esi
80103fa0:	85 d2                	test   %edx,%edx
80103fa2:	7e 11                	jle    80103fb5 <strncpy+0x2d>
80103fa4:	83 c3 01             	add    $0x1,%ebx
80103fa7:	83 c1 01             	add    $0x1,%ecx
80103faa:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
80103fae:	88 41 ff             	mov    %al,-0x1(%ecx)
80103fb1:	84 c0                	test   %al,%al
80103fb3:	75 e6                	jne    80103f9b <strncpy+0x13>
    ;
  while(n-- > 0)
80103fb5:	bb 00 00 00 00       	mov    $0x0,%ebx
80103fba:	83 ea 01             	sub    $0x1,%edx
80103fbd:	85 f6                	test   %esi,%esi
80103fbf:	7e 0f                	jle    80103fd0 <strncpy+0x48>
    *s++ = 0;
80103fc1:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
80103fc5:	83 c3 01             	add    $0x1,%ebx
80103fc8:	89 d6                	mov    %edx,%esi
80103fca:	29 de                	sub    %ebx,%esi
  while(n-- > 0)
80103fcc:	85 f6                	test   %esi,%esi
80103fce:	7f f1                	jg     80103fc1 <strncpy+0x39>
  return os;
}
80103fd0:	89 f8                	mov    %edi,%eax
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5f                   	pop    %edi
80103fd5:	5d                   	pop    %ebp
80103fd6:	c3                   	ret    

80103fd7 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103fd7:	55                   	push   %ebp
80103fd8:	89 e5                	mov    %esp,%ebp
80103fda:	56                   	push   %esi
80103fdb:	53                   	push   %ebx
80103fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fe2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80103fe5:	85 c9                	test   %ecx,%ecx
80103fe7:	7e 1e                	jle    80104007 <safestrcpy+0x30>
80103fe9:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80103fed:	89 c1                	mov    %eax,%ecx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103fef:	39 f2                	cmp    %esi,%edx
80103ff1:	74 11                	je     80104004 <safestrcpy+0x2d>
80103ff3:	83 c2 01             	add    $0x1,%edx
80103ff6:	83 c1 01             	add    $0x1,%ecx
80103ff9:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80103ffd:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104000:	84 db                	test   %bl,%bl
80104002:	75 eb                	jne    80103fef <safestrcpy+0x18>
    ;
  *s = 0;
80104004:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104007:	5b                   	pop    %ebx
80104008:	5e                   	pop    %esi
80104009:	5d                   	pop    %ebp
8010400a:	c3                   	ret    

8010400b <strlen>:

int
strlen(const char *s)
{
8010400b:	55                   	push   %ebp
8010400c:	89 e5                	mov    %esp,%ebp
8010400e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104011:	80 3a 00             	cmpb   $0x0,(%edx)
80104014:	74 10                	je     80104026 <strlen+0x1b>
80104016:	b8 00 00 00 00       	mov    $0x0,%eax
8010401b:	83 c0 01             	add    $0x1,%eax
8010401e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104022:	75 f7                	jne    8010401b <strlen+0x10>
    ;
  return n;
}
80104024:	5d                   	pop    %ebp
80104025:	c3                   	ret    
  for(n = 0; s[n]; n++)
80104026:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
8010402b:	eb f7                	jmp    80104024 <strlen+0x19>

8010402d <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010402d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104031:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104035:	55                   	push   %ebp
  pushl %ebx
80104036:	53                   	push   %ebx
  pushl %esi
80104037:	56                   	push   %esi
  pushl %edi
80104038:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104039:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010403b:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010403d:	5f                   	pop    %edi
  popl %esi
8010403e:	5e                   	pop    %esi
  popl %ebx
8010403f:	5b                   	pop    %ebx
  popl %ebp
80104040:	5d                   	pop    %ebp
  ret
80104041:	c3                   	ret    

80104042 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104042:	55                   	push   %ebp
80104043:	89 e5                	mov    %esp,%ebp
80104045:	53                   	push   %ebx
80104046:	83 ec 04             	sub    $0x4,%esp
80104049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010404c:	e8 25 f3 ff ff       	call   80103376 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104051:	8b 00                	mov    (%eax),%eax
80104053:	39 d8                	cmp    %ebx,%eax
80104055:	76 19                	jbe    80104070 <fetchint+0x2e>
80104057:	8d 53 04             	lea    0x4(%ebx),%edx
8010405a:	39 d0                	cmp    %edx,%eax
8010405c:	72 19                	jb     80104077 <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
8010405e:	8b 13                	mov    (%ebx),%edx
80104060:	8b 45 0c             	mov    0xc(%ebp),%eax
80104063:	89 10                	mov    %edx,(%eax)
  return 0;
80104065:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010406a:	83 c4 04             	add    $0x4,%esp
8010406d:	5b                   	pop    %ebx
8010406e:	5d                   	pop    %ebp
8010406f:	c3                   	ret    
    return -1;
80104070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104075:	eb f3                	jmp    8010406a <fetchint+0x28>
80104077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010407c:	eb ec                	jmp    8010406a <fetchint+0x28>

8010407e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010407e:	55                   	push   %ebp
8010407f:	89 e5                	mov    %esp,%ebp
80104081:	53                   	push   %ebx
80104082:	83 ec 04             	sub    $0x4,%esp
80104085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104088:	e8 e9 f2 ff ff       	call   80103376 <myproc>

  if(addr >= curproc->sz)
8010408d:	39 18                	cmp    %ebx,(%eax)
8010408f:	76 2f                	jbe    801040c0 <fetchstr+0x42>
    return -1;
  *pp = (char*)addr;
80104091:	89 da                	mov    %ebx,%edx
80104093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104096:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104098:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010409a:	39 c3                	cmp    %eax,%ebx
8010409c:	73 29                	jae    801040c7 <fetchstr+0x49>
    if(*s == 0)
8010409e:	80 3b 00             	cmpb   $0x0,(%ebx)
801040a1:	74 0c                	je     801040af <fetchstr+0x31>
  for(s = *pp; s < ep; s++){
801040a3:	83 c2 01             	add    $0x1,%edx
801040a6:	39 d0                	cmp    %edx,%eax
801040a8:	76 0f                	jbe    801040b9 <fetchstr+0x3b>
    if(*s == 0)
801040aa:	80 3a 00             	cmpb   $0x0,(%edx)
801040ad:	75 f4                	jne    801040a3 <fetchstr+0x25>
      return s - *pp;
801040af:	89 d0                	mov    %edx,%eax
801040b1:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801040b3:	83 c4 04             	add    $0x4,%esp
801040b6:	5b                   	pop    %ebx
801040b7:	5d                   	pop    %ebp
801040b8:	c3                   	ret    
  return -1;
801040b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040be:	eb f3                	jmp    801040b3 <fetchstr+0x35>
    return -1;
801040c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040c5:	eb ec                	jmp    801040b3 <fetchstr+0x35>
  return -1;
801040c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040cc:	eb e5                	jmp    801040b3 <fetchstr+0x35>

801040ce <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801040ce:	55                   	push   %ebp
801040cf:	89 e5                	mov    %esp,%ebp
801040d1:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801040d4:	e8 9d f2 ff ff       	call   80103376 <myproc>
801040d9:	83 ec 08             	sub    $0x8,%esp
801040dc:	ff 75 0c             	pushl  0xc(%ebp)
801040df:	8b 40 18             	mov    0x18(%eax),%eax
801040e2:	8b 40 44             	mov    0x44(%eax),%eax
801040e5:	8b 55 08             	mov    0x8(%ebp),%edx
801040e8:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
801040ec:	50                   	push   %eax
801040ed:	e8 50 ff ff ff       	call   80104042 <fetchint>
}
801040f2:	c9                   	leave  
801040f3:	c3                   	ret    

801040f4 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	56                   	push   %esi
801040f8:	53                   	push   %ebx
801040f9:	83 ec 10             	sub    $0x10,%esp
801040fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801040ff:	e8 72 f2 ff ff       	call   80103376 <myproc>
80104104:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104106:	83 ec 08             	sub    $0x8,%esp
80104109:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010410c:	50                   	push   %eax
8010410d:	ff 75 08             	pushl  0x8(%ebp)
80104110:	e8 b9 ff ff ff       	call   801040ce <argint>
    return -1;
  // when i == 0 , means the point to the first part of address space
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz || i == 0)
80104115:	83 c4 10             	add    $0x10,%esp
80104118:	85 db                	test   %ebx,%ebx
8010411a:	78 28                	js     80104144 <argptr+0x50>
8010411c:	85 c0                	test   %eax,%eax
8010411e:	78 24                	js     80104144 <argptr+0x50>
80104120:	8b 16                	mov    (%esi),%edx
80104122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104125:	39 c2                	cmp    %eax,%edx
80104127:	76 22                	jbe    8010414b <argptr+0x57>
80104129:	01 c3                	add    %eax,%ebx
8010412b:	39 da                	cmp    %ebx,%edx
8010412d:	72 23                	jb     80104152 <argptr+0x5e>
8010412f:	85 c0                	test   %eax,%eax
80104131:	74 1f                	je     80104152 <argptr+0x5e>
    return -1;
  *pp = (char*)i;
80104133:	8b 55 0c             	mov    0xc(%ebp),%edx
80104136:	89 02                	mov    %eax,(%edx)
  return 0;
80104138:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010413d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104140:	5b                   	pop    %ebx
80104141:	5e                   	pop    %esi
80104142:	5d                   	pop    %ebp
80104143:	c3                   	ret    
    return -1;
80104144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104149:	eb f2                	jmp    8010413d <argptr+0x49>
8010414b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104150:	eb eb                	jmp    8010413d <argptr+0x49>
80104152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104157:	eb e4                	jmp    8010413d <argptr+0x49>

80104159 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104159:	55                   	push   %ebp
8010415a:	89 e5                	mov    %esp,%ebp
8010415c:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010415f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104162:	50                   	push   %eax
80104163:	ff 75 08             	pushl  0x8(%ebp)
80104166:	e8 63 ff ff ff       	call   801040ce <argint>
8010416b:	83 c4 10             	add    $0x10,%esp
8010416e:	85 c0                	test   %eax,%eax
80104170:	78 13                	js     80104185 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104172:	83 ec 08             	sub    $0x8,%esp
80104175:	ff 75 0c             	pushl  0xc(%ebp)
80104178:	ff 75 f4             	pushl  -0xc(%ebp)
8010417b:	e8 fe fe ff ff       	call   8010407e <fetchstr>
80104180:	83 c4 10             	add    $0x10,%esp
}
80104183:	c9                   	leave  
80104184:	c3                   	ret    
    return -1;
80104185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010418a:	eb f7                	jmp    80104183 <argstr+0x2a>

8010418c <syscall>:
[SYS_shmem_count]  sys_shmem_count
};

void
syscall(void)
{
8010418c:	55                   	push   %ebp
8010418d:	89 e5                	mov    %esp,%ebp
8010418f:	53                   	push   %ebx
80104190:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104193:	e8 de f1 ff ff       	call   80103376 <myproc>
80104198:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010419a:	8b 40 18             	mov    0x18(%eax),%eax
8010419d:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801041a0:	8d 50 ff             	lea    -0x1(%eax),%edx
801041a3:	83 fa 16             	cmp    $0x16,%edx
801041a6:	77 18                	ja     801041c0 <syscall+0x34>
801041a8:	8b 14 85 60 6f 10 80 	mov    -0x7fef90a0(,%eax,4),%edx
801041af:	85 d2                	test   %edx,%edx
801041b1:	74 0d                	je     801041c0 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
801041b3:	ff d2                	call   *%edx
801041b5:	8b 53 18             	mov    0x18(%ebx),%edx
801041b8:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801041bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041be:	c9                   	leave  
801041bf:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
801041c0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801041c1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801041c4:	50                   	push   %eax
801041c5:	ff 73 10             	pushl  0x10(%ebx)
801041c8:	68 31 6f 10 80       	push   $0x80106f31
801041cd:	e8 0f c4 ff ff       	call   801005e1 <cprintf>
    curproc->tf->eax = -1;
801041d2:	8b 43 18             	mov    0x18(%ebx),%eax
801041d5:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801041dc:	83 c4 10             	add    $0x10,%esp
}
801041df:	eb da                	jmp    801041bb <syscall+0x2f>

801041e1 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801041e1:	55                   	push   %ebp
801041e2:	89 e5                	mov    %esp,%ebp
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 18             	sub    $0x18,%esp
801041e9:	89 d6                	mov    %edx,%esi
801041eb:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801041ed:	8d 55 f4             	lea    -0xc(%ebp),%edx
801041f0:	52                   	push   %edx
801041f1:	50                   	push   %eax
801041f2:	e8 d7 fe ff ff       	call   801040ce <argint>
801041f7:	83 c4 10             	add    $0x10,%esp
801041fa:	85 c0                	test   %eax,%eax
801041fc:	78 2e                	js     8010422c <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801041fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104202:	77 2f                	ja     80104233 <argfd+0x52>
80104204:	e8 6d f1 ff ff       	call   80103376 <myproc>
80104209:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010420c:	8b 54 88 28          	mov    0x28(%eax,%ecx,4),%edx
80104210:	85 d2                	test   %edx,%edx
80104212:	74 26                	je     8010423a <argfd+0x59>
    return -1;
  if(pfd)
80104214:	85 f6                	test   %esi,%esi
80104216:	74 02                	je     8010421a <argfd+0x39>
    *pfd = fd;
80104218:	89 0e                	mov    %ecx,(%esi)
  if(pf)
    *pf = f;
  return 0;
8010421a:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
8010421f:	85 db                	test   %ebx,%ebx
80104221:	74 02                	je     80104225 <argfd+0x44>
    *pf = f;
80104223:	89 13                	mov    %edx,(%ebx)
}
80104225:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104228:	5b                   	pop    %ebx
80104229:	5e                   	pop    %esi
8010422a:	5d                   	pop    %ebp
8010422b:	c3                   	ret    
    return -1;
8010422c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104231:	eb f2                	jmp    80104225 <argfd+0x44>
    return -1;
80104233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104238:	eb eb                	jmp    80104225 <argfd+0x44>
8010423a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010423f:	eb e4                	jmp    80104225 <argfd+0x44>

80104241 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104241:	55                   	push   %ebp
80104242:	89 e5                	mov    %esp,%ebp
80104244:	53                   	push   %ebx
80104245:	83 ec 04             	sub    $0x4,%esp
80104248:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010424a:	e8 27 f1 ff ff       	call   80103376 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
8010424f:	83 78 28 00          	cmpl   $0x0,0x28(%eax)
80104253:	74 1b                	je     80104270 <fdalloc+0x2f>
  for(fd = 0; fd < NOFILE; fd++){
80104255:	ba 01 00 00 00       	mov    $0x1,%edx
    if(curproc->ofile[fd] == 0){
8010425a:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
8010425f:	74 14                	je     80104275 <fdalloc+0x34>
  for(fd = 0; fd < NOFILE; fd++){
80104261:	83 c2 01             	add    $0x1,%edx
80104264:	83 fa 10             	cmp    $0x10,%edx
80104267:	75 f1                	jne    8010425a <fdalloc+0x19>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104269:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010426e:	eb 09                	jmp    80104279 <fdalloc+0x38>
  for(fd = 0; fd < NOFILE; fd++){
80104270:	ba 00 00 00 00       	mov    $0x0,%edx
      curproc->ofile[fd] = f;
80104275:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104279:	89 d0                	mov    %edx,%eax
8010427b:	83 c4 04             	add    $0x4,%esp
8010427e:	5b                   	pop    %ebx
8010427f:	5d                   	pop    %ebp
80104280:	c3                   	ret    

80104281 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104281:	55                   	push   %ebp
80104282:	89 e5                	mov    %esp,%ebp
80104284:	57                   	push   %edi
80104285:	56                   	push   %esi
80104286:	53                   	push   %ebx
80104287:	83 ec 44             	sub    $0x44,%esp
8010428a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010428d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104290:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104293:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104296:	52                   	push   %edx
80104297:	50                   	push   %eax
80104298:	e8 3b da ff ff       	call   80101cd8 <nameiparent>
8010429d:	89 c6                	mov    %eax,%esi
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	85 c0                	test   %eax,%eax
801042a4:	0f 84 34 01 00 00    	je     801043de <create+0x15d>
    return 0;
  ilock(dp);
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	50                   	push   %eax
801042ae:	e8 70 d2 ff ff       	call   80101523 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801042b3:	83 c4 0c             	add    $0xc,%esp
801042b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801042b9:	50                   	push   %eax
801042ba:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801042bd:	50                   	push   %eax
801042be:	56                   	push   %esi
801042bf:	e8 25 d7 ff ff       	call   801019e9 <dirlookup>
801042c4:	89 c3                	mov    %eax,%ebx
801042c6:	83 c4 10             	add    $0x10,%esp
801042c9:	85 c0                	test   %eax,%eax
801042cb:	74 3f                	je     8010430c <create+0x8b>
    iunlockput(dp);
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	56                   	push   %esi
801042d1:	e8 96 d4 ff ff       	call   8010176c <iunlockput>
    ilock(ip);
801042d6:	89 1c 24             	mov    %ebx,(%esp)
801042d9:	e8 45 d2 ff ff       	call   80101523 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801042de:	83 c4 10             	add    $0x10,%esp
801042e1:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801042e6:	75 11                	jne    801042f9 <create+0x78>
801042e8:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801042ed:	75 0a                	jne    801042f9 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801042ef:	89 d8                	mov    %ebx,%eax
801042f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f4:	5b                   	pop    %ebx
801042f5:	5e                   	pop    %esi
801042f6:	5f                   	pop    %edi
801042f7:	5d                   	pop    %ebp
801042f8:	c3                   	ret    
    iunlockput(ip);
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	53                   	push   %ebx
801042fd:	e8 6a d4 ff ff       	call   8010176c <iunlockput>
    return 0;
80104302:	83 c4 10             	add    $0x10,%esp
80104305:	bb 00 00 00 00       	mov    $0x0,%ebx
8010430a:	eb e3                	jmp    801042ef <create+0x6e>
  if((ip = ialloc(dp->dev, type)) == 0)
8010430c:	83 ec 08             	sub    $0x8,%esp
8010430f:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104313:	50                   	push   %eax
80104314:	ff 36                	pushl  (%esi)
80104316:	e8 b5 d0 ff ff       	call   801013d0 <ialloc>
8010431b:	89 c3                	mov    %eax,%ebx
8010431d:	83 c4 10             	add    $0x10,%esp
80104320:	85 c0                	test   %eax,%eax
80104322:	74 55                	je     80104379 <create+0xf8>
  ilock(ip);
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	50                   	push   %eax
80104328:	e8 f6 d1 ff ff       	call   80101523 <ilock>
  ip->major = major;
8010432d:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104331:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104335:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104339:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010433f:	89 1c 24             	mov    %ebx,(%esp)
80104342:	e8 32 d1 ff ff       	call   80101479 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104347:	83 c4 10             	add    $0x10,%esp
8010434a:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010434f:	74 35                	je     80104386 <create+0x105>
  if(dirlink(dp, name, ip->inum) < 0)
80104351:	83 ec 04             	sub    $0x4,%esp
80104354:	ff 73 04             	pushl  0x4(%ebx)
80104357:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010435a:	50                   	push   %eax
8010435b:	56                   	push   %esi
8010435c:	e8 aa d8 ff ff       	call   80101c0b <dirlink>
80104361:	83 c4 10             	add    $0x10,%esp
80104364:	85 c0                	test   %eax,%eax
80104366:	78 69                	js     801043d1 <create+0x150>
  iunlockput(dp);
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	56                   	push   %esi
8010436c:	e8 fb d3 ff ff       	call   8010176c <iunlockput>
  return ip;
80104371:	83 c4 10             	add    $0x10,%esp
80104374:	e9 76 ff ff ff       	jmp    801042ef <create+0x6e>
    panic("create: ialloc");
80104379:	83 ec 0c             	sub    $0xc,%esp
8010437c:	68 c0 6f 10 80       	push   $0x80106fc0
80104381:	e8 be bf ff ff       	call   80100344 <panic>
    dp->nlink++;  // for ".."
80104386:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
8010438b:	83 ec 0c             	sub    $0xc,%esp
8010438e:	56                   	push   %esi
8010438f:	e8 e5 d0 ff ff       	call   80101479 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104394:	83 c4 0c             	add    $0xc,%esp
80104397:	ff 73 04             	pushl  0x4(%ebx)
8010439a:	68 d0 6f 10 80       	push   $0x80106fd0
8010439f:	53                   	push   %ebx
801043a0:	e8 66 d8 ff ff       	call   80101c0b <dirlink>
801043a5:	83 c4 10             	add    $0x10,%esp
801043a8:	85 c0                	test   %eax,%eax
801043aa:	78 18                	js     801043c4 <create+0x143>
801043ac:	83 ec 04             	sub    $0x4,%esp
801043af:	ff 76 04             	pushl  0x4(%esi)
801043b2:	68 cf 6f 10 80       	push   $0x80106fcf
801043b7:	53                   	push   %ebx
801043b8:	e8 4e d8 ff ff       	call   80101c0b <dirlink>
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	85 c0                	test   %eax,%eax
801043c2:	79 8d                	jns    80104351 <create+0xd0>
      panic("create dots");
801043c4:	83 ec 0c             	sub    $0xc,%esp
801043c7:	68 d2 6f 10 80       	push   $0x80106fd2
801043cc:	e8 73 bf ff ff       	call   80100344 <panic>
    panic("create: dirlink");
801043d1:	83 ec 0c             	sub    $0xc,%esp
801043d4:	68 de 6f 10 80       	push   $0x80106fde
801043d9:	e8 66 bf ff ff       	call   80100344 <panic>
    return 0;
801043de:	89 c3                	mov    %eax,%ebx
801043e0:	e9 0a ff ff ff       	jmp    801042ef <create+0x6e>

801043e5 <sys_dup>:
{
801043e5:	55                   	push   %ebp
801043e6:	89 e5                	mov    %esp,%ebp
801043e8:	53                   	push   %ebx
801043e9:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801043ec:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043ef:	ba 00 00 00 00       	mov    $0x0,%edx
801043f4:	b8 00 00 00 00       	mov    $0x0,%eax
801043f9:	e8 e3 fd ff ff       	call   801041e1 <argfd>
801043fe:	85 c0                	test   %eax,%eax
80104400:	78 23                	js     80104425 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104405:	e8 37 fe ff ff       	call   80104241 <fdalloc>
8010440a:	89 c3                	mov    %eax,%ebx
8010440c:	85 c0                	test   %eax,%eax
8010440e:	78 1c                	js     8010442c <sys_dup+0x47>
  filedup(f);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	ff 75 f4             	pushl  -0xc(%ebp)
80104416:	e8 f7 c8 ff ff       	call   80100d12 <filedup>
  return fd;
8010441b:	83 c4 10             	add    $0x10,%esp
}
8010441e:	89 d8                	mov    %ebx,%eax
80104420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104423:	c9                   	leave  
80104424:	c3                   	ret    
    return -1;
80104425:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010442a:	eb f2                	jmp    8010441e <sys_dup+0x39>
    return -1;
8010442c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104431:	eb eb                	jmp    8010441e <sys_dup+0x39>

80104433 <sys_read>:
{
80104433:	55                   	push   %ebp
80104434:	89 e5                	mov    %esp,%ebp
80104436:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104439:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010443c:	ba 00 00 00 00       	mov    $0x0,%edx
80104441:	b8 00 00 00 00       	mov    $0x0,%eax
80104446:	e8 96 fd ff ff       	call   801041e1 <argfd>
8010444b:	85 c0                	test   %eax,%eax
8010444d:	78 43                	js     80104492 <sys_read+0x5f>
8010444f:	83 ec 08             	sub    $0x8,%esp
80104452:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104455:	50                   	push   %eax
80104456:	6a 02                	push   $0x2
80104458:	e8 71 fc ff ff       	call   801040ce <argint>
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	85 c0                	test   %eax,%eax
80104462:	78 35                	js     80104499 <sys_read+0x66>
80104464:	83 ec 04             	sub    $0x4,%esp
80104467:	ff 75 f0             	pushl  -0x10(%ebp)
8010446a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010446d:	50                   	push   %eax
8010446e:	6a 01                	push   $0x1
80104470:	e8 7f fc ff ff       	call   801040f4 <argptr>
80104475:	83 c4 10             	add    $0x10,%esp
80104478:	85 c0                	test   %eax,%eax
8010447a:	78 24                	js     801044a0 <sys_read+0x6d>
  return fileread(f, p, n);
8010447c:	83 ec 04             	sub    $0x4,%esp
8010447f:	ff 75 f0             	pushl  -0x10(%ebp)
80104482:	ff 75 ec             	pushl  -0x14(%ebp)
80104485:	ff 75 f4             	pushl  -0xc(%ebp)
80104488:	e8 c6 c9 ff ff       	call   80100e53 <fileread>
8010448d:	83 c4 10             	add    $0x10,%esp
}
80104490:	c9                   	leave  
80104491:	c3                   	ret    
    return -1;
80104492:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104497:	eb f7                	jmp    80104490 <sys_read+0x5d>
80104499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449e:	eb f0                	jmp    80104490 <sys_read+0x5d>
801044a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044a5:	eb e9                	jmp    80104490 <sys_read+0x5d>

801044a7 <sys_write>:
{
801044a7:	55                   	push   %ebp
801044a8:	89 e5                	mov    %esp,%ebp
801044aa:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801044ad:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044b0:	ba 00 00 00 00       	mov    $0x0,%edx
801044b5:	b8 00 00 00 00       	mov    $0x0,%eax
801044ba:	e8 22 fd ff ff       	call   801041e1 <argfd>
801044bf:	85 c0                	test   %eax,%eax
801044c1:	78 43                	js     80104506 <sys_write+0x5f>
801044c3:	83 ec 08             	sub    $0x8,%esp
801044c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044c9:	50                   	push   %eax
801044ca:	6a 02                	push   $0x2
801044cc:	e8 fd fb ff ff       	call   801040ce <argint>
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	85 c0                	test   %eax,%eax
801044d6:	78 35                	js     8010450d <sys_write+0x66>
801044d8:	83 ec 04             	sub    $0x4,%esp
801044db:	ff 75 f0             	pushl  -0x10(%ebp)
801044de:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044e1:	50                   	push   %eax
801044e2:	6a 01                	push   $0x1
801044e4:	e8 0b fc ff ff       	call   801040f4 <argptr>
801044e9:	83 c4 10             	add    $0x10,%esp
801044ec:	85 c0                	test   %eax,%eax
801044ee:	78 24                	js     80104514 <sys_write+0x6d>
  return filewrite(f, p, n);
801044f0:	83 ec 04             	sub    $0x4,%esp
801044f3:	ff 75 f0             	pushl  -0x10(%ebp)
801044f6:	ff 75 ec             	pushl  -0x14(%ebp)
801044f9:	ff 75 f4             	pushl  -0xc(%ebp)
801044fc:	e8 d7 c9 ff ff       	call   80100ed8 <filewrite>
80104501:	83 c4 10             	add    $0x10,%esp
}
80104504:	c9                   	leave  
80104505:	c3                   	ret    
    return -1;
80104506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010450b:	eb f7                	jmp    80104504 <sys_write+0x5d>
8010450d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104512:	eb f0                	jmp    80104504 <sys_write+0x5d>
80104514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104519:	eb e9                	jmp    80104504 <sys_write+0x5d>

8010451b <sys_close>:
{
8010451b:	55                   	push   %ebp
8010451c:	89 e5                	mov    %esp,%ebp
8010451e:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104521:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104524:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104527:	b8 00 00 00 00       	mov    $0x0,%eax
8010452c:	e8 b0 fc ff ff       	call   801041e1 <argfd>
80104531:	85 c0                	test   %eax,%eax
80104533:	78 25                	js     8010455a <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104535:	e8 3c ee ff ff       	call   80103376 <myproc>
8010453a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010453d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104544:	00 
  fileclose(f);
80104545:	83 ec 0c             	sub    $0xc,%esp
80104548:	ff 75 f0             	pushl  -0x10(%ebp)
8010454b:	e8 07 c8 ff ff       	call   80100d57 <fileclose>
  return 0;
80104550:	83 c4 10             	add    $0x10,%esp
80104553:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104558:	c9                   	leave  
80104559:	c3                   	ret    
    return -1;
8010455a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010455f:	eb f7                	jmp    80104558 <sys_close+0x3d>

80104561 <sys_fstat>:
{
80104561:	55                   	push   %ebp
80104562:	89 e5                	mov    %esp,%ebp
80104564:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104567:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010456a:	ba 00 00 00 00       	mov    $0x0,%edx
8010456f:	b8 00 00 00 00       	mov    $0x0,%eax
80104574:	e8 68 fc ff ff       	call   801041e1 <argfd>
80104579:	85 c0                	test   %eax,%eax
8010457b:	78 2a                	js     801045a7 <sys_fstat+0x46>
8010457d:	83 ec 04             	sub    $0x4,%esp
80104580:	6a 14                	push   $0x14
80104582:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104585:	50                   	push   %eax
80104586:	6a 01                	push   $0x1
80104588:	e8 67 fb ff ff       	call   801040f4 <argptr>
8010458d:	83 c4 10             	add    $0x10,%esp
80104590:	85 c0                	test   %eax,%eax
80104592:	78 1a                	js     801045ae <sys_fstat+0x4d>
  return filestat(f, st);
80104594:	83 ec 08             	sub    $0x8,%esp
80104597:	ff 75 f0             	pushl  -0x10(%ebp)
8010459a:	ff 75 f4             	pushl  -0xc(%ebp)
8010459d:	e8 6a c8 ff ff       	call   80100e0c <filestat>
801045a2:	83 c4 10             	add    $0x10,%esp
}
801045a5:	c9                   	leave  
801045a6:	c3                   	ret    
    return -1;
801045a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ac:	eb f7                	jmp    801045a5 <sys_fstat+0x44>
801045ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b3:	eb f0                	jmp    801045a5 <sys_fstat+0x44>

801045b5 <sys_link>:
{
801045b5:	55                   	push   %ebp
801045b6:	89 e5                	mov    %esp,%ebp
801045b8:	56                   	push   %esi
801045b9:	53                   	push   %ebx
801045ba:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801045bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045c0:	50                   	push   %eax
801045c1:	6a 00                	push   $0x0
801045c3:	e8 91 fb ff ff       	call   80104159 <argstr>
801045c8:	83 c4 10             	add    $0x10,%esp
801045cb:	85 c0                	test   %eax,%eax
801045cd:	0f 88 26 01 00 00    	js     801046f9 <sys_link+0x144>
801045d3:	83 ec 08             	sub    $0x8,%esp
801045d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801045d9:	50                   	push   %eax
801045da:	6a 01                	push   $0x1
801045dc:	e8 78 fb ff ff       	call   80104159 <argstr>
801045e1:	83 c4 10             	add    $0x10,%esp
801045e4:	85 c0                	test   %eax,%eax
801045e6:	0f 88 14 01 00 00    	js     80104700 <sys_link+0x14b>
  begin_op();
801045ec:	e8 f9 e1 ff ff       	call   801027ea <begin_op>
  if((ip = namei(old)) == 0){
801045f1:	83 ec 0c             	sub    $0xc,%esp
801045f4:	ff 75 e0             	pushl  -0x20(%ebp)
801045f7:	e8 c4 d6 ff ff       	call   80101cc0 <namei>
801045fc:	89 c3                	mov    %eax,%ebx
801045fe:	83 c4 10             	add    $0x10,%esp
80104601:	85 c0                	test   %eax,%eax
80104603:	0f 84 93 00 00 00    	je     8010469c <sys_link+0xe7>
  ilock(ip);
80104609:	83 ec 0c             	sub    $0xc,%esp
8010460c:	50                   	push   %eax
8010460d:	e8 11 cf ff ff       	call   80101523 <ilock>
  if(ip->type == T_DIR){
80104612:	83 c4 10             	add    $0x10,%esp
80104615:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010461a:	0f 84 88 00 00 00    	je     801046a8 <sys_link+0xf3>
  ip->nlink++;
80104620:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104625:	83 ec 0c             	sub    $0xc,%esp
80104628:	53                   	push   %ebx
80104629:	e8 4b ce ff ff       	call   80101479 <iupdate>
  iunlock(ip);
8010462e:	89 1c 24             	mov    %ebx,(%esp)
80104631:	e8 af cf ff ff       	call   801015e5 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104636:	83 c4 08             	add    $0x8,%esp
80104639:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010463c:	50                   	push   %eax
8010463d:	ff 75 e4             	pushl  -0x1c(%ebp)
80104640:	e8 93 d6 ff ff       	call   80101cd8 <nameiparent>
80104645:	89 c6                	mov    %eax,%esi
80104647:	83 c4 10             	add    $0x10,%esp
8010464a:	85 c0                	test   %eax,%eax
8010464c:	74 7e                	je     801046cc <sys_link+0x117>
  ilock(dp);
8010464e:	83 ec 0c             	sub    $0xc,%esp
80104651:	50                   	push   %eax
80104652:	e8 cc ce ff ff       	call   80101523 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104657:	83 c4 10             	add    $0x10,%esp
8010465a:	8b 03                	mov    (%ebx),%eax
8010465c:	39 06                	cmp    %eax,(%esi)
8010465e:	75 60                	jne    801046c0 <sys_link+0x10b>
80104660:	83 ec 04             	sub    $0x4,%esp
80104663:	ff 73 04             	pushl  0x4(%ebx)
80104666:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104669:	50                   	push   %eax
8010466a:	56                   	push   %esi
8010466b:	e8 9b d5 ff ff       	call   80101c0b <dirlink>
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	85 c0                	test   %eax,%eax
80104675:	78 49                	js     801046c0 <sys_link+0x10b>
  iunlockput(dp);
80104677:	83 ec 0c             	sub    $0xc,%esp
8010467a:	56                   	push   %esi
8010467b:	e8 ec d0 ff ff       	call   8010176c <iunlockput>
  iput(ip);
80104680:	89 1c 24             	mov    %ebx,(%esp)
80104683:	e8 a2 cf ff ff       	call   8010162a <iput>
  end_op();
80104688:	e8 d8 e1 ff ff       	call   80102865 <end_op>
  return 0;
8010468d:	83 c4 10             	add    $0x10,%esp
80104690:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104695:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104698:	5b                   	pop    %ebx
80104699:	5e                   	pop    %esi
8010469a:	5d                   	pop    %ebp
8010469b:	c3                   	ret    
    end_op();
8010469c:	e8 c4 e1 ff ff       	call   80102865 <end_op>
    return -1;
801046a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a6:	eb ed                	jmp    80104695 <sys_link+0xe0>
    iunlockput(ip);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	53                   	push   %ebx
801046ac:	e8 bb d0 ff ff       	call   8010176c <iunlockput>
    end_op();
801046b1:	e8 af e1 ff ff       	call   80102865 <end_op>
    return -1;
801046b6:	83 c4 10             	add    $0x10,%esp
801046b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046be:	eb d5                	jmp    80104695 <sys_link+0xe0>
    iunlockput(dp);
801046c0:	83 ec 0c             	sub    $0xc,%esp
801046c3:	56                   	push   %esi
801046c4:	e8 a3 d0 ff ff       	call   8010176c <iunlockput>
    goto bad;
801046c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801046cc:	83 ec 0c             	sub    $0xc,%esp
801046cf:	53                   	push   %ebx
801046d0:	e8 4e ce ff ff       	call   80101523 <ilock>
  ip->nlink--;
801046d5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801046da:	89 1c 24             	mov    %ebx,(%esp)
801046dd:	e8 97 cd ff ff       	call   80101479 <iupdate>
  iunlockput(ip);
801046e2:	89 1c 24             	mov    %ebx,(%esp)
801046e5:	e8 82 d0 ff ff       	call   8010176c <iunlockput>
  end_op();
801046ea:	e8 76 e1 ff ff       	call   80102865 <end_op>
  return -1;
801046ef:	83 c4 10             	add    $0x10,%esp
801046f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f7:	eb 9c                	jmp    80104695 <sys_link+0xe0>
    return -1;
801046f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046fe:	eb 95                	jmp    80104695 <sys_link+0xe0>
80104700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104705:	eb 8e                	jmp    80104695 <sys_link+0xe0>

80104707 <sys_unlink>:
{
80104707:	55                   	push   %ebp
80104708:	89 e5                	mov    %esp,%ebp
8010470a:	57                   	push   %edi
8010470b:	56                   	push   %esi
8010470c:	53                   	push   %ebx
8010470d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104710:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104713:	50                   	push   %eax
80104714:	6a 00                	push   $0x0
80104716:	e8 3e fa ff ff       	call   80104159 <argstr>
8010471b:	83 c4 10             	add    $0x10,%esp
8010471e:	85 c0                	test   %eax,%eax
80104720:	0f 88 81 01 00 00    	js     801048a7 <sys_unlink+0x1a0>
  begin_op();
80104726:	e8 bf e0 ff ff       	call   801027ea <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010472b:	83 ec 08             	sub    $0x8,%esp
8010472e:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104731:	50                   	push   %eax
80104732:	ff 75 c4             	pushl  -0x3c(%ebp)
80104735:	e8 9e d5 ff ff       	call   80101cd8 <nameiparent>
8010473a:	89 c7                	mov    %eax,%edi
8010473c:	83 c4 10             	add    $0x10,%esp
8010473f:	85 c0                	test   %eax,%eax
80104741:	0f 84 df 00 00 00    	je     80104826 <sys_unlink+0x11f>
  ilock(dp);
80104747:	83 ec 0c             	sub    $0xc,%esp
8010474a:	50                   	push   %eax
8010474b:	e8 d3 cd ff ff       	call   80101523 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104750:	83 c4 08             	add    $0x8,%esp
80104753:	68 d0 6f 10 80       	push   $0x80106fd0
80104758:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010475b:	50                   	push   %eax
8010475c:	e8 73 d2 ff ff       	call   801019d4 <namecmp>
80104761:	83 c4 10             	add    $0x10,%esp
80104764:	85 c0                	test   %eax,%eax
80104766:	0f 84 51 01 00 00    	je     801048bd <sys_unlink+0x1b6>
8010476c:	83 ec 08             	sub    $0x8,%esp
8010476f:	68 cf 6f 10 80       	push   $0x80106fcf
80104774:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104777:	50                   	push   %eax
80104778:	e8 57 d2 ff ff       	call   801019d4 <namecmp>
8010477d:	83 c4 10             	add    $0x10,%esp
80104780:	85 c0                	test   %eax,%eax
80104782:	0f 84 35 01 00 00    	je     801048bd <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104788:	83 ec 04             	sub    $0x4,%esp
8010478b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010478e:	50                   	push   %eax
8010478f:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104792:	50                   	push   %eax
80104793:	57                   	push   %edi
80104794:	e8 50 d2 ff ff       	call   801019e9 <dirlookup>
80104799:	89 c3                	mov    %eax,%ebx
8010479b:	83 c4 10             	add    $0x10,%esp
8010479e:	85 c0                	test   %eax,%eax
801047a0:	0f 84 17 01 00 00    	je     801048bd <sys_unlink+0x1b6>
  ilock(ip);
801047a6:	83 ec 0c             	sub    $0xc,%esp
801047a9:	50                   	push   %eax
801047aa:	e8 74 cd ff ff       	call   80101523 <ilock>
  if(ip->nlink < 1)
801047af:	83 c4 10             	add    $0x10,%esp
801047b2:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801047b7:	7e 79                	jle    80104832 <sys_unlink+0x12b>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047be:	74 7f                	je     8010483f <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
801047c0:	83 ec 04             	sub    $0x4,%esp
801047c3:	6a 10                	push   $0x10
801047c5:	6a 00                	push   $0x0
801047c7:	8d 75 d8             	lea    -0x28(%ebp),%esi
801047ca:	56                   	push   %esi
801047cb:	e8 78 f6 ff ff       	call   80103e48 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801047d0:	6a 10                	push   $0x10
801047d2:	ff 75 c0             	pushl  -0x40(%ebp)
801047d5:	56                   	push   %esi
801047d6:	57                   	push   %edi
801047d7:	e8 d7 d0 ff ff       	call   801018b3 <writei>
801047dc:	83 c4 20             	add    $0x20,%esp
801047df:	83 f8 10             	cmp    $0x10,%eax
801047e2:	0f 85 9c 00 00 00    	jne    80104884 <sys_unlink+0x17d>
  if(ip->type == T_DIR){
801047e8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047ed:	0f 84 9e 00 00 00    	je     80104891 <sys_unlink+0x18a>
  iunlockput(dp);
801047f3:	83 ec 0c             	sub    $0xc,%esp
801047f6:	57                   	push   %edi
801047f7:	e8 70 cf ff ff       	call   8010176c <iunlockput>
  ip->nlink--;
801047fc:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104801:	89 1c 24             	mov    %ebx,(%esp)
80104804:	e8 70 cc ff ff       	call   80101479 <iupdate>
  iunlockput(ip);
80104809:	89 1c 24             	mov    %ebx,(%esp)
8010480c:	e8 5b cf ff ff       	call   8010176c <iunlockput>
  end_op();
80104811:	e8 4f e0 ff ff       	call   80102865 <end_op>
  return 0;
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010481e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5f                   	pop    %edi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
    end_op();
80104826:	e8 3a e0 ff ff       	call   80102865 <end_op>
    return -1;
8010482b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104830:	eb ec                	jmp    8010481e <sys_unlink+0x117>
    panic("unlink: nlink < 1");
80104832:	83 ec 0c             	sub    $0xc,%esp
80104835:	68 ee 6f 10 80       	push   $0x80106fee
8010483a:	e8 05 bb ff ff       	call   80100344 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010483f:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104843:	0f 86 77 ff ff ff    	jbe    801047c0 <sys_unlink+0xb9>
80104849:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010484e:	6a 10                	push   $0x10
80104850:	56                   	push   %esi
80104851:	8d 45 b0             	lea    -0x50(%ebp),%eax
80104854:	50                   	push   %eax
80104855:	53                   	push   %ebx
80104856:	e8 5c cf ff ff       	call   801017b7 <readi>
8010485b:	83 c4 10             	add    $0x10,%esp
8010485e:	83 f8 10             	cmp    $0x10,%eax
80104861:	75 14                	jne    80104877 <sys_unlink+0x170>
    if(de.inum != 0)
80104863:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
80104868:	75 47                	jne    801048b1 <sys_unlink+0x1aa>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010486a:	83 c6 10             	add    $0x10,%esi
8010486d:	3b 73 58             	cmp    0x58(%ebx),%esi
80104870:	72 dc                	jb     8010484e <sys_unlink+0x147>
80104872:	e9 49 ff ff ff       	jmp    801047c0 <sys_unlink+0xb9>
      panic("isdirempty: readi");
80104877:	83 ec 0c             	sub    $0xc,%esp
8010487a:	68 00 70 10 80       	push   $0x80107000
8010487f:	e8 c0 ba ff ff       	call   80100344 <panic>
    panic("unlink: writei");
80104884:	83 ec 0c             	sub    $0xc,%esp
80104887:	68 12 70 10 80       	push   $0x80107012
8010488c:	e8 b3 ba ff ff       	call   80100344 <panic>
    dp->nlink--;
80104891:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
80104896:	83 ec 0c             	sub    $0xc,%esp
80104899:	57                   	push   %edi
8010489a:	e8 da cb ff ff       	call   80101479 <iupdate>
8010489f:	83 c4 10             	add    $0x10,%esp
801048a2:	e9 4c ff ff ff       	jmp    801047f3 <sys_unlink+0xec>
    return -1;
801048a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ac:	e9 6d ff ff ff       	jmp    8010481e <sys_unlink+0x117>
    iunlockput(ip);
801048b1:	83 ec 0c             	sub    $0xc,%esp
801048b4:	53                   	push   %ebx
801048b5:	e8 b2 ce ff ff       	call   8010176c <iunlockput>
    goto bad;
801048ba:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801048bd:	83 ec 0c             	sub    $0xc,%esp
801048c0:	57                   	push   %edi
801048c1:	e8 a6 ce ff ff       	call   8010176c <iunlockput>
  end_op();
801048c6:	e8 9a df ff ff       	call   80102865 <end_op>
  return -1;
801048cb:	83 c4 10             	add    $0x10,%esp
801048ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d3:	e9 46 ff ff ff       	jmp    8010481e <sys_unlink+0x117>

801048d8 <sys_open>:

int
sys_open(void)
{
801048d8:	55                   	push   %ebp
801048d9:	89 e5                	mov    %esp,%ebp
801048db:	57                   	push   %edi
801048dc:	56                   	push   %esi
801048dd:	53                   	push   %ebx
801048de:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048e4:	50                   	push   %eax
801048e5:	6a 00                	push   $0x0
801048e7:	e8 6d f8 ff ff       	call   80104159 <argstr>
801048ec:	83 c4 10             	add    $0x10,%esp
801048ef:	85 c0                	test   %eax,%eax
801048f1:	0f 88 0b 01 00 00    	js     80104a02 <sys_open+0x12a>
801048f7:	83 ec 08             	sub    $0x8,%esp
801048fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048fd:	50                   	push   %eax
801048fe:	6a 01                	push   $0x1
80104900:	e8 c9 f7 ff ff       	call   801040ce <argint>
80104905:	83 c4 10             	add    $0x10,%esp
80104908:	85 c0                	test   %eax,%eax
8010490a:	0f 88 f9 00 00 00    	js     80104a09 <sys_open+0x131>
    return -1;

  begin_op();
80104910:	e8 d5 de ff ff       	call   801027ea <begin_op>

  if(omode & O_CREATE){
80104915:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104919:	0f 84 8a 00 00 00    	je     801049a9 <sys_open+0xd1>
    ip = create(path, T_FILE, 0, 0);
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	6a 00                	push   $0x0
80104924:	b9 00 00 00 00       	mov    $0x0,%ecx
80104929:	ba 02 00 00 00       	mov    $0x2,%edx
8010492e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104931:	e8 4b f9 ff ff       	call   80104281 <create>
80104936:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104938:	83 c4 10             	add    $0x10,%esp
8010493b:	85 c0                	test   %eax,%eax
8010493d:	74 5e                	je     8010499d <sys_open+0xc5>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010493f:	e8 61 c3 ff ff       	call   80100ca5 <filealloc>
80104944:	89 c3                	mov    %eax,%ebx
80104946:	85 c0                	test   %eax,%eax
80104948:	0f 84 ce 00 00 00    	je     80104a1c <sys_open+0x144>
8010494e:	e8 ee f8 ff ff       	call   80104241 <fdalloc>
80104953:	89 c7                	mov    %eax,%edi
80104955:	85 c0                	test   %eax,%eax
80104957:	0f 88 b3 00 00 00    	js     80104a10 <sys_open+0x138>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010495d:	83 ec 0c             	sub    $0xc,%esp
80104960:	56                   	push   %esi
80104961:	e8 7f cc ff ff       	call   801015e5 <iunlock>
  end_op();
80104966:	e8 fa de ff ff       	call   80102865 <end_op>

  f->type = FD_INODE;
8010496b:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104971:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104974:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010497b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010497e:	89 d0                	mov    %edx,%eax
80104980:	83 f0 01             	xor    $0x1,%eax
80104983:	83 e0 01             	and    $0x1,%eax
80104986:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104989:	83 c4 10             	add    $0x10,%esp
8010498c:	f6 c2 03             	test   $0x3,%dl
8010498f:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104993:	89 f8                	mov    %edi,%eax
80104995:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104998:	5b                   	pop    %ebx
80104999:	5e                   	pop    %esi
8010499a:	5f                   	pop    %edi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
      end_op();
8010499d:	e8 c3 de ff ff       	call   80102865 <end_op>
      return -1;
801049a2:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049a7:	eb ea                	jmp    80104993 <sys_open+0xbb>
    if((ip = namei(path)) == 0){
801049a9:	83 ec 0c             	sub    $0xc,%esp
801049ac:	ff 75 e4             	pushl  -0x1c(%ebp)
801049af:	e8 0c d3 ff ff       	call   80101cc0 <namei>
801049b4:	89 c6                	mov    %eax,%esi
801049b6:	83 c4 10             	add    $0x10,%esp
801049b9:	85 c0                	test   %eax,%eax
801049bb:	74 39                	je     801049f6 <sys_open+0x11e>
    ilock(ip);
801049bd:	83 ec 0c             	sub    $0xc,%esp
801049c0:	50                   	push   %eax
801049c1:	e8 5d cb ff ff       	call   80101523 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801049ce:	0f 85 6b ff ff ff    	jne    8010493f <sys_open+0x67>
801049d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049d8:	0f 84 61 ff ff ff    	je     8010493f <sys_open+0x67>
      iunlockput(ip);
801049de:	83 ec 0c             	sub    $0xc,%esp
801049e1:	56                   	push   %esi
801049e2:	e8 85 cd ff ff       	call   8010176c <iunlockput>
      end_op();
801049e7:	e8 79 de ff ff       	call   80102865 <end_op>
      return -1;
801049ec:	83 c4 10             	add    $0x10,%esp
801049ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049f4:	eb 9d                	jmp    80104993 <sys_open+0xbb>
      end_op();
801049f6:	e8 6a de ff ff       	call   80102865 <end_op>
      return -1;
801049fb:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a00:	eb 91                	jmp    80104993 <sys_open+0xbb>
    return -1;
80104a02:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a07:	eb 8a                	jmp    80104993 <sys_open+0xbb>
80104a09:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a0e:	eb 83                	jmp    80104993 <sys_open+0xbb>
      fileclose(f);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	53                   	push   %ebx
80104a14:	e8 3e c3 ff ff       	call   80100d57 <fileclose>
80104a19:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104a1c:	83 ec 0c             	sub    $0xc,%esp
80104a1f:	56                   	push   %esi
80104a20:	e8 47 cd ff ff       	call   8010176c <iunlockput>
    end_op();
80104a25:	e8 3b de ff ff       	call   80102865 <end_op>
    return -1;
80104a2a:	83 c4 10             	add    $0x10,%esp
80104a2d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a32:	e9 5c ff ff ff       	jmp    80104993 <sys_open+0xbb>

80104a37 <sys_mkdir>:

int
sys_mkdir(void)
{
80104a37:	55                   	push   %ebp
80104a38:	89 e5                	mov    %esp,%ebp
80104a3a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104a3d:	e8 a8 dd ff ff       	call   801027ea <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104a42:	83 ec 08             	sub    $0x8,%esp
80104a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a48:	50                   	push   %eax
80104a49:	6a 00                	push   $0x0
80104a4b:	e8 09 f7 ff ff       	call   80104159 <argstr>
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	85 c0                	test   %eax,%eax
80104a55:	78 36                	js     80104a8d <sys_mkdir+0x56>
80104a57:	83 ec 0c             	sub    $0xc,%esp
80104a5a:	6a 00                	push   $0x0
80104a5c:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a61:	ba 01 00 00 00       	mov    $0x1,%edx
80104a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a69:	e8 13 f8 ff ff       	call   80104281 <create>
80104a6e:	83 c4 10             	add    $0x10,%esp
80104a71:	85 c0                	test   %eax,%eax
80104a73:	74 18                	je     80104a8d <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	50                   	push   %eax
80104a79:	e8 ee cc ff ff       	call   8010176c <iunlockput>
  end_op();
80104a7e:	e8 e2 dd ff ff       	call   80102865 <end_op>
  return 0;
80104a83:	83 c4 10             	add    $0x10,%esp
80104a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a8b:	c9                   	leave  
80104a8c:	c3                   	ret    
    end_op();
80104a8d:	e8 d3 dd ff ff       	call   80102865 <end_op>
    return -1;
80104a92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a97:	eb f2                	jmp    80104a8b <sys_mkdir+0x54>

80104a99 <sys_mknod>:

int
sys_mknod(void)
{
80104a99:	55                   	push   %ebp
80104a9a:	89 e5                	mov    %esp,%ebp
80104a9c:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a9f:	e8 46 dd ff ff       	call   801027ea <begin_op>
  if((argstr(0, &path)) < 0 ||
80104aa4:	83 ec 08             	sub    $0x8,%esp
80104aa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aaa:	50                   	push   %eax
80104aab:	6a 00                	push   $0x0
80104aad:	e8 a7 f6 ff ff       	call   80104159 <argstr>
80104ab2:	83 c4 10             	add    $0x10,%esp
80104ab5:	85 c0                	test   %eax,%eax
80104ab7:	78 62                	js     80104b1b <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104ab9:	83 ec 08             	sub    $0x8,%esp
80104abc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104abf:	50                   	push   %eax
80104ac0:	6a 01                	push   $0x1
80104ac2:	e8 07 f6 ff ff       	call   801040ce <argint>
  if((argstr(0, &path)) < 0 ||
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	85 c0                	test   %eax,%eax
80104acc:	78 4d                	js     80104b1b <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104ace:	83 ec 08             	sub    $0x8,%esp
80104ad1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ad4:	50                   	push   %eax
80104ad5:	6a 02                	push   $0x2
80104ad7:	e8 f2 f5 ff ff       	call   801040ce <argint>
     argint(1, &major) < 0 ||
80104adc:	83 c4 10             	add    $0x10,%esp
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	78 38                	js     80104b1b <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104ae3:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80104ae7:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80104aea:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80104aee:	50                   	push   %eax
80104aef:	ba 03 00 00 00       	mov    $0x3,%edx
80104af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af7:	e8 85 f7 ff ff       	call   80104281 <create>
80104afc:	83 c4 10             	add    $0x10,%esp
80104aff:	85 c0                	test   %eax,%eax
80104b01:	74 18                	je     80104b1b <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104b03:	83 ec 0c             	sub    $0xc,%esp
80104b06:	50                   	push   %eax
80104b07:	e8 60 cc ff ff       	call   8010176c <iunlockput>
  end_op();
80104b0c:	e8 54 dd ff ff       	call   80102865 <end_op>
  return 0;
80104b11:	83 c4 10             	add    $0x10,%esp
80104b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b19:	c9                   	leave  
80104b1a:	c3                   	ret    
    end_op();
80104b1b:	e8 45 dd ff ff       	call   80102865 <end_op>
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb f2                	jmp    80104b19 <sys_mknod+0x80>

80104b27 <sys_chdir>:

int
sys_chdir(void)
{
80104b27:	55                   	push   %ebp
80104b28:	89 e5                	mov    %esp,%ebp
80104b2a:	56                   	push   %esi
80104b2b:	53                   	push   %ebx
80104b2c:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104b2f:	e8 42 e8 ff ff       	call   80103376 <myproc>
80104b34:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104b36:	e8 af dc ff ff       	call   801027ea <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104b3b:	83 ec 08             	sub    $0x8,%esp
80104b3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b41:	50                   	push   %eax
80104b42:	6a 00                	push   $0x0
80104b44:	e8 10 f6 ff ff       	call   80104159 <argstr>
80104b49:	83 c4 10             	add    $0x10,%esp
80104b4c:	85 c0                	test   %eax,%eax
80104b4e:	78 52                	js     80104ba2 <sys_chdir+0x7b>
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	ff 75 f4             	pushl  -0xc(%ebp)
80104b56:	e8 65 d1 ff ff       	call   80101cc0 <namei>
80104b5b:	89 c3                	mov    %eax,%ebx
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	85 c0                	test   %eax,%eax
80104b62:	74 3e                	je     80104ba2 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	50                   	push   %eax
80104b68:	e8 b6 c9 ff ff       	call   80101523 <ilock>
  if(ip->type != T_DIR){
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b75:	75 37                	jne    80104bae <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b77:	83 ec 0c             	sub    $0xc,%esp
80104b7a:	53                   	push   %ebx
80104b7b:	e8 65 ca ff ff       	call   801015e5 <iunlock>
  iput(curproc->cwd);
80104b80:	83 c4 04             	add    $0x4,%esp
80104b83:	ff 76 68             	pushl  0x68(%esi)
80104b86:	e8 9f ca ff ff       	call   8010162a <iput>
  end_op();
80104b8b:	e8 d5 dc ff ff       	call   80102865 <end_op>
  curproc->cwd = ip;
80104b90:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b93:	83 c4 10             	add    $0x10,%esp
80104b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b9e:	5b                   	pop    %ebx
80104b9f:	5e                   	pop    %esi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret    
    end_op();
80104ba2:	e8 be dc ff ff       	call   80102865 <end_op>
    return -1;
80104ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bac:	eb ed                	jmp    80104b9b <sys_chdir+0x74>
    iunlockput(ip);
80104bae:	83 ec 0c             	sub    $0xc,%esp
80104bb1:	53                   	push   %ebx
80104bb2:	e8 b5 cb ff ff       	call   8010176c <iunlockput>
    end_op();
80104bb7:	e8 a9 dc ff ff       	call   80102865 <end_op>
    return -1;
80104bbc:	83 c4 10             	add    $0x10,%esp
80104bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc4:	eb d5                	jmp    80104b9b <sys_chdir+0x74>

80104bc6 <sys_exec>:

int
sys_exec(void)
{
80104bc6:	55                   	push   %ebp
80104bc7:	89 e5                	mov    %esp,%ebp
80104bc9:	57                   	push   %edi
80104bca:	56                   	push   %esi
80104bcb:	53                   	push   %ebx
80104bcc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104bd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104bd5:	50                   	push   %eax
80104bd6:	6a 00                	push   $0x0
80104bd8:	e8 7c f5 ff ff       	call   80104159 <argstr>
80104bdd:	83 c4 10             	add    $0x10,%esp
80104be0:	85 c0                	test   %eax,%eax
80104be2:	0f 88 b4 00 00 00    	js     80104c9c <sys_exec+0xd6>
80104be8:	83 ec 08             	sub    $0x8,%esp
80104beb:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104bf1:	50                   	push   %eax
80104bf2:	6a 01                	push   $0x1
80104bf4:	e8 d5 f4 ff ff       	call   801040ce <argint>
80104bf9:	83 c4 10             	add    $0x10,%esp
80104bfc:	85 c0                	test   %eax,%eax
80104bfe:	0f 88 9f 00 00 00    	js     80104ca3 <sys_exec+0xdd>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	68 80 00 00 00       	push   $0x80
80104c0c:	6a 00                	push   $0x0
80104c0e:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104c14:	50                   	push   %eax
80104c15:	e8 2e f2 ff ff       	call   80103e48 <memset>
80104c1a:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104c1d:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104c22:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104c28:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
80104c2f:	83 ec 08             	sub    $0x8,%esp
80104c32:	57                   	push   %edi
80104c33:	89 d8                	mov    %ebx,%eax
80104c35:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80104c3b:	50                   	push   %eax
80104c3c:	e8 01 f4 ff ff       	call   80104042 <fetchint>
80104c41:	83 c4 10             	add    $0x10,%esp
80104c44:	85 c0                	test   %eax,%eax
80104c46:	78 62                	js     80104caa <sys_exec+0xe4>
      return -1;
    if(uarg == 0){
80104c48:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104c4e:	85 c0                	test   %eax,%eax
80104c50:	74 28                	je     80104c7a <sys_exec+0xb4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104c52:	83 ec 08             	sub    $0x8,%esp
80104c55:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
80104c5b:	01 d3                	add    %edx,%ebx
80104c5d:	53                   	push   %ebx
80104c5e:	50                   	push   %eax
80104c5f:	e8 1a f4 ff ff       	call   8010407e <fetchstr>
80104c64:	83 c4 10             	add    $0x10,%esp
80104c67:	85 c0                	test   %eax,%eax
80104c69:	78 4c                	js     80104cb7 <sys_exec+0xf1>
  for(i=0;; i++){
80104c6b:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80104c6e:	83 fe 20             	cmp    $0x20,%esi
80104c71:	75 b5                	jne    80104c28 <sys_exec+0x62>
      return -1;
80104c73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c78:	eb 35                	jmp    80104caf <sys_exec+0xe9>
      argv[i] = 0;
80104c7a:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80104c81:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
80104c85:	83 ec 08             	sub    $0x8,%esp
80104c88:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104c8e:	50                   	push   %eax
80104c8f:	ff 75 e4             	pushl  -0x1c(%ebp)
80104c92:	e8 7b bc ff ff       	call   80100912 <exec>
80104c97:	83 c4 10             	add    $0x10,%esp
80104c9a:	eb 13                	jmp    80104caf <sys_exec+0xe9>
    return -1;
80104c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca1:	eb 0c                	jmp    80104caf <sys_exec+0xe9>
80104ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca8:	eb 05                	jmp    80104caf <sys_exec+0xe9>
      return -1;
80104caa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cb2:	5b                   	pop    %ebx
80104cb3:	5e                   	pop    %esi
80104cb4:	5f                   	pop    %edi
80104cb5:	5d                   	pop    %ebp
80104cb6:	c3                   	ret    
      return -1;
80104cb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbc:	eb f1                	jmp    80104caf <sys_exec+0xe9>

80104cbe <sys_pipe>:

int
sys_pipe(void)
{
80104cbe:	55                   	push   %ebp
80104cbf:	89 e5                	mov    %esp,%ebp
80104cc1:	53                   	push   %ebx
80104cc2:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104cc5:	6a 08                	push   $0x8
80104cc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cca:	50                   	push   %eax
80104ccb:	6a 00                	push   $0x0
80104ccd:	e8 22 f4 ff ff       	call   801040f4 <argptr>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	78 46                	js     80104d1f <sys_pipe+0x61>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104cd9:	83 ec 08             	sub    $0x8,%esp
80104cdc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cdf:	50                   	push   %eax
80104ce0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ce3:	50                   	push   %eax
80104ce4:	e8 35 e1 ff ff       	call   80102e1e <pipealloc>
80104ce9:	83 c4 10             	add    $0x10,%esp
80104cec:	85 c0                	test   %eax,%eax
80104cee:	78 36                	js     80104d26 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cf3:	e8 49 f5 ff ff       	call   80104241 <fdalloc>
80104cf8:	89 c3                	mov    %eax,%ebx
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	78 3c                	js     80104d3a <sys_pipe+0x7c>
80104cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d01:	e8 3b f5 ff ff       	call   80104241 <fdalloc>
80104d06:	85 c0                	test   %eax,%eax
80104d08:	78 23                	js     80104d2d <sys_pipe+0x6f>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104d0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d0d:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d12:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d1d:	c9                   	leave  
80104d1e:	c3                   	ret    
    return -1;
80104d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d24:	eb f4                	jmp    80104d1a <sys_pipe+0x5c>
    return -1;
80104d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d2b:	eb ed                	jmp    80104d1a <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104d2d:	e8 44 e6 ff ff       	call   80103376 <myproc>
80104d32:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d39:	00 
    fileclose(rf);
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	ff 75 f0             	pushl  -0x10(%ebp)
80104d40:	e8 12 c0 ff ff       	call   80100d57 <fileclose>
    fileclose(wf);
80104d45:	83 c4 04             	add    $0x4,%esp
80104d48:	ff 75 ec             	pushl  -0x14(%ebp)
80104d4b:	e8 07 c0 ff ff       	call   80100d57 <fileclose>
    return -1;
80104d50:	83 c4 10             	add    $0x10,%esp
80104d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d58:	eb c0                	jmp    80104d1a <sys_pipe+0x5c>

80104d5a <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104d5a:	55                   	push   %ebp
80104d5b:	89 e5                	mov    %esp,%ebp
80104d5d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d60:	e8 89 e7 ff ff       	call   801034ee <fork>
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    

80104d67 <sys_exit>:

int
sys_exit(void)
{
80104d67:	55                   	push   %ebp
80104d68:	89 e5                	mov    %esp,%ebp
80104d6a:	83 ec 08             	sub    $0x8,%esp
  exit();
80104d6d:	e8 b6 e9 ff ff       	call   80103728 <exit>
  return 0;  // not reached
}
80104d72:	b8 00 00 00 00       	mov    $0x0,%eax
80104d77:	c9                   	leave  
80104d78:	c3                   	ret    

80104d79 <sys_wait>:

int
sys_wait(void)
{
80104d79:	55                   	push   %ebp
80104d7a:	89 e5                	mov    %esp,%ebp
80104d7c:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104d7f:	e8 3f eb ff ff       	call   801038c3 <wait>
}
80104d84:	c9                   	leave  
80104d85:	c3                   	ret    

80104d86 <sys_kill>:

int
sys_kill(void)
{
80104d86:	55                   	push   %ebp
80104d87:	89 e5                	mov    %esp,%ebp
80104d89:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104d8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d8f:	50                   	push   %eax
80104d90:	6a 00                	push   $0x0
80104d92:	e8 37 f3 ff ff       	call   801040ce <argint>
80104d97:	83 c4 10             	add    $0x10,%esp
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	78 10                	js     80104dae <sys_kill+0x28>
    return -1;
  return kill(pid);
80104d9e:	83 ec 0c             	sub    $0xc,%esp
80104da1:	ff 75 f4             	pushl  -0xc(%ebp)
80104da4:	e8 4f ec ff ff       	call   801039f8 <kill>
80104da9:	83 c4 10             	add    $0x10,%esp
}
80104dac:	c9                   	leave  
80104dad:	c3                   	ret    
    return -1;
80104dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104db3:	eb f7                	jmp    80104dac <sys_kill+0x26>

80104db5 <sys_getpid>:

int
sys_getpid(void)
{
80104db5:	55                   	push   %ebp
80104db6:	89 e5                	mov    %esp,%ebp
80104db8:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104dbb:	e8 b6 e5 ff ff       	call   80103376 <myproc>
80104dc0:	8b 40 10             	mov    0x10(%eax),%eax
}
80104dc3:	c9                   	leave  
80104dc4:	c3                   	ret    

80104dc5 <sys_sbrk>:

int
sys_sbrk(void)
{
80104dc5:	55                   	push   %ebp
80104dc6:	89 e5                	mov    %esp,%ebp
80104dc8:	53                   	push   %ebx
80104dc9:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104dcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dcf:	50                   	push   %eax
80104dd0:	6a 00                	push   $0x0
80104dd2:	e8 f7 f2 ff ff       	call   801040ce <argint>
80104dd7:	83 c4 10             	add    $0x10,%esp
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	78 26                	js     80104e04 <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
80104dde:	e8 93 e5 ff ff       	call   80103376 <myproc>
80104de3:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104de5:	83 ec 0c             	sub    $0xc,%esp
80104de8:	ff 75 f4             	pushl  -0xc(%ebp)
80104deb:	e8 91 e6 ff ff       	call   80103481 <growproc>
80104df0:	83 c4 10             	add    $0x10,%esp
80104df3:	85 c0                	test   %eax,%eax
    return -1;
80104df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfa:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
80104dfd:	89 d8                	mov    %ebx,%eax
80104dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e02:	c9                   	leave  
80104e03:	c3                   	ret    
    return -1;
80104e04:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e09:	eb f2                	jmp    80104dfd <sys_sbrk+0x38>

80104e0b <sys_sleep>:

int
sys_sleep(void)
{
80104e0b:	55                   	push   %ebp
80104e0c:	89 e5                	mov    %esp,%ebp
80104e0e:	53                   	push   %ebx
80104e0f:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e15:	50                   	push   %eax
80104e16:	6a 00                	push   $0x0
80104e18:	e8 b1 f2 ff ff       	call   801040ce <argint>
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 79                	js     80104e9d <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	68 60 50 11 80       	push   $0x80115060
80104e2c:	e8 69 ef ff ff       	call   80103d9a <acquire>
  ticks0 = ticks;
80104e31:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e3e:	74 2c                	je     80104e6c <sys_sleep+0x61>
    if(myproc()->killed){
80104e40:	e8 31 e5 ff ff       	call   80103376 <myproc>
80104e45:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e49:	75 3b                	jne    80104e86 <sys_sleep+0x7b>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104e4b:	83 ec 08             	sub    $0x8,%esp
80104e4e:	68 60 50 11 80       	push   $0x80115060
80104e53:	68 a0 58 11 80       	push   $0x801158a0
80104e58:	e8 c4 e9 ff ff       	call   80103821 <sleep>
  while(ticks - ticks0 < n){
80104e5d:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80104e62:	29 d8                	sub    %ebx,%eax
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e6a:	72 d4                	jb     80104e40 <sys_sleep+0x35>
  }
  release(&tickslock);
80104e6c:	83 ec 0c             	sub    $0xc,%esp
80104e6f:	68 60 50 11 80       	push   $0x80115060
80104e74:	e8 88 ef ff ff       	call   80103e01 <release>
  return 0;
80104e79:	83 c4 10             	add    $0x10,%esp
80104e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e84:	c9                   	leave  
80104e85:	c3                   	ret    
      release(&tickslock);
80104e86:	83 ec 0c             	sub    $0xc,%esp
80104e89:	68 60 50 11 80       	push   $0x80115060
80104e8e:	e8 6e ef ff ff       	call   80103e01 <release>
      return -1;
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9b:	eb e4                	jmp    80104e81 <sys_sleep+0x76>
    return -1;
80104e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea2:	eb dd                	jmp    80104e81 <sys_sleep+0x76>

80104ea4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	53                   	push   %ebx
80104ea8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104eab:	68 60 50 11 80       	push   $0x80115060
80104eb0:	e8 e5 ee ff ff       	call   80103d9a <acquire>
  xticks = ticks;
80104eb5:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
80104ebb:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80104ec2:	e8 3a ef ff ff       	call   80103e01 <release>
  return xticks;
}
80104ec7:	89 d8                	mov    %ebx,%eax
80104ec9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ecc:	c9                   	leave  
80104ecd:	c3                   	ret    

80104ece <sys_shmem_access>:

int 
sys_shmem_access(void){
80104ece:	55                   	push   %ebp
80104ecf:	89 e5                	mov    %esp,%ebp
80104ed1:	83 ec 20             	sub    $0x20,%esp
  
  int page_number;
  if(argint(0, &page_number) < 0) {
80104ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ed7:	50                   	push   %eax
80104ed8:	6a 00                	push   $0x0
80104eda:	e8 ef f1 ff ff       	call   801040ce <argint>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	78 10                	js     80104ef6 <sys_shmem_access+0x28>
    cprintf("page number is illege in sys_shmem_access");
    return -1;
  }
  return (int)shmem_access(page_number);
80104ee6:	83 ec 0c             	sub    $0xc,%esp
80104ee9:	ff 75 f4             	pushl  -0xc(%ebp)
80104eec:	e8 00 18 00 00       	call   801066f1 <shmem_access>
80104ef1:	83 c4 10             	add    $0x10,%esp
  
}
80104ef4:	c9                   	leave  
80104ef5:	c3                   	ret    
    cprintf("page number is illege in sys_shmem_access");
80104ef6:	83 ec 0c             	sub    $0xc,%esp
80104ef9:	68 24 70 10 80       	push   $0x80107024
80104efe:	e8 de b6 ff ff       	call   801005e1 <cprintf>
    return -1;
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0b:	eb e7                	jmp    80104ef4 <sys_shmem_access+0x26>

80104f0d <sys_shmem_count>:

int 
sys_shmem_count(void){
80104f0d:	55                   	push   %ebp
80104f0e:	89 e5                	mov    %esp,%ebp
80104f10:	83 ec 20             	sub    $0x20,%esp
  int page_number;
  if(argint(0, &page_number) < 0) {
80104f13:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f16:	50                   	push   %eax
80104f17:	6a 00                	push   $0x0
80104f19:	e8 b0 f1 ff ff       	call   801040ce <argint>
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 10                	js     80104f35 <sys_shmem_count+0x28>
    cprintf("page number is illege in sys_shmem_count");
    return -1;
  }
  return shmem_count(page_number);
80104f25:	83 ec 0c             	sub    $0xc,%esp
80104f28:	ff 75 f4             	pushl  -0xc(%ebp)
80104f2b:	e8 1f 19 00 00       	call   8010684f <shmem_count>
80104f30:	83 c4 10             	add    $0x10,%esp
80104f33:	c9                   	leave  
80104f34:	c3                   	ret    
    cprintf("page number is illege in sys_shmem_count");
80104f35:	83 ec 0c             	sub    $0xc,%esp
80104f38:	68 50 70 10 80       	push   $0x80107050
80104f3d:	e8 9f b6 ff ff       	call   801005e1 <cprintf>
    return -1;
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4a:	eb e7                	jmp    80104f33 <sys_shmem_count+0x26>

80104f4c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104f4c:	1e                   	push   %ds
  pushl %es
80104f4d:	06                   	push   %es
  pushl %fs
80104f4e:	0f a0                	push   %fs
  pushl %gs
80104f50:	0f a8                	push   %gs
  pushal
80104f52:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104f53:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104f57:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104f59:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104f5b:	54                   	push   %esp
  call trap
80104f5c:	e8 bd 00 00 00       	call   8010501e <trap>
  addl $4, %esp
80104f61:	83 c4 04             	add    $0x4,%esp

80104f64 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104f64:	61                   	popa   
  popl %gs
80104f65:	0f a9                	pop    %gs
  popl %fs
80104f67:	0f a1                	pop    %fs
  popl %es
80104f69:	07                   	pop    %es
  popl %ds
80104f6a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104f6b:	83 c4 08             	add    $0x8,%esp
  iret
80104f6e:	cf                   	iret   

80104f6f <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104f6f:	55                   	push   %ebp
80104f70:	89 e5                	mov    %esp,%ebp
80104f72:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104f75:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f7a:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80104f81:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
80104f88:	80 
80104f89:	66 c7 04 c5 a2 50 11 	movw   $0x8,-0x7feeaf5e(,%eax,8)
80104f90:	80 08 00 
80104f93:	c6 04 c5 a4 50 11 80 	movb   $0x0,-0x7feeaf5c(,%eax,8)
80104f9a:	00 
80104f9b:	c6 04 c5 a5 50 11 80 	movb   $0x8e,-0x7feeaf5b(,%eax,8)
80104fa2:	8e 
80104fa3:	c1 ea 10             	shr    $0x10,%edx
80104fa6:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
80104fad:	80 
  for(i = 0; i < 256; i++)
80104fae:	83 c0 01             	add    $0x1,%eax
80104fb1:	3d 00 01 00 00       	cmp    $0x100,%eax
80104fb6:	75 c2                	jne    80104f7a <tvinit+0xb>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104fb8:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80104fbd:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80104fc3:	66 c7 05 a2 52 11 80 	movw   $0x8,0x801152a2
80104fca:	08 00 
80104fcc:	c6 05 a4 52 11 80 00 	movb   $0x0,0x801152a4
80104fd3:	c6 05 a5 52 11 80 ef 	movb   $0xef,0x801152a5
80104fda:	c1 e8 10             	shr    $0x10,%eax
80104fdd:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6

  initlock(&tickslock, "time");
80104fe3:	83 ec 08             	sub    $0x8,%esp
80104fe6:	68 79 70 10 80       	push   $0x80107079
80104feb:	68 60 50 11 80       	push   $0x80115060
80104ff0:	e8 5d ec ff ff       	call   80103c52 <initlock>
}
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	c9                   	leave  
80104ff9:	c3                   	ret    

80104ffa <idtinit>:

void
idtinit(void)
{
80104ffa:	55                   	push   %ebp
80104ffb:	89 e5                	mov    %esp,%ebp
80104ffd:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105000:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105006:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
8010500b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010500f:	c1 e8 10             	shr    $0x10,%eax
80105012:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105016:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105019:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
8010501c:	c9                   	leave  
8010501d:	c3                   	ret    

8010501e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010501e:	55                   	push   %ebp
8010501f:	89 e5                	mov    %esp,%ebp
80105021:	57                   	push   %edi
80105022:	56                   	push   %esi
80105023:	53                   	push   %ebx
80105024:	83 ec 1c             	sub    $0x1c,%esp
80105027:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010502a:	8b 47 30             	mov    0x30(%edi),%eax
8010502d:	83 f8 40             	cmp    $0x40,%eax
80105030:	74 13                	je     80105045 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105032:	83 e8 20             	sub    $0x20,%eax
80105035:	83 f8 1f             	cmp    $0x1f,%eax
80105038:	0f 87 37 01 00 00    	ja     80105175 <trap+0x157>
8010503e:	ff 24 85 20 71 10 80 	jmp    *-0x7fef8ee0(,%eax,4)
    if(myproc()->killed)
80105045:	e8 2c e3 ff ff       	call   80103376 <myproc>
8010504a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010504e:	75 1f                	jne    8010506f <trap+0x51>
    myproc()->tf = tf;
80105050:	e8 21 e3 ff ff       	call   80103376 <myproc>
80105055:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105058:	e8 2f f1 ff ff       	call   8010418c <syscall>
    if(myproc()->killed)
8010505d:	e8 14 e3 ff ff       	call   80103376 <myproc>
80105062:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105066:	74 7e                	je     801050e6 <trap+0xc8>
      exit();
80105068:	e8 bb e6 ff ff       	call   80103728 <exit>
8010506d:	eb 77                	jmp    801050e6 <trap+0xc8>
      exit();
8010506f:	e8 b4 e6 ff ff       	call   80103728 <exit>
80105074:	eb da                	jmp    80105050 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105076:	e8 e0 e2 ff ff       	call   8010335b <cpuid>
8010507b:	85 c0                	test   %eax,%eax
8010507d:	74 6f                	je     801050ee <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
8010507f:	e8 13 d4 ff ff       	call   80102497 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105084:	e8 ed e2 ff ff       	call   80103376 <myproc>
80105089:	85 c0                	test   %eax,%eax
8010508b:	74 1c                	je     801050a9 <trap+0x8b>
8010508d:	e8 e4 e2 ff ff       	call   80103376 <myproc>
80105092:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105096:	74 11                	je     801050a9 <trap+0x8b>
80105098:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010509c:	83 e0 03             	and    $0x3,%eax
8010509f:	66 83 f8 03          	cmp    $0x3,%ax
801050a3:	0f 84 60 01 00 00    	je     80105209 <trap+0x1eb>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801050a9:	e8 c8 e2 ff ff       	call   80103376 <myproc>
801050ae:	85 c0                	test   %eax,%eax
801050b0:	74 0f                	je     801050c1 <trap+0xa3>
801050b2:	e8 bf e2 ff ff       	call   80103376 <myproc>
801050b7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801050bb:	0f 84 52 01 00 00    	je     80105213 <trap+0x1f5>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801050c1:	e8 b0 e2 ff ff       	call   80103376 <myproc>
801050c6:	85 c0                	test   %eax,%eax
801050c8:	74 1c                	je     801050e6 <trap+0xc8>
801050ca:	e8 a7 e2 ff ff       	call   80103376 <myproc>
801050cf:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050d3:	74 11                	je     801050e6 <trap+0xc8>
801050d5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801050d9:	83 e0 03             	and    $0x3,%eax
801050dc:	66 83 f8 03          	cmp    $0x3,%ax
801050e0:	0f 84 41 01 00 00    	je     80105227 <trap+0x209>
    exit();
}
801050e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5f                   	pop    %edi
801050ec:	5d                   	pop    %ebp
801050ed:	c3                   	ret    
      acquire(&tickslock);
801050ee:	83 ec 0c             	sub    $0xc,%esp
801050f1:	68 60 50 11 80       	push   $0x80115060
801050f6:	e8 9f ec ff ff       	call   80103d9a <acquire>
      ticks++;
801050fb:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
80105102:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80105109:	e8 c1 e8 ff ff       	call   801039cf <wakeup>
      release(&tickslock);
8010510e:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105115:	e8 e7 ec ff ff       	call   80103e01 <release>
8010511a:	83 c4 10             	add    $0x10,%esp
8010511d:	e9 5d ff ff ff       	jmp    8010507f <trap+0x61>
    ideintr();
80105122:	e8 06 cd ff ff       	call   80101e2d <ideintr>
    lapiceoi();
80105127:	e8 6b d3 ff ff       	call   80102497 <lapiceoi>
    break;
8010512c:	e9 53 ff ff ff       	jmp    80105084 <trap+0x66>
    kbdintr();
80105131:	e8 95 d1 ff ff       	call   801022cb <kbdintr>
    lapiceoi();
80105136:	e8 5c d3 ff ff       	call   80102497 <lapiceoi>
    break;
8010513b:	e9 44 ff ff ff       	jmp    80105084 <trap+0x66>
    uartintr();
80105140:	e8 1a 02 00 00       	call   8010535f <uartintr>
    lapiceoi();
80105145:	e8 4d d3 ff ff       	call   80102497 <lapiceoi>
    break;
8010514a:	e9 35 ff ff ff       	jmp    80105084 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010514f:	8b 77 38             	mov    0x38(%edi),%esi
80105152:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105156:	e8 00 e2 ff ff       	call   8010335b <cpuid>
8010515b:	56                   	push   %esi
8010515c:	53                   	push   %ebx
8010515d:	50                   	push   %eax
8010515e:	68 84 70 10 80       	push   $0x80107084
80105163:	e8 79 b4 ff ff       	call   801005e1 <cprintf>
    lapiceoi();
80105168:	e8 2a d3 ff ff       	call   80102497 <lapiceoi>
    break;
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	e9 0f ff ff ff       	jmp    80105084 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105175:	e8 fc e1 ff ff       	call   80103376 <myproc>
8010517a:	85 c0                	test   %eax,%eax
8010517c:	74 60                	je     801051de <trap+0x1c0>
8010517e:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105182:	74 5a                	je     801051de <trap+0x1c0>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105184:	0f 20 d0             	mov    %cr2,%eax
80105187:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010518a:	8b 77 38             	mov    0x38(%edi),%esi
8010518d:	e8 c9 e1 ff ff       	call   8010335b <cpuid>
80105192:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105195:	8b 5f 34             	mov    0x34(%edi),%ebx
80105198:	8b 4f 30             	mov    0x30(%edi),%ecx
8010519b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010519e:	e8 d3 e1 ff ff       	call   80103376 <myproc>
801051a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801051a6:	e8 cb e1 ff ff       	call   80103376 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801051ab:	ff 75 d8             	pushl  -0x28(%ebp)
801051ae:	56                   	push   %esi
801051af:	ff 75 e4             	pushl  -0x1c(%ebp)
801051b2:	53                   	push   %ebx
801051b3:	ff 75 e0             	pushl  -0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801051b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801051b9:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801051bc:	52                   	push   %edx
801051bd:	ff 70 10             	pushl  0x10(%eax)
801051c0:	68 dc 70 10 80       	push   $0x801070dc
801051c5:	e8 17 b4 ff ff       	call   801005e1 <cprintf>
    myproc()->killed = 1;
801051ca:	83 c4 20             	add    $0x20,%esp
801051cd:	e8 a4 e1 ff ff       	call   80103376 <myproc>
801051d2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801051d9:	e9 a6 fe ff ff       	jmp    80105084 <trap+0x66>
801051de:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801051e1:	8b 5f 38             	mov    0x38(%edi),%ebx
801051e4:	e8 72 e1 ff ff       	call   8010335b <cpuid>
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	56                   	push   %esi
801051ed:	53                   	push   %ebx
801051ee:	50                   	push   %eax
801051ef:	ff 77 30             	pushl  0x30(%edi)
801051f2:	68 a8 70 10 80       	push   $0x801070a8
801051f7:	e8 e5 b3 ff ff       	call   801005e1 <cprintf>
      panic("trap");
801051fc:	83 c4 14             	add    $0x14,%esp
801051ff:	68 7e 70 10 80       	push   $0x8010707e
80105204:	e8 3b b1 ff ff       	call   80100344 <panic>
    exit();
80105209:	e8 1a e5 ff ff       	call   80103728 <exit>
8010520e:	e9 96 fe ff ff       	jmp    801050a9 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105213:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105217:	0f 85 a4 fe ff ff    	jne    801050c1 <trap+0xa3>
    yield();
8010521d:	e8 cd e5 ff ff       	call   801037ef <yield>
80105222:	e9 9a fe ff ff       	jmp    801050c1 <trap+0xa3>
    exit();
80105227:	e8 fc e4 ff ff       	call   80103728 <exit>
8010522c:	e9 b5 fe ff ff       	jmp    801050e6 <trap+0xc8>

80105231 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105231:	55                   	push   %ebp
80105232:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105234:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
8010523b:	74 15                	je     80105252 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010523d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105242:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105243:	a8 01                	test   $0x1,%al
80105245:	74 12                	je     80105259 <uartgetc+0x28>
80105247:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010524c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010524d:	0f b6 c0             	movzbl %al,%eax
}
80105250:	5d                   	pop    %ebp
80105251:	c3                   	ret    
    return -1;
80105252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105257:	eb f7                	jmp    80105250 <uartgetc+0x1f>
    return -1;
80105259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525e:	eb f0                	jmp    80105250 <uartgetc+0x1f>

80105260 <uartputc>:
  if(!uart)
80105260:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105267:	74 4f                	je     801052b8 <uartputc+0x58>
{
80105269:	55                   	push   %ebp
8010526a:	89 e5                	mov    %esp,%ebp
8010526c:	56                   	push   %esi
8010526d:	53                   	push   %ebx
8010526e:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105273:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105274:	a8 20                	test   $0x20,%al
80105276:	75 30                	jne    801052a8 <uartputc+0x48>
    microdelay(10);
80105278:	83 ec 0c             	sub    $0xc,%esp
8010527b:	6a 0a                	push   $0xa
8010527d:	e8 34 d2 ff ff       	call   801024b6 <microdelay>
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	bb 7f 00 00 00       	mov    $0x7f,%ebx
8010528a:	be fd 03 00 00       	mov    $0x3fd,%esi
8010528f:	89 f2                	mov    %esi,%edx
80105291:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105292:	a8 20                	test   $0x20,%al
80105294:	75 12                	jne    801052a8 <uartputc+0x48>
    microdelay(10);
80105296:	83 ec 0c             	sub    $0xc,%esp
80105299:	6a 0a                	push   $0xa
8010529b:	e8 16 d2 ff ff       	call   801024b6 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	83 eb 01             	sub    $0x1,%ebx
801052a6:	75 e7                	jne    8010528f <uartputc+0x2f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801052a8:	8b 45 08             	mov    0x8(%ebp),%eax
801052ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052b0:	ee                   	out    %al,(%dx)
}
801052b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b4:	5b                   	pop    %ebx
801052b5:	5e                   	pop    %esi
801052b6:	5d                   	pop    %ebp
801052b7:	c3                   	ret    
801052b8:	f3 c3                	repz ret 

801052ba <uartinit>:
{
801052ba:	55                   	push   %ebp
801052bb:	89 e5                	mov    %esp,%ebp
801052bd:	56                   	push   %esi
801052be:	53                   	push   %ebx
801052bf:	b9 00 00 00 00       	mov    $0x0,%ecx
801052c4:	ba fa 03 00 00       	mov    $0x3fa,%edx
801052c9:	89 c8                	mov    %ecx,%eax
801052cb:	ee                   	out    %al,(%dx)
801052cc:	be fb 03 00 00       	mov    $0x3fb,%esi
801052d1:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801052d6:	89 f2                	mov    %esi,%edx
801052d8:	ee                   	out    %al,(%dx)
801052d9:	b8 0c 00 00 00       	mov    $0xc,%eax
801052de:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052e3:	ee                   	out    %al,(%dx)
801052e4:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801052e9:	89 c8                	mov    %ecx,%eax
801052eb:	89 da                	mov    %ebx,%edx
801052ed:	ee                   	out    %al,(%dx)
801052ee:	b8 03 00 00 00       	mov    $0x3,%eax
801052f3:	89 f2                	mov    %esi,%edx
801052f5:	ee                   	out    %al,(%dx)
801052f6:	ba fc 03 00 00       	mov    $0x3fc,%edx
801052fb:	89 c8                	mov    %ecx,%eax
801052fd:	ee                   	out    %al,(%dx)
801052fe:	b8 01 00 00 00       	mov    $0x1,%eax
80105303:	89 da                	mov    %ebx,%edx
80105305:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105306:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010530b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010530c:	3c ff                	cmp    $0xff,%al
8010530e:	74 48                	je     80105358 <uartinit+0x9e>
  uart = 1;
80105310:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105317:	00 00 00 
8010531a:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010531f:	ec                   	in     (%dx),%al
80105320:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105325:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105326:	83 ec 08             	sub    $0x8,%esp
80105329:	6a 00                	push   $0x0
8010532b:	6a 04                	push   $0x4
8010532d:	e8 11 cd ff ff       	call   80102043 <ioapicenable>
80105332:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105335:	bb a0 71 10 80       	mov    $0x801071a0,%ebx
8010533a:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	0f be c0             	movsbl %al,%eax
80105345:	50                   	push   %eax
80105346:	e8 15 ff ff ff       	call   80105260 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010534b:	83 c3 01             	add    $0x1,%ebx
8010534e:	0f b6 03             	movzbl (%ebx),%eax
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	84 c0                	test   %al,%al
80105356:	75 e7                	jne    8010533f <uartinit+0x85>
}
80105358:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010535b:	5b                   	pop    %ebx
8010535c:	5e                   	pop    %esi
8010535d:	5d                   	pop    %ebp
8010535e:	c3                   	ret    

8010535f <uartintr>:

void
uartintr(void)
{
8010535f:	55                   	push   %ebp
80105360:	89 e5                	mov    %esp,%ebp
80105362:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105365:	68 31 52 10 80       	push   $0x80105231
8010536a:	e8 cc b3 ff ff       	call   8010073b <consoleintr>
}
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	c9                   	leave  
80105373:	c3                   	ret    

80105374 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105374:	6a 00                	push   $0x0
  pushl $0
80105376:	6a 00                	push   $0x0
  jmp alltraps
80105378:	e9 cf fb ff ff       	jmp    80104f4c <alltraps>

8010537d <vector1>:
.globl vector1
vector1:
  pushl $0
8010537d:	6a 00                	push   $0x0
  pushl $1
8010537f:	6a 01                	push   $0x1
  jmp alltraps
80105381:	e9 c6 fb ff ff       	jmp    80104f4c <alltraps>

80105386 <vector2>:
.globl vector2
vector2:
  pushl $0
80105386:	6a 00                	push   $0x0
  pushl $2
80105388:	6a 02                	push   $0x2
  jmp alltraps
8010538a:	e9 bd fb ff ff       	jmp    80104f4c <alltraps>

8010538f <vector3>:
.globl vector3
vector3:
  pushl $0
8010538f:	6a 00                	push   $0x0
  pushl $3
80105391:	6a 03                	push   $0x3
  jmp alltraps
80105393:	e9 b4 fb ff ff       	jmp    80104f4c <alltraps>

80105398 <vector4>:
.globl vector4
vector4:
  pushl $0
80105398:	6a 00                	push   $0x0
  pushl $4
8010539a:	6a 04                	push   $0x4
  jmp alltraps
8010539c:	e9 ab fb ff ff       	jmp    80104f4c <alltraps>

801053a1 <vector5>:
.globl vector5
vector5:
  pushl $0
801053a1:	6a 00                	push   $0x0
  pushl $5
801053a3:	6a 05                	push   $0x5
  jmp alltraps
801053a5:	e9 a2 fb ff ff       	jmp    80104f4c <alltraps>

801053aa <vector6>:
.globl vector6
vector6:
  pushl $0
801053aa:	6a 00                	push   $0x0
  pushl $6
801053ac:	6a 06                	push   $0x6
  jmp alltraps
801053ae:	e9 99 fb ff ff       	jmp    80104f4c <alltraps>

801053b3 <vector7>:
.globl vector7
vector7:
  pushl $0
801053b3:	6a 00                	push   $0x0
  pushl $7
801053b5:	6a 07                	push   $0x7
  jmp alltraps
801053b7:	e9 90 fb ff ff       	jmp    80104f4c <alltraps>

801053bc <vector8>:
.globl vector8
vector8:
  pushl $8
801053bc:	6a 08                	push   $0x8
  jmp alltraps
801053be:	e9 89 fb ff ff       	jmp    80104f4c <alltraps>

801053c3 <vector9>:
.globl vector9
vector9:
  pushl $0
801053c3:	6a 00                	push   $0x0
  pushl $9
801053c5:	6a 09                	push   $0x9
  jmp alltraps
801053c7:	e9 80 fb ff ff       	jmp    80104f4c <alltraps>

801053cc <vector10>:
.globl vector10
vector10:
  pushl $10
801053cc:	6a 0a                	push   $0xa
  jmp alltraps
801053ce:	e9 79 fb ff ff       	jmp    80104f4c <alltraps>

801053d3 <vector11>:
.globl vector11
vector11:
  pushl $11
801053d3:	6a 0b                	push   $0xb
  jmp alltraps
801053d5:	e9 72 fb ff ff       	jmp    80104f4c <alltraps>

801053da <vector12>:
.globl vector12
vector12:
  pushl $12
801053da:	6a 0c                	push   $0xc
  jmp alltraps
801053dc:	e9 6b fb ff ff       	jmp    80104f4c <alltraps>

801053e1 <vector13>:
.globl vector13
vector13:
  pushl $13
801053e1:	6a 0d                	push   $0xd
  jmp alltraps
801053e3:	e9 64 fb ff ff       	jmp    80104f4c <alltraps>

801053e8 <vector14>:
.globl vector14
vector14:
  pushl $14
801053e8:	6a 0e                	push   $0xe
  jmp alltraps
801053ea:	e9 5d fb ff ff       	jmp    80104f4c <alltraps>

801053ef <vector15>:
.globl vector15
vector15:
  pushl $0
801053ef:	6a 00                	push   $0x0
  pushl $15
801053f1:	6a 0f                	push   $0xf
  jmp alltraps
801053f3:	e9 54 fb ff ff       	jmp    80104f4c <alltraps>

801053f8 <vector16>:
.globl vector16
vector16:
  pushl $0
801053f8:	6a 00                	push   $0x0
  pushl $16
801053fa:	6a 10                	push   $0x10
  jmp alltraps
801053fc:	e9 4b fb ff ff       	jmp    80104f4c <alltraps>

80105401 <vector17>:
.globl vector17
vector17:
  pushl $17
80105401:	6a 11                	push   $0x11
  jmp alltraps
80105403:	e9 44 fb ff ff       	jmp    80104f4c <alltraps>

80105408 <vector18>:
.globl vector18
vector18:
  pushl $0
80105408:	6a 00                	push   $0x0
  pushl $18
8010540a:	6a 12                	push   $0x12
  jmp alltraps
8010540c:	e9 3b fb ff ff       	jmp    80104f4c <alltraps>

80105411 <vector19>:
.globl vector19
vector19:
  pushl $0
80105411:	6a 00                	push   $0x0
  pushl $19
80105413:	6a 13                	push   $0x13
  jmp alltraps
80105415:	e9 32 fb ff ff       	jmp    80104f4c <alltraps>

8010541a <vector20>:
.globl vector20
vector20:
  pushl $0
8010541a:	6a 00                	push   $0x0
  pushl $20
8010541c:	6a 14                	push   $0x14
  jmp alltraps
8010541e:	e9 29 fb ff ff       	jmp    80104f4c <alltraps>

80105423 <vector21>:
.globl vector21
vector21:
  pushl $0
80105423:	6a 00                	push   $0x0
  pushl $21
80105425:	6a 15                	push   $0x15
  jmp alltraps
80105427:	e9 20 fb ff ff       	jmp    80104f4c <alltraps>

8010542c <vector22>:
.globl vector22
vector22:
  pushl $0
8010542c:	6a 00                	push   $0x0
  pushl $22
8010542e:	6a 16                	push   $0x16
  jmp alltraps
80105430:	e9 17 fb ff ff       	jmp    80104f4c <alltraps>

80105435 <vector23>:
.globl vector23
vector23:
  pushl $0
80105435:	6a 00                	push   $0x0
  pushl $23
80105437:	6a 17                	push   $0x17
  jmp alltraps
80105439:	e9 0e fb ff ff       	jmp    80104f4c <alltraps>

8010543e <vector24>:
.globl vector24
vector24:
  pushl $0
8010543e:	6a 00                	push   $0x0
  pushl $24
80105440:	6a 18                	push   $0x18
  jmp alltraps
80105442:	e9 05 fb ff ff       	jmp    80104f4c <alltraps>

80105447 <vector25>:
.globl vector25
vector25:
  pushl $0
80105447:	6a 00                	push   $0x0
  pushl $25
80105449:	6a 19                	push   $0x19
  jmp alltraps
8010544b:	e9 fc fa ff ff       	jmp    80104f4c <alltraps>

80105450 <vector26>:
.globl vector26
vector26:
  pushl $0
80105450:	6a 00                	push   $0x0
  pushl $26
80105452:	6a 1a                	push   $0x1a
  jmp alltraps
80105454:	e9 f3 fa ff ff       	jmp    80104f4c <alltraps>

80105459 <vector27>:
.globl vector27
vector27:
  pushl $0
80105459:	6a 00                	push   $0x0
  pushl $27
8010545b:	6a 1b                	push   $0x1b
  jmp alltraps
8010545d:	e9 ea fa ff ff       	jmp    80104f4c <alltraps>

80105462 <vector28>:
.globl vector28
vector28:
  pushl $0
80105462:	6a 00                	push   $0x0
  pushl $28
80105464:	6a 1c                	push   $0x1c
  jmp alltraps
80105466:	e9 e1 fa ff ff       	jmp    80104f4c <alltraps>

8010546b <vector29>:
.globl vector29
vector29:
  pushl $0
8010546b:	6a 00                	push   $0x0
  pushl $29
8010546d:	6a 1d                	push   $0x1d
  jmp alltraps
8010546f:	e9 d8 fa ff ff       	jmp    80104f4c <alltraps>

80105474 <vector30>:
.globl vector30
vector30:
  pushl $0
80105474:	6a 00                	push   $0x0
  pushl $30
80105476:	6a 1e                	push   $0x1e
  jmp alltraps
80105478:	e9 cf fa ff ff       	jmp    80104f4c <alltraps>

8010547d <vector31>:
.globl vector31
vector31:
  pushl $0
8010547d:	6a 00                	push   $0x0
  pushl $31
8010547f:	6a 1f                	push   $0x1f
  jmp alltraps
80105481:	e9 c6 fa ff ff       	jmp    80104f4c <alltraps>

80105486 <vector32>:
.globl vector32
vector32:
  pushl $0
80105486:	6a 00                	push   $0x0
  pushl $32
80105488:	6a 20                	push   $0x20
  jmp alltraps
8010548a:	e9 bd fa ff ff       	jmp    80104f4c <alltraps>

8010548f <vector33>:
.globl vector33
vector33:
  pushl $0
8010548f:	6a 00                	push   $0x0
  pushl $33
80105491:	6a 21                	push   $0x21
  jmp alltraps
80105493:	e9 b4 fa ff ff       	jmp    80104f4c <alltraps>

80105498 <vector34>:
.globl vector34
vector34:
  pushl $0
80105498:	6a 00                	push   $0x0
  pushl $34
8010549a:	6a 22                	push   $0x22
  jmp alltraps
8010549c:	e9 ab fa ff ff       	jmp    80104f4c <alltraps>

801054a1 <vector35>:
.globl vector35
vector35:
  pushl $0
801054a1:	6a 00                	push   $0x0
  pushl $35
801054a3:	6a 23                	push   $0x23
  jmp alltraps
801054a5:	e9 a2 fa ff ff       	jmp    80104f4c <alltraps>

801054aa <vector36>:
.globl vector36
vector36:
  pushl $0
801054aa:	6a 00                	push   $0x0
  pushl $36
801054ac:	6a 24                	push   $0x24
  jmp alltraps
801054ae:	e9 99 fa ff ff       	jmp    80104f4c <alltraps>

801054b3 <vector37>:
.globl vector37
vector37:
  pushl $0
801054b3:	6a 00                	push   $0x0
  pushl $37
801054b5:	6a 25                	push   $0x25
  jmp alltraps
801054b7:	e9 90 fa ff ff       	jmp    80104f4c <alltraps>

801054bc <vector38>:
.globl vector38
vector38:
  pushl $0
801054bc:	6a 00                	push   $0x0
  pushl $38
801054be:	6a 26                	push   $0x26
  jmp alltraps
801054c0:	e9 87 fa ff ff       	jmp    80104f4c <alltraps>

801054c5 <vector39>:
.globl vector39
vector39:
  pushl $0
801054c5:	6a 00                	push   $0x0
  pushl $39
801054c7:	6a 27                	push   $0x27
  jmp alltraps
801054c9:	e9 7e fa ff ff       	jmp    80104f4c <alltraps>

801054ce <vector40>:
.globl vector40
vector40:
  pushl $0
801054ce:	6a 00                	push   $0x0
  pushl $40
801054d0:	6a 28                	push   $0x28
  jmp alltraps
801054d2:	e9 75 fa ff ff       	jmp    80104f4c <alltraps>

801054d7 <vector41>:
.globl vector41
vector41:
  pushl $0
801054d7:	6a 00                	push   $0x0
  pushl $41
801054d9:	6a 29                	push   $0x29
  jmp alltraps
801054db:	e9 6c fa ff ff       	jmp    80104f4c <alltraps>

801054e0 <vector42>:
.globl vector42
vector42:
  pushl $0
801054e0:	6a 00                	push   $0x0
  pushl $42
801054e2:	6a 2a                	push   $0x2a
  jmp alltraps
801054e4:	e9 63 fa ff ff       	jmp    80104f4c <alltraps>

801054e9 <vector43>:
.globl vector43
vector43:
  pushl $0
801054e9:	6a 00                	push   $0x0
  pushl $43
801054eb:	6a 2b                	push   $0x2b
  jmp alltraps
801054ed:	e9 5a fa ff ff       	jmp    80104f4c <alltraps>

801054f2 <vector44>:
.globl vector44
vector44:
  pushl $0
801054f2:	6a 00                	push   $0x0
  pushl $44
801054f4:	6a 2c                	push   $0x2c
  jmp alltraps
801054f6:	e9 51 fa ff ff       	jmp    80104f4c <alltraps>

801054fb <vector45>:
.globl vector45
vector45:
  pushl $0
801054fb:	6a 00                	push   $0x0
  pushl $45
801054fd:	6a 2d                	push   $0x2d
  jmp alltraps
801054ff:	e9 48 fa ff ff       	jmp    80104f4c <alltraps>

80105504 <vector46>:
.globl vector46
vector46:
  pushl $0
80105504:	6a 00                	push   $0x0
  pushl $46
80105506:	6a 2e                	push   $0x2e
  jmp alltraps
80105508:	e9 3f fa ff ff       	jmp    80104f4c <alltraps>

8010550d <vector47>:
.globl vector47
vector47:
  pushl $0
8010550d:	6a 00                	push   $0x0
  pushl $47
8010550f:	6a 2f                	push   $0x2f
  jmp alltraps
80105511:	e9 36 fa ff ff       	jmp    80104f4c <alltraps>

80105516 <vector48>:
.globl vector48
vector48:
  pushl $0
80105516:	6a 00                	push   $0x0
  pushl $48
80105518:	6a 30                	push   $0x30
  jmp alltraps
8010551a:	e9 2d fa ff ff       	jmp    80104f4c <alltraps>

8010551f <vector49>:
.globl vector49
vector49:
  pushl $0
8010551f:	6a 00                	push   $0x0
  pushl $49
80105521:	6a 31                	push   $0x31
  jmp alltraps
80105523:	e9 24 fa ff ff       	jmp    80104f4c <alltraps>

80105528 <vector50>:
.globl vector50
vector50:
  pushl $0
80105528:	6a 00                	push   $0x0
  pushl $50
8010552a:	6a 32                	push   $0x32
  jmp alltraps
8010552c:	e9 1b fa ff ff       	jmp    80104f4c <alltraps>

80105531 <vector51>:
.globl vector51
vector51:
  pushl $0
80105531:	6a 00                	push   $0x0
  pushl $51
80105533:	6a 33                	push   $0x33
  jmp alltraps
80105535:	e9 12 fa ff ff       	jmp    80104f4c <alltraps>

8010553a <vector52>:
.globl vector52
vector52:
  pushl $0
8010553a:	6a 00                	push   $0x0
  pushl $52
8010553c:	6a 34                	push   $0x34
  jmp alltraps
8010553e:	e9 09 fa ff ff       	jmp    80104f4c <alltraps>

80105543 <vector53>:
.globl vector53
vector53:
  pushl $0
80105543:	6a 00                	push   $0x0
  pushl $53
80105545:	6a 35                	push   $0x35
  jmp alltraps
80105547:	e9 00 fa ff ff       	jmp    80104f4c <alltraps>

8010554c <vector54>:
.globl vector54
vector54:
  pushl $0
8010554c:	6a 00                	push   $0x0
  pushl $54
8010554e:	6a 36                	push   $0x36
  jmp alltraps
80105550:	e9 f7 f9 ff ff       	jmp    80104f4c <alltraps>

80105555 <vector55>:
.globl vector55
vector55:
  pushl $0
80105555:	6a 00                	push   $0x0
  pushl $55
80105557:	6a 37                	push   $0x37
  jmp alltraps
80105559:	e9 ee f9 ff ff       	jmp    80104f4c <alltraps>

8010555e <vector56>:
.globl vector56
vector56:
  pushl $0
8010555e:	6a 00                	push   $0x0
  pushl $56
80105560:	6a 38                	push   $0x38
  jmp alltraps
80105562:	e9 e5 f9 ff ff       	jmp    80104f4c <alltraps>

80105567 <vector57>:
.globl vector57
vector57:
  pushl $0
80105567:	6a 00                	push   $0x0
  pushl $57
80105569:	6a 39                	push   $0x39
  jmp alltraps
8010556b:	e9 dc f9 ff ff       	jmp    80104f4c <alltraps>

80105570 <vector58>:
.globl vector58
vector58:
  pushl $0
80105570:	6a 00                	push   $0x0
  pushl $58
80105572:	6a 3a                	push   $0x3a
  jmp alltraps
80105574:	e9 d3 f9 ff ff       	jmp    80104f4c <alltraps>

80105579 <vector59>:
.globl vector59
vector59:
  pushl $0
80105579:	6a 00                	push   $0x0
  pushl $59
8010557b:	6a 3b                	push   $0x3b
  jmp alltraps
8010557d:	e9 ca f9 ff ff       	jmp    80104f4c <alltraps>

80105582 <vector60>:
.globl vector60
vector60:
  pushl $0
80105582:	6a 00                	push   $0x0
  pushl $60
80105584:	6a 3c                	push   $0x3c
  jmp alltraps
80105586:	e9 c1 f9 ff ff       	jmp    80104f4c <alltraps>

8010558b <vector61>:
.globl vector61
vector61:
  pushl $0
8010558b:	6a 00                	push   $0x0
  pushl $61
8010558d:	6a 3d                	push   $0x3d
  jmp alltraps
8010558f:	e9 b8 f9 ff ff       	jmp    80104f4c <alltraps>

80105594 <vector62>:
.globl vector62
vector62:
  pushl $0
80105594:	6a 00                	push   $0x0
  pushl $62
80105596:	6a 3e                	push   $0x3e
  jmp alltraps
80105598:	e9 af f9 ff ff       	jmp    80104f4c <alltraps>

8010559d <vector63>:
.globl vector63
vector63:
  pushl $0
8010559d:	6a 00                	push   $0x0
  pushl $63
8010559f:	6a 3f                	push   $0x3f
  jmp alltraps
801055a1:	e9 a6 f9 ff ff       	jmp    80104f4c <alltraps>

801055a6 <vector64>:
.globl vector64
vector64:
  pushl $0
801055a6:	6a 00                	push   $0x0
  pushl $64
801055a8:	6a 40                	push   $0x40
  jmp alltraps
801055aa:	e9 9d f9 ff ff       	jmp    80104f4c <alltraps>

801055af <vector65>:
.globl vector65
vector65:
  pushl $0
801055af:	6a 00                	push   $0x0
  pushl $65
801055b1:	6a 41                	push   $0x41
  jmp alltraps
801055b3:	e9 94 f9 ff ff       	jmp    80104f4c <alltraps>

801055b8 <vector66>:
.globl vector66
vector66:
  pushl $0
801055b8:	6a 00                	push   $0x0
  pushl $66
801055ba:	6a 42                	push   $0x42
  jmp alltraps
801055bc:	e9 8b f9 ff ff       	jmp    80104f4c <alltraps>

801055c1 <vector67>:
.globl vector67
vector67:
  pushl $0
801055c1:	6a 00                	push   $0x0
  pushl $67
801055c3:	6a 43                	push   $0x43
  jmp alltraps
801055c5:	e9 82 f9 ff ff       	jmp    80104f4c <alltraps>

801055ca <vector68>:
.globl vector68
vector68:
  pushl $0
801055ca:	6a 00                	push   $0x0
  pushl $68
801055cc:	6a 44                	push   $0x44
  jmp alltraps
801055ce:	e9 79 f9 ff ff       	jmp    80104f4c <alltraps>

801055d3 <vector69>:
.globl vector69
vector69:
  pushl $0
801055d3:	6a 00                	push   $0x0
  pushl $69
801055d5:	6a 45                	push   $0x45
  jmp alltraps
801055d7:	e9 70 f9 ff ff       	jmp    80104f4c <alltraps>

801055dc <vector70>:
.globl vector70
vector70:
  pushl $0
801055dc:	6a 00                	push   $0x0
  pushl $70
801055de:	6a 46                	push   $0x46
  jmp alltraps
801055e0:	e9 67 f9 ff ff       	jmp    80104f4c <alltraps>

801055e5 <vector71>:
.globl vector71
vector71:
  pushl $0
801055e5:	6a 00                	push   $0x0
  pushl $71
801055e7:	6a 47                	push   $0x47
  jmp alltraps
801055e9:	e9 5e f9 ff ff       	jmp    80104f4c <alltraps>

801055ee <vector72>:
.globl vector72
vector72:
  pushl $0
801055ee:	6a 00                	push   $0x0
  pushl $72
801055f0:	6a 48                	push   $0x48
  jmp alltraps
801055f2:	e9 55 f9 ff ff       	jmp    80104f4c <alltraps>

801055f7 <vector73>:
.globl vector73
vector73:
  pushl $0
801055f7:	6a 00                	push   $0x0
  pushl $73
801055f9:	6a 49                	push   $0x49
  jmp alltraps
801055fb:	e9 4c f9 ff ff       	jmp    80104f4c <alltraps>

80105600 <vector74>:
.globl vector74
vector74:
  pushl $0
80105600:	6a 00                	push   $0x0
  pushl $74
80105602:	6a 4a                	push   $0x4a
  jmp alltraps
80105604:	e9 43 f9 ff ff       	jmp    80104f4c <alltraps>

80105609 <vector75>:
.globl vector75
vector75:
  pushl $0
80105609:	6a 00                	push   $0x0
  pushl $75
8010560b:	6a 4b                	push   $0x4b
  jmp alltraps
8010560d:	e9 3a f9 ff ff       	jmp    80104f4c <alltraps>

80105612 <vector76>:
.globl vector76
vector76:
  pushl $0
80105612:	6a 00                	push   $0x0
  pushl $76
80105614:	6a 4c                	push   $0x4c
  jmp alltraps
80105616:	e9 31 f9 ff ff       	jmp    80104f4c <alltraps>

8010561b <vector77>:
.globl vector77
vector77:
  pushl $0
8010561b:	6a 00                	push   $0x0
  pushl $77
8010561d:	6a 4d                	push   $0x4d
  jmp alltraps
8010561f:	e9 28 f9 ff ff       	jmp    80104f4c <alltraps>

80105624 <vector78>:
.globl vector78
vector78:
  pushl $0
80105624:	6a 00                	push   $0x0
  pushl $78
80105626:	6a 4e                	push   $0x4e
  jmp alltraps
80105628:	e9 1f f9 ff ff       	jmp    80104f4c <alltraps>

8010562d <vector79>:
.globl vector79
vector79:
  pushl $0
8010562d:	6a 00                	push   $0x0
  pushl $79
8010562f:	6a 4f                	push   $0x4f
  jmp alltraps
80105631:	e9 16 f9 ff ff       	jmp    80104f4c <alltraps>

80105636 <vector80>:
.globl vector80
vector80:
  pushl $0
80105636:	6a 00                	push   $0x0
  pushl $80
80105638:	6a 50                	push   $0x50
  jmp alltraps
8010563a:	e9 0d f9 ff ff       	jmp    80104f4c <alltraps>

8010563f <vector81>:
.globl vector81
vector81:
  pushl $0
8010563f:	6a 00                	push   $0x0
  pushl $81
80105641:	6a 51                	push   $0x51
  jmp alltraps
80105643:	e9 04 f9 ff ff       	jmp    80104f4c <alltraps>

80105648 <vector82>:
.globl vector82
vector82:
  pushl $0
80105648:	6a 00                	push   $0x0
  pushl $82
8010564a:	6a 52                	push   $0x52
  jmp alltraps
8010564c:	e9 fb f8 ff ff       	jmp    80104f4c <alltraps>

80105651 <vector83>:
.globl vector83
vector83:
  pushl $0
80105651:	6a 00                	push   $0x0
  pushl $83
80105653:	6a 53                	push   $0x53
  jmp alltraps
80105655:	e9 f2 f8 ff ff       	jmp    80104f4c <alltraps>

8010565a <vector84>:
.globl vector84
vector84:
  pushl $0
8010565a:	6a 00                	push   $0x0
  pushl $84
8010565c:	6a 54                	push   $0x54
  jmp alltraps
8010565e:	e9 e9 f8 ff ff       	jmp    80104f4c <alltraps>

80105663 <vector85>:
.globl vector85
vector85:
  pushl $0
80105663:	6a 00                	push   $0x0
  pushl $85
80105665:	6a 55                	push   $0x55
  jmp alltraps
80105667:	e9 e0 f8 ff ff       	jmp    80104f4c <alltraps>

8010566c <vector86>:
.globl vector86
vector86:
  pushl $0
8010566c:	6a 00                	push   $0x0
  pushl $86
8010566e:	6a 56                	push   $0x56
  jmp alltraps
80105670:	e9 d7 f8 ff ff       	jmp    80104f4c <alltraps>

80105675 <vector87>:
.globl vector87
vector87:
  pushl $0
80105675:	6a 00                	push   $0x0
  pushl $87
80105677:	6a 57                	push   $0x57
  jmp alltraps
80105679:	e9 ce f8 ff ff       	jmp    80104f4c <alltraps>

8010567e <vector88>:
.globl vector88
vector88:
  pushl $0
8010567e:	6a 00                	push   $0x0
  pushl $88
80105680:	6a 58                	push   $0x58
  jmp alltraps
80105682:	e9 c5 f8 ff ff       	jmp    80104f4c <alltraps>

80105687 <vector89>:
.globl vector89
vector89:
  pushl $0
80105687:	6a 00                	push   $0x0
  pushl $89
80105689:	6a 59                	push   $0x59
  jmp alltraps
8010568b:	e9 bc f8 ff ff       	jmp    80104f4c <alltraps>

80105690 <vector90>:
.globl vector90
vector90:
  pushl $0
80105690:	6a 00                	push   $0x0
  pushl $90
80105692:	6a 5a                	push   $0x5a
  jmp alltraps
80105694:	e9 b3 f8 ff ff       	jmp    80104f4c <alltraps>

80105699 <vector91>:
.globl vector91
vector91:
  pushl $0
80105699:	6a 00                	push   $0x0
  pushl $91
8010569b:	6a 5b                	push   $0x5b
  jmp alltraps
8010569d:	e9 aa f8 ff ff       	jmp    80104f4c <alltraps>

801056a2 <vector92>:
.globl vector92
vector92:
  pushl $0
801056a2:	6a 00                	push   $0x0
  pushl $92
801056a4:	6a 5c                	push   $0x5c
  jmp alltraps
801056a6:	e9 a1 f8 ff ff       	jmp    80104f4c <alltraps>

801056ab <vector93>:
.globl vector93
vector93:
  pushl $0
801056ab:	6a 00                	push   $0x0
  pushl $93
801056ad:	6a 5d                	push   $0x5d
  jmp alltraps
801056af:	e9 98 f8 ff ff       	jmp    80104f4c <alltraps>

801056b4 <vector94>:
.globl vector94
vector94:
  pushl $0
801056b4:	6a 00                	push   $0x0
  pushl $94
801056b6:	6a 5e                	push   $0x5e
  jmp alltraps
801056b8:	e9 8f f8 ff ff       	jmp    80104f4c <alltraps>

801056bd <vector95>:
.globl vector95
vector95:
  pushl $0
801056bd:	6a 00                	push   $0x0
  pushl $95
801056bf:	6a 5f                	push   $0x5f
  jmp alltraps
801056c1:	e9 86 f8 ff ff       	jmp    80104f4c <alltraps>

801056c6 <vector96>:
.globl vector96
vector96:
  pushl $0
801056c6:	6a 00                	push   $0x0
  pushl $96
801056c8:	6a 60                	push   $0x60
  jmp alltraps
801056ca:	e9 7d f8 ff ff       	jmp    80104f4c <alltraps>

801056cf <vector97>:
.globl vector97
vector97:
  pushl $0
801056cf:	6a 00                	push   $0x0
  pushl $97
801056d1:	6a 61                	push   $0x61
  jmp alltraps
801056d3:	e9 74 f8 ff ff       	jmp    80104f4c <alltraps>

801056d8 <vector98>:
.globl vector98
vector98:
  pushl $0
801056d8:	6a 00                	push   $0x0
  pushl $98
801056da:	6a 62                	push   $0x62
  jmp alltraps
801056dc:	e9 6b f8 ff ff       	jmp    80104f4c <alltraps>

801056e1 <vector99>:
.globl vector99
vector99:
  pushl $0
801056e1:	6a 00                	push   $0x0
  pushl $99
801056e3:	6a 63                	push   $0x63
  jmp alltraps
801056e5:	e9 62 f8 ff ff       	jmp    80104f4c <alltraps>

801056ea <vector100>:
.globl vector100
vector100:
  pushl $0
801056ea:	6a 00                	push   $0x0
  pushl $100
801056ec:	6a 64                	push   $0x64
  jmp alltraps
801056ee:	e9 59 f8 ff ff       	jmp    80104f4c <alltraps>

801056f3 <vector101>:
.globl vector101
vector101:
  pushl $0
801056f3:	6a 00                	push   $0x0
  pushl $101
801056f5:	6a 65                	push   $0x65
  jmp alltraps
801056f7:	e9 50 f8 ff ff       	jmp    80104f4c <alltraps>

801056fc <vector102>:
.globl vector102
vector102:
  pushl $0
801056fc:	6a 00                	push   $0x0
  pushl $102
801056fe:	6a 66                	push   $0x66
  jmp alltraps
80105700:	e9 47 f8 ff ff       	jmp    80104f4c <alltraps>

80105705 <vector103>:
.globl vector103
vector103:
  pushl $0
80105705:	6a 00                	push   $0x0
  pushl $103
80105707:	6a 67                	push   $0x67
  jmp alltraps
80105709:	e9 3e f8 ff ff       	jmp    80104f4c <alltraps>

8010570e <vector104>:
.globl vector104
vector104:
  pushl $0
8010570e:	6a 00                	push   $0x0
  pushl $104
80105710:	6a 68                	push   $0x68
  jmp alltraps
80105712:	e9 35 f8 ff ff       	jmp    80104f4c <alltraps>

80105717 <vector105>:
.globl vector105
vector105:
  pushl $0
80105717:	6a 00                	push   $0x0
  pushl $105
80105719:	6a 69                	push   $0x69
  jmp alltraps
8010571b:	e9 2c f8 ff ff       	jmp    80104f4c <alltraps>

80105720 <vector106>:
.globl vector106
vector106:
  pushl $0
80105720:	6a 00                	push   $0x0
  pushl $106
80105722:	6a 6a                	push   $0x6a
  jmp alltraps
80105724:	e9 23 f8 ff ff       	jmp    80104f4c <alltraps>

80105729 <vector107>:
.globl vector107
vector107:
  pushl $0
80105729:	6a 00                	push   $0x0
  pushl $107
8010572b:	6a 6b                	push   $0x6b
  jmp alltraps
8010572d:	e9 1a f8 ff ff       	jmp    80104f4c <alltraps>

80105732 <vector108>:
.globl vector108
vector108:
  pushl $0
80105732:	6a 00                	push   $0x0
  pushl $108
80105734:	6a 6c                	push   $0x6c
  jmp alltraps
80105736:	e9 11 f8 ff ff       	jmp    80104f4c <alltraps>

8010573b <vector109>:
.globl vector109
vector109:
  pushl $0
8010573b:	6a 00                	push   $0x0
  pushl $109
8010573d:	6a 6d                	push   $0x6d
  jmp alltraps
8010573f:	e9 08 f8 ff ff       	jmp    80104f4c <alltraps>

80105744 <vector110>:
.globl vector110
vector110:
  pushl $0
80105744:	6a 00                	push   $0x0
  pushl $110
80105746:	6a 6e                	push   $0x6e
  jmp alltraps
80105748:	e9 ff f7 ff ff       	jmp    80104f4c <alltraps>

8010574d <vector111>:
.globl vector111
vector111:
  pushl $0
8010574d:	6a 00                	push   $0x0
  pushl $111
8010574f:	6a 6f                	push   $0x6f
  jmp alltraps
80105751:	e9 f6 f7 ff ff       	jmp    80104f4c <alltraps>

80105756 <vector112>:
.globl vector112
vector112:
  pushl $0
80105756:	6a 00                	push   $0x0
  pushl $112
80105758:	6a 70                	push   $0x70
  jmp alltraps
8010575a:	e9 ed f7 ff ff       	jmp    80104f4c <alltraps>

8010575f <vector113>:
.globl vector113
vector113:
  pushl $0
8010575f:	6a 00                	push   $0x0
  pushl $113
80105761:	6a 71                	push   $0x71
  jmp alltraps
80105763:	e9 e4 f7 ff ff       	jmp    80104f4c <alltraps>

80105768 <vector114>:
.globl vector114
vector114:
  pushl $0
80105768:	6a 00                	push   $0x0
  pushl $114
8010576a:	6a 72                	push   $0x72
  jmp alltraps
8010576c:	e9 db f7 ff ff       	jmp    80104f4c <alltraps>

80105771 <vector115>:
.globl vector115
vector115:
  pushl $0
80105771:	6a 00                	push   $0x0
  pushl $115
80105773:	6a 73                	push   $0x73
  jmp alltraps
80105775:	e9 d2 f7 ff ff       	jmp    80104f4c <alltraps>

8010577a <vector116>:
.globl vector116
vector116:
  pushl $0
8010577a:	6a 00                	push   $0x0
  pushl $116
8010577c:	6a 74                	push   $0x74
  jmp alltraps
8010577e:	e9 c9 f7 ff ff       	jmp    80104f4c <alltraps>

80105783 <vector117>:
.globl vector117
vector117:
  pushl $0
80105783:	6a 00                	push   $0x0
  pushl $117
80105785:	6a 75                	push   $0x75
  jmp alltraps
80105787:	e9 c0 f7 ff ff       	jmp    80104f4c <alltraps>

8010578c <vector118>:
.globl vector118
vector118:
  pushl $0
8010578c:	6a 00                	push   $0x0
  pushl $118
8010578e:	6a 76                	push   $0x76
  jmp alltraps
80105790:	e9 b7 f7 ff ff       	jmp    80104f4c <alltraps>

80105795 <vector119>:
.globl vector119
vector119:
  pushl $0
80105795:	6a 00                	push   $0x0
  pushl $119
80105797:	6a 77                	push   $0x77
  jmp alltraps
80105799:	e9 ae f7 ff ff       	jmp    80104f4c <alltraps>

8010579e <vector120>:
.globl vector120
vector120:
  pushl $0
8010579e:	6a 00                	push   $0x0
  pushl $120
801057a0:	6a 78                	push   $0x78
  jmp alltraps
801057a2:	e9 a5 f7 ff ff       	jmp    80104f4c <alltraps>

801057a7 <vector121>:
.globl vector121
vector121:
  pushl $0
801057a7:	6a 00                	push   $0x0
  pushl $121
801057a9:	6a 79                	push   $0x79
  jmp alltraps
801057ab:	e9 9c f7 ff ff       	jmp    80104f4c <alltraps>

801057b0 <vector122>:
.globl vector122
vector122:
  pushl $0
801057b0:	6a 00                	push   $0x0
  pushl $122
801057b2:	6a 7a                	push   $0x7a
  jmp alltraps
801057b4:	e9 93 f7 ff ff       	jmp    80104f4c <alltraps>

801057b9 <vector123>:
.globl vector123
vector123:
  pushl $0
801057b9:	6a 00                	push   $0x0
  pushl $123
801057bb:	6a 7b                	push   $0x7b
  jmp alltraps
801057bd:	e9 8a f7 ff ff       	jmp    80104f4c <alltraps>

801057c2 <vector124>:
.globl vector124
vector124:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $124
801057c4:	6a 7c                	push   $0x7c
  jmp alltraps
801057c6:	e9 81 f7 ff ff       	jmp    80104f4c <alltraps>

801057cb <vector125>:
.globl vector125
vector125:
  pushl $0
801057cb:	6a 00                	push   $0x0
  pushl $125
801057cd:	6a 7d                	push   $0x7d
  jmp alltraps
801057cf:	e9 78 f7 ff ff       	jmp    80104f4c <alltraps>

801057d4 <vector126>:
.globl vector126
vector126:
  pushl $0
801057d4:	6a 00                	push   $0x0
  pushl $126
801057d6:	6a 7e                	push   $0x7e
  jmp alltraps
801057d8:	e9 6f f7 ff ff       	jmp    80104f4c <alltraps>

801057dd <vector127>:
.globl vector127
vector127:
  pushl $0
801057dd:	6a 00                	push   $0x0
  pushl $127
801057df:	6a 7f                	push   $0x7f
  jmp alltraps
801057e1:	e9 66 f7 ff ff       	jmp    80104f4c <alltraps>

801057e6 <vector128>:
.globl vector128
vector128:
  pushl $0
801057e6:	6a 00                	push   $0x0
  pushl $128
801057e8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801057ed:	e9 5a f7 ff ff       	jmp    80104f4c <alltraps>

801057f2 <vector129>:
.globl vector129
vector129:
  pushl $0
801057f2:	6a 00                	push   $0x0
  pushl $129
801057f4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801057f9:	e9 4e f7 ff ff       	jmp    80104f4c <alltraps>

801057fe <vector130>:
.globl vector130
vector130:
  pushl $0
801057fe:	6a 00                	push   $0x0
  pushl $130
80105800:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105805:	e9 42 f7 ff ff       	jmp    80104f4c <alltraps>

8010580a <vector131>:
.globl vector131
vector131:
  pushl $0
8010580a:	6a 00                	push   $0x0
  pushl $131
8010580c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105811:	e9 36 f7 ff ff       	jmp    80104f4c <alltraps>

80105816 <vector132>:
.globl vector132
vector132:
  pushl $0
80105816:	6a 00                	push   $0x0
  pushl $132
80105818:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010581d:	e9 2a f7 ff ff       	jmp    80104f4c <alltraps>

80105822 <vector133>:
.globl vector133
vector133:
  pushl $0
80105822:	6a 00                	push   $0x0
  pushl $133
80105824:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105829:	e9 1e f7 ff ff       	jmp    80104f4c <alltraps>

8010582e <vector134>:
.globl vector134
vector134:
  pushl $0
8010582e:	6a 00                	push   $0x0
  pushl $134
80105830:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105835:	e9 12 f7 ff ff       	jmp    80104f4c <alltraps>

8010583a <vector135>:
.globl vector135
vector135:
  pushl $0
8010583a:	6a 00                	push   $0x0
  pushl $135
8010583c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105841:	e9 06 f7 ff ff       	jmp    80104f4c <alltraps>

80105846 <vector136>:
.globl vector136
vector136:
  pushl $0
80105846:	6a 00                	push   $0x0
  pushl $136
80105848:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010584d:	e9 fa f6 ff ff       	jmp    80104f4c <alltraps>

80105852 <vector137>:
.globl vector137
vector137:
  pushl $0
80105852:	6a 00                	push   $0x0
  pushl $137
80105854:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105859:	e9 ee f6 ff ff       	jmp    80104f4c <alltraps>

8010585e <vector138>:
.globl vector138
vector138:
  pushl $0
8010585e:	6a 00                	push   $0x0
  pushl $138
80105860:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105865:	e9 e2 f6 ff ff       	jmp    80104f4c <alltraps>

8010586a <vector139>:
.globl vector139
vector139:
  pushl $0
8010586a:	6a 00                	push   $0x0
  pushl $139
8010586c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105871:	e9 d6 f6 ff ff       	jmp    80104f4c <alltraps>

80105876 <vector140>:
.globl vector140
vector140:
  pushl $0
80105876:	6a 00                	push   $0x0
  pushl $140
80105878:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010587d:	e9 ca f6 ff ff       	jmp    80104f4c <alltraps>

80105882 <vector141>:
.globl vector141
vector141:
  pushl $0
80105882:	6a 00                	push   $0x0
  pushl $141
80105884:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105889:	e9 be f6 ff ff       	jmp    80104f4c <alltraps>

8010588e <vector142>:
.globl vector142
vector142:
  pushl $0
8010588e:	6a 00                	push   $0x0
  pushl $142
80105890:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105895:	e9 b2 f6 ff ff       	jmp    80104f4c <alltraps>

8010589a <vector143>:
.globl vector143
vector143:
  pushl $0
8010589a:	6a 00                	push   $0x0
  pushl $143
8010589c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801058a1:	e9 a6 f6 ff ff       	jmp    80104f4c <alltraps>

801058a6 <vector144>:
.globl vector144
vector144:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $144
801058a8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801058ad:	e9 9a f6 ff ff       	jmp    80104f4c <alltraps>

801058b2 <vector145>:
.globl vector145
vector145:
  pushl $0
801058b2:	6a 00                	push   $0x0
  pushl $145
801058b4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801058b9:	e9 8e f6 ff ff       	jmp    80104f4c <alltraps>

801058be <vector146>:
.globl vector146
vector146:
  pushl $0
801058be:	6a 00                	push   $0x0
  pushl $146
801058c0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801058c5:	e9 82 f6 ff ff       	jmp    80104f4c <alltraps>

801058ca <vector147>:
.globl vector147
vector147:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $147
801058cc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801058d1:	e9 76 f6 ff ff       	jmp    80104f4c <alltraps>

801058d6 <vector148>:
.globl vector148
vector148:
  pushl $0
801058d6:	6a 00                	push   $0x0
  pushl $148
801058d8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801058dd:	e9 6a f6 ff ff       	jmp    80104f4c <alltraps>

801058e2 <vector149>:
.globl vector149
vector149:
  pushl $0
801058e2:	6a 00                	push   $0x0
  pushl $149
801058e4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801058e9:	e9 5e f6 ff ff       	jmp    80104f4c <alltraps>

801058ee <vector150>:
.globl vector150
vector150:
  pushl $0
801058ee:	6a 00                	push   $0x0
  pushl $150
801058f0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801058f5:	e9 52 f6 ff ff       	jmp    80104f4c <alltraps>

801058fa <vector151>:
.globl vector151
vector151:
  pushl $0
801058fa:	6a 00                	push   $0x0
  pushl $151
801058fc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105901:	e9 46 f6 ff ff       	jmp    80104f4c <alltraps>

80105906 <vector152>:
.globl vector152
vector152:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $152
80105908:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010590d:	e9 3a f6 ff ff       	jmp    80104f4c <alltraps>

80105912 <vector153>:
.globl vector153
vector153:
  pushl $0
80105912:	6a 00                	push   $0x0
  pushl $153
80105914:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105919:	e9 2e f6 ff ff       	jmp    80104f4c <alltraps>

8010591e <vector154>:
.globl vector154
vector154:
  pushl $0
8010591e:	6a 00                	push   $0x0
  pushl $154
80105920:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105925:	e9 22 f6 ff ff       	jmp    80104f4c <alltraps>

8010592a <vector155>:
.globl vector155
vector155:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $155
8010592c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105931:	e9 16 f6 ff ff       	jmp    80104f4c <alltraps>

80105936 <vector156>:
.globl vector156
vector156:
  pushl $0
80105936:	6a 00                	push   $0x0
  pushl $156
80105938:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010593d:	e9 0a f6 ff ff       	jmp    80104f4c <alltraps>

80105942 <vector157>:
.globl vector157
vector157:
  pushl $0
80105942:	6a 00                	push   $0x0
  pushl $157
80105944:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105949:	e9 fe f5 ff ff       	jmp    80104f4c <alltraps>

8010594e <vector158>:
.globl vector158
vector158:
  pushl $0
8010594e:	6a 00                	push   $0x0
  pushl $158
80105950:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105955:	e9 f2 f5 ff ff       	jmp    80104f4c <alltraps>

8010595a <vector159>:
.globl vector159
vector159:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $159
8010595c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105961:	e9 e6 f5 ff ff       	jmp    80104f4c <alltraps>

80105966 <vector160>:
.globl vector160
vector160:
  pushl $0
80105966:	6a 00                	push   $0x0
  pushl $160
80105968:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010596d:	e9 da f5 ff ff       	jmp    80104f4c <alltraps>

80105972 <vector161>:
.globl vector161
vector161:
  pushl $0
80105972:	6a 00                	push   $0x0
  pushl $161
80105974:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105979:	e9 ce f5 ff ff       	jmp    80104f4c <alltraps>

8010597e <vector162>:
.globl vector162
vector162:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $162
80105980:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105985:	e9 c2 f5 ff ff       	jmp    80104f4c <alltraps>

8010598a <vector163>:
.globl vector163
vector163:
  pushl $0
8010598a:	6a 00                	push   $0x0
  pushl $163
8010598c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105991:	e9 b6 f5 ff ff       	jmp    80104f4c <alltraps>

80105996 <vector164>:
.globl vector164
vector164:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $164
80105998:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010599d:	e9 aa f5 ff ff       	jmp    80104f4c <alltraps>

801059a2 <vector165>:
.globl vector165
vector165:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $165
801059a4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801059a9:	e9 9e f5 ff ff       	jmp    80104f4c <alltraps>

801059ae <vector166>:
.globl vector166
vector166:
  pushl $0
801059ae:	6a 00                	push   $0x0
  pushl $166
801059b0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801059b5:	e9 92 f5 ff ff       	jmp    80104f4c <alltraps>

801059ba <vector167>:
.globl vector167
vector167:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $167
801059bc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801059c1:	e9 86 f5 ff ff       	jmp    80104f4c <alltraps>

801059c6 <vector168>:
.globl vector168
vector168:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $168
801059c8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801059cd:	e9 7a f5 ff ff       	jmp    80104f4c <alltraps>

801059d2 <vector169>:
.globl vector169
vector169:
  pushl $0
801059d2:	6a 00                	push   $0x0
  pushl $169
801059d4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801059d9:	e9 6e f5 ff ff       	jmp    80104f4c <alltraps>

801059de <vector170>:
.globl vector170
vector170:
  pushl $0
801059de:	6a 00                	push   $0x0
  pushl $170
801059e0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801059e5:	e9 62 f5 ff ff       	jmp    80104f4c <alltraps>

801059ea <vector171>:
.globl vector171
vector171:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $171
801059ec:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801059f1:	e9 56 f5 ff ff       	jmp    80104f4c <alltraps>

801059f6 <vector172>:
.globl vector172
vector172:
  pushl $0
801059f6:	6a 00                	push   $0x0
  pushl $172
801059f8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801059fd:	e9 4a f5 ff ff       	jmp    80104f4c <alltraps>

80105a02 <vector173>:
.globl vector173
vector173:
  pushl $0
80105a02:	6a 00                	push   $0x0
  pushl $173
80105a04:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105a09:	e9 3e f5 ff ff       	jmp    80104f4c <alltraps>

80105a0e <vector174>:
.globl vector174
vector174:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $174
80105a10:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105a15:	e9 32 f5 ff ff       	jmp    80104f4c <alltraps>

80105a1a <vector175>:
.globl vector175
vector175:
  pushl $0
80105a1a:	6a 00                	push   $0x0
  pushl $175
80105a1c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105a21:	e9 26 f5 ff ff       	jmp    80104f4c <alltraps>

80105a26 <vector176>:
.globl vector176
vector176:
  pushl $0
80105a26:	6a 00                	push   $0x0
  pushl $176
80105a28:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105a2d:	e9 1a f5 ff ff       	jmp    80104f4c <alltraps>

80105a32 <vector177>:
.globl vector177
vector177:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $177
80105a34:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105a39:	e9 0e f5 ff ff       	jmp    80104f4c <alltraps>

80105a3e <vector178>:
.globl vector178
vector178:
  pushl $0
80105a3e:	6a 00                	push   $0x0
  pushl $178
80105a40:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105a45:	e9 02 f5 ff ff       	jmp    80104f4c <alltraps>

80105a4a <vector179>:
.globl vector179
vector179:
  pushl $0
80105a4a:	6a 00                	push   $0x0
  pushl $179
80105a4c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105a51:	e9 f6 f4 ff ff       	jmp    80104f4c <alltraps>

80105a56 <vector180>:
.globl vector180
vector180:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $180
80105a58:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105a5d:	e9 ea f4 ff ff       	jmp    80104f4c <alltraps>

80105a62 <vector181>:
.globl vector181
vector181:
  pushl $0
80105a62:	6a 00                	push   $0x0
  pushl $181
80105a64:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105a69:	e9 de f4 ff ff       	jmp    80104f4c <alltraps>

80105a6e <vector182>:
.globl vector182
vector182:
  pushl $0
80105a6e:	6a 00                	push   $0x0
  pushl $182
80105a70:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105a75:	e9 d2 f4 ff ff       	jmp    80104f4c <alltraps>

80105a7a <vector183>:
.globl vector183
vector183:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $183
80105a7c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105a81:	e9 c6 f4 ff ff       	jmp    80104f4c <alltraps>

80105a86 <vector184>:
.globl vector184
vector184:
  pushl $0
80105a86:	6a 00                	push   $0x0
  pushl $184
80105a88:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105a8d:	e9 ba f4 ff ff       	jmp    80104f4c <alltraps>

80105a92 <vector185>:
.globl vector185
vector185:
  pushl $0
80105a92:	6a 00                	push   $0x0
  pushl $185
80105a94:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105a99:	e9 ae f4 ff ff       	jmp    80104f4c <alltraps>

80105a9e <vector186>:
.globl vector186
vector186:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $186
80105aa0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105aa5:	e9 a2 f4 ff ff       	jmp    80104f4c <alltraps>

80105aaa <vector187>:
.globl vector187
vector187:
  pushl $0
80105aaa:	6a 00                	push   $0x0
  pushl $187
80105aac:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105ab1:	e9 96 f4 ff ff       	jmp    80104f4c <alltraps>

80105ab6 <vector188>:
.globl vector188
vector188:
  pushl $0
80105ab6:	6a 00                	push   $0x0
  pushl $188
80105ab8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105abd:	e9 8a f4 ff ff       	jmp    80104f4c <alltraps>

80105ac2 <vector189>:
.globl vector189
vector189:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $189
80105ac4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ac9:	e9 7e f4 ff ff       	jmp    80104f4c <alltraps>

80105ace <vector190>:
.globl vector190
vector190:
  pushl $0
80105ace:	6a 00                	push   $0x0
  pushl $190
80105ad0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105ad5:	e9 72 f4 ff ff       	jmp    80104f4c <alltraps>

80105ada <vector191>:
.globl vector191
vector191:
  pushl $0
80105ada:	6a 00                	push   $0x0
  pushl $191
80105adc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105ae1:	e9 66 f4 ff ff       	jmp    80104f4c <alltraps>

80105ae6 <vector192>:
.globl vector192
vector192:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $192
80105ae8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105aed:	e9 5a f4 ff ff       	jmp    80104f4c <alltraps>

80105af2 <vector193>:
.globl vector193
vector193:
  pushl $0
80105af2:	6a 00                	push   $0x0
  pushl $193
80105af4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105af9:	e9 4e f4 ff ff       	jmp    80104f4c <alltraps>

80105afe <vector194>:
.globl vector194
vector194:
  pushl $0
80105afe:	6a 00                	push   $0x0
  pushl $194
80105b00:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105b05:	e9 42 f4 ff ff       	jmp    80104f4c <alltraps>

80105b0a <vector195>:
.globl vector195
vector195:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $195
80105b0c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105b11:	e9 36 f4 ff ff       	jmp    80104f4c <alltraps>

80105b16 <vector196>:
.globl vector196
vector196:
  pushl $0
80105b16:	6a 00                	push   $0x0
  pushl $196
80105b18:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105b1d:	e9 2a f4 ff ff       	jmp    80104f4c <alltraps>

80105b22 <vector197>:
.globl vector197
vector197:
  pushl $0
80105b22:	6a 00                	push   $0x0
  pushl $197
80105b24:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105b29:	e9 1e f4 ff ff       	jmp    80104f4c <alltraps>

80105b2e <vector198>:
.globl vector198
vector198:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $198
80105b30:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105b35:	e9 12 f4 ff ff       	jmp    80104f4c <alltraps>

80105b3a <vector199>:
.globl vector199
vector199:
  pushl $0
80105b3a:	6a 00                	push   $0x0
  pushl $199
80105b3c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105b41:	e9 06 f4 ff ff       	jmp    80104f4c <alltraps>

80105b46 <vector200>:
.globl vector200
vector200:
  pushl $0
80105b46:	6a 00                	push   $0x0
  pushl $200
80105b48:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105b4d:	e9 fa f3 ff ff       	jmp    80104f4c <alltraps>

80105b52 <vector201>:
.globl vector201
vector201:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $201
80105b54:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105b59:	e9 ee f3 ff ff       	jmp    80104f4c <alltraps>

80105b5e <vector202>:
.globl vector202
vector202:
  pushl $0
80105b5e:	6a 00                	push   $0x0
  pushl $202
80105b60:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105b65:	e9 e2 f3 ff ff       	jmp    80104f4c <alltraps>

80105b6a <vector203>:
.globl vector203
vector203:
  pushl $0
80105b6a:	6a 00                	push   $0x0
  pushl $203
80105b6c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105b71:	e9 d6 f3 ff ff       	jmp    80104f4c <alltraps>

80105b76 <vector204>:
.globl vector204
vector204:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $204
80105b78:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105b7d:	e9 ca f3 ff ff       	jmp    80104f4c <alltraps>

80105b82 <vector205>:
.globl vector205
vector205:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $205
80105b84:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105b89:	e9 be f3 ff ff       	jmp    80104f4c <alltraps>

80105b8e <vector206>:
.globl vector206
vector206:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $206
80105b90:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105b95:	e9 b2 f3 ff ff       	jmp    80104f4c <alltraps>

80105b9a <vector207>:
.globl vector207
vector207:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $207
80105b9c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105ba1:	e9 a6 f3 ff ff       	jmp    80104f4c <alltraps>

80105ba6 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $208
80105ba8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105bad:	e9 9a f3 ff ff       	jmp    80104f4c <alltraps>

80105bb2 <vector209>:
.globl vector209
vector209:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $209
80105bb4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105bb9:	e9 8e f3 ff ff       	jmp    80104f4c <alltraps>

80105bbe <vector210>:
.globl vector210
vector210:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $210
80105bc0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105bc5:	e9 82 f3 ff ff       	jmp    80104f4c <alltraps>

80105bca <vector211>:
.globl vector211
vector211:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $211
80105bcc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105bd1:	e9 76 f3 ff ff       	jmp    80104f4c <alltraps>

80105bd6 <vector212>:
.globl vector212
vector212:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $212
80105bd8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105bdd:	e9 6a f3 ff ff       	jmp    80104f4c <alltraps>

80105be2 <vector213>:
.globl vector213
vector213:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $213
80105be4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105be9:	e9 5e f3 ff ff       	jmp    80104f4c <alltraps>

80105bee <vector214>:
.globl vector214
vector214:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $214
80105bf0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105bf5:	e9 52 f3 ff ff       	jmp    80104f4c <alltraps>

80105bfa <vector215>:
.globl vector215
vector215:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $215
80105bfc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105c01:	e9 46 f3 ff ff       	jmp    80104f4c <alltraps>

80105c06 <vector216>:
.globl vector216
vector216:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $216
80105c08:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105c0d:	e9 3a f3 ff ff       	jmp    80104f4c <alltraps>

80105c12 <vector217>:
.globl vector217
vector217:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $217
80105c14:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105c19:	e9 2e f3 ff ff       	jmp    80104f4c <alltraps>

80105c1e <vector218>:
.globl vector218
vector218:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $218
80105c20:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105c25:	e9 22 f3 ff ff       	jmp    80104f4c <alltraps>

80105c2a <vector219>:
.globl vector219
vector219:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $219
80105c2c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105c31:	e9 16 f3 ff ff       	jmp    80104f4c <alltraps>

80105c36 <vector220>:
.globl vector220
vector220:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $220
80105c38:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105c3d:	e9 0a f3 ff ff       	jmp    80104f4c <alltraps>

80105c42 <vector221>:
.globl vector221
vector221:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $221
80105c44:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105c49:	e9 fe f2 ff ff       	jmp    80104f4c <alltraps>

80105c4e <vector222>:
.globl vector222
vector222:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $222
80105c50:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105c55:	e9 f2 f2 ff ff       	jmp    80104f4c <alltraps>

80105c5a <vector223>:
.globl vector223
vector223:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $223
80105c5c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105c61:	e9 e6 f2 ff ff       	jmp    80104f4c <alltraps>

80105c66 <vector224>:
.globl vector224
vector224:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $224
80105c68:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105c6d:	e9 da f2 ff ff       	jmp    80104f4c <alltraps>

80105c72 <vector225>:
.globl vector225
vector225:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $225
80105c74:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105c79:	e9 ce f2 ff ff       	jmp    80104f4c <alltraps>

80105c7e <vector226>:
.globl vector226
vector226:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $226
80105c80:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105c85:	e9 c2 f2 ff ff       	jmp    80104f4c <alltraps>

80105c8a <vector227>:
.globl vector227
vector227:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $227
80105c8c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105c91:	e9 b6 f2 ff ff       	jmp    80104f4c <alltraps>

80105c96 <vector228>:
.globl vector228
vector228:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $228
80105c98:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105c9d:	e9 aa f2 ff ff       	jmp    80104f4c <alltraps>

80105ca2 <vector229>:
.globl vector229
vector229:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $229
80105ca4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105ca9:	e9 9e f2 ff ff       	jmp    80104f4c <alltraps>

80105cae <vector230>:
.globl vector230
vector230:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $230
80105cb0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105cb5:	e9 92 f2 ff ff       	jmp    80104f4c <alltraps>

80105cba <vector231>:
.globl vector231
vector231:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $231
80105cbc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105cc1:	e9 86 f2 ff ff       	jmp    80104f4c <alltraps>

80105cc6 <vector232>:
.globl vector232
vector232:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $232
80105cc8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105ccd:	e9 7a f2 ff ff       	jmp    80104f4c <alltraps>

80105cd2 <vector233>:
.globl vector233
vector233:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $233
80105cd4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105cd9:	e9 6e f2 ff ff       	jmp    80104f4c <alltraps>

80105cde <vector234>:
.globl vector234
vector234:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $234
80105ce0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105ce5:	e9 62 f2 ff ff       	jmp    80104f4c <alltraps>

80105cea <vector235>:
.globl vector235
vector235:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $235
80105cec:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105cf1:	e9 56 f2 ff ff       	jmp    80104f4c <alltraps>

80105cf6 <vector236>:
.globl vector236
vector236:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $236
80105cf8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105cfd:	e9 4a f2 ff ff       	jmp    80104f4c <alltraps>

80105d02 <vector237>:
.globl vector237
vector237:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $237
80105d04:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105d09:	e9 3e f2 ff ff       	jmp    80104f4c <alltraps>

80105d0e <vector238>:
.globl vector238
vector238:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $238
80105d10:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105d15:	e9 32 f2 ff ff       	jmp    80104f4c <alltraps>

80105d1a <vector239>:
.globl vector239
vector239:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $239
80105d1c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105d21:	e9 26 f2 ff ff       	jmp    80104f4c <alltraps>

80105d26 <vector240>:
.globl vector240
vector240:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $240
80105d28:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105d2d:	e9 1a f2 ff ff       	jmp    80104f4c <alltraps>

80105d32 <vector241>:
.globl vector241
vector241:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $241
80105d34:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105d39:	e9 0e f2 ff ff       	jmp    80104f4c <alltraps>

80105d3e <vector242>:
.globl vector242
vector242:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $242
80105d40:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105d45:	e9 02 f2 ff ff       	jmp    80104f4c <alltraps>

80105d4a <vector243>:
.globl vector243
vector243:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $243
80105d4c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105d51:	e9 f6 f1 ff ff       	jmp    80104f4c <alltraps>

80105d56 <vector244>:
.globl vector244
vector244:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $244
80105d58:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105d5d:	e9 ea f1 ff ff       	jmp    80104f4c <alltraps>

80105d62 <vector245>:
.globl vector245
vector245:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $245
80105d64:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105d69:	e9 de f1 ff ff       	jmp    80104f4c <alltraps>

80105d6e <vector246>:
.globl vector246
vector246:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $246
80105d70:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105d75:	e9 d2 f1 ff ff       	jmp    80104f4c <alltraps>

80105d7a <vector247>:
.globl vector247
vector247:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $247
80105d7c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105d81:	e9 c6 f1 ff ff       	jmp    80104f4c <alltraps>

80105d86 <vector248>:
.globl vector248
vector248:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $248
80105d88:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105d8d:	e9 ba f1 ff ff       	jmp    80104f4c <alltraps>

80105d92 <vector249>:
.globl vector249
vector249:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $249
80105d94:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105d99:	e9 ae f1 ff ff       	jmp    80104f4c <alltraps>

80105d9e <vector250>:
.globl vector250
vector250:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $250
80105da0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105da5:	e9 a2 f1 ff ff       	jmp    80104f4c <alltraps>

80105daa <vector251>:
.globl vector251
vector251:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $251
80105dac:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105db1:	e9 96 f1 ff ff       	jmp    80104f4c <alltraps>

80105db6 <vector252>:
.globl vector252
vector252:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $252
80105db8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105dbd:	e9 8a f1 ff ff       	jmp    80104f4c <alltraps>

80105dc2 <vector253>:
.globl vector253
vector253:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $253
80105dc4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105dc9:	e9 7e f1 ff ff       	jmp    80104f4c <alltraps>

80105dce <vector254>:
.globl vector254
vector254:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $254
80105dd0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105dd5:	e9 72 f1 ff ff       	jmp    80104f4c <alltraps>

80105dda <vector255>:
.globl vector255
vector255:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $255
80105ddc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105de1:	e9 66 f1 ff ff       	jmp    80104f4c <alltraps>

80105de6 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105de6:	55                   	push   %ebp
80105de7:	89 e5                	mov    %esp,%ebp
80105de9:	57                   	push   %edi
80105dea:	56                   	push   %esi
80105deb:	53                   	push   %ebx
80105dec:	83 ec 0c             	sub    $0xc,%esp
80105def:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105df1:	c1 ea 16             	shr    $0x16,%edx
80105df4:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105df7:	8b 1f                	mov    (%edi),%ebx
80105df9:	f6 c3 01             	test   $0x1,%bl
80105dfc:	74 21                	je     80105e1f <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105dfe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105e04:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105e0a:	c1 ee 0a             	shr    $0xa,%esi
80105e0d:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80105e13:	01 f3                	add    %esi,%ebx
}
80105e15:	89 d8                	mov    %ebx,%eax
80105e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e1a:	5b                   	pop    %ebx
80105e1b:	5e                   	pop    %esi
80105e1c:	5f                   	pop    %edi
80105e1d:	5d                   	pop    %ebp
80105e1e:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105e1f:	85 c9                	test   %ecx,%ecx
80105e21:	74 2b                	je     80105e4e <walkpgdir+0x68>
80105e23:	e8 73 c3 ff ff       	call   8010219b <kalloc>
80105e28:	89 c3                	mov    %eax,%ebx
80105e2a:	85 c0                	test   %eax,%eax
80105e2c:	74 e7                	je     80105e15 <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80105e2e:	83 ec 04             	sub    $0x4,%esp
80105e31:	68 00 10 00 00       	push   $0x1000
80105e36:	6a 00                	push   $0x0
80105e38:	50                   	push   %eax
80105e39:	e8 0a e0 ff ff       	call   80103e48 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105e3e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105e44:	83 c8 07             	or     $0x7,%eax
80105e47:	89 07                	mov    %eax,(%edi)
80105e49:	83 c4 10             	add    $0x10,%esp
80105e4c:	eb bc                	jmp    80105e0a <walkpgdir+0x24>
      return 0;
80105e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
80105e53:	eb c0                	jmp    80105e15 <walkpgdir+0x2f>

80105e55 <seginit>:
{
80105e55:	55                   	push   %ebp
80105e56:	89 e5                	mov    %esp,%ebp
80105e58:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105e5b:	e8 fb d4 ff ff       	call   8010335b <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e60:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105e66:	66 c7 80 f8 27 11 80 	movw   $0xffff,-0x7feed808(%eax)
80105e6d:	ff ff 
80105e6f:	66 c7 80 fa 27 11 80 	movw   $0x0,-0x7feed806(%eax)
80105e76:	00 00 
80105e78:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
80105e7f:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80105e86:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80105e8d:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105e94:	66 c7 80 00 28 11 80 	movw   $0xffff,-0x7feed800(%eax)
80105e9b:	ff ff 
80105e9d:	66 c7 80 02 28 11 80 	movw   $0x0,-0x7feed7fe(%eax)
80105ea4:	00 00 
80105ea6:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80105ead:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
80105eb4:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80105ebb:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105ec2:	66 c7 80 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%eax)
80105ec9:	ff ff 
80105ecb:	66 c7 80 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%eax)
80105ed2:	00 00 
80105ed4:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80105edb:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80105ee2:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80105ee9:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105ef0:	66 c7 80 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%eax)
80105ef7:	ff ff 
80105ef9:	66 c7 80 12 28 11 80 	movw   $0x0,-0x7feed7ee(%eax)
80105f00:	00 00 
80105f02:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80105f09:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
80105f10:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80105f17:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105f1e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[0] = size-1;
80105f23:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105f29:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105f2d:	c1 e8 10             	shr    $0x10,%eax
80105f30:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105f34:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105f37:	0f 01 10             	lgdtl  (%eax)
}
80105f3a:	c9                   	leave  
80105f3b:	c3                   	ret    

80105f3c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned.
//static int
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105f3c:	55                   	push   %ebp
80105f3d:	89 e5                	mov    %esp,%ebp
80105f3f:	57                   	push   %edi
80105f40:	56                   	push   %esi
80105f41:	53                   	push   %ebx
80105f42:	83 ec 1c             	sub    $0x1c,%esp
80105f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *a, *last; 
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105f48:	89 d0                	mov    %edx,%eax
80105f4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105f4f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105f51:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105f54:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
80105f58:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105f5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105f61:	8b 7d 14             	mov    0x14(%ebp),%edi
80105f64:	29 c7                	sub    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80105f66:	8b 45 18             	mov    0x18(%ebp),%eax
80105f69:	83 c8 01             	or     $0x1,%eax
80105f6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f6f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105f72:	b9 01 00 00 00       	mov    $0x1,%ecx
80105f77:	89 da                	mov    %ebx,%edx
80105f79:	8b 45 08             	mov    0x8(%ebp),%eax
80105f7c:	e8 65 fe ff ff       	call   80105de6 <walkpgdir>
80105f81:	85 c0                	test   %eax,%eax
80105f83:	74 24                	je     80105fa9 <mappages+0x6d>
    if(*pte & PTE_P)
80105f85:	f6 00 01             	testb  $0x1,(%eax)
80105f88:	75 12                	jne    80105f9c <mappages+0x60>
    *pte = pa | perm | PTE_P;
80105f8a:	0b 75 e0             	or     -0x20(%ebp),%esi
80105f8d:	89 30                	mov    %esi,(%eax)
    if(a == last)
80105f8f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80105f92:	74 22                	je     80105fb6 <mappages+0x7a>
      break;
    a += PGSIZE;
80105f94:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105f9a:	eb d3                	jmp    80105f6f <mappages+0x33>
      panic("remap");
80105f9c:	83 ec 0c             	sub    $0xc,%esp
80105f9f:	68 a8 71 10 80       	push   $0x801071a8
80105fa4:	e8 9b a3 ff ff       	call   80100344 <panic>
      return -1;
80105fa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb1:	5b                   	pop    %ebx
80105fb2:	5e                   	pop    %esi
80105fb3:	5f                   	pop    %edi
80105fb4:	5d                   	pop    %ebp
80105fb5:	c3                   	ret    
  return 0;
80105fb6:	b8 00 00 00 00       	mov    $0x0,%eax
80105fbb:	eb f1                	jmp    80105fae <mappages+0x72>

80105fbd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105fbd:	55                   	push   %ebp
80105fbe:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105fc0:	a1 c4 58 11 80       	mov    0x801158c4,%eax
80105fc5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105fca:	0f 22 d8             	mov    %eax,%cr3
}
80105fcd:	5d                   	pop    %ebp
80105fce:	c3                   	ret    

80105fcf <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105fcf:	55                   	push   %ebp
80105fd0:	89 e5                	mov    %esp,%ebp
80105fd2:	57                   	push   %edi
80105fd3:	56                   	push   %esi
80105fd4:	53                   	push   %ebx
80105fd5:	83 ec 1c             	sub    $0x1c,%esp
80105fd8:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105fdb:	85 f6                	test   %esi,%esi
80105fdd:	0f 84 c3 00 00 00    	je     801060a6 <switchuvm+0xd7>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105fe3:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105fe7:	0f 84 c6 00 00 00    	je     801060b3 <switchuvm+0xe4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105fed:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105ff1:	0f 84 c9 00 00 00    	je     801060c0 <switchuvm+0xf1>
    panic("switchuvm: no pgdir");

  pushcli();
80105ff7:	e8 cd dc ff ff       	call   80103cc9 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105ffc:	e8 e3 d2 ff ff       	call   801032e4 <mycpu>
80106001:	89 c3                	mov    %eax,%ebx
80106003:	e8 dc d2 ff ff       	call   801032e4 <mycpu>
80106008:	89 c7                	mov    %eax,%edi
8010600a:	e8 d5 d2 ff ff       	call   801032e4 <mycpu>
8010600f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106012:	e8 cd d2 ff ff       	call   801032e4 <mycpu>
80106017:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010601e:	67 00 
80106020:	83 c7 08             	add    $0x8,%edi
80106023:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010602a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010602d:	83 c2 08             	add    $0x8,%edx
80106030:	c1 ea 10             	shr    $0x10,%edx
80106033:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80106039:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106040:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106047:	83 c0 08             	add    $0x8,%eax
8010604a:	c1 e8 18             	shr    $0x18,%eax
8010604d:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106053:	e8 8c d2 ff ff       	call   801032e4 <mycpu>
80106058:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010605f:	e8 80 d2 ff ff       	call   801032e4 <mycpu>
80106064:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010606a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010606d:	e8 72 d2 ff ff       	call   801032e4 <mycpu>
80106072:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106078:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010607b:	e8 64 d2 ff ff       	call   801032e4 <mycpu>
80106080:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106086:	b8 28 00 00 00       	mov    $0x28,%eax
8010608b:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010608e:	8b 46 04             	mov    0x4(%esi),%eax
80106091:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106096:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106099:	e8 68 dc ff ff       	call   80103d06 <popcli>
}
8010609e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a1:	5b                   	pop    %ebx
801060a2:	5e                   	pop    %esi
801060a3:	5f                   	pop    %edi
801060a4:	5d                   	pop    %ebp
801060a5:	c3                   	ret    
    panic("switchuvm: no process");
801060a6:	83 ec 0c             	sub    $0xc,%esp
801060a9:	68 ae 71 10 80       	push   $0x801071ae
801060ae:	e8 91 a2 ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
801060b3:	83 ec 0c             	sub    $0xc,%esp
801060b6:	68 c4 71 10 80       	push   $0x801071c4
801060bb:	e8 84 a2 ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	68 d9 71 10 80       	push   $0x801071d9
801060c8:	e8 77 a2 ff ff       	call   80100344 <panic>

801060cd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801060cd:	55                   	push   %ebp
801060ce:	89 e5                	mov    %esp,%ebp
801060d0:	56                   	push   %esi
801060d1:	53                   	push   %ebx
801060d2:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801060d5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801060db:	77 4b                	ja     80106128 <inituvm+0x5b>
    panic("inituvm: more than a page");
  mem = kalloc();
801060dd:	e8 b9 c0 ff ff       	call   8010219b <kalloc>
801060e2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801060e4:	83 ec 04             	sub    $0x4,%esp
801060e7:	68 00 10 00 00       	push   $0x1000
801060ec:	6a 00                	push   $0x0
801060ee:	50                   	push   %eax
801060ef:	e8 54 dd ff ff       	call   80103e48 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801060f4:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801060fb:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106101:	50                   	push   %eax
80106102:	68 00 10 00 00       	push   $0x1000
80106107:	6a 00                	push   $0x0
80106109:	ff 75 08             	pushl  0x8(%ebp)
8010610c:	e8 2b fe ff ff       	call   80105f3c <mappages>
  memmove(mem, init, sz);
80106111:	83 c4 1c             	add    $0x1c,%esp
80106114:	56                   	push   %esi
80106115:	ff 75 0c             	pushl  0xc(%ebp)
80106118:	53                   	push   %ebx
80106119:	e8 bf dd ff ff       	call   80103edd <memmove>
}
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106124:	5b                   	pop    %ebx
80106125:	5e                   	pop    %esi
80106126:	5d                   	pop    %ebp
80106127:	c3                   	ret    
    panic("inituvm: more than a page");
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	68 ed 71 10 80       	push   $0x801071ed
80106130:	e8 0f a2 ff ff       	call   80100344 <panic>

80106135 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106135:	55                   	push   %ebp
80106136:	89 e5                	mov    %esp,%ebp
80106138:	57                   	push   %edi
80106139:	56                   	push   %esi
8010613a:	53                   	push   %ebx
8010613b:	83 ec 1c             	sub    $0x1c,%esp
8010613e:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106144:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106149:	75 71                	jne    801061bc <loaduvm+0x87>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010614b:	8b 75 18             	mov    0x18(%ebp),%esi
8010614e:	bb 00 00 00 00       	mov    $0x0,%ebx
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106153:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106158:	85 f6                	test   %esi,%esi
8010615a:	74 7f                	je     801061db <loaduvm+0xa6>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010615c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010615f:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80106162:	b9 00 00 00 00       	mov    $0x0,%ecx
80106167:	8b 45 08             	mov    0x8(%ebp),%eax
8010616a:	e8 77 fc ff ff       	call   80105de6 <walkpgdir>
8010616f:	85 c0                	test   %eax,%eax
80106171:	74 56                	je     801061c9 <loaduvm+0x94>
    pa = PTE_ADDR(*pte);
80106173:	8b 00                	mov    (%eax),%eax
80106175:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
8010617a:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106180:	bf 00 10 00 00       	mov    $0x1000,%edi
80106185:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106188:	57                   	push   %edi
80106189:	89 da                	mov    %ebx,%edx
8010618b:	03 55 14             	add    0x14(%ebp),%edx
8010618e:	52                   	push   %edx
8010618f:	05 00 00 00 80       	add    $0x80000000,%eax
80106194:	50                   	push   %eax
80106195:	ff 75 10             	pushl  0x10(%ebp)
80106198:	e8 1a b6 ff ff       	call   801017b7 <readi>
8010619d:	83 c4 10             	add    $0x10,%esp
801061a0:	39 f8                	cmp    %edi,%eax
801061a2:	75 32                	jne    801061d6 <loaduvm+0xa1>
  for(i = 0; i < sz; i += PGSIZE){
801061a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061aa:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801061b0:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801061b3:	77 a7                	ja     8010615c <loaduvm+0x27>
  return 0;
801061b5:	b8 00 00 00 00       	mov    $0x0,%eax
801061ba:	eb 1f                	jmp    801061db <loaduvm+0xa6>
    panic("loaduvm: addr must be page aligned");
801061bc:	83 ec 0c             	sub    $0xc,%esp
801061bf:	68 4c 73 10 80       	push   $0x8010734c
801061c4:	e8 7b a1 ff ff       	call   80100344 <panic>
      panic("loaduvm: address should exist");
801061c9:	83 ec 0c             	sub    $0xc,%esp
801061cc:	68 07 72 10 80       	push   $0x80107207
801061d1:	e8 6e a1 ff ff       	call   80100344 <panic>
      return -1;
801061d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061de:	5b                   	pop    %ebx
801061df:	5e                   	pop    %esi
801061e0:	5f                   	pop    %edi
801061e1:	5d                   	pop    %ebp
801061e2:	c3                   	ret    

801061e3 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801061e3:	55                   	push   %ebp
801061e4:	89 e5                	mov    %esp,%ebp
801061e6:	57                   	push   %edi
801061e7:	56                   	push   %esi
801061e8:	53                   	push   %ebx
801061e9:	83 ec 0c             	sub    $0xc,%esp
801061ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
801061ef:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
801061f1:	39 7d 10             	cmp    %edi,0x10(%ebp)
801061f4:	73 16                	jae    8010620c <deallocuvm+0x29>

  a = PGROUNDUP(newsz);
801061f6:	8b 45 10             	mov    0x10(%ebp),%eax
801061f9:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801061ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106205:	39 df                	cmp    %ebx,%edi
80106207:	77 21                	ja     8010622a <deallocuvm+0x47>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106209:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010620c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010620f:	5b                   	pop    %ebx
80106210:	5e                   	pop    %esi
80106211:	5f                   	pop    %edi
80106212:	5d                   	pop    %ebp
80106213:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106214:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010621a:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106220:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106226:	39 df                	cmp    %ebx,%edi
80106228:	76 df                	jbe    80106209 <deallocuvm+0x26>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010622a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010622f:	89 da                	mov    %ebx,%edx
80106231:	8b 45 08             	mov    0x8(%ebp),%eax
80106234:	e8 ad fb ff ff       	call   80105de6 <walkpgdir>
80106239:	89 c6                	mov    %eax,%esi
    if(!pte)
8010623b:	85 c0                	test   %eax,%eax
8010623d:	74 d5                	je     80106214 <deallocuvm+0x31>
    else if((*pte & PTE_P) != 0){
8010623f:	8b 00                	mov    (%eax),%eax
80106241:	a8 01                	test   $0x1,%al
80106243:	74 db                	je     80106220 <deallocuvm+0x3d>
      if(pa == 0)
80106245:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010624a:	74 19                	je     80106265 <deallocuvm+0x82>
      kfree(v);
8010624c:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010624f:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106254:	50                   	push   %eax
80106255:	e8 1c be ff ff       	call   80102076 <kfree>
      *pte = 0;
8010625a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106260:	83 c4 10             	add    $0x10,%esp
80106263:	eb bb                	jmp    80106220 <deallocuvm+0x3d>
        panic("kfree");
80106265:	83 ec 0c             	sub    $0xc,%esp
80106268:	68 e6 6a 10 80       	push   $0x80106ae6
8010626d:	e8 d2 a0 ff ff       	call   80100344 <panic>

80106272 <allocuvm>:
{
80106272:	55                   	push   %ebp
80106273:	89 e5                	mov    %esp,%ebp
80106275:	57                   	push   %edi
80106276:	56                   	push   %esi
80106277:	53                   	push   %ebx
80106278:	83 ec 1c             	sub    $0x1c,%esp
8010627b:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010627e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106281:	85 ff                	test   %edi,%edi
80106283:	0f 88 c6 00 00 00    	js     8010634f <allocuvm+0xdd>
  if(newsz < oldsz)
80106289:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010628c:	72 61                	jb     801062ef <allocuvm+0x7d>
  a = PGROUNDUP(oldsz);
8010628e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106291:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106297:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010629d:	39 df                	cmp    %ebx,%edi
8010629f:	0f 86 b1 00 00 00    	jbe    80106356 <allocuvm+0xe4>
    mem = kalloc();
801062a5:	e8 f1 be ff ff       	call   8010219b <kalloc>
801062aa:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801062ac:	85 c0                	test   %eax,%eax
801062ae:	74 47                	je     801062f7 <allocuvm+0x85>
    memset(mem, 0, PGSIZE);
801062b0:	83 ec 04             	sub    $0x4,%esp
801062b3:	68 00 10 00 00       	push   $0x1000
801062b8:	6a 00                	push   $0x0
801062ba:	50                   	push   %eax
801062bb:	e8 88 db ff ff       	call   80103e48 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801062c0:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801062c7:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801062cd:	50                   	push   %eax
801062ce:	68 00 10 00 00       	push   $0x1000
801062d3:	53                   	push   %ebx
801062d4:	ff 75 08             	pushl  0x8(%ebp)
801062d7:	e8 60 fc ff ff       	call   80105f3c <mappages>
801062dc:	83 c4 20             	add    $0x20,%esp
801062df:	85 c0                	test   %eax,%eax
801062e1:	78 3c                	js     8010631f <allocuvm+0xad>
  for(; a < newsz; a += PGSIZE){
801062e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801062e9:	39 df                	cmp    %ebx,%edi
801062eb:	77 b8                	ja     801062a5 <allocuvm+0x33>
801062ed:	eb 67                	jmp    80106356 <allocuvm+0xe4>
    return oldsz;
801062ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801062f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801062f5:	eb 5f                	jmp    80106356 <allocuvm+0xe4>
      cprintf("allocuvm out of memory\n");
801062f7:	83 ec 0c             	sub    $0xc,%esp
801062fa:	68 25 72 10 80       	push   $0x80107225
801062ff:	e8 dd a2 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106304:	83 c4 0c             	add    $0xc,%esp
80106307:	ff 75 0c             	pushl  0xc(%ebp)
8010630a:	57                   	push   %edi
8010630b:	ff 75 08             	pushl  0x8(%ebp)
8010630e:	e8 d0 fe ff ff       	call   801061e3 <deallocuvm>
      return 0;
80106313:	83 c4 10             	add    $0x10,%esp
80106316:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010631d:	eb 37                	jmp    80106356 <allocuvm+0xe4>
      cprintf("allocuvm out of memory (2)\n");
8010631f:	83 ec 0c             	sub    $0xc,%esp
80106322:	68 3d 72 10 80       	push   $0x8010723d
80106327:	e8 b5 a2 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010632c:	83 c4 0c             	add    $0xc,%esp
8010632f:	ff 75 0c             	pushl  0xc(%ebp)
80106332:	57                   	push   %edi
80106333:	ff 75 08             	pushl  0x8(%ebp)
80106336:	e8 a8 fe ff ff       	call   801061e3 <deallocuvm>
      kfree(mem);
8010633b:	89 34 24             	mov    %esi,(%esp)
8010633e:	e8 33 bd ff ff       	call   80102076 <kfree>
      return 0;
80106343:	83 c4 10             	add    $0x10,%esp
80106346:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010634d:	eb 07                	jmp    80106356 <allocuvm+0xe4>
    return 0;
8010634f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010635c:	5b                   	pop    %ebx
8010635d:	5e                   	pop    %esi
8010635e:	5f                   	pop    %edi
8010635f:	5d                   	pop    %ebp
80106360:	c3                   	ret    

80106361 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106361:	55                   	push   %ebp
80106362:	89 e5                	mov    %esp,%ebp
80106364:	57                   	push   %edi
80106365:	56                   	push   %esi
80106366:	53                   	push   %ebx
80106367:	83 ec 0c             	sub    $0xc,%esp
8010636a:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0){
8010636d:	85 ff                	test   %edi,%edi
8010636f:	74 1d                	je     8010638e <freevm+0x2d>
    //cprintf("Segmentation Fault");
  }
  // deallocuvm(pgdir, KERNBASE, 0);
  //Project2
  // Only deallocate non-shared memory
  deallocuvm(pgdir, (KERNBASE - NSHAREPAGE * PGSIZE), 0);
80106371:	83 ec 04             	sub    $0x4,%esp
80106374:	6a 00                	push   $0x0
80106376:	68 00 c0 ff 7f       	push   $0x7fffc000
8010637b:	57                   	push   %edi
8010637c:	e8 62 fe ff ff       	call   801061e3 <deallocuvm>
80106381:	89 fb                	mov    %edi,%ebx
80106383:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80106389:	83 c4 10             	add    $0x10,%esp
8010638c:	eb 14                	jmp    801063a2 <freevm+0x41>
    panic("freevm: no pgdir");
8010638e:	83 ec 0c             	sub    $0xc,%esp
80106391:	68 59 72 10 80       	push   $0x80107259
80106396:	e8 a9 9f ff ff       	call   80100344 <panic>
8010639b:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
8010639e:	39 f3                	cmp    %esi,%ebx
801063a0:	74 1e                	je     801063c0 <freevm+0x5f>
    if(pgdir[i] & PTE_P){
801063a2:	8b 03                	mov    (%ebx),%eax
801063a4:	a8 01                	test   $0x1,%al
801063a6:	74 f3                	je     8010639b <freevm+0x3a>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801063a8:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
801063ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801063b0:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801063b5:	50                   	push   %eax
801063b6:	e8 bb bc ff ff       	call   80102076 <kfree>
801063bb:	83 c4 10             	add    $0x10,%esp
801063be:	eb db                	jmp    8010639b <freevm+0x3a>
    }
  }
  kfree((char*)pgdir);
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	57                   	push   %edi
801063c4:	e8 ad bc ff ff       	call   80102076 <kfree>
}
801063c9:	83 c4 10             	add    $0x10,%esp
801063cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063cf:	5b                   	pop    %ebx
801063d0:	5e                   	pop    %esi
801063d1:	5f                   	pop    %edi
801063d2:	5d                   	pop    %ebp
801063d3:	c3                   	ret    

801063d4 <setupkvm>:
{
801063d4:	55                   	push   %ebp
801063d5:	89 e5                	mov    %esp,%ebp
801063d7:	56                   	push   %esi
801063d8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801063d9:	e8 bd bd ff ff       	call   8010219b <kalloc>
801063de:	89 c6                	mov    %eax,%esi
801063e0:	85 c0                	test   %eax,%eax
801063e2:	74 42                	je     80106426 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801063e4:	83 ec 04             	sub    $0x4,%esp
801063e7:	68 00 10 00 00       	push   $0x1000
801063ec:	6a 00                	push   $0x0
801063ee:	50                   	push   %eax
801063ef:	e8 54 da ff ff       	call   80103e48 <memset>
801063f4:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801063f7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
801063fc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801063ff:	83 ec 0c             	sub    $0xc,%esp
80106402:	ff 73 0c             	pushl  0xc(%ebx)
80106405:	50                   	push   %eax
80106406:	8b 53 08             	mov    0x8(%ebx),%edx
80106409:	29 c2                	sub    %eax,%edx
8010640b:	52                   	push   %edx
8010640c:	ff 33                	pushl  (%ebx)
8010640e:	56                   	push   %esi
8010640f:	e8 28 fb ff ff       	call   80105f3c <mappages>
80106414:	83 c4 20             	add    $0x20,%esp
80106417:	85 c0                	test   %eax,%eax
80106419:	78 14                	js     8010642f <setupkvm+0x5b>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010641b:	83 c3 10             	add    $0x10,%ebx
8010641e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106424:	75 d6                	jne    801063fc <setupkvm+0x28>
}
80106426:	89 f0                	mov    %esi,%eax
80106428:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010642b:	5b                   	pop    %ebx
8010642c:	5e                   	pop    %esi
8010642d:	5d                   	pop    %ebp
8010642e:	c3                   	ret    
      freevm(pgdir);
8010642f:	83 ec 0c             	sub    $0xc,%esp
80106432:	56                   	push   %esi
80106433:	e8 29 ff ff ff       	call   80106361 <freevm>
      return 0;
80106438:	83 c4 10             	add    $0x10,%esp
8010643b:	be 00 00 00 00       	mov    $0x0,%esi
80106440:	eb e4                	jmp    80106426 <setupkvm+0x52>

80106442 <kvmalloc>:
{
80106442:	55                   	push   %ebp
80106443:	89 e5                	mov    %esp,%ebp
80106445:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106448:	e8 87 ff ff ff       	call   801063d4 <setupkvm>
8010644d:	a3 c4 58 11 80       	mov    %eax,0x801158c4
  switchkvm();
80106452:	e8 66 fb ff ff       	call   80105fbd <switchkvm>
}
80106457:	c9                   	leave  
80106458:	c3                   	ret    

80106459 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106459:	55                   	push   %ebp
8010645a:	89 e5                	mov    %esp,%ebp
8010645c:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010645f:	b9 00 00 00 00       	mov    $0x0,%ecx
80106464:	8b 55 0c             	mov    0xc(%ebp),%edx
80106467:	8b 45 08             	mov    0x8(%ebp),%eax
8010646a:	e8 77 f9 ff ff       	call   80105de6 <walkpgdir>
  if(pte == 0)
8010646f:	85 c0                	test   %eax,%eax
80106471:	74 05                	je     80106478 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106473:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106476:	c9                   	leave  
80106477:	c3                   	ret    
    panic("clearpteu");
80106478:	83 ec 0c             	sub    $0xc,%esp
8010647b:	68 6a 72 10 80       	push   $0x8010726a
80106480:	e8 bf 9e ff ff       	call   80100344 <panic>

80106485 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, struct proc *child, struct proc *parent)
{
80106485:	55                   	push   %ebp
80106486:	89 e5                	mov    %esp,%ebp
80106488:	57                   	push   %edi
80106489:	56                   	push   %esi
8010648a:	53                   	push   %ebx
8010648b:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010648e:	e8 41 ff ff ff       	call   801063d4 <setupkvm>
80106493:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106496:	85 c0                	test   %eax,%eax
80106498:	0f 84 d9 00 00 00    	je     80106577 <copyuvm+0xf2>
    return 0;
  //Begin to the Pagesize in order to avoid the first part of address.
  for(i = PGSIZE; i < sz; i += PGSIZE){
8010649e:	81 7d 0c 00 10 00 00 	cmpl   $0x1000,0xc(%ebp)
801064a5:	0f 86 84 00 00 00    	jbe    8010652f <copyuvm+0xaa>
801064ab:	bf 00 10 00 00       	mov    $0x1000,%edi
801064b0:	89 fe                	mov    %edi,%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801064b2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801064b5:	b9 00 00 00 00       	mov    $0x0,%ecx
801064ba:	89 f2                	mov    %esi,%edx
801064bc:	8b 45 08             	mov    0x8(%ebp),%eax
801064bf:	e8 22 f9 ff ff       	call   80105de6 <walkpgdir>
801064c4:	85 c0                	test   %eax,%eax
801064c6:	74 74                	je     8010653c <copyuvm+0xb7>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801064c8:	8b 18                	mov    (%eax),%ebx
801064ca:	f6 c3 01             	test   $0x1,%bl
801064cd:	74 7a                	je     80106549 <copyuvm+0xc4>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801064cf:	89 df                	mov    %ebx,%edi
801064d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
801064d7:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801064dd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801064e0:	e8 b6 bc ff ff       	call   8010219b <kalloc>
801064e5:	89 c3                	mov    %eax,%ebx
801064e7:	85 c0                	test   %eax,%eax
801064e9:	74 77                	je     80106562 <copyuvm+0xdd>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801064eb:	83 ec 04             	sub    $0x4,%esp
801064ee:	68 00 10 00 00       	push   $0x1000
801064f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801064f9:	57                   	push   %edi
801064fa:	50                   	push   %eax
801064fb:	e8 dd d9 ff ff       	call   80103edd <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106500:	83 c4 04             	add    $0x4,%esp
80106503:	ff 75 e0             	pushl  -0x20(%ebp)
80106506:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010650c:	50                   	push   %eax
8010650d:	68 00 10 00 00       	push   $0x1000
80106512:	ff 75 e4             	pushl  -0x1c(%ebp)
80106515:	ff 75 dc             	pushl  -0x24(%ebp)
80106518:	e8 1f fa ff ff       	call   80105f3c <mappages>
8010651d:	83 c4 20             	add    $0x20,%esp
80106520:	85 c0                	test   %eax,%eax
80106522:	78 32                	js     80106556 <copyuvm+0xd1>
  for(i = PGSIZE; i < sz; i += PGSIZE){
80106524:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010652a:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010652d:	77 83                	ja     801064b2 <copyuvm+0x2d>
8010652f:	bb 00 00 00 00       	mov    $0x0,%ebx
80106534:	8b 7d dc             	mov    -0x24(%ebp),%edi
80106537:	8b 75 14             	mov    0x14(%ebp),%esi
8010653a:	eb 4e                	jmp    8010658a <copyuvm+0x105>
      panic("copyuvm: pte should exist");
8010653c:	83 ec 0c             	sub    $0xc,%esp
8010653f:	68 74 72 10 80       	push   $0x80107274
80106544:	e8 fb 9d ff ff       	call   80100344 <panic>
      panic("copyuvm: page not present");
80106549:	83 ec 0c             	sub    $0xc,%esp
8010654c:	68 8e 72 10 80       	push   $0x8010728e
80106551:	e8 ee 9d ff ff       	call   80100344 <panic>
      kfree(mem);
80106556:	83 ec 0c             	sub    $0xc,%esp
80106559:	53                   	push   %ebx
8010655a:	e8 17 bb ff ff       	call   80102076 <kfree>
      goto bad;
8010655f:	83 c4 10             	add    $0x10,%esp
  }
  
  return d;

bad:
  freevm(d);
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	ff 75 dc             	pushl  -0x24(%ebp)
80106568:	e8 f4 fd ff ff       	call   80106361 <freevm>
  return 0;
8010656d:	83 c4 10             	add    $0x10,%esp
80106570:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106577:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010657a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010657d:	5b                   	pop    %ebx
8010657e:	5e                   	pop    %esi
8010657f:	5f                   	pop    %edi
80106580:	5d                   	pop    %ebp
80106581:	c3                   	ret    
80106582:	83 c3 04             	add    $0x4,%ebx
  for (int i = 0; i < NSHAREPAGE; i++)
80106585:	83 fb 10             	cmp    $0x10,%ebx
80106588:	74 ed                	je     80106577 <copyuvm+0xf2>
    if (parent->shared_page[i])
8010658a:	8b 44 1e 7c          	mov    0x7c(%esi,%ebx,1),%eax
8010658e:	85 c0                	test   %eax,%eax
80106590:	74 f0                	je     80106582 <copyuvm+0xfd>
      child->shared_page[i] = parent->shared_page[i];
80106592:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106595:	89 44 19 7c          	mov    %eax,0x7c(%ecx,%ebx,1)
      if(mappages(d, child->shared_page[i], PGSIZE, V2P(sm_addr[i]), PTE_W|PTE_U) < 0 ){
80106599:	83 ec 0c             	sub    $0xc,%esp
8010659c:	6a 06                	push   $0x6
8010659e:	8b 93 a4 58 11 80    	mov    -0x7feea75c(%ebx),%edx
801065a4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801065aa:	52                   	push   %edx
801065ab:	68 00 10 00 00       	push   $0x1000
801065b0:	50                   	push   %eax
801065b1:	57                   	push   %edi
801065b2:	e8 85 f9 ff ff       	call   80105f3c <mappages>
801065b7:	83 c4 20             	add    $0x20,%esp
801065ba:	85 c0                	test   %eax,%eax
801065bc:	78 a4                	js     80106562 <copyuvm+0xdd>
      sm_counts[i]++;
801065be:	83 83 b4 58 11 80 01 	addl   $0x1,-0x7feea74c(%ebx)
801065c5:	eb bb                	jmp    80106582 <copyuvm+0xfd>

801065c7 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801065c7:	55                   	push   %ebp
801065c8:	89 e5                	mov    %esp,%ebp
801065ca:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801065cd:	b9 00 00 00 00       	mov    $0x0,%ecx
801065d2:	8b 55 0c             	mov    0xc(%ebp),%edx
801065d5:	8b 45 08             	mov    0x8(%ebp),%eax
801065d8:	e8 09 f8 ff ff       	call   80105de6 <walkpgdir>
  if((*pte & PTE_P) == 0)
801065dd:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801065df:	89 c2                	mov    %eax,%edx
801065e1:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801065e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065e9:	05 00 00 00 80       	add    $0x80000000,%eax
801065ee:	83 fa 05             	cmp    $0x5,%edx
801065f1:	ba 00 00 00 00       	mov    $0x0,%edx
801065f6:	0f 45 c2             	cmovne %edx,%eax
}
801065f9:	c9                   	leave  
801065fa:	c3                   	ret    

801065fb <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801065fb:	55                   	push   %ebp
801065fc:	89 e5                	mov    %esp,%ebp
801065fe:	57                   	push   %edi
801065ff:	56                   	push   %esi
80106600:	53                   	push   %ebx
80106601:	83 ec 0c             	sub    $0xc,%esp
80106604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106607:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010660b:	74 55                	je     80106662 <copyout+0x67>
    va0 = (uint)PGROUNDDOWN(va);
8010660d:	89 df                	mov    %ebx,%edi
8010660f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106615:	83 ec 08             	sub    $0x8,%esp
80106618:	57                   	push   %edi
80106619:	ff 75 08             	pushl  0x8(%ebp)
8010661c:	e8 a6 ff ff ff       	call   801065c7 <uva2ka>
    if(pa0 == 0)
80106621:	83 c4 10             	add    $0x10,%esp
80106624:	85 c0                	test   %eax,%eax
80106626:	74 41                	je     80106669 <copyout+0x6e>
      return -1;
    n = PGSIZE - (va - va0);
80106628:	89 fe                	mov    %edi,%esi
8010662a:	29 de                	sub    %ebx,%esi
8010662c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106632:	3b 75 14             	cmp    0x14(%ebp),%esi
80106635:	0f 47 75 14          	cmova  0x14(%ebp),%esi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106639:	83 ec 04             	sub    $0x4,%esp
8010663c:	56                   	push   %esi
8010663d:	ff 75 10             	pushl  0x10(%ebp)
80106640:	29 fb                	sub    %edi,%ebx
80106642:	01 d8                	add    %ebx,%eax
80106644:	50                   	push   %eax
80106645:	e8 93 d8 ff ff       	call   80103edd <memmove>
    len -= n;
    buf += n;
8010664a:	01 75 10             	add    %esi,0x10(%ebp)
    va = va0 + PGSIZE;
8010664d:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
  while(len > 0){
80106653:	83 c4 10             	add    $0x10,%esp
80106656:	29 75 14             	sub    %esi,0x14(%ebp)
80106659:	75 b2                	jne    8010660d <copyout+0x12>
  }
  return 0;
8010665b:	b8 00 00 00 00       	mov    $0x0,%eax
80106660:	eb 0c                	jmp    8010666e <copyout+0x73>
80106662:	b8 00 00 00 00       	mov    $0x0,%eax
80106667:	eb 05                	jmp    8010666e <copyout+0x73>
      return -1;
80106669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010666e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106671:	5b                   	pop    %ebx
80106672:	5e                   	pop    %esi
80106673:	5f                   	pop    %edi
80106674:	5d                   	pop    %ebp
80106675:	c3                   	ret    

80106676 <shmem_init>:

// Shared memory pages
// The purpose of this funciton is to initial share page memory
void shmem_init(void){
80106676:	55                   	push   %ebp
80106677:	89 e5                	mov    %esp,%ebp
80106679:	53                   	push   %ebx
8010667a:	83 ec 04             	sub    $0x4,%esp
8010667d:	bb 00 00 00 00       	mov    $0x0,%ebx

  int i;
  for(i = 0; i < NSHAREPAGE; i++)
  {
    //initial sharemem
    sm_counts[i] = 0;
80106682:	c7 83 b4 58 11 80 00 	movl   $0x0,-0x7feea74c(%ebx)
80106689:	00 00 00 
    if ( (sm_addr[i] = kalloc()) == 0 ) {
8010668c:	e8 0a bb ff ff       	call   8010219b <kalloc>
80106691:	89 83 a4 58 11 80    	mov    %eax,-0x7feea75c(%ebx)
80106697:	85 c0                	test   %eax,%eax
80106699:	74 49                	je     801066e4 <shmem_init+0x6e>
      panic("shared memory init failed\n");
      return (void)-1;
    }
    memset(sm_addr[i], 0, PGSIZE);
8010669b:	83 ec 04             	sub    $0x4,%esp
8010669e:	68 00 10 00 00       	push   $0x1000
801066a3:	6a 00                	push   $0x0
801066a5:	50                   	push   %eax
801066a6:	e8 9d d7 ff ff       	call   80103e48 <memset>
    //V2P change virtual address to physical address
    cprintf("The initial address in SharedPage would be %x\n", V2P(sm_addr[i]));
801066ab:	83 c4 08             	add    $0x8,%esp
801066ae:	8b 83 a4 58 11 80    	mov    -0x7feea75c(%ebx),%eax
801066b4:	05 00 00 00 80       	add    $0x80000000,%eax
801066b9:	50                   	push   %eax
801066ba:	68 70 73 10 80       	push   $0x80107370
801066bf:	e8 1d 9f ff ff       	call   801005e1 <cprintf>
801066c4:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NSHAREPAGE; i++)
801066c7:	83 c4 10             	add    $0x10,%esp
801066ca:	83 fb 10             	cmp    $0x10,%ebx
801066cd:	75 b3                	jne    80106682 <shmem_init+0xc>
  }
  cprintf("shmem_init completed\n");
801066cf:	83 ec 0c             	sub    $0xc,%esp
801066d2:	68 c3 72 10 80       	push   $0x801072c3
801066d7:	e8 05 9f ff ff       	call   801005e1 <cprintf>
}
801066dc:	83 c4 10             	add    $0x10,%esp
801066df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066e2:	c9                   	leave  
801066e3:	c3                   	ret    
      panic("shared memory init failed\n");
801066e4:	83 ec 0c             	sub    $0xc,%esp
801066e7:	68 a8 72 10 80       	push   $0x801072a8
801066ec:	e8 53 9c ff ff       	call   80100344 <panic>

801066f1 <shmem_access>:

//The purpose of this funciton is to get the start virtual address for each page
void* shmem_access(int page_number){
801066f1:	55                   	push   %ebp
801066f2:	89 e5                	mov    %esp,%ebp
801066f4:	57                   	push   %edi
801066f5:	56                   	push   %esi
801066f6:	53                   	push   %ebx
801066f7:	83 ec 1c             	sub    $0x1c,%esp
801066fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // Check whether page number is illegal
  if (page_number < 0 || page_number >= NSHAREPAGE) {
801066fd:	83 fb 03             	cmp    $0x3,%ebx
80106700:	0f 87 e8 00 00 00    	ja     801067ee <shmem_access+0xfd>
    cprintf("illegal page number\n");
    return (void*)-1;
  }
  cprintf("shmem_access begin\n");
80106706:	83 ec 0c             	sub    $0xc,%esp
80106709:	68 ee 72 10 80       	push   $0x801072ee
8010670e:	e8 ce 9e ff ff       	call   801005e1 <cprintf>
  struct proc *current_proc = myproc();
80106713:	e8 5e cc ff ff       	call   80103376 <myproc>
80106718:	89 c6                	mov    %eax,%esi
8010671a:	8d 3c 98             	lea    (%eax,%ebx,4),%edi
  //  Check whether the share memory is already allocated for given page number.
  if (current_proc->shared_page[page_number]!=0)
8010671d:	83 c4 10             	add    $0x10,%esp
80106720:	83 7f 7c 00          	cmpl   $0x0,0x7c(%edi)
80106724:	0f 85 e6 00 00 00    	jne    80106810 <shmem_access+0x11f>
  {
    cprintf("%d page haven't allocate space for share memory\n", page_number);
    return (void *)(current_proc->shared_page[page_number]);
  }
  void* virtual_addr = (void*)( KERNBASE - ( page_number+1 ) * PGSIZE );
8010672a:	8d 43 01             	lea    0x1(%ebx),%eax
8010672d:	c1 e0 0c             	shl    $0xc,%eax
  // Check whether virtual address is illegal
  if ( current_proc->sz > V2P(virtual_addr) )
80106730:	89 c2                	mov    %eax,%edx
80106732:	f7 da                	neg    %edx
80106734:	39 16                	cmp    %edx,(%esi)
80106736:	0f 87 ed 00 00 00    	ja     80106829 <shmem_access+0x138>
  void* virtual_addr = (void*)( KERNBASE - ( page_number+1 ) * PGSIZE );
8010673c:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106741:	29 c2                	sub    %eax,%edx
80106743:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106746:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  {
    cprintf("Virtual Address is Illegal\n");
    return (void*) -1;
  }
  
  if ( mappages(current_proc->pgdir, 
80106749:	83 ec 0c             	sub    $0xc,%esp
8010674c:	6a 06                	push   $0x6
8010674e:	8b 04 9d a4 58 11 80 	mov    -0x7feea75c(,%ebx,4),%eax
80106755:	05 00 00 00 80       	add    $0x80000000,%eax
8010675a:	50                   	push   %eax
8010675b:	68 00 10 00 00       	push   $0x1000
80106760:	52                   	push   %edx
80106761:	ff 76 04             	pushl  0x4(%esi)
80106764:	e8 d3 f7 ff ff       	call   80105f3c <mappages>
80106769:	83 c4 20             	add    $0x20,%esp
8010676c:	85 c0                	test   %eax,%eax
8010676e:	0f 88 ce 00 00 00    	js     80106842 <shmem_access+0x151>
      )
  {
    panic("mappages is fail in the shmem_access\n");
  }
  
  sm_counts[page_number]++;
80106774:	83 04 9d b4 58 11 80 	addl   $0x1,-0x7feea74c(,%ebx,4)
8010677b:	01 
  current_proc->shared_page[page_number] = virtual_addr;
8010677c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010677f:	89 47 7c             	mov    %eax,0x7c(%edi)
  cprintf("========================================================\n");
80106782:	83 ec 0c             	sub    $0xc,%esp
80106785:	68 fc 73 10 80       	push   $0x801073fc
8010678a:	e8 52 9e ff ff       	call   801005e1 <cprintf>
  cprintf("shared memeory address: %x, %x, %x, %x\n", sm_addr[0], sm_addr[1], sm_addr[2], sm_addr[3]);
8010678f:	83 c4 04             	add    $0x4,%esp
80106792:	ff 35 b0 58 11 80    	pushl  0x801158b0
80106798:	ff 35 ac 58 11 80    	pushl  0x801158ac
8010679e:	ff 35 a8 58 11 80    	pushl  0x801158a8
801067a4:	ff 35 a4 58 11 80    	pushl  0x801158a4
801067aa:	68 38 74 10 80       	push   $0x80107438
801067af:	e8 2d 9e ff ff       	call   801005e1 <cprintf>
  cprintf("pid %d, psz: %d, virtual address: %x, shmem_count: %d \n", current_proc->pid, current_proc->sz, (uint) virtual_addr, sm_counts[page_number]);
801067b4:	83 c4 14             	add    $0x14,%esp
801067b7:	ff 34 9d b4 58 11 80 	pushl  -0x7feea74c(,%ebx,4)
801067be:	ff 75 e0             	pushl  -0x20(%ebp)
801067c1:	ff 36                	pushl  (%esi)
801067c3:	ff 76 10             	pushl  0x10(%esi)
801067c6:	68 60 74 10 80       	push   $0x80107460
801067cb:	e8 11 9e ff ff       	call   801005e1 <cprintf>
  cprintf("========================================================\n");
801067d0:	83 c4 14             	add    $0x14,%esp
801067d3:	68 fc 73 10 80       	push   $0x801073fc
801067d8:	e8 04 9e ff ff       	call   801005e1 <cprintf>
  cprintf("shmem_access completed\n");
801067dd:	c7 04 24 1e 73 10 80 	movl   $0x8010731e,(%esp)
801067e4:	e8 f8 9d ff ff       	call   801005e1 <cprintf>
  return virtual_addr;
801067e9:	83 c4 10             	add    $0x10,%esp
801067ec:	eb 17                	jmp    80106805 <shmem_access+0x114>
    cprintf("illegal page number\n");
801067ee:	83 ec 0c             	sub    $0xc,%esp
801067f1:	68 d9 72 10 80       	push   $0x801072d9
801067f6:	e8 e6 9d ff ff       	call   801005e1 <cprintf>
    return (void*)-1;
801067fb:	83 c4 10             	add    $0x10,%esp
801067fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
}
80106805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010680b:	5b                   	pop    %ebx
8010680c:	5e                   	pop    %esi
8010680d:	5f                   	pop    %edi
8010680e:	5d                   	pop    %ebp
8010680f:	c3                   	ret    
    cprintf("%d page haven't allocate space for share memory\n", page_number);
80106810:	83 ec 08             	sub    $0x8,%esp
80106813:	53                   	push   %ebx
80106814:	68 a0 73 10 80       	push   $0x801073a0
80106819:	e8 c3 9d ff ff       	call   801005e1 <cprintf>
    return (void *)(current_proc->shared_page[page_number]);
8010681e:	8b 47 7c             	mov    0x7c(%edi),%eax
80106821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106824:	83 c4 10             	add    $0x10,%esp
80106827:	eb dc                	jmp    80106805 <shmem_access+0x114>
    cprintf("Virtual Address is Illegal\n");
80106829:	83 ec 0c             	sub    $0xc,%esp
8010682c:	68 02 73 10 80       	push   $0x80107302
80106831:	e8 ab 9d ff ff       	call   801005e1 <cprintf>
    return (void*) -1;
80106836:	83 c4 10             	add    $0x10,%esp
80106839:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80106840:	eb c3                	jmp    80106805 <shmem_access+0x114>
    panic("mappages is fail in the shmem_access\n");
80106842:	83 ec 0c             	sub    $0xc,%esp
80106845:	68 d4 73 10 80       	push   $0x801073d4
8010684a:	e8 f5 9a ff ff       	call   80100344 <panic>

8010684f <shmem_count>:

// the purpose of this function is to count how many processes are using the same share page.
int shmem_count(int page_number){
8010684f:	55                   	push   %ebp
80106850:	89 e5                	mov    %esp,%ebp
80106852:	83 ec 08             	sub    $0x8,%esp
80106855:	8b 45 08             	mov    0x8(%ebp),%eax
  if (page_number < 0 || page_number > NSHAREPAGE) {
80106858:	83 f8 04             	cmp    $0x4,%eax
8010685b:	77 09                	ja     80106866 <shmem_count+0x17>
    cprintf("illegal page number");
    return -1;
  }
  
  return sm_counts[page_number];
8010685d:	8b 04 85 b4 58 11 80 	mov    -0x7feea74c(,%eax,4),%eax
}
80106864:	c9                   	leave  
80106865:	c3                   	ret    
    cprintf("illegal page number");
80106866:	83 ec 0c             	sub    $0xc,%esp
80106869:	68 36 73 10 80       	push   $0x80107336
8010686e:	e8 6e 9d ff ff       	call   801005e1 <cprintf>
    return -1;
80106873:	83 c4 10             	add    $0x10,%esp
80106876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010687b:	eb e7                	jmp    80106864 <shmem_count+0x15>
