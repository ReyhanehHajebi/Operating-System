
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc b0 83 11 80       	mov    $0x801183b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 36 10 80       	mov    $0x801036c0,%eax
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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 85 10 80       	push   $0x80108560
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 85 53 00 00       	call   801053e0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 85 10 80       	push   $0x80108567
80100097:	50                   	push   %eax
80100098:	e8 13 52 00 00       	call   801052b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 c7 54 00 00       	call   801055b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 e9 53 00 00       	call   80105550 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 51 00 00       	call   801052f0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 af 27 00 00       	call   80102940 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 85 10 80       	push   $0x8010856e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 cd 51 00 00       	call   80105390 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 67 27 00 00       	jmp    80102940 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 85 10 80       	push   $0x8010857f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 51 00 00       	call   80105390 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 51 00 00       	call   80105350 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 90 53 00 00       	call   801055b0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 df 52 00 00       	jmp    80105550 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 85 10 80       	push   $0x80108586
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 27 1c 00 00       	call   80101ec0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
801002a0:	e8 0b 53 00 00       	call   801055b0 <acquire>
  while (n > 0)
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
  {
    while (input.r == input.w)
801002b0:	a1 e0 14 11 80       	mov    0x801114e0,%eax
801002b5:	3b 05 e4 14 11 80    	cmp    0x801114e4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 00 15 11 80       	push   $0x80111500
801002c8:	68 e0 14 11 80       	push   $0x801114e0
801002cd:	e8 1e 48 00 00       	call   80104af0 <sleep>
    while (input.r == input.w)
801002d2:	a1 e0 14 11 80       	mov    0x801114e0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 e4 14 11 80    	cmp    0x801114e4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if (myproc()->killed)
801002e2:	e8 b9 3d 00 00       	call   801040a0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 00 15 11 80       	push   $0x80111500
801002f6:	e8 55 52 00 00       	call   80105550 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 dc 1a 00 00       	call   80101de0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 e0 14 11 80    	mov    %edx,0x801114e0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 60 14 11 80 	movsbl -0x7feeeba0(%edx),%ecx
    if (c == C('D'))
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if (c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 00 15 11 80       	push   $0x80111500
8010034c:	e8 ff 51 00 00       	call   80105550 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 86 1a 00 00       	call   80101de0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if (n < target)
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 e0 14 11 80       	mov    %eax,0x801114e0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 34 15 11 80 00 	movl   $0x0,0x80111534
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 b2 2b 00 00       	call   80102f50 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 85 10 80       	push   $0x8010858d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 1b 90 10 80 	movl   $0x8010901b,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 50 00 00       	call   80105400 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 85 10 80       	push   $0x801085a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for (i = 0; i < 10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 38 15 11 80 01 	movl   $0x1,0x80111538
801003f0:	00 00 00 
  for (;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
void consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if (c == BACKSPACE)
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 71 6a 00 00       	call   80106e90 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if (c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if (c == BACKSPACE)
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if (pos < 0 || pos > 25 * 80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if ((pos / 80) >= 24)
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT + 1, pos >> 8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT + 1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT + 1, pos >> 8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
    if (pos > 0)
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos % 80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 86 69 00 00       	call   80106e90 <uartputc>
    uartputc(' ');
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 7a 69 00 00       	call   80106e90 <uartputc>
    uartputc('\b');
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 6e 69 00 00       	call   80106e90 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT + 1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ba 51 00 00       	call   80105710 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 05 51 00 00       	call   80105670 <memset>
  outb(CRTPORT + 1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 85 10 80       	push   $0x801085a5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 1c 19 00 00       	call   80101ec0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 00 15 11 80 	movl   $0x80111500,(%esp)
801005ab:	e8 00 50 00 00       	call   801055b0 <acquire>
  for (i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if (panicked)
801005bd:	8b 15 38 15 11 80    	mov    0x80111538,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for (;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for (i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 00 15 11 80       	push   $0x80111500
801005e4:	e8 67 4f 00 00       	call   80105550 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ee 17 00 00       	call   80101de0 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if (sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 14 86 10 80 	movzbl -0x7fef79ec(%edx),%edx
  } while ((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  } while ((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if (sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while (--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if (panicked)
80100662:	8b 15 38 15 11 80    	mov    0x80111538,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for (;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while (--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 34 15 11 80       	mov    0x80111534,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint *)(void *)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if (c != '%')
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if (c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch (c)
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if (locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if ((s = (char *)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for (; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if (panicked)
80100760:	8b 15 38 15 11 80    	mov    0x80111538,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for (;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if (panicked)
801007a8:	8b 0d 38 15 11 80    	mov    0x80111538,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for (;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if (panicked)
801007b8:	a1 38 15 11 80       	mov    0x80111538,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 00 15 11 80       	push   $0x80111500
801007e8:	e8 c3 4d 00 00       	call   801055b0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if (panicked)
801007f5:	8b 0d 38 15 11 80    	mov    0x80111538,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 38 15 11 80    	mov    0x80111538,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for (;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for (; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for (;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf b8 85 10 80       	mov    $0x801085b8,%edi
      for (; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 00 15 11 80       	push   $0x80111500
8010085b:	e8 f0 4c 00 00       	call   80105550 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if ((s = (char *)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 85 10 80       	push   $0x801085bf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <incNum>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
  int incedNum = num + K;
80100883:	0f be 45 08          	movsbl 0x8(%ebp),%eax
}
80100887:	5d                   	pop    %ebp
  int incedNum = num + K;
80100888:	8d 50 02             	lea    0x2(%eax),%edx
    incedNum = incedNum - '9' + 'A' - 1;
8010088b:	83 c0 09             	add    $0x9,%eax
8010088e:	83 fa 39             	cmp    $0x39,%edx
  return incedNum;
80100891:	0f 4e c2             	cmovle %edx,%eax
}
80100894:	c3                   	ret    
80100895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010089c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801008a0 <makeSml>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
  return 'a' + c - 'A';
801008a3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}
801008a7:	5d                   	pop    %ebp
  return 'a' + c - 'A';
801008a8:	83 c0 20             	add    $0x20,%eax
}
801008ab:	c3                   	ret    
801008ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801008b0 <makeCap>:
{
801008b0:	55                   	push   %ebp
801008b1:	89 e5                	mov    %esp,%ebp
  return 'A' + c - 'a';
801008b3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}
801008b7:	5d                   	pop    %ebp
  return 'A' + c - 'a';
801008b8:	83 e8 20             	sub    $0x20,%eax
}
801008bb:	c3                   	ret    
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801008c0 <consclear>:
  while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n')
801008c0:	a1 e8 14 11 80       	mov    0x801114e8,%eax
801008c5:	3b 05 e4 14 11 80    	cmp    0x801114e4,%eax
801008cb:	74 44                	je     80100911 <consclear+0x51>
{
801008cd:	55                   	push   %ebp
801008ce:	89 e5                	mov    %esp,%ebp
801008d0:	83 ec 08             	sub    $0x8,%esp
  while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n')
801008d3:	83 e8 01             	sub    $0x1,%eax
801008d6:	89 c2                	mov    %eax,%edx
801008d8:	83 e2 7f             	and    $0x7f,%edx
801008db:	80 ba 60 14 11 80 0a 	cmpb   $0xa,-0x7feeeba0(%edx)
801008e2:	74 2b                	je     8010090f <consclear+0x4f>
    input.e--;
801008e4:	a3 e8 14 11 80       	mov    %eax,0x801114e8
  if (panicked)
801008e9:	a1 38 15 11 80       	mov    0x80111538,%eax
801008ee:	85 c0                	test   %eax,%eax
801008f0:	74 06                	je     801008f8 <consclear+0x38>
801008f2:	fa                   	cli    
    for (;;)
801008f3:	eb fe                	jmp    801008f3 <consclear+0x33>
801008f5:	8d 76 00             	lea    0x0(%esi),%esi
801008f8:	b8 00 01 00 00       	mov    $0x100,%eax
801008fd:	e8 fe fa ff ff       	call   80100400 <consputc.part.0>
  while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n')
80100902:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100907:	3b 05 e4 14 11 80    	cmp    0x801114e4,%eax
8010090d:	75 c4                	jne    801008d3 <consclear+0x13>
}
8010090f:	c9                   	leave  
80100910:	c3                   	ret    
80100911:	c3                   	ret    
80100912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100920 <consputs>:
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	56                   	push   %esi
80100924:	53                   	push   %ebx
80100925:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100928:	8d b3 80 00 00 00    	lea    0x80(%ebx),%esi
  for (int i = 0; i < INPUT_BUF && (s[i]); ++i)
8010092e:	80 3b 00             	cmpb   $0x0,(%ebx)
80100931:	74 3c                	je     8010096f <consputs+0x4f>
    input.buf[input.e++ % INPUT_BUF] = s[i];
80100933:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100938:	8d 50 01             	lea    0x1(%eax),%edx
8010093b:	83 e0 7f             	and    $0x7f,%eax
8010093e:	89 15 e8 14 11 80    	mov    %edx,0x801114e8
80100944:	0f b6 13             	movzbl (%ebx),%edx
80100947:	88 90 60 14 11 80    	mov    %dl,-0x7feeeba0(%eax)
  if (panicked)
8010094d:	a1 38 15 11 80       	mov    0x80111538,%eax
80100952:	85 c0                	test   %eax,%eax
80100954:	74 0a                	je     80100960 <consputs+0x40>
80100956:	fa                   	cli    
    for (;;)
80100957:	eb fe                	jmp    80100957 <consputs+0x37>
80100959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(s[i]);
80100960:	0f be c2             	movsbl %dl,%eax
  for (int i = 0; i < INPUT_BUF && (s[i]); ++i)
80100963:	83 c3 01             	add    $0x1,%ebx
80100966:	e8 95 fa ff ff       	call   80100400 <consputc.part.0>
8010096b:	39 f3                	cmp    %esi,%ebx
8010096d:	75 bf                	jne    8010092e <consputs+0xe>
}
8010096f:	5b                   	pop    %ebx
80100970:	5e                   	pop    %esi
80100971:	5d                   	pop    %ebp
80100972:	c3                   	ret    
80100973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100980 <suggestCmd.part.0>:
void suggestCmd()
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	57                   	push   %edi
  int idx = -1;
80100984:	bf ff ff ff ff       	mov    $0xffffffff,%edi
void suggestCmd()
80100989:	56                   	push   %esi
8010098a:	53                   	push   %ebx
  for (int i = 0; i < MAX_HIST; i++)
8010098b:	31 db                	xor    %ebx,%ebx
void suggestCmd()
8010098d:	83 ec 10             	sub    $0x10,%esp
  cmdSize = input.e - input.w;
80100990:	a1 e4 14 11 80       	mov    0x801114e4,%eax
80100995:	8b 15 e8 14 11 80    	mov    0x801114e8,%edx
8010099b:	29 c2                	sub    %eax,%edx
  memmove(command, input.buf + input.w, cmdSize);
8010099d:	05 60 14 11 80       	add    $0x80111460,%eax
801009a2:	52                   	push   %edx
801009a3:	50                   	push   %eax
801009a4:	68 a0 0e 11 80       	push   $0x80110ea0
  cmdSize = input.e - input.w;
801009a9:	89 15 84 0e 11 80    	mov    %edx,0x80110e84
  memmove(command, input.buf + input.w, cmdSize);
801009af:	e8 5c 4d 00 00       	call   80105710 <memmove>
    if (!strncmp(cmd, history[i], size))
801009b4:	8b 35 84 0e 11 80    	mov    0x80110e84,%esi
801009ba:	83 c4 10             	add    $0x10,%esp
801009bd:	8d 76 00             	lea    0x0(%esi),%esi
801009c0:	89 d8                	mov    %ebx,%eax
801009c2:	83 ec 04             	sub    $0x4,%esp
801009c5:	c1 e0 07             	shl    $0x7,%eax
801009c8:	56                   	push   %esi
801009c9:	05 40 0f 11 80       	add    $0x80110f40,%eax
801009ce:	50                   	push   %eax
801009cf:	68 a0 0e 11 80       	push   $0x80110ea0
801009d4:	e8 a7 4d 00 00       	call   80105780 <strncmp>
801009d9:	83 c4 10             	add    $0x10,%esp
801009dc:	85 c0                	test   %eax,%eax
801009de:	0f 44 fb             	cmove  %ebx,%edi
  for (int i = 0; i < MAX_HIST; i++)
801009e1:	83 c3 01             	add    $0x1,%ebx
801009e4:	83 fb 0a             	cmp    $0xa,%ebx
801009e7:	75 d7                	jne    801009c0 <suggestCmd.part.0+0x40>
    if (suggestedCmdIdx != -1)
801009e9:	83 ff ff             	cmp    $0xffffffff,%edi
801009ec:	74 24                	je     80100a12 <suggestCmd.part.0+0x92>
      histUsed = 1;
801009ee:	c7 05 20 0f 11 80 01 	movl   $0x1,0x80110f20
801009f5:	00 00 00 
      consputs(history[suggestedCmdIdx]);
801009f8:	c1 e7 07             	shl    $0x7,%edi
      consclear();
801009fb:	e8 c0 fe ff ff       	call   801008c0 <consclear>
      consputs(history[suggestedCmdIdx]);
80100a00:	81 c7 40 0f 11 80    	add    $0x80110f40,%edi
80100a06:	83 ec 0c             	sub    $0xc,%esp
80100a09:	57                   	push   %edi
80100a0a:	e8 11 ff ff ff       	call   80100920 <consputs>
80100a0f:	83 c4 10             	add    $0x10,%esp
}
80100a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a15:	5b                   	pop    %ebx
80100a16:	5e                   	pop    %esi
80100a17:	5f                   	pop    %edi
80100a18:	5d                   	pop    %ebp
80100a19:	c3                   	ret    
80100a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a20 <updateCmd>:
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	83 ec 0c             	sub    $0xc,%esp
  cmdSize = input.e - input.w;
80100a26:	a1 e4 14 11 80       	mov    0x801114e4,%eax
80100a2b:	8b 15 e8 14 11 80    	mov    0x801114e8,%edx
80100a31:	29 c2                	sub    %eax,%edx
  memmove(command, input.buf + input.w, cmdSize);
80100a33:	05 60 14 11 80       	add    $0x80111460,%eax
80100a38:	52                   	push   %edx
80100a39:	50                   	push   %eax
80100a3a:	68 a0 0e 11 80       	push   $0x80110ea0
  cmdSize = input.e - input.w;
80100a3f:	89 15 84 0e 11 80    	mov    %edx,0x80110e84
  memmove(command, input.buf + input.w, cmdSize);
80100a45:	e8 c6 4c 00 00       	call   80105710 <memmove>
}
80100a4a:	83 c4 10             	add    $0x10,%esp
80100a4d:	c9                   	leave  
80100a4e:	c3                   	ret    
80100a4f:	90                   	nop

80100a50 <findSuggestion>:
{
80100a50:	55                   	push   %ebp
80100a51:	89 e5                	mov    %esp,%ebp
80100a53:	57                   	push   %edi
80100a54:	56                   	push   %esi
  int idx = -1;
80100a55:	be ff ff ff ff       	mov    $0xffffffff,%esi
{
80100a5a:	53                   	push   %ebx
  for (int i = 0; i < MAX_HIST; i++)
80100a5b:	31 db                	xor    %ebx,%ebx
{
80100a5d:	83 ec 0c             	sub    $0xc,%esp
80100a60:	8b 7d 08             	mov    0x8(%ebp),%edi
80100a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a67:	90                   	nop
    if (!strncmp(cmd, history[i], size))
80100a68:	89 d8                	mov    %ebx,%eax
80100a6a:	83 ec 04             	sub    $0x4,%esp
80100a6d:	ff 75 0c             	push   0xc(%ebp)
80100a70:	c1 e0 07             	shl    $0x7,%eax
80100a73:	05 40 0f 11 80       	add    $0x80110f40,%eax
80100a78:	50                   	push   %eax
80100a79:	57                   	push   %edi
80100a7a:	e8 01 4d 00 00       	call   80105780 <strncmp>
80100a7f:	83 c4 10             	add    $0x10,%esp
80100a82:	85 c0                	test   %eax,%eax
80100a84:	0f 44 f3             	cmove  %ebx,%esi
  for (int i = 0; i < MAX_HIST; i++)
80100a87:	83 c3 01             	add    $0x1,%ebx
80100a8a:	83 fb 0a             	cmp    $0xa,%ebx
80100a8d:	75 d9                	jne    80100a68 <findSuggestion+0x18>
}
80100a8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a92:	89 f0                	mov    %esi,%eax
80100a94:	5b                   	pop    %ebx
80100a95:	5e                   	pop    %esi
80100a96:	5f                   	pop    %edi
80100a97:	5d                   	pop    %ebp
80100a98:	c3                   	ret    
80100a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100aa0 <suggestCmd>:
  if (!histUsed)
80100aa0:	a1 20 0f 11 80       	mov    0x80110f20,%eax
80100aa5:	85 c0                	test   %eax,%eax
80100aa7:	74 07                	je     80100ab0 <suggestCmd+0x10>
}
80100aa9:	c3                   	ret    
80100aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ab0:	e9 cb fe ff ff       	jmp    80100980 <suggestCmd.part.0>
80100ab5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ac0 <convertCmd>:
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	53                   	push   %ebx
80100ac4:	83 ec 04             	sub    $0x4,%esp
80100ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (wIndex < input.e)
80100aca:	8b 15 e8 14 11 80    	mov    0x801114e8,%edx
80100ad0:	39 d3                	cmp    %edx,%ebx
80100ad2:	73 4b                	jae    80100b1f <convertCmd+0x5f>
    if (input.buf[wIndex] <= '9' && input.buf[wIndex] >= '0')
80100ad4:	0f be 83 60 14 11 80 	movsbl -0x7feeeba0(%ebx),%eax
80100adb:	8d 48 d0             	lea    -0x30(%eax),%ecx
80100ade:	80 f9 09             	cmp    $0x9,%cl
80100ae1:	77 41                	ja     80100b24 <convertCmd+0x64>
  int incedNum = num + K;
80100ae3:	8d 50 02             	lea    0x2(%eax),%edx
    incedNum = incedNum - '9' + 'A' - 1;
80100ae6:	83 c0 09             	add    $0x9,%eax
80100ae9:	83 fa 39             	cmp    $0x39,%edx
80100aec:	0f 4f d0             	cmovg  %eax,%edx
  return incedNum;
80100aef:	88 93 60 14 11 80    	mov    %dl,-0x7feeeba0(%ebx)
  if (panicked)
80100af5:	a1 38 15 11 80       	mov    0x80111538,%eax
80100afa:	85 c0                	test   %eax,%eax
80100afc:	74 0a                	je     80100b08 <convertCmd+0x48>
80100afe:	fa                   	cli    
    for (;;)
80100aff:	eb fe                	jmp    80100aff <convertCmd+0x3f>
80100b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b08:	b8 00 01 00 00       	mov    $0x100,%eax
    wIndex++;
80100b0d:	83 c3 01             	add    $0x1,%ebx
80100b10:	e8 eb f8 ff ff       	call   80100400 <consputc.part.0>
  while (wIndex < input.e)
80100b15:	8b 15 e8 14 11 80    	mov    0x801114e8,%edx
80100b1b:	39 da                	cmp    %ebx,%edx
80100b1d:	77 b5                	ja     80100ad4 <convertCmd+0x14>
}
80100b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b22:	c9                   	leave  
80100b23:	c3                   	ret    
    else if (input.buf[wIndex] <= 'Z' && input.buf[wIndex] >= 'A')
80100b24:	8d 48 bf             	lea    -0x41(%eax),%ecx
80100b27:	80 f9 19             	cmp    $0x19,%cl
80100b2a:	76 13                	jbe    80100b3f <convertCmd+0x7f>
    else if (input.buf[wIndex] <= 'z' && input.buf[wIndex] >= 'a')
80100b2c:	8d 48 9f             	lea    -0x61(%eax),%ecx
80100b2f:	80 f9 19             	cmp    $0x19,%cl
80100b32:	77 16                	ja     80100b4a <convertCmd+0x8a>
  return 'A' + c - 'a';
80100b34:	83 e8 20             	sub    $0x20,%eax
80100b37:	88 83 60 14 11 80    	mov    %al,-0x7feeeba0(%ebx)
80100b3d:	eb b6                	jmp    80100af5 <convertCmd+0x35>
  return 'a' + c - 'A';
80100b3f:	83 c0 20             	add    $0x20,%eax
80100b42:	88 83 60 14 11 80    	mov    %al,-0x7feeeba0(%ebx)
80100b48:	eb ab                	jmp    80100af5 <convertCmd+0x35>
      for (int i = wIndex; i < input.e - 1; i++)
80100b4a:	83 ea 01             	sub    $0x1,%edx
80100b4d:	89 d8                	mov    %ebx,%eax
80100b4f:	39 da                	cmp    %ebx,%edx
80100b51:	76 19                	jbe    80100b6c <convertCmd+0xac>
80100b53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b57:	90                   	nop
        input.buf[i] = input.buf[i + 1];
80100b58:	0f b6 88 61 14 11 80 	movzbl -0x7feeeb9f(%eax),%ecx
80100b5f:	83 c0 01             	add    $0x1,%eax
80100b62:	88 88 5f 14 11 80    	mov    %cl,-0x7feeeba1(%eax)
      for (int i = wIndex; i < input.e - 1; i++)
80100b68:	39 d0                	cmp    %edx,%eax
80100b6a:	72 ec                	jb     80100b58 <convertCmd+0x98>
      input.e--;
80100b6c:	89 15 e8 14 11 80    	mov    %edx,0x801114e8
      wIndex -= 1;
80100b72:	83 eb 01             	sub    $0x1,%ebx
80100b75:	e9 7b ff ff ff       	jmp    80100af5 <convertCmd+0x35>
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <makeHist>:
  if (input.e - input.w == 1)
80100b80:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100b85:	2b 05 e4 14 11 80    	sub    0x801114e4,%eax
80100b8b:	83 f8 01             	cmp    $0x1,%eax
80100b8e:	0f 84 9c 00 00 00    	je     80100c30 <makeHist+0xb0>
{
80100b94:	55                   	push   %ebp
80100b95:	89 e5                	mov    %esp,%ebp
80100b97:	83 ec 0c             	sub    $0xc,%esp
  memset(history[historyQueueIdx], 0, INPUT_BUF);
80100b9a:	a1 40 14 11 80       	mov    0x80111440,%eax
80100b9f:	68 80 00 00 00       	push   $0x80
80100ba4:	c1 e0 07             	shl    $0x7,%eax
80100ba7:	6a 00                	push   $0x0
80100ba9:	05 40 0f 11 80       	add    $0x80110f40,%eax
80100bae:	50                   	push   %eax
80100baf:	e8 bc 4a 00 00       	call   80105670 <memset>
  memmove(history[historyQueueIdx], input.buf + input.w, input.e - input.w - 1);
80100bb4:	a1 e4 14 11 80       	mov    0x801114e4,%eax
80100bb9:	83 c4 0c             	add    $0xc,%esp
80100bbc:	89 c2                	mov    %eax,%edx
80100bbe:	05 60 14 11 80       	add    $0x80111460,%eax
80100bc3:	f7 d2                	not    %edx
80100bc5:	03 15 e8 14 11 80    	add    0x801114e8,%edx
80100bcb:	52                   	push   %edx
80100bcc:	50                   	push   %eax
80100bcd:	a1 40 14 11 80       	mov    0x80111440,%eax
80100bd2:	c1 e0 07             	shl    $0x7,%eax
80100bd5:	05 40 0f 11 80       	add    $0x80110f40,%eax
80100bda:	50                   	push   %eax
80100bdb:	e8 30 4b 00 00       	call   80105710 <memmove>
  historyQueueIdx = (historyQueueIdx + 1) % MAX_HIST;
80100be0:	a1 40 14 11 80       	mov    0x80111440,%eax
80100be5:	ba 67 66 66 66       	mov    $0x66666667,%edx
  memset(command, 0, INPUT_BUF);
80100bea:	83 c4 0c             	add    $0xc,%esp
80100bed:	68 80 00 00 00       	push   $0x80
  historyQueueIdx = (historyQueueIdx + 1) % MAX_HIST;
80100bf2:	8d 48 01             	lea    0x1(%eax),%ecx
  memset(command, 0, INPUT_BUF);
80100bf5:	6a 00                	push   $0x0
  historyQueueIdx = (historyQueueIdx + 1) % MAX_HIST;
80100bf7:	89 c8                	mov    %ecx,%eax
  memset(command, 0, INPUT_BUF);
80100bf9:	68 a0 0e 11 80       	push   $0x80110ea0
  histUsed = 0;
80100bfe:	c7 05 20 0f 11 80 00 	movl   $0x0,0x80110f20
80100c05:	00 00 00 
  historyQueueIdx = (historyQueueIdx + 1) % MAX_HIST;
80100c08:	f7 ea                	imul   %edx
80100c0a:	89 c8                	mov    %ecx,%eax
80100c0c:	c1 f8 1f             	sar    $0x1f,%eax
80100c0f:	c1 fa 02             	sar    $0x2,%edx
80100c12:	29 c2                	sub    %eax,%edx
80100c14:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100c17:	01 c0                	add    %eax,%eax
80100c19:	29 c1                	sub    %eax,%ecx
80100c1b:	89 0d 40 14 11 80    	mov    %ecx,0x80111440
  memset(command, 0, INPUT_BUF);
80100c21:	e8 4a 4a 00 00       	call   80105670 <memset>
80100c26:	83 c4 10             	add    $0x10,%esp
}
80100c29:	c9                   	leave  
80100c2a:	c3                   	ret    
80100c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
80100c30:	c3                   	ret    
80100c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c3f:	90                   	nop

80100c40 <copyBuf>:
{
80100c40:	55                   	push   %ebp
80100c41:	89 e5                	mov    %esp,%ebp
80100c43:	56                   	push   %esi
80100c44:	53                   	push   %ebx
80100c45:	8b 75 08             	mov    0x8(%ebp),%esi
80100c48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  memset(copiedBuffer, 0, K);
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	6a 02                	push   $0x2
80100c50:	6a 00                	push   $0x0
80100c52:	68 f0 14 11 80       	push   $0x801114f0
80100c57:	e8 14 4a 00 00       	call   80105670 <memset>
  for (int i = copyPos; i < eIndex; i++)
80100c5c:	83 c4 10             	add    $0x10,%esp
80100c5f:	39 de                	cmp    %ebx,%esi
80100c61:	7d 3a                	jge    80100c9d <copyBuf+0x5d>
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100c63:	89 f2                	mov    %esi,%edx
80100c65:	c1 fa 1f             	sar    $0x1f,%edx
80100c68:	c1 ea 19             	shr    $0x19,%edx
80100c6b:	8d 04 16             	lea    (%esi,%edx,1),%eax
80100c6e:	83 e0 7f             	and    $0x7f,%eax
80100c71:	29 d0                	sub    %edx,%eax
80100c73:	0f b6 80 60 14 11 80 	movzbl -0x7feeeba0(%eax),%eax
80100c7a:	a2 f0 14 11 80       	mov    %al,0x801114f0
  for (int i = copyPos; i < eIndex; i++)
80100c7f:	8d 46 01             	lea    0x1(%esi),%eax
80100c82:	39 c3                	cmp    %eax,%ebx
80100c84:	7e 17                	jle    80100c9d <copyBuf+0x5d>
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100c86:	99                   	cltd   
80100c87:	c1 ea 19             	shr    $0x19,%edx
80100c8a:	01 d0                	add    %edx,%eax
80100c8c:	83 e0 7f             	and    $0x7f,%eax
80100c8f:	29 d0                	sub    %edx,%eax
80100c91:	0f b6 80 60 14 11 80 	movzbl -0x7feeeba0(%eax),%eax
80100c98:	a2 f1 14 11 80       	mov    %al,0x801114f1
  pasteSize = eIndex - copyPos;
80100c9d:	29 f3                	sub    %esi,%ebx
80100c9f:	89 1d ec 14 11 80    	mov    %ebx,0x801114ec
}
80100ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100ca8:	5b                   	pop    %ebx
80100ca9:	5e                   	pop    %esi
80100caa:	5d                   	pop    %ebp
80100cab:	c3                   	ret    
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100cb0 <consoleintr>:
{
80100cb0:	55                   	push   %ebp
80100cb1:	89 e5                	mov    %esp,%ebp
80100cb3:	57                   	push   %edi
80100cb4:	56                   	push   %esi
80100cb5:	53                   	push   %ebx
80100cb6:	83 ec 38             	sub    $0x38,%esp
  int eIndex = input.e;
80100cb9:	8b 1d e8 14 11 80    	mov    0x801114e8,%ebx
  int wIndex = input.w;
80100cbf:	8b 3d e4 14 11 80    	mov    0x801114e4,%edi
  acquire(&cons.lock);
80100cc5:	68 00 15 11 80       	push   $0x80111500
{
80100cca:	8b 45 08             	mov    0x8(%ebp),%eax
  int copyPos = input.w > input.e - K ? input.w : input.e - K;
80100ccd:	8d 73 fe             	lea    -0x2(%ebx),%esi
  int eIndex = input.e;
80100cd0:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  int copyPos = input.w > input.e - K ? input.w : input.e - K;
80100cd3:	39 fe                	cmp    %edi,%esi
{
80100cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int copyPos = input.w > input.e - K ? input.w : input.e - K;
80100cd8:	0f 42 f7             	cmovb  %edi,%esi
  acquire(&cons.lock);
80100cdb:	e8 d0 48 00 00       	call   801055b0 <acquire>
  int c, doprocdump = 0;
80100ce0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  while ((c = getc()) >= 0)
80100ce7:	83 c4 10             	add    $0x10,%esp
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100cea:	89 f0                	mov    %esi,%eax
  for (int i = copyPos; i < eIndex; i++)
80100cec:	8d 4e 01             	lea    0x1(%esi),%ecx
  pasteSize = eIndex - copyPos;
80100cef:	29 f3                	sub    %esi,%ebx
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100cf1:	c1 f8 1f             	sar    $0x1f,%eax
  for (int i = copyPos; i < eIndex; i++)
80100cf4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100cf7:	c1 e8 19             	shr    $0x19,%eax
  pasteSize = eIndex - copyPos;
80100cfa:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100cfd:	8d 14 06             	lea    (%esi,%eax,1),%edx
80100d00:	83 e2 7f             	and    $0x7f,%edx
80100d03:	29 c2                	sub    %eax,%edx
80100d05:	89 c8                	mov    %ecx,%eax
80100d07:	c1 f8 1f             	sar    $0x1f,%eax
80100d0a:	89 55 d0             	mov    %edx,-0x30(%ebp)
80100d0d:	c1 e8 19             	shr    $0x19,%eax
80100d10:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80100d13:	83 e2 7f             	and    $0x7f,%edx
80100d16:	29 c2                	sub    %eax,%edx
80100d18:	89 55 cc             	mov    %edx,-0x34(%ebp)
  while ((c = getc()) >= 0)
80100d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d1e:	ff d0                	call   *%eax
80100d20:	89 c3                	mov    %eax,%ebx
80100d22:	85 c0                	test   %eax,%eax
80100d24:	0f 88 06 01 00 00    	js     80100e30 <consoleintr+0x180>
    switch (c)
80100d2a:	83 fb 15             	cmp    $0x15,%ebx
80100d2d:	7f 21                	jg     80100d50 <consoleintr+0xa0>
80100d2f:	83 fb 04             	cmp    $0x4,%ebx
80100d32:	0f 8e 30 02 00 00    	jle    80100f68 <consoleintr+0x2b8>
80100d38:	8d 43 fb             	lea    -0x5(%ebx),%eax
80100d3b:	83 f8 10             	cmp    $0x10,%eax
80100d3e:	0f 87 24 02 00 00    	ja     80100f68 <consoleintr+0x2b8>
80100d44:	ff 24 85 d0 85 10 80 	jmp    *-0x7fef7a30(,%eax,4)
80100d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d4f:	90                   	nop
80100d50:	83 fb 56             	cmp    $0x56,%ebx
80100d53:	0f 84 cf 01 00 00    	je     80100f28 <consoleintr+0x278>
80100d59:	7e 75                	jle    80100dd0 <consoleintr+0x120>
80100d5b:	83 fb 58             	cmp    $0x58,%ebx
80100d5e:	0f 85 f4 00 00 00    	jne    80100e58 <consoleintr+0x1a8>
  memset(copiedBuffer, 0, K);
80100d64:	83 ec 04             	sub    $0x4,%esp
80100d67:	6a 02                	push   $0x2
80100d69:	6a 00                	push   $0x0
80100d6b:	68 f0 14 11 80       	push   $0x801114f0
80100d70:	e8 fb 48 00 00       	call   80105670 <memset>
  for (int i = copyPos; i < eIndex; i++)
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80100d7b:	0f 8e 97 00 00 00    	jle    80100e18 <consoleintr+0x168>
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100d81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  for (int i = copyPos; i < eIndex; i++)
80100d84:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100d87:	0f b6 80 60 14 11 80 	movzbl -0x7feeeba0(%eax),%eax
80100d8e:	a2 f0 14 11 80       	mov    %al,0x801114f0
  for (int i = copyPos; i < eIndex; i++)
80100d93:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
80100d96:	7d 0f                	jge    80100da7 <consoleintr+0xf7>
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100d98:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100d9b:	0f b6 80 60 14 11 80 	movzbl -0x7feeeba0(%eax),%eax
80100da2:	a2 f1 14 11 80       	mov    %al,0x801114f1
  pasteSize = eIndex - copyPos;
80100da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100daa:	31 db                	xor    %ebx,%ebx
80100dac:	a3 ec 14 11 80       	mov    %eax,0x801114ec
  if (panicked)
80100db1:	a1 38 15 11 80       	mov    0x80111538,%eax
        input.e--;
80100db6:	83 2d e8 14 11 80 01 	subl   $0x1,0x801114e8
  if (panicked)
80100dbd:	85 c0                	test   %eax,%eax
80100dbf:	0f 84 a8 02 00 00    	je     8010106d <consoleintr+0x3bd>
80100dc5:	fa                   	cli    
    for (;;)
80100dc6:	eb fe                	jmp    80100dc6 <consoleintr+0x116>
80100dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100dcf:	90                   	nop
    switch (c)
80100dd0:	83 fb 43             	cmp    $0x43,%ebx
80100dd3:	0f 85 97 01 00 00    	jne    80100f70 <consoleintr+0x2c0>
  memset(copiedBuffer, 0, K);
80100dd9:	83 ec 04             	sub    $0x4,%esp
80100ddc:	6a 02                	push   $0x2
80100dde:	6a 00                	push   $0x0
80100de0:	68 f0 14 11 80       	push   $0x801114f0
80100de5:	e8 86 48 00 00       	call   80105670 <memset>
  for (int i = copyPos; i < eIndex; i++)
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80100df0:	7e 26                	jle    80100e18 <consoleintr+0x168>
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100df2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  for (int i = copyPos; i < eIndex; i++)
80100df5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100df8:	0f b6 80 60 14 11 80 	movzbl -0x7feeeba0(%eax),%eax
80100dff:	a2 f0 14 11 80       	mov    %al,0x801114f0
  for (int i = copyPos; i < eIndex; i++)
80100e04:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
80100e07:	7d 0f                	jge    80100e18 <consoleintr+0x168>
    copiedBuffer[i - copyPos] = input.buf[i % INPUT_BUF];
80100e09:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100e0c:	0f b6 80 60 14 11 80 	movzbl -0x7feeeba0(%eax),%eax
80100e13:	a2 f1 14 11 80       	mov    %al,0x801114f1
  pasteSize = eIndex - copyPos;
80100e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1b:	a3 ec 14 11 80       	mov    %eax,0x801114ec
  while ((c = getc()) >= 0)
80100e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e23:	ff d0                	call   *%eax
80100e25:	89 c3                	mov    %eax,%ebx
80100e27:	85 c0                	test   %eax,%eax
80100e29:	0f 89 fb fe ff ff    	jns    80100d2a <consoleintr+0x7a>
80100e2f:	90                   	nop
  release(&cons.lock);
80100e30:	83 ec 0c             	sub    $0xc,%esp
80100e33:	68 00 15 11 80       	push   $0x80111500
80100e38:	e8 13 47 00 00       	call   80105550 <release>
  if (doprocdump)
80100e3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100e40:	83 c4 10             	add    $0x10,%esp
80100e43:	85 c0                	test   %eax,%eax
80100e45:	0f 85 16 02 00 00    	jne    80101061 <consoleintr+0x3b1>
}
80100e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e4e:	5b                   	pop    %ebx
80100e4f:	5e                   	pop    %esi
80100e50:	5f                   	pop    %edi
80100e51:	5d                   	pop    %ebp
80100e52:	c3                   	ret    
80100e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e57:	90                   	nop
    switch (c)
80100e58:	83 fb 7f             	cmp    $0x7f,%ebx
80100e5b:	0f 85 0f 01 00 00    	jne    80100f70 <consoleintr+0x2c0>
      if (input.e != input.w)
80100e61:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100e66:	3b 05 e4 14 11 80    	cmp    0x801114e4,%eax
80100e6c:	0f 84 a9 fe ff ff    	je     80100d1b <consoleintr+0x6b>
        input.e--;
80100e72:	83 e8 01             	sub    $0x1,%eax
80100e75:	a3 e8 14 11 80       	mov    %eax,0x801114e8
  if (panicked)
80100e7a:	a1 38 15 11 80       	mov    0x80111538,%eax
80100e7f:	85 c0                	test   %eax,%eax
80100e81:	0f 84 04 02 00 00    	je     8010108b <consoleintr+0x3db>
80100e87:	fa                   	cli    
    for (;;)
80100e88:	eb fe                	jmp    80100e88 <consoleintr+0x1d8>
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      convertCmd(wIndex);
80100e90:	83 ec 0c             	sub    $0xc,%esp
80100e93:	57                   	push   %edi
80100e94:	e8 27 fc ff ff       	call   80100ac0 <convertCmd>
      for (wIndex = input.w; wIndex < input.e; wIndex++)
80100e99:	8b 3d e4 14 11 80    	mov    0x801114e4,%edi
80100e9f:	83 c4 10             	add    $0x10,%esp
80100ea2:	3b 3d e8 14 11 80    	cmp    0x801114e8,%edi
80100ea8:	0f 83 6d fe ff ff    	jae    80100d1b <consoleintr+0x6b>
  if (panicked)
80100eae:	8b 0d 38 15 11 80    	mov    0x80111538,%ecx
        consputc(input.buf[wIndex]);
80100eb4:	0f be 87 60 14 11 80 	movsbl -0x7feeeba0(%edi),%eax
  if (panicked)
80100ebb:	85 c9                	test   %ecx,%ecx
80100ebd:	0f 84 5d 01 00 00    	je     80101020 <consoleintr+0x370>
80100ec3:	fa                   	cli    
    for (;;)
80100ec4:	eb fe                	jmp    80100ec4 <consoleintr+0x214>
80100ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ecd:	8d 76 00             	lea    0x0(%esi),%esi
  if (!histUsed)
80100ed0:	8b 15 20 0f 11 80    	mov    0x80110f20,%edx
80100ed6:	85 d2                	test   %edx,%edx
80100ed8:	0f 85 3d fe ff ff    	jne    80100d1b <consoleintr+0x6b>
80100ede:	e8 9d fa ff ff       	call   80100980 <suggestCmd.part.0>
80100ee3:	e9 33 fe ff ff       	jmp    80100d1b <consoleintr+0x6b>
      while (input.e != input.w &&
80100ee8:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100eed:	39 05 e4 14 11 80    	cmp    %eax,0x801114e4
80100ef3:	0f 84 22 fe ff ff    	je     80100d1b <consoleintr+0x6b>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
80100ef9:	83 e8 01             	sub    $0x1,%eax
80100efc:	89 c2                	mov    %eax,%edx
80100efe:	83 e2 7f             	and    $0x7f,%edx
      while (input.e != input.w &&
80100f01:	80 ba 60 14 11 80 0a 	cmpb   $0xa,-0x7feeeba0(%edx)
80100f08:	0f 84 0d fe ff ff    	je     80100d1b <consoleintr+0x6b>
        input.e--;
80100f0e:	a3 e8 14 11 80       	mov    %eax,0x801114e8
  if (panicked)
80100f13:	a1 38 15 11 80       	mov    0x80111538,%eax
80100f18:	85 c0                	test   %eax,%eax
80100f1a:	0f 84 e0 00 00 00    	je     80101000 <consoleintr+0x350>
80100f20:	fa                   	cli    
    for (;;)
80100f21:	eb fe                	jmp    80100f21 <consoleintr+0x271>
80100f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f27:	90                   	nop
      for (int i = 0; i < pasteSize; i++)
80100f28:	a1 ec 14 11 80       	mov    0x801114ec,%eax
80100f2d:	31 db                	xor    %ebx,%ebx
80100f2f:	85 c0                	test   %eax,%eax
80100f31:	0f 8e e4 fd ff ff    	jle    80100d1b <consoleintr+0x6b>
        input.buf[input.e++ % INPUT_BUF] = copiedBuffer[i];
80100f37:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100f3c:	8d 50 01             	lea    0x1(%eax),%edx
80100f3f:	83 e0 7f             	and    $0x7f,%eax
80100f42:	89 15 e8 14 11 80    	mov    %edx,0x801114e8
80100f48:	0f b6 93 f0 14 11 80 	movzbl -0x7feeeb10(%ebx),%edx
80100f4f:	88 90 60 14 11 80    	mov    %dl,-0x7feeeba0(%eax)
  if (panicked)
80100f55:	a1 38 15 11 80       	mov    0x80111538,%eax
80100f5a:	85 c0                	test   %eax,%eax
80100f5c:	0f 84 e3 00 00 00    	je     80101045 <consoleintr+0x395>
80100f62:	fa                   	cli    
    for (;;)
80100f63:	eb fe                	jmp    80100f63 <consoleintr+0x2b3>
80100f65:	8d 76 00             	lea    0x0(%esi),%esi
      if (c != 0 && input.e - input.r < INPUT_BUF)
80100f68:	85 db                	test   %ebx,%ebx
80100f6a:	0f 84 ab fd ff ff    	je     80100d1b <consoleintr+0x6b>
80100f70:	a1 e8 14 11 80       	mov    0x801114e8,%eax
80100f75:	89 c2                	mov    %eax,%edx
80100f77:	2b 15 e0 14 11 80    	sub    0x801114e0,%edx
80100f7d:	83 fa 7f             	cmp    $0x7f,%edx
80100f80:	0f 87 95 fd ff ff    	ja     80100d1b <consoleintr+0x6b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100f86:	8d 48 01             	lea    0x1(%eax),%ecx
  if (panicked)
80100f89:	8b 15 38 15 11 80    	mov    0x80111538,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100f8f:	83 e0 7f             	and    $0x7f,%eax
80100f92:	89 0d e8 14 11 80    	mov    %ecx,0x801114e8
        c = (c == '\r') ? '\n' : c;
80100f98:	83 fb 0d             	cmp    $0xd,%ebx
80100f9b:	0f 84 f9 00 00 00    	je     8010109a <consoleintr+0x3ea>
        input.buf[input.e++ % INPUT_BUF] = c;
80100fa1:	88 98 60 14 11 80    	mov    %bl,-0x7feeeba0(%eax)
  if (panicked)
80100fa7:	85 d2                	test   %edx,%edx
80100fa9:	0f 85 05 01 00 00    	jne    801010b4 <consoleintr+0x404>
80100faf:	89 d8                	mov    %ebx,%eax
80100fb1:	e8 4a f4 ff ff       	call   80100400 <consputc.part.0>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
80100fb6:	83 fb 0a             	cmp    $0xa,%ebx
80100fb9:	74 19                	je     80100fd4 <consoleintr+0x324>
80100fbb:	83 fb 04             	cmp    $0x4,%ebx
80100fbe:	74 14                	je     80100fd4 <consoleintr+0x324>
80100fc0:	a1 e0 14 11 80       	mov    0x801114e0,%eax
80100fc5:	83 e8 80             	sub    $0xffffff80,%eax
80100fc8:	39 05 e8 14 11 80    	cmp    %eax,0x801114e8
80100fce:	0f 85 47 fd ff ff    	jne    80100d1b <consoleintr+0x6b>
          makeHist();
80100fd4:	e8 a7 fb ff ff       	call   80100b80 <makeHist>
          wakeup(&input.r);
80100fd9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100fdc:	a1 e8 14 11 80       	mov    0x801114e8,%eax
          wakeup(&input.r);
80100fe1:	68 e0 14 11 80       	push   $0x801114e0
          input.w = input.e;
80100fe6:	a3 e4 14 11 80       	mov    %eax,0x801114e4
          wakeup(&input.r);
80100feb:	e8 c0 3b 00 00       	call   80104bb0 <wakeup>
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	e9 23 fd ff ff       	jmp    80100d1b <consoleintr+0x6b>
80100ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fff:	90                   	nop
80101000:	b8 00 01 00 00       	mov    $0x100,%eax
80101005:	e8 f6 f3 ff ff       	call   80100400 <consputc.part.0>
      while (input.e != input.w &&
8010100a:	a1 e8 14 11 80       	mov    0x801114e8,%eax
8010100f:	3b 05 e4 14 11 80    	cmp    0x801114e4,%eax
80101015:	0f 85 de fe ff ff    	jne    80100ef9 <consoleintr+0x249>
8010101b:	e9 fb fc ff ff       	jmp    80100d1b <consoleintr+0x6b>
80101020:	e8 db f3 ff ff       	call   80100400 <consputc.part.0>
      for (wIndex = input.w; wIndex < input.e; wIndex++)
80101025:	83 c7 01             	add    $0x1,%edi
80101028:	39 3d e8 14 11 80    	cmp    %edi,0x801114e8
8010102e:	0f 87 7a fe ff ff    	ja     80100eae <consoleintr+0x1fe>
80101034:	e9 e2 fc ff ff       	jmp    80100d1b <consoleintr+0x6b>
    switch (c)
80101039:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
80101040:	e9 d6 fc ff ff       	jmp    80100d1b <consoleintr+0x6b>
        consputc(copiedBuffer[i]);
80101045:	0f be c2             	movsbl %dl,%eax
      for (int i = 0; i < pasteSize; i++)
80101048:	83 c3 01             	add    $0x1,%ebx
8010104b:	e8 b0 f3 ff ff       	call   80100400 <consputc.part.0>
80101050:	39 1d ec 14 11 80    	cmp    %ebx,0x801114ec
80101056:	0f 8f db fe ff ff    	jg     80100f37 <consoleintr+0x287>
8010105c:	e9 ba fc ff ff       	jmp    80100d1b <consoleintr+0x6b>
}
80101061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101064:	5b                   	pop    %ebx
80101065:	5e                   	pop    %esi
80101066:	5f                   	pop    %edi
80101067:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
80101068:	e9 23 3c 00 00       	jmp    80104c90 <procdump>
8010106d:	b8 00 01 00 00       	mov    $0x100,%eax
      for (int i = 0; i < pasteSize; i++)
80101072:	83 c3 01             	add    $0x1,%ebx
80101075:	e8 86 f3 ff ff       	call   80100400 <consputc.part.0>
8010107a:	39 1d ec 14 11 80    	cmp    %ebx,0x801114ec
80101080:	0f 8f 2b fd ff ff    	jg     80100db1 <consoleintr+0x101>
80101086:	e9 90 fc ff ff       	jmp    80100d1b <consoleintr+0x6b>
8010108b:	b8 00 01 00 00       	mov    $0x100,%eax
80101090:	e8 6b f3 ff ff       	call   80100400 <consputc.part.0>
80101095:	e9 81 fc ff ff       	jmp    80100d1b <consoleintr+0x6b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010109a:	c6 80 60 14 11 80 0a 	movb   $0xa,-0x7feeeba0(%eax)
  if (panicked)
801010a1:	85 d2                	test   %edx,%edx
801010a3:	75 0f                	jne    801010b4 <consoleintr+0x404>
801010a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801010aa:	e8 51 f3 ff ff       	call   80100400 <consputc.part.0>
        if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF)
801010af:	e9 20 ff ff ff       	jmp    80100fd4 <consoleintr+0x324>
801010b4:	fa                   	cli    
    for (;;)
801010b5:	eb fe                	jmp    801010b5 <consoleintr+0x405>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax

801010c0 <consoleinit>:

void consoleinit(void)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801010c6:	68 c8 85 10 80       	push   $0x801085c8
801010cb:	68 00 15 11 80       	push   $0x80111500
801010d0:	e8 0b 43 00 00       	call   801053e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801010d5:	58                   	pop    %eax
801010d6:	5a                   	pop    %edx
801010d7:	6a 00                	push   $0x0
801010d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801010db:	c7 05 ec 1e 11 80 90 	movl   $0x80100590,0x80111eec
801010e2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801010e5:	c7 05 e8 1e 11 80 80 	movl   $0x80100280,0x80111ee8
801010ec:	02 10 80 
  cons.locking = 1;
801010ef:	c7 05 34 15 11 80 01 	movl   $0x1,0x80111534
801010f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801010f9:	e8 e2 19 00 00       	call   80102ae0 <ioapicenable>
}
801010fe:	83 c4 10             	add    $0x10,%esp
80101101:	c9                   	leave  
80101102:	c3                   	ret    
80101103:	66 90                	xchg   %ax,%ax
80101105:	66 90                	xchg   %ax,%ax
80101107:	66 90                	xchg   %ax,%ax
80101109:	66 90                	xchg   %ax,%ax
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010111c:	e8 7f 2f 00 00       	call   801040a0 <myproc>
80101121:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101127:	e8 94 22 00 00       	call   801033c0 <begin_op>

  if((ip = namei(path)) == 0){
8010112c:	83 ec 0c             	sub    $0xc,%esp
8010112f:	ff 75 08             	push   0x8(%ebp)
80101132:	e8 c9 15 00 00       	call   80102700 <namei>
80101137:	83 c4 10             	add    $0x10,%esp
8010113a:	85 c0                	test   %eax,%eax
8010113c:	0f 84 02 03 00 00    	je     80101444 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101142:	83 ec 0c             	sub    $0xc,%esp
80101145:	89 c3                	mov    %eax,%ebx
80101147:	50                   	push   %eax
80101148:	e8 93 0c 00 00       	call   80101de0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010114d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101153:	6a 34                	push   $0x34
80101155:	6a 00                	push   $0x0
80101157:	50                   	push   %eax
80101158:	53                   	push   %ebx
80101159:	e8 92 0f 00 00       	call   801020f0 <readi>
8010115e:	83 c4 20             	add    $0x20,%esp
80101161:	83 f8 34             	cmp    $0x34,%eax
80101164:	74 22                	je     80101188 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101166:	83 ec 0c             	sub    $0xc,%esp
80101169:	53                   	push   %ebx
8010116a:	e8 01 0f 00 00       	call   80102070 <iunlockput>
    end_op();
8010116f:	e8 bc 22 00 00       	call   80103430 <end_op>
80101174:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
80101184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101188:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010118f:	45 4c 46 
80101192:	75 d2                	jne    80101166 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101194:	e8 87 6e 00 00       	call   80108020 <setupkvm>
80101199:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010119f:	85 c0                	test   %eax,%eax
801011a1:	74 c3                	je     80101166 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011a3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801011aa:	00 
801011ab:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801011b1:	0f 84 ac 02 00 00    	je     80101463 <exec+0x353>
  sz = 0;
801011b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801011be:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801011c1:	31 ff                	xor    %edi,%edi
801011c3:	e9 8e 00 00 00       	jmp    80101256 <exec+0x146>
801011c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011cf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
801011d0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801011d7:	75 6c                	jne    80101245 <exec+0x135>
    if(ph.memsz < ph.filesz)
801011d9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801011df:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801011e5:	0f 82 87 00 00 00    	jb     80101272 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801011eb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801011f1:	72 7f                	jb     80101272 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801011f3:	83 ec 04             	sub    $0x4,%esp
801011f6:	50                   	push   %eax
801011f7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801011fd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101203:	e8 38 6c 00 00       	call   80107e40 <allocuvm>
80101208:	83 c4 10             	add    $0x10,%esp
8010120b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101211:	85 c0                	test   %eax,%eax
80101213:	74 5d                	je     80101272 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101215:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010121b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101220:	75 50                	jne    80101272 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101222:	83 ec 0c             	sub    $0xc,%esp
80101225:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010122b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101231:	53                   	push   %ebx
80101232:	50                   	push   %eax
80101233:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101239:	e8 12 6b 00 00       	call   80107d50 <loaduvm>
8010123e:	83 c4 20             	add    $0x20,%esp
80101241:	85 c0                	test   %eax,%eax
80101243:	78 2d                	js     80101272 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101245:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010124c:	83 c7 01             	add    $0x1,%edi
8010124f:	83 c6 20             	add    $0x20,%esi
80101252:	39 f8                	cmp    %edi,%eax
80101254:	7e 3a                	jle    80101290 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101256:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010125c:	6a 20                	push   $0x20
8010125e:	56                   	push   %esi
8010125f:	50                   	push   %eax
80101260:	53                   	push   %ebx
80101261:	e8 8a 0e 00 00       	call   801020f0 <readi>
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	83 f8 20             	cmp    $0x20,%eax
8010126c:	0f 84 5e ff ff ff    	je     801011d0 <exec+0xc0>
    freevm(pgdir);
80101272:	83 ec 0c             	sub    $0xc,%esp
80101275:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010127b:	e8 20 6d 00 00       	call   80107fa0 <freevm>
  if(ip){
80101280:	83 c4 10             	add    $0x10,%esp
80101283:	e9 de fe ff ff       	jmp    80101166 <exec+0x56>
80101288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128f:	90                   	nop
  sz = PGROUNDUP(sz);
80101290:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101296:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010129c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801012a2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801012a8:	83 ec 0c             	sub    $0xc,%esp
801012ab:	53                   	push   %ebx
801012ac:	e8 bf 0d 00 00       	call   80102070 <iunlockput>
  end_op();
801012b1:	e8 7a 21 00 00       	call   80103430 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801012b6:	83 c4 0c             	add    $0xc,%esp
801012b9:	56                   	push   %esi
801012ba:	57                   	push   %edi
801012bb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801012c1:	57                   	push   %edi
801012c2:	e8 79 6b 00 00       	call   80107e40 <allocuvm>
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	89 c6                	mov    %eax,%esi
801012cc:	85 c0                	test   %eax,%eax
801012ce:	0f 84 94 00 00 00    	je     80101368 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012d4:	83 ec 08             	sub    $0x8,%esp
801012d7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801012dd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012df:	50                   	push   %eax
801012e0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801012e1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801012e3:	e8 d8 6d 00 00       	call   801080c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801012eb:	83 c4 10             	add    $0x10,%esp
801012ee:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801012f4:	8b 00                	mov    (%eax),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	0f 84 8b 00 00 00    	je     80101389 <exec+0x279>
801012fe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101304:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010130a:	eb 23                	jmp    8010132f <exec+0x21f>
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101310:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101313:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010131a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010131d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101323:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101326:	85 c0                	test   %eax,%eax
80101328:	74 59                	je     80101383 <exec+0x273>
    if(argc >= MAXARG)
8010132a:	83 ff 20             	cmp    $0x20,%edi
8010132d:	74 39                	je     80101368 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	50                   	push   %eax
80101333:	e8 38 45 00 00       	call   80105870 <strlen>
80101338:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010133a:	58                   	pop    %eax
8010133b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010133e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101341:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101344:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101347:	e8 24 45 00 00       	call   80105870 <strlen>
8010134c:	83 c0 01             	add    $0x1,%eax
8010134f:	50                   	push   %eax
80101350:	8b 45 0c             	mov    0xc(%ebp),%eax
80101353:	ff 34 b8             	push   (%eax,%edi,4)
80101356:	53                   	push   %ebx
80101357:	56                   	push   %esi
80101358:	e8 33 6f 00 00       	call   80108290 <copyout>
8010135d:	83 c4 20             	add    $0x20,%esp
80101360:	85 c0                	test   %eax,%eax
80101362:	79 ac                	jns    80101310 <exec+0x200>
80101364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101371:	e8 2a 6c 00 00       	call   80107fa0 <freevm>
80101376:	83 c4 10             	add    $0x10,%esp
  return -1;
80101379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137e:	e9 f9 fd ff ff       	jmp    8010117c <exec+0x6c>
80101383:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101389:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101390:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101392:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101399:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010139d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010139f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801013a2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801013a8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801013aa:	50                   	push   %eax
801013ab:	52                   	push   %edx
801013ac:	53                   	push   %ebx
801013ad:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801013b3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801013ba:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801013bd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801013c3:	e8 c8 6e 00 00       	call   80108290 <copyout>
801013c8:	83 c4 10             	add    $0x10,%esp
801013cb:	85 c0                	test   %eax,%eax
801013cd:	78 99                	js     80101368 <exec+0x258>
  for(last=s=path; *s; s++)
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	8b 55 08             	mov    0x8(%ebp),%edx
801013d5:	0f b6 00             	movzbl (%eax),%eax
801013d8:	84 c0                	test   %al,%al
801013da:	74 13                	je     801013ef <exec+0x2df>
801013dc:	89 d1                	mov    %edx,%ecx
801013de:	66 90                	xchg   %ax,%ax
      last = s+1;
801013e0:	83 c1 01             	add    $0x1,%ecx
801013e3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801013e5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
801013e8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801013eb:	84 c0                	test   %al,%al
801013ed:	75 f1                	jne    801013e0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801013ef:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801013f5:	83 ec 04             	sub    $0x4,%esp
801013f8:	6a 10                	push   $0x10
801013fa:	89 f8                	mov    %edi,%eax
801013fc:	52                   	push   %edx
801013fd:	83 c0 6c             	add    $0x6c,%eax
80101400:	50                   	push   %eax
80101401:	e8 2a 44 00 00       	call   80105830 <safestrcpy>
  curproc->pgdir = pgdir;
80101406:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010140c:	89 f8                	mov    %edi,%eax
8010140e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101411:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101413:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101416:	89 c1                	mov    %eax,%ecx
80101418:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010141e:	8b 40 18             	mov    0x18(%eax),%eax
80101421:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101424:	8b 41 18             	mov    0x18(%ecx),%eax
80101427:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010142a:	89 0c 24             	mov    %ecx,(%esp)
8010142d:	e8 8e 67 00 00       	call   80107bc0 <switchuvm>
  freevm(oldpgdir);
80101432:	89 3c 24             	mov    %edi,(%esp)
80101435:	e8 66 6b 00 00       	call   80107fa0 <freevm>
  return 0;
8010143a:	83 c4 10             	add    $0x10,%esp
8010143d:	31 c0                	xor    %eax,%eax
8010143f:	e9 38 fd ff ff       	jmp    8010117c <exec+0x6c>
    end_op();
80101444:	e8 e7 1f 00 00       	call   80103430 <end_op>
    cprintf("exec: fail\n");
80101449:	83 ec 0c             	sub    $0xc,%esp
8010144c:	68 25 86 10 80       	push   $0x80108625
80101451:	e8 4a f2 ff ff       	call   801006a0 <cprintf>
    return -1;
80101456:	83 c4 10             	add    $0x10,%esp
80101459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010145e:	e9 19 fd ff ff       	jmp    8010117c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101463:	be 00 20 00 00       	mov    $0x2000,%esi
80101468:	31 ff                	xor    %edi,%edi
8010146a:	e9 39 fe ff ff       	jmp    801012a8 <exec+0x198>
8010146f:	90                   	nop

80101470 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101476:	68 31 86 10 80       	push   $0x80108631
8010147b:	68 40 15 11 80       	push   $0x80111540
80101480:	e8 5b 3f 00 00       	call   801053e0 <initlock>
}
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	c9                   	leave  
80101489:	c3                   	ret    
8010148a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101490 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101494:	bb 74 15 11 80       	mov    $0x80111574,%ebx
{
80101499:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010149c:	68 40 15 11 80       	push   $0x80111540
801014a1:	e8 0a 41 00 00       	call   801055b0 <acquire>
801014a6:	83 c4 10             	add    $0x10,%esp
801014a9:	eb 10                	jmp    801014bb <filealloc+0x2b>
801014ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014af:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801014b0:	83 c3 18             	add    $0x18,%ebx
801014b3:	81 fb d4 1e 11 80    	cmp    $0x80111ed4,%ebx
801014b9:	74 25                	je     801014e0 <filealloc+0x50>
    if(f->ref == 0){
801014bb:	8b 43 04             	mov    0x4(%ebx),%eax
801014be:	85 c0                	test   %eax,%eax
801014c0:	75 ee                	jne    801014b0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801014c2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801014c5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801014cc:	68 40 15 11 80       	push   $0x80111540
801014d1:	e8 7a 40 00 00       	call   80105550 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801014d6:	89 d8                	mov    %ebx,%eax
      return f;
801014d8:	83 c4 10             	add    $0x10,%esp
}
801014db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014de:	c9                   	leave  
801014df:	c3                   	ret    
  release(&ftable.lock);
801014e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801014e3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801014e5:	68 40 15 11 80       	push   $0x80111540
801014ea:	e8 61 40 00 00       	call   80105550 <release>
}
801014ef:	89 d8                	mov    %ebx,%eax
  return 0;
801014f1:	83 c4 10             	add    $0x10,%esp
}
801014f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f7:	c9                   	leave  
801014f8:	c3                   	ret    
801014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101500 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	53                   	push   %ebx
80101504:	83 ec 10             	sub    $0x10,%esp
80101507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010150a:	68 40 15 11 80       	push   $0x80111540
8010150f:	e8 9c 40 00 00       	call   801055b0 <acquire>
  if(f->ref < 1)
80101514:	8b 43 04             	mov    0x4(%ebx),%eax
80101517:	83 c4 10             	add    $0x10,%esp
8010151a:	85 c0                	test   %eax,%eax
8010151c:	7e 1a                	jle    80101538 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010151e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101521:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101524:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101527:	68 40 15 11 80       	push   $0x80111540
8010152c:	e8 1f 40 00 00       	call   80105550 <release>
  return f;
}
80101531:	89 d8                	mov    %ebx,%eax
80101533:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101536:	c9                   	leave  
80101537:	c3                   	ret    
    panic("filedup");
80101538:	83 ec 0c             	sub    $0xc,%esp
8010153b:	68 38 86 10 80       	push   $0x80108638
80101540:	e8 3b ee ff ff       	call   80100380 <panic>
80101545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 28             	sub    $0x28,%esp
80101559:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010155c:	68 40 15 11 80       	push   $0x80111540
80101561:	e8 4a 40 00 00       	call   801055b0 <acquire>
  if(f->ref < 1)
80101566:	8b 53 04             	mov    0x4(%ebx),%edx
80101569:	83 c4 10             	add    $0x10,%esp
8010156c:	85 d2                	test   %edx,%edx
8010156e:	0f 8e a5 00 00 00    	jle    80101619 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101574:	83 ea 01             	sub    $0x1,%edx
80101577:	89 53 04             	mov    %edx,0x4(%ebx)
8010157a:	75 44                	jne    801015c0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010157c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101580:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101583:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101585:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010158b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010158e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101591:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101594:	68 40 15 11 80       	push   $0x80111540
  ff = *f;
80101599:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010159c:	e8 af 3f 00 00       	call   80105550 <release>

  if(ff.type == FD_PIPE)
801015a1:	83 c4 10             	add    $0x10,%esp
801015a4:	83 ff 01             	cmp    $0x1,%edi
801015a7:	74 57                	je     80101600 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801015a9:	83 ff 02             	cmp    $0x2,%edi
801015ac:	74 2a                	je     801015d8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801015ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b1:	5b                   	pop    %ebx
801015b2:	5e                   	pop    %esi
801015b3:	5f                   	pop    %edi
801015b4:	5d                   	pop    %ebp
801015b5:	c3                   	ret    
801015b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015bd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801015c0:	c7 45 08 40 15 11 80 	movl   $0x80111540,0x8(%ebp)
}
801015c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ca:	5b                   	pop    %ebx
801015cb:	5e                   	pop    %esi
801015cc:	5f                   	pop    %edi
801015cd:	5d                   	pop    %ebp
    release(&ftable.lock);
801015ce:	e9 7d 3f 00 00       	jmp    80105550 <release>
801015d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015d7:	90                   	nop
    begin_op();
801015d8:	e8 e3 1d 00 00       	call   801033c0 <begin_op>
    iput(ff.ip);
801015dd:	83 ec 0c             	sub    $0xc,%esp
801015e0:	ff 75 e0             	push   -0x20(%ebp)
801015e3:	e8 28 09 00 00       	call   80101f10 <iput>
    end_op();
801015e8:	83 c4 10             	add    $0x10,%esp
}
801015eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ee:	5b                   	pop    %ebx
801015ef:	5e                   	pop    %esi
801015f0:	5f                   	pop    %edi
801015f1:	5d                   	pop    %ebp
    end_op();
801015f2:	e9 39 1e 00 00       	jmp    80103430 <end_op>
801015f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101600:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101604:	83 ec 08             	sub    $0x8,%esp
80101607:	53                   	push   %ebx
80101608:	56                   	push   %esi
80101609:	e8 82 25 00 00       	call   80103b90 <pipeclose>
8010160e:	83 c4 10             	add    $0x10,%esp
}
80101611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101614:	5b                   	pop    %ebx
80101615:	5e                   	pop    %esi
80101616:	5f                   	pop    %edi
80101617:	5d                   	pop    %ebp
80101618:	c3                   	ret    
    panic("fileclose");
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	68 40 86 10 80       	push   $0x80108640
80101621:	e8 5a ed ff ff       	call   80100380 <panic>
80101626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	83 ec 04             	sub    $0x4,%esp
80101637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010163a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010163d:	75 31                	jne    80101670 <filestat+0x40>
    ilock(f->ip);
8010163f:	83 ec 0c             	sub    $0xc,%esp
80101642:	ff 73 10             	push   0x10(%ebx)
80101645:	e8 96 07 00 00       	call   80101de0 <ilock>
    stati(f->ip, st);
8010164a:	58                   	pop    %eax
8010164b:	5a                   	pop    %edx
8010164c:	ff 75 0c             	push   0xc(%ebp)
8010164f:	ff 73 10             	push   0x10(%ebx)
80101652:	e8 69 0a 00 00       	call   801020c0 <stati>
    iunlock(f->ip);
80101657:	59                   	pop    %ecx
80101658:	ff 73 10             	push   0x10(%ebx)
8010165b:	e8 60 08 00 00       	call   80101ec0 <iunlock>
    return 0;
  }
  return -1;
}
80101660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101663:	83 c4 10             	add    $0x10,%esp
80101666:	31 c0                	xor    %eax,%eax
}
80101668:	c9                   	leave  
80101669:	c3                   	ret    
8010166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101678:	c9                   	leave  
80101679:	c3                   	ret    
8010167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101680 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010168c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010168f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101692:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101696:	74 60                	je     801016f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101698:	8b 03                	mov    (%ebx),%eax
8010169a:	83 f8 01             	cmp    $0x1,%eax
8010169d:	74 41                	je     801016e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010169f:	83 f8 02             	cmp    $0x2,%eax
801016a2:	75 5b                	jne    801016ff <fileread+0x7f>
    ilock(f->ip);
801016a4:	83 ec 0c             	sub    $0xc,%esp
801016a7:	ff 73 10             	push   0x10(%ebx)
801016aa:	e8 31 07 00 00       	call   80101de0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801016af:	57                   	push   %edi
801016b0:	ff 73 14             	push   0x14(%ebx)
801016b3:	56                   	push   %esi
801016b4:	ff 73 10             	push   0x10(%ebx)
801016b7:	e8 34 0a 00 00       	call   801020f0 <readi>
801016bc:	83 c4 20             	add    $0x20,%esp
801016bf:	89 c6                	mov    %eax,%esi
801016c1:	85 c0                	test   %eax,%eax
801016c3:	7e 03                	jle    801016c8 <fileread+0x48>
      f->off += r;
801016c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801016c8:	83 ec 0c             	sub    $0xc,%esp
801016cb:	ff 73 10             	push   0x10(%ebx)
801016ce:	e8 ed 07 00 00       	call   80101ec0 <iunlock>
    return r;
801016d3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801016d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016d9:	89 f0                	mov    %esi,%eax
801016db:	5b                   	pop    %ebx
801016dc:	5e                   	pop    %esi
801016dd:	5f                   	pop    %edi
801016de:	5d                   	pop    %ebp
801016df:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801016e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801016e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016e9:	5b                   	pop    %ebx
801016ea:	5e                   	pop    %esi
801016eb:	5f                   	pop    %edi
801016ec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801016ed:	e9 3e 26 00 00       	jmp    80103d30 <piperead>
801016f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801016f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801016fd:	eb d7                	jmp    801016d6 <fileread+0x56>
  panic("fileread");
801016ff:	83 ec 0c             	sub    $0xc,%esp
80101702:	68 4a 86 10 80       	push   $0x8010864a
80101707:	e8 74 ec ff ff       	call   80100380 <panic>
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101710 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	83 ec 1c             	sub    $0x1c,%esp
80101719:	8b 45 0c             	mov    0xc(%ebp),%eax
8010171c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010171f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101722:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101725:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010172c:	0f 84 bd 00 00 00    	je     801017ef <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101732:	8b 03                	mov    (%ebx),%eax
80101734:	83 f8 01             	cmp    $0x1,%eax
80101737:	0f 84 bf 00 00 00    	je     801017fc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010173d:	83 f8 02             	cmp    $0x2,%eax
80101740:	0f 85 c8 00 00 00    	jne    8010180e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101749:	31 f6                	xor    %esi,%esi
    while(i < n){
8010174b:	85 c0                	test   %eax,%eax
8010174d:	7f 30                	jg     8010177f <filewrite+0x6f>
8010174f:	e9 94 00 00 00       	jmp    801017e8 <filewrite+0xd8>
80101754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101758:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010175b:	83 ec 0c             	sub    $0xc,%esp
8010175e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101761:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101764:	e8 57 07 00 00       	call   80101ec0 <iunlock>
      end_op();
80101769:	e8 c2 1c 00 00       	call   80103430 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010176e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101771:	83 c4 10             	add    $0x10,%esp
80101774:	39 c7                	cmp    %eax,%edi
80101776:	75 5c                	jne    801017d4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101778:	01 fe                	add    %edi,%esi
    while(i < n){
8010177a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010177d:	7e 69                	jle    801017e8 <filewrite+0xd8>
      int n1 = n - i;
8010177f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101782:	b8 00 06 00 00       	mov    $0x600,%eax
80101787:	29 f7                	sub    %esi,%edi
80101789:	39 c7                	cmp    %eax,%edi
8010178b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010178e:	e8 2d 1c 00 00       	call   801033c0 <begin_op>
      ilock(f->ip);
80101793:	83 ec 0c             	sub    $0xc,%esp
80101796:	ff 73 10             	push   0x10(%ebx)
80101799:	e8 42 06 00 00       	call   80101de0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010179e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801017a1:	57                   	push   %edi
801017a2:	ff 73 14             	push   0x14(%ebx)
801017a5:	01 f0                	add    %esi,%eax
801017a7:	50                   	push   %eax
801017a8:	ff 73 10             	push   0x10(%ebx)
801017ab:	e8 40 0a 00 00       	call   801021f0 <writei>
801017b0:	83 c4 20             	add    $0x20,%esp
801017b3:	85 c0                	test   %eax,%eax
801017b5:	7f a1                	jg     80101758 <filewrite+0x48>
      iunlock(f->ip);
801017b7:	83 ec 0c             	sub    $0xc,%esp
801017ba:	ff 73 10             	push   0x10(%ebx)
801017bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017c0:	e8 fb 06 00 00       	call   80101ec0 <iunlock>
      end_op();
801017c5:	e8 66 1c 00 00       	call   80103430 <end_op>
      if(r < 0)
801017ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801017cd:	83 c4 10             	add    $0x10,%esp
801017d0:	85 c0                	test   %eax,%eax
801017d2:	75 1b                	jne    801017ef <filewrite+0xdf>
        panic("short filewrite");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 53 86 10 80       	push   $0x80108653
801017dc:	e8 9f eb ff ff       	call   80100380 <panic>
801017e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801017e8:	89 f0                	mov    %esi,%eax
801017ea:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801017ed:	74 05                	je     801017f4 <filewrite+0xe4>
801017ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801017f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5f                   	pop    %edi
801017fa:	5d                   	pop    %ebp
801017fb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801017fc:	8b 43 0c             	mov    0xc(%ebx),%eax
801017ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101802:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101805:	5b                   	pop    %ebx
80101806:	5e                   	pop    %esi
80101807:	5f                   	pop    %edi
80101808:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101809:	e9 22 24 00 00       	jmp    80103c30 <pipewrite>
  panic("filewrite");
8010180e:	83 ec 0c             	sub    $0xc,%esp
80101811:	68 59 86 10 80       	push   $0x80108659
80101816:	e8 65 eb ff ff       	call   80100380 <panic>
8010181b:	66 90                	xchg   %ax,%ax
8010181d:	66 90                	xchg   %ax,%ax
8010181f:	90                   	nop

80101820 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101820:	55                   	push   %ebp
80101821:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101823:	89 d0                	mov    %edx,%eax
80101825:	c1 e8 0c             	shr    $0xc,%eax
80101828:	03 05 ac 3b 11 80    	add    0x80113bac,%eax
{
8010182e:	89 e5                	mov    %esp,%ebp
80101830:	56                   	push   %esi
80101831:	53                   	push   %ebx
80101832:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101834:	83 ec 08             	sub    $0x8,%esp
80101837:	50                   	push   %eax
80101838:	51                   	push   %ecx
80101839:	e8 92 e8 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010183e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101840:	c1 fb 03             	sar    $0x3,%ebx
80101843:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101846:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101848:	83 e1 07             	and    $0x7,%ecx
8010184b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101850:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101856:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101858:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010185d:	85 c1                	test   %eax,%ecx
8010185f:	74 23                	je     80101884 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101861:	f7 d0                	not    %eax
  log_write(bp);
80101863:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101866:	21 c8                	and    %ecx,%eax
80101868:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010186c:	56                   	push   %esi
8010186d:	e8 2e 1d 00 00       	call   801035a0 <log_write>
  brelse(bp);
80101872:	89 34 24             	mov    %esi,(%esp)
80101875:	e8 76 e9 ff ff       	call   801001f0 <brelse>
}
8010187a:	83 c4 10             	add    $0x10,%esp
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
80101883:	c3                   	ret    
    panic("freeing free block");
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	68 63 86 10 80       	push   $0x80108663
8010188c:	e8 ef ea ff ff       	call   80100380 <panic>
80101891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189f:	90                   	nop

801018a0 <balloc>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	57                   	push   %edi
801018a4:	56                   	push   %esi
801018a5:	53                   	push   %ebx
801018a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801018a9:	8b 0d 94 3b 11 80    	mov    0x80113b94,%ecx
{
801018af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801018b2:	85 c9                	test   %ecx,%ecx
801018b4:	0f 84 87 00 00 00    	je     80101941 <balloc+0xa1>
801018ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801018c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801018c4:	83 ec 08             	sub    $0x8,%esp
801018c7:	89 f0                	mov    %esi,%eax
801018c9:	c1 f8 0c             	sar    $0xc,%eax
801018cc:	03 05 ac 3b 11 80    	add    0x80113bac,%eax
801018d2:	50                   	push   %eax
801018d3:	ff 75 d8             	push   -0x28(%ebp)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	83 c4 10             	add    $0x10,%esp
801018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801018e1:	a1 94 3b 11 80       	mov    0x80113b94,%eax
801018e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801018e9:	31 c0                	xor    %eax,%eax
801018eb:	eb 2f                	jmp    8010191c <balloc+0x7c>
801018ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801018f0:	89 c1                	mov    %eax,%ecx
801018f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801018f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801018fa:	83 e1 07             	and    $0x7,%ecx
801018fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801018ff:	89 c1                	mov    %eax,%ecx
80101901:	c1 f9 03             	sar    $0x3,%ecx
80101904:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101909:	89 fa                	mov    %edi,%edx
8010190b:	85 df                	test   %ebx,%edi
8010190d:	74 41                	je     80101950 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010190f:	83 c0 01             	add    $0x1,%eax
80101912:	83 c6 01             	add    $0x1,%esi
80101915:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010191a:	74 05                	je     80101921 <balloc+0x81>
8010191c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010191f:	77 cf                	ja     801018f0 <balloc+0x50>
    brelse(bp);
80101921:	83 ec 0c             	sub    $0xc,%esp
80101924:	ff 75 e4             	push   -0x1c(%ebp)
80101927:	e8 c4 e8 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010192c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101939:	39 05 94 3b 11 80    	cmp    %eax,0x80113b94
8010193f:	77 80                	ja     801018c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101941:	83 ec 0c             	sub    $0xc,%esp
80101944:	68 76 86 10 80       	push   $0x80108676
80101949:	e8 32 ea ff ff       	call   80100380 <panic>
8010194e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101950:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101953:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101956:	09 da                	or     %ebx,%edx
80101958:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010195c:	57                   	push   %edi
8010195d:	e8 3e 1c 00 00       	call   801035a0 <log_write>
        brelse(bp);
80101962:	89 3c 24             	mov    %edi,(%esp)
80101965:	e8 86 e8 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010196a:	58                   	pop    %eax
8010196b:	5a                   	pop    %edx
8010196c:	56                   	push   %esi
8010196d:	ff 75 d8             	push   -0x28(%ebp)
80101970:	e8 5b e7 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101975:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101978:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010197a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010197d:	68 00 02 00 00       	push   $0x200
80101982:	6a 00                	push   $0x0
80101984:	50                   	push   %eax
80101985:	e8 e6 3c 00 00       	call   80105670 <memset>
  log_write(bp);
8010198a:	89 1c 24             	mov    %ebx,(%esp)
8010198d:	e8 0e 1c 00 00       	call   801035a0 <log_write>
  brelse(bp);
80101992:	89 1c 24             	mov    %ebx,(%esp)
80101995:	e8 56 e8 ff ff       	call   801001f0 <brelse>
}
8010199a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010199d:	89 f0                	mov    %esi,%eax
8010199f:	5b                   	pop    %ebx
801019a0:	5e                   	pop    %esi
801019a1:	5f                   	pop    %edi
801019a2:	5d                   	pop    %ebp
801019a3:	c3                   	ret    
801019a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop

801019b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	57                   	push   %edi
801019b4:	89 c7                	mov    %eax,%edi
801019b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801019b7:	31 f6                	xor    %esi,%esi
{
801019b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019ba:	bb 74 1f 11 80       	mov    $0x80111f74,%ebx
{
801019bf:	83 ec 28             	sub    $0x28,%esp
801019c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801019c5:	68 40 1f 11 80       	push   $0x80111f40
801019ca:	e8 e1 3b 00 00       	call   801055b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801019d2:	83 c4 10             	add    $0x10,%esp
801019d5:	eb 1b                	jmp    801019f2 <iget+0x42>
801019d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019e0:	39 3b                	cmp    %edi,(%ebx)
801019e2:	74 6c                	je     80101a50 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801019ea:	81 fb 94 3b 11 80    	cmp    $0x80113b94,%ebx
801019f0:	73 26                	jae    80101a18 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019f2:	8b 43 08             	mov    0x8(%ebx),%eax
801019f5:	85 c0                	test   %eax,%eax
801019f7:	7f e7                	jg     801019e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801019f9:	85 f6                	test   %esi,%esi
801019fb:	75 e7                	jne    801019e4 <iget+0x34>
801019fd:	85 c0                	test   %eax,%eax
801019ff:	75 76                	jne    80101a77 <iget+0xc7>
80101a01:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a03:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a09:	81 fb 94 3b 11 80    	cmp    $0x80113b94,%ebx
80101a0f:	72 e1                	jb     801019f2 <iget+0x42>
80101a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a18:	85 f6                	test   %esi,%esi
80101a1a:	74 79                	je     80101a95 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101a1c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101a1f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101a21:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101a24:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101a2b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101a32:	68 40 1f 11 80       	push   $0x80111f40
80101a37:	e8 14 3b 00 00       	call   80105550 <release>

  return ip;
80101a3c:	83 c4 10             	add    $0x10,%esp
}
80101a3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a42:	89 f0                	mov    %esi,%eax
80101a44:	5b                   	pop    %ebx
80101a45:	5e                   	pop    %esi
80101a46:	5f                   	pop    %edi
80101a47:	5d                   	pop    %ebp
80101a48:	c3                   	ret    
80101a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a50:	39 53 04             	cmp    %edx,0x4(%ebx)
80101a53:	75 8f                	jne    801019e4 <iget+0x34>
      release(&icache.lock);
80101a55:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101a58:	83 c0 01             	add    $0x1,%eax
      return ip;
80101a5b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101a5d:	68 40 1f 11 80       	push   $0x80111f40
      ip->ref++;
80101a62:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101a65:	e8 e6 3a 00 00       	call   80105550 <release>
      return ip;
80101a6a:	83 c4 10             	add    $0x10,%esp
}
80101a6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a70:	89 f0                	mov    %esi,%eax
80101a72:	5b                   	pop    %ebx
80101a73:	5e                   	pop    %esi
80101a74:	5f                   	pop    %edi
80101a75:	5d                   	pop    %ebp
80101a76:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a77:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a7d:	81 fb 94 3b 11 80    	cmp    $0x80113b94,%ebx
80101a83:	73 10                	jae    80101a95 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a85:	8b 43 08             	mov    0x8(%ebx),%eax
80101a88:	85 c0                	test   %eax,%eax
80101a8a:	0f 8f 50 ff ff ff    	jg     801019e0 <iget+0x30>
80101a90:	e9 68 ff ff ff       	jmp    801019fd <iget+0x4d>
    panic("iget: no inodes");
80101a95:	83 ec 0c             	sub    $0xc,%esp
80101a98:	68 8c 86 10 80       	push   $0x8010868c
80101a9d:	e8 de e8 ff ff       	call   80100380 <panic>
80101aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ab0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	89 c6                	mov    %eax,%esi
80101ab7:	53                   	push   %ebx
80101ab8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101abb:	83 fa 0b             	cmp    $0xb,%edx
80101abe:	0f 86 8c 00 00 00    	jbe    80101b50 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101ac4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101ac7:	83 fb 7f             	cmp    $0x7f,%ebx
80101aca:	0f 87 a2 00 00 00    	ja     80101b72 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ad0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ad6:	85 c0                	test   %eax,%eax
80101ad8:	74 5e                	je     80101b38 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101ada:	83 ec 08             	sub    $0x8,%esp
80101add:	50                   	push   %eax
80101ade:	ff 36                	push   (%esi)
80101ae0:	e8 eb e5 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101ae5:	83 c4 10             	add    $0x10,%esp
80101ae8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101aec:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101aee:	8b 3b                	mov    (%ebx),%edi
80101af0:	85 ff                	test   %edi,%edi
80101af2:	74 1c                	je     80101b10 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101af4:	83 ec 0c             	sub    $0xc,%esp
80101af7:	52                   	push   %edx
80101af8:	e8 f3 e6 ff ff       	call   801001f0 <brelse>
80101afd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b03:	89 f8                	mov    %edi,%eax
80101b05:	5b                   	pop    %ebx
80101b06:	5e                   	pop    %esi
80101b07:	5f                   	pop    %edi
80101b08:	5d                   	pop    %ebp
80101b09:	c3                   	ret    
80101b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101b13:	8b 06                	mov    (%esi),%eax
80101b15:	e8 86 fd ff ff       	call   801018a0 <balloc>
      log_write(bp);
80101b1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b1d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101b20:	89 03                	mov    %eax,(%ebx)
80101b22:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101b24:	52                   	push   %edx
80101b25:	e8 76 1a 00 00       	call   801035a0 <log_write>
80101b2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b2d:	83 c4 10             	add    $0x10,%esp
80101b30:	eb c2                	jmp    80101af4 <bmap+0x44>
80101b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b38:	8b 06                	mov    (%esi),%eax
80101b3a:	e8 61 fd ff ff       	call   801018a0 <balloc>
80101b3f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101b45:	eb 93                	jmp    80101ada <bmap+0x2a>
80101b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b4e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101b50:	8d 5a 14             	lea    0x14(%edx),%ebx
80101b53:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101b57:	85 ff                	test   %edi,%edi
80101b59:	75 a5                	jne    80101b00 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b5b:	8b 00                	mov    (%eax),%eax
80101b5d:	e8 3e fd ff ff       	call   801018a0 <balloc>
80101b62:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101b66:	89 c7                	mov    %eax,%edi
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	89 f8                	mov    %edi,%eax
80101b6e:	5e                   	pop    %esi
80101b6f:	5f                   	pop    %edi
80101b70:	5d                   	pop    %ebp
80101b71:	c3                   	ret    
  panic("bmap: out of range");
80101b72:	83 ec 0c             	sub    $0xc,%esp
80101b75:	68 9c 86 10 80       	push   $0x8010869c
80101b7a:	e8 01 e8 ff ff       	call   80100380 <panic>
80101b7f:	90                   	nop

80101b80 <readsb>:
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	56                   	push   %esi
80101b84:	53                   	push   %ebx
80101b85:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101b88:	83 ec 08             	sub    $0x8,%esp
80101b8b:	6a 01                	push   $0x1
80101b8d:	ff 75 08             	push   0x8(%ebp)
80101b90:	e8 3b e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b95:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b98:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b9a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b9d:	6a 1c                	push   $0x1c
80101b9f:	50                   	push   %eax
80101ba0:	56                   	push   %esi
80101ba1:	e8 6a 3b 00 00       	call   80105710 <memmove>
  brelse(bp);
80101ba6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ba9:	83 c4 10             	add    $0x10,%esp
}
80101bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101baf:	5b                   	pop    %ebx
80101bb0:	5e                   	pop    %esi
80101bb1:	5d                   	pop    %ebp
  brelse(bp);
80101bb2:	e9 39 e6 ff ff       	jmp    801001f0 <brelse>
80101bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bbe:	66 90                	xchg   %ax,%ax

80101bc0 <iinit>:
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	53                   	push   %ebx
80101bc4:	bb 80 1f 11 80       	mov    $0x80111f80,%ebx
80101bc9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101bcc:	68 af 86 10 80       	push   $0x801086af
80101bd1:	68 40 1f 11 80       	push   $0x80111f40
80101bd6:	e8 05 38 00 00       	call   801053e0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101bdb:	83 c4 10             	add    $0x10,%esp
80101bde:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101be0:	83 ec 08             	sub    $0x8,%esp
80101be3:	68 b6 86 10 80       	push   $0x801086b6
80101be8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101be9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101bef:	e8 bc 36 00 00       	call   801052b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101bf4:	83 c4 10             	add    $0x10,%esp
80101bf7:	81 fb a0 3b 11 80    	cmp    $0x80113ba0,%ebx
80101bfd:	75 e1                	jne    80101be0 <iinit+0x20>
  bp = bread(dev, 1);
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	6a 01                	push   $0x1
80101c04:	ff 75 08             	push   0x8(%ebp)
80101c07:	e8 c4 e4 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101c0c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101c0f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101c11:	8d 40 5c             	lea    0x5c(%eax),%eax
80101c14:	6a 1c                	push   $0x1c
80101c16:	50                   	push   %eax
80101c17:	68 94 3b 11 80       	push   $0x80113b94
80101c1c:	e8 ef 3a 00 00       	call   80105710 <memmove>
  brelse(bp);
80101c21:	89 1c 24             	mov    %ebx,(%esp)
80101c24:	e8 c7 e5 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101c29:	ff 35 ac 3b 11 80    	push   0x80113bac
80101c2f:	ff 35 a8 3b 11 80    	push   0x80113ba8
80101c35:	ff 35 a4 3b 11 80    	push   0x80113ba4
80101c3b:	ff 35 a0 3b 11 80    	push   0x80113ba0
80101c41:	ff 35 9c 3b 11 80    	push   0x80113b9c
80101c47:	ff 35 98 3b 11 80    	push   0x80113b98
80101c4d:	ff 35 94 3b 11 80    	push   0x80113b94
80101c53:	68 1c 87 10 80       	push   $0x8010871c
80101c58:	e8 43 ea ff ff       	call   801006a0 <cprintf>
}
80101c5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c60:	83 c4 30             	add    $0x30,%esp
80101c63:	c9                   	leave  
80101c64:	c3                   	ret    
80101c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c70 <ialloc>:
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	83 ec 1c             	sub    $0x1c,%esp
80101c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101c7c:	83 3d 9c 3b 11 80 01 	cmpl   $0x1,0x80113b9c
{
80101c83:	8b 75 08             	mov    0x8(%ebp),%esi
80101c86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101c89:	0f 86 91 00 00 00    	jbe    80101d20 <ialloc+0xb0>
80101c8f:	bf 01 00 00 00       	mov    $0x1,%edi
80101c94:	eb 21                	jmp    80101cb7 <ialloc+0x47>
80101c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101ca0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101ca3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101ca6:	53                   	push   %ebx
80101ca7:	e8 44 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101cac:	83 c4 10             	add    $0x10,%esp
80101caf:	3b 3d 9c 3b 11 80    	cmp    0x80113b9c,%edi
80101cb5:	73 69                	jae    80101d20 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101cb7:	89 f8                	mov    %edi,%eax
80101cb9:	83 ec 08             	sub    $0x8,%esp
80101cbc:	c1 e8 03             	shr    $0x3,%eax
80101cbf:	03 05 a8 3b 11 80    	add    0x80113ba8,%eax
80101cc5:	50                   	push   %eax
80101cc6:	56                   	push   %esi
80101cc7:	e8 04 e4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101ccc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101ccf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101cd1:	89 f8                	mov    %edi,%eax
80101cd3:	83 e0 07             	and    $0x7,%eax
80101cd6:	c1 e0 06             	shl    $0x6,%eax
80101cd9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101cdd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101ce1:	75 bd                	jne    80101ca0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101ce3:	83 ec 04             	sub    $0x4,%esp
80101ce6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ce9:	6a 40                	push   $0x40
80101ceb:	6a 00                	push   $0x0
80101ced:	51                   	push   %ecx
80101cee:	e8 7d 39 00 00       	call   80105670 <memset>
      dip->type = type;
80101cf3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101cf7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101cfa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101cfd:	89 1c 24             	mov    %ebx,(%esp)
80101d00:	e8 9b 18 00 00       	call   801035a0 <log_write>
      brelse(bp);
80101d05:	89 1c 24             	mov    %ebx,(%esp)
80101d08:	e8 e3 e4 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101d0d:	83 c4 10             	add    $0x10,%esp
}
80101d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101d13:	89 fa                	mov    %edi,%edx
}
80101d15:	5b                   	pop    %ebx
      return iget(dev, inum);
80101d16:	89 f0                	mov    %esi,%eax
}
80101d18:	5e                   	pop    %esi
80101d19:	5f                   	pop    %edi
80101d1a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101d1b:	e9 90 fc ff ff       	jmp    801019b0 <iget>
  panic("ialloc: no inodes");
80101d20:	83 ec 0c             	sub    $0xc,%esp
80101d23:	68 bc 86 10 80       	push   $0x801086bc
80101d28:	e8 53 e6 ff ff       	call   80100380 <panic>
80101d2d:	8d 76 00             	lea    0x0(%esi),%esi

80101d30 <iupdate>:
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	56                   	push   %esi
80101d34:	53                   	push   %ebx
80101d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d38:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d3b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d3e:	83 ec 08             	sub    $0x8,%esp
80101d41:	c1 e8 03             	shr    $0x3,%eax
80101d44:	03 05 a8 3b 11 80    	add    0x80113ba8,%eax
80101d4a:	50                   	push   %eax
80101d4b:	ff 73 a4             	push   -0x5c(%ebx)
80101d4e:	e8 7d e3 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101d53:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d57:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d5a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d5c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101d5f:	83 e0 07             	and    $0x7,%eax
80101d62:	c1 e0 06             	shl    $0x6,%eax
80101d65:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101d69:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101d6c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d70:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101d73:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101d77:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101d7b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101d7f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101d83:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101d87:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101d8a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101d8d:	6a 34                	push   $0x34
80101d8f:	53                   	push   %ebx
80101d90:	50                   	push   %eax
80101d91:	e8 7a 39 00 00       	call   80105710 <memmove>
  log_write(bp);
80101d96:	89 34 24             	mov    %esi,(%esp)
80101d99:	e8 02 18 00 00       	call   801035a0 <log_write>
  brelse(bp);
80101d9e:	89 75 08             	mov    %esi,0x8(%ebp)
80101da1:	83 c4 10             	add    $0x10,%esp
}
80101da4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101da7:	5b                   	pop    %ebx
80101da8:	5e                   	pop    %esi
80101da9:	5d                   	pop    %ebp
  brelse(bp);
80101daa:	e9 41 e4 ff ff       	jmp    801001f0 <brelse>
80101daf:	90                   	nop

80101db0 <idup>:
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	53                   	push   %ebx
80101db4:	83 ec 10             	sub    $0x10,%esp
80101db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101dba:	68 40 1f 11 80       	push   $0x80111f40
80101dbf:	e8 ec 37 00 00       	call   801055b0 <acquire>
  ip->ref++;
80101dc4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101dc8:	c7 04 24 40 1f 11 80 	movl   $0x80111f40,(%esp)
80101dcf:	e8 7c 37 00 00       	call   80105550 <release>
}
80101dd4:	89 d8                	mov    %ebx,%eax
80101dd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dd9:	c9                   	leave  
80101dda:	c3                   	ret    
80101ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ddf:	90                   	nop

80101de0 <ilock>:
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	56                   	push   %esi
80101de4:	53                   	push   %ebx
80101de5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101de8:	85 db                	test   %ebx,%ebx
80101dea:	0f 84 b7 00 00 00    	je     80101ea7 <ilock+0xc7>
80101df0:	8b 53 08             	mov    0x8(%ebx),%edx
80101df3:	85 d2                	test   %edx,%edx
80101df5:	0f 8e ac 00 00 00    	jle    80101ea7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101dfb:	83 ec 0c             	sub    $0xc,%esp
80101dfe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e01:	50                   	push   %eax
80101e02:	e8 e9 34 00 00       	call   801052f0 <acquiresleep>
  if(ip->valid == 0){
80101e07:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	85 c0                	test   %eax,%eax
80101e0f:	74 0f                	je     80101e20 <ilock+0x40>
}
80101e11:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e14:	5b                   	pop    %ebx
80101e15:	5e                   	pop    %esi
80101e16:	5d                   	pop    %ebp
80101e17:	c3                   	ret    
80101e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e1f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e20:	8b 43 04             	mov    0x4(%ebx),%eax
80101e23:	83 ec 08             	sub    $0x8,%esp
80101e26:	c1 e8 03             	shr    $0x3,%eax
80101e29:	03 05 a8 3b 11 80    	add    0x80113ba8,%eax
80101e2f:	50                   	push   %eax
80101e30:	ff 33                	push   (%ebx)
80101e32:	e8 99 e2 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e37:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101e3a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101e3c:	8b 43 04             	mov    0x4(%ebx),%eax
80101e3f:	83 e0 07             	and    $0x7,%eax
80101e42:	c1 e0 06             	shl    $0x6,%eax
80101e45:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101e49:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e4c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101e4f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101e53:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101e57:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101e5b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101e5f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101e63:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101e67:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101e6b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101e6e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101e71:	6a 34                	push   $0x34
80101e73:	50                   	push   %eax
80101e74:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101e77:	50                   	push   %eax
80101e78:	e8 93 38 00 00       	call   80105710 <memmove>
    brelse(bp);
80101e7d:	89 34 24             	mov    %esi,(%esp)
80101e80:	e8 6b e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101e8d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101e94:	0f 85 77 ff ff ff    	jne    80101e11 <ilock+0x31>
      panic("ilock: no type");
80101e9a:	83 ec 0c             	sub    $0xc,%esp
80101e9d:	68 d4 86 10 80       	push   $0x801086d4
80101ea2:	e8 d9 e4 ff ff       	call   80100380 <panic>
    panic("ilock");
80101ea7:	83 ec 0c             	sub    $0xc,%esp
80101eaa:	68 ce 86 10 80       	push   $0x801086ce
80101eaf:	e8 cc e4 ff ff       	call   80100380 <panic>
80101eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ebf:	90                   	nop

80101ec0 <iunlock>:
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	56                   	push   %esi
80101ec4:	53                   	push   %ebx
80101ec5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ec8:	85 db                	test   %ebx,%ebx
80101eca:	74 28                	je     80101ef4 <iunlock+0x34>
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ed2:	56                   	push   %esi
80101ed3:	e8 b8 34 00 00       	call   80105390 <holdingsleep>
80101ed8:	83 c4 10             	add    $0x10,%esp
80101edb:	85 c0                	test   %eax,%eax
80101edd:	74 15                	je     80101ef4 <iunlock+0x34>
80101edf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ee2:	85 c0                	test   %eax,%eax
80101ee4:	7e 0e                	jle    80101ef4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101ee6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101ee9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101eec:	5b                   	pop    %ebx
80101eed:	5e                   	pop    %esi
80101eee:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101eef:	e9 5c 34 00 00       	jmp    80105350 <releasesleep>
    panic("iunlock");
80101ef4:	83 ec 0c             	sub    $0xc,%esp
80101ef7:	68 e3 86 10 80       	push   $0x801086e3
80101efc:	e8 7f e4 ff ff       	call   80100380 <panic>
80101f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop

80101f10 <iput>:
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	57                   	push   %edi
80101f14:	56                   	push   %esi
80101f15:	53                   	push   %ebx
80101f16:	83 ec 28             	sub    $0x28,%esp
80101f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101f1c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101f1f:	57                   	push   %edi
80101f20:	e8 cb 33 00 00       	call   801052f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101f25:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101f28:	83 c4 10             	add    $0x10,%esp
80101f2b:	85 d2                	test   %edx,%edx
80101f2d:	74 07                	je     80101f36 <iput+0x26>
80101f2f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101f34:	74 32                	je     80101f68 <iput+0x58>
  releasesleep(&ip->lock);
80101f36:	83 ec 0c             	sub    $0xc,%esp
80101f39:	57                   	push   %edi
80101f3a:	e8 11 34 00 00       	call   80105350 <releasesleep>
  acquire(&icache.lock);
80101f3f:	c7 04 24 40 1f 11 80 	movl   $0x80111f40,(%esp)
80101f46:	e8 65 36 00 00       	call   801055b0 <acquire>
  ip->ref--;
80101f4b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101f4f:	83 c4 10             	add    $0x10,%esp
80101f52:	c7 45 08 40 1f 11 80 	movl   $0x80111f40,0x8(%ebp)
}
80101f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5c:	5b                   	pop    %ebx
80101f5d:	5e                   	pop    %esi
80101f5e:	5f                   	pop    %edi
80101f5f:	5d                   	pop    %ebp
  release(&icache.lock);
80101f60:	e9 eb 35 00 00       	jmp    80105550 <release>
80101f65:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	68 40 1f 11 80       	push   $0x80111f40
80101f70:	e8 3b 36 00 00       	call   801055b0 <acquire>
    int r = ip->ref;
80101f75:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101f78:	c7 04 24 40 1f 11 80 	movl   $0x80111f40,(%esp)
80101f7f:	e8 cc 35 00 00       	call   80105550 <release>
    if(r == 1){
80101f84:	83 c4 10             	add    $0x10,%esp
80101f87:	83 fe 01             	cmp    $0x1,%esi
80101f8a:	75 aa                	jne    80101f36 <iput+0x26>
80101f8c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101f92:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101f95:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101f98:	89 cf                	mov    %ecx,%edi
80101f9a:	eb 0b                	jmp    80101fa7 <iput+0x97>
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101fa0:	83 c6 04             	add    $0x4,%esi
80101fa3:	39 fe                	cmp    %edi,%esi
80101fa5:	74 19                	je     80101fc0 <iput+0xb0>
    if(ip->addrs[i]){
80101fa7:	8b 16                	mov    (%esi),%edx
80101fa9:	85 d2                	test   %edx,%edx
80101fab:	74 f3                	je     80101fa0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101fad:	8b 03                	mov    (%ebx),%eax
80101faf:	e8 6c f8 ff ff       	call   80101820 <bfree>
      ip->addrs[i] = 0;
80101fb4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101fba:	eb e4                	jmp    80101fa0 <iput+0x90>
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101fc0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101fc6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101fc9:	85 c0                	test   %eax,%eax
80101fcb:	75 2d                	jne    80101ffa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101fcd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101fd0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101fd7:	53                   	push   %ebx
80101fd8:	e8 53 fd ff ff       	call   80101d30 <iupdate>
      ip->type = 0;
80101fdd:	31 c0                	xor    %eax,%eax
80101fdf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101fe3:	89 1c 24             	mov    %ebx,(%esp)
80101fe6:	e8 45 fd ff ff       	call   80101d30 <iupdate>
      ip->valid = 0;
80101feb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ff2:	83 c4 10             	add    $0x10,%esp
80101ff5:	e9 3c ff ff ff       	jmp    80101f36 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ffa:	83 ec 08             	sub    $0x8,%esp
80101ffd:	50                   	push   %eax
80101ffe:	ff 33                	push   (%ebx)
80102000:	e8 cb e0 ff ff       	call   801000d0 <bread>
80102005:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102014:	8d 70 5c             	lea    0x5c(%eax),%esi
80102017:	89 cf                	mov    %ecx,%edi
80102019:	eb 0c                	jmp    80102027 <iput+0x117>
8010201b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010201f:	90                   	nop
80102020:	83 c6 04             	add    $0x4,%esi
80102023:	39 f7                	cmp    %esi,%edi
80102025:	74 0f                	je     80102036 <iput+0x126>
      if(a[j])
80102027:	8b 16                	mov    (%esi),%edx
80102029:	85 d2                	test   %edx,%edx
8010202b:	74 f3                	je     80102020 <iput+0x110>
        bfree(ip->dev, a[j]);
8010202d:	8b 03                	mov    (%ebx),%eax
8010202f:	e8 ec f7 ff ff       	call   80101820 <bfree>
80102034:	eb ea                	jmp    80102020 <iput+0x110>
    brelse(bp);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	ff 75 e4             	push   -0x1c(%ebp)
8010203c:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010203f:	e8 ac e1 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102044:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010204a:	8b 03                	mov    (%ebx),%eax
8010204c:	e8 cf f7 ff ff       	call   80101820 <bfree>
    ip->addrs[NDIRECT] = 0;
80102051:	83 c4 10             	add    $0x10,%esp
80102054:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010205b:	00 00 00 
8010205e:	e9 6a ff ff ff       	jmp    80101fcd <iput+0xbd>
80102063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102070 <iunlockput>:
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	56                   	push   %esi
80102074:	53                   	push   %ebx
80102075:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102078:	85 db                	test   %ebx,%ebx
8010207a:	74 34                	je     801020b0 <iunlockput+0x40>
8010207c:	83 ec 0c             	sub    $0xc,%esp
8010207f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102082:	56                   	push   %esi
80102083:	e8 08 33 00 00       	call   80105390 <holdingsleep>
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 21                	je     801020b0 <iunlockput+0x40>
8010208f:	8b 43 08             	mov    0x8(%ebx),%eax
80102092:	85 c0                	test   %eax,%eax
80102094:	7e 1a                	jle    801020b0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	56                   	push   %esi
8010209a:	e8 b1 32 00 00       	call   80105350 <releasesleep>
  iput(ip);
8010209f:	89 5d 08             	mov    %ebx,0x8(%ebp)
801020a2:	83 c4 10             	add    $0x10,%esp
}
801020a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020a8:	5b                   	pop    %ebx
801020a9:	5e                   	pop    %esi
801020aa:	5d                   	pop    %ebp
  iput(ip);
801020ab:	e9 60 fe ff ff       	jmp    80101f10 <iput>
    panic("iunlock");
801020b0:	83 ec 0c             	sub    $0xc,%esp
801020b3:	68 e3 86 10 80       	push   $0x801086e3
801020b8:	e8 c3 e2 ff ff       	call   80100380 <panic>
801020bd:	8d 76 00             	lea    0x0(%esi),%esi

801020c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	8b 55 08             	mov    0x8(%ebp),%edx
801020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801020c9:	8b 0a                	mov    (%edx),%ecx
801020cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801020ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801020d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801020d4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801020d8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801020db:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801020df:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801020e3:	8b 52 58             	mov    0x58(%edx),%edx
801020e6:	89 50 10             	mov    %edx,0x10(%eax)
}
801020e9:	5d                   	pop    %ebp
801020ea:	c3                   	ret    
801020eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020ef:	90                   	nop

801020f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 1c             	sub    $0x1c,%esp
801020f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801020fc:	8b 45 08             	mov    0x8(%ebp),%eax
801020ff:	8b 75 10             	mov    0x10(%ebp),%esi
80102102:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102105:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102108:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010210d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102110:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102113:	0f 84 a7 00 00 00    	je     801021c0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102119:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010211c:	8b 40 58             	mov    0x58(%eax),%eax
8010211f:	39 c6                	cmp    %eax,%esi
80102121:	0f 87 ba 00 00 00    	ja     801021e1 <readi+0xf1>
80102127:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010212a:	31 c9                	xor    %ecx,%ecx
8010212c:	89 da                	mov    %ebx,%edx
8010212e:	01 f2                	add    %esi,%edx
80102130:	0f 92 c1             	setb   %cl
80102133:	89 cf                	mov    %ecx,%edi
80102135:	0f 82 a6 00 00 00    	jb     801021e1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010213b:	89 c1                	mov    %eax,%ecx
8010213d:	29 f1                	sub    %esi,%ecx
8010213f:	39 d0                	cmp    %edx,%eax
80102141:	0f 43 cb             	cmovae %ebx,%ecx
80102144:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102147:	85 c9                	test   %ecx,%ecx
80102149:	74 67                	je     801021b2 <readi+0xc2>
8010214b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010214f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102150:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102153:	89 f2                	mov    %esi,%edx
80102155:	c1 ea 09             	shr    $0x9,%edx
80102158:	89 d8                	mov    %ebx,%eax
8010215a:	e8 51 f9 ff ff       	call   80101ab0 <bmap>
8010215f:	83 ec 08             	sub    $0x8,%esp
80102162:	50                   	push   %eax
80102163:	ff 33                	push   (%ebx)
80102165:	e8 66 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010216a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010216d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102172:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102174:	89 f0                	mov    %esi,%eax
80102176:	25 ff 01 00 00       	and    $0x1ff,%eax
8010217b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010217d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102180:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102182:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102186:	39 d9                	cmp    %ebx,%ecx
80102188:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010218b:	83 c4 0c             	add    $0xc,%esp
8010218e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010218f:	01 df                	add    %ebx,%edi
80102191:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102193:	50                   	push   %eax
80102194:	ff 75 e0             	push   -0x20(%ebp)
80102197:	e8 74 35 00 00       	call   80105710 <memmove>
    brelse(bp);
8010219c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010219f:	89 14 24             	mov    %edx,(%esp)
801021a2:	e8 49 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021a7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801021aa:	83 c4 10             	add    $0x10,%esp
801021ad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801021b0:	77 9e                	ja     80102150 <readi+0x60>
  }
  return n;
801021b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801021b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b8:	5b                   	pop    %ebx
801021b9:	5e                   	pop    %esi
801021ba:	5f                   	pop    %edi
801021bb:	5d                   	pop    %ebp
801021bc:	c3                   	ret    
801021bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801021c0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801021c4:	66 83 f8 09          	cmp    $0x9,%ax
801021c8:	77 17                	ja     801021e1 <readi+0xf1>
801021ca:	8b 04 c5 e0 1e 11 80 	mov    -0x7feee120(,%eax,8),%eax
801021d1:	85 c0                	test   %eax,%eax
801021d3:	74 0c                	je     801021e1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801021d5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801021d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021db:	5b                   	pop    %ebx
801021dc:	5e                   	pop    %esi
801021dd:	5f                   	pop    %edi
801021de:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801021df:	ff e0                	jmp    *%eax
      return -1;
801021e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e6:	eb cd                	jmp    801021b5 <readi+0xc5>
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 1c             	sub    $0x1c,%esp
801021f9:	8b 45 08             	mov    0x8(%ebp),%eax
801021fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801021ff:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102202:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102207:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010220a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010220d:	8b 75 10             	mov    0x10(%ebp),%esi
80102210:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102213:	0f 84 b7 00 00 00    	je     801022d0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102219:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010221c:	3b 70 58             	cmp    0x58(%eax),%esi
8010221f:	0f 87 e7 00 00 00    	ja     8010230c <writei+0x11c>
80102225:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102228:	31 d2                	xor    %edx,%edx
8010222a:	89 f8                	mov    %edi,%eax
8010222c:	01 f0                	add    %esi,%eax
8010222e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102231:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102236:	0f 87 d0 00 00 00    	ja     8010230c <writei+0x11c>
8010223c:	85 d2                	test   %edx,%edx
8010223e:	0f 85 c8 00 00 00    	jne    8010230c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102244:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010224b:	85 ff                	test   %edi,%edi
8010224d:	74 72                	je     801022c1 <writei+0xd1>
8010224f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102250:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102253:	89 f2                	mov    %esi,%edx
80102255:	c1 ea 09             	shr    $0x9,%edx
80102258:	89 f8                	mov    %edi,%eax
8010225a:	e8 51 f8 ff ff       	call   80101ab0 <bmap>
8010225f:	83 ec 08             	sub    $0x8,%esp
80102262:	50                   	push   %eax
80102263:	ff 37                	push   (%edi)
80102265:	e8 66 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010226a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010226f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102272:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102275:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102277:	89 f0                	mov    %esi,%eax
80102279:	25 ff 01 00 00       	and    $0x1ff,%eax
8010227e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102280:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102284:	39 d9                	cmp    %ebx,%ecx
80102286:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102289:	83 c4 0c             	add    $0xc,%esp
8010228c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010228d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010228f:	ff 75 dc             	push   -0x24(%ebp)
80102292:	50                   	push   %eax
80102293:	e8 78 34 00 00       	call   80105710 <memmove>
    log_write(bp);
80102298:	89 3c 24             	mov    %edi,(%esp)
8010229b:	e8 00 13 00 00       	call   801035a0 <log_write>
    brelse(bp);
801022a0:	89 3c 24             	mov    %edi,(%esp)
801022a3:	e8 48 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022a8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801022ab:	83 c4 10             	add    $0x10,%esp
801022ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022b1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801022b4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801022b7:	77 97                	ja     80102250 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801022b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801022bc:	3b 70 58             	cmp    0x58(%eax),%esi
801022bf:	77 37                	ja     801022f8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801022c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801022c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c7:	5b                   	pop    %ebx
801022c8:	5e                   	pop    %esi
801022c9:	5f                   	pop    %edi
801022ca:	5d                   	pop    %ebp
801022cb:	c3                   	ret    
801022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801022d0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801022d4:	66 83 f8 09          	cmp    $0x9,%ax
801022d8:	77 32                	ja     8010230c <writei+0x11c>
801022da:	8b 04 c5 e4 1e 11 80 	mov    -0x7feee11c(,%eax,8),%eax
801022e1:	85 c0                	test   %eax,%eax
801022e3:	74 27                	je     8010230c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801022e5:	89 55 10             	mov    %edx,0x10(%ebp)
}
801022e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022eb:	5b                   	pop    %ebx
801022ec:	5e                   	pop    %esi
801022ed:	5f                   	pop    %edi
801022ee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801022ef:	ff e0                	jmp    *%eax
801022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801022f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801022fb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801022fe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102301:	50                   	push   %eax
80102302:	e8 29 fa ff ff       	call   80101d30 <iupdate>
80102307:	83 c4 10             	add    $0x10,%esp
8010230a:	eb b5                	jmp    801022c1 <writei+0xd1>
      return -1;
8010230c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102311:	eb b1                	jmp    801022c4 <writei+0xd4>
80102313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102320 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102326:	6a 0e                	push   $0xe
80102328:	ff 75 0c             	push   0xc(%ebp)
8010232b:	ff 75 08             	push   0x8(%ebp)
8010232e:	e8 4d 34 00 00       	call   80105780 <strncmp>
}
80102333:	c9                   	leave  
80102334:	c3                   	ret    
80102335:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102340 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	57                   	push   %edi
80102344:	56                   	push   %esi
80102345:	53                   	push   %ebx
80102346:	83 ec 1c             	sub    $0x1c,%esp
80102349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010234c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102351:	0f 85 85 00 00 00    	jne    801023dc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102357:	8b 53 58             	mov    0x58(%ebx),%edx
8010235a:	31 ff                	xor    %edi,%edi
8010235c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010235f:	85 d2                	test   %edx,%edx
80102361:	74 3e                	je     801023a1 <dirlookup+0x61>
80102363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102367:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102368:	6a 10                	push   $0x10
8010236a:	57                   	push   %edi
8010236b:	56                   	push   %esi
8010236c:	53                   	push   %ebx
8010236d:	e8 7e fd ff ff       	call   801020f0 <readi>
80102372:	83 c4 10             	add    $0x10,%esp
80102375:	83 f8 10             	cmp    $0x10,%eax
80102378:	75 55                	jne    801023cf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010237a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010237f:	74 18                	je     80102399 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102381:	83 ec 04             	sub    $0x4,%esp
80102384:	8d 45 da             	lea    -0x26(%ebp),%eax
80102387:	6a 0e                	push   $0xe
80102389:	50                   	push   %eax
8010238a:	ff 75 0c             	push   0xc(%ebp)
8010238d:	e8 ee 33 00 00       	call   80105780 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102392:	83 c4 10             	add    $0x10,%esp
80102395:	85 c0                	test   %eax,%eax
80102397:	74 17                	je     801023b0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102399:	83 c7 10             	add    $0x10,%edi
8010239c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010239f:	72 c7                	jb     80102368 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801023a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801023a4:	31 c0                	xor    %eax,%eax
}
801023a6:	5b                   	pop    %ebx
801023a7:	5e                   	pop    %esi
801023a8:	5f                   	pop    %edi
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023af:	90                   	nop
      if(poff)
801023b0:	8b 45 10             	mov    0x10(%ebp),%eax
801023b3:	85 c0                	test   %eax,%eax
801023b5:	74 05                	je     801023bc <dirlookup+0x7c>
        *poff = off;
801023b7:	8b 45 10             	mov    0x10(%ebp),%eax
801023ba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801023bc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801023c0:	8b 03                	mov    (%ebx),%eax
801023c2:	e8 e9 f5 ff ff       	call   801019b0 <iget>
}
801023c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ca:	5b                   	pop    %ebx
801023cb:	5e                   	pop    %esi
801023cc:	5f                   	pop    %edi
801023cd:	5d                   	pop    %ebp
801023ce:	c3                   	ret    
      panic("dirlookup read");
801023cf:	83 ec 0c             	sub    $0xc,%esp
801023d2:	68 fd 86 10 80       	push   $0x801086fd
801023d7:	e8 a4 df ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
801023dc:	83 ec 0c             	sub    $0xc,%esp
801023df:	68 eb 86 10 80       	push   $0x801086eb
801023e4:	e8 97 df ff ff       	call   80100380 <panic>
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023f0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	89 c3                	mov    %eax,%ebx
801023f8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023fb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801023fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102401:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102404:	0f 84 64 01 00 00    	je     8010256e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010240a:	e8 91 1c 00 00       	call   801040a0 <myproc>
  acquire(&icache.lock);
8010240f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102412:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102415:	68 40 1f 11 80       	push   $0x80111f40
8010241a:	e8 91 31 00 00       	call   801055b0 <acquire>
  ip->ref++;
8010241f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102423:	c7 04 24 40 1f 11 80 	movl   $0x80111f40,(%esp)
8010242a:	e8 21 31 00 00       	call   80105550 <release>
8010242f:	83 c4 10             	add    $0x10,%esp
80102432:	eb 07                	jmp    8010243b <namex+0x4b>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102438:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010243b:	0f b6 03             	movzbl (%ebx),%eax
8010243e:	3c 2f                	cmp    $0x2f,%al
80102440:	74 f6                	je     80102438 <namex+0x48>
  if(*path == 0)
80102442:	84 c0                	test   %al,%al
80102444:	0f 84 06 01 00 00    	je     80102550 <namex+0x160>
  while(*path != '/' && *path != 0)
8010244a:	0f b6 03             	movzbl (%ebx),%eax
8010244d:	84 c0                	test   %al,%al
8010244f:	0f 84 10 01 00 00    	je     80102565 <namex+0x175>
80102455:	89 df                	mov    %ebx,%edi
80102457:	3c 2f                	cmp    $0x2f,%al
80102459:	0f 84 06 01 00 00    	je     80102565 <namex+0x175>
8010245f:	90                   	nop
80102460:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102464:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102467:	3c 2f                	cmp    $0x2f,%al
80102469:	74 04                	je     8010246f <namex+0x7f>
8010246b:	84 c0                	test   %al,%al
8010246d:	75 f1                	jne    80102460 <namex+0x70>
  len = path - s;
8010246f:	89 f8                	mov    %edi,%eax
80102471:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102473:	83 f8 0d             	cmp    $0xd,%eax
80102476:	0f 8e ac 00 00 00    	jle    80102528 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010247c:	83 ec 04             	sub    $0x4,%esp
8010247f:	6a 0e                	push   $0xe
80102481:	53                   	push   %ebx
    path++;
80102482:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102484:	ff 75 e4             	push   -0x1c(%ebp)
80102487:	e8 84 32 00 00       	call   80105710 <memmove>
8010248c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010248f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102492:	75 0c                	jne    801024a0 <namex+0xb0>
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102498:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010249b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010249e:	74 f8                	je     80102498 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	56                   	push   %esi
801024a4:	e8 37 f9 ff ff       	call   80101de0 <ilock>
    if(ip->type != T_DIR){
801024a9:	83 c4 10             	add    $0x10,%esp
801024ac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801024b1:	0f 85 cd 00 00 00    	jne    80102584 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801024b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801024ba:	85 c0                	test   %eax,%eax
801024bc:	74 09                	je     801024c7 <namex+0xd7>
801024be:	80 3b 00             	cmpb   $0x0,(%ebx)
801024c1:	0f 84 22 01 00 00    	je     801025e9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	6a 00                	push   $0x0
801024cc:	ff 75 e4             	push   -0x1c(%ebp)
801024cf:	56                   	push   %esi
801024d0:	e8 6b fe ff ff       	call   80102340 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801024d5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
801024d8:	83 c4 10             	add    $0x10,%esp
801024db:	89 c7                	mov    %eax,%edi
801024dd:	85 c0                	test   %eax,%eax
801024df:	0f 84 e1 00 00 00    	je     801025c6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801024e5:	83 ec 0c             	sub    $0xc,%esp
801024e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801024eb:	52                   	push   %edx
801024ec:	e8 9f 2e 00 00       	call   80105390 <holdingsleep>
801024f1:	83 c4 10             	add    $0x10,%esp
801024f4:	85 c0                	test   %eax,%eax
801024f6:	0f 84 30 01 00 00    	je     8010262c <namex+0x23c>
801024fc:	8b 56 08             	mov    0x8(%esi),%edx
801024ff:	85 d2                	test   %edx,%edx
80102501:	0f 8e 25 01 00 00    	jle    8010262c <namex+0x23c>
  releasesleep(&ip->lock);
80102507:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010250a:	83 ec 0c             	sub    $0xc,%esp
8010250d:	52                   	push   %edx
8010250e:	e8 3d 2e 00 00       	call   80105350 <releasesleep>
  iput(ip);
80102513:	89 34 24             	mov    %esi,(%esp)
80102516:	89 fe                	mov    %edi,%esi
80102518:	e8 f3 f9 ff ff       	call   80101f10 <iput>
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	e9 16 ff ff ff       	jmp    8010243b <namex+0x4b>
80102525:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102528:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010252b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010252e:	83 ec 04             	sub    $0x4,%esp
80102531:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102534:	50                   	push   %eax
80102535:	53                   	push   %ebx
    name[len] = 0;
80102536:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102538:	ff 75 e4             	push   -0x1c(%ebp)
8010253b:	e8 d0 31 00 00       	call   80105710 <memmove>
    name[len] = 0;
80102540:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102543:	83 c4 10             	add    $0x10,%esp
80102546:	c6 02 00             	movb   $0x0,(%edx)
80102549:	e9 41 ff ff ff       	jmp    8010248f <namex+0x9f>
8010254e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102550:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102553:	85 c0                	test   %eax,%eax
80102555:	0f 85 be 00 00 00    	jne    80102619 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010255b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010255e:	89 f0                	mov    %esi,%eax
80102560:	5b                   	pop    %ebx
80102561:	5e                   	pop    %esi
80102562:	5f                   	pop    %edi
80102563:	5d                   	pop    %ebp
80102564:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102565:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102568:	89 df                	mov    %ebx,%edi
8010256a:	31 c0                	xor    %eax,%eax
8010256c:	eb c0                	jmp    8010252e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010256e:	ba 01 00 00 00       	mov    $0x1,%edx
80102573:	b8 01 00 00 00       	mov    $0x1,%eax
80102578:	e8 33 f4 ff ff       	call   801019b0 <iget>
8010257d:	89 c6                	mov    %eax,%esi
8010257f:	e9 b7 fe ff ff       	jmp    8010243b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102584:	83 ec 0c             	sub    $0xc,%esp
80102587:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010258a:	53                   	push   %ebx
8010258b:	e8 00 2e 00 00       	call   80105390 <holdingsleep>
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	85 c0                	test   %eax,%eax
80102595:	0f 84 91 00 00 00    	je     8010262c <namex+0x23c>
8010259b:	8b 46 08             	mov    0x8(%esi),%eax
8010259e:	85 c0                	test   %eax,%eax
801025a0:	0f 8e 86 00 00 00    	jle    8010262c <namex+0x23c>
  releasesleep(&ip->lock);
801025a6:	83 ec 0c             	sub    $0xc,%esp
801025a9:	53                   	push   %ebx
801025aa:	e8 a1 2d 00 00       	call   80105350 <releasesleep>
  iput(ip);
801025af:	89 34 24             	mov    %esi,(%esp)
      return 0;
801025b2:	31 f6                	xor    %esi,%esi
  iput(ip);
801025b4:	e8 57 f9 ff ff       	call   80101f10 <iput>
      return 0;
801025b9:	83 c4 10             	add    $0x10,%esp
}
801025bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025bf:	89 f0                	mov    %esi,%eax
801025c1:	5b                   	pop    %ebx
801025c2:	5e                   	pop    %esi
801025c3:	5f                   	pop    %edi
801025c4:	5d                   	pop    %ebp
801025c5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801025c6:	83 ec 0c             	sub    $0xc,%esp
801025c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801025cc:	52                   	push   %edx
801025cd:	e8 be 2d 00 00       	call   80105390 <holdingsleep>
801025d2:	83 c4 10             	add    $0x10,%esp
801025d5:	85 c0                	test   %eax,%eax
801025d7:	74 53                	je     8010262c <namex+0x23c>
801025d9:	8b 4e 08             	mov    0x8(%esi),%ecx
801025dc:	85 c9                	test   %ecx,%ecx
801025de:	7e 4c                	jle    8010262c <namex+0x23c>
  releasesleep(&ip->lock);
801025e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801025e3:	83 ec 0c             	sub    $0xc,%esp
801025e6:	52                   	push   %edx
801025e7:	eb c1                	jmp    801025aa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801025e9:	83 ec 0c             	sub    $0xc,%esp
801025ec:	8d 5e 0c             	lea    0xc(%esi),%ebx
801025ef:	53                   	push   %ebx
801025f0:	e8 9b 2d 00 00       	call   80105390 <holdingsleep>
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	85 c0                	test   %eax,%eax
801025fa:	74 30                	je     8010262c <namex+0x23c>
801025fc:	8b 7e 08             	mov    0x8(%esi),%edi
801025ff:	85 ff                	test   %edi,%edi
80102601:	7e 29                	jle    8010262c <namex+0x23c>
  releasesleep(&ip->lock);
80102603:	83 ec 0c             	sub    $0xc,%esp
80102606:	53                   	push   %ebx
80102607:	e8 44 2d 00 00       	call   80105350 <releasesleep>
}
8010260c:	83 c4 10             	add    $0x10,%esp
}
8010260f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102612:	89 f0                	mov    %esi,%eax
80102614:	5b                   	pop    %ebx
80102615:	5e                   	pop    %esi
80102616:	5f                   	pop    %edi
80102617:	5d                   	pop    %ebp
80102618:	c3                   	ret    
    iput(ip);
80102619:	83 ec 0c             	sub    $0xc,%esp
8010261c:	56                   	push   %esi
    return 0;
8010261d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010261f:	e8 ec f8 ff ff       	call   80101f10 <iput>
    return 0;
80102624:	83 c4 10             	add    $0x10,%esp
80102627:	e9 2f ff ff ff       	jmp    8010255b <namex+0x16b>
    panic("iunlock");
8010262c:	83 ec 0c             	sub    $0xc,%esp
8010262f:	68 e3 86 10 80       	push   $0x801086e3
80102634:	e8 47 dd ff ff       	call   80100380 <panic>
80102639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102640 <dirlink>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	57                   	push   %edi
80102644:	56                   	push   %esi
80102645:	53                   	push   %ebx
80102646:	83 ec 20             	sub    $0x20,%esp
80102649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010264c:	6a 00                	push   $0x0
8010264e:	ff 75 0c             	push   0xc(%ebp)
80102651:	53                   	push   %ebx
80102652:	e8 e9 fc ff ff       	call   80102340 <dirlookup>
80102657:	83 c4 10             	add    $0x10,%esp
8010265a:	85 c0                	test   %eax,%eax
8010265c:	75 67                	jne    801026c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010265e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102661:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102664:	85 ff                	test   %edi,%edi
80102666:	74 29                	je     80102691 <dirlink+0x51>
80102668:	31 ff                	xor    %edi,%edi
8010266a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010266d:	eb 09                	jmp    80102678 <dirlink+0x38>
8010266f:	90                   	nop
80102670:	83 c7 10             	add    $0x10,%edi
80102673:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102676:	73 19                	jae    80102691 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102678:	6a 10                	push   $0x10
8010267a:	57                   	push   %edi
8010267b:	56                   	push   %esi
8010267c:	53                   	push   %ebx
8010267d:	e8 6e fa ff ff       	call   801020f0 <readi>
80102682:	83 c4 10             	add    $0x10,%esp
80102685:	83 f8 10             	cmp    $0x10,%eax
80102688:	75 4e                	jne    801026d8 <dirlink+0x98>
    if(de.inum == 0)
8010268a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010268f:	75 df                	jne    80102670 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102691:	83 ec 04             	sub    $0x4,%esp
80102694:	8d 45 da             	lea    -0x26(%ebp),%eax
80102697:	6a 0e                	push   $0xe
80102699:	ff 75 0c             	push   0xc(%ebp)
8010269c:	50                   	push   %eax
8010269d:	e8 2e 31 00 00       	call   801057d0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026a2:	6a 10                	push   $0x10
  de.inum = inum;
801026a4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026a7:	57                   	push   %edi
801026a8:	56                   	push   %esi
801026a9:	53                   	push   %ebx
  de.inum = inum;
801026aa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026ae:	e8 3d fb ff ff       	call   801021f0 <writei>
801026b3:	83 c4 20             	add    $0x20,%esp
801026b6:	83 f8 10             	cmp    $0x10,%eax
801026b9:	75 2a                	jne    801026e5 <dirlink+0xa5>
  return 0;
801026bb:	31 c0                	xor    %eax,%eax
}
801026bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026c0:	5b                   	pop    %ebx
801026c1:	5e                   	pop    %esi
801026c2:	5f                   	pop    %edi
801026c3:	5d                   	pop    %ebp
801026c4:	c3                   	ret    
    iput(ip);
801026c5:	83 ec 0c             	sub    $0xc,%esp
801026c8:	50                   	push   %eax
801026c9:	e8 42 f8 ff ff       	call   80101f10 <iput>
    return -1;
801026ce:	83 c4 10             	add    $0x10,%esp
801026d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026d6:	eb e5                	jmp    801026bd <dirlink+0x7d>
      panic("dirlink read");
801026d8:	83 ec 0c             	sub    $0xc,%esp
801026db:	68 0c 87 10 80       	push   $0x8010870c
801026e0:	e8 9b dc ff ff       	call   80100380 <panic>
    panic("dirlink");
801026e5:	83 ec 0c             	sub    $0xc,%esp
801026e8:	68 ba 8d 10 80       	push   $0x80108dba
801026ed:	e8 8e dc ff ff       	call   80100380 <panic>
801026f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102700 <namei>:

struct inode*
namei(char *path)
{
80102700:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102701:	31 d2                	xor    %edx,%edx
{
80102703:	89 e5                	mov    %esp,%ebp
80102705:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102708:	8b 45 08             	mov    0x8(%ebp),%eax
8010270b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010270e:	e8 dd fc ff ff       	call   801023f0 <namex>
}
80102713:	c9                   	leave  
80102714:	c3                   	ret    
80102715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102720:	55                   	push   %ebp
  return namex(path, 1, name);
80102721:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102726:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102728:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010272b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010272e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010272f:	e9 bc fc ff ff       	jmp    801023f0 <namex>
80102734:	66 90                	xchg   %ax,%ax
80102736:	66 90                	xchg   %ax,%ax
80102738:	66 90                	xchg   %ax,%ax
8010273a:	66 90                	xchg   %ax,%ax
8010273c:	66 90                	xchg   %ax,%ax
8010273e:	66 90                	xchg   %ax,%ax

80102740 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	57                   	push   %edi
80102744:	56                   	push   %esi
80102745:	53                   	push   %ebx
80102746:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102749:	85 c0                	test   %eax,%eax
8010274b:	0f 84 b4 00 00 00    	je     80102805 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102751:	8b 70 08             	mov    0x8(%eax),%esi
80102754:	89 c3                	mov    %eax,%ebx
80102756:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010275c:	0f 87 96 00 00 00    	ja     801027f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102762:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
80102770:	89 ca                	mov    %ecx,%edx
80102772:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102773:	83 e0 c0             	and    $0xffffffc0,%eax
80102776:	3c 40                	cmp    $0x40,%al
80102778:	75 f6                	jne    80102770 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010277a:	31 ff                	xor    %edi,%edi
8010277c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102781:	89 f8                	mov    %edi,%eax
80102783:	ee                   	out    %al,(%dx)
80102784:	b8 01 00 00 00       	mov    $0x1,%eax
80102789:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010278e:	ee                   	out    %al,(%dx)
8010278f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102794:	89 f0                	mov    %esi,%eax
80102796:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102797:	89 f0                	mov    %esi,%eax
80102799:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010279e:	c1 f8 08             	sar    $0x8,%eax
801027a1:	ee                   	out    %al,(%dx)
801027a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801027a7:	89 f8                	mov    %edi,%eax
801027a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801027ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027b3:	c1 e0 04             	shl    $0x4,%eax
801027b6:	83 e0 10             	and    $0x10,%eax
801027b9:	83 c8 e0             	or     $0xffffffe0,%eax
801027bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801027bd:	f6 03 04             	testb  $0x4,(%ebx)
801027c0:	75 16                	jne    801027d8 <idestart+0x98>
801027c2:	b8 20 00 00 00       	mov    $0x20,%eax
801027c7:	89 ca                	mov    %ecx,%edx
801027c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801027ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027cd:	5b                   	pop    %ebx
801027ce:	5e                   	pop    %esi
801027cf:	5f                   	pop    %edi
801027d0:	5d                   	pop    %ebp
801027d1:	c3                   	ret    
801027d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027d8:	b8 30 00 00 00       	mov    $0x30,%eax
801027dd:	89 ca                	mov    %ecx,%edx
801027df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801027e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801027e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801027e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027ed:	fc                   	cld    
801027ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801027f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027f3:	5b                   	pop    %ebx
801027f4:	5e                   	pop    %esi
801027f5:	5f                   	pop    %edi
801027f6:	5d                   	pop    %ebp
801027f7:	c3                   	ret    
    panic("incorrect blockno");
801027f8:	83 ec 0c             	sub    $0xc,%esp
801027fb:	68 78 87 10 80       	push   $0x80108778
80102800:	e8 7b db ff ff       	call   80100380 <panic>
    panic("idestart");
80102805:	83 ec 0c             	sub    $0xc,%esp
80102808:	68 6f 87 10 80       	push   $0x8010876f
8010280d:	e8 6e db ff ff       	call   80100380 <panic>
80102812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102820 <ideinit>:
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102826:	68 8a 87 10 80       	push   $0x8010878a
8010282b:	68 e0 3b 11 80       	push   $0x80113be0
80102830:	e8 ab 2b 00 00       	call   801053e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102835:	58                   	pop    %eax
80102836:	a1 64 3d 11 80       	mov    0x80113d64,%eax
8010283b:	5a                   	pop    %edx
8010283c:	83 e8 01             	sub    $0x1,%eax
8010283f:	50                   	push   %eax
80102840:	6a 0e                	push   $0xe
80102842:	e8 99 02 00 00       	call   80102ae0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102847:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010284f:	90                   	nop
80102850:	ec                   	in     (%dx),%al
80102851:	83 e0 c0             	and    $0xffffffc0,%eax
80102854:	3c 40                	cmp    $0x40,%al
80102856:	75 f8                	jne    80102850 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010285d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102862:	ee                   	out    %al,(%dx)
80102863:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102868:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010286d:	eb 06                	jmp    80102875 <ideinit+0x55>
8010286f:	90                   	nop
  for(i=0; i<1000; i++){
80102870:	83 e9 01             	sub    $0x1,%ecx
80102873:	74 0f                	je     80102884 <ideinit+0x64>
80102875:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102876:	84 c0                	test   %al,%al
80102878:	74 f6                	je     80102870 <ideinit+0x50>
      havedisk1 = 1;
8010287a:	c7 05 c0 3b 11 80 01 	movl   $0x1,0x80113bc0
80102881:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102884:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102889:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010288e:	ee                   	out    %al,(%dx)
}
8010288f:	c9                   	leave  
80102890:	c3                   	ret    
80102891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop

801028a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	57                   	push   %edi
801028a4:	56                   	push   %esi
801028a5:	53                   	push   %ebx
801028a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028a9:	68 e0 3b 11 80       	push   $0x80113be0
801028ae:	e8 fd 2c 00 00       	call   801055b0 <acquire>

  if((b = idequeue) == 0){
801028b3:	8b 1d c4 3b 11 80    	mov    0x80113bc4,%ebx
801028b9:	83 c4 10             	add    $0x10,%esp
801028bc:	85 db                	test   %ebx,%ebx
801028be:	74 63                	je     80102923 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801028c0:	8b 43 58             	mov    0x58(%ebx),%eax
801028c3:	a3 c4 3b 11 80       	mov    %eax,0x80113bc4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028c8:	8b 33                	mov    (%ebx),%esi
801028ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801028d0:	75 2f                	jne    80102901 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028de:	66 90                	xchg   %ax,%ax
801028e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028e1:	89 c1                	mov    %eax,%ecx
801028e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801028e6:	80 f9 40             	cmp    $0x40,%cl
801028e9:	75 f5                	jne    801028e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028eb:	a8 21                	test   $0x21,%al
801028ed:	75 12                	jne    80102901 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801028ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801028f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801028f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801028fc:	fc                   	cld    
801028fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102901:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102904:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102907:	83 ce 02             	or     $0x2,%esi
8010290a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010290c:	53                   	push   %ebx
8010290d:	e8 9e 22 00 00       	call   80104bb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102912:	a1 c4 3b 11 80       	mov    0x80113bc4,%eax
80102917:	83 c4 10             	add    $0x10,%esp
8010291a:	85 c0                	test   %eax,%eax
8010291c:	74 05                	je     80102923 <ideintr+0x83>
    idestart(idequeue);
8010291e:	e8 1d fe ff ff       	call   80102740 <idestart>
    release(&idelock);
80102923:	83 ec 0c             	sub    $0xc,%esp
80102926:	68 e0 3b 11 80       	push   $0x80113be0
8010292b:	e8 20 2c 00 00       	call   80105550 <release>

  release(&idelock);
}
80102930:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102933:	5b                   	pop    %ebx
80102934:	5e                   	pop    %esi
80102935:	5f                   	pop    %edi
80102936:	5d                   	pop    %ebp
80102937:	c3                   	ret    
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	53                   	push   %ebx
80102944:	83 ec 10             	sub    $0x10,%esp
80102947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010294a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010294d:	50                   	push   %eax
8010294e:	e8 3d 2a 00 00       	call   80105390 <holdingsleep>
80102953:	83 c4 10             	add    $0x10,%esp
80102956:	85 c0                	test   %eax,%eax
80102958:	0f 84 c3 00 00 00    	je     80102a21 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010295e:	8b 03                	mov    (%ebx),%eax
80102960:	83 e0 06             	and    $0x6,%eax
80102963:	83 f8 02             	cmp    $0x2,%eax
80102966:	0f 84 a8 00 00 00    	je     80102a14 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010296c:	8b 53 04             	mov    0x4(%ebx),%edx
8010296f:	85 d2                	test   %edx,%edx
80102971:	74 0d                	je     80102980 <iderw+0x40>
80102973:	a1 c0 3b 11 80       	mov    0x80113bc0,%eax
80102978:	85 c0                	test   %eax,%eax
8010297a:	0f 84 87 00 00 00    	je     80102a07 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102980:	83 ec 0c             	sub    $0xc,%esp
80102983:	68 e0 3b 11 80       	push   $0x80113be0
80102988:	e8 23 2c 00 00       	call   801055b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010298d:	a1 c4 3b 11 80       	mov    0x80113bc4,%eax
  b->qnext = 0;
80102992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102999:	83 c4 10             	add    $0x10,%esp
8010299c:	85 c0                	test   %eax,%eax
8010299e:	74 60                	je     80102a00 <iderw+0xc0>
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	8b 40 58             	mov    0x58(%eax),%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	75 f7                	jne    801029a0 <iderw+0x60>
801029a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801029ac:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801029ae:	39 1d c4 3b 11 80    	cmp    %ebx,0x80113bc4
801029b4:	74 3a                	je     801029f0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029b6:	8b 03                	mov    (%ebx),%eax
801029b8:	83 e0 06             	and    $0x6,%eax
801029bb:	83 f8 02             	cmp    $0x2,%eax
801029be:	74 1b                	je     801029db <iderw+0x9b>
    sleep(b, &idelock);
801029c0:	83 ec 08             	sub    $0x8,%esp
801029c3:	68 e0 3b 11 80       	push   $0x80113be0
801029c8:	53                   	push   %ebx
801029c9:	e8 22 21 00 00       	call   80104af0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029ce:	8b 03                	mov    (%ebx),%eax
801029d0:	83 c4 10             	add    $0x10,%esp
801029d3:	83 e0 06             	and    $0x6,%eax
801029d6:	83 f8 02             	cmp    $0x2,%eax
801029d9:	75 e5                	jne    801029c0 <iderw+0x80>
  }


  release(&idelock);
801029db:	c7 45 08 e0 3b 11 80 	movl   $0x80113be0,0x8(%ebp)
}
801029e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e5:	c9                   	leave  
  release(&idelock);
801029e6:	e9 65 2b 00 00       	jmp    80105550 <release>
801029eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop
    idestart(b);
801029f0:	89 d8                	mov    %ebx,%eax
801029f2:	e8 49 fd ff ff       	call   80102740 <idestart>
801029f7:	eb bd                	jmp    801029b6 <iderw+0x76>
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a00:	ba c4 3b 11 80       	mov    $0x80113bc4,%edx
80102a05:	eb a5                	jmp    801029ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102a07:	83 ec 0c             	sub    $0xc,%esp
80102a0a:	68 b9 87 10 80       	push   $0x801087b9
80102a0f:	e8 6c d9 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102a14:	83 ec 0c             	sub    $0xc,%esp
80102a17:	68 a4 87 10 80       	push   $0x801087a4
80102a1c:	e8 5f d9 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102a21:	83 ec 0c             	sub    $0xc,%esp
80102a24:	68 8e 87 10 80       	push   $0x8010878e
80102a29:	e8 52 d9 ff ff       	call   80100380 <panic>
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102a30:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a31:	c7 05 14 3c 11 80 00 	movl   $0xfec00000,0x80113c14
80102a38:	00 c0 fe 
{
80102a3b:	89 e5                	mov    %esp,%ebp
80102a3d:	56                   	push   %esi
80102a3e:	53                   	push   %ebx
  ioapic->reg = reg;
80102a3f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a46:	00 00 00 
  return ioapic->data;
80102a49:	8b 15 14 3c 11 80    	mov    0x80113c14,%edx
80102a4f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102a52:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102a58:	8b 0d 14 3c 11 80    	mov    0x80113c14,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a5e:	0f b6 15 60 3d 11 80 	movzbl 0x80113d60,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a65:	c1 ee 10             	shr    $0x10,%esi
80102a68:	89 f0                	mov    %esi,%eax
80102a6a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102a6d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102a70:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102a73:	39 c2                	cmp    %eax,%edx
80102a75:	74 16                	je     80102a8d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a77:	83 ec 0c             	sub    $0xc,%esp
80102a7a:	68 d8 87 10 80       	push   $0x801087d8
80102a7f:	e8 1c dc ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102a84:	8b 0d 14 3c 11 80    	mov    0x80113c14,%ecx
80102a8a:	83 c4 10             	add    $0x10,%esp
80102a8d:	83 c6 21             	add    $0x21,%esi
{
80102a90:	ba 10 00 00 00       	mov    $0x10,%edx
80102a95:	b8 20 00 00 00       	mov    $0x20,%eax
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102aa0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aa2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102aa4:	8b 0d 14 3c 11 80    	mov    0x80113c14,%ecx
  for(i = 0; i <= maxintr; i++){
80102aaa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aad:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102ab3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102ab6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102ab9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102abc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102abe:	8b 0d 14 3c 11 80    	mov    0x80113c14,%ecx
80102ac4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102acb:	39 f0                	cmp    %esi,%eax
80102acd:	75 d1                	jne    80102aa0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ad2:	5b                   	pop    %ebx
80102ad3:	5e                   	pop    %esi
80102ad4:	5d                   	pop    %ebp
80102ad5:	c3                   	ret    
80102ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102add:	8d 76 00             	lea    0x0(%esi),%esi

80102ae0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ae0:	55                   	push   %ebp
  ioapic->reg = reg;
80102ae1:	8b 0d 14 3c 11 80    	mov    0x80113c14,%ecx
{
80102ae7:	89 e5                	mov    %esp,%ebp
80102ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102aec:	8d 50 20             	lea    0x20(%eax),%edx
80102aef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102af3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102af5:	8b 0d 14 3c 11 80    	mov    0x80113c14,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102afb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102afe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102b04:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b06:	a1 14 3c 11 80       	mov    0x80113c14,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b0b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102b0e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b11:	5d                   	pop    %ebp
80102b12:	c3                   	ret    
80102b13:	66 90                	xchg   %ax,%ax
80102b15:	66 90                	xchg   %ax,%ax
80102b17:	66 90                	xchg   %ax,%ax
80102b19:	66 90                	xchg   %ax,%ax
80102b1b:	66 90                	xchg   %ax,%ax
80102b1d:	66 90                	xchg   %ax,%ax
80102b1f:	90                   	nop

80102b20 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 04             	sub    $0x4,%esp
80102b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b2a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b30:	75 76                	jne    80102ba8 <kfree+0x88>
80102b32:	81 fb b0 83 11 80    	cmp    $0x801183b0,%ebx
80102b38:	72 6e                	jb     80102ba8 <kfree+0x88>
80102b3a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b40:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b45:	77 61                	ja     80102ba8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b47:	83 ec 04             	sub    $0x4,%esp
80102b4a:	68 00 10 00 00       	push   $0x1000
80102b4f:	6a 01                	push   $0x1
80102b51:	53                   	push   %ebx
80102b52:	e8 19 2b 00 00       	call   80105670 <memset>

  if(kmem.use_lock)
80102b57:	8b 15 54 3c 11 80    	mov    0x80113c54,%edx
80102b5d:	83 c4 10             	add    $0x10,%esp
80102b60:	85 d2                	test   %edx,%edx
80102b62:	75 1c                	jne    80102b80 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b64:	a1 58 3c 11 80       	mov    0x80113c58,%eax
80102b69:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b6b:	a1 54 3c 11 80       	mov    0x80113c54,%eax
  kmem.freelist = r;
80102b70:	89 1d 58 3c 11 80    	mov    %ebx,0x80113c58
  if(kmem.use_lock)
80102b76:	85 c0                	test   %eax,%eax
80102b78:	75 1e                	jne    80102b98 <kfree+0x78>
    release(&kmem.lock);
}
80102b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    
80102b7f:	90                   	nop
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 20 3c 11 80       	push   $0x80113c20
80102b88:	e8 23 2a 00 00       	call   801055b0 <acquire>
80102b8d:	83 c4 10             	add    $0x10,%esp
80102b90:	eb d2                	jmp    80102b64 <kfree+0x44>
80102b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102b98:	c7 45 08 20 3c 11 80 	movl   $0x80113c20,0x8(%ebp)
}
80102b9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba2:	c9                   	leave  
    release(&kmem.lock);
80102ba3:	e9 a8 29 00 00       	jmp    80105550 <release>
    panic("kfree");
80102ba8:	83 ec 0c             	sub    $0xc,%esp
80102bab:	68 0a 88 10 80       	push   $0x8010880a
80102bb0:	e8 cb d7 ff ff       	call   80100380 <panic>
80102bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bc0 <freerange>:
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bc7:	8b 75 0c             	mov    0xc(%ebp),%esi
80102bca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bcb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bd1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bdd:	39 de                	cmp    %ebx,%esi
80102bdf:	72 23                	jb     80102c04 <freerange+0x44>
80102be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102be8:	83 ec 0c             	sub    $0xc,%esp
80102beb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102bf7:	50                   	push   %eax
80102bf8:	e8 23 ff ff ff       	call   80102b20 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bfd:	83 c4 10             	add    $0x10,%esp
80102c00:	39 f3                	cmp    %esi,%ebx
80102c02:	76 e4                	jbe    80102be8 <freerange+0x28>
}
80102c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c07:	5b                   	pop    %ebx
80102c08:	5e                   	pop    %esi
80102c09:	5d                   	pop    %ebp
80102c0a:	c3                   	ret    
80102c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c0f:	90                   	nop

80102c10 <kinit2>:
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c14:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c17:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c1a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c1b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c21:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c27:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c2d:	39 de                	cmp    %ebx,%esi
80102c2f:	72 23                	jb     80102c54 <kinit2+0x44>
80102c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c38:	83 ec 0c             	sub    $0xc,%esp
80102c3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c47:	50                   	push   %eax
80102c48:	e8 d3 fe ff ff       	call   80102b20 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	39 de                	cmp    %ebx,%esi
80102c52:	73 e4                	jae    80102c38 <kinit2+0x28>
  kmem.use_lock = 1;
80102c54:	c7 05 54 3c 11 80 01 	movl   $0x1,0x80113c54
80102c5b:	00 00 00 
}
80102c5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c61:	5b                   	pop    %ebx
80102c62:	5e                   	pop    %esi
80102c63:	5d                   	pop    %ebp
80102c64:	c3                   	ret    
80102c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c70 <kinit1>:
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
80102c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c78:	83 ec 08             	sub    $0x8,%esp
80102c7b:	68 10 88 10 80       	push   $0x80108810
80102c80:	68 20 3c 11 80       	push   $0x80113c20
80102c85:	e8 56 27 00 00       	call   801053e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c90:	c7 05 54 3c 11 80 00 	movl   $0x0,0x80113c54
80102c97:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c9a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ca0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ca6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cac:	39 de                	cmp    %ebx,%esi
80102cae:	72 1c                	jb     80102ccc <kinit1+0x5c>
    kfree(p);
80102cb0:	83 ec 0c             	sub    $0xc,%esp
80102cb3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102cbf:	50                   	push   %eax
80102cc0:	e8 5b fe ff ff       	call   80102b20 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cc5:	83 c4 10             	add    $0x10,%esp
80102cc8:	39 de                	cmp    %ebx,%esi
80102cca:	73 e4                	jae    80102cb0 <kinit1+0x40>
}
80102ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ccf:	5b                   	pop    %ebx
80102cd0:	5e                   	pop    %esi
80102cd1:	5d                   	pop    %ebp
80102cd2:	c3                   	ret    
80102cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ce0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102ce0:	a1 54 3c 11 80       	mov    0x80113c54,%eax
80102ce5:	85 c0                	test   %eax,%eax
80102ce7:	75 1f                	jne    80102d08 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102ce9:	a1 58 3c 11 80       	mov    0x80113c58,%eax
  if(r)
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	74 0e                	je     80102d00 <kalloc+0x20>
    kmem.freelist = r->next;
80102cf2:	8b 10                	mov    (%eax),%edx
80102cf4:	89 15 58 3c 11 80    	mov    %edx,0x80113c58
  if(kmem.use_lock)
80102cfa:	c3                   	ret    
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102d00:	c3                   	ret    
80102d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102d08:	55                   	push   %ebp
80102d09:	89 e5                	mov    %esp,%ebp
80102d0b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d0e:	68 20 3c 11 80       	push   $0x80113c20
80102d13:	e8 98 28 00 00       	call   801055b0 <acquire>
  r = kmem.freelist;
80102d18:	a1 58 3c 11 80       	mov    0x80113c58,%eax
  if(kmem.use_lock)
80102d1d:	8b 15 54 3c 11 80    	mov    0x80113c54,%edx
  if(r)
80102d23:	83 c4 10             	add    $0x10,%esp
80102d26:	85 c0                	test   %eax,%eax
80102d28:	74 08                	je     80102d32 <kalloc+0x52>
    kmem.freelist = r->next;
80102d2a:	8b 08                	mov    (%eax),%ecx
80102d2c:	89 0d 58 3c 11 80    	mov    %ecx,0x80113c58
  if(kmem.use_lock)
80102d32:	85 d2                	test   %edx,%edx
80102d34:	74 16                	je     80102d4c <kalloc+0x6c>
    release(&kmem.lock);
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d3c:	68 20 3c 11 80       	push   $0x80113c20
80102d41:	e8 0a 28 00 00       	call   80105550 <release>
  return (char*)r;
80102d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d49:	83 c4 10             	add    $0x10,%esp
}
80102d4c:	c9                   	leave  
80102d4d:	c3                   	ret    
80102d4e:	66 90                	xchg   %ax,%ax

80102d50 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d50:	ba 64 00 00 00       	mov    $0x64,%edx
80102d55:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d56:	a8 01                	test   $0x1,%al
80102d58:	0f 84 c2 00 00 00    	je     80102e20 <kbdgetc+0xd0>
{
80102d5e:	55                   	push   %ebp
80102d5f:	ba 60 00 00 00       	mov    $0x60,%edx
80102d64:	89 e5                	mov    %esp,%ebp
80102d66:	53                   	push   %ebx
80102d67:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102d68:	8b 1d 5c 3c 11 80    	mov    0x80113c5c,%ebx
  data = inb(KBDATAP);
80102d6e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102d71:	3c e0                	cmp    $0xe0,%al
80102d73:	74 5b                	je     80102dd0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d75:	89 da                	mov    %ebx,%edx
80102d77:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102d7a:	84 c0                	test   %al,%al
80102d7c:	78 62                	js     80102de0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d7e:	85 d2                	test   %edx,%edx
80102d80:	74 09                	je     80102d8b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d82:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d85:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102d88:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102d8b:	0f b6 91 40 89 10 80 	movzbl -0x7fef76c0(%ecx),%edx
  shift ^= togglecode[data];
80102d92:	0f b6 81 40 88 10 80 	movzbl -0x7fef77c0(%ecx),%eax
  shift |= shiftcode[data];
80102d99:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102d9b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d9d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102d9f:	89 15 5c 3c 11 80    	mov    %edx,0x80113c5c
  c = charcode[shift & (CTL | SHIFT)][data];
80102da5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102da8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102dab:	8b 04 85 20 88 10 80 	mov    -0x7fef77e0(,%eax,4),%eax
80102db2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102db6:	74 0b                	je     80102dc3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102db8:	8d 50 9f             	lea    -0x61(%eax),%edx
80102dbb:	83 fa 19             	cmp    $0x19,%edx
80102dbe:	77 48                	ja     80102e08 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102dc0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc6:	c9                   	leave  
80102dc7:	c3                   	ret    
80102dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
    shift |= E0ESC;
80102dd0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102dd3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102dd5:	89 1d 5c 3c 11 80    	mov    %ebx,0x80113c5c
}
80102ddb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dde:	c9                   	leave  
80102ddf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102de0:	83 e0 7f             	and    $0x7f,%eax
80102de3:	85 d2                	test   %edx,%edx
80102de5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102de8:	0f b6 81 40 89 10 80 	movzbl -0x7fef76c0(%ecx),%eax
80102def:	83 c8 40             	or     $0x40,%eax
80102df2:	0f b6 c0             	movzbl %al,%eax
80102df5:	f7 d0                	not    %eax
80102df7:	21 d8                	and    %ebx,%eax
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102dfc:	a3 5c 3c 11 80       	mov    %eax,0x80113c5c
    return 0;
80102e01:	31 c0                	xor    %eax,%eax
}
80102e03:	c9                   	leave  
80102e04:	c3                   	ret    
80102e05:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102e08:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e0b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e11:	c9                   	leave  
      c += 'a' - 'A';
80102e12:	83 f9 1a             	cmp    $0x1a,%ecx
80102e15:	0f 42 c2             	cmovb  %edx,%eax
}
80102e18:	c3                   	ret    
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e25:	c3                   	ret    
80102e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi

80102e30 <kbdintr>:

void
kbdintr(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e36:	68 50 2d 10 80       	push   $0x80102d50
80102e3b:	e8 70 de ff ff       	call   80100cb0 <consoleintr>
}
80102e40:	83 c4 10             	add    $0x10,%esp
80102e43:	c9                   	leave  
80102e44:	c3                   	ret    
80102e45:	66 90                	xchg   %ax,%ax
80102e47:	66 90                	xchg   %ax,%ax
80102e49:	66 90                	xchg   %ax,%ax
80102e4b:	66 90                	xchg   %ax,%ax
80102e4d:	66 90                	xchg   %ax,%ax
80102e4f:	90                   	nop

80102e50 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102e50:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80102e55:	85 c0                	test   %eax,%eax
80102e57:	0f 84 cb 00 00 00    	je     80102f28 <lapicinit+0xd8>
  lapic[index] = value;
80102e5d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e64:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e6a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e71:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e77:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e7e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e81:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e84:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e8b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e91:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e98:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e9e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ea5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102eab:	8b 50 30             	mov    0x30(%eax),%edx
80102eae:	c1 ea 10             	shr    $0x10,%edx
80102eb1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102eb7:	75 77                	jne    80102f30 <lapicinit+0xe0>
  lapic[index] = value;
80102eb9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ec0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ecd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102eda:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102edd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ee0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ee7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ef4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102efa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f01:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f04:	8b 50 20             	mov    0x20(%eax),%edx
80102f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f10:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f16:	80 e6 10             	and    $0x10,%dh
80102f19:	75 f5                	jne    80102f10 <lapicinit+0xc0>
  lapic[index] = value;
80102f1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f22:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f25:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f28:	c3                   	ret    
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102f30:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f37:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f3a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102f3d:	e9 77 ff ff ff       	jmp    80102eb9 <lapicinit+0x69>
80102f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f50 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102f50:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80102f55:	85 c0                	test   %eax,%eax
80102f57:	74 07                	je     80102f60 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102f59:	8b 40 20             	mov    0x20(%eax),%eax
80102f5c:	c1 e8 18             	shr    $0x18,%eax
80102f5f:	c3                   	ret    
    return 0;
80102f60:	31 c0                	xor    %eax,%eax
}
80102f62:	c3                   	ret    
80102f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f70 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102f70:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80102f75:	85 c0                	test   %eax,%eax
80102f77:	74 0d                	je     80102f86 <lapiceoi+0x16>
  lapic[index] = value;
80102f79:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f83:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f86:	c3                   	ret    
80102f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8e:	66 90                	xchg   %ax,%ax

80102f90 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102f90:	c3                   	ret    
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop

80102fa0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fa0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fa1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102fa6:	ba 70 00 00 00       	mov    $0x70,%edx
80102fab:	89 e5                	mov    %esp,%ebp
80102fad:	53                   	push   %ebx
80102fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fb4:	ee                   	out    %al,(%dx)
80102fb5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fba:	ba 71 00 00 00       	mov    $0x71,%edx
80102fbf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102fc0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fc2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102fc5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102fcb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fcd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102fd0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102fd2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fd5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102fd8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102fde:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80102fe3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fe9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ff3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ff6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ff9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103000:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103003:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103006:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010300c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010300f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103015:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103018:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010301e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103021:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103027:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010302a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010302d:	c9                   	leave  
8010302e:	c3                   	ret    
8010302f:	90                   	nop

80103030 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103030:	55                   	push   %ebp
80103031:	b8 0b 00 00 00       	mov    $0xb,%eax
80103036:	ba 70 00 00 00       	mov    $0x70,%edx
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	57                   	push   %edi
8010303e:	56                   	push   %esi
8010303f:	53                   	push   %ebx
80103040:	83 ec 4c             	sub    $0x4c,%esp
80103043:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103044:	ba 71 00 00 00       	mov    $0x71,%edx
80103049:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010304a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010304d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103052:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103055:	8d 76 00             	lea    0x0(%esi),%esi
80103058:	31 c0                	xor    %eax,%eax
8010305a:	89 da                	mov    %ebx,%edx
8010305c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010305d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103062:	89 ca                	mov    %ecx,%edx
80103064:	ec                   	in     (%dx),%al
80103065:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103068:	89 da                	mov    %ebx,%edx
8010306a:	b8 02 00 00 00       	mov    $0x2,%eax
8010306f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103070:	89 ca                	mov    %ecx,%edx
80103072:	ec                   	in     (%dx),%al
80103073:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103076:	89 da                	mov    %ebx,%edx
80103078:	b8 04 00 00 00       	mov    $0x4,%eax
8010307d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010307e:	89 ca                	mov    %ecx,%edx
80103080:	ec                   	in     (%dx),%al
80103081:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103084:	89 da                	mov    %ebx,%edx
80103086:	b8 07 00 00 00       	mov    $0x7,%eax
8010308b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010308c:	89 ca                	mov    %ecx,%edx
8010308e:	ec                   	in     (%dx),%al
8010308f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103092:	89 da                	mov    %ebx,%edx
80103094:	b8 08 00 00 00       	mov    $0x8,%eax
80103099:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010309a:	89 ca                	mov    %ecx,%edx
8010309c:	ec                   	in     (%dx),%al
8010309d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309f:	89 da                	mov    %ebx,%edx
801030a1:	b8 09 00 00 00       	mov    $0x9,%eax
801030a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a7:	89 ca                	mov    %ecx,%edx
801030a9:	ec                   	in     (%dx),%al
801030aa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ac:	89 da                	mov    %ebx,%edx
801030ae:	b8 0a 00 00 00       	mov    $0xa,%eax
801030b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b4:	89 ca                	mov    %ecx,%edx
801030b6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030b7:	84 c0                	test   %al,%al
801030b9:	78 9d                	js     80103058 <cmostime+0x28>
  return inb(CMOS_RETURN);
801030bb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801030bf:	89 fa                	mov    %edi,%edx
801030c1:	0f b6 fa             	movzbl %dl,%edi
801030c4:	89 f2                	mov    %esi,%edx
801030c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
801030c9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801030cd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030d0:	89 da                	mov    %ebx,%edx
801030d2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801030d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030d8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801030dc:	89 75 cc             	mov    %esi,-0x34(%ebp)
801030df:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030e2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801030e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030e9:	31 c0                	xor    %eax,%eax
801030eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ec:	89 ca                	mov    %ecx,%edx
801030ee:	ec                   	in     (%dx),%al
801030ef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f2:	89 da                	mov    %ebx,%edx
801030f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801030f7:	b8 02 00 00 00       	mov    $0x2,%eax
801030fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030fd:	89 ca                	mov    %ecx,%edx
801030ff:	ec                   	in     (%dx),%al
80103100:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103103:	89 da                	mov    %ebx,%edx
80103105:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103108:	b8 04 00 00 00       	mov    $0x4,%eax
8010310d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010310e:	89 ca                	mov    %ecx,%edx
80103110:	ec                   	in     (%dx),%al
80103111:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103114:	89 da                	mov    %ebx,%edx
80103116:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103119:	b8 07 00 00 00       	mov    $0x7,%eax
8010311e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010311f:	89 ca                	mov    %ecx,%edx
80103121:	ec                   	in     (%dx),%al
80103122:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103125:	89 da                	mov    %ebx,%edx
80103127:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010312a:	b8 08 00 00 00       	mov    $0x8,%eax
8010312f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103130:	89 ca                	mov    %ecx,%edx
80103132:	ec                   	in     (%dx),%al
80103133:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103136:	89 da                	mov    %ebx,%edx
80103138:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010313b:	b8 09 00 00 00       	mov    $0x9,%eax
80103140:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103141:	89 ca                	mov    %ecx,%edx
80103143:	ec                   	in     (%dx),%al
80103144:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103147:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010314a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010314d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103150:	6a 18                	push   $0x18
80103152:	50                   	push   %eax
80103153:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103156:	50                   	push   %eax
80103157:	e8 64 25 00 00       	call   801056c0 <memcmp>
8010315c:	83 c4 10             	add    $0x10,%esp
8010315f:	85 c0                	test   %eax,%eax
80103161:	0f 85 f1 fe ff ff    	jne    80103058 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103167:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010316b:	75 78                	jne    801031e5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010316d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103170:	89 c2                	mov    %eax,%edx
80103172:	83 e0 0f             	and    $0xf,%eax
80103175:	c1 ea 04             	shr    $0x4,%edx
80103178:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010317b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010317e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103181:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103184:	89 c2                	mov    %eax,%edx
80103186:	83 e0 0f             	and    $0xf,%eax
80103189:	c1 ea 04             	shr    $0x4,%edx
8010318c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010318f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103192:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103195:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103198:	89 c2                	mov    %eax,%edx
8010319a:	83 e0 0f             	and    $0xf,%eax
8010319d:	c1 ea 04             	shr    $0x4,%edx
801031a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031ac:	89 c2                	mov    %eax,%edx
801031ae:	83 e0 0f             	and    $0xf,%eax
801031b1:	c1 ea 04             	shr    $0x4,%edx
801031b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031c0:	89 c2                	mov    %eax,%edx
801031c2:	83 e0 0f             	and    $0xf,%eax
801031c5:	c1 ea 04             	shr    $0x4,%edx
801031c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801031d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031d4:	89 c2                	mov    %eax,%edx
801031d6:	83 e0 0f             	and    $0xf,%eax
801031d9:	c1 ea 04             	shr    $0x4,%edx
801031dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801031e5:	8b 75 08             	mov    0x8(%ebp),%esi
801031e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031eb:	89 06                	mov    %eax,(%esi)
801031ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031f0:	89 46 04             	mov    %eax,0x4(%esi)
801031f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031f6:	89 46 08             	mov    %eax,0x8(%esi)
801031f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031fc:	89 46 0c             	mov    %eax,0xc(%esi)
801031ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103202:	89 46 10             	mov    %eax,0x10(%esi)
80103205:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103208:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010320b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103215:	5b                   	pop    %ebx
80103216:	5e                   	pop    %esi
80103217:	5f                   	pop    %edi
80103218:	5d                   	pop    %ebp
80103219:	c3                   	ret    
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103220:	8b 0d c8 3c 11 80    	mov    0x80113cc8,%ecx
80103226:	85 c9                	test   %ecx,%ecx
80103228:	0f 8e 8a 00 00 00    	jle    801032b8 <install_trans+0x98>
{
8010322e:	55                   	push   %ebp
8010322f:	89 e5                	mov    %esp,%ebp
80103231:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103232:	31 ff                	xor    %edi,%edi
{
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 0c             	sub    $0xc,%esp
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103240:	a1 b4 3c 11 80       	mov    0x80113cb4,%eax
80103245:	83 ec 08             	sub    $0x8,%esp
80103248:	01 f8                	add    %edi,%eax
8010324a:	83 c0 01             	add    $0x1,%eax
8010324d:	50                   	push   %eax
8010324e:	ff 35 c4 3c 11 80    	push   0x80113cc4
80103254:	e8 77 ce ff ff       	call   801000d0 <bread>
80103259:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010325b:	58                   	pop    %eax
8010325c:	5a                   	pop    %edx
8010325d:	ff 34 bd cc 3c 11 80 	push   -0x7feec334(,%edi,4)
80103264:	ff 35 c4 3c 11 80    	push   0x80113cc4
  for (tail = 0; tail < log.lh.n; tail++) {
8010326a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010326d:	e8 5e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103272:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103275:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103277:	8d 46 5c             	lea    0x5c(%esi),%eax
8010327a:	68 00 02 00 00       	push   $0x200
8010327f:	50                   	push   %eax
80103280:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103283:	50                   	push   %eax
80103284:	e8 87 24 00 00       	call   80105710 <memmove>
    bwrite(dbuf);  // write dst to disk
80103289:	89 1c 24             	mov    %ebx,(%esp)
8010328c:	e8 1f cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103291:	89 34 24             	mov    %esi,(%esp)
80103294:	e8 57 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103299:	89 1c 24             	mov    %ebx,(%esp)
8010329c:	e8 4f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032a1:	83 c4 10             	add    $0x10,%esp
801032a4:	39 3d c8 3c 11 80    	cmp    %edi,0x80113cc8
801032aa:	7f 94                	jg     80103240 <install_trans+0x20>
  }
}
801032ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032af:	5b                   	pop    %ebx
801032b0:	5e                   	pop    %esi
801032b1:	5f                   	pop    %edi
801032b2:	5d                   	pop    %ebp
801032b3:	c3                   	ret    
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032b8:	c3                   	ret    
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	53                   	push   %ebx
801032c4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801032c7:	ff 35 b4 3c 11 80    	push   0x80113cb4
801032cd:	ff 35 c4 3c 11 80    	push   0x80113cc4
801032d3:	e8 f8 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801032d8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801032db:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801032dd:	a1 c8 3c 11 80       	mov    0x80113cc8,%eax
801032e2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801032e5:	85 c0                	test   %eax,%eax
801032e7:	7e 19                	jle    80103302 <write_head+0x42>
801032e9:	31 d2                	xor    %edx,%edx
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
    hb->block[i] = log.lh.block[i];
801032f0:	8b 0c 95 cc 3c 11 80 	mov    -0x7feec334(,%edx,4),%ecx
801032f7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801032fb:	83 c2 01             	add    $0x1,%edx
801032fe:	39 d0                	cmp    %edx,%eax
80103300:	75 ee                	jne    801032f0 <write_head+0x30>
  }
  bwrite(buf);
80103302:	83 ec 0c             	sub    $0xc,%esp
80103305:	53                   	push   %ebx
80103306:	e8 a5 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010330b:	89 1c 24             	mov    %ebx,(%esp)
8010330e:	e8 dd ce ff ff       	call   801001f0 <brelse>
}
80103313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103316:	83 c4 10             	add    $0x10,%esp
80103319:	c9                   	leave  
8010331a:	c3                   	ret    
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <initlog>:
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	53                   	push   %ebx
80103324:	83 ec 2c             	sub    $0x2c,%esp
80103327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010332a:	68 40 8a 10 80       	push   $0x80108a40
8010332f:	68 80 3c 11 80       	push   $0x80113c80
80103334:	e8 a7 20 00 00       	call   801053e0 <initlock>
  readsb(dev, &sb);
80103339:	58                   	pop    %eax
8010333a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010333d:	5a                   	pop    %edx
8010333e:	50                   	push   %eax
8010333f:	53                   	push   %ebx
80103340:	e8 3b e8 ff ff       	call   80101b80 <readsb>
  log.start = sb.logstart;
80103345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103348:	59                   	pop    %ecx
  log.dev = dev;
80103349:	89 1d c4 3c 11 80    	mov    %ebx,0x80113cc4
  log.size = sb.nlog;
8010334f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103352:	a3 b4 3c 11 80       	mov    %eax,0x80113cb4
  log.size = sb.nlog;
80103357:	89 15 b8 3c 11 80    	mov    %edx,0x80113cb8
  struct buf *buf = bread(log.dev, log.start);
8010335d:	5a                   	pop    %edx
8010335e:	50                   	push   %eax
8010335f:	53                   	push   %ebx
80103360:	e8 6b cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103365:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103368:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010336b:	89 1d c8 3c 11 80    	mov    %ebx,0x80113cc8
  for (i = 0; i < log.lh.n; i++) {
80103371:	85 db                	test   %ebx,%ebx
80103373:	7e 1d                	jle    80103392 <initlog+0x72>
80103375:	31 d2                	xor    %edx,%edx
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103380:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103384:	89 0c 95 cc 3c 11 80 	mov    %ecx,-0x7feec334(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010338b:	83 c2 01             	add    $0x1,%edx
8010338e:	39 d3                	cmp    %edx,%ebx
80103390:	75 ee                	jne    80103380 <initlog+0x60>
  brelse(buf);
80103392:	83 ec 0c             	sub    $0xc,%esp
80103395:	50                   	push   %eax
80103396:	e8 55 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010339b:	e8 80 fe ff ff       	call   80103220 <install_trans>
  log.lh.n = 0;
801033a0:	c7 05 c8 3c 11 80 00 	movl   $0x0,0x80113cc8
801033a7:	00 00 00 
  write_head(); // clear the log
801033aa:	e8 11 ff ff ff       	call   801032c0 <write_head>
}
801033af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033b2:	83 c4 10             	add    $0x10,%esp
801033b5:	c9                   	leave  
801033b6:	c3                   	ret    
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax

801033c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801033c6:	68 80 3c 11 80       	push   $0x80113c80
801033cb:	e8 e0 21 00 00       	call   801055b0 <acquire>
801033d0:	83 c4 10             	add    $0x10,%esp
801033d3:	eb 18                	jmp    801033ed <begin_op+0x2d>
801033d5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801033d8:	83 ec 08             	sub    $0x8,%esp
801033db:	68 80 3c 11 80       	push   $0x80113c80
801033e0:	68 80 3c 11 80       	push   $0x80113c80
801033e5:	e8 06 17 00 00       	call   80104af0 <sleep>
801033ea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801033ed:	a1 c0 3c 11 80       	mov    0x80113cc0,%eax
801033f2:	85 c0                	test   %eax,%eax
801033f4:	75 e2                	jne    801033d8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801033f6:	a1 bc 3c 11 80       	mov    0x80113cbc,%eax
801033fb:	8b 15 c8 3c 11 80    	mov    0x80113cc8,%edx
80103401:	83 c0 01             	add    $0x1,%eax
80103404:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103407:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010340a:	83 fa 1e             	cmp    $0x1e,%edx
8010340d:	7f c9                	jg     801033d8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010340f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103412:	a3 bc 3c 11 80       	mov    %eax,0x80113cbc
      release(&log.lock);
80103417:	68 80 3c 11 80       	push   $0x80113c80
8010341c:	e8 2f 21 00 00       	call   80105550 <release>
      break;
    }
  }
}
80103421:	83 c4 10             	add    $0x10,%esp
80103424:	c9                   	leave  
80103425:	c3                   	ret    
80103426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010342d:	8d 76 00             	lea    0x0(%esi),%esi

80103430 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103439:	68 80 3c 11 80       	push   $0x80113c80
8010343e:	e8 6d 21 00 00       	call   801055b0 <acquire>
  log.outstanding -= 1;
80103443:	a1 bc 3c 11 80       	mov    0x80113cbc,%eax
  if(log.committing)
80103448:	8b 35 c0 3c 11 80    	mov    0x80113cc0,%esi
8010344e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103451:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103454:	89 1d bc 3c 11 80    	mov    %ebx,0x80113cbc
  if(log.committing)
8010345a:	85 f6                	test   %esi,%esi
8010345c:	0f 85 22 01 00 00    	jne    80103584 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103462:	85 db                	test   %ebx,%ebx
80103464:	0f 85 f6 00 00 00    	jne    80103560 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010346a:	c7 05 c0 3c 11 80 01 	movl   $0x1,0x80113cc0
80103471:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103474:	83 ec 0c             	sub    $0xc,%esp
80103477:	68 80 3c 11 80       	push   $0x80113c80
8010347c:	e8 cf 20 00 00       	call   80105550 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103481:	8b 0d c8 3c 11 80    	mov    0x80113cc8,%ecx
80103487:	83 c4 10             	add    $0x10,%esp
8010348a:	85 c9                	test   %ecx,%ecx
8010348c:	7f 42                	jg     801034d0 <end_op+0xa0>
    acquire(&log.lock);
8010348e:	83 ec 0c             	sub    $0xc,%esp
80103491:	68 80 3c 11 80       	push   $0x80113c80
80103496:	e8 15 21 00 00       	call   801055b0 <acquire>
    wakeup(&log);
8010349b:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
    log.committing = 0;
801034a2:	c7 05 c0 3c 11 80 00 	movl   $0x0,0x80113cc0
801034a9:	00 00 00 
    wakeup(&log);
801034ac:	e8 ff 16 00 00       	call   80104bb0 <wakeup>
    release(&log.lock);
801034b1:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
801034b8:	e8 93 20 00 00       	call   80105550 <release>
801034bd:	83 c4 10             	add    $0x10,%esp
}
801034c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c3:	5b                   	pop    %ebx
801034c4:	5e                   	pop    %esi
801034c5:	5f                   	pop    %edi
801034c6:	5d                   	pop    %ebp
801034c7:	c3                   	ret    
801034c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034cf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034d0:	a1 b4 3c 11 80       	mov    0x80113cb4,%eax
801034d5:	83 ec 08             	sub    $0x8,%esp
801034d8:	01 d8                	add    %ebx,%eax
801034da:	83 c0 01             	add    $0x1,%eax
801034dd:	50                   	push   %eax
801034de:	ff 35 c4 3c 11 80    	push   0x80113cc4
801034e4:	e8 e7 cb ff ff       	call   801000d0 <bread>
801034e9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034eb:	58                   	pop    %eax
801034ec:	5a                   	pop    %edx
801034ed:	ff 34 9d cc 3c 11 80 	push   -0x7feec334(,%ebx,4)
801034f4:	ff 35 c4 3c 11 80    	push   0x80113cc4
  for (tail = 0; tail < log.lh.n; tail++) {
801034fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034fd:	e8 ce cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103502:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103505:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103507:	8d 40 5c             	lea    0x5c(%eax),%eax
8010350a:	68 00 02 00 00       	push   $0x200
8010350f:	50                   	push   %eax
80103510:	8d 46 5c             	lea    0x5c(%esi),%eax
80103513:	50                   	push   %eax
80103514:	e8 f7 21 00 00       	call   80105710 <memmove>
    bwrite(to);  // write the log
80103519:	89 34 24             	mov    %esi,(%esp)
8010351c:	e8 8f cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103521:	89 3c 24             	mov    %edi,(%esp)
80103524:	e8 c7 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
80103529:	89 34 24             	mov    %esi,(%esp)
8010352c:	e8 bf cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103531:	83 c4 10             	add    $0x10,%esp
80103534:	3b 1d c8 3c 11 80    	cmp    0x80113cc8,%ebx
8010353a:	7c 94                	jl     801034d0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010353c:	e8 7f fd ff ff       	call   801032c0 <write_head>
    install_trans(); // Now install writes to home locations
80103541:	e8 da fc ff ff       	call   80103220 <install_trans>
    log.lh.n = 0;
80103546:	c7 05 c8 3c 11 80 00 	movl   $0x0,0x80113cc8
8010354d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103550:	e8 6b fd ff ff       	call   801032c0 <write_head>
80103555:	e9 34 ff ff ff       	jmp    8010348e <end_op+0x5e>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	68 80 3c 11 80       	push   $0x80113c80
80103568:	e8 43 16 00 00       	call   80104bb0 <wakeup>
  release(&log.lock);
8010356d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80103574:	e8 d7 1f 00 00       	call   80105550 <release>
80103579:	83 c4 10             	add    $0x10,%esp
}
8010357c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357f:	5b                   	pop    %ebx
80103580:	5e                   	pop    %esi
80103581:	5f                   	pop    %edi
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
    panic("log.committing");
80103584:	83 ec 0c             	sub    $0xc,%esp
80103587:	68 44 8a 10 80       	push   $0x80108a44
8010358c:	e8 ef cd ff ff       	call   80100380 <panic>
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359f:	90                   	nop

801035a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
801035a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035a7:	8b 15 c8 3c 11 80    	mov    0x80113cc8,%edx
{
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035b0:	83 fa 1d             	cmp    $0x1d,%edx
801035b3:	0f 8f 85 00 00 00    	jg     8010363e <log_write+0x9e>
801035b9:	a1 b8 3c 11 80       	mov    0x80113cb8,%eax
801035be:	83 e8 01             	sub    $0x1,%eax
801035c1:	39 c2                	cmp    %eax,%edx
801035c3:	7d 79                	jge    8010363e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035c5:	a1 bc 3c 11 80       	mov    0x80113cbc,%eax
801035ca:	85 c0                	test   %eax,%eax
801035cc:	7e 7d                	jle    8010364b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	68 80 3c 11 80       	push   $0x80113c80
801035d6:	e8 d5 1f 00 00       	call   801055b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035db:	8b 15 c8 3c 11 80    	mov    0x80113cc8,%edx
801035e1:	83 c4 10             	add    $0x10,%esp
801035e4:	85 d2                	test   %edx,%edx
801035e6:	7e 4a                	jle    80103632 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035e8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801035eb:	31 c0                	xor    %eax,%eax
801035ed:	eb 08                	jmp    801035f7 <log_write+0x57>
801035ef:	90                   	nop
801035f0:	83 c0 01             	add    $0x1,%eax
801035f3:	39 c2                	cmp    %eax,%edx
801035f5:	74 29                	je     80103620 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035f7:	39 0c 85 cc 3c 11 80 	cmp    %ecx,-0x7feec334(,%eax,4)
801035fe:	75 f0                	jne    801035f0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103600:	89 0c 85 cc 3c 11 80 	mov    %ecx,-0x7feec334(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103607:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010360a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010360d:	c7 45 08 80 3c 11 80 	movl   $0x80113c80,0x8(%ebp)
}
80103614:	c9                   	leave  
  release(&log.lock);
80103615:	e9 36 1f 00 00       	jmp    80105550 <release>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103620:	89 0c 95 cc 3c 11 80 	mov    %ecx,-0x7feec334(,%edx,4)
    log.lh.n++;
80103627:	83 c2 01             	add    $0x1,%edx
8010362a:	89 15 c8 3c 11 80    	mov    %edx,0x80113cc8
80103630:	eb d5                	jmp    80103607 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103632:	8b 43 08             	mov    0x8(%ebx),%eax
80103635:	a3 cc 3c 11 80       	mov    %eax,0x80113ccc
  if (i == log.lh.n)
8010363a:	75 cb                	jne    80103607 <log_write+0x67>
8010363c:	eb e9                	jmp    80103627 <log_write+0x87>
    panic("too big a transaction");
8010363e:	83 ec 0c             	sub    $0xc,%esp
80103641:	68 53 8a 10 80       	push   $0x80108a53
80103646:	e8 35 cd ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	68 69 8a 10 80       	push   $0x80108a69
80103653:	e8 28 cd ff ff       	call   80100380 <panic>
80103658:	66 90                	xchg   %ax,%ax
8010365a:	66 90                	xchg   %ax,%ax
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	53                   	push   %ebx
80103664:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103667:	e8 14 0a 00 00       	call   80104080 <cpuid>
8010366c:	89 c3                	mov    %eax,%ebx
8010366e:	e8 0d 0a 00 00       	call   80104080 <cpuid>
80103673:	83 ec 04             	sub    $0x4,%esp
80103676:	53                   	push   %ebx
80103677:	50                   	push   %eax
80103678:	68 84 8a 10 80       	push   $0x80108a84
8010367d:	e8 1e d0 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103682:	e8 d9 33 00 00       	call   80106a60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103687:	e8 94 09 00 00       	call   80104020 <mycpu>
8010368c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010368e:	b8 01 00 00 00       	mov    $0x1,%eax
80103693:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010369a:	e8 c1 0e 00 00       	call   80104560 <scheduler>
8010369f:	90                   	nop

801036a0 <mpenter>:
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036a6:	e8 05 45 00 00       	call   80107bb0 <switchkvm>
  seginit();
801036ab:	e8 70 44 00 00       	call   80107b20 <seginit>
  lapicinit();
801036b0:	e8 9b f7 ff ff       	call   80102e50 <lapicinit>
  mpmain();
801036b5:	e8 a6 ff ff ff       	call   80103660 <mpmain>
801036ba:	66 90                	xchg   %ax,%ax
801036bc:	66 90                	xchg   %ax,%ax
801036be:	66 90                	xchg   %ax,%ax

801036c0 <main>:
{
801036c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036c4:	83 e4 f0             	and    $0xfffffff0,%esp
801036c7:	ff 71 fc             	push   -0x4(%ecx)
801036ca:	55                   	push   %ebp
801036cb:	89 e5                	mov    %esp,%ebp
801036cd:	53                   	push   %ebx
801036ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036cf:	83 ec 08             	sub    $0x8,%esp
801036d2:	68 00 00 40 80       	push   $0x80400000
801036d7:	68 b0 83 11 80       	push   $0x801183b0
801036dc:	e8 8f f5 ff ff       	call   80102c70 <kinit1>
  kvmalloc();      // kernel page table
801036e1:	e8 ba 49 00 00       	call   801080a0 <kvmalloc>
  mpinit();        // detect other processors
801036e6:	e8 85 01 00 00       	call   80103870 <mpinit>
  lapicinit();     // interrupt controller
801036eb:	e8 60 f7 ff ff       	call   80102e50 <lapicinit>
  seginit();       // segment descriptors
801036f0:	e8 2b 44 00 00       	call   80107b20 <seginit>
  picinit();       // disable pic
801036f5:	e8 76 03 00 00       	call   80103a70 <picinit>
  ioapicinit();    // another interrupt controller
801036fa:	e8 31 f3 ff ff       	call   80102a30 <ioapicinit>
  consoleinit();   // console hardware
801036ff:	e8 bc d9 ff ff       	call   801010c0 <consoleinit>
  uartinit();      // serial port
80103704:	e8 a7 36 00 00       	call   80106db0 <uartinit>
  pinit();         // process table
80103709:	e8 82 08 00 00       	call   80103f90 <pinit>
  tvinit();        // trap vectors
8010370e:	e8 cd 32 00 00       	call   801069e0 <tvinit>
  binit();         // buffer cache
80103713:	e8 28 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103718:	e8 53 dd ff ff       	call   80101470 <fileinit>
  ideinit();       // disk 
8010371d:	e8 fe f0 ff ff       	call   80102820 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103722:	83 c4 0c             	add    $0xc,%esp
80103725:	68 8a 00 00 00       	push   $0x8a
8010372a:	68 8c c4 10 80       	push   $0x8010c48c
8010372f:	68 00 70 00 80       	push   $0x80007000
80103734:	e8 d7 1f 00 00       	call   80105710 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	69 05 64 3d 11 80 b0 	imul   $0xb0,0x80113d64,%eax
80103743:	00 00 00 
80103746:	05 80 3d 11 80       	add    $0x80113d80,%eax
8010374b:	3d 80 3d 11 80       	cmp    $0x80113d80,%eax
80103750:	76 7e                	jbe    801037d0 <main+0x110>
80103752:	bb 80 3d 11 80       	mov    $0x80113d80,%ebx
80103757:	eb 20                	jmp    80103779 <main+0xb9>
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103760:	69 05 64 3d 11 80 b0 	imul   $0xb0,0x80113d64,%eax
80103767:	00 00 00 
8010376a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103770:	05 80 3d 11 80       	add    $0x80113d80,%eax
80103775:	39 c3                	cmp    %eax,%ebx
80103777:	73 57                	jae    801037d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103779:	e8 a2 08 00 00       	call   80104020 <mycpu>
8010377e:	39 c3                	cmp    %eax,%ebx
80103780:	74 de                	je     80103760 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103782:	e8 59 f5 ff ff       	call   80102ce0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103787:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010378a:	c7 05 f8 6f 00 80 a0 	movl   $0x801036a0,0x80006ff8
80103791:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103794:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010379b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010379e:	05 00 10 00 00       	add    $0x1000,%eax
801037a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801037a8:	0f b6 03             	movzbl (%ebx),%eax
801037ab:	68 00 70 00 00       	push   $0x7000
801037b0:	50                   	push   %eax
801037b1:	e8 ea f7 ff ff       	call   80102fa0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037c6:	85 c0                	test   %eax,%eax
801037c8:	74 f6                	je     801037c0 <main+0x100>
801037ca:	eb 94                	jmp    80103760 <main+0xa0>
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037d0:	83 ec 08             	sub    $0x8,%esp
801037d3:	68 00 00 00 8e       	push   $0x8e000000
801037d8:	68 00 00 40 80       	push   $0x80400000
801037dd:	e8 2e f4 ff ff       	call   80102c10 <kinit2>
  userinit();      // first user process
801037e2:	e8 e9 08 00 00       	call   801040d0 <userinit>
  mpmain();        // finish this processor's setup
801037e7:	e8 74 fe ff ff       	call   80103660 <mpmain>
801037ec:	66 90                	xchg   %ax,%ax
801037ee:	66 90                	xchg   %ax,%ax

801037f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801037f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801037fb:	53                   	push   %ebx
  e = addr+len;
801037fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801037ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103802:	39 de                	cmp    %ebx,%esi
80103804:	72 10                	jb     80103816 <mpsearch1+0x26>
80103806:	eb 50                	jmp    80103858 <mpsearch1+0x68>
80103808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
80103810:	89 fe                	mov    %edi,%esi
80103812:	39 fb                	cmp    %edi,%ebx
80103814:	76 42                	jbe    80103858 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103816:	83 ec 04             	sub    $0x4,%esp
80103819:	8d 7e 10             	lea    0x10(%esi),%edi
8010381c:	6a 04                	push   $0x4
8010381e:	68 98 8a 10 80       	push   $0x80108a98
80103823:	56                   	push   %esi
80103824:	e8 97 1e 00 00       	call   801056c0 <memcmp>
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	85 c0                	test   %eax,%eax
8010382e:	75 e0                	jne    80103810 <mpsearch1+0x20>
80103830:	89 f2                	mov    %esi,%edx
80103832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103838:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010383b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010383e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103840:	39 fa                	cmp    %edi,%edx
80103842:	75 f4                	jne    80103838 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103844:	84 c0                	test   %al,%al
80103846:	75 c8                	jne    80103810 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103848:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010384b:	89 f0                	mov    %esi,%eax
8010384d:	5b                   	pop    %ebx
8010384e:	5e                   	pop    %esi
8010384f:	5f                   	pop    %edi
80103850:	5d                   	pop    %ebp
80103851:	c3                   	ret    
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103858:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010385b:	31 f6                	xor    %esi,%esi
}
8010385d:	5b                   	pop    %ebx
8010385e:	89 f0                	mov    %esi,%eax
80103860:	5e                   	pop    %esi
80103861:	5f                   	pop    %edi
80103862:	5d                   	pop    %ebp
80103863:	c3                   	ret    
80103864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010386f:	90                   	nop

80103870 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103879:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103880:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103887:	c1 e0 08             	shl    $0x8,%eax
8010388a:	09 d0                	or     %edx,%eax
8010388c:	c1 e0 04             	shl    $0x4,%eax
8010388f:	75 1b                	jne    801038ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103891:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103898:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010389f:	c1 e0 08             	shl    $0x8,%eax
801038a2:	09 d0                	or     %edx,%eax
801038a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038ac:	ba 00 04 00 00       	mov    $0x400,%edx
801038b1:	e8 3a ff ff ff       	call   801037f0 <mpsearch1>
801038b6:	89 c3                	mov    %eax,%ebx
801038b8:	85 c0                	test   %eax,%eax
801038ba:	0f 84 40 01 00 00    	je     80103a00 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038c0:	8b 73 04             	mov    0x4(%ebx),%esi
801038c3:	85 f6                	test   %esi,%esi
801038c5:	0f 84 25 01 00 00    	je     801039f0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801038cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801038d4:	6a 04                	push   $0x4
801038d6:	68 9d 8a 10 80       	push   $0x80108a9d
801038db:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038df:	e8 dc 1d 00 00       	call   801056c0 <memcmp>
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	85 c0                	test   %eax,%eax
801038e9:	0f 85 01 01 00 00    	jne    801039f0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801038ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801038f6:	3c 01                	cmp    $0x1,%al
801038f8:	74 08                	je     80103902 <mpinit+0x92>
801038fa:	3c 04                	cmp    $0x4,%al
801038fc:	0f 85 ee 00 00 00    	jne    801039f0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103902:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103909:	66 85 d2             	test   %dx,%dx
8010390c:	74 22                	je     80103930 <mpinit+0xc0>
8010390e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103911:	89 f0                	mov    %esi,%eax
  sum = 0;
80103913:	31 d2                	xor    %edx,%edx
80103915:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103918:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010391f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103922:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103924:	39 c7                	cmp    %eax,%edi
80103926:	75 f0                	jne    80103918 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103928:	84 d2                	test   %dl,%dl
8010392a:	0f 85 c0 00 00 00    	jne    801039f0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103930:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103936:	a3 60 3c 11 80       	mov    %eax,0x80113c60
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010393b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103942:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103948:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010394d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103950:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103957:	90                   	nop
80103958:	39 d0                	cmp    %edx,%eax
8010395a:	73 15                	jae    80103971 <mpinit+0x101>
    switch(*p){
8010395c:	0f b6 08             	movzbl (%eax),%ecx
8010395f:	80 f9 02             	cmp    $0x2,%cl
80103962:	74 4c                	je     801039b0 <mpinit+0x140>
80103964:	77 3a                	ja     801039a0 <mpinit+0x130>
80103966:	84 c9                	test   %cl,%cl
80103968:	74 56                	je     801039c0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010396a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010396d:	39 d0                	cmp    %edx,%eax
8010396f:	72 eb                	jb     8010395c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103971:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103974:	85 f6                	test   %esi,%esi
80103976:	0f 84 d9 00 00 00    	je     80103a55 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010397c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103980:	74 15                	je     80103997 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103982:	b8 70 00 00 00       	mov    $0x70,%eax
80103987:	ba 22 00 00 00       	mov    $0x22,%edx
8010398c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010398d:	ba 23 00 00 00       	mov    $0x23,%edx
80103992:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103993:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103996:	ee                   	out    %al,(%dx)
  }
}
80103997:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010399a:	5b                   	pop    %ebx
8010399b:	5e                   	pop    %esi
8010399c:	5f                   	pop    %edi
8010399d:	5d                   	pop    %ebp
8010399e:	c3                   	ret    
8010399f:	90                   	nop
    switch(*p){
801039a0:	83 e9 03             	sub    $0x3,%ecx
801039a3:	80 f9 01             	cmp    $0x1,%cl
801039a6:	76 c2                	jbe    8010396a <mpinit+0xfa>
801039a8:	31 f6                	xor    %esi,%esi
801039aa:	eb ac                	jmp    80103958 <mpinit+0xe8>
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801039b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801039b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801039b7:	88 0d 60 3d 11 80    	mov    %cl,0x80113d60
      continue;
801039bd:	eb 99                	jmp    80103958 <mpinit+0xe8>
801039bf:	90                   	nop
      if(ncpu < NCPU) {
801039c0:	8b 0d 64 3d 11 80    	mov    0x80113d64,%ecx
801039c6:	83 f9 07             	cmp    $0x7,%ecx
801039c9:	7f 19                	jg     801039e4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801039d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801039d5:	83 c1 01             	add    $0x1,%ecx
801039d8:	89 0d 64 3d 11 80    	mov    %ecx,0x80113d64
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039de:	88 9f 80 3d 11 80    	mov    %bl,-0x7feec280(%edi)
      p += sizeof(struct mpproc);
801039e4:	83 c0 14             	add    $0x14,%eax
      continue;
801039e7:	e9 6c ff ff ff       	jmp    80103958 <mpinit+0xe8>
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	68 a2 8a 10 80       	push   $0x80108aa2
801039f8:	e8 83 c9 ff ff       	call   80100380 <panic>
801039fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80103a00:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103a05:	eb 13                	jmp    80103a1a <mpinit+0x1aa>
80103a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103a10:	89 f3                	mov    %esi,%ebx
80103a12:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103a18:	74 d6                	je     801039f0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a1a:	83 ec 04             	sub    $0x4,%esp
80103a1d:	8d 73 10             	lea    0x10(%ebx),%esi
80103a20:	6a 04                	push   $0x4
80103a22:	68 98 8a 10 80       	push   $0x80108a98
80103a27:	53                   	push   %ebx
80103a28:	e8 93 1c 00 00       	call   801056c0 <memcmp>
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	85 c0                	test   %eax,%eax
80103a32:	75 dc                	jne    80103a10 <mpinit+0x1a0>
80103a34:	89 da                	mov    %ebx,%edx
80103a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103a40:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103a43:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103a46:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a48:	39 d6                	cmp    %edx,%esi
80103a4a:	75 f4                	jne    80103a40 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a4c:	84 c0                	test   %al,%al
80103a4e:	75 c0                	jne    80103a10 <mpinit+0x1a0>
80103a50:	e9 6b fe ff ff       	jmp    801038c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	68 bc 8a 10 80       	push   $0x80108abc
80103a5d:	e8 1e c9 ff ff       	call   80100380 <panic>
80103a62:	66 90                	xchg   %ax,%ax
80103a64:	66 90                	xchg   %ax,%ax
80103a66:	66 90                	xchg   %ax,%ax
80103a68:	66 90                	xchg   %ax,%ax
80103a6a:	66 90                	xchg   %ax,%ax
80103a6c:	66 90                	xchg   %ax,%ax
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <picinit>:
80103a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a75:	ba 21 00 00 00       	mov    $0x21,%edx
80103a7a:	ee                   	out    %al,(%dx)
80103a7b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a80:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a81:	c3                   	ret    
80103a82:	66 90                	xchg   %ax,%ax
80103a84:	66 90                	xchg   %ax,%ax
80103a86:	66 90                	xchg   %ax,%ax
80103a88:	66 90                	xchg   %ax,%ax
80103a8a:	66 90                	xchg   %ax,%ax
80103a8c:	66 90                	xchg   %ax,%ax
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
80103a95:	53                   	push   %ebx
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103aa5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103aab:	e8 e0 d9 ff ff       	call   80101490 <filealloc>
80103ab0:	89 03                	mov    %eax,(%ebx)
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	0f 84 a8 00 00 00    	je     80103b62 <pipealloc+0xd2>
80103aba:	e8 d1 d9 ff ff       	call   80101490 <filealloc>
80103abf:	89 06                	mov    %eax,(%esi)
80103ac1:	85 c0                	test   %eax,%eax
80103ac3:	0f 84 87 00 00 00    	je     80103b50 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ac9:	e8 12 f2 ff ff       	call   80102ce0 <kalloc>
80103ace:	89 c7                	mov    %eax,%edi
80103ad0:	85 c0                	test   %eax,%eax
80103ad2:	0f 84 b0 00 00 00    	je     80103b88 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103ad8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103adf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ae2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ae5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103aec:	00 00 00 
  p->nwrite = 0;
80103aef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103af6:	00 00 00 
  p->nread = 0;
80103af9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b00:	00 00 00 
  initlock(&p->lock, "pipe");
80103b03:	68 db 8a 10 80       	push   $0x80108adb
80103b08:	50                   	push   %eax
80103b09:	e8 d2 18 00 00       	call   801053e0 <initlock>
  (*f0)->type = FD_PIPE;
80103b0e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b10:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b13:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b19:	8b 03                	mov    (%ebx),%eax
80103b1b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b1f:	8b 03                	mov    (%ebx),%eax
80103b21:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b25:	8b 03                	mov    (%ebx),%eax
80103b27:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b2a:	8b 06                	mov    (%esi),%eax
80103b2c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b32:	8b 06                	mov    (%esi),%eax
80103b34:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b38:	8b 06                	mov    (%esi),%eax
80103b3a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b3e:	8b 06                	mov    (%esi),%eax
80103b40:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b46:	31 c0                	xor    %eax,%eax
}
80103b48:	5b                   	pop    %ebx
80103b49:	5e                   	pop    %esi
80103b4a:	5f                   	pop    %edi
80103b4b:	5d                   	pop    %ebp
80103b4c:	c3                   	ret    
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103b50:	8b 03                	mov    (%ebx),%eax
80103b52:	85 c0                	test   %eax,%eax
80103b54:	74 1e                	je     80103b74 <pipealloc+0xe4>
    fileclose(*f0);
80103b56:	83 ec 0c             	sub    $0xc,%esp
80103b59:	50                   	push   %eax
80103b5a:	e8 f1 d9 ff ff       	call   80101550 <fileclose>
80103b5f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b62:	8b 06                	mov    (%esi),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	74 0c                	je     80103b74 <pipealloc+0xe4>
    fileclose(*f1);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	50                   	push   %eax
80103b6c:	e8 df d9 ff ff       	call   80101550 <fileclose>
80103b71:	83 c4 10             	add    $0x10,%esp
}
80103b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b7c:	5b                   	pop    %ebx
80103b7d:	5e                   	pop    %esi
80103b7e:	5f                   	pop    %edi
80103b7f:	5d                   	pop    %ebp
80103b80:	c3                   	ret    
80103b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b88:	8b 03                	mov    (%ebx),%eax
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	75 c8                	jne    80103b56 <pipealloc+0xc6>
80103b8e:	eb d2                	jmp    80103b62 <pipealloc+0xd2>

80103b90 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
80103b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b98:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b9b:	83 ec 0c             	sub    $0xc,%esp
80103b9e:	53                   	push   %ebx
80103b9f:	e8 0c 1a 00 00       	call   801055b0 <acquire>
  if(writable){
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	85 f6                	test   %esi,%esi
80103ba9:	74 65                	je     80103c10 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bab:	83 ec 0c             	sub    $0xc,%esp
80103bae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103bb4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bbb:	00 00 00 
    wakeup(&p->nread);
80103bbe:	50                   	push   %eax
80103bbf:	e8 ec 0f 00 00       	call   80104bb0 <wakeup>
80103bc4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bc7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bcd:	85 d2                	test   %edx,%edx
80103bcf:	75 0a                	jne    80103bdb <pipeclose+0x4b>
80103bd1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103bd7:	85 c0                	test   %eax,%eax
80103bd9:	74 15                	je     80103bf0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103bdb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be1:	5b                   	pop    %ebx
80103be2:	5e                   	pop    %esi
80103be3:	5d                   	pop    %ebp
    release(&p->lock);
80103be4:	e9 67 19 00 00       	jmp    80105550 <release>
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	53                   	push   %ebx
80103bf4:	e8 57 19 00 00       	call   80105550 <release>
    kfree((char*)p);
80103bf9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103bfc:	83 c4 10             	add    $0x10,%esp
}
80103bff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c02:	5b                   	pop    %ebx
80103c03:	5e                   	pop    %esi
80103c04:	5d                   	pop    %ebp
    kfree((char*)p);
80103c05:	e9 16 ef ff ff       	jmp    80102b20 <kfree>
80103c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103c19:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c20:	00 00 00 
    wakeup(&p->nwrite);
80103c23:	50                   	push   %eax
80103c24:	e8 87 0f 00 00       	call   80104bb0 <wakeup>
80103c29:	83 c4 10             	add    $0x10,%esp
80103c2c:	eb 99                	jmp    80103bc7 <pipeclose+0x37>
80103c2e:	66 90                	xchg   %ax,%ax

80103c30 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 28             	sub    $0x28,%esp
80103c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c3c:	53                   	push   %ebx
80103c3d:	e8 6e 19 00 00       	call   801055b0 <acquire>
  for(i = 0; i < n; i++){
80103c42:	8b 45 10             	mov    0x10(%ebp),%eax
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	0f 8e c0 00 00 00    	jle    80103d10 <pipewrite+0xe0>
80103c50:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c53:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c59:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c62:	03 45 10             	add    0x10(%ebp),%eax
80103c65:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c68:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c6e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c74:	89 ca                	mov    %ecx,%edx
80103c76:	05 00 02 00 00       	add    $0x200,%eax
80103c7b:	39 c1                	cmp    %eax,%ecx
80103c7d:	74 3f                	je     80103cbe <pipewrite+0x8e>
80103c7f:	eb 67                	jmp    80103ce8 <pipewrite+0xb8>
80103c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c88:	e8 13 04 00 00       	call   801040a0 <myproc>
80103c8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c90:	85 c9                	test   %ecx,%ecx
80103c92:	75 34                	jne    80103cc8 <pipewrite+0x98>
      wakeup(&p->nread);
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	57                   	push   %edi
80103c98:	e8 13 0f 00 00       	call   80104bb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c9d:	58                   	pop    %eax
80103c9e:	5a                   	pop    %edx
80103c9f:	53                   	push   %ebx
80103ca0:	56                   	push   %esi
80103ca1:	e8 4a 0e 00 00       	call   80104af0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ca6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	05 00 02 00 00       	add    $0x200,%eax
80103cba:	39 c2                	cmp    %eax,%edx
80103cbc:	75 2a                	jne    80103ce8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103cbe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103cc4:	85 c0                	test   %eax,%eax
80103cc6:	75 c0                	jne    80103c88 <pipewrite+0x58>
        release(&p->lock);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	53                   	push   %ebx
80103ccc:	e8 7f 18 00 00       	call   80105550 <release>
        return -1;
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cdc:	5b                   	pop    %ebx
80103cdd:	5e                   	pop    %esi
80103cde:	5f                   	pop    %edi
80103cdf:	5d                   	pop    %ebp
80103ce0:	c3                   	ret    
80103ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ce8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ceb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103cf4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103cfa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103cfd:	83 c6 01             	add    $0x1,%esi
80103d00:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d03:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d07:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d0a:	0f 85 58 ff ff ff    	jne    80103c68 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d19:	50                   	push   %eax
80103d1a:	e8 91 0e 00 00       	call   80104bb0 <wakeup>
  release(&p->lock);
80103d1f:	89 1c 24             	mov    %ebx,(%esp)
80103d22:	e8 29 18 00 00       	call   80105550 <release>
  return n;
80103d27:	8b 45 10             	mov    0x10(%ebp),%eax
80103d2a:	83 c4 10             	add    $0x10,%esp
80103d2d:	eb aa                	jmp    80103cd9 <pipewrite+0xa9>
80103d2f:	90                   	nop

80103d30 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	57                   	push   %edi
80103d34:	56                   	push   %esi
80103d35:	53                   	push   %ebx
80103d36:	83 ec 18             	sub    $0x18,%esp
80103d39:	8b 75 08             	mov    0x8(%ebp),%esi
80103d3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d3f:	56                   	push   %esi
80103d40:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d46:	e8 65 18 00 00       	call   801055b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d4b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d51:	83 c4 10             	add    $0x10,%esp
80103d54:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103d5a:	74 2f                	je     80103d8b <piperead+0x5b>
80103d5c:	eb 37                	jmp    80103d95 <piperead+0x65>
80103d5e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103d60:	e8 3b 03 00 00       	call   801040a0 <myproc>
80103d65:	8b 48 24             	mov    0x24(%eax),%ecx
80103d68:	85 c9                	test   %ecx,%ecx
80103d6a:	0f 85 80 00 00 00    	jne    80103df0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d70:	83 ec 08             	sub    $0x8,%esp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	e8 76 0d 00 00       	call   80104af0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d7a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d80:	83 c4 10             	add    $0x10,%esp
80103d83:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103d89:	75 0a                	jne    80103d95 <piperead+0x65>
80103d8b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103d91:	85 c0                	test   %eax,%eax
80103d93:	75 cb                	jne    80103d60 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d95:	8b 55 10             	mov    0x10(%ebp),%edx
80103d98:	31 db                	xor    %ebx,%ebx
80103d9a:	85 d2                	test   %edx,%edx
80103d9c:	7f 20                	jg     80103dbe <piperead+0x8e>
80103d9e:	eb 2c                	jmp    80103dcc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103da0:	8d 48 01             	lea    0x1(%eax),%ecx
80103da3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103da8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103dae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103db3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103db6:	83 c3 01             	add    $0x1,%ebx
80103db9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103dbc:	74 0e                	je     80103dcc <piperead+0x9c>
    if(p->nread == p->nwrite)
80103dbe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103dc4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103dca:	75 d4                	jne    80103da0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103dcc:	83 ec 0c             	sub    $0xc,%esp
80103dcf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103dd5:	50                   	push   %eax
80103dd6:	e8 d5 0d 00 00       	call   80104bb0 <wakeup>
  release(&p->lock);
80103ddb:	89 34 24             	mov    %esi,(%esp)
80103dde:	e8 6d 17 00 00       	call   80105550 <release>
  return i;
80103de3:	83 c4 10             	add    $0x10,%esp
}
80103de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de9:	89 d8                	mov    %ebx,%eax
80103deb:	5b                   	pop    %ebx
80103dec:	5e                   	pop    %esi
80103ded:	5f                   	pop    %edi
80103dee:	5d                   	pop    %ebp
80103def:	c3                   	ret    
      release(&p->lock);
80103df0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103df3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103df8:	56                   	push   %esi
80103df9:	e8 52 17 00 00       	call   80105550 <release>
      return -1;
80103dfe:	83 c4 10             	add    $0x10,%esp
}
80103e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e04:	89 d8                	mov    %ebx,%eax
80103e06:	5b                   	pop    %ebx
80103e07:	5e                   	pop    %esi
80103e08:	5f                   	pop    %edi
80103e09:	5d                   	pop    %ebp
80103e0a:	c3                   	ret    
80103e0b:	66 90                	xchg   %ax,%ax
80103e0d:	66 90                	xchg   %ax,%ax
80103e0f:	90                   	nop

80103e10 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e14:	bb 34 43 11 80       	mov    $0x80114334,%ebx
{
80103e19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e1c:	68 00 43 11 80       	push   $0x80114300
80103e21:	e8 8a 17 00 00       	call   801055b0 <acquire>
80103e26:	83 c4 10             	add    $0x10,%esp
80103e29:	eb 17                	jmp    80103e42 <allocproc+0x32>
80103e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e30:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103e36:	81 fb 34 6b 11 80    	cmp    $0x80116b34,%ebx
80103e3c:	0f 84 ce 00 00 00    	je     80103f10 <allocproc+0x100>
    if (p->state == UNUSED)
80103e42:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e45:	85 c0                	test   %eax,%eax
80103e47:	75 e7                	jne    80103e30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e49:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->start_time = ticks / TICKS_PER_SECOND;

  release(&ptable.lock);
80103e4e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e51:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e58:	8d 50 01             	lea    0x1(%eax),%edx
80103e5b:	89 43 10             	mov    %eax,0x10(%ebx)
  p->start_time = ticks / TICKS_PER_SECOND;
80103e5e:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  p->pid = nextpid++;
80103e63:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  p->start_time = ticks / TICKS_PER_SECOND;
80103e69:	f7 25 40 6b 11 80    	mull   0x80116b40
80103e6f:	c1 ea 05             	shr    $0x5,%edx
80103e72:	89 53 7c             	mov    %edx,0x7c(%ebx)
  release(&ptable.lock);
80103e75:	68 00 43 11 80       	push   $0x80114300
80103e7a:	e8 d1 16 00 00       	call   80105550 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103e7f:	e8 5c ee ff ff       	call   80102ce0 <kalloc>
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	89 43 08             	mov    %eax,0x8(%ebx)
80103e8a:	85 c0                	test   %eax,%eax
80103e8c:	0f 84 97 00 00 00    	je     80103f29 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e92:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103e98:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e9b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ea0:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103ea3:	c7 40 14 cc 69 10 80 	movl   $0x801069cc,0x14(%eax)
  p->context = (struct context *)sp;
80103eaa:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ead:	6a 14                	push   $0x14
80103eaf:	6a 00                	push   $0x0
80103eb1:	50                   	push   %eax
80103eb2:	e8 b9 17 00 00       	call   80105670 <memset>
  p->context->eip = (uint)forkret;
80103eb7:	8b 43 1c             	mov    0x1c(%ebx),%eax

  memset(&p->sched_info, 0, sizeof(p->sched_info));
80103eba:	83 c4 0c             	add    $0xc,%esp
  p->context->eip = (uint)forkret;
80103ebd:	c7 40 10 40 3f 10 80 	movl   $0x80103f40,0x10(%eax)
  memset(&p->sched_info, 0, sizeof(p->sched_info));
80103ec4:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103eca:	6a 18                	push   $0x18
80103ecc:	6a 00                	push   $0x0
80103ece:	50                   	push   %eax
80103ecf:	e8 9c 17 00 00       	call   80105670 <memset>

  p->sched_info.queue = 2;
  p->sched_info.arrival_time = ticks;
80103ed4:	a1 40 6b 11 80       	mov    0x80116b40,%eax
  p->sched_info.last_execution_time = 0;
  p->sched_info.burst_time = INITIAL_BURST_TIME;
  return p;
80103ed9:	83 c4 10             	add    $0x10,%esp
  p->sched_info.queue = 2;
80103edc:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
80103ee3:	00 00 00 
  p->sched_info.last_execution_time = 0;
80103ee6:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103eed:	00 00 00 
  p->sched_info.arrival_time = ticks;
80103ef0:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
}
80103ef6:	89 d8                	mov    %ebx,%eax
  p->sched_info.burst_time = INITIAL_BURST_TIME;
80103ef8:	c7 83 90 00 00 00 05 	movl   $0x5,0x90(%ebx)
80103eff:	00 00 00 
}
80103f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f05:	c9                   	leave  
80103f06:	c3                   	ret    
80103f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f15:	68 00 43 11 80       	push   $0x80114300
80103f1a:	e8 31 16 00 00       	call   80105550 <release>
}
80103f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103f21:	83 c4 10             	add    $0x10,%esp
}
80103f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f27:	c9                   	leave  
80103f28:	c3                   	ret    
    p->state = UNUSED;
80103f29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f30:	31 db                	xor    %ebx,%ebx
}
80103f32:	89 d8                	mov    %ebx,%eax
80103f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f37:	c9                   	leave  
80103f38:	c3                   	ret    
80103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f40 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f46:	68 00 43 11 80       	push   $0x80114300
80103f4b:	e8 00 16 00 00       	call   80105550 <release>

  if (first)
80103f50:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	85 c0                	test   %eax,%eax
80103f5a:	75 04                	jne    80103f60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f5c:	c9                   	leave  
80103f5d:	c3                   	ret    
80103f5e:	66 90                	xchg   %ax,%ax
    first = 0;
80103f60:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103f67:	00 00 00 
    iinit(ROOTDEV);
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	6a 01                	push   $0x1
80103f6f:	e8 4c dc ff ff       	call   80101bc0 <iinit>
    initlog(ROOTDEV);
80103f74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f7b:	e8 a0 f3 ff ff       	call   80103320 <initlog>
}
80103f80:	83 c4 10             	add    $0x10,%esp
80103f83:	c9                   	leave  
80103f84:	c3                   	ret    
80103f85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f90 <pinit>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f96:	68 e0 8a 10 80       	push   $0x80108ae0
80103f9b:	68 00 43 11 80       	push   $0x80114300
80103fa0:	e8 3b 14 00 00       	call   801053e0 <initlock>
}
80103fa5:	83 c4 10             	add    $0x10,%esp
80103fa8:	c9                   	leave  
80103fa9:	c3                   	ret    
80103faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fb0 <printspaces>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	8b 75 08             	mov    0x8(%ebp),%esi
80103fb7:	53                   	push   %ebx
  for(int i = 0; i < count; ++i)
80103fb8:	85 f6                	test   %esi,%esi
80103fba:	7e 1b                	jle    80103fd7 <printspaces+0x27>
80103fbc:	31 db                	xor    %ebx,%ebx
80103fbe:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80103fc0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80103fc3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80103fc6:	68 d5 8b 10 80       	push   $0x80108bd5
80103fcb:	e8 d0 c6 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80103fd0:	83 c4 10             	add    $0x10,%esp
80103fd3:	39 de                	cmp    %ebx,%esi
80103fd5:	75 e9                	jne    80103fc0 <printspaces+0x10>
}
80103fd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fda:	5b                   	pop    %ebx
80103fdb:	5e                   	pop    %esi
80103fdc:	5d                   	pop    %ebp
80103fdd:	c3                   	ret    
80103fde:	66 90                	xchg   %ax,%ax

80103fe0 <digitcount>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103fe7:	53                   	push   %ebx
80103fe8:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(num == 0) return 1;
80103fed:	85 c9                	test   %ecx,%ecx
80103fef:	74 24                	je     80104015 <digitcount+0x35>
  int count = 0;
80103ff1:	31 db                	xor    %ebx,%ebx
    num /= 10;
80103ff3:	be 67 66 66 66       	mov    $0x66666667,%esi
80103ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fff:	90                   	nop
80104000:	89 c8                	mov    %ecx,%eax
    ++count;
80104002:	83 c3 01             	add    $0x1,%ebx
    num /= 10;
80104005:	f7 ee                	imul   %esi
80104007:	89 c8                	mov    %ecx,%eax
80104009:	c1 f8 1f             	sar    $0x1f,%eax
8010400c:	c1 fa 02             	sar    $0x2,%edx
  while(num){
8010400f:	89 d1                	mov    %edx,%ecx
80104011:	29 c1                	sub    %eax,%ecx
80104013:	75 eb                	jne    80104000 <digitcount+0x20>
}
80104015:	89 d8                	mov    %ebx,%eax
80104017:	5b                   	pop    %ebx
80104018:	5e                   	pop    %esi
80104019:	5d                   	pop    %ebp
8010401a:	c3                   	ret    
8010401b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010401f:	90                   	nop

80104020 <mycpu>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104025:	9c                   	pushf  
80104026:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104027:	f6 c4 02             	test   $0x2,%ah
8010402a:	75 46                	jne    80104072 <mycpu+0x52>
  apicid = lapicid();
8010402c:	e8 1f ef ff ff       	call   80102f50 <lapicid>
  for (i = 0; i < ncpu; ++i)
80104031:	8b 35 64 3d 11 80    	mov    0x80113d64,%esi
80104037:	85 f6                	test   %esi,%esi
80104039:	7e 2a                	jle    80104065 <mycpu+0x45>
8010403b:	31 d2                	xor    %edx,%edx
8010403d:	eb 08                	jmp    80104047 <mycpu+0x27>
8010403f:	90                   	nop
80104040:	83 c2 01             	add    $0x1,%edx
80104043:	39 f2                	cmp    %esi,%edx
80104045:	74 1e                	je     80104065 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104047:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010404d:	0f b6 99 80 3d 11 80 	movzbl -0x7feec280(%ecx),%ebx
80104054:	39 c3                	cmp    %eax,%ebx
80104056:	75 e8                	jne    80104040 <mycpu+0x20>
}
80104058:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010405b:	8d 81 80 3d 11 80    	lea    -0x7feec280(%ecx),%eax
}
80104061:	5b                   	pop    %ebx
80104062:	5e                   	pop    %esi
80104063:	5d                   	pop    %ebp
80104064:	c3                   	ret    
  panic("unknown apicid\n");
80104065:	83 ec 0c             	sub    $0xc,%esp
80104068:	68 e7 8a 10 80       	push   $0x80108ae7
8010406d:	e8 0e c3 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104072:	83 ec 0c             	sub    $0xc,%esp
80104075:	68 d8 8b 10 80       	push   $0x80108bd8
8010407a:	e8 01 c3 ff ff       	call   80100380 <panic>
8010407f:	90                   	nop

80104080 <cpuid>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80104086:	e8 95 ff ff ff       	call   80104020 <mycpu>
}
8010408b:	c9                   	leave  
  return mycpu() - cpus;
8010408c:	2d 80 3d 11 80       	sub    $0x80113d80,%eax
80104091:	c1 f8 04             	sar    $0x4,%eax
80104094:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010409a:	c3                   	ret    
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop

801040a0 <myproc>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801040a7:	e8 b4 13 00 00       	call   80105460 <pushcli>
  c = mycpu();
801040ac:	e8 6f ff ff ff       	call   80104020 <mycpu>
  p = c->proc;
801040b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040b7:	e8 f4 13 00 00       	call   801054b0 <popcli>
}
801040bc:	89 d8                	mov    %ebx,%eax
801040be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c1:	c9                   	leave  
801040c2:	c3                   	ret    
801040c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040d0 <userinit>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801040d7:	e8 34 fd ff ff       	call   80103e10 <allocproc>
801040dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801040de:	a3 3c 6b 11 80       	mov    %eax,0x80116b3c
  if ((p->pgdir = setupkvm()) == 0)
801040e3:	e8 38 3f 00 00       	call   80108020 <setupkvm>
801040e8:	89 43 04             	mov    %eax,0x4(%ebx)
801040eb:	85 c0                	test   %eax,%eax
801040ed:	0f 84 c7 00 00 00    	je     801041ba <userinit+0xea>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801040f3:	83 ec 04             	sub    $0x4,%esp
801040f6:	68 2c 00 00 00       	push   $0x2c
801040fb:	68 60 c4 10 80       	push   $0x8010c460
80104100:	50                   	push   %eax
80104101:	e8 ca 3b 00 00       	call   80107cd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104106:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104109:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010410f:	6a 4c                	push   $0x4c
80104111:	6a 00                	push   $0x0
80104113:	ff 73 18             	push   0x18(%ebx)
80104116:	e8 55 15 00 00       	call   80105670 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010411b:	8b 43 18             	mov    0x18(%ebx),%eax
8010411e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104123:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104126:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010412b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010412f:	8b 43 18             	mov    0x18(%ebx),%eax
80104132:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104136:	8b 43 18             	mov    0x18(%ebx),%eax
80104139:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010413d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104141:	8b 43 18             	mov    0x18(%ebx),%eax
80104144:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104148:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010414c:	8b 43 18             	mov    0x18(%ebx),%eax
8010414f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104156:	8b 43 18             	mov    0x18(%ebx),%eax
80104159:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80104160:	8b 43 18             	mov    0x18(%ebx),%eax
80104163:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010416a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010416d:	6a 10                	push   $0x10
8010416f:	68 10 8b 10 80       	push   $0x80108b10
80104174:	50                   	push   %eax
80104175:	e8 b6 16 00 00       	call   80105830 <safestrcpy>
  p->cwd = namei("/");
8010417a:	c7 04 24 19 8b 10 80 	movl   $0x80108b19,(%esp)
80104181:	e8 7a e5 ff ff       	call   80102700 <namei>
80104186:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104189:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104190:	e8 1b 14 00 00       	call   801055b0 <acquire>
  p->state = RUNNABLE;
80104195:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->sched_info.queue = RR;
8010419c:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
801041a3:	00 00 00 
  release(&ptable.lock);
801041a6:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
801041ad:	e8 9e 13 00 00       	call   80105550 <release>
}
801041b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b5:	83 c4 10             	add    $0x10,%esp
801041b8:	c9                   	leave  
801041b9:	c3                   	ret    
    panic("userinit: out of memory?");
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 f7 8a 10 80       	push   $0x80108af7
801041c2:	e8 b9 c1 ff ff       	call   80100380 <panic>
801041c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ce:	66 90                	xchg   %ax,%ax

801041d0 <growproc>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	56                   	push   %esi
801041d4:	53                   	push   %ebx
801041d5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801041d8:	e8 83 12 00 00       	call   80105460 <pushcli>
  c = mycpu();
801041dd:	e8 3e fe ff ff       	call   80104020 <mycpu>
  p = c->proc;
801041e2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e8:	e8 c3 12 00 00       	call   801054b0 <popcli>
  sz = curproc->sz;
801041ed:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801041ef:	85 f6                	test   %esi,%esi
801041f1:	7f 1d                	jg     80104210 <growproc+0x40>
  else if (n < 0)
801041f3:	75 3b                	jne    80104230 <growproc+0x60>
  switchuvm(curproc);
801041f5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801041f8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801041fa:	53                   	push   %ebx
801041fb:	e8 c0 39 00 00       	call   80107bc0 <switchuvm>
  return 0;
80104200:	83 c4 10             	add    $0x10,%esp
80104203:	31 c0                	xor    %eax,%eax
}
80104205:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104208:	5b                   	pop    %ebx
80104209:	5e                   	pop    %esi
8010420a:	5d                   	pop    %ebp
8010420b:	c3                   	ret    
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104210:	83 ec 04             	sub    $0x4,%esp
80104213:	01 c6                	add    %eax,%esi
80104215:	56                   	push   %esi
80104216:	50                   	push   %eax
80104217:	ff 73 04             	push   0x4(%ebx)
8010421a:	e8 21 3c 00 00       	call   80107e40 <allocuvm>
8010421f:	83 c4 10             	add    $0x10,%esp
80104222:	85 c0                	test   %eax,%eax
80104224:	75 cf                	jne    801041f5 <growproc+0x25>
      return -1;
80104226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010422b:	eb d8                	jmp    80104205 <growproc+0x35>
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104230:	83 ec 04             	sub    $0x4,%esp
80104233:	01 c6                	add    %eax,%esi
80104235:	56                   	push   %esi
80104236:	50                   	push   %eax
80104237:	ff 73 04             	push   0x4(%ebx)
8010423a:	e8 31 3d 00 00       	call   80107f70 <deallocuvm>
8010423f:	83 c4 10             	add    $0x10,%esp
80104242:	85 c0                	test   %eax,%eax
80104244:	75 af                	jne    801041f5 <growproc+0x25>
80104246:	eb de                	jmp    80104226 <growproc+0x56>
80104248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop

80104250 <fork>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104259:	e8 02 12 00 00       	call   80105460 <pushcli>
  c = mycpu();
8010425e:	e8 bd fd ff ff       	call   80104020 <mycpu>
  p = c->proc;
80104263:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104269:	e8 42 12 00 00       	call   801054b0 <popcli>
  if ((np = allocproc()) == 0)
8010426e:	e8 9d fb ff ff       	call   80103e10 <allocproc>
80104273:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104276:	85 c0                	test   %eax,%eax
80104278:	0f 84 b7 00 00 00    	je     80104335 <fork+0xe5>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
8010427e:	83 ec 08             	sub    $0x8,%esp
80104281:	ff 33                	push   (%ebx)
80104283:	89 c7                	mov    %eax,%edi
80104285:	ff 73 04             	push   0x4(%ebx)
80104288:	e8 83 3e 00 00       	call   80108110 <copyuvm>
8010428d:	83 c4 10             	add    $0x10,%esp
80104290:	89 47 04             	mov    %eax,0x4(%edi)
80104293:	85 c0                	test   %eax,%eax
80104295:	0f 84 a1 00 00 00    	je     8010433c <fork+0xec>
  np->sz = curproc->sz;
8010429b:	8b 03                	mov    (%ebx),%eax
8010429d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801042a0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801042a2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801042a5:	89 c8                	mov    %ecx,%eax
801042a7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801042aa:	b9 13 00 00 00       	mov    $0x13,%ecx
801042af:	8b 73 18             	mov    0x18(%ebx),%esi
801042b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
801042b4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801042b6:	8b 40 18             	mov    0x18(%eax),%eax
801042b9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
801042c0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801042c4:	85 c0                	test   %eax,%eax
801042c6:	74 13                	je     801042db <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	50                   	push   %eax
801042cc:	e8 2f d2 ff ff       	call   80101500 <filedup>
801042d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042d4:	83 c4 10             	add    $0x10,%esp
801042d7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801042db:	83 c6 01             	add    $0x1,%esi
801042de:	83 fe 10             	cmp    $0x10,%esi
801042e1:	75 dd                	jne    801042c0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042e9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801042ec:	e8 bf da ff ff       	call   80101db0 <idup>
801042f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042f4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801042f7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042fa:	8d 47 6c             	lea    0x6c(%edi),%eax
801042fd:	6a 10                	push   $0x10
801042ff:	53                   	push   %ebx
80104300:	50                   	push   %eax
80104301:	e8 2a 15 00 00       	call   80105830 <safestrcpy>
  pid = np->pid;
80104306:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104309:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104310:	e8 9b 12 00 00       	call   801055b0 <acquire>
  np->state = RUNNABLE;
80104315:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010431c:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104323:	e8 28 12 00 00       	call   80105550 <release>
  return pid;
80104328:	83 c4 10             	add    $0x10,%esp
}
8010432b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010432e:	89 d8                	mov    %ebx,%eax
80104330:	5b                   	pop    %ebx
80104331:	5e                   	pop    %esi
80104332:	5f                   	pop    %edi
80104333:	5d                   	pop    %ebp
80104334:	c3                   	ret    
    return -1;
80104335:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010433a:	eb ef                	jmp    8010432b <fork+0xdb>
    kfree(np->kstack);
8010433c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	ff 73 08             	push   0x8(%ebx)
80104345:	e8 d6 e7 ff ff       	call   80102b20 <kfree>
    np->kstack = 0;
8010434a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104351:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104354:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010435b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104360:	eb c9                	jmp    8010432b <fork+0xdb>
80104362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104370 <change_queue>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	8b 45 08             	mov    0x8(%ebp),%eax
  p->sched_info.queue = new_queue;
80104376:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  enum scheduling_queue old_queue = p->sched_info.queue;
80104379:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
  p->sched_info.queue = new_queue;
8010437f:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
  p->sched_info.last_run = ticks;
80104385:	8b 0d 40 6b 11 80    	mov    0x80116b40,%ecx
8010438b:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
}
80104391:	89 d0                	mov    %edx,%eax
80104393:	5d                   	pop    %ebp
80104394:	c3                   	ret    
80104395:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043a0 <age_processes>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801043a6:	68 00 43 11 80       	push   $0x80114300
801043ab:	e8 00 12 00 00       	call   801055b0 <acquire>
    if (ticks - p->sched_info.last_run > AGING_THRESHOLD)
801043b0:	8b 0d 40 6b 11 80    	mov    0x80116b40,%ecx
  p->sched_info.last_run = ticks;
801043b6:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b9:	b8 34 43 11 80       	mov    $0x80114334,%eax
801043be:	66 90                	xchg   %ax,%ax
    if (p->state != RUNNABLE || p->sched_info.queue == RR)
801043c0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043c4:	75 29                	jne    801043ef <age_processes+0x4f>
801043c6:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
801043cd:	74 20                	je     801043ef <age_processes+0x4f>
    if (ticks - p->sched_info.last_run > AGING_THRESHOLD)
801043cf:	89 ca                	mov    %ecx,%edx
801043d1:	2b 90 84 00 00 00    	sub    0x84(%eax),%edx
801043d7:	81 fa 40 1f 00 00    	cmp    $0x1f40,%edx
801043dd:	76 10                	jbe    801043ef <age_processes+0x4f>
  p->sched_info.queue = new_queue;
801043df:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
801043e6:	00 00 00 
  p->sched_info.last_run = ticks;
801043e9:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ef:	05 a0 00 00 00       	add    $0xa0,%eax
801043f4:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
801043f9:	75 c5                	jne    801043c0 <age_processes+0x20>
  release(&ptable.lock);
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	68 00 43 11 80       	push   $0x80114300
80104403:	e8 48 11 00 00       	call   80105550 <release>
}
80104408:	83 c4 10             	add    $0x10,%esp
8010440b:	c9                   	leave  
8010440c:	c3                   	ret    
8010440d:	8d 76 00             	lea    0x0(%esi),%esi

80104410 <find_next_round_robin>:
{
80104410:	55                   	push   %ebp
      p = ptable.proc;
80104411:	b9 34 43 11 80       	mov    $0x80114334,%ecx
{
80104416:	89 e5                	mov    %esp,%ebp
80104418:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p = last_scheduled;
8010441b:	89 d0                	mov    %edx,%eax
8010441d:	eb 05                	jmp    80104424 <find_next_round_robin+0x14>
8010441f:	90                   	nop
  } while (p != last_scheduled);
80104420:	39 d0                	cmp    %edx,%eax
80104422:	74 24                	je     80104448 <find_next_round_robin+0x38>
    p++;
80104424:	05 a0 00 00 00       	add    $0xa0,%eax
      p = ptable.proc;
80104429:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
8010442e:	0f 44 c1             	cmove  %ecx,%eax
    if (p->state == RUNNABLE && p->sched_info.queue == RR)
80104431:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104435:	75 e9                	jne    80104420 <find_next_round_robin+0x10>
80104437:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
8010443e:	75 e0                	jne    80104420 <find_next_round_robin+0x10>
}
80104440:	5d                   	pop    %ebp
80104441:	c3                   	ret    
80104442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return 0;
80104448:	31 c0                	xor    %eax,%eax
}
8010444a:	5d                   	pop    %ebp
8010444b:	c3                   	ret    
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <find_next_fcfs>:
{
80104450:	55                   	push   %ebp
  int mn = 2e9;
80104451:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104456:	b8 34 43 11 80       	mov    $0x80114334,%eax
{
8010445b:	89 e5                	mov    %esp,%ebp
8010445d:	53                   	push   %ebx
  struct proc *first_proc = 0;
8010445e:	31 db                	xor    %ebx,%ebx
    if (p->state != RUNNABLE || p->sched_info.queue != FCFS)
80104460:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104464:	75 1a                	jne    80104480 <find_next_fcfs+0x30>
80104466:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
8010446d:	75 11                	jne    80104480 <find_next_fcfs+0x30>
    if (p->sched_info.arrival_time < mn)
8010446f:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104475:	39 ca                	cmp    %ecx,%edx
80104477:	7d 07                	jge    80104480 <find_next_fcfs+0x30>
80104479:	89 d1                	mov    %edx,%ecx
8010447b:	89 c3                	mov    %eax,%ebx
8010447d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104480:	05 a0 00 00 00       	add    $0xa0,%eax
80104485:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
8010448a:	75 d4                	jne    80104460 <find_next_fcfs+0x10>
}
8010448c:	89 d8                	mov    %ebx,%eax
8010448e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104491:	c9                   	leave  
80104492:	c3                   	ret    
80104493:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <find_next_sjf>:
{
801044a0:	d9 05 b8 8c 10 80    	flds   0x80108cb8
  struct proc *shortest_job_process = 0;
801044a6:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044a8:	b8 34 43 11 80       	mov    $0x80114334,%eax
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->sched_info.queue != SJF)
801044b0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801044b4:	75 32                	jne    801044e8 <find_next_sjf+0x48>
801044b6:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
801044bd:	75 29                	jne    801044e8 <find_next_sjf+0x48>
    float current_job_rank = p->sched_info.burst_time;
801044bf:	db 80 90 00 00 00    	fildl  0x90(%eax)
    if (shortest_job_process == 0 || current_job_rank < shortest_job_rank)
801044c5:	85 d2                	test   %edx,%edx
801044c7:	74 0f                	je     801044d8 <find_next_sjf+0x38>
801044c9:	d9 c9                	fxch   %st(1)
801044cb:	db f1                	fcomi  %st(1),%st
801044cd:	76 11                	jbe    801044e0 <find_next_sjf+0x40>
801044cf:	dd d8                	fstp   %st(0)
801044d1:	eb 07                	jmp    801044da <find_next_sjf+0x3a>
801044d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d7:	90                   	nop
801044d8:	dd d9                	fstp   %st(1)
801044da:	89 c2                	mov    %eax,%edx
801044dc:	eb 0a                	jmp    801044e8 <find_next_sjf+0x48>
801044de:	66 90                	xchg   %ax,%ax
801044e0:	dd d9                	fstp   %st(1)
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e8:	05 a0 00 00 00       	add    $0xa0,%eax
801044ed:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
801044f2:	75 bc                	jne    801044b0 <find_next_sjf+0x10>
801044f4:	dd d8                	fstp   %st(0)
}
801044f6:	89 d0                	mov    %edx,%eax
801044f8:	c3                   	ret    
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104500 <find_fair_period>:
  int size_of_queue = 0;
80104500:	31 c9                	xor    %ecx,%ecx
  for (prc = ptable.proc; prc < &ptable.proc[NPROC]; prc++)
80104502:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450e:	66 90                	xchg   %ax,%ax
    if (prc->state == RUNNABLE && prc->sched_info.queue == CFS)
80104510:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104514:	75 0e                	jne    80104524 <find_fair_period+0x24>
      size_of_queue++;
80104516:	31 d2                	xor    %edx,%edx
80104518:	83 b8 80 00 00 00 04 	cmpl   $0x4,0x80(%eax)
8010451f:	0f 94 c2             	sete   %dl
80104522:	01 d1                	add    %edx,%ecx
  for (prc = ptable.proc; prc < &ptable.proc[NPROC]; prc++)
80104524:	05 a0 00 00 00       	add    $0xa0,%eax
80104529:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
8010452e:	75 e0                	jne    80104510 <find_fair_period+0x10>
  if (size_of_queue == 0)
80104530:	85 c9                	test   %ecx,%ecx
80104532:	74 0e                	je     80104542 <find_fair_period+0x42>
  fair_period = PERIOD / size_of_queue;
80104534:	b8 64 00 00 00       	mov    $0x64,%eax
80104539:	99                   	cltd   
8010453a:	f7 f9                	idiv   %ecx
8010453c:	a3 38 6b 11 80       	mov    %eax,0x80116b38
}
80104541:	c3                   	ret    
    return 0;
80104542:	31 c0                	xor    %eax,%eax
80104544:	c3                   	ret    
80104545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <find_next_cfs>:
}
80104550:	31 c0                	xor    %eax,%eax
80104552:	c3                   	ret    
80104553:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <scheduler>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
  struct proc *last_rr_scheduled = &ptable.proc[NPROC - 1];
80104565:	be 94 6a 11 80       	mov    $0x80116a94,%esi
{
8010456a:	53                   	push   %ebx
8010456b:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
8010456e:	e8 ad fa ff ff       	call   80104020 <mycpu>
  int now = ticks;
80104573:	8b 3d 40 6b 11 80    	mov    0x80116b40,%edi
  struct proc *last_cfs_scheduled = &ptable.proc[NPROC - 1];
80104579:	c7 45 d8 94 6a 11 80 	movl   $0x80116a94,-0x28(%ebp)
  c->proc = 0;
80104580:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104587:	00 00 00 
  struct cpu *c = mycpu();
8010458a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int now = ticks;
8010458d:	83 c0 04             	add    $0x4,%eax
80104590:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104593:	89 7d d4             	mov    %edi,-0x2c(%ebp)
      p = ptable.proc;
80104596:	bf 34 43 11 80       	mov    $0x80114334,%edi
8010459b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop
  asm volatile("sti");
801045a0:	fb                   	sti    
    acquire(&ptable.lock);
801045a1:	83 ec 0c             	sub    $0xc,%esp
801045a4:	89 f3                	mov    %esi,%ebx
801045a6:	68 00 43 11 80       	push   $0x80114300
801045ab:	e8 00 10 00 00       	call   801055b0 <acquire>
801045b0:	83 c4 10             	add    $0x10,%esp
801045b3:	eb 0b                	jmp    801045c0 <scheduler+0x60>
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
  } while (p != last_scheduled);
801045b8:	39 de                	cmp    %ebx,%esi
801045ba:	0f 84 80 00 00 00    	je     80104640 <scheduler+0xe0>
    p++;
801045c0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      p = ptable.proc;
801045c6:	81 fb 34 6b 11 80    	cmp    $0x80116b34,%ebx
801045cc:	0f 44 df             	cmove  %edi,%ebx
    if (p->state == RUNNABLE && p->sched_info.queue == RR)
801045cf:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801045d3:	75 e3                	jne    801045b8 <scheduler+0x58>
801045d5:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
801045dc:	75 da                	jne    801045b8 <scheduler+0x58>
801045de:	89 de                	mov    %ebx,%esi
    c->proc = p;
801045e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    switchuvm(p);
801045e3:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
801045e6:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
    switchuvm(p);
801045ec:	53                   	push   %ebx
801045ed:	e8 ce 35 00 00       	call   80107bc0 <switchuvm>
    p->sched_info.executed_cycles += 0.1f;
801045f2:	d9 05 bc 8c 10 80    	flds   0x80108cbc
801045f8:	d8 83 88 00 00 00    	fadds  0x88(%ebx)
    p->state = RUNNING;
801045fe:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    p->sched_info.executed_cycles += 0.1f;
80104605:	d9 9b 88 00 00 00    	fstps  0x88(%ebx)
    swtch(&(c->scheduler), p->context);
8010460b:	58                   	pop    %eax
8010460c:	5a                   	pop    %edx
8010460d:	ff 73 1c             	push   0x1c(%ebx)
80104610:	ff 75 dc             	push   -0x24(%ebp)
80104613:	e8 73 12 00 00       	call   8010588b <swtch>
    switchkvm();
80104618:	e8 93 35 00 00       	call   80107bb0 <switchkvm>
    c->proc = 0;
8010461d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104620:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104627:	00 00 00 
    release(&ptable.lock);
8010462a:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104631:	e8 1a 0f 00 00       	call   80105550 <release>
80104636:	83 c4 10             	add    $0x10,%esp
80104639:	e9 62 ff ff ff       	jmp    801045a0 <scheduler+0x40>
8010463e:	66 90                	xchg   %ax,%ax
  struct proc *first_proc = 0;
80104640:	31 db                	xor    %ebx,%ebx
  int mn = 2e9;
80104642:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104647:	b8 34 43 11 80       	mov    $0x80114334,%eax
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->sched_info.queue != FCFS)
80104650:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104654:	75 1a                	jne    80104670 <scheduler+0x110>
80104656:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
8010465d:	75 11                	jne    80104670 <scheduler+0x110>
    if (p->sched_info.arrival_time < mn)
8010465f:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104665:	39 ca                	cmp    %ecx,%edx
80104667:	7d 07                	jge    80104670 <scheduler+0x110>
80104669:	89 d1                	mov    %edx,%ecx
8010466b:	89 c3                	mov    %eax,%ebx
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104670:	05 a0 00 00 00       	add    $0xa0,%eax
80104675:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
8010467a:	75 d4                	jne    80104650 <scheduler+0xf0>
      if (!p)
8010467c:	85 db                	test   %ebx,%ebx
8010467e:	0f 85 5c ff ff ff    	jne    801045e0 <scheduler+0x80>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104684:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->sched_info.queue != SJF)
80104690:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104694:	75 32                	jne    801046c8 <scheduler+0x168>
80104696:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
8010469d:	75 29                	jne    801046c8 <scheduler+0x168>
    float current_job_rank = p->sched_info.burst_time;
8010469f:	db 80 90 00 00 00    	fildl  0x90(%eax)
    if (shortest_job_process == 0 || current_job_rank < shortest_job_rank)
801046a5:	85 db                	test   %ebx,%ebx
801046a7:	74 07                	je     801046b0 <scheduler+0x150>
801046a9:	d9 45 e4             	flds   -0x1c(%ebp)
801046ac:	df f1                	fcomip %st(1),%st
801046ae:	76 10                	jbe    801046c0 <scheduler+0x160>
      shortest_job_rank = current_job_rank;
801046b0:	d9 5d e4             	fstps  -0x1c(%ebp)
801046b3:	89 c3                	mov    %eax,%ebx
801046b5:	eb 11                	jmp    801046c8 <scheduler+0x168>
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
801046c0:	dd d8                	fstp   %st(0)
801046c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c8:	05 a0 00 00 00       	add    $0xa0,%eax
801046cd:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
801046d2:	75 bc                	jne    80104690 <scheduler+0x130>
        if (!p)
801046d4:	85 db                	test   %ebx,%ebx
801046d6:	0f 85 04 ff ff ff    	jne    801045e0 <scheduler+0x80>
          if (now - last_cfs_scheduled->sched_info.last_execution_time >= fair_period)
801046dc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801046df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801046e2:	2b 81 94 00 00 00    	sub    0x94(%ecx),%eax
801046e8:	3b 05 38 6b 11 80    	cmp    0x80116b38,%eax
801046ee:	7c 56                	jl     80104746 <scheduler+0x1e6>
  int size_of_queue = 0;
801046f0:	31 c9                	xor    %ecx,%ecx
  for (prc = ptable.proc; prc < &ptable.proc[NPROC]; prc++)
801046f2:	b8 34 43 11 80       	mov    $0x80114334,%eax
801046f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fe:	66 90                	xchg   %ax,%ax
    if (prc->state == RUNNABLE && prc->sched_info.queue == CFS)
80104700:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104704:	75 0e                	jne    80104714 <scheduler+0x1b4>
      size_of_queue++;
80104706:	31 d2                	xor    %edx,%edx
80104708:	83 b8 80 00 00 00 04 	cmpl   $0x4,0x80(%eax)
8010470f:	0f 94 c2             	sete   %dl
80104712:	01 d1                	add    %edx,%ecx
  for (prc = ptable.proc; prc < &ptable.proc[NPROC]; prc++)
80104714:	05 a0 00 00 00       	add    $0xa0,%eax
80104719:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
8010471e:	75 e0                	jne    80104700 <scheduler+0x1a0>
  if (size_of_queue == 0)
80104720:	85 c9                	test   %ecx,%ecx
80104722:	74 0d                	je     80104731 <scheduler+0x1d1>
  fair_period = PERIOD / size_of_queue;
80104724:	b8 64 00 00 00       	mov    $0x64,%eax
80104729:	99                   	cltd   
8010472a:	f7 f9                	idiv   %ecx
8010472c:	a3 38 6b 11 80       	mov    %eax,0x80116b38
            release(&ptable.lock);
80104731:	83 ec 0c             	sub    $0xc,%esp
80104734:	68 00 43 11 80       	push   $0x80114300
80104739:	e8 12 0e 00 00       	call   80105550 <release>
            continue;
8010473e:	83 c4 10             	add    $0x10,%esp
80104741:	e9 5a fe ff ff       	jmp    801045a0 <scheduler+0x40>
            p = myproc(); // Not Sure
80104746:	e8 55 f9 ff ff       	call   801040a0 <myproc>
8010474b:	89 c3                	mov    %eax,%ebx
          if (p)
8010474d:	85 c0                	test   %eax,%eax
8010474f:	74 e0                	je     80104731 <scheduler+0x1d1>
80104751:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104754:	e9 87 fe ff ff       	jmp    801045e0 <scheduler+0x80>
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104760 <sched>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
  pushcli();
80104765:	e8 f6 0c 00 00       	call   80105460 <pushcli>
  c = mycpu();
8010476a:	e8 b1 f8 ff ff       	call   80104020 <mycpu>
  p = c->proc;
8010476f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104775:	e8 36 0d 00 00       	call   801054b0 <popcli>
  if (!holding(&ptable.lock))
8010477a:	83 ec 0c             	sub    $0xc,%esp
8010477d:	68 00 43 11 80       	push   $0x80114300
80104782:	e8 89 0d 00 00       	call   80105510 <holding>
80104787:	83 c4 10             	add    $0x10,%esp
8010478a:	85 c0                	test   %eax,%eax
8010478c:	74 4f                	je     801047dd <sched+0x7d>
  if (mycpu()->ncli != 1)
8010478e:	e8 8d f8 ff ff       	call   80104020 <mycpu>
80104793:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010479a:	75 68                	jne    80104804 <sched+0xa4>
  if (p->state == RUNNING)
8010479c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801047a0:	74 55                	je     801047f7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047a2:	9c                   	pushf  
801047a3:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801047a4:	f6 c4 02             	test   $0x2,%ah
801047a7:	75 41                	jne    801047ea <sched+0x8a>
  intena = mycpu()->intena;
801047a9:	e8 72 f8 ff ff       	call   80104020 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801047ae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801047b1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801047b7:	e8 64 f8 ff ff       	call   80104020 <mycpu>
801047bc:	83 ec 08             	sub    $0x8,%esp
801047bf:	ff 70 04             	push   0x4(%eax)
801047c2:	53                   	push   %ebx
801047c3:	e8 c3 10 00 00       	call   8010588b <swtch>
  mycpu()->intena = intena;
801047c8:	e8 53 f8 ff ff       	call   80104020 <mycpu>
}
801047cd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801047d0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801047d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d9:	5b                   	pop    %ebx
801047da:	5e                   	pop    %esi
801047db:	5d                   	pop    %ebp
801047dc:	c3                   	ret    
    panic("sched ptable.lock");
801047dd:	83 ec 0c             	sub    $0xc,%esp
801047e0:	68 1b 8b 10 80       	push   $0x80108b1b
801047e5:	e8 96 bb ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	68 47 8b 10 80       	push   $0x80108b47
801047f2:	e8 89 bb ff ff       	call   80100380 <panic>
    panic("sched running");
801047f7:	83 ec 0c             	sub    $0xc,%esp
801047fa:	68 39 8b 10 80       	push   $0x80108b39
801047ff:	e8 7c bb ff ff       	call   80100380 <panic>
    panic("sched locks");
80104804:	83 ec 0c             	sub    $0xc,%esp
80104807:	68 2d 8b 10 80       	push   $0x80108b2d
8010480c:	e8 6f bb ff ff       	call   80100380 <panic>
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop

80104820 <exit>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104829:	e8 72 f8 ff ff       	call   801040a0 <myproc>
  if (curproc == initproc)
8010482e:	39 05 3c 6b 11 80    	cmp    %eax,0x80116b3c
80104834:	0f 84 07 01 00 00    	je     80104941 <exit+0x121>
8010483a:	89 c3                	mov    %eax,%ebx
8010483c:	8d 70 28             	lea    0x28(%eax),%esi
8010483f:	8d 78 68             	lea    0x68(%eax),%edi
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80104848:	8b 06                	mov    (%esi),%eax
8010484a:	85 c0                	test   %eax,%eax
8010484c:	74 12                	je     80104860 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010484e:	83 ec 0c             	sub    $0xc,%esp
80104851:	50                   	push   %eax
80104852:	e8 f9 cc ff ff       	call   80101550 <fileclose>
      curproc->ofile[fd] = 0;
80104857:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010485d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104860:	83 c6 04             	add    $0x4,%esi
80104863:	39 f7                	cmp    %esi,%edi
80104865:	75 e1                	jne    80104848 <exit+0x28>
  begin_op();
80104867:	e8 54 eb ff ff       	call   801033c0 <begin_op>
  iput(curproc->cwd);
8010486c:	83 ec 0c             	sub    $0xc,%esp
8010486f:	ff 73 68             	push   0x68(%ebx)
80104872:	e8 99 d6 ff ff       	call   80101f10 <iput>
  end_op();
80104877:	e8 b4 eb ff ff       	call   80103430 <end_op>
  curproc->cwd = 0;
8010487c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104883:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
8010488a:	e8 21 0d 00 00       	call   801055b0 <acquire>
  wakeup1(curproc->parent);
8010488f:	8b 53 14             	mov    0x14(%ebx),%edx
80104892:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104895:	b8 34 43 11 80       	mov    $0x80114334,%eax
8010489a:	eb 10                	jmp    801048ac <exit+0x8c>
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a0:	05 a0 00 00 00       	add    $0xa0,%eax
801048a5:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
801048aa:	74 1e                	je     801048ca <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
801048ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048b0:	75 ee                	jne    801048a0 <exit+0x80>
801048b2:	3b 50 20             	cmp    0x20(%eax),%edx
801048b5:	75 e9                	jne    801048a0 <exit+0x80>
      p->state = RUNNABLE;
801048b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048be:	05 a0 00 00 00       	add    $0xa0,%eax
801048c3:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
801048c8:	75 e2                	jne    801048ac <exit+0x8c>
      p->parent = initproc;
801048ca:	8b 0d 3c 6b 11 80    	mov    0x80116b3c,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048d0:	ba 34 43 11 80       	mov    $0x80114334,%edx
801048d5:	eb 17                	jmp    801048ee <exit+0xce>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax
801048e0:	81 c2 a0 00 00 00    	add    $0xa0,%edx
801048e6:	81 fa 34 6b 11 80    	cmp    $0x80116b34,%edx
801048ec:	74 3a                	je     80104928 <exit+0x108>
    if (p->parent == curproc)
801048ee:	39 5a 14             	cmp    %ebx,0x14(%edx)
801048f1:	75 ed                	jne    801048e0 <exit+0xc0>
      if (p->state == ZOMBIE)
801048f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801048f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
801048fa:	75 e4                	jne    801048e0 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048fc:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104901:	eb 11                	jmp    80104914 <exit+0xf4>
80104903:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104907:	90                   	nop
80104908:	05 a0 00 00 00       	add    $0xa0,%eax
8010490d:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104912:	74 cc                	je     801048e0 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80104914:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104918:	75 ee                	jne    80104908 <exit+0xe8>
8010491a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010491d:	75 e9                	jne    80104908 <exit+0xe8>
      p->state = RUNNABLE;
8010491f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104926:	eb e0                	jmp    80104908 <exit+0xe8>
  curproc->state = ZOMBIE;
80104928:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010492f:	e8 2c fe ff ff       	call   80104760 <sched>
  panic("zombie exit");
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	68 68 8b 10 80       	push   $0x80108b68
8010493c:	e8 3f ba ff ff       	call   80100380 <panic>
    panic("init exiting");
80104941:	83 ec 0c             	sub    $0xc,%esp
80104944:	68 5b 8b 10 80       	push   $0x80108b5b
80104949:	e8 32 ba ff ff       	call   80100380 <panic>
8010494e:	66 90                	xchg   %ax,%ax

80104950 <wait>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
  pushcli();
80104955:	e8 06 0b 00 00       	call   80105460 <pushcli>
  c = mycpu();
8010495a:	e8 c1 f6 ff ff       	call   80104020 <mycpu>
  p = c->proc;
8010495f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104965:	e8 46 0b 00 00       	call   801054b0 <popcli>
  acquire(&ptable.lock);
8010496a:	83 ec 0c             	sub    $0xc,%esp
8010496d:	68 00 43 11 80       	push   $0x80114300
80104972:	e8 39 0c 00 00       	call   801055b0 <acquire>
80104977:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010497a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010497c:	bb 34 43 11 80       	mov    $0x80114334,%ebx
80104981:	eb 13                	jmp    80104996 <wait+0x46>
80104983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104987:	90                   	nop
80104988:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
8010498e:	81 fb 34 6b 11 80    	cmp    $0x80116b34,%ebx
80104994:	74 1e                	je     801049b4 <wait+0x64>
      if (p->parent != curproc)
80104996:	39 73 14             	cmp    %esi,0x14(%ebx)
80104999:	75 ed                	jne    80104988 <wait+0x38>
      if (p->state == ZOMBIE)
8010499b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010499f:	74 5f                	je     80104a00 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049a1:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
801049a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ac:	81 fb 34 6b 11 80    	cmp    $0x80116b34,%ebx
801049b2:	75 e2                	jne    80104996 <wait+0x46>
    if (!havekids || curproc->killed)
801049b4:	85 c0                	test   %eax,%eax
801049b6:	0f 84 9a 00 00 00    	je     80104a56 <wait+0x106>
801049bc:	8b 46 24             	mov    0x24(%esi),%eax
801049bf:	85 c0                	test   %eax,%eax
801049c1:	0f 85 8f 00 00 00    	jne    80104a56 <wait+0x106>
  pushcli();
801049c7:	e8 94 0a 00 00       	call   80105460 <pushcli>
  c = mycpu();
801049cc:	e8 4f f6 ff ff       	call   80104020 <mycpu>
  p = c->proc;
801049d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049d7:	e8 d4 0a 00 00       	call   801054b0 <popcli>
  if (p == 0)
801049dc:	85 db                	test   %ebx,%ebx
801049de:	0f 84 89 00 00 00    	je     80104a6d <wait+0x11d>
  p->chan = chan;
801049e4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801049e7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049ee:	e8 6d fd ff ff       	call   80104760 <sched>
  p->chan = 0;
801049f3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801049fa:	e9 7b ff ff ff       	jmp    8010497a <wait+0x2a>
801049ff:	90                   	nop
        kfree(p->kstack);
80104a00:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104a03:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a06:	ff 73 08             	push   0x8(%ebx)
80104a09:	e8 12 e1 ff ff       	call   80102b20 <kfree>
        p->kstack = 0;
80104a0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a15:	5a                   	pop    %edx
80104a16:	ff 73 04             	push   0x4(%ebx)
80104a19:	e8 82 35 00 00       	call   80107fa0 <freevm>
        p->pid = 0;
80104a1e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a25:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a2c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a30:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a3e:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104a45:	e8 06 0b 00 00       	call   80105550 <release>
        return pid;
80104a4a:	83 c4 10             	add    $0x10,%esp
}
80104a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a50:	89 f0                	mov    %esi,%eax
80104a52:	5b                   	pop    %ebx
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
      release(&ptable.lock);
80104a56:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a59:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a5e:	68 00 43 11 80       	push   $0x80114300
80104a63:	e8 e8 0a 00 00       	call   80105550 <release>
      return -1;
80104a68:	83 c4 10             	add    $0x10,%esp
80104a6b:	eb e0                	jmp    80104a4d <wait+0xfd>
    panic("sleep");
80104a6d:	83 ec 0c             	sub    $0xc,%esp
80104a70:	68 74 8b 10 80       	push   $0x80108b74
80104a75:	e8 06 b9 ff ff       	call   80100380 <panic>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a80 <yield>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  acquire(&ptable.lock); // DOC: yieldlock
80104a85:	83 ec 0c             	sub    $0xc,%esp
80104a88:	68 00 43 11 80       	push   $0x80114300
80104a8d:	e8 1e 0b 00 00       	call   801055b0 <acquire>
  pushcli();
80104a92:	e8 c9 09 00 00       	call   80105460 <pushcli>
  c = mycpu();
80104a97:	e8 84 f5 ff ff       	call   80104020 <mycpu>
  p = c->proc;
80104a9c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aa2:	e8 09 0a 00 00       	call   801054b0 <popcli>
  myproc()->sched_info.last_execution_time = ticks;
80104aa7:	8b 35 40 6b 11 80    	mov    0x80116b40,%esi
  myproc()->state = RUNNABLE;
80104aad:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
80104ab4:	e8 a7 09 00 00       	call   80105460 <pushcli>
  c = mycpu();
80104ab9:	e8 62 f5 ff ff       	call   80104020 <mycpu>
  p = c->proc;
80104abe:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ac4:	e8 e7 09 00 00       	call   801054b0 <popcli>
  myproc()->sched_info.last_execution_time = ticks;
80104ac9:	89 b3 94 00 00 00    	mov    %esi,0x94(%ebx)
  sched();
80104acf:	e8 8c fc ff ff       	call   80104760 <sched>
  release(&ptable.lock);
80104ad4:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104adb:	e8 70 0a 00 00       	call   80105550 <release>
}
80104ae0:	83 c4 10             	add    $0x10,%esp
80104ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ae6:	5b                   	pop    %ebx
80104ae7:	5e                   	pop    %esi
80104ae8:	5d                   	pop    %ebp
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <sleep>:
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
80104af6:	83 ec 0c             	sub    $0xc,%esp
80104af9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104aff:	e8 5c 09 00 00       	call   80105460 <pushcli>
  c = mycpu();
80104b04:	e8 17 f5 ff ff       	call   80104020 <mycpu>
  p = c->proc;
80104b09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b0f:	e8 9c 09 00 00       	call   801054b0 <popcli>
  if (p == 0)
80104b14:	85 db                	test   %ebx,%ebx
80104b16:	0f 84 87 00 00 00    	je     80104ba3 <sleep+0xb3>
  if (lk == 0)
80104b1c:	85 f6                	test   %esi,%esi
80104b1e:	74 76                	je     80104b96 <sleep+0xa6>
  if (lk != &ptable.lock)
80104b20:	81 fe 00 43 11 80    	cmp    $0x80114300,%esi
80104b26:	74 50                	je     80104b78 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 00 43 11 80       	push   $0x80114300
80104b30:	e8 7b 0a 00 00       	call   801055b0 <acquire>
    release(lk);
80104b35:	89 34 24             	mov    %esi,(%esp)
80104b38:	e8 13 0a 00 00       	call   80105550 <release>
  p->chan = chan;
80104b3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b47:	e8 14 fc ff ff       	call   80104760 <sched>
  p->chan = 0;
80104b4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b53:	c7 04 24 00 43 11 80 	movl   $0x80114300,(%esp)
80104b5a:	e8 f1 09 00 00       	call   80105550 <release>
    acquire(lk);
80104b5f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b62:	83 c4 10             	add    $0x10,%esp
}
80104b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b68:	5b                   	pop    %ebx
80104b69:	5e                   	pop    %esi
80104b6a:	5f                   	pop    %edi
80104b6b:	5d                   	pop    %ebp
    acquire(lk);
80104b6c:	e9 3f 0a 00 00       	jmp    801055b0 <acquire>
80104b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b82:	e8 d9 fb ff ff       	call   80104760 <sched>
  p->chan = 0;
80104b87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b91:	5b                   	pop    %ebx
80104b92:	5e                   	pop    %esi
80104b93:	5f                   	pop    %edi
80104b94:	5d                   	pop    %ebp
80104b95:	c3                   	ret    
    panic("sleep without lk");
80104b96:	83 ec 0c             	sub    $0xc,%esp
80104b99:	68 7a 8b 10 80       	push   $0x80108b7a
80104b9e:	e8 dd b7 ff ff       	call   80100380 <panic>
    panic("sleep");
80104ba3:	83 ec 0c             	sub    $0xc,%esp
80104ba6:	68 74 8b 10 80       	push   $0x80108b74
80104bab:	e8 d0 b7 ff ff       	call   80100380 <panic>

80104bb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 10             	sub    $0x10,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104bba:	68 00 43 11 80       	push   $0x80114300
80104bbf:	e8 ec 09 00 00       	call   801055b0 <acquire>
80104bc4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bc7:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104bcc:	eb 0e                	jmp    80104bdc <wakeup+0x2c>
80104bce:	66 90                	xchg   %ax,%ax
80104bd0:	05 a0 00 00 00       	add    $0xa0,%eax
80104bd5:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104bda:	74 1e                	je     80104bfa <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80104bdc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104be0:	75 ee                	jne    80104bd0 <wakeup+0x20>
80104be2:	3b 58 20             	cmp    0x20(%eax),%ebx
80104be5:	75 e9                	jne    80104bd0 <wakeup+0x20>
      p->state = RUNNABLE;
80104be7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bee:	05 a0 00 00 00       	add    $0xa0,%eax
80104bf3:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104bf8:	75 e2                	jne    80104bdc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104bfa:	c7 45 08 00 43 11 80 	movl   $0x80114300,0x8(%ebp)
}
80104c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c04:	c9                   	leave  
  release(&ptable.lock);
80104c05:	e9 46 09 00 00       	jmp    80105550 <release>
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c10 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 10             	sub    $0x10,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104c1a:	68 00 43 11 80       	push   $0x80114300
80104c1f:	e8 8c 09 00 00       	call   801055b0 <acquire>
80104c24:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c27:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104c2c:	eb 0e                	jmp    80104c3c <kill+0x2c>
80104c2e:	66 90                	xchg   %ax,%ax
80104c30:	05 a0 00 00 00       	add    $0xa0,%eax
80104c35:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104c3a:	74 34                	je     80104c70 <kill+0x60>
  {
    if (p->pid == pid)
80104c3c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c3f:	75 ef                	jne    80104c30 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104c41:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104c45:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104c4c:	75 07                	jne    80104c55 <kill+0x45>
        p->state = RUNNABLE;
80104c4e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104c55:	83 ec 0c             	sub    $0xc,%esp
80104c58:	68 00 43 11 80       	push   $0x80114300
80104c5d:	e8 ee 08 00 00       	call   80105550 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	31 c0                	xor    %eax,%eax
}
80104c6a:	c9                   	leave  
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	68 00 43 11 80       	push   $0x80114300
80104c78:	e8 d3 08 00 00       	call   80105550 <release>
}
80104c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c88:	c9                   	leave  
80104c89:	c3                   	ret    
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104c98:	53                   	push   %ebx
80104c99:	bb a0 43 11 80       	mov    $0x801143a0,%ebx
80104c9e:	83 ec 3c             	sub    $0x3c,%esp
80104ca1:	eb 27                	jmp    80104cca <procdump+0x3a>
80104ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ca7:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ca8:	83 ec 0c             	sub    $0xc,%esp
80104cab:	68 1b 90 10 80       	push   $0x8010901b
80104cb0:	e8 eb b9 ff ff       	call   801006a0 <cprintf>
80104cb5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cb8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104cbe:	81 fb a0 6b 11 80    	cmp    $0x80116ba0,%ebx
80104cc4:	0f 84 7e 00 00 00    	je     80104d48 <procdump+0xb8>
    if (p->state == UNUSED)
80104cca:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104ccd:	85 c0                	test   %eax,%eax
80104ccf:	74 e7                	je     80104cb8 <procdump+0x28>
      state = "???";
80104cd1:	ba 8b 8b 10 80       	mov    $0x80108b8b,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cd6:	83 f8 05             	cmp    $0x5,%eax
80104cd9:	77 11                	ja     80104cec <procdump+0x5c>
80104cdb:	8b 14 85 a0 8c 10 80 	mov    -0x7fef7360(,%eax,4),%edx
      state = "???";
80104ce2:	b8 8b 8b 10 80       	mov    $0x80108b8b,%eax
80104ce7:	85 d2                	test   %edx,%edx
80104ce9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104cec:	53                   	push   %ebx
80104ced:	52                   	push   %edx
80104cee:	ff 73 a4             	push   -0x5c(%ebx)
80104cf1:	68 8f 8b 10 80       	push   $0x80108b8f
80104cf6:	e8 a5 b9 ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
80104cfb:	83 c4 10             	add    $0x10,%esp
80104cfe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104d02:	75 a4                	jne    80104ca8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104d04:	83 ec 08             	sub    $0x8,%esp
80104d07:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d0a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104d0d:	50                   	push   %eax
80104d0e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104d11:	8b 40 0c             	mov    0xc(%eax),%eax
80104d14:	83 c0 08             	add    $0x8,%eax
80104d17:	50                   	push   %eax
80104d18:	e8 e3 06 00 00       	call   80105400 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	8b 17                	mov    (%edi),%edx
80104d22:	85 d2                	test   %edx,%edx
80104d24:	74 82                	je     80104ca8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104d26:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104d29:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104d2c:	52                   	push   %edx
80104d2d:	68 a1 85 10 80       	push   $0x801085a1
80104d32:	e8 69 b9 ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104d37:	83 c4 10             	add    $0x10,%esp
80104d3a:	39 fe                	cmp    %edi,%esi
80104d3c:	75 e2                	jne    80104d20 <procdump+0x90>
80104d3e:	e9 65 ff ff ff       	jmp    80104ca8 <procdump+0x18>
80104d43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d47:	90                   	nop
  }
}
80104d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d4b:	5b                   	pop    %ebx
80104d4c:	5e                   	pop    %esi
80104d4d:	5f                   	pop    %edi
80104d4e:	5d                   	pop    %ebp
80104d4f:	c3                   	ret    

80104d50 <uncle_count>:

int uncle_count(int pid)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 10             	sub    $0x10,%esp
80104d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int num_of_uncles = 0;

  acquire(&ptable.lock);
80104d5a:	68 00 43 11 80       	push   $0x80114300
80104d5f:	e8 4c 08 00 00       	call   801055b0 <acquire>
80104d64:	83 c4 10             	add    $0x10,%esp

  int grand_father_pid = -1;
80104d67:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d6c:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if (p->pid == pid)
80104d78:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d7b:	75 09                	jne    80104d86 <uncle_count+0x36>
    {
      grand_father_pid = p->parent->parent->pid;
80104d7d:	8b 50 14             	mov    0x14(%eax),%edx
80104d80:	8b 52 14             	mov    0x14(%edx),%edx
80104d83:	8b 4a 10             	mov    0x10(%edx),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d86:	05 a0 00 00 00       	add    $0xa0,%eax
80104d8b:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104d90:	75 e6                	jne    80104d78 <uncle_count+0x28>
    }
  }
  if (grand_father_pid < 0)
80104d92:	85 c9                	test   %ecx,%ecx
80104d94:	78 3c                	js     80104dd2 <uncle_count+0x82>
  int num_of_uncles = 0;
80104d96:	31 db                	xor    %ebx,%ebx
    return -1;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d98:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->parent->pid == grand_father_pid)
80104da0:	8b 50 14             	mov    0x14(%eax),%edx
      num_of_uncles++;
80104da3:	39 4a 10             	cmp    %ecx,0x10(%edx)
80104da6:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104da9:	05 a0 00 00 00       	add    $0xa0,%eax
      num_of_uncles++;
80104dae:	0f b6 d2             	movzbl %dl,%edx
80104db1:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104db3:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104db8:	75 e6                	jne    80104da0 <uncle_count+0x50>

  release(&ptable.lock);
80104dba:	83 ec 0c             	sub    $0xc,%esp
80104dbd:	68 00 43 11 80       	push   $0x80114300
80104dc2:	e8 89 07 00 00       	call   80105550 <release>
  return num_of_uncles - 1;
80104dc7:	8d 43 ff             	lea    -0x1(%ebx),%eax
80104dca:	83 c4 10             	add    $0x10,%esp
}
80104dcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd0:	c9                   	leave  
80104dd1:	c3                   	ret    
    return -1;
80104dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd7:	eb f4                	jmp    80104dcd <uncle_count+0x7d>
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104de0 <find_process_lifetime>:
int find_process_lifetime(int pid)
{
80104de0:	55                   	push   %ebp
  struct proc *p; 
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104de1:	b9 34 43 11 80       	mov    $0x80114334,%ecx
{
80104de6:	89 e5                	mov    %esp,%ebp
80104de8:	8b 45 08             	mov    0x8(%ebp),%eax
80104deb:	eb 11                	jmp    80104dfe <find_process_lifetime+0x1e>
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104df0:	81 c1 a0 00 00 00    	add    $0xa0,%ecx
80104df6:	81 f9 34 6b 11 80    	cmp    $0x80116b34,%ecx
80104dfc:	74 05                	je     80104e03 <find_process_lifetime+0x23>
  {
    if (p->pid == pid)
80104dfe:	39 41 10             	cmp    %eax,0x10(%ecx)
80104e01:	75 ed                	jne    80104df0 <find_process_lifetime+0x10>
    {
      break;
    }
  }
  int current_time = ticks / TICKS_PER_SECOND;
80104e03:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104e08:	f7 25 40 6b 11 80    	mull   0x80116b40
  
  return (current_time - p->start_time);
}
80104e0e:	5d                   	pop    %ebp
  int current_time = ticks / TICKS_PER_SECOND;
80104e0f:	c1 ea 05             	shr    $0x5,%edx
  return (current_time - p->start_time);
80104e12:	89 d0                	mov    %edx,%eax
80104e14:	2b 41 7c             	sub    0x7c(%ecx),%eax
}
80104e17:	c3                   	ret    
80104e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop

80104e20 <set_sjf_process>:

int
set_sjf_process(int pid, int burst_time)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
80104e24:	83 ec 10             	sub    $0x10,%esp
80104e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104e2a:	68 00 43 11 80       	push   $0x80114300
80104e2f:	e8 7c 07 00 00       	call   801055b0 <acquire>
80104e34:	83 c4 10             	add    $0x10,%esp
  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e37:	b8 34 43 11 80       	mov    $0x80114334,%eax
80104e3c:	eb 0e                	jmp    80104e4c <set_sjf_process+0x2c>
80104e3e:	66 90                	xchg   %ax,%ax
80104e40:	05 a0 00 00 00       	add    $0xa0,%eax
80104e45:	3d 34 6b 11 80       	cmp    $0x80116b34,%eax
80104e4a:	74 2c                	je     80104e78 <set_sjf_process+0x58>
    if(p->pid == pid){
80104e4c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e4f:	75 ef                	jne    80104e40 <set_sjf_process+0x20>
      p->sched_info.burst_time = burst_time;
80104e51:	8b 55 0c             	mov    0xc(%ebp),%edx
      release(&ptable.lock);
80104e54:	83 ec 0c             	sub    $0xc,%esp
      p->sched_info.burst_time = burst_time;
80104e57:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      release(&ptable.lock);
80104e5d:	68 00 43 11 80       	push   $0x80114300
80104e62:	e8 e9 06 00 00       	call   80105550 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104e67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	31 c0                	xor    %eax,%eax
}
80104e6f:	c9                   	leave  
80104e70:	c3                   	ret    
80104e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	68 00 43 11 80       	push   $0x80114300
80104e80:	e8 cb 06 00 00       	call   80105550 <release>
}
80104e85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104e88:	83 c4 10             	add    $0x10,%esp
80104e8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e90:	c9                   	leave  
80104e91:	c3                   	ret    
80104e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <change_process_queue>:

int
change_process_queue(int pid,int queue_num){
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 75 08             	mov    0x8(%ebp),%esi
 struct proc* p;
 acquire(&ptable.lock);
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ea8:	bb 34 43 11 80       	mov    $0x80114334,%ebx
 acquire(&ptable.lock);
80104ead:	83 ec 0c             	sub    $0xc,%esp
80104eb0:	68 00 43 11 80       	push   $0x80114300
80104eb5:	e8 f6 06 00 00       	call   801055b0 <acquire>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	eb 0f                	jmp    80104ece <change_process_queue+0x2e>
80104ebf:	90                   	nop
 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ec0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104ec6:	81 fb 34 6b 11 80    	cmp    $0x80116b34,%ebx
80104ecc:	74 05                	je     80104ed3 <change_process_queue+0x33>
 if(p->pid == pid){
80104ece:	39 73 10             	cmp    %esi,0x10(%ebx)
80104ed1:	75 ed                	jne    80104ec0 <change_process_queue+0x20>
 break;
 }
 }
 release(&ptable.lock);
80104ed3:	83 ec 0c             	sub    $0xc,%esp
80104ed6:	68 00 43 11 80       	push   $0x80114300
80104edb:	e8 70 06 00 00       	call   80105550 <release>
  p->sched_info.queue = new_queue;
80104ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  enum scheduling_queue old_queue = p->sched_info.queue;
80104ee3:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  p->sched_info.queue = new_queue;
80104ee9:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
  p->sched_info.last_run = ticks;
80104eef:	8b 15 40 6b 11 80    	mov    0x80116b40,%edx
80104ef5:	89 93 84 00 00 00    	mov    %edx,0x84(%ebx)
 int old_queue_num= change_queue(p, queue_num);
 return old_queue_num;
}
80104efb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104efe:	5b                   	pop    %ebx
80104eff:	5e                   	pop    %esi
80104f00:	5d                   	pop    %ebp
80104f01:	c3                   	ret    
80104f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f10 <print_schedule_info>:

void
print_schedule_info(void){
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
80104f16:	bb a0 43 11 80       	mov    $0x801143a0,%ebx
80104f1b:	83 ec 28             	sub    $0x28,%esp
  [RUNNING]   "running",
  [ZOMBIE]    "zombie"
  };

  static int columns[] = {16, 9, 9, 9, 9, 9, 9, 9};
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival  Burst\n"
80104f1e:	68 00 8c 10 80       	push   $0x80108c00
80104f23:	e8 78 b7 ff ff       	call   801006a0 <cprintf>
          "-------------------------------------------------------------------\n");

  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f28:	83 c4 10             	add    $0x10,%esp
80104f2b:	eb 16                	jmp    80104f43 <print_schedule_info+0x33>
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104f36:	b8 a0 6b 11 80       	mov    $0x80116ba0,%eax
80104f3b:	39 d8                	cmp    %ebx,%eax
80104f3d:	0f 84 0f 03 00 00    	je     80105252 <print_schedule_info+0x342>
    if(p->state == UNUSED)
80104f43:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104f46:	85 c0                	test   %eax,%eax
80104f48:	74 e6                	je     80104f30 <print_schedule_info+0x20>

    const char* state;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80104f4a:	c7 45 e0 8b 8b 10 80 	movl   $0x80108b8b,-0x20(%ebp)
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f51:	83 f8 05             	cmp    $0x5,%eax
80104f54:	77 14                	ja     80104f6a <print_schedule_info+0x5a>
80104f56:	8b 3c 85 88 8c 10 80 	mov    -0x7fef7378(,%eax,4),%edi
      state = "???";
80104f5d:	b8 8b 8b 10 80       	mov    $0x80108b8b,%eax
80104f62:	85 ff                	test   %edi,%edi
80104f64:	0f 45 c7             	cmovne %edi,%eax
80104f67:	89 45 e0             	mov    %eax,-0x20(%ebp)

    cprintf("%s", p->name);
80104f6a:	83 ec 08             	sub    $0x8,%esp
    printspaces(columns[0] - strlen(p->name));
80104f6d:	be 10 00 00 00       	mov    $0x10,%esi
    cprintf("%s", p->name);
80104f72:	53                   	push   %ebx
80104f73:	68 95 8b 10 80       	push   $0x80108b95
80104f78:	e8 23 b7 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[0] - strlen(p->name));
80104f7d:	89 1c 24             	mov    %ebx,(%esp)
80104f80:	e8 eb 08 00 00       	call   80105870 <strlen>
  for(int i = 0; i < count; ++i)
80104f85:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[0] - strlen(p->name));
80104f88:	29 c6                	sub    %eax,%esi
  for(int i = 0; i < count; ++i)
80104f8a:	85 f6                	test   %esi,%esi
80104f8c:	7e 19                	jle    80104fa7 <print_schedule_info+0x97>
80104f8e:	31 ff                	xor    %edi,%edi
    cprintf(" ");
80104f90:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104f93:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104f96:	68 d5 8b 10 80       	push   $0x80108bd5
80104f9b:	e8 00 b7 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80104fa0:	83 c4 10             	add    $0x10,%esp
80104fa3:	39 fe                	cmp    %edi,%esi
80104fa5:	75 e9                	jne    80104f90 <print_schedule_info+0x80>

    cprintf("%d", p->pid);
80104fa7:	83 ec 08             	sub    $0x8,%esp
80104faa:	ff 73 a4             	push   -0x5c(%ebx)
80104fad:	68 98 8b 10 80       	push   $0x80108b98
80104fb2:	e8 e9 b6 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[1] - digitcount(p->pid));
80104fb7:	8b 4b a4             	mov    -0x5c(%ebx),%ecx
  if(num == 0) return 1;
80104fba:	83 c4 10             	add    $0x10,%esp
80104fbd:	85 c9                	test   %ecx,%ecx
80104fbf:	0f 84 db 02 00 00    	je     801052a0 <print_schedule_info+0x390>
  int count = 0;
80104fc5:	31 f6                	xor    %esi,%esi
    num /= 10;
80104fc7:	bf 67 66 66 66       	mov    $0x66666667,%edi
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fd0:	89 c8                	mov    %ecx,%eax
    ++count;
80104fd2:	83 c6 01             	add    $0x1,%esi
    num /= 10;
80104fd5:	f7 ef                	imul   %edi
80104fd7:	89 c8                	mov    %ecx,%eax
80104fd9:	c1 f8 1f             	sar    $0x1f,%eax
80104fdc:	c1 fa 02             	sar    $0x2,%edx
  while(num){
80104fdf:	89 d1                	mov    %edx,%ecx
80104fe1:	29 c1                	sub    %eax,%ecx
80104fe3:	75 eb                	jne    80104fd0 <print_schedule_info+0xc0>
    printspaces(columns[1] - digitcount(p->pid));
80104fe5:	bf 09 00 00 00       	mov    $0x9,%edi
80104fea:	29 f7                	sub    %esi,%edi
  for(int i = 0; i < count; ++i)
80104fec:	85 ff                	test   %edi,%edi
80104fee:	7e 1f                	jle    8010500f <print_schedule_info+0xff>
    printspaces(columns[1] - digitcount(p->pid));
80104ff0:	31 f6                	xor    %esi,%esi
80104ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80104ff8:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104ffb:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80104ffe:	68 d5 8b 10 80       	push   $0x80108bd5
80105003:	e8 98 b6 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	39 fe                	cmp    %edi,%esi
8010500d:	7c e9                	jl     80104ff8 <print_schedule_info+0xe8>

    cprintf("%s", state);
8010500f:	8b 7d e0             	mov    -0x20(%ebp),%edi
80105012:	83 ec 08             	sub    $0x8,%esp
80105015:	57                   	push   %edi
80105016:	68 95 8b 10 80       	push   $0x80108b95
8010501b:	e8 80 b6 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[2] - strlen(state));
80105020:	89 3c 24             	mov    %edi,(%esp)
80105023:	bf 09 00 00 00       	mov    $0x9,%edi
80105028:	e8 43 08 00 00       	call   80105870 <strlen>
  for(int i = 0; i < count; ++i)
8010502d:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[2] - strlen(state));
80105030:	29 c7                	sub    %eax,%edi
  for(int i = 0; i < count; ++i)
80105032:	85 ff                	test   %edi,%edi
80105034:	7e 21                	jle    80105057 <print_schedule_info+0x147>
80105036:	31 f6                	xor    %esi,%esi
80105038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503f:	90                   	nop
    cprintf(" ");
80105040:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105043:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105046:	68 d5 8b 10 80       	push   $0x80108bd5
8010504b:	e8 50 b6 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80105050:	83 c4 10             	add    $0x10,%esp
80105053:	39 f7                	cmp    %esi,%edi
80105055:	75 e9                	jne    80105040 <print_schedule_info+0x130>

    cprintf("%d", p->sched_info.queue);
80105057:	83 ec 08             	sub    $0x8,%esp
8010505a:	ff 73 14             	push   0x14(%ebx)
8010505d:	68 98 8b 10 80       	push   $0x80108b98
80105062:	e8 39 b6 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[3] - digitcount(p->sched_info.queue));
80105067:	8b 4b 14             	mov    0x14(%ebx),%ecx
  if(num == 0) return 1;
8010506a:	83 c4 10             	add    $0x10,%esp
8010506d:	85 c9                	test   %ecx,%ecx
8010506f:	0f 84 1b 02 00 00    	je     80105290 <print_schedule_info+0x380>
  int count = 0;
80105075:	31 f6                	xor    %esi,%esi
    num /= 10;
80105077:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105080:	89 c8                	mov    %ecx,%eax
    ++count;
80105082:	83 c6 01             	add    $0x1,%esi
    num /= 10;
80105085:	f7 ef                	imul   %edi
80105087:	89 c8                	mov    %ecx,%eax
80105089:	c1 f8 1f             	sar    $0x1f,%eax
8010508c:	c1 fa 02             	sar    $0x2,%edx
  while(num){
8010508f:	29 c2                	sub    %eax,%edx
80105091:	89 d1                	mov    %edx,%ecx
80105093:	75 eb                	jne    80105080 <print_schedule_info+0x170>
    printspaces(columns[3] - digitcount(p->sched_info.queue));
80105095:	bf 09 00 00 00       	mov    $0x9,%edi
8010509a:	29 f7                	sub    %esi,%edi
  for(int i = 0; i < count; ++i)
8010509c:	85 ff                	test   %edi,%edi
8010509e:	7e 1f                	jle    801050bf <print_schedule_info+0x1af>
    printspaces(columns[3] - digitcount(p->sched_info.queue));
801050a0:	31 f6                	xor    %esi,%esi
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
801050a8:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801050ab:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801050ae:	68 d5 8b 10 80       	push   $0x80108bd5
801050b3:	e8 e8 b5 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	39 fe                	cmp    %edi,%esi
801050bd:	7c e9                	jl     801050a8 <print_schedule_info+0x198>

    cprintf("%d", (int)p->sched_info.executed_cycles);
801050bf:	d9 7d e6             	fnstcw -0x1a(%ebp)
801050c2:	d9 43 1c             	flds   0x1c(%ebx)
801050c5:	83 ec 08             	sub    $0x8,%esp
801050c8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801050cc:	80 cc 0c             	or     $0xc,%ah
801050cf:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801050d3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801050d6:	db 5d e0             	fistpl -0x20(%ebp)
801050d9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801050dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050df:	50                   	push   %eax
801050e0:	68 98 8b 10 80       	push   $0x80108b98
801050e5:	e8 b6 b5 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[4] - digitcount((int)p->sched_info.executed_cycles));
801050ea:	d9 43 1c             	flds   0x1c(%ebx)
  if(num == 0) return 1;
801050ed:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[4] - digitcount((int)p->sched_info.executed_cycles));
801050f0:	d9 7d e6             	fnstcw -0x1a(%ebp)
801050f3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801050f7:	80 cc 0c             	or     $0xc,%ah
801050fa:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801050fe:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105101:	db 5d e0             	fistpl -0x20(%ebp)
80105104:	d9 6d e6             	fldcw  -0x1a(%ebp)
80105107:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  if(num == 0) return 1;
8010510a:	85 c9                	test   %ecx,%ecx
8010510c:	0f 84 6e 01 00 00    	je     80105280 <print_schedule_info+0x370>
  int count = 0;
80105112:	31 f6                	xor    %esi,%esi
    num /= 10;
80105114:	bf 67 66 66 66       	mov    $0x66666667,%edi
80105119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105120:	89 c8                	mov    %ecx,%eax
    ++count;
80105122:	83 c6 01             	add    $0x1,%esi
    num /= 10;
80105125:	f7 ef                	imul   %edi
80105127:	89 c8                	mov    %ecx,%eax
80105129:	c1 f8 1f             	sar    $0x1f,%eax
8010512c:	c1 fa 02             	sar    $0x2,%edx
  while(num){
8010512f:	89 d1                	mov    %edx,%ecx
80105131:	29 c1                	sub    %eax,%ecx
80105133:	75 eb                	jne    80105120 <print_schedule_info+0x210>
    printspaces(columns[4] - digitcount((int)p->sched_info.executed_cycles));
80105135:	bf 09 00 00 00       	mov    $0x9,%edi
8010513a:	29 f7                	sub    %esi,%edi
  for(int i = 0; i < count; ++i)
8010513c:	85 ff                	test   %edi,%edi
8010513e:	7e 1f                	jle    8010515f <print_schedule_info+0x24f>
    printspaces(columns[4] - digitcount((int)p->sched_info.executed_cycles));
80105140:	31 f6                	xor    %esi,%esi
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80105148:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
8010514b:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
8010514e:	68 d5 8b 10 80       	push   $0x80108bd5
80105153:	e8 48 b5 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	39 fe                	cmp    %edi,%esi
8010515d:	7c e9                	jl     80105148 <print_schedule_info+0x238>

    cprintf("%d", p->sched_info.arrival_time);
8010515f:	83 ec 08             	sub    $0x8,%esp
80105162:	ff 73 20             	push   0x20(%ebx)
80105165:	68 98 8b 10 80       	push   $0x80108b98
8010516a:	e8 31 b5 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[5] - digitcount(p->sched_info.arrival_time));
8010516f:	8b 4b 20             	mov    0x20(%ebx),%ecx
  if(num == 0) return 1;
80105172:	83 c4 10             	add    $0x10,%esp
80105175:	85 c9                	test   %ecx,%ecx
80105177:	0f 84 f3 00 00 00    	je     80105270 <print_schedule_info+0x360>
  int count = 0;
8010517d:	31 f6                	xor    %esi,%esi
    num /= 10;
8010517f:	bf 67 66 66 66       	mov    $0x66666667,%edi
80105184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105188:	89 c8                	mov    %ecx,%eax
    ++count;
8010518a:	83 c6 01             	add    $0x1,%esi
    num /= 10;
8010518d:	f7 ef                	imul   %edi
8010518f:	89 c8                	mov    %ecx,%eax
80105191:	c1 f8 1f             	sar    $0x1f,%eax
80105194:	c1 fa 02             	sar    $0x2,%edx
  while(num){
80105197:	29 c2                	sub    %eax,%edx
80105199:	89 d1                	mov    %edx,%ecx
8010519b:	75 eb                	jne    80105188 <print_schedule_info+0x278>
    printspaces(columns[5] - digitcount(p->sched_info.arrival_time));
8010519d:	bf 09 00 00 00       	mov    $0x9,%edi
801051a2:	29 f7                	sub    %esi,%edi
  for(int i = 0; i < count; ++i)
801051a4:	85 ff                	test   %edi,%edi
801051a6:	7e 1f                	jle    801051c7 <print_schedule_info+0x2b7>
    printspaces(columns[5] - digitcount(p->sched_info.arrival_time));
801051a8:	31 f6                	xor    %esi,%esi
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
801051b0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801051b3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801051b6:	68 d5 8b 10 80       	push   $0x80108bd5
801051bb:	e8 e0 b4 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	39 fe                	cmp    %edi,%esi
801051c5:	7c e9                	jl     801051b0 <print_schedule_info+0x2a0>

    cprintf("%d", p->sched_info.burst_time);
801051c7:	83 ec 08             	sub    $0x8,%esp
801051ca:	ff 73 24             	push   0x24(%ebx)
801051cd:	68 98 8b 10 80       	push   $0x80108b98
801051d2:	e8 c9 b4 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[6] - digitcount(p->sched_info.burst_time));
801051d7:	8b 4b 24             	mov    0x24(%ebx),%ecx
  if(num == 0) return 1;
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	85 c9                	test   %ecx,%ecx
801051df:	74 7f                	je     80105260 <print_schedule_info+0x350>
  int count = 0;
801051e1:	31 f6                	xor    %esi,%esi
    num /= 10;
801051e3:	bf 67 66 66 66       	mov    $0x66666667,%edi
801051e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ef:	90                   	nop
801051f0:	89 c8                	mov    %ecx,%eax
    ++count;
801051f2:	83 c6 01             	add    $0x1,%esi
    num /= 10;
801051f5:	f7 ef                	imul   %edi
801051f7:	89 c8                	mov    %ecx,%eax
801051f9:	c1 f8 1f             	sar    $0x1f,%eax
801051fc:	c1 fa 02             	sar    $0x2,%edx
  while(num){
801051ff:	89 d1                	mov    %edx,%ecx
80105201:	29 c1                	sub    %eax,%ecx
80105203:	75 eb                	jne    801051f0 <print_schedule_info+0x2e0>
    printspaces(columns[6] - digitcount(p->sched_info.burst_time));
80105205:	bf 09 00 00 00       	mov    $0x9,%edi
8010520a:	29 f7                	sub    %esi,%edi
  for(int i = 0; i < count; ++i)
8010520c:	85 ff                	test   %edi,%edi
8010520e:	7e 1f                	jle    8010522f <print_schedule_info+0x31f>
    printspaces(columns[6] - digitcount(p->sched_info.burst_time));
80105210:	31 f6                	xor    %esi,%esi
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80105218:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
8010521b:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
8010521e:	68 d5 8b 10 80       	push   $0x80108bd5
80105223:	e8 78 b4 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	39 fe                	cmp    %edi,%esi
8010522d:	7c e9                	jl     80105218 <print_schedule_info+0x308>
    cprintf("\n");
8010522f:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105232:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
    cprintf("\n");
80105238:	68 1b 90 10 80       	push   $0x8010901b
8010523d:	e8 5e b4 ff ff       	call   801006a0 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105242:	b8 a0 6b 11 80       	mov    $0x80116ba0,%eax
    cprintf("\n");
80105247:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010524a:	39 d8                	cmp    %ebx,%eax
8010524c:	0f 85 f1 fc ff ff    	jne    80104f43 <print_schedule_info+0x33>
  }
}
80105252:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105255:	5b                   	pop    %ebx
80105256:	5e                   	pop    %esi
80105257:	5f                   	pop    %edi
80105258:	5d                   	pop    %ebp
80105259:	c3                   	ret    
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[6] - digitcount(p->sched_info.burst_time));
80105260:	bf 08 00 00 00       	mov    $0x8,%edi
80105265:	eb a9                	jmp    80105210 <print_schedule_info+0x300>
80105267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526e:	66 90                	xchg   %ax,%ax
    printspaces(columns[5] - digitcount(p->sched_info.arrival_time));
80105270:	bf 08 00 00 00       	mov    $0x8,%edi
80105275:	e9 2e ff ff ff       	jmp    801051a8 <print_schedule_info+0x298>
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[4] - digitcount((int)p->sched_info.executed_cycles));
80105280:	bf 08 00 00 00       	mov    $0x8,%edi
80105285:	e9 b6 fe ff ff       	jmp    80105140 <print_schedule_info+0x230>
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[3] - digitcount(p->sched_info.queue));
80105290:	bf 08 00 00 00       	mov    $0x8,%edi
80105295:	e9 06 fe ff ff       	jmp    801050a0 <print_schedule_info+0x190>
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[1] - digitcount(p->pid));
801052a0:	bf 08 00 00 00       	mov    $0x8,%edi
801052a5:	e9 46 fd ff ff       	jmp    80104ff0 <print_schedule_info+0xe0>
801052aa:	66 90                	xchg   %ax,%ax
801052ac:	66 90                	xchg   %ax,%ax
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	53                   	push   %ebx
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801052ba:	68 c0 8c 10 80       	push   $0x80108cc0
801052bf:	8d 43 04             	lea    0x4(%ebx),%eax
801052c2:	50                   	push   %eax
801052c3:	e8 18 01 00 00       	call   801053e0 <initlock>
  lk->name = name;
801052c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801052cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801052d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801052d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801052db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801052de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052e1:	c9                   	leave  
801052e2:	c3                   	ret    
801052e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801052f8:	8d 73 04             	lea    0x4(%ebx),%esi
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	56                   	push   %esi
801052ff:	e8 ac 02 00 00       	call   801055b0 <acquire>
  while (lk->locked) {
80105304:	8b 13                	mov    (%ebx),%edx
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	85 d2                	test   %edx,%edx
8010530b:	74 16                	je     80105323 <acquiresleep+0x33>
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105310:	83 ec 08             	sub    $0x8,%esp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
80105315:	e8 d6 f7 ff ff       	call   80104af0 <sleep>
  while (lk->locked) {
8010531a:	8b 03                	mov    (%ebx),%eax
8010531c:	83 c4 10             	add    $0x10,%esp
8010531f:	85 c0                	test   %eax,%eax
80105321:	75 ed                	jne    80105310 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105323:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105329:	e8 72 ed ff ff       	call   801040a0 <myproc>
8010532e:	8b 40 10             	mov    0x10(%eax),%eax
80105331:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105334:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105337:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010533a:	5b                   	pop    %ebx
8010533b:	5e                   	pop    %esi
8010533c:	5d                   	pop    %ebp
  release(&lk->lk);
8010533d:	e9 0e 02 00 00       	jmp    80105550 <release>
80105342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105350 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105358:	8d 73 04             	lea    0x4(%ebx),%esi
8010535b:	83 ec 0c             	sub    $0xc,%esp
8010535e:	56                   	push   %esi
8010535f:	e8 4c 02 00 00       	call   801055b0 <acquire>
  lk->locked = 0;
80105364:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010536a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105371:	89 1c 24             	mov    %ebx,(%esp)
80105374:	e8 37 f8 ff ff       	call   80104bb0 <wakeup>
  release(&lk->lk);
80105379:	89 75 08             	mov    %esi,0x8(%ebp)
8010537c:	83 c4 10             	add    $0x10,%esp
}
8010537f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105382:	5b                   	pop    %ebx
80105383:	5e                   	pop    %esi
80105384:	5d                   	pop    %ebp
  release(&lk->lk);
80105385:	e9 c6 01 00 00       	jmp    80105550 <release>
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105390 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	31 ff                	xor    %edi,%edi
80105396:	56                   	push   %esi
80105397:	53                   	push   %ebx
80105398:	83 ec 18             	sub    $0x18,%esp
8010539b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010539e:	8d 73 04             	lea    0x4(%ebx),%esi
801053a1:	56                   	push   %esi
801053a2:	e8 09 02 00 00       	call   801055b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801053a7:	8b 03                	mov    (%ebx),%eax
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	75 18                	jne    801053c8 <holdingsleep+0x38>
  release(&lk->lk);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	56                   	push   %esi
801053b4:	e8 97 01 00 00       	call   80105550 <release>
  return r;
}
801053b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053bc:	89 f8                	mov    %edi,%eax
801053be:	5b                   	pop    %ebx
801053bf:	5e                   	pop    %esi
801053c0:	5f                   	pop    %edi
801053c1:	5d                   	pop    %ebp
801053c2:	c3                   	ret    
801053c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053c7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801053c8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801053cb:	e8 d0 ec ff ff       	call   801040a0 <myproc>
801053d0:	39 58 10             	cmp    %ebx,0x10(%eax)
801053d3:	0f 94 c0             	sete   %al
801053d6:	0f b6 c0             	movzbl %al,%eax
801053d9:	89 c7                	mov    %eax,%edi
801053db:	eb d3                	jmp    801053b0 <holdingsleep+0x20>
801053dd:	66 90                	xchg   %ax,%ax
801053df:	90                   	nop

801053e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801053e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801053e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801053ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801053f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop

80105400 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105400:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105401:	31 d2                	xor    %edx,%edx
{
80105403:	89 e5                	mov    %esp,%ebp
80105405:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105406:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010540c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010540f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105410:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105416:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010541c:	77 1a                	ja     80105438 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010541e:	8b 58 04             	mov    0x4(%eax),%ebx
80105421:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105424:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105427:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105429:	83 fa 0a             	cmp    $0xa,%edx
8010542c:	75 e2                	jne    80105410 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010542e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105431:	c9                   	leave  
80105432:	c3                   	ret    
80105433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105437:	90                   	nop
  for(; i < 10; i++)
80105438:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010543b:	8d 51 28             	lea    0x28(%ecx),%edx
8010543e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105446:	83 c0 04             	add    $0x4,%eax
80105449:	39 d0                	cmp    %edx,%eax
8010544b:	75 f3                	jne    80105440 <getcallerpcs+0x40>
}
8010544d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105450:	c9                   	leave  
80105451:	c3                   	ret    
80105452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105460 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 04             	sub    $0x4,%esp
80105467:	9c                   	pushf  
80105468:	5b                   	pop    %ebx
  asm volatile("cli");
80105469:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010546a:	e8 b1 eb ff ff       	call   80104020 <mycpu>
8010546f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105475:	85 c0                	test   %eax,%eax
80105477:	74 17                	je     80105490 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105479:	e8 a2 eb ff ff       	call   80104020 <mycpu>
8010547e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105488:	c9                   	leave  
80105489:	c3                   	ret    
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105490:	e8 8b eb ff ff       	call   80104020 <mycpu>
80105495:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010549b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801054a1:	eb d6                	jmp    80105479 <pushcli+0x19>
801054a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054b0 <popcli>:

void
popcli(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801054b6:	9c                   	pushf  
801054b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801054b8:	f6 c4 02             	test   $0x2,%ah
801054bb:	75 35                	jne    801054f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801054bd:	e8 5e eb ff ff       	call   80104020 <mycpu>
801054c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801054c9:	78 34                	js     801054ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801054cb:	e8 50 eb ff ff       	call   80104020 <mycpu>
801054d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801054d6:	85 d2                	test   %edx,%edx
801054d8:	74 06                	je     801054e0 <popcli+0x30>
    sti();
}
801054da:	c9                   	leave  
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801054e0:	e8 3b eb ff ff       	call   80104020 <mycpu>
801054e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801054eb:	85 c0                	test   %eax,%eax
801054ed:	74 eb                	je     801054da <popcli+0x2a>
  asm volatile("sti");
801054ef:	fb                   	sti    
}
801054f0:	c9                   	leave  
801054f1:	c3                   	ret    
    panic("popcli - interruptible");
801054f2:	83 ec 0c             	sub    $0xc,%esp
801054f5:	68 cb 8c 10 80       	push   $0x80108ccb
801054fa:	e8 81 ae ff ff       	call   80100380 <panic>
    panic("popcli");
801054ff:	83 ec 0c             	sub    $0xc,%esp
80105502:	68 e2 8c 10 80       	push   $0x80108ce2
80105507:	e8 74 ae ff ff       	call   80100380 <panic>
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105510 <holding>:
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
80105515:	8b 75 08             	mov    0x8(%ebp),%esi
80105518:	31 db                	xor    %ebx,%ebx
  pushcli();
8010551a:	e8 41 ff ff ff       	call   80105460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010551f:	8b 06                	mov    (%esi),%eax
80105521:	85 c0                	test   %eax,%eax
80105523:	75 0b                	jne    80105530 <holding+0x20>
  popcli();
80105525:	e8 86 ff ff ff       	call   801054b0 <popcli>
}
8010552a:	89 d8                	mov    %ebx,%eax
8010552c:	5b                   	pop    %ebx
8010552d:	5e                   	pop    %esi
8010552e:	5d                   	pop    %ebp
8010552f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105530:	8b 5e 08             	mov    0x8(%esi),%ebx
80105533:	e8 e8 ea ff ff       	call   80104020 <mycpu>
80105538:	39 c3                	cmp    %eax,%ebx
8010553a:	0f 94 c3             	sete   %bl
  popcli();
8010553d:	e8 6e ff ff ff       	call   801054b0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105542:	0f b6 db             	movzbl %bl,%ebx
}
80105545:	89 d8                	mov    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5e                   	pop    %esi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <release>:
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
80105555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105558:	e8 03 ff ff ff       	call   80105460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010555d:	8b 03                	mov    (%ebx),%eax
8010555f:	85 c0                	test   %eax,%eax
80105561:	75 15                	jne    80105578 <release+0x28>
  popcli();
80105563:	e8 48 ff ff ff       	call   801054b0 <popcli>
    panic("release");
80105568:	83 ec 0c             	sub    $0xc,%esp
8010556b:	68 e9 8c 10 80       	push   $0x80108ce9
80105570:	e8 0b ae ff ff       	call   80100380 <panic>
80105575:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105578:	8b 73 08             	mov    0x8(%ebx),%esi
8010557b:	e8 a0 ea ff ff       	call   80104020 <mycpu>
80105580:	39 c6                	cmp    %eax,%esi
80105582:	75 df                	jne    80105563 <release+0x13>
  popcli();
80105584:	e8 27 ff ff ff       	call   801054b0 <popcli>
  lk->pcs[0] = 0;
80105589:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105590:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105597:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010559c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801055a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055a5:	5b                   	pop    %ebx
801055a6:	5e                   	pop    %esi
801055a7:	5d                   	pop    %ebp
  popcli();
801055a8:	e9 03 ff ff ff       	jmp    801054b0 <popcli>
801055ad:	8d 76 00             	lea    0x0(%esi),%esi

801055b0 <acquire>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	53                   	push   %ebx
801055b4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801055b7:	e8 a4 fe ff ff       	call   80105460 <pushcli>
  if(holding(lk))
801055bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801055bf:	e8 9c fe ff ff       	call   80105460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801055c4:	8b 03                	mov    (%ebx),%eax
801055c6:	85 c0                	test   %eax,%eax
801055c8:	75 7e                	jne    80105648 <acquire+0x98>
  popcli();
801055ca:	e8 e1 fe ff ff       	call   801054b0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801055cf:	b9 01 00 00 00       	mov    $0x1,%ecx
801055d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801055d8:	8b 55 08             	mov    0x8(%ebp),%edx
801055db:	89 c8                	mov    %ecx,%eax
801055dd:	f0 87 02             	lock xchg %eax,(%edx)
801055e0:	85 c0                	test   %eax,%eax
801055e2:	75 f4                	jne    801055d8 <acquire+0x28>
  __sync_synchronize();
801055e4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801055e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055ec:	e8 2f ea ff ff       	call   80104020 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801055f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801055f4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801055f6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801055f9:	31 c0                	xor    %eax,%eax
801055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105600:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105606:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010560c:	77 1a                	ja     80105628 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010560e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105611:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105615:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105618:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010561a:	83 f8 0a             	cmp    $0xa,%eax
8010561d:	75 e1                	jne    80105600 <acquire+0x50>
}
8010561f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105622:	c9                   	leave  
80105623:	c3                   	ret    
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105628:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010562c:	8d 51 34             	lea    0x34(%ecx),%edx
8010562f:	90                   	nop
    pcs[i] = 0;
80105630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105636:	83 c0 04             	add    $0x4,%eax
80105639:	39 c2                	cmp    %eax,%edx
8010563b:	75 f3                	jne    80105630 <acquire+0x80>
}
8010563d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105640:	c9                   	leave  
80105641:	c3                   	ret    
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105648:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010564b:	e8 d0 e9 ff ff       	call   80104020 <mycpu>
80105650:	39 c3                	cmp    %eax,%ebx
80105652:	0f 85 72 ff ff ff    	jne    801055ca <acquire+0x1a>
  popcli();
80105658:	e8 53 fe ff ff       	call   801054b0 <popcli>
    panic("acquire");
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	68 f1 8c 10 80       	push   $0x80108cf1
80105665:	e8 16 ad ff ff       	call   80100380 <panic>
8010566a:	66 90                	xchg   %ax,%ax
8010566c:	66 90                	xchg   %ax,%ax
8010566e:	66 90                	xchg   %ax,%ax

80105670 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	8b 55 08             	mov    0x8(%ebp),%edx
80105677:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010567a:	53                   	push   %ebx
8010567b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010567e:	89 d7                	mov    %edx,%edi
80105680:	09 cf                	or     %ecx,%edi
80105682:	83 e7 03             	and    $0x3,%edi
80105685:	75 29                	jne    801056b0 <memset+0x40>
    c &= 0xFF;
80105687:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010568a:	c1 e0 18             	shl    $0x18,%eax
8010568d:	89 fb                	mov    %edi,%ebx
8010568f:	c1 e9 02             	shr    $0x2,%ecx
80105692:	c1 e3 10             	shl    $0x10,%ebx
80105695:	09 d8                	or     %ebx,%eax
80105697:	09 f8                	or     %edi,%eax
80105699:	c1 e7 08             	shl    $0x8,%edi
8010569c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010569e:	89 d7                	mov    %edx,%edi
801056a0:	fc                   	cld    
801056a1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801056a3:	5b                   	pop    %ebx
801056a4:	89 d0                	mov    %edx,%eax
801056a6:	5f                   	pop    %edi
801056a7:	5d                   	pop    %ebp
801056a8:	c3                   	ret    
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801056b0:	89 d7                	mov    %edx,%edi
801056b2:	fc                   	cld    
801056b3:	f3 aa                	rep stos %al,%es:(%edi)
801056b5:	5b                   	pop    %ebx
801056b6:	89 d0                	mov    %edx,%eax
801056b8:	5f                   	pop    %edi
801056b9:	5d                   	pop    %ebp
801056ba:	c3                   	ret    
801056bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop

801056c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	8b 75 10             	mov    0x10(%ebp),%esi
801056c7:	8b 55 08             	mov    0x8(%ebp),%edx
801056ca:	53                   	push   %ebx
801056cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056ce:	85 f6                	test   %esi,%esi
801056d0:	74 2e                	je     80105700 <memcmp+0x40>
801056d2:	01 c6                	add    %eax,%esi
801056d4:	eb 14                	jmp    801056ea <memcmp+0x2a>
801056d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801056e0:	83 c0 01             	add    $0x1,%eax
801056e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801056e6:	39 f0                	cmp    %esi,%eax
801056e8:	74 16                	je     80105700 <memcmp+0x40>
    if(*s1 != *s2)
801056ea:	0f b6 0a             	movzbl (%edx),%ecx
801056ed:	0f b6 18             	movzbl (%eax),%ebx
801056f0:	38 d9                	cmp    %bl,%cl
801056f2:	74 ec                	je     801056e0 <memcmp+0x20>
      return *s1 - *s2;
801056f4:	0f b6 c1             	movzbl %cl,%eax
801056f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801056f9:	5b                   	pop    %ebx
801056fa:	5e                   	pop    %esi
801056fb:	5d                   	pop    %ebp
801056fc:	c3                   	ret    
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
80105700:	5b                   	pop    %ebx
  return 0;
80105701:	31 c0                	xor    %eax,%eax
}
80105703:	5e                   	pop    %esi
80105704:	5d                   	pop    %ebp
80105705:	c3                   	ret    
80105706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570d:	8d 76 00             	lea    0x0(%esi),%esi

80105710 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	8b 55 08             	mov    0x8(%ebp),%edx
80105717:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010571a:	56                   	push   %esi
8010571b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010571e:	39 d6                	cmp    %edx,%esi
80105720:	73 26                	jae    80105748 <memmove+0x38>
80105722:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105725:	39 fa                	cmp    %edi,%edx
80105727:	73 1f                	jae    80105748 <memmove+0x38>
80105729:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010572c:	85 c9                	test   %ecx,%ecx
8010572e:	74 0c                	je     8010573c <memmove+0x2c>
      *--d = *--s;
80105730:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105734:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105737:	83 e8 01             	sub    $0x1,%eax
8010573a:	73 f4                	jae    80105730 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010573c:	5e                   	pop    %esi
8010573d:	89 d0                	mov    %edx,%eax
8010573f:	5f                   	pop    %edi
80105740:	5d                   	pop    %ebp
80105741:	c3                   	ret    
80105742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105748:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010574b:	89 d7                	mov    %edx,%edi
8010574d:	85 c9                	test   %ecx,%ecx
8010574f:	74 eb                	je     8010573c <memmove+0x2c>
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105758:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105759:	39 c6                	cmp    %eax,%esi
8010575b:	75 fb                	jne    80105758 <memmove+0x48>
}
8010575d:	5e                   	pop    %esi
8010575e:	89 d0                	mov    %edx,%eax
80105760:	5f                   	pop    %edi
80105761:	5d                   	pop    %ebp
80105762:	c3                   	ret    
80105763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105770 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105770:	eb 9e                	jmp    80105710 <memmove>
80105772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105780 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	56                   	push   %esi
80105784:	8b 75 10             	mov    0x10(%ebp),%esi
80105787:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010578a:	53                   	push   %ebx
8010578b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010578e:	85 f6                	test   %esi,%esi
80105790:	74 2e                	je     801057c0 <strncmp+0x40>
80105792:	01 d6                	add    %edx,%esi
80105794:	eb 18                	jmp    801057ae <strncmp+0x2e>
80105796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
801057a0:	38 d8                	cmp    %bl,%al
801057a2:	75 14                	jne    801057b8 <strncmp+0x38>
    n--, p++, q++;
801057a4:	83 c2 01             	add    $0x1,%edx
801057a7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801057aa:	39 f2                	cmp    %esi,%edx
801057ac:	74 12                	je     801057c0 <strncmp+0x40>
801057ae:	0f b6 01             	movzbl (%ecx),%eax
801057b1:	0f b6 1a             	movzbl (%edx),%ebx
801057b4:	84 c0                	test   %al,%al
801057b6:	75 e8                	jne    801057a0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801057b8:	29 d8                	sub    %ebx,%eax
}
801057ba:	5b                   	pop    %ebx
801057bb:	5e                   	pop    %esi
801057bc:	5d                   	pop    %ebp
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
801057c0:	5b                   	pop    %ebx
    return 0;
801057c1:	31 c0                	xor    %eax,%eax
}
801057c3:	5e                   	pop    %esi
801057c4:	5d                   	pop    %ebp
801057c5:	c3                   	ret    
801057c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cd:	8d 76 00             	lea    0x0(%esi),%esi

801057d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	8b 75 08             	mov    0x8(%ebp),%esi
801057d8:	53                   	push   %ebx
801057d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801057dc:	89 f0                	mov    %esi,%eax
801057de:	eb 15                	jmp    801057f5 <strncpy+0x25>
801057e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801057e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801057e7:	83 c0 01             	add    $0x1,%eax
801057ea:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801057ee:	88 50 ff             	mov    %dl,-0x1(%eax)
801057f1:	84 d2                	test   %dl,%dl
801057f3:	74 09                	je     801057fe <strncpy+0x2e>
801057f5:	89 cb                	mov    %ecx,%ebx
801057f7:	83 e9 01             	sub    $0x1,%ecx
801057fa:	85 db                	test   %ebx,%ebx
801057fc:	7f e2                	jg     801057e0 <strncpy+0x10>
    ;
  while(n-- > 0)
801057fe:	89 c2                	mov    %eax,%edx
80105800:	85 c9                	test   %ecx,%ecx
80105802:	7e 17                	jle    8010581b <strncpy+0x4b>
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105808:	83 c2 01             	add    $0x1,%edx
8010580b:	89 c1                	mov    %eax,%ecx
8010580d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105811:	29 d1                	sub    %edx,%ecx
80105813:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105817:	85 c9                	test   %ecx,%ecx
80105819:	7f ed                	jg     80105808 <strncpy+0x38>
  return os;
}
8010581b:	5b                   	pop    %ebx
8010581c:	89 f0                	mov    %esi,%eax
8010581e:	5e                   	pop    %esi
8010581f:	5f                   	pop    %edi
80105820:	5d                   	pop    %ebp
80105821:	c3                   	ret    
80105822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105830 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	56                   	push   %esi
80105834:	8b 55 10             	mov    0x10(%ebp),%edx
80105837:	8b 75 08             	mov    0x8(%ebp),%esi
8010583a:	53                   	push   %ebx
8010583b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010583e:	85 d2                	test   %edx,%edx
80105840:	7e 25                	jle    80105867 <safestrcpy+0x37>
80105842:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105846:	89 f2                	mov    %esi,%edx
80105848:	eb 16                	jmp    80105860 <safestrcpy+0x30>
8010584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105850:	0f b6 08             	movzbl (%eax),%ecx
80105853:	83 c0 01             	add    $0x1,%eax
80105856:	83 c2 01             	add    $0x1,%edx
80105859:	88 4a ff             	mov    %cl,-0x1(%edx)
8010585c:	84 c9                	test   %cl,%cl
8010585e:	74 04                	je     80105864 <safestrcpy+0x34>
80105860:	39 d8                	cmp    %ebx,%eax
80105862:	75 ec                	jne    80105850 <safestrcpy+0x20>
    ;
  *s = 0;
80105864:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105867:	89 f0                	mov    %esi,%eax
80105869:	5b                   	pop    %ebx
8010586a:	5e                   	pop    %esi
8010586b:	5d                   	pop    %ebp
8010586c:	c3                   	ret    
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <strlen>:

int
strlen(const char *s)
{
80105870:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105871:	31 c0                	xor    %eax,%eax
{
80105873:	89 e5                	mov    %esp,%ebp
80105875:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105878:	80 3a 00             	cmpb   $0x0,(%edx)
8010587b:	74 0c                	je     80105889 <strlen+0x19>
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
80105880:	83 c0 01             	add    $0x1,%eax
80105883:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105887:	75 f7                	jne    80105880 <strlen+0x10>
    ;
  return n;
}
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    

8010588b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010588b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010588f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105893:	55                   	push   %ebp
  pushl %ebx
80105894:	53                   	push   %ebx
  pushl %esi
80105895:	56                   	push   %esi
  pushl %edi
80105896:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105897:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105899:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010589b:	5f                   	pop    %edi
  popl %esi
8010589c:	5e                   	pop    %esi
  popl %ebx
8010589d:	5b                   	pop    %ebx
  popl %ebp
8010589e:	5d                   	pop    %ebp
  ret
8010589f:	c3                   	ret    

801058a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 04             	sub    $0x4,%esp
801058a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801058aa:	e8 f1 e7 ff ff       	call   801040a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801058af:	8b 00                	mov    (%eax),%eax
801058b1:	39 d8                	cmp    %ebx,%eax
801058b3:	76 1b                	jbe    801058d0 <fetchint+0x30>
801058b5:	8d 53 04             	lea    0x4(%ebx),%edx
801058b8:	39 d0                	cmp    %edx,%eax
801058ba:	72 14                	jb     801058d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801058bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801058bf:	8b 13                	mov    (%ebx),%edx
801058c1:	89 10                	mov    %edx,(%eax)
  return 0;
801058c3:	31 c0                	xor    %eax,%eax
}
801058c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c8:	c9                   	leave  
801058c9:	c3                   	ret    
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d5:	eb ee                	jmp    801058c5 <fetchint+0x25>
801058d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058de:	66 90                	xchg   %ax,%ax

801058e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
801058e4:	83 ec 04             	sub    $0x4,%esp
801058e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801058ea:	e8 b1 e7 ff ff       	call   801040a0 <myproc>

  if(addr >= curproc->sz)
801058ef:	39 18                	cmp    %ebx,(%eax)
801058f1:	76 2d                	jbe    80105920 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801058f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801058f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801058f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801058fa:	39 d3                	cmp    %edx,%ebx
801058fc:	73 22                	jae    80105920 <fetchstr+0x40>
801058fe:	89 d8                	mov    %ebx,%eax
80105900:	eb 0d                	jmp    8010590f <fetchstr+0x2f>
80105902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105908:	83 c0 01             	add    $0x1,%eax
8010590b:	39 c2                	cmp    %eax,%edx
8010590d:	76 11                	jbe    80105920 <fetchstr+0x40>
    if(*s == 0)
8010590f:	80 38 00             	cmpb   $0x0,(%eax)
80105912:	75 f4                	jne    80105908 <fetchstr+0x28>
      return s - *pp;
80105914:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105919:	c9                   	leave  
8010591a:	c3                   	ret    
8010591b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
80105920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105928:	c9                   	leave  
80105929:	c3                   	ret    
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105930 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	56                   	push   %esi
80105934:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105935:	e8 66 e7 ff ff       	call   801040a0 <myproc>
8010593a:	8b 55 08             	mov    0x8(%ebp),%edx
8010593d:	8b 40 18             	mov    0x18(%eax),%eax
80105940:	8b 40 44             	mov    0x44(%eax),%eax
80105943:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105946:	e8 55 e7 ff ff       	call   801040a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010594b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010594e:	8b 00                	mov    (%eax),%eax
80105950:	39 c6                	cmp    %eax,%esi
80105952:	73 1c                	jae    80105970 <argint+0x40>
80105954:	8d 53 08             	lea    0x8(%ebx),%edx
80105957:	39 d0                	cmp    %edx,%eax
80105959:	72 15                	jb     80105970 <argint+0x40>
  *ip = *(int*)(addr);
8010595b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010595e:	8b 53 04             	mov    0x4(%ebx),%edx
80105961:	89 10                	mov    %edx,(%eax)
  return 0;
80105963:	31 c0                	xor    %eax,%eax
}
80105965:	5b                   	pop    %ebx
80105966:	5e                   	pop    %esi
80105967:	5d                   	pop    %ebp
80105968:	c3                   	ret    
80105969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105975:	eb ee                	jmp    80105965 <argint+0x35>
80105977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597e:	66 90                	xchg   %ax,%ax

80105980 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
80105985:	53                   	push   %ebx
80105986:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105989:	e8 12 e7 ff ff       	call   801040a0 <myproc>
8010598e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105990:	e8 0b e7 ff ff       	call   801040a0 <myproc>
80105995:	8b 55 08             	mov    0x8(%ebp),%edx
80105998:	8b 40 18             	mov    0x18(%eax),%eax
8010599b:	8b 40 44             	mov    0x44(%eax),%eax
8010599e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801059a1:	e8 fa e6 ff ff       	call   801040a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059a6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801059a9:	8b 00                	mov    (%eax),%eax
801059ab:	39 c7                	cmp    %eax,%edi
801059ad:	73 31                	jae    801059e0 <argptr+0x60>
801059af:	8d 4b 08             	lea    0x8(%ebx),%ecx
801059b2:	39 c8                	cmp    %ecx,%eax
801059b4:	72 2a                	jb     801059e0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801059b6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801059b9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801059bc:	85 d2                	test   %edx,%edx
801059be:	78 20                	js     801059e0 <argptr+0x60>
801059c0:	8b 16                	mov    (%esi),%edx
801059c2:	39 c2                	cmp    %eax,%edx
801059c4:	76 1a                	jbe    801059e0 <argptr+0x60>
801059c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801059c9:	01 c3                	add    %eax,%ebx
801059cb:	39 da                	cmp    %ebx,%edx
801059cd:	72 11                	jb     801059e0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801059cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801059d2:	89 02                	mov    %eax,(%edx)
  return 0;
801059d4:	31 c0                	xor    %eax,%eax
}
801059d6:	83 c4 0c             	add    $0xc,%esp
801059d9:	5b                   	pop    %ebx
801059da:	5e                   	pop    %esi
801059db:	5f                   	pop    %edi
801059dc:	5d                   	pop    %ebp
801059dd:	c3                   	ret    
801059de:	66 90                	xchg   %ax,%ax
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e5:	eb ef                	jmp    801059d6 <argptr+0x56>
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	56                   	push   %esi
801059f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059f5:	e8 a6 e6 ff ff       	call   801040a0 <myproc>
801059fa:	8b 55 08             	mov    0x8(%ebp),%edx
801059fd:	8b 40 18             	mov    0x18(%eax),%eax
80105a00:	8b 40 44             	mov    0x44(%eax),%eax
80105a03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105a06:	e8 95 e6 ff ff       	call   801040a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105a0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a0e:	8b 00                	mov    (%eax),%eax
80105a10:	39 c6                	cmp    %eax,%esi
80105a12:	73 44                	jae    80105a58 <argstr+0x68>
80105a14:	8d 53 08             	lea    0x8(%ebx),%edx
80105a17:	39 d0                	cmp    %edx,%eax
80105a19:	72 3d                	jb     80105a58 <argstr+0x68>
  *ip = *(int*)(addr);
80105a1b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105a1e:	e8 7d e6 ff ff       	call   801040a0 <myproc>
  if(addr >= curproc->sz)
80105a23:	3b 18                	cmp    (%eax),%ebx
80105a25:	73 31                	jae    80105a58 <argstr+0x68>
  *pp = (char*)addr;
80105a27:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105a2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105a2e:	39 d3                	cmp    %edx,%ebx
80105a30:	73 26                	jae    80105a58 <argstr+0x68>
80105a32:	89 d8                	mov    %ebx,%eax
80105a34:	eb 11                	jmp    80105a47 <argstr+0x57>
80105a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
80105a40:	83 c0 01             	add    $0x1,%eax
80105a43:	39 c2                	cmp    %eax,%edx
80105a45:	76 11                	jbe    80105a58 <argstr+0x68>
    if(*s == 0)
80105a47:	80 38 00             	cmpb   $0x0,(%eax)
80105a4a:	75 f4                	jne    80105a40 <argstr+0x50>
      return s - *pp;
80105a4c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105a4e:	5b                   	pop    %ebx
80105a4f:	5e                   	pop    %esi
80105a50:	5d                   	pop    %ebp
80105a51:	c3                   	ret    
80105a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a58:	5b                   	pop    %ebx
    return -1;
80105a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a5e:	5e                   	pop    %esi
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop

80105a70 <syscall>:

};

void
syscall(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
80105a74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105a77:	e8 24 e6 ff ff       	call   801040a0 <myproc>
80105a7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105a7e:	8b 40 18             	mov    0x18(%eax),%eax
80105a81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a84:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a87:	83 fa 1b             	cmp    $0x1b,%edx
80105a8a:	77 24                	ja     80105ab0 <syscall+0x40>
80105a8c:	8b 14 85 20 8d 10 80 	mov    -0x7fef72e0(,%eax,4),%edx
80105a93:	85 d2                	test   %edx,%edx
80105a95:	74 19                	je     80105ab0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105a97:	ff d2                	call   *%edx
80105a99:	89 c2                	mov    %eax,%edx
80105a9b:	8b 43 18             	mov    0x18(%ebx),%eax
80105a9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa4:	c9                   	leave  
80105aa5:	c3                   	ret    
80105aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105ab0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105ab1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105ab4:	50                   	push   %eax
80105ab5:	ff 73 10             	push   0x10(%ebx)
80105ab8:	68 f9 8c 10 80       	push   $0x80108cf9
80105abd:	e8 de ab ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105ac2:	8b 43 18             	mov    0x18(%ebx),%eax
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad2:	c9                   	leave  
80105ad3:	c3                   	ret    
80105ad4:	66 90                	xchg   %ax,%ax
80105ad6:	66 90                	xchg   %ax,%ax
80105ad8:	66 90                	xchg   %ax,%ax
80105ada:	66 90                	xchg   %ax,%ax
80105adc:	66 90                	xchg   %ax,%ax
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ae5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105ae8:	53                   	push   %ebx
80105ae9:	83 ec 34             	sub    $0x34,%esp
80105aec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105af2:	57                   	push   %edi
80105af3:	50                   	push   %eax
{
80105af4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105af7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105afa:	e8 21 cc ff ff       	call   80102720 <nameiparent>
80105aff:	83 c4 10             	add    $0x10,%esp
80105b02:	85 c0                	test   %eax,%eax
80105b04:	0f 84 46 01 00 00    	je     80105c50 <create+0x170>
    return 0;
  ilock(dp);
80105b0a:	83 ec 0c             	sub    $0xc,%esp
80105b0d:	89 c3                	mov    %eax,%ebx
80105b0f:	50                   	push   %eax
80105b10:	e8 cb c2 ff ff       	call   80101de0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105b15:	83 c4 0c             	add    $0xc,%esp
80105b18:	6a 00                	push   $0x0
80105b1a:	57                   	push   %edi
80105b1b:	53                   	push   %ebx
80105b1c:	e8 1f c8 ff ff       	call   80102340 <dirlookup>
80105b21:	83 c4 10             	add    $0x10,%esp
80105b24:	89 c6                	mov    %eax,%esi
80105b26:	85 c0                	test   %eax,%eax
80105b28:	74 56                	je     80105b80 <create+0xa0>
    iunlockput(dp);
80105b2a:	83 ec 0c             	sub    $0xc,%esp
80105b2d:	53                   	push   %ebx
80105b2e:	e8 3d c5 ff ff       	call   80102070 <iunlockput>
    ilock(ip);
80105b33:	89 34 24             	mov    %esi,(%esp)
80105b36:	e8 a5 c2 ff ff       	call   80101de0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105b43:	75 1b                	jne    80105b60 <create+0x80>
80105b45:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105b4a:	75 14                	jne    80105b60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b4f:	89 f0                	mov    %esi,%eax
80105b51:	5b                   	pop    %ebx
80105b52:	5e                   	pop    %esi
80105b53:	5f                   	pop    %edi
80105b54:	5d                   	pop    %ebp
80105b55:	c3                   	ret    
80105b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	56                   	push   %esi
    return 0;
80105b64:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105b66:	e8 05 c5 ff ff       	call   80102070 <iunlockput>
    return 0;
80105b6b:	83 c4 10             	add    $0x10,%esp
}
80105b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b71:	89 f0                	mov    %esi,%eax
80105b73:	5b                   	pop    %ebx
80105b74:	5e                   	pop    %esi
80105b75:	5f                   	pop    %edi
80105b76:	5d                   	pop    %ebp
80105b77:	c3                   	ret    
80105b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105b80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105b84:	83 ec 08             	sub    $0x8,%esp
80105b87:	50                   	push   %eax
80105b88:	ff 33                	push   (%ebx)
80105b8a:	e8 e1 c0 ff ff       	call   80101c70 <ialloc>
80105b8f:	83 c4 10             	add    $0x10,%esp
80105b92:	89 c6                	mov    %eax,%esi
80105b94:	85 c0                	test   %eax,%eax
80105b96:	0f 84 cd 00 00 00    	je     80105c69 <create+0x189>
  ilock(ip);
80105b9c:	83 ec 0c             	sub    $0xc,%esp
80105b9f:	50                   	push   %eax
80105ba0:	e8 3b c2 ff ff       	call   80101de0 <ilock>
  ip->major = major;
80105ba5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105ba9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105bad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105bb1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105bb5:	b8 01 00 00 00       	mov    $0x1,%eax
80105bba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105bbe:	89 34 24             	mov    %esi,(%esp)
80105bc1:	e8 6a c1 ff ff       	call   80101d30 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105bc6:	83 c4 10             	add    $0x10,%esp
80105bc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105bce:	74 30                	je     80105c00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105bd0:	83 ec 04             	sub    $0x4,%esp
80105bd3:	ff 76 04             	push   0x4(%esi)
80105bd6:	57                   	push   %edi
80105bd7:	53                   	push   %ebx
80105bd8:	e8 63 ca ff ff       	call   80102640 <dirlink>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	85 c0                	test   %eax,%eax
80105be2:	78 78                	js     80105c5c <create+0x17c>
  iunlockput(dp);
80105be4:	83 ec 0c             	sub    $0xc,%esp
80105be7:	53                   	push   %ebx
80105be8:	e8 83 c4 ff ff       	call   80102070 <iunlockput>
  return ip;
80105bed:	83 c4 10             	add    $0x10,%esp
}
80105bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf3:	89 f0                	mov    %esi,%eax
80105bf5:	5b                   	pop    %ebx
80105bf6:	5e                   	pop    %esi
80105bf7:	5f                   	pop    %edi
80105bf8:	5d                   	pop    %ebp
80105bf9:	c3                   	ret    
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105c00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105c03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105c08:	53                   	push   %ebx
80105c09:	e8 22 c1 ff ff       	call   80101d30 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c0e:	83 c4 0c             	add    $0xc,%esp
80105c11:	ff 76 04             	push   0x4(%esi)
80105c14:	68 b0 8d 10 80       	push   $0x80108db0
80105c19:	56                   	push   %esi
80105c1a:	e8 21 ca ff ff       	call   80102640 <dirlink>
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	85 c0                	test   %eax,%eax
80105c24:	78 18                	js     80105c3e <create+0x15e>
80105c26:	83 ec 04             	sub    $0x4,%esp
80105c29:	ff 73 04             	push   0x4(%ebx)
80105c2c:	68 af 8d 10 80       	push   $0x80108daf
80105c31:	56                   	push   %esi
80105c32:	e8 09 ca ff ff       	call   80102640 <dirlink>
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	85 c0                	test   %eax,%eax
80105c3c:	79 92                	jns    80105bd0 <create+0xf0>
      panic("create dots");
80105c3e:	83 ec 0c             	sub    $0xc,%esp
80105c41:	68 a3 8d 10 80       	push   $0x80108da3
80105c46:	e8 35 a7 ff ff       	call   80100380 <panic>
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
}
80105c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105c53:	31 f6                	xor    %esi,%esi
}
80105c55:	5b                   	pop    %ebx
80105c56:	89 f0                	mov    %esi,%eax
80105c58:	5e                   	pop    %esi
80105c59:	5f                   	pop    %edi
80105c5a:	5d                   	pop    %ebp
80105c5b:	c3                   	ret    
    panic("create: dirlink");
80105c5c:	83 ec 0c             	sub    $0xc,%esp
80105c5f:	68 b2 8d 10 80       	push   $0x80108db2
80105c64:	e8 17 a7 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105c69:	83 ec 0c             	sub    $0xc,%esp
80105c6c:	68 94 8d 10 80       	push   $0x80108d94
80105c71:	e8 0a a7 ff ff       	call   80100380 <panic>
80105c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi

80105c80 <sys_dup>:
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	56                   	push   %esi
80105c84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105c8b:	50                   	push   %eax
80105c8c:	6a 00                	push   $0x0
80105c8e:	e8 9d fc ff ff       	call   80105930 <argint>
80105c93:	83 c4 10             	add    $0x10,%esp
80105c96:	85 c0                	test   %eax,%eax
80105c98:	78 36                	js     80105cd0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105c9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105c9e:	77 30                	ja     80105cd0 <sys_dup+0x50>
80105ca0:	e8 fb e3 ff ff       	call   801040a0 <myproc>
80105ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ca8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105cac:	85 f6                	test   %esi,%esi
80105cae:	74 20                	je     80105cd0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105cb0:	e8 eb e3 ff ff       	call   801040a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cb5:	31 db                	xor    %ebx,%ebx
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105cc0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105cc4:	85 d2                	test   %edx,%edx
80105cc6:	74 18                	je     80105ce0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105cc8:	83 c3 01             	add    $0x1,%ebx
80105ccb:	83 fb 10             	cmp    $0x10,%ebx
80105cce:	75 f0                	jne    80105cc0 <sys_dup+0x40>
}
80105cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105cd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105cd8:	89 d8                	mov    %ebx,%eax
80105cda:	5b                   	pop    %ebx
80105cdb:	5e                   	pop    %esi
80105cdc:	5d                   	pop    %ebp
80105cdd:	c3                   	ret    
80105cde:	66 90                	xchg   %ax,%ax
  filedup(f);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ce3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105ce7:	56                   	push   %esi
80105ce8:	e8 13 b8 ff ff       	call   80101500 <filedup>
  return fd;
80105ced:	83 c4 10             	add    $0x10,%esp
}
80105cf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cf3:	89 d8                	mov    %ebx,%eax
80105cf5:	5b                   	pop    %ebx
80105cf6:	5e                   	pop    %esi
80105cf7:	5d                   	pop    %ebp
80105cf8:	c3                   	ret    
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_read>:
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	56                   	push   %esi
80105d04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105d05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105d08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105d0b:	53                   	push   %ebx
80105d0c:	6a 00                	push   $0x0
80105d0e:	e8 1d fc ff ff       	call   80105930 <argint>
80105d13:	83 c4 10             	add    $0x10,%esp
80105d16:	85 c0                	test   %eax,%eax
80105d18:	78 5e                	js     80105d78 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105d1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d1e:	77 58                	ja     80105d78 <sys_read+0x78>
80105d20:	e8 7b e3 ff ff       	call   801040a0 <myproc>
80105d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105d2c:	85 f6                	test   %esi,%esi
80105d2e:	74 48                	je     80105d78 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d30:	83 ec 08             	sub    $0x8,%esp
80105d33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d36:	50                   	push   %eax
80105d37:	6a 02                	push   $0x2
80105d39:	e8 f2 fb ff ff       	call   80105930 <argint>
80105d3e:	83 c4 10             	add    $0x10,%esp
80105d41:	85 c0                	test   %eax,%eax
80105d43:	78 33                	js     80105d78 <sys_read+0x78>
80105d45:	83 ec 04             	sub    $0x4,%esp
80105d48:	ff 75 f0             	push   -0x10(%ebp)
80105d4b:	53                   	push   %ebx
80105d4c:	6a 01                	push   $0x1
80105d4e:	e8 2d fc ff ff       	call   80105980 <argptr>
80105d53:	83 c4 10             	add    $0x10,%esp
80105d56:	85 c0                	test   %eax,%eax
80105d58:	78 1e                	js     80105d78 <sys_read+0x78>
  return fileread(f, p, n);
80105d5a:	83 ec 04             	sub    $0x4,%esp
80105d5d:	ff 75 f0             	push   -0x10(%ebp)
80105d60:	ff 75 f4             	push   -0xc(%ebp)
80105d63:	56                   	push   %esi
80105d64:	e8 17 b9 ff ff       	call   80101680 <fileread>
80105d69:	83 c4 10             	add    $0x10,%esp
}
80105d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d6f:	5b                   	pop    %ebx
80105d70:	5e                   	pop    %esi
80105d71:	5d                   	pop    %ebp
80105d72:	c3                   	ret    
80105d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d77:	90                   	nop
    return -1;
80105d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7d:	eb ed                	jmp    80105d6c <sys_read+0x6c>
80105d7f:	90                   	nop

80105d80 <sys_write>:
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	56                   	push   %esi
80105d84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105d85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105d88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105d8b:	53                   	push   %ebx
80105d8c:	6a 00                	push   $0x0
80105d8e:	e8 9d fb ff ff       	call   80105930 <argint>
80105d93:	83 c4 10             	add    $0x10,%esp
80105d96:	85 c0                	test   %eax,%eax
80105d98:	78 5e                	js     80105df8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105d9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d9e:	77 58                	ja     80105df8 <sys_write+0x78>
80105da0:	e8 fb e2 ff ff       	call   801040a0 <myproc>
80105da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105da8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105dac:	85 f6                	test   %esi,%esi
80105dae:	74 48                	je     80105df8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105db0:	83 ec 08             	sub    $0x8,%esp
80105db3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db6:	50                   	push   %eax
80105db7:	6a 02                	push   $0x2
80105db9:	e8 72 fb ff ff       	call   80105930 <argint>
80105dbe:	83 c4 10             	add    $0x10,%esp
80105dc1:	85 c0                	test   %eax,%eax
80105dc3:	78 33                	js     80105df8 <sys_write+0x78>
80105dc5:	83 ec 04             	sub    $0x4,%esp
80105dc8:	ff 75 f0             	push   -0x10(%ebp)
80105dcb:	53                   	push   %ebx
80105dcc:	6a 01                	push   $0x1
80105dce:	e8 ad fb ff ff       	call   80105980 <argptr>
80105dd3:	83 c4 10             	add    $0x10,%esp
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	78 1e                	js     80105df8 <sys_write+0x78>
  return filewrite(f, p, n);
80105dda:	83 ec 04             	sub    $0x4,%esp
80105ddd:	ff 75 f0             	push   -0x10(%ebp)
80105de0:	ff 75 f4             	push   -0xc(%ebp)
80105de3:	56                   	push   %esi
80105de4:	e8 27 b9 ff ff       	call   80101710 <filewrite>
80105de9:	83 c4 10             	add    $0x10,%esp
}
80105dec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105def:	5b                   	pop    %ebx
80105df0:	5e                   	pop    %esi
80105df1:	5d                   	pop    %ebp
80105df2:	c3                   	ret    
80105df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105df7:	90                   	nop
    return -1;
80105df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfd:	eb ed                	jmp    80105dec <sys_write+0x6c>
80105dff:	90                   	nop

80105e00 <sys_close>:
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	56                   	push   %esi
80105e04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e0b:	50                   	push   %eax
80105e0c:	6a 00                	push   $0x0
80105e0e:	e8 1d fb ff ff       	call   80105930 <argint>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	85 c0                	test   %eax,%eax
80105e18:	78 3e                	js     80105e58 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105e1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e1e:	77 38                	ja     80105e58 <sys_close+0x58>
80105e20:	e8 7b e2 ff ff       	call   801040a0 <myproc>
80105e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e28:	8d 5a 08             	lea    0x8(%edx),%ebx
80105e2b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105e2f:	85 f6                	test   %esi,%esi
80105e31:	74 25                	je     80105e58 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105e33:	e8 68 e2 ff ff       	call   801040a0 <myproc>
  fileclose(f);
80105e38:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105e3b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105e42:	00 
  fileclose(f);
80105e43:	56                   	push   %esi
80105e44:	e8 07 b7 ff ff       	call   80101550 <fileclose>
  return 0;
80105e49:	83 c4 10             	add    $0x10,%esp
80105e4c:	31 c0                	xor    %eax,%eax
}
80105e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e51:	5b                   	pop    %ebx
80105e52:	5e                   	pop    %esi
80105e53:	5d                   	pop    %ebp
80105e54:	c3                   	ret    
80105e55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5d:	eb ef                	jmp    80105e4e <sys_close+0x4e>
80105e5f:	90                   	nop

80105e60 <sys_fstat>:
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	56                   	push   %esi
80105e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105e65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e6b:	53                   	push   %ebx
80105e6c:	6a 00                	push   $0x0
80105e6e:	e8 bd fa ff ff       	call   80105930 <argint>
80105e73:	83 c4 10             	add    $0x10,%esp
80105e76:	85 c0                	test   %eax,%eax
80105e78:	78 46                	js     80105ec0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e7e:	77 40                	ja     80105ec0 <sys_fstat+0x60>
80105e80:	e8 1b e2 ff ff       	call   801040a0 <myproc>
80105e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105e8c:	85 f6                	test   %esi,%esi
80105e8e:	74 30                	je     80105ec0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e90:	83 ec 04             	sub    $0x4,%esp
80105e93:	6a 14                	push   $0x14
80105e95:	53                   	push   %ebx
80105e96:	6a 01                	push   $0x1
80105e98:	e8 e3 fa ff ff       	call   80105980 <argptr>
80105e9d:	83 c4 10             	add    $0x10,%esp
80105ea0:	85 c0                	test   %eax,%eax
80105ea2:	78 1c                	js     80105ec0 <sys_fstat+0x60>
  return filestat(f, st);
80105ea4:	83 ec 08             	sub    $0x8,%esp
80105ea7:	ff 75 f4             	push   -0xc(%ebp)
80105eaa:	56                   	push   %esi
80105eab:	e8 80 b7 ff ff       	call   80101630 <filestat>
80105eb0:	83 c4 10             	add    $0x10,%esp
}
80105eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105eb6:	5b                   	pop    %ebx
80105eb7:	5e                   	pop    %esi
80105eb8:	5d                   	pop    %ebp
80105eb9:	c3                   	ret    
80105eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec5:	eb ec                	jmp    80105eb3 <sys_fstat+0x53>
80105ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <sys_link>:
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ed5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105ed8:	53                   	push   %ebx
80105ed9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105edc:	50                   	push   %eax
80105edd:	6a 00                	push   $0x0
80105edf:	e8 0c fb ff ff       	call   801059f0 <argstr>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 88 fb 00 00 00    	js     80105fea <sys_link+0x11a>
80105eef:	83 ec 08             	sub    $0x8,%esp
80105ef2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ef5:	50                   	push   %eax
80105ef6:	6a 01                	push   $0x1
80105ef8:	e8 f3 fa ff ff       	call   801059f0 <argstr>
80105efd:	83 c4 10             	add    $0x10,%esp
80105f00:	85 c0                	test   %eax,%eax
80105f02:	0f 88 e2 00 00 00    	js     80105fea <sys_link+0x11a>
  begin_op();
80105f08:	e8 b3 d4 ff ff       	call   801033c0 <begin_op>
  if((ip = namei(old)) == 0){
80105f0d:	83 ec 0c             	sub    $0xc,%esp
80105f10:	ff 75 d4             	push   -0x2c(%ebp)
80105f13:	e8 e8 c7 ff ff       	call   80102700 <namei>
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	89 c3                	mov    %eax,%ebx
80105f1d:	85 c0                	test   %eax,%eax
80105f1f:	0f 84 e4 00 00 00    	je     80106009 <sys_link+0x139>
  ilock(ip);
80105f25:	83 ec 0c             	sub    $0xc,%esp
80105f28:	50                   	push   %eax
80105f29:	e8 b2 be ff ff       	call   80101de0 <ilock>
  if(ip->type == T_DIR){
80105f2e:	83 c4 10             	add    $0x10,%esp
80105f31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f36:	0f 84 b5 00 00 00    	je     80105ff1 <sys_link+0x121>
  iupdate(ip);
80105f3c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105f3f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105f44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105f47:	53                   	push   %ebx
80105f48:	e8 e3 bd ff ff       	call   80101d30 <iupdate>
  iunlock(ip);
80105f4d:	89 1c 24             	mov    %ebx,(%esp)
80105f50:	e8 6b bf ff ff       	call   80101ec0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105f55:	58                   	pop    %eax
80105f56:	5a                   	pop    %edx
80105f57:	57                   	push   %edi
80105f58:	ff 75 d0             	push   -0x30(%ebp)
80105f5b:	e8 c0 c7 ff ff       	call   80102720 <nameiparent>
80105f60:	83 c4 10             	add    $0x10,%esp
80105f63:	89 c6                	mov    %eax,%esi
80105f65:	85 c0                	test   %eax,%eax
80105f67:	74 5b                	je     80105fc4 <sys_link+0xf4>
  ilock(dp);
80105f69:	83 ec 0c             	sub    $0xc,%esp
80105f6c:	50                   	push   %eax
80105f6d:	e8 6e be ff ff       	call   80101de0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f72:	8b 03                	mov    (%ebx),%eax
80105f74:	83 c4 10             	add    $0x10,%esp
80105f77:	39 06                	cmp    %eax,(%esi)
80105f79:	75 3d                	jne    80105fb8 <sys_link+0xe8>
80105f7b:	83 ec 04             	sub    $0x4,%esp
80105f7e:	ff 73 04             	push   0x4(%ebx)
80105f81:	57                   	push   %edi
80105f82:	56                   	push   %esi
80105f83:	e8 b8 c6 ff ff       	call   80102640 <dirlink>
80105f88:	83 c4 10             	add    $0x10,%esp
80105f8b:	85 c0                	test   %eax,%eax
80105f8d:	78 29                	js     80105fb8 <sys_link+0xe8>
  iunlockput(dp);
80105f8f:	83 ec 0c             	sub    $0xc,%esp
80105f92:	56                   	push   %esi
80105f93:	e8 d8 c0 ff ff       	call   80102070 <iunlockput>
  iput(ip);
80105f98:	89 1c 24             	mov    %ebx,(%esp)
80105f9b:	e8 70 bf ff ff       	call   80101f10 <iput>
  end_op();
80105fa0:	e8 8b d4 ff ff       	call   80103430 <end_op>
  return 0;
80105fa5:	83 c4 10             	add    $0x10,%esp
80105fa8:	31 c0                	xor    %eax,%eax
}
80105faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fad:	5b                   	pop    %ebx
80105fae:	5e                   	pop    %esi
80105faf:	5f                   	pop    %edi
80105fb0:	5d                   	pop    %ebp
80105fb1:	c3                   	ret    
80105fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105fb8:	83 ec 0c             	sub    $0xc,%esp
80105fbb:	56                   	push   %esi
80105fbc:	e8 af c0 ff ff       	call   80102070 <iunlockput>
    goto bad;
80105fc1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105fc4:	83 ec 0c             	sub    $0xc,%esp
80105fc7:	53                   	push   %ebx
80105fc8:	e8 13 be ff ff       	call   80101de0 <ilock>
  ip->nlink--;
80105fcd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105fd2:	89 1c 24             	mov    %ebx,(%esp)
80105fd5:	e8 56 bd ff ff       	call   80101d30 <iupdate>
  iunlockput(ip);
80105fda:	89 1c 24             	mov    %ebx,(%esp)
80105fdd:	e8 8e c0 ff ff       	call   80102070 <iunlockput>
  end_op();
80105fe2:	e8 49 d4 ff ff       	call   80103430 <end_op>
  return -1;
80105fe7:	83 c4 10             	add    $0x10,%esp
80105fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fef:	eb b9                	jmp    80105faa <sys_link+0xda>
    iunlockput(ip);
80105ff1:	83 ec 0c             	sub    $0xc,%esp
80105ff4:	53                   	push   %ebx
80105ff5:	e8 76 c0 ff ff       	call   80102070 <iunlockput>
    end_op();
80105ffa:	e8 31 d4 ff ff       	call   80103430 <end_op>
    return -1;
80105fff:	83 c4 10             	add    $0x10,%esp
80106002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106007:	eb a1                	jmp    80105faa <sys_link+0xda>
    end_op();
80106009:	e8 22 d4 ff ff       	call   80103430 <end_op>
    return -1;
8010600e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106013:	eb 95                	jmp    80105faa <sys_link+0xda>
80106015:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_unlink>:
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	57                   	push   %edi
80106024:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106025:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106028:	53                   	push   %ebx
80106029:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010602c:	50                   	push   %eax
8010602d:	6a 00                	push   $0x0
8010602f:	e8 bc f9 ff ff       	call   801059f0 <argstr>
80106034:	83 c4 10             	add    $0x10,%esp
80106037:	85 c0                	test   %eax,%eax
80106039:	0f 88 7a 01 00 00    	js     801061b9 <sys_unlink+0x199>
  begin_op();
8010603f:	e8 7c d3 ff ff       	call   801033c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106044:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106047:	83 ec 08             	sub    $0x8,%esp
8010604a:	53                   	push   %ebx
8010604b:	ff 75 c0             	push   -0x40(%ebp)
8010604e:	e8 cd c6 ff ff       	call   80102720 <nameiparent>
80106053:	83 c4 10             	add    $0x10,%esp
80106056:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106059:	85 c0                	test   %eax,%eax
8010605b:	0f 84 62 01 00 00    	je     801061c3 <sys_unlink+0x1a3>
  ilock(dp);
80106061:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106064:	83 ec 0c             	sub    $0xc,%esp
80106067:	57                   	push   %edi
80106068:	e8 73 bd ff ff       	call   80101de0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010606d:	58                   	pop    %eax
8010606e:	5a                   	pop    %edx
8010606f:	68 b0 8d 10 80       	push   $0x80108db0
80106074:	53                   	push   %ebx
80106075:	e8 a6 c2 ff ff       	call   80102320 <namecmp>
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	85 c0                	test   %eax,%eax
8010607f:	0f 84 fb 00 00 00    	je     80106180 <sys_unlink+0x160>
80106085:	83 ec 08             	sub    $0x8,%esp
80106088:	68 af 8d 10 80       	push   $0x80108daf
8010608d:	53                   	push   %ebx
8010608e:	e8 8d c2 ff ff       	call   80102320 <namecmp>
80106093:	83 c4 10             	add    $0x10,%esp
80106096:	85 c0                	test   %eax,%eax
80106098:	0f 84 e2 00 00 00    	je     80106180 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010609e:	83 ec 04             	sub    $0x4,%esp
801060a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801060a4:	50                   	push   %eax
801060a5:	53                   	push   %ebx
801060a6:	57                   	push   %edi
801060a7:	e8 94 c2 ff ff       	call   80102340 <dirlookup>
801060ac:	83 c4 10             	add    $0x10,%esp
801060af:	89 c3                	mov    %eax,%ebx
801060b1:	85 c0                	test   %eax,%eax
801060b3:	0f 84 c7 00 00 00    	je     80106180 <sys_unlink+0x160>
  ilock(ip);
801060b9:	83 ec 0c             	sub    $0xc,%esp
801060bc:	50                   	push   %eax
801060bd:	e8 1e bd ff ff       	call   80101de0 <ilock>
  if(ip->nlink < 1)
801060c2:	83 c4 10             	add    $0x10,%esp
801060c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801060ca:	0f 8e 1c 01 00 00    	jle    801061ec <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801060d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801060d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801060d8:	74 66                	je     80106140 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801060da:	83 ec 04             	sub    $0x4,%esp
801060dd:	6a 10                	push   $0x10
801060df:	6a 00                	push   $0x0
801060e1:	57                   	push   %edi
801060e2:	e8 89 f5 ff ff       	call   80105670 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060e7:	6a 10                	push   $0x10
801060e9:	ff 75 c4             	push   -0x3c(%ebp)
801060ec:	57                   	push   %edi
801060ed:	ff 75 b4             	push   -0x4c(%ebp)
801060f0:	e8 fb c0 ff ff       	call   801021f0 <writei>
801060f5:	83 c4 20             	add    $0x20,%esp
801060f8:	83 f8 10             	cmp    $0x10,%eax
801060fb:	0f 85 de 00 00 00    	jne    801061df <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106106:	0f 84 94 00 00 00    	je     801061a0 <sys_unlink+0x180>
  iunlockput(dp);
8010610c:	83 ec 0c             	sub    $0xc,%esp
8010610f:	ff 75 b4             	push   -0x4c(%ebp)
80106112:	e8 59 bf ff ff       	call   80102070 <iunlockput>
  ip->nlink--;
80106117:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010611c:	89 1c 24             	mov    %ebx,(%esp)
8010611f:	e8 0c bc ff ff       	call   80101d30 <iupdate>
  iunlockput(ip);
80106124:	89 1c 24             	mov    %ebx,(%esp)
80106127:	e8 44 bf ff ff       	call   80102070 <iunlockput>
  end_op();
8010612c:	e8 ff d2 ff ff       	call   80103430 <end_op>
  return 0;
80106131:	83 c4 10             	add    $0x10,%esp
80106134:	31 c0                	xor    %eax,%eax
}
80106136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106139:	5b                   	pop    %ebx
8010613a:	5e                   	pop    %esi
8010613b:	5f                   	pop    %edi
8010613c:	5d                   	pop    %ebp
8010613d:	c3                   	ret    
8010613e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106140:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106144:	76 94                	jbe    801060da <sys_unlink+0xba>
80106146:	be 20 00 00 00       	mov    $0x20,%esi
8010614b:	eb 0b                	jmp    80106158 <sys_unlink+0x138>
8010614d:	8d 76 00             	lea    0x0(%esi),%esi
80106150:	83 c6 10             	add    $0x10,%esi
80106153:	3b 73 58             	cmp    0x58(%ebx),%esi
80106156:	73 82                	jae    801060da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106158:	6a 10                	push   $0x10
8010615a:	56                   	push   %esi
8010615b:	57                   	push   %edi
8010615c:	53                   	push   %ebx
8010615d:	e8 8e bf ff ff       	call   801020f0 <readi>
80106162:	83 c4 10             	add    $0x10,%esp
80106165:	83 f8 10             	cmp    $0x10,%eax
80106168:	75 68                	jne    801061d2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010616a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010616f:	74 df                	je     80106150 <sys_unlink+0x130>
    iunlockput(ip);
80106171:	83 ec 0c             	sub    $0xc,%esp
80106174:	53                   	push   %ebx
80106175:	e8 f6 be ff ff       	call   80102070 <iunlockput>
    goto bad;
8010617a:	83 c4 10             	add    $0x10,%esp
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106180:	83 ec 0c             	sub    $0xc,%esp
80106183:	ff 75 b4             	push   -0x4c(%ebp)
80106186:	e8 e5 be ff ff       	call   80102070 <iunlockput>
  end_op();
8010618b:	e8 a0 d2 ff ff       	call   80103430 <end_op>
  return -1;
80106190:	83 c4 10             	add    $0x10,%esp
80106193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106198:	eb 9c                	jmp    80106136 <sys_unlink+0x116>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801061a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801061a3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801061a6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801061ab:	50                   	push   %eax
801061ac:	e8 7f bb ff ff       	call   80101d30 <iupdate>
801061b1:	83 c4 10             	add    $0x10,%esp
801061b4:	e9 53 ff ff ff       	jmp    8010610c <sys_unlink+0xec>
    return -1;
801061b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061be:	e9 73 ff ff ff       	jmp    80106136 <sys_unlink+0x116>
    end_op();
801061c3:	e8 68 d2 ff ff       	call   80103430 <end_op>
    return -1;
801061c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061cd:	e9 64 ff ff ff       	jmp    80106136 <sys_unlink+0x116>
      panic("isdirempty: readi");
801061d2:	83 ec 0c             	sub    $0xc,%esp
801061d5:	68 d4 8d 10 80       	push   $0x80108dd4
801061da:	e8 a1 a1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801061df:	83 ec 0c             	sub    $0xc,%esp
801061e2:	68 e6 8d 10 80       	push   $0x80108de6
801061e7:	e8 94 a1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801061ec:	83 ec 0c             	sub    $0xc,%esp
801061ef:	68 c2 8d 10 80       	push   $0x80108dc2
801061f4:	e8 87 a1 ff ff       	call   80100380 <panic>
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106200 <sys_open>:

int
sys_open(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	57                   	push   %edi
80106204:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106205:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106208:	53                   	push   %ebx
80106209:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010620c:	50                   	push   %eax
8010620d:	6a 00                	push   $0x0
8010620f:	e8 dc f7 ff ff       	call   801059f0 <argstr>
80106214:	83 c4 10             	add    $0x10,%esp
80106217:	85 c0                	test   %eax,%eax
80106219:	0f 88 8e 00 00 00    	js     801062ad <sys_open+0xad>
8010621f:	83 ec 08             	sub    $0x8,%esp
80106222:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106225:	50                   	push   %eax
80106226:	6a 01                	push   $0x1
80106228:	e8 03 f7 ff ff       	call   80105930 <argint>
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	85 c0                	test   %eax,%eax
80106232:	78 79                	js     801062ad <sys_open+0xad>
    return -1;

  begin_op();
80106234:	e8 87 d1 ff ff       	call   801033c0 <begin_op>

  if(omode & O_CREATE){
80106239:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010623d:	75 79                	jne    801062b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010623f:	83 ec 0c             	sub    $0xc,%esp
80106242:	ff 75 e0             	push   -0x20(%ebp)
80106245:	e8 b6 c4 ff ff       	call   80102700 <namei>
8010624a:	83 c4 10             	add    $0x10,%esp
8010624d:	89 c6                	mov    %eax,%esi
8010624f:	85 c0                	test   %eax,%eax
80106251:	0f 84 7e 00 00 00    	je     801062d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106257:	83 ec 0c             	sub    $0xc,%esp
8010625a:	50                   	push   %eax
8010625b:	e8 80 bb ff ff       	call   80101de0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106260:	83 c4 10             	add    $0x10,%esp
80106263:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106268:	0f 84 c2 00 00 00    	je     80106330 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010626e:	e8 1d b2 ff ff       	call   80101490 <filealloc>
80106273:	89 c7                	mov    %eax,%edi
80106275:	85 c0                	test   %eax,%eax
80106277:	74 23                	je     8010629c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106279:	e8 22 de ff ff       	call   801040a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010627e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106280:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106284:	85 d2                	test   %edx,%edx
80106286:	74 60                	je     801062e8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106288:	83 c3 01             	add    $0x1,%ebx
8010628b:	83 fb 10             	cmp    $0x10,%ebx
8010628e:	75 f0                	jne    80106280 <sys_open+0x80>
    if(f)
      fileclose(f);
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	57                   	push   %edi
80106294:	e8 b7 b2 ff ff       	call   80101550 <fileclose>
80106299:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010629c:	83 ec 0c             	sub    $0xc,%esp
8010629f:	56                   	push   %esi
801062a0:	e8 cb bd ff ff       	call   80102070 <iunlockput>
    end_op();
801062a5:	e8 86 d1 ff ff       	call   80103430 <end_op>
    return -1;
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062b2:	eb 6d                	jmp    80106321 <sys_open+0x121>
801062b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801062b8:	83 ec 0c             	sub    $0xc,%esp
801062bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801062be:	31 c9                	xor    %ecx,%ecx
801062c0:	ba 02 00 00 00       	mov    $0x2,%edx
801062c5:	6a 00                	push   $0x0
801062c7:	e8 14 f8 ff ff       	call   80105ae0 <create>
    if(ip == 0){
801062cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801062cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801062d1:	85 c0                	test   %eax,%eax
801062d3:	75 99                	jne    8010626e <sys_open+0x6e>
      end_op();
801062d5:	e8 56 d1 ff ff       	call   80103430 <end_op>
      return -1;
801062da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062df:	eb 40                	jmp    80106321 <sys_open+0x121>
801062e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801062e8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801062eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801062ef:	56                   	push   %esi
801062f0:	e8 cb bb ff ff       	call   80101ec0 <iunlock>
  end_op();
801062f5:	e8 36 d1 ff ff       	call   80103430 <end_op>

  f->type = FD_INODE;
801062fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106300:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106303:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106306:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106309:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010630b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106312:	f7 d0                	not    %eax
80106314:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106317:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010631a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010631d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106324:	89 d8                	mov    %ebx,%eax
80106326:	5b                   	pop    %ebx
80106327:	5e                   	pop    %esi
80106328:	5f                   	pop    %edi
80106329:	5d                   	pop    %ebp
8010632a:	c3                   	ret    
8010632b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010632f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106330:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106333:	85 c9                	test   %ecx,%ecx
80106335:	0f 84 33 ff ff ff    	je     8010626e <sys_open+0x6e>
8010633b:	e9 5c ff ff ff       	jmp    8010629c <sys_open+0x9c>

80106340 <sys_mkdir>:

int
sys_mkdir(void)
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106346:	e8 75 d0 ff ff       	call   801033c0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010634b:	83 ec 08             	sub    $0x8,%esp
8010634e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106351:	50                   	push   %eax
80106352:	6a 00                	push   $0x0
80106354:	e8 97 f6 ff ff       	call   801059f0 <argstr>
80106359:	83 c4 10             	add    $0x10,%esp
8010635c:	85 c0                	test   %eax,%eax
8010635e:	78 30                	js     80106390 <sys_mkdir+0x50>
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106366:	31 c9                	xor    %ecx,%ecx
80106368:	ba 01 00 00 00       	mov    $0x1,%edx
8010636d:	6a 00                	push   $0x0
8010636f:	e8 6c f7 ff ff       	call   80105ae0 <create>
80106374:	83 c4 10             	add    $0x10,%esp
80106377:	85 c0                	test   %eax,%eax
80106379:	74 15                	je     80106390 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010637b:	83 ec 0c             	sub    $0xc,%esp
8010637e:	50                   	push   %eax
8010637f:	e8 ec bc ff ff       	call   80102070 <iunlockput>
  end_op();
80106384:	e8 a7 d0 ff ff       	call   80103430 <end_op>
  return 0;
80106389:	83 c4 10             	add    $0x10,%esp
8010638c:	31 c0                	xor    %eax,%eax
}
8010638e:	c9                   	leave  
8010638f:	c3                   	ret    
    end_op();
80106390:	e8 9b d0 ff ff       	call   80103430 <end_op>
    return -1;
80106395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010639a:	c9                   	leave  
8010639b:	c3                   	ret    
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063a0 <sys_mknod>:

int
sys_mknod(void)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801063a6:	e8 15 d0 ff ff       	call   801033c0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801063ab:	83 ec 08             	sub    $0x8,%esp
801063ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063b1:	50                   	push   %eax
801063b2:	6a 00                	push   $0x0
801063b4:	e8 37 f6 ff ff       	call   801059f0 <argstr>
801063b9:	83 c4 10             	add    $0x10,%esp
801063bc:	85 c0                	test   %eax,%eax
801063be:	78 60                	js     80106420 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801063c0:	83 ec 08             	sub    $0x8,%esp
801063c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063c6:	50                   	push   %eax
801063c7:	6a 01                	push   $0x1
801063c9:	e8 62 f5 ff ff       	call   80105930 <argint>
  if((argstr(0, &path)) < 0 ||
801063ce:	83 c4 10             	add    $0x10,%esp
801063d1:	85 c0                	test   %eax,%eax
801063d3:	78 4b                	js     80106420 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801063d5:	83 ec 08             	sub    $0x8,%esp
801063d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063db:	50                   	push   %eax
801063dc:	6a 02                	push   $0x2
801063de:	e8 4d f5 ff ff       	call   80105930 <argint>
     argint(1, &major) < 0 ||
801063e3:	83 c4 10             	add    $0x10,%esp
801063e6:	85 c0                	test   %eax,%eax
801063e8:	78 36                	js     80106420 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801063ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801063ee:	83 ec 0c             	sub    $0xc,%esp
801063f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801063f5:	ba 03 00 00 00       	mov    $0x3,%edx
801063fa:	50                   	push   %eax
801063fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063fe:	e8 dd f6 ff ff       	call   80105ae0 <create>
     argint(2, &minor) < 0 ||
80106403:	83 c4 10             	add    $0x10,%esp
80106406:	85 c0                	test   %eax,%eax
80106408:	74 16                	je     80106420 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010640a:	83 ec 0c             	sub    $0xc,%esp
8010640d:	50                   	push   %eax
8010640e:	e8 5d bc ff ff       	call   80102070 <iunlockput>
  end_op();
80106413:	e8 18 d0 ff ff       	call   80103430 <end_op>
  return 0;
80106418:	83 c4 10             	add    $0x10,%esp
8010641b:	31 c0                	xor    %eax,%eax
}
8010641d:	c9                   	leave  
8010641e:	c3                   	ret    
8010641f:	90                   	nop
    end_op();
80106420:	e8 0b d0 ff ff       	call   80103430 <end_op>
    return -1;
80106425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010642a:	c9                   	leave  
8010642b:	c3                   	ret    
8010642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106430 <sys_chdir>:

int
sys_chdir(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	56                   	push   %esi
80106434:	53                   	push   %ebx
80106435:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106438:	e8 63 dc ff ff       	call   801040a0 <myproc>
8010643d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010643f:	e8 7c cf ff ff       	call   801033c0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106444:	83 ec 08             	sub    $0x8,%esp
80106447:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010644a:	50                   	push   %eax
8010644b:	6a 00                	push   $0x0
8010644d:	e8 9e f5 ff ff       	call   801059f0 <argstr>
80106452:	83 c4 10             	add    $0x10,%esp
80106455:	85 c0                	test   %eax,%eax
80106457:	78 77                	js     801064d0 <sys_chdir+0xa0>
80106459:	83 ec 0c             	sub    $0xc,%esp
8010645c:	ff 75 f4             	push   -0xc(%ebp)
8010645f:	e8 9c c2 ff ff       	call   80102700 <namei>
80106464:	83 c4 10             	add    $0x10,%esp
80106467:	89 c3                	mov    %eax,%ebx
80106469:	85 c0                	test   %eax,%eax
8010646b:	74 63                	je     801064d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010646d:	83 ec 0c             	sub    $0xc,%esp
80106470:	50                   	push   %eax
80106471:	e8 6a b9 ff ff       	call   80101de0 <ilock>
  if(ip->type != T_DIR){
80106476:	83 c4 10             	add    $0x10,%esp
80106479:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010647e:	75 30                	jne    801064b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	53                   	push   %ebx
80106484:	e8 37 ba ff ff       	call   80101ec0 <iunlock>
  iput(curproc->cwd);
80106489:	58                   	pop    %eax
8010648a:	ff 76 68             	push   0x68(%esi)
8010648d:	e8 7e ba ff ff       	call   80101f10 <iput>
  end_op();
80106492:	e8 99 cf ff ff       	call   80103430 <end_op>
  curproc->cwd = ip;
80106497:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010649a:	83 c4 10             	add    $0x10,%esp
8010649d:	31 c0                	xor    %eax,%eax
}
8010649f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064a2:	5b                   	pop    %ebx
801064a3:	5e                   	pop    %esi
801064a4:	5d                   	pop    %ebp
801064a5:	c3                   	ret    
801064a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	53                   	push   %ebx
801064b4:	e8 b7 bb ff ff       	call   80102070 <iunlockput>
    end_op();
801064b9:	e8 72 cf ff ff       	call   80103430 <end_op>
    return -1;
801064be:	83 c4 10             	add    $0x10,%esp
801064c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c6:	eb d7                	jmp    8010649f <sys_chdir+0x6f>
801064c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064cf:	90                   	nop
    end_op();
801064d0:	e8 5b cf ff ff       	call   80103430 <end_op>
    return -1;
801064d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064da:	eb c3                	jmp    8010649f <sys_chdir+0x6f>
801064dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064e0 <sys_exec>:

int
sys_exec(void)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	57                   	push   %edi
801064e4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801064e5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801064eb:	53                   	push   %ebx
801064ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801064f2:	50                   	push   %eax
801064f3:	6a 00                	push   $0x0
801064f5:	e8 f6 f4 ff ff       	call   801059f0 <argstr>
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	85 c0                	test   %eax,%eax
801064ff:	0f 88 87 00 00 00    	js     8010658c <sys_exec+0xac>
80106505:	83 ec 08             	sub    $0x8,%esp
80106508:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010650e:	50                   	push   %eax
8010650f:	6a 01                	push   $0x1
80106511:	e8 1a f4 ff ff       	call   80105930 <argint>
80106516:	83 c4 10             	add    $0x10,%esp
80106519:	85 c0                	test   %eax,%eax
8010651b:	78 6f                	js     8010658c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010651d:	83 ec 04             	sub    $0x4,%esp
80106520:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106526:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106528:	68 80 00 00 00       	push   $0x80
8010652d:	6a 00                	push   $0x0
8010652f:	56                   	push   %esi
80106530:	e8 3b f1 ff ff       	call   80105670 <memset>
80106535:	83 c4 10             	add    $0x10,%esp
80106538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010653f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106540:	83 ec 08             	sub    $0x8,%esp
80106543:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106549:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106550:	50                   	push   %eax
80106551:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106557:	01 f8                	add    %edi,%eax
80106559:	50                   	push   %eax
8010655a:	e8 41 f3 ff ff       	call   801058a0 <fetchint>
8010655f:	83 c4 10             	add    $0x10,%esp
80106562:	85 c0                	test   %eax,%eax
80106564:	78 26                	js     8010658c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106566:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010656c:	85 c0                	test   %eax,%eax
8010656e:	74 30                	je     801065a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106570:	83 ec 08             	sub    $0x8,%esp
80106573:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106576:	52                   	push   %edx
80106577:	50                   	push   %eax
80106578:	e8 63 f3 ff ff       	call   801058e0 <fetchstr>
8010657d:	83 c4 10             	add    $0x10,%esp
80106580:	85 c0                	test   %eax,%eax
80106582:	78 08                	js     8010658c <sys_exec+0xac>
  for(i=0;; i++){
80106584:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106587:	83 fb 20             	cmp    $0x20,%ebx
8010658a:	75 b4                	jne    80106540 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010658c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010658f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106594:	5b                   	pop    %ebx
80106595:	5e                   	pop    %esi
80106596:	5f                   	pop    %edi
80106597:	5d                   	pop    %ebp
80106598:	c3                   	ret    
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801065a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801065a7:	00 00 00 00 
  return exec(path, argv);
801065ab:	83 ec 08             	sub    $0x8,%esp
801065ae:	56                   	push   %esi
801065af:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801065b5:	e8 56 ab ff ff       	call   80101110 <exec>
801065ba:	83 c4 10             	add    $0x10,%esp
}
801065bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c0:	5b                   	pop    %ebx
801065c1:	5e                   	pop    %esi
801065c2:	5f                   	pop    %edi
801065c3:	5d                   	pop    %ebp
801065c4:	c3                   	ret    
801065c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065d0 <sys_pipe>:

int
sys_pipe(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	57                   	push   %edi
801065d4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801065d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801065d8:	53                   	push   %ebx
801065d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801065dc:	6a 08                	push   $0x8
801065de:	50                   	push   %eax
801065df:	6a 00                	push   $0x0
801065e1:	e8 9a f3 ff ff       	call   80105980 <argptr>
801065e6:	83 c4 10             	add    $0x10,%esp
801065e9:	85 c0                	test   %eax,%eax
801065eb:	78 4a                	js     80106637 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801065ed:	83 ec 08             	sub    $0x8,%esp
801065f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801065f3:	50                   	push   %eax
801065f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801065f7:	50                   	push   %eax
801065f8:	e8 93 d4 ff ff       	call   80103a90 <pipealloc>
801065fd:	83 c4 10             	add    $0x10,%esp
80106600:	85 c0                	test   %eax,%eax
80106602:	78 33                	js     80106637 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106604:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106607:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106609:	e8 92 da ff ff       	call   801040a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010660e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106610:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106614:	85 f6                	test   %esi,%esi
80106616:	74 28                	je     80106640 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106618:	83 c3 01             	add    $0x1,%ebx
8010661b:	83 fb 10             	cmp    $0x10,%ebx
8010661e:	75 f0                	jne    80106610 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	ff 75 e0             	push   -0x20(%ebp)
80106626:	e8 25 af ff ff       	call   80101550 <fileclose>
    fileclose(wf);
8010662b:	58                   	pop    %eax
8010662c:	ff 75 e4             	push   -0x1c(%ebp)
8010662f:	e8 1c af ff ff       	call   80101550 <fileclose>
    return -1;
80106634:	83 c4 10             	add    $0x10,%esp
80106637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663c:	eb 53                	jmp    80106691 <sys_pipe+0xc1>
8010663e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106640:	8d 73 08             	lea    0x8(%ebx),%esi
80106643:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010664a:	e8 51 da ff ff       	call   801040a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010664f:	31 d2                	xor    %edx,%edx
80106651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106658:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010665c:	85 c9                	test   %ecx,%ecx
8010665e:	74 20                	je     80106680 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106660:	83 c2 01             	add    $0x1,%edx
80106663:	83 fa 10             	cmp    $0x10,%edx
80106666:	75 f0                	jne    80106658 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106668:	e8 33 da ff ff       	call   801040a0 <myproc>
8010666d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106674:	00 
80106675:	eb a9                	jmp    80106620 <sys_pipe+0x50>
80106677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106680:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106684:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106687:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106689:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010668c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010668f:	31 c0                	xor    %eax,%eax
}
80106691:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106694:	5b                   	pop    %ebx
80106695:	5e                   	pop    %esi
80106696:	5f                   	pop    %edi
80106697:	5d                   	pop    %ebp
80106698:	c3                   	ret    
80106699:	66 90                	xchg   %ax,%ax
8010669b:	66 90                	xchg   %ax,%ax
8010669d:	66 90                	xchg   %ax,%ax
8010669f:	90                   	nop

801066a0 <sys_fork>:


int
sys_fork(void)
{
  return fork();
801066a0:	e9 ab db ff ff       	jmp    80104250 <fork>
801066a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066b0 <sys_exit>:
}

int
sys_exit(void)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801066b6:	e8 65 e1 ff ff       	call   80104820 <exit>
  return 0;  // not reached
}
801066bb:	31 c0                	xor    %eax,%eax
801066bd:	c9                   	leave  
801066be:	c3                   	ret    
801066bf:	90                   	nop

801066c0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801066c0:	e9 8b e2 ff ff       	jmp    80104950 <wait>
801066c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066d0 <sys_kill>:
}

int
sys_kill(void)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801066d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d9:	50                   	push   %eax
801066da:	6a 00                	push   $0x0
801066dc:	e8 4f f2 ff ff       	call   80105930 <argint>
801066e1:	83 c4 10             	add    $0x10,%esp
801066e4:	85 c0                	test   %eax,%eax
801066e6:	78 18                	js     80106700 <sys_kill+0x30>
    return -1;
  return kill(pid);
801066e8:	83 ec 0c             	sub    $0xc,%esp
801066eb:	ff 75 f4             	push   -0xc(%ebp)
801066ee:	e8 1d e5 ff ff       	call   80104c10 <kill>
801066f3:	83 c4 10             	add    $0x10,%esp
}
801066f6:	c9                   	leave  
801066f7:	c3                   	ret    
801066f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ff:	90                   	nop
80106700:	c9                   	leave  
    return -1;
80106701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106706:	c3                   	ret    
80106707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670e:	66 90                	xchg   %ax,%ax

80106710 <sys_getpid>:

int
sys_getpid(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106716:	e8 85 d9 ff ff       	call   801040a0 <myproc>
8010671b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010671e:	c9                   	leave  
8010671f:	c3                   	ret    

80106720 <sys_sbrk>:

int
sys_sbrk(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106724:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106727:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010672a:	50                   	push   %eax
8010672b:	6a 00                	push   $0x0
8010672d:	e8 fe f1 ff ff       	call   80105930 <argint>
80106732:	83 c4 10             	add    $0x10,%esp
80106735:	85 c0                	test   %eax,%eax
80106737:	78 27                	js     80106760 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106739:	e8 62 d9 ff ff       	call   801040a0 <myproc>
  if(growproc(n) < 0)
8010673e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106741:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106743:	ff 75 f4             	push   -0xc(%ebp)
80106746:	e8 85 da ff ff       	call   801041d0 <growproc>
8010674b:	83 c4 10             	add    $0x10,%esp
8010674e:	85 c0                	test   %eax,%eax
80106750:	78 0e                	js     80106760 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106752:	89 d8                	mov    %ebx,%eax
80106754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106757:	c9                   	leave  
80106758:	c3                   	ret    
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106760:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106765:	eb eb                	jmp    80106752 <sys_sbrk+0x32>
80106767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010676e:	66 90                	xchg   %ax,%ax

80106770 <sys_sleep>:

int
sys_sleep(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106774:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106777:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010677a:	50                   	push   %eax
8010677b:	6a 00                	push   $0x0
8010677d:	e8 ae f1 ff ff       	call   80105930 <argint>
80106782:	83 c4 10             	add    $0x10,%esp
80106785:	85 c0                	test   %eax,%eax
80106787:	0f 88 8a 00 00 00    	js     80106817 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010678d:	83 ec 0c             	sub    $0xc,%esp
80106790:	68 60 6b 11 80       	push   $0x80116b60
80106795:	e8 16 ee ff ff       	call   801055b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010679a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010679d:	8b 1d 40 6b 11 80    	mov    0x80116b40,%ebx
  while(ticks - ticks0 < n){
801067a3:	83 c4 10             	add    $0x10,%esp
801067a6:	85 d2                	test   %edx,%edx
801067a8:	75 27                	jne    801067d1 <sys_sleep+0x61>
801067aa:	eb 54                	jmp    80106800 <sys_sleep+0x90>
801067ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801067b0:	83 ec 08             	sub    $0x8,%esp
801067b3:	68 60 6b 11 80       	push   $0x80116b60
801067b8:	68 40 6b 11 80       	push   $0x80116b40
801067bd:	e8 2e e3 ff ff       	call   80104af0 <sleep>
  while(ticks - ticks0 < n){
801067c2:	a1 40 6b 11 80       	mov    0x80116b40,%eax
801067c7:	83 c4 10             	add    $0x10,%esp
801067ca:	29 d8                	sub    %ebx,%eax
801067cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801067cf:	73 2f                	jae    80106800 <sys_sleep+0x90>
    if(myproc()->killed){
801067d1:	e8 ca d8 ff ff       	call   801040a0 <myproc>
801067d6:	8b 40 24             	mov    0x24(%eax),%eax
801067d9:	85 c0                	test   %eax,%eax
801067db:	74 d3                	je     801067b0 <sys_sleep+0x40>
      release(&tickslock);
801067dd:	83 ec 0c             	sub    $0xc,%esp
801067e0:	68 60 6b 11 80       	push   $0x80116b60
801067e5:	e8 66 ed ff ff       	call   80105550 <release>
  }
  release(&tickslock);
  return 0;
}
801067ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801067ed:	83 c4 10             	add    $0x10,%esp
801067f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067f5:	c9                   	leave  
801067f6:	c3                   	ret    
801067f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106800:	83 ec 0c             	sub    $0xc,%esp
80106803:	68 60 6b 11 80       	push   $0x80116b60
80106808:	e8 43 ed ff ff       	call   80105550 <release>
  return 0;
8010680d:	83 c4 10             	add    $0x10,%esp
80106810:	31 c0                	xor    %eax,%eax
}
80106812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106815:	c9                   	leave  
80106816:	c3                   	ret    
    return -1;
80106817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681c:	eb f4                	jmp    80106812 <sys_sleep+0xa2>
8010681e:	66 90                	xchg   %ax,%ax

80106820 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	53                   	push   %ebx
80106824:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106827:	68 60 6b 11 80       	push   $0x80116b60
8010682c:	e8 7f ed ff ff       	call   801055b0 <acquire>
  xticks = ticks;
80106831:	8b 1d 40 6b 11 80    	mov    0x80116b40,%ebx
  release(&tickslock);
80106837:	c7 04 24 60 6b 11 80 	movl   $0x80116b60,(%esp)
8010683e:	e8 0d ed ff ff       	call   80105550 <release>
  return xticks;
}
80106843:	89 d8                	mov    %ebx,%eax
80106845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106848:	c9                   	leave  
80106849:	c3                   	ret    
8010684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106850 <sys_count_num_of_digit>:

}

int 
sys_count_num_of_digit(void)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	56                   	push   %esi
    n /= 10;
80106854:	be 67 66 66 66       	mov    $0x66666667,%esi
{
80106859:	53                   	push   %ebx
  int count = 0;
8010685a:	31 db                	xor    %ebx,%ebx
  return count_num_of_digit(myproc()-> tf -> ebx);
8010685c:	e8 3f d8 ff ff       	call   801040a0 <myproc>
80106861:	8b 40 18             	mov    0x18(%eax),%eax
80106864:	8b 48 10             	mov    0x10(%eax),%ecx
  int count = 0;
80106867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010686e:	66 90                	xchg   %ax,%ax
    n /= 10;
80106870:	89 c8                	mov    %ecx,%eax
    ++count;
80106872:	83 c3 01             	add    $0x1,%ebx
    n /= 10;
80106875:	f7 ee                	imul   %esi
80106877:	89 c8                	mov    %ecx,%eax
80106879:	c1 f8 1f             	sar    $0x1f,%eax
8010687c:	c1 fa 02             	sar    $0x2,%edx
  } while (n != 0);
8010687f:	89 d1                	mov    %edx,%ecx
80106881:	29 c1                	sub    %eax,%ecx
80106883:	75 eb                	jne    80106870 <sys_count_num_of_digit+0x20>
}
80106885:	89 d8                	mov    %ebx,%eax
80106887:	5b                   	pop    %ebx
80106888:	5e                   	pop    %esi
80106889:	5d                   	pop    %ebp
8010688a:	c3                   	ret    
8010688b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010688f:	90                   	nop

80106890 <sys_change_process_queue>:

int
sys_change_process_queue(void){
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 20             	sub    $0x20,%esp
    int pid;
    int queue_num;
  if (argint(0, &pid) < 0)
80106896:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106899:	50                   	push   %eax
8010689a:	6a 00                	push   $0x0
8010689c:	e8 8f f0 ff ff       	call   80105930 <argint>
801068a1:	83 c4 10             	add    $0x10,%esp
801068a4:	85 c0                	test   %eax,%eax
801068a6:	78 28                	js     801068d0 <sys_change_process_queue+0x40>
    return -1;
  if (argint(1, &queue_num) < 0)
801068a8:	83 ec 08             	sub    $0x8,%esp
801068ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068ae:	50                   	push   %eax
801068af:	6a 01                	push   $0x1
801068b1:	e8 7a f0 ff ff       	call   80105930 <argint>
801068b6:	83 c4 10             	add    $0x10,%esp
801068b9:	85 c0                	test   %eax,%eax
801068bb:	78 13                	js     801068d0 <sys_change_process_queue+0x40>
    return -1;
  return change_process_queue(pid,queue_num);
801068bd:	83 ec 08             	sub    $0x8,%esp
801068c0:	ff 75 f4             	push   -0xc(%ebp)
801068c3:	ff 75 f0             	push   -0x10(%ebp)
801068c6:	e8 d5 e5 ff ff       	call   80104ea0 <change_process_queue>
801068cb:	83 c4 10             	add    $0x10,%esp

}
801068ce:	c9                   	leave  
801068cf:	c3                   	ret    
801068d0:	c9                   	leave  
    return -1;
801068d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068d6:	c3                   	ret    
801068d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068de:	66 90                	xchg   %ax,%ax

801068e0 <sys_set_sjf_process>:

int
sys_set_sjf_process(void)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int burst_time;
  if(argint(0, &pid) < 0 ||
801068e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068e9:	50                   	push   %eax
801068ea:	6a 00                	push   $0x0
801068ec:	e8 3f f0 ff ff       	call   80105930 <argint>
801068f1:	83 c4 10             	add    $0x10,%esp
801068f4:	85 c0                	test   %eax,%eax
801068f6:	78 28                	js     80106920 <sys_set_sjf_process+0x40>
     argint(1, &burst_time) < 0){
801068f8:	83 ec 08             	sub    $0x8,%esp
801068fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068fe:	50                   	push   %eax
801068ff:	6a 01                	push   $0x1
80106901:	e8 2a f0 ff ff       	call   80105930 <argint>
  if(argint(0, &pid) < 0 ||
80106906:	83 c4 10             	add    $0x10,%esp
80106909:	85 c0                	test   %eax,%eax
8010690b:	78 13                	js     80106920 <sys_set_sjf_process+0x40>
     return -1;
  }
  return set_sjf_process(pid, burst_time);
8010690d:	83 ec 08             	sub    $0x8,%esp
80106910:	ff 75 f4             	push   -0xc(%ebp)
80106913:	ff 75 f0             	push   -0x10(%ebp)
80106916:	e8 05 e5 ff ff       	call   80104e20 <set_sjf_process>
8010691b:	83 c4 10             	add    $0x10,%esp
}
8010691e:	c9                   	leave  
8010691f:	c3                   	ret    
80106920:	c9                   	leave  
     return -1;
80106921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106926:	c3                   	ret    
80106927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692e:	66 90                	xchg   %ax,%ax

80106930 <sys_print_schedule_info>:

int
sys_print_schedule_info(void){
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 08             	sub    $0x8,%esp
  print_schedule_info();
80106936:	e8 d5 e5 ff ff       	call   80104f10 <print_schedule_info>
  return 0;
}
8010693b:	31 c0                	xor    %eax,%eax
8010693d:	c9                   	leave  
8010693e:	c3                   	ret    
8010693f:	90                   	nop

80106940 <sys_printvir>:

int
sys_printvir(void) {
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 08             	sub    $0x8,%esp

  printvir();
80106946:	e8 15 1a 00 00       	call   80108360 <printvir>
  return 0;
}
8010694b:	31 c0                	xor    %eax,%eax
8010694d:	c9                   	leave  
8010694e:	c3                   	ret    
8010694f:	90                   	nop

80106950 <sys_printphy>:

int
sys_printphy(void) {
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	83 ec 08             	sub    $0x8,%esp
  
  printphy();
80106956:	e8 85 1a 00 00       	call   801083e0 <printphy>
  return 0;
}
8010695b:	31 c0                	xor    %eax,%eax
8010695d:	c9                   	leave  
8010695e:	c3                   	ret    
8010695f:	90                   	nop

80106960 <sys_mapex>:
    

int
sys_mapex(void)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	53                   	push   %ebx
    int size;

    if (argint(0, &size) < 0)
80106964:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106967:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &size) < 0)
8010696a:	50                   	push   %eax
8010696b:	6a 00                	push   $0x0
8010696d:	e8 be ef ff ff       	call   80105930 <argint>
80106972:	83 c4 10             	add    $0x10,%esp
80106975:	89 c2                	mov    %eax,%edx
        return 0;
80106977:	31 c0                	xor    %eax,%eax
    if (argint(0, &size) < 0)
80106979:	85 d2                	test   %edx,%edx
8010697b:	78 0f                	js     8010698c <sys_mapex+0x2c>

    if (size <= 0 || size % PGSIZE != 0)
8010697d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106980:	85 d2                	test   %edx,%edx
80106982:	7e 08                	jle    8010698c <sys_mapex+0x2c>
80106984:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
8010698a:	74 0c                	je     80106998 <sys_mapex+0x38>
    uint s_z = myproc()->sz;

    mapex(size);

   return s_z;
}
8010698c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010698f:	c9                   	leave  
80106990:	c3                   	ret    
80106991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint s_z = myproc()->sz;
80106998:	e8 03 d7 ff ff       	call   801040a0 <myproc>
    mapex(size);
8010699d:	83 ec 0c             	sub    $0xc,%esp
    uint s_z = myproc()->sz;
801069a0:	8b 18                	mov    (%eax),%ebx
    mapex(size);
801069a2:	ff 75 f4             	push   -0xc(%ebp)
801069a5:	e8 b6 1a 00 00       	call   80108460 <mapex>
   return s_z;
801069aa:	89 d8                	mov    %ebx,%eax
801069ac:	83 c4 10             	add    $0x10,%esp
}
801069af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801069b2:	c9                   	leave  
801069b3:	c3                   	ret    

801069b4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801069b4:	1e                   	push   %ds
  pushl %es
801069b5:	06                   	push   %es
  pushl %fs
801069b6:	0f a0                	push   %fs
  pushl %gs
801069b8:	0f a8                	push   %gs
  pushal
801069ba:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801069bb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801069bf:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801069c1:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801069c3:	54                   	push   %esp
  call trap
801069c4:	e8 c7 00 00 00       	call   80106a90 <trap>
  addl $4, %esp
801069c9:	83 c4 04             	add    $0x4,%esp

801069cc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801069cc:	61                   	popa   
  popl %gs
801069cd:	0f a9                	pop    %gs
  popl %fs
801069cf:	0f a1                	pop    %fs
  popl %es
801069d1:	07                   	pop    %es
  popl %ds
801069d2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801069d3:	83 c4 08             	add    $0x8,%esp
  iret
801069d6:	cf                   	iret   
801069d7:	66 90                	xchg   %ax,%ax
801069d9:	66 90                	xchg   %ax,%ax
801069db:	66 90                	xchg   %ax,%ax
801069dd:	66 90                	xchg   %ax,%ax
801069df:	90                   	nop

801069e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801069e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801069e1:	31 c0                	xor    %eax,%eax
{
801069e3:	89 e5                	mov    %esp,%ebp
801069e5:	83 ec 08             	sub    $0x8,%esp
801069e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801069f0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801069f7:	c7 04 c5 a2 6b 11 80 	movl   $0x8e000008,-0x7fee945e(,%eax,8)
801069fe:	08 00 00 8e 
80106a02:	66 89 14 c5 a0 6b 11 	mov    %dx,-0x7fee9460(,%eax,8)
80106a09:	80 
80106a0a:	c1 ea 10             	shr    $0x10,%edx
80106a0d:	66 89 14 c5 a6 6b 11 	mov    %dx,-0x7fee945a(,%eax,8)
80106a14:	80 
  for(i = 0; i < 256; i++)
80106a15:	83 c0 01             	add    $0x1,%eax
80106a18:	3d 00 01 00 00       	cmp    $0x100,%eax
80106a1d:	75 d1                	jne    801069f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106a1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a22:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106a27:	c7 05 a2 6d 11 80 08 	movl   $0xef000008,0x80116da2
80106a2e:	00 00 ef 
  initlock(&tickslock, "time");
80106a31:	68 f5 8d 10 80       	push   $0x80108df5
80106a36:	68 60 6b 11 80       	push   $0x80116b60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106a3b:	66 a3 a0 6d 11 80    	mov    %ax,0x80116da0
80106a41:	c1 e8 10             	shr    $0x10,%eax
80106a44:	66 a3 a6 6d 11 80    	mov    %ax,0x80116da6
  initlock(&tickslock, "time");
80106a4a:	e8 91 e9 ff ff       	call   801053e0 <initlock>
}
80106a4f:	83 c4 10             	add    $0x10,%esp
80106a52:	c9                   	leave  
80106a53:	c3                   	ret    
80106a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a5f:	90                   	nop

80106a60 <idtinit>:

void
idtinit(void)
{
80106a60:	55                   	push   %ebp
  pd[0] = size-1;
80106a61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a66:	89 e5                	mov    %esp,%ebp
80106a68:	83 ec 10             	sub    $0x10,%esp
80106a6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a6f:	b8 a0 6b 11 80       	mov    $0x80116ba0,%eax
80106a74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a78:	c1 e8 10             	shr    $0x10,%eax
80106a7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106a85:	c9                   	leave  
80106a86:	c3                   	ret    
80106a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106a9c:	8b 43 30             	mov    0x30(%ebx),%eax
80106a9f:	83 f8 40             	cmp    $0x40,%eax
80106aa2:	0f 84 38 01 00 00    	je     80106be0 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106aa8:	83 e8 0e             	sub    $0xe,%eax
80106aab:	83 f8 31             	cmp    $0x31,%eax
80106aae:	0f 87 8c 00 00 00    	ja     80106b40 <trap+0xb0>
80106ab4:	ff 24 85 9c 8e 10 80 	jmp    *-0x7fef7164(,%eax,4)
80106abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106abf:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106ac0:	e8 bb d5 ff ff       	call   80104080 <cpuid>
80106ac5:	85 c0                	test   %eax,%eax
80106ac7:	0f 84 4b 02 00 00    	je     80106d18 <trap+0x288>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106acd:	e8 9e c4 ff ff       	call   80102f70 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ad2:	e8 c9 d5 ff ff       	call   801040a0 <myproc>
80106ad7:	85 c0                	test   %eax,%eax
80106ad9:	74 1d                	je     80106af8 <trap+0x68>
80106adb:	e8 c0 d5 ff ff       	call   801040a0 <myproc>
80106ae0:	8b 50 24             	mov    0x24(%eax),%edx
80106ae3:	85 d2                	test   %edx,%edx
80106ae5:	74 11                	je     80106af8 <trap+0x68>
80106ae7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106aeb:	83 e0 03             	and    $0x3,%eax
80106aee:	66 83 f8 03          	cmp    $0x3,%ax
80106af2:	0f 84 00 02 00 00    	je     80106cf8 <trap+0x268>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106af8:	e8 a3 d5 ff ff       	call   801040a0 <myproc>
80106afd:	85 c0                	test   %eax,%eax
80106aff:	74 0f                	je     80106b10 <trap+0x80>
80106b01:	e8 9a d5 ff ff       	call   801040a0 <myproc>
80106b06:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106b0a:	0f 84 b8 00 00 00    	je     80106bc8 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b10:	e8 8b d5 ff ff       	call   801040a0 <myproc>
80106b15:	85 c0                	test   %eax,%eax
80106b17:	74 1d                	je     80106b36 <trap+0xa6>
80106b19:	e8 82 d5 ff ff       	call   801040a0 <myproc>
80106b1e:	8b 40 24             	mov    0x24(%eax),%eax
80106b21:	85 c0                	test   %eax,%eax
80106b23:	74 11                	je     80106b36 <trap+0xa6>
80106b25:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106b29:	83 e0 03             	and    $0x3,%eax
80106b2c:	66 83 f8 03          	cmp    $0x3,%ax
80106b30:	0f 84 d7 00 00 00    	je     80106c0d <trap+0x17d>
    exit();
}
80106b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b39:	5b                   	pop    %ebx
80106b3a:	5e                   	pop    %esi
80106b3b:	5f                   	pop    %edi
80106b3c:	5d                   	pop    %ebp
80106b3d:	c3                   	ret    
80106b3e:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80106b40:	e8 5b d5 ff ff       	call   801040a0 <myproc>
80106b45:	85 c0                	test   %eax,%eax
80106b47:	0f 84 04 02 00 00    	je     80106d51 <trap+0x2c1>
80106b4d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106b51:	0f 84 fa 01 00 00    	je     80106d51 <trap+0x2c1>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b57:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b5a:	8b 53 38             	mov    0x38(%ebx),%edx
80106b5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106b60:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106b63:	e8 18 d5 ff ff       	call   80104080 <cpuid>
80106b68:	8b 73 30             	mov    0x30(%ebx),%esi
80106b6b:	89 c7                	mov    %eax,%edi
80106b6d:	8b 43 34             	mov    0x34(%ebx),%eax
80106b70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106b73:	e8 28 d5 ff ff       	call   801040a0 <myproc>
80106b78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b7b:	e8 20 d5 ff ff       	call   801040a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b80:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106b83:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b86:	51                   	push   %ecx
80106b87:	52                   	push   %edx
80106b88:	57                   	push   %edi
80106b89:	ff 75 e4             	push   -0x1c(%ebp)
80106b8c:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106b8d:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106b90:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b93:	56                   	push   %esi
80106b94:	ff 70 10             	push   0x10(%eax)
80106b97:	68 58 8e 10 80       	push   $0x80108e58
80106b9c:	e8 ff 9a ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80106ba1:	83 c4 20             	add    $0x20,%esp
80106ba4:	e8 f7 d4 ff ff       	call   801040a0 <myproc>
80106ba9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bb0:	e8 eb d4 ff ff       	call   801040a0 <myproc>
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	0f 85 1e ff ff ff    	jne    80106adb <trap+0x4b>
80106bbd:	e9 36 ff ff ff       	jmp    80106af8 <trap+0x68>
80106bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106bc8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106bcc:	0f 85 3e ff ff ff    	jne    80106b10 <trap+0x80>
    yield();
80106bd2:	e8 a9 de ff ff       	call   80104a80 <yield>
80106bd7:	e9 34 ff ff ff       	jmp    80106b10 <trap+0x80>
80106bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106be0:	e8 bb d4 ff ff       	call   801040a0 <myproc>
80106be5:	8b 70 24             	mov    0x24(%eax),%esi
80106be8:	85 f6                	test   %esi,%esi
80106bea:	0f 85 18 01 00 00    	jne    80106d08 <trap+0x278>
    myproc()->tf = tf;
80106bf0:	e8 ab d4 ff ff       	call   801040a0 <myproc>
80106bf5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106bf8:	e8 73 ee ff ff       	call   80105a70 <syscall>
    if(myproc()->killed)
80106bfd:	e8 9e d4 ff ff       	call   801040a0 <myproc>
80106c02:	8b 48 24             	mov    0x24(%eax),%ecx
80106c05:	85 c9                	test   %ecx,%ecx
80106c07:	0f 84 29 ff ff ff    	je     80106b36 <trap+0xa6>
}
80106c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c10:	5b                   	pop    %ebx
80106c11:	5e                   	pop    %esi
80106c12:	5f                   	pop    %edi
80106c13:	5d                   	pop    %ebp
      exit();
80106c14:	e9 07 dc ff ff       	jmp    80104820 <exit>
80106c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c20:	8b 7b 38             	mov    0x38(%ebx),%edi
80106c23:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106c27:	e8 54 d4 ff ff       	call   80104080 <cpuid>
80106c2c:	57                   	push   %edi
80106c2d:	56                   	push   %esi
80106c2e:	50                   	push   %eax
80106c2f:	68 00 8e 10 80       	push   $0x80108e00
80106c34:	e8 67 9a ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106c39:	e8 32 c3 ff ff       	call   80102f70 <lapiceoi>
    break;
80106c3e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c41:	e8 5a d4 ff ff       	call   801040a0 <myproc>
80106c46:	85 c0                	test   %eax,%eax
80106c48:	0f 85 8d fe ff ff    	jne    80106adb <trap+0x4b>
80106c4e:	e9 a5 fe ff ff       	jmp    80106af8 <trap+0x68>
80106c53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c57:	90                   	nop
    kbdintr();
80106c58:	e8 d3 c1 ff ff       	call   80102e30 <kbdintr>
    lapiceoi();
80106c5d:	e8 0e c3 ff ff       	call   80102f70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c62:	e8 39 d4 ff ff       	call   801040a0 <myproc>
80106c67:	85 c0                	test   %eax,%eax
80106c69:	0f 85 6c fe ff ff    	jne    80106adb <trap+0x4b>
80106c6f:	e9 84 fe ff ff       	jmp    80106af8 <trap+0x68>
80106c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106c78:	e8 73 02 00 00       	call   80106ef0 <uartintr>
    lapiceoi();
80106c7d:	e8 ee c2 ff ff       	call   80102f70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c82:	e8 19 d4 ff ff       	call   801040a0 <myproc>
80106c87:	85 c0                	test   %eax,%eax
80106c89:	0f 85 4c fe ff ff    	jne    80106adb <trap+0x4b>
80106c8f:	e9 64 fe ff ff       	jmp    80106af8 <trap+0x68>
80106c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106c98:	e8 03 bc ff ff       	call   801028a0 <ideintr>
80106c9d:	e9 2b fe ff ff       	jmp    80106acd <trap+0x3d>
80106ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ca8:	0f 20 d6             	mov    %cr2,%esi
80106cab:	0f 20 d7             	mov    %cr2,%edi
   allocuvm(myproc()->pgdir,PGROUNDDOWN(rcr2()),PGROUNDDOWN(rcr2())+PGSIZE);
80106cae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106cb4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106cba:	e8 e1 d3 ff ff       	call   801040a0 <myproc>
80106cbf:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106cc5:	83 ec 04             	sub    $0x4,%esp
80106cc8:	56                   	push   %esi
80106cc9:	57                   	push   %edi
80106cca:	ff 70 04             	push   0x4(%eax)
80106ccd:	e8 6e 11 00 00       	call   80107e40 <allocuvm>
   switchuvm(myproc());
80106cd2:	e8 c9 d3 ff ff       	call   801040a0 <myproc>
80106cd7:	89 04 24             	mov    %eax,(%esp)
80106cda:	e8 e1 0e 00 00       	call   80107bc0 <switchuvm>
   break;
80106cdf:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ce2:	e8 b9 d3 ff ff       	call   801040a0 <myproc>
80106ce7:	85 c0                	test   %eax,%eax
80106ce9:	0f 85 ec fd ff ff    	jne    80106adb <trap+0x4b>
80106cef:	e9 04 fe ff ff       	jmp    80106af8 <trap+0x68>
80106cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106cf8:	e8 23 db ff ff       	call   80104820 <exit>
80106cfd:	e9 f6 fd ff ff       	jmp    80106af8 <trap+0x68>
80106d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106d08:	e8 13 db ff ff       	call   80104820 <exit>
80106d0d:	e9 de fe ff ff       	jmp    80106bf0 <trap+0x160>
80106d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106d18:	83 ec 0c             	sub    $0xc,%esp
80106d1b:	68 60 6b 11 80       	push   $0x80116b60
80106d20:	e8 8b e8 ff ff       	call   801055b0 <acquire>
      wakeup(&ticks);
80106d25:	c7 04 24 40 6b 11 80 	movl   $0x80116b40,(%esp)
      ticks++;
80106d2c:	83 05 40 6b 11 80 01 	addl   $0x1,0x80116b40
      wakeup(&ticks);
80106d33:	e8 78 de ff ff       	call   80104bb0 <wakeup>
      release(&tickslock);
80106d38:	c7 04 24 60 6b 11 80 	movl   $0x80116b60,(%esp)
80106d3f:	e8 0c e8 ff ff       	call   80105550 <release>
      age_processes();
80106d44:	e8 57 d6 ff ff       	call   801043a0 <age_processes>
80106d49:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106d4c:	e9 7c fd ff ff       	jmp    80106acd <trap+0x3d>
80106d51:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d54:	8b 73 38             	mov    0x38(%ebx),%esi
80106d57:	e8 24 d3 ff ff       	call   80104080 <cpuid>
80106d5c:	83 ec 0c             	sub    $0xc,%esp
80106d5f:	57                   	push   %edi
80106d60:	56                   	push   %esi
80106d61:	50                   	push   %eax
80106d62:	ff 73 30             	push   0x30(%ebx)
80106d65:	68 24 8e 10 80       	push   $0x80108e24
80106d6a:	e8 31 99 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106d6f:	83 c4 14             	add    $0x14,%esp
80106d72:	68 fa 8d 10 80       	push   $0x80108dfa
80106d77:	e8 04 96 ff ff       	call   80100380 <panic>
80106d7c:	66 90                	xchg   %ax,%ax
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106d80:	a1 a0 73 11 80       	mov    0x801173a0,%eax
80106d85:	85 c0                	test   %eax,%eax
80106d87:	74 17                	je     80106da0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d89:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d8e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106d8f:	a8 01                	test   $0x1,%al
80106d91:	74 0d                	je     80106da0 <uartgetc+0x20>
80106d93:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106d99:	0f b6 c0             	movzbl %al,%eax
80106d9c:	c3                   	ret    
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106da5:	c3                   	ret    
80106da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dad:	8d 76 00             	lea    0x0(%esi),%esi

80106db0 <uartinit>:
{
80106db0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106db1:	31 c9                	xor    %ecx,%ecx
80106db3:	89 c8                	mov    %ecx,%eax
80106db5:	89 e5                	mov    %esp,%ebp
80106db7:	57                   	push   %edi
80106db8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106dbd:	56                   	push   %esi
80106dbe:	89 fa                	mov    %edi,%edx
80106dc0:	53                   	push   %ebx
80106dc1:	83 ec 1c             	sub    $0x1c,%esp
80106dc4:	ee                   	out    %al,(%dx)
80106dc5:	be fb 03 00 00       	mov    $0x3fb,%esi
80106dca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106dcf:	89 f2                	mov    %esi,%edx
80106dd1:	ee                   	out    %al,(%dx)
80106dd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106dd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ddc:	ee                   	out    %al,(%dx)
80106ddd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106de2:	89 c8                	mov    %ecx,%eax
80106de4:	89 da                	mov    %ebx,%edx
80106de6:	ee                   	out    %al,(%dx)
80106de7:	b8 03 00 00 00       	mov    $0x3,%eax
80106dec:	89 f2                	mov    %esi,%edx
80106dee:	ee                   	out    %al,(%dx)
80106def:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106df4:	89 c8                	mov    %ecx,%eax
80106df6:	ee                   	out    %al,(%dx)
80106df7:	b8 01 00 00 00       	mov    $0x1,%eax
80106dfc:	89 da                	mov    %ebx,%edx
80106dfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106dff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106e05:	3c ff                	cmp    $0xff,%al
80106e07:	74 78                	je     80106e81 <uartinit+0xd1>
  uart = 1;
80106e09:	c7 05 a0 73 11 80 01 	movl   $0x1,0x801173a0
80106e10:	00 00 00 
80106e13:	89 fa                	mov    %edi,%edx
80106e15:	ec                   	in     (%dx),%al
80106e16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106e1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106e1f:	bf 64 8f 10 80       	mov    $0x80108f64,%edi
80106e24:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106e29:	6a 00                	push   $0x0
80106e2b:	6a 04                	push   $0x4
80106e2d:	e8 ae bc ff ff       	call   80102ae0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106e32:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106e36:	83 c4 10             	add    $0x10,%esp
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106e40:	a1 a0 73 11 80       	mov    0x801173a0,%eax
80106e45:	bb 80 00 00 00       	mov    $0x80,%ebx
80106e4a:	85 c0                	test   %eax,%eax
80106e4c:	75 14                	jne    80106e62 <uartinit+0xb2>
80106e4e:	eb 23                	jmp    80106e73 <uartinit+0xc3>
    microdelay(10);
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	6a 0a                	push   $0xa
80106e55:	e8 36 c1 ff ff       	call   80102f90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e5a:	83 c4 10             	add    $0x10,%esp
80106e5d:	83 eb 01             	sub    $0x1,%ebx
80106e60:	74 07                	je     80106e69 <uartinit+0xb9>
80106e62:	89 f2                	mov    %esi,%edx
80106e64:	ec                   	in     (%dx),%al
80106e65:	a8 20                	test   $0x20,%al
80106e67:	74 e7                	je     80106e50 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e69:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106e6d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e72:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106e73:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106e77:	83 c7 01             	add    $0x1,%edi
80106e7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80106e7d:	84 c0                	test   %al,%al
80106e7f:	75 bf                	jne    80106e40 <uartinit+0x90>
}
80106e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e84:	5b                   	pop    %ebx
80106e85:	5e                   	pop    %esi
80106e86:	5f                   	pop    %edi
80106e87:	5d                   	pop    %ebp
80106e88:	c3                   	ret    
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <uartputc>:
  if(!uart)
80106e90:	a1 a0 73 11 80       	mov    0x801173a0,%eax
80106e95:	85 c0                	test   %eax,%eax
80106e97:	74 47                	je     80106ee0 <uartputc+0x50>
{
80106e99:	55                   	push   %ebp
80106e9a:	89 e5                	mov    %esp,%ebp
80106e9c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106ea2:	53                   	push   %ebx
80106ea3:	bb 80 00 00 00       	mov    $0x80,%ebx
80106ea8:	eb 18                	jmp    80106ec2 <uartputc+0x32>
80106eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106eb0:	83 ec 0c             	sub    $0xc,%esp
80106eb3:	6a 0a                	push   $0xa
80106eb5:	e8 d6 c0 ff ff       	call   80102f90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106eba:	83 c4 10             	add    $0x10,%esp
80106ebd:	83 eb 01             	sub    $0x1,%ebx
80106ec0:	74 07                	je     80106ec9 <uartputc+0x39>
80106ec2:	89 f2                	mov    %esi,%edx
80106ec4:	ec                   	in     (%dx),%al
80106ec5:	a8 20                	test   $0x20,%al
80106ec7:	74 e7                	je     80106eb0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ec9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ecc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ed1:	ee                   	out    %al,(%dx)
}
80106ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5d                   	pop    %ebp
80106ed8:	c3                   	ret    
80106ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee0:	c3                   	ret    
80106ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eef:	90                   	nop

80106ef0 <uartintr>:

void
uartintr(void)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106ef6:	68 80 6d 10 80       	push   $0x80106d80
80106efb:	e8 b0 9d ff ff       	call   80100cb0 <consoleintr>
}
80106f00:	83 c4 10             	add    $0x10,%esp
80106f03:	c9                   	leave  
80106f04:	c3                   	ret    

80106f05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $0
80106f07:	6a 00                	push   $0x0
  jmp alltraps
80106f09:	e9 a6 fa ff ff       	jmp    801069b4 <alltraps>

80106f0e <vector1>:
.globl vector1
vector1:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $1
80106f10:	6a 01                	push   $0x1
  jmp alltraps
80106f12:	e9 9d fa ff ff       	jmp    801069b4 <alltraps>

80106f17 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $2
80106f19:	6a 02                	push   $0x2
  jmp alltraps
80106f1b:	e9 94 fa ff ff       	jmp    801069b4 <alltraps>

80106f20 <vector3>:
.globl vector3
vector3:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $3
80106f22:	6a 03                	push   $0x3
  jmp alltraps
80106f24:	e9 8b fa ff ff       	jmp    801069b4 <alltraps>

80106f29 <vector4>:
.globl vector4
vector4:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $4
80106f2b:	6a 04                	push   $0x4
  jmp alltraps
80106f2d:	e9 82 fa ff ff       	jmp    801069b4 <alltraps>

80106f32 <vector5>:
.globl vector5
vector5:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $5
80106f34:	6a 05                	push   $0x5
  jmp alltraps
80106f36:	e9 79 fa ff ff       	jmp    801069b4 <alltraps>

80106f3b <vector6>:
.globl vector6
vector6:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $6
80106f3d:	6a 06                	push   $0x6
  jmp alltraps
80106f3f:	e9 70 fa ff ff       	jmp    801069b4 <alltraps>

80106f44 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $7
80106f46:	6a 07                	push   $0x7
  jmp alltraps
80106f48:	e9 67 fa ff ff       	jmp    801069b4 <alltraps>

80106f4d <vector8>:
.globl vector8
vector8:
  pushl $8
80106f4d:	6a 08                	push   $0x8
  jmp alltraps
80106f4f:	e9 60 fa ff ff       	jmp    801069b4 <alltraps>

80106f54 <vector9>:
.globl vector9
vector9:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $9
80106f56:	6a 09                	push   $0x9
  jmp alltraps
80106f58:	e9 57 fa ff ff       	jmp    801069b4 <alltraps>

80106f5d <vector10>:
.globl vector10
vector10:
  pushl $10
80106f5d:	6a 0a                	push   $0xa
  jmp alltraps
80106f5f:	e9 50 fa ff ff       	jmp    801069b4 <alltraps>

80106f64 <vector11>:
.globl vector11
vector11:
  pushl $11
80106f64:	6a 0b                	push   $0xb
  jmp alltraps
80106f66:	e9 49 fa ff ff       	jmp    801069b4 <alltraps>

80106f6b <vector12>:
.globl vector12
vector12:
  pushl $12
80106f6b:	6a 0c                	push   $0xc
  jmp alltraps
80106f6d:	e9 42 fa ff ff       	jmp    801069b4 <alltraps>

80106f72 <vector13>:
.globl vector13
vector13:
  pushl $13
80106f72:	6a 0d                	push   $0xd
  jmp alltraps
80106f74:	e9 3b fa ff ff       	jmp    801069b4 <alltraps>

80106f79 <vector14>:
.globl vector14
vector14:
  pushl $14
80106f79:	6a 0e                	push   $0xe
  jmp alltraps
80106f7b:	e9 34 fa ff ff       	jmp    801069b4 <alltraps>

80106f80 <vector15>:
.globl vector15
vector15:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $15
80106f82:	6a 0f                	push   $0xf
  jmp alltraps
80106f84:	e9 2b fa ff ff       	jmp    801069b4 <alltraps>

80106f89 <vector16>:
.globl vector16
vector16:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $16
80106f8b:	6a 10                	push   $0x10
  jmp alltraps
80106f8d:	e9 22 fa ff ff       	jmp    801069b4 <alltraps>

80106f92 <vector17>:
.globl vector17
vector17:
  pushl $17
80106f92:	6a 11                	push   $0x11
  jmp alltraps
80106f94:	e9 1b fa ff ff       	jmp    801069b4 <alltraps>

80106f99 <vector18>:
.globl vector18
vector18:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $18
80106f9b:	6a 12                	push   $0x12
  jmp alltraps
80106f9d:	e9 12 fa ff ff       	jmp    801069b4 <alltraps>

80106fa2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $19
80106fa4:	6a 13                	push   $0x13
  jmp alltraps
80106fa6:	e9 09 fa ff ff       	jmp    801069b4 <alltraps>

80106fab <vector20>:
.globl vector20
vector20:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $20
80106fad:	6a 14                	push   $0x14
  jmp alltraps
80106faf:	e9 00 fa ff ff       	jmp    801069b4 <alltraps>

80106fb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $21
80106fb6:	6a 15                	push   $0x15
  jmp alltraps
80106fb8:	e9 f7 f9 ff ff       	jmp    801069b4 <alltraps>

80106fbd <vector22>:
.globl vector22
vector22:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $22
80106fbf:	6a 16                	push   $0x16
  jmp alltraps
80106fc1:	e9 ee f9 ff ff       	jmp    801069b4 <alltraps>

80106fc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $23
80106fc8:	6a 17                	push   $0x17
  jmp alltraps
80106fca:	e9 e5 f9 ff ff       	jmp    801069b4 <alltraps>

80106fcf <vector24>:
.globl vector24
vector24:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $24
80106fd1:	6a 18                	push   $0x18
  jmp alltraps
80106fd3:	e9 dc f9 ff ff       	jmp    801069b4 <alltraps>

80106fd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $25
80106fda:	6a 19                	push   $0x19
  jmp alltraps
80106fdc:	e9 d3 f9 ff ff       	jmp    801069b4 <alltraps>

80106fe1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $26
80106fe3:	6a 1a                	push   $0x1a
  jmp alltraps
80106fe5:	e9 ca f9 ff ff       	jmp    801069b4 <alltraps>

80106fea <vector27>:
.globl vector27
vector27:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $27
80106fec:	6a 1b                	push   $0x1b
  jmp alltraps
80106fee:	e9 c1 f9 ff ff       	jmp    801069b4 <alltraps>

80106ff3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $28
80106ff5:	6a 1c                	push   $0x1c
  jmp alltraps
80106ff7:	e9 b8 f9 ff ff       	jmp    801069b4 <alltraps>

80106ffc <vector29>:
.globl vector29
vector29:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $29
80106ffe:	6a 1d                	push   $0x1d
  jmp alltraps
80107000:	e9 af f9 ff ff       	jmp    801069b4 <alltraps>

80107005 <vector30>:
.globl vector30
vector30:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $30
80107007:	6a 1e                	push   $0x1e
  jmp alltraps
80107009:	e9 a6 f9 ff ff       	jmp    801069b4 <alltraps>

8010700e <vector31>:
.globl vector31
vector31:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $31
80107010:	6a 1f                	push   $0x1f
  jmp alltraps
80107012:	e9 9d f9 ff ff       	jmp    801069b4 <alltraps>

80107017 <vector32>:
.globl vector32
vector32:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $32
80107019:	6a 20                	push   $0x20
  jmp alltraps
8010701b:	e9 94 f9 ff ff       	jmp    801069b4 <alltraps>

80107020 <vector33>:
.globl vector33
vector33:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $33
80107022:	6a 21                	push   $0x21
  jmp alltraps
80107024:	e9 8b f9 ff ff       	jmp    801069b4 <alltraps>

80107029 <vector34>:
.globl vector34
vector34:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $34
8010702b:	6a 22                	push   $0x22
  jmp alltraps
8010702d:	e9 82 f9 ff ff       	jmp    801069b4 <alltraps>

80107032 <vector35>:
.globl vector35
vector35:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $35
80107034:	6a 23                	push   $0x23
  jmp alltraps
80107036:	e9 79 f9 ff ff       	jmp    801069b4 <alltraps>

8010703b <vector36>:
.globl vector36
vector36:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $36
8010703d:	6a 24                	push   $0x24
  jmp alltraps
8010703f:	e9 70 f9 ff ff       	jmp    801069b4 <alltraps>

80107044 <vector37>:
.globl vector37
vector37:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $37
80107046:	6a 25                	push   $0x25
  jmp alltraps
80107048:	e9 67 f9 ff ff       	jmp    801069b4 <alltraps>

8010704d <vector38>:
.globl vector38
vector38:
  pushl $0
8010704d:	6a 00                	push   $0x0
  pushl $38
8010704f:	6a 26                	push   $0x26
  jmp alltraps
80107051:	e9 5e f9 ff ff       	jmp    801069b4 <alltraps>

80107056 <vector39>:
.globl vector39
vector39:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $39
80107058:	6a 27                	push   $0x27
  jmp alltraps
8010705a:	e9 55 f9 ff ff       	jmp    801069b4 <alltraps>

8010705f <vector40>:
.globl vector40
vector40:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $40
80107061:	6a 28                	push   $0x28
  jmp alltraps
80107063:	e9 4c f9 ff ff       	jmp    801069b4 <alltraps>

80107068 <vector41>:
.globl vector41
vector41:
  pushl $0
80107068:	6a 00                	push   $0x0
  pushl $41
8010706a:	6a 29                	push   $0x29
  jmp alltraps
8010706c:	e9 43 f9 ff ff       	jmp    801069b4 <alltraps>

80107071 <vector42>:
.globl vector42
vector42:
  pushl $0
80107071:	6a 00                	push   $0x0
  pushl $42
80107073:	6a 2a                	push   $0x2a
  jmp alltraps
80107075:	e9 3a f9 ff ff       	jmp    801069b4 <alltraps>

8010707a <vector43>:
.globl vector43
vector43:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $43
8010707c:	6a 2b                	push   $0x2b
  jmp alltraps
8010707e:	e9 31 f9 ff ff       	jmp    801069b4 <alltraps>

80107083 <vector44>:
.globl vector44
vector44:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $44
80107085:	6a 2c                	push   $0x2c
  jmp alltraps
80107087:	e9 28 f9 ff ff       	jmp    801069b4 <alltraps>

8010708c <vector45>:
.globl vector45
vector45:
  pushl $0
8010708c:	6a 00                	push   $0x0
  pushl $45
8010708e:	6a 2d                	push   $0x2d
  jmp alltraps
80107090:	e9 1f f9 ff ff       	jmp    801069b4 <alltraps>

80107095 <vector46>:
.globl vector46
vector46:
  pushl $0
80107095:	6a 00                	push   $0x0
  pushl $46
80107097:	6a 2e                	push   $0x2e
  jmp alltraps
80107099:	e9 16 f9 ff ff       	jmp    801069b4 <alltraps>

8010709e <vector47>:
.globl vector47
vector47:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $47
801070a0:	6a 2f                	push   $0x2f
  jmp alltraps
801070a2:	e9 0d f9 ff ff       	jmp    801069b4 <alltraps>

801070a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $48
801070a9:	6a 30                	push   $0x30
  jmp alltraps
801070ab:	e9 04 f9 ff ff       	jmp    801069b4 <alltraps>

801070b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801070b0:	6a 00                	push   $0x0
  pushl $49
801070b2:	6a 31                	push   $0x31
  jmp alltraps
801070b4:	e9 fb f8 ff ff       	jmp    801069b4 <alltraps>

801070b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801070b9:	6a 00                	push   $0x0
  pushl $50
801070bb:	6a 32                	push   $0x32
  jmp alltraps
801070bd:	e9 f2 f8 ff ff       	jmp    801069b4 <alltraps>

801070c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $51
801070c4:	6a 33                	push   $0x33
  jmp alltraps
801070c6:	e9 e9 f8 ff ff       	jmp    801069b4 <alltraps>

801070cb <vector52>:
.globl vector52
vector52:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $52
801070cd:	6a 34                	push   $0x34
  jmp alltraps
801070cf:	e9 e0 f8 ff ff       	jmp    801069b4 <alltraps>

801070d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801070d4:	6a 00                	push   $0x0
  pushl $53
801070d6:	6a 35                	push   $0x35
  jmp alltraps
801070d8:	e9 d7 f8 ff ff       	jmp    801069b4 <alltraps>

801070dd <vector54>:
.globl vector54
vector54:
  pushl $0
801070dd:	6a 00                	push   $0x0
  pushl $54
801070df:	6a 36                	push   $0x36
  jmp alltraps
801070e1:	e9 ce f8 ff ff       	jmp    801069b4 <alltraps>

801070e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $55
801070e8:	6a 37                	push   $0x37
  jmp alltraps
801070ea:	e9 c5 f8 ff ff       	jmp    801069b4 <alltraps>

801070ef <vector56>:
.globl vector56
vector56:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $56
801070f1:	6a 38                	push   $0x38
  jmp alltraps
801070f3:	e9 bc f8 ff ff       	jmp    801069b4 <alltraps>

801070f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801070f8:	6a 00                	push   $0x0
  pushl $57
801070fa:	6a 39                	push   $0x39
  jmp alltraps
801070fc:	e9 b3 f8 ff ff       	jmp    801069b4 <alltraps>

80107101 <vector58>:
.globl vector58
vector58:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $58
80107103:	6a 3a                	push   $0x3a
  jmp alltraps
80107105:	e9 aa f8 ff ff       	jmp    801069b4 <alltraps>

8010710a <vector59>:
.globl vector59
vector59:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $59
8010710c:	6a 3b                	push   $0x3b
  jmp alltraps
8010710e:	e9 a1 f8 ff ff       	jmp    801069b4 <alltraps>

80107113 <vector60>:
.globl vector60
vector60:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $60
80107115:	6a 3c                	push   $0x3c
  jmp alltraps
80107117:	e9 98 f8 ff ff       	jmp    801069b4 <alltraps>

8010711c <vector61>:
.globl vector61
vector61:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $61
8010711e:	6a 3d                	push   $0x3d
  jmp alltraps
80107120:	e9 8f f8 ff ff       	jmp    801069b4 <alltraps>

80107125 <vector62>:
.globl vector62
vector62:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $62
80107127:	6a 3e                	push   $0x3e
  jmp alltraps
80107129:	e9 86 f8 ff ff       	jmp    801069b4 <alltraps>

8010712e <vector63>:
.globl vector63
vector63:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $63
80107130:	6a 3f                	push   $0x3f
  jmp alltraps
80107132:	e9 7d f8 ff ff       	jmp    801069b4 <alltraps>

80107137 <vector64>:
.globl vector64
vector64:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $64
80107139:	6a 40                	push   $0x40
  jmp alltraps
8010713b:	e9 74 f8 ff ff       	jmp    801069b4 <alltraps>

80107140 <vector65>:
.globl vector65
vector65:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $65
80107142:	6a 41                	push   $0x41
  jmp alltraps
80107144:	e9 6b f8 ff ff       	jmp    801069b4 <alltraps>

80107149 <vector66>:
.globl vector66
vector66:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $66
8010714b:	6a 42                	push   $0x42
  jmp alltraps
8010714d:	e9 62 f8 ff ff       	jmp    801069b4 <alltraps>

80107152 <vector67>:
.globl vector67
vector67:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $67
80107154:	6a 43                	push   $0x43
  jmp alltraps
80107156:	e9 59 f8 ff ff       	jmp    801069b4 <alltraps>

8010715b <vector68>:
.globl vector68
vector68:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $68
8010715d:	6a 44                	push   $0x44
  jmp alltraps
8010715f:	e9 50 f8 ff ff       	jmp    801069b4 <alltraps>

80107164 <vector69>:
.globl vector69
vector69:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $69
80107166:	6a 45                	push   $0x45
  jmp alltraps
80107168:	e9 47 f8 ff ff       	jmp    801069b4 <alltraps>

8010716d <vector70>:
.globl vector70
vector70:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $70
8010716f:	6a 46                	push   $0x46
  jmp alltraps
80107171:	e9 3e f8 ff ff       	jmp    801069b4 <alltraps>

80107176 <vector71>:
.globl vector71
vector71:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $71
80107178:	6a 47                	push   $0x47
  jmp alltraps
8010717a:	e9 35 f8 ff ff       	jmp    801069b4 <alltraps>

8010717f <vector72>:
.globl vector72
vector72:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $72
80107181:	6a 48                	push   $0x48
  jmp alltraps
80107183:	e9 2c f8 ff ff       	jmp    801069b4 <alltraps>

80107188 <vector73>:
.globl vector73
vector73:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $73
8010718a:	6a 49                	push   $0x49
  jmp alltraps
8010718c:	e9 23 f8 ff ff       	jmp    801069b4 <alltraps>

80107191 <vector74>:
.globl vector74
vector74:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $74
80107193:	6a 4a                	push   $0x4a
  jmp alltraps
80107195:	e9 1a f8 ff ff       	jmp    801069b4 <alltraps>

8010719a <vector75>:
.globl vector75
vector75:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $75
8010719c:	6a 4b                	push   $0x4b
  jmp alltraps
8010719e:	e9 11 f8 ff ff       	jmp    801069b4 <alltraps>

801071a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $76
801071a5:	6a 4c                	push   $0x4c
  jmp alltraps
801071a7:	e9 08 f8 ff ff       	jmp    801069b4 <alltraps>

801071ac <vector77>:
.globl vector77
vector77:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $77
801071ae:	6a 4d                	push   $0x4d
  jmp alltraps
801071b0:	e9 ff f7 ff ff       	jmp    801069b4 <alltraps>

801071b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $78
801071b7:	6a 4e                	push   $0x4e
  jmp alltraps
801071b9:	e9 f6 f7 ff ff       	jmp    801069b4 <alltraps>

801071be <vector79>:
.globl vector79
vector79:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $79
801071c0:	6a 4f                	push   $0x4f
  jmp alltraps
801071c2:	e9 ed f7 ff ff       	jmp    801069b4 <alltraps>

801071c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $80
801071c9:	6a 50                	push   $0x50
  jmp alltraps
801071cb:	e9 e4 f7 ff ff       	jmp    801069b4 <alltraps>

801071d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $81
801071d2:	6a 51                	push   $0x51
  jmp alltraps
801071d4:	e9 db f7 ff ff       	jmp    801069b4 <alltraps>

801071d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $82
801071db:	6a 52                	push   $0x52
  jmp alltraps
801071dd:	e9 d2 f7 ff ff       	jmp    801069b4 <alltraps>

801071e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $83
801071e4:	6a 53                	push   $0x53
  jmp alltraps
801071e6:	e9 c9 f7 ff ff       	jmp    801069b4 <alltraps>

801071eb <vector84>:
.globl vector84
vector84:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $84
801071ed:	6a 54                	push   $0x54
  jmp alltraps
801071ef:	e9 c0 f7 ff ff       	jmp    801069b4 <alltraps>

801071f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $85
801071f6:	6a 55                	push   $0x55
  jmp alltraps
801071f8:	e9 b7 f7 ff ff       	jmp    801069b4 <alltraps>

801071fd <vector86>:
.globl vector86
vector86:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $86
801071ff:	6a 56                	push   $0x56
  jmp alltraps
80107201:	e9 ae f7 ff ff       	jmp    801069b4 <alltraps>

80107206 <vector87>:
.globl vector87
vector87:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $87
80107208:	6a 57                	push   $0x57
  jmp alltraps
8010720a:	e9 a5 f7 ff ff       	jmp    801069b4 <alltraps>

8010720f <vector88>:
.globl vector88
vector88:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $88
80107211:	6a 58                	push   $0x58
  jmp alltraps
80107213:	e9 9c f7 ff ff       	jmp    801069b4 <alltraps>

80107218 <vector89>:
.globl vector89
vector89:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $89
8010721a:	6a 59                	push   $0x59
  jmp alltraps
8010721c:	e9 93 f7 ff ff       	jmp    801069b4 <alltraps>

80107221 <vector90>:
.globl vector90
vector90:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $90
80107223:	6a 5a                	push   $0x5a
  jmp alltraps
80107225:	e9 8a f7 ff ff       	jmp    801069b4 <alltraps>

8010722a <vector91>:
.globl vector91
vector91:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $91
8010722c:	6a 5b                	push   $0x5b
  jmp alltraps
8010722e:	e9 81 f7 ff ff       	jmp    801069b4 <alltraps>

80107233 <vector92>:
.globl vector92
vector92:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $92
80107235:	6a 5c                	push   $0x5c
  jmp alltraps
80107237:	e9 78 f7 ff ff       	jmp    801069b4 <alltraps>

8010723c <vector93>:
.globl vector93
vector93:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $93
8010723e:	6a 5d                	push   $0x5d
  jmp alltraps
80107240:	e9 6f f7 ff ff       	jmp    801069b4 <alltraps>

80107245 <vector94>:
.globl vector94
vector94:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $94
80107247:	6a 5e                	push   $0x5e
  jmp alltraps
80107249:	e9 66 f7 ff ff       	jmp    801069b4 <alltraps>

8010724e <vector95>:
.globl vector95
vector95:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $95
80107250:	6a 5f                	push   $0x5f
  jmp alltraps
80107252:	e9 5d f7 ff ff       	jmp    801069b4 <alltraps>

80107257 <vector96>:
.globl vector96
vector96:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $96
80107259:	6a 60                	push   $0x60
  jmp alltraps
8010725b:	e9 54 f7 ff ff       	jmp    801069b4 <alltraps>

80107260 <vector97>:
.globl vector97
vector97:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $97
80107262:	6a 61                	push   $0x61
  jmp alltraps
80107264:	e9 4b f7 ff ff       	jmp    801069b4 <alltraps>

80107269 <vector98>:
.globl vector98
vector98:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $98
8010726b:	6a 62                	push   $0x62
  jmp alltraps
8010726d:	e9 42 f7 ff ff       	jmp    801069b4 <alltraps>

80107272 <vector99>:
.globl vector99
vector99:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $99
80107274:	6a 63                	push   $0x63
  jmp alltraps
80107276:	e9 39 f7 ff ff       	jmp    801069b4 <alltraps>

8010727b <vector100>:
.globl vector100
vector100:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $100
8010727d:	6a 64                	push   $0x64
  jmp alltraps
8010727f:	e9 30 f7 ff ff       	jmp    801069b4 <alltraps>

80107284 <vector101>:
.globl vector101
vector101:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $101
80107286:	6a 65                	push   $0x65
  jmp alltraps
80107288:	e9 27 f7 ff ff       	jmp    801069b4 <alltraps>

8010728d <vector102>:
.globl vector102
vector102:
  pushl $0
8010728d:	6a 00                	push   $0x0
  pushl $102
8010728f:	6a 66                	push   $0x66
  jmp alltraps
80107291:	e9 1e f7 ff ff       	jmp    801069b4 <alltraps>

80107296 <vector103>:
.globl vector103
vector103:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $103
80107298:	6a 67                	push   $0x67
  jmp alltraps
8010729a:	e9 15 f7 ff ff       	jmp    801069b4 <alltraps>

8010729f <vector104>:
.globl vector104
vector104:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $104
801072a1:	6a 68                	push   $0x68
  jmp alltraps
801072a3:	e9 0c f7 ff ff       	jmp    801069b4 <alltraps>

801072a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $105
801072aa:	6a 69                	push   $0x69
  jmp alltraps
801072ac:	e9 03 f7 ff ff       	jmp    801069b4 <alltraps>

801072b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801072b1:	6a 00                	push   $0x0
  pushl $106
801072b3:	6a 6a                	push   $0x6a
  jmp alltraps
801072b5:	e9 fa f6 ff ff       	jmp    801069b4 <alltraps>

801072ba <vector107>:
.globl vector107
vector107:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $107
801072bc:	6a 6b                	push   $0x6b
  jmp alltraps
801072be:	e9 f1 f6 ff ff       	jmp    801069b4 <alltraps>

801072c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $108
801072c5:	6a 6c                	push   $0x6c
  jmp alltraps
801072c7:	e9 e8 f6 ff ff       	jmp    801069b4 <alltraps>

801072cc <vector109>:
.globl vector109
vector109:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $109
801072ce:	6a 6d                	push   $0x6d
  jmp alltraps
801072d0:	e9 df f6 ff ff       	jmp    801069b4 <alltraps>

801072d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801072d5:	6a 00                	push   $0x0
  pushl $110
801072d7:	6a 6e                	push   $0x6e
  jmp alltraps
801072d9:	e9 d6 f6 ff ff       	jmp    801069b4 <alltraps>

801072de <vector111>:
.globl vector111
vector111:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $111
801072e0:	6a 6f                	push   $0x6f
  jmp alltraps
801072e2:	e9 cd f6 ff ff       	jmp    801069b4 <alltraps>

801072e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $112
801072e9:	6a 70                	push   $0x70
  jmp alltraps
801072eb:	e9 c4 f6 ff ff       	jmp    801069b4 <alltraps>

801072f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801072f0:	6a 00                	push   $0x0
  pushl $113
801072f2:	6a 71                	push   $0x71
  jmp alltraps
801072f4:	e9 bb f6 ff ff       	jmp    801069b4 <alltraps>

801072f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801072f9:	6a 00                	push   $0x0
  pushl $114
801072fb:	6a 72                	push   $0x72
  jmp alltraps
801072fd:	e9 b2 f6 ff ff       	jmp    801069b4 <alltraps>

80107302 <vector115>:
.globl vector115
vector115:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $115
80107304:	6a 73                	push   $0x73
  jmp alltraps
80107306:	e9 a9 f6 ff ff       	jmp    801069b4 <alltraps>

8010730b <vector116>:
.globl vector116
vector116:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $116
8010730d:	6a 74                	push   $0x74
  jmp alltraps
8010730f:	e9 a0 f6 ff ff       	jmp    801069b4 <alltraps>

80107314 <vector117>:
.globl vector117
vector117:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $117
80107316:	6a 75                	push   $0x75
  jmp alltraps
80107318:	e9 97 f6 ff ff       	jmp    801069b4 <alltraps>

8010731d <vector118>:
.globl vector118
vector118:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $118
8010731f:	6a 76                	push   $0x76
  jmp alltraps
80107321:	e9 8e f6 ff ff       	jmp    801069b4 <alltraps>

80107326 <vector119>:
.globl vector119
vector119:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $119
80107328:	6a 77                	push   $0x77
  jmp alltraps
8010732a:	e9 85 f6 ff ff       	jmp    801069b4 <alltraps>

8010732f <vector120>:
.globl vector120
vector120:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $120
80107331:	6a 78                	push   $0x78
  jmp alltraps
80107333:	e9 7c f6 ff ff       	jmp    801069b4 <alltraps>

80107338 <vector121>:
.globl vector121
vector121:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $121
8010733a:	6a 79                	push   $0x79
  jmp alltraps
8010733c:	e9 73 f6 ff ff       	jmp    801069b4 <alltraps>

80107341 <vector122>:
.globl vector122
vector122:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $122
80107343:	6a 7a                	push   $0x7a
  jmp alltraps
80107345:	e9 6a f6 ff ff       	jmp    801069b4 <alltraps>

8010734a <vector123>:
.globl vector123
vector123:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $123
8010734c:	6a 7b                	push   $0x7b
  jmp alltraps
8010734e:	e9 61 f6 ff ff       	jmp    801069b4 <alltraps>

80107353 <vector124>:
.globl vector124
vector124:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $124
80107355:	6a 7c                	push   $0x7c
  jmp alltraps
80107357:	e9 58 f6 ff ff       	jmp    801069b4 <alltraps>

8010735c <vector125>:
.globl vector125
vector125:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $125
8010735e:	6a 7d                	push   $0x7d
  jmp alltraps
80107360:	e9 4f f6 ff ff       	jmp    801069b4 <alltraps>

80107365 <vector126>:
.globl vector126
vector126:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $126
80107367:	6a 7e                	push   $0x7e
  jmp alltraps
80107369:	e9 46 f6 ff ff       	jmp    801069b4 <alltraps>

8010736e <vector127>:
.globl vector127
vector127:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $127
80107370:	6a 7f                	push   $0x7f
  jmp alltraps
80107372:	e9 3d f6 ff ff       	jmp    801069b4 <alltraps>

80107377 <vector128>:
.globl vector128
vector128:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $128
80107379:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010737e:	e9 31 f6 ff ff       	jmp    801069b4 <alltraps>

80107383 <vector129>:
.globl vector129
vector129:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $129
80107385:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010738a:	e9 25 f6 ff ff       	jmp    801069b4 <alltraps>

8010738f <vector130>:
.globl vector130
vector130:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $130
80107391:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107396:	e9 19 f6 ff ff       	jmp    801069b4 <alltraps>

8010739b <vector131>:
.globl vector131
vector131:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $131
8010739d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801073a2:	e9 0d f6 ff ff       	jmp    801069b4 <alltraps>

801073a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $132
801073a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801073ae:	e9 01 f6 ff ff       	jmp    801069b4 <alltraps>

801073b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $133
801073b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801073ba:	e9 f5 f5 ff ff       	jmp    801069b4 <alltraps>

801073bf <vector134>:
.globl vector134
vector134:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $134
801073c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801073c6:	e9 e9 f5 ff ff       	jmp    801069b4 <alltraps>

801073cb <vector135>:
.globl vector135
vector135:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $135
801073cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801073d2:	e9 dd f5 ff ff       	jmp    801069b4 <alltraps>

801073d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $136
801073d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801073de:	e9 d1 f5 ff ff       	jmp    801069b4 <alltraps>

801073e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $137
801073e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801073ea:	e9 c5 f5 ff ff       	jmp    801069b4 <alltraps>

801073ef <vector138>:
.globl vector138
vector138:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $138
801073f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801073f6:	e9 b9 f5 ff ff       	jmp    801069b4 <alltraps>

801073fb <vector139>:
.globl vector139
vector139:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $139
801073fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107402:	e9 ad f5 ff ff       	jmp    801069b4 <alltraps>

80107407 <vector140>:
.globl vector140
vector140:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $140
80107409:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010740e:	e9 a1 f5 ff ff       	jmp    801069b4 <alltraps>

80107413 <vector141>:
.globl vector141
vector141:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $141
80107415:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010741a:	e9 95 f5 ff ff       	jmp    801069b4 <alltraps>

8010741f <vector142>:
.globl vector142
vector142:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $142
80107421:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107426:	e9 89 f5 ff ff       	jmp    801069b4 <alltraps>

8010742b <vector143>:
.globl vector143
vector143:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $143
8010742d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107432:	e9 7d f5 ff ff       	jmp    801069b4 <alltraps>

80107437 <vector144>:
.globl vector144
vector144:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $144
80107439:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010743e:	e9 71 f5 ff ff       	jmp    801069b4 <alltraps>

80107443 <vector145>:
.globl vector145
vector145:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $145
80107445:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010744a:	e9 65 f5 ff ff       	jmp    801069b4 <alltraps>

8010744f <vector146>:
.globl vector146
vector146:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $146
80107451:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107456:	e9 59 f5 ff ff       	jmp    801069b4 <alltraps>

8010745b <vector147>:
.globl vector147
vector147:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $147
8010745d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107462:	e9 4d f5 ff ff       	jmp    801069b4 <alltraps>

80107467 <vector148>:
.globl vector148
vector148:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $148
80107469:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010746e:	e9 41 f5 ff ff       	jmp    801069b4 <alltraps>

80107473 <vector149>:
.globl vector149
vector149:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $149
80107475:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010747a:	e9 35 f5 ff ff       	jmp    801069b4 <alltraps>

8010747f <vector150>:
.globl vector150
vector150:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $150
80107481:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107486:	e9 29 f5 ff ff       	jmp    801069b4 <alltraps>

8010748b <vector151>:
.globl vector151
vector151:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $151
8010748d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107492:	e9 1d f5 ff ff       	jmp    801069b4 <alltraps>

80107497 <vector152>:
.globl vector152
vector152:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $152
80107499:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010749e:	e9 11 f5 ff ff       	jmp    801069b4 <alltraps>

801074a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $153
801074a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801074aa:	e9 05 f5 ff ff       	jmp    801069b4 <alltraps>

801074af <vector154>:
.globl vector154
vector154:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $154
801074b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801074b6:	e9 f9 f4 ff ff       	jmp    801069b4 <alltraps>

801074bb <vector155>:
.globl vector155
vector155:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $155
801074bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801074c2:	e9 ed f4 ff ff       	jmp    801069b4 <alltraps>

801074c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $156
801074c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801074ce:	e9 e1 f4 ff ff       	jmp    801069b4 <alltraps>

801074d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $157
801074d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801074da:	e9 d5 f4 ff ff       	jmp    801069b4 <alltraps>

801074df <vector158>:
.globl vector158
vector158:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $158
801074e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801074e6:	e9 c9 f4 ff ff       	jmp    801069b4 <alltraps>

801074eb <vector159>:
.globl vector159
vector159:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $159
801074ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801074f2:	e9 bd f4 ff ff       	jmp    801069b4 <alltraps>

801074f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $160
801074f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801074fe:	e9 b1 f4 ff ff       	jmp    801069b4 <alltraps>

80107503 <vector161>:
.globl vector161
vector161:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $161
80107505:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010750a:	e9 a5 f4 ff ff       	jmp    801069b4 <alltraps>

8010750f <vector162>:
.globl vector162
vector162:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $162
80107511:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107516:	e9 99 f4 ff ff       	jmp    801069b4 <alltraps>

8010751b <vector163>:
.globl vector163
vector163:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $163
8010751d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107522:	e9 8d f4 ff ff       	jmp    801069b4 <alltraps>

80107527 <vector164>:
.globl vector164
vector164:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $164
80107529:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010752e:	e9 81 f4 ff ff       	jmp    801069b4 <alltraps>

80107533 <vector165>:
.globl vector165
vector165:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $165
80107535:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010753a:	e9 75 f4 ff ff       	jmp    801069b4 <alltraps>

8010753f <vector166>:
.globl vector166
vector166:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $166
80107541:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107546:	e9 69 f4 ff ff       	jmp    801069b4 <alltraps>

8010754b <vector167>:
.globl vector167
vector167:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $167
8010754d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107552:	e9 5d f4 ff ff       	jmp    801069b4 <alltraps>

80107557 <vector168>:
.globl vector168
vector168:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $168
80107559:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010755e:	e9 51 f4 ff ff       	jmp    801069b4 <alltraps>

80107563 <vector169>:
.globl vector169
vector169:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $169
80107565:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010756a:	e9 45 f4 ff ff       	jmp    801069b4 <alltraps>

8010756f <vector170>:
.globl vector170
vector170:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $170
80107571:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107576:	e9 39 f4 ff ff       	jmp    801069b4 <alltraps>

8010757b <vector171>:
.globl vector171
vector171:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $171
8010757d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107582:	e9 2d f4 ff ff       	jmp    801069b4 <alltraps>

80107587 <vector172>:
.globl vector172
vector172:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $172
80107589:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010758e:	e9 21 f4 ff ff       	jmp    801069b4 <alltraps>

80107593 <vector173>:
.globl vector173
vector173:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $173
80107595:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010759a:	e9 15 f4 ff ff       	jmp    801069b4 <alltraps>

8010759f <vector174>:
.globl vector174
vector174:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $174
801075a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801075a6:	e9 09 f4 ff ff       	jmp    801069b4 <alltraps>

801075ab <vector175>:
.globl vector175
vector175:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $175
801075ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801075b2:	e9 fd f3 ff ff       	jmp    801069b4 <alltraps>

801075b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $176
801075b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801075be:	e9 f1 f3 ff ff       	jmp    801069b4 <alltraps>

801075c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $177
801075c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801075ca:	e9 e5 f3 ff ff       	jmp    801069b4 <alltraps>

801075cf <vector178>:
.globl vector178
vector178:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $178
801075d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801075d6:	e9 d9 f3 ff ff       	jmp    801069b4 <alltraps>

801075db <vector179>:
.globl vector179
vector179:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $179
801075dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801075e2:	e9 cd f3 ff ff       	jmp    801069b4 <alltraps>

801075e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $180
801075e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801075ee:	e9 c1 f3 ff ff       	jmp    801069b4 <alltraps>

801075f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $181
801075f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801075fa:	e9 b5 f3 ff ff       	jmp    801069b4 <alltraps>

801075ff <vector182>:
.globl vector182
vector182:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $182
80107601:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107606:	e9 a9 f3 ff ff       	jmp    801069b4 <alltraps>

8010760b <vector183>:
.globl vector183
vector183:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $183
8010760d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107612:	e9 9d f3 ff ff       	jmp    801069b4 <alltraps>

80107617 <vector184>:
.globl vector184
vector184:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $184
80107619:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010761e:	e9 91 f3 ff ff       	jmp    801069b4 <alltraps>

80107623 <vector185>:
.globl vector185
vector185:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $185
80107625:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010762a:	e9 85 f3 ff ff       	jmp    801069b4 <alltraps>

8010762f <vector186>:
.globl vector186
vector186:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $186
80107631:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107636:	e9 79 f3 ff ff       	jmp    801069b4 <alltraps>

8010763b <vector187>:
.globl vector187
vector187:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $187
8010763d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107642:	e9 6d f3 ff ff       	jmp    801069b4 <alltraps>

80107647 <vector188>:
.globl vector188
vector188:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $188
80107649:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010764e:	e9 61 f3 ff ff       	jmp    801069b4 <alltraps>

80107653 <vector189>:
.globl vector189
vector189:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $189
80107655:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010765a:	e9 55 f3 ff ff       	jmp    801069b4 <alltraps>

8010765f <vector190>:
.globl vector190
vector190:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $190
80107661:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107666:	e9 49 f3 ff ff       	jmp    801069b4 <alltraps>

8010766b <vector191>:
.globl vector191
vector191:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $191
8010766d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107672:	e9 3d f3 ff ff       	jmp    801069b4 <alltraps>

80107677 <vector192>:
.globl vector192
vector192:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $192
80107679:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010767e:	e9 31 f3 ff ff       	jmp    801069b4 <alltraps>

80107683 <vector193>:
.globl vector193
vector193:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $193
80107685:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010768a:	e9 25 f3 ff ff       	jmp    801069b4 <alltraps>

8010768f <vector194>:
.globl vector194
vector194:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $194
80107691:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107696:	e9 19 f3 ff ff       	jmp    801069b4 <alltraps>

8010769b <vector195>:
.globl vector195
vector195:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $195
8010769d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801076a2:	e9 0d f3 ff ff       	jmp    801069b4 <alltraps>

801076a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $196
801076a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801076ae:	e9 01 f3 ff ff       	jmp    801069b4 <alltraps>

801076b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $197
801076b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801076ba:	e9 f5 f2 ff ff       	jmp    801069b4 <alltraps>

801076bf <vector198>:
.globl vector198
vector198:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $198
801076c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801076c6:	e9 e9 f2 ff ff       	jmp    801069b4 <alltraps>

801076cb <vector199>:
.globl vector199
vector199:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $199
801076cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801076d2:	e9 dd f2 ff ff       	jmp    801069b4 <alltraps>

801076d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $200
801076d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801076de:	e9 d1 f2 ff ff       	jmp    801069b4 <alltraps>

801076e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $201
801076e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801076ea:	e9 c5 f2 ff ff       	jmp    801069b4 <alltraps>

801076ef <vector202>:
.globl vector202
vector202:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $202
801076f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801076f6:	e9 b9 f2 ff ff       	jmp    801069b4 <alltraps>

801076fb <vector203>:
.globl vector203
vector203:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $203
801076fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107702:	e9 ad f2 ff ff       	jmp    801069b4 <alltraps>

80107707 <vector204>:
.globl vector204
vector204:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $204
80107709:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010770e:	e9 a1 f2 ff ff       	jmp    801069b4 <alltraps>

80107713 <vector205>:
.globl vector205
vector205:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $205
80107715:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010771a:	e9 95 f2 ff ff       	jmp    801069b4 <alltraps>

8010771f <vector206>:
.globl vector206
vector206:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $206
80107721:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107726:	e9 89 f2 ff ff       	jmp    801069b4 <alltraps>

8010772b <vector207>:
.globl vector207
vector207:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $207
8010772d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107732:	e9 7d f2 ff ff       	jmp    801069b4 <alltraps>

80107737 <vector208>:
.globl vector208
vector208:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $208
80107739:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010773e:	e9 71 f2 ff ff       	jmp    801069b4 <alltraps>

80107743 <vector209>:
.globl vector209
vector209:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $209
80107745:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010774a:	e9 65 f2 ff ff       	jmp    801069b4 <alltraps>

8010774f <vector210>:
.globl vector210
vector210:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $210
80107751:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107756:	e9 59 f2 ff ff       	jmp    801069b4 <alltraps>

8010775b <vector211>:
.globl vector211
vector211:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $211
8010775d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107762:	e9 4d f2 ff ff       	jmp    801069b4 <alltraps>

80107767 <vector212>:
.globl vector212
vector212:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $212
80107769:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010776e:	e9 41 f2 ff ff       	jmp    801069b4 <alltraps>

80107773 <vector213>:
.globl vector213
vector213:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $213
80107775:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010777a:	e9 35 f2 ff ff       	jmp    801069b4 <alltraps>

8010777f <vector214>:
.globl vector214
vector214:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $214
80107781:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107786:	e9 29 f2 ff ff       	jmp    801069b4 <alltraps>

8010778b <vector215>:
.globl vector215
vector215:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $215
8010778d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107792:	e9 1d f2 ff ff       	jmp    801069b4 <alltraps>

80107797 <vector216>:
.globl vector216
vector216:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $216
80107799:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010779e:	e9 11 f2 ff ff       	jmp    801069b4 <alltraps>

801077a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $217
801077a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801077aa:	e9 05 f2 ff ff       	jmp    801069b4 <alltraps>

801077af <vector218>:
.globl vector218
vector218:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $218
801077b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801077b6:	e9 f9 f1 ff ff       	jmp    801069b4 <alltraps>

801077bb <vector219>:
.globl vector219
vector219:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $219
801077bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801077c2:	e9 ed f1 ff ff       	jmp    801069b4 <alltraps>

801077c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $220
801077c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801077ce:	e9 e1 f1 ff ff       	jmp    801069b4 <alltraps>

801077d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $221
801077d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801077da:	e9 d5 f1 ff ff       	jmp    801069b4 <alltraps>

801077df <vector222>:
.globl vector222
vector222:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $222
801077e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801077e6:	e9 c9 f1 ff ff       	jmp    801069b4 <alltraps>

801077eb <vector223>:
.globl vector223
vector223:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $223
801077ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801077f2:	e9 bd f1 ff ff       	jmp    801069b4 <alltraps>

801077f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $224
801077f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801077fe:	e9 b1 f1 ff ff       	jmp    801069b4 <alltraps>

80107803 <vector225>:
.globl vector225
vector225:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $225
80107805:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010780a:	e9 a5 f1 ff ff       	jmp    801069b4 <alltraps>

8010780f <vector226>:
.globl vector226
vector226:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $226
80107811:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107816:	e9 99 f1 ff ff       	jmp    801069b4 <alltraps>

8010781b <vector227>:
.globl vector227
vector227:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $227
8010781d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107822:	e9 8d f1 ff ff       	jmp    801069b4 <alltraps>

80107827 <vector228>:
.globl vector228
vector228:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $228
80107829:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010782e:	e9 81 f1 ff ff       	jmp    801069b4 <alltraps>

80107833 <vector229>:
.globl vector229
vector229:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $229
80107835:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010783a:	e9 75 f1 ff ff       	jmp    801069b4 <alltraps>

8010783f <vector230>:
.globl vector230
vector230:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $230
80107841:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107846:	e9 69 f1 ff ff       	jmp    801069b4 <alltraps>

8010784b <vector231>:
.globl vector231
vector231:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $231
8010784d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107852:	e9 5d f1 ff ff       	jmp    801069b4 <alltraps>

80107857 <vector232>:
.globl vector232
vector232:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $232
80107859:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010785e:	e9 51 f1 ff ff       	jmp    801069b4 <alltraps>

80107863 <vector233>:
.globl vector233
vector233:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $233
80107865:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010786a:	e9 45 f1 ff ff       	jmp    801069b4 <alltraps>

8010786f <vector234>:
.globl vector234
vector234:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $234
80107871:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107876:	e9 39 f1 ff ff       	jmp    801069b4 <alltraps>

8010787b <vector235>:
.globl vector235
vector235:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $235
8010787d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107882:	e9 2d f1 ff ff       	jmp    801069b4 <alltraps>

80107887 <vector236>:
.globl vector236
vector236:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $236
80107889:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010788e:	e9 21 f1 ff ff       	jmp    801069b4 <alltraps>

80107893 <vector237>:
.globl vector237
vector237:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $237
80107895:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010789a:	e9 15 f1 ff ff       	jmp    801069b4 <alltraps>

8010789f <vector238>:
.globl vector238
vector238:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $238
801078a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801078a6:	e9 09 f1 ff ff       	jmp    801069b4 <alltraps>

801078ab <vector239>:
.globl vector239
vector239:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $239
801078ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801078b2:	e9 fd f0 ff ff       	jmp    801069b4 <alltraps>

801078b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $240
801078b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801078be:	e9 f1 f0 ff ff       	jmp    801069b4 <alltraps>

801078c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $241
801078c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801078ca:	e9 e5 f0 ff ff       	jmp    801069b4 <alltraps>

801078cf <vector242>:
.globl vector242
vector242:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $242
801078d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801078d6:	e9 d9 f0 ff ff       	jmp    801069b4 <alltraps>

801078db <vector243>:
.globl vector243
vector243:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $243
801078dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801078e2:	e9 cd f0 ff ff       	jmp    801069b4 <alltraps>

801078e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $244
801078e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801078ee:	e9 c1 f0 ff ff       	jmp    801069b4 <alltraps>

801078f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $245
801078f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801078fa:	e9 b5 f0 ff ff       	jmp    801069b4 <alltraps>

801078ff <vector246>:
.globl vector246
vector246:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $246
80107901:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107906:	e9 a9 f0 ff ff       	jmp    801069b4 <alltraps>

8010790b <vector247>:
.globl vector247
vector247:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $247
8010790d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107912:	e9 9d f0 ff ff       	jmp    801069b4 <alltraps>

80107917 <vector248>:
.globl vector248
vector248:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $248
80107919:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010791e:	e9 91 f0 ff ff       	jmp    801069b4 <alltraps>

80107923 <vector249>:
.globl vector249
vector249:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $249
80107925:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010792a:	e9 85 f0 ff ff       	jmp    801069b4 <alltraps>

8010792f <vector250>:
.globl vector250
vector250:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $250
80107931:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107936:	e9 79 f0 ff ff       	jmp    801069b4 <alltraps>

8010793b <vector251>:
.globl vector251
vector251:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $251
8010793d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107942:	e9 6d f0 ff ff       	jmp    801069b4 <alltraps>

80107947 <vector252>:
.globl vector252
vector252:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $252
80107949:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010794e:	e9 61 f0 ff ff       	jmp    801069b4 <alltraps>

80107953 <vector253>:
.globl vector253
vector253:
  pushl $0
80107953:	6a 00                	push   $0x0
  pushl $253
80107955:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010795a:	e9 55 f0 ff ff       	jmp    801069b4 <alltraps>

8010795f <vector254>:
.globl vector254
vector254:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $254
80107961:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107966:	e9 49 f0 ff ff       	jmp    801069b4 <alltraps>

8010796b <vector255>:
.globl vector255
vector255:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $255
8010796d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107972:	e9 3d f0 ff ff       	jmp    801069b4 <alltraps>
80107977:	66 90                	xchg   %ax,%ax
80107979:	66 90                	xchg   %ax,%ax
8010797b:	66 90                	xchg   %ax,%ax
8010797d:	66 90                	xchg   %ax,%ax
8010797f:	90                   	nop

80107980 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107986:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010798c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107992:	83 ec 1c             	sub    $0x1c,%esp
80107995:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107998:	39 d3                	cmp    %edx,%ebx
8010799a:	73 49                	jae    801079e5 <deallocuvm.part.0+0x65>
8010799c:	89 c7                	mov    %eax,%edi
8010799e:	eb 0c                	jmp    801079ac <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801079a0:	83 c0 01             	add    $0x1,%eax
801079a3:	c1 e0 16             	shl    $0x16,%eax
801079a6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801079a8:	39 da                	cmp    %ebx,%edx
801079aa:	76 39                	jbe    801079e5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801079ac:	89 d8                	mov    %ebx,%eax
801079ae:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801079b1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801079b4:	f6 c1 01             	test   $0x1,%cl
801079b7:	74 e7                	je     801079a0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801079b9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079bb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801079c1:	c1 ee 0a             	shr    $0xa,%esi
801079c4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801079ca:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801079d1:	85 f6                	test   %esi,%esi
801079d3:	74 cb                	je     801079a0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801079d5:	8b 06                	mov    (%esi),%eax
801079d7:	a8 01                	test   $0x1,%al
801079d9:	75 15                	jne    801079f0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801079db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079e1:	39 da                	cmp    %ebx,%edx
801079e3:	77 c7                	ja     801079ac <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801079e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079eb:	5b                   	pop    %ebx
801079ec:	5e                   	pop    %esi
801079ed:	5f                   	pop    %edi
801079ee:	5d                   	pop    %ebp
801079ef:	c3                   	ret    
      if(pa == 0)
801079f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079f5:	74 25                	je     80107a1c <deallocuvm.part.0+0x9c>
      kfree(v);
801079f7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801079fa:	05 00 00 00 80       	add    $0x80000000,%eax
801079ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107a08:	50                   	push   %eax
80107a09:	e8 12 b1 ff ff       	call   80102b20 <kfree>
      *pte = 0;
80107a0e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107a14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a17:	83 c4 10             	add    $0x10,%esp
80107a1a:	eb 8c                	jmp    801079a8 <deallocuvm.part.0+0x28>
        panic("kfree");
80107a1c:	83 ec 0c             	sub    $0xc,%esp
80107a1f:	68 0a 88 10 80       	push   $0x8010880a
80107a24:	e8 57 89 ff ff       	call   80100380 <panic>
80107a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a30 <mappages>:
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	57                   	push   %edi
80107a34:	56                   	push   %esi
80107a35:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107a36:	89 d3                	mov    %edx,%ebx
80107a38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107a3e:	83 ec 1c             	sub    $0x1c,%esp
80107a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107a44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107a48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107a50:	8b 45 08             	mov    0x8(%ebp),%eax
80107a53:	29 d8                	sub    %ebx,%eax
80107a55:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a58:	eb 3d                	jmp    80107a97 <mappages+0x67>
80107a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107a60:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107a67:	c1 ea 0a             	shr    $0xa,%edx
80107a6a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107a70:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a77:	85 c0                	test   %eax,%eax
80107a79:	74 75                	je     80107af0 <mappages+0xc0>
    if(*pte & PTE_P)
80107a7b:	f6 00 01             	testb  $0x1,(%eax)
80107a7e:	0f 85 86 00 00 00    	jne    80107b0a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107a84:	0b 75 0c             	or     0xc(%ebp),%esi
80107a87:	83 ce 01             	or     $0x1,%esi
80107a8a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107a8c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80107a8f:	74 6f                	je     80107b00 <mappages+0xd0>
    a += PGSIZE;
80107a91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107a9a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a9d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107aa0:	89 d8                	mov    %ebx,%eax
80107aa2:	c1 e8 16             	shr    $0x16,%eax
80107aa5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107aa8:	8b 07                	mov    (%edi),%eax
80107aaa:	a8 01                	test   $0x1,%al
80107aac:	75 b2                	jne    80107a60 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107aae:	e8 2d b2 ff ff       	call   80102ce0 <kalloc>
80107ab3:	85 c0                	test   %eax,%eax
80107ab5:	74 39                	je     80107af0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107ab7:	83 ec 04             	sub    $0x4,%esp
80107aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107abd:	68 00 10 00 00       	push   $0x1000
80107ac2:	6a 00                	push   $0x0
80107ac4:	50                   	push   %eax
80107ac5:	e8 a6 db ff ff       	call   80105670 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107aca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107acd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107ad0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107ad6:	83 c8 07             	or     $0x7,%eax
80107ad9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107adb:	89 d8                	mov    %ebx,%eax
80107add:	c1 e8 0a             	shr    $0xa,%eax
80107ae0:	25 fc 0f 00 00       	and    $0xffc,%eax
80107ae5:	01 d0                	add    %edx,%eax
80107ae7:	eb 92                	jmp    80107a7b <mappages+0x4b>
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107af8:	5b                   	pop    %ebx
80107af9:	5e                   	pop    %esi
80107afa:	5f                   	pop    %edi
80107afb:	5d                   	pop    %ebp
80107afc:	c3                   	ret    
80107afd:	8d 76 00             	lea    0x0(%esi),%esi
80107b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b03:	31 c0                	xor    %eax,%eax
}
80107b05:	5b                   	pop    %ebx
80107b06:	5e                   	pop    %esi
80107b07:	5f                   	pop    %edi
80107b08:	5d                   	pop    %ebp
80107b09:	c3                   	ret    
      panic("remap");
80107b0a:	83 ec 0c             	sub    $0xc,%esp
80107b0d:	68 6c 8f 10 80       	push   $0x80108f6c
80107b12:	e8 69 88 ff ff       	call   80100380 <panic>
80107b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b1e:	66 90                	xchg   %ax,%ax

80107b20 <seginit>:
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107b26:	e8 55 c5 ff ff       	call   80104080 <cpuid>
  pd[0] = size-1;
80107b2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107b30:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107b36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107b3a:	c7 80 f8 3d 11 80 ff 	movl   $0xffff,-0x7feec208(%eax)
80107b41:	ff 00 00 
80107b44:	c7 80 fc 3d 11 80 00 	movl   $0xcf9a00,-0x7feec204(%eax)
80107b4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107b4e:	c7 80 00 3e 11 80 ff 	movl   $0xffff,-0x7feec200(%eax)
80107b55:	ff 00 00 
80107b58:	c7 80 04 3e 11 80 00 	movl   $0xcf9200,-0x7feec1fc(%eax)
80107b5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107b62:	c7 80 08 3e 11 80 ff 	movl   $0xffff,-0x7feec1f8(%eax)
80107b69:	ff 00 00 
80107b6c:	c7 80 0c 3e 11 80 00 	movl   $0xcffa00,-0x7feec1f4(%eax)
80107b73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107b76:	c7 80 10 3e 11 80 ff 	movl   $0xffff,-0x7feec1f0(%eax)
80107b7d:	ff 00 00 
80107b80:	c7 80 14 3e 11 80 00 	movl   $0xcff200,-0x7feec1ec(%eax)
80107b87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107b8a:	05 f0 3d 11 80       	add    $0x80113df0,%eax
  pd[1] = (uint)p;
80107b8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107b93:	c1 e8 10             	shr    $0x10,%eax
80107b96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107b9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107b9d:	0f 01 10             	lgdtl  (%eax)
}
80107ba0:	c9                   	leave  
80107ba1:	c3                   	ret    
80107ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107bb0:	a1 a4 73 11 80       	mov    0x801173a4,%eax
80107bb5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bba:	0f 22 d8             	mov    %eax,%cr3
}
80107bbd:	c3                   	ret    
80107bbe:	66 90                	xchg   %ax,%ax

80107bc0 <switchuvm>:
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	57                   	push   %edi
80107bc4:	56                   	push   %esi
80107bc5:	53                   	push   %ebx
80107bc6:	83 ec 1c             	sub    $0x1c,%esp
80107bc9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107bcc:	85 f6                	test   %esi,%esi
80107bce:	0f 84 cb 00 00 00    	je     80107c9f <switchuvm+0xdf>
  if(p->kstack == 0)
80107bd4:	8b 46 08             	mov    0x8(%esi),%eax
80107bd7:	85 c0                	test   %eax,%eax
80107bd9:	0f 84 da 00 00 00    	je     80107cb9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107bdf:	8b 46 04             	mov    0x4(%esi),%eax
80107be2:	85 c0                	test   %eax,%eax
80107be4:	0f 84 c2 00 00 00    	je     80107cac <switchuvm+0xec>
  pushcli();
80107bea:	e8 71 d8 ff ff       	call   80105460 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107bef:	e8 2c c4 ff ff       	call   80104020 <mycpu>
80107bf4:	89 c3                	mov    %eax,%ebx
80107bf6:	e8 25 c4 ff ff       	call   80104020 <mycpu>
80107bfb:	89 c7                	mov    %eax,%edi
80107bfd:	e8 1e c4 ff ff       	call   80104020 <mycpu>
80107c02:	83 c7 08             	add    $0x8,%edi
80107c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c08:	e8 13 c4 ff ff       	call   80104020 <mycpu>
80107c0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c10:	ba 67 00 00 00       	mov    $0x67,%edx
80107c15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107c1c:	83 c0 08             	add    $0x8,%eax
80107c1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c2b:	83 c1 08             	add    $0x8,%ecx
80107c2e:	c1 e8 18             	shr    $0x18,%eax
80107c31:	c1 e9 10             	shr    $0x10,%ecx
80107c34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107c3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107c40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107c45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107c4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107c51:	e8 ca c3 ff ff       	call   80104020 <mycpu>
80107c56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107c5d:	e8 be c3 ff ff       	call   80104020 <mycpu>
80107c62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107c66:	8b 5e 08             	mov    0x8(%esi),%ebx
80107c69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c6f:	e8 ac c3 ff ff       	call   80104020 <mycpu>
80107c74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c77:	e8 a4 c3 ff ff       	call   80104020 <mycpu>
80107c7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107c80:	b8 28 00 00 00       	mov    $0x28,%eax
80107c85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107c88:	8b 46 04             	mov    0x4(%esi),%eax
80107c8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c90:	0f 22 d8             	mov    %eax,%cr3
}
80107c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c96:	5b                   	pop    %ebx
80107c97:	5e                   	pop    %esi
80107c98:	5f                   	pop    %edi
80107c99:	5d                   	pop    %ebp
  popcli();
80107c9a:	e9 11 d8 ff ff       	jmp    801054b0 <popcli>
    panic("switchuvm: no process");
80107c9f:	83 ec 0c             	sub    $0xc,%esp
80107ca2:	68 72 8f 10 80       	push   $0x80108f72
80107ca7:	e8 d4 86 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107cac:	83 ec 0c             	sub    $0xc,%esp
80107caf:	68 9d 8f 10 80       	push   $0x80108f9d
80107cb4:	e8 c7 86 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107cb9:	83 ec 0c             	sub    $0xc,%esp
80107cbc:	68 88 8f 10 80       	push   $0x80108f88
80107cc1:	e8 ba 86 ff ff       	call   80100380 <panic>
80107cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ccd:	8d 76 00             	lea    0x0(%esi),%esi

80107cd0 <inituvm>:
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	57                   	push   %edi
80107cd4:	56                   	push   %esi
80107cd5:	53                   	push   %ebx
80107cd6:	83 ec 1c             	sub    $0x1c,%esp
80107cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cdc:	8b 75 10             	mov    0x10(%ebp),%esi
80107cdf:	8b 7d 08             	mov    0x8(%ebp),%edi
80107ce2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107ce5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107ceb:	77 4b                	ja     80107d38 <inituvm+0x68>
  mem = kalloc();
80107ced:	e8 ee af ff ff       	call   80102ce0 <kalloc>
  memset(mem, 0, PGSIZE);
80107cf2:	83 ec 04             	sub    $0x4,%esp
80107cf5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107cfa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107cfc:	6a 00                	push   $0x0
80107cfe:	50                   	push   %eax
80107cff:	e8 6c d9 ff ff       	call   80105670 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107d04:	58                   	pop    %eax
80107d05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d0b:	5a                   	pop    %edx
80107d0c:	6a 06                	push   $0x6
80107d0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d13:	31 d2                	xor    %edx,%edx
80107d15:	50                   	push   %eax
80107d16:	89 f8                	mov    %edi,%eax
80107d18:	e8 13 fd ff ff       	call   80107a30 <mappages>
  memmove(mem, init, sz);
80107d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d20:	89 75 10             	mov    %esi,0x10(%ebp)
80107d23:	83 c4 10             	add    $0x10,%esp
80107d26:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107d29:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d2f:	5b                   	pop    %ebx
80107d30:	5e                   	pop    %esi
80107d31:	5f                   	pop    %edi
80107d32:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107d33:	e9 d8 d9 ff ff       	jmp    80105710 <memmove>
    panic("inituvm: more than a page");
80107d38:	83 ec 0c             	sub    $0xc,%esp
80107d3b:	68 b1 8f 10 80       	push   $0x80108fb1
80107d40:	e8 3b 86 ff ff       	call   80100380 <panic>
80107d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d50 <loaduvm>:
{
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	57                   	push   %edi
80107d54:	56                   	push   %esi
80107d55:	53                   	push   %ebx
80107d56:	83 ec 1c             	sub    $0x1c,%esp
80107d59:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d5c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107d5f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107d64:	0f 85 bb 00 00 00    	jne    80107e25 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107d6a:	01 f0                	add    %esi,%eax
80107d6c:	89 f3                	mov    %esi,%ebx
80107d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d71:	8b 45 14             	mov    0x14(%ebp),%eax
80107d74:	01 f0                	add    %esi,%eax
80107d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107d79:	85 f6                	test   %esi,%esi
80107d7b:	0f 84 87 00 00 00    	je     80107e08 <loaduvm+0xb8>
80107d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107d8e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107d90:	89 c2                	mov    %eax,%edx
80107d92:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107d95:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107d98:	f6 c2 01             	test   $0x1,%dl
80107d9b:	75 13                	jne    80107db0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107d9d:	83 ec 0c             	sub    $0xc,%esp
80107da0:	68 cb 8f 10 80       	push   $0x80108fcb
80107da5:	e8 d6 85 ff ff       	call   80100380 <panic>
80107daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107db0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107db3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107db9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107dbe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107dc5:	85 c0                	test   %eax,%eax
80107dc7:	74 d4                	je     80107d9d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107dc9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107dcb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107dce:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107dd8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107dde:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107de1:	29 d9                	sub    %ebx,%ecx
80107de3:	05 00 00 00 80       	add    $0x80000000,%eax
80107de8:	57                   	push   %edi
80107de9:	51                   	push   %ecx
80107dea:	50                   	push   %eax
80107deb:	ff 75 10             	push   0x10(%ebp)
80107dee:	e8 fd a2 ff ff       	call   801020f0 <readi>
80107df3:	83 c4 10             	add    $0x10,%esp
80107df6:	39 f8                	cmp    %edi,%eax
80107df8:	75 1e                	jne    80107e18 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107dfa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107e00:	89 f0                	mov    %esi,%eax
80107e02:	29 d8                	sub    %ebx,%eax
80107e04:	39 c6                	cmp    %eax,%esi
80107e06:	77 80                	ja     80107d88 <loaduvm+0x38>
}
80107e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e0b:	31 c0                	xor    %eax,%eax
}
80107e0d:	5b                   	pop    %ebx
80107e0e:	5e                   	pop    %esi
80107e0f:	5f                   	pop    %edi
80107e10:	5d                   	pop    %ebp
80107e11:	c3                   	ret    
80107e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e20:	5b                   	pop    %ebx
80107e21:	5e                   	pop    %esi
80107e22:	5f                   	pop    %edi
80107e23:	5d                   	pop    %ebp
80107e24:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107e25:	83 ec 0c             	sub    $0xc,%esp
80107e28:	68 a8 90 10 80       	push   $0x801090a8
80107e2d:	e8 4e 85 ff ff       	call   80100380 <panic>
80107e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e40 <allocuvm>:
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	57                   	push   %edi
80107e44:	56                   	push   %esi
80107e45:	53                   	push   %ebx
80107e46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107e49:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107e4c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107e4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e52:	85 c0                	test   %eax,%eax
80107e54:	0f 88 b6 00 00 00    	js     80107f10 <allocuvm+0xd0>
  if(newsz < oldsz)
80107e5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107e60:	0f 82 9a 00 00 00    	jb     80107f00 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107e66:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107e6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107e72:	39 75 10             	cmp    %esi,0x10(%ebp)
80107e75:	77 44                	ja     80107ebb <allocuvm+0x7b>
80107e77:	e9 87 00 00 00       	jmp    80107f03 <allocuvm+0xc3>
80107e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107e80:	83 ec 04             	sub    $0x4,%esp
80107e83:	68 00 10 00 00       	push   $0x1000
80107e88:	6a 00                	push   $0x0
80107e8a:	50                   	push   %eax
80107e8b:	e8 e0 d7 ff ff       	call   80105670 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107e90:	58                   	pop    %eax
80107e91:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e97:	5a                   	pop    %edx
80107e98:	6a 06                	push   $0x6
80107e9a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e9f:	89 f2                	mov    %esi,%edx
80107ea1:	50                   	push   %eax
80107ea2:	89 f8                	mov    %edi,%eax
80107ea4:	e8 87 fb ff ff       	call   80107a30 <mappages>
80107ea9:	83 c4 10             	add    $0x10,%esp
80107eac:	85 c0                	test   %eax,%eax
80107eae:	78 78                	js     80107f28 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107eb0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107eb6:	39 75 10             	cmp    %esi,0x10(%ebp)
80107eb9:	76 48                	jbe    80107f03 <allocuvm+0xc3>
    mem = kalloc();
80107ebb:	e8 20 ae ff ff       	call   80102ce0 <kalloc>
80107ec0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107ec2:	85 c0                	test   %eax,%eax
80107ec4:	75 ba                	jne    80107e80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107ec6:	83 ec 0c             	sub    $0xc,%esp
80107ec9:	68 e9 8f 10 80       	push   $0x80108fe9
80107ece:	e8 cd 87 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ed6:	83 c4 10             	add    $0x10,%esp
80107ed9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107edc:	74 32                	je     80107f10 <allocuvm+0xd0>
80107ede:	8b 55 10             	mov    0x10(%ebp),%edx
80107ee1:	89 c1                	mov    %eax,%ecx
80107ee3:	89 f8                	mov    %edi,%eax
80107ee5:	e8 96 fa ff ff       	call   80107980 <deallocuvm.part.0>
      return 0;
80107eea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ef7:	5b                   	pop    %ebx
80107ef8:	5e                   	pop    %esi
80107ef9:	5f                   	pop    %edi
80107efa:	5d                   	pop    %ebp
80107efb:	c3                   	ret    
80107efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f09:	5b                   	pop    %ebx
80107f0a:	5e                   	pop    %esi
80107f0b:	5f                   	pop    %edi
80107f0c:	5d                   	pop    %ebp
80107f0d:	c3                   	ret    
80107f0e:	66 90                	xchg   %ax,%ax
    return 0;
80107f10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f1d:	5b                   	pop    %ebx
80107f1e:	5e                   	pop    %esi
80107f1f:	5f                   	pop    %edi
80107f20:	5d                   	pop    %ebp
80107f21:	c3                   	ret    
80107f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107f28:	83 ec 0c             	sub    $0xc,%esp
80107f2b:	68 01 90 10 80       	push   $0x80109001
80107f30:	e8 6b 87 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107f35:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f38:	83 c4 10             	add    $0x10,%esp
80107f3b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107f3e:	74 0c                	je     80107f4c <allocuvm+0x10c>
80107f40:	8b 55 10             	mov    0x10(%ebp),%edx
80107f43:	89 c1                	mov    %eax,%ecx
80107f45:	89 f8                	mov    %edi,%eax
80107f47:	e8 34 fa ff ff       	call   80107980 <deallocuvm.part.0>
      kfree(mem);
80107f4c:	83 ec 0c             	sub    $0xc,%esp
80107f4f:	53                   	push   %ebx
80107f50:	e8 cb ab ff ff       	call   80102b20 <kfree>
      return 0;
80107f55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107f5c:	83 c4 10             	add    $0x10,%esp
}
80107f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f65:	5b                   	pop    %ebx
80107f66:	5e                   	pop    %esi
80107f67:	5f                   	pop    %edi
80107f68:	5d                   	pop    %ebp
80107f69:	c3                   	ret    
80107f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f70 <deallocuvm>:
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107f79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107f7c:	39 d1                	cmp    %edx,%ecx
80107f7e:	73 10                	jae    80107f90 <deallocuvm+0x20>
}
80107f80:	5d                   	pop    %ebp
80107f81:	e9 fa f9 ff ff       	jmp    80107980 <deallocuvm.part.0>
80107f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f8d:	8d 76 00             	lea    0x0(%esi),%esi
80107f90:	89 d0                	mov    %edx,%eax
80107f92:	5d                   	pop    %ebp
80107f93:	c3                   	ret    
80107f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f9f:	90                   	nop

80107fa0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fa0:	55                   	push   %ebp
80107fa1:	89 e5                	mov    %esp,%ebp
80107fa3:	57                   	push   %edi
80107fa4:	56                   	push   %esi
80107fa5:	53                   	push   %ebx
80107fa6:	83 ec 0c             	sub    $0xc,%esp
80107fa9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107fac:	85 f6                	test   %esi,%esi
80107fae:	74 59                	je     80108009 <freevm+0x69>
  if(newsz >= oldsz)
80107fb0:	31 c9                	xor    %ecx,%ecx
80107fb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107fb7:	89 f0                	mov    %esi,%eax
80107fb9:	89 f3                	mov    %esi,%ebx
80107fbb:	e8 c0 f9 ff ff       	call   80107980 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107fc0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107fc6:	eb 0f                	jmp    80107fd7 <freevm+0x37>
80107fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fcf:	90                   	nop
80107fd0:	83 c3 04             	add    $0x4,%ebx
80107fd3:	39 df                	cmp    %ebx,%edi
80107fd5:	74 23                	je     80107ffa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107fd7:	8b 03                	mov    (%ebx),%eax
80107fd9:	a8 01                	test   $0x1,%al
80107fdb:	74 f3                	je     80107fd0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107fdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107fe2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107fe5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107fe8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107fed:	50                   	push   %eax
80107fee:	e8 2d ab ff ff       	call   80102b20 <kfree>
80107ff3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ff6:	39 df                	cmp    %ebx,%edi
80107ff8:	75 dd                	jne    80107fd7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107ffa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108000:	5b                   	pop    %ebx
80108001:	5e                   	pop    %esi
80108002:	5f                   	pop    %edi
80108003:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108004:	e9 17 ab ff ff       	jmp    80102b20 <kfree>
    panic("freevm: no pgdir");
80108009:	83 ec 0c             	sub    $0xc,%esp
8010800c:	68 1d 90 10 80       	push   $0x8010901d
80108011:	e8 6a 83 ff ff       	call   80100380 <panic>
80108016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010801d:	8d 76 00             	lea    0x0(%esi),%esi

80108020 <setupkvm>:
{
80108020:	55                   	push   %ebp
80108021:	89 e5                	mov    %esp,%ebp
80108023:	56                   	push   %esi
80108024:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108025:	e8 b6 ac ff ff       	call   80102ce0 <kalloc>
8010802a:	89 c6                	mov    %eax,%esi
8010802c:	85 c0                	test   %eax,%eax
8010802e:	74 42                	je     80108072 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108030:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108033:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108038:	68 00 10 00 00       	push   $0x1000
8010803d:	6a 00                	push   $0x0
8010803f:	50                   	push   %eax
80108040:	e8 2b d6 ff ff       	call   80105670 <memset>
80108045:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108048:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010804b:	83 ec 08             	sub    $0x8,%esp
8010804e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108051:	ff 73 0c             	push   0xc(%ebx)
80108054:	8b 13                	mov    (%ebx),%edx
80108056:	50                   	push   %eax
80108057:	29 c1                	sub    %eax,%ecx
80108059:	89 f0                	mov    %esi,%eax
8010805b:	e8 d0 f9 ff ff       	call   80107a30 <mappages>
80108060:	83 c4 10             	add    $0x10,%esp
80108063:	85 c0                	test   %eax,%eax
80108065:	78 19                	js     80108080 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108067:	83 c3 10             	add    $0x10,%ebx
8010806a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108070:	75 d6                	jne    80108048 <setupkvm+0x28>
}
80108072:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108075:	89 f0                	mov    %esi,%eax
80108077:	5b                   	pop    %ebx
80108078:	5e                   	pop    %esi
80108079:	5d                   	pop    %ebp
8010807a:	c3                   	ret    
8010807b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010807f:	90                   	nop
      freevm(pgdir);
80108080:	83 ec 0c             	sub    $0xc,%esp
80108083:	56                   	push   %esi
      return 0;
80108084:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108086:	e8 15 ff ff ff       	call   80107fa0 <freevm>
      return 0;
8010808b:	83 c4 10             	add    $0x10,%esp
}
8010808e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108091:	89 f0                	mov    %esi,%eax
80108093:	5b                   	pop    %ebx
80108094:	5e                   	pop    %esi
80108095:	5d                   	pop    %ebp
80108096:	c3                   	ret    
80108097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010809e:	66 90                	xchg   %ax,%ax

801080a0 <kvmalloc>:
{
801080a0:	55                   	push   %ebp
801080a1:	89 e5                	mov    %esp,%ebp
801080a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080a6:	e8 75 ff ff ff       	call   80108020 <setupkvm>
801080ab:	a3 a4 73 11 80       	mov    %eax,0x801173a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801080b0:	05 00 00 00 80       	add    $0x80000000,%eax
801080b5:	0f 22 d8             	mov    %eax,%cr3
}
801080b8:	c9                   	leave  
801080b9:	c3                   	ret    
801080ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801080c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801080c0:	55                   	push   %ebp
801080c1:	89 e5                	mov    %esp,%ebp
801080c3:	83 ec 08             	sub    $0x8,%esp
801080c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801080c9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801080cc:	89 c1                	mov    %eax,%ecx
801080ce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801080d1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801080d4:	f6 c2 01             	test   $0x1,%dl
801080d7:	75 17                	jne    801080f0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801080d9:	83 ec 0c             	sub    $0xc,%esp
801080dc:	68 2e 90 10 80       	push   $0x8010902e
801080e1:	e8 9a 82 ff ff       	call   80100380 <panic>
801080e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080ed:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801080f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801080f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801080f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801080fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108105:	85 c0                	test   %eax,%eax
80108107:	74 d0                	je     801080d9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108109:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010810c:	c9                   	leave  
8010810d:	c3                   	ret    
8010810e:	66 90                	xchg   %ax,%ax

80108110 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108110:	55                   	push   %ebp
80108111:	89 e5                	mov    %esp,%ebp
80108113:	57                   	push   %edi
80108114:	56                   	push   %esi
80108115:	53                   	push   %ebx
80108116:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108119:	e8 02 ff ff ff       	call   80108020 <setupkvm>
8010811e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108121:	85 c0                	test   %eax,%eax
80108123:	0f 84 bd 00 00 00    	je     801081e6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108129:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010812c:	85 c9                	test   %ecx,%ecx
8010812e:	0f 84 b2 00 00 00    	je     801081e6 <copyuvm+0xd6>
80108134:	31 f6                	xor    %esi,%esi
80108136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010813d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108140:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108143:	89 f0                	mov    %esi,%eax
80108145:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108148:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010814b:	a8 01                	test   $0x1,%al
8010814d:	75 11                	jne    80108160 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010814f:	83 ec 0c             	sub    $0xc,%esp
80108152:	68 38 90 10 80       	push   $0x80109038
80108157:	e8 24 82 ff ff       	call   80100380 <panic>
8010815c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108160:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108167:	c1 ea 0a             	shr    $0xa,%edx
8010816a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108170:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108177:	85 c0                	test   %eax,%eax
80108179:	74 d4                	je     8010814f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010817b:	8b 00                	mov    (%eax),%eax
8010817d:	a8 01                	test   $0x1,%al
8010817f:	0f 84 9f 00 00 00    	je     80108224 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108185:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108187:	25 ff 0f 00 00       	and    $0xfff,%eax
8010818c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010818f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108195:	e8 46 ab ff ff       	call   80102ce0 <kalloc>
8010819a:	89 c3                	mov    %eax,%ebx
8010819c:	85 c0                	test   %eax,%eax
8010819e:	74 64                	je     80108204 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801081a0:	83 ec 04             	sub    $0x4,%esp
801081a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801081a9:	68 00 10 00 00       	push   $0x1000
801081ae:	57                   	push   %edi
801081af:	50                   	push   %eax
801081b0:	e8 5b d5 ff ff       	call   80105710 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801081b5:	58                   	pop    %eax
801081b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801081bc:	5a                   	pop    %edx
801081bd:	ff 75 e4             	push   -0x1c(%ebp)
801081c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801081c5:	89 f2                	mov    %esi,%edx
801081c7:	50                   	push   %eax
801081c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081cb:	e8 60 f8 ff ff       	call   80107a30 <mappages>
801081d0:	83 c4 10             	add    $0x10,%esp
801081d3:	85 c0                	test   %eax,%eax
801081d5:	78 21                	js     801081f8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801081d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801081dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801081e0:	0f 87 5a ff ff ff    	ja     80108140 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801081e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081ec:	5b                   	pop    %ebx
801081ed:	5e                   	pop    %esi
801081ee:	5f                   	pop    %edi
801081ef:	5d                   	pop    %ebp
801081f0:	c3                   	ret    
801081f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801081f8:	83 ec 0c             	sub    $0xc,%esp
801081fb:	53                   	push   %ebx
801081fc:	e8 1f a9 ff ff       	call   80102b20 <kfree>
      goto bad;
80108201:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108204:	83 ec 0c             	sub    $0xc,%esp
80108207:	ff 75 e0             	push   -0x20(%ebp)
8010820a:	e8 91 fd ff ff       	call   80107fa0 <freevm>
  return 0;
8010820f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108216:	83 c4 10             	add    $0x10,%esp
}
80108219:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010821c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010821f:	5b                   	pop    %ebx
80108220:	5e                   	pop    %esi
80108221:	5f                   	pop    %edi
80108222:	5d                   	pop    %ebp
80108223:	c3                   	ret    
      panic("copyuvm: page not present");
80108224:	83 ec 0c             	sub    $0xc,%esp
80108227:	68 52 90 10 80       	push   $0x80109052
8010822c:	e8 4f 81 ff ff       	call   80100380 <panic>
80108231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010823f:	90                   	nop

80108240 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108246:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108249:	89 c1                	mov    %eax,%ecx
8010824b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010824e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108251:	f6 c2 01             	test   $0x1,%dl
80108254:	0f 84 dd 02 00 00    	je     80108537 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010825a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010825d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108263:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108264:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108269:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108270:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108272:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108277:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010827a:	05 00 00 00 80       	add    $0x80000000,%eax
8010827f:	83 fa 05             	cmp    $0x5,%edx
80108282:	ba 00 00 00 00       	mov    $0x0,%edx
80108287:	0f 45 c2             	cmovne %edx,%eax
}
8010828a:	c3                   	ret    
8010828b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010828f:	90                   	nop

80108290 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108290:	55                   	push   %ebp
80108291:	89 e5                	mov    %esp,%ebp
80108293:	57                   	push   %edi
80108294:	56                   	push   %esi
80108295:	53                   	push   %ebx
80108296:	83 ec 0c             	sub    $0xc,%esp
80108299:	8b 75 14             	mov    0x14(%ebp),%esi
8010829c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010829f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801082a2:	85 f6                	test   %esi,%esi
801082a4:	75 51                	jne    801082f7 <copyout+0x67>
801082a6:	e9 a5 00 00 00       	jmp    80108350 <copyout+0xc0>
801082ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082af:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801082b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801082b6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801082bc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801082c2:	74 75                	je     80108339 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801082c4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801082c6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801082c9:	29 c3                	sub    %eax,%ebx
801082cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801082d1:	39 f3                	cmp    %esi,%ebx
801082d3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801082d6:	29 f8                	sub    %edi,%eax
801082d8:	83 ec 04             	sub    $0x4,%esp
801082db:	01 c1                	add    %eax,%ecx
801082dd:	53                   	push   %ebx
801082de:	52                   	push   %edx
801082df:	51                   	push   %ecx
801082e0:	e8 2b d4 ff ff       	call   80105710 <memmove>
    len -= n;
    buf += n;
801082e5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801082e8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801082ee:	83 c4 10             	add    $0x10,%esp
    buf += n;
801082f1:	01 da                	add    %ebx,%edx
  while(len > 0){
801082f3:	29 de                	sub    %ebx,%esi
801082f5:	74 59                	je     80108350 <copyout+0xc0>
  if(*pde & PTE_P){
801082f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801082fa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801082fc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801082fe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108301:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108307:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010830a:	f6 c1 01             	test   $0x1,%cl
8010830d:	0f 84 2b 02 00 00    	je     8010853e <copyout.cold>
  return &pgtab[PTX(va)];
80108313:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108315:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010831b:	c1 eb 0c             	shr    $0xc,%ebx
8010831e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108324:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010832b:	89 d9                	mov    %ebx,%ecx
8010832d:	83 e1 05             	and    $0x5,%ecx
80108330:	83 f9 05             	cmp    $0x5,%ecx
80108333:	0f 84 77 ff ff ff    	je     801082b0 <copyout+0x20>
  }
  return 0;
}
80108339:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010833c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108341:	5b                   	pop    %ebx
80108342:	5e                   	pop    %esi
80108343:	5f                   	pop    %edi
80108344:	5d                   	pop    %ebp
80108345:	c3                   	ret    
80108346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010834d:	8d 76 00             	lea    0x0(%esi),%esi
80108350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108353:	31 c0                	xor    %eax,%eax
}
80108355:	5b                   	pop    %ebx
80108356:	5e                   	pop    %esi
80108357:	5f                   	pop    %edi
80108358:	5d                   	pop    %ebp
80108359:	c3                   	ret    
8010835a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108360 <printvir>:
// Blank page.
//PAGEBREAK!
// Blank page.

void 
printvir(void) {
80108360:	55                   	push   %ebp
80108361:	89 e5                	mov    %esp,%ebp
80108363:	57                   	push   %edi
80108364:	56                   	push   %esi
80108365:	53                   	push   %ebx
80108366:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p = myproc();
80108369:	e8 32 bd ff ff       	call   801040a0 <myproc>
    pde_t *pgdir = p->pgdir;
    int virtual_pages = 0;
8010836e:	31 c9                	xor    %ecx,%ecx
80108370:	8b 70 04             	mov    0x4(%eax),%esi
80108373:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108379:	eb 0c                	jmp    80108387 <printvir+0x27>
8010837b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010837f:	90                   	nop

    for (int i = 0; i < NPDENTRIES; i++) {
80108380:	83 c6 04             	add    $0x4,%esi
80108383:	39 fe                	cmp    %edi,%esi
80108385:	74 3a                	je     801083c1 <printvir+0x61>
        if (!(pgdir[i] & PTE_U))
80108387:	8b 1e                	mov    (%esi),%ebx
80108389:	f6 c3 04             	test   $0x4,%bl
8010838c:	74 33                	je     801083c1 <printvir+0x61>
            break;;
        
        pde_t *pde = &pgdir[i];
        if (*pde & PTE_P) {
8010838e:	f6 c3 01             	test   $0x1,%bl
80108391:	74 ed                	je     80108380 <printvir+0x20>

            pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108393:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108399:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
            for (int j = 0; j < NPTENTRIES; j++) {
8010839f:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
801083a5:	8d 76 00             	lea    0x0(%esi),%esi
                if (pgtab[j] & PTE_U) {
801083a8:	8b 10                	mov    (%eax),%edx
801083aa:	83 e2 04             	and    $0x4,%edx
                    virtual_pages++;
801083ad:	83 fa 01             	cmp    $0x1,%edx
801083b0:	83 d9 ff             	sbb    $0xffffffff,%ecx
            for (int j = 0; j < NPTENTRIES; j++) {
801083b3:	83 c0 04             	add    $0x4,%eax
801083b6:	39 d8                	cmp    %ebx,%eax
801083b8:	75 ee                	jne    801083a8 <printvir+0x48>
    for (int i = 0; i < NPDENTRIES; i++) {
801083ba:	83 c6 04             	add    $0x4,%esi
801083bd:	39 fe                	cmp    %edi,%esi
801083bf:	75 c6                	jne    80108387 <printvir+0x27>
                }
            }
        }
    }

    cprintf("Number of virtual pages: %d\n", virtual_pages);
801083c1:	83 ec 08             	sub    $0x8,%esp
801083c4:	51                   	push   %ecx
801083c5:	68 6c 90 10 80       	push   $0x8010906c
801083ca:	e8 d1 82 ff ff       	call   801006a0 <cprintf>
}
801083cf:	83 c4 10             	add    $0x10,%esp
801083d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083d5:	5b                   	pop    %ebx
801083d6:	5e                   	pop    %esi
801083d7:	5f                   	pop    %edi
801083d8:	5d                   	pop    %ebp
801083d9:	c3                   	ret    
801083da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801083e0 <printphy>:

void printphy(void)
{
801083e0:	55                   	push   %ebp
801083e1:	89 e5                	mov    %esp,%ebp
801083e3:	57                   	push   %edi
801083e4:	56                   	push   %esi
801083e5:	53                   	push   %ebx
801083e6:	83 ec 0c             	sub    $0xc,%esp

  struct proc *p = myproc();
801083e9:	e8 b2 bc ff ff       	call   801040a0 <myproc>
    pde_t *pgdir = p->pgdir;
    int physical_pages = 0;
801083ee:	31 c9                	xor    %ecx,%ecx
801083f0:	8b 70 04             	mov    0x4(%eax),%esi
801083f3:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801083f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    for (int i = 0; i < NPDENTRIES; i++) {
        if (!((pgdir[i] &  PTE_U )&& (pgdir[i] & PTE_P)))
80108400:	8b 1e                	mov    (%esi),%ebx
80108402:	89 d8                	mov    %ebx,%eax
80108404:	83 e0 05             	and    $0x5,%eax
80108407:	83 f8 05             	cmp    $0x5,%eax
8010840a:	75 32                	jne    8010843e <printphy+0x5e>
            break;

        pde_t *pde = &pgdir[i];
        pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010840c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108412:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
        
        for (int j = 0; j < NPTENTRIES; j++) {
80108418:	81 eb 00 f0 ff 7f    	sub    $0x7ffff000,%ebx
8010841e:	66 90                	xchg   %ax,%ax
            if ((pgtab[j] & PTE_U) && (pgtab[j] & PTE_P)){
80108420:	8b 10                	mov    (%eax),%edx
80108422:	83 e2 05             	and    $0x5,%edx
                physical_pages++;
80108425:	83 fa 05             	cmp    $0x5,%edx
80108428:	0f 94 c2             	sete   %dl
        for (int j = 0; j < NPTENTRIES; j++) {
8010842b:	83 c0 04             	add    $0x4,%eax
                physical_pages++;
8010842e:	0f b6 d2             	movzbl %dl,%edx
80108431:	01 d1                	add    %edx,%ecx
        for (int j = 0; j < NPTENTRIES; j++) {
80108433:	39 d8                	cmp    %ebx,%eax
80108435:	75 e9                	jne    80108420 <printphy+0x40>
    for (int i = 0; i < NPDENTRIES; i++) {
80108437:	83 c6 04             	add    $0x4,%esi
8010843a:	39 fe                	cmp    %edi,%esi
8010843c:	75 c2                	jne    80108400 <printphy+0x20>
            }
        }
    }

    cprintf("Number of physical pages: %d\n", physical_pages);
8010843e:	83 ec 08             	sub    $0x8,%esp
80108441:	51                   	push   %ecx
80108442:	68 89 90 10 80       	push   $0x80109089
80108447:	e8 54 82 ff ff       	call   801006a0 <cprintf>
    
}
8010844c:	83 c4 10             	add    $0x10,%esp
8010844f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108452:	5b                   	pop    %ebx
80108453:	5e                   	pop    %esi
80108454:	5f                   	pop    %edi
80108455:	5d                   	pop    %ebp
80108456:	c3                   	ret    
80108457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010845e:	66 90                	xchg   %ax,%ax

80108460 <mapex>:

void*
mapex(int size)
{
80108460:	55                   	push   %ebp
80108461:	89 e5                	mov    %esp,%ebp
80108463:	57                   	push   %edi
80108464:	56                   	push   %esi
80108465:	53                   	push   %ebx
80108466:	83 ec 1c             	sub    $0x1c,%esp
  char *a, *last;
  pte_t *pte;
  void* va = myproc()->sz;
80108469:	e8 32 bc ff ff       	call   801040a0 <myproc>

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010846e:	8b 55 08             	mov    0x8(%ebp),%edx
  void* va = myproc()->sz;
80108471:	8b 00                	mov    (%eax),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108473:	8d 74 10 ff          	lea    -0x1(%eax,%edx,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
80108477:	89 c7                	mov    %eax,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108479:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  a = (char*)PGROUNDDOWN((uint)va);
8010847f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108485:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80108488:	eb 38                	jmp    801084c2 <mapex+0x62>
8010848a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108490:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108492:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108497:	c1 ea 0a             	shr    $0xa,%edx
8010849a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801084a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
  for(;;){
    if((pte = walkpgdir(myproc()->pgdir, a, 1)) == 0)
801084a7:	85 c0                	test   %eax,%eax
801084a9:	74 65                	je     80108510 <mapex+0xb0>
      return -1;
    if(*pte & PTE_P)
801084ab:	8b 10                	mov    (%eax),%edx
801084ad:	f6 c2 01             	test   $0x1,%dl
801084b0:	75 78                	jne    8010852a <mapex+0xca>
      panic("remap");
    *pte = *pte | PTE_U;
801084b2:	83 ca 04             	or     $0x4,%edx
801084b5:	89 10                	mov    %edx,(%eax)
    if(a == last)
801084b7:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801084ba:	74 64                	je     80108520 <mapex+0xc0>
      break;
    a += PGSIZE;
801084bc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    if((pte = walkpgdir(myproc()->pgdir, a, 1)) == 0)
801084c2:	e8 d9 bb ff ff       	call   801040a0 <myproc>
  pde = &pgdir[PDX(va)];
801084c7:	89 fa                	mov    %edi,%edx
801084c9:	8b 40 04             	mov    0x4(%eax),%eax
801084cc:	c1 ea 16             	shr    $0x16,%edx
801084cf:	8d 34 90             	lea    (%eax,%edx,4),%esi
  if(*pde & PTE_P){
801084d2:	8b 06                	mov    (%esi),%eax
801084d4:	a8 01                	test   $0x1,%al
801084d6:	75 b8                	jne    80108490 <mapex+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801084d8:	e8 03 a8 ff ff       	call   80102ce0 <kalloc>
801084dd:	89 c3                	mov    %eax,%ebx
801084df:	85 c0                	test   %eax,%eax
801084e1:	74 2d                	je     80108510 <mapex+0xb0>
    memset(pgtab, 0, PGSIZE);
801084e3:	83 ec 04             	sub    $0x4,%esp
801084e6:	68 00 10 00 00       	push   $0x1000
801084eb:	6a 00                	push   $0x0
801084ed:	50                   	push   %eax
801084ee:	e8 7d d1 ff ff       	call   80105670 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801084f3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  return &pgtab[PTX(va)];
801084f9:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801084fc:	83 c8 07             	or     $0x7,%eax
801084ff:	89 06                	mov    %eax,(%esi)
  return &pgtab[PTX(va)];
80108501:	89 f8                	mov    %edi,%eax
80108503:	c1 e8 0a             	shr    $0xa,%eax
80108506:	25 fc 0f 00 00       	and    $0xffc,%eax
8010850b:	01 d8                	add    %ebx,%eax
8010850d:	eb 9c                	jmp    801084ab <mapex+0x4b>
8010850f:	90                   	nop
  }

  return 0;
}
80108510:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108518:	5b                   	pop    %ebx
80108519:	5e                   	pop    %esi
8010851a:	5f                   	pop    %edi
8010851b:	5d                   	pop    %ebp
8010851c:	c3                   	ret    
8010851d:	8d 76 00             	lea    0x0(%esi),%esi
80108520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108523:	31 c0                	xor    %eax,%eax
}
80108525:	5b                   	pop    %ebx
80108526:	5e                   	pop    %esi
80108527:	5f                   	pop    %edi
80108528:	5d                   	pop    %ebp
80108529:	c3                   	ret    
      panic("remap");
8010852a:	83 ec 0c             	sub    $0xc,%esp
8010852d:	68 6c 8f 10 80       	push   $0x80108f6c
80108532:	e8 49 7e ff ff       	call   80100380 <panic>

80108537 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108537:	a1 00 00 00 00       	mov    0x0,%eax
8010853c:	0f 0b                	ud2    

8010853e <copyout.cold>:
8010853e:	a1 00 00 00 00       	mov    0x0,%eax
80108543:	0f 0b                	ud2    
