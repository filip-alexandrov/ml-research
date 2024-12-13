# Find the duplicate number in O(1) space O(N) time
# array can be seen as linked list
# based on leetcode 287. Find the Duplicate Number

class Solution:
    def findDuplicate(self, nums: List[int]) -> int:
        # linked list
        # list idx = node_current_idx
        # value = node_next_idx, node_value (for determining duplicate value)

        fast = 0 
        slow = 0 

        # intercept at d from start of cycle
        while True: 
            # traverse 2 pos (fast), 1 pos (slow)
            fast = nums[nums[fast]] # idx in nums -> next pos
            slow = nums[slow] # idx in nums

            # check if both located on the same pos (idx pointer, not value (next_pos) 
            # since value contains duplicates)
            if fast == slow: 
                break

        # fast pointer is now reset and slow too
        fast = 0 

        # continue until intercepted, then value == duplicate 
        while True: 
            if fast == slow: 
                return slow # next_node_idx == value (duplicate)
            
            fast = nums[fast]
            slow = nums[slow]

        

