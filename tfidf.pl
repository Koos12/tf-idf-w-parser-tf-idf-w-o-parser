#!/usr/bin/perl


# classify.pl - list most significant words in a text
#               based on http://en.wikipedia.org/wiki/Tfidf

# Eric Lease Morgan <eric_morgan@infomotions.com>
# April 10, 2009 - first investigations; based on search.pl
# April 12, 2009 - added dynamic corpus

{
        no warnings;          # temporarily turn off warnings
        
        $x = $y + $z;         # I know these might be undef
}


# use/require
my @stopWords = qw (a about  above   above   across   after   afterwards
again   against   all   almost   alone   along   already   also  although
always  am  among   amongst   amoungst   amount    an   and   another   any
anyhow  anyone  anything  anyway   anywhere   are   around   as    at   back
be  became   because  become  becomes   becoming   been   before   beforehand
behind   being   below   beside   besides   between   beyond   bill   both
bottom  but   by   call   can   cannot   cant   co   con   could   couldnt   cryout.txt
de   describe   detail   do   done   down   due   during   each   eg   eight
either   eleven  else   elsewhere   empty   enough   etc   even   ever   every
everyone   everything   everywhere   except   few   fifteen   fify   fill   find
fire   first   five   for   former   formerly   forty found four from front full
further get give go had has hasnt have he hence her here hereafter hereby herein
hereupon hers herself him himself his how however hundred ie if in inc indeed interest
into is it its itself keep last latter latterly least less ltd made many may me meanwhile
might mill mine more moreover most mostly move much must my myself name namely neither
never nevertheless next nine no nobody none noone nor not nothing now nowhere of off often
on once one only onto or other others otherwise our ours ourselves out over ownpart per
perhaps please put rather re same see seem seemed seeming seems serious several she should
show side since sincere six sixty so some somehow someone something sometime sometimes
somewhere still such system take ten than that the their them themselves then thence there
thereafter thereby therefore therein thereupon these they thickv thin third this those
though three through throughout thru thus to together too top toward towards twelve twenty
two un under until up upon us very via was we well were what whatever when whence whenever
where whereafter whereas whereby wherein whereupon wherever whether which while whither who
whoever whole whom whose why will with within without would yet you your yours yourself
yourselves the);

require 'subroutines.pl';
my $AwellClassified=0;
my $GwellClassified=0;
my $Total=0;
my $numOfGraphicsFiles=0;
my $numOfAtheismFiles=0;
my $numOfAtheismTrainingFiles=0;
my $numOfGraphicsTrainingFiles=0;

# index, sans stopwords
my %index = ();

my @blockSixTrainingCorpus = <C:/Perl/20news-bydate/20news-bydate-train/6label/alt.atheism/*>;
foreach my $file (my @files) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $lines = join " ", map {lcfirst} split " ", $lines;
   my $blockSix=$blockSix.' '.$lines;
   $trainingFileHash{$fileName[$fileNameLength-1]}=$blockSix;
   $numOfAtheismFiles++;
   last if ($numOfAtheismFiles> 100);
}


my @blockOneTrainingCorpus = <C:/Perl/20news-bydate/20news-bydate-train/1label/comp.graphics/*>;
foreach my $file (@files) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $blockOne=$blockOne.' '.$lines;
   #print $lines, "\n";
   #print @processedLines;
   $trainingFileHash{$fileName[$fileNameLength-1]}=$blockOne;
   $numOfGraphicsFiles++;
   last if ($numOfGraphicsFiles> 100);  
}

my @blockSixTestCorpus = <C:/Perl/20news-bydate/20news-bydate-test/alt.atheism/*>;
foreach my $file (@blockSixTestCorpus) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $lines = join " ", map {lcfirst} split " ", $lines;
   $tblockOne=$tblockOne.' '.$lines;
    #print $lines, "\n";
   my @processedLines=split(/ /,$lines);
    #print @processedLines;
   $testFileHash{$fileName[$fileNameLength-1]}=$lines;
   $numOfAtheismTrainingFiles++;
   last if ($numOfAtheismTrainingFiles> 100);
}


my @blockTestCorpus = <C:/Perl/20news-bydate/20news-bydate-test/comp.graphics/*>;
foreach my $file (@blockTestCorpus) {
  #somehow the regular expression with backreference does not work here
  my @fileName=split(/\//, $file);
  my $fileNameLength=scalar(@fileName);
  print $file , "\n";
  open(INFILE, $file) or die "Cannot open $file: $!.\n";
  my @lines=<INFILE>;
  #rudimentarily cleaning the corpus
  my $lines=join(' ',@lines);
   $lines=~ s/From.*\n//;
   $lines=~ s/Subject.*\n//;
   $lines=~ s/Organization.*\n//;
   $lines=~ s/Lines.*\n//;
   $lines=~ s/Reply-to.*\n//;
   $lines=~ s/Reply-To.*\n//;
   $lines=~ s/In-Reply-to.*\n//;
   $lines=~ s/NNTP-Posting-Host.*\n//;
   $lines=~ s/Distribution.*//;
   $lines=~ s/In\sarticle.*writes:\n//;
   $lines=~ s/[`\>`]//;
   $lines=~ s/[`\>`][`\>`]//;
   $lines=lc($lines);
   $lines=~ s/\.//g;
   $lines=~ s/\?//g;
   $lines=~ s/\W/\ /g;
   $lines=~ s/\s(\s)+/ /g;
   $tblockSix=$tblockSix.' '.$lines;
   #print $lines, "\n";
   #print @processedLines;
   $testFileHash{$fileName[$fileNameLength-1]}=$lines;
   $numOfGraphicsTrainingFiles++;
   last if ($numOfGraphicsTrainingFiles> 100);
}


