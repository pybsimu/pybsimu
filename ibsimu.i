%module ibsimu

// # /usr/bin/swig3.0 -c++ -python -o ibsimu_wrap.cxx -I/home/ubuntu/include/ibsimu-1.0.6dev ibsimu.i 

%rename(__str__) operator<<;
%rename(__getitem__) STLFile::Triangle::operator[];
%rename(copy) MeshVectorField::operator=;
%rename(assign) ParticleDataBase::operator=;
%rename(assign) ParticleDataBase2D::operator=;
%rename(assign) ParticleDataBaseCyl::operator=;
%rename(assign) ParticleDataBase3D::operator=;

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
#include "meshvectorvield.hpp"
#include "particledatabase.hpp"
#include "plotter.hpp"
#include "geomplot.hpp"
#include "geomplotter.hpp"
%}

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