#!/usr/bin/perl
package dbUser;
sub checkUserExist
{
    my ($username, $dbh) = @_;
    my $sqlstr;
    $sqlstr = $dbh->prepare("SELECT username FROM user WHERE username=?");
    $sqlstr->execute($username) or die "$dbh->errstr()";
    if($sqlstr->rows > 0){
        return 1;
    }
    return 0;
}

# Register User Function
sub registerUser{
    my ($username, $password, $email, $dbh) = @_;
    if(!checkUserExist($username, $dbh))
    {
        my $sqlstr;
        my $unHashedPass;
        my $pro;
        my $salt;
        my $hashedPassword;
        my $myHash;
        $myHash = qx{mkpasswd --method=sha-512 $password};
        $_ = $myHash;
        ($pro, $pro, $salt, $hashedPassword) = split /\$/;
        chomp $hashedPassword;
        my $query = "INSERT INTO user(username,email,password,salt) VALUES(?, ?, ?, ?)";
        $sqlstr=$dbh->prepare($query) or die "$dbh->errstr()";
        $sqlstr->execute($username, $email, $myHash, $salt) or die "$dbh->errstr()";
        $sqlstr->finish();
        return 1;
    }
    return 0;
}

# Authenticate User Function
sub authUser{
    my ($username, $password, $dbh) = @_;
    my $sqlstr;
    my $hashedPassword;
    my $salt;
    if(checkUserExist($username, $dbh))
    {
        $sqlstr=$dbh->prepare("SELECT * FROM user") or die "$dbh->errstr()";
        $sqlstr->execute() or die "$dbh->errstr()";
        while ( $rec = $sqlstr->fetchrow_hashref() ) {
            $salt = $rec->{"salt"};
            $hashedPassword = qx{mkpasswd -m sha-512 $password $salt};
            chomp $hashAfterGenerate;
            if($rec->{"password"} eq $hashedPassword)
            {
                return 1;
            }
        }
        $sqlstr->finish;
    }
    return 0;
}
1;