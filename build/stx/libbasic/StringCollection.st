"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

OrderedCollection subclass:#StringCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!StringCollection class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
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
    StringCollection is a variable sized array of lines which are strings.
    WARNING:
        This class is temporary (a historic leftover) - it may change or
        even vanish in the future. Use OrderedCollections or other standard
        classes to represent collections of strings.

    StringCollection used to be called Text, but this is a very bad name
     - there is something totally different also named Text in ST-80 ...

    [author:]
        Claus Gittinger
"
! !

!StringCollection class methodsFor:'instance creation'!

from:aString
    <resource: #obsolete>
    "return a new text object with lines taken from the argument, aString"

    self obsoleteMethodWarning:'use #fromString:'.
    ^ self fromString:aString.
!

fromArray:anArray
    "return a new text object with lines taken from the argument, an array
     of strings"

    |newStringCollection
     size "{ Class: SmallInteger }" |

    size := anArray size.
    newStringCollection := self new:size.
    1 to:size do:[:line |
	newStringCollection at:line put:(anArray at:line)
    ].
    ^ newStringCollection
!

fromString:aString
    "return a new text object with lines taken from the argument, aString"

    ^ (self new:1) fromString:aString

    "Modified: / 25-07-2012 / 18:52:47 / cg"
!

new:size
    "return a new string collection with size empty lines"

    ^ (super new:size) grow:size

    "   
     StringCollection new:10
    "
!

newWithSize:size
    "return a new string collection with size empty lines"

    ^ self new:size "/ already does what we want
! !

!StringCollection methodsFor:'converting'!

asString
    "return myself as a string with embedded cr's"

    ^ self 
        asStringWith:Character cr
        from:1 to:(self size) 
        compressTabs:false 
        final:Character cr
!

asStringCollection
    "return the receiver as a stringCollection - that's easy"

    ^ self

    "Modified (comment): / 25-07-2012 / 18:11:14 / cg"
!

asStringWithoutEmphasis
    "return myself as a string with embedded cr's, but drop any emphasis"

    ^ self 
        asStringWith:Character cr
        from:1 to:(self size) 
        compressTabs:false 
        final:Character cr
        withEmphasis:false

    "Created: / 17.6.1998 / 12:32:48 / cg"
!

asStringWithoutFinalCR
    "return myself as a string with embedded cr's
     but do not add a final CR"

    ^ self 
        asStringWith:Character cr
        from:1 to:(self size) 
        compressTabs:false 
        final:nil
!

encodeFrom:oldEncoding into:newEncoding
    "encode each line"

    |enc|

    enc := CharacterEncoder encoderToEncodeFrom:oldEncoding into:newEncoding.
    ^ self 
        collect:[:line |
            line isNil 
                ifTrue:[ nil ]
                ifFalse:[ enc encodeString:line]
        ]

    "Modified (comment): / 25-07-2012 / 18:09:40 / cg"
!

from:aString
    "setup my contents from the argument, aString"

    <resource: #obsolete>

    self obsoleteMethodWarning:'use #fromString:'.
    ^ self fromString:aString

    "Modified (format): / 25-07-2012 / 18:02:34 / cg"
!

fromString:aString
    "setup my contents from the argument, aString.
     AString should be delimited by newline characters"

    |numberOfLines "{ Class:SmallInteger }"
     start         "{ Class:SmallInteger }"
     stop          "{ Class:SmallInteger }"
     delimiter
    |

    aString isEmpty ifTrue:[self grow:0. ^ self ].

    delimiter := Character cr.

    numberOfLines := aString occurrencesOf:delimiter.
    numberOfLines == 0 ifTrue:[
        "/ check if its a return-delimited string
        (aString occurrencesOf:(Character return)) > 0 ifTrue:[
            delimiter := Character return.
        ].
    ].
    aString last == delimiter ifFalse:[
        numberOfLines := numberOfLines + 1.
    ].

    self grow:numberOfLines.

    start := 1.
    1 to:numberOfLines do:[:lineNr |
        stop := aString indexOf:delimiter startingAt:start.
        stop == 0 ifTrue:[
            self at:lineNr put:(aString copyFrom:start).
            self from:lineNr+1 to:numberOfLines put:''.
            ^ self.
        ].

        self at:lineNr put:(aString copyFrom:start to:stop-1).
        start := stop + 1
    ]

    "Modified: / 25-07-2012 / 18:52:58 / cg"
