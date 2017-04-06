#!/usr/local/bin/perl 

use Math::Round qw(:all);

&lueTiedosto;
&etsiRegex;

sub lueTiedosto {
	open(XZY,"garmin.tcx");
	push(@kuskit,<XZY>);
	close(XZY);	
}


sub etsiRegex {
	# print "@kuskit";
	$laskePalauttava = 0;
	$laskeKevyt = 0;
	$laskeReipas = 0;
	$laskeKova = 0;
	$laskeMaksimi = 0;	
	$laskeKaikki = 0;
	$laskeSumma = 0;
	open(FILE,">testi.txt");
	foreach $rivi (@kuskit) {
		if ($rivi =~ /<Value>(.*?)<\/Value>/) {
			print FILE "$1\n";
			if ($1 < 111) { $laskePalauttava++; }
			if ($1 >= 111 && $1 < 140) { $laskeKevyt++; }	
			if ($1 >= 140 && $1 < 152) { $laskeReipas++; }
			if ($1 >= 152) { $laskeKova++; }
			$laskeKaikki++;
			$laskeSumma += $1;
			if ($1 > $laskeMaksimi) { $laskeMaksimi = $1; }
		}
		#$rivi =~ s/[\r\s]+//g;
		#$rivi =~ s/\./,/g; # pisteet pilkuiksi
	}
	close(FILE);

	$laskeKa = nearest(1, $laskeSumma/$laskeKaikki);
	$palPros = nearest(1, $laskePalauttava/$laskeKaikki*100);
	$kevPros = nearest(1, $laskeKevyt/$laskeKaikki*100);
	$reiPros = nearest(1, $laskeReipas/$laskeKaikki*100);
	$kovPros = nearest(1, $laskeKova/$laskeKaikki*100);

	print "Kaikki sykemerkinnät: $laskeKaikki \n";
	print "Palauttava (<111): $laskePalauttava ($palPros \%)\n";
	print "Kevyt (111<140): $laskeKevyt ($kevPros \%)\n";
	print "Reipas (140<152): $laskeReipas ($reiPros \%)\n";
	print "Kova (>152): $laskeKova ($kovPros \%)\n";
	print "Maksimi: $laskeMaksimi \n";
	print "Keskiarvo: $laskeKa \n";
}
