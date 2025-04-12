
_sdvar:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    *size = strlen(reversedString);
    return resultString;
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
    if (argc < 2)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 6e                	jle    8c <main+0x8c>
    {
        printf(1, "There are no input!\n");
        exit();
    }
    if (argc > 8)
  1e:	83 fe 08             	cmp    $0x8,%esi
  21:	7f 56                	jg     79 <main+0x79>
    char *MVStr;
    char *LSDStr;
    int avSize;
    int mvSize;
    int lsdSize;
    AVStr = malloc(16);
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	6a 10                	push   $0x10
  28:	e8 73 0c 00 00       	call   ca0 <malloc>
    MVStr = malloc(16);
  2d:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
  34:	e8 67 0c 00 00       	call   ca0 <malloc>
    LSDStr = malloc(16);
  39:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
  40:	e8 5b 0c 00 00       	call   ca0 <malloc>
    int numOfNums = argc - 1;
  45:	8d 46 ff             	lea    -0x1(%esi),%eax
    int numArray[numOfNums];
  48:	83 c4 10             	add    $0x10,%esp
    int numOfNums = argc - 1;
  4b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    int numArray[numOfNums];
  4e:	c1 e0 02             	shl    $0x2,%eax
  51:	89 e1                	mov    %esp,%ecx
  53:	89 45 cc             	mov    %eax,-0x34(%ebp)
  56:	83 c0 0f             	add    $0xf,%eax
  59:	89 c2                	mov    %eax,%edx
  5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  60:	83 e2 f0             	and    $0xfffffff0,%edx
  63:	29 c1                	sub    %eax,%ecx
  65:	39 cc                	cmp    %ecx,%esp
  67:	74 36                	je     9f <main+0x9f>
  69:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  6f:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  76:	00 
  77:	eb ec                	jmp    65 <main+0x65>
        printf(1, "There are more that 7 inputs!\n");
  79:	56                   	push   %esi
  7a:	56                   	push   %esi
  7b:	68 e8 0d 00 00       	push   $0xde8
  80:	6a 01                	push   $0x1
  82:	e8 e9 09 00 00       	call   a70 <printf>
        exit();
  87:	e8 57 08 00 00       	call   8e3 <exit>
        printf(1, "There are no input!\n");
  8c:	57                   	push   %edi
  8d:	57                   	push   %edi
  8e:	68 c0 0d 00 00       	push   $0xdc0
  93:	6a 01                	push   $0x1
  95:	e8 d6 09 00 00       	call   a70 <printf>
        exit();
  9a:	e8 44 08 00 00       	call   8e3 <exit>
    int numArray[numOfNums];
  9f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  a5:	29 d4                	sub    %edx,%esp
  a7:	85 d2                	test   %edx,%edx
  a9:	74 05                	je     b0 <main+0xb0>
  ab:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  b0:	89 65 d0             	mov    %esp,-0x30(%ebp)

    for (int i = 1; i < argc; i++)
  b3:	bb 01 00 00 00       	mov    $0x1,%ebx
  b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bf:	90                   	nop
        numArray[i - 1] = atoi(argv[i]);
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	ff 34 9f             	push   (%edi,%ebx,4)
  c6:	e8 a5 07 00 00       	call   870 <atoi>
  cb:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    for (int i = 1; i < argc; i++)
  ce:	83 c4 10             	add    $0x10,%esp
        numArray[i - 1] = atoi(argv[i]);
  d1:	89 44 99 fc          	mov    %eax,-0x4(%ecx,%ebx,4)
    for (int i = 1; i < argc; i++)
  d5:	83 c3 01             	add    $0x1,%ebx
  d8:	39 de                	cmp    %ebx,%esi
  da:	75 e4                	jne    c0 <main+0xc0>
  dc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  df:	89 c8                	mov    %ecx,%eax
    double sum = 0;
  e1:	d9 ee                	fldz   
    for (int i = 1; i < argc; i++)
  e3:	89 ca                	mov    %ecx,%edx
  e5:	8d 73 04             	lea    0x4(%ebx),%esi
  e8:	01 cb                	add    %ecx,%ebx
  ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += numArray[i];
  f0:	db 02                	fildl  (%edx)
    for (int i = 0; i < size; i++)
  f2:	83 c2 04             	add    $0x4,%edx
        sum += numArray[i];
  f5:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < size; i++)
  f7:	39 da                	cmp    %ebx,%edx
  f9:	75 f5                	jne    f0 <main+0xf0>

    int average = calcAverage(numArray, numOfNums);
  fb:	d9 7d d6             	fnstcw -0x2a(%ebp)
    return sum / size;
  fe:	db 45 c8             	fildl  -0x38(%ebp)

    int k = 0, j = 0;
 101:	31 c9                	xor    %ecx,%ecx
    int average = calcAverage(numArray, numOfNums);
 103:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
    return sum / size;
 107:	de f9                	fdivrp %st,%st(1)
    int average = calcAverage(numArray, numOfNums);
 109:	80 ce 0c             	or     $0xc,%dh
 10c:	66 89 55 d4          	mov    %dx,-0x2c(%ebp)
 110:	8b 55 d0             	mov    -0x30(%ebp),%edx
 113:	d9 6d d4             	fldcw  -0x2c(%ebp)
 116:	db 5d cc             	fistpl -0x34(%ebp)
 119:	d9 6d d6             	fldcw  -0x2a(%ebp)
 11c:	8b 7d cc             	mov    -0x34(%ebp),%edi
    int k = 0, j = 0;
 11f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 122:	31 c0                	xor    %eax,%eax
 124:	eb 14                	jmp    13a <main+0x13a>
 126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12d:	8d 76 00             	lea    0x0(%esi),%esi
    for (int i = 0; i < numOfNums; i++)
 130:	83 c2 04             	add    $0x4,%edx
    {
        if (numArray[i] > average)
            j++;
 133:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < numOfNums; i++)
 136:	39 da                	cmp    %ebx,%edx
 138:	74 0e                	je     148 <main+0x148>
        if (numArray[i] > average)
 13a:	39 3a                	cmp    %edi,(%edx)
 13c:	7f f2                	jg     130 <main+0x130>
    for (int i = 0; i < numOfNums; i++)
 13e:	83 c2 04             	add    $0x4,%edx
        else
            k++;
 141:	83 c1 01             	add    $0x1,%ecx
    for (int i = 0; i < numOfNums; i++)
 144:	39 da                	cmp    %ebx,%edx
 146:	75 f2                	jne    13a <main+0x13a>
    }
    int lessThan[k];
 148:	8d 14 8d 0f 00 00 00 	lea    0xf(,%ecx,4),%edx
 14f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
 152:	89 e1                	mov    %esp,%ecx
 154:	89 d3                	mov    %edx,%ebx
 156:	89 45 c0             	mov    %eax,-0x40(%ebp)
 159:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
 15f:	8b 45 cc             	mov    -0x34(%ebp),%eax
 162:	83 e3 f0             	and    $0xfffffff0,%ebx
 165:	29 d1                	sub    %edx,%ecx
 167:	39 cc                	cmp    %ecx,%esp
 169:	74 10                	je     17b <main+0x17b>
 16b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 171:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 178:	00 
 179:	eb ec                	jmp    167 <main+0x167>
 17b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
 181:	29 dc                	sub    %ebx,%esp
 183:	85 db                	test   %ebx,%ebx
 185:	74 05                	je     18c <main+0x18c>
 187:	83 4c 1c fc 00       	orl    $0x0,-0x4(%esp,%ebx,1)
    int moreThan[j];
 18c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    int lessThan[k];
 18f:	89 65 c8             	mov    %esp,-0x38(%ebp)
    int moreThan[j];
 192:	8d 14 8d 0f 00 00 00 	lea    0xf(,%ecx,4),%edx
 199:	89 e1                	mov    %esp,%ecx
 19b:	89 d3                	mov    %edx,%ebx
 19d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
 1a3:	83 e3 f0             	and    $0xfffffff0,%ebx
 1a6:	29 d1                	sub    %edx,%ecx
 1a8:	39 cc                	cmp    %ecx,%esp
 1aa:	74 10                	je     1bc <main+0x1bc>
 1ac:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 1b2:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 1b9:	00 
 1ba:	eb ec                	jmp    1a8 <main+0x1a8>
 1bc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
 1c2:	29 dc                	sub    %ebx,%esp
 1c4:	85 db                	test   %ebx,%ebx
 1c6:	74 05                	je     1cd <main+0x1cd>
 1c8:	83 4c 1c fc 00       	orl    $0x0,-0x4(%esp,%ebx,1)
 1cd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    int x = 0, y = 0;
 1d0:	31 db                	xor    %ebx,%ebx
    int moreThan[j];
 1d2:	89 65 c4             	mov    %esp,-0x3c(%ebp)
    int x = 0, y = 0;
 1d5:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 1d8:	01 f1                	add    %esi,%ecx
 1da:	31 f6                	xor    %esi,%esi
 1dc:	89 75 cc             	mov    %esi,-0x34(%ebp)
 1df:	87 f9                	xchg   %edi,%ecx
 1e1:	eb 19                	jmp    1fc <main+0x1fc>
 1e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e7:	90                   	nop
    for (int i = 0; i <= numOfNums; i++)
    {
        if (numArray[i] > average)
        {
            moreThan[x] = numArray[i];
 1e8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 1eb:	8b 75 c4             	mov    -0x3c(%ebp),%esi
    for (int i = 0; i <= numOfNums; i++)
 1ee:	83 c0 04             	add    $0x4,%eax
            x++;
 1f1:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
            moreThan[x] = numArray[i];
 1f5:	89 14 9e             	mov    %edx,(%esi,%ebx,4)
    for (int i = 0; i <= numOfNums; i++)
 1f8:	39 c7                	cmp    %eax,%edi
 1fa:	74 1e                	je     21a <main+0x21a>
        if (numArray[i] > average)
 1fc:	8b 10                	mov    (%eax),%edx
 1fe:	39 ca                	cmp    %ecx,%edx
 200:	7f e6                	jg     1e8 <main+0x1e8>
        }
        else
        {
            lessThan[y] = numArray[i];
 202:	8b 5d cc             	mov    -0x34(%ebp),%ebx
 205:	8b 75 c8             	mov    -0x38(%ebp),%esi
    for (int i = 0; i <= numOfNums; i++)
 208:	83 c0 04             	add    $0x4,%eax
            lessThan[y] = numArray[i];
 20b:	89 14 9e             	mov    %edx,(%esi,%ebx,4)
            y++;
 20e:	89 de                	mov    %ebx,%esi
 210:	83 c6 01             	add    $0x1,%esi
 213:	89 75 cc             	mov    %esi,-0x34(%ebp)
    for (int i = 0; i <= numOfNums; i++)
 216:	39 c7                	cmp    %eax,%edi
 218:	75 e2                	jne    1fc <main+0x1fc>
        }
    }
    int MVariance = calcVariance(moreThan, j);
 21a:	db 45 c0             	fildl  -0x40(%ebp)
 21d:	83 ec 0c             	sub    $0xc,%esp
 220:	89 cf                	mov    %ecx,%edi
 222:	dd 1c 24             	fstpl  (%esp)
 225:	ff 75 c4             	push   -0x3c(%ebp)
 228:	e8 b3 01 00 00       	call   3e0 <calcVariance>
 22d:	59                   	pop    %ecx
 22e:	5b                   	pop    %ebx
    int LDerivation = calcStandardDeviation(lessThan, k);
 22f:	ff 75 bc             	push   -0x44(%ebp)
 232:	ff 75 c8             	push   -0x38(%ebp)
    int MVariance = calcVariance(moreThan, j);
 235:	89 c3                	mov    %eax,%ebx
    int LDerivation = calcStandardDeviation(lessThan, k);
 237:	e8 54 02 00 00       	call   490 <calcStandardDeviation>
 23c:	5e                   	pop    %esi
 23d:	5a                   	pop    %edx
 23e:	89 c6                	mov    %eax,%esi
    AVStr = intToStr(average, &avSize);
 240:	8d 45 dc             	lea    -0x24(%ebp),%eax
 243:	50                   	push   %eax
 244:	57                   	push   %edi
 245:	e8 e6 02 00 00       	call   530 <intToStr>
    MVStr = intToStr(MVariance, &mvSize);
 24a:	59                   	pop    %ecx
    AVStr = intToStr(average, &avSize);
 24b:	89 c7                	mov    %eax,%edi
    MVStr = intToStr(MVariance, &mvSize);
 24d:	58                   	pop    %eax
 24e:	8d 45 e0             	lea    -0x20(%ebp),%eax
 251:	50                   	push   %eax
 252:	53                   	push   %ebx
 253:	e8 d8 02 00 00       	call   530 <intToStr>
 258:	89 45 d0             	mov    %eax,-0x30(%ebp)
    LSDStr = intToStr(LDerivation, &lsdSize);
 25b:	58                   	pop    %eax
 25c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 25f:	5a                   	pop    %edx
 260:	50                   	push   %eax
 261:	56                   	push   %esi
 262:	e8 c9 02 00 00       	call   530 <intToStr>

    unlink("sdvar_result.txt");
 267:	c7 04 24 d5 0d 00 00 	movl   $0xdd5,(%esp)
    LSDStr = intToStr(LDerivation, &lsdSize);
 26e:	89 c6                	mov    %eax,%esi
    unlink("sdvar_result.txt");
 270:	e8 be 06 00 00       	call   933 <unlink>
    int fd = open("sdvar_result.txt", O_CREATE | O_WRONLY);
 275:	59                   	pop    %ecx
 276:	5b                   	pop    %ebx
 277:	68 01 02 00 00       	push   $0x201
 27c:	68 d5 0d 00 00       	push   $0xdd5
 281:	e8 9d 06 00 00       	call   923 <open>

    if (fd < 0)
 286:	83 c4 10             	add    $0x10,%esp
    int fd = open("sdvar_result.txt", O_CREATE | O_WRONLY);
 289:	89 c3                	mov    %eax,%ebx
    if (fd < 0)
 28b:	85 c0                	test   %eax,%eax
 28d:	78 64                	js     2f3 <main+0x2f3>
    {
        printf(1, "result_sdvar.:cannot create sdvar_result.txt\n");
        exit();
    }

    write(fd, AVStr, avSize);
 28f:	50                   	push   %eax
 290:	ff 75 dc             	push   -0x24(%ebp)
 293:	57                   	push   %edi
 294:	53                   	push   %ebx
 295:	e8 69 06 00 00       	call   903 <write>
    write(fd, " ", 1);
 29a:	83 c4 0c             	add    $0xc,%esp
 29d:	6a 01                	push   $0x1
 29f:	68 e6 0d 00 00       	push   $0xde6
 2a4:	53                   	push   %ebx
 2a5:	e8 59 06 00 00       	call   903 <write>
    write(fd, LSDStr, lsdSize);
 2aa:	83 c4 0c             	add    $0xc,%esp
 2ad:	ff 75 e4             	push   -0x1c(%ebp)
 2b0:	56                   	push   %esi
 2b1:	53                   	push   %ebx
 2b2:	e8 4c 06 00 00       	call   903 <write>
    write(fd, " ", 1);
 2b7:	83 c4 0c             	add    $0xc,%esp
 2ba:	6a 01                	push   $0x1
 2bc:	68 e6 0d 00 00       	push   $0xde6
 2c1:	53                   	push   %ebx
 2c2:	e8 3c 06 00 00       	call   903 <write>
    write(fd, MVStr, mvSize);
 2c7:	83 c4 0c             	add    $0xc,%esp
 2ca:	ff 75 e0             	push   -0x20(%ebp)
 2cd:	ff 75 d0             	push   -0x30(%ebp)
 2d0:	53                   	push   %ebx
 2d1:	e8 2d 06 00 00       	call   903 <write>
    write(fd, "\n", 1);
 2d6:	83 c4 0c             	add    $0xc,%esp
 2d9:	6a 01                	push   $0x1
 2db:	68 d3 0d 00 00       	push   $0xdd3
 2e0:	53                   	push   %ebx
 2e1:	e8 1d 06 00 00       	call   903 <write>
    close(fd);
 2e6:	89 1c 24             	mov    %ebx,(%esp)
 2e9:	e8 1d 06 00 00       	call   90b <close>

    exit();
 2ee:	e8 f0 05 00 00       	call   8e3 <exit>
        printf(1, "result_sdvar.:cannot create sdvar_result.txt\n");
 2f3:	52                   	push   %edx
 2f4:	52                   	push   %edx
 2f5:	68 08 0e 00 00       	push   $0xe08
 2fa:	6a 01                	push   $0x1
 2fc:	e8 6f 07 00 00       	call   a70 <printf>
        exit();
 301:	e8 dd 05 00 00       	call   8e3 <exit>
 306:	66 90                	xchg   %ax,%ax
 308:	66 90                	xchg   %ax,%ax
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <sqroot>:
{
 310:	55                   	push   %ebp
        return 1;
 311:	b8 01 00 00 00       	mov    $0x1,%eax
{
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 08             	sub    $0x8,%esp
 31b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if (square == 2 || square == 1)
 31e:	8d 51 ff             	lea    -0x1(%ecx),%edx
 321:	83 fa 01             	cmp    $0x1,%edx
 324:	76 6a                	jbe    390 <sqroot+0x80>
        return 0;
 326:	31 c0                	xor    %eax,%eax
    if (square <= 0)
 328:	85 c9                	test   %ecx,%ecx
 32a:	7e 64                	jle    390 <sqroot+0x80>
    double root = square / 3, last, diff = 1;
 32c:	89 c8                	mov    %ecx,%eax
 32e:	ba 56 55 55 55       	mov    $0x55555556,%edx
 333:	f7 ea                	imul   %edx
 335:	89 c8                	mov    %ecx,%eax
 337:	c1 f8 1f             	sar    $0x1f,%eax
 33a:	29 c2                	sub    %eax,%edx
 33c:	89 55 f8             	mov    %edx,-0x8(%ebp)
 33f:	db 45 f8             	fildl  -0x8(%ebp)
        root = (root + square / root) / 2;
 342:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 345:	db 45 f8             	fildl  -0x8(%ebp)
    } while (diff > MINDIFF || diff < -MINDIFF);
 348:	dd 05 40 0e 00 00    	fldl   0xe40
 34e:	eb 02                	jmp    352 <sqroot+0x42>
 350:	dd d8                	fstp   %st(0)
        root = (root + square / root) / 2;
 352:	d9 c1                	fld    %st(1)
 354:	d8 f3                	fdiv   %st(3),%st
 356:	d8 c3                	fadd   %st(3),%st
 358:	d8 0d 38 0e 00 00    	fmuls  0xe38
        diff = root - last;
 35e:	dc e3                	fsub   %st,%st(3)
 360:	d9 cb                	fxch   %st(3)
    } while (diff > MINDIFF || diff < -MINDIFF);
 362:	db f1                	fcomi  %st(1),%st
 364:	77 ea                	ja     350 <sqroot+0x40>
 366:	dd 05 48 0e 00 00    	fldl   0xe48
 36c:	df f1                	fcomip %st(1),%st
 36e:	dd d8                	fstp   %st(0)
 370:	77 e0                	ja     352 <sqroot+0x42>
 372:	dd d8                	fstp   %st(0)
 374:	dd d8                	fstp   %st(0)
    return root;
 376:	d9 7d fe             	fnstcw -0x2(%ebp)
 379:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
 37d:	80 cc 0c             	or     $0xc,%ah
 380:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
 384:	d9 6d fc             	fldcw  -0x4(%ebp)
 387:	db 5d f8             	fistpl -0x8(%ebp)
 38a:	d9 6d fe             	fldcw  -0x2(%ebp)
 38d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 390:	c9                   	leave  
 391:	c3                   	ret    
 392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003a0 <calcAverage>:
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 08             	sub    $0x8,%esp
 3a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    for (int i = 0; i < size; i++)
 3a9:	85 c9                	test   %ecx,%ecx
 3ab:	7e 23                	jle    3d0 <calcAverage+0x30>
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
    double sum = 0;
 3b0:	d9 ee                	fldz   
 3b2:	8d 14 88             	lea    (%eax,%ecx,4),%edx
 3b5:	8d 76 00             	lea    0x0(%esi),%esi
        sum += numArray[i];
 3b8:	db 00                	fildl  (%eax)
    for (int i = 0; i < size; i++)
 3ba:	83 c0 04             	add    $0x4,%eax
        sum += numArray[i];
 3bd:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < size; i++)
 3bf:	39 c2                	cmp    %eax,%edx
 3c1:	75 f5                	jne    3b8 <calcAverage+0x18>
    return sum / size;
 3c3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3c6:	db 45 fc             	fildl  -0x4(%ebp)
}
 3c9:	c9                   	leave  
    return sum / size;
 3ca:	de f9                	fdivrp %st,%st(1)
}
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
    return sum / size;
 3d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    double sum = 0;
 3d3:	d9 ee                	fldz   
    return sum / size;
 3d5:	db 45 fc             	fildl  -0x4(%ebp)
}
 3d8:	c9                   	leave  
    return sum / size;
 3d9:	de f9                	fdivrp %st,%st(1)
}
 3db:	c3                   	ret    
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <calcVariance>:
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	83 ec 0c             	sub    $0xc,%esp
 3e7:	dd 45 0c             	fldl   0xc(%ebp)
 3ea:	8b 55 08             	mov    0x8(%ebp),%edx
    double average = calcAverage(numArray, size);
 3ed:	d9 7d f6             	fnstcw -0xa(%ebp)
 3f0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
 3f4:	80 cc 0c             	or     $0xc,%ah
 3f7:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
 3fb:	d9 6d f4             	fldcw  -0xc(%ebp)
 3fe:	db 55 f0             	fistl  -0x10(%ebp)
 401:	d9 6d f6             	fldcw  -0xa(%ebp)
 404:	8b 5d f0             	mov    -0x10(%ebp),%ebx
    for (int i = 0; i < size; i++)
 407:	85 db                	test   %ebx,%ebx
 409:	7e 75                	jle    480 <calcVariance+0xa0>
 40b:	89 d0                	mov    %edx,%eax
    double sum = 0;
 40d:	d9 ee                	fldz   
 40f:	8d 0c 9a             	lea    (%edx,%ebx,4),%ecx
 412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += numArray[i];
 418:	db 00                	fildl  (%eax)
    for (int i = 0; i < size; i++)
 41a:	83 c0 04             	add    $0x4,%eax
        sum += numArray[i];
 41d:	de c1                	faddp  %st,%st(1)
    for (int i = 0; i < size; i++)
 41f:	39 c1                	cmp    %eax,%ecx
 421:	75 f5                	jne    418 <calcVariance+0x38>
    return sum / size;
 423:	89 5d f0             	mov    %ebx,-0x10(%ebp)
 426:	db 45 f0             	fildl  -0x10(%ebp)
    for (int i = 0; i < size; i++)
 429:	31 c0                	xor    %eax,%eax
    return sum / size;
 42b:	de f9                	fdivrp %st,%st(1)
    for (int i = 0; i < size; i++)
 42d:	d9 ee                	fldz   
 42f:	d9 c0                	fld    %st(0)
    double squaredSum = 0;
 431:	d9 c1                	fld    %st(1)
 433:	d9 cc                	fxch   %st(4)
    for (int i = 0; i < size; i++)
 435:	db f1                	fcomi  %st(1),%st
 437:	dd d9                	fstp   %st(1)
 439:	76 4d                	jbe    488 <calcVariance+0xa8>
 43b:	dd d9                	fstp   %st(1)
 43d:	8d 76 00             	lea    0x0(%esi),%esi
        double a = numArray[i] - average;
 440:	db 04 82             	fildl  (%edx,%eax,4)
    for (int i = 0; i < size; i++)
 443:	83 c0 01             	add    $0x1,%eax
 446:	89 45 f0             	mov    %eax,-0x10(%ebp)
        double a = numArray[i] - average;
 449:	d8 e2                	fsub   %st(2),%st
        squaredSum += a * a;
 44b:	d8 c8                	fmul   %st(0),%st
 44d:	de c3                	faddp  %st,%st(3)
    for (int i = 0; i < size; i++)
 44f:	db 45 f0             	fildl  -0x10(%ebp)
 452:	d9 c9                	fxch   %st(1)
 454:	db f1                	fcomi  %st(1),%st
 456:	dd d9                	fstp   %st(1)
 458:	77 e6                	ja     440 <calcVariance+0x60>
 45a:	dd d9                	fstp   %st(1)
 45c:	d9 c9                	fxch   %st(1)
    return (int)squaredSum / size;
 45e:	d9 6d f4             	fldcw  -0xc(%ebp)
 461:	db 5d f0             	fistpl -0x10(%ebp)
 464:	d9 6d f6             	fldcw  -0xa(%ebp)
 467:	db 45 f0             	fildl  -0x10(%ebp)
 46a:	de f1                	fdivp  %st,%st(1)
}
 46c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return (int)squaredSum / size;
 46f:	d9 6d f4             	fldcw  -0xc(%ebp)
 472:	db 5d f0             	fistpl -0x10(%ebp)
 475:	d9 6d f6             	fldcw  -0xa(%ebp)
 478:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 47b:	c9                   	leave  
 47c:	c3                   	ret    
 47d:	8d 76 00             	lea    0x0(%esi),%esi
    double sum = 0;
 480:	d9 ee                	fldz   
 482:	eb 9f                	jmp    423 <calcVariance+0x43>
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 488:	dd da                	fstp   %st(2)
 48a:	dd da                	fstp   %st(2)
 48c:	d9 c9                	fxch   %st(1)
 48e:	eb da                	jmp    46a <calcVariance+0x8a>

