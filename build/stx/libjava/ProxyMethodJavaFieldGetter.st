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

ProxyMethodJavaFieldAccessor subclass:#ProxyMethodJavaFieldGetter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Interop'
!

!ProxyMethodJavaFieldGetter class methodsFor:'documentation'!

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

!ProxyMethodJavaFieldGetter methodsFor:'evaluating'!

evaluateWithReceiver:receiver arguments:arguments 
    | value |

    self assert:arguments isEmpty.
    value := receiver instVarAt:field index.
    ^ self fieldType javaUnwrap:value

    "Modified: / 26-07-2016 / 11:44:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaFieldGetter methodsFor:'generating'!

generate:compiler
    | valueNode |

    valueNode := (VariableNode type: #InstanceVariable name: field name)
                    index: field index.
    ^ MessageNode receiver: (VariableNode globalNamed: self fieldType name)
                  selector: #javaUnwrap:
                       arg: valueNode

    "Modified: / 26-07-2016 / 11:43:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaFieldGetter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodJavaFieldGetter.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

