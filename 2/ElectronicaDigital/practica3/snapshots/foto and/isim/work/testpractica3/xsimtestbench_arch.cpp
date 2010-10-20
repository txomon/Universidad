static const char * HSimCopyRightNotice = "Copyright 2004-2005, Xilinx Inc. All rights reserved.";
#ifdef __MINGW32__
#include "xsimMinGW.h"
#else
#include "xsim.h"
#endif
#include "C:/Archivos de programa/Xilinx ISE 9.2i/vhdl/hdp/nt/ieee/std_logic_1164/std_logic_1164.h"
#include "C:/Archivos de programa/Xilinx ISE 9.2i/vhdl/hdp/nt/ieee/std_logic_arith/std_logic_arith.h"
#include "C:/Archivos de programa/Xilinx ISE 9.2i/vhdl/hdp/nt/std/textio/textio.h"
#include "C:/Archivos de programa/Xilinx ISE 9.2i/vhdl/hdp/nt/ieee/std_logic_unsigned/std_logic_unsigned.h"
#include "C:/Archivos de programa/Xilinx ISE 9.2i/vhdl/hdp/nt/ieee/std_logic_textio/std_logic_textio.h"

class _top : public HSim__s6 {
public:
    _top() : HSim__s6(false, "_top", "_top", 0, 0, HSim::VhdlDesignEntity) {}
    HSimConfigDecl * topModuleInstantiate() {
        HSimConfigDecl * cfgvh = 0;
        cfgvh = new HSimConfigDecl("default");
        (*cfgvh).registerFuseLibList("unisims_ver");

        HSim__s6 * topvh = 0;
        extern HSim__s6 * createWork_testpractica3_testbench_arch(const char*);
        topvh = createWork_testpractica3_testbench_arch("testpractica3");
        topvh->constructPorts();
        topvh->checkTopLevelPortsConstrainted();
        topvh->vhdlArchImplement();
        topvh->architectureInstantiate(cfgvh);
        addChild(topvh);
        return cfgvh;
}
};

main(int argc, char **argv) {
  HSimDesign::initDesign();
  globalKernel->getOptions(argc,argv);
  HSim__s6 * _top_i = 0;
  try {
    IeeeStd_logic_1164=new Ieee_std_logic_1164("std_logic_1164");
    IeeeStd_logic_arith=new Ieee_std_logic_arith("std_logic_arith");
    StdTextio=new Std_textio("TEXTIO");
    IeeeStd_logic_unsigned=new Ieee_std_logic_unsigned("STD_LOGIC_UNSIGNED");
    IeeeStd_logic_textio=new Ieee_std_logic_textio("STD_LOGIC_TEXTIO");
    HSimConfigDecl *cfg;
 _top_i = new _top();
  cfg =  _top_i->topModuleInstantiate();
    return globalKernel->runTcl(cfg, _top_i, "_top", argc, argv);
  }
  catch (HSimError& msg){
    try {
      globalKernel->error(msg.ErrMsg);
      return 1;
    }
    catch(...) {}
      return 1;
  }
  catch (...){
    globalKernel->fatalError();
    return 1;
  }
}
