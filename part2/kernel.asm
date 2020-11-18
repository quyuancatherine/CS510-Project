
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
8010002d:	b8 40 31 10 80       	mov    $0x80103140,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 74 10 80       	push   $0x80107420
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 65 46 00 00       	call   801046c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 74 10 80       	push   $0x80107427
80100097:	50                   	push   %eax
80100098:	e8 f3 44 00 00       	call   80104590 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 17 47 00 00       	call   80104800 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 59 47 00 00       	call   801048c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 44 00 00       	call   801045d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 22 00 00       	call   801023c0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 74 10 80       	push   $0x8010742e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 44 00 00       	call   80104670 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 f7 21 00 00       	jmp    801023c0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 74 10 80       	push   $0x8010743f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 44 00 00       	call   80104670 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 44 00 00       	call   80104630 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 f0 45 00 00       	call   80104800 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 46 00 00       	jmp    801048c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 74 10 80       	push   $0x80107446
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 6f 45 00 00       	call   80104800 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 56 3f 00 00       	call   80104220 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 37 00 00       	call   80103aa0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 cc 45 00 00       	call   801048c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 6e 45 00 00       	call   801048c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 26 00 00       	call   801029d0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 74 10 80       	push   $0x8010744d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 df 7d 10 80 	movl   $0x80107ddf,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 43 00 00       	call   801046e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 74 10 80       	push   $0x80107461
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 5b 00 00       	call   80106030 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 5b 00 00       	call   80106030 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 5b 00 00       	call   80106030 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 5b 00 00       	call   80106030 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 44 00 00       	call   801049c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 43 00 00       	call   80104910 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 74 10 80       	push   $0x80107465
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 74 10 80 	movzbl -0x7fef8b70(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 e0 41 00 00       	call   80104800 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 74 42 00 00       	call   801048c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 9c 41 00 00       	call   801048c0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 74 10 80       	mov    $0x80107478,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 0b 40 00 00       	call   80104800 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 74 10 80       	push   $0x8010747f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 d8 3f 00 00       	call   80104800 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 33 40 00 00       	call   801048c0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 c5 3a 00 00       	call   801043e0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 24 3b 00 00       	jmp    801044c0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 74 10 80       	push   $0x80107488
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 eb 3c 00 00       	call   801046c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 72 1b 00 00       	call   80102570 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 7f 30 00 00       	call   80103aa0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 14 24 00 00       	call   80102e40 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 49 17 00 00       	call   80102180 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 92 0f 00 00       	call   801019f0 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 3c 24 00 00       	call   80102eb0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 e7 66 00 00       	call   80107180 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 a5 64 00 00       	call   80106fa0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 b3 63 00 00       	call   80106ee0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 93 0e 00 00       	call   801019f0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 89 65 00 00       	call   80107100 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 11 23 00 00       	call   80102eb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 f1 63 00 00       	call   80106fa0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 3a 65 00 00       	call   80107100 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 22 00 00       	call   80102eb0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 a1 74 10 80       	push   $0x801074a1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 15 66 00 00       	call   80107220 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 f2 3e 00 00       	call   80104b30 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 df 3e 00 00       	call   80104b30 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 1e 67 00 00       	call   80107380 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 b4 66 00 00       	call   80107380 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 e1 3d 00 00       	call   80104af0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 17 60 00 00       	call   80106d50 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 bf 63 00 00       	call   80107100 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 ad 74 10 80       	push   $0x801074ad
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 4b 39 00 00       	call   801046c0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 6a 3a 00 00       	call   80104800 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 fa 3a 00 00       	call   801048c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 e1 3a 00 00       	call   801048c0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 fc 39 00 00       	call   80104800 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 9f 3a 00 00       	call   801048c0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 b4 74 10 80       	push   $0x801074b4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 aa 39 00 00       	call   80104800 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 3f 3a 00 00       	jmp    801048c0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 13 3a 00 00       	call   801048c0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 1a 27 00 00       	call   801035f0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 5b 1f 00 00       	call   80102e40 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 b1 1f 00 00       	jmp    80102eb0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 bc 74 10 80       	push   $0x801074bc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 54 0a 00 00       	call   801019f0 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 27 00 00       	jmp    801037a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 c6 74 10 80       	push   $0x801074c6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 62 1e 00 00       	call   80102eb0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 c5 1d 00 00       	call   80102e40 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 78 0b 00 00       	call   80101c10 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 fe 1d 00 00       	call   80102eb0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 9e 25 00 00       	jmp    80103690 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 cf 74 10 80       	push   $0x801074cf
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 d5 74 10 80       	push   $0x801074d5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 df 74 10 80       	push   $0x801074df
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 3e 1e 00 00       	call   80103010 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 16 37 00 00       	call   80104910 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 0e 1e 00 00       	call   80103010 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 09 11 80       	push   $0x801109e0
8010123a:	e8 c1 35 00 00       	call   80104800 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 1c 36 00 00       	call   801048c0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 ee 35 00 00       	call   801048c0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 f5 74 10 80       	push   $0x801074f5
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 28                	ja     80101328 <bmap+0x38>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 66                	je     80101370 <bmap+0x80>
      log_write(bp);
    }
    brelse(bp);
    //Project 5
    //For Checksum file
    if(ip->type == T_CHECKED)
8010130a:	66 83 7e 50 04       	cmpw   $0x4,0x50(%esi)
8010130f:	75 06                	jne    80101317 <bmap+0x27>
      addr = 0x00ffffff & addr;
80101311:	81 e3 ff ff ff 00    	and    $0xffffff,%ebx
    return addr;
  }

  panic("bmap: out of range");
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 d8                	mov    %ebx,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101328:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010132b:	83 fb 7f             	cmp    $0x7f,%ebx
8010132e:	0f 87 7d 00 00 00    	ja     801013b1 <bmap+0xc1>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101334:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010133a:	8b 00                	mov    (%eax),%eax
8010133c:	85 d2                	test   %edx,%edx
8010133e:	74 60                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101340:	83 ec 08             	sub    $0x8,%esp
80101343:	52                   	push   %edx
80101344:	50                   	push   %eax
80101345:	e8 86 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010134a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010134e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101351:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101353:	8b 1a                	mov    (%edx),%ebx
80101355:	85 db                	test   %ebx,%ebx
80101357:	74 27                	je     80101380 <bmap+0x90>
    brelse(bp);
80101359:	83 ec 0c             	sub    $0xc,%esp
8010135c:	57                   	push   %edi
8010135d:	e8 7e ee ff ff       	call   801001e0 <brelse>
    if(ip->type == T_CHECKED)
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb a3                	jmp    8010130a <bmap+0x1a>
80101367:	89 f6                	mov    %esi,%esi
80101369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 00                	mov    (%eax),%eax
80101372:	e8 99 fd ff ff       	call   80101110 <balloc>
80101377:	89 c3                	mov    %eax,%ebx
80101379:	89 47 5c             	mov    %eax,0x5c(%edi)
8010137c:	eb 8c                	jmp    8010130a <bmap+0x1a>
8010137e:	66 90                	xchg   %ax,%ax
      a[bn] = addr = balloc(ip->dev);
80101380:	8b 06                	mov    (%esi),%eax
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101385:	e8 86 fd ff ff       	call   80101110 <balloc>
8010138a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010138d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101390:	89 c3                	mov    %eax,%ebx
80101392:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101394:	57                   	push   %edi
80101395:	e8 76 1c 00 00       	call   80103010 <log_write>
8010139a:	83 c4 10             	add    $0x10,%esp
8010139d:	eb ba                	jmp    80101359 <bmap+0x69>
8010139f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	eb 8f                	jmp    80101340 <bmap+0x50>
  panic("bmap: out of range");
801013b1:	83 ec 0c             	sub    $0xc,%esp
801013b4:	68 05 75 10 80       	push   $0x80107505
801013b9:	e8 d2 ef ff ff       	call   80100390 <panic>
801013be:	66 90                	xchg   %ax,%ax

801013c0 <readsb>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013c8:	83 ec 08             	sub    $0x8,%esp
801013cb:	6a 01                	push   $0x1
801013cd:	ff 75 08             	pushl  0x8(%ebp)
801013d0:	e8 fb ec ff ff       	call   801000d0 <bread>
801013d5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013da:	83 c4 0c             	add    $0xc,%esp
801013dd:	6a 1c                	push   $0x1c
801013df:	50                   	push   %eax
801013e0:	56                   	push   %esi
801013e1:	e8 da 35 00 00       	call   801049c0 <memmove>
  brelse(bp);
801013e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013e9:	83 c4 10             	add    $0x10,%esp
}
801013ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ef:	5b                   	pop    %ebx
801013f0:	5e                   	pop    %esi
801013f1:	5d                   	pop    %ebp
  brelse(bp);
801013f2:	e9 e9 ed ff ff       	jmp    801001e0 <brelse>
801013f7:	89 f6                	mov    %esi,%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101400 <bfree>:
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	89 d3                	mov    %edx,%ebx
80101407:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101409:	83 ec 08             	sub    $0x8,%esp
8010140c:	68 c0 09 11 80       	push   $0x801109c0
80101411:	50                   	push   %eax
80101412:	e8 a9 ff ff ff       	call   801013c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101417:	58                   	pop    %eax
80101418:	5a                   	pop    %edx
80101419:	89 da                	mov    %ebx,%edx
8010141b:	c1 ea 0c             	shr    $0xc,%edx
8010141e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101424:	52                   	push   %edx
80101425:	56                   	push   %esi
80101426:	e8 a5 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010142b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101430:	ba 01 00 00 00       	mov    $0x1,%edx
80101435:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101438:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010143e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101441:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101443:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101448:	85 d1                	test   %edx,%ecx
8010144a:	74 25                	je     80101471 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010144c:	f7 d2                	not    %edx
8010144e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101450:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101453:	21 ca                	and    %ecx,%edx
80101455:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101459:	56                   	push   %esi
8010145a:	e8 b1 1b 00 00       	call   80103010 <log_write>
  brelse(bp);
8010145f:	89 34 24             	mov    %esi,(%esp)
80101462:	e8 79 ed ff ff       	call   801001e0 <brelse>
}
80101467:	83 c4 10             	add    $0x10,%esp
8010146a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146d:	5b                   	pop    %ebx
8010146e:	5e                   	pop    %esi
8010146f:	5d                   	pop    %ebp
80101470:	c3                   	ret    
    panic("freeing free block");
80101471:	83 ec 0c             	sub    $0xc,%esp
80101474:	68 18 75 10 80       	push   $0x80107518
80101479:	e8 12 ef ff ff       	call   80100390 <panic>
8010147e:	66 90                	xchg   %ax,%ax

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 2b 75 10 80       	push   $0x8010752b
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 25 32 00 00       	call   801046c0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 32 75 10 80       	push   $0x80107532
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 dc 30 00 00       	call   80104590 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 c0 09 11 80       	push   $0x801109c0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 f1 fe ff ff       	call   801013c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014d5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014db:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014e1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014e7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ed:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014f3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014f9:	68 bc 75 10 80       	push   $0x801075bc
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 7d 33 00 00       	call   80104910 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 6b 1a 00 00       	call   80103010 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 60 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 38 75 10 80       	push   $0x80107538
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 8a 33 00 00       	call   801049c0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 d2 19 00 00       	call   80103010 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 e0 09 11 80       	push   $0x801109e0
8010165f:	e8 9c 31 00 00       	call   80104800 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 4c 32 00 00       	call   801048c0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 29 2f 00 00       	call   801045d0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 a3 32 00 00       	call   801049c0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 50 75 10 80       	push   $0x80107550
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 4a 75 10 80       	push   $0x8010754a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 f8 2e 00 00       	call   80104670 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 9c 2e 00 00       	jmp    80104630 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 5f 75 10 80       	push   $0x8010755f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 0b 2e 00 00       	call   801045d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 51 2e 00 00       	call   80104630 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 15 30 00 00       	call   80104800 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 bb 30 00 00       	jmp    801048c0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 eb 2f 00 00       	call   80104800 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 9c 30 00 00       	call   801048c0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 ac fb ff ff       	call   80101400 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 24 fb ff ff       	call   80101400 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 07 fb ff ff       	call   80101400 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010193c:	8b 75 0c             	mov    0xc(%ebp),%esi
  st->dev = ip->dev;
8010193f:	8b 01                	mov    (%ecx),%eax
80101941:	89 46 04             	mov    %eax,0x4(%esi)
  st->ino = ip->inum;
80101944:	8b 41 04             	mov    0x4(%ecx),%eax
80101947:	89 46 08             	mov    %eax,0x8(%esi)
  st->type = ip->type;
8010194a:	0f b7 41 50          	movzwl 0x50(%ecx),%eax
8010194e:	66 89 06             	mov    %ax,(%esi)
  st->nlink = ip->nlink;
80101951:	0f b7 41 56          	movzwl 0x56(%ecx),%eax
80101955:	66 89 46 0c          	mov    %ax,0xc(%esi)
  st->size = ip->size;
80101959:	8b 41 58             	mov    0x58(%ecx),%eax
8010195c:	89 46 10             	mov    %eax,0x10(%esi)

  //Calculate Checksum
  if (ip->type == T_CHECKED) {
8010195f:	66 83 79 50 04       	cmpw   $0x4,0x50(%ecx)
80101964:	74 0a                	je     80101970 <stati+0x40>
      brelse(indirect_bp);
    }
    st->checksum = (uchar) checksum;
  }
  
}
80101966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101969:	5b                   	pop    %ebx
8010196a:	5e                   	pop    %esi
8010196b:	5f                   	pop    %edi
8010196c:	5d                   	pop    %ebp
8010196d:	c3                   	ret    
8010196e:	66 90                	xchg   %ax,%ax
80101970:	8d 41 5c             	lea    0x5c(%ecx),%eax
80101973:	8d b9 8c 00 00 00    	lea    0x8c(%ecx),%edi
    uint checksum = 0;
80101979:	31 db                	xor    %ebx,%ebx
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      checksum ^= (ip->addrs[i] >> 24) & 0xff;
80101980:	8b 10                	mov    (%eax),%edx
80101982:	83 c0 04             	add    $0x4,%eax
80101985:	c1 ea 18             	shr    $0x18,%edx
80101988:	31 d3                	xor    %edx,%ebx
    for(int i = 0; i < NDIRECT; i++)
8010198a:	39 f8                	cmp    %edi,%eax
8010198c:	75 f2                	jne    80101980 <stati+0x50>
    if (ip->addrs[NDIRECT] != 0) {
8010198e:	8b 81 8c 00 00 00    	mov    0x8c(%ecx),%eax
80101994:	85 c0                	test   %eax,%eax
80101996:	75 10                	jne    801019a8 <stati+0x78>
    st->checksum = (uchar) checksum;
80101998:	88 5e 14             	mov    %bl,0x14(%esi)
}
8010199b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010199e:	5b                   	pop    %ebx
8010199f:	5e                   	pop    %esi
801019a0:	5f                   	pop    %edi
801019a1:	5d                   	pop    %ebp
801019a2:	c3                   	ret    
801019a3:	90                   	nop
801019a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      struct buf *indirect_bp = bread(ip->dev, ip->addrs[NINDIRECT]);
801019a8:	83 ec 08             	sub    $0x8,%esp
801019ab:	ff b1 5c 02 00 00    	pushl  0x25c(%ecx)
801019b1:	ff 31                	pushl  (%ecx)
801019b3:	e8 18 e7 ff ff       	call   801000d0 <bread>
      uint *addr = (uint*)indirect_bp->data;
801019b8:	8d 50 5c             	lea    0x5c(%eax),%edx
801019bb:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
801019c1:	83 c4 10             	add    $0x10,%esp
801019c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        checksum ^= ((*addr) >> 24) & 0xff;
801019c8:	8b 0a                	mov    (%edx),%ecx
        addr++;
801019ca:	83 c2 04             	add    $0x4,%edx
        checksum ^= ((*addr) >> 24) & 0xff;
801019cd:	c1 e9 18             	shr    $0x18,%ecx
801019d0:	31 cb                	xor    %ecx,%ebx
      for(int i = 0; i < NINDIRECT; i++)
801019d2:	39 d7                	cmp    %edx,%edi
801019d4:	75 f2                	jne    801019c8 <stati+0x98>
      brelse(indirect_bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	50                   	push   %eax
801019da:	e8 01 e8 ff ff       	call   801001e0 <brelse>
801019df:	83 c4 10             	add    $0x10,%esp
801019e2:	eb b4                	jmp    80101998 <stati+0x68>
801019e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 2c             	sub    $0x2c,%esp
801019f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019fc:	8b 75 08             	mov    0x8(%ebp),%esi
801019ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101a02:	8b 45 10             	mov    0x10(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a05:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101a0a:	89 c3                	mov    %eax,%ebx
80101a0c:	8b 45 14             	mov    0x14(%ebp),%eax
80101a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a12:	0f 84 48 01 00 00    	je     80101b60 <readi+0x170>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a18:	8b 46 58             	mov    0x58(%esi),%eax
80101a1b:	39 c3                	cmp    %eax,%ebx
80101a1d:	0f 87 2c 01 00 00    	ja     80101b4f <readi+0x15f>
80101a23:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a26:	89 da                	mov    %ebx,%edx
80101a28:	31 c9                	xor    %ecx,%ecx
80101a2a:	01 fa                	add    %edi,%edx
80101a2c:	0f 92 c1             	setb   %cl
80101a2f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80101a32:	0f 82 17 01 00 00    	jb     80101b4f <readi+0x15f>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a38:	89 c1                	mov    %eax,%ecx
80101a3a:	29 d9                	sub    %ebx,%ecx
80101a3c:	39 d0                	cmp    %edx,%eax
80101a3e:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a41:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
80101a43:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a46:	0f 84 3c 01 00 00    	je     80101b88 <readi+0x198>
80101a4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a53:	eb 39                	jmp    80101a8e <readi+0x9e>
80101a55:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("Checksum is unmatch in Readi()\n");
      }

    }
    //Project5 End
    memmove(dst, bp->data + off%BSIZE, m);
80101a58:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a5c:	83 ec 04             	sub    $0x4,%esp
80101a5f:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101a62:	57                   	push   %edi
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a63:	01 fb                	add    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a65:	50                   	push   %eax
80101a66:	ff 75 dc             	pushl  -0x24(%ebp)
80101a69:	e8 52 2f 00 00       	call   801049c0 <memmove>
    brelse(bp);
80101a6e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101a71:	89 14 24             	mov    %edx,(%esp)
80101a74:	e8 67 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a79:	01 7d e4             	add    %edi,-0x1c(%ebp)
80101a7c:	01 7d dc             	add    %edi,-0x24(%ebp)
80101a7f:	83 c4 10             	add    $0x10,%esp
80101a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a85:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101a88:	0f 86 fa 00 00 00    	jbe    80101b88 <readi+0x198>
    uint block = bmap(ip, off/BSIZE);
80101a8e:	89 df                	mov    %ebx,%edi
80101a90:	89 f0                	mov    %esi,%eax
80101a92:	c1 ef 09             	shr    $0x9,%edi
80101a95:	89 fa                	mov    %edi,%edx
80101a97:	e8 54 f8 ff ff       	call   801012f0 <bmap>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9c:	89 fa                	mov    %edi,%edx
    uint block = bmap(ip, off/BSIZE);
80101a9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa1:	89 f0                	mov    %esi,%eax
80101aa3:	e8 48 f8 ff ff       	call   801012f0 <bmap>
80101aa8:	83 ec 08             	sub    $0x8,%esp
80101aab:	50                   	push   %eax
80101aac:	ff 36                	pushl  (%esi)
80101aae:	e8 1d e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab3:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab6:	2b 7d e4             	sub    -0x1c(%ebp),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab9:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abb:	89 d8                	mov    %ebx,%eax
80101abd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ac2:	83 c4 10             	add    $0x10,%esp
80101ac5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aca:	29 c1                	sub    %eax,%ecx
80101acc:	39 f9                	cmp    %edi,%ecx
80101ace:	0f 46 f9             	cmovbe %ecx,%edi
    if (ip->type == T_CHECKED) {
80101ad1:	66 83 7e 50 04       	cmpw   $0x4,0x50(%esi)
80101ad6:	75 80                	jne    80101a58 <readi+0x68>
80101ad8:	8d 46 5c             	lea    0x5c(%esi),%eax
80101adb:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101ae1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80101ae4:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ae7:	89 d3                	mov    %edx,%ebx
80101ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((ip->addrs[i] & 0x00ffffff)== block){
80101af0:	8b 38                	mov    (%eax),%edi
80101af2:	89 fa                	mov    %edi,%edx
80101af4:	81 e2 ff ff ff 00    	and    $0xffffff,%edx
80101afa:	39 d6                	cmp    %edx,%esi
80101afc:	0f 84 91 00 00 00    	je     80101b93 <readi+0x1a3>
80101b02:	83 c0 04             	add    $0x4,%eax
      for( i = 0; i < NDIRECT; i++)
80101b05:	39 c1                	cmp    %eax,%ecx
80101b07:	75 e7                	jne    80101af0 <readi+0x100>
80101b09:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      if (isFind == 0 && ip->addrs[NDIRECT]!=0 ) {
80101b0c:	8b be 8c 00 00 00    	mov    0x8c(%esi),%edi
80101b12:	85 ff                	test   %edi,%edi
80101b14:	0f 85 9a 00 00 00    	jne    80101bb4 <readi+0x1c4>
      char* data = (char*)bp->data;
80101b1a:	8d 43 5c             	lea    0x5c(%ebx),%eax
      int checksum = 0;
80101b1d:	31 f6                	xor    %esi,%esi
80101b1f:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80101b25:	8d 76 00             	lea    0x0(%esi),%esi
          checksum = checksum ^ (uint)* data;
80101b28:	0f be 10             	movsbl (%eax),%edx
          data++;
80101b2b:	83 c0 01             	add    $0x1,%eax
          checksum = checksum ^ (uint)* data;
80101b2e:	31 d6                	xor    %edx,%esi
      for(int i = 0; i < BSIZE; i++)
80101b30:	39 d8                	cmp    %ebx,%eax
80101b32:	75 f4                	jne    80101b28 <readi+0x138>
      cprintf("addr is %d\n", addr);
80101b34:	83 ec 08             	sub    $0x8,%esp
80101b37:	57                   	push   %edi
80101b38:	68 81 75 10 80       	push   $0x80107581
80101b3d:	e8 1e eb ff ff       	call   80100660 <cprintf>
      if (checksum == old) {
80101b42:	83 c4 10             	add    $0x10,%esp
80101b45:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
        return 1;
80101b48:	b8 01 00 00 00       	mov    $0x1,%eax
      if (checksum == old) {
80101b4d:	74 3c                	je     80101b8b <readi+0x19b>
        return -1;
80101b4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b54:	eb 35                	jmp    80101b8b <readi+0x19b>
80101b56:	8d 76 00             	lea    0x0(%esi),%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 46 52          	movswl 0x52(%esi),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 e5                	ja     80101b4f <readi+0x15f>
80101b6a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 da                	je     80101b4f <readi+0x15f>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101b78:	89 75 10             	mov    %esi,0x10(%ebp)
  }
  return n;
}
80101b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7e:	5b                   	pop    %ebx
80101b7f:	5e                   	pop    %esi
80101b80:	5f                   	pop    %edi
80101b81:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b82:	ff e0                	jmp    *%eax
80101b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return n;
80101b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8e:	5b                   	pop    %ebx
80101b8f:	5e                   	pop    %esi
80101b90:	5f                   	pop    %edi
80101b91:	5d                   	pop    %ebp
80101b92:	c3                   	ret    
          cprintf("addr: %d, block size: %d\n", ip->addrs[i], block);
80101b93:	83 ec 04             	sub    $0x4,%esp
80101b96:	ff 75 d8             	pushl  -0x28(%ebp)
80101b99:	57                   	push   %edi
80101b9a:	68 67 75 10 80       	push   $0x80107567
80101b9f:	e8 bc ea ff ff       	call   80100660 <cprintf>
80101ba4:	89 f8                	mov    %edi,%eax
80101ba6:	83 c4 10             	add    $0x10,%esp
80101ba9:	c1 e8 18             	shr    $0x18,%eax
80101bac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101baf:	e9 66 ff ff ff       	jmp    80101b1a <readi+0x12a>
        struct buf *buf = bread(ip->dev, ip->addrs[NDIRECT]);
80101bb4:	83 ec 08             	sub    $0x8,%esp
80101bb7:	57                   	push   %edi
80101bb8:	ff 36                	pushl  (%esi)
      uint addr = 0;
80101bba:	31 ff                	xor    %edi,%edi
        struct buf *buf = bread(ip->dev, ip->addrs[NDIRECT]);
80101bbc:	e8 0f e5 ff ff       	call   801000d0 <bread>
          if(((*ptr) & 0x00ffffff) == block){
80101bc1:	8b 50 5c             	mov    0x5c(%eax),%edx
      uint addr = 0;
80101bc4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
        struct buf *buf = bread(ip->dev, ip->addrs[NDIRECT]);
80101bc7:	89 c6                	mov    %eax,%esi
      uint addr = 0;
80101bc9:	8b 5d d8             	mov    -0x28(%ebp),%ebx
          if(((*ptr) & 0x00ffffff) == block){
80101bcc:	83 c4 10             	add    $0x10,%esp
80101bcf:	b8 80 00 00 00       	mov    $0x80,%eax
80101bd4:	89 d1                	mov    %edx,%ecx
80101bd6:	81 e1 ff ff ff 00    	and    $0xffffff,%ecx
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            addr = *ptr;
80101be0:	39 cb                	cmp    %ecx,%ebx
80101be2:	0f 44 fa             	cmove  %edx,%edi
        for(int i = 0; i < NINDIRECT; i++)
80101be5:	83 e8 01             	sub    $0x1,%eax
80101be8:	75 f6                	jne    80101be0 <readi+0x1f0>
        brelse(buf);       
80101bea:	83 ec 0c             	sub    $0xc,%esp
80101bed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bf0:	56                   	push   %esi
80101bf1:	e8 ea e5 ff ff       	call   801001e0 <brelse>
80101bf6:	89 f8                	mov    %edi,%eax
80101bf8:	83 c4 10             	add    $0x10,%esp
80101bfb:	c1 e8 18             	shr    $0x18,%eax
80101bfe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101c01:	e9 14 ff ff ff       	jmp    80101b1a <readi+0x12a>
80101c06:	8d 76 00             	lea    0x0(%esi),%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 2c             	sub    $0x2c,%esp
80101c19:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1c:	8b 7d 08             	mov    0x8(%ebp),%edi
80101c1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c22:	8b 45 10             	mov    0x10(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c25:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101c2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c2d:	8b 45 14             	mov    0x14(%ebp),%eax
80101c30:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(ip->type == T_DEV){
80101c33:	0f 84 c1 01 00 00    	je     80101dfa <writei+0x1ea>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c3c:	39 47 58             	cmp    %eax,0x58(%edi)
80101c3f:	0f 82 d9 01 00 00    	jb     80101e1e <writei+0x20e>
80101c45:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101c48:	01 f0                	add    %esi,%eax
80101c4a:	89 c2                	mov    %eax,%edx
80101c4c:	0f 92 c0             	setb   %al
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c4f:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c55:	0f b6 c0             	movzbl %al,%eax
80101c58:	0f 87 c0 01 00 00    	ja     80101e1e <writei+0x20e>
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	0f 85 b8 01 00 00    	jne    80101e1e <writei+0x20e>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c66:	85 f6                	test   %esi,%esi
80101c68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c6f:	75 43                	jne    80101cb4 <writei+0xa4>
80101c71:	e9 79 01 00 00       	jmp    80101def <writei+0x1df>
80101c76:	8d 76 00             	lea    0x0(%esi),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        brelse(indirect_buf);
      }
      
    }
    //Project 5 END
    log_write(bp);
80101c80:	83 ec 0c             	sub    $0xc,%esp
80101c83:	56                   	push   %esi
80101c84:	e8 87 13 00 00       	call   80103010 <log_write>
    bwrite(bp);
80101c89:	89 34 24             	mov    %esi,(%esp)
80101c8c:	e8 0f e5 ff ff       	call   801001a0 <bwrite>
    brelse(bp);
80101c91:	89 34 24             	mov    %esi,(%esp)
80101c94:	e8 47 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c99:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80101c9c:	01 75 e4             	add    %esi,-0x1c(%ebp)
80101c9f:	83 c4 10             	add    $0x10,%esp
80101ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca5:	01 75 e0             	add    %esi,-0x20(%ebp)
80101ca8:	01 75 d8             	add    %esi,-0x28(%ebp)
80101cab:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80101cae:	0f 86 21 01 00 00    	jbe    80101dd5 <writei+0x1c5>
    uint block = bmap(ip, off/BSIZE);
80101cb4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cb7:	89 f8                	mov    %edi,%eax
80101cb9:	c1 eb 09             	shr    $0x9,%ebx
80101cbc:	89 da                	mov    %ebx,%edx
80101cbe:	e8 2d f6 ff ff       	call   801012f0 <bmap>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cc3:	89 da                	mov    %ebx,%edx
    uint block = bmap(ip, off/BSIZE);
80101cc5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cc8:	89 f8                	mov    %edi,%eax
80101cca:	e8 21 f6 ff ff       	call   801012f0 <bmap>
80101ccf:	83 ec 08             	sub    $0x8,%esp
80101cd2:	50                   	push   %eax
80101cd3:	ff 37                	pushl  (%edi)
80101cd5:	e8 f6 e3 ff ff       	call   801000d0 <bread>
80101cda:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101cdf:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ce2:	2b 55 e4             	sub    -0x1c(%ebp),%edx
80101ce5:	b9 00 02 00 00       	mov    $0x200,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cea:	8d 5e 5c             	lea    0x5c(%esi),%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ced:	83 c4 0c             	add    $0xc,%esp
80101cf0:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cf5:	29 c1                	sub    %eax,%ecx
80101cf7:	39 d1                	cmp    %edx,%ecx
80101cf9:	0f 46 d1             	cmovbe %ecx,%edx
    memmove(bp->data + off%BSIZE, src, m);
80101cfc:	01 d8                	add    %ebx,%eax
80101cfe:	52                   	push   %edx
80101cff:	ff 75 d8             	pushl  -0x28(%ebp)
80101d02:	50                   	push   %eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d03:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101d06:	e8 b5 2c 00 00       	call   801049c0 <memmove>
    if (ip->type == T_CHECKED) {
80101d0b:	83 c4 10             	add    $0x10,%esp
80101d0e:	66 83 7f 50 04       	cmpw   $0x4,0x50(%edi)
80101d13:	0f 85 67 ff ff ff    	jne    80101c80 <writei+0x70>
80101d19:	8d 8e 5c 02 00 00    	lea    0x25c(%esi),%ecx
      uint checksum = 0;
80101d1f:	31 d2                	xor    %edx,%edx
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        checksum = checksum ^ (uint)*data;
80101d28:	0f be 03             	movsbl (%ebx),%eax
        data++;
80101d2b:	83 c3 01             	add    $0x1,%ebx
        checksum = checksum ^ (uint)*data;
80101d2e:	31 c2                	xor    %eax,%edx
      for(int i = 0; i < BSIZE; i++)
80101d30:	39 cb                	cmp    %ecx,%ebx
80101d32:	75 f4                	jne    80101d28 <writei+0x118>
      for(int i = 0; i < NDIRECT; i++)
80101d34:	8b 5d d0             	mov    -0x30(%ebp),%ebx
80101d37:	31 c0                	xor    %eax,%eax
80101d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((ip->addrs[i] & 0x00ffffff) == block){
80101d40:	8b 4c 87 5c          	mov    0x5c(%edi,%eax,4),%ecx
80101d44:	81 e1 ff ff ff 00    	and    $0xffffff,%ecx
80101d4a:	39 cb                	cmp    %ecx,%ebx
80101d4c:	74 78                	je     80101dc6 <writei+0x1b6>
      for(int i = 0; i < NDIRECT; i++)
80101d4e:	83 c0 01             	add    $0x1,%eax
80101d51:	83 f8 0c             	cmp    $0xc,%eax
80101d54:	75 ea                	jne    80101d40 <writei+0x130>
        struct buf *indirect_buf = bread(ip->dev,ip->addrs[NDIRECT]);
80101d56:	83 ec 08             	sub    $0x8,%esp
80101d59:	ff b7 8c 00 00 00    	pushl  0x8c(%edi)
80101d5f:	ff 37                	pushl  (%edi)
80101d61:	89 55 c8             	mov    %edx,-0x38(%ebp)
80101d64:	e8 67 e3 ff ff       	call   801000d0 <bread>
            if(((*ptr) & 0x00ffffff) == block){
80101d69:	8b 48 5c             	mov    0x5c(%eax),%ecx
80101d6c:	83 c4 10             	add    $0x10,%esp
        struct buf *indirect_buf = bread(ip->dev,ip->addrs[NDIRECT]);
80101d6f:	89 c3                	mov    %eax,%ebx
80101d71:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
          ptr++;
80101d77:	8d 40 60             	lea    0x60(%eax),%eax
            if(((*ptr) & 0x00ffffff) == block){
80101d7a:	81 e1 ff ff ff 00    	and    $0xffffff,%ecx
80101d80:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
80101d83:	89 55 cc             	mov    %edx,-0x34(%ebp)
80101d86:	8b 55 c8             	mov    -0x38(%ebp),%edx
80101d89:	75 0d                	jne    80101d98 <writei+0x188>
80101d8b:	e9 95 00 00 00       	jmp    80101e25 <writei+0x215>
          ptr++;
80101d90:	83 c0 04             	add    $0x4,%eax
        for(int i = 0; i < NINDIRECT; i++)
80101d93:	3b 45 cc             	cmp    -0x34(%ebp),%eax
80101d96:	74 15                	je     80101dad <writei+0x19d>
            if(((*ptr) & 0x00ffffff) == block){
80101d98:	8b 08                	mov    (%eax),%ecx
80101d9a:	81 e1 ff ff ff 00    	and    $0xffffff,%ecx
80101da0:	39 4d d0             	cmp    %ecx,-0x30(%ebp)
80101da3:	75 eb                	jne    80101d90 <writei+0x180>
            *ptr = block + (checksum << 24);
80101da5:	c1 e2 18             	shl    $0x18,%edx
80101da8:	03 55 d0             	add    -0x30(%ebp),%edx
80101dab:	89 10                	mov    %edx,(%eax)
        bwrite(indirect_buf);
80101dad:	83 ec 0c             	sub    $0xc,%esp
80101db0:	53                   	push   %ebx
80101db1:	e8 ea e3 ff ff       	call   801001a0 <bwrite>
        brelse(indirect_buf);
80101db6:	89 1c 24             	mov    %ebx,(%esp)
80101db9:	e8 22 e4 ff ff       	call   801001e0 <brelse>
80101dbe:	83 c4 10             	add    $0x10,%esp
80101dc1:	e9 ba fe ff ff       	jmp    80101c80 <writei+0x70>
        ip->addrs[blockNum] = block + (checksum << 24);
80101dc6:	c1 e2 18             	shl    $0x18,%edx
80101dc9:	03 55 d0             	add    -0x30(%ebp),%edx
80101dcc:	89 54 87 5c          	mov    %edx,0x5c(%edi,%eax,4)
80101dd0:	e9 ab fe ff ff       	jmp    80101c80 <writei+0x70>
  }

  if(n > 0 && off > ip->size){
80101dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd8:	3b 47 58             	cmp    0x58(%edi),%eax
80101ddb:	76 12                	jbe    80101def <writei+0x1df>
    ip->size = off;
80101ddd:	8b 45 e0             	mov    -0x20(%ebp),%eax
    iupdate(ip);
80101de0:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101de3:	89 47 58             	mov    %eax,0x58(%edi)
    iupdate(ip);
80101de6:	57                   	push   %edi
80101de7:	e8 e4 f7 ff ff       	call   801015d0 <iupdate>
80101dec:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80101def:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80101df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101dfa:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101dfe:	66 83 f8 09          	cmp    $0x9,%ax
80101e02:	77 1a                	ja     80101e1e <writei+0x20e>
80101e04:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101e0b:	85 c0                	test   %eax,%eax
80101e0d:	74 0f                	je     80101e1e <writei+0x20e>
    return devsw[ip->major].write(ip, src, n);
80101e0f:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101e12:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e18:	5b                   	pop    %ebx
80101e19:	5e                   	pop    %esi
80101e1a:	5f                   	pop    %edi
80101e1b:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e1c:	ff e0                	jmp    *%eax
      return -1;
80101e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e23:	eb cd                	jmp    80101df2 <writei+0x1e2>
        uint *ptr = (uint*)indirect_buf->data;
80101e25:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101e28:	e9 78 ff ff ff       	jmp    80101da5 <writei+0x195>
80101e2d:	8d 76 00             	lea    0x0(%esi),%esi

80101e30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e36:	6a 0e                	push   $0xe
80101e38:	ff 75 0c             	pushl  0xc(%ebp)
80101e3b:	ff 75 08             	pushl  0x8(%ebp)
80101e3e:	e8 ed 2b 00 00       	call   80104a30 <strncmp>
}
80101e43:	c9                   	leave  
80101e44:	c3                   	ret    
80101e45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 1c             	sub    $0x1c,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e61:	0f 85 85 00 00 00    	jne    80101eec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e67:	8b 53 58             	mov    0x58(%ebx),%edx
80101e6a:	31 ff                	xor    %edi,%edi
80101e6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e6f:	85 d2                	test   %edx,%edx
80101e71:	74 3e                	je     80101eb1 <dirlookup+0x61>
80101e73:	90                   	nop
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e78:	6a 10                	push   $0x10
80101e7a:	57                   	push   %edi
80101e7b:	56                   	push   %esi
80101e7c:	53                   	push   %ebx
80101e7d:	e8 6e fb ff ff       	call   801019f0 <readi>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	83 f8 10             	cmp    $0x10,%eax
80101e88:	75 55                	jne    80101edf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8f:	74 18                	je     80101ea9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e94:	83 ec 04             	sub    $0x4,%esp
80101e97:	6a 0e                	push   $0xe
80101e99:	50                   	push   %eax
80101e9a:	ff 75 0c             	pushl  0xc(%ebp)
80101e9d:	e8 8e 2b 00 00       	call   80104a30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	85 c0                	test   %eax,%eax
80101ea7:	74 17                	je     80101ec0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ea9:	83 c7 10             	add    $0x10,%edi
80101eac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101eaf:	72 c7                	jb     80101e78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101eb4:	31 c0                	xor    %eax,%eax
}
80101eb6:	5b                   	pop    %ebx
80101eb7:	5e                   	pop    %esi
80101eb8:	5f                   	pop    %edi
80101eb9:	5d                   	pop    %ebp
80101eba:	c3                   	ret    
80101ebb:	90                   	nop
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ec0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	74 05                	je     80101ecc <dirlookup+0x7c>
        *poff = off;
80101ec7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ecc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ed0:	8b 03                	mov    (%ebx),%eax
80101ed2:	e8 49 f3 ff ff       	call   80101220 <iget>
}
80101ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eda:	5b                   	pop    %ebx
80101edb:	5e                   	pop    %esi
80101edc:	5f                   	pop    %edi
80101edd:	5d                   	pop    %ebp
80101ede:	c3                   	ret    
      panic("dirlookup read");
80101edf:	83 ec 0c             	sub    $0xc,%esp
80101ee2:	68 9f 75 10 80       	push   $0x8010759f
80101ee7:	e8 a4 e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101eec:	83 ec 0c             	sub    $0xc,%esp
80101eef:	68 8d 75 10 80       	push   $0x8010758d
80101ef4:	e8 97 e4 ff ff       	call   80100390 <panic>
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	89 cf                	mov    %ecx,%edi
80101f08:	89 c3                	mov    %eax,%ebx
80101f0a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f0d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f13:	0f 84 67 01 00 00    	je     80102080 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f19:	e8 82 1b 00 00       	call   80103aa0 <myproc>
  acquire(&icache.lock);
80101f1e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f21:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f24:	68 e0 09 11 80       	push   $0x801109e0
80101f29:	e8 d2 28 00 00       	call   80104800 <acquire>
  ip->ref++;
80101f2e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f32:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101f39:	e8 82 29 00 00       	call   801048c0 <release>
80101f3e:	83 c4 10             	add    $0x10,%esp
80101f41:	eb 08                	jmp    80101f4b <namex+0x4b>
80101f43:	90                   	nop
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	0f b6 03             	movzbl (%ebx),%eax
80101f4e:	3c 2f                	cmp    $0x2f,%al
80101f50:	74 f6                	je     80101f48 <namex+0x48>
  if(*path == 0)
80101f52:	84 c0                	test   %al,%al
80101f54:	0f 84 ee 00 00 00    	je     80102048 <namex+0x148>
  while(*path != '/' && *path != 0)
80101f5a:	0f b6 03             	movzbl (%ebx),%eax
80101f5d:	3c 2f                	cmp    $0x2f,%al
80101f5f:	0f 84 b3 00 00 00    	je     80102018 <namex+0x118>
80101f65:	84 c0                	test   %al,%al
80101f67:	89 da                	mov    %ebx,%edx
80101f69:	75 09                	jne    80101f74 <namex+0x74>
80101f6b:	e9 a8 00 00 00       	jmp    80102018 <namex+0x118>
80101f70:	84 c0                	test   %al,%al
80101f72:	74 0a                	je     80101f7e <namex+0x7e>
    path++;
80101f74:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f77:	0f b6 02             	movzbl (%edx),%eax
80101f7a:	3c 2f                	cmp    $0x2f,%al
80101f7c:	75 f2                	jne    80101f70 <namex+0x70>
80101f7e:	89 d1                	mov    %edx,%ecx
80101f80:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101f82:	83 f9 0d             	cmp    $0xd,%ecx
80101f85:	0f 8e 91 00 00 00    	jle    8010201c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101f8b:	83 ec 04             	sub    $0x4,%esp
80101f8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f91:	6a 0e                	push   $0xe
80101f93:	53                   	push   %ebx
80101f94:	57                   	push   %edi
80101f95:	e8 26 2a 00 00       	call   801049c0 <memmove>
    path++;
80101f9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101f9d:	83 c4 10             	add    $0x10,%esp
    path++;
80101fa0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101fa2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101fa5:	75 11                	jne    80101fb8 <namex+0xb8>
80101fa7:	89 f6                	mov    %esi,%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101fb0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fb3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fb6:	74 f8                	je     80101fb0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fb8:	83 ec 0c             	sub    $0xc,%esp
80101fbb:	56                   	push   %esi
80101fbc:	e8 bf f6 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101fc1:	83 c4 10             	add    $0x10,%esp
80101fc4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fc9:	0f 85 91 00 00 00    	jne    80102060 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fd2:	85 d2                	test   %edx,%edx
80101fd4:	74 09                	je     80101fdf <namex+0xdf>
80101fd6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fd9:	0f 84 b7 00 00 00    	je     80102096 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fdf:	83 ec 04             	sub    $0x4,%esp
80101fe2:	6a 00                	push   $0x0
80101fe4:	57                   	push   %edi
80101fe5:	56                   	push   %esi
80101fe6:	e8 65 fe ff ff       	call   80101e50 <dirlookup>
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	85 c0                	test   %eax,%eax
80101ff0:	74 6e                	je     80102060 <namex+0x160>
  iunlock(ip);
80101ff2:	83 ec 0c             	sub    $0xc,%esp
80101ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ff8:	56                   	push   %esi
80101ff9:	e8 62 f7 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101ffe:	89 34 24             	mov    %esi,(%esp)
80102001:	e8 aa f7 ff ff       	call   801017b0 <iput>
80102006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102009:	83 c4 10             	add    $0x10,%esp
8010200c:	89 c6                	mov    %eax,%esi
8010200e:	e9 38 ff ff ff       	jmp    80101f4b <namex+0x4b>
80102013:	90                   	nop
80102014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102018:	89 da                	mov    %ebx,%edx
8010201a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010201c:	83 ec 04             	sub    $0x4,%esp
8010201f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102022:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102025:	51                   	push   %ecx
80102026:	53                   	push   %ebx
80102027:	57                   	push   %edi
80102028:	e8 93 29 00 00       	call   801049c0 <memmove>
    name[len] = 0;
8010202d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102030:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102033:	83 c4 10             	add    $0x10,%esp
80102036:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010203a:	89 d3                	mov    %edx,%ebx
8010203c:	e9 61 ff ff ff       	jmp    80101fa2 <namex+0xa2>
80102041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102048:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010204b:	85 c0                	test   %eax,%eax
8010204d:	75 5d                	jne    801020ac <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010204f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102052:	89 f0                	mov    %esi,%eax
80102054:	5b                   	pop    %ebx
80102055:	5e                   	pop    %esi
80102056:	5f                   	pop    %edi
80102057:	5d                   	pop    %ebp
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102060:	83 ec 0c             	sub    $0xc,%esp
80102063:	56                   	push   %esi
80102064:	e8 f7 f6 ff ff       	call   80101760 <iunlock>
  iput(ip);
80102069:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010206c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010206e:	e8 3d f7 ff ff       	call   801017b0 <iput>
      return 0;
80102073:	83 c4 10             	add    $0x10,%esp
}
80102076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102079:	89 f0                	mov    %esi,%eax
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
8010207f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102080:	ba 01 00 00 00       	mov    $0x1,%edx
80102085:	b8 01 00 00 00       	mov    $0x1,%eax
8010208a:	e8 91 f1 ff ff       	call   80101220 <iget>
8010208f:	89 c6                	mov    %eax,%esi
80102091:	e9 b5 fe ff ff       	jmp    80101f4b <namex+0x4b>
      iunlock(ip);
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	56                   	push   %esi
8010209a:	e8 c1 f6 ff ff       	call   80101760 <iunlock>
      return ip;
8010209f:	83 c4 10             	add    $0x10,%esp
}
801020a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a5:	89 f0                	mov    %esi,%eax
801020a7:	5b                   	pop    %ebx
801020a8:	5e                   	pop    %esi
801020a9:	5f                   	pop    %edi
801020aa:	5d                   	pop    %ebp
801020ab:	c3                   	ret    
    iput(ip);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	56                   	push   %esi
    return 0;
801020b0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020b2:	e8 f9 f6 ff ff       	call   801017b0 <iput>
    return 0;
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	eb 93                	jmp    8010204f <namex+0x14f>
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <dirlink>:
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 20             	sub    $0x20,%esp
801020c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020cc:	6a 00                	push   $0x0
801020ce:	ff 75 0c             	pushl  0xc(%ebp)
801020d1:	53                   	push   %ebx
801020d2:	e8 79 fd ff ff       	call   80101e50 <dirlookup>
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	85 c0                	test   %eax,%eax
801020dc:	75 67                	jne    80102145 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020de:	8b 7b 58             	mov    0x58(%ebx),%edi
801020e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020e4:	85 ff                	test   %edi,%edi
801020e6:	74 29                	je     80102111 <dirlink+0x51>
801020e8:	31 ff                	xor    %edi,%edi
801020ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020ed:	eb 09                	jmp    801020f8 <dirlink+0x38>
801020ef:	90                   	nop
801020f0:	83 c7 10             	add    $0x10,%edi
801020f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020f6:	73 19                	jae    80102111 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f8:	6a 10                	push   $0x10
801020fa:	57                   	push   %edi
801020fb:	56                   	push   %esi
801020fc:	53                   	push   %ebx
801020fd:	e8 ee f8 ff ff       	call   801019f0 <readi>
80102102:	83 c4 10             	add    $0x10,%esp
80102105:	83 f8 10             	cmp    $0x10,%eax
80102108:	75 4e                	jne    80102158 <dirlink+0x98>
    if(de.inum == 0)
8010210a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010210f:	75 df                	jne    801020f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102111:	8d 45 da             	lea    -0x26(%ebp),%eax
80102114:	83 ec 04             	sub    $0x4,%esp
80102117:	6a 0e                	push   $0xe
80102119:	ff 75 0c             	pushl  0xc(%ebp)
8010211c:	50                   	push   %eax
8010211d:	e8 6e 29 00 00       	call   80104a90 <strncpy>
  de.inum = inum;
80102122:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102125:	6a 10                	push   $0x10
80102127:	57                   	push   %edi
80102128:	56                   	push   %esi
80102129:	53                   	push   %ebx
  de.inum = inum;
8010212a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010212e:	e8 dd fa ff ff       	call   80101c10 <writei>
80102133:	83 c4 20             	add    $0x20,%esp
80102136:	83 f8 10             	cmp    $0x10,%eax
80102139:	75 2a                	jne    80102165 <dirlink+0xa5>
  return 0;
8010213b:	31 c0                	xor    %eax,%eax
}
8010213d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102140:	5b                   	pop    %ebx
80102141:	5e                   	pop    %esi
80102142:	5f                   	pop    %edi
80102143:	5d                   	pop    %ebp
80102144:	c3                   	ret    
    iput(ip);
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	50                   	push   %eax
80102149:	e8 62 f6 ff ff       	call   801017b0 <iput>
    return -1;
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102156:	eb e5                	jmp    8010213d <dirlink+0x7d>
      panic("dirlink read");
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	68 ae 75 10 80       	push   $0x801075ae
80102160:	e8 2b e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 c6 7b 10 80       	push   $0x80107bc6
8010216d:	e8 1e e2 ff ff       	call   80100390 <panic>
80102172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <namei>:

struct inode*
namei(char *path)
{
80102180:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102181:	31 d2                	xor    %edx,%edx
{
80102183:	89 e5                	mov    %esp,%ebp
80102185:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102188:	8b 45 08             	mov    0x8(%ebp),%eax
8010218b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010218e:	e8 6d fd ff ff       	call   80101f00 <namex>
}
80102193:	c9                   	leave  
80102194:	c3                   	ret    
80102195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021a0:	55                   	push   %ebp
  return namex(path, 1, name);
801021a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021af:	e9 4c fd ff ff       	jmp    80101f00 <namex>
801021b4:	66 90                	xchg   %ax,%ax
801021b6:	66 90                	xchg   %ax,%ax
801021b8:	66 90                	xchg   %ax,%ax
801021ba:	66 90                	xchg   %ax,%ax
801021bc:	66 90                	xchg   %ax,%ax
801021be:	66 90                	xchg   %ax,%ax

801021c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	57                   	push   %edi
801021c4:	56                   	push   %esi
801021c5:	53                   	push   %ebx
801021c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021c9:	85 c0                	test   %eax,%eax
801021cb:	0f 84 b4 00 00 00    	je     80102285 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021d1:	8b 58 08             	mov    0x8(%eax),%ebx
801021d4:	89 c6                	mov    %eax,%esi
801021d6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801021dc:	0f 87 96 00 00 00    	ja     80102278 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021e7:	89 f6                	mov    %esi,%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801021f0:	89 ca                	mov    %ecx,%edx
801021f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f3:	83 e0 c0             	and    $0xffffffc0,%eax
801021f6:	3c 40                	cmp    $0x40,%al
801021f8:	75 f6                	jne    801021f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021fa:	31 ff                	xor    %edi,%edi
801021fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102201:	89 f8                	mov    %edi,%eax
80102203:	ee                   	out    %al,(%dx)
80102204:	b8 01 00 00 00       	mov    $0x1,%eax
80102209:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010220e:	ee                   	out    %al,(%dx)
8010220f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102214:	89 d8                	mov    %ebx,%eax
80102216:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102217:	89 d8                	mov    %ebx,%eax
80102219:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010221e:	c1 f8 08             	sar    $0x8,%eax
80102221:	ee                   	out    %al,(%dx)
80102222:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102227:	89 f8                	mov    %edi,%eax
80102229:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010222a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010222e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102233:	c1 e0 04             	shl    $0x4,%eax
80102236:	83 e0 10             	and    $0x10,%eax
80102239:	83 c8 e0             	or     $0xffffffe0,%eax
8010223c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010223d:	f6 06 04             	testb  $0x4,(%esi)
80102240:	75 16                	jne    80102258 <idestart+0x98>
80102242:	b8 20 00 00 00       	mov    $0x20,%eax
80102247:	89 ca                	mov    %ecx,%edx
80102249:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010224a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224d:	5b                   	pop    %ebx
8010224e:	5e                   	pop    %esi
8010224f:	5f                   	pop    %edi
80102250:	5d                   	pop    %ebp
80102251:	c3                   	ret    
80102252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102258:	b8 30 00 00 00       	mov    $0x30,%eax
8010225d:	89 ca                	mov    %ecx,%edx
8010225f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102260:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102265:	83 c6 5c             	add    $0x5c,%esi
80102268:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010226d:	fc                   	cld    
8010226e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
    panic("incorrect blockno");
80102278:	83 ec 0c             	sub    $0xc,%esp
8010227b:	68 18 76 10 80       	push   $0x80107618
80102280:	e8 0b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102285:	83 ec 0c             	sub    $0xc,%esp
80102288:	68 0f 76 10 80       	push   $0x8010760f
8010228d:	e8 fe e0 ff ff       	call   80100390 <panic>
80102292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ideinit>:
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022a6:	68 2a 76 10 80       	push   $0x8010762a
801022ab:	68 80 a5 10 80       	push   $0x8010a580
801022b0:	e8 0b 24 00 00       	call   801046c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022b5:	58                   	pop    %eax
801022b6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801022bb:	5a                   	pop    %edx
801022bc:	83 e8 01             	sub    $0x1,%eax
801022bf:	50                   	push   %eax
801022c0:	6a 0e                	push   $0xe
801022c2:	e8 a9 02 00 00       	call   80102570 <ioapicenable>
801022c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022cf:	90                   	nop
801022d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022d1:	83 e0 c0             	and    $0xffffffc0,%eax
801022d4:	3c 40                	cmp    $0x40,%al
801022d6:	75 f8                	jne    801022d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022e2:	ee                   	out    %al,(%dx)
801022e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ed:	eb 06                	jmp    801022f5 <ideinit+0x55>
801022ef:	90                   	nop
  for(i=0; i<1000; i++){
801022f0:	83 e9 01             	sub    $0x1,%ecx
801022f3:	74 0f                	je     80102304 <ideinit+0x64>
801022f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022f6:	84 c0                	test   %al,%al
801022f8:	74 f6                	je     801022f0 <ideinit+0x50>
      havedisk1 = 1;
801022fa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102301:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102304:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102309:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010230e:	ee                   	out    %al,(%dx)
}
8010230f:	c9                   	leave  
80102310:	c3                   	ret    
80102311:	eb 0d                	jmp    80102320 <ideintr>
80102313:	90                   	nop
80102314:	90                   	nop
80102315:	90                   	nop
80102316:	90                   	nop
80102317:	90                   	nop
80102318:	90                   	nop
80102319:	90                   	nop
8010231a:	90                   	nop
8010231b:	90                   	nop
8010231c:	90                   	nop
8010231d:	90                   	nop
8010231e:	90                   	nop
8010231f:	90                   	nop

80102320 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102329:	68 80 a5 10 80       	push   $0x8010a580
8010232e:	e8 cd 24 00 00       	call   80104800 <acquire>

  if((b = idequeue) == 0){
80102333:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 db                	test   %ebx,%ebx
8010233e:	74 67                	je     801023a7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102340:	8b 43 58             	mov    0x58(%ebx),%eax
80102343:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102348:	8b 3b                	mov    (%ebx),%edi
8010234a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102350:	75 31                	jne    80102383 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102352:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102357:	89 f6                	mov    %esi,%esi
80102359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102360:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102361:	89 c6                	mov    %eax,%esi
80102363:	83 e6 c0             	and    $0xffffffc0,%esi
80102366:	89 f1                	mov    %esi,%ecx
80102368:	80 f9 40             	cmp    $0x40,%cl
8010236b:	75 f3                	jne    80102360 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010236d:	a8 21                	test   $0x21,%al
8010236f:	75 12                	jne    80102383 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102371:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102374:	b9 80 00 00 00       	mov    $0x80,%ecx
80102379:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010237e:	fc                   	cld    
8010237f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102381:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102383:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102386:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102389:	89 f9                	mov    %edi,%ecx
8010238b:	83 c9 02             	or     $0x2,%ecx
8010238e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102390:	53                   	push   %ebx
80102391:	e8 4a 20 00 00       	call   801043e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102396:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010239b:	83 c4 10             	add    $0x10,%esp
8010239e:	85 c0                	test   %eax,%eax
801023a0:	74 05                	je     801023a7 <ideintr+0x87>
    idestart(idequeue);
801023a2:	e8 19 fe ff ff       	call   801021c0 <idestart>
    release(&idelock);
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 80 a5 10 80       	push   $0x8010a580
801023af:	e8 0c 25 00 00       	call   801048c0 <release>

  release(&idelock);
}
801023b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5f                   	pop    %edi
801023ba:	5d                   	pop    %ebp
801023bb:	c3                   	ret    
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	53                   	push   %ebx
801023c4:	83 ec 10             	sub    $0x10,%esp
801023c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801023cd:	50                   	push   %eax
801023ce:	e8 9d 22 00 00       	call   80104670 <holdingsleep>
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	85 c0                	test   %eax,%eax
801023d8:	0f 84 c6 00 00 00    	je     801024a4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	0f 84 ab 00 00 00    	je     80102497 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023ec:	8b 53 04             	mov    0x4(%ebx),%edx
801023ef:	85 d2                	test   %edx,%edx
801023f1:	74 0d                	je     80102400 <iderw+0x40>
801023f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801023f8:	85 c0                	test   %eax,%eax
801023fa:	0f 84 b1 00 00 00    	je     801024b1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102400:	83 ec 0c             	sub    $0xc,%esp
80102403:	68 80 a5 10 80       	push   $0x8010a580
80102408:	e8 f3 23 00 00       	call   80104800 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010240d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102413:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102416:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241d:	85 d2                	test   %edx,%edx
8010241f:	75 09                	jne    8010242a <iderw+0x6a>
80102421:	eb 6d                	jmp    80102490 <iderw+0xd0>
80102423:	90                   	nop
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 c2                	mov    %eax,%edx
8010242a:	8b 42 58             	mov    0x58(%edx),%eax
8010242d:	85 c0                	test   %eax,%eax
8010242f:	75 f7                	jne    80102428 <iderw+0x68>
80102431:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102434:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102436:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010243c:	74 42                	je     80102480 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010243e:	8b 03                	mov    (%ebx),%eax
80102440:	83 e0 06             	and    $0x6,%eax
80102443:	83 f8 02             	cmp    $0x2,%eax
80102446:	74 23                	je     8010246b <iderw+0xab>
80102448:	90                   	nop
80102449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102450:	83 ec 08             	sub    $0x8,%esp
80102453:	68 80 a5 10 80       	push   $0x8010a580
80102458:	53                   	push   %ebx
80102459:	e8 c2 1d 00 00       	call   80104220 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010245e:	8b 03                	mov    (%ebx),%eax
80102460:	83 c4 10             	add    $0x10,%esp
80102463:	83 e0 06             	and    $0x6,%eax
80102466:	83 f8 02             	cmp    $0x2,%eax
80102469:	75 e5                	jne    80102450 <iderw+0x90>
  }


  release(&idelock);
8010246b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102475:	c9                   	leave  
  release(&idelock);
80102476:	e9 45 24 00 00       	jmp    801048c0 <release>
8010247b:	90                   	nop
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102480:	89 d8                	mov    %ebx,%eax
80102482:	e8 39 fd ff ff       	call   801021c0 <idestart>
80102487:	eb b5                	jmp    8010243e <iderw+0x7e>
80102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102490:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102495:	eb 9d                	jmp    80102434 <iderw+0x74>
    panic("iderw: nothing to do");
80102497:	83 ec 0c             	sub    $0xc,%esp
8010249a:	68 44 76 10 80       	push   $0x80107644
8010249f:	e8 ec de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	68 2e 76 10 80       	push   $0x8010762e
801024ac:	e8 df de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801024b1:	83 ec 0c             	sub    $0xc,%esp
801024b4:	68 59 76 10 80       	push   $0x80107659
801024b9:	e8 d2 de ff ff       	call   80100390 <panic>
801024be:	66 90                	xchg   %ax,%ax

801024c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801024c8:	00 c0 fe 
{
801024cb:	89 e5                	mov    %esp,%ebp
801024cd:	56                   	push   %esi
801024ce:	53                   	push   %ebx
  ioapic->reg = reg;
801024cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024d6:	00 00 00 
  return ioapic->data;
801024d9:	a1 34 26 11 80       	mov    0x80112634,%eax
801024de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801024e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801024e7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024ed:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801024f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801024fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102500:	39 c2                	cmp    %eax,%edx
80102502:	74 16                	je     8010251a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102504:	83 ec 0c             	sub    $0xc,%esp
80102507:	68 78 76 10 80       	push   $0x80107678
8010250c:	e8 4f e1 ff ff       	call   80100660 <cprintf>
80102511:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102517:	83 c4 10             	add    $0x10,%esp
8010251a:	83 c3 21             	add    $0x21,%ebx
{
8010251d:	ba 10 00 00 00       	mov    $0x10,%edx
80102522:	b8 20 00 00 00       	mov    $0x20,%eax
80102527:	89 f6                	mov    %esi,%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102530:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102532:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102538:	89 c6                	mov    %eax,%esi
8010253a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102540:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102543:	89 71 10             	mov    %esi,0x10(%ecx)
80102546:	8d 72 01             	lea    0x1(%edx),%esi
80102549:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010254c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010254e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102550:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102556:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010255d:	75 d1                	jne    80102530 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010255f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102562:	5b                   	pop    %ebx
80102563:	5e                   	pop    %esi
80102564:	5d                   	pop    %ebp
80102565:	c3                   	ret    
80102566:	8d 76 00             	lea    0x0(%esi),%esi
80102569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102570 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102570:	55                   	push   %ebp
  ioapic->reg = reg;
80102571:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102577:	89 e5                	mov    %esp,%ebp
80102579:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010257c:	8d 50 20             	lea    0x20(%eax),%edx
8010257f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102583:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102585:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010258b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010258e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102591:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102594:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102596:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010259b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010259e:	89 50 10             	mov    %edx,0x10(%eax)
}
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	66 90                	xchg   %ax,%ax
801025a5:	66 90                	xchg   %ax,%ax
801025a7:	66 90                	xchg   %ax,%ax
801025a9:	66 90                	xchg   %ax,%ax
801025ab:	66 90                	xchg   %ax,%ax
801025ad:	66 90                	xchg   %ax,%ax
801025af:	90                   	nop

801025b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 04             	sub    $0x4,%esp
801025b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025c0:	75 70                	jne    80102632 <kfree+0x82>
801025c2:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
801025c8:	72 68                	jb     80102632 <kfree+0x82>
801025ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025d5:	77 5b                	ja     80102632 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025d7:	83 ec 04             	sub    $0x4,%esp
801025da:	68 00 10 00 00       	push   $0x1000
801025df:	6a 01                	push   $0x1
801025e1:	53                   	push   %ebx
801025e2:	e8 29 23 00 00       	call   80104910 <memset>

  if(kmem.use_lock)
801025e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	85 d2                	test   %edx,%edx
801025f2:	75 2c                	jne    80102620 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801025f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025fb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102600:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102606:	85 c0                	test   %eax,%eax
80102608:	75 06                	jne    80102610 <kfree+0x60>
    release(&kmem.lock);
}
8010260a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010260d:	c9                   	leave  
8010260e:	c3                   	ret    
8010260f:	90                   	nop
    release(&kmem.lock);
80102610:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102617:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010261a:	c9                   	leave  
    release(&kmem.lock);
8010261b:	e9 a0 22 00 00       	jmp    801048c0 <release>
    acquire(&kmem.lock);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	68 40 26 11 80       	push   $0x80112640
80102628:	e8 d3 21 00 00       	call   80104800 <acquire>
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	eb c2                	jmp    801025f4 <kfree+0x44>
    panic("kfree");
80102632:	83 ec 0c             	sub    $0xc,%esp
80102635:	68 aa 76 10 80       	push   $0x801076aa
8010263a:	e8 51 dd ff ff       	call   80100390 <panic>
8010263f:	90                   	nop

80102640 <freerange>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102645:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102648:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010264b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102651:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102657:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265d:	39 de                	cmp    %ebx,%esi
8010265f:	72 23                	jb     80102684 <freerange+0x44>
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102668:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010266e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102671:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102677:	50                   	push   %eax
80102678:	e8 33 ff ff ff       	call   801025b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	39 f3                	cmp    %esi,%ebx
80102682:	76 e4                	jbe    80102668 <freerange+0x28>
}
80102684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102687:	5b                   	pop    %ebx
80102688:	5e                   	pop    %esi
80102689:	5d                   	pop    %ebp
8010268a:	c3                   	ret    
8010268b:	90                   	nop
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 b0 76 10 80       	push   $0x801076b0
801026a0:	68 40 26 11 80       	push   $0x80112640
801026a5:	e8 16 20 00 00       	call   801046c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cc:	39 de                	cmp    %ebx,%esi
801026ce:	72 1c                	jb     801026ec <kinit1+0x5c>
    kfree(p);
801026d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026d6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026df:	50                   	push   %eax
801026e0:	e8 cb fe ff ff       	call   801025b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	39 de                	cmp    %ebx,%esi
801026ea:	73 e4                	jae    801026d0 <kinit1+0x40>
}
801026ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ef:	5b                   	pop    %ebx
801026f0:	5e                   	pop    %esi
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret    
801026f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <kinit2>:
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102705:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102708:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010270b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102711:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102717:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010271d:	39 de                	cmp    %ebx,%esi
8010271f:	72 23                	jb     80102744 <kinit2+0x44>
80102721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102728:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010272e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102731:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102737:	50                   	push   %eax
80102738:	e8 73 fe ff ff       	call   801025b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	39 de                	cmp    %ebx,%esi
80102742:	73 e4                	jae    80102728 <kinit2+0x28>
  kmem.use_lock = 1;
80102744:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010274b:	00 00 00 
}
8010274e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102751:	5b                   	pop    %ebx
80102752:	5e                   	pop    %esi
80102753:	5d                   	pop    %ebp
80102754:	c3                   	ret    
80102755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102760:	a1 74 26 11 80       	mov    0x80112674,%eax
80102765:	85 c0                	test   %eax,%eax
80102767:	75 1f                	jne    80102788 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102769:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010276e:	85 c0                	test   %eax,%eax
80102770:	74 0e                	je     80102780 <kalloc+0x20>
    kmem.freelist = r->next;
80102772:	8b 10                	mov    (%eax),%edx
80102774:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102780:	f3 c3                	repz ret 
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102788:	55                   	push   %ebp
80102789:	89 e5                	mov    %esp,%ebp
8010278b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010278e:	68 40 26 11 80       	push   $0x80112640
80102793:	e8 68 20 00 00       	call   80104800 <acquire>
  r = kmem.freelist;
80102798:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801027a6:	85 c0                	test   %eax,%eax
801027a8:	74 08                	je     801027b2 <kalloc+0x52>
    kmem.freelist = r->next;
801027aa:	8b 08                	mov    (%eax),%ecx
801027ac:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801027b2:	85 d2                	test   %edx,%edx
801027b4:	74 16                	je     801027cc <kalloc+0x6c>
    release(&kmem.lock);
801027b6:	83 ec 0c             	sub    $0xc,%esp
801027b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027bc:	68 40 26 11 80       	push   $0x80112640
801027c1:	e8 fa 20 00 00       	call   801048c0 <release>
  return (char*)r;
801027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027c9:	83 c4 10             	add    $0x10,%esp
}
801027cc:	c9                   	leave  
801027cd:	c3                   	ret    
801027ce:	66 90                	xchg   %ax,%ax

801027d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d0:	ba 64 00 00 00       	mov    $0x64,%edx
801027d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027d6:	a8 01                	test   $0x1,%al
801027d8:	0f 84 c2 00 00 00    	je     801028a0 <kbdgetc+0xd0>
801027de:	ba 60 00 00 00       	mov    $0x60,%edx
801027e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801027e4:	0f b6 d0             	movzbl %al,%edx
801027e7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801027ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801027f3:	0f 84 7f 00 00 00    	je     80102878 <kbdgetc+0xa8>
{
801027f9:	55                   	push   %ebp
801027fa:	89 e5                	mov    %esp,%ebp
801027fc:	53                   	push   %ebx
801027fd:	89 cb                	mov    %ecx,%ebx
801027ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102802:	84 c0                	test   %al,%al
80102804:	78 4a                	js     80102850 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102806:	85 db                	test   %ebx,%ebx
80102808:	74 09                	je     80102813 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010280a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010280d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102810:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102813:	0f b6 82 e0 77 10 80 	movzbl -0x7fef8820(%edx),%eax
8010281a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010281c:	0f b6 82 e0 76 10 80 	movzbl -0x7fef8920(%edx),%eax
80102823:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102825:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102827:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010282d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102830:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102833:	8b 04 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%eax
8010283a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010283e:	74 31                	je     80102871 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102840:	8d 50 9f             	lea    -0x61(%eax),%edx
80102843:	83 fa 19             	cmp    $0x19,%edx
80102846:	77 40                	ja     80102888 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102848:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010284b:	5b                   	pop    %ebx
8010284c:	5d                   	pop    %ebp
8010284d:	c3                   	ret    
8010284e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102850:	83 e0 7f             	and    $0x7f,%eax
80102853:	85 db                	test   %ebx,%ebx
80102855:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102858:	0f b6 82 e0 77 10 80 	movzbl -0x7fef8820(%edx),%eax
8010285f:	83 c8 40             	or     $0x40,%eax
80102862:	0f b6 c0             	movzbl %al,%eax
80102865:	f7 d0                	not    %eax
80102867:	21 c1                	and    %eax,%ecx
    return 0;
80102869:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010286b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102871:	5b                   	pop    %ebx
80102872:	5d                   	pop    %ebp
80102873:	c3                   	ret    
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102878:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010287b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010287d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102883:	c3                   	ret    
80102884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102888:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010288b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010288e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010288f:	83 f9 1a             	cmp    $0x1a,%ecx
80102892:	0f 42 c2             	cmovb  %edx,%eax
}
80102895:	5d                   	pop    %ebp
80102896:	c3                   	ret    
80102897:	89 f6                	mov    %esi,%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801028a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028a5:	c3                   	ret    
801028a6:	8d 76 00             	lea    0x0(%esi),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <kbdintr>:

void
kbdintr(void)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028b6:	68 d0 27 10 80       	push   $0x801027d0
801028bb:	e8 50 df ff ff       	call   80100810 <consoleintr>
}
801028c0:	83 c4 10             	add    $0x10,%esp
801028c3:	c9                   	leave  
801028c4:	c3                   	ret    
801028c5:	66 90                	xchg   %ax,%ax
801028c7:	66 90                	xchg   %ax,%ax
801028c9:	66 90                	xchg   %ax,%ax
801028cb:	66 90                	xchg   %ax,%ax
801028cd:	66 90                	xchg   %ax,%ax
801028cf:	90                   	nop

801028d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801028d5:	55                   	push   %ebp
801028d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801028d8:	85 c0                	test   %eax,%eax
801028da:	0f 84 c8 00 00 00    	je     801029a8 <lapicinit+0xd8>
  lapic[index] = value;
801028e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102901:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102904:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102907:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010290e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102911:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102914:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010291b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010291e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102921:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102928:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010292e:	8b 50 30             	mov    0x30(%eax),%edx
80102931:	c1 ea 10             	shr    $0x10,%edx
80102934:	80 fa 03             	cmp    $0x3,%dl
80102937:	77 77                	ja     801029b0 <lapicinit+0xe0>
  lapic[index] = value;
80102939:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102940:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102943:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102946:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010294d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102950:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102953:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010295a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102960:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102967:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102974:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102977:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102981:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102984:	8b 50 20             	mov    0x20(%eax),%edx
80102987:	89 f6                	mov    %esi,%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102990:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102996:	80 e6 10             	and    $0x10,%dh
80102999:	75 f5                	jne    80102990 <lapicinit+0xc0>
  lapic[index] = value;
8010299b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029a8:	5d                   	pop    %ebp
801029a9:	c3                   	ret    
801029aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801029b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx
801029bd:	e9 77 ff ff ff       	jmp    80102939 <lapicinit+0x69>
801029c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029d0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
801029d6:	55                   	push   %ebp
801029d7:	31 c0                	xor    %eax,%eax
801029d9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801029db:	85 d2                	test   %edx,%edx
801029dd:	74 06                	je     801029e5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801029df:	8b 42 20             	mov    0x20(%edx),%eax
801029e2:	c1 e8 18             	shr    $0x18,%eax
}
801029e5:	5d                   	pop    %ebp
801029e6:	c3                   	ret    
801029e7:	89 f6                	mov    %esi,%esi
801029e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801029f5:	55                   	push   %ebp
801029f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801029f8:	85 c0                	test   %eax,%eax
801029fa:	74 0d                	je     80102a09 <lapiceoi+0x19>
  lapic[index] = value;
801029fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a03:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a06:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a09:	5d                   	pop    %ebp
80102a0a:	c3                   	ret    
80102a0b:	90                   	nop
80102a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a10 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
}
80102a13:	5d                   	pop    %ebp
80102a14:	c3                   	ret    
80102a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a26:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	53                   	push   %ebx
80102a2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a34:	ee                   	out    %al,(%dx)
80102a35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a4d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a50:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102a53:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a5e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aaa:	5b                   	pop    %ebx
80102aab:	5d                   	pop    %ebp
80102aac:	c3                   	ret    
80102aad:	8d 76 00             	lea    0x0(%esi),%esi

80102ab0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ab0:	55                   	push   %ebp
80102ab1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ab6:	ba 70 00 00 00       	mov    $0x70,%edx
80102abb:	89 e5                	mov    %esp,%ebp
80102abd:	57                   	push   %edi
80102abe:	56                   	push   %esi
80102abf:	53                   	push   %ebx
80102ac0:	83 ec 4c             	sub    $0x4c,%esp
80102ac3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ac9:	ec                   	in     (%dx),%al
80102aca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ad2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ad5:	8d 76 00             	lea    0x0(%esi),%esi
80102ad8:	31 c0                	xor    %eax,%eax
80102ada:	89 da                	mov    %ebx,%edx
80102adc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102add:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ae2:	89 ca                	mov    %ecx,%edx
80102ae4:	ec                   	in     (%dx),%al
80102ae5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae8:	89 da                	mov    %ebx,%edx
80102aea:	b8 02 00 00 00       	mov    $0x2,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 da                	mov    %ebx,%edx
80102af8:	b8 04 00 00 00       	mov    $0x4,%eax
80102afd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afe:	89 ca                	mov    %ecx,%edx
80102b00:	ec                   	in     (%dx),%al
80102b01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b04:	89 da                	mov    %ebx,%edx
80102b06:	b8 07 00 00 00       	mov    $0x7,%eax
80102b0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0c:	89 ca                	mov    %ecx,%edx
80102b0e:	ec                   	in     (%dx),%al
80102b0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b12:	89 da                	mov    %ebx,%edx
80102b14:	b8 08 00 00 00       	mov    $0x8,%eax
80102b19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1a:	89 ca                	mov    %ecx,%edx
80102b1c:	ec                   	in     (%dx),%al
80102b1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1f:	89 da                	mov    %ebx,%edx
80102b21:	b8 09 00 00 00       	mov    $0x9,%eax
80102b26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b27:	89 ca                	mov    %ecx,%edx
80102b29:	ec                   	in     (%dx),%al
80102b2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2c:	89 da                	mov    %ebx,%edx
80102b2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b34:	89 ca                	mov    %ecx,%edx
80102b36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b37:	84 c0                	test   %al,%al
80102b39:	78 9d                	js     80102ad8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b3f:	89 fa                	mov    %edi,%edx
80102b41:	0f b6 fa             	movzbl %dl,%edi
80102b44:	89 f2                	mov    %esi,%edx
80102b46:	0f b6 f2             	movzbl %dl,%esi
80102b49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4c:	89 da                	mov    %ebx,%edx
80102b4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b69:	31 c0                	xor    %eax,%eax
80102b6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6c:	89 ca                	mov    %ecx,%edx
80102b6e:	ec                   	in     (%dx),%al
80102b6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b72:	89 da                	mov    %ebx,%edx
80102b74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b77:	b8 02 00 00 00       	mov    $0x2,%eax
80102b7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7d:	89 ca                	mov    %ecx,%edx
80102b7f:	ec                   	in     (%dx),%al
80102b80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b83:	89 da                	mov    %ebx,%edx
80102b85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b88:	b8 04 00 00 00       	mov    $0x4,%eax
80102b8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8e:	89 ca                	mov    %ecx,%edx
80102b90:	ec                   	in     (%dx),%al
80102b91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b94:	89 da                	mov    %ebx,%edx
80102b96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b99:	b8 07 00 00 00       	mov    $0x7,%eax
80102b9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9f:	89 ca                	mov    %ecx,%edx
80102ba1:	ec                   	in     (%dx),%al
80102ba2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba5:	89 da                	mov    %ebx,%edx
80102ba7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102baa:	b8 08 00 00 00       	mov    $0x8,%eax
80102baf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb0:	89 ca                	mov    %ecx,%edx
80102bb2:	ec                   	in     (%dx),%al
80102bb3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb6:	89 da                	mov    %ebx,%edx
80102bb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc1:	89 ca                	mov    %ecx,%edx
80102bc3:	ec                   	in     (%dx),%al
80102bc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bcd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bd0:	6a 18                	push   $0x18
80102bd2:	50                   	push   %eax
80102bd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bd6:	50                   	push   %eax
80102bd7:	e8 84 1d 00 00       	call   80104960 <memcmp>
80102bdc:	83 c4 10             	add    $0x10,%esp
80102bdf:	85 c0                	test   %eax,%eax
80102be1:	0f 85 f1 fe ff ff    	jne    80102ad8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102be7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102beb:	75 78                	jne    80102c65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bed:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bf0:	89 c2                	mov    %eax,%edx
80102bf2:	83 e0 0f             	and    $0xf,%eax
80102bf5:	c1 ea 04             	shr    $0x4,%edx
80102bf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c04:	89 c2                	mov    %eax,%edx
80102c06:	83 e0 0f             	and    $0xf,%eax
80102c09:	c1 ea 04             	shr    $0x4,%edx
80102c0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c18:	89 c2                	mov    %eax,%edx
80102c1a:	83 e0 0f             	and    $0xf,%eax
80102c1d:	c1 ea 04             	shr    $0x4,%edx
80102c20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c2c:	89 c2                	mov    %eax,%edx
80102c2e:	83 e0 0f             	and    $0xf,%eax
80102c31:	c1 ea 04             	shr    $0x4,%edx
80102c34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c40:	89 c2                	mov    %eax,%edx
80102c42:	83 e0 0f             	and    $0xf,%eax
80102c45:	c1 ea 04             	shr    $0x4,%edx
80102c48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c54:	89 c2                	mov    %eax,%edx
80102c56:	83 e0 0f             	and    $0xf,%eax
80102c59:	c1 ea 04             	shr    $0x4,%edx
80102c5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c65:	8b 75 08             	mov    0x8(%ebp),%esi
80102c68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c6b:	89 06                	mov    %eax,(%esi)
80102c6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c70:	89 46 04             	mov    %eax,0x4(%esi)
80102c73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c76:	89 46 08             	mov    %eax,0x8(%esi)
80102c79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c82:	89 46 10             	mov    %eax,0x10(%esi)
80102c85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c95:	5b                   	pop    %ebx
80102c96:	5e                   	pop    %esi
80102c97:	5f                   	pop    %edi
80102c98:	5d                   	pop    %ebp
80102c99:	c3                   	ret    
80102c9a:	66 90                	xchg   %ax,%ax
80102c9c:	66 90                	xchg   %ax,%ax
80102c9e:	66 90                	xchg   %ax,%ax

80102ca0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ca0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ca6:	85 c9                	test   %ecx,%ecx
80102ca8:	0f 8e 8a 00 00 00    	jle    80102d38 <install_trans+0x98>
{
80102cae:	55                   	push   %ebp
80102caf:	89 e5                	mov    %esp,%ebp
80102cb1:	57                   	push   %edi
80102cb2:	56                   	push   %esi
80102cb3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb4:	31 db                	xor    %ebx,%ebx
{
80102cb6:	83 ec 0c             	sub    $0xc,%esp
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	01 d8                	add    %ebx,%eax
80102cca:	83 c0 01             	add    $0x1,%eax
80102ccd:	50                   	push   %eax
80102cce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
80102cd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cdb:	58                   	pop    %eax
80102cdc:	5a                   	pop    %edx
80102cdd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ce4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ced:	e8 de d3 ff ff       	call   801000d0 <bread>
80102cf2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cf4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102cf7:	83 c4 0c             	add    $0xc,%esp
80102cfa:	68 00 02 00 00       	push   $0x200
80102cff:	50                   	push   %eax
80102d00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d03:	50                   	push   %eax
80102d04:	e8 b7 1c 00 00       	call   801049c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d09:	89 34 24             	mov    %esi,(%esp)
80102d0c:	e8 8f d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102d11:	89 3c 24             	mov    %edi,(%esp)
80102d14:	e8 c7 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102d19:	89 34 24             	mov    %esi,(%esp)
80102d1c:	e8 bf d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d21:	83 c4 10             	add    $0x10,%esp
80102d24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102d2a:	7f 94                	jg     80102cc0 <install_trans+0x20>
  }
}
80102d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2f:	5b                   	pop    %ebx
80102d30:	5e                   	pop    %esi
80102d31:	5f                   	pop    %edi
80102d32:	5d                   	pop    %ebp
80102d33:	c3                   	ret    
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d38:	f3 c3                	repz ret 
80102d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	56                   	push   %esi
80102d44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102d45:	83 ec 08             	sub    $0x8,%esp
80102d48:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102d4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d54:	e8 77 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d59:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102d64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102d66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d69:	7e 16                	jle    80102d81 <write_head+0x41>
80102d6b:	c1 e3 02             	shl    $0x2,%ebx
80102d6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102d70:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102d76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102d7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102d7d:	39 da                	cmp    %ebx,%edx
80102d7f:	75 ef                	jne    80102d70 <write_head+0x30>
  }
  bwrite(buf);
80102d81:	83 ec 0c             	sub    $0xc,%esp
80102d84:	56                   	push   %esi
80102d85:	e8 16 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d8a:	89 34 24             	mov    %esi,(%esp)
80102d8d:	e8 4e d4 ff ff       	call   801001e0 <brelse>
}
80102d92:	83 c4 10             	add    $0x10,%esp
80102d95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d98:	5b                   	pop    %ebx
80102d99:	5e                   	pop    %esi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret    
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102da0 <initlog>:
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 2c             	sub    $0x2c,%esp
80102da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102daa:	68 e0 78 10 80       	push   $0x801078e0
80102daf:	68 80 26 11 80       	push   $0x80112680
80102db4:	e8 07 19 00 00       	call   801046c0 <initlock>
  readsb(dev, &sb);
80102db9:	58                   	pop    %eax
80102dba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dbd:	5a                   	pop    %edx
80102dbe:	50                   	push   %eax
80102dbf:	53                   	push   %ebx
80102dc0:	e8 fb e5 ff ff       	call   801013c0 <readsb>
  log.size = sb.nlog;
80102dc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102dcb:	59                   	pop    %ecx
  log.dev = dev;
80102dcc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102dd2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102dd8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102ddd:	5a                   	pop    %edx
80102dde:	50                   	push   %eax
80102ddf:	53                   	push   %ebx
80102de0:	e8 eb d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102de5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102de8:	83 c4 10             	add    $0x10,%esp
80102deb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ded:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102df3:	7e 1c                	jle    80102e11 <initlog+0x71>
80102df5:	c1 e3 02             	shl    $0x2,%ebx
80102df8:	31 d2                	xor    %edx,%edx
80102dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102e00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e04:	83 c2 04             	add    $0x4,%edx
80102e07:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102e0d:	39 d3                	cmp    %edx,%ebx
80102e0f:	75 ef                	jne    80102e00 <initlog+0x60>
  brelse(buf);
80102e11:	83 ec 0c             	sub    $0xc,%esp
80102e14:	50                   	push   %eax
80102e15:	e8 c6 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e1a:	e8 81 fe ff ff       	call   80102ca0 <install_trans>
  log.lh.n = 0;
80102e1f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e26:	00 00 00 
  write_head(); // clear the log
80102e29:	e8 12 ff ff ff       	call   80102d40 <write_head>
}
80102e2e:	83 c4 10             	add    $0x10,%esp
80102e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e34:	c9                   	leave  
80102e35:	c3                   	ret    
80102e36:	8d 76 00             	lea    0x0(%esi),%esi
80102e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e46:	68 80 26 11 80       	push   $0x80112680
80102e4b:	e8 b0 19 00 00       	call   80104800 <acquire>
80102e50:	83 c4 10             	add    $0x10,%esp
80102e53:	eb 18                	jmp    80102e6d <begin_op+0x2d>
80102e55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e58:	83 ec 08             	sub    $0x8,%esp
80102e5b:	68 80 26 11 80       	push   $0x80112680
80102e60:	68 80 26 11 80       	push   $0x80112680
80102e65:	e8 b6 13 00 00       	call   80104220 <sleep>
80102e6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102e72:	85 c0                	test   %eax,%eax
80102e74:	75 e2                	jne    80102e58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102e81:	83 c0 01             	add    $0x1,%eax
80102e84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e8a:	83 fa 1e             	cmp    $0x1e,%edx
80102e8d:	7f c9                	jg     80102e58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102e97:	68 80 26 11 80       	push   $0x80112680
80102e9c:	e8 1f 1a 00 00       	call   801048c0 <release>
      break;
    }
  }
}
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	c9                   	leave  
80102ea5:	c3                   	ret    
80102ea6:	8d 76 00             	lea    0x0(%esi),%esi
80102ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102eb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	57                   	push   %edi
80102eb4:	56                   	push   %esi
80102eb5:	53                   	push   %ebx
80102eb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102eb9:	68 80 26 11 80       	push   $0x80112680
80102ebe:	e8 3d 19 00 00       	call   80104800 <acquire>
  log.outstanding -= 1;
80102ec3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102ec8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102ece:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ed1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102ed4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102ed6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102edc:	0f 85 1a 01 00 00    	jne    80102ffc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102ee2:	85 db                	test   %ebx,%ebx
80102ee4:	0f 85 ee 00 00 00    	jne    80102fd8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102eea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102eed:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102ef4:	00 00 00 
  release(&log.lock);
80102ef7:	68 80 26 11 80       	push   $0x80112680
80102efc:	e8 bf 19 00 00       	call   801048c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f01:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102f07:	83 c4 10             	add    $0x10,%esp
80102f0a:	85 c9                	test   %ecx,%ecx
80102f0c:	0f 8e 85 00 00 00    	jle    80102f97 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f12:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102f17:	83 ec 08             	sub    $0x8,%esp
80102f1a:	01 d8                	add    %ebx,%eax
80102f1c:	83 c0 01             	add    $0x1,%eax
80102f1f:	50                   	push   %eax
80102f20:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102f26:	e8 a5 d1 ff ff       	call   801000d0 <bread>
80102f2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f2d:	58                   	pop    %eax
80102f2e:	5a                   	pop    %edx
80102f2f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102f36:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f3c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f3f:	e8 8c d1 ff ff       	call   801000d0 <bread>
80102f44:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f46:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f49:	83 c4 0c             	add    $0xc,%esp
80102f4c:	68 00 02 00 00       	push   $0x200
80102f51:	50                   	push   %eax
80102f52:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f55:	50                   	push   %eax
80102f56:	e8 65 1a 00 00       	call   801049c0 <memmove>
    bwrite(to);  // write the log
80102f5b:	89 34 24             	mov    %esi,(%esp)
80102f5e:	e8 3d d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102f63:	89 3c 24             	mov    %edi,(%esp)
80102f66:	e8 75 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102f6b:	89 34 24             	mov    %esi,(%esp)
80102f6e:	e8 6d d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f73:	83 c4 10             	add    $0x10,%esp
80102f76:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102f7c:	7c 94                	jl     80102f12 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f7e:	e8 bd fd ff ff       	call   80102d40 <write_head>
    install_trans(); // Now install writes to home locations
80102f83:	e8 18 fd ff ff       	call   80102ca0 <install_trans>
    log.lh.n = 0;
80102f88:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102f8f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f92:	e8 a9 fd ff ff       	call   80102d40 <write_head>
    acquire(&log.lock);
80102f97:	83 ec 0c             	sub    $0xc,%esp
80102f9a:	68 80 26 11 80       	push   $0x80112680
80102f9f:	e8 5c 18 00 00       	call   80104800 <acquire>
    wakeup(&log);
80102fa4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102fab:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102fb2:	00 00 00 
    wakeup(&log);
80102fb5:	e8 26 14 00 00       	call   801043e0 <wakeup>
    release(&log.lock);
80102fba:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102fc1:	e8 fa 18 00 00       	call   801048c0 <release>
80102fc6:	83 c4 10             	add    $0x10,%esp
}
80102fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fcc:	5b                   	pop    %ebx
80102fcd:	5e                   	pop    %esi
80102fce:	5f                   	pop    %edi
80102fcf:	5d                   	pop    %ebp
80102fd0:	c3                   	ret    
80102fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102fd8:	83 ec 0c             	sub    $0xc,%esp
80102fdb:	68 80 26 11 80       	push   $0x80112680
80102fe0:	e8 fb 13 00 00       	call   801043e0 <wakeup>
  release(&log.lock);
80102fe5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102fec:	e8 cf 18 00 00       	call   801048c0 <release>
80102ff1:	83 c4 10             	add    $0x10,%esp
}
80102ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ff7:	5b                   	pop    %ebx
80102ff8:	5e                   	pop    %esi
80102ff9:	5f                   	pop    %edi
80102ffa:	5d                   	pop    %ebp
80102ffb:	c3                   	ret    
    panic("log.committing");
80102ffc:	83 ec 0c             	sub    $0xc,%esp
80102fff:	68 e4 78 10 80       	push   $0x801078e4
80103004:	e8 87 d3 ff ff       	call   80100390 <panic>
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103010 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103017:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
8010301d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103020:	83 fa 1d             	cmp    $0x1d,%edx
80103023:	0f 8f 9d 00 00 00    	jg     801030c6 <log_write+0xb6>
80103029:	a1 b8 26 11 80       	mov    0x801126b8,%eax
8010302e:	83 e8 01             	sub    $0x1,%eax
80103031:	39 c2                	cmp    %eax,%edx
80103033:	0f 8d 8d 00 00 00    	jge    801030c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103039:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010303e:	85 c0                	test   %eax,%eax
80103040:	0f 8e 8d 00 00 00    	jle    801030d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	68 80 26 11 80       	push   $0x80112680
8010304e:	e8 ad 17 00 00       	call   80104800 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103053:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80103059:	83 c4 10             	add    $0x10,%esp
8010305c:	83 f9 00             	cmp    $0x0,%ecx
8010305f:	7e 57                	jle    801030b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103061:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103064:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103066:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
8010306c:	75 0b                	jne    80103079 <log_write+0x69>
8010306e:	eb 38                	jmp    801030a8 <log_write+0x98>
80103070:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80103077:	74 2f                	je     801030a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103079:	83 c0 01             	add    $0x1,%eax
8010307c:	39 c1                	cmp    %eax,%ecx
8010307e:	75 f0                	jne    80103070 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103080:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103087:	83 c0 01             	add    $0x1,%eax
8010308a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
8010308f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103092:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80103099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010309c:	c9                   	leave  
  release(&log.lock);
8010309d:	e9 1e 18 00 00       	jmp    801048c0 <release>
801030a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030a8:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
801030af:	eb de                	jmp    8010308f <log_write+0x7f>
801030b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030b8:	8b 43 08             	mov    0x8(%ebx),%eax
801030bb:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
801030c0:	75 cd                	jne    8010308f <log_write+0x7f>
801030c2:	31 c0                	xor    %eax,%eax
801030c4:	eb c1                	jmp    80103087 <log_write+0x77>
    panic("too big a transaction");
801030c6:	83 ec 0c             	sub    $0xc,%esp
801030c9:	68 f3 78 10 80       	push   $0x801078f3
801030ce:	e8 bd d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801030d3:	83 ec 0c             	sub    $0xc,%esp
801030d6:	68 09 79 10 80       	push   $0x80107909
801030db:	e8 b0 d2 ff ff       	call   80100390 <panic>

801030e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	53                   	push   %ebx
801030e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030e7:	e8 94 09 00 00       	call   80103a80 <cpuid>
801030ec:	89 c3                	mov    %eax,%ebx
801030ee:	e8 8d 09 00 00       	call   80103a80 <cpuid>
801030f3:	83 ec 04             	sub    $0x4,%esp
801030f6:	53                   	push   %ebx
801030f7:	50                   	push   %eax
801030f8:	68 24 79 10 80       	push   $0x80107924
801030fd:	e8 5e d5 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103102:	e8 39 2b 00 00       	call   80105c40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103107:	e8 f4 08 00 00       	call   80103a00 <mycpu>
8010310c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010310e:	b8 01 00 00 00       	mov    $0x1,%eax
80103113:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010311a:	e8 71 0c 00 00       	call   80103d90 <scheduler>
8010311f:	90                   	nop

80103120 <mpenter>:
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103126:	e8 05 3c 00 00       	call   80106d30 <switchkvm>
  seginit();
8010312b:	e8 70 3b 00 00       	call   80106ca0 <seginit>
  lapicinit();
80103130:	e8 9b f7 ff ff       	call   801028d0 <lapicinit>
  mpmain();
80103135:	e8 a6 ff ff ff       	call   801030e0 <mpmain>
8010313a:	66 90                	xchg   %ax,%ax
8010313c:	66 90                	xchg   %ax,%ax
8010313e:	66 90                	xchg   %ax,%ax

80103140 <main>:
{
80103140:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103144:	83 e4 f0             	and    $0xfffffff0,%esp
80103147:	ff 71 fc             	pushl  -0x4(%ecx)
8010314a:	55                   	push   %ebp
8010314b:	89 e5                	mov    %esp,%ebp
8010314d:	53                   	push   %ebx
8010314e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010314f:	83 ec 08             	sub    $0x8,%esp
80103152:	68 00 00 40 80       	push   $0x80400000
80103157:	68 a8 58 11 80       	push   $0x801158a8
8010315c:	e8 2f f5 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103161:	e8 9a 40 00 00       	call   80107200 <kvmalloc>
  mpinit();        // detect other processors
80103166:	e8 75 01 00 00       	call   801032e0 <mpinit>
  lapicinit();     // interrupt controller
8010316b:	e8 60 f7 ff ff       	call   801028d0 <lapicinit>
  seginit();       // segment descriptors
80103170:	e8 2b 3b 00 00       	call   80106ca0 <seginit>
  picinit();       // disable pic
80103175:	e8 46 03 00 00       	call   801034c0 <picinit>
  ioapicinit();    // another interrupt controller
8010317a:	e8 41 f3 ff ff       	call   801024c0 <ioapicinit>
  consoleinit();   // console hardware
8010317f:	e8 3c d8 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103184:	e8 e7 2d 00 00       	call   80105f70 <uartinit>
  pinit();         // process table
80103189:	e8 52 08 00 00       	call   801039e0 <pinit>
  tvinit();        // trap vectors
8010318e:	e8 2d 2a 00 00       	call   80105bc0 <tvinit>
  binit();         // buffer cache
80103193:	e8 a8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103198:	e8 c3 db ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010319d:	e8 fe f0 ff ff       	call   801022a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031a2:	83 c4 0c             	add    $0xc,%esp
801031a5:	68 8a 00 00 00       	push   $0x8a
801031aa:	68 8c a4 10 80       	push   $0x8010a48c
801031af:	68 00 70 00 80       	push   $0x80007000
801031b4:	e8 07 18 00 00       	call   801049c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031b9:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801031c0:	00 00 00 
801031c3:	83 c4 10             	add    $0x10,%esp
801031c6:	05 80 27 11 80       	add    $0x80112780,%eax
801031cb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801031d0:	76 71                	jbe    80103243 <main+0x103>
801031d2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801031d7:	89 f6                	mov    %esi,%esi
801031d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801031e0:	e8 1b 08 00 00       	call   80103a00 <mycpu>
801031e5:	39 d8                	cmp    %ebx,%eax
801031e7:	74 41                	je     8010322a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031e9:	e8 72 f5 ff ff       	call   80102760 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801031f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103120,0x80006ff8
801031fa:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031fd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103204:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103207:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010320c:	0f b6 03             	movzbl (%ebx),%eax
8010320f:	83 ec 08             	sub    $0x8,%esp
80103212:	68 00 70 00 00       	push   $0x7000
80103217:	50                   	push   %eax
80103218:	e8 03 f8 ff ff       	call   80102a20 <lapicstartap>
8010321d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103220:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103226:	85 c0                	test   %eax,%eax
80103228:	74 f6                	je     80103220 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010322a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103231:	00 00 00 
80103234:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010323a:	05 80 27 11 80       	add    $0x80112780,%eax
8010323f:	39 c3                	cmp    %eax,%ebx
80103241:	72 9d                	jb     801031e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103243:	83 ec 08             	sub    $0x8,%esp
80103246:	68 00 00 00 8e       	push   $0x8e000000
8010324b:	68 00 00 40 80       	push   $0x80400000
80103250:	e8 ab f4 ff ff       	call   80102700 <kinit2>
  userinit();      // first user process
80103255:	e8 76 08 00 00       	call   80103ad0 <userinit>
  mpmain();        // finish this processor's setup
8010325a:	e8 81 fe ff ff       	call   801030e0 <mpmain>
8010325f:	90                   	nop

80103260 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103265:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010326b:	53                   	push   %ebx
  e = addr+len;
8010326c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010326f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103272:	39 de                	cmp    %ebx,%esi
80103274:	72 10                	jb     80103286 <mpsearch1+0x26>
80103276:	eb 50                	jmp    801032c8 <mpsearch1+0x68>
80103278:	90                   	nop
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103280:	39 fb                	cmp    %edi,%ebx
80103282:	89 fe                	mov    %edi,%esi
80103284:	76 42                	jbe    801032c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103286:	83 ec 04             	sub    $0x4,%esp
80103289:	8d 7e 10             	lea    0x10(%esi),%edi
8010328c:	6a 04                	push   $0x4
8010328e:	68 38 79 10 80       	push   $0x80107938
80103293:	56                   	push   %esi
80103294:	e8 c7 16 00 00       	call   80104960 <memcmp>
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	85 c0                	test   %eax,%eax
8010329e:	75 e0                	jne    80103280 <mpsearch1+0x20>
801032a0:	89 f1                	mov    %esi,%ecx
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032a8:	0f b6 11             	movzbl (%ecx),%edx
801032ab:	83 c1 01             	add    $0x1,%ecx
801032ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801032b0:	39 f9                	cmp    %edi,%ecx
801032b2:	75 f4                	jne    801032a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032b4:	84 c0                	test   %al,%al
801032b6:	75 c8                	jne    80103280 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032bb:	89 f0                	mov    %esi,%eax
801032bd:	5b                   	pop    %ebx
801032be:	5e                   	pop    %esi
801032bf:	5f                   	pop    %edi
801032c0:	5d                   	pop    %ebp
801032c1:	c3                   	ret    
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032cb:	31 f6                	xor    %esi,%esi
}
801032cd:	89 f0                	mov    %esi,%eax
801032cf:	5b                   	pop    %ebx
801032d0:	5e                   	pop    %esi
801032d1:	5f                   	pop    %edi
801032d2:	5d                   	pop    %ebp
801032d3:	c3                   	ret    
801032d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801032e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032f7:	c1 e0 08             	shl    $0x8,%eax
801032fa:	09 d0                	or     %edx,%eax
801032fc:	c1 e0 04             	shl    $0x4,%eax
801032ff:	85 c0                	test   %eax,%eax
80103301:	75 1b                	jne    8010331e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103303:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010330a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103311:	c1 e0 08             	shl    $0x8,%eax
80103314:	09 d0                	or     %edx,%eax
80103316:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103319:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010331e:	ba 00 04 00 00       	mov    $0x400,%edx
80103323:	e8 38 ff ff ff       	call   80103260 <mpsearch1>
80103328:	85 c0                	test   %eax,%eax
8010332a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010332d:	0f 84 3d 01 00 00    	je     80103470 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103336:	8b 58 04             	mov    0x4(%eax),%ebx
80103339:	85 db                	test   %ebx,%ebx
8010333b:	0f 84 4f 01 00 00    	je     80103490 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103341:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103347:	83 ec 04             	sub    $0x4,%esp
8010334a:	6a 04                	push   $0x4
8010334c:	68 55 79 10 80       	push   $0x80107955
80103351:	56                   	push   %esi
80103352:	e8 09 16 00 00       	call   80104960 <memcmp>
80103357:	83 c4 10             	add    $0x10,%esp
8010335a:	85 c0                	test   %eax,%eax
8010335c:	0f 85 2e 01 00 00    	jne    80103490 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103362:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103369:	3c 01                	cmp    $0x1,%al
8010336b:	0f 95 c2             	setne  %dl
8010336e:	3c 04                	cmp    $0x4,%al
80103370:	0f 95 c0             	setne  %al
80103373:	20 c2                	and    %al,%dl
80103375:	0f 85 15 01 00 00    	jne    80103490 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010337b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103382:	66 85 ff             	test   %di,%di
80103385:	74 1a                	je     801033a1 <mpinit+0xc1>
80103387:	89 f0                	mov    %esi,%eax
80103389:	01 f7                	add    %esi,%edi
  sum = 0;
8010338b:	31 d2                	xor    %edx,%edx
8010338d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103390:	0f b6 08             	movzbl (%eax),%ecx
80103393:	83 c0 01             	add    $0x1,%eax
80103396:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103398:	39 c7                	cmp    %eax,%edi
8010339a:	75 f4                	jne    80103390 <mpinit+0xb0>
8010339c:	84 d2                	test   %dl,%dl
8010339e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801033a1:	85 f6                	test   %esi,%esi
801033a3:	0f 84 e7 00 00 00    	je     80103490 <mpinit+0x1b0>
801033a9:	84 d2                	test   %dl,%dl
801033ab:	0f 85 df 00 00 00    	jne    80103490 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801033b7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801033c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801033c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033ce:	01 d6                	add    %edx,%esi
801033d0:	39 c6                	cmp    %eax,%esi
801033d2:	76 23                	jbe    801033f7 <mpinit+0x117>
    switch(*p){
801033d4:	0f b6 10             	movzbl (%eax),%edx
801033d7:	80 fa 04             	cmp    $0x4,%dl
801033da:	0f 87 ca 00 00 00    	ja     801034aa <mpinit+0x1ca>
801033e0:	ff 24 95 7c 79 10 80 	jmp    *-0x7fef8684(,%edx,4)
801033e7:	89 f6                	mov    %esi,%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033f3:	39 c6                	cmp    %eax,%esi
801033f5:	77 dd                	ja     801033d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033f7:	85 db                	test   %ebx,%ebx
801033f9:	0f 84 9e 00 00 00    	je     8010349d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103402:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103406:	74 15                	je     8010341d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103408:	b8 70 00 00 00       	mov    $0x70,%eax
8010340d:	ba 22 00 00 00       	mov    $0x22,%edx
80103412:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103413:	ba 23 00 00 00       	mov    $0x23,%edx
80103418:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103419:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010341c:	ee                   	out    %al,(%dx)
  }
}
8010341d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103420:	5b                   	pop    %ebx
80103421:	5e                   	pop    %esi
80103422:	5f                   	pop    %edi
80103423:	5d                   	pop    %ebp
80103424:	c3                   	ret    
80103425:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103428:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010342e:	83 f9 07             	cmp    $0x7,%ecx
80103431:	7f 19                	jg     8010344c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103433:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103437:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010343d:	83 c1 01             	add    $0x1,%ecx
80103440:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103446:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010344c:	83 c0 14             	add    $0x14,%eax
      continue;
8010344f:	e9 7c ff ff ff       	jmp    801033d0 <mpinit+0xf0>
80103454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103458:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010345c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010345f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103465:	e9 66 ff ff ff       	jmp    801033d0 <mpinit+0xf0>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103470:	ba 00 00 01 00       	mov    $0x10000,%edx
80103475:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010347a:	e8 e1 fd ff ff       	call   80103260 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010347f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103484:	0f 85 a9 fe ff ff    	jne    80103333 <mpinit+0x53>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	68 3d 79 10 80       	push   $0x8010793d
80103498:	e8 f3 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010349d:	83 ec 0c             	sub    $0xc,%esp
801034a0:	68 5c 79 10 80       	push   $0x8010795c
801034a5:	e8 e6 ce ff ff       	call   80100390 <panic>
      ismp = 0;
801034aa:	31 db                	xor    %ebx,%ebx
801034ac:	e9 26 ff ff ff       	jmp    801033d7 <mpinit+0xf7>
801034b1:	66 90                	xchg   %ax,%ax
801034b3:	66 90                	xchg   %ax,%ax
801034b5:	66 90                	xchg   %ax,%ax
801034b7:	66 90                	xchg   %ax,%ax
801034b9:	66 90                	xchg   %ax,%ax
801034bb:	66 90                	xchg   %ax,%ax
801034bd:	66 90                	xchg   %ax,%ax
801034bf:	90                   	nop

801034c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801034c0:	55                   	push   %ebp
801034c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034c6:	ba 21 00 00 00       	mov    $0x21,%edx
801034cb:	89 e5                	mov    %esp,%ebp
801034cd:	ee                   	out    %al,(%dx)
801034ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801034d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034d4:	5d                   	pop    %ebp
801034d5:	c3                   	ret    
801034d6:	66 90                	xchg   %ax,%ax
801034d8:	66 90                	xchg   %ax,%ax
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
801034e5:	53                   	push   %ebx
801034e6:	83 ec 0c             	sub    $0xc,%esp
801034e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034fb:	e8 80 d8 ff ff       	call   80100d80 <filealloc>
80103500:	85 c0                	test   %eax,%eax
80103502:	89 03                	mov    %eax,(%ebx)
80103504:	74 22                	je     80103528 <pipealloc+0x48>
80103506:	e8 75 d8 ff ff       	call   80100d80 <filealloc>
8010350b:	85 c0                	test   %eax,%eax
8010350d:	89 06                	mov    %eax,(%esi)
8010350f:	74 3f                	je     80103550 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103511:	e8 4a f2 ff ff       	call   80102760 <kalloc>
80103516:	85 c0                	test   %eax,%eax
80103518:	89 c7                	mov    %eax,%edi
8010351a:	75 54                	jne    80103570 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010351c:	8b 03                	mov    (%ebx),%eax
8010351e:	85 c0                	test   %eax,%eax
80103520:	75 34                	jne    80103556 <pipealloc+0x76>
80103522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103528:	8b 06                	mov    (%esi),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	74 0c                	je     8010353a <pipealloc+0x5a>
    fileclose(*f1);
8010352e:	83 ec 0c             	sub    $0xc,%esp
80103531:	50                   	push   %eax
80103532:	e8 09 d9 ff ff       	call   80100e40 <fileclose>
80103537:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010353a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010353d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103542:	5b                   	pop    %ebx
80103543:	5e                   	pop    %esi
80103544:	5f                   	pop    %edi
80103545:	5d                   	pop    %ebp
80103546:	c3                   	ret    
80103547:	89 f6                	mov    %esi,%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	74 e4                	je     8010353a <pipealloc+0x5a>
    fileclose(*f0);
80103556:	83 ec 0c             	sub    $0xc,%esp
80103559:	50                   	push   %eax
8010355a:	e8 e1 d8 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010355f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103561:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103564:	85 c0                	test   %eax,%eax
80103566:	75 c6                	jne    8010352e <pipealloc+0x4e>
80103568:	eb d0                	jmp    8010353a <pipealloc+0x5a>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103570:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103573:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010357a:	00 00 00 
  p->writeopen = 1;
8010357d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103584:	00 00 00 
  p->nwrite = 0;
80103587:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010358e:	00 00 00 
  p->nread = 0;
80103591:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103598:	00 00 00 
  initlock(&p->lock, "pipe");
8010359b:	68 90 79 10 80       	push   $0x80107990
801035a0:	50                   	push   %eax
801035a1:	e8 1a 11 00 00       	call   801046c0 <initlock>
  (*f0)->type = FD_PIPE;
801035a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801035a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035b1:	8b 03                	mov    (%ebx),%eax
801035b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035b7:	8b 03                	mov    (%ebx),%eax
801035b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035bd:	8b 03                	mov    (%ebx),%eax
801035bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035c2:	8b 06                	mov    (%esi),%eax
801035c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035ca:	8b 06                	mov    (%esi),%eax
801035cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035d0:	8b 06                	mov    (%esi),%eax
801035d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035d6:	8b 06                	mov    (%esi),%eax
801035d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801035db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035de:	31 c0                	xor    %eax,%eax
}
801035e0:	5b                   	pop    %ebx
801035e1:	5e                   	pop    %esi
801035e2:	5f                   	pop    %edi
801035e3:	5d                   	pop    %ebp
801035e4:	c3                   	ret    
801035e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	53                   	push   %ebx
801035ff:	e8 fc 11 00 00       	call   80104800 <acquire>
  if(writable){
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	85 f6                	test   %esi,%esi
80103609:	74 45                	je     80103650 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010360b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103611:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103614:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010361b:	00 00 00 
    wakeup(&p->nread);
8010361e:	50                   	push   %eax
8010361f:	e8 bc 0d 00 00       	call   801043e0 <wakeup>
80103624:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103627:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010362d:	85 d2                	test   %edx,%edx
8010362f:	75 0a                	jne    8010363b <pipeclose+0x4b>
80103631:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103637:	85 c0                	test   %eax,%eax
80103639:	74 35                	je     80103670 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010363b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010363e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103641:	5b                   	pop    %ebx
80103642:	5e                   	pop    %esi
80103643:	5d                   	pop    %ebp
    release(&p->lock);
80103644:	e9 77 12 00 00       	jmp    801048c0 <release>
80103649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103650:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103656:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103659:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103660:	00 00 00 
    wakeup(&p->nwrite);
80103663:	50                   	push   %eax
80103664:	e8 77 0d 00 00       	call   801043e0 <wakeup>
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	eb b9                	jmp    80103627 <pipeclose+0x37>
8010366e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	53                   	push   %ebx
80103674:	e8 47 12 00 00       	call   801048c0 <release>
    kfree((char*)p);
80103679:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010367c:	83 c4 10             	add    $0x10,%esp
}
8010367f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103682:	5b                   	pop    %ebx
80103683:	5e                   	pop    %esi
80103684:	5d                   	pop    %ebp
    kfree((char*)p);
80103685:	e9 26 ef ff ff       	jmp    801025b0 <kfree>
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103690 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 28             	sub    $0x28,%esp
80103699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010369c:	53                   	push   %ebx
8010369d:	e8 5e 11 00 00       	call   80104800 <acquire>
  for(i = 0; i < n; i++){
801036a2:	8b 45 10             	mov    0x10(%ebp),%eax
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 c0                	test   %eax,%eax
801036aa:	0f 8e c9 00 00 00    	jle    80103779 <pipewrite+0xe9>
801036b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036c2:	03 4d 10             	add    0x10(%ebp),%ecx
801036c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801036ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801036d4:	39 d0                	cmp    %edx,%eax
801036d6:	75 71                	jne    80103749 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801036d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036de:	85 c0                	test   %eax,%eax
801036e0:	74 4e                	je     80103730 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801036e8:	eb 3a                	jmp    80103724 <pipewrite+0x94>
801036ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	57                   	push   %edi
801036f4:	e8 e7 0c 00 00       	call   801043e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036f9:	5a                   	pop    %edx
801036fa:	59                   	pop    %ecx
801036fb:	53                   	push   %ebx
801036fc:	56                   	push   %esi
801036fd:	e8 1e 0b 00 00       	call   80104220 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103702:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103708:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010370e:	83 c4 10             	add    $0x10,%esp
80103711:	05 00 02 00 00       	add    $0x200,%eax
80103716:	39 c2                	cmp    %eax,%edx
80103718:	75 36                	jne    80103750 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010371a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103720:	85 c0                	test   %eax,%eax
80103722:	74 0c                	je     80103730 <pipewrite+0xa0>
80103724:	e8 77 03 00 00       	call   80103aa0 <myproc>
80103729:	8b 40 24             	mov    0x24(%eax),%eax
8010372c:	85 c0                	test   %eax,%eax
8010372e:	74 c0                	je     801036f0 <pipewrite+0x60>
        release(&p->lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	53                   	push   %ebx
80103734:	e8 87 11 00 00       	call   801048c0 <release>
        return -1;
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103741:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103744:	5b                   	pop    %ebx
80103745:	5e                   	pop    %esi
80103746:	5f                   	pop    %edi
80103747:	5d                   	pop    %ebp
80103748:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103749:	89 c2                	mov    %eax,%edx
8010374b:	90                   	nop
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103750:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103753:	8d 42 01             	lea    0x1(%edx),%eax
80103756:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010375c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103762:	83 c6 01             	add    $0x1,%esi
80103765:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103769:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010376c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010376f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103773:	0f 85 4f ff ff ff    	jne    801036c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103779:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010377f:	83 ec 0c             	sub    $0xc,%esp
80103782:	50                   	push   %eax
80103783:	e8 58 0c 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
80103788:	89 1c 24             	mov    %ebx,(%esp)
8010378b:	e8 30 11 00 00       	call   801048c0 <release>
  return n;
80103790:	83 c4 10             	add    $0x10,%esp
80103793:	8b 45 10             	mov    0x10(%ebp),%eax
80103796:	eb a9                	jmp    80103741 <pipewrite+0xb1>
80103798:	90                   	nop
80103799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	57                   	push   %edi
801037a4:	56                   	push   %esi
801037a5:	53                   	push   %ebx
801037a6:	83 ec 18             	sub    $0x18,%esp
801037a9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037af:	56                   	push   %esi
801037b0:	e8 4b 10 00 00       	call   80104800 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037b5:	83 c4 10             	add    $0x10,%esp
801037b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037c4:	75 6a                	jne    80103830 <piperead+0x90>
801037c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801037cc:	85 db                	test   %ebx,%ebx
801037ce:	0f 84 c4 00 00 00    	je     80103898 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037da:	eb 2d                	jmp    80103809 <piperead+0x69>
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037e0:	83 ec 08             	sub    $0x8,%esp
801037e3:	56                   	push   %esi
801037e4:	53                   	push   %ebx
801037e5:	e8 36 0a 00 00       	call   80104220 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ea:	83 c4 10             	add    $0x10,%esp
801037ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037f9:	75 35                	jne    80103830 <piperead+0x90>
801037fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103801:	85 d2                	test   %edx,%edx
80103803:	0f 84 8f 00 00 00    	je     80103898 <piperead+0xf8>
    if(myproc()->killed){
80103809:	e8 92 02 00 00       	call   80103aa0 <myproc>
8010380e:	8b 48 24             	mov    0x24(%eax),%ecx
80103811:	85 c9                	test   %ecx,%ecx
80103813:	74 cb                	je     801037e0 <piperead+0x40>
      release(&p->lock);
80103815:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103818:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010381d:	56                   	push   %esi
8010381e:	e8 9d 10 00 00       	call   801048c0 <release>
      return -1;
80103823:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103826:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103829:	89 d8                	mov    %ebx,%eax
8010382b:	5b                   	pop    %ebx
8010382c:	5e                   	pop    %esi
8010382d:	5f                   	pop    %edi
8010382e:	5d                   	pop    %ebp
8010382f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103830:	8b 45 10             	mov    0x10(%ebp),%eax
80103833:	85 c0                	test   %eax,%eax
80103835:	7e 61                	jle    80103898 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103837:	31 db                	xor    %ebx,%ebx
80103839:	eb 13                	jmp    8010384e <piperead+0xae>
8010383b:	90                   	nop
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103840:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103846:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010384c:	74 1f                	je     8010386d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010384e:	8d 41 01             	lea    0x1(%ecx),%eax
80103851:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103857:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010385d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103862:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103865:	83 c3 01             	add    $0x1,%ebx
80103868:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386b:	75 d3                	jne    80103840 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010386d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103873:	83 ec 0c             	sub    $0xc,%esp
80103876:	50                   	push   %eax
80103877:	e8 64 0b 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
8010387c:	89 34 24             	mov    %esi,(%esp)
8010387f:	e8 3c 10 00 00       	call   801048c0 <release>
  return i;
80103884:	83 c4 10             	add    $0x10,%esp
}
80103887:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010388a:	89 d8                	mov    %ebx,%eax
8010388c:	5b                   	pop    %ebx
8010388d:	5e                   	pop    %esi
8010388e:	5f                   	pop    %edi
8010388f:	5d                   	pop    %ebp
80103890:	c3                   	ret    
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103898:	31 db                	xor    %ebx,%ebx
8010389a:	eb d1                	jmp    8010386d <piperead+0xcd>
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801038a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ac:	68 20 2d 11 80       	push   $0x80112d20
801038b1:	e8 4a 0f 00 00       	call   80104800 <acquire>
801038b6:	83 c4 10             	add    $0x10,%esp
801038b9:	eb 17                	jmp    801038d2 <allocproc+0x32>
801038bb:	90                   	nop
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801038c6:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801038cc:	0f 83 96 00 00 00    	jae    80103968 <allocproc+0xc8>
    if(p->state == UNUSED)
801038d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038d5:	85 c0                	test   %eax,%eax
801038d7:	75 e7                	jne    801038c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038d9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  //Initialize the proc priority as 1
  p->pri = 1;
  //Initialize the proc ticks
  p->lop_ticks=0;
  p->hip_ticks=0;
  release(&ptable.lock);
801038de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pri = 1;
801038e8:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801038ef:	00 00 00 
  p->lop_ticks=0;
801038f2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801038f9:	00 00 00 
  p->hip_ticks=0;
801038fc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103903:	00 00 00 
  p->pid = nextpid++;
80103906:	8d 50 01             	lea    0x1(%eax),%edx
80103909:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010390c:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103911:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103917:	e8 a4 0f 00 00       	call   801048c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010391c:	e8 3f ee ff ff       	call   80102760 <kalloc>
80103921:	83 c4 10             	add    $0x10,%esp
80103924:	85 c0                	test   %eax,%eax
80103926:	89 43 08             	mov    %eax,0x8(%ebx)
80103929:	74 56                	je     80103981 <allocproc+0xe1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010392b:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103931:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103934:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103939:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010393c:	c7 40 14 af 5b 10 80 	movl   $0x80105baf,0x14(%eax)
  p->context = (struct context*)sp;
80103943:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103946:	6a 14                	push   $0x14
80103948:	6a 00                	push   $0x0
8010394a:	50                   	push   %eax
8010394b:	e8 c0 0f 00 00       	call   80104910 <memset>
  p->context->eip = (uint)forkret;
80103950:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103953:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103956:	c7 40 10 90 39 10 80 	movl   $0x80103990,0x10(%eax)
}
8010395d:	89 d8                	mov    %ebx,%eax
8010395f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103962:	c9                   	leave  
80103963:	c3                   	ret    
80103964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103968:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010396b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010396d:	68 20 2d 11 80       	push   $0x80112d20
80103972:	e8 49 0f 00 00       	call   801048c0 <release>
}
80103977:	89 d8                	mov    %ebx,%eax
  return 0;
80103979:	83 c4 10             	add    $0x10,%esp
}
8010397c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397f:	c9                   	leave  
80103980:	c3                   	ret    
    p->state = UNUSED;
80103981:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103988:	31 db                	xor    %ebx,%ebx
8010398a:	eb d1                	jmp    8010395d <allocproc+0xbd>
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103996:	68 20 2d 11 80       	push   $0x80112d20
8010399b:	e8 20 0f 00 00       	call   801048c0 <release>

  if (first) {
801039a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	85 c0                	test   %eax,%eax
801039aa:	75 04                	jne    801039b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039ac:	c9                   	leave  
801039ad:	c3                   	ret    
801039ae:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801039b0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801039b3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039ba:	00 00 00 
    iinit(ROOTDEV);
801039bd:	6a 01                	push   $0x1
801039bf:	e8 bc da ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801039c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039cb:	e8 d0 f3 ff ff       	call   80102da0 <initlog>
801039d0:	83 c4 10             	add    $0x10,%esp
}
801039d3:	c9                   	leave  
801039d4:	c3                   	ret    
801039d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039e0 <pinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039e6:	68 95 79 10 80       	push   $0x80107995
801039eb:	68 20 2d 11 80       	push   $0x80112d20
801039f0:	e8 cb 0c 00 00       	call   801046c0 <initlock>
}
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	c9                   	leave  
801039f9:	c3                   	ret    
801039fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a00 <mycpu>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a05:	9c                   	pushf  
80103a06:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a07:	f6 c4 02             	test   $0x2,%ah
80103a0a:	75 5e                	jne    80103a6a <mycpu+0x6a>
  apicid = lapicid();
80103a0c:	e8 bf ef ff ff       	call   801029d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a11:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103a17:	85 f6                	test   %esi,%esi
80103a19:	7e 42                	jle    80103a5d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a1b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103a22:	39 d0                	cmp    %edx,%eax
80103a24:	74 30                	je     80103a56 <mycpu+0x56>
80103a26:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a2b:	31 d2                	xor    %edx,%edx
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
80103a30:	83 c2 01             	add    $0x1,%edx
80103a33:	39 f2                	cmp    %esi,%edx
80103a35:	74 26                	je     80103a5d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a37:	0f b6 19             	movzbl (%ecx),%ebx
80103a3a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a40:	39 c3                	cmp    %eax,%ebx
80103a42:	75 ec                	jne    80103a30 <mycpu+0x30>
80103a44:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a4a:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a52:	5b                   	pop    %ebx
80103a53:	5e                   	pop    %esi
80103a54:	5d                   	pop    %ebp
80103a55:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a56:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
80103a5b:	eb f2                	jmp    80103a4f <mycpu+0x4f>
  panic("unknown apicid\n");
80103a5d:	83 ec 0c             	sub    $0xc,%esp
80103a60:	68 9c 79 10 80       	push   $0x8010799c
80103a65:	e8 26 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	68 94 7a 10 80       	push   $0x80107a94
80103a72:	e8 19 c9 ff ff       	call   80100390 <panic>
80103a77:	89 f6                	mov    %esi,%esi
80103a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a80 <cpuid>:
cpuid() {
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a86:	e8 75 ff ff ff       	call   80103a00 <mycpu>
80103a8b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103a90:	c9                   	leave  
  return mycpu()-cpus;
80103a91:	c1 f8 04             	sar    $0x4,%eax
80103a94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a9a:	c3                   	ret    
80103a9b:	90                   	nop
80103a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103aa0 <myproc>:
myproc(void) {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	53                   	push   %ebx
80103aa4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103aa7:	e8 84 0c 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103aac:	e8 4f ff ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103ab1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab7:	e8 b4 0c 00 00       	call   80104770 <popcli>
}
80103abc:	83 c4 04             	add    $0x4,%esp
80103abf:	89 d8                	mov    %ebx,%eax
80103ac1:	5b                   	pop    %ebx
80103ac2:	5d                   	pop    %ebp
80103ac3:	c3                   	ret    
80103ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ad0 <userinit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
80103ad4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ad7:	e8 c4 fd ff ff       	call   801038a0 <allocproc>
80103adc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ade:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103ae3:	e8 98 36 00 00       	call   80107180 <setupkvm>
80103ae8:	85 c0                	test   %eax,%eax
80103aea:	89 43 04             	mov    %eax,0x4(%ebx)
80103aed:	0f 84 db 00 00 00    	je     80103bce <userinit+0xfe>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103af3:	83 ec 04             	sub    $0x4,%esp
80103af6:	68 2c 00 00 00       	push   $0x2c
80103afb:	68 60 a4 10 80       	push   $0x8010a460
80103b00:	50                   	push   %eax
80103b01:	e8 5a 33 00 00       	call   80106e60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b0f:	6a 4c                	push   $0x4c
80103b11:	6a 00                	push   $0x0
80103b13:	ff 73 18             	pushl  0x18(%ebx)
80103b16:	e8 f5 0d 00 00       	call   80104910 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b23:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b28:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b36:	8b 43 18             	mov    0x18(%ebx),%eax
80103b39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b41:	8b 43 18             	mov    0x18(%ebx),%eax
80103b44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b56:	8b 43 18             	mov    0x18(%ebx),%eax
80103b59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b60:	8b 43 18             	mov    0x18(%ebx),%eax
80103b63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b6d:	6a 10                	push   $0x10
80103b6f:	68 c5 79 10 80       	push   $0x801079c5
80103b74:	50                   	push   %eax
80103b75:	e8 76 0f 00 00       	call   80104af0 <safestrcpy>
  p->cwd = namei("/");
80103b7a:	c7 04 24 ce 79 10 80 	movl   $0x801079ce,(%esp)
80103b81:	e8 fa e5 ff ff       	call   80102180 <namei>
80103b86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b90:	e8 6b 0c 00 00       	call   80104800 <acquire>
  p->pri = LOW_PRI;
80103b95:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
80103b9c:	00 00 00 
  p->lop_ticks = 0;
80103b9f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103ba6:	00 00 00 
  p->hip_ticks = 0;
80103ba9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103bb0:	00 00 00 
  p->state = RUNNABLE;
80103bb3:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bc1:	e8 fa 0c 00 00       	call   801048c0 <release>
}
80103bc6:	83 c4 10             	add    $0x10,%esp
80103bc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bcc:	c9                   	leave  
80103bcd:	c3                   	ret    
    panic("userinit: out of memory?");
80103bce:	83 ec 0c             	sub    $0xc,%esp
80103bd1:	68 ac 79 10 80       	push   $0x801079ac
80103bd6:	e8 b5 c7 ff ff       	call   80100390 <panic>
80103bdb:	90                   	nop
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103be0 <growproc>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103be8:	e8 43 0b 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103bed:	e8 0e fe ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103bf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf8:	e8 73 0b 00 00       	call   80104770 <popcli>
  if(n > 0){
80103bfd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c02:	7f 1c                	jg     80103c20 <growproc+0x40>
  } else if(n < 0){
80103c04:	75 3a                	jne    80103c40 <growproc+0x60>
  switchuvm(curproc);
80103c06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c0b:	53                   	push   %ebx
80103c0c:	e8 3f 31 00 00       	call   80106d50 <switchuvm>
  return 0;
80103c11:	83 c4 10             	add    $0x10,%esp
80103c14:	31 c0                	xor    %eax,%eax
}
80103c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c19:	5b                   	pop    %ebx
80103c1a:	5e                   	pop    %esi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	pushl  0x4(%ebx)
80103c2a:	e8 71 33 00 00       	call   80106fa0 <allocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 d0                	jne    80103c06 <growproc+0x26>
      return -1;
80103c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c3b:	eb d9                	jmp    80103c16 <growproc+0x36>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	pushl  0x4(%ebx)
80103c4a:	e8 81 34 00 00       	call   801070d0 <deallocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 b0                	jne    80103c06 <growproc+0x26>
80103c56:	eb de                	jmp    80103c36 <growproc+0x56>
80103c58:	90                   	nop
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c60 <fork>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c69:	e8 c2 0a 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103c6e:	e8 8d fd ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103c73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c79:	e8 f2 0a 00 00       	call   80104770 <popcli>
  if((np = allocproc()) == 0){
80103c7e:	e8 1d fc ff ff       	call   801038a0 <allocproc>
80103c83:	85 c0                	test   %eax,%eax
80103c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c88:	0f 84 d5 00 00 00    	je     80103d63 <fork+0x103>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c8e:	83 ec 08             	sub    $0x8,%esp
80103c91:	ff 33                	pushl  (%ebx)
80103c93:	ff 73 04             	pushl  0x4(%ebx)
80103c96:	89 c7                	mov    %eax,%edi
80103c98:	e8 b3 35 00 00       	call   80107250 <copyuvm>
80103c9d:	83 c4 10             	add    $0x10,%esp
80103ca0:	85 c0                	test   %eax,%eax
80103ca2:	89 47 04             	mov    %eax,0x4(%edi)
80103ca5:	0f 84 bf 00 00 00    	je     80103d6a <fork+0x10a>
  np->sz = curproc->sz;
80103cab:	8b 03                	mov    (%ebx),%eax
80103cad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cb0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103cb2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103cb5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103cb7:	8b 79 18             	mov    0x18(%ecx),%edi
80103cba:	8b 73 18             	mov    0x18(%ebx),%esi
80103cbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cc6:	8b 40 18             	mov    0x18(%eax),%eax
80103cc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103cd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	74 13                	je     80103ceb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	50                   	push   %eax
80103cdc:	e8 0f d1 ff ff       	call   80100df0 <filedup>
80103ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ceb:	83 c6 01             	add    $0x1,%esi
80103cee:	83 fe 10             	cmp    $0x10,%esi
80103cf1:	75 dd                	jne    80103cd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cfc:	e8 4f d9 ff ff       	call   80101650 <idup>
80103d01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	53                   	push   %ebx
80103d10:	50                   	push   %eax
80103d11:	e8 da 0d 00 00       	call   80104af0 <safestrcpy>
  np->lop_ticks = 0;
80103d16:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
80103d1d:	00 00 00 
  np->hip_ticks = 0;
80103d20:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80103d27:	00 00 00 
  pid = np->pid;
80103d2a:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d34:	e8 c7 0a 00 00       	call   80104800 <acquire>
  np->pri = LOW_PRI;
80103d39:	c7 87 88 00 00 00 01 	movl   $0x1,0x88(%edi)
80103d40:	00 00 00 
  np->state = RUNNABLE;
80103d43:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d51:	e8 6a 0b 00 00       	call   801048c0 <release>
  return pid;
80103d56:	83 c4 10             	add    $0x10,%esp
}
80103d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d5c:	89 d8                	mov    %ebx,%eax
80103d5e:	5b                   	pop    %ebx
80103d5f:	5e                   	pop    %esi
80103d60:	5f                   	pop    %edi
80103d61:	5d                   	pop    %ebp
80103d62:	c3                   	ret    
    return -1;
80103d63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d68:	eb ef                	jmp    80103d59 <fork+0xf9>
    kfree(np->kstack);
80103d6a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103d6d:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103d70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103d75:	ff 77 08             	pushl  0x8(%edi)
80103d78:	e8 33 e8 ff ff       	call   801025b0 <kfree>
    np->kstack = 0;
80103d7d:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103d84:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103d8b:	83 c4 10             	add    $0x10,%esp
80103d8e:	eb c9                	jmp    80103d59 <fork+0xf9>

80103d90 <scheduler>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103d99:	e8 62 fc ff ff       	call   80103a00 <mycpu>
  c->proc = 0;
80103d9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103da5:	00 00 00 
  struct cpu *c = mycpu();
80103da8:	89 c3                	mov    %eax,%ebx
80103daa:	8d 40 04             	lea    0x4(%eax),%eax
80103dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103db0:	fb                   	sti    
    acquire(&ptable.lock);
80103db1:	83 ec 0c             	sub    $0xc,%esp
80103db4:	68 20 2d 11 80       	push   $0x80112d20
80103db9:	e8 42 0a 00 00       	call   80104800 <acquire>
80103dbe:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dc6:	eb 18                	jmp    80103de0 <scheduler+0x50>
80103dc8:	90                   	nop
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dd0:	05 8c 00 00 00       	add    $0x8c,%eax
80103dd5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103dda:	0f 83 d8 00 00 00    	jae    80103eb8 <scheduler+0x128>
      if (p->state != RUNNABLE || p->pri < search_pri)
80103de0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103de4:	75 ea                	jne    80103dd0 <scheduler+0x40>
80103de6:	8b b0 88 00 00 00    	mov    0x88(%eax),%esi
      if (p->pri > search_pri && p->pri == HIGH_PRI)
80103dec:	83 fe 02             	cmp    $0x2,%esi
80103def:	75 df                	jne    80103dd0 <scheduler+0x40>
    enum procpri search_pri = LOW_PRI;
80103df1:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
80103df6:	eb 1a                	jmp    80103e12 <scheduler+0x82>
80103df8:	90                   	nop
80103df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e00:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80103e06:	81 ff 54 50 11 80    	cmp    $0x80115054,%edi
80103e0c:	0f 83 8e 00 00 00    	jae    80103ea0 <scheduler+0x110>
      if(p->state != RUNNABLE)
80103e12:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103e16:	75 e8                	jne    80103e00 <scheduler+0x70>
      if (p->pri == search_pri)
80103e18:	39 b7 88 00 00 00    	cmp    %esi,0x88(%edi)
80103e1e:	75 e0                	jne    80103e00 <scheduler+0x70>
        switchuvm(p);
80103e20:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103e23:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
80103e29:	57                   	push   %edi
80103e2a:	e8 21 2f 00 00       	call   80106d50 <switchuvm>
        p->state = RUNNING;
80103e2f:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        p->sched_time = sys_uptime();
80103e36:	e8 b5 1c 00 00       	call   80105af0 <sys_uptime>
80103e3b:	89 47 7c             	mov    %eax,0x7c(%edi)
        swtch(&(c->scheduler), p->context);
80103e3e:	58                   	pop    %eax
80103e3f:	5a                   	pop    %edx
80103e40:	ff 77 1c             	pushl  0x1c(%edi)
80103e43:	ff 75 e4             	pushl  -0x1c(%ebp)
80103e46:	e8 00 0d 00 00       	call   80104b4b <swtch>
        switchkvm();
80103e4b:	e8 e0 2e 00 00       	call   80106d30 <switchkvm>
        tdif = sys_uptime() - p->sched_time;
80103e50:	e8 9b 1c 00 00       	call   80105af0 <sys_uptime>
        switch (p->pri)
80103e55:	8b 8f 88 00 00 00    	mov    0x88(%edi),%ecx
        tdif = sys_uptime() - p->sched_time;
80103e5b:	2b 47 7c             	sub    0x7c(%edi),%eax
        switch (p->pri)
80103e5e:	83 c4 10             	add    $0x10,%esp
80103e61:	83 f9 01             	cmp    $0x1,%ecx
80103e64:	74 72                	je     80103ed8 <scheduler+0x148>
80103e66:	83 f9 02             	cmp    $0x2,%ecx
80103e69:	75 5d                	jne    80103ec8 <scheduler+0x138>
                p->hip_ticks += tdif;
80103e6b:	01 87 84 00 00 00    	add    %eax,0x84(%edi)
        if (p->state != ZOMBIE && p->pri > search_pri)
80103e71:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
80103e75:	74 6d                	je     80103ee4 <scheduler+0x154>
80103e77:	39 f1                	cmp    %esi,%ecx
80103e79:	76 69                	jbe    80103ee4 <scheduler+0x154>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7b:	81 c7 8c 00 00 00    	add    $0x8c,%edi
        c->proc = 0;
80103e81:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103e88:	00 00 00 
80103e8b:	89 ce                	mov    %ecx,%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8d:	81 ff 54 50 11 80    	cmp    $0x80115054,%edi
80103e93:	0f 82 79 ff ff ff    	jb     80103e12 <scheduler+0x82>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 20 2d 11 80       	push   $0x80112d20
80103ea8:	e8 13 0a 00 00       	call   801048c0 <release>
  for(;;){
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	e9 fb fe ff ff       	jmp    80103db0 <scheduler+0x20>
80103eb5:	8d 76 00             	lea    0x0(%esi),%esi
    enum procpri search_pri = LOW_PRI;
80103eb8:	be 01 00 00 00       	mov    $0x1,%esi
80103ebd:	e9 2f ff ff ff       	jmp    80103df1 <scheduler+0x61>
80103ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                panic("priority");
80103ec8:	83 ec 0c             	sub    $0xc,%esp
80103ecb:	68 d0 79 10 80       	push   $0x801079d0
80103ed0:	e8 bb c4 ff ff       	call   80100390 <panic>
80103ed5:	8d 76 00             	lea    0x0(%esi),%esi
                p->lop_ticks += tdif;
80103ed8:	01 87 80 00 00 00    	add    %eax,0x80(%edi)
        if (p->state != ZOMBIE && p->pri > search_pri)
80103ede:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
80103ee2:	75 93                	jne    80103e77 <scheduler+0xe7>
80103ee4:	89 f1                	mov    %esi,%ecx
80103ee6:	eb 93                	jmp    80103e7b <scheduler+0xeb>
80103ee8:	90                   	nop
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <setpri>:
int setpri(int priority){
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
80103ef5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (priority < 1 || priority > 2)
80103ef8:	8d 43 ff             	lea    -0x1(%ebx),%eax
80103efb:	83 f8 01             	cmp    $0x1,%eax
80103efe:	77 48                	ja     80103f48 <setpri+0x58>
  pushcli();
80103f00:	e8 2b 08 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103f05:	e8 f6 fa ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103f0a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f10:	e8 5b 08 00 00       	call   80104770 <popcli>
  acquire(&ptable.lock);
80103f15:	83 ec 0c             	sub    $0xc,%esp
80103f18:	68 20 2d 11 80       	push   $0x80112d20
80103f1d:	e8 de 08 00 00       	call   80104800 <acquire>
  p->pri = priority;
80103f22:	89 9e 88 00 00 00    	mov    %ebx,0x88(%esi)
  release(&ptable.lock);
80103f28:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2f:	e8 8c 09 00 00       	call   801048c0 <release>
  return 1;
80103f34:	83 c4 10             	add    $0x10,%esp
80103f37:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f3f:	5b                   	pop    %ebx
80103f40:	5e                   	pop    %esi
80103f41:	5d                   	pop    %ebp
80103f42:	c3                   	ret    
80103f43:	90                   	nop
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("illegal priority\n");
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	68 d9 79 10 80       	push   $0x801079d9
80103f50:	e8 0b c7 ff ff       	call   80100660 <cprintf>
    return -1;
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f5d:	eb dd                	jmp    80103f3c <setpri+0x4c>
80103f5f:	90                   	nop

80103f60 <getpinfo>:
int getpinfo(struct pstat* ps){
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103f66:	68 20 2d 11 80       	push   $0x80112d20
80103f6b:	e8 90 08 00 00       	call   80104800 <acquire>
80103f70:	8b 55 08             	mov    0x8(%ebp),%edx
80103f73:	83 c4 10             	add    $0x10,%esp
  for ( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f76:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f7b:	eb 2a                	jmp    80103fa7 <getpinfo+0x47>
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
      ps[count].inuse = 0;
80103f80:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    ps[count].pid = p->pid;
80103f86:	8b 48 10             	mov    0x10(%eax),%ecx
  for ( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f89:	05 8c 00 00 00       	add    $0x8c,%eax
80103f8e:	83 c2 10             	add    $0x10,%edx
    ps[count].pid = p->pid;
80103f91:	89 4a f4             	mov    %ecx,-0xc(%edx)
    ps[count].hticks = p->hip_ticks;
80103f94:	8b 48 f8             	mov    -0x8(%eax),%ecx
80103f97:	89 4a f8             	mov    %ecx,-0x8(%edx)
    ps[count].lticks = p->lop_ticks;
80103f9a:	8b 48 f4             	mov    -0xc(%eax),%ecx
80103f9d:	89 4a fc             	mov    %ecx,-0x4(%edx)
  for ( p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa0:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103fa5:	73 19                	jae    80103fc0 <getpinfo+0x60>
    if (p->state ==UNUSED)
80103fa7:	8b 48 0c             	mov    0xc(%eax),%ecx
80103faa:	85 c9                	test   %ecx,%ecx
80103fac:	74 d2                	je     80103f80 <getpinfo+0x20>
      ps[count].inuse = 1;
80103fae:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
80103fb4:	eb d0                	jmp    80103f86 <getpinfo+0x26>
80103fb6:	8d 76 00             	lea    0x0(%esi),%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&ptable.lock);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	68 20 2d 11 80       	push   $0x80112d20
80103fc8:	e8 f3 08 00 00       	call   801048c0 <release>
}
80103fcd:	31 c0                	xor    %eax,%eax
80103fcf:	c9                   	leave  
80103fd0:	c3                   	ret    
80103fd1:	eb 0d                	jmp    80103fe0 <sched>
80103fd3:	90                   	nop
80103fd4:	90                   	nop
80103fd5:	90                   	nop
80103fd6:	90                   	nop
80103fd7:	90                   	nop
80103fd8:	90                   	nop
80103fd9:	90                   	nop
80103fda:	90                   	nop
80103fdb:	90                   	nop
80103fdc:	90                   	nop
80103fdd:	90                   	nop
80103fde:	90                   	nop
80103fdf:	90                   	nop

80103fe0 <sched>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
  pushcli();
80103fe5:	e8 46 07 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103fea:	e8 11 fa ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103fef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff5:	e8 76 07 00 00       	call   80104770 <popcli>
  if(!holding(&ptable.lock))
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 20 2d 11 80       	push   $0x80112d20
80104002:	e8 c9 07 00 00       	call   801047d0 <holding>
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	85 c0                	test   %eax,%eax
8010400c:	74 4f                	je     8010405d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010400e:	e8 ed f9 ff ff       	call   80103a00 <mycpu>
80104013:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010401a:	75 68                	jne    80104084 <sched+0xa4>
  if(p->state == RUNNING)
8010401c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104020:	74 55                	je     80104077 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104022:	9c                   	pushf  
80104023:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104024:	f6 c4 02             	test   $0x2,%ah
80104027:	75 41                	jne    8010406a <sched+0x8a>
  intena = mycpu()->intena;
80104029:	e8 d2 f9 ff ff       	call   80103a00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010402e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104031:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104037:	e8 c4 f9 ff ff       	call   80103a00 <mycpu>
8010403c:	83 ec 08             	sub    $0x8,%esp
8010403f:	ff 70 04             	pushl  0x4(%eax)
80104042:	53                   	push   %ebx
80104043:	e8 03 0b 00 00       	call   80104b4b <swtch>
  mycpu()->intena = intena;
80104048:	e8 b3 f9 ff ff       	call   80103a00 <mycpu>
}
8010404d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104050:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104056:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104059:	5b                   	pop    %ebx
8010405a:	5e                   	pop    %esi
8010405b:	5d                   	pop    %ebp
8010405c:	c3                   	ret    
    panic("sched ptable.lock");
8010405d:	83 ec 0c             	sub    $0xc,%esp
80104060:	68 eb 79 10 80       	push   $0x801079eb
80104065:	e8 26 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010406a:	83 ec 0c             	sub    $0xc,%esp
8010406d:	68 17 7a 10 80       	push   $0x80107a17
80104072:	e8 19 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80104077:	83 ec 0c             	sub    $0xc,%esp
8010407a:	68 09 7a 10 80       	push   $0x80107a09
8010407f:	e8 0c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	68 fd 79 10 80       	push   $0x801079fd
8010408c:	e8 ff c2 ff ff       	call   80100390 <panic>
80104091:	eb 0d                	jmp    801040a0 <exit>
80104093:	90                   	nop
80104094:	90                   	nop
80104095:	90                   	nop
80104096:	90                   	nop
80104097:	90                   	nop
80104098:	90                   	nop
80104099:	90                   	nop
8010409a:	90                   	nop
8010409b:	90                   	nop
8010409c:	90                   	nop
8010409d:	90                   	nop
8010409e:	90                   	nop
8010409f:	90                   	nop

801040a0 <exit>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040a9:	e8 82 06 00 00       	call   80104730 <pushcli>
  c = mycpu();
801040ae:	e8 4d f9 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
801040b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040b9:	e8 b2 06 00 00       	call   80104770 <popcli>
  if(curproc == initproc)
801040be:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
801040c4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040c7:	8d 7e 68             	lea    0x68(%esi),%edi
801040ca:	0f 84 f1 00 00 00    	je     801041c1 <exit+0x121>
    if(curproc->ofile[fd]){
801040d0:	8b 03                	mov    (%ebx),%eax
801040d2:	85 c0                	test   %eax,%eax
801040d4:	74 12                	je     801040e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040d6:	83 ec 0c             	sub    $0xc,%esp
801040d9:	50                   	push   %eax
801040da:	e8 61 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801040df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040e5:	83 c4 10             	add    $0x10,%esp
801040e8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801040eb:	39 fb                	cmp    %edi,%ebx
801040ed:	75 e1                	jne    801040d0 <exit+0x30>
  begin_op();
801040ef:	e8 4c ed ff ff       	call   80102e40 <begin_op>
  iput(curproc->cwd);
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	ff 76 68             	pushl  0x68(%esi)
801040fa:	e8 b1 d6 ff ff       	call   801017b0 <iput>
  end_op();
801040ff:	e8 ac ed ff ff       	call   80102eb0 <end_op>
  curproc->cwd = 0;
80104104:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010410b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104112:	e8 e9 06 00 00       	call   80104800 <acquire>
  wakeup1(curproc->parent);
80104117:	8b 56 14             	mov    0x14(%esi),%edx
8010411a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104122:	eb 10                	jmp    80104134 <exit+0x94>
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104128:	05 8c 00 00 00       	add    $0x8c,%eax
8010412d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104132:	73 1e                	jae    80104152 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104134:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104138:	75 ee                	jne    80104128 <exit+0x88>
8010413a:	3b 50 20             	cmp    0x20(%eax),%edx
8010413d:	75 e9                	jne    80104128 <exit+0x88>
      p->state = RUNNABLE;
8010413f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104146:	05 8c 00 00 00       	add    $0x8c,%eax
8010414b:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104150:	72 e2                	jb     80104134 <exit+0x94>
      p->parent = initproc;
80104152:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104158:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010415d:	eb 0f                	jmp    8010416e <exit+0xce>
8010415f:	90                   	nop
80104160:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80104166:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
8010416c:	73 3a                	jae    801041a8 <exit+0x108>
    if(p->parent == curproc){
8010416e:	39 72 14             	cmp    %esi,0x14(%edx)
80104171:	75 ed                	jne    80104160 <exit+0xc0>
      if(p->state == ZOMBIE)
80104173:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104177:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010417a:	75 e4                	jne    80104160 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104181:	eb 11                	jmp    80104194 <exit+0xf4>
80104183:	90                   	nop
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104188:	05 8c 00 00 00       	add    $0x8c,%eax
8010418d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104192:	73 cc                	jae    80104160 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104194:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104198:	75 ee                	jne    80104188 <exit+0xe8>
8010419a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010419d:	75 e9                	jne    80104188 <exit+0xe8>
      p->state = RUNNABLE;
8010419f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041a6:	eb e0                	jmp    80104188 <exit+0xe8>
  curproc->state = ZOMBIE;
801041a8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801041af:	e8 2c fe ff ff       	call   80103fe0 <sched>
  panic("zombie exit");
801041b4:	83 ec 0c             	sub    $0xc,%esp
801041b7:	68 38 7a 10 80       	push   $0x80107a38
801041bc:	e8 cf c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
801041c1:	83 ec 0c             	sub    $0xc,%esp
801041c4:	68 2b 7a 10 80       	push   $0x80107a2b
801041c9:	e8 c2 c1 ff ff       	call   80100390 <panic>
801041ce:	66 90                	xchg   %ax,%ax

801041d0 <yield>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041d7:	68 20 2d 11 80       	push   $0x80112d20
801041dc:	e8 1f 06 00 00       	call   80104800 <acquire>
  pushcli();
801041e1:	e8 4a 05 00 00       	call   80104730 <pushcli>
  c = mycpu();
801041e6:	e8 15 f8 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
801041eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f1:	e8 7a 05 00 00       	call   80104770 <popcli>
  myproc()->state = RUNNABLE;
801041f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041fd:	e8 de fd ff ff       	call   80103fe0 <sched>
  release(&ptable.lock);
80104202:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104209:	e8 b2 06 00 00       	call   801048c0 <release>
}
8010420e:	83 c4 10             	add    $0x10,%esp
80104211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	8d 76 00             	lea    0x0(%esi),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <sleep>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	8b 7d 08             	mov    0x8(%ebp),%edi
8010422c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010422f:	e8 fc 04 00 00       	call   80104730 <pushcli>
  c = mycpu();
80104234:	e8 c7 f7 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80104239:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010423f:	e8 2c 05 00 00       	call   80104770 <popcli>
  if(p == 0)
80104244:	85 db                	test   %ebx,%ebx
80104246:	0f 84 87 00 00 00    	je     801042d3 <sleep+0xb3>
  if(lk == 0)
8010424c:	85 f6                	test   %esi,%esi
8010424e:	74 76                	je     801042c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104250:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104256:	74 50                	je     801042a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 20 2d 11 80       	push   $0x80112d20
80104260:	e8 9b 05 00 00       	call   80104800 <acquire>
    release(lk);
80104265:	89 34 24             	mov    %esi,(%esp)
80104268:	e8 53 06 00 00       	call   801048c0 <release>
  p->chan = chan;
8010426d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104270:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104277:	e8 64 fd ff ff       	call   80103fe0 <sched>
  p->chan = 0;
8010427c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104283:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010428a:	e8 31 06 00 00       	call   801048c0 <release>
    acquire(lk);
8010428f:	89 75 08             	mov    %esi,0x8(%ebp)
80104292:	83 c4 10             	add    $0x10,%esp
}
80104295:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104298:	5b                   	pop    %ebx
80104299:	5e                   	pop    %esi
8010429a:	5f                   	pop    %edi
8010429b:	5d                   	pop    %ebp
    acquire(lk);
8010429c:	e9 5f 05 00 00       	jmp    80104800 <acquire>
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042b2:	e8 29 fd ff ff       	call   80103fe0 <sched>
  p->chan = 0;
801042b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c1:	5b                   	pop    %ebx
801042c2:	5e                   	pop    %esi
801042c3:	5f                   	pop    %edi
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
    panic("sleep without lk");
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	68 4a 7a 10 80       	push   $0x80107a4a
801042ce:	e8 bd c0 ff ff       	call   80100390 <panic>
    panic("sleep");
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	68 44 7a 10 80       	push   $0x80107a44
801042db:	e8 b0 c0 ff ff       	call   80100390 <panic>

801042e0 <wait>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	56                   	push   %esi
801042e4:	53                   	push   %ebx
  pushcli();
801042e5:	e8 46 04 00 00       	call   80104730 <pushcli>
  c = mycpu();
801042ea:	e8 11 f7 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
801042ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042f5:	e8 76 04 00 00       	call   80104770 <popcli>
  acquire(&ptable.lock);
801042fa:	83 ec 0c             	sub    $0xc,%esp
801042fd:	68 20 2d 11 80       	push   $0x80112d20
80104302:	e8 f9 04 00 00       	call   80104800 <acquire>
80104307:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010430a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010430c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104311:	eb 13                	jmp    80104326 <wait+0x46>
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010431e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104324:	73 1e                	jae    80104344 <wait+0x64>
      if(p->parent != curproc)
80104326:	39 73 14             	cmp    %esi,0x14(%ebx)
80104329:	75 ed                	jne    80104318 <wait+0x38>
      if(p->state == ZOMBIE){
8010432b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010432f:	74 37                	je     80104368 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104331:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80104337:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010433c:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104342:	72 e2                	jb     80104326 <wait+0x46>
    if(!havekids || curproc->killed){
80104344:	85 c0                	test   %eax,%eax
80104346:	74 76                	je     801043be <wait+0xde>
80104348:	8b 46 24             	mov    0x24(%esi),%eax
8010434b:	85 c0                	test   %eax,%eax
8010434d:	75 6f                	jne    801043be <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010434f:	83 ec 08             	sub    $0x8,%esp
80104352:	68 20 2d 11 80       	push   $0x80112d20
80104357:	56                   	push   %esi
80104358:	e8 c3 fe ff ff       	call   80104220 <sleep>
    havekids = 0;
8010435d:	83 c4 10             	add    $0x10,%esp
80104360:	eb a8                	jmp    8010430a <wait+0x2a>
80104362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010436e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104371:	e8 3a e2 ff ff       	call   801025b0 <kfree>
        freevm(p->pgdir);
80104376:	5a                   	pop    %edx
80104377:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010437a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104381:	e8 7a 2d 00 00       	call   80107100 <freevm>
        release(&ptable.lock);
80104386:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010438d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104394:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010439b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010439f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043a6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801043ad:	e8 0e 05 00 00       	call   801048c0 <release>
        return pid;
801043b2:	83 c4 10             	add    $0x10,%esp
}
801043b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b8:	89 f0                	mov    %esi,%eax
801043ba:	5b                   	pop    %ebx
801043bb:	5e                   	pop    %esi
801043bc:	5d                   	pop    %ebp
801043bd:	c3                   	ret    
      release(&ptable.lock);
801043be:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801043c1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801043c6:	68 20 2d 11 80       	push   $0x80112d20
801043cb:	e8 f0 04 00 00       	call   801048c0 <release>
      return -1;
801043d0:	83 c4 10             	add    $0x10,%esp
801043d3:	eb e0                	jmp    801043b5 <wait+0xd5>
801043d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 10             	sub    $0x10,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ea:	68 20 2d 11 80       	push   $0x80112d20
801043ef:	e8 0c 04 00 00       	call   80104800 <acquire>
801043f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043fc:	eb 0e                	jmp    8010440c <wakeup+0x2c>
801043fe:	66 90                	xchg   %ax,%ax
80104400:	05 8c 00 00 00       	add    $0x8c,%eax
80104405:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010440a:	73 1e                	jae    8010442a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010440c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104410:	75 ee                	jne    80104400 <wakeup+0x20>
80104412:	3b 58 20             	cmp    0x20(%eax),%ebx
80104415:	75 e9                	jne    80104400 <wakeup+0x20>
      p->state = RUNNABLE;
80104417:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441e:	05 8c 00 00 00       	add    $0x8c,%eax
80104423:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104428:	72 e2                	jb     8010440c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010442a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104431:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104434:	c9                   	leave  
  release(&ptable.lock);
80104435:	e9 86 04 00 00       	jmp    801048c0 <release>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010444a:	68 20 2d 11 80       	push   $0x80112d20
8010444f:	e8 ac 03 00 00       	call   80104800 <acquire>
80104454:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104457:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010445c:	eb 0e                	jmp    8010446c <kill+0x2c>
8010445e:	66 90                	xchg   %ax,%ax
80104460:	05 8c 00 00 00       	add    $0x8c,%eax
80104465:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010446a:	73 34                	jae    801044a0 <kill+0x60>
    if(p->pid == pid){
8010446c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010446f:	75 ef                	jne    80104460 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104471:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104475:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010447c:	75 07                	jne    80104485 <kill+0x45>
        p->state = RUNNABLE;
8010447e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104485:	83 ec 0c             	sub    $0xc,%esp
80104488:	68 20 2d 11 80       	push   $0x80112d20
8010448d:	e8 2e 04 00 00       	call   801048c0 <release>
      return 0;
80104492:	83 c4 10             	add    $0x10,%esp
80104495:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010449a:	c9                   	leave  
8010449b:	c3                   	ret    
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	68 20 2d 11 80       	push   $0x80112d20
801044a8:	e8 13 04 00 00       	call   801048c0 <release>
  return -1;
801044ad:	83 c4 10             	add    $0x10,%esp
801044b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	56                   	push   %esi
801044c5:	53                   	push   %ebx
801044c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801044ce:	83 ec 3c             	sub    $0x3c,%esp
801044d1:	eb 27                	jmp    801044fa <procdump+0x3a>
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044d8:	83 ec 0c             	sub    $0xc,%esp
801044db:	68 df 7d 10 80       	push   $0x80107ddf
801044e0:	e8 7b c1 ff ff       	call   80100660 <cprintf>
801044e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801044ee:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801044f4:	0f 83 86 00 00 00    	jae    80104580 <procdump+0xc0>
    if(p->state == UNUSED)
801044fa:	8b 43 0c             	mov    0xc(%ebx),%eax
801044fd:	85 c0                	test   %eax,%eax
801044ff:	74 e7                	je     801044e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104501:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104504:	ba 5b 7a 10 80       	mov    $0x80107a5b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104509:	77 11                	ja     8010451c <procdump+0x5c>
8010450b:	8b 14 85 bc 7a 10 80 	mov    -0x7fef8544(,%eax,4),%edx
      state = "???";
80104512:	b8 5b 7a 10 80       	mov    $0x80107a5b,%eax
80104517:	85 d2                	test   %edx,%edx
80104519:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010451c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010451f:	50                   	push   %eax
80104520:	52                   	push   %edx
80104521:	ff 73 10             	pushl  0x10(%ebx)
80104524:	68 5f 7a 10 80       	push   $0x80107a5f
80104529:	e8 32 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010452e:	83 c4 10             	add    $0x10,%esp
80104531:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104535:	75 a1                	jne    801044d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104537:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010453a:	83 ec 08             	sub    $0x8,%esp
8010453d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104540:	50                   	push   %eax
80104541:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104544:	8b 40 0c             	mov    0xc(%eax),%eax
80104547:	83 c0 08             	add    $0x8,%eax
8010454a:	50                   	push   %eax
8010454b:	e8 90 01 00 00       	call   801046e0 <getcallerpcs>
80104550:	83 c4 10             	add    $0x10,%esp
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104558:	8b 17                	mov    (%edi),%edx
8010455a:	85 d2                	test   %edx,%edx
8010455c:	0f 84 76 ff ff ff    	je     801044d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104562:	83 ec 08             	sub    $0x8,%esp
80104565:	83 c7 04             	add    $0x4,%edi
80104568:	52                   	push   %edx
80104569:	68 61 74 10 80       	push   $0x80107461
8010456e:	e8 ed c0 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104573:	83 c4 10             	add    $0x10,%esp
80104576:	39 fe                	cmp    %edi,%esi
80104578:	75 de                	jne    80104558 <procdump+0x98>
8010457a:	e9 59 ff ff ff       	jmp    801044d8 <procdump+0x18>
8010457f:	90                   	nop
  }
}
80104580:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104583:	5b                   	pop    %ebx
80104584:	5e                   	pop    %esi
80104585:	5f                   	pop    %edi
80104586:	5d                   	pop    %ebp
80104587:	c3                   	ret    
80104588:	66 90                	xchg   %ax,%ax
8010458a:	66 90                	xchg   %ax,%ax
8010458c:	66 90                	xchg   %ax,%ax
8010458e:	66 90                	xchg   %ax,%ax

80104590 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010459a:	68 d4 7a 10 80       	push   $0x80107ad4
8010459f:	8d 43 04             	lea    0x4(%ebx),%eax
801045a2:	50                   	push   %eax
801045a3:	e8 18 01 00 00       	call   801046c0 <initlock>
  lk->name = name;
801045a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c1:	c9                   	leave  
801045c2:	c3                   	ret    
801045c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	8d 73 04             	lea    0x4(%ebx),%esi
801045de:	56                   	push   %esi
801045df:	e8 1c 02 00 00       	call   80104800 <acquire>
  while (lk->locked) {
801045e4:	8b 13                	mov    (%ebx),%edx
801045e6:	83 c4 10             	add    $0x10,%esp
801045e9:	85 d2                	test   %edx,%edx
801045eb:	74 16                	je     80104603 <acquiresleep+0x33>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045f0:	83 ec 08             	sub    $0x8,%esp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	e8 26 fc ff ff       	call   80104220 <sleep>
  while (lk->locked) {
801045fa:	8b 03                	mov    (%ebx),%eax
801045fc:	83 c4 10             	add    $0x10,%esp
801045ff:	85 c0                	test   %eax,%eax
80104601:	75 ed                	jne    801045f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104603:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104609:	e8 92 f4 ff ff       	call   80103aa0 <myproc>
8010460e:	8b 40 10             	mov    0x10(%eax),%eax
80104611:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104614:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104617:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010461a:	5b                   	pop    %ebx
8010461b:	5e                   	pop    %esi
8010461c:	5d                   	pop    %ebp
  release(&lk->lk);
8010461d:	e9 9e 02 00 00       	jmp    801048c0 <release>
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d 73 04             	lea    0x4(%ebx),%esi
8010463e:	56                   	push   %esi
8010463f:	e8 bc 01 00 00       	call   80104800 <acquire>
  lk->locked = 0;
80104644:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010464a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104651:	89 1c 24             	mov    %ebx,(%esp)
80104654:	e8 87 fd ff ff       	call   801043e0 <wakeup>
  release(&lk->lk);
80104659:	89 75 08             	mov    %esi,0x8(%ebp)
8010465c:	83 c4 10             	add    $0x10,%esp
}
8010465f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104662:	5b                   	pop    %ebx
80104663:	5e                   	pop    %esi
80104664:	5d                   	pop    %ebp
  release(&lk->lk);
80104665:	e9 56 02 00 00       	jmp    801048c0 <release>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	56                   	push   %esi
80104675:	53                   	push   %ebx
80104676:	31 ff                	xor    %edi,%edi
80104678:	83 ec 18             	sub    $0x18,%esp
8010467b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010467e:	8d 73 04             	lea    0x4(%ebx),%esi
80104681:	56                   	push   %esi
80104682:	e8 79 01 00 00       	call   80104800 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104687:	8b 03                	mov    (%ebx),%eax
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	85 c0                	test   %eax,%eax
8010468e:	74 13                	je     801046a3 <holdingsleep+0x33>
80104690:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104693:	e8 08 f4 ff ff       	call   80103aa0 <myproc>
80104698:	39 58 10             	cmp    %ebx,0x10(%eax)
8010469b:	0f 94 c0             	sete   %al
8010469e:	0f b6 c0             	movzbl %al,%eax
801046a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801046a3:	83 ec 0c             	sub    $0xc,%esp
801046a6:	56                   	push   %esi
801046a7:	e8 14 02 00 00       	call   801048c0 <release>
  return r;
}
801046ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046af:	89 f8                	mov    %edi,%eax
801046b1:	5b                   	pop    %ebx
801046b2:	5e                   	pop    %esi
801046b3:	5f                   	pop    %edi
801046b4:	5d                   	pop    %ebp
801046b5:	c3                   	ret    
801046b6:	66 90                	xchg   %ax,%ax
801046b8:	66 90                	xchg   %ax,%ax
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046e1:	31 d2                	xor    %edx,%edx
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ec:	83 e8 08             	sub    $0x8,%eax
801046ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046fc:	77 1a                	ja     80104718 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104701:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104704:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104707:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104709:	83 fa 0a             	cmp    $0xa,%edx
8010470c:	75 e2                	jne    801046f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010470e:	5b                   	pop    %ebx
8010470f:	5d                   	pop    %ebp
80104710:	c3                   	ret    
80104711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104718:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010471b:	83 c1 28             	add    $0x28,%ecx
8010471e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104726:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104729:	39 c1                	cmp    %eax,%ecx
8010472b:	75 f3                	jne    80104720 <getcallerpcs+0x40>
}
8010472d:	5b                   	pop    %ebx
8010472e:	5d                   	pop    %ebp
8010472f:	c3                   	ret    

80104730 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	9c                   	pushf  
80104738:	5b                   	pop    %ebx
  asm volatile("cli");
80104739:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010473a:	e8 c1 f2 ff ff       	call   80103a00 <mycpu>
8010473f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104745:	85 c0                	test   %eax,%eax
80104747:	75 11                	jne    8010475a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104749:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010474f:	e8 ac f2 ff ff       	call   80103a00 <mycpu>
80104754:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010475a:	e8 a1 f2 ff ff       	call   80103a00 <mycpu>
8010475f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104766:	83 c4 04             	add    $0x4,%esp
80104769:	5b                   	pop    %ebx
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <popcli>:

void
popcli(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104776:	9c                   	pushf  
80104777:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104778:	f6 c4 02             	test   $0x2,%ah
8010477b:	75 35                	jne    801047b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010477d:	e8 7e f2 ff ff       	call   80103a00 <mycpu>
80104782:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104789:	78 34                	js     801047bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010478b:	e8 70 f2 ff ff       	call   80103a00 <mycpu>
80104790:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104796:	85 d2                	test   %edx,%edx
80104798:	74 06                	je     801047a0 <popcli+0x30>
    sti();
}
8010479a:	c9                   	leave  
8010479b:	c3                   	ret    
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047a0:	e8 5b f2 ff ff       	call   80103a00 <mycpu>
801047a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	74 eb                	je     8010479a <popcli+0x2a>
  asm volatile("sti");
801047af:	fb                   	sti    
}
801047b0:	c9                   	leave  
801047b1:	c3                   	ret    
    panic("popcli - interruptible");
801047b2:	83 ec 0c             	sub    $0xc,%esp
801047b5:	68 df 7a 10 80       	push   $0x80107adf
801047ba:	e8 d1 bb ff ff       	call   80100390 <panic>
    panic("popcli");
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	68 f6 7a 10 80       	push   $0x80107af6
801047c7:	e8 c4 bb ff ff       	call   80100390 <panic>
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <holding>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 75 08             	mov    0x8(%ebp),%esi
801047d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047da:	e8 51 ff ff ff       	call   80104730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047df:	8b 06                	mov    (%esi),%eax
801047e1:	85 c0                	test   %eax,%eax
801047e3:	74 10                	je     801047f5 <holding+0x25>
801047e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801047e8:	e8 13 f2 ff ff       	call   80103a00 <mycpu>
801047ed:	39 c3                	cmp    %eax,%ebx
801047ef:	0f 94 c3             	sete   %bl
801047f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801047f5:	e8 76 ff ff ff       	call   80104770 <popcli>
}
801047fa:	89 d8                	mov    %ebx,%eax
801047fc:	5b                   	pop    %ebx
801047fd:	5e                   	pop    %esi
801047fe:	5d                   	pop    %ebp
801047ff:	c3                   	ret    

80104800 <acquire>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104805:	e8 26 ff ff ff       	call   80104730 <pushcli>
  if(holding(lk))
8010480a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010480d:	83 ec 0c             	sub    $0xc,%esp
80104810:	53                   	push   %ebx
80104811:	e8 ba ff ff ff       	call   801047d0 <holding>
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 c0                	test   %eax,%eax
8010481b:	0f 85 83 00 00 00    	jne    801048a4 <acquire+0xa4>
80104821:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104823:	ba 01 00 00 00       	mov    $0x1,%edx
80104828:	eb 09                	jmp    80104833 <acquire+0x33>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104830:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104833:	89 d0                	mov    %edx,%eax
80104835:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104838:	85 c0                	test   %eax,%eax
8010483a:	75 f4                	jne    80104830 <acquire+0x30>
  __sync_synchronize();
8010483c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104841:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104844:	e8 b7 f1 ff ff       	call   80103a00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104849:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010484c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010484f:	89 e8                	mov    %ebp,%eax
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104858:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010485e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104864:	77 1a                	ja     80104880 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104866:	8b 48 04             	mov    0x4(%eax),%ecx
80104869:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010486c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010486f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104871:	83 fe 0a             	cmp    $0xa,%esi
80104874:	75 e2                	jne    80104858 <acquire+0x58>
}
80104876:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104879:	5b                   	pop    %ebx
8010487a:	5e                   	pop    %esi
8010487b:	5d                   	pop    %ebp
8010487c:	c3                   	ret    
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
80104880:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104883:	83 c2 28             	add    $0x28,%edx
80104886:	8d 76 00             	lea    0x0(%esi),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104896:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104899:	39 d0                	cmp    %edx,%eax
8010489b:	75 f3                	jne    80104890 <acquire+0x90>
}
8010489d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a0:	5b                   	pop    %ebx
801048a1:	5e                   	pop    %esi
801048a2:	5d                   	pop    %ebp
801048a3:	c3                   	ret    
    panic("acquire");
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	68 fd 7a 10 80       	push   $0x80107afd
801048ac:	e8 df ba ff ff       	call   80100390 <panic>
801048b1:	eb 0d                	jmp    801048c0 <release>
801048b3:	90                   	nop
801048b4:	90                   	nop
801048b5:	90                   	nop
801048b6:	90                   	nop
801048b7:	90                   	nop
801048b8:	90                   	nop
801048b9:	90                   	nop
801048ba:	90                   	nop
801048bb:	90                   	nop
801048bc:	90                   	nop
801048bd:	90                   	nop
801048be:	90                   	nop
801048bf:	90                   	nop

801048c0 <release>:
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 10             	sub    $0x10,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801048ca:	53                   	push   %ebx
801048cb:	e8 00 ff ff ff       	call   801047d0 <holding>
801048d0:	83 c4 10             	add    $0x10,%esp
801048d3:	85 c0                	test   %eax,%eax
801048d5:	74 22                	je     801048f9 <release+0x39>
  lk->pcs[0] = 0;
801048d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f3:	c9                   	leave  
  popcli();
801048f4:	e9 77 fe ff ff       	jmp    80104770 <popcli>
    panic("release");
801048f9:	83 ec 0c             	sub    $0xc,%esp
801048fc:	68 05 7b 10 80       	push   $0x80107b05
80104901:	e8 8a ba ff ff       	call   80100390 <panic>
80104906:	66 90                	xchg   %ax,%ax
80104908:	66 90                	xchg   %ax,%ax
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	53                   	push   %ebx
80104915:	8b 55 08             	mov    0x8(%ebp),%edx
80104918:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010491b:	f6 c2 03             	test   $0x3,%dl
8010491e:	75 05                	jne    80104925 <memset+0x15>
80104920:	f6 c1 03             	test   $0x3,%cl
80104923:	74 13                	je     80104938 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104925:	89 d7                	mov    %edx,%edi
80104927:	8b 45 0c             	mov    0xc(%ebp),%eax
8010492a:	fc                   	cld    
8010492b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010492d:	5b                   	pop    %ebx
8010492e:	89 d0                	mov    %edx,%eax
80104930:	5f                   	pop    %edi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104938:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010493c:	c1 e9 02             	shr    $0x2,%ecx
8010493f:	89 f8                	mov    %edi,%eax
80104941:	89 fb                	mov    %edi,%ebx
80104943:	c1 e0 18             	shl    $0x18,%eax
80104946:	c1 e3 10             	shl    $0x10,%ebx
80104949:	09 d8                	or     %ebx,%eax
8010494b:	09 f8                	or     %edi,%eax
8010494d:	c1 e7 08             	shl    $0x8,%edi
80104950:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104952:	89 d7                	mov    %edx,%edi
80104954:	fc                   	cld    
80104955:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104957:	5b                   	pop    %ebx
80104958:	89 d0                	mov    %edx,%eax
8010495a:	5f                   	pop    %edi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret    
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
80104966:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104969:	8b 75 08             	mov    0x8(%ebp),%esi
8010496c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010496f:	85 db                	test   %ebx,%ebx
80104971:	74 29                	je     8010499c <memcmp+0x3c>
    if(*s1 != *s2)
80104973:	0f b6 16             	movzbl (%esi),%edx
80104976:	0f b6 0f             	movzbl (%edi),%ecx
80104979:	38 d1                	cmp    %dl,%cl
8010497b:	75 2b                	jne    801049a8 <memcmp+0x48>
8010497d:	b8 01 00 00 00       	mov    $0x1,%eax
80104982:	eb 14                	jmp    80104998 <memcmp+0x38>
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104988:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010498c:	83 c0 01             	add    $0x1,%eax
8010498f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104994:	38 ca                	cmp    %cl,%dl
80104996:	75 10                	jne    801049a8 <memcmp+0x48>
  while(n-- > 0){
80104998:	39 d8                	cmp    %ebx,%eax
8010499a:	75 ec                	jne    80104988 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010499c:	5b                   	pop    %ebx
  return 0;
8010499d:	31 c0                	xor    %eax,%eax
}
8010499f:	5e                   	pop    %esi
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	90                   	nop
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801049a8:	0f b6 c2             	movzbl %dl,%eax
}
801049ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801049ac:	29 c8                	sub    %ecx,%eax
}
801049ae:	5e                   	pop    %esi
801049af:	5f                   	pop    %edi
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 45 08             	mov    0x8(%ebp),%eax
801049c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ce:	39 c3                	cmp    %eax,%ebx
801049d0:	73 26                	jae    801049f8 <memmove+0x38>
801049d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801049d5:	39 c8                	cmp    %ecx,%eax
801049d7:	73 1f                	jae    801049f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801049d9:	85 f6                	test   %esi,%esi
801049db:	8d 56 ff             	lea    -0x1(%esi),%edx
801049de:	74 0f                	je     801049ef <memmove+0x2f>
      *--d = *--s;
801049e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801049e7:	83 ea 01             	sub    $0x1,%edx
801049ea:	83 fa ff             	cmp    $0xffffffff,%edx
801049ed:	75 f1                	jne    801049e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049ef:	5b                   	pop    %ebx
801049f0:	5e                   	pop    %esi
801049f1:	5d                   	pop    %ebp
801049f2:	c3                   	ret    
801049f3:	90                   	nop
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801049f8:	31 d2                	xor    %edx,%edx
801049fa:	85 f6                	test   %esi,%esi
801049fc:	74 f1                	je     801049ef <memmove+0x2f>
801049fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a00:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a04:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a07:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a0a:	39 d6                	cmp    %edx,%esi
80104a0c:	75 f2                	jne    80104a00 <memmove+0x40>
}
80104a0e:	5b                   	pop    %ebx
80104a0f:	5e                   	pop    %esi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a23:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a24:	eb 9a                	jmp    801049c0 <memmove>
80104a26:	8d 76 00             	lea    0x0(%esi),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a38:	53                   	push   %ebx
80104a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a3f:	85 ff                	test   %edi,%edi
80104a41:	74 2f                	je     80104a72 <strncmp+0x42>
80104a43:	0f b6 01             	movzbl (%ecx),%eax
80104a46:	0f b6 1e             	movzbl (%esi),%ebx
80104a49:	84 c0                	test   %al,%al
80104a4b:	74 37                	je     80104a84 <strncmp+0x54>
80104a4d:	38 c3                	cmp    %al,%bl
80104a4f:	75 33                	jne    80104a84 <strncmp+0x54>
80104a51:	01 f7                	add    %esi,%edi
80104a53:	eb 13                	jmp    80104a68 <strncmp+0x38>
80104a55:	8d 76 00             	lea    0x0(%esi),%esi
80104a58:	0f b6 01             	movzbl (%ecx),%eax
80104a5b:	84 c0                	test   %al,%al
80104a5d:	74 21                	je     80104a80 <strncmp+0x50>
80104a5f:	0f b6 1a             	movzbl (%edx),%ebx
80104a62:	89 d6                	mov    %edx,%esi
80104a64:	38 d8                	cmp    %bl,%al
80104a66:	75 1c                	jne    80104a84 <strncmp+0x54>
    n--, p++, q++;
80104a68:	8d 56 01             	lea    0x1(%esi),%edx
80104a6b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a6e:	39 fa                	cmp    %edi,%edx
80104a70:	75 e6                	jne    80104a58 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a72:	5b                   	pop    %ebx
    return 0;
80104a73:	31 c0                	xor    %eax,%eax
}
80104a75:	5e                   	pop    %esi
80104a76:	5f                   	pop    %edi
80104a77:	5d                   	pop    %ebp
80104a78:	c3                   	ret    
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a80:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a84:	29 d8                	sub    %ebx,%eax
}
80104a86:	5b                   	pop    %ebx
80104a87:	5e                   	pop    %esi
80104a88:	5f                   	pop    %edi
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	90                   	nop
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 45 08             	mov    0x8(%ebp),%eax
80104a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a9e:	89 c2                	mov    %eax,%edx
80104aa0:	eb 19                	jmp    80104abb <strncpy+0x2b>
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	83 c3 01             	add    $0x1,%ebx
80104aab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104aaf:	83 c2 01             	add    $0x1,%edx
80104ab2:	84 c9                	test   %cl,%cl
80104ab4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ab7:	74 09                	je     80104ac2 <strncpy+0x32>
80104ab9:	89 f1                	mov    %esi,%ecx
80104abb:	85 c9                	test   %ecx,%ecx
80104abd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ac0:	7f e6                	jg     80104aa8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ac2:	31 c9                	xor    %ecx,%ecx
80104ac4:	85 f6                	test   %esi,%esi
80104ac6:	7e 17                	jle    80104adf <strncpy+0x4f>
80104ac8:	90                   	nop
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ad0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ad4:	89 f3                	mov    %esi,%ebx
80104ad6:	83 c1 01             	add    $0x1,%ecx
80104ad9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104adb:	85 db                	test   %ebx,%ebx
80104add:	7f f1                	jg     80104ad0 <strncpy+0x40>
  return os;
}
80104adf:	5b                   	pop    %ebx
80104ae0:	5e                   	pop    %esi
80104ae1:	5d                   	pop    %ebp
80104ae2:	c3                   	ret    
80104ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104af8:	8b 45 08             	mov    0x8(%ebp),%eax
80104afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104afe:	85 c9                	test   %ecx,%ecx
80104b00:	7e 26                	jle    80104b28 <safestrcpy+0x38>
80104b02:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b06:	89 c1                	mov    %eax,%ecx
80104b08:	eb 17                	jmp    80104b21 <safestrcpy+0x31>
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b10:	83 c2 01             	add    $0x1,%edx
80104b13:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b17:	83 c1 01             	add    $0x1,%ecx
80104b1a:	84 db                	test   %bl,%bl
80104b1c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b1f:	74 04                	je     80104b25 <safestrcpy+0x35>
80104b21:	39 f2                	cmp    %esi,%edx
80104b23:	75 eb                	jne    80104b10 <safestrcpy+0x20>
    ;
  *s = 0;
80104b25:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <strlen>:

int
strlen(const char *s)
{
80104b30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b31:	31 c0                	xor    %eax,%eax
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b38:	80 3a 00             	cmpb   $0x0,(%edx)
80104b3b:	74 0c                	je     80104b49 <strlen+0x19>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
80104b40:	83 c0 01             	add    $0x1,%eax
80104b43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b47:	75 f7                	jne    80104b40 <strlen+0x10>
    ;
  return n;
}
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    

80104b4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b53:	55                   	push   %ebp
  pushl %ebx
80104b54:	53                   	push   %ebx
  pushl %esi
80104b55:	56                   	push   %esi
  pushl %edi
80104b56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b5b:	5f                   	pop    %edi
  popl %esi
80104b5c:	5e                   	pop    %esi
  popl %ebx
80104b5d:	5b                   	pop    %ebx
  popl %ebp
80104b5e:	5d                   	pop    %ebp
  ret
80104b5f:	c3                   	ret    

80104b60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 04             	sub    $0x4,%esp
80104b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b6a:	e8 31 ef ff ff       	call   80103aa0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b6f:	8b 00                	mov    (%eax),%eax
80104b71:	39 d8                	cmp    %ebx,%eax
80104b73:	76 1b                	jbe    80104b90 <fetchint+0x30>
80104b75:	8d 53 04             	lea    0x4(%ebx),%edx
80104b78:	39 d0                	cmp    %edx,%eax
80104b7a:	72 14                	jb     80104b90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7f:	8b 13                	mov    (%ebx),%edx
80104b81:	89 10                	mov    %edx,(%eax)
  return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	83 c4 04             	add    $0x4,%esp
80104b88:	5b                   	pop    %ebx
80104b89:	5d                   	pop    %ebp
80104b8a:	c3                   	ret    
80104b8b:	90                   	nop
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b95:	eb ee                	jmp    80104b85 <fetchint+0x25>
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	53                   	push   %ebx
80104ba4:	83 ec 04             	sub    $0x4,%esp
80104ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104baa:	e8 f1 ee ff ff       	call   80103aa0 <myproc>

  if(addr >= curproc->sz)
80104baf:	39 18                	cmp    %ebx,(%eax)
80104bb1:	76 29                	jbe    80104bdc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104bb6:	89 da                	mov    %ebx,%edx
80104bb8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bbc:	39 c3                	cmp    %eax,%ebx
80104bbe:	73 1c                	jae    80104bdc <fetchstr+0x3c>
    if(*s == 0)
80104bc0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104bc3:	75 10                	jne    80104bd5 <fetchstr+0x35>
80104bc5:	eb 39                	jmp    80104c00 <fetchstr+0x60>
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bd0:	80 3a 00             	cmpb   $0x0,(%edx)
80104bd3:	74 1b                	je     80104bf0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104bd5:	83 c2 01             	add    $0x1,%edx
80104bd8:	39 d0                	cmp    %edx,%eax
80104bda:	77 f4                	ja     80104bd0 <fetchstr+0x30>
    return -1;
80104bdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104be1:	83 c4 04             	add    $0x4,%esp
80104be4:	5b                   	pop    %ebx
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bf0:	83 c4 04             	add    $0x4,%esp
80104bf3:	89 d0                	mov    %edx,%eax
80104bf5:	29 d8                	sub    %ebx,%eax
80104bf7:	5b                   	pop    %ebx
80104bf8:	5d                   	pop    %ebp
80104bf9:	c3                   	ret    
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c00:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c02:	eb dd                	jmp    80104be1 <fetchstr+0x41>
80104c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	e8 86 ee ff ff       	call   80103aa0 <myproc>
80104c1a:	8b 40 18             	mov    0x18(%eax),%eax
80104c1d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c20:	8b 40 44             	mov    0x44(%eax),%eax
80104c23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c26:	e8 75 ee ff ff       	call   80103aa0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c2b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c2d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c30:	39 c6                	cmp    %eax,%esi
80104c32:	73 1c                	jae    80104c50 <argint+0x40>
80104c34:	8d 53 08             	lea    0x8(%ebx),%edx
80104c37:	39 d0                	cmp    %edx,%eax
80104c39:	72 15                	jb     80104c50 <argint+0x40>
  *ip = *(int*)(addr);
80104c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c41:	89 10                	mov    %edx,(%eax)
  return 0;
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	5b                   	pop    %ebx
80104c46:	5e                   	pop    %esi
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c55:	eb ee                	jmp    80104c45 <argint+0x35>
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	83 ec 10             	sub    $0x10,%esp
80104c68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c6b:	e8 30 ee ff ff       	call   80103aa0 <myproc>
80104c70:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c75:	83 ec 08             	sub    $0x8,%esp
80104c78:	50                   	push   %eax
80104c79:	ff 75 08             	pushl  0x8(%ebp)
80104c7c:	e8 8f ff ff ff       	call   80104c10 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	85 c0                	test   %eax,%eax
80104c86:	78 28                	js     80104cb0 <argptr+0x50>
80104c88:	85 db                	test   %ebx,%ebx
80104c8a:	78 24                	js     80104cb0 <argptr+0x50>
80104c8c:	8b 16                	mov    (%esi),%edx
80104c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c91:	39 c2                	cmp    %eax,%edx
80104c93:	76 1b                	jbe    80104cb0 <argptr+0x50>
80104c95:	01 c3                	add    %eax,%ebx
80104c97:	39 da                	cmp    %ebx,%edx
80104c99:	72 15                	jb     80104cb0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c9e:	89 02                	mov    %eax,(%edx)
  return 0;
80104ca0:	31 c0                	xor    %eax,%eax
}
80104ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb5:	eb eb                	jmp    80104ca2 <argptr+0x42>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cc9:	50                   	push   %eax
80104cca:	ff 75 08             	pushl  0x8(%ebp)
80104ccd:	e8 3e ff ff ff       	call   80104c10 <argint>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	78 17                	js     80104cf0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cd9:	83 ec 08             	sub    $0x8,%esp
80104cdc:	ff 75 0c             	pushl  0xc(%ebp)
80104cdf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ce2:	e8 b9 fe ff ff       	call   80104ba0 <fetchstr>
80104ce7:	83 c4 10             	add    $0x10,%esp
}
80104cea:	c9                   	leave  
80104ceb:	c3                   	ret    
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <syscall>:
[SYS_getpinfo]  sys_getpinfo
};

void
syscall(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d07:	e8 94 ed ff ff       	call   80103aa0 <myproc>
80104d0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d0e:	8b 40 18             	mov    0x18(%eax),%eax
80104d11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d17:	83 fa 16             	cmp    $0x16,%edx
80104d1a:	77 1c                	ja     80104d38 <syscall+0x38>
80104d1c:	8b 14 85 40 7b 10 80 	mov    -0x7fef84c0(,%eax,4),%edx
80104d23:	85 d2                	test   %edx,%edx
80104d25:	74 11                	je     80104d38 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d27:	ff d2                	call   *%edx
80104d29:	8b 53 18             	mov    0x18(%ebx),%edx
80104d2c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d32:	c9                   	leave  
80104d33:	c3                   	ret    
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d38:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d39:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d3c:	50                   	push   %eax
80104d3d:	ff 73 10             	pushl  0x10(%ebx)
80104d40:	68 0d 7b 10 80       	push   $0x80107b0d
80104d45:	e8 16 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104d4a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d4d:	83 c4 10             	add    $0x10,%esp
80104d50:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d5a:	c9                   	leave  
80104d5b:	c3                   	ret    
80104d5c:	66 90                	xchg   %ax,%ax
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d66:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104d69:	83 ec 44             	sub    $0x44,%esp
80104d6c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d72:	56                   	push   %esi
80104d73:	50                   	push   %eax
{
80104d74:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d77:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d7a:	e8 21 d4 ff ff       	call   801021a0 <nameiparent>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	85 c0                	test   %eax,%eax
80104d84:	0f 84 46 01 00 00    	je     80104ed0 <create+0x170>
    return 0;
  ilock(dp);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
80104d8d:	89 c3                	mov    %eax,%ebx
80104d8f:	50                   	push   %eax
80104d90:	e8 eb c8 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104d95:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104d98:	83 c4 0c             	add    $0xc,%esp
80104d9b:	50                   	push   %eax
80104d9c:	56                   	push   %esi
80104d9d:	53                   	push   %ebx
80104d9e:	e8 ad d0 ff ff       	call   80101e50 <dirlookup>
80104da3:	83 c4 10             	add    $0x10,%esp
80104da6:	85 c0                	test   %eax,%eax
80104da8:	89 c7                	mov    %eax,%edi
80104daa:	74 34                	je     80104de0 <create+0x80>
    iunlockput(dp);
80104dac:	83 ec 0c             	sub    $0xc,%esp
80104daf:	53                   	push   %ebx
80104db0:	e8 5b cb ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104db5:	89 3c 24             	mov    %edi,(%esp)
80104db8:	e8 c3 c8 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104dc5:	0f 85 95 00 00 00    	jne    80104e60 <create+0x100>
80104dcb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104dd0:	0f 85 8a 00 00 00    	jne    80104e60 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dd9:	89 f8                	mov    %edi,%eax
80104ddb:	5b                   	pop    %ebx
80104ddc:	5e                   	pop    %esi
80104ddd:	5f                   	pop    %edi
80104dde:	5d                   	pop    %ebp
80104ddf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104de0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104de4:	83 ec 08             	sub    $0x8,%esp
80104de7:	50                   	push   %eax
80104de8:	ff 33                	pushl  (%ebx)
80104dea:	e8 21 c7 ff ff       	call   80101510 <ialloc>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	89 c7                	mov    %eax,%edi
80104df6:	0f 84 e8 00 00 00    	je     80104ee4 <create+0x184>
  ilock(ip);
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	50                   	push   %eax
80104e00:	e8 7b c8 ff ff       	call   80101680 <ilock>
  ip->major = major;
80104e05:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e09:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e0d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e11:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e15:	b8 01 00 00 00       	mov    $0x1,%eax
80104e1a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e1e:	89 3c 24             	mov    %edi,(%esp)
80104e21:	e8 aa c7 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e26:	83 c4 10             	add    $0x10,%esp
80104e29:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e2e:	74 50                	je     80104e80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e30:	83 ec 04             	sub    $0x4,%esp
80104e33:	ff 77 04             	pushl  0x4(%edi)
80104e36:	56                   	push   %esi
80104e37:	53                   	push   %ebx
80104e38:	e8 83 d2 ff ff       	call   801020c0 <dirlink>
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	85 c0                	test   %eax,%eax
80104e42:	0f 88 8f 00 00 00    	js     80104ed7 <create+0x177>
  iunlockput(dp);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	53                   	push   %ebx
80104e4c:	e8 bf ca ff ff       	call   80101910 <iunlockput>
  return ip;
80104e51:	83 c4 10             	add    $0x10,%esp
}
80104e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e57:	89 f8                	mov    %edi,%eax
80104e59:	5b                   	pop    %ebx
80104e5a:	5e                   	pop    %esi
80104e5b:	5f                   	pop    %edi
80104e5c:	5d                   	pop    %ebp
80104e5d:	c3                   	ret    
80104e5e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e60:	83 ec 0c             	sub    $0xc,%esp
80104e63:	57                   	push   %edi
    return 0;
80104e64:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e66:	e8 a5 ca ff ff       	call   80101910 <iunlockput>
    return 0;
80104e6b:	83 c4 10             	add    $0x10,%esp
}
80104e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e71:	89 f8                	mov    %edi,%eax
80104e73:	5b                   	pop    %ebx
80104e74:	5e                   	pop    %esi
80104e75:	5f                   	pop    %edi
80104e76:	5d                   	pop    %ebp
80104e77:	c3                   	ret    
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104e80:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e85:	83 ec 0c             	sub    $0xc,%esp
80104e88:	53                   	push   %ebx
80104e89:	e8 42 c7 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e8e:	83 c4 0c             	add    $0xc,%esp
80104e91:	ff 77 04             	pushl  0x4(%edi)
80104e94:	68 bc 7b 10 80       	push   $0x80107bbc
80104e99:	57                   	push   %edi
80104e9a:	e8 21 d2 ff ff       	call   801020c0 <dirlink>
80104e9f:	83 c4 10             	add    $0x10,%esp
80104ea2:	85 c0                	test   %eax,%eax
80104ea4:	78 1c                	js     80104ec2 <create+0x162>
80104ea6:	83 ec 04             	sub    $0x4,%esp
80104ea9:	ff 73 04             	pushl  0x4(%ebx)
80104eac:	68 bb 7b 10 80       	push   $0x80107bbb
80104eb1:	57                   	push   %edi
80104eb2:	e8 09 d2 ff ff       	call   801020c0 <dirlink>
80104eb7:	83 c4 10             	add    $0x10,%esp
80104eba:	85 c0                	test   %eax,%eax
80104ebc:	0f 89 6e ff ff ff    	jns    80104e30 <create+0xd0>
      panic("create dots");
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	68 af 7b 10 80       	push   $0x80107baf
80104eca:	e8 c1 b4 ff ff       	call   80100390 <panic>
80104ecf:	90                   	nop
    return 0;
80104ed0:	31 ff                	xor    %edi,%edi
80104ed2:	e9 ff fe ff ff       	jmp    80104dd6 <create+0x76>
    panic("create: dirlink");
80104ed7:	83 ec 0c             	sub    $0xc,%esp
80104eda:	68 be 7b 10 80       	push   $0x80107bbe
80104edf:	e8 ac b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	68 a0 7b 10 80       	push   $0x80107ba0
80104eec:	e8 9f b4 ff ff       	call   80100390 <panic>
80104ef1:	eb 0d                	jmp    80104f00 <argfd.constprop.0>
80104ef3:	90                   	nop
80104ef4:	90                   	nop
80104ef5:	90                   	nop
80104ef6:	90                   	nop
80104ef7:	90                   	nop
80104ef8:	90                   	nop
80104ef9:	90                   	nop
80104efa:	90                   	nop
80104efb:	90                   	nop
80104efc:	90                   	nop
80104efd:	90                   	nop
80104efe:	90                   	nop
80104eff:	90                   	nop

80104f00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
80104f05:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f07:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f0a:	89 d6                	mov    %edx,%esi
80104f0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f0f:	50                   	push   %eax
80104f10:	6a 00                	push   $0x0
80104f12:	e8 f9 fc ff ff       	call   80104c10 <argint>
80104f17:	83 c4 10             	add    $0x10,%esp
80104f1a:	85 c0                	test   %eax,%eax
80104f1c:	78 2a                	js     80104f48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f22:	77 24                	ja     80104f48 <argfd.constprop.0+0x48>
80104f24:	e8 77 eb ff ff       	call   80103aa0 <myproc>
80104f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f30:	85 c0                	test   %eax,%eax
80104f32:	74 14                	je     80104f48 <argfd.constprop.0+0x48>
  if(pfd)
80104f34:	85 db                	test   %ebx,%ebx
80104f36:	74 02                	je     80104f3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f3a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f3c:	31 c0                	xor    %eax,%eax
}
80104f3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f41:	5b                   	pop    %ebx
80104f42:	5e                   	pop    %esi
80104f43:	5d                   	pop    %ebp
80104f44:	c3                   	ret    
80104f45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4d:	eb ef                	jmp    80104f3e <argfd.constprop.0+0x3e>
80104f4f:	90                   	nop

80104f50 <sys_dup>:
{
80104f50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f51:	31 c0                	xor    %eax,%eax
{
80104f53:	89 e5                	mov    %esp,%ebp
80104f55:	56                   	push   %esi
80104f56:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f57:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f5a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f5d:	e8 9e ff ff ff       	call   80104f00 <argfd.constprop.0>
80104f62:	85 c0                	test   %eax,%eax
80104f64:	78 42                	js     80104fa8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104f66:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f69:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f6b:	e8 30 eb ff ff       	call   80103aa0 <myproc>
80104f70:	eb 0e                	jmp    80104f80 <sys_dup+0x30>
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f78:	83 c3 01             	add    $0x1,%ebx
80104f7b:	83 fb 10             	cmp    $0x10,%ebx
80104f7e:	74 28                	je     80104fa8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104f80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f84:	85 d2                	test   %edx,%edx
80104f86:	75 f0                	jne    80104f78 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104f88:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f8c:	83 ec 0c             	sub    $0xc,%esp
80104f8f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f92:	e8 59 be ff ff       	call   80100df0 <filedup>
  return fd;
80104f97:	83 c4 10             	add    $0x10,%esp
}
80104f9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9d:	89 d8                	mov    %ebx,%eax
80104f9f:	5b                   	pop    %ebx
80104fa0:	5e                   	pop    %esi
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret    
80104fa3:	90                   	nop
80104fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fb0:	89 d8                	mov    %ebx,%eax
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5d                   	pop    %ebp
80104fb5:	c3                   	ret    
80104fb6:	8d 76 00             	lea    0x0(%esi),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <sys_read>:
{
80104fc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fc1:	31 c0                	xor    %eax,%eax
{
80104fc3:	89 e5                	mov    %esp,%ebp
80104fc5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fcb:	e8 30 ff ff ff       	call   80104f00 <argfd.constprop.0>
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	78 4c                	js     80105020 <sys_read+0x60>
80104fd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd7:	83 ec 08             	sub    $0x8,%esp
80104fda:	50                   	push   %eax
80104fdb:	6a 02                	push   $0x2
80104fdd:	e8 2e fc ff ff       	call   80104c10 <argint>
80104fe2:	83 c4 10             	add    $0x10,%esp
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 37                	js     80105020 <sys_read+0x60>
80104fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fec:	83 ec 04             	sub    $0x4,%esp
80104fef:	ff 75 f0             	pushl  -0x10(%ebp)
80104ff2:	50                   	push   %eax
80104ff3:	6a 01                	push   $0x1
80104ff5:	e8 66 fc ff ff       	call   80104c60 <argptr>
80104ffa:	83 c4 10             	add    $0x10,%esp
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	78 1f                	js     80105020 <sys_read+0x60>
  return fileread(f, p, n);
80105001:	83 ec 04             	sub    $0x4,%esp
80105004:	ff 75 f0             	pushl  -0x10(%ebp)
80105007:	ff 75 f4             	pushl  -0xc(%ebp)
8010500a:	ff 75 ec             	pushl  -0x14(%ebp)
8010500d:	e8 4e bf ff ff       	call   80100f60 <fileread>
80105012:	83 c4 10             	add    $0x10,%esp
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_write>:
{
80105030:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105031:	31 c0                	xor    %eax,%eax
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105038:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010503b:	e8 c0 fe ff ff       	call   80104f00 <argfd.constprop.0>
80105040:	85 c0                	test   %eax,%eax
80105042:	78 4c                	js     80105090 <sys_write+0x60>
80105044:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105047:	83 ec 08             	sub    $0x8,%esp
8010504a:	50                   	push   %eax
8010504b:	6a 02                	push   $0x2
8010504d:	e8 be fb ff ff       	call   80104c10 <argint>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	78 37                	js     80105090 <sys_write+0x60>
80105059:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505c:	83 ec 04             	sub    $0x4,%esp
8010505f:	ff 75 f0             	pushl  -0x10(%ebp)
80105062:	50                   	push   %eax
80105063:	6a 01                	push   $0x1
80105065:	e8 f6 fb ff ff       	call   80104c60 <argptr>
8010506a:	83 c4 10             	add    $0x10,%esp
8010506d:	85 c0                	test   %eax,%eax
8010506f:	78 1f                	js     80105090 <sys_write+0x60>
  return filewrite(f, p, n);
80105071:	83 ec 04             	sub    $0x4,%esp
80105074:	ff 75 f0             	pushl  -0x10(%ebp)
80105077:	ff 75 f4             	pushl  -0xc(%ebp)
8010507a:	ff 75 ec             	pushl  -0x14(%ebp)
8010507d:	e8 6e bf ff ff       	call   80100ff0 <filewrite>
80105082:	83 c4 10             	add    $0x10,%esp
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_close>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050ac:	e8 4f fe ff ff       	call   80104f00 <argfd.constprop.0>
801050b1:	85 c0                	test   %eax,%eax
801050b3:	78 2b                	js     801050e0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801050b5:	e8 e6 e9 ff ff       	call   80103aa0 <myproc>
801050ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050bd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050c0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050c7:	00 
  fileclose(f);
801050c8:	ff 75 f4             	pushl  -0xc(%ebp)
801050cb:	e8 70 bd ff ff       	call   80100e40 <fileclose>
  return 0;
801050d0:	83 c4 10             	add    $0x10,%esp
801050d3:	31 c0                	xor    %eax,%eax
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050f0 <sys_fstat>:
{
801050f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050f1:	31 c0                	xor    %eax,%eax
{
801050f3:	89 e5                	mov    %esp,%ebp
801050f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801050fb:	e8 00 fe ff ff       	call   80104f00 <argfd.constprop.0>
80105100:	85 c0                	test   %eax,%eax
80105102:	78 2c                	js     80105130 <sys_fstat+0x40>
80105104:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105107:	83 ec 04             	sub    $0x4,%esp
8010510a:	6a 18                	push   $0x18
8010510c:	50                   	push   %eax
8010510d:	6a 01                	push   $0x1
8010510f:	e8 4c fb ff ff       	call   80104c60 <argptr>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	78 15                	js     80105130 <sys_fstat+0x40>
  return filestat(f, st);
8010511b:	83 ec 08             	sub    $0x8,%esp
8010511e:	ff 75 f4             	pushl  -0xc(%ebp)
80105121:	ff 75 f0             	pushl  -0x10(%ebp)
80105124:	e8 e7 bd ff ff       	call   80100f10 <filestat>
80105129:	83 c4 10             	add    $0x10,%esp
}
8010512c:	c9                   	leave  
8010512d:	c3                   	ret    
8010512e:	66 90                	xchg   %ax,%ax
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105135:	c9                   	leave  
80105136:	c3                   	ret    
80105137:	89 f6                	mov    %esi,%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <sys_link>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
80105145:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105146:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105149:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 6c fb ff ff       	call   80104cc0 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 fb 00 00 00    	js     8010525a <sys_link+0x11a>
8010515f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105162:	83 ec 08             	sub    $0x8,%esp
80105165:	50                   	push   %eax
80105166:	6a 01                	push   $0x1
80105168:	e8 53 fb ff ff       	call   80104cc0 <argstr>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	0f 88 e2 00 00 00    	js     8010525a <sys_link+0x11a>
  begin_op();
80105178:	e8 c3 dc ff ff       	call   80102e40 <begin_op>
  if((ip = namei(old)) == 0){
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	ff 75 d4             	pushl  -0x2c(%ebp)
80105183:	e8 f8 cf ff ff       	call   80102180 <namei>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	89 c3                	mov    %eax,%ebx
8010518f:	0f 84 ea 00 00 00    	je     8010527f <sys_link+0x13f>
  ilock(ip);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	50                   	push   %eax
80105199:	e8 e2 c4 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a6:	0f 84 bb 00 00 00    	je     80105267 <sys_link+0x127>
  ip->nlink++;
801051ac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051b1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801051b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051b7:	53                   	push   %ebx
801051b8:	e8 13 c4 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
801051bd:	89 1c 24             	mov    %ebx,(%esp)
801051c0:	e8 9b c5 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051c5:	58                   	pop    %eax
801051c6:	5a                   	pop    %edx
801051c7:	57                   	push   %edi
801051c8:	ff 75 d0             	pushl  -0x30(%ebp)
801051cb:	e8 d0 cf ff ff       	call   801021a0 <nameiparent>
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	85 c0                	test   %eax,%eax
801051d5:	89 c6                	mov    %eax,%esi
801051d7:	74 5b                	je     80105234 <sys_link+0xf4>
  ilock(dp);
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	50                   	push   %eax
801051dd:	e8 9e c4 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	8b 03                	mov    (%ebx),%eax
801051e7:	39 06                	cmp    %eax,(%esi)
801051e9:	75 3d                	jne    80105228 <sys_link+0xe8>
801051eb:	83 ec 04             	sub    $0x4,%esp
801051ee:	ff 73 04             	pushl  0x4(%ebx)
801051f1:	57                   	push   %edi
801051f2:	56                   	push   %esi
801051f3:	e8 c8 ce ff ff       	call   801020c0 <dirlink>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	78 29                	js     80105228 <sys_link+0xe8>
  iunlockput(dp);
801051ff:	83 ec 0c             	sub    $0xc,%esp
80105202:	56                   	push   %esi
80105203:	e8 08 c7 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105208:	89 1c 24             	mov    %ebx,(%esp)
8010520b:	e8 a0 c5 ff ff       	call   801017b0 <iput>
  end_op();
80105210:	e8 9b dc ff ff       	call   80102eb0 <end_op>
  return 0;
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	31 c0                	xor    %eax,%eax
}
8010521a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010521d:	5b                   	pop    %ebx
8010521e:	5e                   	pop    %esi
8010521f:	5f                   	pop    %edi
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	56                   	push   %esi
8010522c:	e8 df c6 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105231:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	53                   	push   %ebx
80105238:	e8 43 c4 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010523d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105242:	89 1c 24             	mov    %ebx,(%esp)
80105245:	e8 86 c3 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010524a:	89 1c 24             	mov    %ebx,(%esp)
8010524d:	e8 be c6 ff ff       	call   80101910 <iunlockput>
  end_op();
80105252:	e8 59 dc ff ff       	call   80102eb0 <end_op>
  return -1;
80105257:	83 c4 10             	add    $0x10,%esp
}
8010525a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010525d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105262:	5b                   	pop    %ebx
80105263:	5e                   	pop    %esi
80105264:	5f                   	pop    %edi
80105265:	5d                   	pop    %ebp
80105266:	c3                   	ret    
    iunlockput(ip);
80105267:	83 ec 0c             	sub    $0xc,%esp
8010526a:	53                   	push   %ebx
8010526b:	e8 a0 c6 ff ff       	call   80101910 <iunlockput>
    end_op();
80105270:	e8 3b dc ff ff       	call   80102eb0 <end_op>
    return -1;
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527d:	eb 9b                	jmp    8010521a <sys_link+0xda>
    end_op();
8010527f:	e8 2c dc ff ff       	call   80102eb0 <end_op>
    return -1;
80105284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105289:	eb 8f                	jmp    8010521a <sys_link+0xda>
8010528b:	90                   	nop
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_unlink>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
80105295:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105296:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105299:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010529c:	50                   	push   %eax
8010529d:	6a 00                	push   $0x0
8010529f:	e8 1c fa ff ff       	call   80104cc0 <argstr>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 77 01 00 00    	js     80105426 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801052af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801052b2:	e8 89 db ff ff       	call   80102e40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052b7:	83 ec 08             	sub    $0x8,%esp
801052ba:	53                   	push   %ebx
801052bb:	ff 75 c0             	pushl  -0x40(%ebp)
801052be:	e8 dd ce ff ff       	call   801021a0 <nameiparent>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	89 c6                	mov    %eax,%esi
801052ca:	0f 84 60 01 00 00    	je     80105430 <sys_unlink+0x1a0>
  ilock(dp);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	50                   	push   %eax
801052d4:	e8 a7 c3 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052d9:	58                   	pop    %eax
801052da:	5a                   	pop    %edx
801052db:	68 bc 7b 10 80       	push   $0x80107bbc
801052e0:	53                   	push   %ebx
801052e1:	e8 4a cb ff ff       	call   80101e30 <namecmp>
801052e6:	83 c4 10             	add    $0x10,%esp
801052e9:	85 c0                	test   %eax,%eax
801052eb:	0f 84 03 01 00 00    	je     801053f4 <sys_unlink+0x164>
801052f1:	83 ec 08             	sub    $0x8,%esp
801052f4:	68 bb 7b 10 80       	push   $0x80107bbb
801052f9:	53                   	push   %ebx
801052fa:	e8 31 cb ff ff       	call   80101e30 <namecmp>
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	85 c0                	test   %eax,%eax
80105304:	0f 84 ea 00 00 00    	je     801053f4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010530a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010530d:	83 ec 04             	sub    $0x4,%esp
80105310:	50                   	push   %eax
80105311:	53                   	push   %ebx
80105312:	56                   	push   %esi
80105313:	e8 38 cb ff ff       	call   80101e50 <dirlookup>
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	85 c0                	test   %eax,%eax
8010531d:	89 c3                	mov    %eax,%ebx
8010531f:	0f 84 cf 00 00 00    	je     801053f4 <sys_unlink+0x164>
  ilock(ip);
80105325:	83 ec 0c             	sub    $0xc,%esp
80105328:	50                   	push   %eax
80105329:	e8 52 c3 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105336:	0f 8e 10 01 00 00    	jle    8010544c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010533c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105341:	74 6d                	je     801053b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105343:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105346:	83 ec 04             	sub    $0x4,%esp
80105349:	6a 10                	push   $0x10
8010534b:	6a 00                	push   $0x0
8010534d:	50                   	push   %eax
8010534e:	e8 bd f5 ff ff       	call   80104910 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105353:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105356:	6a 10                	push   $0x10
80105358:	ff 75 c4             	pushl  -0x3c(%ebp)
8010535b:	50                   	push   %eax
8010535c:	56                   	push   %esi
8010535d:	e8 ae c8 ff ff       	call   80101c10 <writei>
80105362:	83 c4 20             	add    $0x20,%esp
80105365:	83 f8 10             	cmp    $0x10,%eax
80105368:	0f 85 eb 00 00 00    	jne    80105459 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010536e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105373:	0f 84 97 00 00 00    	je     80105410 <sys_unlink+0x180>
  iunlockput(dp);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	56                   	push   %esi
8010537d:	e8 8e c5 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105382:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105387:	89 1c 24             	mov    %ebx,(%esp)
8010538a:	e8 41 c2 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010538f:	89 1c 24             	mov    %ebx,(%esp)
80105392:	e8 79 c5 ff ff       	call   80101910 <iunlockput>
  end_op();
80105397:	e8 14 db ff ff       	call   80102eb0 <end_op>
  return 0;
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	31 c0                	xor    %eax,%eax
}
801053a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a4:	5b                   	pop    %ebx
801053a5:	5e                   	pop    %esi
801053a6:	5f                   	pop    %edi
801053a7:	5d                   	pop    %ebp
801053a8:	c3                   	ret    
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053b4:	76 8d                	jbe    80105343 <sys_unlink+0xb3>
801053b6:	bf 20 00 00 00       	mov    $0x20,%edi
801053bb:	eb 0f                	jmp    801053cc <sys_unlink+0x13c>
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
801053c0:	83 c7 10             	add    $0x10,%edi
801053c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801053c6:	0f 83 77 ff ff ff    	jae    80105343 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053cc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053cf:	6a 10                	push   $0x10
801053d1:	57                   	push   %edi
801053d2:	50                   	push   %eax
801053d3:	53                   	push   %ebx
801053d4:	e8 17 c6 ff ff       	call   801019f0 <readi>
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	83 f8 10             	cmp    $0x10,%eax
801053df:	75 5e                	jne    8010543f <sys_unlink+0x1af>
    if(de.inum != 0)
801053e1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053e6:	74 d8                	je     801053c0 <sys_unlink+0x130>
    iunlockput(ip);
801053e8:	83 ec 0c             	sub    $0xc,%esp
801053eb:	53                   	push   %ebx
801053ec:	e8 1f c5 ff ff       	call   80101910 <iunlockput>
    goto bad;
801053f1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	56                   	push   %esi
801053f8:	e8 13 c5 ff ff       	call   80101910 <iunlockput>
  end_op();
801053fd:	e8 ae da ff ff       	call   80102eb0 <end_op>
  return -1;
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540a:	eb 95                	jmp    801053a1 <sys_unlink+0x111>
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105410:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105415:	83 ec 0c             	sub    $0xc,%esp
80105418:	56                   	push   %esi
80105419:	e8 b2 c1 ff ff       	call   801015d0 <iupdate>
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	e9 53 ff ff ff       	jmp    80105379 <sys_unlink+0xe9>
    return -1;
80105426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542b:	e9 71 ff ff ff       	jmp    801053a1 <sys_unlink+0x111>
    end_op();
80105430:	e8 7b da ff ff       	call   80102eb0 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543a:	e9 62 ff ff ff       	jmp    801053a1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010543f:	83 ec 0c             	sub    $0xc,%esp
80105442:	68 e0 7b 10 80       	push   $0x80107be0
80105447:	e8 44 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	68 ce 7b 10 80       	push   $0x80107bce
80105454:	e8 37 af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	68 f2 7b 10 80       	push   $0x80107bf2
80105461:	e8 2a af ff ff       	call   80100390 <panic>
80105466:	8d 76 00             	lea    0x0(%esi),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_open>:

int
sys_open(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105476:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105479:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010547c:	50                   	push   %eax
8010547d:	6a 00                	push   $0x0
8010547f:	e8 3c f8 ff ff       	call   80104cc0 <argstr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	0f 88 38 01 00 00    	js     801055c7 <sys_open+0x157>
8010548f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105492:	83 ec 08             	sub    $0x8,%esp
80105495:	50                   	push   %eax
80105496:	6a 01                	push   $0x1
80105498:	e8 73 f7 ff ff       	call   80104c10 <argint>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	0f 88 1f 01 00 00    	js     801055c7 <sys_open+0x157>
    return -1;

  begin_op();
801054a8:	e8 93 d9 ff ff       	call   80102e40 <begin_op>

  if(omode & O_CREATE){
801054ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801054b0:	f6 c6 02             	test   $0x2,%dh
801054b3:	0f 84 c7 00 00 00    	je     80105580 <sys_open+0x110>
    //FileSystem Intergrity
    if (omode & O_CHECKED) {
801054b9:	80 e6 04             	and    $0x4,%dh
801054bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054bf:	0f 85 9b 00 00 00    	jne    80105560 <sys_open+0xf0>
      ip = create(path, T_CHECKED, 0, 0);
    }else{
      ip = create(path, T_FILE, 0, 0);
801054c5:	83 ec 0c             	sub    $0xc,%esp
801054c8:	31 c9                	xor    %ecx,%ecx
801054ca:	ba 02 00 00 00       	mov    $0x2,%edx
801054cf:	6a 00                	push   $0x0
801054d1:	e8 8a f8 ff ff       	call   80104d60 <create>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	89 c6                	mov    %eax,%esi
    }
    if(ip == 0){
801054db:	85 f6                	test   %esi,%esi
801054dd:	0f 84 03 01 00 00    	je     801055e6 <sys_open+0x176>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054e3:	e8 98 b8 ff ff       	call   80100d80 <filealloc>
801054e8:	85 c0                	test   %eax,%eax
801054ea:	89 c7                	mov    %eax,%edi
801054ec:	0f 84 c4 00 00 00    	je     801055b6 <sys_open+0x146>
  struct proc *curproc = myproc();
801054f2:	e8 a9 e5 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054f7:	31 db                	xor    %ebx,%ebx
801054f9:	eb 11                	jmp    8010550c <sys_open+0x9c>
801054fb:	90                   	nop
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105500:	83 c3 01             	add    $0x1,%ebx
80105503:	83 fb 10             	cmp    $0x10,%ebx
80105506:	0f 84 cc 00 00 00    	je     801055d8 <sys_open+0x168>
    if(curproc->ofile[fd] == 0){
8010550c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105510:	85 d2                	test   %edx,%edx
80105512:	75 ec                	jne    80105500 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105514:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105517:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010551b:	56                   	push   %esi
8010551c:	e8 3f c2 ff ff       	call   80101760 <iunlock>
  end_op();
80105521:	e8 8a d9 ff ff       	call   80102eb0 <end_op>

  f->type = FD_INODE;
80105526:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010552c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010552f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105532:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105535:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010553c:	89 d0                	mov    %edx,%eax
8010553e:	f7 d0                	not    %eax
80105540:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105543:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105546:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105549:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010554d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105550:	89 d8                	mov    %ebx,%eax
80105552:	5b                   	pop    %ebx
80105553:	5e                   	pop    %esi
80105554:	5f                   	pop    %edi
80105555:	5d                   	pop    %ebp
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip = create(path, T_CHECKED, 0, 0);
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	31 c9                	xor    %ecx,%ecx
80105565:	ba 04 00 00 00       	mov    $0x4,%edx
8010556a:	6a 00                	push   $0x0
8010556c:	e8 ef f7 ff ff       	call   80104d60 <create>
80105571:	83 c4 10             	add    $0x10,%esp
80105574:	89 c6                	mov    %eax,%esi
80105576:	e9 60 ff ff ff       	jmp    801054db <sys_open+0x6b>
8010557b:	90                   	nop
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	ff 75 e0             	pushl  -0x20(%ebp)
80105586:	e8 f5 cb ff ff       	call   80102180 <namei>
8010558b:	83 c4 10             	add    $0x10,%esp
8010558e:	85 c0                	test   %eax,%eax
80105590:	89 c6                	mov    %eax,%esi
80105592:	74 52                	je     801055e6 <sys_open+0x176>
    ilock(ip);
80105594:	83 ec 0c             	sub    $0xc,%esp
80105597:	50                   	push   %eax
80105598:	e8 e3 c0 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055a5:	0f 85 38 ff ff ff    	jne    801054e3 <sys_open+0x73>
801055ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055ae:	85 c9                	test   %ecx,%ecx
801055b0:	0f 84 2d ff ff ff    	je     801054e3 <sys_open+0x73>
    iunlockput(ip);
801055b6:	83 ec 0c             	sub    $0xc,%esp
801055b9:	56                   	push   %esi
801055ba:	e8 51 c3 ff ff       	call   80101910 <iunlockput>
    end_op();
801055bf:	e8 ec d8 ff ff       	call   80102eb0 <end_op>
    return -1;
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055cc:	e9 7c ff ff ff       	jmp    8010554d <sys_open+0xdd>
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	57                   	push   %edi
801055dc:	e8 5f b8 ff ff       	call   80100e40 <fileclose>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	eb d0                	jmp    801055b6 <sys_open+0x146>
      end_op();
801055e6:	e8 c5 d8 ff ff       	call   80102eb0 <end_op>
      return -1;
801055eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055f0:	e9 58 ff ff ff       	jmp    8010554d <sys_open+0xdd>
801055f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_mkdir>:

int
sys_mkdir(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105606:	e8 35 d8 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010560b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560e:	83 ec 08             	sub    $0x8,%esp
80105611:	50                   	push   %eax
80105612:	6a 00                	push   $0x0
80105614:	e8 a7 f6 ff ff       	call   80104cc0 <argstr>
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	85 c0                	test   %eax,%eax
8010561e:	78 30                	js     80105650 <sys_mkdir+0x50>
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105626:	31 c9                	xor    %ecx,%ecx
80105628:	6a 00                	push   $0x0
8010562a:	ba 01 00 00 00       	mov    $0x1,%edx
8010562f:	e8 2c f7 ff ff       	call   80104d60 <create>
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	85 c0                	test   %eax,%eax
80105639:	74 15                	je     80105650 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010563b:	83 ec 0c             	sub    $0xc,%esp
8010563e:	50                   	push   %eax
8010563f:	e8 cc c2 ff ff       	call   80101910 <iunlockput>
  end_op();
80105644:	e8 67 d8 ff ff       	call   80102eb0 <end_op>
  return 0;
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	31 c0                	xor    %eax,%eax
}
8010564e:	c9                   	leave  
8010564f:	c3                   	ret    
    end_op();
80105650:	e8 5b d8 ff ff       	call   80102eb0 <end_op>
    return -1;
80105655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565a:	c9                   	leave  
8010565b:	c3                   	ret    
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_mknod>:

int
sys_mknod(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105666:	e8 d5 d7 ff ff       	call   80102e40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010566b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010566e:	83 ec 08             	sub    $0x8,%esp
80105671:	50                   	push   %eax
80105672:	6a 00                	push   $0x0
80105674:	e8 47 f6 ff ff       	call   80104cc0 <argstr>
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	78 60                	js     801056e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105680:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105683:	83 ec 08             	sub    $0x8,%esp
80105686:	50                   	push   %eax
80105687:	6a 01                	push   $0x1
80105689:	e8 82 f5 ff ff       	call   80104c10 <argint>
  if((argstr(0, &path)) < 0 ||
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	85 c0                	test   %eax,%eax
80105693:	78 4b                	js     801056e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105695:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105698:	83 ec 08             	sub    $0x8,%esp
8010569b:	50                   	push   %eax
8010569c:	6a 02                	push   $0x2
8010569e:	e8 6d f5 ff ff       	call   80104c10 <argint>
     argint(1, &major) < 0 ||
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 36                	js     801056e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056ae:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801056b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056b5:	ba 03 00 00 00       	mov    $0x3,%edx
801056ba:	50                   	push   %eax
801056bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056be:	e8 9d f6 ff ff       	call   80104d60 <create>
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 c0                	test   %eax,%eax
801056c8:	74 16                	je     801056e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ca:	83 ec 0c             	sub    $0xc,%esp
801056cd:	50                   	push   %eax
801056ce:	e8 3d c2 ff ff       	call   80101910 <iunlockput>
  end_op();
801056d3:	e8 d8 d7 ff ff       	call   80102eb0 <end_op>
  return 0;
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	31 c0                	xor    %eax,%eax
}
801056dd:	c9                   	leave  
801056de:	c3                   	ret    
801056df:	90                   	nop
    end_op();
801056e0:	e8 cb d7 ff ff       	call   80102eb0 <end_op>
    return -1;
801056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_chdir>:

int
sys_chdir(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	56                   	push   %esi
801056f4:	53                   	push   %ebx
801056f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056f8:	e8 a3 e3 ff ff       	call   80103aa0 <myproc>
801056fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056ff:	e8 3c d7 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105704:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105707:	83 ec 08             	sub    $0x8,%esp
8010570a:	50                   	push   %eax
8010570b:	6a 00                	push   $0x0
8010570d:	e8 ae f5 ff ff       	call   80104cc0 <argstr>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	78 77                	js     80105790 <sys_chdir+0xa0>
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	ff 75 f4             	pushl  -0xc(%ebp)
8010571f:	e8 5c ca ff ff       	call   80102180 <namei>
80105724:	83 c4 10             	add    $0x10,%esp
80105727:	85 c0                	test   %eax,%eax
80105729:	89 c3                	mov    %eax,%ebx
8010572b:	74 63                	je     80105790 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010572d:	83 ec 0c             	sub    $0xc,%esp
80105730:	50                   	push   %eax
80105731:	e8 4a bf ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010573e:	75 30                	jne    80105770 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	53                   	push   %ebx
80105744:	e8 17 c0 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105749:	58                   	pop    %eax
8010574a:	ff 76 68             	pushl  0x68(%esi)
8010574d:	e8 5e c0 ff ff       	call   801017b0 <iput>
  end_op();
80105752:	e8 59 d7 ff ff       	call   80102eb0 <end_op>
  curproc->cwd = ip;
80105757:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	31 c0                	xor    %eax,%eax
}
8010575f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105762:	5b                   	pop    %ebx
80105763:	5e                   	pop    %esi
80105764:	5d                   	pop    %ebp
80105765:	c3                   	ret    
80105766:	8d 76 00             	lea    0x0(%esi),%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	53                   	push   %ebx
80105774:	e8 97 c1 ff ff       	call   80101910 <iunlockput>
    end_op();
80105779:	e8 32 d7 ff ff       	call   80102eb0 <end_op>
    return -1;
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105786:	eb d7                	jmp    8010575f <sys_chdir+0x6f>
80105788:	90                   	nop
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105790:	e8 1b d7 ff ff       	call   80102eb0 <end_op>
    return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579a:	eb c3                	jmp    8010575f <sys_chdir+0x6f>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_exec>:

int
sys_exec(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
801057a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057b2:	50                   	push   %eax
801057b3:	6a 00                	push   $0x0
801057b5:	e8 06 f5 ff ff       	call   80104cc0 <argstr>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	85 c0                	test   %eax,%eax
801057bf:	0f 88 87 00 00 00    	js     8010584c <sys_exec+0xac>
801057c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057cb:	83 ec 08             	sub    $0x8,%esp
801057ce:	50                   	push   %eax
801057cf:	6a 01                	push   $0x1
801057d1:	e8 3a f4 ff ff       	call   80104c10 <argint>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	78 6f                	js     8010584c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801057e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057e8:	68 80 00 00 00       	push   $0x80
801057ed:	6a 00                	push   $0x0
801057ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057f5:	50                   	push   %eax
801057f6:	e8 15 f1 ff ff       	call   80104910 <memset>
801057fb:	83 c4 10             	add    $0x10,%esp
801057fe:	eb 2c                	jmp    8010582c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105800:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105806:	85 c0                	test   %eax,%eax
80105808:	74 56                	je     80105860 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010580a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105810:	83 ec 08             	sub    $0x8,%esp
80105813:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105816:	52                   	push   %edx
80105817:	50                   	push   %eax
80105818:	e8 83 f3 ff ff       	call   80104ba0 <fetchstr>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 28                	js     8010584c <sys_exec+0xac>
  for(i=0;; i++){
80105824:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105827:	83 fb 20             	cmp    $0x20,%ebx
8010582a:	74 20                	je     8010584c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010582c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105832:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105839:	83 ec 08             	sub    $0x8,%esp
8010583c:	57                   	push   %edi
8010583d:	01 f0                	add    %esi,%eax
8010583f:	50                   	push   %eax
80105840:	e8 1b f3 ff ff       	call   80104b60 <fetchint>
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	85 c0                	test   %eax,%eax
8010584a:	79 b4                	jns    80105800 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010584c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010584f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105854:	5b                   	pop    %ebx
80105855:	5e                   	pop    %esi
80105856:	5f                   	pop    %edi
80105857:	5d                   	pop    %ebp
80105858:	c3                   	ret    
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105860:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105866:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105869:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105870:	00 00 00 00 
  return exec(path, argv);
80105874:	50                   	push   %eax
80105875:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010587b:	e8 90 b1 ff ff       	call   80100a10 <exec>
80105880:	83 c4 10             	add    $0x10,%esp
}
80105883:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105886:	5b                   	pop    %ebx
80105887:	5e                   	pop    %esi
80105888:	5f                   	pop    %edi
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    
8010588b:	90                   	nop
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_pipe>:

int
sys_pipe(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105896:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105899:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010589c:	6a 08                	push   $0x8
8010589e:	50                   	push   %eax
8010589f:	6a 00                	push   $0x0
801058a1:	e8 ba f3 ff ff       	call   80104c60 <argptr>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	0f 88 ae 00 00 00    	js     8010595f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058b4:	83 ec 08             	sub    $0x8,%esp
801058b7:	50                   	push   %eax
801058b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058bb:	50                   	push   %eax
801058bc:	e8 1f dc ff ff       	call   801034e0 <pipealloc>
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	85 c0                	test   %eax,%eax
801058c6:	0f 88 93 00 00 00    	js     8010595f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058d1:	e8 ca e1 ff ff       	call   80103aa0 <myproc>
801058d6:	eb 10                	jmp    801058e8 <sys_pipe+0x58>
801058d8:	90                   	nop
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058e0:	83 c3 01             	add    $0x1,%ebx
801058e3:	83 fb 10             	cmp    $0x10,%ebx
801058e6:	74 60                	je     80105948 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801058e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058ec:	85 f6                	test   %esi,%esi
801058ee:	75 f0                	jne    801058e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058f0:	8d 73 08             	lea    0x8(%ebx),%esi
801058f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058fa:	e8 a1 e1 ff ff       	call   80103aa0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ff:	31 d2                	xor    %edx,%edx
80105901:	eb 0d                	jmp    80105910 <sys_pipe+0x80>
80105903:	90                   	nop
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105908:	83 c2 01             	add    $0x1,%edx
8010590b:	83 fa 10             	cmp    $0x10,%edx
8010590e:	74 28                	je     80105938 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105910:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105914:	85 c9                	test   %ecx,%ecx
80105916:	75 f0                	jne    80105908 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105918:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010591c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010591f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105921:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105924:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105927:	31 c0                	xor    %eax,%eax
}
80105929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010592c:	5b                   	pop    %ebx
8010592d:	5e                   	pop    %esi
8010592e:	5f                   	pop    %edi
8010592f:	5d                   	pop    %ebp
80105930:	c3                   	ret    
80105931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105938:	e8 63 e1 ff ff       	call   80103aa0 <myproc>
8010593d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105944:	00 
80105945:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 e0             	pushl  -0x20(%ebp)
8010594e:	e8 ed b4 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105953:	58                   	pop    %eax
80105954:	ff 75 e4             	pushl  -0x1c(%ebp)
80105957:	e8 e4 b4 ff ff       	call   80100e40 <fileclose>
    return -1;
8010595c:	83 c4 10             	add    $0x10,%esp
8010595f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105964:	eb c3                	jmp    80105929 <sys_pipe+0x99>
80105966:	66 90                	xchg   %ax,%ax
80105968:	66 90                	xchg   %ax,%ax
8010596a:	66 90                	xchg   %ax,%ax
8010596c:	66 90                	xchg   %ax,%ax
8010596e:	66 90                	xchg   %ax,%ax

80105970 <sys_fork>:
#include "proc.h"
#include "pstat.h"

int
sys_fork(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105973:	5d                   	pop    %ebp
  return fork();
80105974:	e9 e7 e2 ff ff       	jmp    80103c60 <fork>
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_exit>:

int
sys_exit(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 08             	sub    $0x8,%esp
  exit();
80105986:	e8 15 e7 ff ff       	call   801040a0 <exit>
  return 0;  // not reached
}
8010598b:	31 c0                	xor    %eax,%eax
8010598d:	c9                   	leave  
8010598e:	c3                   	ret    
8010598f:	90                   	nop

80105990 <sys_wait>:

int
sys_wait(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105993:	5d                   	pop    %ebp
  return wait();
80105994:	e9 47 e9 ff ff       	jmp    801042e0 <wait>
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_kill>:

int
sys_kill(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059a9:	50                   	push   %eax
801059aa:	6a 00                	push   $0x0
801059ac:	e8 5f f2 ff ff       	call   80104c10 <argint>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	85 c0                	test   %eax,%eax
801059b6:	78 18                	js     801059d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	ff 75 f4             	pushl  -0xc(%ebp)
801059be:	e8 7d ea ff ff       	call   80104440 <kill>
801059c3:	83 c4 10             	add    $0x10,%esp
}
801059c6:	c9                   	leave  
801059c7:	c3                   	ret    
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <sys_getpid>:

int
sys_getpid(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059e6:	e8 b5 e0 ff ff       	call   80103aa0 <myproc>
801059eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059ee:	c9                   	leave  
801059ef:	c3                   	ret    

801059f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 0e f2 ff ff       	call   80104c10 <argint>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 27                	js     80105a30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a09:	e8 92 e0 ff ff       	call   80103aa0 <myproc>
  if(growproc(n) < 0)
80105a0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a13:	ff 75 f4             	pushl  -0xc(%ebp)
80105a16:	e8 c5 e1 ff ff       	call   80103be0 <growproc>
80105a1b:	83 c4 10             	add    $0x10,%esp
80105a1e:	85 c0                	test   %eax,%eax
80105a20:	78 0e                	js     80105a30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a22:	89 d8                	mov    %ebx,%eax
80105a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a27:	c9                   	leave  
80105a28:	c3                   	ret    
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a35:	eb eb                	jmp    80105a22 <sys_sbrk+0x32>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_sleep>:

int
sys_sleep(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a4a:	50                   	push   %eax
80105a4b:	6a 00                	push   $0x0
80105a4d:	e8 be f1 ff ff       	call   80104c10 <argint>
80105a52:	83 c4 10             	add    $0x10,%esp
80105a55:	85 c0                	test   %eax,%eax
80105a57:	0f 88 8a 00 00 00    	js     80105ae7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
80105a60:	68 60 50 11 80       	push   $0x80115060
80105a65:	e8 96 ed ff ff       	call   80104800 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a6d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a70:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
80105a76:	85 d2                	test   %edx,%edx
80105a78:	75 27                	jne    80105aa1 <sys_sleep+0x61>
80105a7a:	eb 54                	jmp    80105ad0 <sys_sleep+0x90>
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a80:	83 ec 08             	sub    $0x8,%esp
80105a83:	68 60 50 11 80       	push   $0x80115060
80105a88:	68 a0 58 11 80       	push   $0x801158a0
80105a8d:	e8 8e e7 ff ff       	call   80104220 <sleep>
  while(ticks - ticks0 < n){
80105a92:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	29 d8                	sub    %ebx,%eax
80105a9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a9f:	73 2f                	jae    80105ad0 <sys_sleep+0x90>
    if(myproc()->killed){
80105aa1:	e8 fa df ff ff       	call   80103aa0 <myproc>
80105aa6:	8b 40 24             	mov    0x24(%eax),%eax
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	74 d3                	je     80105a80 <sys_sleep+0x40>
      release(&tickslock);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	68 60 50 11 80       	push   $0x80115060
80105ab5:	e8 06 ee ff ff       	call   801048c0 <release>
      return -1;
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	68 60 50 11 80       	push   $0x80115060
80105ad8:	e8 e3 ed ff ff       	call   801048c0 <release>
  return 0;
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	31 c0                	xor    %eax,%eax
}
80105ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
    return -1;
80105ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aec:	eb f4                	jmp    80105ae2 <sys_sleep+0xa2>
80105aee:	66 90                	xchg   %ax,%ax

80105af0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	53                   	push   %ebx
80105af4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105af7:	68 60 50 11 80       	push   $0x80115060
80105afc:	e8 ff ec ff ff       	call   80104800 <acquire>
  xticks = ticks;
80105b01:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
80105b07:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105b0e:	e8 ad ed ff ff       	call   801048c0 <release>
  return xticks;
}
80105b13:	89 d8                	mov    %ebx,%eax
80105b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b18:	c9                   	leave  
80105b19:	c3                   	ret    
80105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b20 <sys_setpri>:
int
sys_setpri(void){
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 20             	sub    $0x20,%esp
  int priority;
  if(argint(0, &priority) < 0){
80105b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b29:	50                   	push   %eax
80105b2a:	6a 00                	push   $0x0
80105b2c:	e8 df f0 ff ff       	call   80104c10 <argint>
80105b31:	83 c4 10             	add    $0x10,%esp
80105b34:	85 c0                	test   %eax,%eax
80105b36:	78 18                	js     80105b50 <sys_setpri+0x30>
  return -1;
  }
  return setpri(priority);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b3e:	e8 ad e3 ff ff       	call   80103ef0 <setpri>
80105b43:	83 c4 10             	add    $0x10,%esp
}
80105b46:	c9                   	leave  
80105b47:	c3                   	ret    
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <sys_getpinfo>:
int
sys_getpinfo(void){
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 1c             	sub    $0x1c,%esp
  struct pstat *ps;
  if(argptr(0, (void*)&ps, sizeof(ps)) < 0){
80105b66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b69:	6a 04                	push   $0x4
80105b6b:	50                   	push   %eax
80105b6c:	6a 00                	push   $0x0
80105b6e:	e8 ed f0 ff ff       	call   80104c60 <argptr>
80105b73:	83 c4 10             	add    $0x10,%esp
80105b76:	85 c0                	test   %eax,%eax
80105b78:	78 16                	js     80105b90 <sys_getpinfo+0x30>
    return -1;
  }
  return getpinfo(ps);
80105b7a:	83 ec 0c             	sub    $0xc,%esp
80105b7d:	ff 75 f4             	pushl  -0xc(%ebp)
80105b80:	e8 db e3 ff ff       	call   80103f60 <getpinfo>
80105b85:	83 c4 10             	add    $0x10,%esp
80105b88:	c9                   	leave  
80105b89:	c3                   	ret    
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    

80105b97 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b97:	1e                   	push   %ds
  pushl %es
80105b98:	06                   	push   %es
  pushl %fs
80105b99:	0f a0                	push   %fs
  pushl %gs
80105b9b:	0f a8                	push   %gs
  pushal
80105b9d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b9e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ba2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ba4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ba6:	54                   	push   %esp
  call trap
80105ba7:	e8 c4 00 00 00       	call   80105c70 <trap>
  addl $4, %esp
80105bac:	83 c4 04             	add    $0x4,%esp

80105baf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105baf:	61                   	popa   
  popl %gs
80105bb0:	0f a9                	pop    %gs
  popl %fs
80105bb2:	0f a1                	pop    %fs
  popl %es
80105bb4:	07                   	pop    %es
  popl %ds
80105bb5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bb6:	83 c4 08             	add    $0x8,%esp
  iret
80105bb9:	cf                   	iret   
80105bba:	66 90                	xchg   %ax,%ax
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bc1:	31 c0                	xor    %eax,%eax
{
80105bc3:	89 e5                	mov    %esp,%ebp
80105bc5:	83 ec 08             	sub    $0x8,%esp
80105bc8:	90                   	nop
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bd0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bd7:	c7 04 c5 a2 50 11 80 	movl   $0x8e000008,-0x7feeaf5e(,%eax,8)
80105bde:	08 00 00 8e 
80105be2:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
80105be9:	80 
80105bea:	c1 ea 10             	shr    $0x10,%edx
80105bed:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
80105bf4:	80 
  for(i = 0; i < 256; i++)
80105bf5:	83 c0 01             	add    $0x1,%eax
80105bf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bfd:	75 d1                	jne    80105bd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bff:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105c04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c07:	c7 05 a2 52 11 80 08 	movl   $0xef000008,0x801152a2
80105c0e:	00 00 ef 
  initlock(&tickslock, "time");
80105c11:	68 01 7c 10 80       	push   $0x80107c01
80105c16:	68 60 50 11 80       	push   $0x80115060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c1b:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80105c21:	c1 e8 10             	shr    $0x10,%eax
80105c24:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6
  initlock(&tickslock, "time");
80105c2a:	e8 91 ea ff ff       	call   801046c0 <initlock>
}
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c40 <idtinit>:

void
idtinit(void)
{
80105c40:	55                   	push   %ebp
  pd[0] = size-1;
80105c41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c46:	89 e5                	mov    %esp,%ebp
80105c48:	83 ec 10             	sub    $0x10,%esp
80105c4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c4f:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
80105c54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c58:	c1 e8 10             	shr    $0x10,%eax
80105c5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	83 ec 1c             	sub    $0x1c,%esp
80105c79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c7c:	8b 47 30             	mov    0x30(%edi),%eax
80105c7f:	83 f8 40             	cmp    $0x40,%eax
80105c82:	0f 84 f0 00 00 00    	je     80105d78 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c88:	83 e8 20             	sub    $0x20,%eax
80105c8b:	83 f8 1f             	cmp    $0x1f,%eax
80105c8e:	77 10                	ja     80105ca0 <trap+0x30>
80105c90:	ff 24 85 a8 7c 10 80 	jmp    *-0x7fef8358(,%eax,4)
80105c97:	89 f6                	mov    %esi,%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ca0:	e8 fb dd ff ff       	call   80103aa0 <myproc>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105caa:	0f 84 14 02 00 00    	je     80105ec4 <trap+0x254>
80105cb0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105cb4:	0f 84 0a 02 00 00    	je     80105ec4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cba:	0f 20 d1             	mov    %cr2,%ecx
80105cbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cc0:	e8 bb dd ff ff       	call   80103a80 <cpuid>
80105cc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cc8:	8b 47 34             	mov    0x34(%edi),%eax
80105ccb:	8b 77 30             	mov    0x30(%edi),%esi
80105cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105cd1:	e8 ca dd ff ff       	call   80103aa0 <myproc>
80105cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cd9:	e8 c2 dd ff ff       	call   80103aa0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ce1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ce4:	51                   	push   %ecx
80105ce5:	53                   	push   %ebx
80105ce6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ce7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cea:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ced:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cf1:	52                   	push   %edx
80105cf2:	ff 70 10             	pushl  0x10(%eax)
80105cf5:	68 64 7c 10 80       	push   $0x80107c64
80105cfa:	e8 61 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cff:	83 c4 20             	add    $0x20,%esp
80105d02:	e8 99 dd ff ff       	call   80103aa0 <myproc>
80105d07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0e:	e8 8d dd ff ff       	call   80103aa0 <myproc>
80105d13:	85 c0                	test   %eax,%eax
80105d15:	74 1d                	je     80105d34 <trap+0xc4>
80105d17:	e8 84 dd ff ff       	call   80103aa0 <myproc>
80105d1c:	8b 50 24             	mov    0x24(%eax),%edx
80105d1f:	85 d2                	test   %edx,%edx
80105d21:	74 11                	je     80105d34 <trap+0xc4>
80105d23:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d27:	83 e0 03             	and    $0x3,%eax
80105d2a:	66 83 f8 03          	cmp    $0x3,%ax
80105d2e:	0f 84 4c 01 00 00    	je     80105e80 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d34:	e8 67 dd ff ff       	call   80103aa0 <myproc>
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 0b                	je     80105d48 <trap+0xd8>
80105d3d:	e8 5e dd ff ff       	call   80103aa0 <myproc>
80105d42:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d46:	74 68                	je     80105db0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d48:	e8 53 dd ff ff       	call   80103aa0 <myproc>
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	74 19                	je     80105d6a <trap+0xfa>
80105d51:	e8 4a dd ff ff       	call   80103aa0 <myproc>
80105d56:	8b 40 24             	mov    0x24(%eax),%eax
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	74 0d                	je     80105d6a <trap+0xfa>
80105d5d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d61:	83 e0 03             	and    $0x3,%eax
80105d64:	66 83 f8 03          	cmp    $0x3,%ax
80105d68:	74 37                	je     80105da1 <trap+0x131>
    exit();
}
80105d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d6d:	5b                   	pop    %ebx
80105d6e:	5e                   	pop    %esi
80105d6f:	5f                   	pop    %edi
80105d70:	5d                   	pop    %ebp
80105d71:	c3                   	ret    
80105d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105d78:	e8 23 dd ff ff       	call   80103aa0 <myproc>
80105d7d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d80:	85 db                	test   %ebx,%ebx
80105d82:	0f 85 e8 00 00 00    	jne    80105e70 <trap+0x200>
    myproc()->tf = tf;
80105d88:	e8 13 dd ff ff       	call   80103aa0 <myproc>
80105d8d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d90:	e8 6b ef ff ff       	call   80104d00 <syscall>
    if(myproc()->killed)
80105d95:	e8 06 dd ff ff       	call   80103aa0 <myproc>
80105d9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d9d:	85 c9                	test   %ecx,%ecx
80105d9f:	74 c9                	je     80105d6a <trap+0xfa>
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
      exit();
80105da8:	e9 f3 e2 ff ff       	jmp    801040a0 <exit>
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105db0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105db4:	75 92                	jne    80105d48 <trap+0xd8>
    yield();
80105db6:	e8 15 e4 ff ff       	call   801041d0 <yield>
80105dbb:	eb 8b                	jmp    80105d48 <trap+0xd8>
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105dc0:	e8 bb dc ff ff       	call   80103a80 <cpuid>
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	0f 84 c3 00 00 00    	je     80105e90 <trap+0x220>
    lapiceoi();
80105dcd:	e8 1e cc ff ff       	call   801029f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 c9 dc ff ff       	call   80103aa0 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 38 ff ff ff    	jne    80105d17 <trap+0xa7>
80105ddf:	e9 50 ff ff ff       	jmp    80105d34 <trap+0xc4>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105de8:	e8 c3 ca ff ff       	call   801028b0 <kbdintr>
    lapiceoi();
80105ded:	e8 fe cb ff ff       	call   801029f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df2:	e8 a9 dc ff ff       	call   80103aa0 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 18 ff ff ff    	jne    80105d17 <trap+0xa7>
80105dff:	e9 30 ff ff ff       	jmp    80105d34 <trap+0xc4>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e08:	e8 53 02 00 00       	call   80106060 <uartintr>
    lapiceoi();
80105e0d:	e8 de cb ff ff       	call   801029f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e12:	e8 89 dc ff ff       	call   80103aa0 <myproc>
80105e17:	85 c0                	test   %eax,%eax
80105e19:	0f 85 f8 fe ff ff    	jne    80105d17 <trap+0xa7>
80105e1f:	e9 10 ff ff ff       	jmp    80105d34 <trap+0xc4>
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e28:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e2c:	8b 77 38             	mov    0x38(%edi),%esi
80105e2f:	e8 4c dc ff ff       	call   80103a80 <cpuid>
80105e34:	56                   	push   %esi
80105e35:	53                   	push   %ebx
80105e36:	50                   	push   %eax
80105e37:	68 0c 7c 10 80       	push   $0x80107c0c
80105e3c:	e8 1f a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105e41:	e8 aa cb ff ff       	call   801029f0 <lapiceoi>
    break;
80105e46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e49:	e8 52 dc ff ff       	call   80103aa0 <myproc>
80105e4e:	85 c0                	test   %eax,%eax
80105e50:	0f 85 c1 fe ff ff    	jne    80105d17 <trap+0xa7>
80105e56:	e9 d9 fe ff ff       	jmp    80105d34 <trap+0xc4>
80105e5b:	90                   	nop
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e60:	e8 bb c4 ff ff       	call   80102320 <ideintr>
80105e65:	e9 63 ff ff ff       	jmp    80105dcd <trap+0x15d>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e70:	e8 2b e2 ff ff       	call   801040a0 <exit>
80105e75:	e9 0e ff ff ff       	jmp    80105d88 <trap+0x118>
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e80:	e8 1b e2 ff ff       	call   801040a0 <exit>
80105e85:	e9 aa fe ff ff       	jmp    80105d34 <trap+0xc4>
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 60 50 11 80       	push   $0x80115060
80105e98:	e8 63 e9 ff ff       	call   80104800 <acquire>
      wakeup(&ticks);
80105e9d:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
      ticks++;
80105ea4:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
80105eab:	e8 30 e5 ff ff       	call   801043e0 <wakeup>
      release(&tickslock);
80105eb0:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105eb7:	e8 04 ea ff ff       	call   801048c0 <release>
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	e9 09 ff ff ff       	jmp    80105dcd <trap+0x15d>
80105ec4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ec7:	e8 b4 db ff ff       	call   80103a80 <cpuid>
80105ecc:	83 ec 0c             	sub    $0xc,%esp
80105ecf:	56                   	push   %esi
80105ed0:	53                   	push   %ebx
80105ed1:	50                   	push   %eax
80105ed2:	ff 77 30             	pushl  0x30(%edi)
80105ed5:	68 30 7c 10 80       	push   $0x80107c30
80105eda:	e8 81 a7 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105edf:	83 c4 14             	add    $0x14,%esp
80105ee2:	68 06 7c 10 80       	push   $0x80107c06
80105ee7:	e8 a4 a4 ff ff       	call   80100390 <panic>
80105eec:	66 90                	xchg   %ax,%ax
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ef0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105ef5:	55                   	push   %ebp
80105ef6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	74 1c                	je     80105f18 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105efc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f02:	a8 01                	test   $0x1,%al
80105f04:	74 12                	je     80105f18 <uartgetc+0x28>
80105f06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f0c:	0f b6 c0             	movzbl %al,%eax
}
80105f0f:	5d                   	pop    %ebp
80105f10:	c3                   	ret    
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f1d:	5d                   	pop    %ebp
80105f1e:	c3                   	ret    
80105f1f:	90                   	nop

80105f20 <uartputc.part.0>:
uartputc(int c)
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	57                   	push   %edi
80105f24:	56                   	push   %esi
80105f25:	53                   	push   %ebx
80105f26:	89 c7                	mov    %eax,%edi
80105f28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f32:	83 ec 0c             	sub    $0xc,%esp
80105f35:	eb 1b                	jmp    80105f52 <uartputc.part.0+0x32>
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	6a 0a                	push   $0xa
80105f45:	e8 c6 ca ff ff       	call   80102a10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	83 eb 01             	sub    $0x1,%ebx
80105f50:	74 07                	je     80105f59 <uartputc.part.0+0x39>
80105f52:	89 f2                	mov    %esi,%edx
80105f54:	ec                   	in     (%dx),%al
80105f55:	a8 20                	test   $0x20,%al
80105f57:	74 e7                	je     80105f40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5e:	89 f8                	mov    %edi,%eax
80105f60:	ee                   	out    %al,(%dx)
}
80105f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f64:	5b                   	pop    %ebx
80105f65:	5e                   	pop    %esi
80105f66:	5f                   	pop    %edi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <uartinit>:
{
80105f70:	55                   	push   %ebp
80105f71:	31 c9                	xor    %ecx,%ecx
80105f73:	89 c8                	mov    %ecx,%eax
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	57                   	push   %edi
80105f78:	56                   	push   %esi
80105f79:	53                   	push   %ebx
80105f7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f7f:	89 da                	mov    %ebx,%edx
80105f81:	83 ec 0c             	sub    $0xc,%esp
80105f84:	ee                   	out    %al,(%dx)
80105f85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f8f:	89 fa                	mov    %edi,%edx
80105f91:	ee                   	out    %al,(%dx)
80105f92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9c:	ee                   	out    %al,(%dx)
80105f9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105fa2:	89 c8                	mov    %ecx,%eax
80105fa4:	89 f2                	mov    %esi,%edx
80105fa6:	ee                   	out    %al,(%dx)
80105fa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fac:	89 fa                	mov    %edi,%edx
80105fae:	ee                   	out    %al,(%dx)
80105faf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fb4:	89 c8                	mov    %ecx,%eax
80105fb6:	ee                   	out    %al,(%dx)
80105fb7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fbc:	89 f2                	mov    %esi,%edx
80105fbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fc4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fc5:	3c ff                	cmp    $0xff,%al
80105fc7:	74 5a                	je     80106023 <uartinit+0xb3>
  uart = 1;
80105fc9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105fd0:	00 00 00 
80105fd3:	89 da                	mov    %ebx,%edx
80105fd5:	ec                   	in     (%dx),%al
80105fd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fdc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fdf:	bb 28 7d 10 80       	mov    $0x80107d28,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fe4:	6a 00                	push   $0x0
80105fe6:	6a 04                	push   $0x4
80105fe8:	e8 83 c5 ff ff       	call   80102570 <ioapicenable>
80105fed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ff0:	b8 78 00 00 00       	mov    $0x78,%eax
80105ff5:	eb 13                	jmp    8010600a <uartinit+0x9a>
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106000:	83 c3 01             	add    $0x1,%ebx
80106003:	0f be 03             	movsbl (%ebx),%eax
80106006:	84 c0                	test   %al,%al
80106008:	74 19                	je     80106023 <uartinit+0xb3>
  if(!uart)
8010600a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80106010:	85 d2                	test   %edx,%edx
80106012:	74 ec                	je     80106000 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106014:	83 c3 01             	add    $0x1,%ebx
80106017:	e8 04 ff ff ff       	call   80105f20 <uartputc.part.0>
8010601c:	0f be 03             	movsbl (%ebx),%eax
8010601f:	84 c0                	test   %al,%al
80106021:	75 e7                	jne    8010600a <uartinit+0x9a>
}
80106023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106026:	5b                   	pop    %ebx
80106027:	5e                   	pop    %esi
80106028:	5f                   	pop    %edi
80106029:	5d                   	pop    %ebp
8010602a:	c3                   	ret    
8010602b:	90                   	nop
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106030 <uartputc>:
  if(!uart)
80106030:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80106036:	55                   	push   %ebp
80106037:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106039:	85 d2                	test   %edx,%edx
{
8010603b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010603e:	74 10                	je     80106050 <uartputc+0x20>
}
80106040:	5d                   	pop    %ebp
80106041:	e9 da fe ff ff       	jmp    80105f20 <uartputc.part.0>
80106046:	8d 76 00             	lea    0x0(%esi),%esi
80106049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106050:	5d                   	pop    %ebp
80106051:	c3                   	ret    
80106052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106060 <uartintr>:

void
uartintr(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106066:	68 f0 5e 10 80       	push   $0x80105ef0
8010606b:	e8 a0 a7 ff ff       	call   80100810 <consoleintr>
}
80106070:	83 c4 10             	add    $0x10,%esp
80106073:	c9                   	leave  
80106074:	c3                   	ret    

80106075 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $0
80106077:	6a 00                	push   $0x0
  jmp alltraps
80106079:	e9 19 fb ff ff       	jmp    80105b97 <alltraps>

8010607e <vector1>:
.globl vector1
vector1:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $1
80106080:	6a 01                	push   $0x1
  jmp alltraps
80106082:	e9 10 fb ff ff       	jmp    80105b97 <alltraps>

80106087 <vector2>:
.globl vector2
vector2:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $2
80106089:	6a 02                	push   $0x2
  jmp alltraps
8010608b:	e9 07 fb ff ff       	jmp    80105b97 <alltraps>

80106090 <vector3>:
.globl vector3
vector3:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $3
80106092:	6a 03                	push   $0x3
  jmp alltraps
80106094:	e9 fe fa ff ff       	jmp    80105b97 <alltraps>

80106099 <vector4>:
.globl vector4
vector4:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $4
8010609b:	6a 04                	push   $0x4
  jmp alltraps
8010609d:	e9 f5 fa ff ff       	jmp    80105b97 <alltraps>

801060a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $5
801060a4:	6a 05                	push   $0x5
  jmp alltraps
801060a6:	e9 ec fa ff ff       	jmp    80105b97 <alltraps>

801060ab <vector6>:
.globl vector6
vector6:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $6
801060ad:	6a 06                	push   $0x6
  jmp alltraps
801060af:	e9 e3 fa ff ff       	jmp    80105b97 <alltraps>

801060b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $7
801060b6:	6a 07                	push   $0x7
  jmp alltraps
801060b8:	e9 da fa ff ff       	jmp    80105b97 <alltraps>

801060bd <vector8>:
.globl vector8
vector8:
  pushl $8
801060bd:	6a 08                	push   $0x8
  jmp alltraps
801060bf:	e9 d3 fa ff ff       	jmp    80105b97 <alltraps>

801060c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $9
801060c6:	6a 09                	push   $0x9
  jmp alltraps
801060c8:	e9 ca fa ff ff       	jmp    80105b97 <alltraps>

801060cd <vector10>:
.globl vector10
vector10:
  pushl $10
801060cd:	6a 0a                	push   $0xa
  jmp alltraps
801060cf:	e9 c3 fa ff ff       	jmp    80105b97 <alltraps>

801060d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060d4:	6a 0b                	push   $0xb
  jmp alltraps
801060d6:	e9 bc fa ff ff       	jmp    80105b97 <alltraps>

801060db <vector12>:
.globl vector12
vector12:
  pushl $12
801060db:	6a 0c                	push   $0xc
  jmp alltraps
801060dd:	e9 b5 fa ff ff       	jmp    80105b97 <alltraps>

801060e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060e2:	6a 0d                	push   $0xd
  jmp alltraps
801060e4:	e9 ae fa ff ff       	jmp    80105b97 <alltraps>

801060e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060e9:	6a 0e                	push   $0xe
  jmp alltraps
801060eb:	e9 a7 fa ff ff       	jmp    80105b97 <alltraps>

801060f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $15
801060f2:	6a 0f                	push   $0xf
  jmp alltraps
801060f4:	e9 9e fa ff ff       	jmp    80105b97 <alltraps>

801060f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $16
801060fb:	6a 10                	push   $0x10
  jmp alltraps
801060fd:	e9 95 fa ff ff       	jmp    80105b97 <alltraps>

80106102 <vector17>:
.globl vector17
vector17:
  pushl $17
80106102:	6a 11                	push   $0x11
  jmp alltraps
80106104:	e9 8e fa ff ff       	jmp    80105b97 <alltraps>

80106109 <vector18>:
.globl vector18
vector18:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $18
8010610b:	6a 12                	push   $0x12
  jmp alltraps
8010610d:	e9 85 fa ff ff       	jmp    80105b97 <alltraps>

80106112 <vector19>:
.globl vector19
vector19:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $19
80106114:	6a 13                	push   $0x13
  jmp alltraps
80106116:	e9 7c fa ff ff       	jmp    80105b97 <alltraps>

8010611b <vector20>:
.globl vector20
vector20:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $20
8010611d:	6a 14                	push   $0x14
  jmp alltraps
8010611f:	e9 73 fa ff ff       	jmp    80105b97 <alltraps>

80106124 <vector21>:
.globl vector21
vector21:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $21
80106126:	6a 15                	push   $0x15
  jmp alltraps
80106128:	e9 6a fa ff ff       	jmp    80105b97 <alltraps>

8010612d <vector22>:
.globl vector22
vector22:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $22
8010612f:	6a 16                	push   $0x16
  jmp alltraps
80106131:	e9 61 fa ff ff       	jmp    80105b97 <alltraps>

80106136 <vector23>:
.globl vector23
vector23:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $23
80106138:	6a 17                	push   $0x17
  jmp alltraps
8010613a:	e9 58 fa ff ff       	jmp    80105b97 <alltraps>

8010613f <vector24>:
.globl vector24
vector24:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $24
80106141:	6a 18                	push   $0x18
  jmp alltraps
80106143:	e9 4f fa ff ff       	jmp    80105b97 <alltraps>

80106148 <vector25>:
.globl vector25
vector25:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $25
8010614a:	6a 19                	push   $0x19
  jmp alltraps
8010614c:	e9 46 fa ff ff       	jmp    80105b97 <alltraps>

80106151 <vector26>:
.globl vector26
vector26:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $26
80106153:	6a 1a                	push   $0x1a
  jmp alltraps
80106155:	e9 3d fa ff ff       	jmp    80105b97 <alltraps>

8010615a <vector27>:
.globl vector27
vector27:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $27
8010615c:	6a 1b                	push   $0x1b
  jmp alltraps
8010615e:	e9 34 fa ff ff       	jmp    80105b97 <alltraps>

80106163 <vector28>:
.globl vector28
vector28:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $28
80106165:	6a 1c                	push   $0x1c
  jmp alltraps
80106167:	e9 2b fa ff ff       	jmp    80105b97 <alltraps>

8010616c <vector29>:
.globl vector29
vector29:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $29
8010616e:	6a 1d                	push   $0x1d
  jmp alltraps
80106170:	e9 22 fa ff ff       	jmp    80105b97 <alltraps>

80106175 <vector30>:
.globl vector30
vector30:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $30
80106177:	6a 1e                	push   $0x1e
  jmp alltraps
80106179:	e9 19 fa ff ff       	jmp    80105b97 <alltraps>

8010617e <vector31>:
.globl vector31
vector31:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $31
80106180:	6a 1f                	push   $0x1f
  jmp alltraps
80106182:	e9 10 fa ff ff       	jmp    80105b97 <alltraps>

80106187 <vector32>:
.globl vector32
vector32:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $32
80106189:	6a 20                	push   $0x20
  jmp alltraps
8010618b:	e9 07 fa ff ff       	jmp    80105b97 <alltraps>

80106190 <vector33>:
.globl vector33
vector33:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $33
80106192:	6a 21                	push   $0x21
  jmp alltraps
80106194:	e9 fe f9 ff ff       	jmp    80105b97 <alltraps>

80106199 <vector34>:
.globl vector34
vector34:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $34
8010619b:	6a 22                	push   $0x22
  jmp alltraps
8010619d:	e9 f5 f9 ff ff       	jmp    80105b97 <alltraps>

801061a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $35
801061a4:	6a 23                	push   $0x23
  jmp alltraps
801061a6:	e9 ec f9 ff ff       	jmp    80105b97 <alltraps>

801061ab <vector36>:
.globl vector36
vector36:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $36
801061ad:	6a 24                	push   $0x24
  jmp alltraps
801061af:	e9 e3 f9 ff ff       	jmp    80105b97 <alltraps>

801061b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $37
801061b6:	6a 25                	push   $0x25
  jmp alltraps
801061b8:	e9 da f9 ff ff       	jmp    80105b97 <alltraps>

801061bd <vector38>:
.globl vector38
vector38:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $38
801061bf:	6a 26                	push   $0x26
  jmp alltraps
801061c1:	e9 d1 f9 ff ff       	jmp    80105b97 <alltraps>

801061c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $39
801061c8:	6a 27                	push   $0x27
  jmp alltraps
801061ca:	e9 c8 f9 ff ff       	jmp    80105b97 <alltraps>

801061cf <vector40>:
.globl vector40
vector40:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $40
801061d1:	6a 28                	push   $0x28
  jmp alltraps
801061d3:	e9 bf f9 ff ff       	jmp    80105b97 <alltraps>

801061d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $41
801061da:	6a 29                	push   $0x29
  jmp alltraps
801061dc:	e9 b6 f9 ff ff       	jmp    80105b97 <alltraps>

801061e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $42
801061e3:	6a 2a                	push   $0x2a
  jmp alltraps
801061e5:	e9 ad f9 ff ff       	jmp    80105b97 <alltraps>

801061ea <vector43>:
.globl vector43
vector43:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $43
801061ec:	6a 2b                	push   $0x2b
  jmp alltraps
801061ee:	e9 a4 f9 ff ff       	jmp    80105b97 <alltraps>

801061f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $44
801061f5:	6a 2c                	push   $0x2c
  jmp alltraps
801061f7:	e9 9b f9 ff ff       	jmp    80105b97 <alltraps>

801061fc <vector45>:
.globl vector45
vector45:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $45
801061fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106200:	e9 92 f9 ff ff       	jmp    80105b97 <alltraps>

80106205 <vector46>:
.globl vector46
vector46:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $46
80106207:	6a 2e                	push   $0x2e
  jmp alltraps
80106209:	e9 89 f9 ff ff       	jmp    80105b97 <alltraps>

8010620e <vector47>:
.globl vector47
vector47:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $47
80106210:	6a 2f                	push   $0x2f
  jmp alltraps
80106212:	e9 80 f9 ff ff       	jmp    80105b97 <alltraps>

80106217 <vector48>:
.globl vector48
vector48:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $48
80106219:	6a 30                	push   $0x30
  jmp alltraps
8010621b:	e9 77 f9 ff ff       	jmp    80105b97 <alltraps>

80106220 <vector49>:
.globl vector49
vector49:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $49
80106222:	6a 31                	push   $0x31
  jmp alltraps
80106224:	e9 6e f9 ff ff       	jmp    80105b97 <alltraps>

80106229 <vector50>:
.globl vector50
vector50:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $50
8010622b:	6a 32                	push   $0x32
  jmp alltraps
8010622d:	e9 65 f9 ff ff       	jmp    80105b97 <alltraps>

80106232 <vector51>:
.globl vector51
vector51:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $51
80106234:	6a 33                	push   $0x33
  jmp alltraps
80106236:	e9 5c f9 ff ff       	jmp    80105b97 <alltraps>

8010623b <vector52>:
.globl vector52
vector52:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $52
8010623d:	6a 34                	push   $0x34
  jmp alltraps
8010623f:	e9 53 f9 ff ff       	jmp    80105b97 <alltraps>

80106244 <vector53>:
.globl vector53
vector53:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $53
80106246:	6a 35                	push   $0x35
  jmp alltraps
80106248:	e9 4a f9 ff ff       	jmp    80105b97 <alltraps>

8010624d <vector54>:
.globl vector54
vector54:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $54
8010624f:	6a 36                	push   $0x36
  jmp alltraps
80106251:	e9 41 f9 ff ff       	jmp    80105b97 <alltraps>

80106256 <vector55>:
.globl vector55
vector55:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $55
80106258:	6a 37                	push   $0x37
  jmp alltraps
8010625a:	e9 38 f9 ff ff       	jmp    80105b97 <alltraps>

8010625f <vector56>:
.globl vector56
vector56:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $56
80106261:	6a 38                	push   $0x38
  jmp alltraps
80106263:	e9 2f f9 ff ff       	jmp    80105b97 <alltraps>

80106268 <vector57>:
.globl vector57
vector57:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $57
8010626a:	6a 39                	push   $0x39
  jmp alltraps
8010626c:	e9 26 f9 ff ff       	jmp    80105b97 <alltraps>

80106271 <vector58>:
.globl vector58
vector58:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $58
80106273:	6a 3a                	push   $0x3a
  jmp alltraps
80106275:	e9 1d f9 ff ff       	jmp    80105b97 <alltraps>

8010627a <vector59>:
.globl vector59
vector59:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $59
8010627c:	6a 3b                	push   $0x3b
  jmp alltraps
8010627e:	e9 14 f9 ff ff       	jmp    80105b97 <alltraps>

80106283 <vector60>:
.globl vector60
vector60:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $60
80106285:	6a 3c                	push   $0x3c
  jmp alltraps
80106287:	e9 0b f9 ff ff       	jmp    80105b97 <alltraps>

8010628c <vector61>:
.globl vector61
vector61:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $61
8010628e:	6a 3d                	push   $0x3d
  jmp alltraps
80106290:	e9 02 f9 ff ff       	jmp    80105b97 <alltraps>

80106295 <vector62>:
.globl vector62
vector62:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $62
80106297:	6a 3e                	push   $0x3e
  jmp alltraps
80106299:	e9 f9 f8 ff ff       	jmp    80105b97 <alltraps>

8010629e <vector63>:
.globl vector63
vector63:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $63
801062a0:	6a 3f                	push   $0x3f
  jmp alltraps
801062a2:	e9 f0 f8 ff ff       	jmp    80105b97 <alltraps>

801062a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $64
801062a9:	6a 40                	push   $0x40
  jmp alltraps
801062ab:	e9 e7 f8 ff ff       	jmp    80105b97 <alltraps>

801062b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $65
801062b2:	6a 41                	push   $0x41
  jmp alltraps
801062b4:	e9 de f8 ff ff       	jmp    80105b97 <alltraps>

801062b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $66
801062bb:	6a 42                	push   $0x42
  jmp alltraps
801062bd:	e9 d5 f8 ff ff       	jmp    80105b97 <alltraps>

801062c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $67
801062c4:	6a 43                	push   $0x43
  jmp alltraps
801062c6:	e9 cc f8 ff ff       	jmp    80105b97 <alltraps>

801062cb <vector68>:
.globl vector68
vector68:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $68
801062cd:	6a 44                	push   $0x44
  jmp alltraps
801062cf:	e9 c3 f8 ff ff       	jmp    80105b97 <alltraps>

801062d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $69
801062d6:	6a 45                	push   $0x45
  jmp alltraps
801062d8:	e9 ba f8 ff ff       	jmp    80105b97 <alltraps>

801062dd <vector70>:
.globl vector70
vector70:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $70
801062df:	6a 46                	push   $0x46
  jmp alltraps
801062e1:	e9 b1 f8 ff ff       	jmp    80105b97 <alltraps>

801062e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $71
801062e8:	6a 47                	push   $0x47
  jmp alltraps
801062ea:	e9 a8 f8 ff ff       	jmp    80105b97 <alltraps>

801062ef <vector72>:
.globl vector72
vector72:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $72
801062f1:	6a 48                	push   $0x48
  jmp alltraps
801062f3:	e9 9f f8 ff ff       	jmp    80105b97 <alltraps>

801062f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $73
801062fa:	6a 49                	push   $0x49
  jmp alltraps
801062fc:	e9 96 f8 ff ff       	jmp    80105b97 <alltraps>

80106301 <vector74>:
.globl vector74
vector74:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $74
80106303:	6a 4a                	push   $0x4a
  jmp alltraps
80106305:	e9 8d f8 ff ff       	jmp    80105b97 <alltraps>

8010630a <vector75>:
.globl vector75
vector75:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $75
8010630c:	6a 4b                	push   $0x4b
  jmp alltraps
8010630e:	e9 84 f8 ff ff       	jmp    80105b97 <alltraps>

80106313 <vector76>:
.globl vector76
vector76:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $76
80106315:	6a 4c                	push   $0x4c
  jmp alltraps
80106317:	e9 7b f8 ff ff       	jmp    80105b97 <alltraps>

8010631c <vector77>:
.globl vector77
vector77:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $77
8010631e:	6a 4d                	push   $0x4d
  jmp alltraps
80106320:	e9 72 f8 ff ff       	jmp    80105b97 <alltraps>

80106325 <vector78>:
.globl vector78
vector78:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $78
80106327:	6a 4e                	push   $0x4e
  jmp alltraps
80106329:	e9 69 f8 ff ff       	jmp    80105b97 <alltraps>

8010632e <vector79>:
.globl vector79
vector79:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $79
80106330:	6a 4f                	push   $0x4f
  jmp alltraps
80106332:	e9 60 f8 ff ff       	jmp    80105b97 <alltraps>

80106337 <vector80>:
.globl vector80
vector80:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $80
80106339:	6a 50                	push   $0x50
  jmp alltraps
8010633b:	e9 57 f8 ff ff       	jmp    80105b97 <alltraps>

80106340 <vector81>:
.globl vector81
vector81:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $81
80106342:	6a 51                	push   $0x51
  jmp alltraps
80106344:	e9 4e f8 ff ff       	jmp    80105b97 <alltraps>

80106349 <vector82>:
.globl vector82
vector82:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $82
8010634b:	6a 52                	push   $0x52
  jmp alltraps
8010634d:	e9 45 f8 ff ff       	jmp    80105b97 <alltraps>

80106352 <vector83>:
.globl vector83
vector83:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $83
80106354:	6a 53                	push   $0x53
  jmp alltraps
80106356:	e9 3c f8 ff ff       	jmp    80105b97 <alltraps>

8010635b <vector84>:
.globl vector84
vector84:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $84
8010635d:	6a 54                	push   $0x54
  jmp alltraps
8010635f:	e9 33 f8 ff ff       	jmp    80105b97 <alltraps>

80106364 <vector85>:
.globl vector85
vector85:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $85
80106366:	6a 55                	push   $0x55
  jmp alltraps
80106368:	e9 2a f8 ff ff       	jmp    80105b97 <alltraps>

8010636d <vector86>:
.globl vector86
vector86:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $86
8010636f:	6a 56                	push   $0x56
  jmp alltraps
80106371:	e9 21 f8 ff ff       	jmp    80105b97 <alltraps>

80106376 <vector87>:
.globl vector87
vector87:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $87
80106378:	6a 57                	push   $0x57
  jmp alltraps
8010637a:	e9 18 f8 ff ff       	jmp    80105b97 <alltraps>

8010637f <vector88>:
.globl vector88
vector88:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $88
80106381:	6a 58                	push   $0x58
  jmp alltraps
80106383:	e9 0f f8 ff ff       	jmp    80105b97 <alltraps>

80106388 <vector89>:
.globl vector89
vector89:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $89
8010638a:	6a 59                	push   $0x59
  jmp alltraps
8010638c:	e9 06 f8 ff ff       	jmp    80105b97 <alltraps>

80106391 <vector90>:
.globl vector90
vector90:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $90
80106393:	6a 5a                	push   $0x5a
  jmp alltraps
80106395:	e9 fd f7 ff ff       	jmp    80105b97 <alltraps>

8010639a <vector91>:
.globl vector91
vector91:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $91
8010639c:	6a 5b                	push   $0x5b
  jmp alltraps
8010639e:	e9 f4 f7 ff ff       	jmp    80105b97 <alltraps>

801063a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $92
801063a5:	6a 5c                	push   $0x5c
  jmp alltraps
801063a7:	e9 eb f7 ff ff       	jmp    80105b97 <alltraps>

801063ac <vector93>:
.globl vector93
vector93:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $93
801063ae:	6a 5d                	push   $0x5d
  jmp alltraps
801063b0:	e9 e2 f7 ff ff       	jmp    80105b97 <alltraps>

801063b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $94
801063b7:	6a 5e                	push   $0x5e
  jmp alltraps
801063b9:	e9 d9 f7 ff ff       	jmp    80105b97 <alltraps>

801063be <vector95>:
.globl vector95
vector95:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $95
801063c0:	6a 5f                	push   $0x5f
  jmp alltraps
801063c2:	e9 d0 f7 ff ff       	jmp    80105b97 <alltraps>

801063c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $96
801063c9:	6a 60                	push   $0x60
  jmp alltraps
801063cb:	e9 c7 f7 ff ff       	jmp    80105b97 <alltraps>

801063d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $97
801063d2:	6a 61                	push   $0x61
  jmp alltraps
801063d4:	e9 be f7 ff ff       	jmp    80105b97 <alltraps>

801063d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $98
801063db:	6a 62                	push   $0x62
  jmp alltraps
801063dd:	e9 b5 f7 ff ff       	jmp    80105b97 <alltraps>

801063e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $99
801063e4:	6a 63                	push   $0x63
  jmp alltraps
801063e6:	e9 ac f7 ff ff       	jmp    80105b97 <alltraps>

801063eb <vector100>:
.globl vector100
vector100:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $100
801063ed:	6a 64                	push   $0x64
  jmp alltraps
801063ef:	e9 a3 f7 ff ff       	jmp    80105b97 <alltraps>

801063f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $101
801063f6:	6a 65                	push   $0x65
  jmp alltraps
801063f8:	e9 9a f7 ff ff       	jmp    80105b97 <alltraps>

801063fd <vector102>:
.globl vector102
vector102:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $102
801063ff:	6a 66                	push   $0x66
  jmp alltraps
80106401:	e9 91 f7 ff ff       	jmp    80105b97 <alltraps>

80106406 <vector103>:
.globl vector103
vector103:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $103
80106408:	6a 67                	push   $0x67
  jmp alltraps
8010640a:	e9 88 f7 ff ff       	jmp    80105b97 <alltraps>

8010640f <vector104>:
.globl vector104
vector104:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $104
80106411:	6a 68                	push   $0x68
  jmp alltraps
80106413:	e9 7f f7 ff ff       	jmp    80105b97 <alltraps>

80106418 <vector105>:
.globl vector105
vector105:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $105
8010641a:	6a 69                	push   $0x69
  jmp alltraps
8010641c:	e9 76 f7 ff ff       	jmp    80105b97 <alltraps>

80106421 <vector106>:
.globl vector106
vector106:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $106
80106423:	6a 6a                	push   $0x6a
  jmp alltraps
80106425:	e9 6d f7 ff ff       	jmp    80105b97 <alltraps>

8010642a <vector107>:
.globl vector107
vector107:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $107
8010642c:	6a 6b                	push   $0x6b
  jmp alltraps
8010642e:	e9 64 f7 ff ff       	jmp    80105b97 <alltraps>

80106433 <vector108>:
.globl vector108
vector108:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $108
80106435:	6a 6c                	push   $0x6c
  jmp alltraps
80106437:	e9 5b f7 ff ff       	jmp    80105b97 <alltraps>

8010643c <vector109>:
.globl vector109
vector109:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $109
8010643e:	6a 6d                	push   $0x6d
  jmp alltraps
80106440:	e9 52 f7 ff ff       	jmp    80105b97 <alltraps>

80106445 <vector110>:
.globl vector110
vector110:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $110
80106447:	6a 6e                	push   $0x6e
  jmp alltraps
80106449:	e9 49 f7 ff ff       	jmp    80105b97 <alltraps>

8010644e <vector111>:
.globl vector111
vector111:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $111
80106450:	6a 6f                	push   $0x6f
  jmp alltraps
80106452:	e9 40 f7 ff ff       	jmp    80105b97 <alltraps>

80106457 <vector112>:
.globl vector112
vector112:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $112
80106459:	6a 70                	push   $0x70
  jmp alltraps
8010645b:	e9 37 f7 ff ff       	jmp    80105b97 <alltraps>

80106460 <vector113>:
.globl vector113
vector113:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $113
80106462:	6a 71                	push   $0x71
  jmp alltraps
80106464:	e9 2e f7 ff ff       	jmp    80105b97 <alltraps>

80106469 <vector114>:
.globl vector114
vector114:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $114
8010646b:	6a 72                	push   $0x72
  jmp alltraps
8010646d:	e9 25 f7 ff ff       	jmp    80105b97 <alltraps>

80106472 <vector115>:
.globl vector115
vector115:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $115
80106474:	6a 73                	push   $0x73
  jmp alltraps
80106476:	e9 1c f7 ff ff       	jmp    80105b97 <alltraps>

8010647b <vector116>:
.globl vector116
vector116:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $116
8010647d:	6a 74                	push   $0x74
  jmp alltraps
8010647f:	e9 13 f7 ff ff       	jmp    80105b97 <alltraps>

80106484 <vector117>:
.globl vector117
vector117:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $117
80106486:	6a 75                	push   $0x75
  jmp alltraps
80106488:	e9 0a f7 ff ff       	jmp    80105b97 <alltraps>

8010648d <vector118>:
.globl vector118
vector118:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $118
8010648f:	6a 76                	push   $0x76
  jmp alltraps
80106491:	e9 01 f7 ff ff       	jmp    80105b97 <alltraps>

80106496 <vector119>:
.globl vector119
vector119:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $119
80106498:	6a 77                	push   $0x77
  jmp alltraps
8010649a:	e9 f8 f6 ff ff       	jmp    80105b97 <alltraps>

8010649f <vector120>:
.globl vector120
vector120:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $120
801064a1:	6a 78                	push   $0x78
  jmp alltraps
801064a3:	e9 ef f6 ff ff       	jmp    80105b97 <alltraps>

801064a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $121
801064aa:	6a 79                	push   $0x79
  jmp alltraps
801064ac:	e9 e6 f6 ff ff       	jmp    80105b97 <alltraps>

801064b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $122
801064b3:	6a 7a                	push   $0x7a
  jmp alltraps
801064b5:	e9 dd f6 ff ff       	jmp    80105b97 <alltraps>

801064ba <vector123>:
.globl vector123
vector123:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $123
801064bc:	6a 7b                	push   $0x7b
  jmp alltraps
801064be:	e9 d4 f6 ff ff       	jmp    80105b97 <alltraps>

801064c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $124
801064c5:	6a 7c                	push   $0x7c
  jmp alltraps
801064c7:	e9 cb f6 ff ff       	jmp    80105b97 <alltraps>

801064cc <vector125>:
.globl vector125
vector125:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $125
801064ce:	6a 7d                	push   $0x7d
  jmp alltraps
801064d0:	e9 c2 f6 ff ff       	jmp    80105b97 <alltraps>

801064d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $126
801064d7:	6a 7e                	push   $0x7e
  jmp alltraps
801064d9:	e9 b9 f6 ff ff       	jmp    80105b97 <alltraps>

801064de <vector127>:
.globl vector127
vector127:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $127
801064e0:	6a 7f                	push   $0x7f
  jmp alltraps
801064e2:	e9 b0 f6 ff ff       	jmp    80105b97 <alltraps>

801064e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $128
801064e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ee:	e9 a4 f6 ff ff       	jmp    80105b97 <alltraps>

801064f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $129
801064f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064fa:	e9 98 f6 ff ff       	jmp    80105b97 <alltraps>

801064ff <vector130>:
.globl vector130
vector130:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $130
80106501:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106506:	e9 8c f6 ff ff       	jmp    80105b97 <alltraps>

8010650b <vector131>:
.globl vector131
vector131:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $131
8010650d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106512:	e9 80 f6 ff ff       	jmp    80105b97 <alltraps>

80106517 <vector132>:
.globl vector132
vector132:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $132
80106519:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010651e:	e9 74 f6 ff ff       	jmp    80105b97 <alltraps>

80106523 <vector133>:
.globl vector133
vector133:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $133
80106525:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010652a:	e9 68 f6 ff ff       	jmp    80105b97 <alltraps>

8010652f <vector134>:
.globl vector134
vector134:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $134
80106531:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106536:	e9 5c f6 ff ff       	jmp    80105b97 <alltraps>

8010653b <vector135>:
.globl vector135
vector135:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $135
8010653d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106542:	e9 50 f6 ff ff       	jmp    80105b97 <alltraps>

80106547 <vector136>:
.globl vector136
vector136:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $136
80106549:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010654e:	e9 44 f6 ff ff       	jmp    80105b97 <alltraps>

80106553 <vector137>:
.globl vector137
vector137:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $137
80106555:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010655a:	e9 38 f6 ff ff       	jmp    80105b97 <alltraps>

8010655f <vector138>:
.globl vector138
vector138:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $138
80106561:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106566:	e9 2c f6 ff ff       	jmp    80105b97 <alltraps>

8010656b <vector139>:
.globl vector139
vector139:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $139
8010656d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106572:	e9 20 f6 ff ff       	jmp    80105b97 <alltraps>

80106577 <vector140>:
.globl vector140
vector140:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $140
80106579:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010657e:	e9 14 f6 ff ff       	jmp    80105b97 <alltraps>

80106583 <vector141>:
.globl vector141
vector141:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $141
80106585:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010658a:	e9 08 f6 ff ff       	jmp    80105b97 <alltraps>

8010658f <vector142>:
.globl vector142
vector142:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $142
80106591:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106596:	e9 fc f5 ff ff       	jmp    80105b97 <alltraps>

8010659b <vector143>:
.globl vector143
vector143:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $143
8010659d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065a2:	e9 f0 f5 ff ff       	jmp    80105b97 <alltraps>

801065a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $144
801065a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ae:	e9 e4 f5 ff ff       	jmp    80105b97 <alltraps>

801065b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $145
801065b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065ba:	e9 d8 f5 ff ff       	jmp    80105b97 <alltraps>

801065bf <vector146>:
.globl vector146
vector146:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $146
801065c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065c6:	e9 cc f5 ff ff       	jmp    80105b97 <alltraps>

801065cb <vector147>:
.globl vector147
vector147:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $147
801065cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065d2:	e9 c0 f5 ff ff       	jmp    80105b97 <alltraps>

801065d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $148
801065d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065de:	e9 b4 f5 ff ff       	jmp    80105b97 <alltraps>

801065e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $149
801065e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ea:	e9 a8 f5 ff ff       	jmp    80105b97 <alltraps>

801065ef <vector150>:
.globl vector150
vector150:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $150
801065f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065f6:	e9 9c f5 ff ff       	jmp    80105b97 <alltraps>

801065fb <vector151>:
.globl vector151
vector151:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $151
801065fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106602:	e9 90 f5 ff ff       	jmp    80105b97 <alltraps>

80106607 <vector152>:
.globl vector152
vector152:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $152
80106609:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010660e:	e9 84 f5 ff ff       	jmp    80105b97 <alltraps>

80106613 <vector153>:
.globl vector153
vector153:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $153
80106615:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010661a:	e9 78 f5 ff ff       	jmp    80105b97 <alltraps>

8010661f <vector154>:
.globl vector154
vector154:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $154
80106621:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106626:	e9 6c f5 ff ff       	jmp    80105b97 <alltraps>

8010662b <vector155>:
.globl vector155
vector155:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $155
8010662d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106632:	e9 60 f5 ff ff       	jmp    80105b97 <alltraps>

80106637 <vector156>:
.globl vector156
vector156:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $156
80106639:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010663e:	e9 54 f5 ff ff       	jmp    80105b97 <alltraps>

80106643 <vector157>:
.globl vector157
vector157:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $157
80106645:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010664a:	e9 48 f5 ff ff       	jmp    80105b97 <alltraps>

8010664f <vector158>:
.globl vector158
vector158:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $158
80106651:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106656:	e9 3c f5 ff ff       	jmp    80105b97 <alltraps>

8010665b <vector159>:
.globl vector159
vector159:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $159
8010665d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106662:	e9 30 f5 ff ff       	jmp    80105b97 <alltraps>

80106667 <vector160>:
.globl vector160
vector160:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $160
80106669:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010666e:	e9 24 f5 ff ff       	jmp    80105b97 <alltraps>

80106673 <vector161>:
.globl vector161
vector161:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $161
80106675:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010667a:	e9 18 f5 ff ff       	jmp    80105b97 <alltraps>

8010667f <vector162>:
.globl vector162
vector162:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $162
80106681:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106686:	e9 0c f5 ff ff       	jmp    80105b97 <alltraps>

8010668b <vector163>:
.globl vector163
vector163:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $163
8010668d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106692:	e9 00 f5 ff ff       	jmp    80105b97 <alltraps>

80106697 <vector164>:
.globl vector164
vector164:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $164
80106699:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010669e:	e9 f4 f4 ff ff       	jmp    80105b97 <alltraps>

801066a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $165
801066a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066aa:	e9 e8 f4 ff ff       	jmp    80105b97 <alltraps>

801066af <vector166>:
.globl vector166
vector166:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $166
801066b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066b6:	e9 dc f4 ff ff       	jmp    80105b97 <alltraps>

801066bb <vector167>:
.globl vector167
vector167:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $167
801066bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066c2:	e9 d0 f4 ff ff       	jmp    80105b97 <alltraps>

801066c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $168
801066c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ce:	e9 c4 f4 ff ff       	jmp    80105b97 <alltraps>

801066d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $169
801066d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066da:	e9 b8 f4 ff ff       	jmp    80105b97 <alltraps>

801066df <vector170>:
.globl vector170
vector170:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $170
801066e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066e6:	e9 ac f4 ff ff       	jmp    80105b97 <alltraps>

801066eb <vector171>:
.globl vector171
vector171:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $171
801066ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066f2:	e9 a0 f4 ff ff       	jmp    80105b97 <alltraps>

801066f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $172
801066f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066fe:	e9 94 f4 ff ff       	jmp    80105b97 <alltraps>

80106703 <vector173>:
.globl vector173
vector173:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $173
80106705:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010670a:	e9 88 f4 ff ff       	jmp    80105b97 <alltraps>

8010670f <vector174>:
.globl vector174
vector174:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $174
80106711:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106716:	e9 7c f4 ff ff       	jmp    80105b97 <alltraps>

8010671b <vector175>:
.globl vector175
vector175:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $175
8010671d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106722:	e9 70 f4 ff ff       	jmp    80105b97 <alltraps>

80106727 <vector176>:
.globl vector176
vector176:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $176
80106729:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010672e:	e9 64 f4 ff ff       	jmp    80105b97 <alltraps>

80106733 <vector177>:
.globl vector177
vector177:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $177
80106735:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010673a:	e9 58 f4 ff ff       	jmp    80105b97 <alltraps>

8010673f <vector178>:
.globl vector178
vector178:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $178
80106741:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106746:	e9 4c f4 ff ff       	jmp    80105b97 <alltraps>

8010674b <vector179>:
.globl vector179
vector179:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $179
8010674d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106752:	e9 40 f4 ff ff       	jmp    80105b97 <alltraps>

80106757 <vector180>:
.globl vector180
vector180:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $180
80106759:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010675e:	e9 34 f4 ff ff       	jmp    80105b97 <alltraps>

80106763 <vector181>:
.globl vector181
vector181:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $181
80106765:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010676a:	e9 28 f4 ff ff       	jmp    80105b97 <alltraps>

8010676f <vector182>:
.globl vector182
vector182:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $182
80106771:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106776:	e9 1c f4 ff ff       	jmp    80105b97 <alltraps>

8010677b <vector183>:
.globl vector183
vector183:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $183
8010677d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106782:	e9 10 f4 ff ff       	jmp    80105b97 <alltraps>

80106787 <vector184>:
.globl vector184
vector184:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $184
80106789:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010678e:	e9 04 f4 ff ff       	jmp    80105b97 <alltraps>

80106793 <vector185>:
.globl vector185
vector185:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $185
80106795:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010679a:	e9 f8 f3 ff ff       	jmp    80105b97 <alltraps>

8010679f <vector186>:
.globl vector186
vector186:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $186
801067a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067a6:	e9 ec f3 ff ff       	jmp    80105b97 <alltraps>

801067ab <vector187>:
.globl vector187
vector187:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $187
801067ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067b2:	e9 e0 f3 ff ff       	jmp    80105b97 <alltraps>

801067b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $188
801067b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067be:	e9 d4 f3 ff ff       	jmp    80105b97 <alltraps>

801067c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $189
801067c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ca:	e9 c8 f3 ff ff       	jmp    80105b97 <alltraps>

801067cf <vector190>:
.globl vector190
vector190:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $190
801067d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067d6:	e9 bc f3 ff ff       	jmp    80105b97 <alltraps>

801067db <vector191>:
.globl vector191
vector191:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $191
801067dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067e2:	e9 b0 f3 ff ff       	jmp    80105b97 <alltraps>

801067e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $192
801067e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ee:	e9 a4 f3 ff ff       	jmp    80105b97 <alltraps>

801067f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $193
801067f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067fa:	e9 98 f3 ff ff       	jmp    80105b97 <alltraps>

801067ff <vector194>:
.globl vector194
vector194:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $194
80106801:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106806:	e9 8c f3 ff ff       	jmp    80105b97 <alltraps>

8010680b <vector195>:
.globl vector195
vector195:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $195
8010680d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106812:	e9 80 f3 ff ff       	jmp    80105b97 <alltraps>

80106817 <vector196>:
.globl vector196
vector196:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $196
80106819:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010681e:	e9 74 f3 ff ff       	jmp    80105b97 <alltraps>

80106823 <vector197>:
.globl vector197
vector197:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $197
80106825:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010682a:	e9 68 f3 ff ff       	jmp    80105b97 <alltraps>

8010682f <vector198>:
.globl vector198
vector198:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $198
80106831:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106836:	e9 5c f3 ff ff       	jmp    80105b97 <alltraps>

8010683b <vector199>:
.globl vector199
vector199:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $199
8010683d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106842:	e9 50 f3 ff ff       	jmp    80105b97 <alltraps>

80106847 <vector200>:
.globl vector200
vector200:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $200
80106849:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010684e:	e9 44 f3 ff ff       	jmp    80105b97 <alltraps>

80106853 <vector201>:
.globl vector201
vector201:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $201
80106855:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010685a:	e9 38 f3 ff ff       	jmp    80105b97 <alltraps>

8010685f <vector202>:
.globl vector202
vector202:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $202
80106861:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106866:	e9 2c f3 ff ff       	jmp    80105b97 <alltraps>

8010686b <vector203>:
.globl vector203
vector203:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $203
8010686d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106872:	e9 20 f3 ff ff       	jmp    80105b97 <alltraps>

80106877 <vector204>:
.globl vector204
vector204:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $204
80106879:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010687e:	e9 14 f3 ff ff       	jmp    80105b97 <alltraps>

80106883 <vector205>:
.globl vector205
vector205:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $205
80106885:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010688a:	e9 08 f3 ff ff       	jmp    80105b97 <alltraps>

8010688f <vector206>:
.globl vector206
vector206:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $206
80106891:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106896:	e9 fc f2 ff ff       	jmp    80105b97 <alltraps>

8010689b <vector207>:
.globl vector207
vector207:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $207
8010689d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068a2:	e9 f0 f2 ff ff       	jmp    80105b97 <alltraps>

801068a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $208
801068a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ae:	e9 e4 f2 ff ff       	jmp    80105b97 <alltraps>

801068b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $209
801068b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068ba:	e9 d8 f2 ff ff       	jmp    80105b97 <alltraps>

801068bf <vector210>:
.globl vector210
vector210:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $210
801068c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068c6:	e9 cc f2 ff ff       	jmp    80105b97 <alltraps>

801068cb <vector211>:
.globl vector211
vector211:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $211
801068cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068d2:	e9 c0 f2 ff ff       	jmp    80105b97 <alltraps>

801068d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $212
801068d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068de:	e9 b4 f2 ff ff       	jmp    80105b97 <alltraps>

801068e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $213
801068e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ea:	e9 a8 f2 ff ff       	jmp    80105b97 <alltraps>

801068ef <vector214>:
.globl vector214
vector214:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $214
801068f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068f6:	e9 9c f2 ff ff       	jmp    80105b97 <alltraps>

801068fb <vector215>:
.globl vector215
vector215:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $215
801068fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106902:	e9 90 f2 ff ff       	jmp    80105b97 <alltraps>

80106907 <vector216>:
.globl vector216
vector216:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $216
80106909:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010690e:	e9 84 f2 ff ff       	jmp    80105b97 <alltraps>

80106913 <vector217>:
.globl vector217
vector217:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $217
80106915:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010691a:	e9 78 f2 ff ff       	jmp    80105b97 <alltraps>

8010691f <vector218>:
.globl vector218
vector218:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $218
80106921:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106926:	e9 6c f2 ff ff       	jmp    80105b97 <alltraps>

8010692b <vector219>:
.globl vector219
vector219:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $219
8010692d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106932:	e9 60 f2 ff ff       	jmp    80105b97 <alltraps>

80106937 <vector220>:
.globl vector220
vector220:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $220
80106939:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010693e:	e9 54 f2 ff ff       	jmp    80105b97 <alltraps>

80106943 <vector221>:
.globl vector221
vector221:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $221
80106945:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010694a:	e9 48 f2 ff ff       	jmp    80105b97 <alltraps>

8010694f <vector222>:
.globl vector222
vector222:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $222
80106951:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106956:	e9 3c f2 ff ff       	jmp    80105b97 <alltraps>

8010695b <vector223>:
.globl vector223
vector223:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $223
8010695d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106962:	e9 30 f2 ff ff       	jmp    80105b97 <alltraps>

80106967 <vector224>:
.globl vector224
vector224:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $224
80106969:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010696e:	e9 24 f2 ff ff       	jmp    80105b97 <alltraps>

80106973 <vector225>:
.globl vector225
vector225:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $225
80106975:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010697a:	e9 18 f2 ff ff       	jmp    80105b97 <alltraps>

8010697f <vector226>:
.globl vector226
vector226:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $226
80106981:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106986:	e9 0c f2 ff ff       	jmp    80105b97 <alltraps>

8010698b <vector227>:
.globl vector227
vector227:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $227
8010698d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106992:	e9 00 f2 ff ff       	jmp    80105b97 <alltraps>

80106997 <vector228>:
.globl vector228
vector228:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $228
80106999:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010699e:	e9 f4 f1 ff ff       	jmp    80105b97 <alltraps>

801069a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $229
801069a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069aa:	e9 e8 f1 ff ff       	jmp    80105b97 <alltraps>

801069af <vector230>:
.globl vector230
vector230:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $230
801069b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069b6:	e9 dc f1 ff ff       	jmp    80105b97 <alltraps>

801069bb <vector231>:
.globl vector231
vector231:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $231
801069bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069c2:	e9 d0 f1 ff ff       	jmp    80105b97 <alltraps>

801069c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $232
801069c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ce:	e9 c4 f1 ff ff       	jmp    80105b97 <alltraps>

801069d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $233
801069d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069da:	e9 b8 f1 ff ff       	jmp    80105b97 <alltraps>

801069df <vector234>:
.globl vector234
vector234:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $234
801069e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069e6:	e9 ac f1 ff ff       	jmp    80105b97 <alltraps>

801069eb <vector235>:
.globl vector235
vector235:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $235
801069ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069f2:	e9 a0 f1 ff ff       	jmp    80105b97 <alltraps>

801069f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $236
801069f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069fe:	e9 94 f1 ff ff       	jmp    80105b97 <alltraps>

80106a03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $237
80106a05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a0a:	e9 88 f1 ff ff       	jmp    80105b97 <alltraps>

80106a0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $238
80106a11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a16:	e9 7c f1 ff ff       	jmp    80105b97 <alltraps>

80106a1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $239
80106a1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a22:	e9 70 f1 ff ff       	jmp    80105b97 <alltraps>

80106a27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $240
80106a29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a2e:	e9 64 f1 ff ff       	jmp    80105b97 <alltraps>

80106a33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $241
80106a35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a3a:	e9 58 f1 ff ff       	jmp    80105b97 <alltraps>

80106a3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $242
80106a41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a46:	e9 4c f1 ff ff       	jmp    80105b97 <alltraps>

80106a4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $243
80106a4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a52:	e9 40 f1 ff ff       	jmp    80105b97 <alltraps>

80106a57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $244
80106a59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a5e:	e9 34 f1 ff ff       	jmp    80105b97 <alltraps>

80106a63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $245
80106a65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a6a:	e9 28 f1 ff ff       	jmp    80105b97 <alltraps>

80106a6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $246
80106a71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a76:	e9 1c f1 ff ff       	jmp    80105b97 <alltraps>

80106a7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $247
80106a7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a82:	e9 10 f1 ff ff       	jmp    80105b97 <alltraps>

80106a87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $248
80106a89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a8e:	e9 04 f1 ff ff       	jmp    80105b97 <alltraps>

80106a93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $249
80106a95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a9a:	e9 f8 f0 ff ff       	jmp    80105b97 <alltraps>

80106a9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $250
80106aa1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106aa6:	e9 ec f0 ff ff       	jmp    80105b97 <alltraps>

80106aab <vector251>:
.globl vector251
vector251:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $251
80106aad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ab2:	e9 e0 f0 ff ff       	jmp    80105b97 <alltraps>

80106ab7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $252
80106ab9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106abe:	e9 d4 f0 ff ff       	jmp    80105b97 <alltraps>

80106ac3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $253
80106ac5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aca:	e9 c8 f0 ff ff       	jmp    80105b97 <alltraps>

80106acf <vector254>:
.globl vector254
vector254:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $254
80106ad1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ad6:	e9 bc f0 ff ff       	jmp    80105b97 <alltraps>

80106adb <vector255>:
.globl vector255
vector255:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $255
80106add:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ae2:	e9 b0 f0 ff ff       	jmp    80105b97 <alltraps>
80106ae7:	66 90                	xchg   %ax,%ax
80106ae9:	66 90                	xchg   %ax,%ax
80106aeb:	66 90                	xchg   %ax,%ax
80106aed:	66 90                	xchg   %ax,%ax
80106aef:	90                   	nop

80106af0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106af6:	89 d3                	mov    %edx,%ebx
{
80106af8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106afa:	c1 eb 16             	shr    $0x16,%ebx
80106afd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106b00:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b03:	8b 06                	mov    (%esi),%eax
80106b05:	a8 01                	test   $0x1,%al
80106b07:	74 27                	je     80106b30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b0e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b14:	c1 ef 0a             	shr    $0xa,%edi
}
80106b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b1a:	89 fa                	mov    %edi,%edx
80106b1c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b22:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b30:	85 c9                	test   %ecx,%ecx
80106b32:	74 2c                	je     80106b60 <walkpgdir+0x70>
80106b34:	e8 27 bc ff ff       	call   80102760 <kalloc>
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	89 c3                	mov    %eax,%ebx
80106b3d:	74 21                	je     80106b60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b3f:	83 ec 04             	sub    $0x4,%esp
80106b42:	68 00 10 00 00       	push   $0x1000
80106b47:	6a 00                	push   $0x0
80106b49:	50                   	push   %eax
80106b4a:	e8 c1 dd ff ff       	call   80104910 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b55:	83 c4 10             	add    $0x10,%esp
80106b58:	83 c8 07             	or     $0x7,%eax
80106b5b:	89 06                	mov    %eax,(%esi)
80106b5d:	eb b5                	jmp    80106b14 <walkpgdir+0x24>
80106b5f:	90                   	nop
}
80106b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b63:	31 c0                	xor    %eax,%eax
}
80106b65:	5b                   	pop    %ebx
80106b66:	5e                   	pop    %esi
80106b67:	5f                   	pop    %edi
80106b68:	5d                   	pop    %ebp
80106b69:	c3                   	ret    
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b76:	89 d3                	mov    %edx,%ebx
80106b78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b7e:	83 ec 1c             	sub    $0x1c,%esp
80106b81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b96:	29 df                	sub    %ebx,%edi
80106b98:	83 c8 01             	or     $0x1,%eax
80106b9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b9e:	eb 15                	jmp    80106bb5 <mappages+0x45>
    if(*pte & PTE_P)
80106ba0:	f6 00 01             	testb  $0x1,(%eax)
80106ba3:	75 45                	jne    80106bea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ba5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ba8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106bab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bad:	74 31                	je     80106be0 <mappages+0x70>
      break;
    a += PGSIZE;
80106baf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bb8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bbd:	89 da                	mov    %ebx,%edx
80106bbf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106bc2:	e8 29 ff ff ff       	call   80106af0 <walkpgdir>
80106bc7:	85 c0                	test   %eax,%eax
80106bc9:	75 d5                	jne    80106ba0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bd3:	5b                   	pop    %ebx
80106bd4:	5e                   	pop    %esi
80106bd5:	5f                   	pop    %edi
80106bd6:	5d                   	pop    %ebp
80106bd7:	c3                   	ret    
80106bd8:	90                   	nop
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106be3:	31 c0                	xor    %eax,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
      panic("remap");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 30 7d 10 80       	push   $0x80107d30
80106bf2:	e8 99 97 ff ff       	call   80100390 <panic>
80106bf7:	89 f6                	mov    %esi,%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c0c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106c0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c14:	83 ec 1c             	sub    $0x1c,%esp
80106c17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c1a:	39 d3                	cmp    %edx,%ebx
80106c1c:	73 66                	jae    80106c84 <deallocuvm.part.0+0x84>
80106c1e:	89 d6                	mov    %edx,%esi
80106c20:	eb 3d                	jmp    80106c5f <deallocuvm.part.0+0x5f>
80106c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c28:	8b 10                	mov    (%eax),%edx
80106c2a:	f6 c2 01             	test   $0x1,%dl
80106c2d:	74 26                	je     80106c55 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c35:	74 58                	je     80106c8f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c43:	52                   	push   %edx
80106c44:	e8 67 b9 ff ff       	call   801025b0 <kfree>
      *pte = 0;
80106c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c4c:	83 c4 10             	add    $0x10,%esp
80106c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c5b:	39 f3                	cmp    %esi,%ebx
80106c5d:	73 25                	jae    80106c84 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c5f:	31 c9                	xor    %ecx,%ecx
80106c61:	89 da                	mov    %ebx,%edx
80106c63:	89 f8                	mov    %edi,%eax
80106c65:	e8 86 fe ff ff       	call   80106af0 <walkpgdir>
    if(!pte)
80106c6a:	85 c0                	test   %eax,%eax
80106c6c:	75 ba                	jne    80106c28 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c6e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c74:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c80:	39 f3                	cmp    %esi,%ebx
80106c82:	72 db                	jb     80106c5f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c8a:	5b                   	pop    %ebx
80106c8b:	5e                   	pop    %esi
80106c8c:	5f                   	pop    %edi
80106c8d:	5d                   	pop    %ebp
80106c8e:	c3                   	ret    
        panic("kfree");
80106c8f:	83 ec 0c             	sub    $0xc,%esp
80106c92:	68 aa 76 10 80       	push   $0x801076aa
80106c97:	e8 f4 96 ff ff       	call   80100390 <panic>
80106c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <seginit>:
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ca6:	e8 d5 cd ff ff       	call   80103a80 <cpuid>
80106cab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106cb1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cb6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cba:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106cc1:	ff 00 00 
80106cc4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106ccb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cce:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106cd5:	ff 00 00 
80106cd8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106cdf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ce2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106ce9:	ff 00 00 
80106cec:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106cf3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cf6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106cfd:	ff 00 00 
80106d00:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106d07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d0a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106d0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d13:	c1 e8 10             	shr    $0x10,%eax
80106d16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d1d:	0f 01 10             	lgdtl  (%eax)
}
80106d20:	c9                   	leave  
80106d21:	c3                   	ret    
80106d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d30:	a1 a4 58 11 80       	mov    0x801158a4,%eax
{
80106d35:	55                   	push   %ebp
80106d36:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d38:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d3d:	0f 22 d8             	mov    %eax,%cr3
}
80106d40:	5d                   	pop    %ebp
80106d41:	c3                   	ret    
80106d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <switchuvm>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
80106d56:	83 ec 1c             	sub    $0x1c,%esp
80106d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d5c:	85 db                	test   %ebx,%ebx
80106d5e:	0f 84 cb 00 00 00    	je     80106e2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d64:	8b 43 08             	mov    0x8(%ebx),%eax
80106d67:	85 c0                	test   %eax,%eax
80106d69:	0f 84 da 00 00 00    	je     80106e49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d6f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d72:	85 c0                	test   %eax,%eax
80106d74:	0f 84 c2 00 00 00    	je     80106e3c <switchuvm+0xec>
  pushcli();
80106d7a:	e8 b1 d9 ff ff       	call   80104730 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d7f:	e8 7c cc ff ff       	call   80103a00 <mycpu>
80106d84:	89 c6                	mov    %eax,%esi
80106d86:	e8 75 cc ff ff       	call   80103a00 <mycpu>
80106d8b:	89 c7                	mov    %eax,%edi
80106d8d:	e8 6e cc ff ff       	call   80103a00 <mycpu>
80106d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d95:	83 c7 08             	add    $0x8,%edi
80106d98:	e8 63 cc ff ff       	call   80103a00 <mycpu>
80106d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106da0:	83 c0 08             	add    $0x8,%eax
80106da3:	ba 67 00 00 00       	mov    $0x67,%edx
80106da8:	c1 e8 18             	shr    $0x18,%eax
80106dab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106db2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106db9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dbf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dc4:	83 c1 08             	add    $0x8,%ecx
80106dc7:	c1 e9 10             	shr    $0x10,%ecx
80106dca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106dd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106dd5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ddc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106de1:	e8 1a cc ff ff       	call   80103a00 <mycpu>
80106de6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ded:	e8 0e cc ff ff       	call   80103a00 <mycpu>
80106df2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106df6:	8b 73 08             	mov    0x8(%ebx),%esi
80106df9:	e8 02 cc ff ff       	call   80103a00 <mycpu>
80106dfe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e04:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e07:	e8 f4 cb ff ff       	call   80103a00 <mycpu>
80106e0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e10:	b8 28 00 00 00       	mov    $0x28,%eax
80106e15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e18:	8b 43 04             	mov    0x4(%ebx),%eax
80106e1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e20:	0f 22 d8             	mov    %eax,%cr3
}
80106e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e26:	5b                   	pop    %ebx
80106e27:	5e                   	pop    %esi
80106e28:	5f                   	pop    %edi
80106e29:	5d                   	pop    %ebp
  popcli();
80106e2a:	e9 41 d9 ff ff       	jmp    80104770 <popcli>
    panic("switchuvm: no process");
80106e2f:	83 ec 0c             	sub    $0xc,%esp
80106e32:	68 36 7d 10 80       	push   $0x80107d36
80106e37:	e8 54 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e3c:	83 ec 0c             	sub    $0xc,%esp
80106e3f:	68 61 7d 10 80       	push   $0x80107d61
80106e44:	e8 47 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e49:	83 ec 0c             	sub    $0xc,%esp
80106e4c:	68 4c 7d 10 80       	push   $0x80107d4c
80106e51:	e8 3a 95 ff ff       	call   80100390 <panic>
80106e56:	8d 76 00             	lea    0x0(%esi),%esi
80106e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e60 <inituvm>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
80106e66:	83 ec 1c             	sub    $0x1c,%esp
80106e69:	8b 75 10             	mov    0x10(%ebp),%esi
80106e6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e7b:	77 49                	ja     80106ec6 <inituvm+0x66>
  mem = kalloc();
80106e7d:	e8 de b8 ff ff       	call   80102760 <kalloc>
  memset(mem, 0, PGSIZE);
80106e82:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e85:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e87:	68 00 10 00 00       	push   $0x1000
80106e8c:	6a 00                	push   $0x0
80106e8e:	50                   	push   %eax
80106e8f:	e8 7c da ff ff       	call   80104910 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e94:	58                   	pop    %eax
80106e95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ea0:	5a                   	pop    %edx
80106ea1:	6a 06                	push   $0x6
80106ea3:	50                   	push   %eax
80106ea4:	31 d2                	xor    %edx,%edx
80106ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ea9:	e8 c2 fc ff ff       	call   80106b70 <mappages>
  memmove(mem, init, sz);
80106eae:	89 75 10             	mov    %esi,0x10(%ebp)
80106eb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106eb4:	83 c4 10             	add    $0x10,%esp
80106eb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ebd:	5b                   	pop    %ebx
80106ebe:	5e                   	pop    %esi
80106ebf:	5f                   	pop    %edi
80106ec0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ec1:	e9 fa da ff ff       	jmp    801049c0 <memmove>
    panic("inituvm: more than a page");
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	68 75 7d 10 80       	push   $0x80107d75
80106ece:	e8 bd 94 ff ff       	call   80100390 <panic>
80106ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ee0 <loaduvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106ee9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ef0:	0f 85 91 00 00 00    	jne    80106f87 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ef6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ef9:	31 db                	xor    %ebx,%ebx
80106efb:	85 f6                	test   %esi,%esi
80106efd:	75 1a                	jne    80106f19 <loaduvm+0x39>
80106eff:	eb 6f                	jmp    80106f70 <loaduvm+0x90>
80106f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f17:	76 57                	jbe    80106f70 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1f:	31 c9                	xor    %ecx,%ecx
80106f21:	01 da                	add    %ebx,%edx
80106f23:	e8 c8 fb ff ff       	call   80106af0 <walkpgdir>
80106f28:	85 c0                	test   %eax,%eax
80106f2a:	74 4e                	je     80106f7a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106f2c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f31:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f41:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f44:	01 d9                	add    %ebx,%ecx
80106f46:	05 00 00 00 80       	add    $0x80000000,%eax
80106f4b:	57                   	push   %edi
80106f4c:	51                   	push   %ecx
80106f4d:	50                   	push   %eax
80106f4e:	ff 75 10             	pushl  0x10(%ebp)
80106f51:	e8 9a aa ff ff       	call   801019f0 <readi>
80106f56:	83 c4 10             	add    $0x10,%esp
80106f59:	39 f8                	cmp    %edi,%eax
80106f5b:	74 ab                	je     80106f08 <loaduvm+0x28>
}
80106f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f65:	5b                   	pop    %ebx
80106f66:	5e                   	pop    %esi
80106f67:	5f                   	pop    %edi
80106f68:	5d                   	pop    %ebp
80106f69:	c3                   	ret    
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 8f 7d 10 80       	push   $0x80107d8f
80106f82:	e8 09 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f87:	83 ec 0c             	sub    $0xc,%esp
80106f8a:	68 30 7e 10 80       	push   $0x80107e30
80106f8f:	e8 fc 93 ff ff       	call   80100390 <panic>
80106f94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fa0 <allocuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fa9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106fac:	85 ff                	test   %edi,%edi
80106fae:	0f 88 8e 00 00 00    	js     80107042 <allocuvm+0xa2>
  if(newsz < oldsz)
80106fb4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106fb7:	0f 82 93 00 00 00    	jb     80107050 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106fc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106fcc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fcf:	0f 86 7e 00 00 00    	jbe    80107053 <allocuvm+0xb3>
80106fd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fdb:	eb 42                	jmp    8010701f <allocuvm+0x7f>
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fe0:	83 ec 04             	sub    $0x4,%esp
80106fe3:	68 00 10 00 00       	push   $0x1000
80106fe8:	6a 00                	push   $0x0
80106fea:	50                   	push   %eax
80106feb:	e8 20 d9 ff ff       	call   80104910 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ff0:	58                   	pop    %eax
80106ff1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ff7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ffc:	5a                   	pop    %edx
80106ffd:	6a 06                	push   $0x6
80106fff:	50                   	push   %eax
80107000:	89 da                	mov    %ebx,%edx
80107002:	89 f8                	mov    %edi,%eax
80107004:	e8 67 fb ff ff       	call   80106b70 <mappages>
80107009:	83 c4 10             	add    $0x10,%esp
8010700c:	85 c0                	test   %eax,%eax
8010700e:	78 50                	js     80107060 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107010:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107016:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107019:	0f 86 81 00 00 00    	jbe    801070a0 <allocuvm+0x100>
    mem = kalloc();
8010701f:	e8 3c b7 ff ff       	call   80102760 <kalloc>
    if(mem == 0){
80107024:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107026:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107028:	75 b6                	jne    80106fe0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 ad 7d 10 80       	push   $0x80107dad
80107032:	e8 29 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107037:	83 c4 10             	add    $0x10,%esp
8010703a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107040:	77 6e                	ja     801070b0 <allocuvm+0x110>
}
80107042:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107045:	31 ff                	xor    %edi,%edi
}
80107047:	89 f8                	mov    %edi,%eax
80107049:	5b                   	pop    %ebx
8010704a:	5e                   	pop    %esi
8010704b:	5f                   	pop    %edi
8010704c:	5d                   	pop    %ebp
8010704d:	c3                   	ret    
8010704e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107050:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107056:	89 f8                	mov    %edi,%eax
80107058:	5b                   	pop    %ebx
80107059:	5e                   	pop    %esi
8010705a:	5f                   	pop    %edi
8010705b:	5d                   	pop    %ebp
8010705c:	c3                   	ret    
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	68 c5 7d 10 80       	push   $0x80107dc5
80107068:	e8 f3 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010706d:	83 c4 10             	add    $0x10,%esp
80107070:	8b 45 0c             	mov    0xc(%ebp),%eax
80107073:	39 45 10             	cmp    %eax,0x10(%ebp)
80107076:	76 0d                	jbe    80107085 <allocuvm+0xe5>
80107078:	89 c1                	mov    %eax,%ecx
8010707a:	8b 55 10             	mov    0x10(%ebp),%edx
8010707d:	8b 45 08             	mov    0x8(%ebp),%eax
80107080:	e8 7b fb ff ff       	call   80106c00 <deallocuvm.part.0>
      kfree(mem);
80107085:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107088:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010708a:	56                   	push   %esi
8010708b:	e8 20 b5 ff ff       	call   801025b0 <kfree>
      return 0;
80107090:	83 c4 10             	add    $0x10,%esp
}
80107093:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107096:	89 f8                	mov    %edi,%eax
80107098:	5b                   	pop    %ebx
80107099:	5e                   	pop    %esi
8010709a:	5f                   	pop    %edi
8010709b:	5d                   	pop    %ebp
8010709c:	c3                   	ret    
8010709d:	8d 76 00             	lea    0x0(%esi),%esi
801070a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801070a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a6:	5b                   	pop    %ebx
801070a7:	89 f8                	mov    %edi,%eax
801070a9:	5e                   	pop    %esi
801070aa:	5f                   	pop    %edi
801070ab:	5d                   	pop    %ebp
801070ac:	c3                   	ret    
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
801070b0:	89 c1                	mov    %eax,%ecx
801070b2:	8b 55 10             	mov    0x10(%ebp),%edx
801070b5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801070b8:	31 ff                	xor    %edi,%edi
801070ba:	e8 41 fb ff ff       	call   80106c00 <deallocuvm.part.0>
801070bf:	eb 92                	jmp    80107053 <allocuvm+0xb3>
801070c1:	eb 0d                	jmp    801070d0 <deallocuvm>
801070c3:	90                   	nop
801070c4:	90                   	nop
801070c5:	90                   	nop
801070c6:	90                   	nop
801070c7:	90                   	nop
801070c8:	90                   	nop
801070c9:	90                   	nop
801070ca:	90                   	nop
801070cb:	90                   	nop
801070cc:	90                   	nop
801070cd:	90                   	nop
801070ce:	90                   	nop
801070cf:	90                   	nop

801070d0 <deallocuvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070dc:	39 d1                	cmp    %edx,%ecx
801070de:	73 10                	jae    801070f0 <deallocuvm+0x20>
}
801070e0:	5d                   	pop    %ebp
801070e1:	e9 1a fb ff ff       	jmp    80106c00 <deallocuvm.part.0>
801070e6:	8d 76 00             	lea    0x0(%esi),%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070f0:	89 d0                	mov    %edx,%eax
801070f2:	5d                   	pop    %ebp
801070f3:	c3                   	ret    
801070f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107100 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 0c             	sub    $0xc,%esp
80107109:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010710c:	85 f6                	test   %esi,%esi
8010710e:	74 59                	je     80107169 <freevm+0x69>
80107110:	31 c9                	xor    %ecx,%ecx
80107112:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107117:	89 f0                	mov    %esi,%eax
80107119:	e8 e2 fa ff ff       	call   80106c00 <deallocuvm.part.0>
8010711e:	89 f3                	mov    %esi,%ebx
80107120:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107126:	eb 0f                	jmp    80107137 <freevm+0x37>
80107128:	90                   	nop
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107130:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107133:	39 fb                	cmp    %edi,%ebx
80107135:	74 23                	je     8010715a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107137:	8b 03                	mov    (%ebx),%eax
80107139:	a8 01                	test   $0x1,%al
8010713b:	74 f3                	je     80107130 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010713d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107142:	83 ec 0c             	sub    $0xc,%esp
80107145:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107148:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010714d:	50                   	push   %eax
8010714e:	e8 5d b4 ff ff       	call   801025b0 <kfree>
80107153:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107156:	39 fb                	cmp    %edi,%ebx
80107158:	75 dd                	jne    80107137 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010715a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010715d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107160:	5b                   	pop    %ebx
80107161:	5e                   	pop    %esi
80107162:	5f                   	pop    %edi
80107163:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107164:	e9 47 b4 ff ff       	jmp    801025b0 <kfree>
    panic("freevm: no pgdir");
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	68 e1 7d 10 80       	push   $0x80107de1
80107171:	e8 1a 92 ff ff       	call   80100390 <panic>
80107176:	8d 76 00             	lea    0x0(%esi),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <setupkvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	56                   	push   %esi
80107184:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107185:	e8 d6 b5 ff ff       	call   80102760 <kalloc>
8010718a:	85 c0                	test   %eax,%eax
8010718c:	89 c6                	mov    %eax,%esi
8010718e:	74 42                	je     801071d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107193:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107198:	68 00 10 00 00       	push   $0x1000
8010719d:	6a 00                	push   $0x0
8010719f:	50                   	push   %eax
801071a0:	e8 6b d7 ff ff       	call   80104910 <memset>
801071a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071ae:	83 ec 08             	sub    $0x8,%esp
801071b1:	8b 13                	mov    (%ebx),%edx
801071b3:	ff 73 0c             	pushl  0xc(%ebx)
801071b6:	50                   	push   %eax
801071b7:	29 c1                	sub    %eax,%ecx
801071b9:	89 f0                	mov    %esi,%eax
801071bb:	e8 b0 f9 ff ff       	call   80106b70 <mappages>
801071c0:	83 c4 10             	add    $0x10,%esp
801071c3:	85 c0                	test   %eax,%eax
801071c5:	78 19                	js     801071e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071c7:	83 c3 10             	add    $0x10,%ebx
801071ca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071d0:	75 d6                	jne    801071a8 <setupkvm+0x28>
}
801071d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071d5:	89 f0                	mov    %esi,%eax
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5d                   	pop    %ebp
801071da:	c3                   	ret    
801071db:	90                   	nop
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071e0:	83 ec 0c             	sub    $0xc,%esp
801071e3:	56                   	push   %esi
      return 0;
801071e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071e6:	e8 15 ff ff ff       	call   80107100 <freevm>
      return 0;
801071eb:	83 c4 10             	add    $0x10,%esp
}
801071ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f1:	89 f0                	mov    %esi,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5d                   	pop    %ebp
801071f6:	c3                   	ret    
801071f7:	89 f6                	mov    %esi,%esi
801071f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107200 <kvmalloc>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107206:	e8 75 ff ff ff       	call   80107180 <setupkvm>
8010720b:	a3 a4 58 11 80       	mov    %eax,0x801158a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107210:	05 00 00 00 80       	add    $0x80000000,%eax
80107215:	0f 22 d8             	mov    %eax,%cr3
}
80107218:	c9                   	leave  
80107219:	c3                   	ret    
8010721a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107220 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107220:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107221:	31 c9                	xor    %ecx,%ecx
{
80107223:	89 e5                	mov    %esp,%ebp
80107225:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107228:	8b 55 0c             	mov    0xc(%ebp),%edx
8010722b:	8b 45 08             	mov    0x8(%ebp),%eax
8010722e:	e8 bd f8 ff ff       	call   80106af0 <walkpgdir>
  if(pte == 0)
80107233:	85 c0                	test   %eax,%eax
80107235:	74 05                	je     8010723c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107237:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010723a:	c9                   	leave  
8010723b:	c3                   	ret    
    panic("clearpteu");
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	68 f2 7d 10 80       	push   $0x80107df2
80107244:	e8 47 91 ff ff       	call   80100390 <panic>
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107250 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107259:	e8 22 ff ff ff       	call   80107180 <setupkvm>
8010725e:	85 c0                	test   %eax,%eax
80107260:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107263:	0f 84 9f 00 00 00    	je     80107308 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107269:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010726c:	85 c9                	test   %ecx,%ecx
8010726e:	0f 84 94 00 00 00    	je     80107308 <copyuvm+0xb8>
80107274:	31 ff                	xor    %edi,%edi
80107276:	eb 4a                	jmp    801072c2 <copyuvm+0x72>
80107278:	90                   	nop
80107279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107280:	83 ec 04             	sub    $0x4,%esp
80107283:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107289:	68 00 10 00 00       	push   $0x1000
8010728e:	53                   	push   %ebx
8010728f:	50                   	push   %eax
80107290:	e8 2b d7 ff ff       	call   801049c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107295:	58                   	pop    %eax
80107296:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010729c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072a1:	5a                   	pop    %edx
801072a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801072a5:	50                   	push   %eax
801072a6:	89 fa                	mov    %edi,%edx
801072a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ab:	e8 c0 f8 ff ff       	call   80106b70 <mappages>
801072b0:	83 c4 10             	add    $0x10,%esp
801072b3:	85 c0                	test   %eax,%eax
801072b5:	78 61                	js     80107318 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801072b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801072bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801072c0:	76 46                	jbe    80107308 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072c2:	8b 45 08             	mov    0x8(%ebp),%eax
801072c5:	31 c9                	xor    %ecx,%ecx
801072c7:	89 fa                	mov    %edi,%edx
801072c9:	e8 22 f8 ff ff       	call   80106af0 <walkpgdir>
801072ce:	85 c0                	test   %eax,%eax
801072d0:	74 61                	je     80107333 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801072d2:	8b 00                	mov    (%eax),%eax
801072d4:	a8 01                	test   $0x1,%al
801072d6:	74 4e                	je     80107326 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801072d8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801072da:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801072df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801072e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801072e8:	e8 73 b4 ff ff       	call   80102760 <kalloc>
801072ed:	85 c0                	test   %eax,%eax
801072ef:	89 c6                	mov    %eax,%esi
801072f1:	75 8d                	jne    80107280 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801072f3:	83 ec 0c             	sub    $0xc,%esp
801072f6:	ff 75 e0             	pushl  -0x20(%ebp)
801072f9:	e8 02 fe ff ff       	call   80107100 <freevm>
  return 0;
801072fe:	83 c4 10             	add    $0x10,%esp
80107301:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107308:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010730b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730e:	5b                   	pop    %ebx
8010730f:	5e                   	pop    %esi
80107310:	5f                   	pop    %edi
80107311:	5d                   	pop    %ebp
80107312:	c3                   	ret    
80107313:	90                   	nop
80107314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107318:	83 ec 0c             	sub    $0xc,%esp
8010731b:	56                   	push   %esi
8010731c:	e8 8f b2 ff ff       	call   801025b0 <kfree>
      goto bad;
80107321:	83 c4 10             	add    $0x10,%esp
80107324:	eb cd                	jmp    801072f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	68 16 7e 10 80       	push   $0x80107e16
8010732e:	e8 5d 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107333:	83 ec 0c             	sub    $0xc,%esp
80107336:	68 fc 7d 10 80       	push   $0x80107dfc
8010733b:	e8 50 90 ff ff       	call   80100390 <panic>

80107340 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107340:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107341:	31 c9                	xor    %ecx,%ecx
{
80107343:	89 e5                	mov    %esp,%ebp
80107345:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107348:	8b 55 0c             	mov    0xc(%ebp),%edx
8010734b:	8b 45 08             	mov    0x8(%ebp),%eax
8010734e:	e8 9d f7 ff ff       	call   80106af0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107353:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107355:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107356:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107358:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010735d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107360:	05 00 00 00 80       	add    $0x80000000,%eax
80107365:	83 fa 05             	cmp    $0x5,%edx
80107368:	ba 00 00 00 00       	mov    $0x0,%edx
8010736d:	0f 45 c2             	cmovne %edx,%eax
}
80107370:	c3                   	ret    
80107371:	eb 0d                	jmp    80107380 <copyout>
80107373:	90                   	nop
80107374:	90                   	nop
80107375:	90                   	nop
80107376:	90                   	nop
80107377:	90                   	nop
80107378:	90                   	nop
80107379:	90                   	nop
8010737a:	90                   	nop
8010737b:	90                   	nop
8010737c:	90                   	nop
8010737d:	90                   	nop
8010737e:	90                   	nop
8010737f:	90                   	nop

80107380 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 1c             	sub    $0x1c,%esp
80107389:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010738c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010738f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107392:	85 db                	test   %ebx,%ebx
80107394:	75 40                	jne    801073d6 <copyout+0x56>
80107396:	eb 70                	jmp    80107408 <copyout+0x88>
80107398:	90                   	nop
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801073a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073a3:	89 f1                	mov    %esi,%ecx
801073a5:	29 d1                	sub    %edx,%ecx
801073a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801073ad:	39 d9                	cmp    %ebx,%ecx
801073af:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073b2:	29 f2                	sub    %esi,%edx
801073b4:	83 ec 04             	sub    $0x4,%esp
801073b7:	01 d0                	add    %edx,%eax
801073b9:	51                   	push   %ecx
801073ba:	57                   	push   %edi
801073bb:	50                   	push   %eax
801073bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801073bf:	e8 fc d5 ff ff       	call   801049c0 <memmove>
    len -= n;
    buf += n;
801073c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801073c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801073ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801073d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801073d2:	29 cb                	sub    %ecx,%ebx
801073d4:	74 32                	je     80107408 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801073d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073e4:	56                   	push   %esi
801073e5:	ff 75 08             	pushl  0x8(%ebp)
801073e8:	e8 53 ff ff ff       	call   80107340 <uva2ka>
    if(pa0 == 0)
801073ed:	83 c4 10             	add    $0x10,%esp
801073f0:	85 c0                	test   %eax,%eax
801073f2:	75 ac                	jne    801073a0 <copyout+0x20>
  }
  return 0;
}
801073f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073fc:	5b                   	pop    %ebx
801073fd:	5e                   	pop    %esi
801073fe:	5f                   	pop    %edi
801073ff:	5d                   	pop    %ebp
80107400:	c3                   	ret    
80107401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010740b:	31 c0                	xor    %eax,%eax
}
8010740d:	5b                   	pop    %ebx
8010740e:	5e                   	pop    %esi
8010740f:	5f                   	pop    %edi
80107410:	5d                   	pop    %ebp
80107411:	c3                   	ret    
