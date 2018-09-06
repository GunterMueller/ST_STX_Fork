#encoding ascii

; resources
;
; $Header$

#if Language == #af                 "afrikaans"
# include 'af.rs'
#endif

#if Language == #bs                 "bosnian"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'bs.rs'
#endif

#if Language == #ca                 "catalan"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'ca.rs'
#endif

#if Language == #cs                 "czech"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'cs.rs'
#endif

#if Language == #da                 "danish"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'da.rs'
#endif

#if Language == #de                 "german"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'de.rs'
#endif

#if Language == #el                 "greek"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-7')
# include 'el.rs'
#endif

#if Language == #en                 "english"
# include 'en.rs'
#endif

#if Language == #eo                 "esperanto"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'eo.rs'
#endif

#if Language == #es                 "spanish"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'es.rs'
#endif

#if Language == #et                 "estonian"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'et.rs'
#endif

#if Language == #fr                 "french"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'fr.rs'
#endif

#if Language == #it                 "italian"
# include 'it.rs'
#endif

#if Language == #fi                 "finnish"
# include 'fi.rs'
#endif

#if Language == #hu                 "hungarian"
# include 'hu.rs'
#endif

#if Language == #ja                 "japanese"
'PREFERRED_FONT_ENCODINGS'          #('unicode' 'jis0208*')
# include 'ja.rs'
#endif

#if Language == #ko                 "korean"
'PREFERRED_FONT_ENCODINGS'          #('unicode' )
# include 'ko.rs'
#endif

#if Language == #la                 "latin"
# include 'la.rs'
#endif

#if Language == #nl                 "dutch"
# include 'nl.rs'
#endif

#if Language == #no                 "norwegian"
# include 'no.rs'
#endif

#if Language == #pl                 "polish"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'pl.rs'
#endif

#if Language == #pt                 "portuguese"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'pt.rs'
#endif

#if Language == #ro                 "romania"
PREFERRED_FONT_ENCODINGS            #('unicode')
# include 'ro.rs'
#endif

#if Language == #ru                 "russian"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-5' 'koi8-r')
# include 'ru.rs'
#endif

#if Language == #sl                 "slovenian"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'sl.rs'
#endif

#if Language == #sk                 "slovak"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-2')
# include 'sk.rs'
#endif

#if Language == #sv                 "swedish"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'sv.rs'
#endif

#if Language == #tr                 "turkish"
PREFERRED_FONT_ENCODINGS            #('unicode' )
# include 'tr.rs'
#endif

#if Language == #zh                 "chinese"
PREFERRED_FONT_ENCODINGS            #('unicode' )
# if (LanguageTerritory == #trad)
#  include 'zh_trad.rs'
# else
#  include 'zh.rs'
# endif
#endif


;
; fallbacks - (?) means: if not already defined, define as.
;

PREFERRED_FONT_ENCODINGS            ? #('unicode' 'iso8859-1')

#if (LanguageTerritory == #us)
'TIME_FORMAT'                       ? 12
#else
'TIME_FORMAT'                       ? 24
#endif

#if (Smalltalk releaseIdentification = 'Smalltalk/X jv')
'LICENCEFILE'                           'english/LICENCE_FREE_STX.html'
#else 
# if (Smalltalk releaseIdentification = 'ST/X_free_demo_vsn')
'LICENCEFILE'                           'english/LICENCE_FREE_STX.html'
# else
'LICENCEFILE'                           'english/LICENCE_STX.html'
# endif
#endif
; 'LICENCEFILE'                       ? 'doc/online/english/LICENCE_STX.html'

MENU_Help       [ (View styleSheet at:#useQuestForHelp) == true ifTrue:'?' ifFalse:[ View resources at:'Help'] ]
