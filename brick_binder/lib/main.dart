import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; //for BackgroundIsolateBinaryMessenger
import 'package:flutter/scheduler.dart';

late List<CameraDescription> _cameras;
final GlobalKey<_CameraScreenState> cameraScreenKey = GlobalKey<_CameraScreenState>();

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const BrickBinder());
}

class IsolateData 
{
  final RootIsolateToken token;
  final String tempPath;

  IsolateData(this.token, this.tempPath);
}

Future<Uint8List> readImageFileInIsolate(IsolateData data) async 
{
  //Initialize the messenger for platform interaction
  BackgroundIsolateBinaryMessenger.ensureInitialized(data.token); 

  // Read the file from the path and return the bytes
  final Uint8List bytes = await File(data.tempPath).readAsBytes();
  return bytes;
}

Future<String> saveImageFileInIsolate(IsolateData data) async 
{
  BackgroundIsolateBinaryMessenger.ensureInitialized(data.token);

  final Uint8List bytes = await File(data.tempPath).readAsBytes();
  final Directory appDir = await getApplicationDocumentsDirectory();
  final String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
  final String newPath = '${appDir.path}/$fileName';

  await File(newPath).writeAsBytes(bytes); // Use data.picture
  await File(data.tempPath).delete();
  return newPath;
}

class BrickBinder extends StatelessWidget 
{
  const BrickBinder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavPanel());
  }
}

class NavPanel extends StatefulWidget {
  const NavPanel({super.key});

  @override
  State<NavPanel> createState() => _NavPanelState();
}

class _NavPanelState extends State<NavPanel> 
{
  int currentPageIndex = 1;
  //late CameraController controller;
  //late XFile? imageFile;

  @override
  void initState() 
  {
    super.initState();
    storagePermission();
    /*controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) 
    {
      if (!mounted) 
      {
        return;
      }
      setState(() {});
    }).catchError((Object e) 
    {
      if (e is CameraException) 
      {
        switch (e.code) 
        {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });*/
  }
  
  void storagePermission() async
  {
    //getting storage permissions
    /*var status = await Permission.storage.status;
    if(!status.isGranted)
    {
      await Permission.storage.request();
    }*/

    //getting camera permissions
    var cameraStatus = await Permission.camera.status;
    if(!cameraStatus.isGranted)
    {
      await Permission.camera.request();
    }
  }

  @override
  void dispose() 
  {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    final ThemeData theme = Theme.of(context);
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: const Color.fromARGB(253, 255, 213, 2), 
        title: Text('Brick Binder')
      ),
      bottomNavigationBar: NavigationBar
      (
        onDestinationSelected: (int index) 
        {
          setState(() 
          {
            if(currentPageIndex == 0 && index != 0)
            {
              cameraScreenKey.currentState?.pauseCamera();
            }
            if(currentPageIndex != 0 && index == 0)
            {
              cameraScreenKey.currentState?.resumeCamera();
            }
            setState(() 
            {
              currentPageIndex = index;
            });
          });
        },
        indicatorColor: const Color.fromARGB(253, 255, 213, 2),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: Badge(label: Text('2'), child: Icon(Icons.book)),
            label: 'Collection',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.settings)),
            label: 'Settings',
          ),
        ],
      ),
      body: IndexedStack
      (
        index: currentPageIndex,
        children: <Widget>
        [
          /// Camera
          CameraScreen(key: cameraScreenKey, camera: _cameras[0]),
          /*Stack
          (
            children: <Widget>
            [
              CameraPreview(controller),  //camera live feed
              //bottom left take picture button
              Align
              (
                alignment: Alignment.bottomLeft,
                child: Padding
                (
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: FloatingActionButton
                  (
                    onPressed: () 
                    {
                      _takePicture();
                    },
                    child: Icon(Icons.circle),
                    backgroundColor: const Color.fromARGB(253, 255, 213, 2),
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
              //bottom right open picture button
              Align
              (
                alignment: Alignment.bottomRight,
                child: Padding
                (
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: FloatingActionButton
                  (
                    onPressed: () 
                    {
                      _openPicture();
                    },
                    child: Icon(Icons.folder),
                    backgroundColor: const Color.fromARGB(253, 255, 213, 2),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),*/

          /// Collection
          GridView.count
          (
            crossAxisCount: 3,
            padding: EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0,
            children: <Widget>
            [
              Card
              (
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 18.0 / 11.0,
                      child: Icon(Icons.square),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Title'),
                          const SizedBox(height: 8.0),
                          Text('Secondary Text'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          /// Settings
          ListView.builder
          (
            //reverse: true,
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) 
            {
              if (index == 0) 
              {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Hello',
                      style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ),
                );
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hi!',
                    style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            },
          ),
        ]
      ),
    );
  }
}

