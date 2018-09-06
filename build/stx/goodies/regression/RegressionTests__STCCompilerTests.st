"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#STCCompilerTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!

!STCCompilerTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    documentation to be added.

    [author:]
	cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!STCCompilerTests methodsFor:'code templates'!

inlinedBlockVariables1
    "stc generates wrong code for inlined variables"

    | b |

    b := [:arg1 |
	|local1|

	local1 := #local1.
	1 to:3 do:[:argb_1 |
	    |localb_1 localb_2|

	    localb_1 := #localb_1.
	    localb_2 := #localb_2.
	    1 to:5 do:[:argbb_1 |
		|localbb_1 localbb_2|

		localbb_1 := #localbb_1.
		localbb_2 := #localbb_2.
		argbb_1 == 3 ifTrue:[
		    ^ [:argbbb_1 |
			|localbbb_1 localbbb_2|

			localbbb_1 := #localbbb_1.
			localbbb_2 := #localbbb_2.

			localb_1 "/ here, in old stc versions, localb_2 is returned
		    ].
		].
	    ]
	]
    ].

    ^ b value:#arg1
!

inlinedBlockVariables2
    "stc generates wrong code for inlined variables"

    | b |

    b := [:arg1 |
	|local1|

	local1 := #local1.
	1 to:3 do:[:argb_1 |
	    |localb_1 localb_2|

	    localb_1 := #localb_1.
	    localb_2 := #localb_2.
	    1 to:5 do:[:argbb_1 |
		|localbb_1 localbb_2|

		localbb_1 := #localbb_1.
		localbb_2 := #localbb_2.
		argbb_1 == 3 ifTrue:[
		    ^ [:argbbb_1 |
			|localbbb_1 localbbb_2|

			localbbb_1 := #localbbb_1.
			localbbb_2 := #localbbb_2.
			argbb_1
		    ].
		].
	    ]
	]
    ].

    ^ b value:#arg1
!

nextLittleEndianNumber: n from:bytes
    "stc generates wrong code for the following s := assignment"

    | s |

    s := 0.
    n to: 1 by: -1 do: [:i | s := (s bitShift: 8) bitOr: (bytes at: i)].
    ^ s

    "Created: / 17-09-2011 / 10:32:29 / cg"
! !

!STCCompilerTests methodsFor:'tests'!

test01_compilation
    "checks for an stc compiler bug (detected Sep 2011).
     stc generates bad code for the bitOr expression in nextLittleEndianNumber"

    Class withoutUpdatingChangesDo:[
	(STCCompilerInterface new)
	    compileToMachineCode:'hello
%{
    console_printf("hello world\n");
%}
'
	    forClass:self class
	    selector:#'hello'
	    inCategory:'tests'
	    notifying:nil
	    install:true
	    skipIfSame:false
	    silent:true.

	self hello.
	self class removeSelector:#hello.
    ].

    "
     self run:#test01_compilation
     self new test01_compilation
    "

    "Created: / 17-09-2011 / 10:32:18 / cg"
!

test02_compilation
    "checks for an stc compiler bug (detected Sep 2011).
     stc generates bad code for the bitOr expression in nextLittleEndianNumber"

    |val|

    Class withoutUpdatingChangesDo:[
	(STCCompilerInterface new)
	    compileToMachineCode:'x123
%{
    RETURN(__MKSMALLINT(123));
%}
'
	    forClass:self class
	    selector:#'x123'
	    inCategory:'tests'
	    notifying:nil
	    install:true
	    skipIfSame:false
	    silent:true.

	val := self x123.
	self assert:(val == 123).
	self class removeSelector:#x123.
    ].

    "
     self run:#test02_compilation
     self new test02_compilation
    "

    "Created: / 17-09-2011 / 10:32:18 / cg"
!

