#!/usr/bin/perl
# utdep.pl - Check the dependencies of an Unreal Tournament (UT99) file.
# Version: 0.1.0

# This script comes with NO WARRANTY so USE IT AT YOUR OWN RISK
# There should probably be some more error checking in the script however at
# the moment I don't have time to write that. Anyway the script should only
# read data and write to STDOUT so unless you do something stupid it
# shouldn't cause any damage.

# This script was written by Christiaan "Rork" ter Veen to report a list of
# packages an Unreal Tournament (UT99) map depends on. In theory it could do
# the same for other Unreal Tournament files and versions, however this is not
# tested. The main parts of the scripts are inspired on parts of a C++ code of
# another script see the next paragraph.
#
# With writing this script I had a lot of help at the Beyond Unreal forums, 
# especially from from Just**Me who gave me an example script to work from.
# You can find the topic with the example script here:
# http://forums.beyondunreal.com/showthread.php?p=2285785
#
# Other helpfull pages at UnrealWiki:
# http://wiki.beyondunreal.com/wiki/Package_File_Format
# http://wiki.beyondunreal.com/wiki/Package_File_Format/Data_Details
#
# Not all packages can be determined to their filetype, in this case <name>.???
# is used, I'll see if I can imporve this.
#
# Some extra subroutines are available to write out the Headers, Names Table
# and Import Table. Also there's some leftover subroutines to store (and print)
# the Export Table, these last subroutines weren't tested after ordening the
# script.
#
# You may change anything you want and redistribute it too. If you do I would
# appreciate it if you sent me the changes. You can probably reach me for that
# and any questions via my website: www.rork.nl

use strict;
use warnings;

my $debug = 0;

my $map = shift;

unless ($map) {
  print "Usage: perl -w $0 <FileName> [ -h | -n | -i | -d ]\n";
  print "  to print headers, name, imports, or dependencies (default).\n";
  exit;
}

my %headers;
my (@names, @imports, @exports);

open(MAP, "<", $map) or die "Can't open $map: $!";

# get the headers to find the tables.
getHeaders();

# check the file's signature to make sure it's an Unreal Tournament file;
if ($headers{"Signature"} ne "9e2a83c1") {
  die "Invallid file";
}

# get the tables I need to get the dependancies
getNames();
getImports();
getImportNames();

# parseAndRunArgs();

my $arg;

$arg = shift;

if ($arg) {
} else {
  $arg = "-d";
}

while ($arg) {
  if ($arg eq "-h") {
    printHeaders();
  }
  if ($arg eq "-n") {
    printNames();
  }
  if ($arg eq "-i") {
    printImports();
  }
  if ($arg eq "-d") {
    printDependencies();
  }
  # $arg = shift || exit;
  $arg = shift;
}

close(MAP);

#----------------------------------------#
# subroutines used above and for testing #
#----------------------------------------#

sub getHeaders {
  # this shouldn't be an issue, paranoia.
  seek(MAP, 0, 0);
  $headers{"Signature"} = sprintf("%x", ReadLong());
  $headers{"Version"} = ReadShort();
  $headers{"License"} = ReadShort();
  $headers{"Flag"} = ReadLong();
  $headers{"NameCount"} = ReadLong();
  $headers{"NameOffset"} = ReadLong();
  $headers{"ExportCount"} = ReadLong();
  $headers{"ExportOffset"} = ReadLong();
  $headers{"ImportCount"} = ReadLong();
  $headers{"ImportOffset"} = ReadLong();

  # only get the GUID if the version >= 68
  if ($headers{"Version"} >= 68) {
    $headers{"GUID"} = sprintf("%x", ReadLong()) . "-" . sprintf("%x", ReadLong()) . "-" . sprintf("%x", ReadLong()) . "-" . sprintf("%x", ReadLong());
  }
}

sub getImports {
  # skip to the imports table
  seek(MAP, $headers{"ImportOffset"}, 0);
  for (my $i = 0; $i < $headers{"ImportCount"}; $i++) {
    my $offset = tell(MAP);
    my $class_package = ReadIndex();
    my $class_name = ReadIndex();
    my $package = ReadLong();
    my $name = ReadIndex();
    $imports[$i] = {"offset" => $offset, "uPackage" => $class_package, "uName" => $class_name, "Package" => $package, "Name" => $name};
  }
}

