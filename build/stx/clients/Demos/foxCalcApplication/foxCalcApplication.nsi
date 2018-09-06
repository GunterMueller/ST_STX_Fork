; $Header: /cvs/stx/stx/clients/Demos/foxCalcApplication/foxCalcApplication.nsi,v 1.10 2016-03-27 12:30:14 cg Exp $
; Script generated by ProjectDefinition.

!define PRODUCT_NAME "Smalltalk/X Demo Calculator"
!define PRODUCT_FILENAME "Smalltalk_X Demo Calculator"
!define PRODUCT_VERSION "6.2.5.0"
!define PRODUCT_PUBLISHER "eXept Software AG"
!define PRODUCT_WEB_SITE "http://www.exept.de"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_FILENAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define STX_ROOT "..\..\..\.."

SetCompressor /solid lzma

!include "MUI2.nsh"
!include "x64.nsh"

; MUI Settings

!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
;; !define MUI_ICON "nil.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
;; !define MUI_UNICON "nil.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
; !define MUI_LICENSEPAGE_CHECKBOX


!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

; MUI end ------



Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "6.2.1.19"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright Claus Gittinger 2008"


OutFile "Smalltalk_X Demo CalculatorSetup.exe"
InstallDir "$PROGRAMFILES\exept\stxFoxClone"
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

InstType Full
InstType Partial

Section "Programme" Section1
  SectionIn 1 2
  SetOutPath "$INSTDIR\bin"
  SetOverwrite ifnewer
  File "stxFoxClone.exe"
  File "*.dll"
  File "symbols.stc"
  File "*.stx"
  File "*.rc"
  File /r /x CVS /x ".*" resources





  WriteRegStr HKCR "Stx.Smalltalk_X Demo Calculator.1" "" "Smalltalk_X Demo Calculator File"
  WriteRegStr HKCR "Stx.Smalltalk_X Demo Calculator.1\DefaultIcon" "" '$INSTDIR\bin\stxFoxClone.exe,0'
  WriteRegStr HKCR "Stx.Smalltalk_X Demo Calculator.1\Shell\open" "" $(appOpen)
  WriteRegStr HKCR "Stx.Smalltalk_X Demo Calculator.1\Shell\open\command" "" '"$INSTDIR\bin\stxFoxClone.exe" -- "%1"'
SectionEnd

;; Section "Online-Documentation for Smalltalk/X Demo Calculator" Section2
;;   SectionIn 1
;;   SetOutPath "$INSTDIR\doc"
;;   SetOverwrite ifnewer
;;   File /r /x CVS "${STX_ROOT}\stx\stxFoxClone\doc\*"
;; SectionEnd

;; Section "Smalltalk/X Demo Calculator Libraries and Demos" Section3
;;   SectionIn 1
;;   SetOutPath "$INSTDIR\lib"
;;   SetOverwrite ifnewer
;; ;   File /r /x CVS "${STX_ROOT}\stx\stxFoxClone\examples\*"
;; SectionEnd
;; 
;; Section "Smalltalk/X Demo Calculator Reports and Printing" Section4
;;   SectionIn 1
;;   SetOutPath "$INSTDIR\reportGenerator"
;;   SetOverwrite ifnewer
;; ;  File /r /x CVS "..\reportGenerator\java" "..\reportGenerator\rules" "..\reportGenerator\*.xml" "..\reportGenerator\*.xslt" "..\reportGenerator\CloseApp.exe" "..\reportGenerator\expecco.jpg"
;; SectionEnd








Section -AdditionalIcons
  SetOutPath "$INSTDIR\bin"
  WriteIniStr "$INSTDIR\${PRODUCT_FILENAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\${PRODUCT_FILENAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_FILENAME}\stxFoxClone.lnk" "$INSTDIR\bin\stxFoxClone.exe"
  CreateShortCut "$DESKTOP\stxFoxClone.lnk" "$INSTDIR\bin\stxFoxClone.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_FILENAME}\Website.lnk" "$INSTDIR\${PRODUCT_FILENAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_FILENAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

LangString appOpen ${LANG_GERMAN}  "Mit Smalltalk/X Demo Calculator �ffnen"
LangString appOpen ${LANG_ENGLISH} "Open with Smalltalk/X Demo Calculator"

LangString DESC_Section1 ${LANG_ENGLISH} "Program components of Smalltalk/X Demo Calculator"
LangString DESC_Section1 ${LANG_GERMAN}  "Alle Programmkomponenten von Smalltalk/X Demo Calculator"
;; LangString DESC_Section2 ${LANG_ENGLISH} "Online-Documentation of Smalltalk/X Demo Calculator"
;; LangString DESC_Section2 ${LANG_GERMAN}  "Online-Dokumentation zu Smalltalk/X Demo Calculator"
;; LangString DESC_Section3 ${LANG_ENGLISH} "Libraries and Demo Projects"
;; LangString DESC_Section3 ${LANG_GERMAN}  "Bibliotheken und Beispielprojekte"
;; LangString DESC_Section4 ${LANG_ENGLISH} "Logfile Printing and Report Generation"
;; LangString DESC_Section4 ${LANG_GERMAN}  "Drucken und Report-Generierung aus Log-Dateien"
;; LangString DESC_Section3 ${LANG_ENGLISH} "Sources of ST/X (Base-System)"
;; LangString DESC_Section3 ${LANG_GERMAN}  "Quellcode von ST/X (Basis-System)"
;; LangString DESC_Section4 ${LANG_ENGLISH} "Sources of Smalltalk/X Demo Calculator"
;; LangString DESC_Section4 ${LANG_GERMAN}  "Quellcode von Smalltalk/X Demo Calculator"


!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
;;   !insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
;;  !insertmacro MUI_DESCRIPTION_TEXT ${Section3} $(DESC_Section3)
;;  !insertmacro MUI_DESCRIPTION_TEXT ${Section4} $(DESC_Section4)

!insertmacro MUI_FUNCTION_DESCRIPTION_END



Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "Smalltalk/X Demo Calculator wurde erfolgreich deinstalliert"
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "M�chten Sie Smalltalk/X Demo Calculator und alle seine Komponenten deinstallieren?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_FILENAME}.url"
  Delete "$INSTDIR\uninst.exe"

    Delete "$INSTDIR\*"
    RMDir /r "$INSTDIR"

  Delete "$SMPROGRAMS\${PRODUCT_FILENAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_FILENAME}\Website.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_FILENAME}\stxFoxClone.lnk"
  Delete "$DESKTOP\stxFoxClone.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_FILENAME}"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKCR "Stx.Smalltalk_X Demo Calculator.1"



  SetAutoClose true
SectionEnd
