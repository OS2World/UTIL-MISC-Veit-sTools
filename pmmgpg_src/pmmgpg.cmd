/* REXX */

/*******************************************************************/
/* limited PGP 2.x imitation for PMMail using GnuPG                */
/* Veit Kannegieser 2006-03-21                                     */
/*******************************************************************/

Signal on NOVALUE name ErrorREXX
Signal on SYNTAX  name ErrorREXX
Signal on FAILURE name ErrorREXX
Signal on HALT    name HaltREXX

MyVersion = '2006-04-25'

StdErr = 'StdErr' /* no idea why this is not defined sometimes */

Call RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
Call SysLoadFuncs


/* debugging */
Verbose = Value('PGP_GPG_VERBOSE', , 'OS2ENVIRONMENT') <> ''
/*Verbose = 1*/

/* temporary filename to do some rewording on the messages */
StdErrTemp = SysTempFileName(Value('TEMP', , 'OS2ENVIRONMENT')'\PGP?????.002')
if StdErrTemp == '' then
  Return 99

passphrase_file = Value('TEMP', , 'OS2ENVIRONMENT')'\PGP_PASS.TXT'

/* PMMAIl seem to have PGP 2.x and 5.x commands
 *
 * decode:
 * "/c GPG.EXE +bat +int=off +pa=cat +verb=0 -f +la=en +char=noconv -ft -z"777" -u veit@kannegieser.net < .\TEMP\TEMP.BOD 2> .\TEMP\TEMP.ERR 1> .\TEMP\TEMP.PGP"
 *             v +batchmode -f -z123
 *
 * encrypt + sign:
 *             +cl -fat -se -z"" veit@kannegieser.net veit@kannegieser.net -u veit@kannegieser.net
 *
 * encrypt:
 *             +cl -fat -e veit@kannegieser.net veit@kannegieser.net
 *
 * sign:
 *             +cl -fat -s -z"" -u veit@kannegieser.net
 *
 * include public key:
 *             +bat +int=off +pa=cat +verb=0 -f +la=en +char=noconv +cl -fkxat veit@kannegieser.net
 *                                                                        ^^^^
 *
 * include public key fingerprint:
 *             +bat +int=off +pa=cat +verb=0 -f +la=en +char=noconv +cl -fkvcat veit@kannegieser.net
 *                                                                        ^^^^^
 *
 * add key to keyring:
 *             +bat +int=off +pa=cat +verb=0 -f +la=en +char=noconv +cl -a -fkat C:\pgp\pubring.pgp
 *
 *
 * meaning of used PGP 2.x options:
 *   +bat       Suppressing Unnecessary Questions
 *              BATCHMODE may also be enabled to check the validity of a signature on
 *              a file.  If there was no signature on the file, the exit code is 1.
 *              If it had a signature that was good, the exit code is 0.
 *
 *   +int=off   Ask for Confirmation for Key Adds := off
 *
 *   +pa=cat    PAGER - Selects Shell Command to Display Plaintext Output
 *
 *   +verb=0    0 - Display messages only if there is a problem.  Unix fans wanted this "quiet mode" setting.
 *
 *   -f         filter
 *   -ft        filter + TEXTMODE - Assuming Plaintext is a Text File
 *   -fkxat     (ascii amored pgp key)
 *   -fkvcat    (lines including "Key fingerprint = ")
 *   -fat       (filter+ascii+textmode)
 *   -fkat      ? (add key to keyring)
 *
 *   +la=en     Foreign Language Selector
 *
 *   +char=noconv       no codepage conversion
 *
 *   -z"..."    pass phrase
 *
 *   -u ..      set your_userid
 *
 *   +cl        CLEARSIG - Enable Signed Messages to be Encapsulated as Clear Text
 *
 *   -s         sign
 *   -e         encrypt
 *   -se        sign+encrypt
 *
 *   -a         armor
 */


Call ResetVar

Parse Arg arg_alt

/** /
'@echo PGP: %0' arg_alt '>> %tmp%\pgp.log'
/ **/

