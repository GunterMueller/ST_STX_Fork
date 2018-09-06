"{ Package: 'stx:goodies/sunit' }"!

!Behavior methodsFor:'Camp Smalltalk'!

sunitSelectors

    ^self selectors

    "Modified: / 11-09-2010 / 15:07:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Block methodsFor:'Camp Smalltalk'!

sunitEnsure: aBlock
	
	^self ensure: aBlock
! !

!Block methodsFor:'Camp Smalltalk'!

sunitOn: aSignal do: anExceptionBlock
	
	^self on: aSignal do: anExceptionBlock
! !

!Class methodsFor:'Camp Smalltalk'!

sunitName
	
	^self name
! !

!GenericException methodsFor:'Camp Smalltalk'!

sunitAnnounce: aTestCase toResult: aTestResult
        aTestResult addError: aTestCase detail: self.
        self sunitExitWith: false.

    "Modified: / 03-08-2011 / 13:53:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GenericException methodsFor:'Camp Smalltalk'!

sunitExitWith: aValue
	
	^self return: aValue
! !

!GenericException class methodsFor:'Camp Smalltalk'!

sunitSignalWith: aString

    <resource: #skipInDebuggersWalkBack>

    ^self raiseSignal: aString

    "Modified: / 05-12-2009 / 18:29:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'Camp Smalltalk'!

sunitAddDependent: anObject
	
	self addDependent: anObject
! !

!Object methodsFor:'Camp Smalltalk'!

sunitChanged: aspect
	
	self changed: aspect
! !

!Object methodsFor:'Camp Smalltalk'!

sunitRemoveDependent: anObject
	
	self removeDependent: anObject
! !

!String methodsFor:'Camp Smalltalk'!

sunitAsSymbol
	
	^self asSymbol
! !

!String methodsFor:'Camp Smalltalk'!

sunitMatch: aString
	
	^self match: aString
! !

!String methodsFor:'deprecated'!

sunitSubStrings

        <resource: #obsolete>
        
        | stream answer index |
        answer := OrderedCollection new.
        stream := ReadStream on: self.
        [stream atEnd]
                whileFalse:
                        [[stream atEnd ifTrue: [^answer asArray].
                        stream peek > Character space] whileFalse: [stream next].
                        index := stream position + 1.
                        [stream atEnd or: [stream peek <= Character space]] whileFalse: [stream next].
                        answer
                                add:
                                        (self
                                                copyFrom: index
                                                to: stream position)].
        ^answer asArray

    "Modified: / 11-09-2010 / 15:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Symbol methodsFor:'Camp Smalltalk'!

sunitAsClass
    "this is an sunit compatibility wrapper: return the class by that name"

    ^SUnitNameResolver classNamed: self
! !

!stx_goodies_sunit class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
