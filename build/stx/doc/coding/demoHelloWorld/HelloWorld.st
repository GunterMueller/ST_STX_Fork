"{ Package: 'stx:doc/coding/demoHelloWorld' }"

"{ NameSpace: Smalltalk }"

StandaloneStartupHeadless subclass:#HelloWorld
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-standalone'
!

!HelloWorld class methodsFor:'documentation'!

documentation
"
    this is compiled to a stand-alone, headless command line program.
    Demonstrating a minimum overhead executable.
    
    To build, go to my folder top/stx/doc/coding/demoHelloWorld,
    and type 'make'.
    
    The resulting 'hello' program can be executed there with:
        ./hello
    It will display the obligatory message on the standard output.
    
    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HelloWorld class methodsFor:'startup'!

main:argv
    "main entry; argv is the array of command arguments 
     (as array of words from space-separated command line)."

    Stdout showCR:'Hello World'.
! !

!HelloWorld class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/demoHelloWorld/HelloWorld.st,v 1.1 2016-10-11 00:06:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/doc/coding/demoHelloWorld/HelloWorld.st,v 1.1 2016-10-11 00:06:36 cg Exp $'
! !

