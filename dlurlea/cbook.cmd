/*Rexx: clean Mozilla bookmarks.html */

/* parameter 1: filename */
parse arg name

/* handle help request */
if name=='' | name=='?' | name=='/?' | name = '-?' then
  do
    Say 'Usage: cbook.cmd bookmarks.html'
    Return 99
  end

/* error, if file does not even exist */
if Stream(name, 'c', 'query exist') == '' then
  do
    Say 'file' name 'does not exist.'
    Return 99
  end

/* read all lines, ignoring garbage */
comment=0
r = 0
j = 0
do while lines(name)
   r = r + 1
   ibuf = linein(name)
   jbuf = Strip(Translate(ibuf))
   
   /* skip comments from Netscape 4.6 DE */
   if jbuf == '' then Iterate
   if jbuf == '<!-- DIESE DATEI WIRD AUTOMATISCH GENERIERT.' then Iterate
   if jbuf == 'SIE WIRD GELESEN UND üBERSCHRIEBEN.' then Iterate
   if jbuf == 'DIE DATEI NICHT BEARBEITEN! -->' then Iterate
   
   /* skip comments from Mozilla 1.7 */
   if jbuf == '<!-- THIS IS AN AUTOMATICALLY GENERATED FILE.' then Iterate
   if jbuf == 'IT WILL BE READ AND OVERWRITTEN.' then Iterate
   if jbuf == 'DO NOT EDIT! -->' then Iterate
   
   if Pos(' ADD_DATE="',ibuf)>0 then
     do
       Parse Var ibuf ibuf1 ' ADD_DATE="' dummy '"' ibuf2
       ibuf = ibuf1||ibuf2
     end

   if Pos(' ICON="',ibuf)>0 then
     do
       Parse Var ibuf ibuf1 ' ICON="' dummy '"' ibuf2
       ibuf = ibuf1||ibuf2
     end

   if Pos(' LAST_VISIT="',ibuf)>0 then
     do
       Parse Var ibuf ibuf1 ' LAST_VISIT="' dummy '"' ibuf2
       ibuf = ibuf1||ibuf2
     end

   if Pos(' LAST_MODIFIED="',ibuf)>0 then
     do
       Parse Var ibuf ibuf1 ' LAST_MODIFIED="' dummy '"' ibuf2
       ibuf = ibuf1||ibuf2
     end

   if Pos(' LAST_CHARSET="',ibuf)>0 then
     do
       Parse Var ibuf ibuf1 ' LAST_CHARSET="' dummy '"' ibuf2
       ibuf = ibuf1||ibuf2
     end

   if Pos(' ID="',ibuf)>0 then
     do
       Parse Var ibuf ibuf1 ' ID="' dummy '"' ibuf2
       if dummy<>'NC:PersonalToolbarFolder' then
         ibuf = ibuf1||ibuf2
     end

   /* PERSONAL_TOOLBAR_FOLDER="true" ? */
   
   
   /* when having a 'recurivly' sorted file, 
      we can very effiently remove duplicates 
      - in the same subfolder */
      
   if j>0 then if lines.j=ibuf then iterate

   j = j + 1
   lines.j = ibuf
end
Say 'Read' r 'lines,'

/* write back remaining lines */
if (j>0) then do
   call lineout name
   '@call del 'name
   lines.0 = j
   do i = 1 to lines.0
      call lineout name, lines.i
   end
   call lineout name
end
Say 'Wrote' j 'lines.'

/* done, successful */
return 0
