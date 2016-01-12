#pragma once

#include <vector>
#include <string>

using namespace std;

namespace mylib {
	namespace models
	{
		class MyClass
		{
		public:
			virtual ~MyClass();

			double x, y;

			std::string ProcessString(const std::string& variableIdentifier);
			vector<string> ProcessVecString(const vector<std::string>& ids);
			vector<string> GetVariableIdentifiers();
            vector<vector<string> > GetVecVecString();
			vector<vector<double> > GetVecVecDouble();
			vector<double> GetVecDouble();
			double ProcessVecVecDouble(const vector<vector<double> >& data);

		};

	}

}


string LibProcessString(const std::string& variableIdentifier);
vector<string> LibProcessVecString(const vector<std::string>& ids);
vector<string> LibGetVariableIdentifiers();
vector<vector<string> > LibGetVecVecString();
vector<vector<double> > LibGetVecVecDouble();
vector<double> LibGetVecDouble();
double LibProcessVecVecDouble(const vector<vector<double> >& data);
