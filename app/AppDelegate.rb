# coding: utf-8
#
# GyaimMotion
#
# Created by Toshiyuki Masui on 2015/9/7
# Copyright (C) 2015 Pitecan Systems. All rights reserved.
#
class AppDelegate
  def applicationDidFinishLaunching(notification)

    identifier = NSBundle.mainBundle.bundleIdentifier
    server = IMKServer.alloc.initWithName("Gyaim_Connection",bundleIdentifier:identifier)
    Thread.new do
      while true do
        CopyText.set NSPasteboard.generalPasteboard.stringForType(NSPasteboardTypeString)
        sleep 60
      end
    end
  end

  def candidatesFor(input)
    if input.start_with?("/gpt ")
      char, message = parse_input(input)
      response = ChatGPT.query(char, message)
      return [[response, "ChatGPT（#{char}風）"]]
    else
      # 通常の変換処理
      return [["通常変換（仮）", "標準変換処理"]]
    end
  end
  def parse_input(input)
    _, char, *rest = input.split(" ")
    [char, rest.join(" ")]
  end
end
