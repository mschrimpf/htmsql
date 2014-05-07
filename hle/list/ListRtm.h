#ifndef LIST_RTM_H_
#define LIST_RTM_H_

#include "List.h" // extend


class ListRtm : public List {
protected:
	virtual ListItem * findAndRemoveFromList(int data);
public:
	ListRtm();
	~ListRtm();

	virtual void insertTail(ListItem * item);
};

#endif /* LIST_RTM_H_ */
