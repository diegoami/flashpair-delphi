_____________________________________________________________________
|                                                                   |
| TGIFImage 2.9                                                     |
|                                                                   |
| Delphi & C++Builder VCL Component for manipilating GIF files      |
|                                                                   |
---------------------------------------------------------------------
|                                                                   |
| Theodor Kleynhans                                                 |
|                                                                   |
| theodor@sulako.com                                                |
| http://www.sulako.com/                                            |
|                                                                   |
---------------------------------------------------------------------

Hi folks!

Greetings from a sunny South Africa (Cape Town to be precise).

Well, after downloading many a free component I felt obliged to return the favour. I was
looking for a GIF component myself but found out they're all about $10,000 (well, not really,
but almost...).

Thus the TGIFImage component was born. From the outset I decided to release it as Freeware
(although I still prefer to keep the source). So anybody who thinks the component is worthwhile
is free to use it in any way they please.

All I ask is that you EMail me to tell me what you think of it (good or bad) and whether you
would like to see any features added or removed. I'd also appreciate it if, when it chokes on
an image, you send me a copy of the image and, if possible, a short description of your
implementation of the component. I'll then fix the bug as soon as possible and send you an
update.

So many users asked for a way to get hold of the source, I eventually decided to make it
available for $50. You can order it on-line using a secure SSL 3.0 server at the following
URL: http://www.shareit.com/programs/100318.htm.
If you'd prefer not to give out credit-card information, there are also other ways to pay.
(Also listed at the above URL).


Now, a few features of TGIFImage:

* Fully compliant with the GIF 87a and 89a standards
  Will also try to decode unknown versions, as recommended in the specifications.

* Recognizes all documented extension blocks
  Plain Text blocks and Unknown Application blocks are recognized but skipped over.

* Can decode and display animated GIF's
  Supports the Netscape Loop-block implemented by apps such as GIF Construction Set and MS GIF
  Animator. Also supports the "Remove To Previous Image" animation option not even supported by
  Netscape.

* Can decode and display transparent GIF's
  Animated GIF's can also be transparent. Even when images are tiled or stretched they still keep
  their transparency.

* Can decode and display interlaced GIF's
  Animations and Transparent GIF's can also be interlaced.

* Can save to GIF files as well
  This enables you to compress those bulky Bitmaps. Do the following test: Use the sample
  application to load a GIF animation and then save it under another name (again using the
  sample app). Now compare the file sizes... TGIFImage optimized the file size as much as
  possible without sacrificing image quality. I tried it on a sample GIF, and it
  shrunk from 25,821 bytes to 19,029 bytes. Not so much in itself, but if you add all the
  images on eg. your web site together, it can make quite an impact on download performance.

I think that about covers everything the GIF standard currently supports. If I've missed
anything, please let me know and I'll implement it (or at least try to...).



The following files should be included with this file:
* Install.txt  - Installation instructions.
* Licence.txt  - User Licence.
* ReadMe.txt   - This file
* Versions.txt - Contains the Version History.
* Bin\         - Here you'll find the compiled versions of the components for
                 all the different platforms. The resource files (that contain
                 the component bitmaps) can be found in the Glyph?? directories.
                 Delphi 1 users should use the files in Glyph16, while other
                 users should use the files in Glyph32.
* Demos\       - Directory containing sample applications with source. You
                 don't need to install the component to run the demos, just
                 copy GIFImage.dcu and TimerEx.dcu to the Demo's directory.
* Source\      - If you registered TGIFImage, you can get all the source here.



To install the components follow the steps set out in Install.txt.



{MWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMW}
Part of the declaration of TGIFImage looks like this:
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    function GetFrameInfo(const FrameIndex: Integer): TFrameInfo;

    function LoadFromFile(const GIFFileName: String): Boolean;
    function LoadFromStream(Stream: TStream): Boolean;
    function LoadInfoFromFile(const GIFFileName: String): Boolean;
    function LoadInfoFromStream(Stream: TStream): Boolean;
    function LoadFromResourceName(Instance: THandle; const ResName: String): Boolean;
    function LoadFromResourceID(Instance: THandle; const ResID: Integer): Boolean;

    property Bitmap            : TBitmap       ;
    property BitsPerPixel      : Integer       ;
    property Data              : TMemoryStream ;
    property Empty             : Boolean       ;
    property ImageWidth        : Integer       ;
    property ImageHeight       : Integer       ;
    property IsAnimated        : Boolean       ;
    property IsInterlaced      : Boolean       ;
    property IsTransparent     : Boolean       ;
    property MouseOnTransparent: Boolean       ;
    property NumFrames         : Integer       ;
    property NumIterations     : Integer       ;
  published
    { Published declarations }
    { Inherited Properties...}

    { New Properties }
    property Animate        : Boolean         ;
    property AutoSize       : Boolean         ;
    property Center         : Boolean         ;
    property CurrentFrame   : Integer         ;
    property DoubleBuffered : Boolean         ;
    property FirstImageOnly : Boolean         ;
    property Loop           : Boolean         ;
    property Opaque         : Boolean         ;
    property Speed          : Integer         ;
    property Stretch        : Boolean         ;
    property StretchRatio   : Boolean         ;
    property Tile           : Boolean         ;
    property Threaded       : Boolean         ;
    property ThreadPriority : TThreadPriority ;
    property Visible        : Boolean         ;
    property Version        : TGIFVersion     ;
    property OnChanging     : TNotifyEvent    ;
    property OnChange       : TNotifyEvent    ;
    property OnProgress     : TProgressEvent  ;
    property OnWrapAnimation: TNotifyEvent    ;
  end;

  function SaveToFile(const GIFFileName: String;
                      var FramesArray: TSaveInfo): Boolean;

  function SaveToStream(Stream: TStream;
                        var FramesArray: TSaveInfo): Boolean;

  function SaveToFileSingle(const GIFFileName: String;
                            const aBitmap: TBitmap;
                            const aInterlaced, aTransparent: Boolean;
                            const aTransparentColor: TColor): Boolean;

  function SaveToStreamSingle(Stream: TStream;
                              const aBitmap: TBitmap;
                              const aInterlaced, aTransparent: Boolean;
                              const aTransparentColor: TColor): Boolean;

var
  LastWriteError: TGIFError;
  OnWriteProgress: TProgressEvent;
{MWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMW}


TGIFImage has the following key properties:

* Animate : Boolean
  Determines whether animated GIF's will be played or not.

* AutoSize : Boolean
  Automatically sizes the component to the size of the GIF image if set.

* Bitmap : TBitmap (ReadOnly)
  The GIF image itself. You can use this to save the image as a bitmap file using
  Bitmap.SaveToFile. For animated GIF's the Bitmap property returns only the first frame.

* BitsPerPixel : Integer (ReadOnly)
  The highest amount of bits per pixel for any image in the file.

* Center : Boolean
  When the component is larger than the GIF image it will be centered within the component
  boundaries if this property is set and neither the Stretch nor Tile properties are set.

* CurrentFrame : Integer
  The frame currently displayed (1..NumFrames). You can also manually set this value to
  display a particular frame of your choice.

* DoubleBuffered : Boolean
  Determines whether the image should be painted to a temporary background bitmap and then
  painted on the screen (True), or not (False). It's true by default and results in smooth,
  flicker-free painting of animations. Setting it to False will speed up the painting
  routines slightly.

* FirstImageOnly : Boolean
  If True, only the first image will be decoded, even if there is more than one (animations).
  This is useful if you're using it in eg. a browser where you don't want to see animation,
  but only thumbnails.

* Empty : Boolean (ReadOnly)
  This is True when no image is loaded.

* ImageWidth, ImageHeight : Integer (ReadOnly)
  The dimensions of the loaded GIF.

* IsAnimated  : Boolean (ReadOnly)
  If you want to know if the GIF is animated or not (Duh!)

* IsInterlaced  : Boolean (ReadOnly)
  If you want to know if the GIF is interlaced or not.

* IsTransparent  : Boolean (ReadOnly)
  Mmmm.... I wonder what this is for? Note that this is set when any 1 frame in the GIF is
  transparent. So, even though some animations might not look like they have any transparent
  areas, they do if this property is set. GIF animators use this technique to increase the
  compression by replacing pixels which stay the same between frames with transparent ones.

