"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

NavigatorModel subclass:#BrowserList
	instanceVariableNames:'menuHolder inGeneratorHolder outGeneratorHolder
		selectionChangeCondition immediateUpdate doubleClickChannel
		filter updateTrigger forceGeneratorTrigger hideUnloadedClasses
		showClassPackages selectionHolder packageFilter nameSpaceFilter
		organizerMode slaveMode listValid pseudoListLabelHolder icons
		sortBy autoSelect showAllClassesInNameSpaceOrganisation
		nameFilter showCoverageInformation searchHandler
		autoUpdateOnChange loadInProgress'
	classVariableNames:'SynchronousUpdate Icons'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

Object subclass:#SearchHandler
	instanceVariableNames:'listView listViewVisualBlock listViewSelectedVisualBlock
		listHolder listSelectionHolder searchField searchWindow
		searchHolder nextDelegate'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BrowserList
!

!BrowserList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    embeddable application displaying a browser's list.
    I am a pluggable component, which gets an input collection
    (typically a generator/iterator), which tells me what to display
    in the list.
    When an item is selected, I provides a similar outputGenerator, 
    which enumerates the selected sub-items.
    Concrete subclasses exist, to present lists of:
        class-categories (and generate a list of classes),
        packages (and generate a list of classes),
        namespaces (generates a list of classes),
        classes (and generate a list of methods+method category,
        method-categories (and generate a list of methods),
        methods

    [author:]
        Claus Gittinger (cg@exept.de)

    [instance variables:]
        can someone please write a  few words here...

        menuHolder 
        inGeneratorHolder 
        outGeneratorHolder
        selectionChangeCondition 
        immediateUpdate 
        doubleClickChannel
        filter                          a filterblock by the one who embedds this
        updateTrigger 
        forceGeneratorTrigger 
        hideUnloadedClasses
        showClassPackages 
        selectionHolder 
        packageFilter 
        nameSpaceFilter
        organizerMode 
        slaveMode                       I am just following passively (used for hidden
                                        organized lists (for example: package list, while hidden
                                        when another mode is active, to prevent it from sending
                                        out change requests etc.)
        listValid 
        pseudoListLabelHolder 
        icons
        sortBy 
        autoSelect 
        showAllClassesInNameSpaceOrganisation
        nameFilter                      a string or glob pattern (from the user, if a GUI for that is present)
"
! !

!BrowserList class methodsFor:'image specs'!

checkedIcon
    "TODO: cg: ask the checkbox for its icon, to ensure a common look"

    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkedIcon inspect
     ImageEditor openOnClass:self andSelector:#checkedIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^ MenuPanel iconIndicationOn

"/    ^Icon
"/        constantNamed:#'Tools::HierarchicalPackageFilterList::PackageItem class checkedIcon'
"/        ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?07?C?<O?0??@@@@@@b') ; colorMapFromArray:#[0 0 0 33 161 33]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
"/?????<@C0@O@D<@30GOH8<7C38OG@<HC0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]

    "Created: / 06-11-2008 / 16:32:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-12-2011 / 15:35:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkedIconDisabled
    "TODO: cg: ask the checkbox for its icon, to ensure a common look"

    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self checkedIcon inspect
     ImageEditor openOnClass:self andSelector:#checkedIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^ MenuPanel iconIndicationDisabledOn

"/    ^Icon
"/        constantNamed:#'Tools::HierarchicalPackageFilterList::PackageItem class checkedIcon'
"/        ifAbsentPut:[(Depth1Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?07?C?<O?0??@@@@@@b') ; colorMapFromArray:#[0 0 0 33 161 33]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
"/?????<@C0@O@D<@30GOH8<7C38OG@<HC0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]

    "Created: / 08-10-2014 / 22:53:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceIcon
    ^ SystemBrowser nameSpaceIcon
!

packageIcon
    ^ SystemBrowser packageIcon
!

padLockBlueMiniIcon
    ^ SystemBrowser padLockBlueMiniIcon
!

padLockGrayMiniIcon
    ^ SystemBrowser padLockGrayMiniIcon
!

padLockGreenMiniIcon
    ^ SystemBrowser padLockGreenMiniIcon
!

padLockRedMiniIcon
    ^ SystemBrowser padLockRedMiniIcon
!

programImageIcon
    ^ SystemBrowser programImageIcon
!

protectedMethod
    ^ self padLockRedMiniIcon
!

redLockIcon
    ^ SystemBrowser redLockIcon
!

uncheckedIcon
    "TODO: cg: ask the checkbox for its icon, to ensure a common look"

    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self uncheckedIcon inspect
     ImageEditor openOnClass:self andSelector:#uncheckedIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::BrowserList uncheckedIcon'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
G!!8^G!!8^G!!8^G!!8^G!!8,KB0,KB0,KB0,KA8^KA@PDA@PDCT)HR0^G"0PJ"(*J \QLR4,G!!8,DB(*@RX3E TUKA8^KA@4L <1F"8CHB0^G"00DQ$[@2\SD0$,
G!!8,IQXW@"LLC@0_KA8^K@8\H!!LLKAH,K20^G"0XH!!LTKB (JBP,G!!8,J04@A@ JA ,]KA8^KB0,KB0,KB0,KB0^G!!8^G!!8^G!!8^G!!8^G @a') ; colorMapFromArray:#[219 219 220 205 209 214 234 234 234 232 232 232 224 225 225 226 227 228 235 236 236 208 211 216 230 231 231 212 213 214 234 235 235 235 235 236 242 242 242 212 212 213 188 191 194 212 215 219 174 179 185 213 216 220 245 245 245 237 237 237 240 240 240 198 199 200 221 223 225 228 229 229 194 196 198 218 220 223 225 226 227 224 225 227 227 228 229 233 233 234 142 143 143 220 221 222 204 205 205 187 190 193 233 233 233 239 239 239 230 230 230 184 187 191 210 213 218 236 236 236 246 246 246 180 185 189 203 207 213 202 203 204 244 244 244 193 195 197 229 230 230 225 226 226 178 183 188 219 221 223 208 212 217 216 219 222 205 209 215 175 180 186]; yourself]
!

uncheckedIconDisabled
    "TODO: cg: ask the checkbox for its icon, to ensure a common look"

    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self uncheckedIconDisabled inspect
     ImageEditor openOnClass:self andSelector:#uncheckedIconDisabled
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'Tools::BrowserList uncheckedIconDisabled'
        ifAbsentPut:[(Depth8Image new) width:13; height:13; bits:(ByteArray fromPackedString:'
LC@0LC@0LC@0LC@0LC@GA0\GA0\GA0\GA3@0A2H"H"H"H!!@DL0\0L@\"APTEAQ #C@ GLC@GH TED D]JAX''A3@0A2HOCRDLK@$TL \0L@\KH2,-E@H%IQ(G
LC@G@B )D3T^G!!81A3@0A2@.MBT^A2PGB \0L@\*MBT&A0LC@08GLC@GA!!<QEQ$[E10/A3@0A0\GA0\GA0\GA0\0LC@0LC@0LC@0LC@0L@@a') ; colorMapFromArray:#[184 187 191 210 213 218 236 236 236 246 246 246 180 185 189 203 207 213 202 203 204 244 244 244 193 195 197 229 230 230 225 226 226 178 183 188 219 221 223 208 212 217 230 230 230 205 209 215 175 180 186 219 219 220 205 209 214 234 234 234 232 232 232 224 225 225 226 227 228 235 236 236 208 211 216 230 231 231 212 213 214 234 235 235 235 235 236 216 219 222 242 242 242 212 212 213 188 191 194 212 215 219 174 179 185 213 216 220 245 245 245 237 237 237 240 240 240 198 199 200 221 223 225 228 229 229 194 196 198 218 220 223 225 226 227 224 225 227 227 228 229 233 233 234 142 143 143 220 221 222 204 205 205 187 190 193 233 233 233 239 239 239]; yourself]
! !

!BrowserList class methodsFor:'queries'!

isAbstract
    ^ self == Tools::BrowserList
! !

!BrowserList methodsFor:'accessing'!

nameFilter:something
    nameFilter := something.
! !

!BrowserList methodsFor:'aspects'!

autoUpdateOnChange
    "automatic update of the list, when the system changes.
     For some (slow) search lists (such as string-search), autoupdate is
     disabled as it would otherwise make the browser unusable.
     Those lists need an explicit menu-update action."

    ^ autoUpdateOnChange ? true.

    "Modified: / 24-02-2000 / 23:57:13 / cg"
    "Created: / 15-05-2012 / 11:16:07 / cg"
!

autoUpdateOnChange: aBoolean
    "automatic update of the list, when the system changes.
     For some (slow) search lists (such as string-search), autoupdate is
     disabled as it would otherwise make the browser unusable.
     Those lists need an explicit menu-update action."

    autoUpdateOnChange := aBoolean

    "Modified: / 24-02-2000 / 23:57:13 / cg"
    "Created: / 15-05-2012 / 11:17:18 / cg"
!

defaultSlaveModeValue
    ^ nil.

    "Created: / 25.2.2000 / 22:36:40 / cg"
!

doubleClickChannel
    doubleClickChannel isNil ifTrue:[
	doubleClickChannel := TriggerValue new.
    ].
    ^ doubleClickChannel.

    "Modified: / 31.1.2000 / 00:42:44 / cg"
    "Created: / 5.2.2000 / 22:38:32 / cg"
!

doubleClickChannel:aChannel
    doubleClickChannel := aChannel
!

filter:aValueHolder
    filter notNil ifTrue:[
	filter removeDependent:self
    ].
    filter := aValueHolder.
    filter notNil ifTrue:[
	filter addDependent:self
    ].

    "Modified: / 4.2.2000 / 23:29:30 / cg"
    "Created: / 5.2.2000 / 13:42:12 / cg"
!

forceGeneratorTrigger
    forceGeneratorTrigger isNil ifTrue:[
	forceGeneratorTrigger := TriggerValue new.
	forceGeneratorTrigger addDependent:self.
    ].
    ^ forceGeneratorTrigger.

    "Modified: / 18.2.2000 / 02:02:52 / cg"
    "Created: / 18.2.2000 / 02:46:40 / cg"
!

forceGeneratorTrigger:aTriggerValue
    forceGeneratorTrigger notNil ifTrue:[
	forceGeneratorTrigger removeDependent:self
    ].
    forceGeneratorTrigger := aTriggerValue.
    forceGeneratorTrigger notNil ifTrue:[
	forceGeneratorTrigger addDependent:self
    ].

    "Modified: / 4.2.2000 / 23:29:30 / cg"
    "Created: / 18.2.2000 / 02:46:52 / cg"
!

hideUnloadedClasses
    hideUnloadedClasses isNil ifTrue:[
        hideUnloadedClasses := ValueHolder with:false.
        hideUnloadedClasses addDependent:self.
    ].
    ^ hideUnloadedClasses.

    "Modified: / 18.2.2000 / 02:02:52 / cg"
    "Created: / 18.2.2000 / 17:36:30 / cg"
!

hideUnloadedClasses:aValueHolder
    hideUnloadedClasses notNil ifTrue:[
	hideUnloadedClasses removeDependent:self
    ].
    hideUnloadedClasses := aValueHolder.
    hideUnloadedClasses notNil ifTrue:[
	hideUnloadedClasses addDependent:self
    ].

    "Modified: / 4.2.2000 / 23:29:30 / cg"
    "Created: / 18.2.2000 / 17:46:36 / cg"
!

menuHolder
    ^ menuHolder

    "Created: / 5.2.2000 / 13:42:06 / cg"
!

menuHolder:aValueHolder
    menuHolder := aValueHolder.

    "Created: / 5.2.2000 / 13:42:06 / cg"
!

nameSpaceFilter
    nameSpaceFilter isNil ifTrue:[
	nameSpaceFilter := ValueHolder new.
	nameSpaceFilter addDependent:self.
    ].
    ^ nameSpaceFilter.

    "Modified: / 24.2.2000 / 23:57:13 / cg"
    "Created: / 18.8.2000 / 14:18:56 / cg"
!

nameSpaceFilter:aValueHolder
    nameSpaceFilter notNil ifTrue:[
	nameSpaceFilter removeDependent:self
    ].
    nameSpaceFilter := aValueHolder.
    nameSpaceFilter notNil ifTrue:[
	nameSpaceFilter addDependent:self
    ].

    "Modified: / 24.2.2000 / 23:56:22 / cg"
    "Created: / 18.8.2000 / 14:19:06 / cg"
!

organizerMode
    organizerMode isNil ifTrue:[
        organizerMode := OrganizerCanvas organizerModeCategory asValue.
        organizerMode addDependent:self.
    ].
    ^ organizerMode

    "Modified: / 31.1.2000 / 00:51:06 / cg"
    "Created: / 25.2.2000 / 22:36:15 / cg"
!

organizerMode:aValueHolder
    organizerMode notNil ifTrue:[
	organizerMode removeDependent:self
    ].
    organizerMode := aValueHolder.
    organizerMode notNil ifTrue:[
	organizerMode addDependent:self
    ].

    "Modified: / 4.2.2000 / 23:34:28 / cg"
    "Created: / 25.2.2000 / 22:36:28 / cg"
!

packageFilter
    packageFilter isNil ifTrue:[
	packageFilter := ValueHolder new.
	packageFilter addDependent:self.

"/ debug-check only
"/ packageFilter onChangeEvaluate:[packageFilter value isValueModel ifTrue:[self halt:'debug halt']].
    ].
    ^ packageFilter.

    "Modified: / 18.8.2000 / 19:26:36 / cg"
!

packageFilter:aValueHolder
    packageFilter notNil ifTrue:[
	packageFilter removeDependent:self
    ].
    packageFilter := aValueHolder.
    packageFilter notNil ifTrue:[
	packageFilter addDependent:self.

"/ debug-check only
"/ packageFilter onChangeEvaluate:[packageFilter value isValueModel ifTrue:[self halt:'debug halt']].
    ].

    "Modified: / 18.8.2000 / 19:26:40 / cg"
!

pseudoListLabelHolder
    pseudoListLabelHolder isNil ifTrue:[
        pseudoListLabelHolder := ValueHolder with:''.
    ].
    ^ pseudoListLabelHolder
!

selectionChangeCondition:aBlockOrValueHolder
    selectionChangeCondition := aBlockOrValueHolder
!

selectionHolder
    selectionHolder isNil ifTrue:[
	selectionHolder := ValueHolder new.
	selectionHolder addDependent:self
    ].
    ^ selectionHolder.

!

selectionHolder:aValueHolder
    |prevSelection|

    prevSelection := selectionHolder value ? #().

    selectionHolder notNil ifTrue:[
	selectionHolder removeDependent:self
    ].
    selectionHolder := aValueHolder.
    selectionHolder notNil ifTrue:[
	selectionHolder addDependent:self
    ].
    (selectionHolder value ? #()) ~= prevSelection ifTrue:[
	"/ update
	self update:#value with:nil from:selectionHolder
    ].


!

showAllClassesInNameSpaceOrganisation
    ^[
        |holder|

        showAllClassesInNameSpaceOrganisation notNil ifTrue:[
            holder := showAllClassesInNameSpaceOrganisation
        ] ifFalse:[
            masterApplication notNil ifTrue:[
                holder := masterApplication perform:#showAllClassesInNameSpaceOrganisation ifNotUnderstood:nil.
            ].
            holder notNil ifTrue:[
                holder addDependent:self.
            ] ifFalse:[
                showAllClassesInNameSpaceOrganisation isNil ifTrue:[
                    showAllClassesInNameSpaceOrganisation := ValueHolder with:false.
                    showAllClassesInNameSpaceOrganisation addDependent:self.
                ].
                holder := showAllClassesInNameSpaceOrganisation.
            ].
        ].
        holder value
    ].

    "Created: / 05-03-2007 / 16:47:03 / cg"
    "Modified: / 04-07-2011 / 21:49:10 / cg"
!

showAllClassesInNameSpaceOrganisation:aValueHolder
    showAllClassesInNameSpaceOrganisation notNil ifTrue:[
        showAllClassesInNameSpaceOrganisation removeDependent:self
    ].
    showAllClassesInNameSpaceOrganisation := aValueHolder.
    showAllClassesInNameSpaceOrganisation notNil ifTrue:[
        showAllClassesInNameSpaceOrganisation addDependent:self
    ].

    "Created: / 05-03-2007 / 16:47:13 / cg"
!

showClassPackages
    showClassPackages isNil ifTrue:[
        showClassPackages := ValueHolder with:false.
        showClassPackages addDependent:self.
    ].
    ^ showClassPackages.

    "Modified: / 18.2.2000 / 02:02:52 / cg"
    "Created: / 18.2.2000 / 17:36:30 / cg"
!

showClassPackages:aValueHolder
    showClassPackages notNil ifTrue:[
	showClassPackages removeDependent:self
    ].
    showClassPackages := aValueHolder.
    showClassPackages notNil ifTrue:[
	showClassPackages addDependent:self
    ].
!

showCoverageInformation
    showCoverageInformation isNil ifTrue:[
        showCoverageInformation := ValueHolder with:false.
        showCoverageInformation addDependent:self.
    ].
    ^ showCoverageInformation.

    "Created: / 27-04-2010 / 16:13:16 / cg"
!

showCoverageInformation:aValueHolder
    showCoverageInformation notNil ifTrue:[
        showCoverageInformation removeDependent:self
    ].
    showCoverageInformation := aValueHolder.
    showCoverageInformation notNil ifTrue:[
        showCoverageInformation  addDependent:self
    ].

    "Created: / 27-04-2010 / 16:13:20 / cg"
!

slaveMode
    slaveMode isNil ifTrue:[
	slaveMode := self defaultSlaveModeValue asValue.
	slaveMode addDependent:self.
    ].
    ^ slaveMode.

    "Created: / 25.2.2000 / 22:36:40 / cg"
!

slaveMode:aValueHolder
    |prev|

    slaveMode notNil ifTrue:[
	slaveMode removeDependent:self.
	prev := slaveMode value.
    ].
    slaveMode := aValueHolder.
    slaveMode notNil ifTrue:[
	slaveMode addDependent:self
    ].
    prev ~~ slaveMode value ifTrue:[
	(prev isNil and:[slaveMode value]) ifFalse:[
	    self update:#value with:nil from:slaveMode.
	]
    ].
!

sortBy
    sortBy isNil ifTrue:[
        sortBy := ValueHolder with:nil.
        sortBy addDependent:self.
    ].
    ^ sortBy.

    "Created: / 25.2.2000 / 22:36:40 / cg"
!

sortBy:aValueHolder
    |prev|

    prev := sortBy value.
    sortBy notNil ifTrue:[
	sortBy removeDependent:self
    ].
    sortBy := aValueHolder.
    sortBy notNil ifTrue:[
	sortBy addDependent:self
    ].
    prev ~~ sortBy value ifTrue:[
	self update:#value with:nil from:sortBy.
    ].

    "Modified: / 4.2.2000 / 23:29:30 / cg"
    "Created: / 5.2.2000 / 13:42:12 / cg"
!

updateTrigger
    updateTrigger isNil ifTrue:[
	updateTrigger := TriggerValue new.
	updateTrigger addDependent:self.
    ].
    ^ updateTrigger.

    "Created: / 18.2.2000 / 01:59:58 / cg"
    "Modified: / 18.2.2000 / 02:02:52 / cg"
!

updateTrigger:aTriggerValue
    updateTrigger notNil ifTrue:[
	updateTrigger removeDependent:self
    ].
    updateTrigger := aTriggerValue.
    updateTrigger notNil ifTrue:[
	updateTrigger addDependent:self
    ].

    "Modified: / 4.2.2000 / 23:29:30 / cg"
    "Created: / 18.2.2000 / 02:03:15 / cg"
! !

!BrowserList methodsFor:'change & update'!

applicationIsActive
    "true if I am the active view"

    |wg activeView|

    (wg := self windowGroup) isNil ifTrue:[ ^ true ].   "/ I am being initialized  
    self device isNil ifTrue:[ ^ true ].   "/ I am being initialized   

    (activeView := self device activeView) isNil ifTrue:[ "Transcript showCR:'nil active'." ^ false ].   
"/Transcript showCR:'active view: ',(activeView printString). 
"/Transcript showCR:'active wg: ',(activeView windowGroup printString). 
"/Transcript showCR:'my wg: ',wg printString. 
    ^ activeView windowGroup == wg
!

delayedUpdate:something with:aParameter from:changedObject

    "/ if any of my subclasses want those, they should look for them.
    changedObject == environment ifTrue:[
        (something == #Language or:[something == #LanguageTerritory]) ifTrue:[
            ^ self
        ].
        something == #organization ifTrue:[
            ^ self
        ].
        something == #classDefinition ifTrue:[
            ^ self
        ].
        something == #classVariables ifTrue:[
            ^ self
        ].
        something == #methodTrap ifTrue:[
            ^ self
        ].
        something == #methodInClassRemoved ifTrue:[
            ^ self.
        ].
        something == #methodDictionary ifTrue:[
            ^ self 
        ].
        something == #newClass ifTrue:[
            ^ self 
        ].
    ].

    changedObject == slaveMode ifTrue:[
        slaveMode value ~~ true ifTrue:[
            listValid ~~ true ifTrue:[
                self updateList.
            ].
            self updateOutputGenerator.
        ].
        ^ self.
    ].

    changedObject == selectionHolder ifTrue:[
        listValid ifFalse:[
            self updateList.
        ].
        ^ self selectionChanged
    ].

    changedObject == forceGeneratorTrigger ifTrue:[
        self updateOutputGenerator.
        ^ self.
    ].

    changedObject == hideUnloadedClasses ifTrue:[
        self invalidateList.
        slaveMode value ~~ true ifTrue:[
            self updateOutputGenerator.
        ].
        ^ self.
    ].

    changedObject == updateTrigger ifTrue:[
        self enqueueDelayedUpdateList.
        ^ self 
    ].

    changedObject == inGeneratorHolder ifTrue:[
        self invalidateList.
        ^ self 
    ].

