s/(\*\$IFDEF VIRTUALPASCAL/(\*\$IfDef VirtualPascal/g
s/(\*\$IFNDEF VIRTUALPASCAL/(\*\$IfNDef VirtualPascal/g
s/(\*\$ELSE VIRTUALPASCAL/(\*\$Else VirtualPascal/g
s/(\*\$ENDIF VIRTUALPASCAL/(\*\$EndIf VirtualPascal/g

s/(\*\$IFDEF /(\*\$IfDef /g
s/(\*\$IFNDEF /(\*\$IfNDef /g
s/(\*\$ELSE /(\*\$Else /g
s/(\*\$ENDIF /(\*\$EndIf /g
s/(\*\$DEFINE /(\*\$Define /g
s/(\*\$UNDEF /(\*\$UnDef /g
s/(\*\$IFOPT /(\*\$IfOpt /g

s/(\*\$FRAME/(\*\$Frame/g
s/(\*\$USES/(\*\$Uses/g

s/(\*\$IFDEF\*)/(\*\$IfDef\*)/g
s/(\*\$IFNDEF\*)/(\*\$IfNDef\*)/g
s/(\*\$ELSE\*)/(\*\$Else\*)/g
s/(\*\$ENDIF\*)/(\*\$EndIf\*)/g
s/(\*\$DEFINE\*)/(\*\$Define\*)/g
s/(\*\$UnDef\*)/(\*\$UnDef\*)/g
