"""This is the pybsimu version of the simulation portion of the example at this link:

https://ibsimu.sourceforge.net/examples/radis/index.html

"""
from pybsimu import \
    Geometry, \
    Bound, \
    EpotField, \
    EpotEfield, \
    MeshScalarField, \
    MeshVectorField, \
    Int3D, \
    Vec3D, \
    EpotBiCGSTABSolver, \
    ParticleDataBase3D, \
    InitialPlasma, \
    Transformation, \
    CallbackFunctorB_V, \
    STLFile, \
    STLSolid, \
    NPlasmaBfieldSuppression, \
    ibsimu, \
    AXIS_Z, \
    FIELD_EXTRAPOLATE, \
    FIELD_ZERO, \
    BOUND_DIRICHLET, \
    BOUND_NEUMANN, \
    MODE_3D, \
    MSG_VERBOSE

import math

bfieldfn = "examples/radis/Radis_final.dat"

Vbias = 19.0e3
Vpuller = 10.0e3
Vdump = 6.0e3
Veinzel = 20e3

class ForcedPot(CallbackFunctorB_V):
    def __init__(self):        
        super().__init__()

    def call(self, v: Vec3D):
        return (v.z() < 0.2e-3) and (v.x()*v.x()+v.y()*v.y() > 6e-3*6e-3)

