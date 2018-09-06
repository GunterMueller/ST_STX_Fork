"
 COPYRIGHT (c) 1999 by eXept Software AG 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/xml/stx' }"

"{ NameSpace: Smalltalk }"

XMLCoder subclass:#XMLStandardCoder
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-Presentation'
!

!XMLStandardCoder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG 
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
    A standard representation, which mimics the binary storage
    semantics (i.e. an object can be restored - even if self-referencing)

    Standard types are mapped to different element names.
    The className, the index or instVarName are stored as attributes.

    The same structure is used for all same-typed instances,
    and a DTD may be used to describe the output.

    [author:]
        Stefan Vogel

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"<<EOF
   save a point:
                                                                [exBegin]
     (XMLStandardCoder on:Transcript) nextPut:1 @ 2 .
                                                                [exEnd]


   save an array:
                                                                [exBegin]
     |o|

     o := Array new:3.
     o at:1 put:1 @ 2.
     o at:2 put:'hello'.
     o at:3 put:o.
     (XMLStandardCoder on:Transcript) nextPut:o .
                                                                [exEnd]

   save and restore:
                                                                [exBegin]
     |xmlText o s|

     s := '' writeStream.
     o := OrderedCollection new.
     o add:1 @ 2.
     o add:'hello'.
     o add:true.
     o add:o.
     xmlText := XMLStandardCoder encodingOf:o.
     Transcript showCR:xmlText.

     (XMLStandardDecoder on:(xmlText readStream)) next inspect
                                                                [exEnd]

   save and restore:
                                                                [exBegin]
     |xmlText p o s decodedObject|

     s := '' writeStream.
     o := Array new:5.
     o at:1 put:(p := 1 @ 2).
     o at:2 put:p.
     o at:3 put:'hello'.
     o at:4 put:p.
     o at:5 put:o.
     xmlText := XMLStandardCoder encodingOf:o.
     Transcript showCR:xmlText.

     decodedObject := (XMLStandardDecoder on:(xmlText readStream)) next.
     decodedObject inspect.
     (decodedObject at:2) == (decodedObject at:4) ifFalse:[self halt].
     (decodedObject at:2) == (decodedObject at:1) ifFalse:[self halt].
                                                                [exEnd]

   save and restore.
   Use special aspect to encode nil variables:
                                                                [exBegin]
     |xmlText o s encoder decoder decodedObject sharedString|

     s := '' writeStream.
     o := OrderedCollection new.
     o add:1 @ 2.
     o add:(sharedString := 'hello').
     o add:sharedString.
     o add:o.
     o add:(1 @ nil).
     encoder := XMLStandardCoder new aspect:#encodingVectorForInstanceVariables.
     encoder version:'1.0'.
     xmlText := encoder encodingOf:o.
     Transcript showCR:xmlText.

     decoder := XMLStandardDecoder on:xmlText readStream.
     decodedObject := decoder next.
     decodedObject inspect.
     Transcript cr; showCR:'Aspect:', decoder aspect, ' Version: ', decoder version.
     decodedObject size ~~ 5 ifTrue:[self halt].
     ((decodedObject at:2) == (decodedObject at:3)) ifFalse:[self halt].
     (decodedObject copyTo:3) = (o copyTo:3) ifFalse:[self halt].
     (decodedObject at:4) == decodedObject ifFalse:[self halt].
                                                                [exEnd]

   save and restore, and use message sends to restore:
                                                                [exBegin]
     |xmlText o s sharedString decoder decodedObject|

     s := '' writeStream.
     o := Set new.
     o add:1 @ 2.
     o add:(sharedString := 'hello').
     o add:sharedString.
     o add:o.
     xmlText := XMLStandardCoder encodingOf:o.
     Transcript showCR:xmlText.

     decoder := XMLStandardDecoder on:(xmlText readStream).
     decoder useSend:true.
     decodedObject := decoder next.
     decodedObject inspect.

     decodedObject size ~~ 3 ifTrue:[self halt].
                                                                [exEnd]

   save and restore with references:
                                                                [exBegin]
     |xmlText sharedString a o s|

     sharedString := 'hello world'.

     s := '' writeStream.
     a := Array new:2.
     a at:1 put:sharedString.

     o := OrderedCollection new.
     o add:nil.
     o add:'hello'.
     o add:sharedString.

     a at:2 put:o.
     xmlText := XMLStandardCoder encodingOf:a.
     Transcript showCR:xmlText.

     (XMLStandardDecoder on:(xmlText readStream)) next inspect
                                                                [exEnd]

                                                                [exBegin]
     |o xmlText|

     o := Array new:1.
     o at:1 put:o.
     xmlText := XMLStandardCoder encodingOf:o.
     Transcript showCR:xmlText.
                                                                [exEnd]

                                                                [exBegin]
     |o s|

    s := '
<sequence SIZE="1" ID="1">
<sequence ID="2"/>
</sequence>
'.
     (XMLStandardDecoder on:(s readStream)) next inspect

                                                                [exBegin]
                                                                [exBegin]
     |o s|

    s := '

