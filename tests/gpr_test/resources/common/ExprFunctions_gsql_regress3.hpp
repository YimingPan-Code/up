/******************************************************************************
 * Copyright (c) 2015-2016, TigerGraph Inc.
 * All rights reserved.
 * Project: TigerGraph Query Language
 * udf.hpp: a library of user defined functions used in queries.
 *
 * - This library should only define functions that will be used in
 *   TigerGraph Query scripts. Other logics, such as structs and helper
 *   functions that will not be directly called in the GQuery scripts,
 *   must be put into "ExprUtil.hpp" under the same directory where
 *   this file is located.
 *
 * - Supported type of return value and parameters
 *     - int
 *     - float
 *     - double
 *     - bool
 *     - string (don't use std::string)
 *     - accumulators
 *
 * - Function names are case sensitive, unique, and can't be conflict with
 *   built-in math functions and reserve keywords.
 *
 * - Please don't remove necessary codes in this file
 *
 * - A backup of this file can be retrieved at
 *     <tigergraph_root_path>/dev_<backup_time>/gdk/gsql/src/QueryUdf/ExprFunctions.hpp
 *   after upgrading the system.
 *
 ******************************************************************************/

#ifndef EXPRFUNCTIONS_HPP_
#define EXPRFUNCTIONS_HPP_

#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <gle/engine/cpplib/headers.hpp>

/**     XXX Warning!! Put self-defined struct in ExprUtil.hpp **
 *  No user defined struct, helper functions (that will not be directly called
 *  in the GQuery scripts) etc. are allowed in this file. This file only
 *  contains user-defined expression function's signature and body.
 *  Please put user defined structs, helper functions etc. in ExprUtil.hpp
 */
#include "ExprUtil.hpp"

namespace UDIMPL {
  typedef std::string string; //XXX DON'T REMOVE

  inline MinAccum<uint64_t> addUintMinAccum(MinAccum<uint64_t> accum) {
    accum += 0;
    return accum;
  }

  inline MinAccum<int> addIntMinAccum(MinAccum<int> accum) {
    accum += 0;
    return accum;
  }

  inline MinAccum<float> addFloatMinAccum(MinAccum<float> accum) {
    accum += 1.0;
    return accum;
  }

  inline MinAccum<double> addDoubleMinAccum(MinAccum<double> accum) {
    accum += 1.0;
    return accum;
  }

  inline MinAccum<VERTEX> addVertexMinAccum(MinAccum<VERTEX> accum, VERTEX v) {
    accum += v;
    return accum;
  }

  inline MaxAccum<uint64_t> addUintMaxAccum(MaxAccum<uint64_t> accum) {
    accum += 100;
    return accum;
  }

  inline MaxAccum<int> addIntMaxAccum(MaxAccum<int> accum) {
    accum += 100;
    return accum;
  }

  inline MaxAccum<float> addFloatMaxAccum(MaxAccum<float> accum) {
    accum += 100.0;
    return accum;
  }

  inline MaxAccum<double> addDoubleMaxAccum(MaxAccum<double> accum) {
    accum += 100.0;
    return accum;
  }

  inline MaxAccum<VERTEX> addVertexMaxAccum(MaxAccum<VERTEX> accum, VERTEX v) {
    accum += v;
    return accum;
  }

  inline int getId (const VERTEX vertex) {
    return vertex.vid;
  }

  /****** BIULT-IN FUNCTIONS **************/
  /****** XXX DON'T REMOVE ****************/
  inline int str_to_int (string str) {
    return atoi(str.c_str());
  }

  inline int float_to_int (float val) {
    return (int) val;
  }

  inline string to_string (double val) {
    char result[200];
    sprintf(result, "%g", val);
    return string(result);
  }
}
/****************************************/

#endif /* EXPRFUNCTIONS_HPP_ */