"/    changedObject == outGeneratorHolder ifTrue:[
"/        self enqueueDelayedUpdateList.
"/        ^ self 
"/    ].

    changedObject == packageFilter ifTrue:[
        self invalidateList.
        ^ self 
    ].
    changedObject == nameSpaceFilter ifTrue:[
        self invalidateList.
        ^ self 
    ].

    changedObject == organizerMode ifTrue:[
        ^ self
    ].

    self invalidateList.
    ^ self

    "Created: / 05-02-2000 / 13:42:06 / cg"
    "Modified: / 18-08-2000 / 14:19:24 / cg"
    "Modified (format): / 25-02-2014 / 10:02:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enqueueDelayedUpdateList
    self setListValid:false.

    (NewSystemBrowser synchronousUpdate == true
    or:[ immediateUpdate value == true ])
    ifTrue:[
        self updateList.
        ^ self.
    ].

    (self applicationIsActive) ifTrue:[
        self enqueueMessage:#updateList for:self arguments:nil
    ] ifFalse:[
        self enqueueMessage:#updateListInBackground for:self arguments:nil
    ].

    "Modified: / 05-06-2012 / 23:38:18 / cg"
!

enqueueDelayedUpdateOutputGenerator
    (NewSystemBrowser synchronousUpdate == true
    or:[ immediateUpdate value == true ])
    ifTrue:[
        self updateOutputGenerator.
        ^ self.
    ].
    "/ listValid := false.
    self enqueueMessage:#updateOutputGenerator for:self arguments:#()
