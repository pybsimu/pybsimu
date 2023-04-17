%module(directors="1") pybsimu

// # /usr/bin/swig3.0 -c++ -python -o ibsimu_wrap.cxx -I/home/ubuntu/include/ibsimu-1.0.6dev ibsimu.i 

%rename(__str__) operator<<;
%rename(__getitem__) STLFile::Triangle::operator[];
%rename(copy) MeshScalarField::operator=;
%rename(copy) MeshVectorField::operator=;
%rename(assign) ParticleDataBase::operator=;
%rename(assign) ParticleDataBase2D::operator=;
%rename(assign) ParticleDataBaseCyl::operator=;
%rename(assign) ParticleDataBase3D::operator=;
%rename(assign) Vec3D::operator=;
%rename(assign) Int3D::operator=;
%rename(times) operator*(double, const Vec3D&);
%rename(times) operator*(double, const class Int3D&);
%rename(times) operator*(double, const Int3D&);
%rename(times) operator*(int, const Int3D&);
%rename(times) Int3D::operator*;

// These are in the header but no implementation, not sure what's up with that
%ignore Geometry::get_boundaries;
%ignore STLFile::STLFile(const std::vector<Vec3D>&, const std::vector<VTriangle>&);
%ignore IBSimu::halt;
%ignore coordinate_axis_string;
%ignore coordinate_axis_string_with_unit;
%ignore trajectory_diagnostic_string;
%ignore trajectory_diagnostic_string_with_unit;
%ignore trajectory_diagnostic_string_unit;

// Replacing these with x, y, z, in extend blocks later.
%ignore Vec3D::operator[];
%ignore Int3D::operator[];

%include "std_string.i"

%{
#include "mesh.hpp"
#include "geometry.hpp"
#include "solid.hpp"
#include "func_solid.hpp"
#include "stl_solid.hpp"
#include "stlfile.hpp"
#include "ibsimu.hpp"
#include "error.hpp"
#include "callback.hpp"
#include "epot_solver.hpp"
#include "epot_matrixsolver.hpp"
#include "epot_bicgstabsolver.hpp"
#include "field.hpp"
#include "vectorfield.hpp"
#include "epot_efield.hpp"
#include "meshvectorfield.hpp"
#include "particledatabase.hpp"
#include "plotter.hpp"
#include "geomplot.hpp"
#include "geomplotter.hpp"
#include "types.hpp"
#include "vec3d.hpp"
#include "scalarfield.hpp"
#include "meshscalarfield.hpp"
#include "epot_field.hpp"
#include <functional>
%}

%include "vec3d.hpp"

%extend Vec3D {
    double x() {
        return $self->operator[](0);
    }
    double y() {
        return $self->operator[](1);
    }
    double z() {
        return $self->operator[](2);
    }
};

%extend Int3D {
    double x() {
        return $self->operator[](0);
    }
    double y() {
        return $self->operator[](1);
    }
    double z() {
        return $self->operator[](2);
    }
};

%include "stdint.i"
%include "mesh.hpp"
%include "geometry.hpp"
%include "solid.hpp"
%include "func_solid.hpp"
%include "stl_solid.hpp"
%include "stlfile.hpp"
%include "ibsimu.hpp"
%include "error.hpp"
%include "callback.hpp"
%include "epot_solver.hpp"
%include "epot_matrixsolver.hpp"
%include "epot_bicgstabsolver.hpp"
%include "field.hpp"
%include "vectorfield.hpp"
%include "meshvectorfield.hpp"
%include "particledatabase.hpp"
%include "plotter.hpp"
%include "geomplot.hpp"
%include "geomplotter.hpp"
%include "types.hpp"
%include "scalarfield.hpp"
%include "meshscalarfield.hpp"
%include "epot_field.hpp"
%include "epot_efield.hpp"

%extend EpotEfield {
    void set_extrapolation(PyObject* e1, PyObject* e2, PyObject* e3, PyObject* e4, PyObject* e5, PyObject* e6) {
        field_extrpl_e extrap[6];
        extrap[0] = static_cast<field_extrpl_e>( (int) PyInt_AsLong(e1) );
        extrap[1] = static_cast<field_extrpl_e>( (int) PyInt_AsLong(e2) );
        extrap[2] = static_cast<field_extrpl_e>( (int) PyInt_AsLong(e3) );
        extrap[3] = static_cast<field_extrpl_e>( (int) PyInt_AsLong(e4) );
        extrap[4] = static_cast<field_extrpl_e>( (int) PyInt_AsLong(e5) );
        extrap[5] = static_cast<field_extrpl_e>( (int) PyInt_AsLong(e6) );
        $self->set_extrapolation(extrap);
    }
}

