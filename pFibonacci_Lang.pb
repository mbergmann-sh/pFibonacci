; -----------------------------------------------------------------------------
;           Name: pFibonacci GUI
;    Description: calculate Fibonacci Iterations
;         Author: Michael Bergmann
;           Date: 2023-02-02
;        Version: 1.0
;     PB-Version: 6.0 LTS
;             OS: Windows
;         Credit: hier gibt's kein Kredit!
;          Forum: Farum Föffelstiel
;     Created by: Micha B. 2023
; -----------------------------------------------------------------------------

EnableExplicit

Global LangFolder.s = "Lang"

Structure Lang
  Map LangKey.s()
EndStructure
Global NewMap Lang.Lang()

;- ----- Public  -----
Macro GetLang(Section, Keyname)
  ReplaceCrlfQuote(Lang(UCase(Section))\LangKey(UCase(Keyname)))
EndMacro

Macro GetInterfaceLang(Keyname)
  ReplaceCrlfQuote(Lang("INTERFACE")\LangKey(UCase(Keyname)))
EndMacro

Macro GetTooltipLang(Keyname)
  ReplaceCrlfQuote(Lang("TOOLTIP")\LangKey(UCase(Keyname)))
EndMacro

Macro GetMenuLang(Keyname)
  ReplaceCrlfQuote(Lang("MENU")\LangKey(UCase(Keyname)))
EndMacro

Macro GetToolBarLang(Keyname)
  ReplaceCrlfQuote(Lang("TOOLBAR")\LangKey(UCase(Keyname)))
EndMacro

Macro GetStatusBarLang(Keyname)
  ReplaceCrlfQuote(Lang("STATUSBAR")\LangKey(UCase(Keyname)))
EndMacro

Macro GetMessageLang(Keyname)
  ReplaceCrlfQuote(Lang("MESSAGE")\LangKey(UCase(Keyname)))
EndMacro