00000490 <calcStandardDeviation>:
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 14             	sub    $0x14,%esp
    return sqroot(calcVariance(numArray, size));
 496:	db 45 0c             	fildl  0xc(%ebp)
 499:	dd 1c 24             	fstpl  (%esp)
 49c:	ff 75 08             	push   0x8(%ebp)
 49f:	e8 3c ff ff ff       	call   3e0 <calcVariance>
 4a4:	83 c4 10             	add    $0x10,%esp
    if (square == 2 || square == 1)
 4a7:	8d 50 ff             	lea    -0x1(%eax),%edx
    return sqroot(calcVariance(numArray, size));
 4aa:	89 c1                	mov    %eax,%ecx
        return 1;
 4ac:	b8 01 00 00 00       	mov    $0x1,%eax
    if (square == 2 || square == 1)
 4b1:	83 fa 01             	cmp    $0x1,%edx
 4b4:	76 6a                	jbe    520 <calcStandardDeviation+0x90>
        return 0;
 4b6:	31 c0                	xor    %eax,%eax
    if (square <= 0)
 4b8:	85 c9                	test   %ecx,%ecx
 4ba:	7e 64                	jle    520 <calcStandardDeviation+0x90>
    double root = square / 3, last, diff = 1;
 4bc:	89 c8                	mov    %ecx,%eax
 4be:	ba 56 55 55 55       	mov    $0x55555556,%edx
 4c3:	f7 ea                	imul   %edx
 4c5:	89 c8                	mov    %ecx,%eax
 4c7:	c1 f8 1f             	sar    $0x1f,%eax
 4ca:	29 c2                	sub    %eax,%edx
 4cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
 4cf:	db 45 f8             	fildl  -0x8(%ebp)
        root = (root + square / root) / 2;
 4d2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4d5:	db 45 f8             	fildl  -0x8(%ebp)
    } while (diff > MINDIFF || diff < -MINDIFF);
 4d8:	dd 05 40 0e 00 00    	fldl   0xe40
 4de:	eb 02                	jmp    4e2 <calcStandardDeviation+0x52>
 4e0:	dd d8                	fstp   %st(0)
        root = (root + square / root) / 2;
 4e2:	d9 c1                	fld    %st(1)
 4e4:	d8 f3                	fdiv   %st(3),%st
 4e6:	d8 c3                	fadd   %st(3),%st
 4e8:	d8 0d 38 0e 00 00    	fmuls  0xe38
        diff = root - last;
 4ee:	dc e3                	fsub   %st,%st(3)
 4f0:	d9 cb                	fxch   %st(3)
    } while (diff > MINDIFF || diff < -MINDIFF);
 4f2:	db f1                	fcomi  %st(1),%st
 4f4:	77 ea                	ja     4e0 <calcStandardDeviation+0x50>
 4f6:	dd 05 48 0e 00 00    	fldl   0xe48
 4fc:	df f1                	fcomip %st(1),%st
 4fe:	dd d8                	fstp   %st(0)
 500:	77 e0                	ja     4e2 <calcStandardDeviation+0x52>
 502:	dd d8                	fstp   %st(0)
 504:	dd d8                	fstp   %st(0)
    return root;
 506:	d9 7d fe             	fnstcw -0x2(%ebp)
 509:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
 50d:	80 cc 0c             	or     $0xc,%ah
 510:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
 514:	d9 6d fc             	fldcw  -0x4(%ebp)
 517:	db 5d f8             	fistpl -0x8(%ebp)
 51a:	d9 6d fe             	fldcw  -0x2(%ebp)
 51d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 520:	c9                   	leave  
 521:	c3                   	ret    
 522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000530 <intToStr>:
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 28             	sub    $0x28,%esp
 539:	8b 5d 08             	mov    0x8(%ebp),%ebx
    reversedString = malloc(16);
 53c:	6a 10                	push   $0x10
 53e:	e8 5d 07 00 00       	call   ca0 <malloc>
    resultString = malloc(16);
 543:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    reversedString = malloc(16);
 54a:	89 c7                	mov    %eax,%edi
    resultString = malloc(16);
 54c:	e8 4f 07 00 00       	call   ca0 <malloc>
    if (number == 0)
 551:	83 c4 10             	add    $0x10,%esp
    resultString = malloc(16);
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (number == 0)
 557:	85 db                	test   %ebx,%ebx
 559:	0f 84 d1 00 00 00    	je     630 <intToStr+0x100>
    while (number >= 1)
 55f:	89 f9                	mov    %edi,%ecx
        switch (number % 10)
 561:	be cd cc cc cc       	mov    $0xcccccccd,%esi
    while (number >= 1)
 566:	0f 8e c7 00 00 00    	jle    633 <intToStr+0x103>
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        switch (number % 10)
 570:	89 d8                	mov    %ebx,%eax
 572:	f7 e6                	mul    %esi
 574:	c1 ea 03             	shr    $0x3,%edx
 577:	8d 04 92             	lea    (%edx,%edx,4),%eax
 57a:	89 da                	mov    %ebx,%edx
 57c:	01 c0                	add    %eax,%eax
 57e:	29 c2                	sub    %eax,%edx
 580:	83 fa 09             	cmp    $0x9,%edx
 583:	0f 87 f2 00 00 00    	ja     67b <intToStr+0x14b>
 589:	ff 24 95 98 0d 00 00 	jmp    *0xd98(,%edx,4)
 590:	b8 32 00 00 00       	mov    $0x32,%eax
 595:	8d 76 00             	lea    0x0(%esi),%esi
            reversedString[k] = '1';
 598:	88 01                	mov    %al,(%ecx)
        number = number / 10;
 59a:	89 d8                	mov    %ebx,%eax
    while (number >= 1)
 59c:	83 c1 01             	add    $0x1,%ecx
        number = number / 10;
 59f:	f7 e6                	mul    %esi
 5a1:	c1 ea 03             	shr    $0x3,%edx
    while (number >= 1)
 5a4:	83 fb 09             	cmp    $0x9,%ebx
 5a7:	0f 8e 86 00 00 00    	jle    633 <intToStr+0x103>
        number = number / 10;
 5ad:	89 d3                	mov    %edx,%ebx
 5af:	eb bf                	jmp    570 <intToStr+0x40>
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        switch (number % 10)
 5b8:	b8 31 00 00 00       	mov    $0x31,%eax
 5bd:	eb d9                	jmp    598 <intToStr+0x68>
 5bf:	90                   	nop
            break;
 5c0:	b8 39 00 00 00       	mov    $0x39,%eax
 5c5:	eb d1                	jmp    598 <intToStr+0x68>
 5c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ce:	66 90                	xchg   %ax,%ax
            break;
 5d0:	b8 38 00 00 00       	mov    $0x38,%eax
 5d5:	eb c1                	jmp    598 <intToStr+0x68>
 5d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5de:	66 90                	xchg   %ax,%ax
            break;
 5e0:	b8 37 00 00 00       	mov    $0x37,%eax
 5e5:	eb b1                	jmp    598 <intToStr+0x68>
 5e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ee:	66 90                	xchg   %ax,%ax
            break;
 5f0:	b8 36 00 00 00       	mov    $0x36,%eax
 5f5:	eb a1                	jmp    598 <intToStr+0x68>
 5f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fe:	66 90                	xchg   %ax,%ax
            break;
 600:	b8 35 00 00 00       	mov    $0x35,%eax
 605:	eb 91                	jmp    598 <intToStr+0x68>
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
            break;
 610:	b8 34 00 00 00       	mov    $0x34,%eax
 615:	eb 81                	jmp    598 <intToStr+0x68>
 617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61e:	66 90                	xchg   %ax,%ax
            break;
 620:	b8 33 00 00 00       	mov    $0x33,%eax
 625:	e9 6e ff ff ff       	jmp    598 <intToStr+0x68>
 62a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        reversedString[k] = '0';
 630:	c6 07 30             	movb   $0x30,(%edi)
    for (int i = strlen(reversedString) - 1; i >= 0; i--)
 633:	83 ec 0c             	sub    $0xc,%esp
 636:	57                   	push   %edi
 637:	e8 e4 00 00 00       	call   720 <strlen>
 63c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 63f:	83 c4 10             	add    $0x10,%esp
 642:	83 e8 01             	sub    $0x1,%eax
 645:	78 1b                	js     662 <intToStr+0x132>
 647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64e:	66 90                	xchg   %ax,%ax
        char c = reversedString[i];
 650:	0f b6 14 07          	movzbl (%edi,%eax,1),%edx
    for (int i = strlen(reversedString) - 1; i >= 0; i--)
 654:	83 e8 01             	sub    $0x1,%eax
 657:	83 c1 01             	add    $0x1,%ecx
        resultString[j] = c;
 65a:	88 51 ff             	mov    %dl,-0x1(%ecx)
    for (int i = strlen(reversedString) - 1; i >= 0; i--)
 65d:	83 f8 ff             	cmp    $0xffffffff,%eax
 660:	75 ee                	jne    650 <intToStr+0x120>
    *size = strlen(reversedString);
 662:	83 ec 0c             	sub    $0xc,%esp
 665:	57                   	push   %edi
 666:	e8 b5 00 00 00       	call   720 <strlen>
 66b:	8b 55 0c             	mov    0xc(%ebp),%edx
 66e:	89 02                	mov    %eax,(%edx)
}
 670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 673:	8d 65 f4             	lea    -0xc(%ebp),%esp
 676:	5b                   	pop    %ebx
 677:	5e                   	pop    %esi
 678:	5f                   	pop    %edi
 679:	5d                   	pop    %ebp
 67a:	c3                   	ret    
            break;
 67b:	b8 30 00 00 00       	mov    $0x30,%eax
 680:	e9 13 ff ff ff       	jmp    598 <intToStr+0x68>
 685:	66 90                	xchg   %ax,%ax
 687:	66 90                	xchg   %ax,%ax
 689:	66 90                	xchg   %ax,%ax
 68b:	66 90                	xchg   %ax,%ax
 68d:	66 90                	xchg   %ax,%ax
 68f:	90                   	nop

