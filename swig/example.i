%module mylibwrap
%{
#include "mylib.h"
%}

%include stl.i
/* instantiate the required template specializations */
%template(DoubleVector) std::vector<double>;
%template(StringVector) std::vector<std::string>;
%template(DoubleVectorVector) std::vector<std::vector<double> >;
%template(StringVectorVector) std::vector<std::vector<std::string> >;


// Now list ANSI C/C++ declarations

extern std::string LibProcessString(const std::string& variableIdentifier);
extern std::vector<std::string> LibProcessVecString(const std::vector<std::string>& ids);
extern std::vector<std::string> LibGetVariableIdentifiers();
extern std::vector<std::vector<std::string> > LibGetVecVecString();
extern std::vector<std::vector<double> > LibGetVecVecDouble();
extern std::vector<double> LibGetVecDouble();
extern double LibProcessVecVecDouble(const std::vector<std::vector<double> >& data);
