# How to SCP

## FROM LOCAL TO REMOTE

Execute while on local:

```sh
scp [remote user]@[remote host] /path/to/local/file.ext [remote user]@[remote host]:/path/to/remote/directory
```

example:

```sh
scp myuser@login.com /mnt/c/Users/Username/thefolder/file.txt myuser@login.com:~/
```

saves file.txt to root dir on remote

---

## FROM REMOTE TO LOCAL

Execute while on local:

```sh
scp [remote user]@[remote host]:/path/to/remote/file.ext /path/to/local/directory/
```

example:

```sh
scp myuser@login.com:~/afolder/otherfolder/file.txt /mnt/c/Users/Username/thefolder/
```

saves file.txt from remote onto local in folder "the folder"
