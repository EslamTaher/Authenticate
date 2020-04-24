#!/usr/bin/perl
## Do not forget to set envi variable export PERL5LIB=.
use strict;
use DBI;
my %SETTINGS;
my $DSN;
my $dbh;
my $sqlstr;
my $rec;
my $username;
my $password;
my $operation;
my $email;
use dbUser;
use Validate;
my $config = 'config.ini';
open(my $filehandle1, '<', $config) or die "Can't open $config";
my @configArray;
while(my $line = <$filehandle1>){
    chomp $line;
    my @linearray = split("=", $line);
    push(@configArray, @linearray[1])
}
$SETTINGS{"DBHOST"}=@configArray[0];
$SETTINGS{"DBUSER"}=@configArray[1];
$SETTINGS{"DBPASS"}=@configArray[2];
$SETTINGS{"DBNAME"}=@configArray[3];
$DSN="DBI:mysql:database=".$SETTINGS{"DBNAME"}.";host=".$SETTINGS{"DBHOST"}."";
$dbh=DBI->connect($DSN,$SETTINGS{"DBUSER"},$SETTINGS{"DBPASS"}) or die "$dbh->errstr()";
print "Enter R If you want To Register Or A For Authentication[R/A]: ";
$operation = <STDIN>;
chomp $operation;
if($operation eq "R")
{
    print "Enter your username: ";
    $username = <STDIN>;
    chomp $username;
    if(!Validate::checkValidUser($username))
    {
        print "Sorry This username is invalid\n";
        exit;
    }
    print "Enter your password: ";
    $password = <STDIN>;
    system ("stty echo");
    chomp $password;
    if(!Validate::checkValidPassword($password))
    {
        print "Sorry Thus Password is Invalid\n";
        exit;
    }
    print "Enter your email: ";
    $email = <STDIN>;
    chomp $email;
    if(!Validate::checkValidEMail($email))
    {
        print "Sorry This Email is Invalid\n";
        exit;
    }
    if(dbUser::registerUser($username, $password, $email,$dbh))
    {
        print "Success! Your Account Registered Successfully..\n";
    }
    else
    {
        print "Sorry This User Already Exist..\n";
    }
}
elsif($operation eq "A")
{
    print "Enter your username: ";
    $username = <STDIN>;
    chomp $username;
    print "Enter your password: ";
    $password = <STDIN>;
    system ("stty echo");
    chomp $password;
    if(dbUser::authUser($username, $password, $dbh))
    {
        print "Welcome! Access granted...\n";
        exit;
    }
    print "Sorry Access Denied!!..\n";
}
else{
    print "Please Select Valid Operation [R/A]";
}
