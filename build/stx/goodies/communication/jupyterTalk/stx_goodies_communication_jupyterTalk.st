"{ Package: 'stx:goodies/communication/jupyterTalk' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_communication_jupyterTalk
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_communication_jupyterTalk class methodsFor:'description'!

excludedFromPreRequisites
    "obsolete; temporarily, this is still called for, but will eventually vanish.
    
     List packages which are to be explicitely excluded from the automatic constructed
     prerequisites lists (both). 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "ArrayedCollection - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:libbasic2'    "UUID - referenced by IPDisplay>>openInJupyter:"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #referencedPrerequisites or #mandatoryPreRequisites."

    ^ #(
    )
! !

!stx_goodies_communication_jupyterTalk class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        CommandLineHandler
        IPDisplay
        IPHMACException
        IPMessageProcessor
        IPMsg
        IPSession
        IPWidget
        IPWidgetRegistry
        IPWireMessage
        IPharoKernel
        SCJsonObject
        #'stx_goodies_communication_jupyterTalk'
        IPCommInfoReplyMsg
        IPCommMsg
        IPDisplayDataMsg
        IPExecuteErrorMsg
        IPExecuteInputMsg
        IPExecuteRequestReplayMsg
        IPIOPubProcessor
        IPIsCompleteReplyMsg
        IPKernelInfoReplyMsg
        IPKernelStatusMsg
        IPShellProcessor
        IPStdInProcessor
        IPStreamMsg
        IPWidgetModel
        IPWidgetView
        IPharoCommandLineHandler
        IPCommCloseMsg
        IPCommOpenMsg
        IPControlProcessor
        IPExecuteResultMsg
        IPExecutionAbortedMsg
        IPExecutionErrorMsg
        IPExecutionOkMsg
        IPKernelStatusBusyMsg
        IPKernelStatusIdleMsg
        IPKernelStatusStartingMsg
        IPUpdateDisplayDataMsg
        (IPMessaggingTest autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        Dictionary asJupyterDataWithExtent:
        IPDisplay extent
        IPDisplay extent:
        IPDisplay initialize
        IPDisplay jupyterData
        IPDisplay maxNumberOfRows
        IPDisplay openInJupyter:
        IPDisplay openInJupyter:extent:
        IPDisplay publish:
        IPDisplay refresh:
        IPSession bindingOf:
        IPSession commCloseMessage
        IPSession commMsgMessage
        IPSession commOpenMessage
        IPSession compileAndEvaluate:
        IPSession defaultNumberOfRows
        IPSession display
        IPSession displayDataMessage
        IPSession doItContext
        IPSession doItReceiver
        IPSession executeErrorMessage
        IPSession executeInputMessage
        IPSession executeResultMessage
        IPSession executionAbortedMessage
        IPSession executionCounter
        IPSession executionErrorMessage
        IPSession executionOkMessage
        IPSession guessTypeForName:
        IPSession hasBindingOf:
        IPSession hasBindingThatBeginsWith:
        IPSession id
        IPSession id:
        IPSession increaseExecutionCounter
        IPSession initialize
        IPSession initializeBindings
        IPSession jupyterData
        IPSession kernelInfoReplayMessage
        IPSession kernelUsername
        IPSession loadScript:
        IPSession resetJupyterData
        IPSession selectedClassOrMetaClass
        IPSession setBindings:
        IPSession startTime
        IPSession startTime:
        IPSession timeout
        IPSession timeout:
        IPSession updateDisplayMessage
        IPSession username
        IPSession username:
        IPharoKernel addCommMsgHandler:toChanel:
        IPharoKernel commChanels
        IPharoKernel commMsgHandlerFor:
        IPharoKernel commMsgHandlers
        IPharoKernel config
        IPharoKernel config:
        IPharoKernel configKernel:
        IPharoKernel connectionStringFor:ip:port:
        IPharoKernel debug:
        IPharoKernel heartbeatThread
        IPharoKernel initialize
        IPharoKernel isStopping
        IPharoKernel newCommChannelFor:
        IPharoKernel port
        IPharoKernel port:
        IPharoKernel processors
        IPharoKernel removeCommMsgHandlersForChanel:
        IPharoKernel sharedKey
        IPharoKernel start
        IPharoKernel stop
        Object asJupyterDataWithExtent:
        SequenceableCollection asJupyterDataWithExtent:
        String asJupyterDataWithExtent:
        'IPDisplay class' cachedObjects
        'IPDisplay class' resetCache
        'IPSession class' currentSession
        'IPSession class' finalizeSession
        'IPSession class' newSessionFor:
        'IPSession class' session:
        'IPharoKernel class' implementation
        'IPharoKernel class' initialize
        'IPharoKernel class' instance
        'IPharoKernel class' new
        'IPharoKernel class' protocolVersion
        'IPharoKernel class' shutDown
        'IPharoKernel class' startUp
        'IPharoKernel class' version
    )
! !

!stx_goodies_communication_jupyterTalk class methodsFor:'description - project information'!

companyName
    "Returns a company string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     Other systems may put it elsewhere, or ignore it."

    ^ 'Claus Gittinger & eXept Software AG'
!

description
    "Returns a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Returns a copyright string which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     Other systems may put it elsewhere, or ignore it."

    ^ 'Copyright Claus Gittinger 2018\nCopyright eXept Software AG 2018'
!

productName
    "Returns a product name which will appear in <lib>.rc.
     Under win32, this is placed into the dll's file-info.
     This method is usually redefined in a concrete application definition"

    ^ 'Smalltalk/X'
! !

!stx_goodies_communication_jupyterTalk class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/stx_goodies_communication_jupyterTalk.st,v 1.9 2018-05-14 00:54:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/stx_goodies_communication_jupyterTalk.st,v 1.9 2018-05-14 00:54:07 cg Exp $'
! !

