"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

Object subclass:#URITransmissionService
	instanceVariableNames:'transmissions timerProcess transmissionsCriticalSema onErrorBlock
		fileName fileModificationTime monitoring transmissionInfoHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-URI'
!

!URITransmissionService class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    documentation to be added.

    [author:]
        Timo Merkert (tm@asterix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
                                                                [exBegin]
    |description transmissions service|

    description := 'file:/tmp/test/transmission.txt  
                    file:/home/tm/tmp/transmission.txt  
                    file:/home/tm/tmp/sent' 
                    asCollectionOfWords.

    service := URITransmissionService new.
    service transmissions:transmissions.
    service onErrorBlock:[:ex| Transcript showCR:ex description ].
    service transmissionInfoHolder:[:info| Transcript showCR:info value]
    service startService.
    Delay waitForSeconds:10. 
    service terminateService.
                                                                [exEnd]


                                                                [exBegin]
    |service|

    service := self fromString:'file:/phys/exept/home/tm/tmp  /home/tm/test' 
                onErrorHandle:[:ex| Transcript showCR:ex description ]
                transmissionInfoHolder:[:info| Transcript showCR:info value].
    Delay waitForSeconds:30. 
    service terminateService.
                                                                [exEnd]


                                                                [exEnd]
    |service|

    service := self fromFile:'/home/tm/pcsmd/config/fileTransmission/serviceConfiguration' 
                monitoring:true 
                onErrorHandle:[:ex| Transcript showCR:ex description ]
                transmissionInfoHolder:[:info| Transcript showCR:info value].
    Delay waitForSeconds:30. 
    service terminateService.
                                                                [exEnd]
"
! !

!URITransmissionService class methodsFor:'instance creation'!

fromFile:aFileName monitoring:aBoolean onErrorHandle:anErrorHandleBlock

    ^ self fromFile:aFileName 
        monitoring:aBoolean 
        onErrorHandle:anErrorHandleBlock 
        transmissionInfoHolder:ValueHolder new

"
    self fromFile:'/home/tm/pcsmd/config/fileTransmission/serviceConfiguration' 
    monitoring:false 
    onErrorHandle:[:ex| Transcript showCR:ex description ]
"
!

fromFile:aFileName monitoring:aBoolean onErrorHandle:anErrorHandleBlock transmissionInfoHolder:aTransmissionInfoHolder

    |service|

    service := self new.
    service onErrorBlock:anErrorHandleBlock.
    service transmissionInfoHolder:aTransmissionInfoHolder.
    service fileName:aFileName asFilename.
    service monitoring:aBoolean.
    service startService.
    ^ service

"
    self fromFile:'/home/tm/pcsmd/config/fileTransmission/serviceConfiguration' 
    monitoring:true 
    onErrorHandle:[:ex| Transcript showCR:ex description ]
    transmissionInfoHolder:[:info| Transcript showCR:info ]
"
!

fromFile:aFileName onErrorHandle:anErrorHandleBlock transmissionInfoHolder:aTransmissionInfoHolder

    ^ self fromFile:aFileName 
        monitoring:true 
        onErrorHandle:anErrorHandleBlock 
        transmissionInfoHolder:aTransmissionInfoHolder

"
    self fromFile:'/home/tm/pcsmd/config/fileTransmission/serviceConfiguration' 
    onErrorHandle:[:ex| Transcript showCR:ex description ]
    transmissionInfoHolder:[:info| Transcript showCR:info ]
"
!

fromString:aString onErrorHandle:anErrorHandleBlock transmissionInfoHolder:aTransmissionInfoHolder

    |transmission service|

    service := self new.
    [
        transmission := URITransmission fromString:aString.
    ] on:Error do:[:ex| 
        anErrorHandleBlock value:ex 
    ].
    transmission isNil ifTrue:[ ^ nil ].
    service onErrorBlock:anErrorHandleBlock.
    service transmissionInfoHolder:aTransmissionInfoHolder.
    service transmissions:(OrderedCollection with:transmission).
    service startService.
    ^ service

"
    self fromString:'file:/phys/exept/home/tm/tmp  file:/home/tm/test' 
    onErrorHandle:[:ex| Transcript showCR:ex description ]
    transmissionInfoHolder:[:info| Transcript showCR:info value ]
"
! !

!URITransmissionService class methodsFor:'default settings'!

secondsForTimerAction
    "Returnd the seconds about the interval refered to the timer action"

    ^ 60
! !

!URITransmissionService class methodsFor:'reading'!

transmissionListFromFile:aFileName

    ^ self transmissionListFromFile:aFileName onError:[:idx :line :aFileName|
        self error:('Faulty line:%1\in:%2' bindWith:idx with:aFileName asString) withCRs
             mayProceed:true.
    ].
!

transmissionListFromFile:aFileName onError:aThreArgBlock

    |file list descriptions|

    list := OrderedCollection new.
    file := aFileName asFilename.
    file exists ifFalse:[ ^ list ].

    descriptions := file contents. "/ list of Strings
    descriptions keysAndValuesDo:[:idx :eachLine| |transmission|
        (eachLine size == 0 or:[eachLine startsWith:$#]) ifTrue:[
            "add empty line or comment"
            list add:eachLine.
        ] ifFalse:[ 
            transmission := URITransmission 
                fromString:eachLine 
                onError:[aThreArgBlock value:idx value:eachLine value:aFileName asString.
                         nil].
            transmission notNil ifTrue:[
                list add:transmission
            ].
        ].
    ].

    ^ list

"
    |list|

    Error handle:[:ex| self halt.
        Transcript showCR:ex description.
        ex proceed.
    ] do:[
        list := self transmissionListFromFile:'~/pcsmd/config/fileTransfer'
    ].
    list
"
! !

!URITransmissionService methodsFor:'accessing'!

fileName
    "return the value of the instance variable 'fileName' (automatically generated)"

    ^ fileName
!

fileName:aFileName
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := aFileName asFilename.
    self evaluateFile.
!

monitoring
    "return the value of the instance variable 'monitoring' (automatically generated)"

    ^ monitoring ? false
!

monitoring:aBoolean
    "if true; 
     reset transmissions read from fileName,
     after each processing-loop about the transmissions"

    monitoring := aBoolean.
!

onErrorBlock
    "get the value of the instance variable 'errorHandler' (automatically generated)"

    onErrorBlock isNil ifTrue:[
        onErrorBlock := [:err| err errorPrintCR ]
    ].

    ^ onErrorBlock
!

onErrorBlock:aOneArgBlock
    "set the value of the instance variable 'errorHandler' (automatically generated)"

    onErrorBlock := aOneArgBlock.
!

timerProcess
    "return the value of the instance variable 'timerProcess' (automatically generated)"

    ^ timerProcess
!

transmissionInfoHolder:aValueHolder
    "set the value of the instance variable 'transmissionInfoHolder' (automatically generated)"

    transmissionInfoHolder := aValueHolder.
!

transmissions
    "return the value of the instance variable 'transmissions' (automatically generated)"

    ^ transmissions
!

transmissions:aTransmissionList
    "set the value of the instance variable 'transmissions' (automatically generated)"

    self transmissionsCriticalDo:[
        transmissions := aTransmissionList.
        transmissions do:[:aTr| 
            aTr infoChannel:transmissionInfoHolder
        ].
    ].
! !

!URITransmissionService methodsFor:'processing'!

doTimerActions

    |now finished|

    finished := OrderedCollection new.
    self transmissionsCriticalDo:[
        now := Timestamp now.
        (self monitoring and:[ fileName notNil ]) ifTrue:[
            self evaluateFile
        ].
        transmissions keysAndValuesDo:[:idx :aTransmission| |timeStamp|
            timeStamp := aTransmission activeTime.
            ((aTransmission interval isNil or:[aTransmission interval > 0]) 
             and:[timeStamp isNil or:[ timeStamp <= now ]]) ifTrue:[
                Error handle:[:ex| 
                    self onErrorBlock value:idx value:ex.
                ] do:[ 
                    aTransmission doCommit.
                    aTransmission interval notNil ifTrue:[
                        aTransmission advanceFrom:now.
                    ] ifFalse:[
                        finished add:aTransmission
                    ].
                ].
            ].
        ].

        finished size ~~ 0 ifTrue:[
            transmissions removeAll:finished.
            transmissions size == 0 ifTrue:[
                self monitoring ifFalse:[
                    self terminateService 
                ].
            ].
        ].
    ].
!

startService
    "start a sub-process to invoke timer actions cyclic here" 

    timerProcess isNil ifTrue:[
        timerProcess := [
            [   
                "/ do not invoke timer methods from here -
                "/ add them to the corresponding doXXXActions method.
                "/ (this allows the program to be changed while running,
                "/  without a need to restart the timerProcess)

                [
                    self doTimerActions. "/ the action methode
                    Delay waitForSeconds:self class secondsForTimerAction.
                ] loop.
            ] ifCurtailed:[ timerProcess := nil ].
        ] newProcess.
        timerProcess priority:(Processor userSchedulingPriority).
        timerProcess name:'URI-Transmission Service'.
    ].
    timerProcess resume

    "
        URITransmissionService new startService
    "
!

terminateService
    "terminate the sub-process about the timer actions" 

    |task|

    (task := timerProcess) notNil ifTrue:[
        task terminate
    ].

    "
        URITransmissionService new terminateService
    "
!

transmissionsCriticalDo:aBlock
    "do operate with RecursionLock on transmissions"

    transmissionsCriticalSema isNil ifTrue:[
        transmissionsCriticalSema := RecursionLock new.
        transmissionsCriticalSema name:'URI-Transmissions lock'.
    ].
    ^ transmissionsCriticalSema critical:aBlock
! !

!URITransmissionService methodsFor:'queries'!

state

    (timerProcess notNil and:[ timerProcess isDead not ]) ifTrue:[
        ^ timerProcess state
    ].

    ^ #inActive
! !

!URITransmissionService methodsFor:'validation'!

evaluateFile

    |modified list|

    modified := fileName modificationTime.
    (modified isNil or:[
     fileModificationTime isNil or:[
     fileModificationTime < modified]]) ifFalse:[
        "ignore non-existing files or files not due to be evaluated"
        ^ self
    ].

    Error handle:[:ex| 
        onErrorBlock value:nil value:ex.
        ex proceed.
    ] do:[
        list := self class transmissionListFromFile:fileName
    ].

    self transmissions:(list select:[:eachElement| eachElement isString not]).
    fileModificationTime := modified.
! !

!URITransmissionService class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/URITransmissionService.st,v 1.20 2010-08-13 13:57:03 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/URITransmissionService.st,v 1.20 2010-08-13 13:57:03 stefan Exp $'
! !
