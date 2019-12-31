when isMainModule:
  from strformat import `&`
  import parseopt, os, strutils
  import ../../gyaric

  type
    Options = object
      args: seq[string]

  const
    appName = "gyaric"
    version = &"""{appName} version 1.0.0
Copyright (c) 2019 jiro4989
Released under the MIT License.
https://github.com/jiro4989/gyaric"""

    doc = &"""{appName} encode/decode a text to unreadable gyaru's text.

Usage:
    {appName} -h | --help
    {appName} -v | --version
    {appName} encode <file...>
    {appName} decode <file...>

Options:
    -h, --help       print help and exit
    -v, --version    print version and exit
    """

  proc getCmdOpts(params: seq[string]): Options =
    ## コマンドライン引数を解析して返す。
    ## helpとversionが見つかったらテキストを標準出力して早期リターンする。
    var optParser = initOptParser(params)
    for kind, key, val in optParser.getopt():
      case kind
      of cmdArgument:
        result.args.add(key)
      of cmdLongOption, cmdShortOption:
        case key
        of "help", "h":
          echo doc
          quit 0
        of "version", "v":
          echo version
          quit 0
      of cmdEnd:
        assert false # cannot happen

  proc runSubcmd(subcmd, cont: string) =
    case subcmd
    of "encode":
      echo encode(cont)
    of "decode":
      echo decode(cont)
    else:
      stderr.writeLine &"ERROR: illegal subcommand = '{subcmd}'"
      stderr.writeLine &"See '{appName} -h'"
      quit 1

  let opts = getCmdOpts(commandLineParams())
  if opts.args.len < 1:
    stderr.writeLine "ERROR: need subcommand"
    stderr.writeLine &"See '{appName} -h'"
    quit 1

  let subcmd = opts.args[0]

  # ファイルが存在しない時は標準入力を処理
  if opts.args.len == 1:
    var lines: string
    for line in stdin.lines:
      lines.add(line)
    runSubcmd(subcmd, lines.join.encode)
    quit 0

  # 引数にファイルが存在したらファイルを処理
  for file in opts.args[1..^1]:
    let cont = readFile(file)
    runSubcmd(subcmd, cont)
