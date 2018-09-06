"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015 Jan Vrany
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

ChangeList subclass:#HierarchicalChangeList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-ChangeSet'
!

!HierarchicalChangeList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015 Jan Vrany
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

!HierarchicalChangeList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."


    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::HierarchicalChangeList andSelector:#windowSpec
     Tools::HierarchicalChangeList new openInterface:#windowSpec
     Tools::HierarchicalChangeList open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'ChangeList'
          name: 'ChangeList'
          min: (Point 10 10)
          bounds: (Rectangle 0 0 300 300)
        )
        component: 
       (SpecCollection
          collection: (
           (HierarchicalListViewSpec
              name: 'List'
              layout: (LayoutFrame 0 0 0 0 0 1 0 1)
              model: selectionHolder
              menu: menuHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              listModel: listHolder
              multipleSelectOk: true
              useIndex: false
              highlightMode: line
              showLines: false
              useDefaultIcons: false
              postBuildCallback: postBuildListView:
            )
            (InputFieldSpec
            name: 'Filter'
            layout: (LayoutFrame 0 0 0 0 0 1 26 0)
            initiallyInvisible: true
            model: filterPatternHolder
            immediateAccept: true
            acceptOnLeave: false
            acceptOnReturn: false
            acceptOnTab: false
            acceptOnPointerLeave: false
            emptyFieldReplacementText: 'Search Filter...'
            usePreferredHeight: true
            useDynamicPreferredHeight: true
            postBuildCallback: postBuildFilterView:
            )
           )
         
        )
      )

    "Modified: / 20-12-2011 / 10:31:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 20-12-2011 / 16:20:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalChangeList methodsFor:'aspects'!

listHolder
    "return/create the 'changeList' value holder (automatically generated)"
    
    listHolder isNil ifTrue:[
        listHolder := (HierarchicalList new)            
                    showRoot:false;
                    application: self;
                    yourself
    ].
    ^ listHolder

    "Created: / 25-07-2009 / 23:34:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!HierarchicalChangeList methodsFor:'event processing'!

buttonPress:button x:x y:y view:aView

    | itemIndex item |

    button ~= 1 ifTrue:[^aView buttonPress:button x:x y:y].

    itemIndex := aView yVisibleToLineNr:y.
    itemIndex isNil ifTrue:[^self].
    itemIndex == 0 ifTrue:[^self].
    itemIndex > aView list size ifTrue:[^self].
    item := aView list at: itemIndex.

    ((aView left + x) between: (item x) and: ((item x ? 0) + 16))
        ifFalse:[^aView buttonPress:button x:x y:y].

    item removed: item removed not.
    aView invalidate

    "Created: / 08-12-2009 / 14:12:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:55:41 / cg"
    "Modified: / 26-07-2012 / 18:21:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlesButtonPress:button inView:aView
    ^ listView scrolledView == aView

    "Created: / 08-12-2009 / 14:08:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 10-04-2014 / 11:23:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalChangeList methodsFor:'private'!

listColumn: columnId visible: visible
    "Nothing to do here"

    "Created: / 26-07-2012 / 18:42:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listColumnHide: columnId
    "Nothing to do here"

    "Created: / 26-07-2012 / 18:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

listColumnShow: columnId
    "Nothing to do here"

    "Created: / 26-07-2012 / 18:43:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawListItemAt: index
    listView notNil ifTrue:[ 
        index ~~ 0 ifTrue:[ 
            listView invalidateLineAt:index.                      
         ].
    ]

    "Created: / 20-08-2015 / 16:19:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    |inGenerator changeset root|

    inGenerator := self inGeneratorHolder value.
    changeset := inGenerator ifNil:[ #() ] ifNotNil:[ inGenerator ].
    root := self listEntryFor: (CompositeChange name:'Change set' changes:changeset).
    root children do:[:e|e expand].

    self listHolder root:root

    "Modified: / 04-12-2011 / 15:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalChangeList class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__HierarchicalChangeList.st,v 1.9 2014-04-10 09:59:55 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__HierarchicalChangeList.st,v 1.9 2014-04-10 09:59:55 vrany Exp $'
! !

