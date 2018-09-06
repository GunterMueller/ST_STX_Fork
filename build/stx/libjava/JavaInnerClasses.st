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

Array variableSubclass:#JavaInnerClasses
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

Object subclass:#Entry
	instanceVariableNames:'innerClassRefIndex outerClassRefIndex nameIndex accessFlags'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaInnerClasses
!

!JavaInnerClasses class methodsFor:'documentation'!

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
    Instances of this class represent the InnerClasses attribute of a class.

    From JVM Spec:
    The InnerClasses attribute has the following format:

    InnerClasses_attribute {
        u2 attribute_name_index;
        u4 attribute_length;
        u2 number_of_classes;
        {
            u2 inner_class_info_index;
            u2 outer_class_info_index;
            u2 inner_name_index;
            u2 inner_class_access_flags;
        } classes[number_of_classes];
    }

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        JVM Spec, 4rd Edition, sec 4.7.6 The InnerClasses Attribute

"
! !

!JavaInnerClasses::Entry methodsFor:'accessing'!

accessFlags
    ^ accessFlags
!

innerClassRefIndex
    ^ innerClassRefIndex
!

innerClassRefIndex:something
    innerClassRefIndex := something.
!

nameIndex
    ^ nameIndex
!

nameIndex:something
    nameIndex := something.
!

outerClassRefIndex
    ^ outerClassRefIndex
!

outerClassRefIndex:something
    outerClassRefIndex := something.
! !

!JavaInnerClasses::Entry methodsFor:'initialization'!

setAccessFlags: anInteger
    accessFlags := anInteger

    "Created: / 16-10-2013 / 09:24:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setInnerClassRefIndex:aJavaClassRef 
    innerClassRefIndex := aJavaClassRef

    "Created: / 16-10-2013 / 09:22:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setNameIndex: aString
    nameIndex := aString

    "Created: / 03-12-2014 / 14:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setOuterClassRefIndex:aJavaClassRef 
    outerClassRefIndex := aJavaClassRef

    "Created: / 16-10-2013 / 09:22:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaInnerClasses class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

