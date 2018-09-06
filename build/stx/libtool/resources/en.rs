#encoding utf8

; $Header$

;--------------------------------------------------------------------------------------------
;
; Workspace
;

;--------------------------------------------------------------------------------------------
;
; SystemBrowser resources
;

HELP_CCAT_LIST          ? 'lists class categories.\All classes are organized into these categories for your\convenience.\Select a category to see the corresponding classes.\The special entry ``all'''' shows a full alphabetic list,\while ``hierarchy'''' shows them by inheritance.\\Class categories have no semantic meaning.'
HELP_CLASS_LIST         ? 'lists classes by name.\Select a class to see its definition below and methods to the right.'
HELP_HCLASS_LIST        ? 'lists classes along the superclass chain.\Select a class to see its definition below and methods to the right.'
HELP_PCLASS_LIST        ? 'lists classes along the superclass chain.\Select any to strike it out and have its methods ignored\in the method lists.'
HELP_MCAT_LIST          ? 'lists method categories.\All methods are organized into these categories for your\convenience.\Select a category to see the corresponding methods\or ``all'''', for a full list.\\Method categories have no semantic meaning.'
HELP_METHOD_LIST        ? 'lists methods by selector.\Select any to see the methods source code below.\You will find many useful search and debug functions in its menu;\some of them take default input from the selected text in the view below.'
HELP_CLSMTHOD_LIST      ? 'lists methods found by your query by class and selector.\Select any to see the methods source code below.'
HELP_VAR_LIST           ? 'lists the instance or class variables of the selected class.\The list includes inherited variables.\Select any to highlight methods which refer to this variable.\The popupMenu offers for more search functions\on variable accesses/modifications.'
HELP_CODE_VIEW          ? 'shows the selected classes definition\or the selected methods source code.\You can edit the text and install changes by ``accepting''''.\To change your mind and go back to the original version,\simply select the class or method again.\Have a look at its popupMenu for edit functions;\some of them are also available via keyboard shortcuts.'
HELP_FULLCODE_VIEW      ? 'shows the selected classes complete source in fileOut format.\You can edit the text and reinstall the class by ``accepting''''.\To change your mind and go back to the original version,\simply select the class or method again.\Have a look at its popupMenu for edit functions;\some of them are also available via keyboard shortcuts.'
HELP_INST_CLASS_TOGGLE  ? 'these two toggles switch between\class and instance protocol.\\The instance protocol is understood by objects\which are instances of the selected class or a subclass,\while the class protocol is understood\by the class itself (and subclasses).'
HELP_NS_BOX             ? 'namespace filter; only classes in the selected namespace are listed.'

'SPAWN_CATEGORY'        ? 'Spawn'
'SPAWN_CLASS'           ? 'Spawn '
'SPAWN_METHODCATEGORY'  ? 'Spawn'
'SPAWN_METHOD'          ? 'Spawn '

'WARN_RENAME'           ? 'A class named %1 already exists (in ''%2'')\\that class will no longer be visible (i.e. removed) if you continue.\\Continue ?'
'CREATE_REPOSITORY'     ? 'Creating new source repository container for %1.\\'

;--------------------------------------------------------------------------------------------
;
; ChangesBrowser resources
;
'update view'       ? 'update'

;--------------------------------------------------------------------------------------------
;
; Launcher
;

#if LanguageTerritory == #us
'Licence conditions'                'License Conditions'
'licence conditions'                'license Conditions'
TIME_FORMAT             12
#endif

LANG_MSG        'Select a Language.\\Notice: You need the corresponding text translations to be present in the resource-files.\These might be missing (in part or whole) for some languages in the current version.\\The change will NOT affect views which are already open.\'

#if LanguageTerritory == #uk
'Color Printer'                     'Colour Printer'
'Color Monitor'                     'Colour Monitor'
'use fix color palette %1'          'use fix colour palette %1'
'use fix gray color palette %1'     'use fix grey colour palette %1'
'allow colored/grayscale icons'     'allow coloured/greyscale icons'
'colored octahedron'                'coloured octahedron'
'licence conditions'                'licence conditions'
'Licence Conditions'                'Licence Conditions'
#endif

; 'New FileBrowser'       'New FileBrowser'
; 'New SystemBrowser'     'New SystemBrowser'
'Reload Resources'      'Reload Language Resources'

'CHANGE'                             'Change'

;
; Debugger
;
'Debug_Next'                        'Step Over'
'Debug_Step'                        'Step'
'Debug_Send'                        'Step Into'
'Debug_Terminate'                   'Terminate'

'Browse Receivers Class'            'Browse Receiver's Class'
'Browse Receivers Class Hierarchy'  'Browse Receiver''s Class Hierarchy'
'Browse Receivers Full Protocol'    'Browse Receiver''s Full Protocol'
