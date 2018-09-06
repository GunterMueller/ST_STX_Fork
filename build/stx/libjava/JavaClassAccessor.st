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

Object subclass:#JavaClassAccessor
	instanceVariableNames:'name binaryName package loading'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

!JavaClassAccessor class methodsFor:'documentation'!

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

!JavaClassAccessor class methodsFor:'instance creation'!

fullName: aSymbol

    ^self new setBinaryName: aSymbol

    "Created: / 28-02-2012 / 19:20:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'* As yet uncategorized *'!

constantPool
    ^ #()

    "Created: / 08-10-2013 / 23:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'accessing'!

fullName
    ^ binaryName
!

name
    "Returns Smalltalk name"
    ^name

    "Created: / 28-02-2012 / 19:48:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theClass
    | cls |

    cls := self theClassOrNil.
    cls isNil ifTrue:[
        [ 
            loading := true.
            cls := JavaVM classForName: (binaryName copyReplaceAll: $/ with: $.) definedBy: JavaVM systemClassLoader.
        ] ensure:[
            loading := false
        ].
    ].
    ^cls

    "Created: / 28-02-2012 / 19:22:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-12-2013 / 23:54:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theClassOrNil

    | cls |
    [
        loading := true.
        cls := JavaVM registry classNamed: binaryName.
        cls isNil ifTrue:[
            "Hmm...maybe somebody will provide me the class, let's try"    
            cls := JavaClassQuery query: binaryName
        ].
    ] ensure:[
        loading := false.
    ].
    ^cls

    "Created: / 28-02-2012 / 19:47:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'error handling'!

doesNotUnderstand: aMessage

    ^aMessage sendTo: self theClass

    "Created: / 28-02-2012 / 19:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'exception handling support'!

isExceptionCreator

    loading ifTrue:[ ^ false ].
    ^self theClass isThrowable

    "Created: / 18-03-2012 / 20:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExceptionHandler
    loading ifTrue:[ ^ false ].
    ^self theClass isThrowable

    "Created: / 18-03-2012 / 14:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'initialization'!

setBinaryName: aSymbol 
    binaryName := aSymbol.
    name := 'JAVA::' , ((binaryName tokensBasedOn: $/) asStringWith: '::')
! !

!JavaClassAccessor methodsFor:'instance creation'!

basicNew

    ^self theClass basicNew

    "Created: / 02-11-2012 / 21:09:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new

    ^self theClass new

    "Created: / 28-02-2012 / 19:34:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newCleared
    <resource: #obsolete>
    "Use basicNew"

    ^self theClass basicNew

    "Created: / 28-02-2012 / 19:34:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll: 'JAVA '.
    (binaryName tokensBasedOn: $/) 
        do:[:component|aStream nextPutAll: component]
        separatedBy:[aStream space].

    "Modified: / 28-02-2012 / 20:27:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor methodsFor:'testing'!

isBehavior

    ^true

    "Created: / 28-02-2012 / 19:36:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isClass

    ^true

    "Created: / 28-02-2012 / 20:00:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaClass

    ^true

    "Created: / 28-02-2012 / 20:08:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLoaded

    loading ifTrue:[ ^ false ].
    self theClass. "/Force load"
    ^true

    "Created: / 19-03-2012 / 10:44:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassAccessor class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassAccessor.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