def simulate():
    start = -3.0e-3
    h = 0.4e-3
    #h = 2e-3
    sizereq = [
        50.0e-3,
        50.0e-3, 
        125.0e-3-start
    ]
    meshsize = Int3D(
        int(math.floor(sizereq[0]/h)+1),
        int(math.floor(sizereq[1]/h)+1),
        int(math.floor(sizereq[2]/h)+1)
    )
    origo = Vec3D(-25.0e-3, -25.0e-3, start)
    geom = Geometry(MODE_3D, meshsize, origo, h)

    dx = 0.00405834+0.00505786
    dy = -0.00808772+0.0140138
    angle = math.atan2( dx, dy ) + 0.5*math.pi
    print(f"angle = {angle}")
    t = Transformation()
    t.translate( Vec3D( 0, -197, 0 ) )
    t.scale( Vec3D( 1.0e-3, -1.0e-3, 1.0e-3 ) )
    t.rotate_x( 0.5*math.pi )
    t.translate( Vec3D( 0, 0, h/50.0 ) )
    t.rotate_z( angle )

    fplasma = STLFile("examples/radis/plasma.stl")
    fpuller = STLFile("examples/radis/puller.stl")
    fedump = STLFile("examples/radis/edump.stl")
    fedump2 = STLFile("examples/radis/edump2.stl")
    fmaa1a = STLFile("examples/radis/maa1a.stl")
    fmaa1b = STLFile("examples/radis/maa1b.stl")
    fmaa2a = STLFile("examples/radis/maa2a.stl")
    fmaa2b = STLFile("examples/radis/maa2b.stl")
    feinzela = STLFile("examples/radis/einzela.stl")
    feinzelb = STLFile("examples/radis/einzelb.stl")

    plasma = STLSolid()
    plasma.set_transformation(t)
    plasma.add_stl_file(fplasma)
    geom.set_solid(7, plasma)

    puller = STLSolid()
    puller.set_transformation(t)
    puller.add_stl_file(fpuller)
    geom.set_solid(8, puller)

    edump = STLSolid()
    edump.set_transformation(t)
    edump.add_stl_file(fedump)
    edump.add_stl_file(fedump2)
    geom.set_solid(9, edump)

    maa1 = STLSolid()
    maa1.set_transformation(t)
    maa1.add_stl_file(fmaa1a)
    maa1.add_stl_file(fmaa1b)
    geom.set_solid(10, maa1)

    einzel = STLSolid()
    einzel.set_transformation(t)
    einzel.add_stl_file(feinzela)
    einzel.add_stl_file(feinzelb)
    geom.set_solid(11, einzel)

    maa2 = STLSolid()
    maa2.set_transformation(t)
    maa2.add_stl_file(fmaa2a)
    maa2.add_stl_file(fmaa2b)
    geom.set_solid(12, maa2)

    geom.set_boundary(  1,  Bound(BOUND_NEUMANN,     0.0) )
    geom.set_boundary(  2,  Bound(BOUND_NEUMANN,     0.0) )
    geom.set_boundary(  3,  Bound(BOUND_NEUMANN,     0.0) )
    geom.set_boundary(  4,  Bound(BOUND_NEUMANN,     0.0) )
    geom.set_boundary(  5,  Bound(BOUND_DIRICHLET,   0.0) )
    geom.set_boundary(  6,  Bound(BOUND_DIRICHLET,   Vbias) )

    geom.set_boundary(  7,  Bound(BOUND_DIRICHLET,   0.0) )
    geom.set_boundary(  8,  Bound(BOUND_DIRICHLET,   Vpuller) )
    geom.set_boundary(  9,  Bound(BOUND_DIRICHLET,   Vdump) )

    geom.set_boundary( 10,  Bound(BOUND_DIRICHLET,   Vbias) )
    geom.set_boundary( 11,  Bound(BOUND_DIRICHLET,   (Vbias+Veinzel)) )
    geom.set_boundary( 12,  Bound(BOUND_DIRICHLET,   Vbias) )
    geom.build_mesh()
    geom.build_surface()

    solver = EpotBiCGSTABSolver(geom)
    initp = InitialPlasma(AXIS_Z, 0.2e-3)
    solver.set_nsimp_initial_plasma(initp)
    force = ForcedPot()
    solver.set_forced_potential_volume(0.0, force)
    solver.set_gnewton(True)

    epot = EpotField(geom)
    scharge = MeshScalarField(geom)
    scharge_ave = MeshScalarField(geom)

    fout = [True, True, True]
    bfield = MeshVectorField(MODE_3D, fout, 1.0e-3, 1.0, bfieldfn)
    bfldextrpl = [
        FIELD_ZERO, FIELD_ZERO, 
        FIELD_ZERO, FIELD_ZERO, 
        FIELD_ZERO, FIELD_ZERO 
    ]
    bfield.set_extrapolation( bfldextrpl )

    efield = EpotEfield (epot)
    efldextrpl = [
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE, 
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE, 
        FIELD_EXTRAPOLATE, FIELD_EXTRAPOLATE
    ]
    efield.set_extrapolation(efldextrpl)

    pdb = ParticleDataBase3D(geom)
    pdb.set_max_steps(1000)
    pmirror = [
        False, False, False, False, False, False
    ]
    pdb.set_mirror( pmirror )

    # Suppress effects of magnetic field at volume where phi<1000. This is needed
    # because of erroneous field values close to the plasma electrode magnetic
    # steel (bug in Radia-3D).
    psup = NPlasmaBfieldSuppression(epot, 1000.0)
    pdb.set_bfield_suppression(psup)

    rho_h = 0.0
    rho_tot = 0.0

    for i in range(15):
        if i == 1:            
            Ei = [2.0]            
            rhoi = [0.5*rho_h]
            rhop = rho_tot - rho_h*0.5
            solver.set_nsimp_plasma( rhop, 10.0, rhoi, Ei )
            
        solver.solve( epot, scharge_ave )
        efield.recalculate()

        J = 35.0
        pdb.clear(); 
        pdb.add_cylindrical_beam_with_energy(
            50000,
            J,
            -1.0,
            1.0, 
            2.0,
            0.0,
            1.0, 
            Vec3D(0,0,start),
            Vec3D(1,0,0), 
            Vec3D(0,1,0),
            8e-3
        )
        rho_h = pdb.get_rhosum()
        pdb.add_cylindrical_beam_with_energy(
            50000,
            J*100.0,
            -1.0,
            1.0/1836.15, 
            2.0,
            0.0,
            1.0, 
            Vec3D(0,0,start),
            Vec3D(1,0,0), 
            Vec3D(0,1,0),
            8e-3
        )
        pdb.iterate_trajectories( scharge, efield, bfield )
        rho_tot = pdb.get_rhosum()

        # Space charge averaging
        if i == 0:
            scharge_ave = scharge
        else:
            coef = 0.3
            scharge *= coef
            scharge_ave += scharge
            scharge_ave *= (1.0/(1.0+coef))
    
    geom.save("geom.dat")
    epot.save("epot.dat")
    pdb.save("pdb.dat")   


def radis():
    ibsimu.set_message_threshold(MSG_VERBOSE, 1)
    ibsimu.set_thread_count(4)
    simulate()

if __name__ == '__main__':
    try:
        radis()
    except Exception as e:
        print('exception: ')
        print(e)