!

environmentChanged
    super environmentChanged.
    self updateList.

    "Created: / 24-02-2014 / 10:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forceReselect
    |selectionHolder prevSelection|

    selectionHolder := self selectionHolder.
    prevSelection := selectionHolder value.

    selectionHolder class == ValueHolder ifTrue:[
        selectionHolder changed:#value with:prevSelection.
    ] ifFalse:[
        selectionHolder setValue:nil.
        selectionHolder value:prevSelection.
    ]
!

forceSelectionClear
    self selectionHolder setValue:nil
!

forceUpdateList
"/    |listView|
"/
"/    listView := builder componentAt:#List.
"/    listView notNil ifTrue:[    
"/        listView list:#()
"/    ].
    self updateList
!

immediateUpdate:aBooleanOrBooleanHolder
    immediateUpdate := aBooleanOrBooleanHolder

    "Created: / 13.2.2000 / 22:26:06 / cg"
    "Modified: / 13.2.2000 / 22:28:09 / cg"
!

prioDelayedUpdate:something with:aParameter from:changedObject
    Processor activeProcess withLowerPriorityDo:[
        self delayedUpdate:something with:aParameter from:changedObject
    ]
!

selectionChangeAllowed
    selectionChangeCondition isNil ifTrue:[^ true].
    selectionChangeCondition isBlock ifTrue:[
	selectionChangeCondition numArgs == 1 ifTrue:[
	    ^ selectionChangeCondition value:self
	]
    ].
    ^ selectionChangeCondition value
