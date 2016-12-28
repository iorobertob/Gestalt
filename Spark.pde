
// TODO: see if two spark methods can be merged

// TODO: Make the spark along the axon to be progressive. Right now it is all drawn at once. 

class Spark{
  
  Spark(){}
  
  /*
  Create a spark like behaviour
  */
  void proximalSpark(float[][] thetas)
  {
   if (STARTSPARK)
      {
        numberDendriteProximal =  int(random(0,pow(2,levels-1))); // This could also be named angleNumber, and it would be located anywhere
                                                          // inside the andgles matrix. 
        moveToStartPosition();
        tempDistance = 0;                                 // Used to see length progrees on every branch
        STARTSPARK = false;                                
       }
    
      if( tempDistance < distance )           // If the line along the branch is not finished
      {
        moveToNode(levelsToDraw, thetas, PROXIMAL, numberDendriteProximal);                 // Go to the ende of dendrite, levels decrease one by one
        
        stroke(white,int(currentLevel+1)*25);                        
        strokeWeight(1);                                  
        //strokeWeight(11*pow(thicknessDecrement,currentLevel+1));
        float targetY = tempDistance + sparkSpeed;
        if (targetY > distance){ targetY = distance;}
        line(0,tempDistance,0,targetY);                   // Spark line progress TODO: insert png
        
        tempDistance += sparkSpeed;                       // The spark line is made longer by sparkSpeed.
      }
      else                                    // Or else rotate and change the distance for the next (lower) segment)
      {
        distance = distance / lengthDecrement;            // Longer branch segment
        rotate(thetas0[currentLevel][numberDendriteProximal]);    // The angle of the current node
        currentLevel -= 1;                                // One node below.  
        levelsToDraw -= 1;                                // To move to the node we only move to that level
        tempDistance  = 0;                                // Restart value
      }
      
      if (currentLevel < 0)                   // We reached the bottom of the tree sructure, finish. 
      {
        SPARK      = true;
        STARTSPARK = true;                                 // Continous sparking
        levelsToDraw = levels;
        numberDendriteProximal = 0;
        RUN = true;
      }   
  }
  
  void distalSpark()
  {
    resetMatrix();
    moveToStartPosition();                                // This moves to the start of the upper branching !!!!!!
    strokeWeight(1);                                      // Draw spark linealong Axon
    stroke(white, 5);
    line(10,200,0,0);
    
    if (true)                                   // here was the StartSpark condition TODO: This might be merged with the proximalSpark method
      {
        moveToNode(levels, thetas, DISTAL, numberDendriteDistal); // Go to the end of a random dendrite.
        tempDistance = 0;                                         // Used to see length progrees on every branch
        STARTSPARK = false;                                       // Do not come here ever again. 
      }
      
      stroke(white,100);                          
      strokeWeight(1);                                  

      numberDendriteDistal += 1;
   
      if (numberDendriteDistal >= pow(2,levels-1))
      {
        AXONSPARK = false;
        numberDendriteDistal = 0;  
      }
      
      resetMatrix();
  }
  
  
  /*
  Follow the angle until the end of a branching to reach such dendrite.
  */
  void moveToNode(int levelsToDraw, float[][] thetas, boolean type, int numberDendrite1)
  {
    if(type == DISTAL)       // Drawing the Distal Dendrites
    {
      translate(10,200);                      
      rotate(PI);                                          // Move to the start of the new set of branches (Axon dendrites)
      line(10,200,0,0);
    }
    else
    { 
      moveToStartPosition();                               // Drawing the Proximal Dendrites.Every iterarion position is restarted so we start from the origin 
    }
    
    if(type == DISTAL){ distance = sizeMainBranchAxon;}
    else              { distance = sizeMainBranch;}        // Set the start of the length, to be computed in the
                                                           // next for cycle
    
    for (int i = 1; i < levelsToDraw; i++)    // Navigate to a certain node. 
        { 
          distance *= lengthDecrement;                    // Get to the end of a dendrite section
          currentLevel = i-1;                             // Set current level for next iteration! as one below the last  
          rotate(thetas[i][numberDendrite1]);              // Rotate accordingly to the level
          
          if (type == DISTAL){ line(0,0,0, -distance);}
          
          translate(0,-distance);                         // Move to the end of that branch
          
         }
  }
}