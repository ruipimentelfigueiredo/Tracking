#ifndef MMBANKITEM_HPP
#define MMBANKITEM_HPP

#include "BaseBayesianFilter.hpp"
#include <eigen3/Eigen/Core>

using namespace Eigen;

class MMBankItem
{
public:

	~MMBankItem();
	VectorXd getStatePred();
	VectorXd getStatePost();
	MatrixXd getCovPred();
	MatrixXd getCovPost();

    void predict(VectorXd &control);
    void update(VectorXd &measure);


    void predict()
    {
        predict(EMPTYVEC);
    }

    void update()
    {
        update(EMPTYVEC);
    }

	std::string getModelName();

	virtual std::shared_ptr<MMBankItem> clone() = 0;


protected:

	MMBankItem();
	std::shared_ptr<BaseBayesianFilter> filter;
	

};

#endif // MMBANKITEM_HPP