00000690 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 690:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 691:	31 c0                	xor    %eax,%eax
{
 693:	89 e5                	mov    %esp,%ebp
 695:	53                   	push   %ebx
 696:	8b 4d 08             	mov    0x8(%ebp),%ecx
 699:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 6a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 6a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 6a7:	83 c0 01             	add    $0x1,%eax
 6aa:	84 d2                	test   %dl,%dl
 6ac:	75 f2                	jne    6a0 <strcpy+0x10>
    ;
  return os;
}
 6ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b1:	89 c8                	mov    %ecx,%eax
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    
 6b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	53                   	push   %ebx
 6c4:	8b 55 08             	mov    0x8(%ebp),%edx
 6c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 6ca:	0f b6 02             	movzbl (%edx),%eax
 6cd:	84 c0                	test   %al,%al
 6cf:	75 17                	jne    6e8 <strcmp+0x28>
 6d1:	eb 3a                	jmp    70d <strcmp+0x4d>
 6d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6d7:	90                   	nop
 6d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 6dc:	83 c2 01             	add    $0x1,%edx
 6df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 6e2:	84 c0                	test   %al,%al
 6e4:	74 1a                	je     700 <strcmp+0x40>
    p++, q++;
 6e6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 6e8:	0f b6 19             	movzbl (%ecx),%ebx
 6eb:	38 c3                	cmp    %al,%bl
 6ed:	74 e9                	je     6d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 6ef:	29 d8                	sub    %ebx,%eax
}
 6f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6f4:	c9                   	leave  
 6f5:	c3                   	ret    
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 700:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 704:	31 c0                	xor    %eax,%eax
 706:	29 d8                	sub    %ebx,%eax
}
 708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 70b:	c9                   	leave  
 70c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 70d:	0f b6 19             	movzbl (%ecx),%ebx
 710:	31 c0                	xor    %eax,%eax
 712:	eb db                	jmp    6ef <strcmp+0x2f>
 714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop

