#ifndef ASSOCIATION_HPP
#define ASSOCIATION_HPP

#include <memory>
#include <vector>
#include "Detection.hpp"

using namespace std;

template <class Obj, class Trk> class Association
{
public:
	Association(shared_ptr<Trk> trackPTR, shared_ptr<Detection<Obj> > detecPTR)
	{
		this->trackerPTR = trackPTR;
		this->detectionPTR = detecPTR;
	};

	~Association() {};

	shared_ptr<Trk> getTrackerPTR()
	{
		return trackerPTR;
	};

	shared_ptr<Detection<Obj>> getDetectionPTR()
	{
		return detectionPTR;
	};
	/*
	friend ostream& operator<<(ostream& os, const Association& ass)
	{

		os << "**** Association ****" << endl << endl;
		os << *ass.getTrackerPTR() << endl;
		os << "with: " << endl;
		os << *ass.getDetectionPTR() << endl;
		os << "******************" << endl;

		return os;
	}
	*/

private:
	shared_ptr<Trk> trackerPTR;
	shared_ptr<Detection<Obj> > detectionPTR;

};

template <class Obj, class Trk> class AssociationList
{
public:

	AssociationList() {};

	vector<Association<Obj, Trk>> getSuccessfulAssociations() const
	{
		return associationList;
	}


	vector<shared_ptr<Trk>> getUnassociatedTrackers()
	{
		return unassociatedDetections;
	}


	vector<shared_ptr<Detection<Obj>>> getUnassociatedDetections()
	{

		return unassociatedDetections;
	}

	void addSuccessfulAssociation(Association<Obj, Trk> assoc)
	{
		this->associationList.push_back(assoc);
	};



	void addUnassociatedDetection(shared_ptr<Detection<Obj>> det) 
	{
		this->unassociatedDetections.push_back(det);
	};

	void addUnassociatedDetection(vector<shared_ptr<Detection<Obj>>> detecPTRvec)
	{
		this->unassociatedDetections = detecPTRvec;
	};
	/*
	friend ostream& operator<<(ostream& os, const AssociationList& assocList)
	{

		vector<Association<Obj, Trk>> assocVect = assocList.getSuccessfulAssociations();

		os << "-- Successful associations -- " << endl << endl;

		for (auto& ass : assocVect)
		{
			os << ass;
		}

		return os;
	}*/

protected:

	vector<Association<Obj, Trk>> associationList;
	vector<shared_ptr<Detection<Obj>>> unassociatedDetections;


};
#endif // ASSOCIATION_HPP

