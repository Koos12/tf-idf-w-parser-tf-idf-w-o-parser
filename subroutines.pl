# subroutines.pl - a library of functions used to index,
#                  classify, and compare documents as well
#                  as rank search results

# Eric Lease Morgan <eric_morgan@infomotions.com>

# April 10, 2009 - first investigations
# April 11, 2009 - added stopwords; efficient-ized
# April 12, 2009 - added dynamic corpus
# April 16, 2009 - added dot product and Euclidian length
# April 17, 2009 - added compare
# April 25, 2009 - added great_idea
# May   31, 2009 - added cosine to compare routine, dumb!



# return a hash of all words in a document, plus their counts
sub index {

	my $file      = shift;
	
	
	my %words = ();
	
	open ( F, "< $file" ) or die "Can't open $file ($!)\n";
	while ( <F> ) {
	
		foreach my $word ( split /\W/ ) {
		
			# normalize and exclude words we don't want
			next if ( ! $word );
			$word = lc( $word );
			next if ( $word =~ /\d/ );
			next if ( length( $word ) < 3 );
			
			# update the "index"
			$words{ $word }++;
			
		}
		
	}
	
	close F;
	return \%words;

}

# return a vector of term frequencies in a document
sub createVector {

	my $file      = shift;
	
	
	my %words = ();
	
	open ( F, "< $file" ) or die "Can't open $file ($!)\n";
	while ( <F> ) {
	
		foreach my $word ( split /\W/ ) {
		
			# normalize and exclude words we don't want
			next if ( ! $word );
			$word = lc( $word );
			next if ( $word =~ /\d/ );
			next if ( length( $word ) < 3 );
			
			# update the "index"
			$words{ $word }++;
			#print "HERE2", " ", $word, " ",  $words{$word}, "\n";
		}
		
	}
	
	close F;
	return \%words;

}

# return a vector of term frequencies in a document

sub addDocCat {
	
	my %words1 = ();
	
	my $index  = shift;
	my $file = shift;
	my $CatRef = shift;
	my %Cat=%$CatRef;

	
	
	$numOfWords=0;
	#print " file2: ", $file, "\n";
	
	foreach my $words ( $$index{ $file } ) {
		foreach my $word ( keys %$words ){
			foreach my $aWord ( sort keys %Cat ){
				#print "addDocCat Word in Cat ", $aWord, "\n";
				if ($word eq $aWord) {
					$Cat{$aWord}++;
				    $numOfWords++;	
				}
			}
		}
	
	}
#print "number of Words in subroutines ", $numOfWords , "\n";	
return \%Cat;
}






# return the number of hits against a corpus and a list of the corresponding files
sub search {

	my $index = shift;
	my $query = shift;
	
	my $hits  = 0;
	my @files = ();
	
	foreach ( keys %$index ) {
	
		my $words = $$index{ $_ };
		if ( $$words{ $query } ) {
			#print " File (?) stacked in $_files: ", $_, "\n";
			$hits++;
			push @files, $_;
			
		}
		
	}
	
	return ( $hits, @files );

}


# assign a rank to a given file for a given query
sub rank {

	my $index = shift;
	my $files = shift;
	my $query = shift;
	
	my %ranks = ();
	
	foreach my $file ( @$files ) {
	
		# get n, query word count in a document
		my $words = $$index{ $file };
		my $n = $$words{ $query };
		
		# calculate t, total number of words in a document
		my $t = 0;
		foreach my $word ( keys %$words ) { $t = $t + $$words{ $word } }
		
		# assign tfidf to file	
		$ranks{ $file } = &tfidf( $n, $t, keys %$index, scalar @$files );

	}

	return \%ranks;

}

sub printIndex {

	my $index  = shift;
	my $file = shift;
	#print " file2: ", $file, "\n";
	foreach my $words ( $$index{ $file } ) {
		foreach my $word ( keys %$words ){
			#print " Word in index ", $word, "\n";
		}
	}
}




# rank each word in a given document compared to a corpus
sub classify {

	my $index  = shift;
	my $file   = shift;
	my $corpus = shift;
	
	my %tags = ();
	
	foreach my $words ( $$index{ $file } ) {
	
		# calculate t, total number of words in a document
		my $t = 0;
		foreach my $word ( keys %$words ) { $t = $t + $$words{ $word } }
		
		foreach my $word ( keys %$words ) {
	
			# get n, query word count in a document
			my $n = $$words{ $word };
			
			# calculate h, number of hits across the corpus
			my ( $h, @files ) = &search( $index, $word );
			foreach $f (@files){
				#print " File (?) stacked in -files in classify: ", $f, "\n";
				
				
			}
			
		}
				
	}
	
	return \%tags;
	
}


# calculate tfidf
sub tfidf {

	# tfidf = ( n / t ) * log( d / h ) where:
	#     n = number of times a word appears in a document
	#     t = total number of words
	#     d = total number of documents
	#     h = number of documents that contain the word

	my $n = shift;
	my $t = shift;
	my $d = shift;
	my $h = shift;
	
	my $tfidf = 0;
	
	if ($n!=0) {
		if ( $d == $h ) { $tfidf = ( $n / $t ) }
	    else { $tfidf = ( $n / $t ) * log( $d / $h ) }
	
	return $tfidf;
	}
	else{
		
		return 0;
	}
	
}	
return 1;
