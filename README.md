# Dante

---
## Introduction

Dante is a flexible multiscale influenza forecasting model that learns rather than prescribes spatial, temporal, and surveillance data structure. Forecasts at the Health and Human Services (HHS) regional and national scales are generated as linear combinations of state forecasts with weights proportional to US Census population estimates, resulting in coherent forecasts across nested geographic scales.

Dante participated in the prospective 2018/19 FluSight challenge hosted by the Centers for Disease Control and Prevention and placed 1st in both the national and regional competition and the state competition. The methodology underpinning Dante can be used in other disease forecasting contexts where nested geographic scales of interest exist.

## System requirements

Dante uses the software JAGS (Just Another Gibbs Sampler), as called by the R package rjags within the programming language R to perform the MCMC sampling. The code is supported on all operating systems for which the requisite downloads (see below) are possible. The example code was tested on a 64-bit x86_64-redhat-linux-gnu platform running Fedora 29, using R version 3.6.1, rjags 4-10, and coda 0.19-3.

## Installation

To downloading and install software and packages:
 - R (>= 2.14.0) follow instructions at https://www.r-project.org/
 - rjags (>= 4-10) run `install.packages('rjags')` within R session
 - coda (>= 0.13) run `install.packages('coda')` within R session

Installation should take less than 15 minutes on a normal desktop computer.

## Demonstration

A reduced data set is provided, named **dat.Rdata**. This example data includes ILI observations from epi seasons 2013, 2014, and 2015 for the states Alaska, Illinois, Indiana, Maryland, Ohio, Virginia, Washington, West Virginia, and Wisconsin. For 2013 and 2014, data from epi time 1 through 30 are included; for 2015, the "forecast season", ILI is observed only from epi time 1 through 14. Note that "regional" and "national" data is also scaled down to this set of states.

The R code to collect samples from Dante using this data set is found in the file **run_model.R**. This file includes comments throughout noting the structure of the data, should users wish to format their own data for modeling, and other choices that could be make at various points in the example code. The expected output is a series of three plots: trace plots and density estimates for two of the state-specific precision parameters in the model, followed by the "national" observed data with forecast mean and 95% credible interval. The code should take roughly 2-3 minutes to run.

## Instructions for use

Users should create an R list containing the following named variables should they wish to run the model on their own data:
 - NR_state = Integer number of unique states.
 - NR_region = Integer number of unique regions.
 - NS = Integer number of unique seasons.
 - NT = Integer number of unique time points.
 - y_state = 3D array with state ILI data; array is of size NR_state x NS x NT
 - yobs_region = 2D array with region wILI data from current season; matrix is of size nobs x NR_region.
 - yobs_nat = 1D vector with national wILI data from current season; of size nobs
 - census_weights = 2D matrix of census weights; matrix is of size NR_state x (NR_region + 1), where the last column is the national weights.
 - fcstseason = an integer defining which number the "current" season to be forecast is.
 - nobs = an integer defining the last week at which data were available in current season.

Following data creation, assuming **Dante.bug** is in the current working directory and the data are named **dat**, the model can be run by simply running `jags.model(file="Dante.bug", data=dat)` in R.

## Attribution

If you use the Dante in your research work, please cite the following paper:

D. Osthus, KR. Moran. Multiscale Influenza Forecasting. [Under consideration at Nature Communications](https://nature-research-under-consideration.nature.com/users/37265-nature-communications/posts/55426-multiscale-influenza-forecasting).

---
Copyright 2020 for **C20067 Dante**

This program is open source under the BSD-3 License.
Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and
the following disclaimer.
 
2.Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the
distribution.
 
3.Neither the name of the copyright holder nor the names of its contributors may be used to endorse
or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

© 2020. Triad National Security, LLC. All rights reserved.
This program was produced under U.S. Government contract 89233218CNA000001 for Los Alamos
National Laboratory (LANL), which is operated by Triad National Security, LLC for the U.S.
Department of Energy/National Nuclear Security Administration. All rights in the program are
reserved by Triad National Security, LLC, and the U.S. Department of Energy/National Nuclear
Security Administration. The Government is granted for itself and others acting on its behalf a
nonexclusive, paid-up, irrevocable worldwide license in this material to reproduce, prepare
derivative works, distribute copies to the public, perform publicly and display publicly, and to permit
others to do so.
