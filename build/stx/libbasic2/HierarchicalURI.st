"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

URI subclass:#HierarchicalURI
	instanceVariableNames:'authority isAbsolute isDirectory pathSegments query fragment'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Resources'
!

!HierarchicalURI class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    Hierarchical URI as defined in RFC2396:

    <scheme:[//authority][/absolute_path][?query][#fragment]>

    [author:]
        Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    |u1 u2|

    u1 := URI fromString:'file:/phys/exept/tmp/'.
    u2 := u1 construct:'test.txt'.
    Transcript showCR:u1.
    Transcript showCR:u2.
                                                                [exEnd]

                                                                [exBegin]
    |u1 u2|

    u1 := URI fromString:'file:/phys/exept/tmp'.
    u2 := u1 construct:'test.txt'.
    Transcript showCR:u1.
    Transcript showCR:u2.
                                                                [exEnd]
"
! !

!HierarchicalURI class methodsFor:'instance creation'!

new

    ^ self basicNew initialize
!

scheme:aSchemeString fromString:aString
    "parse the hierarchical information.
     schemeString is ignored here"

    ^ self new scheme:aSchemeString; 
               fromString:aString
! !

!HierarchicalURI methodsFor:'accessing'!

authority
    "return the value of the instance variable 'authority' (automatically generated)"

    ^ authority
!

authority:something
    "set the value of the instance variable 'authority' (automatically generated)"

    authority := something.
!

baseName
    ^ pathSegments last

    "
     (URI fromString:'file:/phys/exept/tmp/foo.html') baseName. 
     (URI fromString:'file:/phys/exept/tmp/foo') baseName.      
     (URI fromString:'file:/phys/exept/tmp/') baseName.         
     (URI fromString:'file:/phys/') baseName.         
     (URI fromString:'file:/phys') baseName.         

     (URI fromString:'file://phys/exept/tmp/foo.html') baseName. 
     (URI fromString:'file://phys/exept/tmp/foo') baseName.      
     (URI fromString:'file://phys/exept/tmp/') baseName.         
     (URI fromString:'file://phys/exept/tmp') baseName.         
     (URI fromString:'file://phys/exept/') baseName.         
     (URI fromString:'file://phys/exept') baseName.         
     (URI fromString:'file://phys/') baseName.         
     (URI fromString:'file://phys') baseName.         
     (URI fromString:'file://') baseName.
    "
!

examples
"

  more examples to be added:
                                                                [exBegin]
        URI fromString:'file:/phys/exept/home/tm/tmp'
                                                                [exEnd]
"
!

fragment
    "return the value of the instance variable 'fragment' (automatically generated)"

    ^ fragment
!

fragment:something
    "set the value of the instance variable 'fragment' (automatically generated)"

    fragment := something.
!

isAbsolute
    "return the value of the instance variable 'isAbsolute' (automatically generated)"

    ^ isAbsolute
!

isDirectory
    "return the value of the instance variable 'isDirectory' (automatically generated)"

    ^ isDirectory ? false
!

pathSegments
    "return the value of the instance variable 'pathSegments' (automatically generated)"

    ^ pathSegments
!

pathSegments:something
    "set the value of the instance variable 'pathSegments' (automatically generated)"

    pathSegments := something.
!

query
    "return the value of the instance variable 'query' (automatically generated)"

    ^ query
!

query:something
    "set the value of the instance variable 'query' (automatically generated)"

    query := something.
! !

!HierarchicalURI methodsFor:'accessing-details'!

host
    "answer the host part of authority"

    |start end|

    authority isNil ifTrue:[
        ^ nil
    ].
    start := (authority indexOf:$@) + 1.
    end := (authority indexOf:$: startingAt:start) - 1.
    end == -1 ifTrue:[
        end := authority size
    ].
    ^ authority copyFrom:start to:end

    "
      (self fromString:'ftp://stefan@www.exept.de:80/test') host
      (self fromString:'ftp://www.exept.de:80/test') host
      (self fromString:'ftp://www.exept.de/test') host
    "
!

password
    "answer the user part of authority"

    |end start|

    authority isNil ifTrue:[
        ^ nil
    ].
    end := authority indexOf:$@.
    end == 0 ifTrue:[
        ^ nil
    ].
    start := authority indexOf:$:.
    (start == 0 or:[start > end]) ifTrue:[
        ^ nil
    ].
    ^ authority copyFrom:start+1 to:end-1

    "
      (self fromString:'ftp://stefan@www.exept.de:80/test') password
      (self fromString:'ftp://stefan:pass@www.exept.de:80/test') password
      (self fromString:'ftp://www.exept.de:80/test') password
    "
!

port
    "answer the port part of authority"

    |start|

    authority isNil ifTrue:[
        ^ self defaultPort
    ].
    start := authority indexOf:$@ ifAbsent:1.
    start := authority indexOf:$: startingAt:start.

    start == 0 ifTrue:[
        ^ self defaultPort
    ].

    ^ authority copyFrom:start+1

    "
      (self fromString:'ftp://stefan@www.exept.de:80/test') port    
      (self fromString:'ftp://www.exept.de:80/test') port       
      (self fromString:'ftp://www.exept.de/test') port          
    "
!

user
    "answer the user part of authority"

    |end end1|

    authority isNil ifTrue:[
        ^ nil
    ].
    end := authority indexOf:$@.
    end == 0 ifTrue:[
        ^ nil
    ].
    end1 := authority indexOf:$:.
    end1 ~~ 0 ifTrue:[
        end := end min:end1.
    ].
    ^ authority copyTo:end-1

    "
      (self fromString:'ftp://stefan@www.exept.de:80/test') user
      (self fromString:'ftp://stefan:pass@www.exept.de:80/test') user
      (self fromString:'ftp://www.exept.de:80/test') user
    "
! !

!HierarchicalURI methodsFor:'comparing'!

= anHierarchicalUri

    ^ self class == anHierarchicalUri class 
      and:[self scheme = anHierarchicalUri scheme
      and:[pathSegments = anHierarchicalUri pathSegments
      and:[authority = anHierarchicalUri authority
      and:[self isAbsolute = anHierarchicalUri isAbsolute
      and:[self isDirectory = anHierarchicalUri isDirectory
      and:[query = anHierarchicalUri query
      and:[fragment = anHierarchicalUri fragment]]]]]]]
!

hash

    ^ pathSegments hash bitXor:query hash

    "Modified: / 20-01-2017 / 19:49:30 / stefan"
! !

!HierarchicalURI methodsFor:'copying'!

postCopy

    pathSegments := pathSegments copy
! !

!HierarchicalURI methodsFor:'defaults'!

defaultPort
   "answer the default port for the given scheme.
    Concrete subclasses redefine this method"

   ^ nil
! !

!HierarchicalURI methodsFor:'escape'!

unEscape
    "convert escaped characters (such as %20 for ' ') to their native
     representation"

    authority := self class unEscape:authority readStream.
    pathSegments keysAndValuesDo:[:i :v|
        pathSegments at:i put:(self class unEscape:v readStream).
    ].
    query := self class unEscape:query readStream.
    fragment := self class unEscape:fragment readStream.
! !

!HierarchicalURI methodsFor:'initialization'!

fromString:aString
    |i i1 separator|

    (aString startsWith:'//') ifTrue:[
        i := aString indexOfAny:'/?#' startingAt:3.
        i == 0 ifTrue:[
            authority := aString copyFrom:3.
            ^ self.
        ] ifFalse:[
            separator := aString at:i.
            authority := aString copyFrom:3 to:i-1.
        ].
        isAbsolute := (aString at:i) == $/.
    ] ifFalse:[
        (isAbsolute := aString startsWith:$/) ifTrue:[
            i := 1.
        ] ifFalse:[
            i := 0.
        ]
    ].

    [
        i1 := aString indexOfAny:'/?#' startingAt:i+1.
        i1 == 0 ifTrue:[ |path|
            path := aString copyFrom:i+1.
            path size ~~ 0 ifTrue:[
                pathSegments add:path.
            ] ifFalse:[
                (aString at:i) == $/ ifTrue:[
                    isDirectory := true
                ].
            ].
            ^ self.
        ] ifFalse:[
            separator := aString at:i1.
            pathSegments add:(aString copyFrom:i+1 to:i1-1).
            isAbsolute ifTrue:[
                pathSegments size == 1 ifTrue:[
                    (pathSegments first startsWith:$~) ifTrue:[
                        isAbsolute := false
                    ].
                ].
            ].
            i := i1.
        ].
    ] doWhile:[separator == $/].

    separator == $? ifTrue:[
        i1 := aString indexOf:$# startingAt:i+1.
        i1 == 0 ifTrue:[
            query := aString copyFrom:i+1.
            ^ self.
        ] ifFalse:[
            separator := aString at:i1.
            query := aString copyFrom:i+1 to:i1-1.
            i := i1.
        ].
    ].
    separator == $# ifTrue:[
        fragment := aString copyFrom:i+1.
    ].
        
    "
     self new fromString:'//exept~/tmp'  
     self new fromString:'~/tmp'        
     self new fromString:'/~/tmp'       
     self new fromString:'//authority/path1/path2/' 
     self new fromString:'//authority/path1/path2?query'
     self new fromString:'//authority/path1/path2?query#fragment'
     self new fromString:'/path1/path2?query#fragment'
     self new fromString:'/path1/path2#fragment'
     self new fromString:'path1/path2#fragment'
    "    