sub getImportNames {
  for(my $i = 0; $i < $headers{"ImportCount"}; $i++) {
    $imports[$i]->{"_uPackage"} = getName($imports[$i]->{"uPackage"});
    $imports[$i]->{"_uName"} = getName($imports[$i]->{"uName"});
    ## Catch the bug where we fail to parse the file properly, and abort the process instead of looping and spewing errors.
    # if ($imports[$i]->{"Package"} < 0 || $imports[$i]->{"Package"} >= 0) {
    # } else {
      # die "getImportNames(): Package is not a number!"
    # }
    # if (!$imports[$i]->{"Package"}) {
    if ($imports[$i]->{"Package"} eq "") {
      die "getImportNames(): \$import[".$i."]->{\"Package\"} has no value; aborting";
      # die "getImportNames(): Package \"" . ($imports[$i]->{"Package"}) . "\" (".$i.") is not a number; aborting";
    }
    if ($imports[$i]->{"Package"} < 0) {
      my $tmp = $imports[$i]->{"Package"};
      $tmp *= -1;
      $tmp -= 1;
      $imports[$i]->{"_Package"} = getName($imports[$tmp]->{"Name"});
    }
    else {
      $imports[$i]->{"_Package"} = getName($imports[$i]->{"Package"});
    }
    $imports[$i]->{"_Name"} = getName($imports[$i]->{"Name"});
  }
}

sub getName {
  my $i = shift;
  if ($i < 0) {
      return "Engine";
  }
  elsif ($i > $#names) {
    return "Error";
  }
  else {
    return $names[$i]->{"Name"};
  }
}

sub getNames {
  # skip to the name table.
  seek(MAP, $headers{"NameOffset"}, 0);

  my $object;
  my $length;

  for (my $i = 0; $i < $headers{"NameCount"}; $i++) {
    my ($length, $object);
    read(MAP, $length, 1);
      $length = unpack("C", $length);
    read(MAP, $object, $length);
    $object =~ s/ $//g;

    my $flag = ReadLong();
    $names[$i] = { "Name" => $object, "Flag" => $flag }; 
    # $debug && print "getNames: name=" . $object . " flag=" . $object . "\n";
  }
}

sub printDependencies {
  # this subroutine can probably be written a lot better but this will do for now.
  for (my $i = 0; $i < $headers{"ImportCount"}; $i++) {
    if ($imports[$i]->{"Package"} == 0) {
      # now we have a package;
      for(my $x = 0; $x < $headers{"ImportCount"}; $x++) {
        if ($imports[$i]->{"_Name"} eq $imports[$x]->{"_Package"}) {
          # there must be some hidden character for I can only use a regexp and not an exact match;
          if ($imports[$x]->{"_uName"} =~ m/Class/) {
            $imports[$i]->{"Type"} = ".u";
            last;
          }
          elsif ($imports[$x]->{"_uName"} =~ m/Texture/) {
            $imports[$i]->{"Type"} = ".utx";
          }
          elsif ($imports[$x]->{"_uName"} =~ m/Sound/) {
            $imports[$i]->{"Type"} = ".uax";
          }
          elsif ($imports[$x]->{"_uName"} =~ m/Music/) {
            $imports[$i]->{"Type"} = ".umx";
          }
	  else {
            # another deeper search for the origin of a package;
            foreach (my $y = 0; $y < $headers{"ImportCount"}; $y++) {
              if ($imports[$x]->{"_Name"} eq $imports[$y]->{"_Package"}) {
                if ($imports[$y]->{"_uName"} =~ m/Class/) {
                  $imports[$i]->{"Type"} = ".u";
                  last;
                }
                elsif ($imports[$y]->{"_uName"} =~ m/Texture/) {
                  $imports[$i]->{"Type"} = ".utx";
                }
                elsif ($imports[$y]->{"_uName"} =~ m/Sound/) {
                  $imports[$i]->{"Type"} = ".uax";
                }
                elsif ($imports[$y]->{"_uName"} =~ m/Music/) {
                  $imports[$i]->{"Type"} = ".umx";
                }
              }
             }
          }
          # if a package is marked as a non .u file it can also be .u package with some imported stuff
          # if it's an .u there's no need to look further though.
          last if ($imports[$i]->{"Type"} and $imports[$i]->{"Type"} eq ".u");
        }
        # same here.
          last if ($imports[$i]->{"Type"} and $imports[$i]->{"Type"} eq ".u");
        }
        print $imports[$i]->{"_Name"};
        if ($imports[$i]->{"Type"}) {
          print $imports[$i]->{"Type"} . "\n";
        }
        else {
        print ".???\n";
      }
    }
  }
}