!

selectionChanged
    slaveMode value ~~ true ifTrue:[
	self enqueueDelayedUpdateOutputGenerator
	"/ self updateOutputGenerator.
    ]

    "Modified: / 4.2.2000 / 15:49:23 / cg"
    "Created: / 5.2.2000 / 13:42:07 / cg"
!

selectionChangedByClick

    "Created: / 25.2.2000 / 21:19:25 / cg"
!

syncDelayedUpdateList
    |sensor|

    sensor := self window sensor.
    sensor isNil ifTrue:[
	^ self
    ].

    "/
    "/ if an update is in the queue, process it.
    "/
    (sensor 
      hasEvent:#updateList
      for:self
      withArguments:#()
    ) ifTrue:[
	sensor flushEventsFor:self withType:#updateList.
	self updateList.
	^ self
    ].
!

update:something with:aParameter from:changedObject
    |window|

    changedObject == environmentHolder ifTrue:[
        self environmentChanged.
        ^ self.
    ].  
    (changedObject == Smalltalk) ifTrue:[
        (#( preLoad prePackageLoad preClassLoad ) includes:something) ifTrue:[
            loadInProgress := true.
            ^ self.
        ].
        (#( postLoad postPackageLoad postClassLoad ) includes:something) ifTrue:[
            "/ must check, as it could be nested...
            LoadInProgressQuery query ifFalse:[
                loadInProgress := false.
            ].
            ^ self.
        ].
    ].

    (NewSystemBrowser synchronousUpdate == true
    or:[ immediateUpdate value == true ])
    ifTrue:[
        self delayedUpdate:something with:aParameter from:changedObject.
        ^ self.
    ].

"/    changedObject == selectionHolder ifTrue:[
"/        listValid ifFalse:[
"/            self inSlaveMode ifTrue:[
"/                ^ self
"/            ]
"/        ]
"/    ].

    changedObject == inGeneratorHolder ifTrue:[
        self setListValid:false.
        "/ if not shown, this will be done when opened.
        "/ if shown, it will be done in delayedUpdate.
        "/ self invalidateList. "/  setListValid:false.
    ].

    ((window := self window) notNil and:[window isOpen]) ifFalse:[
        ^ self
    ].
    window sensor userEventCount > 100 ifTrue:[
        listValid ifTrue:[
            "/ enqueue a full update.
            self setListValid:false.
            self enqueueMessage:#updateList for:self arguments:nil.
        ].
        ^ self
    ].

    self enqueueDelayedUpdate:something with:aParameter from:changedObject.

    "Created: / 05-02-2000 / 13:42:07 / cg"
    "Modified: / 13-11-2001 / 11:30:19 / cg"
    "Modified: / 25-02-2014 / 09:05:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateListInBackground
    self executeInBackground:[self updateList] 
! !

!BrowserList methodsFor:'drag & drop'!

canDrop: aDropContext
    ^ self canDropContext: aDropContext

    "Created: / 03-07-2007 / 15:59:06 / cg"
!

doDrop: aDropContext
    ^ self doDropContext: aDropContext

    "Created: / 03-07-2007 / 15:59:33 / cg"
!

dropClassFiles:files
    files do:[:fn |
        (Dialog confirm:(resources string:'FileIn %1 ?' with:fn baseName allBold)) ifTrue:[
            environment fileIn:fn logged:true.
        ]
    ].

    "Created: / 17-10-2006 / 18:24:36 / cg"
!

objectsAreClassFiles:objects
    (objects conform:[:anObject | anObject isFilename]) ifTrue:[
        |files|

        files := objects.
        ^ files conform:[:aFilename | aFilename exists
                                      and:[ aFilename suffix = 'st'
                                      and:[ aFilename isRegularFile ]]]
    ].
    ^ false

    "Created: / 17-10-2006 / 18:25:40 / cg"
! !

!BrowserList methodsFor:'generators'!

inGeneratorHolder
    ^ inGeneratorHolder

    "Created: / 5.2.2000 / 13:42:07 / cg"
!

inGeneratorHolder:aConditionBlockHolder
    |prevHolder|

    (prevHolder := inGeneratorHolder) notNil ifTrue:[
        inGeneratorHolder removeDependent:self
    ].
    inGeneratorHolder := aConditionBlockHolder.
    inGeneratorHolder notNil ifTrue:[
        inGeneratorHolder addDependent:self
    ].
    (prevHolder notNil or:[inGeneratorHolder notNil]) ifTrue:[
        true "self window shown" ifFalse:[
            "/ self enqueueDelayedUpdateList - will be done anyway, when shown
        ] ifTrue:[
            (prevHolder value isNil and:[ inGeneratorHolder value isEmptyOrNil]) 
            ifFalse:[
                self update:#value with:nil from:inGeneratorHolder
            ].
        ].
    ].

    "Modified: / 12-03-2007 / 11:31:23 / cg"
!

makeGenerator
    self subclassResponsibility

    "Created: / 5.2.2000 / 13:42:07 / cg"
!

outGeneratorHolder
    outGeneratorHolder isNil ifTrue:[
	outGeneratorHolder := ValueHolder new
    ].
    ^ outGeneratorHolder

    "Modified: / 4.2.2000 / 17:17:16 / cg"
    "Created: / 5.2.2000 / 13:42:07 / cg"
!

outGeneratorHolder:aConditionBlockHolder
    outGeneratorHolder := aConditionBlockHolder.

    "Created: / 5.2.2000 / 13:42:08 / cg"
!

