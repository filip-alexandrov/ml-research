# 210 Course Schedule 2, return 1 possible combinations of courses, so prereqs are fullfilled 

class Course: 
    def __init__(self, id = 0, prereqs = []): 
        self.id = id
        self.prereqs = prereqs

class Solution:
    topology = []

    cycle = False
    seen = set()

    def dfs(self, course): 
        # detect cycle
        if course in self.seen: 
            self.cycle = True
            return 

        if course.id in self.topology: 
            return

        # add to seen 
        self.seen.add(course)

        for prereq in course.prereqs: 
            # course and its prereqs already added
            if prereq in self.topology: 
                continue

            self.dfs(prereq)

        # remove from seen before return 
        self.seen.remove(course)

        # add to topology 
        self.topology.append(course.id)


    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        # reset object
        self.topology = []
        self.cycle = False
        self.seen = set()
        
        courses = [Course(i, []) for i in range(numCourses)]

        # build graph 
        for p in prerequisites: 
            course = courses[p[0]]
            prereq = courses[p[1]]

            course.prereqs.append(prereq)

        # build topological graph 
        for course in courses: 
            self.dfs(course)
            
            if self.cycle: 
                return []

        return self.topology
    

# Input: numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]
# Output: [0,2,1,3]