# Notes on ParaView Server and HPC platform

1. Download ParaView linux server from http://paraview.org. Notes that the version should be identical if you wish to connect from local.

2. Open a port for TCP connection. Please refer to the document of specific linux release. The command would be something like

  `sudo firewall-cmd --add-port=11111/tcp `

  This may be required when using VPN, but could be skipped if you're in LAN.

3. Find `pvserver` in `PATH_TO_PARAVIEW/bin`, submit the job and the paravie server will be idling for connection request. 

  - This could be as same as running a program

    `mpiexec -np 4 ./pvserver &`

  - Or submitting a job to HPC

    ```bash
    #!/bin/bash
    
    #SBATCH -J test
    #SBATCH -n 1
    #SBATCH -N 1
    #SBATCH -p normal
    
    #SBATCH --gres=dcu:1
    ifconfig
    ./pvserver --server-port=11111 > log
    ```

    

Note that:

- When local part disconnected, the remote pvserver also closed. So remember to submit another job when establishing a new paraview session.

- To see port status

  `lsof -i:11111`