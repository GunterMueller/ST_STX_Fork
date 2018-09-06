"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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

LintRuleList subclass:#HierarchicalLintRuleList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!HierarchicalLintRuleList class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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

!HierarchicalLintRuleList class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::HierarchicalLintRuleList andSelector:#windowSpec
     Tools::HierarchicalLintRuleList new openInterface:#windowSpec
     Tools::HierarchicalLintRuleList open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'SmallLintRuleList'
         name: 'SmallLintRuleList'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (InputFieldSpec
             name: 'RuleFilter'
             layout: (LayoutFrame 0 0 0 0 0 1 30 0)
             model: filterHolder
             immediateAccept: true
             acceptOnReturn: true
             acceptOnTab: true
             acceptOnPointerLeave: true
             emptyFieldReplacementText: 'Rule Search'
           )
          (HierarchicalListViewSpec
             name: 'RuleList'
             layout: (LayoutFrame 0 0 30 0 0 1 0 1)
             model: listSelection
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             listModel: listHolder
             useIndex: false
             highlightMode: line
             showLines: false
             useDefaultIcons: false
             postBuildCallback: postBuildList:
           )
          )
        
       )
     )
! !

!HierarchicalLintRuleList class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #environmentHolder
        #inGeneratorHolder
        #listSelection
        #modeHolder
        #outGeneratorHolder
        #selectionHolder
      ).

! !

!HierarchicalLintRuleList methodsFor:'aspects'!

listHolder
    listHolder isNil ifTrue:[
        listHolder := (HierarchicalList new)
                    showRoot:false;
                    application:self;
                    yourself
    ].
    ^ listHolder

    "Created: / 15-04-2010 / 20:32:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalLintRuleList methodsFor:'private'!

updateList
    |inGenerator filterS inRules root|

    inGenerator := self inGeneratorHolder value.
    filterS := self filterHolder value.
    filterS notEmptyOrNil ifTrue:[
         (filterS startsWith: $*) ifFalse:[filterS := '*' , filterS].
         (filterS endsWith:   $*) ifFalse:[filterS := filterS , '*']
    ].
    (inGenerator isNil and: [self mode == #display])
        ifTrue:[inGenerator := RBCompositeLintRule allRules rules ].
    inRules := OrderedCollection new.
    filterS isEmptyOrNil 
        ifTrue:[
            inGenerator do:[:rule | inRules add:rule ]]
        ifFalse:[
            inGenerator do:[:rule|
                rule flattened do:[:each|
                    ((each name matches: filterS caseSensitive: false) 
                    or:[ (each class name matches: filterS caseSensitive: false) ])
                        ifTrue: [inRules add: each]]]].
    root := (self 
                listEntryFor:(RBCompositeLintRule rules:inRules name:'Rules'))
                parent:self listHolder;
                expand;
                yourself.
    root children do:[:e | 
        e expand
    ].
    self listHolder root:root.
    self setListValid:true.

    "Created: / 15-04-2010 / 20:39:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-04-2010 / 09:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-08-2010 / 11:56:39 / Jan Vrany <enter your email here>"
    "Modified: / 08-03-2012 / 03:11:19 / cg"
! !

!HierarchicalLintRuleList class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

