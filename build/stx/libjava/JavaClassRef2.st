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

"{ NameSpace: Smalltalk }"

JavaRef2 subclass:#JavaClassRef2
	instanceVariableNames:'nameIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaClassRef2 class methodsFor:'documentation'!

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
!

documentation
"
    A symbolic reference to a class.

    [author:]
        Marcel Hlopko <marcel.hlopko@fit.cvut.cz>
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaClassRef2 class methodsFor:'instance creation'!

in: aJavaConstantPool withNameAt: nameIndex
    ^ self basicNew initializeIn: aJavaConstantPool withNameAt: nameIndex.

    "Created: / 10-05-2011 / 14:56:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 28-09-2012 / 23:01:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'accessing'!

classLoader
    self owner isNil ifTrue:[
        ^ nil
    ] ifFalse:[
        ^ self owner classLoader
    ].

    "Created: / 11-04-2011 / 21:52:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:32:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayString
    ^self name.

    "Created: / 01-11-2011 / 15:29:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fullName

    ^self javaClassName

    "Created: / 08-04-2011 / 13:48:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-05-2011 / 09:59:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 30-10-2011 / 22:00:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClass

    resolvedValue isNil ifTrue:[self resolve: false].
    ^resolvedValue

    "Created: / 22-05-2011 / 14:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2013 / 10:59:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClass: javaClass

    resolvedValue := javaClass.

    "Created: / 12-10-2013 / 15:43:45 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

javaClassName
    "return java class name as written in java programs e.g. java.util.String
     in case of array, return class name without square brackets. For primitive
     types, it returns nil. "
    
    | tmp |

    "/ Argh, this implementation is rubbish!! Use indices to avoid 
    "/ copying strings every now and again.
    tmp := self name copy.
    [ tmp startsWith: '[' ] whileTrue: [ tmp := tmp copyFrom: 2 ].
    tmp size == 1 ifTrue:[ ^ nil ].
    tmp := tmp replaceAll: $/ with: $..
    (tmp startsWith: 'L') ifTrue: [ tmp := tmp copyFrom: 2 to: tmp size ].
    (tmp endsWith: ';') ifTrue: [ tmp := tmp copyFrom: 1 to: tmp size - 1 ].
    ^ tmp.

    "Created: / 08-04-2011 / 18:30:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-05-2011 / 15:30:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 04-10-2013 / 21:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClassNameOrPrimitiveTypeId
    "return java class name as written in java programs e.g. java.util.String
     in case of array, return class name without square brackets."
    
    | tmp |

    "/ Argh, this implementation is rubbish!! Use indices to avoid 
    "/ copying strings every now and again.
    tmp := self name copy.
    [ tmp startsWith: '[' ] whileTrue: [ tmp := tmp copyFrom: 2 ].
    tmp := tmp replaceAll: $/ with: $..
    (tmp startsWith: 'L') ifTrue: [ tmp := tmp copyFrom: 2 to: tmp size ].
    (tmp endsWith: ';') ifTrue: [ tmp := tmp copyFrom: 1 to: tmp size - 1 ].
    ^ tmp.

    "Created: / 05-10-2013 / 01:05:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaName
    ^ self javaClassName
!

name
    ^constantPool at: nameIndex.

    "Created: / 08-04-2011 / 13:48:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-05-2011 / 09:59:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'array support'!

arrayDimensions
    ^ self name occurrencesOf: $[.

    "Created: / 08-04-2011 / 18:42:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-05-2011 / 10:00:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isJavaArrayClassRef
    ^ self name startsWith: '['.

    "Created: / 08-04-2011 / 18:40:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-05-2011 / 10:00:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'comparing'!

= anotherJavaClassRef 
    "superclass JavaRef2 says that I am responsible to implement this method"
    
    anotherJavaClassRef isJavaClassRef ifFalse: [ ^ false ].
    ^ self name = anotherJavaClassRef name.

    "Modified: / 08-04-2011 / 13:48:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

hash
    ^ self name hash.

    "Modified: / 13-05-2011 / 10:00:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'initialization'!

initializeIn: aJavaConstantPool withNameAt: nameCPIndex
    nameIndex := nameCPIndex.
    constantPool := aJavaConstantPool.
    super initialize.

    "Modified: / 10-05-2011 / 14:57:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    self name printOn: aStream.
    aStream nextPut:$).

    "Modified: / 30-10-2011 / 21:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'private - resolving'!

findResolvedStaticValue
    "Resolving static inner classes is not different from resolving any other class, it's only done in different circumstances"
    
    ^ self findResolvedValue.

    "Created: / 28-04-2011 / 21:57:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

findResolvedValue
    "Resolve reference and set valueCache."
    
    self findResolvedValue: true

    "Modified: / 08-04-2011 / 17:39:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-10-2011 / 10:58:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findResolvedValue: doInit
    "Resolve reference and set valueCache."
    
    resolvedValue := JavaResolver uniqueInstance 
                resolveClassIndentifiedByRef: self init: doInit.

    "Modified: / 08-04-2011 / 17:39:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 12-08-2011 / 22:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveForVersionOf: javaObj or: otherJavaObj
    | matchingClass |
    "
    this method is called by the vm when there are multiple
    class versions and we need to get a handle of the correct
    one. javaObj an otherJavaObj contain reference to the 
    object in question, the other one is DUMMYLONGWORD or trash.
    "    
    self findResolvedValue: true.
    matchingClass := javaObj class.
    [ matchingClass notNil and: [ matchingClass name ~= self javaClass name ]] whileTrue: [
        matchingClass := matchingClass superclass.
    ].
    matchingClass isNil ifTrue: [ self error: 'error in get/pufield, object is not of expected type'. ] ifFalse: [
        self javaClass: javaObj class.    
    ].

    "Created: / 13-10-2013 / 12:33:08 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 13-10-2013 / 16:13:51 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'queries'!

isJavaClassRef
    ^true.

    "Created: / 11-04-2011 / 19:10:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 30-08-2013 / 00:42:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRef2 methodsFor:'resolving'!

invalidateForClass: internalJavaClassName 
    "Invalidates receiver iff it refers (even indirectly)
     to a class ref that has been resolved to given class.
     Returns true, if the receiver has been invalidated,
     false otherwise"
    
    self name = internalJavaClassName ifTrue: [
        self invalidate.
        ^ true
    ].
    ^ false.

    "Modified: / 23-05-2011 / 15:21:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 21-02-2012 / 10:21:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassRef2.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

