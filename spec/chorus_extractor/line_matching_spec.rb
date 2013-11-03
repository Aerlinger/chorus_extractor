require 'spec_helper'

describe "matching two lines" do

  describe "two matching lines" do
    before do
      @first_line  = "This is a simple line of text"
      @second_line = "This is a simple line of text"
    end

    it "have a correlation coefficient of 1" do
      cc = ChorusExtractor.correlation_coeff(@first_line, @second_line)
      cc.should eq 1.0
    end

    it "counts zero differences between them" do
      cc = ChorusExtractor.num_differences(@first_line, @second_line)
      cc.should eq 0
    end
  end

  it "has cc of 0.5 for two character strings differing by one char" do
    @first_line  = "ab"
    @second_line = "aa"

    cc = ChorusExtractor.correlation_coeff(@first_line, @second_line)

    cc.should eq 0.5
  end

  it "has cc of 0.5 for two character strings differing by one char" do
    @first_line  = "aba"
    @second_line = "abb"

    cc = ChorusExtractor.correlation_coeff(@first_line, @second_line)

    cc.should be_within(0.01).of(0.666)
  end

  it "has cc of 0.25 for four letter string with a one char match" do
    @first_line  = "abcl"
    @second_line = "calb"

    cc = ChorusExtractor.correlation_coeff(@first_line, @second_line)

    cc.should eq 0.25
  end
end
