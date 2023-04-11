%module pybsimu

// # /usr/bin/swig3.0 -c++ -python -o ibsimu_wrap.cxx -I/home/ubuntu/include/ibsimu-1.0.6dev ibsimu.i 

%rename(__str__) operator<<;
%rename(__getitem__) STLFile::Triangle::operator[];
%rename(copy) MeshVectorField::operator=;
%rename(assign) ParticleDataBase::operator=;
%rename(assign) ParticleDataBase2D::operator=;
%rename(assign) ParticleDataBaseCyl::operator=;
%rename(assign) ParticleDataBase3D::operator=;
%rename(assign) Vec3D::operator=;
%rename(assign) Int3D::operator=;

// This is in the header but no implementation, not sure what's up with that
%ignore Geometry::get_boundaries;
%ignore STLFile::STLFile(const std::vector<Vec3D>&, const std::vector<VTriangle>&);
%ignore IBSimu::halt;
%ignore coordinate_axis_string;
%ignore coordinate_axis_string_with_unit;
%ignore trajectory_diagnostic_string;
%ignore trajectory_diagnostic_string_with_unit;
%ignore trajectory_diagnostic_string_unit;

%ignore Vec3D::operator[];
%ignore Int3D::operator[];

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
%}

class Vec3D {
public:
    %extend {
        double x() {
            return $self->operator[](0);
        }
        double y() {
            return $self->operator[](1);
        }
        double z() {
            return $self->operator[](2);
        }
    }
};

class Int3D {
public:
    %extend {
        double x() {
            return $self->operator[](0);
        }
        double y() {
            return $self->operator[](1);
        }
        double z() {
            return $self->operator[](2);
        }
    }
};


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
%include "epot_efield.hpp"
%include "meshvectorfield.hpp"
%include "particledatabase.hpp"
%include "plotter.hpp"
%include "geomplot.hpp"
%include "geomplotter.hpp"
%include "types.hpp"
%include "vec3d.hpp"
%include "scalarfield.hpp"
%include "meshscalarfield.hpp"
%include "epot_field.hpp"