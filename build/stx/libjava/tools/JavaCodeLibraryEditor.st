"{ Encoding: utf8 }"

"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

SimpleDialog subclass:#JavaCodeLibraryEditor
	instanceVariableNames:'readonlyHolder library infoPanel nameHolder classesHolder
		sourcesHolder acceptEnabledHolder nameIsDefault'
	classVariableNames:'LastDirectory'
	poolDictionaries:''
	category:'Languages-Java-Tools'
!


!JavaCodeLibraryEditor class methodsFor:'accessing'!

lastDirectory
    ^LastDirectory

    "Created: / 22-02-2013 / 00:27:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:JavaCodeLibraryEditor    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#classes
'Path to a directory or .jar archive containing classes'

#name
'Name of the library (optional)'

#sources
'Path do a directory or .zip achive containing sources'

)
! !

!JavaCodeLibraryEditor class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:JavaCodeLibraryEditor andSelector:#windowSpec
     JavaCodeLibraryEditor new openInterface:#windowSpec
     JavaCodeLibraryEditor open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'Java Library Definition'
          name: 'Java Library Definition'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 576 200)
        )
        component: 
       (SpecCollection
          collection: (
           (SubCanvasSpec
              name: 'InfoPanel'
              layout: (LayoutFrame 0 0 0 0 0 1 40 0)
              level: 0
              hasHorizontalScrollBar: false
              hasVerticalScrollBar: false
              clientKey: infoPanel
              createNewBuilder: false
            )
           (VerticalPanelViewSpec
              name: 'Content'
              layout: (LayoutFrame 0 0 40 0 0 1 -30 1)
              horizontalLayout: fit
              verticalLayout: top
              horizontalSpace: 3
              verticalSpace: 3
              component: 
             (SpecCollection
                collection: (
                 (ViewSpec
                    name: 'NameBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Name:'
                          name: 'NameLabel'
                          layout: (LayoutFrame 0 0 0 0 70 0 0 1.0)
                          activeHelpKey: name
                          translateLabel: true
                        )
                       (InputFieldSpec
                          name: 'Name'
                          layout: (LayoutFrame 70 0 4 0 -70 1 26 0)
                          activeHelpKey: name
                          model: nameHolder
                          immediateAccept: true
                          acceptOnPointerLeave: true
                          emptyFieldReplacementText: 'Name of the library (optional)'
                        )
                       )
                     
                    )
                    extent: (Point 576 28)
                  )
                 (ViewSpec
                    name: 'ClassesBox'
                    activeHelpKey: classes
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Classes:'
                          name: 'ClassesLabel'
                          layout: (LayoutFrame 0 0 0 0 70 0 0 1.0)
                          activeHelpKey: classes
                          translateLabel: true
                        )
                       (FilenameInputFieldSpec
                          name: 'Classes'
                          layout: (LayoutFrame 70 0 4 0 -70 1 26 0)
                          activeHelpKey: classes
                          model: classesHolder
                          immediateAccept: true
                          acceptOnPointerLeave: true
                        )
                       (ActionButtonSpec
                          label: 'Browse'
                          name: 'ClassesBrowse'
                          layout: (LayoutFrame -70 1 4 0 -3 1 26 0)
                          translateLabel: true
                          model: doSelectClasses
                        )
                       )
                     
                    )
                    extent: (Point 576 30)
                  )
                 (ViewSpec
                    name: 'SourcesBox'
                    component: 
                   (SpecCollection
                      collection: (
                       (LabelSpec
                          label: 'Sources:'
                          name: 'Label1'
                          layout: (LayoutFrame 0 0 0 0 70 0 0 1.0)
                          activeHelpKey: sources
                          translateLabel: true
                        )
                       (FilenameInputFieldSpec
                          name: 'Sources'
                          layout: (LayoutFrame 70 0 4 0 -70 1 26 0)
                          activeHelpKey: sources
                          model: sourcesHolder
                          immediateAccept: true
                          acceptOnPointerLeave: true
                        )
                       (ActionButtonSpec
                          label: 'Browse'
                          name: 'SourcesBrowse'
                          layout: (LayoutFrame -70 1 4 0 -3 1 26 0)
                          translateLabel: true
                          model: doSelectSources
                        )
                       )
                     
                    )
                    extent: (Point 576 29)
                  )
                 )
               
              )
            )
           (HorizontalPanelViewSpec
              name: 'Buttons'
              layout: (LayoutFrame 3 0 -30 1 -3 1 0 1)
              horizontalLayout: right
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button2'
                    translateLabel: true
                    model: doCancel
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button1'
                    translateLabel: true
                    model: doAccept
                    enableChannel: acceptEnabledHolder
                    extent: (Point 125 22)
                  )
                 )
               
              )
            )
           )
         
        )
      )
