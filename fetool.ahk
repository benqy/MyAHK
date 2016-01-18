^!u::
Send, ^c
UniStr = %clipboard%
CnStr = % uxxxx2cn(UniStr)
ToolTip %CnStr%
clipboard = %CnStr%
SetTimer, RemoveToolTip, 3000
return

uxxxx2cn(s) {
	i := 1
	while j := RegExMatch(s, "\\u[A-Fa-f0-9]{1,4}", m, i)
		e .= SubStr(s, i, j-i) Chr("0x" SubStr(m, 3)), i := j + StrLen(m)
	return e . SubStr(s, i)
}

^!i::
Send, ^c
UniStr = %clipboard%
CnStr =% cn2uxxxx(UniStr)
clipboard = %CnStr%
Send, ^v
return

cn2uxxxx(cnStr)
{ ; from tmplin = A_FormatInteger
    SetFormat, Integer, Hex
    Loop, Parse, cnStr
    {
    	;;\u4E2De
      FoundPos := RegExMatch(A_LoopField, "\p{Han}")
      ;;Msgbox %A_LoopField%
      ;;Msgbox %FoundPos%
    	;;if( A_LoopField = "a")
      if( FoundPos = 0)
      {
      	out .= A_LoopField
      }
      else
      {
        out .= "\u" . SubStr( Asc(A_LoopField), 3 )
      }
    }
    SetFormat, Integer, %OldFormat%
    Return out
}

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return