#encoding ascii

; resources
;
; $Header$

#superpack      (ResourcePack forPackage:'stx:libview')

;
; Workspace
;
HELLO_UTF_FILE       'Hello_utf8.wsp'
WELCOME_FILE         'Welcome.wsp'
SETUP_FILE           'Setup.wsp'
KEYBOARD_FILE        'Keyboard.wsp'
GETTING_STARTED_FILE 'GettingStarted.wsp'

;
; SystemBrowser
;
; something very special:
; define the name of a file which contains
; a copyright template for the browsers 'generate doc methods'
; function.
; This will be included into the #copyright method
; (I am lazy ;-)
; (Of course, you dont want the eXept copyright text to be
; placed into your code - therefore, we check the domain below.
; Add 3 lines with a check for your domain (or hostname) and
; edit the filename to the location of your copyright template.

#if OperatingSystem getDomainName = 'exept.de'
COPYRIGHT_TEMPLATE_FILE         '../../../eXept/COPYRIGHT.tmpl'
#endif

;
; FileBrowser
;
FILEBROWSER_UPDATE_CHECK_DELTA     10
'ICON_DIRECTORY'          'bitmaps/xpmBitmaps/document_images/tiny_yellow_dir.xpm'
'ICON_DIRECTORY_LOCKED'   'bitmaps/xpmBitmaps/document_images/tiny_yellow_dir_locked.xpm'
'ICON_DIRECTORY_LINK'     'bitmaps/xpmBitmaps/document_images/tiny_yellow_dir_link.xpm'
'ICON_FILE'               'bitmaps/xpmBitmaps/document_images/tiny_file_plain.xpm'
'ICON_FILE_LOCKED'        'bitmaps/xpmBitmaps/document_images/tiny_file_lock.xpm'
'ICON_FILE_LINK'          'bitmaps/xpmBitmaps/document_images/tiny_file_link.xpm'
'ICON_IMAGE_FILE'         'bitmaps/xpmBitmaps/document_images/tiny_file_pix.xpm'
'ICON_TEXT_FILE'          'bitmaps/xpmBitmaps/document_images/tiny_file_text.xpm'

;
; Launcher
;
; Offered languages:
;   most are still very incomplete & may look funny
;   however, enabling them shows at least how it is done
;   and gives editors something to start with.

;
; the ones with territory (ll-tt) will be split
; into Language and LanguageTerritory
;
LIST_OF_OFFERED_LANGUAGES #( \
  'af' \
  "'ar' -- Cannot offer this right now: need right-to-left text support " \
  'cs' \
  'da' \
  'de' \
  'en-uk' \
  'en-us' \
  'el' \
  'eo' \
  'es' \
  'fr' \
  'fi' \
  "'he' -- Cannot offer this right now: need right-to-left text support " \
  'hi' \
  'hr' \
  'hu' \
  'it' \
  'ja' \
  'ko' \
  'la' \
  'nl' \
  'no' \
  'pl' \
  'pt' \
  'pt-br' \
  'ro' \
  'ru' \
  'sk' \
  'sl' \
  'sv' \
  'th' \
  'tr' \
  'zh' \
  'zh-trad' \
)

