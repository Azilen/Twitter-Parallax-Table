# Twitter-Parallax-Table

Twitter Parallax Table is great demo just like twitter account page. Here you can see Layers overlap, scale and move in unison with the tableview offset, creating an harmonic and smooth ensemble of transitions 

###How To Implement It

1) User pulls down (when the Scrollview content is already at the top of the screen)
2) User scrolls down/up


###PULL DOWN
if offset < 0 {
 .....
}

First, we check that the offset is negative: it means the user is Pulling Down, entering the tableview bounce-area.
In the rest of code the Header is scale up so that its top edge is fixed to the top of the screen and the image is scaled from the bottom.

###HEADER (FIRST PHASE)
The Avatar is scaled with the same logic we used for the Pull Down but in this case attaching the image to the bottom rather than the top.

we define which is the frontmost layer depending on the current offset. Until the offset is less than or equal to offset_HeaderStop the frontmost layer is the Avatar; higher than offset_HeaderStop it’s the Heade

At this point, we define which is the frontmost layer depending on the current offset. Until the offset is less than or equal to offset_HeaderStop the frontmost layer is the Avatar; higher than offset_HeaderStop it’s the Header.

if offset <= offset_HeaderStop {
 
     if avatarImage.layer.zPosition < header.layer.zPosition{
         header.layer.zPosition = 0
     }
 
 }
 else {
     if avatarImage.layer.zPosition >= header.layer.zPosition{
         header.layer.zPosition = 2
     }
 }

###BLUR
The blurred view is obtained using FXBlurView.

![Demo][1]


  [1]: https://github.com/Azilen/Twitter-Parallax-Table/blob/master/twitter.gif