class CameraScreen extends StatefulWidget 
{
  final CameraDescription camera;
  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> 
{
  CameraController? _controller;
  bool _isCapturing = false;
  bool _isScreenActive = true;

  @override
  void initState() 
  {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() 
  {
    if (_controller != null && _controller!.value.isInitialized) 
    {
      _controller!.dispose(); 
    }
    _controller = null;
    super.dispose();
  }

  void pauseCamera() 
  {
    if (_controller!.value.isInitialized) 
    {
      _controller!.pausePreview().catchError((e) => print('Pause Error: $e'));
      if (mounted) setState(() { _isScreenActive = false; });
    }
  }

  void resumeCamera() 
  {
    if (_controller!.value.isInitialized) 
    {
      if (mounted) setState(() { _isScreenActive = true; });
      _controller!.resumePreview().catchError((e) => print('Resume Error: $e'));
    }
  }

  Future<void> _initializeController() async 
  {
    _controller = CameraController(widget.camera, ResolutionPreset.low); 
    await _controller!.initialize().catchError((Object e) 
    {
      if (e is CameraException) 
      {
        print("Camera Re-Initialization Error: ${e.code}");
      }
    });
    if (mounted) setState(() {});
  }

  void _takePicture() async
  {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) 
    {
        print("Controller not initialized or busy.");
        return;
    }

    if (mounted) 
    {
      setState(() 
      {
        _isCapturing = true; // Block button
        _isScreenActive = false; // Trigger build() to hide CameraPreview
      });
    }

    await SchedulerBinding.instance.endOfFrame;

    try
    {
      await _controller!.pausePreview();
      
      //Take the picture before disposing the controller
      final XFile picture = await _controller!.takePicture();
      
      //Dispose the controller to FORCE PlatformView cleanup
      await _controller!.dispose(); // No need for isInitialized check here as it was just checked.
      _controller = null;
      
      //Wait for the disposal/rebuild before computing and navigating
      await SchedulerBinding.instance.endOfFrame;
      
      //Compute image saving
      final String savedFilePath = await compute<IsolateData, String>(saveImageFileInIsolate, IsolateData(RootIsolateToken.instance!, picture.path));

      if (!mounted) return;
      
      //Navigate
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ImageViewPage(imagePath: savedFilePath),
          transitionDuration: Duration.zero,
          transitionsBuilder: (context, animation1, animation2, child) => child,
        ),
      );

      //Re-initialize controller upon return
      if (mounted) 
      {
        await _initializeController();
        setState(() {
          _isCapturing = false;
          _isScreenActive = true;
        });
      }
    }
    catch (e)
    {
      print("Error taking picture: $e");
      if (mounted) 
      {
        resumeCamera();
        setState(() 
        {
          _isCapturing = false;
        });
      }
    }
  }

  void _openPicture() async
  {

  }

  @override
  Widget build(BuildContext context) 
  {
    if (_controller == null || !_controller!.value.isInitialized) 
    {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: <Widget>
      [
        _isScreenActive 
          ? Hero
          (
            tag: 'camera-preview-hero-bug-fix', // Unique tag
            child: CameraPreview(_controller!),
          )
          : const Center(child: CircularProgressIndicator()),
        //bottom left take picture button
        Align
        (
          alignment: Alignment.bottomLeft,
          child: Padding
          (
            padding: const EdgeInsets.only(bottom: 10.0, left: 10.0),
            child: FloatingActionButton
            (
              onPressed: (_isCapturing || !_isScreenActive) ? null : _takePicture,
              child: _isCapturing 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Icon(Icons.circle),
                backgroundColor: const Color.fromARGB(253, 255, 213, 2),
                foregroundColor: Colors.red,
            ),
          ),
        ),
        //bottom right open picture button
        Align
        (
          alignment: Alignment.bottomRight,
          child: Padding
          (
            padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
            child: FloatingActionButton
            (
              onPressed: () 
              {
                _openPicture();
              },
              child: Icon(Icons.folder),
              backgroundColor: const Color.fromARGB(253, 255, 213, 2),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class ImageViewPage extends StatefulWidget 
{
  final String imagePath;
  const ImageViewPage({super.key, required this.imagePath});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> 
{
  late Future<Uint8List> _imageBytesFuture;

  @override
  void initState() {
    super.initState();
    // Start loading the file bytes immediately on initState
    _imageBytesFuture = compute<IsolateData, Uint8List>(readImageFileInIsolate, IsolateData(RootIsolateToken.instance!, widget.imagePath));
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Captured Image'),
      ),
      body: Center
      (
        //FutureBuilder to display loading indicator while file is read
        child: FutureBuilder<Uint8List>
        (
          future: _imageBytesFuture,
          builder: (context, snapshot) 
          {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) 
            {
              // Once bytes are ready, display the image from memory
              return Image.memory(snapshot.data!); 
            } else if (snapshot.hasError) 
            {
              return const Text('Error loading image');
            }
            // Show a progress indicator while loading
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

/*class LegoCard extends StatelessWidget 
{
  
  const LegoCard({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox(width: 300, height: 100, child: Center(child: Text(cardName)));
  }
}*/