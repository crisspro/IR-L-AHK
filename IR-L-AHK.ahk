;nombre: Ir-L-AHK
;Autor: crisspro
;Año: 2020
;Licencia: GPL-3.0


ScriptNombre:= "IR-L-AHK"
VSTNombre:= "IR-L"
VSTControl:= "WaveShell2-VST"

xg:= 0
yg:= 0
VSTControlDetectado:= False
VSTNombreDetectado:= False


;funciones

;mensajes

;carga NVDA
nvdaSpeak(text)
{
Return DllCall("nvdaControllerClient" A_PtrSize*8 ".dll\nvdaController_speakText", "wstr", text)
}

hablar(es,en)
{
Lector:= "otro"
process, Exist, nvda.exe
if ErrorLevel != 0
{
Lector:= "nvda"
if (InStr(A_language,"0a") = "3")
nvdaSpeak(es)
else
nvdaSpeak(en)
}
process, Exist, jfw.exe
if ErrorLevel != 0
{
Lector:= "jaws"
Jaws := ComObjCreate("FreedomSci.JawsApi")
if (InStr(A_language,"0a") = "3")
Jaws.SayString(es)
else
Jaws.SayString(en)
}
If global Lector = "otro"
{
Sapi := ComObjCreate("SAPI.SpVoice")
Sapi.Rate := 5
Sapi.Volume :=90
if (InStr(A_language,"0a") = "3")
Sapi.Speak(es)
else
Sapi.Speak(en)
}
}

SetTitleMatchMode,2

;inicio
SoundPlay,sounds/start.wav, 1
hablar(ScriptNombre " activado",ScriptNombre " ready")

;chequea actualización

;conectado(flag=0x40) { 
;Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0) 
;}

;If (conectado())
;{
;MsgBox, conectado!
;return
;}

;detecta el plugin
loop
{
WinGet, VentanaID,Id,A
winget, controles, ControlList, A
IfWinActive,%VSTNombre%
{
VSTNombreDetectado:= True
loop, parse, controles, `n
{
if A_LoopField contains %VSTControl%
{
VSTControlDetectado:= True
ControlGetPos, x,y,a,b,%A_loopField%, ahk_id %VentanaID% 
xg:= x
yg:= y
break
}
else
VSTControlDetectado:= False
}
}
else
VSTNombreDetectado:= False
}

;atajos
#If VSTControlDetectado= True and VSTNombreDetectado= True

;cargar
l::MouseClick, LEFT, xg+401, yg+6

;guardar
g::MouseClick, LEFT, xg+453, yg+7

;cambia al Impulso anterior.
a::
MouseClick,LEFT, xg+295, yg+7
hablar("anterior", "back")
return

;cambia al siguiente preset.
s::
MouseClick,LEFT, xg+321, yg+6 
hablar("siguiente", "next")
return

;Marcar preset (A B)
m::
MouseClick, LEFT, xg+359, yg+8
SoundPlay,sounds/mark.wav
sleep 10
hablar("marcado", "marcked")
return

;cambio de preset marcado
c::
MouseClick, LEFT, xg+225, yg+6
hablar("cambio", "change")
return
 
;deshacer
z::
MouseClick, LEFT, xg+82, yg+12
hablar("deshacer", "undo the changes")
return

;rehacer
r::
MouseClick, LEFT, xg+122, yg+7
hablar("rehacer", "redo changes")
return

;abre la ayuda.
f1::
if (InStr(A_language,"0a") = "3")
Run Documentation\es.html
else
Run Documentation\en.html
return

;sale del script.
^q:: 
hablar(ScriptNombre " cerrado",ScriptNombre " closed")
SoundPlay,sounds/exit.wav,1
ExitApp
return