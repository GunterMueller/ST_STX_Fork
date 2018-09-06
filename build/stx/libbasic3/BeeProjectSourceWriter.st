"
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

BeeProjectWriter subclass:#BeeProjectSourceWriter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes-Support'
!

!BeeProjectSourceWriter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    A writer to write Smalltalk/X package in Bee Smalltalk format (.stp). Usage:

    BeeProjectSourceWriter fileOut: 'jv:calipel/s' to: '/tmp/jv-calipel-s.stp'

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!BeeProjectSourceWriter methodsFor:'source writing'!

fileOutClasses: classes on: stream
    | classesToFileout writer |

    stream nextPutAll: '"**** Class definitions ****"!!'; cr.

    classesToFileout := classes reject:[:cls | cls isSubclassOf: ProjectDefinition ].
    classesToFileout topologicalSort:[:a :b | b isSubclassOf:a].

    classesToFileout do:[:cls | 
        cls isPrivate ifTrue:[
            self error:'Cannot file out private class: ',cls name.
        ].
    ].  

    writer := BeeSourceWriter new.
    classesToFileout do:[:class |
        self activityNotification:'exporting ', class name,'...'.
        writer fileOut:class on:stream withTimeStamp:false withInitialize:false withDefinition:true methodFilter:[:m | false]
    ].
    classesToFileout do:[:class |
        self activityNotification:'exporting ', class name,'...'.
        writer fileOut:class on:stream withTimeStamp:false withInitialize:false withDefinition:false methodFilter:[:m | 
            | who |

            who := m who.
            (who methodClass isMetaclass and:[ who methodSelector == #copyright ]) not
                and:[ (AbstractSourceCodeManager isVersionMethodSelector: who methodSelector) not ]
        ]
    ].

    "Created: / 14-04-2015 / 13:47:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 15:50:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutExtensions: methods on:stream
    | writer |

    writer := BeeSourceWriter new.
    self activityNotification:'exporting extensions...'.
    methods do:[:eachMethod |
        writer fileOutMethods:methods on:stream.
        stream cr.
    ]

    "Modified: / 14-04-2015 / 13:51:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutHeaderOn: aStream

    aStream nextPutAll:(
'"
        __________________________________________________
        Author: %(AUTHOR).
        Project name: %(NAME)
        Version: %(VERSION)
        Timestamp: %(TIMESTAMP)
        Description: %(DESCRIPTION)
        __________________________________________________
"

' bindWithArguments: self mappings)

    "Created: / 14-04-2015 / 13:42:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2015 / 19:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BeeProjectSourceWriter methodsFor:'utilities'!

ensureNoUnicodeInClass:aClass
    "/ check if we need UTF8 encoding
    aClass withAllPrivateClasses do:[:cls |
         cls instAndClassMethods contains:[:m |
            self ensureNoUnicodeInMethod:m
         ]
    ].
!

ensureNoUnicodeInMethod:aMethod
    |src|

    src := aMethod source.
    src isNil ifTrue:[
        self error:'missing source in ',aMethod whoString
    ].
    src asSingleByteStringIfPossible isWideString ifTrue:[
        self error:(aMethod whoString , ' contains unicode strings or character contants. Cannot be exported to VSE')
    ].
! !