my %gramWords;
  


push @blockTrainingCorpus, @blockSixTrainingCorpus;
push @blockTrainingCorpus, @blockOneTrainingCorpus;


# index, sans stopwords


push (@blockTestCorpus, @blockSixTestCorpus);


# @members is now ("Time", "Flies", "An", "Arrow")

my $loops=0;
my $numOfFilesTwo=0;
my $numOfWords=0;

foreach my $file ( @blockTrainingCorpus){
        $numOfFilesOne++;
        #print "  numOfFiles ", "$numOfFilesTwo", "\n";
}


foreach my $file ( @blockTrainingCorpus){   
        my @fileName=split(/\//, $file);
        my $fileNameLength=scalar(@fileName);
        #print "file ",  $fileName[$fileNameLength-1], "\n";
        $index{$file}=&index($file);
        &printIndex(\%index, $file);
        if ($loops==0) {
           $CatRef=&createVector($file);
           %Cat = %$CatRef;
           $loops=1;     
        }
        else{
           $loops++;   
           #$CatRef=&createVector($file);
           #my %Cat = %$CatRef;
           $cat=&addDocCat(\%index, $file, \%Cat);     
           %Cat=%$cat;      
           if ($numOfFilesOne==$loops) {
               foreach my $word (sort keys %Cat) {
                        if (&stopList(\@stopWords, $word)) {
                               $numOfWords+=$Cat{$word};
                                #print " Above 1", "  $Cat{$word} ", "$word", "\n";
                                $catTfIdfRef=&preTfIdf(\%index,  [ @blockTrainingCorpus ], $word);
                                %catTfIdf=%$catTfIdfRef;
                                #print " wkj value ", "$catTfIdf{$file}{$word} ", "\n" if ($catTfIdf{$file}{$word}>0);
                                #wkj
                        }
               }
           print "  numOfWords training corpus  ", "$numOfWords", "\n";
           }
        }
}


my @ary;
my %HoA = ();
my %unique = ();
foreach my $file (sort keys %catTfIdf) {
        #print  "$file \n\n";
        my @fileName=split(/\//, $file);
        my $fileNameLength=scalar(@fileName);
                foreach my $word (keys %{$catTfIdf{$file}}){ 
                        
                                #print  "1 INSIDE gramWord scope ", "$word ", $catTfIdf{$file}{$word}, "  \n" if $catTfIdf{$file}{$word}!=0;          
                                push (@oneAry, $catTfIdf{$file}{$word}) if ($catTfIdf{$file}{$word}!= 0);
        
        }
        foreach my $item (@oneAry)
                        {
                           #print "ITEM 1:  $item ", "\n";
                           $unique{$item}++;
                        }
        my @myOneArray = keys %unique;
        undef(@oneAry);
        undef(%unique);
        $HoA{$file} = \@myOneArray;
        #print " ARRAY1 $file ", "@myOneArray ", "\n";
}




$numOFWords=0;
$loops=0;

foreach my $file ( @blockTestCorpus){
        $numOfFiles++;
        #print "  numOfFiles ", "$numOfFiles", "\n";
}

my $TestTfIdfOneRef;
my %TestTfIdfOne = ();
my $TestTfIdfSixRef;
my %TestTfIdfSix = ();



undef(@myTwoArray);
undef(@myOnArray);
my @onArray;
my @twArray;
my %TestTfIdfSix = ();
my %TestTfIdfOne = ();
my @aOne;
my @aSix;
my $i=0;
my $j=0;
my $fiveGroup=0;
my $threeGroup=1;
foreach my $file ( @blockTestCorpus){  
        my @fileName=split(/\//, $file);
        my $fileNameLength=scalar(@fileName);
        #print "file ",  $fileName[$fileNameLength-1], "\n";
        $index{$file}=&index($file);
        &printIndex(\%index, $file);
        $CatRef=&createVector($file);
        %Cat = %$CatRef;
        foreach my $word (sort keys %Cat) {
                if (&stopList(\@stopWords, $word)) {
                        $numOfWords+=$Cat{$word};
                        #print " Above 3", "  $Cat{$word} ", "$word", "\n";
                        $valSix=&preTfIdfTest(\%index, $file,  [ @blockOneTrainingCorpus ], $word);
                        #print " 1 tfidf is  $valSix\n" if ($valSix!= 0);
                        push(@onAry, $valSix) if ($valSix != 0);
                        #print " 1 growing array:", @onAry, "\n";
                        foreach my $item (@onAry){
                                #print "ITEM 1:  $item ", "\n";
                                $unique{$item}++;
                        }
                        my @myArray = keys %unique;
                        undef(%unique);
                        $HashOfTestFile{$file} = \@myArray;
                        #print " File $fileName[$fileNameLength-1] and associated array ", " @myArray ", "\n";     
                }
         }
   #wki
undef(@onAry);
undef(@twAry);
}

$printCtr=0;


$oneCorrectlyClassified=0;
$sixCorrectlyClassified=0;
$totalFiles=0;


foreach my $File ( sort keys %HoA){
        $printCtr++;
        foreach my $testFile ( sort keys %HashOfTestFile){
                my @TrainingfileName=split(/\//, $File);
                my $TrainingfileNameLength=scalar(@TrainingfileName);
                my @TestfileName=split(/\//, $testFile);
                my $TestfileNameLength=scalar(@TestfileName);
                #print  " training file ",  $TrainingfileName[$TrainingfileNameLength-1],  " test file ", $TestfileName[$TestfileNameLength-1], "\n";
        }
}

foreach my $File ( sort keys %HoA){
        $totalFiles++;
        foreach my $testFile ( sort keys %HashOfTestFile){
                $totalFiles++;                
                my @TrainingfileName=split(/\//, $File);
                my $TrainingfileNameLength=scalar(@TrainingfileName);
                my @TestfileName=split(/\//, $testFile);
                my $TestfileNameLength=scalar(@TestfileName);
                #print  " training file ",  $TrainingfileName[$TrainingfileNameLength-1],  " test file ", $TestfileName[$TestfileNameLength-1], "\n";      
                #case one one
                if ((($TrainingfileName[$TrainingfileNameLength-1]<38816)&&($TrainingfileName[$TrainingfileNameLength-1]>37261)) &&
                   (($TestfileName[$TestfileNameLength-1]< 40062) && ($TestfileName[$TestfileNameLength-1]> 37261))){
                        $OneOnefinalResult= cos(&dot([ @{$HoA{$File}} ], [ @{$HashOfTestFile{$testFile}} ])/&euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [ @{$HashOfTestFile{$testFile}}  ] )), "\n" if &euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [  @{$HashOfTestFile{$testFile}} ] ) !=0;
                        #print  " One training and One test RESULT: ", $OneOnefinalResult, "\n\n" if (exists($TestfileName[$TestfileNameLength-1])); 
                } #check one and six business
                if ((($TrainingfileName[$TrainingfileNameLength-1]<38816)&&($TrainingfileName[$TrainingfileNameLength-1]>37261)) &&
                   (($TestfileName[$TestfileNameLength-1]< 54564) && ($TestfileName[$TestfileNameLength-1]> 53068))){
                        $OneSixfinalResult= cos(&dot([ @{$HoA{$File}} ], [ @{$HashOfTestFile{$testFile}} ])/&euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [ @{$HashOfTestFile{$testFile}}  ] )), "\n" if &euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [  @{$HashOfTestFile{$testFile}} ] ) !=0;
                        #print  " One training and Six test RESULT: ", $OneSixfinalResult, "\n\n" if (exists($TestfileName[$TestfileNameLength-1])); 
                }      
                if ((($TrainingfileName[$TrainingfileNameLength-1]<54473)&&($TrainingfileName[$TrainingfileNameLength-1]>49960)) &&
                   (($TestfileName[$TestfileNameLength-1]< 54564) && ($TestfileName[$TestfileNameLength-1]> 53068))){
                        $SixSixfinalResult= cos(&dot([ @{$HoA{$File}} ], [ @{$HashOfTestFile{$testFile}} ])/&euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [ @{$HashOfTestFile{$testFile}}  ] )), "\n" if &euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [  @{$HashOfTestFile{$testFile}} ] ) !=0;
                        print  " training file ",  $TrainingfileName[$TrainingfileNameLength-1], " training array ",  @{$HoA{$File}}, "\n", " test file ", $TestfileName[$TestfileNameLength-1], " test array ", @{$HashOfTestFile{$testFile}} , "\n";      
                        print  " Six training and Six test RESULT: ", $SixSixfinalResult, "\n\n" if (exists($TestfileName[$TestfileNameLength-1])); 
                }      
                if ((($TrainingfileName[$TrainingfileNameLength-1]<54473)&&($TrainingfileName[$TrainingfileNameLength-1]>49960)) &&
                   (($TestfileName[$TestfileNameLength-1]< 40062) && ($TestfileName[$TestfileNameLength-1]> 38758))){
                        $SixOnefinalResult= cos(&dot([ @{$HoA{$File}} ], [ @{$HashOfTestFile{$testFile}} ])/&euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [ @{$HashOfTestFile{$testFile}}  ] )), "\n" if &euclidian( [ @{$HoA{$File}} ] ) * &euclidian( [  @{$HashOfTestFile{$testFile}} ] ) !=0;
                        print  " training file ",  $TrainingfileName[$TrainingfileNameLength-1], " training array ",  @{$HoA{$File}}, "\n", " test file ", $TestfileName[$TestfileNameLength-1], " test array ", @{$HashOfTestFile{$testFile}} , "\n";      
                        print  " Six training and One test RESULT: ", $SixOnefinalResult, "\n\n" if (exists($TestfileName[$TestfileNameLength-1])); 
                }   
                if ($OneOnefinalResult > $OneSixfinalResult) {
                        $oneCorrectlyClassified++;
                }
                if ($SixSixfinalResult > $SixOnefinalResult) {
                        $sixCorrectlyClassified++;
                }
        }
}


