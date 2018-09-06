"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCAncestry subclass:#MCVersionInfo
	instanceVariableNames:'id name message date time author'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Versioning'
!

MCVersionInfo comment:'Adds to the record of ancestry, other identifying details.'
!


!MCVersionInfo class methodsFor:'as yet unclassified'!

name: vName id: id message: message date: date time: time author: author ancestors: ancestors
	^ self 
		name: vName
		id: id
		message: message
		date: date
		time: time
		author: author
		ancestors: ancestors
		stepChildren: #()
!

name: vName id: id message: message date: date time: time author: author ancestors: ancestors stepChildren: stepChildren
	^ self new
		initializeWithName: vName
		id: id
		message: message
		date: date
		time: time
		author: author
		ancestors: ancestors
		stepChildren: stepChildren
! !

!MCVersionInfo methodsFor:'accessing'!

inspector2TabAncestry
    <inspector2Tab>

    ^ (self newInspector2Tab)
        label:'Ancestry';
        priority:50;
        view: [
            | list view |

            list := PluggableHierarchicalList new.
            list childBlock: [ :parent | parent ancestors ].
            list labelBlock: [ :child | child name ].
            list root: self.
            view := ScrollableView for:HierarchicalListView.
            view useDefaultIcons: false.
            view list: list.
            view
        ];
        yourself

    "Created: / 07-09-2015 / 15:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message
	^ message ifNil: ['']
!

name
	^ name ifNil: ['<working copy>']
!

summary
	^ String streamContents:
		[:s |
		s
			nextPutAll: self summaryHeader; cr; cr;
			nextPutAll: self message.
		]
!

summaryHeader
        ^ String streamContents:
                [:s |
                s
                        nextPutAll: 'Name: '; nextPutAll: self name; cr.
                date ifNotNil:
                        [s
                                nextPutAll: 'Author: '; nextPutAll: author; cr;
                                nextPutAll: 'Time: '; nextPutAll:  date asString, ', ', time asString; cr].
                id ifNotNil:
                        [s nextPutAll: 'UUID: '; nextPutAll: id printString; cr].
                s
                        nextPutAll: 'Ancestors: '; nextPutAll: self ancestorString.
                self stepChildren isEmpty ifFalse:
                        [s cr; nextPutAll: 'Backported From: '; nextPutAll: self stepChildrenString].
                ]

    "Modified: / 05-09-2011 / 09:07:31 / cg"
!

timeStamp
    Smalltalk isSmalltalkX ifTrue:[
        ^ Timestamp fromDate: date andTime: time
    ].
    ^ TimeStamp date: date time: time

    "Modified: / 02-12-2011 / 14:36:15 / cg"
!

timeString
	^ date asString, ', ', time asString
! !

!MCVersionInfo methodsFor:'comparing'!

= other
	^ other species = self species
		and: [other hasID: id]
!

hash
	^ id hash
! !

!MCVersionInfo methodsFor:'converting'!

asDictionary
	^ Dictionary new
		at: #name put: name;
		at: #id put: id;
		at: #message put: message;
		at: #date put: date;
		at: #time put: time;
		at: #author put: author;
		at: #ancestors put: (self ancestors collect: [:a | a asDictionary]);
		yourself
!

fromLiteralArrayEncoding: encoding
    name := encoding at: 3.
    id := UUID fromString: (encoding at: 5).
    date := Date readFrom:(encoding at: 7) format: '%y-%m-%d'.
    time := Time readFrom:(encoding at: 9) format: '%H:%m:%s.%i'.
    author :=  encoding at: 11.
    message := (encoding at: 13) asStringWithSqueakLineEndings.     
    encoding size > 13 ifTrue:[
        ancestors := (encoding at: 15) collect:[ :e | e decodeAsLiteralArray ].
    ].

    "Created: / 07-09-2015 / 17:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 00:02:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalArrayEncoding
    ^ self literalArrayEncodingWithAncestors: true

    "Created: / 07-09-2015 / 17:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalArrayEncodingWithAncestors: withAncestors
    | encoding |
    encoding := Array new: 13 + (withAncestors ifTrue:[2] ifFalse:[0]).
    encoding
        at: 1 put: MCVersionInfo name;
        at: 2 put: #name:; at: 3 put: name;
        at: 4 put: #id:; at: 5 put: id printString;
        at: 6 put: #date:; at: 7 put: (date printStringFormat:'%y-%m-%d');
        at: 8 put: #time:; at: 9 put: (time printStringFormat:'%H:%m:%s.%i');
        at:10 put: #author:; at: 11 put: author;
        at:12 put: #message:; at: 13 put: (message asStringWithNativeLineEndings).
    withAncestors ifTrue:[    
        encoding at:14 put: #ancestors:; at: 15 put: (withAncestors ifTrue:[self ancestors collect:[ :e|e literalArrayEncodingWithAncestors: withAncestors ] as: Array] ifFalse:[ #() ]).
    ].
    ^ encoding.

    "Created: / 07-09-2015 / 17:22:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 00:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalArrayEncodingWithoutAncestors
    ^ self literalArrayEncodingWithAncestors: false

    "Created: / 07-09-2015 / 17:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionInfo methodsFor:'initialize-release'!

initializeWithName: vName id: aUUID message: aString date: aDate time: aTime author: initials ancestors: aCollection stepChildren: stepCollection
	name _ vName.
	id _ aUUID.
	message _ aString.
	date _ aDate.
	time _ aTime.
	author _ initials.
	ancestors _  aCollection.
	stepChildren _ stepCollection
! !

!MCVersionInfo methodsFor:'pillaging'!

author
	^ author
!

date
	^ date
!

id
	^ id 
!

time
	^ time
! !

!MCVersionInfo methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; nextPutAll: self name; nextPut: $)
	
! !

!MCVersionInfo methodsFor:'private'!

hasID: aUUID
	^ id = aUUID
! !

!MCVersionInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionInfo.st,v 1.4 2012-09-11 21:30:28 cg Exp $'
! !

