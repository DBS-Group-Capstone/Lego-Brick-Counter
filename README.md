# Brick Binder
An object detection android application that identifies and logs Lego bricks from images.

Created by DBS Group. DBS Group is:
    Giovanni Rebosio, Brenton Bales, Seth Perry, and Daniel Prum

Requires Flutter, the Android Studio sdk, and Java SDK 17.0.2

Running  
`flutter doctor`  
should be sufficient to locate dependencies, save for the Java SDK.  

For the Java SDK, run  
`flutter config --jdk-dir=”<Path-to-your-install-destination>\jdk-17.0.2\”`  

The models used are not publicly available at this time. If they are made public  
at a future date, the link will be provided here.  
However, to use your own models, view pubspec.yaml to determine where they  
must be placed and their names. Be sure the classes they use follow this format:   
`{LDRAW ID}_{TYPE}_{OPTIONAL SUBTYPE}_{OPTIONAL SUBTYPE}_{SIZE}`