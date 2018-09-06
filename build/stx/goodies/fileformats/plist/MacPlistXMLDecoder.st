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

XML::FastSAXDriver subclass:#MacPlistXMLDecoder
	instanceVariableNames:'object stack characterStream needWhitespace storeAction'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-FileFormats'
!

!MacPlistXMLDecoder class methodsFor:'documentation'!

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
    - restores all sequenceableCollection types as Array (tag: array)
    - restores all dictionary types as Dictionary (tag: dict)
    - restores all string types (incl. Symbols) as String (tag: string)
    - restores all non-integer numeric types as Float (tag: real)

    Thus, be careful when restoring; all of the above are restored as those base types.

    [author:]
        Claus Gittinger

    [see also:]
        XMLStandardDeCoder

    [instance variables:]

    [class variables:]
"
!

examples
"
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

                                                                [exBegin]
     ((MacPlistXMLDecoder on:('~/test.plist' asFilename readStream)) decodedObject) inspect.
                                                                [exEnd]
"
! !

!MacPlistXMLDecoder methodsFor:'accessing'!

decodedObject
    self assert:(stack isEmpty).
    ^ object.
! !

!MacPlistXMLDecoder methodsFor:'content handler'!

characters:chars
    "someone interested in those characters?"

    characterStream notNil ifTrue:[
        characterStream nextPutAll:chars.
        ^ self
    ].
!

endElement:tag namespace:alwaysNil1 prefix:alwaysNil2 
    "/ hard coded tag handling here...

    tag = 'key' ifTrue:[
        "/ I can only be inside a dict..
        stack removeLast.
        stack addLast:(characterStream contents).
        ^ self.
    ].

    tag = 'string' ifTrue:[
        storeAction value:(characterStream contents).
        ^ self.
    ].
    tag = 'true' ifTrue:[
        storeAction value:true.
        ^ self.
    ].
    tag = 'false' ifTrue:[
        storeAction value:false.
        ^ self.
    ].
    tag = 'integer' ifTrue:[
        storeAction value:(Integer readFrom:characterStream contents).
        ^ self.
    ].
    tag = 'real' ifTrue:[
        storeAction value:(Number readFrom:characterStream contents).
        ^ self.
    ].

    tag = 'array' ifTrue:[
        |coll|

        coll := object.
        object := stack removeLast.
        storeAction := stack removeLast.
        storeAction value:(coll asArray).
        ^ self.
    ].

    tag = 'dict' ifTrue:[
        |dict|

        dict := object.
        stack removeLast. "/ nil slot
        object := stack removeLast.
        storeAction := stack removeLast.
        storeAction value:dict.
        ^ self.
    ].

    tag = 'plist' ifTrue:[
        ^ self.
    ].

    self halt.
!

on:aStream beforeScanDo:aOneArgBlock
    stack := OrderedCollection new.
    super on:aStream beforeScanDo:aOneArgBlock
!

startElement:tag namespace:alwaysNil1 prefix:alwaysNil2 attributes:attsOrNil
    "/ hard coded tag handling here...

    tag = 'plist' ifTrue:[
        "/ ignore - wait for top-level dict
        storeAction := [:val | object := val ].
        ^ self.
    ].

    tag = 'dict' ifTrue:[
        stack addLast:storeAction.
        stack addLast:object.
        stack addLast:nil.     "/ will be the key
        object := Dictionary new.
        storeAction := [:val | 
                            |k| 
                            k := stack removeLast.
                            object at:k put:val.
                            stack addLast:nil.     "/ will be next key
                       ].

        ^ self.
    ].
    tag = 'key' ifTrue:[
        "/ only allowed in dictionary
        characterStream := CharacterWriteStream on:(String new:10).
        ^ self.
    ].
    tag = 'array' ifTrue:[
        stack addLast:storeAction.
        stack addLast:object.
        object := OrderedCollection new.
        storeAction := [:val | object add:val ].
        ^ self.
    ].
    tag = 'string' ifTrue:[
        characterStream := CharacterWriteStream on:(String new:10).
        ^ self.
    ].
    tag = 'integer' ifTrue:[
        characterStream := WriteStream on:(String new:10).
        ^ self.
    ].
    tag = 'real' ifTrue:[
        characterStream := WriteStream on:(String new:10).
        ^ self.
    ].
    tag = 'true' ifTrue:[
        ^ self.
    ].
    tag = 'false' ifTrue:[
        ^ self.
    ].
    self halt.
! !

!MacPlistXMLDecoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacPlistXMLDecoder.st,v 1.1 2018-05-03 23:28:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/fileformats/plist/MacPlistXMLDecoder.st,v 1.1 2018-05-03 23:28:43 cg Exp $'
! !

