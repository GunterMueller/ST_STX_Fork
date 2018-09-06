"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGElementDefinition subclass:#RGCommentDefinition
	instanceVariableNames:'content stamp'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGCommentDefinition comment:'RGCommentDefinition is a first-class representation of class''s comments'
!

!RGCommentDefinition class methodsFor:'instance creation'!

realClass: aClass
    "Creates a ring comment definition from a Smalltalk class"
    ^(super realClass: aClass)
        asActive;
        yourself
! !

!RGCommentDefinition methodsFor:'accessing'!

content

    self isActive 
        ifTrue: [ ^ self realClass organization classComment ].
    self isHistorical
        ifTrue: [ ^ self contentAtPointer ifNil:[ | rc | (rc := self realClass) ifNil:[ content ] ifNotNil:[ rc organization classComment ] ] ].	
    ^ content
!

content: anObject

    content:= anObject
!

fullName
    "Keeps a unique description for the receiver. As annotation to avoid converting each time is invoked"
    
    ^self annotationNamed: self class fullNameKey
        ifAbsentPut:[ (self parentName, ' ', self name) asSymbol ]
!

name

    ^name ifNil:[ name := #Comment ]
!

stamp
    "Retrieves the user-alias + timestamp associated to the receiver (if exists)"
    
    self isActive 
        ifTrue: [ ^ self realClass organization commentStamp ].
    self isHistorical
        ifTrue: [ ^ self stampAtPointer ifNil:[ | rc | (rc := self realClass) ifNil:[ stamp ] ifNotNil:[ rc organization commentStamp ] ] ].	
    ^ stamp
!

stamp: anObject

    stamp:= anObject
! !

!RGCommentDefinition methodsFor:'backward compatibility'!

sourceCode

    ^ self content   
! !

!RGCommentDefinition methodsFor:'comparing'!

<= aRGCommentDefinition
    "Sort comment definition according to: 1) name of the class"
    
    ^(self parentName <= aRGCommentDefinition parentName)
! !

!RGCommentDefinition methodsFor:'printing'!

printOn: aStream 

    self parentName ifNotNil: [
        aStream nextPutAll: self parentName;
                  nextPutAll: ' ' ].
    aStream nextPutAll: self name
! !

!RGCommentDefinition methodsFor:'source pointers'!

commentDataPointers
    "Retrieves the combination key to look for information of the receiver in the source file"
    ^'commentStamp:' -> #commentStamp:
!

contentAtPointer
    "A RGCommentDefinition may be created to point the sourceFile in which case it retrieves the class comment"

    ^ self sourcePointer notNil
        ifTrue: [ SourceFiles sourceCodeAt: self sourcePointer ]
        ifFalse:[ '' ]
!

sourcePointer
    "Retrieves the sourcePointer for this definition if exists"
    
    ^self annotationNamed:  self class sourcePointerKey   
!

sourcePointer: aNumber

    self annotationNamed:  self class sourcePointerKey put: aNumber 
!

stampAtPointer
    "A RGMethodDefinition may be created to point the sourceFile in which case it retrieves the stamp"

    ^ self sourcePointer notNil
        ifTrue: [ SourceFiles timeStampAt: self sourcePointer for: self commentDataPointers ]
        ifFalse:[ nil ]	
! !

!RGCommentDefinition methodsFor:'stamp values'!

author 

    ^self annotationNamed: self class authorKey
        ifAbsentPut:[ self class parseAuthorAliasFrom: stamp ]
!

author: aString 

    self annotationNamed: self class authorKey
            put: aString 
!

timeStamp 

    ^ self annotationNamed: self class timeStampKey 
        ifAbsentPut: [ self class 
                            parseTimestampFrom: self stamp 
                            default: (Timestamp epoch) ]

    "Modified: / 25-09-2015 / 19:05:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timeStamp: aTimestamp 

    self annotationNamed: self class timeStampKey
            put: aTimestamp 
! !

!RGCommentDefinition methodsFor:'testing'!

hasAuthor

    ^self hasStamp and:[ self author isEmptyOrNil not ]
!

hasStamp

    ^stamp isEmptyOrNil not

    
!

isComment

    ^true
!

isEmptyOrNil

    ^content isEmptyOrNil 
!

isFromTrait
    ^false
!

isSameRevisionAs: aRGCommentDefinition
    "This method look for equality of the properties of the receiver"
    "A comment validates only its contents and not its stamp"
    
    ^(super isSameRevisionAs: aRGCommentDefinition)
        and:[ self content = aRGCommentDefinition content ]
! !

!RGCommentDefinition methodsFor:'to remove as soon as possible'!

category
    ^self realClass category
!

isValid
    "for compatibility with method definition"

    ^ true
!

methodClass
    self flag: 'if comments are mixed with methods use #realClass instead'.
    ^self realClass
!

selector
    self flag: 'if comments are mixed with methods use #name instead'.
    ^self name
! !

!RGCommentDefinition methodsFor:'type of comments'!

asActive

    "Sets the receiver as active object, which will allow itself to retrieve its data from the class organization"
    self annotationNamed: self class statusKey put: #active.
!

asHistorical

    "Sets the receiver as historical object, which will allow itself to retrieve its data using the sourcePointer"
    | realClass |
    self annotationNamed: self class statusKey put: #historical.
    self sourcePointer ifNil:[
        realClass := self realClass.
        realClass notNil ifTrue: [ 
            | str |
            (str := realClass organization commentRemoteString)
                ifNotNil: [ self sourcePointer: str sourcePointer ] ] ]
!

asPassive

    "Sets the receiver as passive object, which will allow itself to retrieve its data that was assigned in its creation"
    self annotationNamed: self class statusKey put: #passive
!

fromActiveToHistorical
    "If the receiver was generated as an active comment, it can be converted to a historical one by reading the data of the real class (if exists)"
    
    self isActive ifTrue: [
        self asHistorical ]
!

fromActiveToPassive
    "If the receiver was generated as an active comment, it can be converted to a passive one by reading the data of the real class organization"

    | realClass |
    self isActive
        ifFalse: [ ^ self ].
    realClass := self realClass.
    realClass notNil
        ifTrue: [ 
            self content: realClass organization classComment.
            self stamp: realClass organization commentStamp ].
    self asPassive
!

isActive
    "A ring comment isActive when it needs to access the class organization for retrieving its data"

    | status |

    ^(status := self annotationNamed: self class statusKey) 
        ifNil:[ false ] 
        ifNotNil:[ status == #active ]
!

isHistorical
    "A ring comment can be used to point an old version of the receiver, in this case it will use the sourcePointer to retrieve its information"

    | status |

    ^(self annotationNamed: self class statusKey) 
        ifNil:[ false ] 
        ifNotNil:[ status == #historical ]
!

isPassive
    "A ring comment isPassive by default.  In this case it will retrieve the data that was assigned in its creation"

    | status |

    ^(status := self annotationNamed: self class statusKey) 
        ifNil:[ true ] 
        ifNotNil:[ status == #passive ]
! !

