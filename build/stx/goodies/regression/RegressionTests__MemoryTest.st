"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#MemoryTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!

!MemoryTest class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	Michael Beyl (mb@bart)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 14.10.2003 / 17:53:03 / mb"
! !

!MemoryTest methodsFor:'tests'!

test1
    "cg: whoever wrote this test:
	 please add some comment on what is actually tested"

    |x y z|
    1 to: 100 do: [:rep|
    x := XML::Element tag:'x'.
    ObjectMemory garbageCollect.

    x attributes: (Array with: (XML::Attribute name: 'a' value: '1')
      with: (XML::Attribute name: 'a' value: '1')).
    1 to: 500 do: [:i |
      x addNode: (y := XML::Element tag: 'y').
     y attributes: (Array with: (XML::Attribute name: 'a' value: '1')
      with: (XML::Attribute name: 'a' value: '1')).
      1 to: 1000 do: [:j |
	y addNode: (z := XML::Element tag: 'y').
     z attributes: (Array with: (XML::Attribute name: 'a' value: '1')
      with: (XML::Attribute name: 'a' value: '1')).]].
    ObjectMemory garbageCollect.
    x nodesDo: [:el |
     (el isKindOf: XML::Element)
       ifTrue: [(el attributeNamed:'a')
	value: ((el valueOfAttribute:'a' ifAbsent:[]) asNumber * 10 / 3 ) asString]
    ].
    ]

    "
     self run:#test1
     self new test1
    "
! !

!MemoryTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

