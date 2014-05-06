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

//	virtual void * insertHead(ListItem * item);
	virtual void insertTail(ListItem * item);
	/**
	 * Removes the given item from list structure only, not from memory.
	 */
	virtual void removeFromList(ListItem * item);
public:
	List();
	virtual ~List();

	// memory operations

	virtual ListItem* createListItem(int data, ListItem * prev,
			ListItem * next);
	virtual void deleteListItem(ListItem * item);


	// list operations

	/**
	 * Inserts the given data at the head of the list.
	 * If the data is already contained, NULL is returned (O(n)),
	 * otherwise the pointer to the new list item.
	 * @return NULL if the data is contained in this list, the data's item otherwise
	 */
	virtual ListItem * insert(int data);
	virtual void remove(ListItem * item);
	/**
	 * @return the list item holding the specified data or NULL if no such item exists
	 */
	virtual ListItem * get(int data);
	/**
	 * @return 1 if contained, 0 if not
	 */
	virtual int contains(int data);
	/** Deletes the whole list, defined as consecutive list->nexts */
	virtual void deleteAll(ListItem * list);

	virtual int size();

	virtual void print();
};

#endif // _LIST_H_