updateOutputGenerator
    "create a generator which enumerates my elements, 
     and place it into the outputGenerator holder"

    self outGeneratorHolder value: self makeGenerator.

    "Modified: / 4.2.2000 / 17:16:34 / cg"
    "Created: / 5.2.2000 / 13:42:08 / cg"
! !

!BrowserList methodsFor:'icons'!

abstractMethodIcon
    "answer an icon to mark abstract methods"

    ^ self fetchIcon:#abstractMethod selector:#abstractMethodIcon
!

breakPointedIcon
    "answer an icon to mark breakPointed methods"
    <resource: #obsolete>

    ^ self lineBreakPointedIcon

    "Modified: / 05-03-2014 / 10:29:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canvasIcon
    "answer an icon to mark canvas spec methods"

    ^ self fetchIcon:#canvas selector:#canvasIcon

!

deprecatedMethodIcon
    ^ self fetchIcon:#deprecatedMethodIcon selector:#deprecatedMethodIcon
!

disabledBreakpointIcon
    "answer an icon to mark methods with disabled breakpoints"

    ^ self fetchIcon:#disabledBreakpointIcon selector:#disabledBreakpointIcon
!

fetchIcon:name selector:fetchSelector
    "answer an icon to mark methods"

    icons isNil ifTrue:[icons := IdentityDictionary new].

    ^ icons at:name ifAbsentPut:[
        |icn fh h|

        icn := (SystemBrowser perform:fetchSelector) onDevice:device.
        h := icn height.
        h > (fh := SelectionInListView defaultFont heightOn:device) ifTrue:[
            icn := icn magnifiedBy:(fh / h)
        ].
        icn onDevice:device
      ]
!

fileImageIcon
    "answer an icon to mark file-image spec methods"

    ^ self fetchIcon:#fileImage selector:#fileImageIcon
!

fullBreakPointedIcon
    "answer an icon to mark breakPointed methods"

    ^ self fetchIcon:#fullBreakPointedIcon selector:#fullBreakPointedIcon

    "Created: / 05-03-2014 / 10:18:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

helpIcon
    "answer an icon to mark help spec methods"

    ^ self fetchIcon:#help selector:#helpIcon

!

hierarchicalListIcon
    "answer an icon to mark hierarchicalList spec methods"

    ^ self fetchIcon:#hierarchicalList selector:#hierarchicalListIcon

!

ignoredMethodIcon
    "answer an icon to mark ignored methods"

    ^ self fetchIcon:#ignoredMethod selector:#ignoredMethodIcon
!

imageIcon
    "answer an icon to mark image spec methods"

    ^ self fetchIcon:#image selector:#imageIcon
!

instrumentationIcon
    "answer an icon to mark instrumented methods"

"/    ^ self fetchIcon:#watch selector:#watchIcon
    ^ self fetchIcon:#instrumentation selector:#instrumentationIcon
!

lineBreakPointedIcon
    "answer an icon to mark breakPointed methods"

    ^ self fetchIcon:#lineBreakPointedIcon selector:#lineBreakPointedIcon

    "Created: / 05-03-2014 / 10:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineTracePointedIcon
    "answer an icon to mark tracePointed methods"

    ^ self fetchIcon:#lineTracePointedIcon selector:#lineTracePointedIcon
!

menuIcon
    "answer an icon to mark menu spec methods"

    ^ self fetchIcon:#menu selector:#menuIcon

!

methodEmptyInheritedIcon
    ^ self fetchIcon:#methodEmptyInherited selector:#methodEmptyInheritedIcon
!

methodInheritedFromAboveAndRedefinedBelowIcon
    ^ self fetchIcon:#methodInheritedFromAboveAndRedefinedBelow selector:#methodInheritedFromAboveAndRedefinedBelowIcon
!

methodInheritedFromAboveIcon
    ^ self fetchIcon:#methodInheritedFromAbove selector:#methodInheritedFromAboveIcon
!

methodIsSubclassResponsibilityAndRedefinedBelowIcon
    ^ self fetchIcon:#methodIsSubclassResponsibilityAndRedefinedBelowIcon selector:#methodIsSubclassResponsibilityAndRedefinedBelowIcon
!

methodIsSubclassResponsibilityIcon
    ^ self fetchIcon:#methodIsSubclassResponsibilityIcon selector:#methodIsSubclassResponsibilityIcon
!

methodRedefinedBelowIcon
    ^ self fetchIcon:#methodRedefinedBelow selector:#methodRedefinedBelowIcon
!

privateMethodIcon
    "answer an icon to mark private methods"

    ^ self fetchIcon:#privateMethod selector:#privateMethodIcon
!

programImageIcon
    "answer an icon to mark image spec methods"

    ^ self fetchIcon:#programImage selector:#programImageIcon
!

programMenuIcon
    "answer an icon to mark program generated menu methods"

    ^ self fetchIcon:#programMenu selector:#programMenuIcon

!

protectedMethodIcon
    "answer an icon to mark protected methods"

    ^ self fetchIcon:#protectedMethod selector:#protectedMethodIcon
!

stopIcon
    "answer an icon to mark breakPointed methods"
    <resource: #obsolete>

    ^ self fullBreakPointedIcon

    "Modified: / 05-03-2014 / 10:29:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tabListIcon
    "answer an icon to mark tabList spec methods"

    ^ self fetchIcon:#tabList selector:#tabListIcon

!

tableColumnsIcon
    "answer an icon to mark tableColumns spec methods"

    ^ self fetchIcon:#tableColumns selector:#tableColumnsIcon

!

timeIcon
    "answer an icon to mark timed methods"

    ^ self fetchIcon:#time selector:#timeIcon

!

traceIcon
    "answer an icon to mark traced methods"

"/    ^ self fetchIcon:#watch selector:#watchIcon
    ^ self fetchIcon:#trace selector:#traceIcon
! !

!BrowserList methodsFor:'initialize-release'!

commonPostBuild
    |list|

    self inSlaveMode ifFalse:[
        "//// listValid ifFalse:[self enqueueDelayedUpdateList "updateList"].
        "/ self setListValid:false.  -- wrong, iff the view has already created a valid list in its initialize
    ] ifTrue:[
        "/ self setListValid:false.  -- wrong, iff the view has already created a valid list in its initialize
        "//// self enqueueDelayedUpdateList.
        "//// self invalidateList
    ].

    self makeDependent.

    list := builder componentAt:#List.
    list notNil ifTrue:[
        list selectConditionBlock:[:item | self selectionChangeAllowed].
        list ignoreReselect:false.
    ].

    UserPreferences current useInPlaceSearchInBrowserLists ifTrue:[
        self supportsSearch ifTrue:[
            list notNil ifTrue:[
                searchHandler := SearchHandler for: list
            ] ifFalse:[ 
                self breakPoint: #jv info: 'Should support search but list is nil. Wrong spec?'
            ].
        ]
    ]

    "Modified: / 28-07-2011 / 09:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

commonPostOpen
    super commonPostOpen.
    listValid ifFalse:[
        "/ self breakPoint:#cg.
        self enqueueDelayedUpdateList.
    ]. 
!

initialize
    listValid := false.
    loadInProgress := false.
    super initialize.
!

release
    self makeIndependent.
    super release.

    filter removeDependent:self.
    forceGeneratorTrigger removeDependent:self.
    hideUnloadedClasses removeDependent:self.
    inGeneratorHolder removeDependent:self.
    nameSpaceFilter removeDependent:self.
    organizerMode removeDependent:self.
    packageFilter removeDependent:self.
    selectionHolder removeDependent:self.
    showClassPackages removeDependent:self.
    slaveMode removeDependent:self.
    sortBy removeDependent:self.
    updateTrigger removeDependent:self.

    "Created: / 5.2.2000 / 13:42:09 / cg"
    "Modified: / 13.2.2000 / 23:32:23 / cg"
