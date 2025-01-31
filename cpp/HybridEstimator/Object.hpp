#ifndef OBJECT_HPP
#define OBJECT_HPP

#include <memory>
#include <eigen3/Eigen/Core>

using namespace Eigen;

class Object
{
public:
	Object() {};
	~Object() {};

	//Object type consts
	static const int TYPE_PERSON = 1;
	static const int TYPE_TORSO = 2;
	static const int TYPE_FACE = 3;
	static const int TYPE_HEADANDSHOULDERS = 4;
	static const int TYPE_LEGS = 5;
	static const int TYPE_BALL = 6;
	static const int TYPE_CYLINDER = 7;
	static const int TYPE_CUBE = 8;
	static const int TYPE_MARKER = 9;

	//Comparison mode consts
	static const int COMP_POSITION = 1;
	static const int COMP_COLORS = 2;
	static const int COMP_COLORSANDPOSITION = 3;
	static const int COMP_FORMFEATURES = 4;
	static const int COMP_ALL = 5;

	//Mode must be defined in derived classes
	virtual double compareWith(Object &otherObject, int mode, int metric) = 0;

	int getObjectType()
	{
		return objectType;
	};

	virtual std::shared_ptr<Object> clone() = 0;

	virtual VectorXd getObservableStates() = 0;

	virtual MatrixXd getObervableCovariance() = 0;

protected:

	int objectType;

};

#endif //OBJECT_HPP