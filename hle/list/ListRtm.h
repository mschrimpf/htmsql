#ifndef LIST_RTM_H_
#define LIST_RTM_H_

#include "List.h" // extend


class ListRtm : public List {
public:
	ListRtm();
	~ListRtm();

	virtual void insertTail(ListItem * item);
	virtual void removeFromList(ListItem * item);
	/**
	 * @return the list item holding the specified data or NULL if no such item exists
	 */
	virtual ListItem * get(int data);
};

#endif /* LIST_RTM_H_ */
