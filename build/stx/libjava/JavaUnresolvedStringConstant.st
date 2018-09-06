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

JavaUnresolvedConstant subclass:#JavaUnresolvedStringConstant
	instanceVariableNames:'stringIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaUnresolvedStringConstant class methodsFor:'documentation'!

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

!JavaUnresolvedStringConstant class methodsFor:'instance creation'!

pool:aPool poolIndex:index stringIndex:stringIndex
    ^ self new 
        pool:aPool poolIndex:index stringIndex:stringIndex


! !

!JavaUnresolvedStringConstant methodsFor:'accessing'!

pool:aPool poolIndex:i stringIndex:string_index
    constantPool := aPool.
    constantPoolIndex := i.
    stringIndex := string_index.

! !

!JavaUnresolvedStringConstant methodsFor:'resolving'!

preResolve
    |jString chars|

    Java java_lang_String notNil ifTrue:[
        chars := (constantPool at:stringIndex).
        chars isString ifFalse:[
            self halt:'should not happen'
        ].
        jString := JavaVM javaStringObjectForString:chars interned:true.

"/constantPool owner == (Java at:'java/awt/Container') ifTrue:[
"/self halt
"/].

        constantPool at:constantPoolIndex put:jString.
        ^ jString.
    ].

    self rememberForResolveWith:'java/lang/String'.
    ^ self

    "Modified: / 07-08-1997 / 21:17:23 / cg"
    "Modified: / 10-08-2011 / 23:28:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUnresolvedStringConstant class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaUnresolvedStringConstant.st,v 1.15 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaUnresolvedStringConstant.st,v 1.15 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

