"{ Package: 'stx:libscm/git' }"

ExternalStructure subclass:#GitStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Git-Core-Internal-Structures'
!


!GitStructure class methodsFor:'instance creation'!

address: address
    ^self address: address size: self structSize.

    "Created: / 19-09-2012 / 14:04:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromExternalAddress:anExternalAddress
    ^ self basicNew fromExternalAddress:anExternalAddress

    "Created: / 01-10-2012 / 14:26:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^self new: self structSize

    "Created: / 30-09-2012 / 20:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    size == self structSize ifFalse:[
        self error:'Invalid size for git_checkout_opts'.
        ^nil.
    ].
    ^(super new: size) initialize.

    "Created: / 19-09-2012 / 18:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newAddress: address
    ^self address: address size: self structSize.

    "Created: / 25-09-2012 / 15:07:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStructure class methodsFor:'accessing'!

structSize
    ^0

    "Created: / 19-09-2012 / 01:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStructure methodsFor:'initialization'!

initialize
    1 to: self size do:[:i|self at: i put: 0]

    "Created: / 03-10-2012 / 20:31:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStructure methodsFor:'private'!

fromExternalAddress:anExternalAddress
    self setAddress:(anExternalAddress address) size: self class structSize

    "Created: / 19-09-2012 / 01:53:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GitStructure class methodsFor:'documentation'!

version_GIT
    "Never, ever change this method. Ask JV or CG why"
    ^thisContext method mclass theNonMetaclass instVarNamed: #revision
!

version_SVN
    ^ '$Id$'
! !
