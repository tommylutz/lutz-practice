#!c:\Strawberry\perl\bin\perl.exe
use strict;
use warnings;
use IO::Socket::INET;
use IO::File;
use IO::Select;
use Time::HiRes;
$| = 1; #Autoflush stdout
use Getopt::Long;

my %Config = 
(
	Port => 8998,
	RemoteHost => '192.168.1.4',
	LogFile => "networktest.log",
	BufferSize => 4096,
	StatsPeriod => 5,
	Duration => 20, #seconds
	Tx=>0,
	Rx=>0,
	Connect => 0 #if not connect, then listen and accept
);

{
	my $logFileHandle = undef;
	sub log_it
	{
		if(not $logFileHandle)
		{
			printf("Log file is [%s]\n",$Config{LogFile});
			$logFileHandle = IO::File->new($Config{LogFile},"w") if not $logFileHandle;
			
			die("Unable to open log file") if not $logFileHandle;
		}
		$logFileHandle->printf(@_);
		$logFileHandle->printf("\n") if $_[0] !~ m/\n$/;
		return 1;
	}
	
	sub spew_it
	{
		log_it(@_);
		printf(@_);
		printf("\n") if $_[0] !~ m/\n$/;
	}
	
	
}

{
	my $testBuf = undef;
	sub testBuffer()
	{
		return $testBuf if $testBuf;
		my $packStr = 'C'x($Config{BufferSize});
		my @vals = ();
		for(my $i=0; $i<$Config{BufferSize}; ++$i)
		{
			push (@vals, int(rand(256)) );
		}
		$testBuf = pack($packStr,@vals);
		spew_it("Generated test buffer, size=%d",length $testBuf);
		return $testBuf;
	}
}

# creating object interface of IO::Socket::INET modules which internally does 
# socket creation, binding and listening at the specified port address.
sub listenForConn()
{
	my $socket = new IO::Socket::INET (
	LocalHost => '0.0.0.0',
	LocalPort => $Config{Port},
	Proto => 'tcp',
	Listen => 1,
	Reuse => 1
		) or die "ERROR in Socket Creation : $!\n";
	return $socket;
}

my %Stats = 
(
	LastStatPrint => 0,
	StartTime => 0,
	Tx   => 0,
	Rx   => 0,
	TxDiff => 0,
	RxDiff => 0,
);

sub logReceived($)
{
	my $bytesRx = $_[0];
	$Stats{Rx} += $bytesRx;
	$Stats{RxDiff} += $bytesRx;
}

sub logSent($)
{
	my $bytesTx = $_[0];
	$Stats{Tx} += $bytesTx;
	$Stats{TxDiff} += $bytesTx;
}

sub intermediateStatsPrint($)
{
	my $now = $_[0];
	return if ($now - $Stats{LastStatPrint}) < $Config{StatsPeriod};
	$Stats{StartTime} = $now if not $Stats{StartTime};
	my $diff = $now - $Stats{LastStatPrint};
	my $txRate = ($Stats{TxDiff}*8/$diff) / 1000000;
	my $rxRate = ($Stats{RxDiff}*8/$diff) / 1000000;
	spew_it("T=%6.2f: Tx %6.2f MB (%4.2f mbps) /  Rx: %6.2f MB (%4.2f mbps)",$now-$Stats{StartTime},$Stats{TxDiff}/1048576, $txRate, $Stats{RxDiff}/1048576, $rxRate);
	$Stats{RxDiff} = 0;
	$Stats{TxDiff} = 0;
	$Stats{LastStatPrint} = $now;
}

sub printStats()
{
	spew_it("TOTAL: Tx: %8.2f MB  /  Rx: %8.2f MB",$Stats{Tx}/1048576, $Stats{Rx}/1048576);
	my $txRate = $Stats{Tx} / $Config{Duration} * 8 / 1000000;
	my $rxRate = $Stats{Rx} / $Config{Duration} * 8 / 1000000;
	spew_it("OVERALL RATES: Tx: %4.2f mbps, Rx: %4.2f mbps",$txRate, $rxRate);
}

sub doStressTest($)
{
	my $sock = shift;
	my $select = IO::Select->new($sock) or die("Unable to create Select object $!");
		
	if(not $Config{Connect})
	{
		my $rx = '';
		$sock->recv($rx,4);
		spew_it("ERROR: Failed to receive duration of test!") and return if $rx !~ m/^[0-9]{4}$/;
		$Config{Duration} = $rx + 0;
		spew_it("Duration: $Config{Duration}");
	}
	else
	{
		$sock->send(sprintf("%04d",$Config{Duration}));
	}

	my $startTime = Time::HiRes::time();
	my $done = 0;
	my $quitTime = $startTime + $Config{Duration}+5;
	my $stopTime = $startTime + $Config{Duration};

	
	while(1)
	{
		my $now = Time::HiRes::time();
		intermediateStatsPrint($now);
		spew_it("Done with test") and last if $now >= $quitTime;
		
		if($Config{Rx} and $select->can_read(0))
		{
			my $rcvBuf = '';
			$sock->recv($rcvBuf,$Config{BufferSize});
			logReceived(length $rcvBuf);
		}
		
		if($Config{Tx} and ($now < $stopTime) and $select->can_write(0))
		{
			my $testBuf = testBuffer();
			my $bytesSent = $sock->send($testBuf);
			if(not $bytesSent or $bytesSent !=(length $testBuf)) { spew_it("Problem sending"); last; }
			logSent(length $testBuf);
		}
	}
	printStats();
	
}

sub usage()
{
	printf("Usage: networktest.pl [--connect]\n");
	return 1;
}

sub main()
{
	GetOptions(
		"connect" => \$Config{Connect},
		"duration=i" => \$Config{Duration},
		"tx" => \$Config{Tx},
		"remotehost=s" => \$Config{RemoteHost},
		"rx" => \$Config{Rx}) or usage() and die("Invalid options!");
	usage() and die("Must specify --tx or --rx") if not $Config{Tx} and not $Config{Rx};
		

	my $sock = undef;
	
	if($Config{Connect})
	{
		$Config{LogFile} .= '.con';
		spew_it("Attempting to connect");
		$sock = new IO::Socket::INET (
			PeerHost => $Config{RemoteHost},
			PeerPort => $Config{Port},
			Proto => 'tcp',
		) or die "ERROR in Socket Creation : $!\n";
		doStressTest($sock);
	}
	else
	{

		my $listenSock = listenForConn();
		while(1)
		{
			spew_it("Waiting for connection");
			$sock = $listenSock->accept();
			spew_it("Accepted connection");
			doStressTest($sock);
			$sock->close();
		}
	}	
	
}

main();