* LastError: TGIFError
  Where:
  TGIFError = (geNone,
               geInternal,
               geFileFormat,
               geTooManyColors,
               geIndexOutOfBounds,
               geWindows,
               geFileNotFound,
               geResourceNotFound
               );
  Note that no exceptions are raised within the component. The LastError property is simply
  there for informational purposes if you receive a false result from one of the functions.

* Loop : Boolean
  When set, animated GIF's will animate indefinitely. Otherwise they'll only run for the amount
  of iterations specified in the file.

* Opaque : Boolean
  If set to True, underlying areas not covered by the loaded image will be filled with
  the Color property. It improves painting speed slightly for transparent images, and
  some users requested this feature.

* MouseOnTransparent  : Boolean (ReadOnly)
  This property is True when the pixel last passed over by the mouse was a transparent one. You
  can use this property in the OnClick event handler for example to find out whether the user
  clicked on a transparent area of the image.

* NumFrames: Integer (ReadOnly)
  The number of images contained in the GIF. Equals 1 for standard GIF's, can be up to
  MaximumGIFFrameCount (constant set at 256) for animated GIF's.

* NumIterations: Integer (ReadOnly)
  The number of times an animated GIF will repeat. This value is ignored when Loop = True.

* Speed : Integer
  The relative speed at which animations are played back. The value is as a percentage of the
  GIF-specified speed and defaults to 100.

* Stretch : Boolean
  When the component is larger than the GIF image it will be stretched to fit within the
  component boundaries if this property is set. Stretch overrides the Tile property.

* StretchRatio : Boolean
  Same as Stretch, except that the original image ratio (width:height) is preserved.
  Stretch overrides the StretchRatio property.

* Threaded : Boolean
  Selects whether the timing signals that control animation should use a seperate thread or not.
  When this property is set to True, the animation will be smoother and will enable the main
  application thread to continue with process-intensive tasks such as calculations without the
  animation grinding to a halt.

* ThreadPriority : TThreadPriority
  Select the system-wide priority given to the animation-signalling thread.

* Tile : Boolean
  Well now, you all know what this is! Even animated GIF's can be tiled! This property works
  well for displaying tileable backgrounds.

* Version : TGIFVersion
  Where: TGIFVersion = (gvGIF87a, gvGIF89a);

* Visible : Boolean
  The name says it all.


The following methods are included:

* procedure Clear
  Clears the loaded image and all internal buffers from memory.

* function GetFrameInfo(const FrameIndex: Integer): TFrameInfo
  Enables you to gather information about a specific frame. Returns a TFrameInfo structure
  which is defined as:

    TFrameInfo = Record
      iiImage           : TBitmap;
      iiLeft            : Integer;  {relative to whole image}
      iiTop             : Integer;  {relative to whole image}
      iiWidth           : Integer;
      iiHeight          : Integer;
      iiDelay           : Integer;  {in milliseconds, rounded to nearest 100}
      iiInterlaced      : Boolean;
      iiTransparent     : Boolean;
      iiTransparentColor: TColor;
      iiDisposalMethod  : TDisposalType;
      iiComment         : String;
    end;

  and TDisposalType is defined as:

    TDisposalType = (dtUndefined, dtDoNothing, dtToBackground, dtToPrevious);

* function LoadFromFile(const GIFFileName: String): Boolean
  Similar to TBitmap.LoadFromFile and the FileName property, but it returns a result indicating
  whether it loaded successfully or not.

* function LoadInfoFromFile(const GIFFileName: String): Boolean
  Same as LoadFromFile, but doesn't decode or display the individual images. Useful for getting
  a GIF's properties quickly. When using this function you can still refer to individual frames
  and get their details by using the GetFrameInfo function, but all images will be returned as
  nil instead of TBitmaps.

* function LoadInfoFromStream(Stream: TStream): Boolean
  Same as LoadFromStream, but also only gathers GIF details.

* function LoadFromStream(Stream: TStream): Boolean
  A lot of users asked for this one.

* function LoadFromResourceName(Instance: THandle; const ResName: String): Boolean
  I included this to enable you to link a GIF file directly into your executable. Look at the
  sample resource script included in the Demos\ResLoad directory.