Declare.s LocaleInfo(LCType.i = #LOCALE_SNATIVELANGNAME)
Declare.s ReplaceCrlfQuote(String.s)
Declare   LangLoadDefault()
Declare   LangLoad(Filename.s = "")
Declare   LangSaveFile(Filename.s)
Declare   LangSave(Filename.s)

;- ----- Private -----
Procedure.s LocaleInfo(LCType.i = #LOCALE_SNATIVELANGNAME)
  Protected LCData.s, LCDataLen.i
  ; MS: The application should call GetLocaleInfoEx function in preference To GetLocaleInfo If designed To run only on Windows Vista And later. But it works
  LCDataLen = GetLocaleInfo_(#LOCALE_USER_DEFAULT, LCType, @LCData, 0)
  LCData = Space(LCDataLen)
  If GetLocaleInfo_(#LOCALE_USER_DEFAULT, LCType, @LCData, LCDataLen)
    ProcedureReturn LCData
  EndIf
EndProcedure

Procedure.s ReplaceCrlfQuote(String.s)
  Protected NewString.s, NewString2.s, I.i
  For I = 1 To CountString(String, "+#CRLF$+")  + 1
    If I = 1
      NewString2 + StringField(String, I, "+#CRLF$+")
    Else
      NewString2 + #CRLF$ + StringField(String, I, "+#CRLF$+")
    EndIf
  Next
  For I = 1 To CountString(NewString2, "+#DQUOTE$+")  + 1
    If I = 1
      NewString + StringField(NewString2, I, "+#DQUOTE$+")
    Else
      NewString + #DQUOTE$ + StringField(NewString2, I, "+#DQUOTE$+")
    EndIf
  Next
  ProcedureReturn NewString
EndProcedure

Procedure LangLoadDefault()
  Protected Section.s = "COMMON", Keyname.s, Value.s
  ClearMap(Lang())
  Restore DefaultLang:
  Repeat
    Read.s Keyname
    Read.s Value
    Keyname = UCase(Keyname)
    Select Keyname
      Case "", "_END_"
        Break
      Case "_SECTION_"
        Section = UCase(Value)
      Default
        Lang(Section)\LangKey(Keyname) = Value
        ;Debug Section + "\" + Keyname + "=" + Value
    EndSelect
  ForEver
  ProcedureReturn #True
EndProcedure

Procedure LangLoad(Filename.s = "")
  If Filename
    If OpenPreferences(LangFolder + "\" + Filename)       
      ForEach Lang()
        PreferenceGroup(MapKey(Lang()))
        ForEach Lang()\LangKey()
          Lang()\LangKey() = ReadPreferenceString(MapKey(Lang()\LangKey()), Lang()\LangKey())
        Next
      Next
      ClosePreferences()
    Else
      ProcedureReturn #False
    EndIf
  EndIf
  ProcedureReturn #True    
EndProcedure

Procedure LangSaveFile(Filename.s)
  PreferenceGroup("Info")   ;just in case we need this information sometimes
  WritePreferenceString("Program", GetFilePart(ProgramFilename()))
  WritePreferenceString("Version", "1.00")
  ForEach Lang()       
    PreferenceGroup(MapKey(Lang()))
    ForEach Lang()\LangKey()
      If ReadPreferenceString(MapKey(Lang()\LangKey()), "") = ""
        WritePreferenceString(MapKey(Lang()\LangKey()), Lang()\LangKey())
      EndIf
    Next
  Next
EndProcedure

Procedure LangSave(Filename.s)
  If Filename
    If FileSize(LangFolder) = -1 : CreateDirectory(LangFolder) : EndIf
    If FileSize(LangFolder) = -2
      If MapSize(Lang()) = 0 : LangLoadDefault() : EndIf
      If OpenPreferences(LangFolder + "\" + Filename, #PB_Preference_GroupSeparator)
        LangSaveFile(Filename)
      ElseIf CreatePreferences(LangFolder + "\" + Filename, #PB_Preference_GroupSeparator)
        PreferenceComment("Language File")
        LangSaveFile(Filename)
      Else
        ProcedureReturn #False
      EndIf
      ClosePreferences()
      ProcedureReturn #True
    EndIf
  EndIf
  ProcedureReturn #False
EndProcedure


;- ----- Main    -----

; -----------------------------------------------------------------------------------------------------------------------------
; Via LocaleInfo() is for Windows only, see Keya's topic for Linux or MacOS: https://www.purebasic.fr/english/viewtopic.php?t=66552
; -----------------------------------------------------------------------------------------------------------------------------
Define NativeLangName.s = LocaleInfo()   ; Or use LocaleInfo(#LOCALE_SENGLANGUAGE) For English Name
NativeLangName = UCase(Left(NativeLangName, 1)) + Mid(NativeLangName, 2)

If NativeLangName = "English"
  LangLoadDefault()
Else
  Define LangFileName.s = NativeLangName + ".lang"   ; Or use LangFileName = "French.lang"
  
  ; Create the language file if it does not already exist. Otherwise update the language file with possible keywords addition and without changing the current values
  LangSave(LangFileName)
  
  ; Load the default language then update with the language file translated values
  LangLoad(LangFileName)
EndIf


; -----------------------------------------------------------------------------------------------------------------------------
; Or, if you want to let the user choose his language  Via a Combobox for example with LangName$ = GetGadgetText(#LangName) :
; -----------------------------------------------------------------------------------------------------------------------------
; Select LangName$ = "English"
;     LangLoadDefault()
;   Case "French"
;     LangSave(LangName$ + ".lang")
;     LangLoad(LangName$ + ".lang")
;   Case "Deutsch"
;     LangSave(LangName$ + ".lang")
;     LangLoad(LangName$ + ".lang")
;   Default
;     LangLoadDefault()
; EndSelect


; -----------------------------------------------------------------------------------------------------------------------------
; To save a new Language file template or refresh the language file with new keywords.
; -----------------------------------------------------------------------------------------------------------------------------
; LangLoadDefault()
; LangSave("French.lang")


DataSection
  ; Here the default language is specified (usually in English). It is a list of Section and of Key name with its Value,
  ;
  ; With some special Keywords for the Section:
  ;   "_SECTION_" will indicate a new Section in the datasection, the second value is the Section name
  ;   "_END_" will indicate the end of the language list (as there is no fixed number)
  ;
  ; Note: The Section and Key name are case insensitive to make live easier :)
  
  DefaultLang:
  ; =========================================================================
  Data.s "_SECTION_",                             "Interface"
  ; =========================================================================
  Data.s "Window_0_Txt_1",                        "Fn from"
  Data.s "Window_0_Txt_2",                        "to"
  Data.s "Window_0_Btn_Clear_1",                  "&Clear"
  Data.s "Window_0_Btn_Calculate_1",              "C&alculate"

  ; =========================================================================
  Data.s "_SECTION_",                             "Tooltip"
  ; =========================================================================
  Data.s "Window_0_Cont_1",                       "Enter Parameters for Fibonacci number calculation"
  Data.s "Window_0_Spin_Start",                   "Start where?"
  Data.s "Window_0_Spin_Max",                     "How many iterations?"

  ; =========================================================================
  Data.s "_SECTION_",                             "Menu"
  ; =========================================================================

  ; =========================================================================
  Data.s "_SECTION_",                             "ToolBar"
  ; =========================================================================

  ; =========================================================================
  Data.s "_SECTION_",                             "StatusBar"
  ; =========================================================================

  ; =========================================================================
  Data.s "_SECTION_",                             "Message"
  ; =========================================================================

  ; =========================================================================
  Data.s "_END_",                                 ""
  ; =========================================================================
EndDataSection

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 11
; Folding = ---
; EnableXP
; DPIAware