00000720 <strlen>:

uint
strlen(const char *s)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 726:	80 3a 00             	cmpb   $0x0,(%edx)
 729:	74 15                	je     740 <strlen+0x20>
 72b:	31 c0                	xor    %eax,%eax
 72d:	8d 76 00             	lea    0x0(%esi),%esi
 730:	83 c0 01             	add    $0x1,%eax
 733:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 737:	89 c1                	mov    %eax,%ecx
 739:	75 f5                	jne    730 <strlen+0x10>
    ;
  return n;
}
 73b:	89 c8                	mov    %ecx,%eax
 73d:	5d                   	pop    %ebp
 73e:	c3                   	ret    
 73f:	90                   	nop
  for(n = 0; s[n]; n++)
 740:	31 c9                	xor    %ecx,%ecx
}
 742:	5d                   	pop    %ebp
 743:	89 c8                	mov    %ecx,%eax
 745:	c3                   	ret    
 746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74d:	8d 76 00             	lea    0x0(%esi),%esi

00000750 <memset>:

void*
memset(void *dst, int c, uint n)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 757:	8b 4d 10             	mov    0x10(%ebp),%ecx
 75a:	8b 45 0c             	mov    0xc(%ebp),%eax
 75d:	89 d7                	mov    %edx,%edi
 75f:	fc                   	cld    
 760:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 762:	8b 7d fc             	mov    -0x4(%ebp),%edi
 765:	89 d0                	mov    %edx,%eax
 767:	c9                   	leave  
 768:	c3                   	ret    
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000770 <strchr>:

