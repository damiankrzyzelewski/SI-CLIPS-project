import javax.swing.*;
import java.awt.*; 
import java.awt.event.*; 
import java.text.BreakIterator;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.MissingResourceException;
 
import CLIPSJNI.*;


public class Cartoon implements ActionListener
  {  
   JLabel displayLabel;
   JLabel conclusionsLabel;
   JButton nextButton;
   JButton prevButton;
   JPanel choicesPanel;
   JPanel conclusionsPanel;
   JPanel displayPanel;
   ButtonGroup choicesButtons;
   ResourceBundle CartoonResources;
   JFrame jfrm;
   Environment clips;
   boolean isExecuting = false;
   Thread executionThread;
      
   Cartoon()
     {  
      try
        {
         CartoonResources = ResourceBundle.getBundle("resources.Cartoon",Locale.getDefault());
        }
      catch (MissingResourceException mre)
        {
         mre.printStackTrace();
         return;
        }
      
      /*================================*/
      /* Create a new JFrame container. */
      /*================================*/
     
      jfrm = new JFrame(CartoonResources.getString("Cartoon"));  
    
      /*=================================*/
      /* Give the frame an initial size. */
      /*=================================*/
     
      jfrm.setSize(400,400);  
  
      /*=============================================================*/
      /* Terminate the program when the user closes the application. */
      /*=============================================================*/
     
      jfrm.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);  
      jfrm.getContentPane().setLayout(new BoxLayout(jfrm.getContentPane(), BoxLayout.Y_AXIS));
      /*===========================*/
      /* Create the display panel. */
      /*===========================*/
      
      displayPanel = new JPanel(); 
      conclusionsPanel = new JPanel();
      displayLabel = new JLabel();
      conclusionsLabel = new JLabel();
      displayPanel.add(displayLabel);
      conclusionsPanel.add(conclusionsLabel);
      
      /*===========================*/
      /* Create the choices panel. */
      /*===========================*/
     
      choicesPanel = new JPanel(); 
      choicesPanel.setLayout(new FlowLayout());
      displayPanel.setLayout(new FlowLayout());
      choicesButtons = new ButtonGroup();
   
      
      /*===========================*/
      /* Create the buttons panel. */
      /*===========================*/

      JPanel buttonPanel = new JPanel(); 
      
      prevButton = new JButton(CartoonResources.getString("Prev"));
      prevButton.setActionCommand("Prev");
      buttonPanel.add(prevButton);
      prevButton.addActionListener(this);
      
      nextButton = new JButton(CartoonResources.getString("Next"));
      nextButton.setActionCommand("Next");
      buttonPanel.add(nextButton);
      nextButton.addActionListener(this);
     
      /*=====================================*/
      /* Add the panels to the content pane. */
      /*=====================================*/
      
      jfrm.getContentPane().add(displayPanel); 
      jfrm.getContentPane().add(choicesPanel); 
      jfrm.getContentPane().add(conclusionsPanel);
      jfrm.getContentPane().add(buttonPanel); 
      jfrm.setSize(400,400); 
      /*========================*/
      /* Load the clp program. */
      /*========================*/
      
      clips = new Environment();
      
      clips.load("cartoon.clp");
      
      clips.reset();
      runAuto();

      /*====================*/
      /* Display the frame. */
      /*====================*/
      
      jfrm.setVisible(true);  
     }  

   /****************/
   /* nextUIState: */
   /****************/  
   private void nextUIState() throws Exception
     {
      /*=====================*/
      /* Get the state-list. */
      /*=====================*/
      
      String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
      
      String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

      /*===========================*/
      /* Get the current UI state. */
      /*===========================*/
      
      evalStr = "(find-all-facts ((?f UI-state)) " +
                                "(eq ?f:id " + currentID + "))";
      
      PrimitiveValue fv = clips.eval(evalStr).get(0);
      
      /*========================================*/
      /* Determine the Next/Prev button states. */
      /*========================================*/
      
      if (fv.getFactSlot("state").toString().equals("final"))
        { 
         nextButton.setActionCommand("Restart");
         nextButton.setText(CartoonResources.getString("Restart")); 
         prevButton.setVisible(true);
        }
      else if (fv.getFactSlot("state").toString().equals("initial"))
        {
         nextButton.setActionCommand("Next");
         nextButton.setText(CartoonResources.getString("Next"));
         prevButton.setVisible(false);
        }
      else
        { 
         nextButton.setActionCommand("Next");
         nextButton.setText(CartoonResources.getString("Next"));
         prevButton.setVisible(true);
        }
      
      /*=====================*/
      /* Set up the choices. */
      /*=====================*/

      choicesPanel.removeAll();
      choicesButtons = new ButtonGroup();

      PrimitiveValue pv = fv.getFactSlot("valid-answers");

      String selected = fv.getFactSlot("response").toString();

      for (int i = 0; i < pv.size(); i++) {
          PrimitiveValue bv = pv.get(i);
          JRadioButton rButton;

          if (bv.toString().equals(selected)) {
              rButton = new JRadioButton(CartoonResources.getString(bv.toString()), true);
          } else {
              rButton = new JRadioButton(CartoonResources.getString(bv.toString()), false);
          }

          rButton.setActionCommand(bv.toString());
          choicesPanel.add(rButton);
          choicesButtons.add(rButton);
      }
      
      choicesPanel.repaint();

      /*====================================*/
      /* Set the label to the display text. */
      /*====================================*/


      executionThread = null;

      isExecuting = false;

      /*====================================*/
      /* Check if state is 'final'           */
      /* and update values in GUI.      */
      /*====================================*/

      String state = fv.getFactSlot("state").symbolValue();
      if ("final".equals(state)) {
          PrimitiveValue conclusions = fv.getFactSlot("conclusions");
          conclusionsPanel.setLayout(new GridBagLayout());
          
          GridBagConstraints gbc = new GridBagConstraints();
          gbc.gridx = 0;
          gbc.gridy = 0;
          gbc.weighty = 1.0; 
          
          for (int j = 0; j < conclusions.size(); j++) {
              PrimitiveValue conclusion = conclusions.get(j);
              String conclusionValue = conclusion.toString();
              JLabel conclusionLabel = new JLabel(conclusionValue);
              conclusionsPanel.add(conclusionLabel, gbc);
              gbc.gridy++;
          }

          gbc.insets = new Insets(10, 0, 0, 0);
          conclusionsPanel.add(Box.createVerticalStrut(10), gbc);
          
          wrapLabelText(displayLabel, "Recommended cartoons for you:");

          gbc.weighty = 1.0;
          gbc.gridy++;
          conclusionsPanel.add(Box.createGlue(), gbc);
      } else {
          String theText = CartoonResources.getString(fv.getFactSlot("display").symbolValue());
          wrapLabelText(displayLabel, theText);
      }


      } 

   /*########################*/
   /* ActionListener Methods */
   /*########################*/

   /*******************/
   /* actionPerformed */
   /*******************/  
   public void actionPerformed(
     ActionEvent ae) 
     { 
      try
        { onActionPerformed(ae); }
      catch (Exception e)
        { e.printStackTrace(); }
     }
 
   /***********/
   /* runAuto */
   /***********/  
   public void runAuto()
     {
      Runnable runThread = 
         new Runnable()
           {
            public void run()
              {
               clips.run();
               
               SwingUtilities.invokeLater(
                  new Runnable()
                    {
                     public void run()
                       {
                        try 
                          { nextUIState(); }
                        catch (Exception e)
                          { e.printStackTrace(); }
                       }
                    });
              }
           };
      
      isExecuting = true;
      
      executionThread = new Thread(runThread);
      
      executionThread.start();
     }

   /*********************/
   /* onActionPerformed */
   /*********************/  
   public void onActionPerformed(
     ActionEvent ae) throws Exception 
     { 
      if (isExecuting) return;
      
      /*=====================*/
      /* Get the state-list. */
      /*=====================*/
      
      String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
      
      String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

      /*=========================*/
      /* Handle the Next button. */
      /*=========================*/
      
      if (ae.getActionCommand().equals("Next"))
        {
         if (choicesButtons.getButtonCount() == 0)
           { clips.assertString("(next " + currentID + ")"); }
         else
           {
            clips.assertString("(next " + currentID + " " +
                               choicesButtons.getSelection().getActionCommand() + 
                               ")");
           }
           
         runAuto();
        }
      else if (ae.getActionCommand().equals("Restart"))
        { 
    	  conclusionsPanel.removeAll();
    	  conclusionsPanel.revalidate();
    	  conclusionsPanel.repaint();
         clips.reset(); 
         runAuto();
        }
      else if (ae.getActionCommand().equals("Prev"))
        {
         clips.assertString("(prev " + currentID + ")");
         conclusionsPanel.removeAll();
   	  	 conclusionsPanel.revalidate();
   	     conclusionsPanel.repaint();
         runAuto();
        }
     }

   /*****************/
   /* wrapLabelText */
   /*****************/  
   private void wrapLabelText(
     JLabel label, 
     String text) 
     {
      FontMetrics fm = label.getFontMetrics(label.getFont());
      Container container = label.getParent();
      int containerWidth = container.getWidth();
      int textWidth = SwingUtilities.computeStringWidth(fm,text);
      int desiredWidth;

      if (textWidth <= containerWidth)
        { desiredWidth = containerWidth; }
      else
        { 
         int lines = (int) ((textWidth + containerWidth) / containerWidth);
                  
         desiredWidth = (int) (textWidth / lines);
        }
                 
      BreakIterator boundary = BreakIterator.getWordInstance();
      boundary.setText(text);
   
      StringBuffer trial = new StringBuffer();
      StringBuffer real = new StringBuffer("<html><center>");
   
      int start = boundary.first();
      for (int end = boundary.next(); end != BreakIterator.DONE;
           start = end, end = boundary.next())
        {
         String word = text.substring(start,end);
         trial.append(word);
         int trialWidth = SwingUtilities.computeStringWidth(fm,trial.toString());
         if (trialWidth > containerWidth) 
           {
            trial = new StringBuffer(word);
            real.append("<br>");
            real.append(word);
           }
         else if (trialWidth > desiredWidth)
           {
            trial = new StringBuffer("");
            real.append(word);
            real.append("<br>");
           }
         else
           { real.append(word); }
        }
   
      real.append("</html>");
   
      label.setText(real.toString());
     }
     
   public static void main(String args[])
     {  
      // Create the frame on the event dispatching thread.  
      SwingUtilities.invokeLater(
        new Runnable() 
          {  
           public void run() { new Cartoon(); }  
          });   
     }  
  }