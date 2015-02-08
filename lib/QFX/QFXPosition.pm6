role QFXInstrument {
	has Str $.posType;
	has Str $.secType;
	has Str $.uniqueId;
	has Str $.secName;
	has Str $.ticker;
}

class QFXStock is QFXInstrument {
	has Str $.posType = "POSSTOCK";
	has Str $.secType = "STOCKINFO";
}

class QFXPortion {
	has Str $.assetClass;
	has Str $.percent;
}

class QFXMutualFund is QFXInstrument {
	has Str $.posType = "POSMF";
	has Str $.secType = "MFINFO";
	has @.portions;
}

class QFXPosition {
	has QFXInstrument $.instrument;
	has Str $.units;
	has Str $.unitPrice;
	has Str $.mktVal;
	has Str $.date;
	
	method posType {
		$.instrument.posType;
	}
	
	method secType {
		$.instrument.secType;
	}
	
	method toPositionXML {
		qq :to 'EOT';
<INVPOS>
	<SECID>
		<UNIQUEID>{$.instrument.uniqueId}</UNIQUEID>
		<UNIQUEIDTYPE>ISM_SEC_ID</UNIQUEIDTYPE>
	</SECID>
	<HELDINACCT>CASH</HELDINACCT>
	<POSTYPE>LONG</POSTYPE>
	<UNITS>{$.units}</UNITS>
	<UNITPRICE>{$.unitPrice}</UNITPRICE>
	<MKTVAL>{$.mktVal}</MKTVAL>
	<DTPRICEASOF>{$.date}</DTPRICEASOF>
</INVPOS>
EOT
	}

	method toSecInfoXML {
		my $retval = qq :to 'EOT';
<SECINFO>
	<SECID>
		<UNIQUEID>{$.instrument.uniqueId}</UNIQUEID>
		<UNIQUEIDTYPE>ISM_SEC_ID</UNIQUEIDTYPE>
	</SECID>
	<SECNAME>{$.instrument.secName}</SECNAME>
	<TICKER>{$.instrument.ticker}</TICKER>
</SECINFO>
EOT
		if ($.instrument ~~ QFXMutualFund) {
			$retval ~= "<MFASSETCLASS>";
			for $.instrument.portions -> $portion {
				$retval ~= qq :to 'EOT';
<PORTION>
	<ASSETCLASS>{$portion.assetClass}</ASSETCLASS>
	<PERCENT>{$portion.percent}</PERCENT>
</PORTION>
EOT
			}
			$retval ~= "</MFASSETCLASS>";
		}
		$retval;
	}
}


