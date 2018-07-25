# etcd Basics
This repository houses a simple introduction to etcd
and a scripted example of how one can restore their etcd
cluster with a snapshot or backend store.

Every script you run requires you to be on a UNIX based machine
installed with:
* Docker
* Bash

You'll need to hit "enter" to advance the script.

### Recovering from an etcd Snapshot
1. Start by creating your etcd cluster.
    ```
    $ bash create.snapshot.sh
    ```
2. Add some keys to your etcd cluster. The script
   below will add a key named `foo` and a value
   named `bar`.
   ```
   $ bash addkey.sh
   ```
3. Save the etcd cluster state into a `snapshot.db`
   file.
   ```
   $ bash save.snapshot.sh
   ```
4. Create a new cluster and recover it from the snapshot.
   ```
   $ bash recover.snapshot.sh
   ```

### Recovering from a Backend Store
1. Start by creating your etcd cluster.
    ```
    $ bash create.backend.sh
    ```
2. Notice it has been mounted to a backend
   directory called `backup`. This is going to
   be the backend store on your local filesystem.
3. Add some keys to your etcd cluster. The script
   below will add a key named `foo` and a value
   named `bar`.
   ```
   $ bash addkey.sh
   ```
4. Remove the etcd cluster, create a new one backed
   by the `backup` folder, and check that your keys
   are good!
   ```
   $ bash recover.backend.sh
   ```