#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use DBI;		

my $endpoint="http://gs-service-production.geodab.eu/gs-service/services/essi/view/plata/cuahsi_1_1.asmx?WSDL";
my $accion="insert";

#~ my $dbh = DBI->connect("DBI:Pg:dbname=odm","wmlclient","wmlclient");
for(my $lon=-40;$lon>=-70;$lon--) {
	for(my $lat=-10;$lat>=-40;$lat--) {
		my $north = $lat;
		my $south = $lat - 1;
		my $east = $lon;
		my $west= $lon - 1;
		system("curl \"http://localhost:3000/wmlclient/sites?accion=$accion&north=$north&south=$south&east=$east&west=$west&endpoint=$endpoint\"");
	#~ exit;
	}
}
