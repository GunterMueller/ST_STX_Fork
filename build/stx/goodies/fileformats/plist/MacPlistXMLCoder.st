"
 COPYRIGHT (c) 2015 by Claus Gittinger 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/fileformats/plist' }"

"{ NameSpace: Smalltalk }"

XMLCoder subclass:#MacPlistXMLCoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!MacPlistXMLCoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 by Claus Gittinger 
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
    A common XML file format representation on Mac OSX.
    On OSX, this is used to store user preferences, settings and application histories.
    It is also used to provide additional attributes for applications (such as type of
    document, icons etc.)

    This is a very limited encoding, which:
    - only supports a small number of objects (array, dictionaries, strings and numbers
    - does not support recursive or cyclic references
    - does not even support shared references.
    - stores all sequenceableCollection types as Array (tag: array)
    - stores all dictionary types as Dictionary (tag: dict)
    - stores all string types (incl. Symbols) as String (tag: string)
    - stores all non-integer numeric types as Float (tag: real)

    Thus, be careful when restoring; all of the above are restored as those base types.
    
    [author:]
        Claus Gittinger

    [see also:]
        XMLStandardCoder

    [instance variables:]

    [class variables:]
"
!

examples
"
   save a settings dictionary:
                                                                [exBegin]
     |d|

     d := Dictionary new
        at:'$archiver' put:'NSKeyedArchiver';
        at:'$objects' put:{
            'null' .
            (Dictionary new
                at:'$class' put:(Dictionary new
                                at:'CF$UID' put:16;
                                yourself);
                at:'bForce' put:false;
                at:'bTrunc' put:true;
                at:'runMode' put:0;
                at:'str' put:'<hello>';
                at:'NS.time' put:450351871.9149;
                at:'classes' put:#( 'NSDate' #'NSObject' );
                yourself) 
            };
        yourself.
     MacPlistXMLCoder encode:d on:Transcript.
     Transcript cr; cr; nextPutLine:'-----------------------'; cr.
     (MacPlistXMLCoder new prettyPrint:true) encode:d on:Transcript
                                                                [exEnd]

   save and restore:
                                                                [exBegin]
     |d xmlText decodedObject|

     d := Dictionary new
        at:'$archiver' put:'NSKeyedArchiver';
        at:'$objects' put:{
            'null' .
            (Dictionary new
                at:'$class' put:(Dictionary new
                                at:'CF$UID' put:16;
                                yourself);
                at:'bForce' put:false;
                at:'bTrunc' put:true;
                at:'runMode' put:0;
                at:'NS.time' put:450351871.9149;
                at:'classes' put:#( 'NSDate' 'NSObject' );
                yourself)};
        yourself.
     xmlText := MacPlistXMLCoder encodingOf:d .
     Transcript showCR:xmlText.

     decodedObject := (MacPlistXMLDecoder on:(xmlText readStream)) decodedObject.
     decodedObject inspect.
     self assert:(d = decodedObject).
                                                                [exEnd]

"
! !

!MacPlistXMLCoder methodsFor:'blocked queries'!

possiblyReferenced:anObject
    "never - I do not allow sharing"

    ^ false
! !

!MacPlistXMLCoder methodsFor:'visiting'!

unsupportedObjectType:anObject
    "PList format only allows a very limited set of classes (similar to JSON)"

    self error:'unsupported object class: ',anObject class name.
!

visitBoolean:aBool with:nameOrIndex
    "xml encode a boolean as <false/> or <true/>"

    self 
        putObject:aBool 
        element:(aBool ifTrue:['true'] ifFalse:['false'])
        name:nil 
        class:nil value:nil.

    "
     self encodingOf:true
     self encodingOf:false
    "
!

visitByteArray:aByteArray with:nameOrIndex
    self unsupportedObjectType:aByteArray
!

visitCharacter:aCharacter with:nameOrIndex
    self unsupportedObjectType:aCharacter
!

visitCollection:aCollection with:nameOrIndex
    self unsupportedObjectType:aCollection
!

visitDictionary:aCollection with:nameOrIndex
    "encode a dictionary as: <dict><key>..</key><...object>...</dict>."

    |valueBlock|

    valueBlock := 
        aCollection isEmpty 
            ifTrue:[nil]
            ifFalse:[
                [ |oldLevel|
                    oldLevel := level.
                    level := level + 1.
                    stream cr. 
                    aCollection keysAndValuesDo:[:k :v| 
                        (k isSymbol or:[k isString]) ifFalse:[
                            self unsupportedObjectType:k
                        ].
                        self 
                            putObject:k 
                            element:'key' 
                            name:nil class:nil
                            value:(k isEmpty ifTrue:[nil] ifFalse:[[self quoteString:k]]).
                    
                        stream cr. 
                        v acceptVisitor:self with:nil. 
                        stream cr.
                    ].
                    level := oldLevel.
                    self indent.
                ]                    
            ].

    self 
        putObject:aCollection 
        element:'dict' 
        name:nil class:nil
        value:valueBlock.

    "
     self encodingOf:Dictionary new 
     self encodingOf:(Dictionary new at:#key1 put:1; at:#key2 put:true; yourself) 
    "
!

visitFloat:aFloat with:nameOrIndex
    "xml encode a float as <real>nnnn<real/>"

    self 
        putObject:aFloat 
        element:'real'
        name:nil class:nil 
        value:[aFloat printOn:stream].

    "
     self encodingOf:123.456
     self encodingOf:123.0
    "
!

visitInteger:anInteger with:nameOrIndex
    "xml encode a boolean as <integer>iii<integer/>"

    self 
        putObject:anInteger 
        element:'integer'
        name:nil class:nil 
        value:[anInteger printOn:stream].

    "
     self encodingOf:123
    "
!

visitNilWith:nameOrIndex
    self unsupportedObjectType:nameOrIndex
!

visitObject:anObject with:nameOrIndex
    self unsupportedObjectType:anObject
!

visitSequenceableCollection:aCollection with:nameOrIndex
    "encode a seq. collection as: <array><...object>...</array>."

    |valueBlock|

    valueBlock := 
        aCollection isEmpty 
            ifTrue:[nil]
            ifFalse:[
                [ |oldLevel|
                    oldLevel := level.
                    level := level + 1.
                    stream cr. 
                    aCollection do:[:v| 
                        v acceptVisitor:self with:nil. 
                        stream cr.
                    ].
                    level := oldLevel.
                    self indent.
                ]                    
            ].

    self 
        putObject:aCollection 
        element:'array' 
        name:nil class:nil
        value:valueBlock.

    "
     self encodingOf:Array new 
     self encodingOf:#(1 2.5 true false 'hello' 'world')
    "
!

visitString:aString with:nameOrIndex
    "xml encode a string as <string>sss<string/>.
     Symbols will also be handled here, but always decoded as Strings"

    self 
        putObject:aString 
        element:'string'
        name:nil class:nil 
        value:(aString isEmpty ifTrue:[nil] ifFalse:[[self quoteString:aString]]).

    "
     self encodingOf:'hello world'
     self encodingOf:#'hello'
    "
! !

!MacPlistXMLCoder methodsFor:'xml output'!

endEncoding
    "redefined to create a file trailer"

    self putXmlTrailer
!

putXmlHeader
    "write an xml standard header"

    super putXmlHeader.
    stream cr.
    stream nextPutLine:'<!!DOCTYPE plist PUBLIC "-//Apple//DTP PLIST 1.0//EN" "http//www.apple.com/DTDs/ProperyList-1.0.dtd">'.
    stream nextPutLine:'<plist version="1.0">'.
!

putXmlTrailer
    "append a cosing plist element"

    stream cr.
    stream nextPutLine:'</plist>'.
!

startEncoding
    "redefined to create a file header"

    self putXmlHeader
! !

!MacPlistXMLCoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacPlistXMLCoder.st,v 1.1 2018-05-03 23:27:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacPlistXMLCoder.st,v 1.1 2018-05-03 23:27:58 cg Exp $'
! !

