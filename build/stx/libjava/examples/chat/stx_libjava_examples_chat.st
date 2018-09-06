"{ Package: 'stx:libjava/examples/chat' }"

ApplicationDefinition subclass:#stx_libjava_examples_chat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_libjava_examples_chat class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
    )
!

isGUIApplication
    "return true, if this is a GUI application.
     (these need more libraries and use a different startup procedure)"

    ^ true
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)"

    ^ #(
        #'stx:libbasic'    "ApplicationDefinition - superclass of stx_libjava_examples_chat "
        #'stx:libview2'    "ApplicationModel - superclass of Chat "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic2'    "UUID - referenced by ChatStart class>>applicationUUID "
        #'stx:libjava'    "Java - referenced by ChatStart class>>realMain: "
    )
!

subProjects
    "list packages which are known as subprojects.
     This method is generated automatically; however, when generating automatically,
     packages are only added - never removed, unless listed in #excludedFromSubProjects."

    ^ #(
)
! !

!stx_libjava_examples_chat class methodsFor:'description - compilation'!

additionalRules_bc_dot_mak
    ^ '
java: ant

ant:
        ant -f java\build.xml

antIfPossible:
        -ant -f java\build.xml

full::  ant

$(ZLIB):
        cd $(ZLIB_DIR)
        $(MAKE) $(MAKE_ZLIB_ARG) $(ZLIB)
        cd ..\..\libjava

$(BZ2LIB):
        cd $(BZ2LIB_DIR)
        $(MAKE) $(MAKE_BZ2LIB_ARG) bz2.lib
        cd ..\..\libjava

support\fdlibm\libfdm.lib:
        cd support\fdlibm
        $(MAKE) -f Makefile.bcc
        cd ..\..

'

    "Modified: / 26-02-2013 / 16:51:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    ^ '
java: ant

ant:
        ant -f java/build.xml

antIfPossible:
        -ant -f java/build.xml

full::  ant

zlib:
        cd $(ZLIB_DIR); $(MAKE) $(MAKE_ZLIB_ARG)

support/fdlibm/libfdm.a:
        $(MAKE) CCCONFOPT="$(CCCONFOPT)" -C support/fdlibm

'

    "Modified: / 26-02-2013 / 16:51:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak

    ^ '$(ZLIB) support\fdlibm\libfdm.lib antIfPossible'

    "Modified: / 15-11-2012 / 23:20:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_make_dot_proto

    ^ ' zlib support/fdlibm/libfdm.a antIfPossible'

    "Created: / 05-09-2006 / 16:05:12 / cg"
    "Modified: / 15-11-2012 / 23:20:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_chat class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        Chat
        ChatStart
        ChatWindow
        #'stx_libjava_examples_chat'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libjava_examples_chat class methodsFor:'description - java'!

javaBundle

    ^JavaCodeBundle standardPackageBundleFor: self package

    "
    self javaBundle
    "

    "Created: / 15-01-2013 / 17:35:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 24-09-2013 / 00:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_chat class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'SWING Research Group'

    "Modified: / 23-09-2013 / 22:30:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Very Simple Jabber Client'

    "Modified: / 23-09-2013 / 22:30:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany 2013'

    "Modified: / 23-09-2013 / 22:29:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Chat'

    "Modified: / 23-09-2013 / 22:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava_examples_chat class methodsFor:'description - startup'!

startupClassName
    "the class that starts the show in its startupSelector method"

    ^ 'ChatStart'
!

startupSelector
    "the message that is sent to the startupClass to start the show"

    ^ #'start'        
! !

!stx_libjava_examples_chat class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