char*
strchr(const char *s, char c)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 77a:	0f b6 10             	movzbl (%eax),%edx
 77d:	84 d2                	test   %dl,%dl
 77f:	75 12                	jne    793 <strchr+0x23>
 781:	eb 1d                	jmp    7a0 <strchr+0x30>
 783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 787:	90                   	nop
 788:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 78c:	83 c0 01             	add    $0x1,%eax
 78f:	84 d2                	test   %dl,%dl
 791:	74 0d                	je     7a0 <strchr+0x30>
    if(*s == c)
 793:	38 d1                	cmp    %dl,%cl
 795:	75 f1                	jne    788 <strchr+0x18>
      return (char*)s;
  return 0;
}
 797:	5d                   	pop    %ebp
 798:	c3                   	ret    
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 7a0:	31 c0                	xor    %eax,%eax
}
 7a2:	5d                   	pop    %ebp
 7a3:	c3                   	ret    
 7a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop

000007b0 <gets>:

char*
gets(char *buf, int max)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 7b5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 7b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 7b9:	31 db                	xor    %ebx,%ebx
{
 7bb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 7be:	eb 27                	jmp    7e7 <gets+0x37>
    cc = read(0, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	6a 01                	push   $0x1
 7c5:	57                   	push   %edi
 7c6:	6a 00                	push   $0x0
 7c8:	e8 2e 01 00 00       	call   8fb <read>
    if(cc < 1)
 7cd:	83 c4 10             	add    $0x10,%esp
 7d0:	85 c0                	test   %eax,%eax
 7d2:	7e 1d                	jle    7f1 <gets+0x41>
      break;
    buf[i++] = c;
 7d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 7d8:	8b 55 08             	mov    0x8(%ebp),%edx
 7db:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 7df:	3c 0a                	cmp    $0xa,%al
 7e1:	74 1d                	je     800 <gets+0x50>
 7e3:	3c 0d                	cmp    $0xd,%al
 7e5:	74 19                	je     800 <gets+0x50>
  for(i=0; i+1 < max; ){
 7e7:	89 de                	mov    %ebx,%esi
 7e9:	83 c3 01             	add    $0x1,%ebx
 7ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 7ef:	7c cf                	jl     7c0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 7f1:	8b 45 08             	mov    0x8(%ebp),%eax
 7f4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 7f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7fb:	5b                   	pop    %ebx
 7fc:	5e                   	pop    %esi
 7fd:	5f                   	pop    %edi
 7fe:	5d                   	pop    %ebp
 7ff:	c3                   	ret    
  buf[i] = '\0';
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	89 de                	mov    %ebx,%esi
 805:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 809:	8d 65 f4             	lea    -0xc(%ebp),%esp
 80c:	5b                   	pop    %ebx
 80d:	5e                   	pop    %esi
 80e:	5f                   	pop    %edi
 80f:	5d                   	pop    %ebp
 810:	c3                   	ret    
 811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop

00000820 <stat>:

int
stat(const char *n, struct stat *st)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	56                   	push   %esi
 824:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 825:	83 ec 08             	sub    $0x8,%esp
 828:	6a 00                	push   $0x0
 82a:	ff 75 08             	push   0x8(%ebp)
 82d:	e8 f1 00 00 00       	call   923 <open>
  if(fd < 0)
 832:	83 c4 10             	add    $0x10,%esp
 835:	85 c0                	test   %eax,%eax
 837:	78 27                	js     860 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 839:	83 ec 08             	sub    $0x8,%esp
 83c:	ff 75 0c             	push   0xc(%ebp)
 83f:	89 c3                	mov    %eax,%ebx
 841:	50                   	push   %eax
 842:	e8 f4 00 00 00       	call   93b <fstat>
  close(fd);
 847:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 84a:	89 c6                	mov    %eax,%esi
  close(fd);
 84c:	e8 ba 00 00 00       	call   90b <close>
  return r;
 851:	83 c4 10             	add    $0x10,%esp
}
 854:	8d 65 f8             	lea    -0x8(%ebp),%esp
 857:	89 f0                	mov    %esi,%eax
 859:	5b                   	pop    %ebx
 85a:	5e                   	pop    %esi
 85b:	5d                   	pop    %ebp
 85c:	c3                   	ret    
 85d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 860:	be ff ff ff ff       	mov    $0xffffffff,%esi
 865:	eb ed                	jmp    854 <stat+0x34>
 867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 86e:	66 90                	xchg   %ax,%ax

00000870 <atoi>:

int
atoi(const char *s)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	53                   	push   %ebx
 874:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 877:	0f be 02             	movsbl (%edx),%eax
 87a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 87d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 880:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 885:	77 1e                	ja     8a5 <atoi+0x35>
 887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 88e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 890:	83 c2 01             	add    $0x1,%edx
 893:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 896:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 89a:	0f be 02             	movsbl (%edx),%eax
 89d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 8a0:	80 fb 09             	cmp    $0x9,%bl
 8a3:	76 eb                	jbe    890 <atoi+0x20>
  return n;
}
 8a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8a8:	89 c8                	mov    %ecx,%eax
 8aa:	c9                   	leave  
 8ab:	c3                   	ret    
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	57                   	push   %edi
 8b4:	8b 45 10             	mov    0x10(%ebp),%eax
 8b7:	8b 55 08             	mov    0x8(%ebp),%edx
 8ba:	56                   	push   %esi
 8bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8be:	85 c0                	test   %eax,%eax
 8c0:	7e 13                	jle    8d5 <memmove+0x25>
 8c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 8c4:	89 d7                	mov    %edx,%edi
 8c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 8d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 8d1:	39 f8                	cmp    %edi,%eax
 8d3:	75 fb                	jne    8d0 <memmove+0x20>
  return vdst;
}
 8d5:	5e                   	pop    %esi
 8d6:	89 d0                	mov    %edx,%eax
 8d8:	5f                   	pop    %edi
 8d9:	5d                   	pop    %ebp
 8da:	c3                   	ret    