! !

!StringCollection methodsFor:'copying'!

copyEmpty:size
    "we have to redefine this, since 'self class new:size' 
     does allocate size nil lines (it does an implicit #grow: size).
     In order to get #collect: working, we should not perform this implicit grow"

    ^ super copyEmpty:0.

    "Created: 14.2.1996 / 11:05:47 / stefan"
!

copyEmptyAndGrow:size
    "performance optimization: 
     StringCollections are always grown to size after #new: / #copyEmpty:"

    ^ super copyEmpty:size.
!

withoutLeadingAndTrailingBlankLines
    "return a copy of the receiver with leading and trailing blank lines removed.
     If there are no trailing blank lines, the original receiver is returned.
     If all lines are blank, an empty string collection is returned."

    ^ self withoutLeadingBlankLines withoutTrailingBlankLines.

    "
'1
2
3' asStringCollection withoutLeadingAndTrailingBlankLines      
    "

    "
'

2
3

' asStringCollection withoutLeadingAndTrailingBlankLines       
    "
!

withoutLeadingBlankLines
    "return a copy of the receiver with leading blank lines removed.
     If there are no leading blank lines, the original receiver is returned.
     If all lines are blank, an empty string collection is returned."

    |indexOfFirstNonBlankLine|

    indexOfFirstNonBlankLine := self findFirst:[:line | line notEmptyOrNil and:[line isBlank not]].
    indexOfFirstNonBlankLine == 0 ifTrue:[ ^ self copyEmpty ].
    indexOfFirstNonBlankLine == 1 ifTrue:[ ^ self ].
    ^ self copyFrom:indexOfFirstNonBlankLine

    "
'1
2
3' asStringCollection withoutLeadingBlankLines     
    "

    "
'
2
3' asStringCollection withoutLeadingBlankLines       
    "

    "
'

' asStringCollection withoutLeadingBlankLines      
    "
!

withoutTrailingBlankLines
    "return a copy of the receiver with trailing blank lines removed.
     If there are no trailing blank lines, the original receiver is returned.
     If all lines are blank, an empty string collection is returned."

    |indexOfLastNonBlankLine|

    indexOfLastNonBlankLine := self findLast:[:line | line notEmptyOrNil and:[line isBlank not]].
    indexOfLastNonBlankLine == 0 ifTrue:[ ^ self copyEmpty ].
    indexOfLastNonBlankLine == self size ifTrue:[ ^ self ].
    ^ self copyTo:indexOfLastNonBlankLine

    "
'1
2
3' asStringCollection withoutTrailingBlankLines      
    "

    "
'
2
3
' asStringCollection withoutTrailingBlankLines       
    "

    "
'
2
3


' asStringCollection withoutTrailingBlankLines       
    "
    "
'

' asStringCollection withoutTrailingBlankLines      
    "
! !


!StringCollection methodsFor:'printing & storing'!

printOn:aStream
    "print myself on aStream with embedded cr's"

    self do:[:eachString|
        eachString printOn:aStream.
        aStream cr.
    ].
!

printString
    "return the receiver's printString"

    ^ self asString
! !

!StringCollection methodsFor:'queries'!

encoding
    "the encoding; ask my first line"

    self do:[:l | l notNil ifTrue:[^ l encoding]].
    "/ sigh
    ^ #unicode

    "Modified (comment): / 25-07-2012 / 18:09:15 / cg"
!

stringSize
    "the size of the string if I was converted"

    ^ self inject:0 into:[:sizeSoFar :eachLine | 
            sizeSoFar + eachLine size + 1
        ]

    "Modified (comment): / 25-07-2012 / 18:02:19 / cg"
! !

!StringCollection methodsFor:'searching'!

indexOfLineStartingWith:aString
    "return the index of the first line starting with the argument, aString"

    ^ self findFirst:[:l | l notNil and:[l startsWith:aString]] ifNone:0.

"/    |sz    "{ Class:SmallInteger }"      
"/     l|
"/
"/    sz := self size.
"/    1 to:sz do:[:index |
"/        l := self at:index.
"/        (l notNil and:[l startsWith:aString]) ifTrue:[
"/            ^ index
"/        ].
"/    ].
"/    ^ 0

    "Modified: 24.2.1996 / 19:08:47 / cg"
! !

!StringCollection methodsFor:'special converting'!

decodeFrom: encodingSymbol
    "given the receiver encoded as described by encodingSymbol,
     convert it into internal ST/X (unicode) encoding and return a 
     corresponding StringCollection."

    |myEncoding encoder|

    encodingSymbol isNil ifTrue:[^ self].

    encoder := CharacterEncoder encoderToEncodeFrom:#unicode into:encodingSymbol.
    encoder isNil ifTrue:[^ self].

    ^ self 
        collect:[:eachLineOrNil | 
            eachLineOrNil isNil ifTrue:[
                eachLineOrNil
            ] ifFalse:[
                encoder decodeString: eachLineOrNil
            ]
        ]

    "Created: / 12-07-2012 / 14:30:25 / cg"
!

withTabs
    "return a new stringCollection consisting of the receiver's lines,
     where leading spaces are replaced by tabulator characters (assuming 8-col tabs).
     Notice: lines which do not contain leading spaces, are copied by reference to the
             new stringCollection (i.e. shared);
             otherwise new strings is created.
     Limitation: only the very first spaces are replaced"

    ^ self collect:[:string|
        string notNil ifTrue:[
            string withTabs     
        ] ifFalse:[
            string
        ]
    ]

    "
       ('        abcd            ') asStringCollection withTabs
    "

    "Created: 4.3.1996 / 17:09:07 / cg"
    "Modified: 4.3.1996 / 17:10:37 / cg"
!

withTabsExpanded
    "return a new stringCollection consisting of the receiver's lines,
     where tabs are replaced by space characters (assuming 8-col tabs).
     Notice: lines which do not contain any tab, are copied by reference to the
             new stringCollection (i.e. shared);
             otherwise new strings is created."

    ^ self withTabsExpanded:8

    "
       |tab|
       tab := String with:Character tab.
       ('abcd', tab, 'tef', tab, 'tgh') asStringCollection withTabsExpanded
    "

    "Created: 12.2.1996 / 22:25:56 / stefan"
    "Modified: 14.2.1996 / 11:13:01 / stefan"
    "Modified: 4.3.1996 / 17:10:22 / cg"
!

withTabsExpanded:n
    "return a new stringCollection consisting of the receiver's lines,
     where tabs are replaced by space characters (assuming n-col tabs).
     Notice: lines which do not contain any tab, are copied by reference to the
             new stringCollection (i.e. shared);
             otherwise new strings is created."

    ^ self collect:[:string|
        string notNil ifTrue:[
            string withTabsExpanded:n     
        ] ifFalse:[
            string
        ]
    ]

    "
       |tab|
       tab := String with:Character tab.
       ('abcd', tab, 'tef', tab, 'tgh') asStringCollection withTabsExpanded
    "

    "Created: 12.2.1996 / 22:25:56 / stefan"
    "Modified: 14.2.1996 / 11:13:01 / stefan"
    "Modified: 4.3.1996 / 17:10:22 / cg"
! !

!StringCollection methodsFor:'testing'!

isStringCollection
    "return true, if the receiver is some kind of stringCollection;
     true is returned here - the method is redefined from Object."

    ^ true


! !

!StringCollection class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

