# MLCollage: Train AI to see  
### Create effective object detection models with less data collection  
MLCollage is a mac-based app that allows users to generate high volumes of novel annotated images given a small sample input. 
Used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/), users can easily and quickly train their very own object detection model 
capable of finding the location of any object within a picture. Traditionally, when training object detection models it can take days, or even weeks, 
to collect the thousands of sample photos needed. MLCollage changes that! This app allows the artificial generation of thousands of unique photos featuring any subject a user desires. 
This drastically cuts down on the time it takes to prepare training data. Additionally, MLCollage helps ensure a diverse data set by changing a wide array of variables. 
This further improves an object detection model's capability to recognize an object in a wide variety of conditions, such as at night or in different weather conditions.
Stop wasting your time on the tedium of data collection. Dowload MLCollage, and train your vison model _fast_.

### What is an object detection model?
A model trained to detect a particular object within a larger image is called an object detection model. Specifically, such a model is designed to locate and identify instances of the target object within the broader visual context.

### What is novel data?  
CreateML needs an input consisting of many photos of the object to be recognized, as well as an annotation pointing 
out where the object is speciffically in each picture. Many times, the number of photos needed to effectively train a 
model number in the thousands or more. Taking that many photos is tedious. So is annotating all of them. MLcollage helps by 
providing all that data with as few as 30 photos. 

### Modify the original subject in multiple ways:
- Translate 
- Scale
- Rotate
- Flip accross either axis
- Hue shift to simulate differing time of day

### Example use cases
- Detecting a specific type of fruit in a bin of assorted produce.
- Identifying vehicles in traffic footage.
- Recognizing a logo within a busy advertisement.

## Directions
as previously mentioned, MLCollage is designed to be used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/). 
When a training set is generated, a JSON file is included in the output. This package, including the JSON, can be dropped directly into an ML object detection model's inputs in the create ML app.

### Download Xcode
First you will need the Xcode IDE, as that is where CreateML is housed. If you don't already have Xcode, you can download it [here](https://developer.apple.com/xcode/).

### Launch CreateML
Once you've launched Xcode, you can access CreateML by going to Xcode > Open Developer Tool > Create ML in the menu bar.

### Download MLCollage to your iPhone  
- download with Xcode
- sync your device
- run

### Take photos and isolate them to be used
you will now need to take photos of the object you want the detection model to identify. Photos should be taken in neutral lighting, and from as many angles as possible. 
Remember, we want to allow our algoritim to recognize the object regardless of what angle it is viewed from! I reccomend at least 14 photos if you evenly space the angle between each photo.
Once these photos have been collected, you will need lift the subject from it's background. This can be easily done thanks to apple's lift feature, just press and hold the subject within the picture then select share > save image.
You should now have a PNG of your subject with no background. Repeat this for every photo of the subject untill you have isolated an image from every angle.

For backgrounds, you can provide whatever images you'd like. I reccomend choosing photos with varied colors and settings. Even abstract art or camo patterns can be good, the name of the game is finding visualy diverse patterns/scenes.  

### TODO: include example of non-varied vs varied backgrounds, maybe provide default photos in app?  

### Select subjects and backgrounds in the app  
once you have the app launched, the first screen you come to will be the photo select screen. This is where you will select the photos of your subject as well as the backgrounds you want to use. Multiple subjects to be trained on can be added to a single set of photos. To add a new subject, press the add subject button at the bottom of the screen and enter the name of your new subject. Once that subject has been added to the list, you can then select add photos below it's name to add example photos of your new subject. Once you have all your subject and background photos uploaded, you're ready to move on to the next section.

### Set parameters for image generation  
there are many different ways MLCollage can change the example images, and these changes all help train the detection model to see a subject in different environmnents. I recommend turning all of these on, with their paramaters set to maximum or the largest possible range. Unless you want to fine-tune the speciffic ways in which your subject is altered, the only setting you should be concerned with is "number of each subject", which dictatates how many images of each subject the result will contain.

### Generate images  
This part is really easy, simply go to the output tab and press the export button. Select the location you want to save your file in, and press the move button in the top right corner.

### Drop file into CreateML
Open create CreateML and create a new project. Select Vision ML Model, and create a new one. Once that is done, drag and drop your data into the train box in CreateML. An additional set of data can be generated to provide a validation set, further increasing the model's training effectiveness.
### Train
Press the train button and observe the results.
