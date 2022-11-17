typedef struct node {
    int value;
    struct node* next;
} Node;

int
sumlist(Node* the_list) { // I removed const here to get rid of warning
    int sum = 0;
    Node* l;

    for (l = the_list; l != 0; l = l -> next)
    {
        sum = sum + l->value;
    }

    return sum;
}

int
sumlist1(const Node* the_list) {
    const Node* list;           /* args to loop */
    int sum;

    list = the_list;            /* args to the first call */
    sum = 0;
    goto loop;                  /* a tail call to loop */


loop:
    if (list == 0) {
        return sum;             /* value returned from loop */
    }
    else {
        int v = list->value;
        const Node* rest = list->next;

        list = rest;            /* new args for the tail call */
        sum = sum + v;
        goto loop;
    }
}

// just to make it compile.
int main(int argc, char *argv[]) {
    return 0;
}