000008db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8db:	b8 01 00 00 00       	mov    $0x1,%eax
 8e0:	cd 40                	int    $0x40
 8e2:	c3                   	ret    

000008e3 <exit>:
SYSCALL(exit)
 8e3:	b8 02 00 00 00       	mov    $0x2,%eax
 8e8:	cd 40                	int    $0x40
 8ea:	c3                   	ret    

000008eb <wait>:
SYSCALL(wait)
 8eb:	b8 03 00 00 00       	mov    $0x3,%eax
 8f0:	cd 40                	int    $0x40
 8f2:	c3                   	ret    

000008f3 <pipe>:
SYSCALL(pipe)
 8f3:	b8 04 00 00 00       	mov    $0x4,%eax
 8f8:	cd 40                	int    $0x40
 8fa:	c3                   	ret    

000008fb <read>:
SYSCALL(read)
 8fb:	b8 05 00 00 00       	mov    $0x5,%eax
 900:	cd 40                	int    $0x40
 902:	c3                   	ret    

00000903 <write>:
SYSCALL(write)
 903:	b8 10 00 00 00       	mov    $0x10,%eax
 908:	cd 40                	int    $0x40
 90a:	c3                   	ret    

0000090b <close>:
SYSCALL(close)
 90b:	b8 15 00 00 00       	mov    $0x15,%eax
 910:	cd 40                	int    $0x40
 912:	c3                   	ret    

00000913 <kill>:
SYSCALL(kill)
 913:	b8 06 00 00 00       	mov    $0x6,%eax
 918:	cd 40                	int    $0x40
 91a:	c3                   	ret    

0000091b <exec>:
SYSCALL(exec)
 91b:	b8 07 00 00 00       	mov    $0x7,%eax
 920:	cd 40                	int    $0x40
 922:	c3                   	ret    

00000923 <open>:
SYSCALL(open)
 923:	b8 0f 00 00 00       	mov    $0xf,%eax
 928:	cd 40                	int    $0x40
 92a:	c3                   	ret    

0000092b <mknod>:
SYSCALL(mknod)
 92b:	b8 11 00 00 00       	mov    $0x11,%eax
 930:	cd 40                	int    $0x40
 932:	c3                   	ret    

00000933 <unlink>:
SYSCALL(unlink)
 933:	b8 12 00 00 00       	mov    $0x12,%eax
 938:	cd 40                	int    $0x40
 93a:	c3                   	ret    

0000093b <fstat>:
SYSCALL(fstat)
 93b:	b8 08 00 00 00       	mov    $0x8,%eax
 940:	cd 40                	int    $0x40
 942:	c3                   	ret    

00000943 <link>:
SYSCALL(link)
 943:	b8 13 00 00 00       	mov    $0x13,%eax
 948:	cd 40                	int    $0x40
 94a:	c3                   	ret    

0000094b <mkdir>:
SYSCALL(mkdir)
 94b:	b8 14 00 00 00       	mov    $0x14,%eax
 950:	cd 40                	int    $0x40
 952:	c3                   	ret    

00000953 <chdir>:
SYSCALL(chdir)
 953:	b8 09 00 00 00       	mov    $0x9,%eax
 958:	cd 40                	int    $0x40
 95a:	c3                   	ret    

0000095b <dup>:
SYSCALL(dup)
 95b:	b8 0a 00 00 00       	mov    $0xa,%eax
 960:	cd 40                	int    $0x40
 962:	c3                   	ret    

00000963 <getpid>:
SYSCALL(getpid)
 963:	b8 0b 00 00 00       	mov    $0xb,%eax
 968:	cd 40                	int    $0x40
 96a:	c3                   	ret    

0000096b <sbrk>:
SYSCALL(sbrk)
 96b:	b8 0c 00 00 00       	mov    $0xc,%eax
 970:	cd 40                	int    $0x40
 972:	c3                   	ret    

00000973 <sleep>:
SYSCALL(sleep)
 973:	b8 0d 00 00 00       	mov    $0xd,%eax
 978:	cd 40                	int    $0x40
 97a:	c3                   	ret    

0000097b <uptime>:
SYSCALL(uptime)
 97b:	b8 0e 00 00 00       	mov    $0xe,%eax
 980:	cd 40                	int    $0x40
 982:	c3                   	ret    

00000983 <count_num_of_digit>:
SYSCALL(count_num_of_digit)
 983:	b8 16 00 00 00       	mov    $0x16,%eax
 988:	cd 40                	int    $0x40
 98a:	c3                   	ret    

0000098b <change_process_queue>:
SYSCALL(change_process_queue)
 98b:	b8 17 00 00 00       	mov    $0x17,%eax
 990:	cd 40                	int    $0x40
 992:	c3                   	ret    

00000993 <set_sjf_process>:
SYSCALL(set_sjf_process)
 993:	b8 19 00 00 00       	mov    $0x19,%eax
 998:	cd 40                	int    $0x40
 99a:	c3                   	ret    

0000099b <print_schedule_info>:
SYSCALL(print_schedule_info)
 99b:	b8 18 00 00 00       	mov    $0x18,%eax
 9a0:	cd 40                	int    $0x40
 9a2:	c3                   	ret    

