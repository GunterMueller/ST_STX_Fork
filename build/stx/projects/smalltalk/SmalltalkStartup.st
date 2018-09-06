"
 COPYRIGHT (c) 2016 Jan Vrany <jan.vrany@fit.cvut.cz>
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:projects/smalltalk' }"

"{ NameSpace: Smalltalk }"

StandaloneStartup subclass:#SmalltalkStartup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

!SmalltalkStartup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
               2016-now by Jan Vrany <jan.vrany@fit.cvut.cz>
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
    Smalltalk/X IDE startup.

    For historical reasons, IDE startup is not actually implemented as
    a StandaloneStartup class as for Smalltalk/X-based applications.
    Instead, the Smalltalk>>start reads smalltalk.rc and startup procedure
    is defined there.

    In order to reduce a number of .rc script hackery, functionality will be
    incrementally moved from those scripts to this class and scripts will be
    changed to call methods in this class. Eventually we will reach the point
    when scripts will be empty and all functionality will be here. Let's hope.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkStartup class methodsFor:'startup-to be redefined'!

main:argv

    "/ Due to a historical reasons (see this class's comment), this 
    "/ method is called from `smalltalk.rc` startup script manually. 
    "/ Hopefully at some point we will move all the code from there
    "/ to here. Hopefully...

    | optparser unparsed |

    optparser := CmdLineParser new.
    optparser ignoreUnknownOptions: true.
    optparser on:#('--package-path PATH') do:[:pp |  
        (pp asCollectionOfSubstringsSeparatedBy: OperatingSystem pathSeparator) reverseDo:[:e |
            Smalltalk packagePath addFirst: e  
        ]
    ].
    unparsed := optparser parse: argv.
    argv isOrderedCollection ifTrue:[
        argv removeAll; addAll: unparsed.
    ].

    "/ Ask user to accept 'Smalltalk/X Software Licence Agreement'. 
    "/ This could be suppressed with a command-line argument;
    "/ however, if you do so, we assume you have read & accepted it at least
    "/ once (since this command-line-argument is not documented, you obviously
    "/ read the code below).        
    (argv includesAny: #('--noLicenceBox' '--quick' '--faststart' '--fastStart')) ifFalse:[
        Smalltalk addStartBlock:[                            
        	self acceptLicense 
        ].
    ]

    "
    SmalltalkStartup main: #('-I' '--quick' '--package-path' '/home/some/packages') asOrderedCollection.
    Smalltalk packagePath
    "

    "Created: / 28-06-2016 / 23:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-12-2016 / 00:02:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkStartup class methodsFor:'startup-utilities'!

acceptLicense
    "
    Ask user to accept 'Smalltalk/X Software Licence Agreement'. If rejected,
    exit.

    You may find this annoying - but lawers say: 'this is a must ...' ;-)
    License Agreement is shown only once.
    "

    | licenseAcceptedFile |

    licenseAcceptedFile := Filename homeDirectory / '.smalltalk' / '.license-accepted'.

    (Smalltalk isStandAloneApp or:[ Smalltalk isPlugin or:[ Display isNil]]) ifTrue:[ 
        ^ self
    ].

    licenseAcceptedFile exists ifTrue:[ 
        "/ License has been already accepted, don't dhow it again
        ^ self 
    ].
    LicenceBox autoload.
    [
       | licenseAcceptedDir |

	   Display exitOnLastClose:false.
       (LicenceBox open) ifFalse:[
           Smalltalk exit
       ].              
       licenseAcceptedDir := licenseAcceptedFile directory.
       licenseAcceptedDir exists ifFalse:[
           licenseAcceptedDir recursiveMakeDirectory.
       ].
       licenseAcceptedDir isWritable ifTrue:[
           licenseAcceptedFile writingFileDo:[ :s| s nextPutLine: 'accepted' ]
       ].
    ] on: LicenceBox licenceRejectSignal do:[ 
        Smalltalk exit
    ] on: Error do:[
        "/ Ignore this, but user will be acc
    ].

    "
    SmalltalkStartup acceptLicense
    "

    "Created: / 30-12-2016 / 23:41:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkStartup class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

