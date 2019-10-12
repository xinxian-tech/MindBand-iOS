# Project MindBand

> Follow your mind, the world is your band.

### Architecture

##### Representation for Melody Generate Resources

This app will help to capture the media elements, such as images, emojies, or humming audios, represented as `MediaElement` objects. Each specific media element such emojies have a subclass of `MediaElement`, such as `EmojiElement`. The following member variables should be emphasized:

- `token`: the emotional label of the corresponding media element, say, valence and arousal variable. However, in this version, this variable stands for the URL of the saved audio of this element, since currently we only concern the music generation for one single media element.
- `identifier`: identifies the media element.

Each subclass is in charge of managing the raw media file of them, such as the humming audio URL for `HummingElement`.

##### Media Token Generation

Once decided the media elements, `TokenGenerator` is in charge of generating `token` for them. In this version, `TokenGenerator` ask the backend for the corresponding audio, save it, then assign `token` with the URL of the audio.

##### Melody Generation

The melody of several elements is synthesised and used to generate melodies, the corresponding class is `MelodyGenerator`. However, in this version, there is no practical use of this class: it directly returns the `token` of the first `MediaElement`.

##### MelodyPresentation

By reading an array of `MediaElements` and the URL of the melody audio generated, `MelodyPresentationView` will play the video and audio for the generation. Subclass `MelodyPresentationView` for different visualization.

### To Do List

- [ ] Parallel fetch `token` variable `MediaElement` when tapping `addButton` in `MindViewController`
- [ ] Permanent data storage structure
- [ ] Documentation
- [ ] MVC design
- [ ] Asking for authorization before utilizing resources, such as network and photo album.