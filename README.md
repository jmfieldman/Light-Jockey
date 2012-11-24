From http://www.fieldman.org/light-jockey/

Light-Jockey
============

Light Jockey
Have you ever played the flash game Auditorium?  If not, you should; it’s awesome. That’s why I decided to see if I could make a game like it for the iPhone. Keep in mind this is back in 2009 when the iPhone 3G was state of the art, and OpenGLES was still at 1.1.

I was actually pretty successful, and made something very fun and playable. Each frame, I cycled between two offscreen buffers; blurring one and drawing it into the other, then drawing the sharp content over the blur. With the proper parameters it made the little light lines appear to glow and blur into each other dynamically. Implementing the physics and element interaction was pretty straightforward.

The official version of Auditorium was written for the iPhone many months later. The publisher, EA, sent me a cease and desist to remove Light Jockey from the app store. My version hadn’t really sold well, and I wasn’t in the mood for lawsuit, so I pulled the game. Now it's open source!

![Screen1](/jmfieldman/Light-Jockey/blob/master/Images/screenshots/screenLev1.png?raw=true)
![Screen2](/jmfieldman/Light-Jockey/blob/master/Images/screenshots/screenMenu.png?raw=true)
![Screen3](/jmfieldman/Light-Jockey/blob/master/Images/screenshots/screenchrom.png?raw=true)
![Screen4](/jmfieldman/Light-Jockey/blob/master/Images/screenshots/screenpull.png?raw=true)
![Screen5](/jmfieldman/Light-Jockey/blob/master/Images/screenshots/screenspeed.png?raw=true)
