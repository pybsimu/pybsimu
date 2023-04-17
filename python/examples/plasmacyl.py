from pybsimu import \
    Geometry, \
    Bound, \
    FuncSolid, \
    EpotField, \
    EpotEfield, \
    MeshScalarField, \
    MeshVectorField, \
    Int3D, \
    Vec3D, \
    EpotBiCGSTABSolver, \
    ParticleDataBaseCyl, \
    GTKPlotter, \
    InitialPlasma, \
    ibsimu, \
    AXIS_X, \
    FIELD_EXTRAPOLATE, \
    FIELD_SYMMETRIC_POTENTIAL, \
    BOUND_DIRICHLET, \
    BOUND_NEUMANN, \
    MODE_CYL, \
    MSG_VERBOSE, \
    funcsolid_callback

import sys

Te = 5.0
Up = 5.0

@funcsolid_callback
def solid1(x, y, z):
    return( x <= 0.00187 and y >= 0.00054 and y >= 2.28*x - 0.0010 and
            (x >= 0.00054 or y >= 0.0015) )

@funcsolid_callback
def solid2(x, y, z):
    return( x >= 0.0095 and y >= 0.0023333 and y >= 0.01283 - x )


def simulate():

    geom = Geometry(MODE_CYL, Int3D(241,141,1), Vec3D(0,0,0), 0.00005)
    s1 = FuncSolid( solid1 )
    geom.set_solid( 7, s1 )
    s2 = FuncSolid( solid2 )
    geom.set_solid( 8, s2 )

    geom.set_boundary( 1, Bound(BOUND_NEUMANN,    0.0 )   )
    geom.set_boundary( 2, Bound(BOUND_DIRICHLET, -12.0e3) )
    geom.set_boundary( 3, Bound(BOUND_NEUMANN,    0.0)    )
    geom.set_boundary( 4, Bound(BOUND_NEUMANN,    0.0)    )
    geom.set_boundary( 7, Bound(BOUND_DIRICHLET,  0.0)    )
    geom.set_boundary( 8, Bound(BOUND_DIRICHLET, -12.0e3) )
    geom.build_mesh()

    solver = EpotBiCGSTABSolver(geom)
    initp = InitialPlasma(AXIS_X, 0.55e-3)
    solver.set_initial_plasma(5.0, initp)

    epot = EpotField(geom)
    scharge = MeshScalarField (geom)
    bfield = MeshVectorField() 
    efield = EpotEfield(epot)

    efield.set_extrapolation(
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE, 
        FIELD_SYMMETRIC_POTENTIAL, FIELD_EXTRAPOLATE,
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE
    )

    pdb = ParticleDataBaseCyl(geom)
    pdb.set_mirror( 
        False, False, True, False, False, False        
    )

    for i in range(15):

        if i == 1 :
            rhoe = pdb.get_rhosum()
            solver.set_pexp_plasma( -rhoe, Te, Up )

        solver.solve( epot, scharge )
        efield.recalculate()

        pdb.clear()
        pdb.add_2d_beam_with_energy(
            15000,
            600.0,
            1.0,
            4.0,
            5.0,
            0.0,
            0.5,    
            0.0,
            0.0, 
            0.0,
            0.0015
        )
        
        pdb.iterate_trajectories( scharge, efield, bfield )    

    argc = len(sys.argv)    
    plotter = GTKPlotter(argc, sys.argv)
    plotter.set_geometry(geom)
    plotter.set_epot(epot)
    plotter.set_scharge(scharge)
    plotter.set_particledatabase(pdb)
    plotter.new_geometry_plot_window()
    plotter.run()


def plasymacyl():
    ibsimu.set_message_threshold(MSG_VERBOSE, 1)
    ibsimu.set_thread_count(4)
    simulate()

if __name__ == '__main__':
    plasymacyl()