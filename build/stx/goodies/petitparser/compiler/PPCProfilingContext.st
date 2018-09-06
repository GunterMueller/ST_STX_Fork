"{ Package: 'stx:goodies/petitparser/compiler' }"

"{ NameSpace: Smalltalk }"

PPCContext subclass:#PPCProfilingContext
	instanceVariableNames:'invocations remembers restores lwRemembers lwRestores totalSize
		tokenReads'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitCompiler-Context'
!


!PPCProfilingContext methodsFor:'accessing'!

position: value
    self assert: value isInteger.
    super position: value
! !

!PPCProfilingContext methodsFor:'gt'!

gtReport: composite
    <gtInspectorPresentationOrder: 40>
    composite table 
        title: 'Report';
        column: 'Info' evaluated: [ :each | each key printString ];
        column: 'Value' evaluated: [ :each | each value printString ];
        display: [:context | context asReportTable ].
! !

!PPCProfilingContext methodsFor:'initialization'!

initialize
    super initialize.
    self reset
!

reset
    invocations := OrderedCollection new.
    remembers := OrderedCollection new.
    restores := OrderedCollection new.
    
    lwRemembers := OrderedCollection new.
    lwRestores := OrderedCollection new.
    
    tokenReads := OrderedCollection new.
    
    totalSize := 0.
! !

!PPCProfilingContext methodsFor:'profiling'!

invocations
    ^ invocations 
!

lwRemember
    | selector |
    selector := thisContext sender selector.
    lwRemembers add: selector.

    ^ super lwRemember
!

lwRestore: whatever
    | selector |
    selector := thisContext sender selector.
    lwRestores add: selector.

    ^ super lwRestore: whatever.
!

methodFinished: selector
    "Nothing to do for now"
!

methodInvoked: selector
    invocations add: selector
!

remember
    | sender selector |

    sender := thisContext sender.
    selector := (sender receiver isKindOf: PPCompiledParser) ifTrue: [ 
 								sender selector.
    ] ifFalse: [ 
 								sender receiver class.	
    ].
    remembers add: selector.
    ^ super remember
!

restore: whatever
    | selector sender |
    
    sender := thisContext sender.
    selector := (sender receiver isKindOf: PPCompiledParser) ifTrue: [ 
 								sender selector.
    ] ifFalse: [ 
 								sender receiver class.	
    ].
    
    
    restores add: selector.
    
    ^ super restore: whatever
!

stream: aStream
    totalSize := totalSize + aStream size.
    ^ super stream: aStream
!

tokenRead: tokenName
    tokenReads add: tokenName
!

tokenReadCount
    ^ tokenReads size
!

tokenReads
    ^ tokenReads 
! !

!PPCProfilingContext methodsFor:'reporting'!

asReportTable
    ^{ 
        #'invocations per character (NOT PRECISE YET)' -> (self invocationCount / (totalSize + 1.0)).
        #'lwBacktrack per character' -> (self lwRestoreCount / (totalSize + 1.0)).
        #'backtrack per character' -> (self restoreCount / (totalSize + 1.0)).
        #'total stream size' -> totalSize .
        #'invocation count' -> self invocationCount.
        #'lwRemember count' -> self lwRememberCount.
        #'lwRestore count' -> self lwRestoreCount.
        #'remember count' -> self rememberCount.
        #'restore count' -> self restoreCount.
        #'token read count' -> self tokenReadCount.
    
    }
!

invocationCount
    ^ invocations size
!

lwRememberCount
    ^ lwRemembers size
!

lwRestoreCount
    ^ lwRestores size
!

rememberCount
    ^ remembers size
!

restoreCount
    ^ restores size
! !

!PPCProfilingContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