sub printHeaders {
  print "Headers:";
  print "\n  Signature: " . $headers{"Signature"};
  print "\n  Version: " . $headers{"Version"};
  print "\n  License: " . $headers{"License"};
  print "\n  Flag: " . $headers{"Flag"};
  print "\n  Name Count: " . $headers{"NameCount"};
  print "\n  Name Offset: " . $headers{"NameOffset"};
  print "\n  Export Count: " . $headers{"ExportCount"};
  print "\n  Export Offset: " . $headers{"ExportOffset"};
  print "\n  Import Count: " . $headers{"ImportCount"};
  print "\n  Import Offset: " . $headers{"ImportOffset"};

  # only print the GUID if the version >= 68
  if ($headers{"Version"} >= 68) {
    print "\nGUID: " . $headers{"GUID"} 
  }

  print "\n\n";
}

sub printImports {
  print "Imports:";

  for (my $i = 0; $i < $headers{"ImportCount"}; $i++) {
    print "\n  Import $i: ";
    print join(".", $imports[$i]->{"_uPackage"}, $imports[$i]->{"_uName"}, $imports[$i]->{"_Package"}, $imports[$i]->{"_Name"});
  }
  print "\n\n";
}

sub printNames {
  print "Names";
  for (my $i = 0; $i < $headers{"NameCount"}; $i++) {
    print "\n  Name $i: " . $names[$i]->{"Name"};
  }
  print "\n\n";
}

sub ReadIndex {
  # read an index coded section from MAP, I really have no idea what I'm doing
  # here, just copied the code from the original script but it seems to work ok

  my $buffer;
  my $neg;

  for(my $i = 0; $i < 5; $i++) {
    my $more = 0;
    my $char;
    read(MAP, $char, 1);
    $char = vec($char, 0, 8);
    my $length = 6;

    if ($i == 0) {
      $neg = ($char & 0x80);
      $more = ($char & 0x40);
      $buffer = ($char & 0x3F);
    }
    elsif ($i == 4) {
      $buffer |= ($char & 0x80) << $length;
      $more = 0;
    }
    else {
     $more = ($char & 0x80);
     $buffer |= ($char & 0x7F) << $length;
     $length += 7;
    }
    last unless ($more);
  }

  if ($neg) {
    $buffer *= -1;
  }

  # $debug && print "ReadIndex returning buffer: " . $buffer . "\n";
  return $buffer;

}

sub ReadLong {
  my $string;
  my $char = read(MAP, $string, 4);
  return unpack("l", $string);
}

sub ReadShort {
  my $string;
  read(MAP, $string, 2);
  return unpack("S", $string);
}

#----------------------------------------------------------------------------------#
# some subroutines from when I wrote the script, maybe someone needs them sometime.#
# WARNING: these subroutines haven't been tested after reordering the script.      #
#----------------------------------------------------------------------------------#

sub export {
  seek(MAP, $headers{"ExportOffset"}, 0);
  for (my $i = 0; $i < $headers{"ExportCount"}; $i++) {
    $debug && print "Export Package $i: ";

    my %object;
    $object{"Offset"} = tell(MAP);
    $object{"Class"} = ReadIndex();
    $object{"Super"} = ReadIndex();
    $object{"Package"} = ReadLong();
    $object{"Name"} = ReadIndex();
    $object{"Flags"} = ReadLong();
    $object{"Size"} = ReadIndex();

    if ($object{"Size"} > 0) {
      $object{"Offset"} = ReadIndex();
    }

    $debug && print "Export P " . getName($object{"Package"}) . ".";
    $debug && print "Export S " . getName($object{"Super"}) . ".";

    if ($object{"Class"} < 0) {
      $object{"Class"} *= -1;
      $object{"Class"} -= 1;
      $object{"Class"} = $imports[$object{"Class"}]->{"Name"};
    }

#    print getName($object{"Class"}) . ".";
#    print getName($object{"Name"}) . " ";
#    print $object{"Flags"} . " ";
#    print $object{"Size"} . " ";
    # print $object{"Storage"} . " ";
#    print sprintf("%x", $object{"Offset"}) . "\n";

    $exports[$i] = \%object;

  }
}

sub storeExport {
  # another side track, it was in the original script but dunno if it's important.
  for (my $i = 0; $i < $headers{"ImportCount"}; $i++) {

    if ($exports[$i]->{"Size"} <= 1) {
      $exports[$i]->{"BytesRead"} = $exports[$i]->{"Size"};
      next;
    }

    seek(MAP, $exports[$i]->{"Offset"}, 0);
    # $export[$i]->{"Data"} = malloc($exports[$i]->{"Size"});
    # next unless $exports[$i]->{"Data"};

    $exports[$i]->{"BytesRead"} = read(MAP, $exports[$i]->{"Data"}, $exports[$i]->{"Size"});

    $debug && print "Export Object $i: " . $exports[$i]->{"Data"} . "\n";
  }
}