if arg_alt = '' then
  do
    Say 'limited PGP 2.x imitation for PMMail using GnuPG'
    Say 'Veit Kannegieser * 2006-03-21 ..' MyVersion
    Return 99
  end

/*************************************/
/* compose new commandline for GnuPG */
/*************************************/

/* '@start /pm D:\extra\FM2UTIL\TESTPM.EXE' arg_alt */
arg_neu = 'gpg.exe '

arg_array. = ''
i = 1
do while Word(arg_alt,i) <> ''
  arg_array.i = Word(arg_alt,i)
  i = i + 1
end
arg_array.0 = i

i = 1
do while i <= arg_array.0

  select

    when (arg_array.i == 'v') & (i = 1) then
      do
        /* verify */
        warnpgpk = 1
        i = i + 1
      end

    when (arg_array.i == '+bat') | (arg_array.i == '+batchmode') then
      do
        arg_neu = arg_neu' --batch'
        i = i + 1
      end

    when arg_array.i == '+int=off' then
      do
        /* there is only a --interactive (on) option */
        i = i + 1
      end

    when arg_array.i == '+pa=cat' then
      do
        /* no pager option */
        i = i + 1
      end

    when arg_array.i == '+verb=0' then
      do
        /* less verbose is default */
        i = i + 1
      end

    when arg_array.i == '-f' then
      do
        /* ? */
        i = i + 1
      end

    when arg_array.i == '-ft' then
      do
        arg_neu = arg_neu' --textmode'
        i = i + 1
      end

    when arg_array.i == '-fkxat' then
      do
        i = i + 1
        exportasciikey = arg_array.i
        i = i + 1
      end

    when arg_array.i == '-fkvcat' then
      do
        i = i + 1
        fingerprintofkey = arg_array.i
        i = i + 1
      end

    when arg_array.i == '-fat' then
      do
        arg_neu = arg_neu' --armor --textmode'
        i = i + 1
      end

    when arg_array.i == '-fkat' then
      do
        /* this is only used when importing keys into the keyring. the next argument passed is the target keyring (why??) */
        arg_neu = arg_neu' --import'
        i = i + 2
      end

    when Abbrev(arg_array.i, '-z') then
      do

        if Abbrev(arg_array.i, '-z"') then
          do
            Parse Value arg_array.i With '-z"' pass
            i = i + 1
            do while Pos('"', pass) = 0
              pass = pass' 'arg_array.i
              i = i + 1
            end
            pass = Left(pass, Pos('"', pass) - 1)
          end
        else
          do
            warnpgpk = 1
            Parse Value arg_array.i With '-z"' pass
            i = i + 1
          end

       if pass <> '' then
         arg_neu = arg_neu' --passphrase-file 'passphrase_file
      end

    when arg_array.i == '+la=en' then
      do
        /* we always use english anyway */
        i = i + 1
      end

    when arg_array.i == '+char=noconv' then
      do
        /* no such option, gpg.conf has "charset ISO-8859-1"... */
        i = i + 1
      end

    when arg_array.i == '-u' then
      do
        i = i + 1
        arg_neu = arg_neu' --local-user' arg_array.i
        i = i + 1
      end

    when arg_array.i == '+cl' then
      do
        clearsig = 1
        i = i + 1
      end

    when arg_array.i == '-s' then
      do
        sign_ = 1
        i = i + 1
      end

    when (arg_array.i == 's') & (i = 1) then
      do
        warnpgpk = 1
        sign_ = 1
        i = i + 1
      end

    when arg_array.i == '-e' then
      do
        encrypt = 1
        i = i + 1
      end

    when (arg_array.i == 'e') & (i = 1) then
      do
        warnpgpk = 1
        encrypt = 1
        i = i + 1
      end

    when arg_array.i == '-se' then
      do
        sign_ = 1
        encrypt = 1
        i = i + 1
      end

    when (arg_array.i == 'se') & (i = 1) then
      do
        warnpgpk = 1
        sign_ = 1
        encrypt = 1
        i = i + 1
      end

    when arg_array.i == '-a' then
      do
        arg_neu = arg_neu' --armor'
        i = i + 1
      end


  otherwise
    if arg_array.i = '' then
      do
        i = i + 1
      end
    else
    if encrypt then
      do
        arg_neu = arg_neu' --recipient "'arg_array.i'"'
        i = i + 1
      end
    else
      do
        Say 'unbekannt: ' arg_array.i
        Say arg_alt
        Say arg_neu
        Return 1
      end

  end

