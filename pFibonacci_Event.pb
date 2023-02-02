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

;- Declare
Declare Event_Window_0_Spin_Start()
Declare Event_Window_0_Spin_Max()
Declare Event_Window_0_Btn_Clear_1()
Declare Event_Window_0_Btn_Calculate_1()
Declare Resize_Window_0()
Declare Calc_Fibonacci(start.l, iterations.l)
Declare Set_Defaults()

Procedure Set_Defaults()
  ClearGadgetItems(#Window_0_Edit_Output)
  SetGadgetState(#Window_0_Spin_Start, 0)  
  SetGadgetState(#Window_0_Spin_Max, 3)   
EndProcedure

Procedure Calc_Fibonacci(start.l, iterations.l)
  Define.l start, iterations, out 
  Define.s meldung, output 
  Define N.q
  Dim fibArray.q(iterations + 1) 
 
  ;-> prepare and fill fibArray
  fibArray(0)  = 0
  fibArray(1)  = 1
  
  N = 1 
    
  Repeat   
    ; -> compute next Fibonacci number
    fibArray(N + 1) = fibArray(N) + fibArray(N - 1)
    
    ;PrintN("N = " + Str(N) + ". Step: " + Str(fibArray(N)))
    N = N + 1
  Until N = (iterations + 1) ;-> beware of array index!  
  
  ;-> Empty output gadget
  ClearGadgetItems(#Window_0_Edit_Output)
  
  ;-> Prepare Output
  meldung = "Fn = " + Str(start) + ~", iterations = \n" + Str(iterations)
  ;AddGadgetItem(#Window_0_Edit_Output, -1, meldung)
  
  start = GetGadgetState(#Window_0_Spin_Start)
  iterations = GetGadgetState(#Window_0_Spin_Max)
  For out = start To iterations
    meldung = Str(start) + ". Fibonacci-Zahl = " + Str(fibArray(start))  
    AddGadgetItem(#Window_0_Edit_Output, -1, meldung)
    start = start + 1
  Next out
  
EndProcedure

Procedure Event_Window_0_Spin_Start()
  Define.l start, iterations
 
  start = GetGadgetState(#Window_0_Spin_Start)
  iterations = GetGadgetState(#Window_0_Spin_Max)
  
  ; -> Correct values if start gets bigger than iterations
  If start >= iterations
        SetGadgetState(#Window_0_Spin_Max, start + 1)
  EndIf    
EndProcedure

Procedure Event_Window_0_Spin_Max()
   Define.l start, iterations
   
   start = GetGadgetState(#Window_0_Spin_Start)
   iterations = GetGadgetState(#Window_0_Spin_Max)
  
   ; -> Correct values if iterations gets smaller than start
   If iterations <= start
     If iterations = 0
       iterations = 1
       SetGadgetState(#Window_0_Spin_Max, iterations)
       MessageRequester("Korrektur", ~"Es macht wirklich keinen Sinn, NULL\nIterationen durchzuführen!\nDer Wert wurde automatisch korrigiert.", #PB_MessageRequester_Ok|#PB_MessageRequester_Warning)
     EndIf
     
        SetGadgetState(#Window_0_Spin_Start, iterations - 1)
   EndIf   
EndProcedure

Procedure Event_Window_0_Btn_Clear_1()
  Select EventType()
    Case #PB_EventType_LeftClick
      Set_Defaults()
  EndSelect
EndProcedure

Procedure Event_Window_0_Btn_Calculate_1()
  Select EventType()
    Case #PB_EventType_LeftClick
      Calc_Fibonacci(GetGadgetState(#Window_0_Spin_Start), GetGadgetState(#Window_0_Spin_Max)) 
  EndSelect
EndProcedure

Procedure Resize_Window_0()
  Protected ScaleX.f, ScaleY.f
  Static Window_0_WidthIni, Window_0_HeightIni
  Static Window_0_Cont_1_WidthIni, Window_0_Cont_1_HeightIni
  If Window_0_WidthIni = 0
    Window_0_WidthIni = WindowWidth(#Window_0) : Window_0_HeightIni = WindowHeight(#Window_0)
    Window_0_Cont_1_WidthIni = GadgetWidth(#Window_0_Cont_1) : Window_0_Cont_1_HeightIni = GadgetHeight(#Window_0_Cont_1)
  EndIf

  ScaleX = WindowWidth(#Window_0) / Window_0_WidthIni : ScaleY = WindowHeight(#Window_0) / Window_0_HeightIni
  ResizeGadget(#Window_0_Cont_1, ScaleX * 0, ScaleY * 0, ScaleX * 250, ScaleY * 170)
  ScaleX = GadgetWidth(#Window_0_Cont_1) / Window_0_Cont_1_WidthIni : ScaleY = GadgetHeight(#Window_0_Cont_1) / Window_0_Cont_1_HeightIni
  ResizeGadget(#Window_0_Txt_1, ScaleX * 10, ScaleY * 10, ScaleX * 50, ScaleY * 20)
  ResizeGadget(#Window_0_Spin_Start, ScaleX * 60, ScaleY * 10, ScaleX * 50, ScaleY * 20)
  ResizeGadget(#Window_0_Txt_2, ScaleX * 110, ScaleY * 10, ScaleX * 80, ScaleY * 20)
  ResizeGadget(#Window_0_Spin_Max, ScaleX * 190, ScaleY * 10, ScaleX * 50, ScaleY * 20)
  ResizeGadget(#Window_0_Btn_Clear_1, ScaleX * 10, ScaleY * 40, ScaleX * 110, ScaleY * 24)
  ResizeGadget(#Window_0_Btn_Calculate_1, ScaleX * 140, ScaleY * 40, ScaleX * 100, ScaleY * 24)
  ResizeGadget(#Window_0_Edit_Output, ScaleX * 10, ScaleY * 70, ScaleX * 230, ScaleY * 90)
EndProcedure

; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 23
; FirstLine = 19
; Folding = --
; EnableXP
; DPIAware