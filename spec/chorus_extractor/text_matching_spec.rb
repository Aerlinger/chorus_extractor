require 'spec_helper'

describe 'building a correlation matrix from a body of text' do
  before :all do
    @cleaned_1 = File.read(Dir.pwd + '/spec/lyrics_data/1_cleaned.jsi')
  end

  describe "a file with only repeated lines" do
    it "maps to a correlation matrix of all ones" do
      @filename = Dir.pwd + '/spec/lyrics_data/repeated_text.jsi'

      matrix = ChorusExtractor.compute_correlation_matrix(@filename)

      matrix.should eq []
    end

    after :all do
      @repeated.close
    end
  end

  describe "a file with only repeated lines" do
    it "maps to a correlation matrix of similars" do
      filename = Dir.pwd + '/spec/lyrics_data/non_repeated_text.jsi'

      matrix = ChorusExtractor.compute_correlation_matrix(filename)

      matrix.should eq []
    end

    after :all do
      @repeated.close
    end
  end

  describe "a file with only repeated lines" do
    it "maps to a correlation matrix of similars" do
      filename = Dir.pwd + '/spec/lyrics_data/6_cleaned.jsi'

      matrix = ChorusExtractor.compute_correlation_matrix(filename)

      matrix.should eq []
    end

    after :all do
      @repeated.close
    end
  end
end