! !

!BrowserList methodsFor:'misc'!

invalidateList
    self setListValid:false.
    slaveMode value ~~ true ifTrue:[
        self enqueueDelayedUpdateList.
    ]
! !

!BrowserList methodsFor:'private'!

browserNameList
    self subclassResponsibility
!

classesToProcessForClasses:classes withVisibility:visibility
    "for methodCategory and methodList, depending on the setting
     of visibility (allButObject, includeAllSupers or class only),
     return a combined hull set of classes for a given set."

    |classesToProcess classesToProcessInOrder|

    visibility isNil ifTrue:[^classes].
    visibility == #class ifTrue:[^classes].

    classesToProcess := IdentitySet new.
    classesToProcessInOrder := OrderedCollection new.
    classes notNil ifTrue:[
        classes do:[:eachClass |
            |withAllSupers|

            withAllSupers := eachClass withAllSuperclasses.
            visibility == #allButObject ifTrue:[
                eachClass isMeta ifTrue:[
                    withAllSupers removeAllFoundIn:(Object class withAllSuperclasses)
                ] ifFalse:[
                    withAllSupers remove:Object ifAbsent:nil
                ]
            ].
            withAllSupers do:[:each |
                (classesToProcess includes:each) ifFalse:[
                    classesToProcess add:each. 
                    classesToProcessInOrder add:each. 
                ]
            ]
        ].
    ].
    ^ classesToProcessInOrder

    "Modified (comment): / 06-07-2011 / 11:21:16 / cg"
!

colorize:aString with:emphasis
    ^ aString asText emphasisAllAdd:emphasis

    "Created: / 27-04-2010 / 15:36:34 / cg"
!

colorizeForChangedCode:someString
    ^ someString asText emphasisAllAdd:(UserPreferences current emphasisForChangedCode)

    "Created: / 31.10.2001 / 10:17:56 / cg"
!

colorizeForChangedCodeInSmallTeam:someString
    ^ someString asText emphasisAllAdd:(UserPreferences current emphasisForChangedCodeInSmallTeam)

    "Created: / 10-11-2006 / 16:53:53 / cg"
!

colorizeForDifferentPackage:someString
    ^ someString asText emphasisAllAdd:(UserPreferences current emphasisForDifferentPackage)
!

colorizeForInstrumentedFullyCoveredCode:someString
    ^ self colorize:someString with:(UserPreferences current emphasisForInstrumentedFullyCoveredCode)

    "Created: / 27-04-2010 / 13:01:24 / cg"
    "Modified: / 27-04-2010 / 15:36:49 / cg"
!

colorizeForInstrumentedNeverCalledCode:someString
    ^ self colorize:someString with:(UserPreferences current emphasisForInstrumentedNeverCalledCode)

    "Created: / 27-04-2010 / 12:59:56 / cg"
    "Modified: / 27-04-2010 / 15:37:02 / cg"
!

colorizeForInstrumentedPartiallyCoveredCode:someString
    ^ self colorize:someString with:(UserPreferences current emphasisForInstrumentedPartiallyCoveredCode)

    "Created: / 27-04-2010 / 13:01:31 / cg"
    "Modified: / 27-04-2010 / 15:37:06 / cg"
!

colorizeGrey:someString
    ^ someString asText emphasisAllAdd:(#color->Color darkGray)
!

emphasizeForChangedCode:someString
    ^ self colorizeForChangedCode:someString

    "Modified: / 31.10.2001 / 10:18:57 / cg"
!

emphasizeForDifferentPackage:someString
    ^ self colorizeForDifferentPackage:(' [' , (' ' , someString , ' ') "allItalic" , ']')

    "Modified: / 31.10.2001 / 10:13:35 / cg"
!

executeInBackground:aBlock
    "used to update when I do not have the focus (i.e. being iconified or non-active).
     Run aBlock at userBackgroundPrio, but go back to normal prio, if I get the focus"

    |activeProcess watcher done|

    activeProcess := Processor activeProcess.

    done := false.

    watcher :=
        [
            |wg|

            [done] whileFalse:[
                Delay waitForSeconds:0.2.
                self applicationIsActive ifTrue:[
                    activeProcess priority:(Processor userSchedulingPriority).
                    done := true.
                ].
            ].
        ] fork.

    [
        activeProcess withPriority:(Processor userBackgroundPriority) to:(Processor activePriority) do:aBlock
    ] ensure:[ 
        done := true. 
        watcher terminate 
    ].
!

inSlaveMode
    ^ (self slaveMode value == true)
!

inSlaveModeOrInvisible
    (self slaveMode value == true) ifTrue:[^ true].
"/    self slaveMode value isNil ifTrue:[
"/        self window shown ifFalse:[
"/            ^ true
"/        ].
"/    ].
    ^ false
!

isClass:aClass shownWithNameSpaceFilter:nameSpaceFilter
    |nsName|

    nameSpaceFilter isNil ifTrue:[^ true].
    nsName := aClass topNameSpace name.

    (nameSpaceFilter includes:nsName) ifTrue:[^ true].
    (nameSpaceFilter contains:[:ns | nsName startsWith:(ns , '::')]) ifTrue:[^ true].
    ^ false
!

isClass:aClass shownWithPackageFilter:packageFilter
    |classPackage|

    packageFilter isNil ifTrue:[^ true].
    classPackage := aClass package.
    (packageFilter includes:classPackage) ifTrue:[^ true].
    (packageFilter includes:self class nameListEntryForChanged) ifTrue:[^ true].

    aClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
        |mthdPackage|

        mthdPackage := mthd package.
        mthdPackage ~~ classPackage ifTrue:[
            (packageFilter includes:mthdPackage) ifTrue:[^ true].
        ].
    ].
    ^ false

    "Modified: / 11-08-2006 / 15:15:28 / cg"
!

makeDependent
    self subclassResponsibility

    "Created: / 5.2.2000 / 13:42:08 / cg"
!

makeIndependent
    self subclassResponsibility

    "Created: / 5.2.2000 / 13:42:08 / cg"
!

releaseAsSubCanvas
    self makeIndependent.
    super releaseAsSubCanvas.

    "Created: / 13.2.2000 / 23:11:29 / cg"
    "Modified: / 13.2.2000 / 23:32:29 / cg"
!

setListValid:aBoolean
    listValid := aBoolean
!

updateList
    self subclassResponsibility.
!

updateListFor:newList
    "update the browsers list in a way which avoids scrolls
     and flicker; returns true, if the newList is the same."

    |"oldListSize newListSize" sameContents sameStrings oldEntry browserNameList
     "firstDifferentFromBeginning firstDifferentFromEnd" listView prevMode sav|

    browserNameList := self browserNameList value.
    sameContents := sameStrings := (newList size == browserNameList size).

    sameContents ifTrue:[
        newList with:browserNameList do:[:newLine :oldLine |
            sameStrings ifTrue:[
                sameStrings := ((newLine ? '')  = (oldLine ? '')).    
            ].
            sameContents ifTrue:[
                ((newLine ? '') sameStringAndEmphasisAs:(oldLine ? '')) ifFalse:[
                    sameContents := false
                ]
            ].
        ]
    ].

    listView := builder componentAt:#List.
    listView isNil ifTrue:[
        "/ called early during setup ...
        browserNameList contents:newList.
        ^ sameContents.
    ].

    sameContents ifTrue:[
        ^ sameContents
    ].
    sameStrings ifTrue:[
        newList keysAndValuesDo:[:lineNr :line |
            oldEntry := browserNameList at:lineNr.    
            (oldEntry sameStringAndEmphasisAs:line) ifFalse:[
                browserNameList at:lineNr put:line.
            ]
        ].
        ^ sameContents
    ].

    listView := listView scrolledView.
    listView isNil ifTrue:[^ false].
    prevMode := listView scrollWhenUpdating.
    listView scrollWhenUpdating:nil.

    [
        "/ don't want to be called if selection is changed by selListView
        sav := listView action.
        listView action:nil.
        browserNameList contents:newList.
    ] ensure:[
        listView action:sav.
    ].

    listView scrollWhenUpdating:prevMode.
    ^ sameContents.

