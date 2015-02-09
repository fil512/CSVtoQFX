use QFX::QFXPosition;

class QFXStatement {
	has Str $.date;
	has Str $.brokerid;
	has Str $.acctid;
	has Str $.trnuid;
	has Str $.availCash;
	has QFXPosition @.positions;
	
	method addPosition(QFXPosition $position) {
		@!positions.push($position);
	}
}

