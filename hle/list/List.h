#ifndef _LIST_H_
#define _LIST_H_ 1

class ListItem {
public:
	ListItem * prev;
	ListItem * next;
	int data;
	ListItem(int data, ListItem * prev, ListItem * next);
};

class List {
protected:
	ListItem * first;
	ListItem * last;
public:
	List();
	~List();

	/** @see #insertHead(int data) */
	ListItem * insert(int data);
	virtual ListItem * insertHead(ListItem * item);
//	virtual ListItem * insertTail(ListItem * item);
	/**
	 * Removes the occurrences of data in the list.
	 * If removeAll is != 0, all occurrences are removed, otherwise only the first one.
	 * */
	virtual void remove(int data, int removeAll = 0);
	/** @return 1 if data is contained, 0 if not */
	virtual int contains(int data);
	/** Deletes the whole list, defined as consecutive list->nexts */
	virtual void deleteAll(ListItem * list);

	virtual int size();

	virtual void print();
};

#endif // _LIST_H_
