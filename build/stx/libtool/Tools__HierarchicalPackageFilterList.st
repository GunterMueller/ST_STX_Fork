"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

HierarchicalProjectList subclass:#HierarchicalPackageFilterList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Profiler'
!

HierarchicalItemWithLabel subclass:#PackageItem
	instanceVariableNames:'packageID selected'
	classVariableNames:''
	poolDictionaries:''
	privateIn:HierarchicalPackageFilterList
!

!HierarchicalPackageFilterList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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
! !

!HierarchicalPackageFilterList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::HierarchicalPackageFilterList andSelector:#windowSpec
     Tools::HierarchicalPackageFilterList new openInterface:#windowSpec
     Tools::HierarchicalPackageFilterList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'ProjectList'
          name: 'ProjectList'
          min: (Point 0 0)
          max: (Point 1024 721)
          bounds: (Rectangle 0 0 346 324)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'HierarchicalListView1'
              layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
              tabable: true
              model: hierarchicalProjectSelection
              menu: menuHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              miniScrollerHorizontal: true
              listModel: hierarchicalProjectList
              highlightMode: line
              doubleClickSelector: doubleClicked:
              showLines: false
              indicatorSelector: indicatorPressed:
              properties: 
             (PropertyListDictionary
                dragArgument: nil
                dropArgument: nil
                canDropSelector: canDrop:
                dropSelector: doDrop:
              )
            )
           (LabelSpec
              label: 'Hint: double-click on item to (de)select'
              name: 'Hint'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              translateLabel: true
              adjust: left
            )
           )
         
        )
      )

    "Modified: / 10-10-2007 / 12:25:16 / janfrog"
! !

!HierarchicalPackageFilterList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        environmentHolder
        #packageFilter
      ).

    "Modified: / 10-10-2007 / 12:24:58 / janfrog"
    "Modified: / 24-02-2014 / 10:38:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalPackageFilterList methodsFor:'aspects'!

generateHierarchicalProjectTree
    |anchor|

    self projectList value isNil ifTrue:[
        self updateList.
        self projectList value isNil ifTrue:[
            ^ nil.
        ]
    ].

    anchor := Tools::HierarchicalPackageFilterList::PackageItem new.
    anchor package:''.
    anchor label:nil.

    packageToItemDictionary := IdentityDictionary new.
    packageToItemDictionary at:'' asSymbol put:anchor.

    self projectList value do:[:eachPackageString |
        |package|
        eachPackageString = '* all *' ifFalse:[
            package := eachPackageString asSymbol.
            (packageToItemDictionary includesKey:package) ifFalse:[
                self addPackage:package 
            ]            
        ].
    ].

"/    environment allClassesDo:[:eachClass |
"/        |package|
"/
"/        package := eachClass package asSymbol.
"/        (packageToItemDictionary includesKey:package) ifFalse:[
"/            self addPackage:package 
"/        ].
"/    ].
    anchor recursiveSortChildren:[:i1 :i2 | i1 label asLowercase < i2 label asLowercase].
    anchor expand.
    anchor selected: true.

    ^ anchor

    "Created: / 10-10-2007 / 10:16:57 / janfrog"
    "Modified: / 10-10-2007 / 12:40:52 / janfrog"
!

hierarchicalProjectList
    |anchor |

    hierarchicalProjectList isNil ifTrue:[
        hierarchicalProjectList := HierarchicalList new.
        hierarchicalProjectList showRoot:false.
        hierarchicalProjectList application: self.

        ("self slaveMode value ~~" true) ifTrue:[
            anchor := self generateHierarchicalProjectTree.
            hierarchicalProjectList root:anchor.
            anchor parent: hierarchicalProjectList.
            self setListValid:true.
        ] ifFalse:[
            self setListValid:false
        ]
    ].
    ^ hierarchicalProjectList

    "Created: / 10-10-2007 / 10:36:38 / janfrog"
! !

!HierarchicalPackageFilterList methodsFor:'change & update'!

updatePackageFilter

    | selectedPackages |
    selectedPackages := self hierarchicalProjectList root selectedPackageIDs.
    self packageFilter value: selectedPackages

    "Created: / 10-10-2007 / 12:41:46 / janfrog"
!

updateSelectionFromTree

    "nothing to do"

    "Created: / 10-10-2007 / 12:13:10 / janfrog"
! !

!HierarchicalPackageFilterList methodsFor:'private'!

addPackage:package
    |i p pp l parentPackage parentItem idx|

    i:= packageToItemDictionary at:package asSymbol ifAbsent:nil.
    i isNil ifTrue:[
        i := Tools::HierarchicalPackageFilterList::PackageItem new.
        i package:package.
        packageToItemDictionary at:package asSymbol put:i.

        package size > 0 ifTrue:[
            "/ find the parent ...
            p := package asCollectionOfSubstringsSeparatedByAny:':/.'.
            pp := p copyButLast.
            l := (pp asStringWith:$/) size.
            parentPackage := package copyTo:l.

            parentItem := self addPackage:parentPackage asSymbol .

            parentPackage size == 0 ifTrue:[
                idx := 1.
            ] ifFalse:[
                idx := parentPackage size + 2
            ].
            i label:(package copyFrom:idx).

            parentItem add:i sortBlock:[:i1 :i2 | i1 label asLowercase < i2 label asLowercase].

            "/ TODO: special items for classes, resources etc.
        
        ]
    ].
    ^ i

    "Created: / 10-10-2007 / 10:17:10 / janfrog"
