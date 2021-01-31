# TransNJU

Transparent Nanjing University is an experimental project exploring the fine geological structure underneath Nanjing University Xianlin Campus. Being initialized in May 2020, the project is currently stepping into data procoessing. One of the most essential ingredients of active seismic data processing in this project is Full Waveform Inversion (FWI). This repository contains temporal parameters and configurations of [SeisFlows](https://github.com/niyiyu2316/seisflows) and [SPECFEM 3D](https://github.com/geodynamics/specfem3d) for this local 3D FWI task.



## Topo

NJU campus contains topography as elevation ranges from ~20m to ~80m (Mt. Nanyong). Data from receivers and sources are extracted and interpolated. Due to the sparse and uneven distribution of data points, I later applied a mean smoothing to the topography in avoid of poor mesh generated later (skewness ~0.9).

The MATLAB style matrix could later be easily written SEM-readable interface data.



## SEM_Demo

This folder contains some SEM shake volume/surface movies. Most of them are not reproducible due to the large size of vtk file required.