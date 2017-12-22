#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <map>

//class instruction, super classe de tout le reste
class instruction
{

public:
	virtual int executer() const=0;

private:
//peut être
}


class incplus:
	public instruction
{
public:
	incplus(std::string & const identifiant): _id(identifiant)		
	{}
	
	int executer() const override
	{
		
	}
	//on demlande la valeur pour cette variable, on sauvegarde la nouvelle valeur, puis on la retourne

private:
	std::string _id;
}


class incmoins:
	public instrtuction
{
public:
	incmoins(int val): _val(val--)
	{}

private:
	int _val;
}




