# ezstream

The latest Ezstream image built within Debian Buster with all the possible batteries included:
 - tag support
 - lame
 - vorbis-tools
 - flac
 - madplay
 - iputils-ping
 - some free samples in `./data`

Some agreements:
 - config file should be stored in `/application/configs/prod.xml`
 - `/application/data` stands for your collection you want to stream
 - `/applicaton/playlists/<playlist>.m3u` contains paths to the `./data` directory
 
This image should be available on docker hub:
    
    ncrawler/streamforce:latest
 
And squashed version:
 
    ncrawler/streamforce:squashed-latest
 
Just tune up a little bit `./configs/prod.xml` according to your icecast setup.

In my case icecast is present in two networks: `nginx-network` and `icecast-network`.
 
    docker network create --attachable --driver overlay --subnet 10.0.0.1/24 nginx-network
    docker network create --attachable --driver overlay --subnet 10.66.66.1/24 icecast-network

Anyway, it's just a docker image.
