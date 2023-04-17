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
    ParticleDataBase2D, \
    GeomPlotter, \
    ibsimu, \
    FIELD_EXTRAPOLATE, \
    FIELD_SYMMETRIC_POTENTIAL, \
    BOUND_DIRICHLET, \
    BOUND_NEUMANN, \
    MODE_2D, \
    MSG_VERBOSE, \
    RAPPER, \
    bddd


def solid1(x, y, z):
    print('in solid 1')
    return( x <= 0.02 and y >= 0.018 )


def solid2(x, y, z ):
    return( x >= 0.03 and x <= 0.04 and y >= 0.02 )


def solid3( x, y, z ):
    return( x >= 0.06 and y >= 0.03 and y >= 0.07 - 0.5*x )


def simulate():

    geom = Geometry ( MODE_2D, Int3D(241,101,1), Vec3D(0,0,0), 0.0005 )

    print('making zz')
    zz = RAPPER(solid1, 7)
    zz8 = RAPPER(solid2, 8)
    zz9 = RAPPER(solid3, 9)

    print(f'zz: {zz}')
    print(f'repr(zz): {repr(zz)}')

    s1 = FuncSolid( bddd(7) )
    geom.set_solid( 7, s1 )
    s2 = FuncSolid( bddd(8) )
    geom.set_solid( 8, s2 )
    s3 = FuncSolid( bddd(9) )
    geom.set_solid( 9, s3 )
    
    geom.set_boundary( 1, Bound(BOUND_DIRICHLET,  -3.0e3) )
    geom.set_boundary( 2, Bound(BOUND_DIRICHLET,  -1.0e3) )
    geom.set_boundary( 3, Bound(BOUND_NEUMANN,     0.0  ) )
    geom.set_boundary( 4, Bound(BOUND_NEUMANN,     0.0  ) )
    geom.set_boundary( 7, Bound(BOUND_DIRICHLET,  -3.0e3) )
    geom.set_boundary( 8, Bound(BOUND_DIRICHLET, -14.0e3) )
    geom.set_boundary( 9, Bound(BOUND_DIRICHLET,  -1.0e3) )
    geom.build_mesh()

    epot = EpotField(geom)
    scharge = MeshScalarField (geom)
    bfield = MeshVectorField() 
    efield = EpotEfield(epot)
 
    efield.set_extrapolation(
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE, 
        FIELD_SYMMETRIC_POTENTIAL, FIELD_EXTRAPOLATE,
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE 
    )

    solver = EpotBiCGSTABSolver(geom)

    pdb = ParticleDataBase2D(geom)

    pdb.set_mirror( 
        False, False, True, False, False, False
     )

    for i in range(5):
        solver.solve(epot, scharge)
        efield.recalculate()
        pdb.clear()
        pdb.add_2d_beam_with_energy( 
            1000, 
            50.0, 
            1.0, 
            1.0, 
            3.0e3,
            0.0,
            0.0, 
            0.0,
            0.0, 
            0.0,
            0.012 
        )
        pdb.iterate_trajectories( scharge, efield, bfield )

    geomplotter = GeomPlotter(geom)
    geomplotter.set_size(750, 750)
    geomplotter.set_epot(epot)
    geomplotter.set_particle_database(pdb)
    geomplotter.plot_png(str("plot1.png"))

def vlasov2d():
    ibsimu.set_message_threshold(MSG_VERBOSE, 1)
    ibsimu.set_thread_count(4)
    simulate()
    

if __name__ == '__main__':
    vlasov2d()