<sequence SIZE="2" ID="1">
<sequence INDEX="1" IDREF="1"/>
</sequence>
'.
     (XMLStandardDecoder on:(s readStream)) next inspect

                                                                [exBegin]
     |o s|

    s := '
<object ASPECT="encodingVector" CLASS="Expecco::ExpeccoPreferences" ID="1">
<sequence NAME="savedHostSetupList" ID="10"/>
<sequence NAME="projectPath" IDREF="10"/>
</object>
'.
     (XMLStandardDecoder on:(s readStream)) next inspect
                                                                [exEnd]

EOF
! !

!XMLStandardCoder class methodsFor:'encoding / decoding'!

decode:aStringOrStream
    "redefined to make the protocol more horizontal"
    
    ^ (XMLStandardDecoder on:(aStringOrStream readStream)) next

    "Created: / 06-02-2017 / 09:54:21 / cg"
!

encodingOf:anObject aspect:aspect with:aParameter
    "return the encoding of anObject"

    ^ self new 
        aspect:aspect;
        encodingOf:anObject with:aParameter
! !

!XMLStandardCoder methodsFor:'visiting'!

visitBoolean:aBool with:nameOrIndex
    "xml encode a boolean"

    self putObject:aBool element:aBool printString name:nameOrIndex class:nil value:nil.

    "
      self encodingOf:true
      self encodingOf:true with:'test'
      self encodingOf:true with:11
    "
!

visitByteArray:bytes with:nameOrIndex
    "encode a byte array.
     BASE64 coding is used"

    |valueBlock classNameOrNil|

"/ Later, code to decode empty class name as ByteArray 
"/ has been added to XMLStandardCoder as of 2013-04-11
"/    aCollection class == ByteArray ifTrue:[
"/        classNameOrNil := nil    
"/    ] ifFalse:[
        classNameOrNil := bytes class name.
"/    ].

    valueBlock := bytes isEmpty 
                    ifTrue:[nil]
                    ifFalse:[
                        [ |oldLevel needIndex|
                            stream cr.
                            (Base64Coder on:stream) nextPutAll:bytes; flush.
                            stream cr.
                            self indent.
                        ]
                    ].

    self putObject:bytes element:'bytes' name:nameOrIndex class:classNameOrNil
             value:valueBlock.

    "
     self encodingOf:#[]
     self encodingOf:#[1 2 3 4 5 6 7]
     self encodingOf:UUID genUUID
    "
!

visitCharacter:aCharacter with:nameOrIndex
    "encode a character.
     The characters codePoint value is used"

    self putObject:aCharacter element:'char' name:nameOrIndex class:nil
             value:[aCharacter codePoint printOn:stream].

    "
      self encodingOf:$A
      self encodingOf:$B with:'test'
      self encodingOf:$C with:11
      self encodingOf:(Character value:16raffe)
    "

    "Modified: / 03-11-2007 / 11:17:32 / cg"
    "Modified (comment): / 15-01-2018 / 08:29:28 / mawalch"
!

