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

TestCase subclass:#JavaUTF8Tests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaUTF8Tests class methodsFor:'documentation'!

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

!JavaUTF8Tests methodsFor:'loadingTests'!

test_S1
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[97 98 99 100] asString.

    self assert: string = 'abcd'

    "Created: / 04-08-2014 / 11:25:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S10
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[97 98 99 100 192 128] asString.

    self assert: string size = 5.
    self assert: string fifth  codePoint = 16r0000.

    "Created: / 04-08-2014 / 11:45:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S11
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[194 128 97 98 99 100] asString.

    self assert: string size = 5.
    self assert: string first codePoint = 16r0080.

    "Created: / 04-08-2014 / 11:45:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S12
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[97 98 99 100 224 160 128] asString.

    self assert: string size = 5.
    self assert: string fifth codePoint = 16r0800.

    "Created: / 04-08-2014 / 11:45:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S13
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[224 160 128 97 98 99 100] asString .

    self assert: string size = 5.
    self assert: string first codePoint = 16r0800.

    "Created: / 04-08-2014 / 11:46:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S14
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[97 98 99 100 222 170 239 190 170] asString .

    self assert: string size = 6.
    self assert: string fifth codePoint = 16r07AA.
    self assert: string sixth codePoint = 16rFFAA.

    "Created: / 04-08-2014 / 11:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S15
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[222 170 239 190 170 97 98 99 100] asString.

    self assert: string size = 6.
    self assert: string first codePoint = 16r07AA.
    self assert: string second codePoint = 16rFFAA.

    "Created: / 04-08-2014 / 11:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S2
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[1 127] asString.

    self assert: string size = 2.
    self assert: string first  codePoint = 1.
    self assert: string second codePoint = 16r7F.

    "Created: / 04-08-2014 / 11:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S3
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[192 128] asString.

    self assert: string size = 1.
    self assert: string first  codePoint = 16r0000.

    "Created: / 04-08-2014 / 11:27:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S4
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[194 128] asString .

    self assert: string size = 1.
    self assert: string first  codePoint = 16r0080.

    "Created: / 04-08-2014 / 11:27:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S5
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[192 128 194 128] asString .

    self assert: string size = 2.
    self assert: string first  codePoint = 16r0000.
    self assert: string second codePoint = 16r0080.

    "Created: / 04-08-2014 / 11:28:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S6
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[223 191] asString  .

    self assert: string size = 1.
    self assert: string first  codePoint = 16r07FF.

    "Created: / 04-08-2014 / 11:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S7
    
    | string |

    string := CharacterArray decodeFromJavaUTF8:#[224 160 128] asString .

    self assert: string size = 1.
    self assert: string first  codePoint = 16r0800.

    "Created: / 04-08-2014 / 11:30:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:47:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S8
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[239 191 191] asString.

    self assert: string size = 1.
    self assert: string first  codePoint = 16rFFFF.

    "Created: / 04-08-2014 / 11:30:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:48:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_S9
    
    | string |

    string := CharacterArray decodeFromJavaUTF8: #[224 160 128 239 191 191] asString.

    self assert: string size = 2.
    self assert: string first  codePoint = 16r0800.
    self assert: string second codePoint = 16rFFFF.

    "Created: / 04-08-2014 / 11:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUTF8Tests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaUTF8Tests.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

