#ifndef RTAPI_MATH_H
#define RTAPI_MATH_H

#ifdef RTAPI
extern double sin(double);
extern double cos(double);
extern double sqrt(double);
extern double fabs(double);
extern double atan2(double, double);
extern double acos(double);
extern double pow(double, double);

#define M_PIl		3.1415926535897932384626433832795029L  /* pi */

#ifdef __i386__
#include "rtapi_math_i386.h"
#endif

#else
#include <math.h>
#endif

#endif
