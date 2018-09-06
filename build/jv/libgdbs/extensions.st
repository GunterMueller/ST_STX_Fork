"{ Package: 'jv:libgdbs' }"!

!ByteArray methodsFor:'printing & storing'!

pythonOn: aStream
    "Prints Python-escaped representation on `aStream`.

     This may be useful when copu-pasting ByteArray values to
     Python code."

    self do:[:byte | 
        (byte between: $0 codePoint and: $z codePoint) ifTrue:[
            aStream nextPut: (Character codePoint: byte)  
        ] ifFalse:[ 
            aStream nextPutAll: '\x'.
            byte printOn:aStream base:16 size:2 fill:$0
        ].
    ].

    "
    #[46 0 1 1 0 41 0 1 1 0 36 0 0 0 0 0 1 0 28 0 1 25 0 97 83 101 113 117 101 110 99 101 97 98 108 101 67 111 108 108 101 99 116 105 111 110] pythonString
    "

    "Created: / 22-06-2018 / 09:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray methodsFor:'printing & storing'!

pythonString
    "Returns Python-escaped representation of self as String`.

     This may be useful when copu-pasting ByteArray values to
     Python code."

    ^ String streamContents:[ :s | self pythonOn: s ]

    "
    #[46 0 1 1 0 41 0 1 1 0 36 0 0 0 0 0 1 0 28 0 1 25 0 97 83 101 113 117 101 110 99 101 97 98 108 101 67 111 108 108 101 99 116 105 111 110] pythonString
    "

    "Created: / 22-06-2018 / 09:31:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Filename methodsFor:'queries-path & name'!

cygName
    "
    Return the pathname as used by Cygwin. 
    See http://cygwin.com/cygwin-ug-net/cygpath.html
    "
    | cygName |

    cygName := self pathName.
    (cygName includes: $\) ifTrue:[
    	cygName := cygName copyReplaceAll: $\ with: $/.
        (cygName size > 1 and:[cygName first isLetter and: [cygName second == $:]]) ifTrue:[ 
            cygName 
                at: 2 put: cygName first asLowercase;
                at: 1 put: $/
        ].
    ].	   
    ^ cygName

    "
    Filename currentDirectory cygName
    'C:\' asFilename cygName
    "

    "Created: / 03-04-2018 / 17:05:50 / jv"
! !

!Filename class methodsFor:'instance creation'!

cygNamed:aString
    "
    Return a Filename instance for given Cygwin path. 
    See http://cygwin.com/cygwin-ug-net/cygpath.html, option -w
    "    
    | winName |

    winName := aString.
    self concreteClass == PCFilename ifTrue:[
        winName := winName copyReplaceAll: $/ with: $\.
        (winName first == $\ and: [winName second isLetter and:[ winName third = $\]]) ifTrue:[ 
            winName 
                at: 1 put: (winName at: 2) asUppercase;
                at: 2 put: $:.
        ].
    ].
    ^ self named: winName.
    "
    Filename cygNamed: '/C/temp'
    Filename cygNamed: 'C:\temp'
    Filename cygNamed:'/c/temp')
    Filename cygNamed: Filename currentDirectory cygName

    "

    "Created: / 03-04-2018 / 17:12:29 / jv"
! !

!Magritte::MABooleanDescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ aGDBMIParser parseValueAsBoolean

    "Created: / 23-09-2014 / 22:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MADescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ self subclassResponsibility

    "Created: / 23-09-2014 / 22:23:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MADescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser taggedAs: aString
    ^ self parseUsingGDBMIParser: aGDBMIParser

    "Created: / 03-07-2018 / 16:23:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MANumberDescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ aGDBMIParser parseValueAsInteger

    "Created: / 23-09-2014 / 22:24:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MASingleOptionDescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser:aGDBMIParser
    | stringValue |

    stringValue := aGDBMIParser parseValueAsString.
    (self propertyAt: #labels ifAbsent: [ #() ])
        keysAndValuesDo:[ :key :value | value = stringValue ifTrue:[ ^ key ] ].
    self options 
        do:[:key | key printString = stringValue ifTrue:[ ^ key ] ].
    MAReadError new signal: 'No option found for string value ''', stringValue , ''''.

    "Created: / 25-09-2014 / 08:35:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MAStringDescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ aGDBMIParser parseValueAsString

    "Created: / 23-09-2014 / 22:24:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MAToManyRelationDescription methodsFor:'accessing-properties'!

allowOmmitedBrackets
        ^ self propertyAt: #allowOmmitedBrackets ifAbsent: [ self class defaultAllowOmmitedBrackets ]

    "Created: / 11-11-2017 / 12:11:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MAToManyRelationDescription methodsFor:'accessing-properties'!

allowOmmitedBrackets: aBoolean
        self propertyAt: #allowOmmitedBrackets put: aBoolean

    "Created: / 11-11-2017 / 12:11:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MAToManyRelationDescription methodsFor:'parsing-GDB/MI'!

parseUsingGDBMIParser: aGDBMIParser
    ^ aGDBMIParser parseValueAsListOf: classes anElement describedBy: reference allowOmmitedBrackets: self allowOmmitedBrackets

    "Created: / 23-09-2014 / 23:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-07-2018 / 17:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Magritte::MAToManyRelationDescription class methodsFor:'accessing-defaults'!

defaultAllowOmmitedBrackets
        ^ false

    "Created: / 11-11-2017 / 12:11:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SubscriptionCollection methodsFor:'private'!

value: anAnnouncement

        self do: [ :each | each notNil ifTrue:[each value: anAnnouncement]]

    "Modified: / 03-02-2018 / 21:26:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!jv_libgdbs class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
