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
    stack build
    make build

Alternatively

    stack build
    make build

If cabal fails:

    dd if=/dev/zero of=/tmp/swap bs=1M count=1024
    mkswap /tmp/swap
    sudo swapon /tmp/swap

And add parameter `-j` to parallelize.
