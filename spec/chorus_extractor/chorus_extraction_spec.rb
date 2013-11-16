require 'spec_helper'

describe "chorus extraction", focus: true do
  before :all do
    @cleaned_1 = File.read(Dir.pwd + '/spec/lyrics_data/holdmetight.jsi')
  end

  it "extracts diagonal from matrix correctly" do
  end

  it "correctly extracts chorus from a matrix" do
  end

  it "annotates text properly" do
    result = ChorusExtractor.process(Dir.pwd + '/spec/lyrics_data/holdmetight.jsi')

    puts ""
    puts result.join

    result.should eq ""
  end
end

#<head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# profile: http://ogp.me/ns/profile#">
#<meta property="fb:app_id" content="221362478027994" />
#<meta property="og:type"   content="profile" />
#<meta property="og:url"    content="Put your own URL to the object here" />
#<meta property="og:title"  content="Sample Profile" />
#<meta property="og:image"  content="https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png" />