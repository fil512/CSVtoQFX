use QFX::QFXPosition;

class QFXStatement {
	has Str $.date;
	has Str $.trnuid;
	has Str $.fitid;
	has Str $.availCash;
	has QFXPosition @.positions;
	
	method addPosition(QFXPosition $position) {
		@!positions.push($position);
	}
}

