Yoga
====

iOS yoga themed auto-generating music app

Sounds selected based on where the user taps the screen. Notes scroll from right to left to show when instruments are triggered. App auto-generates new compositions over time based on user selections. 

• I created a music architecture in Objective-C that would take the first few taps from the user on a particular instrument, quantize those taps, then look in an array database for that instrument and choose placement of other notes in a rhythmic arrangement that would sound good for that particular instrument. Some instruments vary in pitch, while all can vary in volume and composition. Some instruments loop more frequently than others, but they all stay in sync to the same big loop. 

• With each loop of the music, a note instance of an instrument becomes quieter. Once the note drops below it’s particular volume threshold, it is removed from the composition and a request is sent to a Rejuventor class that analyzes the current state of the song and makes decisions based on a combination of 1) how many other notes are playing of that instrument 2) how many other instruments are playing and 3) a randomization equation. The result is that you can tap a few notes at the beginning of the session, then leave it for hours and at no point will all the instruments die off nor will the composition become too busy. It continuously auto-generates new music and new compositions (while sticking to the user-selected instruments) for hours. That way a yoga teacher could start the app and then focus entirely on teaching.

• I did all the field recordings for the different instruments. I converted the AIFs to CAFs and learned OpenAL (Audio Language) for the playback and manipulation of the sounds (including volume, pitch, pan)

• The object hierarchy is the Song class, Measure class, Beat class, and Note classes. A sound manager class handles the OpenAL usage. An Orchestra class contains all the Instrument classes and their unique data. 

• A Visualizer class handles the graphics and animation using OpenGL (Graphics Language) rather than Apple UIViews. I wanted a page that continually refreshed, something particularly good for ongoing animation or games.

Last tested build was for iOS 3.0
