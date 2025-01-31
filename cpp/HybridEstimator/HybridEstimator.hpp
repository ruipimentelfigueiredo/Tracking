#ifndef HYBRIDESTIMATOR_HPP
#define HYBRIDESTIMATOR_HPP

#include <eigen3/Eigen/Core>
#include "MMBankItem.hpp"
#include "MMBankItem.hpp"
#include "BaseBayesianFilter.hpp"
#include <vector>
#include <memory>

using namespace Eigen;

/**
 * @file HybridEstimator.hpp
 *
 * Copyright (C) 2016, Joao Avelino
 *
 * This abstract class defines a Hybrid Estimator. It can be used to implement algorithms
 * that rely on multiple models and fuses their estimations on a probabilistic way, like
 * the Multiple Models Adaptive Estimator [1] or the Interactive Multiple Models [2].
 *
 *  Refs:
 *  [1] Hanlon, P. D., & Maybeck, P. S. (2000). Multiple-model adaptive estimation 
 *	   using a residual correlation Kalman filter bank. IEEE Transactions on Aerospace 
 *	   and Electronic Systems, 36(2), 393-406.
 *  [2] Mazor, Efim, et al. "Interacting multiple model methods in target tracking: a survey." 
 *		IEEE transactions on aerospace and electronic systems 34.1 (1998): 103-123.
 *
 *
 *
 *  License stuff
 */

class HybridEstimator : public BaseBayesianFilter
{
public:
    virtual VectorXd getStatePred() = 0;
    virtual MatrixXd getCovPred() = 0;
    virtual VectorXd getStatePost() = 0;
    virtual MatrixXd getCovPost() = 0;
	VectorXd getMeasurementResidual(VectorXd &measure)
	{
		return VectorXd();
	}

	MatrixXd getResidualCovariance()
	{
		return MatrixXd();
	}

    virtual void predict(VectorXd &control) = 0;

    void predict()
    {
        predict(EMPTYVEC);
    }

    virtual void update(VectorXd &measure) = 0;

    void update()
    {
        update(EMPTYVEC);
    }

    virtual void updateDeltaT(double deltaT) = 0;
    virtual std::vector<double> getAllModelProbabilities() = 0;
    HybridEstimator();

	virtual std::shared_ptr<BaseBayesianFilter> clone() = 0;

};

#endif // HYBRIDESTIMATOR_HPP
