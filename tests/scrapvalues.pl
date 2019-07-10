#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use DBI;		
use Astro::Time;
use Data::Dumper;

my $endpoint="http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL";
my $accion="insert";

my $dbh = DBI->connect("DBI:Pg:dbname=odm","wmlclient","wmlclient");
my $sites = $dbh->selectall_arrayref("select \"SiteCode\" from \"Sites\" WHERE \"SiteID\">=3988");
foreach(@$sites) {
	#~ print "$_\n";
	my $site=$_->[0];
	my $siteinfo = `curl "http://localhost:3000/wmlclient/siteinfo?accion=download&site=$site&endpoint=$endpoint"`;
	#~ print "$siteinfo \n";
	#~ try{
		my $si = decode_json $siteinfo;
		#~ print Dumper($si);
		#~ exit;
		foreach my $s (@{$si->{sitesResponse}->{site}->[0]->{seriesCatalog}->[0]->{series}}) {
			my $variableCode = $s->{variable}->{variableCode}->[0]->{"\$value"};
			my $startdate = $s->{variableTimeInterval}->{beginDateTimeUTC};
			my $enddate = $s->{variableTimeInterval}->{endDateTimeUTC};
			my @a = split (/T/,$enddate);
			my @b = split (/-/,$a[0]);
			my $jed = cal2mjd($b[2],$b[1],$b[0],0);
			my $jsd = $jed - 7;
			my @csd = mjd2cal($jsd);
			my $customstartdate = "$csd[2]-$csd[1]-$csd[0]T00:00:00.000Z";
			print STDERR "Intentando site $site, var $variableCode, startdate $customstartdate, enddate $enddate...\n";
			system("curl \"http://localhost:3000/wmlclient/values?accion=insert&site=$site&variable=$variableCode&startDate=$customstartdate&endDate=$enddate&endpoint=$endpoint\"");
		}
	#~ } catch {
		#~ my $e=shift;
		#~ print STDERR "Error: $e\n";
	#~ }
		
}
