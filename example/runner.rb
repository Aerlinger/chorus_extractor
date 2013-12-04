require 'chorus_extractor'

filename = "/Users/Aerlinger/Dropbox/JSI_Development/code/chorus_extractor/spec/lyrics_data/holdmetight.jsi"
runner = ChorusExtractor::Main.new(filename)

runner.show_lines
runner.text_from_line_data
