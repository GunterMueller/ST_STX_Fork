"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

AbstractSearchDialog subclass:#MethodSearchDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!MethodSearchDialog class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!MethodSearchDialog class methodsFor:'interface specs-content'!

optionsPaneSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SmallSense::ClassSearchDialog andSelector:#optionsPaneSpec
     SmallSense::ClassSearchDialog new openInterface:#optionsPaneSpec
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: optionsPaneSpec
       window: 
      (WindowSpec
         label: 'Search Options...'
         name: 'Search Options...'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 634 25)
       )
       component: 
      (SpecCollection
         collection: (
          (VerticalPanelViewSpec
             name: 'Options'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             horizontalLayout: fit
             verticalLayout: fit
             horizontalSpace: 3
             verticalSpace: 3
             component: 
            (SpecCollection
               collection: (
                (CheckBoxSpec
                   label: 'Match fully qualified class names'
                   name: 'CheckBox1'
                   model: matchFullyQualifiedClassNameHolder
                   extent: (Point 634 25)
                 )
                )
              
             )
           )
          )
        
       )
     )
! !

!MethodSearchDialog methodsFor:'accessing-defaults'!

defaultProcessorClass
    "superclass SmallSense::AbstractListDialog says that I am responsible to implement this method"

    ^ ImplementorSearchProcessor

    "Created: / 12-12-2014 / 23:21:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTitle
    ^ (resources string: 'Search Method...')

    "Created: / 05-05-2014 / 23:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodSearchDialog methodsFor:'initialization'!

initialize  
    super initialize.
    processor := ImplementorSearchProcessor new.

    "Created: / 13-12-2014 / 08:46:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

