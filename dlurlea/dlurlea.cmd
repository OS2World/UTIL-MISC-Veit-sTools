/* Rexx: Attach .SUBJECT/.URL EA, that contain the URL, to Mozilla downloads
 * 2004.12.04 Veit Kannegieser
 * 2004.12.06 Use->Parse Arg, %mozilla_home%
 * 2004.12.07 %mozilla_home% without Mozilla\Profiles\
 * .......... ANSI logo
 * .......... %MOZILLA_HOME%\Mozilla\Firefox\Profiles\xkec69kd.default\downloads.rdf
 * 2005.01.15 ANSI markup for filename
 * .......... cleanup recommendation when more than 100 obsolete entries exist
 * 2005.03.24 look in os2.ini file for mozilla home dir
 * 2005.04.22 configuration option to handle only mozilla/firefox
 * .......... codepage 1004/1252/819
 */

/*** Please configure **********************************************/

process_mozilla=1
process_firefox=1
show_ansi_logo=1
overwrite_existing_ea=1
allow_delay=1
debug=0

/*******************************************************************/

Call RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
Call SysLoadFuncs
Call SysCls

if show_ansi_logo then
  do
    Say "[01;1H[0;1;5;34;47m[K"
    Say "[02;1H[K"
    Say "[03;1H                                      мппл[K"
    Say "[04;1H            ллллллллллллллллллллм   мп мп[K"
    Say "[05;1H            ллпллплппллпллллллллллмлмпп[K"
    Say "[06;1H            лл лл л л л лллллллплмллм[K"
    Say "[07;1H            лл лл л мпл лллллллммллллп[K"
    Say "[08;1H            лл пп л л л пплллллллллп[K"
    Say "[09;1H            лллллллллллллллллллллп[K"
    Say "[10;1H            пппппппппппппппппппп[K"
    Say "[11;1H[K"
    Say "[12;1H[0m"
  end

Parse Arg Param
if (Param='-?') | (Param='/?') then
  do
    Say 'Usage: DlUrlEA.cmd [path\downloads.rdf]'
    Say 'if file is not specified, the program will try to search it..'
    Exit 1
  end

Call init_unicode_to_codepage
/*Say Decode_UTF8('D:\neu\1'||'c3'x||'a4'x||'1')*/

if Param<>'' then
  do
    Exit Do_downloads_rdf(Param)
  end


/* to locate search Mozialla\Profiles\%user%\profile directory */
home        =Value('HOME'        ,,'OS2ENVIRONMENT')
mozilla_home=Value('MOZILLA_HOME',,'OS2ENVIRONMENT')
programs    =Value('PROGRAMS'    ,,'OS2ENVIRONMENT')
home_ini    =Strip(SysIni('USER', 'Mozilla', 'Home'),,'0'X)

handeled_downloads_rdf=0

/* D:\extra\home\veit\Mozilla\Profiles\Veit\8pkcqdh4.slt\downloads.rdf */
/* D:\extra\home\veit\Mozilla\Firefox\Profiles\xkec69kd.default\downloads.rdf */
if process_mozilla then if home_ini<>'ERROR:' then call Do_Mozilla home_ini'\Mozilla\Profiles\'
if process_firefox then if home_ini<>'ERROR:' then call Do_Mozilla home_ini'\Mozilla\Firefox\Profiles\'
if handeled_downloads_rdf then signal search_done

if process_mozilla then if mozilla_home<>''   then call Do_Mozilla mozilla_home'\Mozilla\Profiles\'
if process_firefox then if mozilla_home<>''   then call Do_Mozilla mozilla_home'\Mozilla\Firefox\Profiles\'
if handeled_downloads_rdf then signal search_done

if mozilla_home<>'' then call Do_Mozilla mozilla_home'\'
if handeled_downloads_rdf then Return 0

if process_mozilla then if home<>''           then call Do_Mozilla home'\Mozilla\Profiles\'
if process_firefox then if home<>''           then call Do_Mozilla home'\Mozilla\Firefox\Profiles\'
if handeled_downloads_rdf then signal search_done

if home<>'' then         call Do_Mozilla home'\'
if handeled_downloads_rdf then signal search_done

if programs<>'' then     call Do_Mozilla programs'\browser'
if handeled_downloads_rdf then signal search_done

if programs<>'' then     call Do_Mozilla programs'\'
if handeled_downloads_rdf then signal search_done

Say 'Sorry, can not find it. Please set %MOZILLA_HOME% for me.'
if allow_delay then Call SysSleep 5
Return 1

search_done:
if allow_delay then Call SysSleep 2
Return 0

/*******************************************************************/

