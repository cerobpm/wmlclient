#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use DBI;		

my $endpoint="http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL";
my $accion="insert";

my $dbh = DBI->connect("DBI:Pg:dbname=odm","wmlclient","wmlclient");
my $sites = $dbh->selectall_arrayref("select \"SiteCode\" from \"Sites\" WHERE \"SiteID\">=3988");
foreach(@$sites) {
	#~ print "$_\n";
	my $site=$_->[0];
	system("curl \"http://localhost:3000/wmlclient/siteinfo?accion=$accion&site=$site&endpoint=$endpoint\"");
	#~ exit;
}
