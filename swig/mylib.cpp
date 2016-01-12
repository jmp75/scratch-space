
#include "mylib.h"

using namespace std;

namespace mylib {
	namespace models
	{
        MyClass::~MyClass() {}

        double x, y;

        std::string MyClass::ProcessString(const std::string& variableIdentifier)
        {
            string result = variableIdentifier;
            return result.append(string("_postfix"));
        }
        vector<string> MyClass::ProcessVecString(const vector<std::string>& ids)
        {
            vector<string> a;
            for (int i = 0 ; i < ids.size() ; i++ )
                a.push_back(ProcessString(ids[i]));
            return a;
        }
        vector<string> MyClass::GetVariableIdentifiers()
        {
            vector<string> a;
            a.push_back(string("blahVarId"));
            return a;
        }
        vector<vector<double> > MyClass::GetVecVecDouble()
        {
            vector<vector<double> > a;
            for (int i = 0 ; i < a.size() ; i++ )
                for (int j = 0 ; j < 5 ; j++ )
                    a[i].push_back(i+0.1*j);
            return a;
        }
        vector<vector<string> > MyClass::GetVecVecString()
        {
            vector<vector<string> > a(3);
            for (int i = 0 ; i < a.size() ; i++ )
                for (int j = 0 ; j < 5 ; j++ )
                    a[i].push_back(string("V"));
            return a;
        }
        vector<double> MyClass::GetVecDouble()
        {
            vector<double> a;
            for (int j = 0 ; j < 5 ; j++ )
                a.push_back(j);
            return a;
        }
        double MyClass::ProcessVecVecDouble(const vector<vector<double> >& data)
        {
            double result;
            for (int i = 0 ; i < data.size() ; i++ )
                for (int j = 0 ; j < data[i].size() ; j++ )
                    result += data[i][j];
            return result;
        }
	}

}

string LibProcessString(const std::string& variableIdentifier)
{
    mylib::models::MyClass obj;    
    return obj.ProcessString(variableIdentifier);
}
vector<string> LibProcessVecString(const vector<std::string>& ids)
{
    mylib::models::MyClass obj;    
    return obj.ProcessVecString(ids);
}
vector<string> LibGetVariableIdentifiers()
{
    mylib::models::MyClass obj;    
    return obj.GetVariableIdentifiers();
}
vector<vector<double> > LibGetVecVecDouble()
{
    mylib::models::MyClass obj;    
    return obj.GetVecVecDouble();
}
vector<vector<string> > LibGetVecVecString()
{
    mylib::models::MyClass obj;    
    return obj.GetVecVecString();
}
vector<double> LibGetVecDouble()
{
    mylib::models::MyClass obj;    
    return obj.GetVecDouble();
}
double LibProcessVecVecDouble(const vector<vector<double> >& data)
{
    mylib::models::MyClass obj;    
    return obj.ProcessVecVecDouble(data);
}