test03_compilation
    "As of 2013-09-04, instance variables of Class are not visible
     in class methods of ordinary classes.
     For bytecode-compiled method they are.

     This tests checks for this bug.
    "

    |val|
    [
       Class withoutUpdatingChangesDo:[
	   "/ Check bytecode version first...
	   self class class compile:'returnMyName
       ^ name
   '.
	   val := self class returnMyName.
	   self assert:(val == self class name).
	   self class class removeSelector:#returnMyName.

	   "/ Now, compile the same source using stc and check...
	   (STCCompilerInterface new)
	       compileToMachineCode:'returnMyName
       ^ name
   '
	       forClass:self class class
	       selector:#'returnMyName'
	       inCategory:'tests'
	       notifying:nil
	       install:true
	       skipIfSame:false
	       silent:true.

	   val := self class returnMyName.
	   self assert:(val == self class name).
	   self class class removeSelector:#returnMyName.
       ].
    ] ensure:[
	self class class removeSelector:#returnMyName.
    ]

    "
     self run:#test02_compilation
     self new test02_compilation
    "

    "Created: / 04-09-2013 / 09:35:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test04_doubleArraySize_bug

    "As of 2014-03-11, __doubleArraySize() seem to return off-by-one size
     on Windows. Under Linux it seem to work just fine.

     This tests checks for this bug.
    "

    | sizes |
    [
       Class withoutUpdatingChangesDo:[
	   (STCCompilerInterface new)
	       compileToMachineCode:'doubleArraySize
		    | arr size1 size2 |

		    arr := DoubleArray new: 8.
		    size1 := arr size.
%{
		    size2 = __MKINT(__doubleArraySize(arr));
%}.
		    ^ Array with: size1 with: size2.
   '
	       forClass:self class class
	       selector:#'doubleArraySize'
	       inCategory:'tests'
	       notifying:nil
	       install:true
	       skipIfSame:false
	       silent:true.

	   sizes := self class perform: #doubleArraySize.
	   self assert:(sizes first == 8).
	   self assert:(sizes second == 8).
	   self class class removeSelector:#doubleArraySize.
       ].
    ] ensure:[
	self class class removeSelector:#doubleArraySize.
    ]

    "
     self run:#test02_compilation
     self new test02_compilation
    "

    "Created: / 11-02-2014 / 23:50:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 04-03-2014 / 10:13:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test10_bitor_bug
    "checks for an stc compiler bug (detected Sep 2011).
     stc generates bad code for the bitOr expression in nextLittleEndianNumber"

    |val mthd|

    Class withoutUpdatingChangesDo:[
	self class recompile:#'nextLittleEndianNumber:from:'.
        
	val := self nextLittleEndianNumber:4 from:#[1 2 3 4].
	self assert:(val = 16r04030201).
	val := self nextLittleEndianNumber:8 from:#[1 2 3 4 5 6 7 8].
	self assert:(val = 16r0807060504030201).

	mthd := self class compiledMethodAt:#'nextLittleEndianNumber:from:'.
	(STCCompilerInterface new)
	    compileToMachineCode:mthd source
	    forClass:self class
	    selector:#'nextLittleEndianNumber:from:'
	    inCategory:mthd category
	    notifying:nil
	    install:true
	    skipIfSame:false
	    silent:true.

	self
	    assert:mthd ~= (self class compiledMethodAt:#'nextLittleEndianNumber:from:')
	    description:'Could not compile with STC'.

	val := self nextLittleEndianNumber:4 from:#[1 2 3 4].
	self assert:(val = 16r04030201).
	val := self nextLittleEndianNumber:8 from:#[1 2 3 4 5 6 7 8].
	self assert:(val = 16r0807060504030201).
    ].

    "
     self run:#test10_bitor_bug
     self new test10_bitor_bug
    "

    "Created: / 17-09-2011 / 10:32:18 / cg"
!

test20_localsOfInlinedBlock_bug
    "checks for an stc compiler bug (detected Sep 2011).
     stc generates bad code for the bitOr expression in nextLittleEndianNumber"

    |blk mthd|

    Class withoutUpdatingChangesDo:[
	self class recompile:#'inlinedBlockVariables1'.
	blk := self inlinedBlockVariables1.
	self assert:((blk value:#argbbb_1) == #localb_1).

	mthd := self class compiledMethodAt:#'inlinedBlockVariables1'.
	(STCCompilerInterface new)
	    compileToMachineCode:mthd source
	    forClass:self class
	    selector:#'inlinedBlockVariables1'
	    inCategory:mthd category
	    notifying:nil
	    install:true
	    skipIfSame:false
	    silent:true.

	self
	    assert:mthd ~= (self class compiledMethodAt:#'inlinedBlockVariables1')
	    description:'Could not compile with STC'.

	blk := self inlinedBlockVariables1.
	self assert:((blk value:#argbbb_1) == #localb_1).
    ].

    "
     self run:#test20_localsOfInlinedBlock_bug
     self new test20_localsOfInlinedBlock_bug
    "

    "Created: / 17-09-2011 / 10:32:18 / cg"
!

test21_localsOfInlinedBlock_bug
    "checks for an stc compiler bug (detected Sep 2011).
     stc generates bad code for the bitOr expression in nextLittleEndianNumber"

    |blk mthd|

    Class withoutUpdatingChangesDo:[
	self class recompile:#'inlinedBlockVariables2'.
	blk := self inlinedBlockVariables2.
	self assert:((blk value:#argbbb_1) == 3).

	mthd := self class compiledMethodAt:#'inlinedBlockVariables2'.
	(STCCompilerInterface new)
	    compileToMachineCode:mthd source
	    forClass:self class
	    selector:#'inlinedBlockVariables2'
	    inCategory:mthd category
	    notifying:nil
	    install:true
	    skipIfSame:false
	    silent:true.

	self
	    assert:mthd ~= (self class compiledMethodAt:#'inlinedBlockVariables2')
	    description:'Could not compile with STC'.

	blk := self inlinedBlockVariables2.
	self assert:((blk value:#argbbb_1) == 3).
    ].

    "
     self run:#test21_localsOfInlinedBlock_bug
     self new test21_localsOfInlinedBlock_bug
    "

    "Created: / 17-09-2011 / 10:32:18 / cg"
!

test_LongIntegerArray_01
    |sizes|

    [
	Class
	    withoutUpdatingChangesDo:[
		"/ Now, compile the same source using stc and check...
		(STCCompilerInterface new)
		    compileToMachineCode:'longIntegerArray_size
		    | arr size1 size2 |

		    arr := LongIntegerArray new: 8.
		    size1 := arr size.
%{
		    size2 = __MKINT(__longIntegerArraySize(arr));
%}.
		    ^ Array with: size1 with: size2.
   '
		    forClass:self class class
		    selector:#'longIntegerArray_size'
		    inCategory:'tests'
		    notifying:nil
		    install:true
		    skipIfSame:false
		    silent:true.
		sizes := self class perform:#'longIntegerArray_size'.
		self assert:(sizes first == 8).
		self assert:(sizes second == 8).
		self class class removeSelector:#'longIntegerArray_size'.
	    ].
    ] ensure:[ self class class removeSelector:#'longIntegerArray_size'. ]

    "
     self run:#test02_compilation
     self new test02_compilation"
    "Created: / 04-03-2014 / 10:20:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_LongIntegerArray_02
    |sizes verbose|

    verbose := false.

    [
	Class
	    withoutUpdatingChangesDo:[
		(STCCompilerInterface new)
		    compileToMachineCode:'longIntegerArray_i_element
		    | arr v1 v8 |

		    arr := LongIntegerArray new: 8.
		    arr at: 1 put: 11123456789.
		    arr at: 8 put: 11123456789.
		    self assert: (arr at: 1) = 11123456789.
		    self assert: (arr at: 8) = 11123456789.

%{
		    __uint64__ val;
		    console_printf("arr: arr = 0x%x\n", (INT)arr);
#if defined(__x86_64__)
		    val = 0x0001000100010001;
#else
		    val.lo = 1; val.hi = 1;
#endif
		    val =  __LongIntegerArrayInstPtr(arr)->i_element[0];
//                    console_printf("v1: val.lo = %d, val.hi = %d\n", val.lo, val.hi);
		    v1 = __MKUINT64(&val);
		    val =  __LongIntegerArrayInstPtr(arr)->i_element[7];
//                    console_printf("v2: val.lo = %d, val.hi = %d\n", val.lo, val.hi);
		    v8 = __MKUINT64(&val);
%}.
		    v1 errorPrintCR.
		    v8 errorPrintCR.
		    ^ Array with: v1 with: v8.
   '
		    forClass:self class class
		    selector:#'longIntegerArray_i_element'
		    inCategory:'tests'
		    notifying:nil
		    install:true
		    skipIfSame:false
		    silent:true.
		1 to:100 do:[:i |
		    verbose ifTrue:[
                        ('Pass ' , i printString) errorPrintCR.
		    ].
		    sizes := self class perform:#'longIntegerArray_i_element'.
		    self assert:(sizes first = 11123456789) description:('failed in pass ',i printString).
		    self assert:(sizes second = 11123456789) description:('failed in pass ',i printString).
		].
		self class class removeSelector:#'longIntegerArray_i_element'.
	    ].
    ] ensure:[ self class class removeSelector:#'longIntegerArray_i_element'. ]

    "
     self run:#test02_compilation
     self new test02_compilation"
    "Created: / 04-03-2014 / 10:21:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-06-2014 / 10:44:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_SignedLongIntegerArray_01
    |sizes|

    [
	Class
	    withoutUpdatingChangesDo:[
		"/ Now, compile the same source using stc and check...
		(STCCompilerInterface new)
		    compileToMachineCode:'signedLongIntegerArray_size
		    | arr size1 size2 |

		    arr := SignedLongIntegerArray new: 8.
		    size1 := arr size.
%{
		    size2 = __MKINT(__signedLongIntegerArraySize(arr));
%}.
		    ^ Array with: size1 with: size2.
   '
		    forClass:self class class
		    selector:#'signedLongIntegerArray_size'
		    inCategory:'tests'
		    notifying:nil
		    install:true
		    skipIfSame:false
		    silent:true.
		sizes := self class perform:#'signedLongIntegerArray_size'.
		self assert:(sizes first == 8).
		self assert:(sizes second == 8).
		self class class removeSelector:#'signedLongIntegerArray_size'.
	    ].
    ] ensure:[ self class class removeSelector:#'signedLongIntegerArray_size'. ]

    "
     self run:#test02_compilation
     self new test02_compilation"
    "Created: / 04-03-2014 / 10:11:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_SignedLongIntegerArray_02
    |sizes|

    [
	Class
	    withoutUpdatingChangesDo:[
		(STCCompilerInterface new)
		    compileToMachineCode:'signedLongIntegerArray_i_element
		    | arr v1 v8 |

		    arr := SignedLongIntegerArray new: 8.
		    arr at: 1 put: 1123456789.
		    arr at: 8 put: 1123456789.

%{
		    __int64__ val;
		    val =  __SignedLongIntegerArrayInstPtr(arr)->i_element[0];
		    v1 = __MKINT64(&val);
		    val =  __SignedLongIntegerArrayInstPtr(arr)->i_element[7];
		    v8 = __MKINT64(&val);

%}.
		    ^ Array with: v1 with: v8.
   '
		    forClass:self class class
		    selector:#'signedLongIntegerArray_i_element'
		    inCategory:'tests'
		    notifying:nil
		    install:true
		    skipIfSame:false
		    silent:true.
		sizes := self class perform:#'signedLongIntegerArray_i_element'.
		self assert:(sizes first = 1123456789).
		self assert:(sizes second = 1123456789).
		self class class removeSelector:#'signedLongIntegerArray_i_element'.
	    ].
    ] ensure:[ self class class removeSelector:#'signedLongIntegerArray_i_element'. ]

    "
     self run:#test02_compilation
     self new test02_compilation"
    "Created: / 04-03-2014 / 10:13:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!STCCompilerTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

