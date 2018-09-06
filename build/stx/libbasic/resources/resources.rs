#encoding ascii

;
; $Header: /cvs/stx/stx/libbasic/resources/resources.rs,v 1.8 2008/11/28 16:44:55 cg Exp $
;

#if Language == #af
# include 'af.rs'
#endif

#if Language == #ar
# include 'ar.rs'
#endif

#if Language == #cs
# include 'cs.rs'
#endif

#if Language == #da
# include 'da.rs'
#endif

#if Language == #de
# include 'de.rs'
#endif

#if Language == #el
# include 'el.rs'
#endif

#if Language == #en
# include 'en.rs'
#endif

#if Language == #eo
# include 'eo.rs'
#endif

#if Language == #es
# include 'es.rs'
#endif

#if Language == #fi
# include 'fi.rs'
#endif

#if Language == #fr
# include 'fr.rs'
#endif

#if Language == #hu
# include 'hu.rs'
#endif

#if Language == #it
# include 'it.rs'
#endif

#if Language == #ja
# include 'ja.rs'
#endif

#if Language == #la
# include 'la.rs'
#endif

#if Language == #nl
# include 'nl.rs'
#endif

#if Language == #no
# include 'no.rs'
#endif

#if Language == #pt
# include 'pt.rs'
#endif

#if Language == #ro
# include 'ro.rs'
#endif

#if Language == #ru
# include 'ru.rs'
#endif

#if Language == #sk
# include 'sk.rs'
#endif

#if Language == #sl
# include 'sl.rs'
#endif

#if Language == #sv
# include 'sv.rs'
#endif

#if Language == #th
# include 'th.rs'
#endif

#if Language == #tr
# include 'tr.rs'
#endif

#if Language == #uk
# include 'uk.rs'
#endif

#if Language == #zh                 "chinese traditional"
# if (LanguageTerritory == #trad)
#  include 'zh_trad.rs'
# else
#  include 'zh.rs'
# endif
#endif


;
; fallback - use english strings for missing messages
;
#include 'en.rs'


#if (LanguageTerritory == #us)
'TIME_FORMAT'                       ? 12
#else
'TIME_FORMAT'                       ? 24
#endif







