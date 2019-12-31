## gyaric is a module to encode/decode text to unreadable gyaru's text.
##
## Overview
## --------
##
## Japanese gyaru sometimes do not use regular hiragana or katakana when
## chatting with text. Instead of using regular hiragana or katakana, they
## express hiragana and katakana with symbols that approximate them. I don't
## know the reason that they do it, but maybe they want to make the text cute.
##
## This module provides to encode regular hiragana or katakana text to
## unreadable gyaru's text, and decode that.
##
## What is the gyaru?
## ------------------
##
## A girl who dies her hair blonde or brown, wears a lot of make up, wears 
## short skirts, carries brand-name bags, is fun to be with and speaks casually.
##
## See also
## --------
##
## * `gyaru character dictionary <https://s.maho.jp/book/1fa879i4aad4e663/3761668001/1/>`_

import tables, random, strutils

const
  dict = {
    "あ": @["ぁ", "ァ"],
    "ア": @["ァ", "了"],
    "い": @["ﾚヽ", "ﾚ|", "ヰ"],
    "ぃ": @["ы"],
    "イ": @["亻"],
    "う": @["⊃`"],
    "ウ": @["宀"],
    "え": @["ゑ", "λ_"],
    "エ": @["ヱ"],
    "お": @["寸>`"],
    "オ": @["才", "ｵ"],
    "が": @["ｶヾ", "ｶ〃", "ｶゞ", "ヵ〃"],
    "ガ": @["ｶヾ", "ｶ〃", "ｶゞ", "ヵ〃"],
    "か": @["ｶl", "ｶゝ", "ｶヽ", "ヵゝ"],
    "カ": @["ヵ"],
    "ぎ": @["(ｷ〃", "‡〃", "≠〃"],
    "ギ": @["‡〃", "≠〃"],
    "き": @["(ｷ", "‡", "≠"],
    "キ": @["‡", "≠"],
    "ぐ": @["＜〃"],
    "く": @["＜"],
    "げ": @["｜ﾅ〃", "ﾚﾅ〃"],
    "ゲ": @["ヶ〃"],
    "け": @["｜ﾅ", "ﾚﾅ"],
    "ケ": @["ヶ"],
    "ご": @["⊃〃", "⊇〃"],
    "ゴ": @["⊃〃", "⊇〃"],
    "こ": @["＝"],
    "コ": @["⊃", "⊇"],
    "サ": @["廾"],
    "さ": @["±"],
    "し": @["ι", "υ", "∪", "U", "Ｕ"],
    "じ": @["ι〃", "υ〃", "∪〃", "Uﾞ", "Ｕﾞ"],
    "ソ": @["`ﾉ", "ヽﾉ"],
    "だ": @["tﾆﾞ", "+ﾆ〃", "ﾅﾆ〃", "ﾅこﾞ"],
    "た": @["tﾆ", "+ﾆ", "ﾅﾆ", "ﾅこ"],
    "ヂ": @["干〃", "千〃"],
    "チ": @["干", "千"],
    "づ": @["⊃〃", "っ〃"],
    "つ": @["⊃"],
    "ツ": @["〃ﾉ"],
    "っ": @["ッ"],
    "で": @["τ〃"],
    "て": @["〒", "τ"],
    "テ": @["〒", "τ"],
    "ド": @["├〃", "┣〃"],
    "ト": @["├", "┣"],
    "と": @["├", "?"],
    "な": @["ﾅょ", "+?", "+ょ", "fょ"],
    "ナ": @["ﾅ"],
    "に": @["｜=", "｜ﾆ", "ﾚﾆ"],
    "ニ": @["ﾆ"],
    "ね": @["ｷａ", "пё", "Йё"],
    "の": @["σ"],
    "ネ": @["пё", "Йё", "ネ"],
    "ノ": @["/", "丿"],
    "バ": @["ﾊ〃", "/ヽ〃"],
    "パ": @["ﾊo", "/ヽo"],
    "ぱ": @["ﾊo", "/ヽo"],
    "は": @["|?", "ﾚ?", "は"],
    "ハ": @["/ヽ"],
    "ビ": @["ﾋ〃"],
    "ぴ": @["ﾋo", "ﾋ*"],
    "ピ": @["ﾋo", "ﾋ*"],
    "ヒ": @["ﾋ"],
    "ブ": @["ﾌ〃", "┐〃"],
    "プ": @["ﾌo", "┐o", "┐*"],
    "ぷ": @["ﾌo", "┐o", "┐*"],
    "べ": @["∧〃"],
    "ベ": @["∧〃"],
    "ぺ": @["ﾍo", "∧o", "∧*"],
    "ペ": @["ﾍo", "∧o", "∧*"],
    "ボ": @["ﾎ〃"],
    "ポ": @["ﾎo", "ﾎ*"],
    "ぽ": @["ﾎo", "ﾎ*"],
    "ほ": @["│ま"],
    "マ": @["ма", "マ"],
    "ま": @["ма", "ま"],
    "ミ": @["Ξ", "彡"],
    "み": @["Ξ", "彡", "ゐ"],
    "ム": @["厶", "∠、", "＜、"],
    "む": @["厶", "∠、", "＜、"],
    "メ": @["×", "乂", "〆"],
    "も": @["м○", "も"],
    "モ": @["м○", "モ"],
    "や": @["ゃ"],
    "ゃ": @["ャ"],
    "ヤ": @["ャ"],
    "ゆ": @["ゅ"],
    "ユ": @["ュ"],
    "ゅ": @["ュ"],
    "よ": @["∋", "чOo0"],
    "ヨ": @["∋"],
    "ょ": @["ョ"],
    "ら": @["ら", "ζ"],
    "り": @["L|", "└ﾉ", "Lﾉ", "ﾚﾉ"],
    "リ": @["L|", "└ﾉ", "Lﾉ", "ﾚﾉ"],
    "る": @["lﾚ", "｣レ", "/レ", "ﾉﾚ"],
    "ル": @["lﾚ", "｣レ", "/レ", "ﾉﾚ"],
    "れ": @["れ", "ｷν", "└"],
    "レ": @["レ", "└"],
    "ろ": @["з", "З"],
    "ロ": @["口"],
    "わ": @["ゎ", "ｷっ"],
    "ワ": @["ヮ"],
    "ん": @["ω", "μ", "ｗ"],
    "ン": @["*ﾉ"],
    }.toTable

randomize()

proc encode*(text: string): string =
  ## Returns encoded text like girl's unreadable text.
  runnableExamples:
    echo encode("こんばんは")
    ## Output:
    ##   ＝ｗばｗ|?
  result = text
  for key, words in dict.pairs:
    result = result.replace(key, sample(words))

proc decode*(text: string): string =
  ## Returns decoded text like girl's unreadable text.
  runnableExamples:
    doAssert decode("＝ｗばｗ|?") == "こんばんは"
  result = text
  for key, words in dict.pairs:
    for word in words:
      result = result.replace(word, key)

when isMainModule:
  echo encode("あいうえお")
  echo encode("はじめまして！19:00に渋谷でディナーはいかが？")
  echo encode("じゅげむじゅげむごこうのすりきれかいじゃりすいぎょのすいぎょうまつ")
  echo encode("あいうえお").decode
  echo encode("はじめまして！19:00に渋谷でディナーはいかが？").decode
  echo encode("じゅげむじゅげむごこうのすりきれかいじゃりすいぎょのすいぎょうまつ").decode
