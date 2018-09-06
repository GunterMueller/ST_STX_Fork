"{ Package: 'stx:goodies/monticello' }"

MCDefinition subclass:#MCClassComment
	instanceVariableNames:'className comment source'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Modeling'
!


!MCClassComment methodsFor:'accessing'!

actualClass
        ^Smalltalk classNamed: self className
!

className
    ^ className
!

className:classNameArg comment:commentArg source:sourceArg 
    className := classNameArg.
    comment := commentArg.
    source := sourceArg.
!

comment
    ^ comment
!

sortKey
    self halt:'please define sortKey here'.
!

source
    ^ source
! !

!MCClassComment methodsFor:'converting'!

asChange
    ^ ClassCommentChange new className:self className comment:self comment
! !

!MCClassComment methodsFor:'loading'!

load
    |actualClass|

    actualClass := self actualClass.
    actualClass comment:comment
! !

!MCClassComment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassComment.st,v 1.2 2014-12-23 19:47:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCClassComment.st,v 1.2 2014-12-23 19:47:11 cg Exp $'
! !

