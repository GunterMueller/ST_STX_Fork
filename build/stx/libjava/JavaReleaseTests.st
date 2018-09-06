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

TestCase subclass:#JavaReleaseTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaReleaseTests class methodsFor:'documentation'!

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

!JavaReleaseTests methodsFor:'tests'!

test_display_string_known_java_home
    | release expectedString actualString |

    expectedString := 'Open JDK 6 (JRE) ', '- some_path_which_does_not_exist'.

    release := JavaRelease::OpenJDK6 new.
    release javaHome: 'some_path_which_does_not_exist'.              
    actualString := release displayString string.    
    
    self assert: expectedString = actualString

    "Created: / 07-12-2014 / 13:38:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 08:55:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_display_string_unknown_java_home
    | release expectedString actualString |

    expectedString := 'Open JDK 6 - not found'.

    [ 
        MessageTracer mock: #searchForJavaHome in: JavaRelease do:[ :receiver | nil ].
        release := JavaRelease::OpenJDK6 new.    
        actualString := release displayString string.    
        self assert: expectedString = actualString
    ] ensure:[ 
        MessageTracer unmock: #searchForJavaHome in: JavaRelease.
    ].

    "Modified: / 07-12-2014 / 13:37:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 08:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_linux_OpenJDK_1_6_0_30_jdk

    | java_home |

    java_home :=  #(
            '/usr/lib/jvm/java-6-openjdk-i386' 
            '/usr/lib/jvm/java-6-openjdk-amd64'
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home).
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.          

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK6))

    "Created: / 03-04-2014 / 12:50:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:05:06 / jv"
!

test_linux_OpenJDK_1_6_0_30_jre

   | java_home |

    java_home :=  #(
            '/usr/lib/jvm/java-6-openjdk-i386/jre' 
            '/usr/lib/jvm/java-6-openjdk-amd64/jre'
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home).
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.          

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK6))

    "Created: / 03-04-2014 / 12:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:05:00 / jv"
!

test_linux_OpenJDK_1_7_0_51_jdk

    | java_home |

    java_home :=  #(
            '/usr/lib/jvm/java-7-openjdk-amd64' 
            '/usr/lib/jvm/java-7-openjdk-i386'
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.          

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK7))

    "Created: / 03-04-2014 / 12:54:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:54 / jv"
!

test_linux_OpenJDK_1_7_0_51_jre

    | java_home |

    java_home :=  #(
            '/usr/lib/jvm/java-7-openjdk-amd64/jre' 
            '/usr/lib/jvm/java-7-openjdk-i386/jre'
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.          

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK7))

    "Created: / 03-04-2014 / 12:54:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:48 / jv"
!

test_linux_OracleJDK_1_7_0_13_jdk

    | java_home |

    java_home :=  #(
            '/opt/jdk1.7.0_13' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.          

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK7))

    "Created: / 03-04-2014 / 14:09:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:39 / jv"
!

test_linux_OracleJDK_1_7_0_13_jre

    | java_home |

    java_home :=  #(
            '/opt/jdk1.7.0_13/jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.          

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK7))

    "Created: / 03-04-2014 / 13:04:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:32 / jv"
!

test_linux_OracleJDK_1_8_0_jdk

    | java_home |

    java_home :=  #(
            '/opt/jdk1.8.0' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 03-04-2014 / 14:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:22 / jv"
!

test_linux_OracleJDK_1_8_0_jre

    | java_home |

    java_home :=  #(
            '/opt/jdk1.8.0/jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 03-04-2014 / 14:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:18 / jv"
!

test_linux_Zulu_7

    | java_home |

    java_home :=  #(
            '/usr/lib/jvm/zulu-7-amd64' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home).
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::Zulu7))

    "Created: / 11-03-2015 / 11:39:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_liux_Zulu_8

    | java_home |

    java_home :=  #(
            '/usr/lib/jvm/zulu-8-amd64'   
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home).

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::Zulu8))

    "Created: / 11-03-2015 / 11:39:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_windows_OracleJDK_1_6_0_34_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.6.0_34' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK6))

    "Created: / 03-04-2014 / 16:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:10 / jv"
