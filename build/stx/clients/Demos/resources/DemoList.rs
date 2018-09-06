"/
"/ $Header: /cvs/stx/stx/clients/Demos/resources/DemoList.rs,v 1.1 1995-10-27 18:57:14 cg Exp $
"/ this files defines which applications should be offered in
"/ the launchers demo menu.
"/
"/ each entry consists of:
"/
"/ - name of the demo (list-entry)
"/ - short explanation
"/ - class name
"/ - file name to load (or nil if autoloaded)
"/ - startup selector
"/
"/ one of classname and filename must be non-nil
"/

#(  ButtonAndLabelDemo1 
    'how to handle buttons and labels'
    ButtonAndLabelDemo1
    'BDemo1.st'
    start
 )

#(  ButtonAndLabelDemo2 
    'how to handle buttons and labels;
like ButtonAndLabelDemo1 but looking better'
    ButtonAndLabelDemo2
    'BDemo2.st'
    start
 )

#(  ButtonAndLabelDemo3 
    'how to handle buttons and labels;
like ButtonAndLabelDemo2 but adds more buttons'
    ButtonAndLabelDemo3
    'BDemo3.st'
    start
 )
