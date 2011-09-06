use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Freezer',
    AUTHOR        => 'Some Person <person@example.com>',
    VERSION_FROM  => 'lib/Freezer.pm',
    PREREQ_PM     => {
        'Amon2'                           => '2.49',
        'Text::Xslate'                    => '1.1005',
        'Text::Xslate::Bridge::TT2Like'   => '0.00008',
        'Plack::Middleware::ReverseProxy' => '0.09',
        'HTML::FillInForm::Lite'          => '1.09',
        'Time::Piece'                     => '1.20',
        'Git::Repository'                 => '1.21',
        'DBIx::Skinny'                    => '0.0741',
        'Qudo'                            => '0.0213',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