* function LoadFromResourceID(Instance: THandle; const ResID: Integer): Boolean
  Same as previous one, only uses Number instead of String for Resource ID.


The following events are included:

* OnChanging: TNotifyEvent
  This event is triggered just before the next frame is displayed.

* OnChange: TNotifyEvent
  This event is triggered just after the next frame is displayed. During this call the
  CurrentFrame property will be one more (or 1 if the animation looped) than in the preceding
  OnChanging event.

* OnProgress: TProgressEvent
  Enables the updating of a progress indicator while decoding the image,
  where:
    TProgressEvent = procedure(Sender: TObject;
                               const BytesProcessed, BytesToProcess,
                               PercentageProcessed: LongInt;
                               var KeepOnProcessing: Boolean) of object;

* OnWrapAnimation: TNotifyEvent
  This event is triggered when the animation has completed a single loop, ie. it will be called
  NumIterations times if Loop = False.



The output routines are not part of the TGIFImage class (as it doesn't need to be) and
comprises the following:

* function SaveToFile(const GIFFileName: String; const FramesArray: TSaveInfo): Boolean
  Set up a TSaveInfo structure which is defined as:

    TSaveInfo = Record
      siNumFrames          : Integer;
      siFrames             : array[1..MaximumGIFFrameCount] of ^TFrameInfo;
      siNumLoops           : Word;  {Number of times animation loop is run}
      siUseGlobalColorTable: Boolean;
    end;

  and then let rip! It can handle bitmaps of any color depth except Monochrome (1 bit per
  pixel) because Win32's GetDIBits function does not seem to support it. One restriction though
  is that each frame can not have more than 256 distinct colors, as the GIF format only
  supports up to this amount. Maybe later on I'll include a Dithering algorithm, but nothing is
  planned as yet... See the included Demo applications for examples on how to use this function.

  Most GIF animator applications write every image in an animation to the file with its own
  color table (palette). If the total amount of colors used by all the images is 256 or less,
  this results in a waste of space as only a single, global color table is needed. You can set
  siUseGlobalColorTable to true to try and generate only a global color table. If this is not
  possible, every image will be given a local color table. You can test the value of
  siUseGlobalColorTable on return to see if a global color table was indeed generated. All
  images are stored using the mimimum number of bits needed, thus resulting in greater
  compression than simply assuming an 8-bit color depth.

* function SaveToStream(Stream: TStream; const FramesArray: TSaveInfo): Boolean
  I suppose you can figure out how this works?

* function SaveToFileSingle(const GIFFileName: String;
                            const aBitmap: TBitmap;
                            const aInterlaced, aTransparent: Boolean;
                            const aTransparentColor: TColor): Boolean;
  A simplified, 1-line method to save a bitmap to GIF format.

* function SaveToStreamSingle(Stream: TStream;
                              const aBitmap: TBitmap;
                              const aInterlaced, aTransparent: Boolean;
                              const aTransparentColor: TColor): Boolean;
  As above, but for streams.

The following global variables can be used when output routines are used:

* LastWriteError : TGIFError;
  Similar to the TGIFImage.LastError property, it contains the error code when an output
  routine returns a False result.

* OnWriteProgress : TProgressEvent;
  Similar to the TGIFImage.OnProgress property, it enables you to assign a progress-display
  when using the output routines.


New from version 2.5 is the ability to load an image while in the IDE by either double-clicking
on the component or right-clicking and choosing the 'Load...' option on the popup menu which
follows. Also on the popup menu is a 'Clear' function which disposes of the loaded image and
a 'Refresh' option which just updates the display in case it got garbled.


I hope this clears up all your questions. If not, drop me a line!

I love getting EMail so please tell me what you think of the component (it's my first). I've
tested it on all the GIF's I could find and sorted out all the problems I encountered, but
obviously there are many more out there...

Come by my site often to see if you have the latest release.

I wish to thank all those who mailed me their thoughts and ideas.

Hope you enjoy it and look forward to hearing from you soon!

Regards,
Theodor

_____________________________________________________________________
|                                                                   |
| Theodor Kleynhans                                                 |
|                                                                   |
| theodor@sulako.com                                                |
| http://www.sulako.com/                                            |
|                                                                   |
---------------------------------------------------------------------
