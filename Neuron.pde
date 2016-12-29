//TODO: Merge the two branch methods!!

class Neuron {
  
  
  Neuron(){}
  
  /*
  Draws a Neuron
  */
  void drawNeuron(boolean fromMatrix, float initialThicknessProximal, float initialThicknessDistal)
  {
    clearArray(repeatedThetaCounter);
    
    //fill(0,0,0,10);
    //rect(0,0,width,height);
    
    a     = random(10, 60);                              // Random angle for next branching.
    theta = radians(a);                                  // Convert it to radiana.
    
    moveToStartPosition();
    
    stroke(blue,250);
    strokeWeight(10);
    
    // Draw Proximal Dendrites
    if(fromMatrix == false)
    {
      branch(sizeMainBranch, initialThicknessProximal, 0, PROXIMAL); 
      copyThetas();                // Stupid! I know, but I had to do it beause simply doing thetas0 = thetas was merging them into the same object!
    } 
    else 
    {
      branchFromMatrix(sizeMainBranch, initialThicknessProximal, 0, thetas0, PROXIMAL);// Start the recursive branching!
    }
    
    drawPyramidLine();                                   // Draw the line that completes the triangle in the pyramid 
    
    for (int i = 0; i < levels; i ++)                    // Reset the counter used to repeat the angles in the "thetas" matrix
    {
      repeatedThetaCounter[i] = 0;
    }
    
    translate(10,200);                      
    rotate(PI);                                          // Move to the start of the new set of branches (dendrites)
    
    
    // Draw Distal Dendrites
    if(fromMatrix == false){branch(sizeMainBranchAxon, initialThicknessDistal, 0, DISTAL);} // Recursive branching call 
    else                   {branchFromMatrix(sizeMainBranchAxon, initialThicknessDistal, 0, thetas, DISTAL);}
    
    rotate(-PI);
    translate(-10,-200);                                 // Move back to do the firing.
    
    
  }
  
  /*The result of calling branch is vector with all angles of branches by levels
  
  thetas
  
  this should be computed everytime? now its almost hardcoded, but since the selection of
  angles is arbitrary, or random, there is no understanding of the cause of these angles
  in nature, there is a paper about the role of resistance to the air as the cause of the
  thickness of the branching. 
  TODO: change thickness of branches, to be complementary
        ac + bc = c 
        c = previous thicknness, a and b are coefficients adding to one. 
  */
  void branch(float h, float thickness, int level, boolean type) 
  {
    level     += 1;                                      // Move one level (node) forward everytime this function is [re] called
    h         *= lengthDecrement;                        // Each branch will be decremented by a global variable
    
    if(type == PROXIMAL){thickness *= thicknessDecrementProximal;}
    else                {thickness *= thicknessDecrementDistal;  }   // Thinner and thinner branches. 
    
    if (thickness<-90){
      thickness =2;
    }
    
    if (level < levels) {                     // Exit condition from recursion. If we have moved all over the desired number of levels 
      
      pushMatrix();                                      // Save the current state of transformation (i.e. where are we now)
      
      getAndStoreNextAngle(level);                       // Randomize next angle and store it in "tethas" matrix. TODO: see about the cast
  
      rotate   (theta);                                  // Rotate by theta
      
      strokeWeight(thickness);
      line(0, 0, 0, -h);                                 // Draw the branch
      
      translate(0, -h);                                  // Move to the end of the branch
      
      branch(h, thickness, level, type);                 // Call again to draw two new branches!!
      
      popMatrix();                                       // Whenever we get back here, we "pop" in order to restore the previous matrix state
      pushMatrix();                                      // Save state of matrix
      
      // Repeat the same thing, only change the angle, another randomized one. 
      getAndStoreNextAngle(level);                       // Randomize next angle and store it in "tethas" matrix. TODO: see about the cast
      
      rotate   (theta);                                  // Rotate by theta
      
      strokeWeight(thickness);
      line(0, 0, 0, -h);                                 // Draw the branch
      
      translate(0, -h);                                  // Move to the end of the branch
  
      branch(h, thickness, level, type);                 // Call again to draw two new branches!!
      
      popMatrix();                                       // Retreive the matrix.
    } 
  }
  
