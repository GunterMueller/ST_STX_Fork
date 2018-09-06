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

ProxyMethodJavaFieldAccessor subclass:#ProxyMethodJavaFieldSetter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Interop'
!

!ProxyMethodJavaFieldSetter class methodsFor:'documentation'!

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

!ProxyMethodJavaFieldSetter methodsFor:'evaluating'!

evaluateWithReceiver:receiver arguments:arguments
    field isFinal ifTrue:[ 
        NoModificationError raiseErrorString:'Field ', field name , ' is final'.
    ].
    self assert: arguments size == 1.
    ^receiver instVarAt: field index put: arguments first.

    "Modified: / 26-07-2016 / 20:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaFieldSetter methodsFor:'generating'!

generate:compiler
    "Generate a ParseNode that evaluate myself. Used for
     byte-compiling the proxies"

    | valueNode |

    field isFinal ifTrue:[ 
        ^ MessageNode receiver: (VariableNode globalNamed: NoModificationError name)
                      selector: #raiseErrorString:
                           arg: (ConstantNode value: 'Field ', field name , ' is final')          
    ].
    valueNode := MessageNode receiver: (VariableNode globalNamed: self fieldType name)
                  selector: #javaWrap:
                       arg: (compiler args at: 1).
    ^ AssignmentNode 
        variable: ((VariableNode type: #InstanceVariable name: field name)
                    index: field index)
      expression:  valueNode

    "Modified: / 26-07-2016 / 20:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProxyMethodJavaFieldSetter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/ProxyMethodJavaFieldSetter.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

