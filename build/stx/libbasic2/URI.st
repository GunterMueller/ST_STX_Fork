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

Object subclass:#URI
	instanceVariableNames:'scheme'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Resources'
!

!URI class methodsFor:'documentation'!

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
! !

!URI class methodsFor:'instance creation'!

fromString:aString
    "create an URI from a given String"
        
    |i scheme rest|

    i := aString indexOf:$:.
    i == 0 ifTrue:[
        (aString startsWith:$/) ifTrue:[
            scheme := #file.
            rest := aString.
        ] ifFalse:[
            self error:('Missing scheme in: %1!!' bindWith:aString).
        ].
    ] ifFalse:[
        scheme := aString copyFrom:1 to:i-1.
        rest := aString copyFrom:i+1.
    ].
    ^ (self classForScheme:scheme) scheme:scheme fromString:rest

    "
     self fromString:''
     self fromString:'file:~'
     self fromString:'ftp://exept.exept.de/~stefan/bla'
     self fromString:'cg@exept.exept.de:/cvs/bosch'
    "
!

fromString:aString onError:exceptionBlock
    "create an URI from a given String"

    |uri|

    Error handle:[:ex| 
        exceptionBlock value.
    ] do:[
        uri := self fromString:aString
    ].
    ^ uri

    "
     self fromString:'' onError:nil    
    "
! !

!URI class methodsFor:'accessing'!

attributes

    |dict|

    dict := Dictionary new.
    dict at:#MIME put:'text/plain'.
    ^ dict
!

classForScheme:aString
    "find a class for a given scheme name aString"

    |s|

    s := aString asLowercase.

    ^ self allSubclasses detect:[:cls| |schemes|
        schemes := cls schemes.
        schemes size ~~ 0 and:[schemes includes:s]
    ] ifNone:[HierarchicalURI]

"
    self classForScheme:'file'
"
!

schemes
    "answer the schemes supported by an URI-class.
     Concrete subclasses redefine this to answer an array of scheme names"

    ^ nil
!

transferBufferSize
    ^ 8 * 1024
! !

!URI class methodsFor:'escape'!

escape:aString allow:additionalCharacters on:aStream

    |val|

    aString do:[:c|
        ((c isLetterOrDigit) 
         or:[('-_.!!~*''()' includes:c) 
         or:[additionalCharacters notNil 
             and:[additionalCharacters includes:c]]]
        ) ifTrue:[
            aStream nextPut:c
        ] ifFalse:[
            val := c codePoint.            
            aStream nextPut:$%; 
                    nextPut:(Character digitValue:val//16);
                    nextPut:(Character digitValue:val\\16).
        ].
    ].
        

    "
     self escape:'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
          allow:nil on:TextCollector open

     self escape:'Ein text mit blanks und @ & #' 
          allow:nil on:TextCollector open
    "  
!

unEscape:aStream
    "convert escape sequences to the original characters"

    |s c1 c2|

    s := WriteStream on:''.

    [aStream atEnd] whileFalse:[
        c1 := aStream next.
        c1 == $% ifTrue:[
            c1 := aStream next.
            c1 isNil ifTrue:[
                self error:'escape sequence incomplete'
            ].
            c2 := aStream next.
            c2 isNil ifTrue:[
                self error:'escape sequence incomplete'
            ].
            c1 := c1 digitValue.
            c2 := c2 digitValue.
            (c1 > 15 or:[c2 > 15]) ifTrue:[
                self error:'escape sequence: expect hex digit'
            ].
            c1 := Character value:c1*16 + c2.
        ].
        s nextPut:c1.
    ].

    ^ s contents.

    "
     self unEscape:(self escape:'   &%@   ' )
    "
! !

!URI methodsFor:'accessing'!

contents
    |data|

    self readStreamDo:[:s |
        data := s contents.
        s close.
    ].
    ^  data
!

method
    "for compatibility with outdated URL class"

    ^ self scheme
!

scheme
    "return primary scheme of the class.
     Concrete subclasses may redefine this"

    |schemes|

    scheme notNil ifTrue:[
        ^ scheme
    ].

    schemes := self class schemes.
    ^ schemes size ~~ 0 ifTrue:[
        schemes at:1
    ] ifFalse:[
        nil
    ]
!

scheme:aString
    scheme := aString
! !

!URI methodsFor:'comparing'!

= anURI
    ^ self class == anURI class and:[self asString == anURI asString]
!

hash
    ^ self asString hash
! !

!URI methodsFor:'converting'!

asURI
    "return myself - I am an URI"

    ^ self
! !

!URI methodsFor:'printing & storing'!

printOn:aStream

    |scheme|

    scheme := self scheme.
    scheme size ~~ 0 ifTrue:[
        aStream nextPutAll:scheme; nextPut:$:
    ].
!

publicPrintOn:aStream
    "print, but omit password information.
     Subclasses which know about secret information have to redefine this"

    ^ self printOn:aStream
! !

!URI methodsFor:'subclass responsibility'!

readStreamsDo:aBlock

    "evaluate the block with a Collection of streams as first argument
     and a dictionary containing attributes as optional second argument,
     - a collection with a stream on a single file,
     - or a collection with streams on a directorie's files, but not recursive

     The streams are closed after aBlock has been evaluated.
     Attributes may be the mime type (key #MIME)"

    ^ self subclassResponsibility
! !

!URI methodsFor:'testing'!

isRemote
    "return true, if this is a remote URI"

    ^ false
! !

!URI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/URI.st,v 1.18 2014-02-12 14:40:46 cg Exp $'
! !