;
; flags - add one if you add one above.
;
FLAG_af     'bitmaps/xpmBitmaps/countries/s_africa.xpm'
FLAG_ar     'bitmaps/xpmBitmaps/languages/arabic.xpm'
FLAG_cs     'bitmaps/xpmBitmaps/countries/czech.xpm'
FLAG_da     'bitmaps/xpmBitmaps/countries/denmark.xpm'
FLAG_de     'bitmaps/xpmBitmaps/countries/germany.xpm'
FLAG_el     'bitmaps/xpmBitmaps/countries/greece.xpm'
FLAG_en_us  'bitmaps/xpmBitmaps/countries/usa.xpm'
FLAG_en_uk  'bitmaps/xpmBitmaps/countries/uk.xpm'
FLAG_eo     'bitmaps/xpmBitmaps/languages/esperanto.xpm'
FLAG_es     'bitmaps/xpmBitmaps/countries/spain.xpm'
FLAG_fi     'bitmaps/xpmBitmaps/countries/finland.xpm'
FLAG_fr     'bitmaps/xpmBitmaps/countries/france.xpm'
FLAG_he     'bitmaps/xpmBitmaps/countries/israel2.xpm'
FLAG_hi     'bitmaps/xpmBitmaps/countries/india.xpm'
FLAG_hr     'bitmaps/xpmBitmaps/countries/croatia.xpm'
FLAG_hu     'bitmaps/xpmBitmaps/countries/hungary.xpm'
FLAG_it     'bitmaps/xpmBitmaps/countries/italy.xpm'
FLAG_ja     'bitmaps/xpmBitmaps/countries/japan.xpm'
FLAG_ko     'bitmaps/xpmBitmaps/countries/s_korea.xpm'
FLAG_la     'bitmaps/xpmBitmaps/languages/latin.xpm'
FLAG_nl     'bitmaps/xpmBitmaps/countries/netherlands.xpm'
FLAG_no     'bitmaps/xpmBitmaps/countries/norweg.xpm'
FLAG_pl     'bitmaps/xpmBitmaps/countries/poland.xpm'
FLAG_pt     'bitmaps/xpmBitmaps/countries/portug.xpm'
FLAG_pt_br  'bitmaps/xpmBitmaps/countries/brazil.xpm'
FLAG_ro     'bitmaps/xpmBitmaps/countries/romania.xpm'
FLAG_ru     'bitmaps/xpmBitmaps/countries/russia.xpm'
FLAG_sk     'bitmaps/xpmBitmaps/countries/slovakia.xpm'
FLAG_sl     'bitmaps/xpmBitmaps/countries/slovenia.xpm'
FLAG_sv     'bitmaps/xpmBitmaps/countries/sweden.xpm'
FLAG_th     'bitmaps/xpmBitmaps/countries/thailand.xpm'
FLAG_tr     'bitmaps/xpmBitmaps/countries/turkey.xpm'
FLAG_zh       'bitmaps/xpmBitmaps/countries/china.xpm'
FLAG_zh_trad  'bitmaps/xpmBitmaps/countries/taiwan.xpm'

;
; language name in english.
;
'LANG_af'       'Afrikaans'
'LANG_ar'       'Arabic'
'LANG_az'       'Azerbaijani'
'LANG_be'       'Byelorussian'
'LANG_bg'       'Bulgarian'
'LANG_br'       'Breton'
'LANG_ca'       'Catalan'
'LANG_co'       'Corsican'
'LANG_cs'       'Czech'
'LANG_cy'       'Welsh'
'LANG_da'       'Danish'
'LANG_de'       'German'
'LANG_el'       'Greek'
'LANG_en_us'    'English (US)'
'LANG_en_uk'    'English (UK)'
'LANG_eo'       'Esperanto'
'LANG_es'       'Spanish'
'LANG_et'       'Estonian'
'LANG_eu'       'Basque'
'LANG_fa'       'Persian (Farsi)'
'LANG_fi'       'Finnish'
'LANG_fr'       'French'
'LANG_ga'       'Irish'
'LANG_gd'       'Scots Gaelic'
'LANG_gl'       'Galician'
'LANG_he'       'Hebrew'
'LANG_hi'       'Hindi'
'LANG_hr'       'Croatian'
'LANG_hu'       'Hungarian'
'LANG_ia'       'Interlingua'
'LANG_id'       'Indonesian'
'LANG_ie'       'Interlingue'
'LANG_it'       'Italian'
'LANG_ja'       'Japanese'
'LANG_jv'       'Javanese'
'LANG_km'       'Cambodian'
'LANG_ko'       'Korean'
'LANG_la'       'Latin'
'LANG_lt'       'Lithuanian'
'LANG_lv'       'Lettish'
'LANG_mk'       'Macedonian'
'LANG_mo'       'Moldavian'
'LANG_mn'       'Mongolian'
'LANG_my'       'Burmese'
'LANG_nl'       'Dutch'
'LANG_no'       'Norwegian'
'LANG_pl'       'Polish'
'LANG_pt'       'Portuguese'
'LANG_pt_br'    'Portuguese (Brazilian)'
'LANG_rm'       'Rhaeto-Romance'
'LANG_ro'       'Romanian'
'LANG_ru'       'Russian'
'LANG_sa'       'Sanskrit'
'LANG_sh'       'Serbo-Croatian'
'LANG_sk'       'Slovak'
'LANG_sl'       'Slovenian'
'LANG_sr'       'Serbian'
'LANG_sv'       'Swedish'
'LANG_sw'       'Swahili'
'LANG_th'       'Thai'
'LANG_tk'       'Turkmen'
'LANG_tr'       'Turkish'
'LANG_uk'       'Ukrainian'
'LANG_vi'       'Vietnamese'
'LANG_yi'       'Yiddish'
'LANG_zh'       'Chinese (simplified)'
'LANG_zh_trad'  'Chinese (traditional)'
'LANG_zu'       'Zulu'