"/    oldListSize := browserNameList size.
"/    newListSize := newList size.
"/    newListSize == 0 ifTrue:[
"/        oldListSize == 0 ifTrue:[
"/            ^ true "/ same
"/        ].
"/        browserNameList removeAll.
"/        ^ false "/ not same
"/    ].
"/
"/    oldListSize == 0 ifTrue:[
"/        browserNameList contents:newList.
"/        ^ false. "/ not same
"/    ].
"/
"/    (newListSize between:(oldListSize-1) and:(oldListSize+1)) ifTrue:[
"/        "/ individually exchange changed lines, to avoid flicker.
"/        "/ the old code was: self browserNameList value:newList
"/        "/ but if only a single method is changed (or an instrumentation icon changes),
"/        "/ this results in avoidable flicker.
"/
"/        newListSize > oldListSize ifTrue:[
"/            "/ an entry seems to be added
"/            "/ try to find it.
"/            firstDifferentFromBeginning := 1.
"/
"/            [firstDifferentFromBeginning <= oldListSize
"/             and:[(newList at:firstDifferentFromBeginning) sameStringAndEmphasisAs: (browserNameList at:firstDifferentFromBeginning)]]   
"/            whileTrue:[
"/                firstDifferentFromBeginning := firstDifferentFromBeginning + 1.
"/            ].
"/            firstDifferentFromEnd := newListSize.
"/            [firstDifferentFromEnd >= 1
"/             and:[(newList at:firstDifferentFromEnd) sameStringAndEmphasisAs: (browserNameList at:firstDifferentFromEnd-1)]]   
"/            whileTrue:[
"/                firstDifferentFromEnd := firstDifferentFromEnd - 1.
"/            ].
"/            (firstDifferentFromEnd - firstDifferentFromBeginning) > (newList size // 10) ifTrue:[
"/                "/ too many differences - exchange the list en-bloque
"/                browserNameList contents:newList.
"/                ^ false. "/ not same
"/            ].
"/            "/ entries from firstDifferentFromBeginning to firstDifferentFromEnd in newList are different
"/
"/            (firstDifferentFromEnd - firstDifferentFromBeginning + 1 "number of different items") == (newListSize - oldListSize) ifTrue:[
"/                "/ for now, only handle single-added-item case
"/                firstDifferentFromEnd ~~ firstDifferentFromBeginning ifTrue:[
"/                    self halt
"/                ].
"/
"/                "/ item at firstDifferentFromBeginning has been inserted.
"/                browserNameList add:(newList at:firstDifferentFromBeginning) beforeIndex:firstDifferentFromEnd.
"/               ^ false "/ not the same
"/            ].
"/        ] ifFalse:[
"/            newListSize < oldListSize ifTrue:[
"/                "/ an entry seems to be removed
"/                "/ try to find it.
"/                firstDifferentFromBeginning := 1.
"/
"/                [firstDifferentFromBeginning <= newListSize
"/                 and:[(newList at:firstDifferentFromBeginning) sameStringAndEmphasisAs: (browserNameList at:firstDifferentFromBeginning)]]   
"/                whileTrue:[
"/                    firstDifferentFromBeginning := firstDifferentFromBeginning + 1.
"/                ].
"/                firstDifferentFromEnd := newListSize.
"/                [firstDifferentFromEnd >= 1
"/                 and:[(newList at:firstDifferentFromEnd) sameStringAndEmphasisAs: (browserNameList at:firstDifferentFromEnd+1)]]   
"/                whileTrue:[
"/                    firstDifferentFromEnd := firstDifferentFromEnd - 1.
"/                ].
"/                (firstDifferentFromEnd - firstDifferentFromBeginning) > (newList size // 10) ifTrue:[
"/                    "/ too many differences - exchange the list en-bloque
"/                    browserNameList contents:newList.
"/                    ^ false. "/ not same
"/                ].
"/                "/ entries from firstDifferentFromBeginning to firstDifferentFromEnd in newList are different
"/
"/                (firstDifferentFromBeginning - firstDifferentFromEnd) == (oldListSize - newListSize) ifTrue:[
"/                    "/ for now, only handle single-removed-item case
"/                    firstDifferentFromEnd ~~ (firstDifferentFromBeginning-1) ifTrue:[self halt].
"/
"/                    "/ item at firstDifferentFromBeginning has been removed.
"/                    browserNameList removeFromIndex:firstDifferentFromBeginning toIndex:firstDifferentFromBeginning.
"/                   ^ false "/ not the same
"/                ].
"/            ]
"/        ].
"/
"/        sameContents := true.
"/        newList keysAndValuesDo:[:lineNr :line |
"/            lineNr > browserNameList size ifTrue:[
"/                browserNameList add:line.
"/                sameContents := false.
"/            ] ifFalse:[
"/                oldEntry := browserNameList at:lineNr.    
"/                (oldEntry ~= line 
"/                or:[(oldEntry sameStringAndEmphasisAs:line) not]) ifTrue:[
"/                    browserNameList at:lineNr put:line.
"/                    sameContents := false.
"/                ]
"/            ]
"/        ].
"/        newList size < browserNameList size ifTrue:[
"/            browserNameList removeFromIndex:(newList size + 1) toIndex:(browserNameList size).
"/            sameContents := false.
"/        ].
"/        ^ sameContents
"/    ].
"/
"/    browserNameList contents:newList.
"/    ^ false "/ not the same
! !

!BrowserList methodsFor:'queries'!

supportsSearch

    ^true

    "Created: / 27-07-2011 / 20:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserList methodsFor:'setup'!

autoSelect:aBoolean
    autoSelect := aBoolean.
! !

!BrowserList::SearchHandler class methodsFor:'instance creation'!

for: aView

    ^self new initializeFor: aView.

    "Created: / 27-07-2011 / 20:30:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserList::SearchHandler methodsFor:'event handling'!

buttonMotion:button x:x y:y view:aView
    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #buttonMotion:x:y:view:)
            and:[nextDelegate buttonMotion:button x:x y:y view:aView]
    ].
    ^false

    "Created: / 10-04-2014 / 11:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buttonPress:button x:x y:y view:aView
    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #buttonPress:x:y:view:)
            and:[nextDelegate buttonPress:button x:x y:y view:aView]
    ].
    ^false

    "Created: / 10-04-2014 / 11:43:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyPress:key x:x y:y view:aView
    <resource: #keyboard (#Escape #Accept #Return #CursorUp #CursorDown)>

    | v |

    aView == listView ifTrue:[

        "Forward the event to the view under pointer.
         Therefore, the seach is started only iff the
         pointer points to the list. Based on experience,
         this improves usability because: does not require 
         to click in the list to focus it (which may change 
         the selection)"
        (v := aView windowGroup pointerView) ~~ aView ifTrue:[
            v notNil ifTrue:[
                aView windowGroup focusView: v.
                v sensor keyPress:key x:x y:y view:v.
                ^self.
            ].
        ].

        searchWindow isNil ifTrue:[
            key isCharacter ifTrue:[
                searchHolder setValue: key asString.
                self startSearch.
                ^ self
            ]
        ] ifFalse:[
            key == #Escape ifTrue:[self stopSearch. ^ self].
            key == #Accept ifTrue:[self stopSearch. ^ self].
            key == #Return ifTrue:[self stopSearch. ^ self].
        ]
    ].

    aView == searchField ifTrue:[
        key == #Escape ifTrue:[self stopSearch. ^ self].
        key == #Accept ifTrue:[self stopSearch. ^ self].
        key == #Return ifTrue:[self stopSearch. ^ self].
        (key == #CursorUp or:[key == #CursorDown]) ifTrue:[
            listView sensor setCtrlDown: false.
            listView sensor setShiftDown: false.
            listView keyPress:key x:x y:y.
            ^ self
        ].
    ].

    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #keyPress:x:y:view:)
            and:[nextDelegate keyPress:key x:x y:y view:aView]
    ].

    "Created: / 27-07-2011 / 20:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 11:44:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

