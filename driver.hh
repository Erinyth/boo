#pragma once

#include <map>
#include <string>

class Driver {
public:
    Driver();
    ~Driver();

    int getSuperInt(const std::string & superMot);
    
    void setSuperInt(const std::string & superMot, int superFloat);

 	bool present(std::string identifiant)
 	{
 		auto i = supermap.find(identifiant);
 		return !(i==supermap.end());
 	}
    
private:
    std::map<std::string,int> supermap;
};



class DriverError{
public:
	DriverError(std::string const & message);
	~DriverError()=default;

private:
	std::string _message;
};
