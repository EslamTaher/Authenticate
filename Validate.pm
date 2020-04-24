#!/usr/bin/perl
package Validate;
sub checkValidUser
{
    my ($username) = @_;
    if($username eq "")
    {
        return 0;
    }
    return 1;
}
sub checkValidEMail
{
    my ($email) = @_;
    if($email =~ m/^([a-zA-Z][\w\_\.]{2,15})\@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,4})$/)
    {
        return 1;
    }
    return 0;
}
sub checkValidPassword
{
    my ($password) = @_;
    if($password =~ m/^[a-zA-Z0-9]{6,40}$/)
    {
        return 1;
    }
    return 0;
}
1;