!

test_windows_OracleJDK_1_6_0_34_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.6.0_34\jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK6))

    "Created: / 03-04-2014 / 16:45:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:04:05 / jv"
!

test_windows_OracleJDK_1_6_0_45_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.6.0_45' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK6))

    "Created: / 20-02-2015 / 14:41:29 / jv"
    "Modified: / 11-03-2015 / 11:04:01 / jv"
!

test_windows_OracleJDK_1_6_0_45_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.6.0_45\jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OpenJDK6))

    "Created: / 20-02-2015 / 14:41:38 / jv"
    "Modified: / 11-03-2015 / 11:03:55 / jv"
!

test_windows_OracleJDK_1_7_0_13_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.7.0_13'  
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK7))

    "Created: / 03-04-2014 / 16:50:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:03:48 / jv"
!

test_windows_OracleJDK_1_7_0_13_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.7.0_13'  
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK7))

    "Created: / 03-04-2014 / 16:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:03:41 / jv"
!

test_windows_OracleJDK_1_7_0_75_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.7.0_76'  
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK7))

    "Created: / 13-03-2015 / 16:02:03 / jv"
!

test_windows_OracleJDK_1_7_0_76_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.7.0_76'  
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home).
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK7))

    "Created: / 13-03-2015 / 16:02:22 / jv"
!

test_windows_OracleJDK_1_8_0_05_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.8.0_05' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 20-02-2015 / 14:40:47 / jv"
    "Modified: / 11-03-2015 / 11:03:31 / jv"
!

test_windows_OracleJDK_1_8_0_05_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.8.0_05\jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 20-02-2015 / 14:41:02 / jv"
    "Modified: / 11-03-2015 / 11:03:26 / jv"
!

test_windows_OracleJDK_1_8_0_40_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.8.0_40' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 13-03-2015 / 16:03:00 / jv"
!

test_windows_OracleJDK_1_8_0_40_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.8.0_40\jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 13-03-2015 / 16:03:19 / jv"
!

test_windows_OracleJDK_1_8_0_jdk

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.8.0' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      
    

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 03-04-2014 / 17:03:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:03:20 / jv"
!

test_windows_OracleJDK_1_8_0_jre

    | java_home |

    java_home :=  #(
            'C:\Program Files\Java\jdk1.8.0\jre' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home).

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.      

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::OracleJDK8))

    "Created: / 03-04-2014 / 17:04:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-03-2015 / 11:03:13 / jv"
!

test_windows_Zulu_7

    | java_home |

    java_home :=  #(
            'C:\Program Files\Zulu\zulu-7' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home).
    self assert: (JavaRelease zulu8 validateJavaHome: java_home) not.

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::Zulu7))

    "Created: / 11-03-2015 / 11:02:50 / jv"
!

test_windows_Zulu_8

    | java_home |

    java_home :=  #(
            'C:\Program Files\Zulu\zulu-8' 
            ) detect:[:each | each asFilename exists ] ifNone:[ nil ].

    java_home notNil ifTrue:[ java_home := java_home asFilename ].                
    self 
        skipIf:  (java_home isNil or:[ java_home exists not ])
        description: ('Directory does not exist (%1)' bindWith:(java_home notNil 
                                   ifTrue:[ java_home pathName ]
                                   ifFalse:[ 'nil' ])).     

    self assert: (JavaRelease openJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease openJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease oracleJDK6 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK7 validateJavaHome: java_home) not.
    self assert: (JavaRelease oracleJDK8 validateJavaHome: java_home) not.

    self assert: (JavaRelease zulu7 validateJavaHome: java_home) not.
    self assert: (JavaRelease zulu8 validateJavaHome: java_home).

    self assert: ((JavaRelease inDirectory: java_home) isKindOf: (JavaRelease::Zulu8))

    "Created: / 11-03-2015 / 11:02:11 / jv"
! !

!JavaReleaseTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

