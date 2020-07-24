# Package

version       = "1.0.2"
author        = "jiro4989"
description   = "gyaric is a module to encode/decode text to unreadable gyaru's text."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gyaric/cli/gyaric"]
binDir        = "bin"

# Dependencies

requires "nim >= 1.0.4"

task docs, "Generate API documents":
  exec "nimble doc --index:on --project --out:docs --hints:off src/gyaric.nim"