!

initialize

    pathSegments := OrderedCollection new.
! !

!HierarchicalURI methodsFor:'printing & storing'!

directoryPath
    "answer the directory path part of the URI"

    |aStream|

    aStream := WriteStream on:''.

    pathSegments size ~~ 0 ifTrue: [
        self isAbsolute ifTrue:[
            aStream nextPut:$/.
        ].
        pathSegments size > 1 ifTrue:[
            (pathSegments copyTo:pathSegments size-1) do:[:p|
                self class escape:p allow:'~;:@&=+",' on:aStream
            ] separatedBy:[
                aStream nextPut:$/
            ].
        ].
    ].

    ^ aStream contents
!

path
    "answer the path part of the URI"

    |aStream|

    aStream := WriteStream on:''.

    pathSegments size ~~ 0 ifTrue: [
        self isAbsolute ifTrue:[
            aStream nextPut:$/.
        ].
        pathSegments do:[:p|
            self class escape:p allow:'~;:@&=+",' on:aStream
        ] separatedBy:[
            aStream nextPut:$/
        ].
    ].
    query notNil ifTrue: [
        aStream nextPut:$?.
        self class escape:query allow:nil on:aStream
    ].
    fragment notNil ifTrue: [
        aStream nextPut:$#.
        self class escape:fragment allow:nil on:aStream
    ].

    ^ aStream contents
