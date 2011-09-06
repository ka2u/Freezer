package Freezer::VCS::Git;

use strict;
use warnings;
use Git::Repository;

sub new {
    my ($class, $path) = @_;

    my $r = Git::Repository->new(work_tree => $path);
    my $self = bless {repos => $r}, $class;
    return $self;
}

sub init {
    my ($class, $path) = @_;

    Git::Repository->run(init => {cwd => $path});
    my $r = Git::Repository->new(work_tree => $path);
    my $self = bless {repos => $r}, $class;
    return $self;
}

sub status {
    my $self = shift;

    return $self->{repos}->run('status');
}

sub add {
    my ($self, @files) = @_;

    for (@files) {
        $self->{repos}->run(add => $_);
    }
}

sub commit {
    my ($self, $message) = @_;

    return $self->{repos}->run(commit => '-m',  $message);
}

sub log {
    my $self = shift;

    return $self->{repos}->run('log');
}

sub untracked_array {
    my ($self, @output) = @_;

    return $self->_status_filter(
        "Untracked files",
        "nothing added to commit but untracked files present",
        '#\s+(.*)', @output);
}

sub changes_to_be_commit_array {
    my ($self, @output) = @_;

    return $self->_status_filter(
        "Changes to be committed",
        undef,
        '#\s+new file:\s+(.*)', @output);
}

sub _status_filter {
    my ($self, $mark_line, $skip, $regexp,  @output) = @_;

    my $flag;
    my @files;
    while (my $line = shift @output) {
        if ($line =~ /$mark_line/) {
            my $i = 0;
            while($i < 2) {
                shift @output;
                $i++;
            }
            $flag = 1;
            next;
        }
        next if $skip && $line =~ /$skip/;
        $line =~ /$regexp/;
        push @files, $1 if $flag && $1;
    }
    return @files;
}

1;