print " Total number of files ", $totalFiles   , "\n";
print " correctly classified documents from atheism ", "$sixCorrectlyClassified   ", "\n";
print " correctly classified documents from graphics ", "$oneCorrectlyClassified   ", "\n";



sub preTfIdf {

	my $index = shift;
	my $files = shift;
    my $term = shift;
	
   

	foreach my $file ( @$files ) {
	
		# get n, query word count in a document
		my $words = $$index{ $file };
		my $n = $$words{ $term };
		
		# calculate t, total number of words in a document
		my $t = 0;
		foreach my $word ( keys %$words ) { $t = $t + $$words{ $word } }
		
		# assign tfidf to file	
		$tfidfvalues{ $file }{$term } = &tfidf( $n, $t, keys %$index, scalar @$files );
	}

	return \%tfidfvalues;

}

# tfidf = ( n / t ) * log( d / h ) where:
	#     n = number of times a word appears in a document
	#     t = total number of words
	#     d = total number of documents
	#     h = number of documents that contain the word


sub preTfIdfTest {
 
    my $index=shift;
    my $ffile = shift;
    my $files = shift;
    my $term=shift;
    
    my $tfidfvalue;
    
	
    #print " TRALA 0 term  ", $term ,"\n"; 
    # get n, query word count in a document
    my $words = $$index{ $ffile };
    my $n = $$words{ $term };
    # calculate t, total number of words in a document
    my $t = 0;
    foreach my $word ( keys %$words ) { $t = $t + $$words{ $word } }
    # assign tfidf to file	
    $tfidfvalue{$term} = &tfidf( $n, $t, keys %$index, scalar @$files );
    $scalarOutOne=$tfidfvalue{$term};
    my $val=$scalarOutOne+0;
    return $val;
}




