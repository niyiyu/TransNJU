#!/share/apps/python/python2.7.10/bin/python
from mpi4py import MPI
from os.path import getsize, join
import numpy as np
import scipy.io as scio
import os
import sys

def read_slice(path, parameters, iproc):
    """ Reads SPECFEM model slice(s)
        Such as, for example : proc000005_vp.bin
        In that specific case it would be : read_slice(path, 'vp', 5)
    """
    vals = []
    for key in parameters:
        filename = '%s/proc%06d_%s.bin' % (path, iproc, key)
        vals += [_read(filename)]
    return vals

def _read(filename):
    """ Reads Fortran style binary data into numpy array
    """
    nbytes = getsize(filename)
    with open(filename, 'rb') as file:
        # read size of record
        file.seek(0)
        n = np.fromfile(file, dtype='int32', count=1)[0]
        if n == nbytes-8:
            file.seek(4)
            data = np.fromfile(file, dtype='float32')
            return data[:-1]
        else:
            file.seek(0)
            data = np.fromfile(file, dtype='float32')
            return data

def write_slice(data, path, parameters, iproc):
    """ Writes SPECFEM model slice
    """
    for key in parameters:
        filename = '%s/proc%06d_%s.bin' % (path, iproc, key)
        _write(data, filename)

def _write(v, filename):
    """ Writes Fortran style binary files--data are written as single precision
        floating point numbers
    """
    n = np.array([4*len(v)], dtype='int32')
    v = np.array(v, dtype='float32')

    with open(filename, 'wb') as file:
        n.tofile(file)
        v.tofile(file)
        n.tofile(file)

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()
node_name = MPI.Get_processor_name() # get the name of the node

if rank == 0:
    print("Running at " + str(size) + " nodes.")
    print("Current directory is:" + os.getcwd())
    old_model_dir = './DATABASES_MPI'
    new_model_dir = './TMP_DATABASES_MPI'
    mat_model_file = './model.mat'

    print('Initial model is in:' + old_model_dir)
    print("New model will be in:" + new_model_dir) 
    print("Mat model is in" + mat_model_file)
    sys.stdout.flush()

new_model_dir = comm.bcast(new_model_dir if rank == 0 else None, root=0)
old_model_dir = comm.bcast(old_model_dir if rank == 0 else None, root=0)
mat_model_file = comm.bcast(mat_model_file if rank == 0 else None, root=0)

comm.Barrier()

try:
    z = _read(old_model_dir + '/proc' + str(rank).zfill(6) + '_z.bin')
    y = _read(old_model_dir + '/proc' + str(rank).zfill(6) + '_y.bin')
    x = _read(old_model_dir + '/proc' + str(rank).zfill(6) + '_x.bin')
    vp = _read(old_model_dir + '/proc' + str(rank).zfill(6) + '_vp.bin')
    vs = _read(old_model_dir + '/proc' + str(rank).zfill(6) + '_vs.bin')
    rho = _read(old_model_dir + '/proc' + str(rank).zfill(6) + '_rho.bin')
    with open(old_model_dir + '/proc' + str(rank).zfill(6) + '_ibool.bin', 'rb') as file:
        file.seek(4)
        ibool = np.fromfile(file, dtype='int32')
except:
    MPI.Finalize()
    raise FileNotFoundError


# comm.Barrier()
if rank == 0:
    print("Done reading all initial binary models.")

mat = scio.loadmat(mat_model_file)
vel = mat['vel_pad']
vel = np.require(vel, dtype=np.float32)

# comm.Barrier()
if rank == 0:
    print("Done reading mat model.")

nvp = np.zeros([len(ibool)-1,], dtype = 'float32')
nvs = np.zeros([len(ibool)-1,], dtype = 'float32')
nrho = np.zeros([len(ibool)-1,], dtype = 'float32')

comm.Barrier()
if rank == 0:
    print("Done allocate new model memory.")

for ib in range(len(ibool)-1):
    i = ibool[ib]
    vp = vel[np.floor((x[i-1]-3554400)/5).astype('int')][np.floor((y[i-1]-400000)/5).astype('int')][(-np.floor((z[i-1]+882)/3)-1).astype('int')]
    nvp[i-1] = vp
    nvs[i-1] = vp/np.sqrt(3)
    nrho[i-1] = 1000
    if rank == 0:
        if ib % 100000 == 0:
            print("Done " + str(float(ib)/len(ibool)*100) + "%." )

write_slice(nvp, new_model_dir,["vp"],0)
print("Done writing vp binary file from rank " + str(rank))
write_slice(nvs, new_model_dir,["vs"],0)
print("Done writing vs binary file from rank " + str(rank))
write_slice(nrho,new_model_dir,["rho"],0)
print("Done writing rho binary file from rank " + str(rank))

