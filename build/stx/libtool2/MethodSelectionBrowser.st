"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ResourceSelectionBrowser subclass:#MethodSelectionBrowser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

Object subclass:#Method
	instanceVariableNames:'selector protocol'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MethodSelectionBrowser
!

!MethodSelectionBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    The MethodSelectionBrowser allows you to browse in class hierarchies
    for selecting methods for you purposes.

    [start with:]
        MethodSelectionBrowser open

    [author:]
        Thomas Zwick
"

! !

!MethodSelectionBrowser class methodsFor:'instance creation'!

request: aTitle onSuperclass: aSuperclass andClass: aClass andSelector: aSelector withTypes: protocolTypes
    "opens a MethodSelectionBrowser on 
        aSuperclassOrSymbol, 
        and aClassOrSymbol, 
        and aSelector,
        with allowed protocolTypes"

    ^ self new
        title: aTitle;
        openOnSuperclass: aSuperclass
        andClass: aClass
        andSelector: aSelector
        withTypes: protocolTypes

    "
     MethodSelectionBrowser
        request: 'Select a Method'
        onSuperclass: #ApplicationModel 
        andClass: #MenuEditor 
        andSelector: #menuItemImage
        withTypes: #(class)      
    "
! !

!MethodSelectionBrowser class methodsFor:'list specs'!

tableColumnsForResourceMethodAttributes
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:MethodSelectionBrowser andSelector:#tableColumnsForResourceMethodAttributes
    "

    <resource: #tableColumns>


    ^ #(
        #(#DataSetColumnSpec
           #label: ' Selector'
           #labelAlignment: #left
           #model: #selector
           #canSelect: false
       )
        #(#DataSetColumnSpec
           #label: ' Protocol'
           #labelAlignment: #left
           #model: #protocol
           #canSelect: false
       )
     )
! !

!MethodSelectionBrowser methodsFor:'aspects'!

helpEnabled
    "returns whether there is a documentation file"

    ^false

! !

!MethodSelectionBrowser methodsFor:'callbacks - user'!

classSelected
    "after a class selection, read the class or/and instance methods of the selected class"

    ClassPresentation = #'Class Hierarchy'
        ifTrue:  [self selectionOfClassHierarchy  value isNil ifTrue: [^nil]]
        ifFalse: [self selectionOfClassCategories value isNil ifTrue: [^nil]].

    self withWaitCursorDo:
    [
        |clsName contentsBlock|
        resourceTypes isNil ifTrue: [resourceTypes := #(instance class)].
        ClassPresentation = #'Class Hierarchy'
            ifTrue:  [clsName := (self selectionOfClassHierarchy  value name upTo: $ ) asSymbol]
            ifFalse: [clsName := (self selectionOfClassCategories value name upTo: $ ) asSymbol].
        self valueOfClassName value: clsName.
        self class lastSelection: clsName.
        self listOfResourceMethods removeAll.
        contentsBlock := 
        [:protocol|
            |cls|
            (resourceTypes includes: protocol) 
            ifTrue: 
            [
                cls := Smalltalk at: clsName.
                cls := (protocol = #instance) ifTrue: [cls] ifFalse: [cls class].
                self listOfResourceMethods addAll:
                    (cls selectors asOrderedCollection
                     collect: [:sel| Method new selector: sel; protocol: protocol asString])
            ]
        ].
        contentsBlock value: #instance.
        contentsBlock value: #class.
    ]


! !

!MethodSelectionBrowser methodsFor:'instance creation'!

openOnSuperclass: aSuperclassOrSymbol andClass: aClassOrSymbol andSelector: aSelector withTypes: protocolTypes
    "opens a MethodSelectionBrowser on 
        aSuperclassOrSymbol, 
        and aClassOrSymbol, 
        and aSelector,
        with allowed protocolTypes"

    |message type row|

    message := self 
        openOnSuperclass: aSuperclassOrSymbol 
        andClass: aClassOrSymbol 
        andSelector: aSelector 
        withResourceTypes: protocolTypes.

    (message notNil and:
    [((row := self selectionOfResourceMethod value) notNil and:
    [(type := row protocol) = 'class'])])
    ifTrue:
    [   
        message := message replChar:$  withString: ' class '
    ].
    ^message
! !

!MethodSelectionBrowser methodsFor:'startup & release'!

postBuildWith:aBuilder
    "sets the correct title"

    title := 'Method Selection Browser'.

    ^super postBuildWith:aBuilder

! !

!MethodSelectionBrowser::Method methodsFor:'accessing'!

protocol
    "returns the protocol of the method (#instance or #class)"

    ^protocol


!

protocol: aSymbol
    "sets the protocol of the method (#instance or #class)"

    protocol := aSymbol


!

selector
    "returns the selector of the method"

    ^selector

!

selector: aSymbol
    "sets the selector of the method"

    selector := aSymbol

! !

!MethodSelectionBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

