"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#CodeCritics
	instanceVariableNames:'code critics'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!CodeCritics class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    extracted critics from the browser
    For now, not much is found here - however, it will eventually grow and should collect
    the critics in the parser as well.

    [author:]
        Claus Gittinger (cg@exept.de)
"
! !

!CodeCritics class methodsFor:'critics'!

checkCodeQuality:code
    ^ (self new code:code) checkCodeQuality

    "Created: / 27-03-2007 / 21:41:50 / cg"
! !

!CodeCritics methodsFor:'accessing'!

code:something
    code := something.
! !

!CodeCritics methodsFor:'critics'!

checkBadIndentationOfReturns
    "we want returns to be indented correctly"

    code asCollectionOfLines keysAndValuesDo:[:lineNr :eachLine |
        |lineString column|

        lineString := eachLine string.
        (lineString withoutLeadingSeparators startsWith:'^') ifTrue:[
            column := lineString indexOf:$^.
            (column-1) \\ 4 ~~ 0 ifTrue:[
                self addCritic:'bad indentation' line:lineNr.
            ].
        ]
    ].

    "Created: / 27-03-2007 / 21:41:10 / cg"
!

checkCodeQuality
    self checkBadIndentationOfReturns.
    ^ critics

    "Created: / 27-03-2007 / 21:42:11 / cg"
! !

!CodeCritics methodsFor:'helpers'!

addCritic:msg line:lineNr
    critics isNil ifTrue:[
        critics := OrderedCollection new.
    ].
    critics add:(lineNr -> msg)

    "Created: / 27-03-2007 / 21:47:09 / cg"
! !

!CodeCritics class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools__CodeCritics.st,v 1.3 2011/07/03 13:31:36 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__CodeCritics.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

