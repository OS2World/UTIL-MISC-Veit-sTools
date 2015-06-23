/* REXX: example rexx for REXX_EXE */

/* use 'rexxc test_src.cmd test_tok.cmd' to produce test_tok.cmd from it */

Parse Source operatingSystem commandType sourceFileName
Say 'The Operating system is "'operatingSystem'".'
Say 'The call type is "'commandType'".'
Say 'The name of the source file is "'sourceFileName'".'
  
Say 'ADDRESS() = "'ADDRESS()'"'

Parse Arg CmdLine
Say 'CmdLine = "'CmdLine'"'

Say 'SourceLine() = "'SourceLine()'"'
if SourceLine() > 1 then
  Say 'SourceLine('SourceLine()') = "'SourceLine(SourceLine())'"'

Return '123'
