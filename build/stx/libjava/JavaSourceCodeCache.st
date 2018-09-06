"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

Object subclass:#JavaSourceCodeCache
	instanceVariableNames:'parsedCodes'
	classVariableNames:'parsedCode'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

JavaSourceCodeCache class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!

!JavaSourceCodeCache class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaSourceCodeCache class methodsFor:'instance creation'!

new
    instance isNil ifTrue: [ instance := self basicNew initialize ].
    ^ instance

    "Created: / 13-12-2010 / 13:56:31 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaSourceCodeCache methodsFor:'adding & removing'!

flush
    self parsedCodes removeAll.

    "Created: / 17-12-2010 / 16:32:49 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaSourceCodeCache methodsFor:'initialize'!

initialize
    parsedCodes := IdentityDictionary new.

    "Created: / 13-12-2010 / 14:11:49 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 17-12-2010 / 13:35:36 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaSourceCodeCache methodsFor:'private - searching'!

findMethodLine: javaMethod inMethods: methods 
    | bestMatchMethod  pos |

    pos := javaMethod firstInstructionLineNumber.
    bestMatchMethod := Plug new respondTo: #startLine with: [^ 0].
    methods do: [
        :method | 
        method startLine > pos ifTrue: [
            ^ bestMatchMethod startLine
        ].
        bestMatchMethod := method.
    ].
    ^ 0.

    "Created: / 08-01-2011 / 16:10:37 / Jan Kurs <kurs.jan@post.cz>"
!

getMethodsFor:class 
    ^ parsedCodes at: class fullName ifAbsentPut: [
        [        
            JavaParser_Old methodsIn: class source 
        ] on: Exception do:
        [
            OrderedCollection new.
        ]
    ].

    "Created: / 08-01-2011 / 16:09:47 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 09-03-2012 / 23:30:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsedCodes
    ^ parsedCodes
! !

!JavaSourceCodeCache methodsFor:'queries'!

findLineForMethod:javaMethod inClass:javaClass 
    | methods  mdL |
    methods := self getMethodsFor:javaClass.
    mdL := self findMethodLine:javaMethod inMethods:methods.
    ^ mdL

    "Created: / 13-12-2010 / 13:47:26 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 08-01-2011 / 16:10:21 / Jan Kurs <kurs.jan@post.cz>"
! !

!JavaSourceCodeCache class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaSourceCodeCache.st,v 1.7 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