! !

!HierarchicalPackageFilterList methodsFor:'user actions'!

doubleClicked:anIndex

    | selectedPackageItem |
    selectedPackageItem := self hierarchicalProjectList at:
                                self hierarchicalProjectSelection value.
    selectedPackageItem toggleSelection

    "Created: / 10-10-2007 / 10:19:17 / janfrog"
    "Modified: / 10-10-2007 / 12:15:53 / janfrog"
! !

!HierarchicalPackageFilterList::PackageItem class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libtool/Tools__HierarchicalPackageFilterList.st,v 1.8 2014-11-19 21:41:47 cg Exp $'
! !

!HierarchicalPackageFilterList::PackageItem class methodsFor:'image specs'!

checkedIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self checkedIcon inspect
     ImageEditor openOnClass:self andSelector:#checkedIcon
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'Tools::HierarchicalPackageFilterList::PackageItem class checkedIcon'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?07?C?<O?0??@@@@@@b');
                colorMapFromArray:#[ 0 0 0 33 161 33 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
?????<@C0@O@D<@30GOH8<7C38OG@<HC0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 10-10-2007 / 10:52:06 / janfrog"
!

uncheckedIcon
    <resource: #image>
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."
    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."
    "
     self checkFrameForm inspect
     ImageEditor openOnClass:self andSelector:#checkFrameForm
     Icon flushCachedIcons"
    
    ^ Icon 
        constantNamed:#'Tools::HierarchicalPackageFilterList::PackageItem class checkFrameForm'
        ifAbsentPut:[
            (Depth1Image new)
                width:16;
                height:16;
                photometric:(#palette);
                bitsPerSample:(#[ 1 ]);
                samplesPerPixel:(1);
                bits:(ByteArray 
                            fromPackedString:'@@@@@C?<O?0??C?<O?0??C?<O?0??C?<O?0??@@@@@@b');
                colorMapFromArray:#[ 0 0 0 255 255 255 ];
                mask:((ImageMask new)
                            width:16;
                            height:16;
                            bits:(ByteArray 
                                        fromPackedString:'
?????<@C0@O@@<@C0@O@@<@C0@O@@<@C0@O@@?????<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a');
                            yourself);
                yourself
        ]

    "Created: / 10-10-2007 / 10:49:12 / janfrog"
! !

!HierarchicalPackageFilterList::PackageItem methodsFor:'accessing'!

children
    children isNil ifTrue:[
        children := #()
    ].
    ^ children
!

icon

    ^self selected
       ifTrue:[self class checkedIcon]
        ifFalse:[self class uncheckedIcon]

    "Created: / 10-10-2007 / 10:16:04 / janfrog"
    "Modified: / 10-10-2007 / 12:17:50 / janfrog"
!

label

    ^label


    "Modified: / 20-04-2005 / 19:10:49 / janfrog"
!

label:aString
    label ~= aString ifTrue:[
        label := aString.
        self changed:#label
    ].
!

package
    ^ packageID
!

package:prefixOrPackageID
    packageID := prefixOrPackageID
!

packageID
    ^ packageID

    "Created: / 10-10-2007 / 12:09:14 / janfrog"
!

selected
    ^ selected ? false

    "Created: / 10-10-2007 / 12:16:21 / janfrog"
!

selected:aBoolean

   self selected: aBoolean doUpdate: true

    "Created: / 10-10-2007 / 12:16:21 / janfrog"
!

selected:sel doUpdate: doUpdate

    selected := sel.
    self children do:[:child|child selected: sel doUpdate:false].
    doUpdate ifTrue:[
        self model ifNotNil:[
            self model changed.
            self application updatePackageFilter
        ]                            
    ]

    "Created: / 10-10-2007 / 12:19:51 / janfrog"
!

selectedPackageIDs

    | stream |
    stream := OrderedCollection new writeStream.
    self selectedPackageIDsOn: stream.
    ^stream contents

    "Created: / 10-10-2007 / 13:29:35 / janfrog"
!

selectedPackageIDsOn: stream

    self selected ifTrue:[stream nextPut: self packageID].
    self children do:[:child|child selectedPackageIDsOn: stream].

    "Created: / 10-10-2007 / 13:30:18 / janfrog"
! !

!HierarchicalPackageFilterList::PackageItem methodsFor:'user actions'!

toggleSelection

    self selected: self selected not

    "Created: / 10-10-2007 / 12:16:08 / janfrog"
! !

!HierarchicalPackageFilterList class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalPackageFilterList.st,v 1.8 2014-11-19 21:41:47 cg Exp $'
!

version_SVN
    ^ '$Id: Tools__HierarchicalPackageFilterList.st,v 1.8 2014-11-19 21:41:47 cg Exp $'
! !