000009a3 <printvir>:
SYSCALL(printvir)
 9a3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 9a8:	cd 40                	int    $0x40
 9aa:	c3                   	ret    

000009ab <printphy>:
SYSCALL(printphy)
 9ab:	b8 1b 00 00 00       	mov    $0x1b,%eax
 9b0:	cd 40                	int    $0x40
 9b2:	c3                   	ret    

000009b3 <mapex>:
SYSCALL(mapex)
 9b3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 9b8:	cd 40                	int    $0x40
 9ba:	c3                   	ret    
 9bb:	66 90                	xchg   %ax,%ax
 9bd:	66 90                	xchg   %ax,%ax
 9bf:	90                   	nop

000009c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 3c             	sub    $0x3c,%esp
 9c9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 9cc:	89 d1                	mov    %edx,%ecx
{
 9ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 9d1:	85 d2                	test   %edx,%edx
 9d3:	0f 89 7f 00 00 00    	jns    a58 <printint+0x98>
 9d9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 9dd:	74 79                	je     a58 <printint+0x98>
    neg = 1;
 9df:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 9e6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 9e8:	31 db                	xor    %ebx,%ebx
 9ea:	8d 75 d7             	lea    -0x29(%ebp),%esi
 9ed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 9f0:	89 c8                	mov    %ecx,%eax
 9f2:	31 d2                	xor    %edx,%edx
 9f4:	89 cf                	mov    %ecx,%edi
 9f6:	f7 75 c4             	divl   -0x3c(%ebp)
 9f9:	0f b6 92 b0 0e 00 00 	movzbl 0xeb0(%edx),%edx
 a00:	89 45 c0             	mov    %eax,-0x40(%ebp)
 a03:	89 d8                	mov    %ebx,%eax
 a05:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 a08:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 a0b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 a0e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 a11:	76 dd                	jbe    9f0 <printint+0x30>
  if(neg)
 a13:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 a16:	85 c9                	test   %ecx,%ecx
 a18:	74 0c                	je     a26 <printint+0x66>
    buf[i++] = '-';
 a1a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 a1f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 a21:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 a26:	8b 7d b8             	mov    -0x48(%ebp),%edi
 a29:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 a2d:	eb 07                	jmp    a36 <printint+0x76>
 a2f:	90                   	nop
    putc(fd, buf[i]);
 a30:	0f b6 13             	movzbl (%ebx),%edx
 a33:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 a36:	83 ec 04             	sub    $0x4,%esp
 a39:	88 55 d7             	mov    %dl,-0x29(%ebp)
 a3c:	6a 01                	push   $0x1
 a3e:	56                   	push   %esi
 a3f:	57                   	push   %edi
 a40:	e8 be fe ff ff       	call   903 <write>
  while(--i >= 0)
 a45:	83 c4 10             	add    $0x10,%esp
 a48:	39 de                	cmp    %ebx,%esi
 a4a:	75 e4                	jne    a30 <printint+0x70>
}
 a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a4f:	5b                   	pop    %ebx
 a50:	5e                   	pop    %esi
 a51:	5f                   	pop    %edi
 a52:	5d                   	pop    %ebp
 a53:	c3                   	ret    
 a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 a58:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 a5f:	eb 87                	jmp    9e8 <printint+0x28>
 a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a6f:	90                   	nop

