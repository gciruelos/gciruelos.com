First log in to the server:

    ssh -p <port> <user>@<address>

Update the repository:

    cd gciruelos.com
    git pull

Clone if it doesn't exist:

    git clone ???


Compile everyting:

    cabal sandbox init
    cabal update
    cabal install --only-dependencies
    cabal configure
    cabal build
    make build

Copy results to website directory and clean:

    cp -ri ~/gciruelos.com/_site/* /var/www/gciruelos.com/html
    make clean


If cabal fails:

    dd if=/dev/zero of=/tmp/swap bs=1M count=1024
    mkswap /tmp/swap
    sudo swapon /tmp/swap
