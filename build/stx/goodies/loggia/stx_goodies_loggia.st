"
 Copyright (c) 2005-2010 Martin Dvorak and Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_loggia
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_loggia class methodsFor:'documentation'!

copyright
"    
 Copyright (c) 2005-2010 Martin Dvorak and Jan Vrany

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"    
    Package documentation:
    
    a flexible logger package.
    Set the global Logger to one of my logger instances,
    for various difference logging options, from
    null-logger (not loggin at all), to file-writing loggers,
    to mail-sending loggers with a lot of additional information (stack traces etc.)
    Some are unfinished (SMSLogger), but presented as guideline.
"
! !

!stx_goodies_loggia class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

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
        #'stx:libbasic'    "GenericException - superclass of Loggia::HaltingTransport::HaltingTransportException"
        #'stx:libboss'    "BinaryIOManager - superclass of Loggia::BOSSFileTransport::BinaryFileWriter"
        #'stx:libtool'    "AbstractSettingsApplication - superclass of Loggia::LoggiaSettingsApplication"
        #'stx:libview2'    "ApplicationModel - superclass of Loggia::AbstractUI"
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
        #'stx:goodies/communication'    "SMTPClient - referenced by Loggia::MailTransport>>sendMessages:"
        #'stx:libbasic2'    "IPSocketAddress - referenced by Loggia::SyslogTransport>>initialize"
        #'stx:libview'    "Color - referenced by Loggia::FacilitiesUI class>>severityColors"
        #'stx:libwidg2'    "TabItem - referenced by Loggia::LoggiaUI class>>tabList"
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

!stx_goodies_loggia class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Loggia::AbstractUI'
        #'Loggia::LogLevels'
        #'Loggia::LogOriginatorProxy'
        #'Loggia::LogTransport'
        #'Loggia::LoggiaSettingsApplication'
        #'stx_goodies_loggia'
        #'Loggia::BOSSFileTransportUI'
        #'Loggia::CustomBlockTransport'
        #'Loggia::CustomBlockTransportUI'
        #'Loggia::DirectoryTransport'
        #'Loggia::DirectoryTransportUI'
        #'Loggia::FacilitiesUI'
        #'Loggia::FileTransport'
        #'Loggia::HaltingTransport'
        #'Loggia::InMemoryTransport'
        #'Loggia::InMemoryTransportUI'
        #'Loggia::LogFacility'
        #'Loggia::LogLevel'
        #'Loggia::LogMessage'
        #'Loggia::LogMessagesBrowserUI'
        #'Loggia::Logger'
        #'Loggia::LoggiaUI'
        #'Loggia::MailTransport'
        #'Loggia::MailTransportUI'
        #'Loggia::MultiplexTransport'
        #'Loggia::MultiplexTransportUI'
        #'Loggia::NullTransport'
        #'Loggia::PlainFileTransportUI'
        #'Loggia::SMSTransport'
        #'Loggia::SyslogTransport'
        #'Loggia::SyslogTransportUI'
        #'Loggia::TranscriptTransport'
        #'Loggia::TransportsUI'
        #'Loggia::BOSSFileTransport'
        #'Loggia::PlainFileTransport'
        #'Loggia::CSVTransport'
        #'Loggia::LogFileTransport'
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
    )
! !

!stx_goodies_loggia class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eFractal s.r.o. & CVUT-FEL'

    "Modified: / 08-04-2008 / 14:54:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Logging framework for Smalltalk/X'

    "Modified: / 08-04-2008 / 14:54:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Martin Dvorak 2006 & Jan Vrany 2007-2008'

    "Modified: / 08-04-2008 / 14:55:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Logging framework for Smalltalk/X'

    "Modified: / 08-04-2008 / 14:54:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!stx_goodies_loggia class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "        

    ^ '$URL$'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'24'"$"
! !

!stx_goodies_loggia class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/stx_goodies_loggia.st,v 1.9 2016-12-05 12:09:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/stx_goodies_loggia.st,v 1.9 2016-12-05 12:09:08 cg Exp $'
!

version_SVN
    ^ '$Id: stx_goodies_loggia.st,v 1.9 2016-12-05 12:09:08 cg Exp $'
! !