LIST_OF_OFFERED_SCREEN_SIZES   #('scr_10' 'scr_11' 'scr_15' 'scr_15_16' 'scr_17' 'scr_17_16' 'scr_19' 'scr_21' 'scr_22' 'scr_23' 'scr_24')

; how those sizes present themself in the list and set the size
'scr_10'             #( '10''   (200mm x 150mm)'                 (200 150)  )
'scr_11'             #( '11''   (220mm x 170mm)'                 (220 170)  )
'scr_15'             #( '15''   (300mm x 230mm)'                 (300 230)  )
'scr_15_16'          #( '15'' 16:9 (330mm x 190mm)'              (330 190)  )
'scr_17'             #( '17''   (340mm x 270mm)'                 (340 270)  )
'scr_17_16'          #( '17'' 16:9 (380mm x 210mm)'              (380 210)  )
'scr_19'             #( '19''   (380mm x 300mm)'                 (380 300)  )
'scr_21'             #( '21''   (420mm x 330mm)'                 (420 330)  )
'scr_22'             #( '22'' 16:9 (490mm x 270mm)'              (490 270)  )
'scr_23'             #( '23'' 16:9 (510mm x 290mm)'              (510 290)  )
'scr_24'             #( '24'' 16:9 (530mm x 300mm)'              (530 300)  )


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

#if Language == #fi                 "finnish"
# include 'fi.rs'
#endif

#if Language == #fr                 "french"
PREFERRED_FONT_ENCODINGS            #('unicode' 'iso8859-1')
# include 'fr.rs'
#endif

#if Language == #hr                 "croatian"
# include 'hr.rs'
#endif

#if Language == #hu                 "hungarian"
# include 'hu.rs'
#endif

#if Language == #it                 "italian"
# include 'it.rs'
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
# if LanguageTerritory == #trad         "chinese traditional"
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

;
; fallbacks ('?'-prefix means: if not defined already, then define as).
;
; LANG_MSG        ? 'select a language.\\This requires that the resource files have the\corresponding language strings available.\This may be not the case for all languages/texts in this\version, and you may still see english messages\with some language settings.\\The change will not affect views which are already open.\'
LANG_MSG        ? 'Select a Language.\\Notice:\The change will not affect views which are already open.\'
STYLE_MSG       ? 'Select a Style for Views.\\Some of the non-standard styles are experimental,\provided for fun or for demonstration purposes\and therefore not supported.\Many are not very ergonomic - use them at your\own (eye) risk.\Please read the documentation for more details.\\The style change will not affect views which are\already open.\Please close and reopen all other ST/X windows after\closing this dialog.\'
KEY_MSG         ? 'Please read the documentation on how keys are\assigned to functions and how macros are defined.\'

TRANSCRIPT_HELP        ? 'this is the Transcript.\It is used to send\messages to the user.'
INFOVIEW_HELP          ? 'this shows the name of the current\project and the directory\where a fileOut operation writes the file.'
SBROWSER_BUTTON_HELP   ? 'opens a\SystemBrowser'
FBROWSER_BUTTON_HELP   ? 'opens a\FileBrowser'
CBROWSER_BUTTON_HELP   ? 'opens a\ChangeBrowser'

'licence conditions'    ? 'licence conditions (english)'
