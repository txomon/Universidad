////////////////////////////////////////////////////////////////////////////////
//   ____  ____   
//  /   /\/   /  
// /___/  \  /   
// \   \   \/  
//  \   \        Copyright (c) 2003-2004 Xilinx, Inc.
//  /   /        All Right Reserved. 
// /---/   /\     
// \   \  /  \  
//  \___\/\___\
////////////////////////////////////////////////////////////////////////////////

#ifndef H_Work_entidad_behavioral_H
#define H_Work_entidad_behavioral_H
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif


class Work_entidad_behavioral: public HSim__s6 {
public:

    HSim__s1 SE[6];

    HSim__s1 SA[6];
HSimConstraints *c6;
  char *t7;
HSimConstraints *c8;
  char *t9;
HSimConstraints *c10;
  char *t11;
    Work_entidad_behavioral(const char * name);
    ~Work_entidad_behavioral();
    void constructObject();
    void constructPorts();
    void reset();
    void architectureInstantiate(HSimConfigDecl* cfg);
    virtual void vhdlArchImplement();
};



HSim__s6 *createWork_entidad_behavioral(const char *name);

#endif