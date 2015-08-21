#include <unittest/unittest.h>

#include <cusp/array1d.h>
#include <cusp/coo_matrix.h>
#include <cusp/csr_matrix.h>
#include <cusp/dia_matrix.h>
#include <cusp/ell_matrix.h>
#include <cusp/hyb_matrix.h>
#include <cusp/multiply.h>
#include <cusp/elementwise.h>

#include <cusp/gallery/poisson.h>
#include <cusp/gallery/random.h>

template <typename SparseMatrixType, typename DenseMatrixType>
void CompareGeneralizedMultSparseMatrixMatrixMultiply(DenseMatrixType A, DenseMatrixType B)
{
    typedef typename SparseMatrixType::index_type IndexType;
    typedef typename SparseMatrixType::value_type ValueType;

    cusp::zero_functor<ValueType> initialize;
    thrust::multiplies<ValueType> combine;
    thrust::plus<ValueType>       reduce;

    DenseMatrixType C, Temp;
    cusp::gallery::random(C, A.num_rows, B.num_cols, A.num_entries);
    DenseMatrixType C_input(C);
    cusp::multiply(A, B, Temp, initialize, combine, reduce);
    cusp::elementwise(C, Temp, C, reduce);

    cusp::coo_matrix<IndexType, ValueType, cusp::host_memory> D(C_input);

    SparseMatrixType _A(A), _B(B), _C(D);
    cusp::generalized_multiply(_A, _B, _C, combine, reduce, reduce);

    ASSERT_EQUAL(C == DenseMatrixType(_C), true);

    _C = D;
    typename SparseMatrixType::view _Aview(_A), _Bview(_B), _Cview(_C);
    cusp::generalized_multiply(_Aview, _Bview, _Cview, combine, reduce, reduce);

    ASSERT_EQUAL(C == DenseMatrixType(_Cview), true);
}

template <typename TestMatrix>
void TestGeneralizedMultSparseMatrixMatrixMultiply(void)
{
    typedef typename TestMatrix::value_type ValueType;

    cusp::array2d<ValueType,cusp::host_memory> A(3,2);
    A(0,0) = 1.0;
    A(0,1) = 2.0;
    A(1,0) = 3.0;
    A(1,1) = 0.0;
    A(2,0) = 5.0;
    A(2,1) = 6.0;

    cusp::array2d<ValueType,cusp::host_memory> B(2,4);
    B(0,0) = 0.0;
    B(0,1) = 2.0;
    B(0,2) = 3.0;
    B(0,3) = 4.0;
    B(1,0) = 5.0;
    B(1,1) = 0.0;
    B(1,2) = 0.0;
    B(1,3) = 8.0;

    cusp::array2d<ValueType,cusp::host_memory> C(2,2);
    C(0,0) = 0.0;
    C(0,1) = 0.0;
    C(1,0) = 3.0;
    C(1,1) = 5.0;

    cusp::array2d<ValueType,cusp::host_memory> D(2,1);
    D(0,0) = 2.0;
    D(1,0) = 3.0;

    cusp::array2d<ValueType,cusp::host_memory> E(2,2);
    E(0,0) = 0.0;
    E(0,1) = 0.0;
    E(1,0) = 0.0;
    E(1,1) = 0.0;

    cusp::array2d<ValueType,cusp::host_memory> F(2,3);
    F(0,0) = 0.0;
    F(0,1) = 1.5;
    F(0,2) = 3.0;
    F(1,0) = 0.5;
    F(1,1) = 0.0;
    F(1,2) = 0.0;

    cusp::array2d<ValueType,cusp::host_memory> G;
    cusp::gallery::poisson5pt(G, 4, 6);

    cusp::array2d<ValueType,cusp::host_memory> H;
    cusp::gallery::poisson5pt(H, 8, 3);

    cusp::array2d<ValueType,cusp::host_memory> I;
    cusp::gallery::random(I, 24, 24, 150);

    cusp::array2d<ValueType,cusp::host_memory> J;
    cusp::gallery::random(J, 24, 24, 50);

    cusp::array2d<ValueType,cusp::host_memory> K;
    cusp::gallery::random(K, 24, 12, 20);

    //thrust::host_vector< cusp::array2d<float,cusp::host_memory> > matrices;
    std::vector< cusp::array2d<ValueType,cusp::host_memory> > matrices;
    matrices.push_back(A);
    matrices.push_back(B);
    matrices.push_back(C);
    matrices.push_back(D);
    matrices.push_back(E);
    matrices.push_back(F);
    matrices.push_back(G);
    matrices.push_back(H);
    matrices.push_back(I);
    matrices.push_back(J);
    matrices.push_back(K);

    // test matrix multiply for every pair of compatible matrices
    for(size_t i = 0; i < matrices.size(); i++)
    {
        const cusp::array2d<ValueType,cusp::host_memory>& left = matrices[i];
        for(size_t j = 0; j < matrices.size(); j++)
        {
            const cusp::array2d<ValueType,cusp::host_memory>& right = matrices[j];

            if (left.num_cols == right.num_rows)
                CompareGeneralizedMultSparseMatrixMatrixMultiply<TestMatrix>(left, right);
        }
    }

}
DECLARE_SPARSE_MATRIX_UNITTEST(TestGeneralizedMultSparseMatrixMatrixMultiply);

template <typename DerivedPolicy,
          typename LinearOperator,
          typename MatrixOrVector1,
          typename MatrixOrVector2,
          typename BinaryFunction1,
          typename BinaryFunction2,
          typename BinaryFunction3>
void generalized_multiply(my_system &system,
                          const LinearOperator&  A,
                          const MatrixOrVector1& B,
                                MatrixOrVector2& C,
                          BinaryFunction1 combine,
                          BinaryFunction2 reduce,
                          BinaryFunction3 accum)
{
    system.validate_dispatch();
    return;
}

void TestGeneralizedMultSpGEMMDispatch()
{
    // initialize testing variables
    cusp::coo_matrix<int, float, cusp::device_memory> A, B, C;

    my_system sys(0);

    thrust::multiplies<float> combine;
    thrust::plus<float>       reduce;

    // call with explicit dispatching
    cusp::generalized_multiply(sys, A, B, C, combine, reduce, reduce);

    // check if dispatch policy was used
    ASSERT_EQUAL(true, sys.is_valid());
}
DECLARE_UNITTEST(TestGeneralizedMultSpGEMMDispatch);