print "YAYAYAYAYA", "\n";

    

sub dot {
  
    # dot product = (a1*b1 + a2*b2 ... ) where a and b are equally sized arrays (vectors)
    my $a = shift;
    my $b = shift;
    my $d = 0;
    for ( my $i = 0; $i <= $#$a; $i++ ) { $d = $d + ( $$a[ $i ] * $$b[ $i ] ) }
    return $d;
  }

sub euclidian {
  
    # Euclidian length = sqrt( a1^2 + a2^2 ... ) where a is an array (vector)
    my $a = shift;
    my $e = 0;
    for ( my $i = 0; $i <= $#$a; $i++ ) { $e = $e + ( $$a[ $i ] * $$a[ $i ] ) }
    return sqrt( $e );
  
  } 
  
sub stopList
{
my @stopWordList=@{$_[0]};
 my $word=${$_[1]};
 #print "DEBUG_DOWN1  *", $line, "*\n\n";
 my @newLine;
 foreach my $stopWord(@stopWordList){
        if ($stopWord eq $word){
                        #print "   ", $stopWord, "   ";
                return 0;
        }
        else{
                return 1;
        }
  }

}


sub  GramWord
{
        my $aword=${$_[0]};
        my %gramWords=%{$_[1]};
        #print "Incoming word within gramWord function: ", $aword, "\n";
        if (exists($gramWords{$aword})){
                #print " We found a gramWord ", $aword , "\n";
                return 1;
        }
        else{
                #print " We found no gramWord ", "\n";
                return 0;
        }                        
}



    
    
