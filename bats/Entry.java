

public final class Entry<T> {
    public int     mDegree = 0;       // Number of children
    public boolean mIsMarked = false; // Whether this node is marked

    public Entry<T> mNext;   // Next and previous elements in the list
    public Entry<T> mPrev;

    public Entry<T> mParent; // Parent in the tree, if any.

    public Entry<T> mChild;  // Child node, if any.

    public T      mElem;     // Element being stored here
    public double mPriority; // Its priority

    /**
     * Returns the element represented by this heap entry.
     *
     * @return The element represented by this heap entry.
     */
    public T getValue() {
        return mElem;
    }
    /**
     * Sets the element associated with this heap entry.
     *
     * @param value The element to associate with this heap entry.
     */
    public void setValue(T value) {
        mElem = value;
    }

    /**
     * Returns the priority of this element.
     *
     * @return The priority of this element.
     */
    public double getPriority() {
        return mPriority;
    }

    /**
     * Constructs a new Entry that holds the given element with the indicated 
     * priority.
     *
     * @param elem The element stored in this node.
     * @param priority The priority of this element.
     */
    public Entry(T elem, double priority) {
        mNext = mPrev = this;
        mElem = elem;
        mPriority = priority;
    }
}
