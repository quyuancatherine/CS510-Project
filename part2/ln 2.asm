
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	...

00000060 <strcpy>:
	...

00000090 <strcmp>:
	...

000000e0 <strlen>:
	...

00000110 <memset>:
	...

00000130 <strchr>:
	...

00000170 <gets>:
	...

000001f0 <stat>:
	...

00000240 <atoi>:
	...

00000280 <memmove>:
	...

000002aa <fork>:
	...

000002b2 <exit>:
	...

000002ba <wait>:
	...

000002c2 <pipe>:
	...

000002ca <read>:
	...

000002d2 <write>:
	...

000002da <close>:
	...

000002e2 <kill>:
	...

000002ea <exec>:
	...

000002f2 <open>:
	...

000002fa <mknod>:
	...

00000302 <unlink>:
	...

0000030a <fstat>:
	...

00000312 <link>:
	...

0000031a <mkdir>:
	...

00000322 <chdir>:
	...

0000032a <dup>:
	...

00000332 <getpid>:
	...

0000033a <sbrk>:
	...

00000342 <sleep>:
	...

0000034a <uptime>:
	...

00000352 <setpri>:
	...

0000035a <getpinfo>:
	...

00000370 <printint>:
	...

00000410 <printf>:
	...
 5d8:	66 90                	xchg   %ax,%ax
 5da:	66 90                	xchg   %ax,%ax
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
 5e0:	55                   	push   %ebp
 5e1:	a1 40 0a 00 00       	mov    0xa40,%eax
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	39 c8                	cmp    %ecx,%eax
 5fa:	8b 10                	mov    (%eax),%edx
 5fc:	73 32                	jae    630 <free+0x50>
 5fe:	39 d1                	cmp    %edx,%ecx
 600:	72 04                	jb     606 <free+0x26>
 602:	39 d0                	cmp    %edx,%eax
 604:	72 32                	jb     638 <free+0x58>
 606:	8b 73 fc             	mov    -0x4(%ebx),%esi
 609:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60c:	39 fa                	cmp    %edi,%edx
 60e:	74 30                	je     640 <free+0x60>
 610:	89 53 f8             	mov    %edx,-0x8(%ebx)
 613:	8b 50 04             	mov    0x4(%eax),%edx
 616:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 619:	39 f1                	cmp    %esi,%ecx
 61b:	74 3a                	je     657 <free+0x77>
 61d:	89 08                	mov    %ecx,(%eax)
 61f:	a3 40 0a 00 00       	mov    %eax,0xa40
 624:	5b                   	pop    %ebx
 625:	5e                   	pop    %esi
 626:	5f                   	pop    %edi
 627:	5d                   	pop    %ebp
 628:	c3                   	ret    
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 630:	39 d0                	cmp    %edx,%eax
 632:	72 04                	jb     638 <free+0x58>
 634:	39 d1                	cmp    %edx,%ecx
 636:	72 ce                	jb     606 <free+0x26>
 638:	89 d0                	mov    %edx,%eax
 63a:	eb bc                	jmp    5f8 <free+0x18>
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 640:	03 72 04             	add    0x4(%edx),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
 646:	8b 10                	mov    (%eax),%edx
 648:	8b 12                	mov    (%edx),%edx
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 c6                	jne    61d <free+0x3d>
 657:	03 53 fc             	add    -0x4(%ebx),%edx
 65a:	a3 40 0a 00 00       	mov    %eax,0xa40
 65f:	89 50 04             	mov    %edx,0x4(%eax)
 662:	8b 53 f8             	mov    -0x8(%ebx),%edx
 665:	89 10                	mov    %edx,(%eax)
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <malloc>:
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 0c             	sub    $0xc,%esp
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	8b 15 40 0a 00 00    	mov    0xa40,%edx
 682:	8d 78 07             	lea    0x7(%eax),%edi
 685:	c1 ef 03             	shr    $0x3,%edi
 688:	83 c7 01             	add    $0x1,%edi
 68b:	85 d2                	test   %edx,%edx
 68d:	0f 84 9d 00 00 00    	je     730 <malloc+0xc0>
 693:	8b 02                	mov    (%edx),%eax
 695:	8b 48 04             	mov    0x4(%eax),%ecx
 698:	39 cf                	cmp    %ecx,%edi
 69a:	76 6c                	jbe    708 <malloc+0x98>
 69c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a7:	0f 43 df             	cmovae %edi,%ebx
 6aa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6b1:	eb 0e                	jmp    6c1 <malloc+0x51>
 6b3:	90                   	nop
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6b8:	8b 02                	mov    (%edx),%eax
 6ba:	8b 48 04             	mov    0x4(%eax),%ecx
 6bd:	39 f9                	cmp    %edi,%ecx
 6bf:	73 47                	jae    708 <malloc+0x98>
 6c1:	39 05 40 0a 00 00    	cmp    %eax,0xa40
 6c7:	89 c2                	mov    %eax,%edx
 6c9:	75 ed                	jne    6b8 <malloc+0x48>
 6cb:	83 ec 0c             	sub    $0xc,%esp
 6ce:	56                   	push   %esi
 6cf:	e8 66 fc ff ff       	call   33a <sbrk>
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6da:	74 1c                	je     6f8 <malloc+0x88>
 6dc:	89 58 04             	mov    %ebx,0x4(%eax)
 6df:	83 ec 0c             	sub    $0xc,%esp
 6e2:	83 c0 08             	add    $0x8,%eax
 6e5:	50                   	push   %eax
 6e6:	e8 f5 fe ff ff       	call   5e0 <free>
 6eb:	8b 15 40 0a 00 00    	mov    0xa40,%edx
 6f1:	83 c4 10             	add    $0x10,%esp
 6f4:	85 d2                	test   %edx,%edx
 6f6:	75 c0                	jne    6b8 <malloc+0x48>
 6f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6fb:	31 c0                	xor    %eax,%eax
 6fd:	5b                   	pop    %ebx
 6fe:	5e                   	pop    %esi
 6ff:	5f                   	pop    %edi
 700:	5d                   	pop    %ebp
 701:	c3                   	ret    
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 708:	39 cf                	cmp    %ecx,%edi
 70a:	74 54                	je     760 <malloc+0xf0>
 70c:	29 f9                	sub    %edi,%ecx
 70e:	89 48 04             	mov    %ecx,0x4(%eax)
 711:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 714:	89 78 04             	mov    %edi,0x4(%eax)
 717:	89 15 40 0a 00 00    	mov    %edx,0xa40
 71d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 720:	83 c0 08             	add    $0x8,%eax
 723:	5b                   	pop    %ebx
 724:	5e                   	pop    %esi
 725:	5f                   	pop    %edi
 726:	5d                   	pop    %ebp
 727:	c3                   	ret    
 728:	90                   	nop
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 730:	c7 05 40 0a 00 00 44 	movl   $0xa44,0xa40
 737:	0a 00 00 
 73a:	c7 05 44 0a 00 00 44 	movl   $0xa44,0xa44
 741:	0a 00 00 
 744:	b8 44 0a 00 00       	mov    $0xa44,%eax
 749:	c7 05 48 0a 00 00 00 	movl   $0x0,0xa48
 750:	00 00 00 
 753:	e9 44 ff ff ff       	jmp    69c <malloc+0x2c>
 758:	90                   	nop
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb b1                	jmp    717 <malloc+0xa7>
