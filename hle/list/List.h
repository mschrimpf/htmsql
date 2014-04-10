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
private:
	ListItem * first;
	ListItem * last;
public:
	/** @see #insertHead(int data) */
	ListItem * insert(int data);
	ListItem * insertHead(int data);
	ListItem * insertTail(int data);
	/**
	 * Removes the occurrences of data in the list.
	 * If removeAll is != 0, all occurrences are removed, otherwise only the first one.
	 * */
	void remove(int data, int removeAll = 0);
	/** @return 1 if data is contained, 0 if not */
	int contains(int data);

	void print();

	List();
	~List();
};

#endif // _LIST_H_
