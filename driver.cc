#include "driver.hh"
#include <iostream>

Driver::Driver() {}
Driver::~Driver() {}

int Driver::getSuperInt(const std::string & superMot) {
	if (present(superMot))
		return supermap[superMot];
	else
		throw DriverError("Variable non existante.");
}

void Driver::setSuperInt(const std::string & superMot, int superFloat) {
	supermap[superMot]=superFloat;
}


DriverError::DriverError(std::string const & message): _message(message) {
}
