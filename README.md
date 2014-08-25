# ChorusExtractor

Extracts chorus from lyrics by finding consecutive matching lines of
text in a file.

To find patterns, each line is assigned a "diff score" based on the
percentage of similar lines that exist within the same file computed
via the McIlroy-Hunt Longest Common Subsequence (LCS) algorithm)
Groups of consecutive lines with a high score are marked as being
chorus lines.

Matching lines do not need to be exact and matching algorithm is not case sensitive.
Ambiguity can be resolved

### Example:

> Written in these walls all the stories that I cant explain,
> I leave my heart open but it stays right here empty for days,
> She told me in the morning she don’t feel the same about us in her bones,
> It seems to me that when I die these words will be written on my stone,
> And I'll be gone, gone tonight
> The ground beneath my feet is open wide
> The way that I've been holding on too tight with nothing in between

```
  The story of my life I take her home
  I drive all night
  To keep her warm and time-
  Is frozen
  The story of my life I give her hope
  I spend her love until she’s broke inside
  The story of my life
```

> Written on these walls are the colours that I can't change
> Leave my heart open but it stays right here in its cage
> I know that in the morning I'll see us in the light upon the pier
> Although I'm broken my heart is untamed still
> And I'll be gone, gone tonight
> The fire beneath my feet is burning bright
> The way that I've been holding on so tight 
> With nothing in between

```
  The story of my life I take her home
  I drive all night
  To keep her warm and time-
  Is frozen
  The Story of my life I give her hope
  I spend her love until she’s broke inside
  The story of my life
```

> And I've been waiting for this time to come around
> But baby running after you is like chasing chasing the clouds

> The story of my life I take her home
> I drive all night
> To keep her warm and time
> Is frozen
> The Story of my life I give her hope
> I spend her love until she’s broke inside
> The story of my life

# Algorithm

For any two lines of text we can compute their similarity by finding the
order-sensitive difference between them. The percentage similarity can
be computed as a correlation coefficient scored between zero and one. 

We can then build a correlation matrix by mapping the difference between one
line against all other lines in the file. For N lines in a file, this
results in an NxN pseudo-symmetrical matrix.

Groups of similar lines of text will result in segments of the
correlation matrix with high values.

Chorus features occur in groups of diagonals along the correlation matrix

Blocks (i.e. large sections) of repeated text can be identified as blocks of white (1.0)
within the correlation map.



![](https://raw.githubusercontent.com/Aerlinger/chorus_extractor/develop/example/correlation_maps/3_cleaned.jsi_processed.bmp)

# Metrics

*Confidence* *Index* Some lyric files contain more than one chorus, or can contain pre-chorus
and chorus, or even multiple choruses. Confidence score (0-1) is a measure of confidence. 1 is
complete confidence and 0 is no confidence.
*Recurse* *Index* How many nestings of similarity
*Breadth* *Index* How many


## Installation

Add this line to your application's Gemfile:

    gem 'chorus_extractor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chorus_extractor

## Usage

# Examples and results

ChorusExtractor.process('/path/to/lyrics/file')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