! !

!JavaCodeLibraryEditor methodsFor:'accessing'!

library
    ^ library
!

library: aJavaCodeLibrary
    library ~~ aJavaCodeLibrary ifTrue:[
        library := aJavaCodeLibrary.
        self nameHolder value: library name.
        self classesHolder value: library classes.
        self sourcesHolder value: library sources.

        nameIsDefault := library name = library classes asFilename baseName.
    ].

    "Modified: / 21-02-2013 / 19:55:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor methodsFor:'actions'!

doAccept
    super doAccept

    "Created: / 21-02-2013 / 19:51:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelectClasses
    <resource: #uiCallback>

    | file |

    file := Dialog 
                requestFileName:(resources string: 'Select directory or .jar archive') 
                default:''
                ifFail:[ ^ self ]
                pattern:'*.jar'
                fromDirectory: (LastDirectory ? Filename currentDirectory pathName).
    (file := file asFilename) exists ifTrue:[
        LastDirectory := file directory pathName
    ].
    self classesHolder value: file pathName

    "Modified: / 21-02-2013 / 19:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doSelectSources
    <resource: #uiCallback>

    | file |

    file := Dialog 
                requestFileName:(resources string: 'Select directory or .jar/.zip archive with sources') 
                default:''
                ifFail:[ ^ self ]
                pattern:'*.jar; *.zip'
                fromDirectory: (LastDirectory ? Filename currentDirectory pathName).
    (file := file asFilename) exists ifTrue:[
        LastDirectory := file directory pathName
    ].
    self sourcesHolder value: file pathName

    "Modified: / 21-02-2013 / 19:29:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor methodsFor:'aspects'!

acceptEnabledHolder
    "return/create the 'acceptEnabledHolder' value holder (automatically generated)"

    acceptEnabledHolder isNil ifTrue:[
        acceptEnabledHolder := false asValue
    ].
    ^ acceptEnabledHolder

    "Modified: / 21-02-2013 / 19:36:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesHolder
    <resource: #uiAspect>

    classesHolder isNil ifTrue:[
        classesHolder := ValueHolder new.
        classesHolder addDependent:self.

    ].
    ^ classesHolder.

    "Modified: / 21-02-2013 / 19:02:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoPanel
    infoPanel isNil ifTrue:[
        infoPanel := Tools::InlineMessageDialog new.
        infoPanel changeLayoutUponShowHide: false.
    ].
    ^ infoPanel

    "Created: / 09-02-2012 / 19:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2013 / 19:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameHolder
    <resource: #uiAspect>

    nameHolder isNil ifTrue:[
        nameHolder := ValueHolder new.
        nameHolder addDependent:self.

    ].
    ^ nameHolder.

    "Modified: / 21-02-2013 / 20:00:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readonlyHolder
    "return/create the 'readonlyHolder' value holder (automatically generated)"

    readonlyHolder isNil ifTrue:[
        readonlyHolder := ValueHolder new.
    ].
    ^ readonlyHolder
!

readonlyHolder:something
    "set the 'readonlyHolder' value holder (automatically generated)"

    readonlyHolder := something.
!

