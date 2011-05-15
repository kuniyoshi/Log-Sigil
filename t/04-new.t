use Test::More tests => 1;
use Test::Exception;
use Log::Sigil;

dies_ok { Log::Sigil->new };