%extend ParticleDataBase {
    void set_mirror(PyObject* b1, PyObject* b2, PyObject* b3, PyObject* b4, PyObject* b5, PyObject* b6) {
        bool b[6];
        b[0] = PyObject_IsTrue(b1);
        b[1] = PyObject_IsTrue(b2);
        b[2] = PyObject_IsTrue(b3);
        b[3] = PyObject_IsTrue(b4);
        b[4] = PyObject_IsTrue(b5);
        b[5] = PyObject_IsTrue(b6);
        $self->set_mirror(b);
    }
}

%{
bool calc_op(double x, double y, double z, bool (*op)(double, double, double)) {
  return op(x, y, z);
}
%}

%feature("director") op_bool_double_double_double;

%inline %{

typedef bool(*bdddptr)(double, double, double);

std::vector<bdddptr> fptr_bddd;
std::vector<std::function<bool(double,double,double)>> functor_bddd;

bool __bddd_0(double x, double y, double z) {
//    std::cout << "in __bddd_0" << std::endl;
//    std::cout << "functor_bdd.size(): " << functor_bddd.size() << std::endl;
    bool result = functor_bddd[0](x, y, z);
    return result;
}

bool __bddd_1(double x, double y, double z) {
    return functor_bddd[1](x, y, z);
}

void init_bddd() {
//    std::cout << "init_bddd" << std::endl;
    fptr_bddd.resize(1000);
    fptr_bddd[0] = &__bddd_0;
    fptr_bddd[1] = &__bddd_1;
}


bdddptr bddd(int k) {
//    std::cout << "fptr_bddd[" << k << "]: " << fptr_bddd[k] << std::endl;
    return fptr_bddd[k];
}

struct op_bool_double_double_double {
    void zzz(int id) {
        init_bddd();
        functor_bddd.resize(1000);
        functor_bddd[id] = std::bind(&op_bool_double_double_double::handle, this, 
            std::placeholders::_1, 
            std::placeholders::_2, 
            std::placeholders::_3
        );
    }    
    virtual bool handle(double x, double y, double z) = 0;
    virtual ~op_bool_double_double_double() {}
};


/*
struct op_bool_double_double_double {
    virtual bool handle(double x, double y, double z) = 0;
    bdddptr get_op() {
        using namespace std::placeholders;
        auto cb = std::bind(&op_bool_double_double_double::handle, this, _1, _2, _3 );
        return static_cast<bdddptr>(cb);
    }
    virtual ~op_bool_double_double_double() {}
};
*/
%}

%pythoncode
%{

from functools import partial

class RAPPER(op_bool_double_double_double):

    def __init__(self, callback, id):
        op_bool_double_double_double.__init__(self)
        self._callback = callback
        self.zzz(0)
                 
    def handle(self, x, y, z):
        #print('in handle')
        return self._callback(x, y, z)

%}

%typemap(in) field_extrpl_e[6] {
  /* Check if is a list */
  if (PyList_Check($input)) {
    int size = PyList_Size($input);
    int i = 0;
    $1 = (char **) malloc((size+1)*sizeof(char *));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($input, i);
      if (PyString_Check(o)) {
        $1[i] = PyString_AsString(PyList_GetItem($input, i));
      } else {
        free($1);
        PyErr_SetString(PyExc_TypeError, "list must contain strings");
        SWIG_fail;
      }
    }
    $1[i] = 0;
  } else {
    PyErr_SetString(PyExc_TypeError, "not a list");
    SWIG_fail;
  }
}

// This cleans up the char ** array we malloc'd before the function call
%typemap(freearg) char ** {
  free((char *) $1);
}

/* 

// a typemap for the callback, it expects the argument to be an integer
// whose value is the address of an appropriate callback function
%typemap(in) bool (*f)(double, double, double) {
    $1 = (bool (*)(double, double, double))PyLong_AsVoidPtr($input);;
}

//%{
//    void use_callback(bool (*f)(double x, double y, double z));
//%}

//%inline
//%{
//
// a C function that accepts a callback
//void use_callback(void (*f)(int i, const char* str))
//{
//    f(100, "callback arg");
//}
//
//%}

%pythoncode
%{

import ctypes

# a ctypes callback prototype
py_callback_type = ctypes.CFUNCTYPE(ctypes.c_bool, ctypes.c_double, ctypes.c_double, ctypes.c_double)

def RAPPER(py_callback):

    # wrap the python callback with a ctypes function pointer
    f = py_callback_type(py_callback)

    # get the function pointer of the ctypes wrapper by casting it to void* and taking its value
    #f_ptr = ctypes.cast(f, ctypes.c_void_p)

    return f

%} */