00000a70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	57                   	push   %edi
 a74:	56                   	push   %esi
 a75:	53                   	push   %ebx
 a76:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 a7c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 a7f:	0f b6 13             	movzbl (%ebx),%edx
 a82:	84 d2                	test   %dl,%dl
 a84:	74 6a                	je     af0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 a86:	8d 45 10             	lea    0x10(%ebp),%eax
 a89:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 a8c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 a8f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 a91:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a94:	eb 36                	jmp    acc <printf+0x5c>
 a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a9d:	8d 76 00             	lea    0x0(%esi),%esi
 aa0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 aa3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 aa8:	83 f8 25             	cmp    $0x25,%eax
 aab:	74 15                	je     ac2 <printf+0x52>
  write(fd, &c, 1);
 aad:	83 ec 04             	sub    $0x4,%esp
 ab0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 ab3:	6a 01                	push   $0x1
 ab5:	57                   	push   %edi
 ab6:	56                   	push   %esi
 ab7:	e8 47 fe ff ff       	call   903 <write>
 abc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 abf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 ac2:	0f b6 13             	movzbl (%ebx),%edx
 ac5:	83 c3 01             	add    $0x1,%ebx
 ac8:	84 d2                	test   %dl,%dl
 aca:	74 24                	je     af0 <printf+0x80>
    c = fmt[i] & 0xff;
 acc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 acf:	85 c9                	test   %ecx,%ecx
 ad1:	74 cd                	je     aa0 <printf+0x30>
      }
    } else if(state == '%'){
 ad3:	83 f9 25             	cmp    $0x25,%ecx
 ad6:	75 ea                	jne    ac2 <printf+0x52>
      if(c == 'd'){
 ad8:	83 f8 25             	cmp    $0x25,%eax
 adb:	0f 84 07 01 00 00    	je     be8 <printf+0x178>
 ae1:	83 e8 63             	sub    $0x63,%eax
 ae4:	83 f8 15             	cmp    $0x15,%eax
 ae7:	77 17                	ja     b00 <printf+0x90>
 ae9:	ff 24 85 58 0e 00 00 	jmp    *0xe58(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 af3:	5b                   	pop    %ebx
 af4:	5e                   	pop    %esi
 af5:	5f                   	pop    %edi
 af6:	5d                   	pop    %ebp
 af7:	c3                   	ret    
 af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aff:	90                   	nop
  write(fd, &c, 1);
 b00:	83 ec 04             	sub    $0x4,%esp
 b03:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 b06:	6a 01                	push   $0x1
 b08:	57                   	push   %edi
 b09:	56                   	push   %esi
 b0a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b0e:	e8 f0 fd ff ff       	call   903 <write>
        putc(fd, c);
 b13:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 b17:	83 c4 0c             	add    $0xc,%esp
 b1a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 b1d:	6a 01                	push   $0x1
 b1f:	57                   	push   %edi
 b20:	56                   	push   %esi
 b21:	e8 dd fd ff ff       	call   903 <write>
        putc(fd, c);
 b26:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b29:	31 c9                	xor    %ecx,%ecx
 b2b:	eb 95                	jmp    ac2 <printf+0x52>
 b2d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 b30:	83 ec 0c             	sub    $0xc,%esp
 b33:	b9 10 00 00 00       	mov    $0x10,%ecx
 b38:	6a 00                	push   $0x0
 b3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 b3d:	8b 10                	mov    (%eax),%edx
 b3f:	89 f0                	mov    %esi,%eax
 b41:	e8 7a fe ff ff       	call   9c0 <printint>
        ap++;
 b46:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 b4a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b4d:	31 c9                	xor    %ecx,%ecx
 b4f:	e9 6e ff ff ff       	jmp    ac2 <printf+0x52>
 b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 b58:	8b 45 d0             	mov    -0x30(%ebp),%eax
 b5b:	8b 10                	mov    (%eax),%edx
        ap++;
 b5d:	83 c0 04             	add    $0x4,%eax
 b60:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 b63:	85 d2                	test   %edx,%edx
 b65:	0f 84 8d 00 00 00    	je     bf8 <printf+0x188>
        while(*s != 0){
 b6b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 b6e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 b70:	84 c0                	test   %al,%al
 b72:	0f 84 4a ff ff ff    	je     ac2 <printf+0x52>
 b78:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 b7b:	89 d3                	mov    %edx,%ebx
 b7d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 b80:	83 ec 04             	sub    $0x4,%esp
          s++;
 b83:	83 c3 01             	add    $0x1,%ebx
 b86:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 b89:	6a 01                	push   $0x1
 b8b:	57                   	push   %edi
 b8c:	56                   	push   %esi
 b8d:	e8 71 fd ff ff       	call   903 <write>
        while(*s != 0){
 b92:	0f b6 03             	movzbl (%ebx),%eax
 b95:	83 c4 10             	add    $0x10,%esp
 b98:	84 c0                	test   %al,%al
 b9a:	75 e4                	jne    b80 <printf+0x110>
      state = 0;
 b9c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 b9f:	31 c9                	xor    %ecx,%ecx
 ba1:	e9 1c ff ff ff       	jmp    ac2 <printf+0x52>
 ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 bad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 bb0:	83 ec 0c             	sub    $0xc,%esp
 bb3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 bb8:	6a 01                	push   $0x1
 bba:	e9 7b ff ff ff       	jmp    b3a <printf+0xca>
 bbf:	90                   	nop
        putc(fd, *ap);
 bc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 bc3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 bc6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 bc8:	6a 01                	push   $0x1
 bca:	57                   	push   %edi
 bcb:	56                   	push   %esi
        putc(fd, *ap);
 bcc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 bcf:	e8 2f fd ff ff       	call   903 <write>
        ap++;
 bd4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 bd8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bdb:	31 c9                	xor    %ecx,%ecx
 bdd:	e9 e0 fe ff ff       	jmp    ac2 <printf+0x52>
 be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 be8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 beb:	83 ec 04             	sub    $0x4,%esp
 bee:	e9 2a ff ff ff       	jmp    b1d <printf+0xad>
 bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 bf7:	90                   	nop
          s = "(null)";
 bf8:	ba 50 0e 00 00       	mov    $0xe50,%edx
        while(*s != 0){
 bfd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 c00:	b8 28 00 00 00       	mov    $0x28,%eax
 c05:	89 d3                	mov    %edx,%ebx
 c07:	e9 74 ff ff ff       	jmp    b80 <printf+0x110>
 c0c:	66 90                	xchg   %ax,%ax
 c0e:	66 90                	xchg   %ax,%ax

00000c10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c10:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c11:	a1 24 12 00 00       	mov    0x1224,%eax
{
 c16:	89 e5                	mov    %esp,%ebp
 c18:	57                   	push   %edi
 c19:	56                   	push   %esi
 c1a:	53                   	push   %ebx
 c1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 c1e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c28:	89 c2                	mov    %eax,%edx
 c2a:	8b 00                	mov    (%eax),%eax
 c2c:	39 ca                	cmp    %ecx,%edx
 c2e:	73 30                	jae    c60 <free+0x50>
 c30:	39 c1                	cmp    %eax,%ecx
 c32:	72 04                	jb     c38 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c34:	39 c2                	cmp    %eax,%edx
 c36:	72 f0                	jb     c28 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c38:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c3b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c3e:	39 f8                	cmp    %edi,%eax
 c40:	74 30                	je     c72 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 c42:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 c45:	8b 42 04             	mov    0x4(%edx),%eax
 c48:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 c4b:	39 f1                	cmp    %esi,%ecx
 c4d:	74 3a                	je     c89 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 c4f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 c51:	5b                   	pop    %ebx
  freep = p;
 c52:	89 15 24 12 00 00    	mov    %edx,0x1224
}
 c58:	5e                   	pop    %esi
 c59:	5f                   	pop    %edi
 c5a:	5d                   	pop    %ebp
 c5b:	c3                   	ret    
 c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c60:	39 c2                	cmp    %eax,%edx
 c62:	72 c4                	jb     c28 <free+0x18>
 c64:	39 c1                	cmp    %eax,%ecx
 c66:	73 c0                	jae    c28 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 c68:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c6b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c6e:	39 f8                	cmp    %edi,%eax
 c70:	75 d0                	jne    c42 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 c72:	03 70 04             	add    0x4(%eax),%esi
 c75:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 c78:	8b 02                	mov    (%edx),%eax
 c7a:	8b 00                	mov    (%eax),%eax
 c7c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 c7f:	8b 42 04             	mov    0x4(%edx),%eax
 c82:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 c85:	39 f1                	cmp    %esi,%ecx
 c87:	75 c6                	jne    c4f <free+0x3f>
    p->s.size += bp->s.size;
 c89:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 c8c:	89 15 24 12 00 00    	mov    %edx,0x1224
    p->s.size += bp->s.size;
 c92:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 c95:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 c98:	89 0a                	mov    %ecx,(%edx)
}
 c9a:	5b                   	pop    %ebx
 c9b:	5e                   	pop    %esi
 c9c:	5f                   	pop    %edi
 c9d:	5d                   	pop    %ebp
 c9e:	c3                   	ret    
 c9f:	90                   	nop

00000ca0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ca0:	55                   	push   %ebp
 ca1:	89 e5                	mov    %esp,%ebp
 ca3:	57                   	push   %edi
 ca4:	56                   	push   %esi
 ca5:	53                   	push   %ebx
 ca6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 cac:	8b 3d 24 12 00 00    	mov    0x1224,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cb2:	8d 70 07             	lea    0x7(%eax),%esi
 cb5:	c1 ee 03             	shr    $0x3,%esi
 cb8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 cbb:	85 ff                	test   %edi,%edi
 cbd:	0f 84 9d 00 00 00    	je     d60 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 cc5:	8b 4a 04             	mov    0x4(%edx),%ecx
 cc8:	39 f1                	cmp    %esi,%ecx
 cca:	73 6a                	jae    d36 <malloc+0x96>
 ccc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 cd1:	39 de                	cmp    %ebx,%esi
 cd3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 cd6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 cdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 ce0:	eb 17                	jmp    cf9 <malloc+0x59>
 ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 cea:	8b 48 04             	mov    0x4(%eax),%ecx
 ced:	39 f1                	cmp    %esi,%ecx
 cef:	73 4f                	jae    d40 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cf1:	8b 3d 24 12 00 00    	mov    0x1224,%edi
 cf7:	89 c2                	mov    %eax,%edx
 cf9:	39 d7                	cmp    %edx,%edi
 cfb:	75 eb                	jne    ce8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 cfd:	83 ec 0c             	sub    $0xc,%esp
 d00:	ff 75 e4             	push   -0x1c(%ebp)
 d03:	e8 63 fc ff ff       	call   96b <sbrk>
  if(p == (char*)-1)
 d08:	83 c4 10             	add    $0x10,%esp
 d0b:	83 f8 ff             	cmp    $0xffffffff,%eax
 d0e:	74 1c                	je     d2c <malloc+0x8c>
  hp->s.size = nu;
 d10:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d13:	83 ec 0c             	sub    $0xc,%esp
 d16:	83 c0 08             	add    $0x8,%eax
 d19:	50                   	push   %eax
 d1a:	e8 f1 fe ff ff       	call   c10 <free>
  return freep;
 d1f:	8b 15 24 12 00 00    	mov    0x1224,%edx
      if((p = morecore(nunits)) == 0)
 d25:	83 c4 10             	add    $0x10,%esp
 d28:	85 d2                	test   %edx,%edx
 d2a:	75 bc                	jne    ce8 <malloc+0x48>
        return 0;
  }
}
 d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 d2f:	31 c0                	xor    %eax,%eax
}
 d31:	5b                   	pop    %ebx
 d32:	5e                   	pop    %esi
 d33:	5f                   	pop    %edi
 d34:	5d                   	pop    %ebp
 d35:	c3                   	ret    
    if(p->s.size >= nunits){
 d36:	89 d0                	mov    %edx,%eax
 d38:	89 fa                	mov    %edi,%edx
 d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 d40:	39 ce                	cmp    %ecx,%esi
 d42:	74 4c                	je     d90 <malloc+0xf0>
        p->s.size -= nunits;
 d44:	29 f1                	sub    %esi,%ecx
 d46:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 d49:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 d4c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 d4f:	89 15 24 12 00 00    	mov    %edx,0x1224
}
 d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 d58:	83 c0 08             	add    $0x8,%eax
}
 d5b:	5b                   	pop    %ebx
 d5c:	5e                   	pop    %esi
 d5d:	5f                   	pop    %edi
 d5e:	5d                   	pop    %ebp
 d5f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 d60:	c7 05 24 12 00 00 28 	movl   $0x1228,0x1224
 d67:	12 00 00 
    base.s.size = 0;
 d6a:	bf 28 12 00 00       	mov    $0x1228,%edi
    base.s.ptr = freep = prevp = &base;
 d6f:	c7 05 28 12 00 00 28 	movl   $0x1228,0x1228
 d76:	12 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d79:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 d7b:	c7 05 2c 12 00 00 00 	movl   $0x0,0x122c
 d82:	00 00 00 
    if(p->s.size >= nunits){
 d85:	e9 42 ff ff ff       	jmp    ccc <malloc+0x2c>
 d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 d90:	8b 08                	mov    (%eax),%ecx
 d92:	89 0a                	mov    %ecx,(%edx)
 d94:	eb b9                	jmp    d4f <malloc+0xaf>