keyRelease:key x:x y:y view:aView
    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #keyRelease:x:y:view:)
            and:[nextDelegate keyRelease:key x:x y:y view:aView]
    ].
    ^false

    "Created: / 10-04-2014 / 11:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserList::SearchHandler methodsFor:'event handling-queries'!

handlesButtonMotion:something inView:aView
    "I am not interested in button events"

    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #handlesButtonMotion:inView:)
            and:[nextDelegate handlesButtonMotion:something inView:aView]
    ].
    ^false

    "Modified: / 10-04-2014 / 11:40:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlesButtonPress:something inView:aView
    "I am not interested in button events"

    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #handlesButtonPress:inView:)
            and:[nextDelegate handlesButtonPress:something inView:aView]
    ].
    ^false

    "Modified: / 10-04-2014 / 11:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlesKeyPress:key inView:aView
    <resource: #keyboard (#Escape #Accept #Return #CursorUp #CursorDown)>

    aView == listView ifTrue:[
        key isCharacter ifTrue:[
            ^true
        ]
    ].
    aView == searchField ifTrue:[
        (#(#Escape #Accept #Return #CursorUp #CursorDown) includes: key) ifTrue:[
            ^true
        ]
    ].

    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #handlesKeyPress:inView:)
            and:[nextDelegate handlesKeyPress:key inView:aView]
    ].
    ^false

    "Created: / 27-07-2011 / 20:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 11:39:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlesKeyRelease:key inView:aView
    "this is the query from the sensor to ask me if I would like to
     get a keyRelease event for key from aView. Return true, if I want so,
     false otherwise."

    nextDelegate notNil ifTrue:[
        ^ (nextDelegate respondsTo: #handlesKeyRelease:inView:)
            and:[nextDelegate handlesKeyRelease:key inView:aView]
    ].
    ^false

    "Modified: / 10-04-2014 / 11:40:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserList::SearchHandler methodsFor:'initialization'!

initializeFor: aView

    aView isScrollWrapper ifTrue:[
        listView := aView scrolledView
    ] ifFalse:[
        listView := aView.
    ].
    nextDelegate := listView delegate.
    listView delegate: self.
    searchHolder := ValueHolder with: nil.
    searchHolder onChangeSend: #updateList to: self.

    "Created: / 27-07-2011 / 20:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 11:36:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserList::SearchHandler methodsFor:'private'!

absoluteLeftOfListView

    | absoluteLeft view |
    absoluteLeft := 1.
    view := listView.
    [ view notNil ] whileTrue:
        [absoluteLeft := absoluteLeft + view left - 2.
        view := view superView].
    ^absoluteLeft

    "Created: / 08-08-2009 / 22:30:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 27-07-2011 / 21:54:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

absoluteTopOfListView

    | absoluteTop view |
    absoluteTop := 1.
    view := listView.
    [ view notNil ] whileTrue:
        [absoluteTop := absoluteTop + view top - 1.
        view := view superView].
    ^absoluteTop

    "Created: / 08-08-2009 / 22:30:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 27-07-2011 / 21:54:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filter
    | pattern |

    pattern := StringPattern fromString: searchHolder value.

    ^ [:entry :relax|
        pattern match: entry asString withoutSeparators relax: relax
      ]

    "Created: / 27-07-2011 / 22:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hideSearchWindow

    searchWindow
        ifNotNil:[
            searchWindow destroy.
            searchWindow := nil.
            searchField := nil.
        ]

    "Created: / 27-07-2011 / 21:38:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

restoreList

    self updateSelection.
    listView listHolder: listHolder.
    listSelectionHolder notNil ifTrue:[
        listView model: listSelectionHolder.    
    ].
    listSelectionHolder changed: #value

    "Created: / 27-07-2011 / 22:14:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

restoreListViewProperties

    listView visualBlock: listViewVisualBlock.
    listView selectedVisualBlock: listViewSelectedVisualBlock.

    "Created: / 26-03-2014 / 09:50:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveList

    listHolder := listView listHolder.  
    listSelectionHolder := listView model.

    "Created: / 27-07-2011 / 22:14:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

saveListViewProperties

    listViewVisualBlock := listView visualBlock.
    listViewSelectedVisualBlock := listView selectedVisualBlock.

    listView visualBlock: nil.
    listView selectedVisualBlock: nil.

    "Created: / 26-03-2014 / 09:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showSearchWindow

    searchWindow := StandardSystemView new
        bePopUpView;
        beSlave;        
        origin:(self absoluteLeftOfListView + 5" - optionsView textStartLeft") 
                    @ (self absoluteTopOfListView + listView height + 1 + 5)
        extent:(listView width + 0"((optionsView textStartLeft) * 2)") @ (listView font height * 1.5) ceiling.

    searchField := (EditField 
                    origin: 0.0@0.0
                    corner: 1.0@1.0
                    in: searchWindow)
                    model: searchHolder;
                    immediateAccept: true;
                    delegate: self;
                    yourself.

    searchWindow openModal.

    "Created: / 27-07-2011 / 21:37:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startSearch

    self saveListViewProperties.
    self saveList.
    self updateList.
    self showSearchWindow.

    "Created: / 27-07-2011 / 21:37:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 09:50:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stopSearch

    self hideSearchWindow.
    self restoreListViewProperties.
    self restoreList.

    "Created: / 27-07-2011 / 21:37:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 09:50:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList

    | filter filteredList |
    filter := self filter.

    filteredList := listHolder value select:[:each|filter value: each value: 1].
    filteredList isEmpty ifTrue:[
    filteredList := listHolder value select:[:each|filter value: each value: 2].
    filteredList isEmpty ifTrue:[
    filteredList := listHolder value select:[:each|filter value: each value: 3].
    ]].


    listView listHolder == listHolder ifTrue:[
        listView listHolder: (ValueHolder with: filteredList)
    ] ifFalse:[
        listView listHolder value: filteredList.
    ].
    listView model == listSelectionHolder ifTrue:[
        listView model: ValueHolder new.
        listView model onChangeSend: #updateSelection to: self.
    ].
    filteredList size == 1 ifTrue:[
        listView selection: 1
    ]

    "Created: / 27-07-2011 / 22:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSelection

    | sel |

    listSelectionHolder isNil ifTrue:[^self].

    sel := listView selection.
    sel notNil ifTrue:[
        sel isInteger ifTrue:[
            sel := listHolder identityIndexOf: (listView list at: sel)
        ] ifFalse:[
            sel := sel collect:[:each|listHolder value identityIndexOf: (listView list at: each)]
        ].
    ] ifFalse:[
        listView multipleSelectOk ifTrue:[
            sel := #()
        ]
    ].
    listView useIndex ifFalse:[
        sel isInteger ifTrue:[
            sel := listHolder value at: sel
        ] ifFalse:[
            sel := sel collect:[:each|listHolder value at: each].
        ]
    ].


    listSelectionHolder value: sel.

    "Created: / 02-08-2011 / 09:08:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserList class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

