"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCPatchOperation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Patching'
!


!MCPatchOperation methodsFor:'accessing'!

annotations
	^self annotations: Preferences defaultAnnotationRequests
!

annotations: requests
	"Answer a string for an annotation pane, trying to fulfill the annotation requests.
	These might include anything that
		Preferences defaultAnnotationRequests 
	might return. Which includes anything in
		Preferences annotationInfo
	To edit these, use:"
	"Preferences editAnnotations"

	^String streamContents: [ :s | self printAnnotations: requests on: s ].
!

definition
	^ self subclassResponsibility 
!

inverse
	self subclassResponsibility
!

prefixForOperation: aSymbol
	aSymbol == #insert ifTrue: [^ '+'].
	aSymbol == #remove ifTrue: [^ '-'].
	^ ' '
!

printAnnotations: requests on: aStream
	"Add a string for an annotation pane, trying to fulfill the annotation requests.
	These might include anything that
		Preferences defaultAnnotationRequests 
	might return. Which includes anything in
		Preferences annotationInfo
	To edit these, use:"
	"Preferences editAnnotations"

	self definition printAnnotations: requests on: aStream.
!

source
	^ self sourceText
!

sourceString
	^self sourceText asString
!

sourceText
	| builder |
	builder := (Preferences diffsWithPrettyPrint and: [ self targetClass notNil and: [ self isClassPatch not ] ])
				ifTrue: 
					[PrettyTextDiffBuilder 
						from: self fromSource
						to: self toSource
						inClass: self targetClass]
				ifFalse: [TextDiffBuilder from: self fromSource to: self toSource].
	^builder buildDisplayPatch.
!

summary
	^ self definition summary, self summarySuffix
!

summarySuffix
	^ ''
! !

!MCPatchOperation methodsFor:'as yet unclassified'!

isClassPatch
	^false
!

targetClass
	self subclassResponsibility.
! !

!MCPatchOperation methodsFor:'comparing'!

<= other
	^ self definition <= other definition
! !

!MCPatchOperation methodsFor:'testing'!

isAddition
	^ false
!

isModification
	^ false
!

isRemoval
	^ false
! !

!MCPatchOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatchOperation.st,v 1.4 2012-09-11 21:25:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPatchOperation.st,v 1.4 2012-09-11 21:25:36 cg Exp $'
!

version_SVN
    ^ '§Id: MCPatchOperation.st 5 2010-08-29 07:30:29Z vranyj1 §'
! !
