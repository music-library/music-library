# Music Player :musical_note:
Self-hosted music player.

\- _for those of us too stubborn to just use Spotify_




![](./screenshots/music-player.gif)




## Features :muscle:
- NBUI (not bad user-interface)
- Sources tracks from file-system
- Supported File Formats
	- MP3
	- FLAC
- Uses track metadata - (falls-back to filename if no [tags](https://www.mp3tag.de/en/) found)
	- Title
	- Artist
	- Album Artist
	- Album
	- Cover Art
- Key bindings
	- `K` or `P`: pause




## How to setup :bulb:

### Build docker image from source

1. Clone this repo with all submodules

```bash
$ git clone --recurse-submodules https://github.com/hmerritt/music-library-player
```

2. Modify `docker-compose.yml` file

```bash
version: "3"

services:
  
  ## music-player
  music-player:
    build: .

    environment:
        - REACT_APP_HTTP=http
        - REACT_APP_HOST=localhost:7788
        - REACT_APP_API=http://localhost:7789

    ports:
      - 7788:80
      - 7789:8000

    volumes:
      - path-to-your-music:/app/music
```

3. Run `docker-compose up`

```bash
$ docker-compose up
```




<br />

## How to clone repo
Clone repo (with all submodules)
```bash
$ git clone --recurse-submodules https://github.com/hmerritt/music-library-player
```
