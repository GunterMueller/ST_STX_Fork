"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCDefinition
	instanceVariableNames:''
	classVariableNames:'Instances'
	poolDictionaries:''
	category:'SCM-Monticello-Base'
!


!MCDefinition class methodsFor:'as yet unclassified'!

clearInstances

        Instances := nil

    "Modified: / 18-08-2009 / 10:14:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

instanceLike: aDefinition 

    Instances ifNil: [ Instances := WeakIdentitySet new ].
    Instances do:
        [:each|each = aDefinition ifTrue:[^each]].
    Instances add: aDefinition.
    ^aDefinition.

    "Modified: / 18-08-2009 / 10:18:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!MCDefinition methodsFor:'accessing'!

provisions
	^ #()
!

requirements
	^ #()
! !

!MCDefinition methodsFor:'annotations'!

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

printAnnotations: requests on: aStream
	"Add a string for an annotation pane, trying to fulfill the annotation requests.
	These might include anything that
		Preferences defaultAnnotationRequests 
	might return. Which includes anything in
		Preferences annotationInfo
	To edit these, use:"
	"Preferences editAnnotations"

	aStream nextPutAll: 'not yet implemented'
! !

!MCDefinition methodsFor:'comparing'!

< aMCMethodDefinition

    ^self <= aMCMethodDefinition
        and: [(self = aMCMethodDefinition) not]

    "Created: / 18-08-2009 / 10:25:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

<= other
	^ self sortKey <= other sortKey
!

= aDefinition
	^ self isRevisionOf: aDefinition
!

description
	self subclassResponsibility
!

fullTimeStamp
	^Timestamp current
!

hash
	^ self description hash
!

isRevisionOf: aDefinition
	^ (aDefinition isKindOf: MCDefinition) and: [aDefinition description = self description]
!

isSameRevisionAs: aDefinition
	^ self = aDefinition
!

sortKey
	self subclassResponsibility 
! !

!MCDefinition methodsFor:'converting'!

asChange
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!MCDefinition methodsFor:'installing'!

load
	
!

loadOver: aDefinition
	self load
	
!

postload
!

postloadOver: aDefinition
	self postload
!

unload
! !

!MCDefinition methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: '(', self summary, ')'
!

summary
	self subclassResponsibility 
! !

!MCDefinition methodsFor:'serializing'!

storeDataOn: aDataStream
    "Store myself on a DataStream.  
     Answer self.  
     This is a low-level DataStream/ReferenceStream method. 
     See also objectToStoreOnDataStream.  
     NOTE: This method must send 'aDataStream beginInstance:size:' and then (nextPut:/nextPutWeak:) its subobjects.  
     readDataFrom:size: reads back what we write here."

    | cntInstVars cntIndexedVars |

    cntInstVars := self class instSize.
    cntIndexedVars := self basicSize.
    aDataStream
        beginInstance: self class
        size: cntInstVars + cntIndexedVars.
    1 to: cntInstVars do:[:i | 
        | value |

        value := (self instVarAt: i).
        "/ Special hack for ImmutableString / ImmutableArray which is not known by Squeak / Pharo,
        "/ and therefore will fail to load properly there.
        "/ In one of those is encountered, convert them to their mutable version.
        (value class == ImmutableString or:[value class == ImmutableArray or:[value class == ImmutableByteArray]]) ifTrue:[ 
            value := value asMutableCollection.
        ].
        aDataStream nextPut: value   
    ].

    "Write fields of a variable length object.  When writing to a dummy
        stream, don't bother to write the bytes"
    "1 to: cntInstVars do:
        [:i | aDataStream nextPut: (self instVarAt: i)]."

    "Created: / 23-04-2015 / 15:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDefinition methodsFor:'testing'!

isClassDefinition
	^false
!

isClassDefinitionExtension
	"Answer true if this definition extends the regular class definition"
	^false
!

isMethodDefinition
	^false
!

isOrganizationDefinition
	^false
!

isOverrideDefinition
    ^false

    "Created: / 08-11-2010 / 17:29:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCDefinition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDefinition.st,v 1.5 2012-09-11 21:21:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDefinition.st,v 1.5 2012-09-11 21:21:09 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: MCDefinition.st 24 2010-11-09 14:00:17Z vranyj1 §'
! !

