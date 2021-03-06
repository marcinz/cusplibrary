/*
 *  Copyright 2008-2014 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/*! \file spectral_radius.h
 *  \brief Various methods to compute spectral radius
 */

#pragma once

#include <cusp/detail/config.h>

#include <cstddef>

namespace cusp
{
namespace eigen
{

/*! \addtogroup iterative_solvers Iterative Solvers
 *  \addtogroup eigensolvers EigenSolvers
 *  \ingroup iterative_solvers
 *  \{
 */

template <typename Matrix>
double disks_spectral_radius(const Matrix& A);

template <typename MatrixType>
double estimate_rho_Dinv_A(const MatrixType& A);

template <typename Matrix>
double estimate_spectral_radius(const Matrix& A, size_t k = 20);

template <typename Matrix>
double ritz_spectral_radius(const Matrix& A, size_t k = 10, bool symmetric=false);

/*! \}
 */

} // end namespace eigen
} // end namespace cusp

#include <cusp/eigen/detail/spectral_radius.inl>
