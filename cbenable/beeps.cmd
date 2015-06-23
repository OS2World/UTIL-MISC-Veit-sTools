/*REXX: Play CBENABLE error sounds */
'@cls'

Say 'Playing CBENABLE error sounds...'
Say ''

Say '- "cardbus not supported!"'
call Beep 1000, 1000
call Beep 2000, 1000
call Beep 1000, 1000
call Beep 2000, 1000
'@pause'

Say '- "success!"'
call Beep 8000, 50
'@pause'

Say '- "resource problem!"'
call Beep 2000, 1000
call Beep 3000, 1000
call Beep 2000, 1000
'@pause'

'@pause'