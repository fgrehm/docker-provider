# Dummy box

Vagrant providers each require a custom provider-specific box format. This folder
contains a "dummy" box that allows you to use the plugin without the need to create
a custom base box.

To turn this into a "box", run:

```
tar cvzf dummy.box ./metadata.json
```

By using this box you'll need to specify a Docker image on your `Vagrantfile`
[as described](README.md#using-custom-images) on the README.

For "real world" examples please check out [`boxes/precise`](boxes/precise) and
[`boxes/nginx`](boxes/nginx).
