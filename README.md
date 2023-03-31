# Robots!
Robots! is a multi-round, completely autonomous game played by two robots taking turns moving across a 7x7 game board in search of a randomly placed prize token.

![ezgif com-optimize](https://user-images.githubusercontent.com/99278919/229037927-ef135e83-e2a7-4549-b559-ef10cc4f459f.gif)

## 1. Used Stack and Concepts
• UIKit
• Swift
• Protocols and delegates
• MVC
• Threads and Grand Central Dispatch
• Graphs, nodes, and queues
• Breadth First Search Algorithm
• XCTest and UITest

## 2. Bonus
You can change the target by tapping one of the available nodes, so the robots change the path and try to reach the new goal.

## 3. Architecture

![Screen Shot 2023-03-31 at 12 28 36 AM](https://user-images.githubusercontent.com/99278919/229031055-a34f5a08-3e7e-4136-803f-96dcec741707.png)

## 4. Breadth First Search Algorithm

A dungeon has a board size of R x C and you start at cell ’0,0’ and there’s an exit at cell ‘4,3’. Blockers are indicated by a ’#’ and empty cells are represented by a ’.’.

![Screen Shot 2023-03-31 at 12 29 14 AM](https://user-images.githubusercontent.com/99278919/229031141-88a45e74-73a2-4fc0-8d7d-ea912669c86f.png)

Start at the start node coordinate by adding (sr, sc) to the queue:

![Screen Shot 2023-03-31 at 12 29 43 AM](https://user-images.githubusercontent.com/99278919/229031209-09a492de-7df1-4f9d-bf66-8e387b5c7fd1.png)

Keep adding to the queue:

![Screen Shot 2023-03-31 at 12 30 07 AM](https://user-images.githubusercontent.com/99278919/229031273-e655ff09-70df-4299-a579-e53cf1c6d34e.png)

![Screen Shot 2023-03-31 at 12 30 31 AM](https://user-images.githubusercontent.com/99278919/229031327-04176328-18e6-4a41-a30c-736b722872f1.png)

We have reached the end, and if we had a 2D prev matrix we could regenerate the path by retracing our steps:

![Screen Shot 2023-03-31 at 12 30 57 AM](https://user-images.githubusercontent.com/99278919/229031389-96a9db2e-000b-4a2a-85db-d14da59e0d64.png)
