Build Rocket Chat with the 8080 proxy (i.e. no Github/S3 access).

Notes:

1. This is just a POC. That's why you do everything by hand.
2. It is build for Rocket Chat `1.0.0-rc.2`. Other versions definitely won't work.

On your work machine clone Rocket Chat sources. Note that `.git` there is quite beefy so it's better to only get latest commit:

    git clone --branch 1.0.0-rc.2 --depth 1 https://github.com/RocketChat/Rocket.Chat.git

Make source archive:

    tar czf rc.tgz -C Rocket.Chat .

That will put the sources in the archive's root. Now place this archive near the Dockerfile and copy everything into your build box.
Then run:

    docker build -t rc-build .

Note that downloading Meteor sometimes fails. When it happens just restart the build.

Now when you have the image run the container:

    docker run -it --name=rc rc-build

If you plan to start Rocket Chat and you have a container running Mongo named `mongo` you can use this command:

    docker run -it --name=rc -p 3000:3000 --link=mongo rc-build

The container will just start Bash. Once in the container run:

    cd /home/node/rc/src/
    meteor npm install

If everything is fine (except a huge amount of warning) do:

    meteor build --server-only --directory /home/node/rc/build/

This will take some time. If you still lucky and the build is successful do:

    cd /home/node/rc/build/bundle/programs/server
    patch package.json /home/node/rc/rc.build.patch

Now take a deep breath and here is the last step:

    npm install

And now you've built the Rocket Chat! The bundle is located in the `/home/node/rc/build`.

If you want to run it (and you've started the container with the port mapping):

    cd /home/node/rc/build/bundle
    NODE_ENV=production PORT=3000 ROOT_URL=http://<your_host>.ap.hedani.net:3000 MONGO_URL=mongodb://mongo:27017/rocketchat node main.js