!

printOn:aStream

    self printOn:aStream escape:false
!

printOn:aStream escape:doEscape
    "print the URI on aStream. If doEscape is set, escape special
     characters"

    super printOn:aStream.
    aStream nextPutAll:'//'.
    authority notNil ifTrue:[
        doEscape ifTrue:[
            self class escape:authority allow:'~$,;:@&=+' on:aStream
        ] ifFalse:[
            aStream nextPutAll:authority
        ]
    ].

    self printPathOn:aStream escape:doEscape.
!

printPathOn:aStream escape:doEscape
    "print the path part"
    
    pathSegments size ~~ 0 ifTrue: [
        self isAbsolute ifTrue:[
            aStream nextPut:$/.
        ].
        pathSegments do:[:p|
            doEscape ifTrue:[
                self class escape:p allow:'~;:@&=+",' on:aStream
            ] ifFalse:[
                aStream nextPutAll:p
            ]
        ] separatedBy:[
            aStream nextPut:$/
        ].
    ].
    query notNil ifTrue: [
        aStream nextPut:$?.
        doEscape ifTrue:[
            self class escape:query allow:nil on:aStream
        ] ifFalse:[
            aStream nextPutAll:query
        ]

    ].
    fragment notNil ifTrue: [
        aStream nextPut:$#.
        doEscape ifTrue:[
            self class escape:fragment allow:nil on:aStream
        ] ifFalse:[
            aStream nextPutAll:fragment
        ]
    ].
!

publicPrintOn:aStream
    "print, but omit password information"

    |password|

    password := self password.
    password size ~~ 0 ifTrue:[
        super printOn:aStream.
        aStream 
                nextPutAll:'//';
                nextPutAll:self user;
                nextPut:$@;
                nextPutAll:self host.
        self printPathOn:aStream escape:true.
    ] ifFalse:[
        "no password, use normal printing"
        self printOn:aStream
    ].
! !

!HierarchicalURI methodsFor:'resolution'!

/ aString
    "concatenate aString to my path.
     Same as #construct:, but simpler to use"

    ^ self construct:aString.
!

addComponent:aString
    "concatenate aString to my path"

    (aString = '..' 
     and:[pathSegments size ~~ 0 
     and:[pathSegments last ~= '..']]) ifTrue:[
        pathSegments removeLast.
    ] ifFalse:[
        pathSegments add:aString
    ].
!

construct:aString
    "concatenate aString to my path"

    ^ self copy 
        addComponent:aString;
        yourself.
!

directory
    "remove the last path component"

    ^ self copy 
        removeLastComponent;
        yourself.
!

removeLastComponent
    "remove the last component"

    pathSegments size ~~ 0 ifTrue:[ 
        pathSegments last = '..' ifTrue:[
            pathSegments add:'..'.
        ] ifFalse:[
            pathSegments removeLast.
        ].
    ].
! !

!HierarchicalURI class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

