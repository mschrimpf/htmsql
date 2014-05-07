#ifndef _LIST_H_
#define _LIST_H_ 1

class ListItem {
//private:
//	unsigned char padding[64-24];
public:
	ListItem * prev; // 8 bit
	ListItem * next; // 8 bit
	int data; // 8 bit
	ListItem(int data, ListItem * prev, ListItem * next);
};

class List {
private:
	/**
	 * @return the list item holding the specified data or NULL if no such item exists
	 */
	ListItem * get(int data);
	/**
	 * Removes the given item from list structure only, not from memory.
	 */
	void removeFromList(ListItem * item);
protected:
	ListItem * first;
	ListItem * last;

//	virtual void * insertHead(ListItem * item);
	virtual void insertTail(ListItem * item);
	virtual ListItem * findAndRemoveFromList(int data);
	void remove(ListItem * item);
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
	ListItem * insert(int data);
	virtual void remove(int data);
	/**
	 * @return 1 if contained, 0 if not
	 */
	int contains(int data);
	/** Deletes the whole list, defined as consecutive list->nexts */
	void deleteAll(ListItem * list);

	virtual int size();

	virtual void print();
};

#endif // _LIST_H_
