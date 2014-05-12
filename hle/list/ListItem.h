#ifndef LIST_ITEM_H_
#define LIST_ITEM_H_ 1

class ListItem {
//private:
//	unsigned char padding[64-24];
public:
	ListItem * prev; // 8 bit
	ListItem * next; // 8 bit
	int data; // 8 bit
	ListItem(int data, ListItem * prev, ListItem * next);
};

#endif // LIST_ITEM_H_