end


/**********************************/
/* decide which GnuPG mode to use */
/**********************************/

if warnpgpk then
  Say 'Warning: PMMail has is using PGP 5.x compatible command line, but this imitation will produce 2.x messages!'

org_lang = Value('LANG', 'en_US', 'OS2ENVIRONMENT')

/*if pass then
  arg_neu = arg_neu' -z"'pass'"' - no documented option? */

if encrypt then
  arg_neu = arg_neu' --encrypt'

if sign_ then
  do
    if (clearsig = 1) & (encrypt = 0) then
      arg_neu = arg_neu' --clearsign'
    else
      arg_neu = arg_neu' --sign'
  end

if exportasciikey <> '' then
  arg_neu = arg_neu' --armor --export 'exportasciikey

if fingerprintofkey <> '' then
  arg_neu = arg_neu' --fingerprint 'fingerprintofkey

if Verbose then
  Say '@@ 'arg_neu


/***********************************************************************************************/
/* if an non-empty passphrase was specified place it into an file. -z can not be used for this */
/***********************************************************************************************/

if pass <> '' then
  do
    Call SysFileDelete passphrase_file
    Call Stream        passphrase_file, 'C', 'Open'
    Call CharOut       passphrase_file, pass
    Call Stream        passphrase_file, 'C', 'Close'
  end

/*********************************/
/* Launch GnuPG, redirect StdErr */
/*********************************/

'@'arg_neu '2>'StdErrTemp
ExitCode = rc

if Verbose then
  Say 'ExitCode='ExitCode

if pass <> '' then
  Call SysFileDelete passphrase_file

Call Value 'LANG', org_lang, 'OS2ENVIRONMENT'


/*************************************************************/
/* translate GPG messages to PGP messages expected by PMMAIL */
/*************************************************************/

linecount = 0
line. = ''
Call Stream StdErrTemp, 'C', 'Open'
do while Lines(StdErrTemp)
  linecount = linecount + 1
  line.linecount = LineIn(StdErrTemp)
  if Abbrev(line.linecount, 'gpg: ') then
    line.linecount = SubStr(line.linecount, 6)
end
Call Stream StdErrTemp, 'C', 'Close'
Call SysFileDelete StdErrTemp
Drop StdErrTemp