sourcesHolder
    <resource: #uiAspect>

    sourcesHolder isNil ifTrue:[
        sourcesHolder := ValueHolder new.
        sourcesHolder addDependent:self.

    ].
    ^ sourcesHolder.

    "Modified: / 21-02-2013 / 19:02:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    "stub code automatically generated - please change as required"

    changedObject == nameHolder ifTrue:[
         nameIsDefault := false.
         ^ self.
    ].

    changedObject == classesHolder ifTrue:[
         self validate.
         ^ self.
    ].
    changedObject == sourcesHolder ifTrue:[
         self validate.
         ^ self.
    ].
    changedObject == accept ifTrue:[
        library isNil ifTrue:[
            library := JavaCodeLibrary new.
        ].
        library name: self nameHolder value.
        library classes: self classesHolder value.
        library sources: self sourcesHolder value.
        acceptedValue := library.
        ^self
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 22-02-2013 / 11:46:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor methodsFor:'hooks'!

commonPostOpen
    self validate

    "Created: / 21-02-2013 / 19:06:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2015 / 16:30:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor methodsFor:'initialization'!

initialize
    super initialize.
    accept addDependent: self.
    nameIsDefault := true.

    "Created: / 21-02-2013 / 19:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-12-2014 / 00:29:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor methodsFor:'private'!

validate
    | classes sources |
    classes := self classesHolder value.
    classes isNil ifTrue:[
        self validationError: 'Selected class path does not exist'.
        ^self.
    ].
    classes := classes asFilename.
    classes exists ifFalse:[
        classes suffix = 'jar' ifTrue:[
            self validationError: 'Selected .jar archive does not exist'.
        ] ifFalse:[
            self validationError: 'Selected class path does not exist'.
        ].
        ^self.
    ].
    classes isReadable ifFalse:[
        classes suffix = 'jar' ifTrue:[
            self validationError: 'Selected .jar archive is not readable'.
        ] ifFalse:[
            self validationError: 'Selected class path is not readable'.
        ].
        ^self.
    ].
    classes isDirectory ifFalse:[
        (ZipArchive isZipArchive: classes) ifFalse:[
            self validationError: 'Selected .jar file is not a valid zip archive'.
            ^self
        ].
    ].
    nameIsDefault ifTrue:[
        self nameHolder value: classes baseName.
        nameIsDefault := true
    ].

    sources := self sourcesHolder value.
    sources isEmptyOrNil ifTrue:[
        "/Sources optional
        ^self validationOK.
    ].
    sources := sources asFilename.
    sources exists ifFalse:[
        (#('jar' 'zip') includes: sources suffix) ifTrue:[
            self validationWarning: 'Selected source archive does not exist'.
        ] ifFalse:[
            self validationWarning: 'Selected source directory does not exist'.
        ].
        ^self.
    ].
    sources isReadable ifFalse:[
        sources suffix = 'jar' ifTrue:[
            self validationWarning: 'Selected source archive is not readable'.
        ] ifFalse:[
            self validationWarning: 'Selected source directory is not readable'.
        ].
        ^self.
    ].
    sources isDirectory ifFalse:[
        (ZipArchive isZipArchive: sources) ifFalse:[
            self validationWarning: 'Selected source archive is not a valid zip archive'.
            ^self
        ].
    ].
    self validationOK.

    "Created: / 21-02-2013 / 19:04:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validationError: msg

    self acceptEnabledHolder value: false.
    self infoPanel 
        reset;
        beWarning;
        message: (resources string: msg);
        show

    "Created: / 21-02-2013 / 19:14:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validationOK

    self acceptEnabledHolder value: true.
    self infoPanel 
        reset;
        hide

    "Created: / 21-02-2013 / 19:16:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validationWarning: msg

    self acceptEnabledHolder value: true.
    self infoPanel 
        reset;
        beInformation;
        message: (resources string: msg);
        show

    "Created: / 21-02-2013 / 19:16:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryEditor class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaCodeLibraryEditor.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

