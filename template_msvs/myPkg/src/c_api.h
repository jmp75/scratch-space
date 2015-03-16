#ifndef __C_API_H__
#define __C_API_H__

#include "R.h"
#include "rinternals.h"
#include "hello_world.h"

extern "C"
{
	SEXP say_hello_extern( SEXP myname );
}

#endif __C_API_H__
