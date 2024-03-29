# Short Video App like Tik-Tok

In this Flutter application, BLoC state management to create a vertical video page like TikTok. 
Videos are displayed them in a scrollable view. 
There is also preloading of videos to ensure a seamless video viewing experience.

## Output Demo Video

<!-- ![Output sample](example_media/video_feed_media.gif) -->
<img src="example_media/video_feed_media.gif" width="290" height="500"/>


## Improvements

- [ ] If user scrolls too fast, the video will not be loaded. This can be done by increasing the number of videos that are preloaded.
- [ ] Add pagination with API call to load more videos when user scrolls near to the end of the list. 
  - This can be done inside the `isolates`, so that the UI thread is not blocked.
- [ ] Show appropriate error messages with a retry button when there is an error in loading videos.
