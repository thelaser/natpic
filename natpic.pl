#!/usr/local/bin/perl     
use strict;
use File::Path qw(make_path);

# Script to download image of the day from National Geographic


#Global var
my $dirname = join "", $ENV{"HOME"}, "/Pictures/NG/";

## Arguments treatement

if (scalar @ARGV > 1) {
    print "The program only accepts 1 argument, the destination folder";
    exit;
}
elsif ($ARGV[0] eq "--help") {
    print "Only one option available, the destination folder, which is the first argument. If not provided, the output defaults to ~/Pictures/NG/";
    exit;
}
elsif (scalar @ARGV == 1) {
    $dirname = $ARGV[0];
    if ((substr $dirname, -1) ne "/"){
        $dirname = join "", $dirname, "/";
    }
    print "$dirname \n"; 
}



################ Subroutines ######################


sub download_save {
    # this variable holds the filename
    #my @list = @_;
    
    my $NAME = join "", "NGPic_", `date +"%m-%d-%Y"|tr -d "\n"`, ".jpg";
    my $final_dest = join "", $dirname, $NAME;


    # we only want to download and save if it hasn't been done previously for the same day
    if (!-e $final_dest) {
        
        # we dowload the pic from national geographic's web into temporal folder
        `/usr/bin/wget http://photography.nationalgeographic.com/photography/photo-of-the-day/ --quiet -O- > /tmp/index`;
        
        # here we extract the image link from NG's downloaded website
        # grep https://www.nationalgeographic.com/content/dam/photography/photo-of-the-day/*.*adapt.1900.1.jpeg hola | rev | cut -d'"' -f2 | rev"
        my $link=`grep https://www.nationalgeographic.com/content/dam/photography/photo-of-the-day/*.*adapt.1900.1.jpeg /tmp/index  | rev | cut -d'"' -f2 | rev | head -c -1`;
        
        # download and save image to desired folder (by default ~/Pictures/NG)
        `/usr/bin/wget $link --quiet -O $final_dest`;
        `rm /tmp/index`;
    }

}

################ Main ######################


if (-d $dirname) {
    download_save();
}

else {
    ## if folder doesn't already exist, let's create it
    eval { make_path($dirname) };
    download_save();
}

#############################################
