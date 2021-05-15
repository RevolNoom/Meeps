## Report outline for each part of the project

### 1. <Method name>
- Brief explanation of the evaluation strategy
- Pros/cons (in terms of views from computer aspect, human aspect, accuracy, etc. Note: in this part, we only consider the overall result, not the specific result in the project implementation)

### 2. Implementation
- Explanation of each part of the code with its function (if the code has many sections)
- Explain the result
- Determine how the float is calculated, stored, rounded, etc
- Determine steps that errors can occurs
- Other problems that you want to consider about the implementation, put it here

### 3. Comments
- Is the method proper to implement in MIPS?
- Why we can/cannot improve the result/performance? Suggest solutions
- Real implementation (if you can find any)
- Anything you can think about, put it here

Example: This might give you some idea for brainstorming

```
1. Newton - Lebniz
- Newton Lebniz is the very-basic way to compute area of a surface, which is taught to student from middle school
- Easy to understand to human with high precision. However, is not easy to implement with code
- The result of Newton - Lebniz is a function that can be represented by a series, which make the coding easier. However, the accurracy decreases when the number of terms considered is small

2. Implementation
- This A function does this. The final result is put in this register
- This B function does that. At this point, the precision decrease since the number of steps is small
- We put them all in this loop to do these stuff
- The final result is put in this register. This register is of type X, and since we use this operation, X is converted and be rounded...
- Take notice that the operation gives this result implementing this way, but that result implementing that way. The reason is that...
- We must use this instruction and register to...
- 

3. Comment
- Pros: This implementation is straightforward according to the analyzing stated in part 1
- Cons: The loop is time consuming, the result has (un)acceptable accuracy

```