  void branchFromMatrix(float h, float thickness, int level, float[][] thetasVector, boolean type) 
{
  level     += 1;                                      // Move one level (node) forward everytime this function is [re] called
  h         *= lengthDecrement;                        // Each branch will be decremented by a global variable
  
  if(type == PROXIMAL){thickness *= thicknessDecrementProximal;}
  else                {thickness *= thicknessDecrementDistal;  }   // Thinner and thinner branches. 
  
  if (thickness<-90){
    thickness =2;
  }
  
  if (level < levels) {                     // Exit condition from recursion. If we have moved all over the desired number of levels 
    
    pushMatrix();                                      // Save the current state of transformation (i.e. where are we now)
    
    theta = thetasVector[level][repeatedThetaCounter[level]];// Get angle from the thetas vector. 
    float factor = pow(2, levels-level-1);             // Hop size in the matrix. Or how many repeated angles are stored. 
    repeatedThetaCounter[level] += int(factor);        // How many branches (angles) at this level 
    
    rotate   (theta);                                  // Rotate by theta
    
    strokeWeight(thickness);
    stroke(blue,20);
    line(0, 0, 0, -h);                                 // Draw the branch
    
    translate(0, -h);                                  // Move to the end of the branch
    
    branchFromMatrix(h, thickness, level, thetasVector, type); // Call again to draw two new branches!!
    
    popMatrix();                                       // Whenever we get back here, we "pop" in order to restore the previous matrix state
    pushMatrix();                                      // Save state of matrix
    
    
    theta  = thetasVector[level][repeatedThetaCounter[level]];    // Repeat the same thing, only change the angle, another from the vector
    factor = pow(2, levels-level-1);                              // Hop size in the matrix. Or how many repeated angles are stored. 
    repeatedThetaCounter[level] += int(factor);                   // How many branches (angles) at this level 
    
    rotate   (theta);                                  // Rotate by theta
    
    strokeWeight(thickness);
    
    strokeWeight(thickness);
    stroke(blue,20);
    line(0, 0, 0, -h);                                 // Draw the branch
    
    translate(0, -h);                                  // Move to the end of the branch
    
    branchFromMatrix(h, thickness, level, thetasVector, type); // Call again to draw two new branches!!
    
    popMatrix();                                       // Retreive the matrix.
  } 
}
  
  
  /*
  Obtain a random angle and store it in the thetas matrix according to how many repetitions need to be written there.
  */
  void getAndStoreNextAngle(int level)
  {
      stroke(random(0,255),random(0,255),random(0,255),random(0,255));
      a               = random(-70, 70);                 // Randomize next angle in this node 
      theta           = radians(a);                      // Convert it to radians
      float factor    = pow(2, levels-level-1);          // Hop size in the matrix. Or how many repeated angles are stored. 
      int repetitions = int(repeatedThetaCounter[level] * factor); // Starting point in the matrix where to store the angles
      
      for(int i = repetitions; i < repetitions + factor; i ++)
      {
        thetas [level][i] = theta;                  // Store repeated angles
      }
      repeatedThetaCounter[level] += 1;             // How many branches (angles) at this level 
  }
  
  /*
  Just making thetas0 = thetas would actually make them be the same object
  */
  void copyThetas()
  {
    for( int i  = 0 ; i < levels; i++)
    {
      for( int j = 0 ; j < pow(2, levels-1); j ++)
      {
        thetas0[i][j] = thetas[i][j];
      }
    }
  }
  
  /*
  Draw a line that is not straight but wonky, to make it look more organic
  TODO: improve this thing, it is shit at the moment
  */
  void drawOrganicLine(float x1, float y1, float x2, float y2)
  {
    float deltaX = x2 - x1;
    float deltaY = y2 - y1;
    float newX;
    float newY;
    
    while ( (abs(deltaX) > 1) || (abs(deltaY) > 1) )     // While we havent arrived at destination. By 1 pixel
    {
      deltaX = x2 - x1;                                  // Update deltas
      deltaY = y2 - y1;
      
      if (deltaX > 0) newX = random(0,deltaX);           // If positive difference randomize next X position accordingly 
      else            newX = random(deltaX, 0);          // If negative difference randomize next X position accordingly
      
      if (deltaY > 0) newY = random(0,deltaY);           // Same as for deltaX
      else            newY = random(deltaY, 0);
  
      line (x1, y1, x1+newX, y1+newY);                   // Line with the randomized destination
      
      x1 = x1 + newX;                                    // Updating the current position in the travelling to destination
      y1 = y1 + newY;
    }
  }

  void drawPyramidLine()
  {
    // Draw the Triangle that makes the pyramidal neuron 
    float hipo = 180 * 0.66;                             // Trigonometry to find ends of first two branches
    float x1 = cos((-(PI/2)+thetas0[1][0])) * hipo;
    float y1 = sin((-(PI/2)+thetas0[1][0])) * hipo;
    float x2 = cos((-(PI/2)+thetas0[1][int((numberOfAngles/2))])) * hipo;
    float y2 = sin((-(PI/2)+thetas0[1][int((numberOfAngles/2))])) * hipo;
    strokeWeight(10*thicknessDecrementProximal);                 // TODO: abstract the number 10, or initial thickness
    drawOrganicLine(x1,y1,x2,y2);                        // Draw a somewhat randomized line between two points, for a more organic look
    drawOrganicLine(0,0,10,200);                         // Draw a somewhat randomized line as the axon, for a more organic look
  }  
}