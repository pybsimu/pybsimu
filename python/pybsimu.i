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
#include "gtkplotter.hpp"
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

%include "typemaps.i"
%typemap(in) int * ($*1_type temp1) {
    temp1 = PyInt_AsLong($input);
    $1 = &temp1;
}
%typemap(in) char *** ($*1_type temp1) {
    $1 = &temp1;
}

%include "gtkplotter.hpp"

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

%feature("director") op_bool_double_double_double;

%inline %{

// If you bump this number up, you'll 
// also need to create the additional functions to go along with the larger
// number (sorry!)
static const int MAX_BDDDPTR = 100;

typedef bool(*bdddptr)(double, double, double);

std::vector<bdddptr> fptr_bddd;
std::vector<std::function<bool(double,double,double)>> functor_bddd;

bool __bddd_0(double x, double y, double z){return functor_bddd[0](x,y,z);}
bool __bddd_1(double x, double y, double z){return functor_bddd[1](x,y,z);}
bool __bddd_2(double x, double y, double z){return functor_bddd[2](x,y,z);}
bool __bddd_3(double x, double y, double z){return functor_bddd[3](x,y,z);}
bool __bddd_4(double x, double y, double z){return functor_bddd[4](x,y,z);}
bool __bddd_5(double x, double y, double z){return functor_bddd[5](x,y,z);}
bool __bddd_6(double x, double y, double z){return functor_bddd[6](x,y,z);}
bool __bddd_7(double x, double y, double z){return functor_bddd[7](x,y,z);}
bool __bddd_8(double x, double y, double z){return functor_bddd[8](x,y,z);}
bool __bddd_9(double x, double y, double z){return functor_bddd[9](x,y,z);}
bool __bddd_10(double x, double y, double z){return functor_bddd[10](x,y,z);}
bool __bddd_11(double x, double y, double z){return functor_bddd[11](x,y,z);}
bool __bddd_12(double x, double y, double z){return functor_bddd[12](x,y,z);}
bool __bddd_13(double x, double y, double z){return functor_bddd[13](x,y,z);}
bool __bddd_14(double x, double y, double z){return functor_bddd[14](x,y,z);}
bool __bddd_15(double x, double y, double z){return functor_bddd[15](x,y,z);}
bool __bddd_16(double x, double y, double z){return functor_bddd[16](x,y,z);}
bool __bddd_17(double x, double y, double z){return functor_bddd[17](x,y,z);}
bool __bddd_18(double x, double y, double z){return functor_bddd[18](x,y,z);}
bool __bddd_19(double x, double y, double z){return functor_bddd[19](x,y,z);}
bool __bddd_20(double x, double y, double z){return functor_bddd[20](x,y,z);}
bool __bddd_21(double x, double y, double z){return functor_bddd[21](x,y,z);}
bool __bddd_22(double x, double y, double z){return functor_bddd[22](x,y,z);}
bool __bddd_23(double x, double y, double z){return functor_bddd[23](x,y,z);}
bool __bddd_24(double x, double y, double z){return functor_bddd[24](x,y,z);}
bool __bddd_25(double x, double y, double z){return functor_bddd[25](x,y,z);}
bool __bddd_26(double x, double y, double z){return functor_bddd[26](x,y,z);}
bool __bddd_27(double x, double y, double z){return functor_bddd[27](x,y,z);}
bool __bddd_28(double x, double y, double z){return functor_bddd[28](x,y,z);}
bool __bddd_29(double x, double y, double z){return functor_bddd[29](x,y,z);}
bool __bddd_30(double x, double y, double z){return functor_bddd[30](x,y,z);}
bool __bddd_31(double x, double y, double z){return functor_bddd[31](x,y,z);}
bool __bddd_32(double x, double y, double z){return functor_bddd[32](x,y,z);}
bool __bddd_33(double x, double y, double z){return functor_bddd[33](x,y,z);}
bool __bddd_34(double x, double y, double z){return functor_bddd[34](x,y,z);}
bool __bddd_35(double x, double y, double z){return functor_bddd[35](x,y,z);}
bool __bddd_36(double x, double y, double z){return functor_bddd[36](x,y,z);}
bool __bddd_37(double x, double y, double z){return functor_bddd[37](x,y,z);}
bool __bddd_38(double x, double y, double z){return functor_bddd[38](x,y,z);}
bool __bddd_39(double x, double y, double z){return functor_bddd[39](x,y,z);}
bool __bddd_40(double x, double y, double z){return functor_bddd[40](x,y,z);}
bool __bddd_41(double x, double y, double z){return functor_bddd[41](x,y,z);}
bool __bddd_42(double x, double y, double z){return functor_bddd[42](x,y,z);}
bool __bddd_43(double x, double y, double z){return functor_bddd[43](x,y,z);}
bool __bddd_44(double x, double y, double z){return functor_bddd[44](x,y,z);}
bool __bddd_45(double x, double y, double z){return functor_bddd[45](x,y,z);}
bool __bddd_46(double x, double y, double z){return functor_bddd[46](x,y,z);}
bool __bddd_47(double x, double y, double z){return functor_bddd[47](x,y,z);}
bool __bddd_48(double x, double y, double z){return functor_bddd[48](x,y,z);}
bool __bddd_49(double x, double y, double z){return functor_bddd[49](x,y,z);}
bool __bddd_50(double x, double y, double z){return functor_bddd[50](x,y,z);}
bool __bddd_51(double x, double y, double z){return functor_bddd[51](x,y,z);}
bool __bddd_52(double x, double y, double z){return functor_bddd[52](x,y,z);}
bool __bddd_53(double x, double y, double z){return functor_bddd[53](x,y,z);}
bool __bddd_54(double x, double y, double z){return functor_bddd[54](x,y,z);}
bool __bddd_55(double x, double y, double z){return functor_bddd[55](x,y,z);}
bool __bddd_56(double x, double y, double z){return functor_bddd[56](x,y,z);}
bool __bddd_57(double x, double y, double z){return functor_bddd[57](x,y,z);}
bool __bddd_58(double x, double y, double z){return functor_bddd[58](x,y,z);}
bool __bddd_59(double x, double y, double z){return functor_bddd[59](x,y,z);}
bool __bddd_60(double x, double y, double z){return functor_bddd[60](x,y,z);}
bool __bddd_61(double x, double y, double z){return functor_bddd[61](x,y,z);}
bool __bddd_62(double x, double y, double z){return functor_bddd[62](x,y,z);}
bool __bddd_63(double x, double y, double z){return functor_bddd[63](x,y,z);}
bool __bddd_64(double x, double y, double z){return functor_bddd[64](x,y,z);}
bool __bddd_65(double x, double y, double z){return functor_bddd[65](x,y,z);}
bool __bddd_66(double x, double y, double z){return functor_bddd[66](x,y,z);}
bool __bddd_67(double x, double y, double z){return functor_bddd[67](x,y,z);}
bool __bddd_68(double x, double y, double z){return functor_bddd[68](x,y,z);}
bool __bddd_69(double x, double y, double z){return functor_bddd[69](x,y,z);}
bool __bddd_70(double x, double y, double z){return functor_bddd[70](x,y,z);}
bool __bddd_71(double x, double y, double z){return functor_bddd[71](x,y,z);}
bool __bddd_72(double x, double y, double z){return functor_bddd[72](x,y,z);}
bool __bddd_73(double x, double y, double z){return functor_bddd[73](x,y,z);}
bool __bddd_74(double x, double y, double z){return functor_bddd[74](x,y,z);}
bool __bddd_75(double x, double y, double z){return functor_bddd[75](x,y,z);}
bool __bddd_76(double x, double y, double z){return functor_bddd[76](x,y,z);}
bool __bddd_77(double x, double y, double z){return functor_bddd[77](x,y,z);}
bool __bddd_78(double x, double y, double z){return functor_bddd[78](x,y,z);}
bool __bddd_79(double x, double y, double z){return functor_bddd[79](x,y,z);}
bool __bddd_80(double x, double y, double z){return functor_bddd[80](x,y,z);}
bool __bddd_81(double x, double y, double z){return functor_bddd[81](x,y,z);}
bool __bddd_82(double x, double y, double z){return functor_bddd[82](x,y,z);}
bool __bddd_83(double x, double y, double z){return functor_bddd[83](x,y,z);}
bool __bddd_84(double x, double y, double z){return functor_bddd[84](x,y,z);}
bool __bddd_85(double x, double y, double z){return functor_bddd[85](x,y,z);}
bool __bddd_86(double x, double y, double z){return functor_bddd[86](x,y,z);}
bool __bddd_87(double x, double y, double z){return functor_bddd[87](x,y,z);}
bool __bddd_88(double x, double y, double z){return functor_bddd[88](x,y,z);}
bool __bddd_89(double x, double y, double z){return functor_bddd[89](x,y,z);}
bool __bddd_90(double x, double y, double z){return functor_bddd[90](x,y,z);}
bool __bddd_91(double x, double y, double z){return functor_bddd[91](x,y,z);}
bool __bddd_92(double x, double y, double z){return functor_bddd[92](x,y,z);}
bool __bddd_93(double x, double y, double z){return functor_bddd[93](x,y,z);}
bool __bddd_94(double x, double y, double z){return functor_bddd[94](x,y,z);}
bool __bddd_95(double x, double y, double z){return functor_bddd[95](x,y,z);}
bool __bddd_96(double x, double y, double z){return functor_bddd[96](x,y,z);}
bool __bddd_97(double x, double y, double z){return functor_bddd[97](x,y,z);}
bool __bddd_98(double x, double y, double z){return functor_bddd[98](x,y,z);}
bool __bddd_99(double x, double y, double z){return functor_bddd[99](x,y,z);}

void init_fptr_bddd_lookups() {
    fptr_bddd.resize(MAX_BDDDPTR);
    fptr_bddd[0] = &__bddd_0;
    fptr_bddd[1] = &__bddd_1;
    fptr_bddd[2] = &__bddd_2;
    fptr_bddd[3] = &__bddd_3;
    fptr_bddd[4] = &__bddd_4;
    fptr_bddd[5] = &__bddd_5;
    fptr_bddd[6] = &__bddd_6;
    fptr_bddd[7] = &__bddd_7;
    fptr_bddd[8] = &__bddd_8;
    fptr_bddd[9] = &__bddd_9;
    fptr_bddd[10] = &__bddd_10;
    fptr_bddd[11] = &__bddd_11;
    fptr_bddd[12] = &__bddd_12;
    fptr_bddd[13] = &__bddd_13;
    fptr_bddd[14] = &__bddd_14;
    fptr_bddd[15] = &__bddd_15;
    fptr_bddd[16] = &__bddd_16;
    fptr_bddd[17] = &__bddd_17;
    fptr_bddd[18] = &__bddd_18;
    fptr_bddd[19] = &__bddd_19;
    fptr_bddd[20] = &__bddd_20;
    fptr_bddd[21] = &__bddd_21;
    fptr_bddd[22] = &__bddd_22;
    fptr_bddd[23] = &__bddd_23;
    fptr_bddd[24] = &__bddd_24;
    fptr_bddd[25] = &__bddd_25;
    fptr_bddd[26] = &__bddd_26;
    fptr_bddd[27] = &__bddd_27;
    fptr_bddd[28] = &__bddd_28;
    fptr_bddd[29] = &__bddd_29;
    fptr_bddd[30] = &__bddd_30;
    fptr_bddd[31] = &__bddd_31;
    fptr_bddd[32] = &__bddd_32;
    fptr_bddd[33] = &__bddd_33;
    fptr_bddd[34] = &__bddd_34;
    fptr_bddd[35] = &__bddd_35;
    fptr_bddd[36] = &__bddd_36;
    fptr_bddd[37] = &__bddd_37;
    fptr_bddd[38] = &__bddd_38;
    fptr_bddd[39] = &__bddd_39;
    fptr_bddd[40] = &__bddd_40;
    fptr_bddd[41] = &__bddd_41;
    fptr_bddd[42] = &__bddd_42;
    fptr_bddd[43] = &__bddd_43;
    fptr_bddd[44] = &__bddd_44;
    fptr_bddd[45] = &__bddd_45;
    fptr_bddd[46] = &__bddd_46;
    fptr_bddd[47] = &__bddd_47;
    fptr_bddd[48] = &__bddd_48;
    fptr_bddd[49] = &__bddd_49;
    fptr_bddd[50] = &__bddd_50;
    fptr_bddd[51] = &__bddd_51;
    fptr_bddd[52] = &__bddd_52;
    fptr_bddd[53] = &__bddd_53;
    fptr_bddd[54] = &__bddd_54;
    fptr_bddd[55] = &__bddd_55;
    fptr_bddd[56] = &__bddd_56;
    fptr_bddd[57] = &__bddd_57;
    fptr_bddd[58] = &__bddd_58;
    fptr_bddd[59] = &__bddd_59;
    fptr_bddd[60] = &__bddd_60;
    fptr_bddd[61] = &__bddd_61;
    fptr_bddd[62] = &__bddd_62;
    fptr_bddd[63] = &__bddd_63;
    fptr_bddd[64] = &__bddd_64;
    fptr_bddd[65] = &__bddd_65;
    fptr_bddd[66] = &__bddd_66;
    fptr_bddd[67] = &__bddd_67;
    fptr_bddd[68] = &__bddd_68;
    fptr_bddd[69] = &__bddd_69;
    fptr_bddd[70] = &__bddd_70;
    fptr_bddd[71] = &__bddd_71;
    fptr_bddd[72] = &__bddd_72;
    fptr_bddd[73] = &__bddd_73;
    fptr_bddd[74] = &__bddd_74;
    fptr_bddd[75] = &__bddd_75;
    fptr_bddd[76] = &__bddd_76;
    fptr_bddd[77] = &__bddd_77;
    fptr_bddd[78] = &__bddd_78;
    fptr_bddd[79] = &__bddd_79;
    fptr_bddd[80] = &__bddd_80;
    fptr_bddd[81] = &__bddd_81;
    fptr_bddd[82] = &__bddd_82;
    fptr_bddd[83] = &__bddd_83;
    fptr_bddd[84] = &__bddd_84;
    fptr_bddd[85] = &__bddd_85;
    fptr_bddd[86] = &__bddd_86;
    fptr_bddd[87] = &__bddd_87;
    fptr_bddd[88] = &__bddd_88;
    fptr_bddd[89] = &__bddd_89;
    fptr_bddd[90] = &__bddd_90;
    fptr_bddd[91] = &__bddd_91;
    fptr_bddd[92] = &__bddd_92;
    fptr_bddd[93] = &__bddd_93;
    fptr_bddd[94] = &__bddd_94;
    fptr_bddd[95] = &__bddd_95;
    fptr_bddd[96] = &__bddd_96;
    fptr_bddd[97] = &__bddd_97;
    fptr_bddd[98] = &__bddd_98;
    fptr_bddd[99] = &__bddd_99;    
}

bdddptr get_fptr_bddd(int k) {
    return fptr_bddd[k];
}

struct op_bool_double_double_double {
    void initialize_fptr_lookup(int id) {
        // It's not ideal but doesn't hurt to do this init every time.
        init_fptr_bddd_lookups();
        functor_bddd.resize(MAX_BDDDPTR);
        // This sets up the functor to call our handle(x,y,z), which
        // will be overridden in python class CallbackWrapper, which
        // will then delegate it off to a python function.
        functor_bddd[id] = std::bind(&op_bool_double_double_double::handle, this, 
            std::placeholders::_1, 
            std::placeholders::_2, 
            std::placeholders::_3
        );
    }
    // This will get overridden in python class CallbackWrapper.
    virtual bool handle(double x, double y, double z) = 0;
    // Virtual destructor just because.
    virtual ~op_bool_double_double_double() {}
};

%}

%pythoncode
%{

# module global state
next_fptr_index = 0
callback_wrappers = {}

# decorator for FuncSolid callbacks
#
# Used like:
# @funcsolid_callback
# def my_solid(x, y,z):
#     return(x<=0.01 and y>=0.01 and z<=0.01)
#
# ... then, later ...
# s1 = FuncSolid(my_solid)
def funcsolid_callback(f):
    # We will create and store the callback wrapper.
    global next_fptr_index
    global callback_wrappers
    fptr_index = next_fptr_index
    if fptr_index >= MAX_BDDDPTR:
        raise IndexError(f'Exceeded MAX_BDDDPTR={MAX_BDDPTR}')
    next_fptr_index = next_fptr_index + 1
    callback_wrappers[fptr_index] = CallbackWrapper(f, fptr_index)
    # What we are returning is the C function pointer,
    # this is what gets passed to ibsimu FuncSolid constructor.
    return get_fptr_bddd(fptr_index)

class CallbackWrapper(op_bool_double_double_double):

    def __init__(self, callback, id):
        op_bool_double_double_double.__init__(self)
        self._callback = callback
        self.initialize_fptr_lookup(id)
                 
    def handle(self, x, y, z):
        return self._callback(x, y, z)

%}
