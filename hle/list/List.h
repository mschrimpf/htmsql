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

	virtual ListItem * insertHead(ListItem * item);
//	virtual ListItem * insertTail(ListItem * item);
public:
	List();
	~List();

	/**
	 * Inserts the given data at the head of the list.
	 * If the data is already contained, NULL is returned (O(n)),
	 * otherwise the pointer to the new list item.
	 * @return NULL if the data is contained in this list, the data's item otherwise
	 */
	ListItem * insert(int data);
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
