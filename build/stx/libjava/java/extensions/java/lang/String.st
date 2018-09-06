"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.lang.String') class methodsFor:'queries'!

javaWrap: object
    | jstring |

    object isNil ifTrue:[ ^ nil ].
    jstring := self basicNew.
    jstring perform: #'<init>([C)V' with: object.
    ^jstring
! !
!(Java classForName:'java.lang.String') class methodsFor:'queries'!

javaWrapRequired
    "Returns true, if a #javaWrap: has to be called
     prior an instance of Smalltalk object is passed 
     as an argument to Java method, whoose formal tyoe
     is the receiver."

    ^true
! !
