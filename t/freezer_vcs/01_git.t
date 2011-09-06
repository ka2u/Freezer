use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Spec::Functions;
use Freezer::VCS::Git;
use Test::More tests => 5;

my $user = "ka2u";
my $temp = File::Temp->newdir();
my $rep_path = catdir($temp->dirname, $user);
mkdir $rep_path or die "mkdir: $!";
my $vcs = Freezer::VCS::Git->init($rep_path);

ok(-e catdir($rep_path, '.git'));

my ($fh, $filename) = File::Temp->tempfile('XXXX', DIR => $rep_path);
my @status = $vcs->status;
my @files = $vcs->untracked_array(@status);
is catdir($rep_path, $files[0]), $filename;

$vcs->add(@files);
@status = $vcs->status;
my @added = $vcs->changes_to_be_commit_array(@status);
is catdir($rep_path, $added[0]), $filename;

my @commited = $vcs->commit("hoge");
like $commited[0], qr/Created initial commit/;

my @logs = $vcs->log;
like $logs[0], qr/commit/;

