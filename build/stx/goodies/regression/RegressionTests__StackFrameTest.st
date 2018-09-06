"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#StackFrameTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!


!StackFrameTest methodsFor:'tests'!

testUnlimitedStack1
    10 timesRepeat:[
	|a|

	a := Array with:('1' copy) with:('2' copy) with:('3' copy) with:('4' copy) with:('5' copy).
	self unlimitedStackTest1:a.
	true.
    ]

    "
     self run:#testUnlimitedStack1
    "
!

unlimitedStackTest1:anArray
"
[
    |a|

    a := Array with:'1' copy with:'2' copy with:'3' copy with:'4' copy with:'5' copy.
    self unlimitedStackTest1:a.
    true.
] whileTrue
"
%{  /* UNLIMITEDSTACK */

    OBJ __returnArray;
    OBJ __symbol;
    OBJ __returnCode;

    if (!__isString(__ArrayInstPtr(anArray)->a_element[0])) {
	printf("OOPS\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[1])) {
	printf("OOPS\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[2])) {
	printf("OOPS\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[3])) {
	printf("OOPS\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[4])) {
	printf("OOPS\n");
    };
    __PROTECT__(anArray);
    __scavenge();
    __UNPROTECT__(anArray);


    if (!__isString(__ArrayInstPtr(anArray)->a_element[0])) {
	printf("OOPS2\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[1])) {
	printf("OOPS2\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[2])) {
	printf("OOPS2\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[3])) {
	printf("OOPS2\n");
    };
    if (!__isString(__ArrayInstPtr(anArray)->a_element[4])) {
	printf("OOPS2\n");
    };
%}.
! !

!StackFrameTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

