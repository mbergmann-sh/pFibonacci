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

;- Enumerations
Enumeration Window
  #Window_0
EndEnumeration

Enumeration Gadgets
  #Window_0_Cont_1
  #Window_0_Txt_1
  #Window_0_Spin_Start
  #Window_0_Txt_2
  #Window_0_Spin_Max
  #Window_0_Btn_Clear_1
  #Window_0_Btn_Calculate_1
  #Window_0_Edit_Output
EndEnumeration

Global AppQuit, Result

;- Declare
Declare Open_Window_0(X = 0, Y = 0, Width = 250, Height = 170)

XIncludeFile "ObjectColor.pbi"
XIncludeFile "pFibonacci_Lang.pb"
XIncludeFile "pFibonacci_Event.pb"

Procedure Open_Window_0(X = 0, Y = 0, Width = 250, Height = 170)
  If OpenWindow(#Window_0, X, Y, Width, Height, "pFibonacci GUI", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
    ContainerGadget(#Window_0_Cont_1, 0, 0, 250, 170, #PB_Container_Single)
      GadgetToolTip(#Window_0_Cont_1, GetTooltipLang("Window_0_Cont_1"))
      TextGadget(#Window_0_Txt_1, 10, 10, 50, 20, GetInterfaceLang("Window_0_Txt_1"), #PB_Text_Center)
      SpinGadget(#Window_0_Spin_Start, 60, 10, 50, 20, 0, 93, #PB_Spin_ReadOnly|#PB_Spin_Numeric)
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows : SetWindowLongPtr_(GadgetID(#Window_0_Spin_Start), #GWL_STYLE, GetWindowLongPtr_(GadgetID(#Window_0_Spin_Start), #GWL_STYLE) | #ES_NUMBER) : CompilerEndIf
        SetGadgetState(#Window_0_Spin_Start, 0)
        GadgetToolTip(#Window_0_Spin_Start, GetTooltipLang("Window_0_Spin_Start"))
      TextGadget(#Window_0_Txt_2, 110, 10, 80, 20, GetInterfaceLang("Window_0_Txt_2"), #PB_Text_Center)
      SpinGadget(#Window_0_Spin_Max, 190, 10, 50, 20, 0, 93, #PB_Spin_ReadOnly|#PB_Spin_Numeric)
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows : SetWindowLongPtr_(GadgetID(#Window_0_Spin_Max), #GWL_STYLE, GetWindowLongPtr_(GadgetID(#Window_0_Spin_Max), #GWL_STYLE) | #ES_NUMBER) : CompilerEndIf
        SetGadgetState(#Window_0_Spin_Max, 3)
        GadgetToolTip(#Window_0_Spin_Max, GetTooltipLang("Window_0_Spin_Max"))
      ButtonGadget(#Window_0_Btn_Clear_1, 10, 40, 110, 24, GetInterfaceLang("Window_0_Btn_Clear_1"))
      ButtonGadget(#Window_0_Btn_Calculate_1, 140, 40, 100, 24, GetInterfaceLang("Window_0_Btn_Calculate_1"))
      EditorGadget(#Window_0_Edit_Output, 10, 70, 230, 90, #PB_Editor_ReadOnly)
    CloseGadgetList()   ; #Window_0_Cont_1

    BindGadgetEvent(#Window_0_Spin_Start, @Event_Window_0_Spin_Start())
    BindGadgetEvent(#Window_0_Spin_Max, @Event_Window_0_Spin_Max())
    BindGadgetEvent(#Window_0_Btn_Clear_1, @Event_Window_0_Btn_Clear_1())
    BindGadgetEvent(#Window_0_Btn_Calculate_1, @Event_Window_0_Btn_Calculate_1())
    BindEvent(#PB_Event_SizeWindow, @Resize_Window_0(), #Window_0)
    PostEvent(#PB_Event_SizeWindow, #Window_0, 0)

    WindowBounds(#Window_0, 210, 170, #PB_Ignore, #PB_Ignore)

    SetObjectColor()
  EndIf
EndProcedure

CompilerIf (#PB_Compiler_IsMainFile)
;- Main Program
Open_Window_0()

;- Event Loop
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Result = MessageRequester("Programm beenden", "Möchten Sie das Programm wirklich beenden?", #PB_MessageRequester_YesNo|#PB_MessageRequester_Warning)
      If Result = #PB_MessageRequester_Yes       ; Ja-Schalter wurde gedrückt
        AppQuit = #True
      EndIf   
      ;-> Event Gadget
    Case #PB_Event_Gadget
      Select EventGadget()
      EndSelect

  EndSelect
Until AppQuit
CompilerEndIf

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 41
; FirstLine = 36
; Folding = -
; Optimizer
; EnableAsm
; EnableThread
; EnableXP
; EnableUser
; DPIAware
; UseIcon = accessories-calculator-4.ico