i = 1
do while i <= linecount

  i1 = i + 1
  /* GPG:
  gpg: Signature made Mi 19 Apr 15:53:29 2006 UCT using RSA key ID C0BF027D
  gpg: Good signature from "Veit Kannegieser <vk@informatik.tu-cottbus.de>"

     PGP 2.x:
  Good signature from user "Veit Kannegieser <vk@informatik.tu-cottbus.de>".
  Signature made 2006/04/19 15:53 GMT using 2048-bit key, key ID C0BF027D       */

  if Abbrev(line.i, 'Signature made ') & Abbrev(line.i1, 'Good signature from ') then
    do
      Parse Value line.i  With 'Signature made ' l1
      Parse Value line.i1 With 'Good signature from ' l2
      Call LineOut StdErr, 'Good signature from user 'l2
      Call LineOut StdErr, 'Signature made 'l1
      i = i + 2
    end

  else
  /* GPG:
   gpg: Signature made Mi 19 Apr 15:53:29 2006 UCT using RSA key ID C0BF027D
   gpg: BAD signature from "Veit Kannegieser <vk@informatik.tu-cottbus.de>"

     PGP 2.x:
   Bad signature from user "Veit Kannegieser <vk@informatik.tu-cottbus.de>".
   Signature made 2006/04/19 15:53 GMT using 2048-bit key, key ID C0BF027D      */

  if Abbrev(line.i, 'Signature made ') & Abbrev(line.i1, 'BAD signature from ') then
    do
      Parse Value line.i  With 'Signature made ' l1
      Parse Value line.i1 With 'BAD signature from ' l2
      Call LineOut StdErr, 'Bad signature from user 'l2
      Call LineOut StdErr, 'Signature made 'l1
      i = i + 2
    end


  else
  /* GPG:
   Signature made Tue Mar 21 01:54:10 UCT 2006 using DSA key ID 025D7C5D
   Can't check signature: public key not found

     PGP 2.x:
   Key matching expected Key ID 3B782F91 not found in file 'pubring.pgp'. -- modified
   WARNING: Can't find the right public key-- can't check signature integrity.  */
  if Abbrev(line.i, 'Signature made ') & Abbrev(line.i1, "Can't check signature: public key not found") then
    do
      Parse Value line.i  With 'Signature made ' . 'using' . 'key ID ' l1
      Call LineOut StdErr, "Key matching expected Key ID "l1" not found in public keyring."
      Call LineOut StdErr, "WARNING: Can't find the right public key-- can't check signature integrity."
      i = i + 2
    end


  else
  /* GPG:
   ehm3948: skipped: public key not found

     PGP 2.x:
   Key matching userid 'ehm' not found in file 'pubring.pgp'. -- modified */
  if Pos(': skipped: public key not found', line.i) > 0 then
    do
      Parse Value line.i With l1': skipped: public key not found'
      Call LineOut StdErr, "Key matching userid '"l1"' not found in public keyring."
      i = i + 1
      ExitCode = 21
    end

  else
  /* GPG:
   skipped "veit@kannegieser.net": bad passphrase
   [stdin]: sign+encrypt failed: bad passphrase

     PGP 2.x
   Error:  Bad pass phrase.
   Signature error                                      */
  if Abbrev(line.i, 'skipped "') & (Pos('failed: bad passphrase', line.i1) > 0) then
    do
      Call LineOut StdErr, 'Error:  Bad pass phrase.'
      Call LineOut StdErr, 'Signature error'
      i = i + 2
      ExitCode = 20
    end

  else
  /* GPG messages that have no corresponding PGP messages:

   encrypted with ELG-E key, ID 1D756BF6
   encrypted with 2048-bit ELG-E key, ID C80B032E, created 2006-03-20
   encrypted with 2048-bit RSA key, ID C0BF027D, created 1996-10-10
         "Veit Kannegieser <vk@informatik.tu-cottbus.de>"

   old style (PGP 2.x) signature                                         */

  if Abbrev(line.i, 'encrypted with ') then
    do

      do while Abbrev(line.i, 'encrypted with ')
        i = i + 1
      end

      if Abbrev(line.i, ' ') then
        i = i + 1

    end

  else
  if Abbrev(line.i, 'old style (PGP 2.x) signature') then
    do
      i = i + 1
    end

  else
  /* keep as is */
    do
      Call LineOut StdErr, line.i
      i = i + 1
    end
end

/***********/
/* cleanup */
/***********/


Drop line
Drop linecount
Drop i
Drop l1
Drop l2

Call ResetVar

Return ExitCode


/*************************/
/* setup/reset variables */
/*************************/

ResetVar:
                arg_alt  = ''
                arg_array. = ''
                arg_neu  = ''
                clearsig = 0
                encrypt  = 0
                sign_    = 0
                exportasciikey = ''
                fingerprintofkey = ''
                pass     = ''
                org_lang = ''
                warnpgpk = 0
                Return

/*******************************************************************/
ErrorREXX: /* S.L. */
  say
  parse source . . szThisCmd
  say 'CONDITION'('C') 'signaled at line' SIGL 'of' szThisCmd
  if 'SYMBOL'('RC') == 'VAR' then
    say 'REXX error' RC':' 'ERRORTEXT'(RC)
  say 'Source =' 'SOURCELINE'(SIGL)
  if 'CONDITION'('I') == 'CALL' then do
    szCondition = 'CONDITION'('C')
    say 'Returning'
    return
  end
  trace '?A'
  say 'Exiting'
  call 'SYSSLEEP' 2
  exit
/*******************************************************************/
HaltREXX:
  Say 'Halt.'
  Exit 99
/*******************************************************************/