visitCollection:aCollection with:nameOrIndex
   "encode a collection of objects"

    |classNameOrNil valueBlock|

    aCollection class == Set ifTrue:[
        classNameOrNil := nil    
    ] ifFalse:[
        classNameOrNil := aCollection class name.
    ].

    valueBlock := aCollection isEmpty 
                    ifTrue:[nil]
                    ifFalse:[
                        [ |oldLevel|
                            oldLevel := level.
                            level := level + 1.
                            stream cr. 
                            aCollection do:[:element| 
                                element acceptVisitor:self with:nil. 
                                stream cr.
                            ].
                            level := oldLevel.
                            self indent.
                         ]
                    ].

    self putObject:aCollection element:'collection' name:nameOrIndex class:classNameOrNil
             value:valueBlock.

    "
     self encodingOf:Set new    
     self encodingOf:#(1 12 34 true 'abc') asSet    
     self encodingOf:(Dictionary new at:#key1 put:1; at:#key2 put:2; yourself) 
    "

    "Modified: / 03-11-2007 / 11:16:32 / cg"
!

visitDictionary:aCollection with:nameOrIndex
    "encode a dictionary.
     A collection of Associations is encoded"

    |classNameOrNil valueBlock|

    aCollection class == Dictionary ifTrue:[
        classNameOrNil := nil    
    ] ifFalse:[
        classNameOrNil := aCollection class name.
    ].

    valueBlock := aCollection isEmpty 
                    ifTrue:[nil]
                    ifFalse:[
                        [ |oldLevel|
                            oldLevel := level.
                            level := level + 1.
                            stream cr. 
                            aCollection associationsDo:[:assoc| 
                                assoc acceptVisitor:self with:nil. 
                                stream cr.
                            ].
                            level := oldLevel.
                            self indent.
                        ]                    
                    ].

    self putObject:aCollection element:'dictionary' name:nameOrIndex class:classNameOrNil
             value:valueBlock.

    "
     self encodingOf:Dictionary new 
     self encodingOf:(Dictionary new at:#key1 put:1; at:#key2 put:true; yourself) 
    "

    "Modified: / 03-11-2007 / 11:11:16 / cg"
!

visitFloat:aNumber with:nameOrIndex
    "encode a float"

    self putObject:aNumber element:'float' name:nameOrIndex 
            class:(aNumber class == Float ifTrue:[nil] ifFalse:[aNumber class name])
            value:[aNumber printOn:stream].

    "
     self encodingOf:0.123
     self encodingOf:0.123 asLongFloat
     self encodingOf:0.123 asShortFloat
    "
!

visitInteger:aNumber with:nameOrIndex
    "encode an integer"

    self putObject:aNumber element:'integer' name:nameOrIndex class:nil
             value:[aNumber printOn:stream].

    "
     self encodingOf:123
    "
!

visitInterval:anInterval with:aParameter
    "do not encode this as a sequenceable collection, but 
     encode the instance variables"

    ^ self visitObject:anInterval with:aParameter

    "Modified: / 03-11-2007 / 11:14:49 / cg"
!

visitNilWith:nameOrIndex
    "encode nil.
     Be careful, often nil is not coded, but ignored"

    self putObject:nil element:'nil' name:nameOrIndex class:nil value:nil.

    "
      self encodingOf:nil
      self encodingOf:nil with:'test'
      self encodingOf:nil with:11
    "
!

visitNumber:aNumber with:nameOrIndex
    "encode a number"

    self putObject:aNumber element:'number' name:nameOrIndex 
            class:(aNumber class == Fraction ifTrue:[nil] ifFalse:[aNumber class name])
            value:[aNumber printOn:stream].

    "
     self encodingOf:(1/3)
     self encodingOf:1.345s 
     Object readFromString:((1/3) printString)
    "
!

visitObject:anObject with:nameOrIndex
    "encode an object.
     Encode all the objects contained in anObject"


    (maxLevel notNil and:[level >= maxLevel]) ifTrue:[^ self].

    self putObject:anObject element:'object' name:nameOrIndex class:anObject class name
             value:[  |oldLevel|
                oldLevel := level.
                level := level + 1.
                stream cr. 
                self visitChildrenOf:anObject.
                level := oldLevel.
                self indent.
             ].


    "
     XMLStandardCoder encodingOf:(#key -> 'value') 
     XMLStandardCoder encodingOf:(100 @ 200) 
    "
!

visitSequenceableCollection:aCollection with:nameOrIndex
    "encode a sequenceable collection.
     Nil elements in the collection are suppressed"

    |classNameOrNil valueBlock|

    aCollection isArray ifTrue:[
        classNameOrNil := nil
    ] ifFalse:[
        classNameOrNil := aCollection class name.
    ].

    valueBlock := aCollection isEmpty
                    ifTrue:[nil]
                    ifFalse:[
                        [ |oldLevel needIndex needIndexForNext|
                            oldLevel := level.
                            level := level + 1.

                            "arrays need an index, because they do not support #add:
                             in all other cases, output index only if nil elements were suppressed"
                            needIndex := needIndexForNext := aCollection isArray.
                            "as of 2013-04-12, XMLStandardDecoder does not need an explicit INDEX
                             for Arrays. But we keep it in Order to read XML files with old implementaions"
"/                            needIndex := needIndexForNext := false.

                            stream cr.
                            aCollection keysAndValuesDo:[:index :element|
                                element notNil ifTrue:[
                                    element acceptVisitor:self with:(needIndexForNext ifTrue:[index] ifFalse:[]).
                                    stream cr.
                                    "now I have restored the position, next element does not need the index"
                                    needIndexForNext := needIndex.
                                ] ifFalse:[
                                    "need an INDEX, since a nil was suppressed"
                                    needIndexForNext := true.
                                ].
                            ].
                            level := oldLevel.
                            self indent.
                        ]
                    ].

    self putObject:aCollection element:'sequence' name:nameOrIndex class:classNameOrNil
             value:valueBlock.

    "
     self encodingOf:#()
     self encodingOf:#(1 12 34 nil 'abc')
     self encodingOf:#(1 12 34 nil 'abc' 'def') asOrderedCollection
    "

    "Modified: / 03-11-2007 / 11:14:11 / cg"
!

visitString:aString with:nameOrIndex
    self putObject:aString element:'string' name:nameOrIndex class:nil 
             value:(aString isEmpty ifTrue:[nil] ifFalse:[[self quoteString:aString]]).

    "
     self encodingOf:''
     self encodingOf:'abc'
     self encodingOf:'<abc'
     self encodingOf:'&abc'
     self encodingOf:'&abc
def'
    "
!

visitSymbol:aSymbol with:nameOrIndex
    self putObject:aSymbol element:'symbol' name:nameOrIndex class:nil
             value:[self quoteString:aSymbol].

    "
     self encodingOf:#abc
    "
! !

!XMLStandardCoder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XMLStandardCoder.st,v 1.19 2018-01-15 07:31:11 mawalch Exp $'
! !