Do_Mozilla:
  Parse Arg home_mozilla_profiles

  /* does that directory exist? -- if not, silently skip */
  if \ DirectoryExist(home_mozilla_profiles) then
    do
      if debug then Say '"'home_mozilla_profiles'" does not exist, skipping.'
      Return 1
    end

  /* search all 'downloads.rdf' in profile subdirs */
  rc=SysFileTree(home_mozilla_profiles'downloads.rdf', 'downloads_rdf', 'FSO')
  if rc<>0 then
    do
      Say 'Search for downloads.rdf failed, rc='rc
      Return rc
    end
  if downloads_rdf.0==0 then
    do
      Say 'No file downloads.rdf found in 'home_mozilla_profiles'..'
      Return 99
    end
  do i=1 to downloads_rdf.0
    call Do_downloads_rdf downloads_rdf.i
    handeled_downloads_rdf=1-debug
  end
  Return 0

/*******************************************************************/

Do_downloads_rdf:
  Parse Arg RDF
  Say '[0;7m***' RDF '... ***[K[0m'

  if Stream(RDF, 'C', 'Query Exist')=='' then
    do
      Say 'does not exist!'
      Return 1
    end

  Call Stream RDF, 'C', 'Open Read'
  filename=''
  fileurl=''
  count_descriptions=0
  count_found=0
  count_changed=0
  do while Lines(RDF)
    line=LineIn(RDF)
    select
      when Pos('</RDF:Description>',line)>0 then
        do
          /* block end */
          if (filename<>'') & (fileurl<>'') then
            do

              if debug then
                do
                  Say '* ' filename
                  Say '  ' fileurl
                end

              count_descriptions=count_descriptions+1

              /* does the downloaded file still exist in the downloaded directory? */
              if Stream(filename, 'C', 'Query Exist')<>'' then
                do

                  count_found=count_found+1

                  /* debug: use undocumented type command option
                  '@cmd.exe /c type -ea:'filename
                   */

                  /* query current value */
                  if SysGetEA(filename, '.SUBJECT', 'current_subject')<>0 then
                    current_subject=''

                  if SysGetEA(filename, '.URL', 'current_url')<>0 then
                    current_url=''

                  new_subject='fd'x'ff'x||D2C(Length(fileurl)//256)||D2C(Length(fileurl)%256)||fileurl

                  /* no change, skip */
                  if (current_subject<>new_subject) & (current_url<>new_subject) then
                    do

                      if (current_subject=='') | (current_url=='') | overwrite_existing_ea then
                        do
                          Say filename
                          count_changed=count_changed+1
                        end

                      /* write when empty, or when overwrite is allowed */
                      if (current_subject=='') | overwrite_existing_ea then
                        do
                          rc=SysPutEA(filename, '.SUBJECT', new_subject)
                          if rc<>0 then
                            Say 'Failed! rc='rc
                        end

                      /* write when empty, or when overwrite is allowed */
                      if (current_url=='') | overwrite_existing_ea then
                        do
                          rc=SysPutEA(filename, '.URL', new_subject)
                          if rc<>0 then
                            Say 'Failed! rc='rc
                        end

                    end /* different */

                end /* exist */
              else
                do
                  if debug then Say filename 'does not exist!'
                end


            end /* <>'' */

          filename=''
          fileurl=''
        end
      when Pos('<RDF:Description about="',line)>0 then
        do
          /* block begin */
          filename=''
          fileurl=''
        end
      when Pos('<NC:File resource="',line)>0 then
        do
          /* <NC:File resource="D:\neu\w420041105d.zip"/> */
          Parse Var line . '<NC:File resource="' filename '"/>' .
          filename=Decode_UTF8(filename)
        end
      when Pos('<NC:File RDF:resource="',line)>0 then
        do
          /* Firefox:<NC:File RDF:resource="D:\neu\1УЄ1.txt"/> */
          Parse Var line . '<NC:File RDF:resource="' filename '"/>' .
          filename=Decode_UTF8(filename)
        end
      when  Pos('<NC:URL resource="',line)>0 then
        do
          /*     <NC:URL resource="ftp://testcase.boulder.ibm.com/ps/fromibm/os2/w420041105d.zip"/> */
          Parse Var line . '<NC:URL resource="' fileurl '"/>' .
        end
      when  Pos('<NC:URL RDF:resource="',line)>0 then
        do
          /* FF: <NC:URL RDF:resource="file:///M:/1%841.txt"/> */
          Parse Var line . '<NC:URL RDF:resource="' fileurl '"/>' .
        end
      otherwise
        nop
      end
  end
  Call Stream RDF, 'C', 'Close'
  Say '    found' count_descriptions 'entries,' count_found 'files, applied extended attribute to' count_changed 'files.'
  if count_changed + 100 < count_descriptions then
    Say '    [31;1mcleanup recommended ...[0m'
  Return 0

/*******************************************************************/

Decode_UTF8:
  /*
    <NC:URL resource="http://quarz/t2/1%841.txt"/>
    <NC:File resource="D:\neu\1УЄ1"/>    */
  Parse Arg String
  /* would nice to have:
  if RxFuncQuery('RxConvertStringUTF8toCurrentCodepage')=0 then
    Return RxConvertStringUTF8toCurrentCodepage(String) */

  String2=''
  sp=1
  sl=Length(String)
  do while sp<=sl
    /* U-00000000 - U-0000007F: 0xxxxxxx
       U-00000080 - U-000007FF: 110xxxxx 10xxxxxx
       U-00000800 - U-0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
       U-00010000 - U-001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
       U-00200000 - U-03FFFFFF: 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
       U-04000000 - U-7FFFFFFF: 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx */
    b1=X2B(C2X(SubStr(String,sp,1)))
    sp=sp+1
    select
      when Abbrev(b1,'0') then
        u=SubStr(b1,2,7)
      when Abbrev(b1,'110') then
        u=SubStr(b1,4,5)||GetContinueBits()
      when Abbrev(b1,'1110') then
        u=SubStr(b1,5,4)||GetContinueBits()||GetContinueBits()
      when Abbrev(b1,'11110') then
        u=SubStr(b1,6,3)||GetContinueBits()||GetContinueBits()||GetContinueBits()
      when Abbrev(b1,'111110') then
        u=SubStr(b1,7,2)||GetContinueBits()||GetContinueBits()||GetContinueBits()||GetContinueBits()
      when Abbrev(b1,'1111110') then
        u=SubStr(b1,8,1)||GetContinueBits()||GetContinueBits()||GetContinueBits()||GetContinueBits()||GetContinueBits()
      otherwise
        u=X2B(C2X('X')) /* error */
    end

    u=X2D(B2X(u))
    z=D2C(u)
    do ii=0 to 255
      if curcp.ii=u then
        do
          z=D2C(ii)
          Leave
        end
    end

    String2=String2||z
  end

  Return String2

/*******************************************************************/

GetContinueBits:
  sp=sp+1
  aa=X2B(C2X(SubStr(String,sp-1,1)))
  if Substr(aa,1,2)<>'10' then
    do
      Say 'UTF8 Decoding error.'
      Exit 99
    end
  Return Substr(aa,3,6)

/*******************************************************************/

init_unicode_to_codepage:

  do ii=0 to 255
    curcp.ii=ii
  end

  ProcessCodePage=QueryProcessCodePage()

  select
    when ProcessCodePage=850 then
      do
        cp850='0000 263a 263b 2665 2666 2663 2660 2022 25d8 25cb 25d9 2642 2640 266a 266b 263c',
              '25ba 25c4 2195 203c 00b6 00a7 25ac 21a8 2191 2193 2192 2190 221f 2194 25b2 25bc',
              '0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 002a 002b 002c 002d 002e 002f',
              '0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 003a 003b 003c 003d 003e 003f',
              '0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 004a 004b 004c 004d 004e 004f',
              '0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 005a 005b 005c 005d 005e 005f',
              '0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 006a 006b 006c 006d 006e 006f',
              '0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 007a 007b 007c 007d 007e 2302',
              '00c7 00fc 00e9 00e2 00e4 00e0 00e5 00e7 00ea 00eb 00e8 00ef 00ee 00ec 00c4 00c5',
              '00c9 00e6 00c6 00f4 00f6 00f2 00fb 00f9 00ff 00d6 00dc 00f8 00a3 00d8 00d7 0192',
              '00e1 00ed 00f3 00fa 00f1 00d1 00aa 00ba 00bf 00ae 00ac 00bd 00bc 00a1 00ab 00bb',
              '2591 2592 2593 2502 2524 00c1 00c2 00c0 00a9 2563 2551 2557 255d 00a2 00a5 2510',
              '2514 2534 252c 251c 2500 253c 00e3 00c3 255a 2554 2569 2566 2560 2550 256c 00a4',
              '00f0 00d0 00ca 00cb 00c8 20ac 00cd 00ce 00cf 2518 250c 2588 2584 00a6 00cc 2580',
              '00d3 00df 00d4 00d2 00f5 00d5 00b5 00fe 00de 00da 00db 00d9 00fd 00dd 00af 00b4',
              '00ad 00b1 2017 00be 00b6 00a7 00f7 00b8 00b0 00a8 00b7 00b9 00b3 00b2 25a0 00a0'
        do ii=0 to 255
          curcp.ii=X2D(SubStr(cp850,1+ii*5,4))
        end
      end /* 850 */

    when ProcessCodePage=437 then
      do
        cp437='0000 263a 263b 2665 2666 2663 2660 2022 25d8 25cb 25d9 2642 2640 266a 266b 263c',
              '25ba 25c4 2195 203c 00b6 00a7 25ac 21a8 2191 2193 2192 2190 221f 2194 25b2 25bc',
              '0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 002a 002b 002c 002d 002e 002f',
              '0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 003a 003b 003c 003d 003e 003f',
              '0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 004a 004b 004c 004d 004e 004f',
              '0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 005a 005b 005c 005d 005e 005f',
              '0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 006a 006b 006c 006d 006e 006f',
              '0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 007a 007b 007c 007d 007e 2302',
              '00C7 00FC 00E9 00E2 00E4 00E0 00E5 00E7 00EA 00EB 00E8 00EF 00EE 00EC 00C4 00C5',
              '00C9 00E6 00C6 00F4 00F6 00F2 00FB 00F9 00FF 00D6 00DC 00A2 00A3 00A5 20A7 0192',
              '00E1 00ED 00F3 00FA 00F1 00D1 00AA 00BA 00BF 2310 00AC 00BD 00BC 00A1 00AB 00BB',
              '2591 2592 2593 2502 2524 2561 2562 2556 2555 2563 2551 2557 255D 255C 255B 2510',
              '2514 2534 252C 251C 2500 253C 255E 255F 255A 2554 2569 2566 2560 2550 256C 2567',
              '2568 2564 2565 2559 2558 2552 2553 256B 256A 2518 250C 2588 2584 258C 2590 2580',
              '03B1 00DF 0393 03C0 03A3 03C3 03BC 03C4 03A6 0398 03A9 03B4 221E 03C6 03B5 2229',
              '2261 00B1 2265 2264 2320 2321 00F7 2248 00B0 2219 00B7 221A 207F 00B2 25A0 00A0'

        do ii=0 to 255
          curcp.ii=X2D(SubStr(cp437,1+ii*5,4))
        end
      end /* 437 */

    when ProcessCodePage=819 then /* ISO 8859-1 */
      do
        nop /* could mask out 1X,2X,8X,9X */
      end /* 819 */

    when (ProcessCodePage=1004) | (ProcessCodePage=1252) then /* Windows Extended | Latin 1 Windows */
      do /* only difference 00AF/203E */
        cp1004='0000 0001 0002 0003 0004 0005 0006 0007 0008 0009 000A 000B 000C 000D 000E 000F',
               '0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 001C 001B 007F 001D 001E 001F',
               '0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 002A 002B 002C 002D 002E 002F',
               '0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 003A 003B 003C 003D 003E 003F',
               '0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 004A 004B 004C 004D 004E 004F',
               '0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 005A 005B 005C 005D 005E 005F',
               '0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 006A 006B 006C 006D 006E 006F',
               '0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 007A 007B 007C 007D 007E 001A',
               '20AC FFFF 201A 0192 201E 2026 2020 2021 02C6 2030 0160 2039 0152 FFFF 017D FFFF',
               'FFFF 2018 2019 201C 201D 2022 2013 2014 02DC 2122 0161 203A 0153 FFFF 017E 0178',
               '00A0 00A1 00A2 00A3 00A4 00A5 00A6 00A7 00A8 00A9 00AA 00AB 00AC 00AD 00AE 203E',
               '00B0 00B1 00B2 00B3 00B4 00B5 00B6 00B7 00B8 00B9 00BA 00BB 00BC 00BD 00BE 00BF',
               '00C0 00C1 00C2 00C3 00C4 00C5 00C6 00C7 00C8 00C9 00CA 00CB 00CC 00CD 00CE 00CF',
               '00D0 00D1 00D2 00D3 00D4 00D5 00D6 00D7 00D8 00D9 00DA 00DB 00DC 00DD 00DE 00DF',
               '00E0 00E1 00E2 00E3 00E4 00E5 00E6 00E7 00E8 00E9 00EA 00EB 00EC 00ED 00EE 00EF',
               '00F0 00F1 00F2 00F3 00F4 00F5 00F6 00F7 00F8 00F9 00FA 00FB 00FC 00FD 00FE 00FF'
        do ii=0 to 255
          curcp.ii=X2D(SubStr(cp1004,1+ii*5,4))
        end
      end /* 1004 | 1252 */

    otherwise
      Say 'Warning: do not have unicode translation table for current codepage..'
      Say 'Please ask author for codepage' ProcessCodePage 'support!'
      nop
  end
  Return

/*******************************************************************/

QueryProcessCodePage:
  if RxFuncQuery('SysQueryProcessCodePage')=0 then
    Return SysQueryProcessCodePage()
  Return 850

/*******************************************************************/

DirectoryExist:
  Parse Arg directory
  /* a directory exist for our purpose if it has any files in it... */
  if SysFileTree(directory'*', 'dirp', 'B')<>0 then Return 0
  Return dirp.0>0

/*******************************************************************/
