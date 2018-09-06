"
 COPYRIGHT (c) 2006 by eXept Software AG
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

Object subclass:#LintAnnotation
	instanceVariableNames:'line rule'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintAnnotation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!LintAnnotation class methodsFor:'instance creation'!

from: start to: end rule: rule

    ^self new
        startPosition: start;
        endPosition: end;
        rule: rule;
        yourself.

    "Created: / 30-01-2012 / 15:23:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintAnnotation methodsFor:'accessing'!

line
    ^ line
!

line:anInteger
    line := anInteger.
!

rule
    ^ rule
!

rule:anRBLintRule
    rule := anRBLintRule.

    "Modified: / 15-12-2014 / 13:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintAnnotation methodsFor:'help'!

helpTextFor:aView
    |info resources|

    rule isNil ifTrue:[^ nil].
    
    resources := self class classResources.
    rule isComposite ifTrue:[
        "/ sigh - must collect here, because lint does not know about my resources.
        info := rule rules 
                    collect:[:each | 
                        (resources string:each infoInToolTip)
                    ] as:Set.
        info size > 1 ifTrue:[
            info := info collect:[:each | '- ',each].
        ].
        info := info asStringCollection asStringWith:Character cr. 
    ] ifFalse:[
        info := resources string:rule infoInToolTip
    ].
    info isEmptyOrNil ifTrue:[^ nil].
    ^ resources 
            stringWithCRs:(('Lint says (click on icon for details):\' withColor:#gray),'\%1') "/ 'Lint says: %1\Click for more info.' 
            with:info.
! !

!LintAnnotation methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
    The format is suitable for a human - not meant to be read back."

    self basicPrintOn: aStream.
    aStream nextPut: $(.
    line printOn: aStream.
    aStream nextPut: $).

    "Modified: / 15-12-2014 / 13:41:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintAnnotation class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

